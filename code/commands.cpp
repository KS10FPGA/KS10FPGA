//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    Console commands
//!
//! \details
//!    All of the console commands are implemented in this file.
//!
//! \file
//!    commands.cpp
//!
//! \author
//!    Rob Doyle - doyle (at) cox (dot) net
//
//******************************************************************************
//
// Copyright (C) 2013-2022 Rob Doyle
//
// This file is part of the KS10 FPGA Project
//
// The KS10 FPGA project is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by the Free
// Software Foundation, either version 3 of the License, or (at your option) any
// later version.
//
// The KS10 FPGA project is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
// or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
// more details.
//
// You should have received a copy of the GNU General Public License along with
// this software.  If not, see <http://www.gnu.org/licenses/>.
//
//******************************************************************************

#include <atomic>
#include <thread>

#include <ctype.h>
#include <getopt.h>
#include <setjmp.h>
#include <signal.h>
#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <termios.h>
#include <unistd.h>
#include <inttypes.h>
#include <sys/stat.h>
#include <sys/select.h>

#include "mt.hpp"
#include "rp.hpp"
#include "dasm.hpp"
#include "dz11.hpp"
#include "ks10.hpp"
#include "lp20.hpp"
#include "rh11.hpp"
#include "tape.hpp"
#include "dup11.hpp"
#include "vt100.hpp"
#include "commands.hpp"

#define __unused __attribute__((unused))

void printPCIR(uint64_t data);

//!
//! \brief
//!    Construct object to abstract the hardware
//!

rp_t    rp;             //!< Construct RP (disk) device
mt_t    mt;             //!< Construct MT (tape) device
lp20_t  lp;             //!< Construct LP (printer) device
dz11_t  dz;             //!< Construct DZ (tty) device
dup11_t dp;             //!< Construct DUP (serial com) device

//
// RP configuration
//

struct rp_cfg_t {
    uint32_t baseaddr;                          // Base address (includes UBA field)
    uint8_t  unit;                              // Selected disk unit
    bool     bootdiag;                          // Boot to diagnostic monitor
} rp_cfg;

//
// MT configuration
//

struct mt_cfg_t {
    uint32_t baseaddr;                          // Base address (includes UBA field)
    bool     bootdiag;                          // Boot to diagnostic monitor
    uint32_t debugMask;                         // Debug Mask
    struct {                                    // Per disk parameters
       FILE * fp;                               //   Pointer to Tape File
       uint16_t param;                          //   Tape parameters (sets MTTC) (include slave and density)
       int length;                              //   Tape length in feet
       char filename[32];                       //   Filename
       std::atomic<bool> attached;              //   Tape is mounted on Tape Drive (reference)
       tape_t *tape;                            //   Pointer to Tape object
    } drive[8];                                 // ...
} mt_cfg;

//!
//! \brief
//!    sigaction struct
//!

struct sigaction sa;

//!
//! \brief
//!    Signal handler
//!
//! \details
//!    We install a signal handler so that commands can be interrupted if they
//!    get stuck in a loop. The handler is installed before the command is
//!    executed and operation is restored to normal after the command completes.
//!
//! \param
//!    sig - should alwasy be SIGNIT
//!
//! \returns
//!    This function never returns.
//!

static jmp_buf env;

void sigHandler(int sig) {
    if (sig == SIGINT) {
        longjmp(env, 1);
    }
}

//!
//! \brief
//!    Initialize defaults
//!

void command_t::initialize(void) {

    //
    // Initialize MT default parameters
    //

    mt_cfg.baseaddr  = 03772440;                        // Standard base address
    mt_cfg.bootdiag  = false;                           // Not booting to diagnostics
    mt_cfg.debugMask = 0x0fffb;                         // Debug Mask
    for (int i = 0; i < 8; i++) {
        mt_cfg.drive[i].fp          = NULL;             // No tape file attached to slave
        mt_cfg.drive[i].param       = 00002000 + i;     // 1600 BPI + slave
        mt_cfg.drive[i].length      = 2400;             // 2400 foot tape
        mt_cfg.drive[i].filename[0] = 0;                // Filename
        mt_cfg.drive[i].attached    = false;            // Not mounted
    }
    ks10_t::writeMTCCR(0x00000000);

    //
    // Initialize RP default parameters
    //

    rp_cfg.baseaddr = 01776700;
    rp_cfg.unit     = 00000000;
    rp_cfg.bootdiag = false;
    ks10_t::writeRPCCR(0x00000000);

    //
    // Initialize the Console Communications memory area
    //

    ks10_t::writeMem(ks10_t::switchADDR,  0400000400000);       // Initialize switch register
    ks10_t::writeMem(ks10_t::kaswADDR,    0003740000000);       // Initialize keep-alive and status word
    ks10_t::writeMem(ks10_t::ctyinADDR,   0000000000000);       // Initialize CTY input word
    ks10_t::writeMem(ks10_t::ctyoutADDR,  0000000000000);       // Initialize CTY output word
    ks10_t::writeMem(ks10_t::klninADDR,   0000000000000);       // Initialize KLINIK input word
    ks10_t::writeMem(ks10_t::klnoutADDR,  0000000000000);       // Initialize KLINIK output word
}

//!
//! \brief
//!    Set disk boot parameters in the Console Communications memory area
//!

static void rpSetBootParam(void) {
    ks10_t::writeMem(ks10_t::rhbaseADDR, rp_cfg.baseaddr);
    ks10_t::writeMem(ks10_t::rhunitADDR, rp_cfg.unit);
    ks10_t::writeMem(ks10_t::mtparmADDR, 0);
}

//!
//! \brief
//!    Set tape boot parameters in the Console Communications memory area
//!

static void mtSetBootParam(uint32_t unit) {
    ks10_t::writeMem(ks10_t::rhbaseADDR, mt_cfg.baseaddr);
    ks10_t::writeMem(ks10_t::rhunitADDR, unit);
    ks10_t::writeMem(ks10_t::mtparmADDR, mt_cfg.drive[unit].param);
}

//!
//! \brief
//!    Function to interface to the KS10 console
//!
//! \details
//!    #. ^C is caught and sent to the KS10 monitor program instead of
//!          performing the default INTR action the console program.
//!    #. ^E will disconnect the console from the KS10 CTY and escape back to
//!          the console prompt. You can re-connect with the CO command.
//!          When you type ^E, the default signal action for ^C (QUIT),
//!          ^Z (SUSP), and ^\ (QUIT) are restored.
//!    #. ^L will set the printer on-line. This is useful for the DSLPA
//!          diagnostic that keeps settting the printer off-line.
//!    #. ^T prints the program counter and disassmbles the current instruction.
//!          This command generally satifies my curiousity about "is it stuck?".
//!    #. ^Z is caught and sent to the KS10 monitor program instead of
//!          performing the default SUSP action the console program.
//!    #. ^\ is caught and sent to the KS10 monitor program instead of
//!          performing the default QUIT action the console program.
//!
//!    You can type an escape character before the ^E, ^T, and ^L which will
//!    send the ^E, ^T, or ^L to the monitor running on the KS10.
//!

bool command_t::consoleOutput(void) {
    bool escape = false;

    const char cntl_e = 0x05;   // ^E
    const char cntl_l = 0x0c;   // ^L
    const char cntl_t = 0x14;   // ^T

    //
    // Pass INTR, QUIT, SUSP characters to KS10. Don't generate signals.
    //

    struct termios termattr;
    tcgetattr(STDIN_FILENO, &termattr);
    termattr.c_lflag &= ~ISIG;
    tcsetattr(STDIN_FILENO, TCSANOW, &termattr);

    //
    // Pass ^C to the monitor. Don't abort.
    //
    // Note: We poll characters and abort on ^E
    //

    sa.sa_handler = SIG_IGN;
    sigaction(SIGINT, &sa, NULL);

    fd_set fds;
    struct timeval tv = {0, 0};

    //
    // Loop while not halted
    //

    do {

        //
        // Check STDIN for a character to send to the KS10
        //
        //  The escape character escapes the ^E, ^L, and ^T commands
        //
        //  Typing two sequential escape characters will pass a single escape
        //  character to the KS10 CTY.
        //

        FD_ZERO(&fds);
        FD_SET(STDIN_FILENO, &fds);

        if (select(1, &fds, NULL, NULL, &tv) != 0) {
            int ch = getchar();
            if (!escape && ch == '\e') {
                escape = true;
                continue;
            } else if (!escape && (ch == cntl_e)) {
                printf("^E\n");
                break;
            } else if (!escape && (ch == cntl_t)) {
                printPCIR(ks10_t::readPCIR());
            } else if (!escape && (ch == cntl_l)) {
                ks10_t::writeLPCCR(ks10_t::lpONLINE | ks10_t::readLPCCR());
            } else {

                //
                // The KS10 CTY requires a carriage return -
                //  not a newline character.
                //

                if (ch == '\n') {
                    ch = '\r';
                }
                ks10_t::putchar(ch);
                escape = false;
            }
        }

        //
        // Sleep for 100 us
        //

        usleep(100);
    } while (!ks10_t::halt());

    //
    // Restore the terminal attributes
    //

    termattr.c_lflag |= ISIG;
    tcsetattr(STDIN_FILENO, TCSANOW, &termattr);

    return !ks10_t::halt();
}

//!
//! \brief
//!    Patch the code and whine about it
//!
//! \param [in] addr -
//!    addr is the address to be patched
//!
//! \param [in] data -
//!    data is the data to be written at the patch address
//!

void patchCode(ks10_t::addr_t addr, ks10_t::data_t data) {
    ks10_t::writeMem(addr, data);
    printf("KS10: Patched executable with a %012llo instruction at address %06llo.\n", data, addr);
}

//!
//! \brief
//!    Parses an octal number
//!
//! \param [in] buf
//!     Pointer to line buffer.
//!
//! \returns
//!     Number
//!

static ks10_t::data_t parseOctal(const char *buf) {

    ks10_t::data_t num = 0;

    for (int i = 0; i < 36; i += 3) {
        if (*buf >= '0' && *buf <= '7') {
            num += *buf++ - '0';
            num <<= 3;
        } else {
            if (*buf != 0) {
                printf("Parsed invalid character.\n");
            }
            break;
        }
    }
    num >>= 3;

    return num;
}

//!
//! \brief
//!    This function builds a 36-bit data word from the contents of the .SAV
//!    file.
//!
//! \param
//!    b is a pointer to the input data
//!
//! \details
//!    Data is in the format:
//!
//!       Byte 0:   0  B00 B01 B02 B03 B04 B05 B06
//!       Byte 1:   0  B07 B08 B09 B10 B11 B12 B13
//!       Byte 2:   0  B14 B15 B16 B17 B18 B19 B20
//!       Byte 3:   0  B21 B22 B23 B24 B25 B26 B27
//!       Byte 4:  B35 B28 B29 B30 B31 B32 B33 B34
//!
//!       Note the position of B35!
//!
//!    See "TOPS-10 Tape Processing Manual" Section 6.4 entitled "ANSI-ASCII
//!    Mode" for format definition.
//!
//!    See also document entitled "Dumper and Backup Tape Formats".
//!
//! \returns
//!    36-bit data word
//!

ks10_t::data_t rdword(const uint8_t *b) {
    return ((((ks10_t::data_t)(b[0] & 0x7f)) << 29) |   // Bit  0 - Bit  6
            (((ks10_t::data_t)(b[1] & 0x7f)) << 22) |   // Bit  7 - Bit 13
            (((ks10_t::data_t)(b[2] & 0x7f)) << 15) |   // Bit 14 - Bit 20
            (((ks10_t::data_t)(b[3] & 0x7f)) <<  8) |   // Bit 21 - Bit 27
            (((ks10_t::data_t)(b[4] & 0x7f)) <<  1) |   // Bit 28 - Bit 34
            (((ks10_t::data_t)(b[4] & 0x80)) >>  7));   // Bit 35
}

//!
//! \brief
//!    Read the PDP10 .SAV file
//!
//! \details
//!    This function reads 5-byte buffers from the FAT filesytems and converts
//!    the data into PDP10 words.
//!
//! \param [in] fp
//!    file pointer
//!
//! \pre
//!    The filesystem must be mounted and the file must be opened.
//!
//! \returns
//!    a 36-bit PDP10 word
//!
//! \note
//!    The .SAV file should be a multiple of 5 bytes in size.
//!

ks10_t::data_t getdata(FILE *fp) {

    uint8_t buffer[5];
    size_t bytes = fread(buffer, 1, sizeof(buffer), fp);
    if (bytes != sizeof(buffer)) {
        printf("KS10: getdata - read() failed.\n");
    }

    return rdword(buffer);
}

//!
//! \brief
//!    Load code into the KS10
//!
//! \details
//!    This function reads a .SAV file and writes the contents of that file to
//!    the KS10 memory. The .SAV file also contains the starting address of
//!    the executable. This address is loaded into the Console Instruction
//!    Register.
//!
//! \param [in] filename
//!    filename of the .SAV file
//!

static bool loadCode(const char * filename) {

    FILE *fp = fopen(filename, "r");
    if (fp == NULL) {
        printf("KS10: fopen(%s) failed.\n", filename);
        return false;
    }

    for (;;) {

        //
        // The data36 format is:  -n,,a-1
        //

        ks10_t::data_t data36 = getdata(fp);
        unsigned int words    = ks10_t::lh(data36);
        unsigned int addr     = ks10_t::rh(data36);
#if 0
        printf("addr is %06o, words is %06o\n", addr, words);
#endif

        //
        // Check for end
        //

        if ((words & 0400000) == 0) {
            if (words == ks10_t::opJRST) {

                //
                // Create JRST to starting address.
                //

                printf("KS10: Starting Address: %06o,,%06o\n", ks10_t::lh(data36), ks10_t::rh(data36));
                ks10_t::writeRegCIR(data36);
            }
            fclose(fp);
            return true;
        }

        //
        // Read record
        //

        while ((words & 0400000) != 0) {
            ks10_t::data_t data36 = getdata(fp);
            addr  = (addr  + 1) & 0777777;
            ks10_t::writeMem(addr, data36);
#if 0
            printf("%06o\t%s\n", addr, dasm(data36));
#endif
            words = (words + 1) & 0777777;
        }
    }
}

//!
//! \brief
//!   Function to disassemble and print  memory contents
//!
//! \param addr
//!   Address of data to begin disassembly
//!
//! \param len
//!   Number of words to read and print
//!

static void dasmMEM(ks10_t::addr_t addr, unsigned int len) {
    printf("KS10: Memory disassembly:\n");
    for (unsigned int i = 0; i < len; i++) {
        ks10_t::data_t data = ks10_t::readMem(addr);
        if (ks10_t::nxmnxd()) {
            printf("  Failed. (NXM)\n");
        } else {
            printf("%07llo: %s\n", addr & ks10_t::maxMemAddr, dasm(data));
        }
        addr++;
    }
}

//!
//! \brief
//!   Function to print trace data
//!

void printPCIR(uint64_t data) {
    unsigned int pc = (data >> 36) &  0777777;
    unsigned long long ir = (data >> 0) & 0777777777777;
    printf("%06o\t%s\n", pc, dasm(ir));
}

//!
//! \brief
//!   BANG to shell
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!
//! \note
//!    Normally you cannot edit the command line, but ...
//!

bool command_t::cmdBA(int argc, char *argv[]) {

    int status __unused;

    const char *usage =
        "\n"
        "The \"bang\" command escapes to a sub-subprogram. The \"bang\" command is\n"
        "executed by entering the \"!\" character.\n"
        "\n"
        "Usage: ! [--help] <options>\n"
        "\n"
        "\"!\" without options will start a bash sub-shell\n"
        "\"!\" with options will execute the options as a program\n"
        "For example:\n"
        "\"!\" - start bash shell\n"
        "\"! ls -al\" - will list a directory\n"
        "\n";

    struct termios ctrl;
    tcgetattr(STDIN_FILENO, &ctrl);
    ctrl.c_lflag |= (ICANON | ECHO);
    tcsetattr(STDIN_FILENO, TCSANOW, &ctrl);

    switch(argc) {
        case 0:
            break;
        case 1:
            status = system("sh");
            break;
        case 2:
            if (strncasecmp(argv[1], "--help", 6) == 0)  {
                printf(usage);
                // Fix TTY attributes and return
                break;
            }
#if __GNUC__ > 6
            [[fallthrough]];
#endif
        default: {
            char *p = (char *)argv[1];
            char *end = &p[80];
            for (int i = 1; i < argc-1; i++) {
                while (p < end) {
                    if (*p == 0) {
                        *p = ' ';
                        p++;
                        break;
                    } else {
                        p++;
                    }
                }
            }
            status = system(argv[1]);
        }
    }

    tcgetattr(STDIN_FILENO, &ctrl);
    ctrl.c_lflag &= ~(ICANON | ECHO);
    tcsetattr(STDIN_FILENO, TCSANOW, &ctrl);

    return true;
}

//!
//! \brief
//!    Dump BRAR or BRMR
//!

static void printBRxR(ks10_t::data_t dbxr, const char *regName) {
    printf("%s: %012llo\n"
           "       FLAGS   : %s%s%s%s%s%s\n"
           "       ADDRESS : %08llo\n",
           regName, dbxr,
           dbxr & ks10_t::flagFetch ? "Fetch "    : "",
           dbxr & ks10_t::flagRead  ? "Read "     : "",
           dbxr & ks10_t::flagWrite ? "Write "    : "",
           dbxr & ks10_t::flagPhys  ? "Physical " : "",
           dbxr & ks10_t::flagIO    ? "IO "       : "",
           dbxr & ks10_t::flagByte  ? "Byte "     : "",
          (dbxr & ks10_t::flagIO)   ? dbxr & ks10_t::brarIOMASK : dbxr & ks10_t::brarMEMMASK);
}

//!
//! \brief
//!   Print breakpoint status
//!

static void cmdBR_printStatus(char unit) {

    ks10_t::data_t brar;
    ks10_t::data_t brmr;

    switch(unit) {
        case '0':
            brar = ks10_t::readBRAR(0);
            brmr = ks10_t::readBRMR(0);
            if ((brar == 0) && (brmr == 0)) {
                printf("br0: breakpoint disabled\n");
            } else {
                printBRxR(brar, "BRAR0");
                printBRxR(brmr, "BRMR0");
            }
            break;
        case '1':
            brar = ks10_t::readBRAR(1);
            brmr = ks10_t::readBRMR(1);
            if ((brar == 0) && (brmr == 0)) {
                printf("br1: breakpoint disabled\n");
            } else {
                printBRxR(brar, "BRAR1");
                printBRxR(brmr, "BRMR1");
            }
            break;
        case '2':
            brar = ks10_t::readBRAR(2);
            brmr = ks10_t::readBRMR(2);
            if ((brar == 0) && (brmr == 0)) {
                printf("br2: breakpoint disabled\n");
            } else {
                printBRxR(brar, "BRAR2");
                printBRxR(brmr, "BRMR2");
            }
            break;
        case '3':
            brar = ks10_t::readBRAR(3);
            brmr = ks10_t::readBRMR(3);
            if ((brar == 0) && (brmr == 0)) {
                printf("br3: breakpoint disabled\n");
            } else {
                printBRxR(brar, "BRAR3");
                printBRxR(brmr, "BRMR3");
            }
            break;
    }
}

//!
//! \brief
//!   Breakpoint control
//!
//! \details
//!    The <b>BR#</b> (Breakpoint) command creates a hardware breakpoint.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

bool command_t::cmdBR(int argc, char *argv[]) {

    const char *usage =
        "\n"
        "The \"br#\" command controls the breakpoint hardware.\n"
        "\n"
        "When a breakpoint condtion is triggered, the breakpoint hardware will halt the\n"
        "processor. There are four independant sets of breakpoint registers which allows\n"
        "up to four independant breakpoints to be configured simultaneously. The\n"
        "breakpoint device monitors the address on the KS10 backplane bus and when an\n"
        "address match is detected, the breakpoint hardware asserts the \"Console Halt\"\n"
        "signal to the KS10 which stops the KS10 at the completion of the current\n"
        "instruction.\n"
        "\n"
        "usage: br[#] [options] \"break_condition\"\n"
        "\n"
        "There are four sets of breakpoint registers. These are configured as follows:\n"
        "\n"
        "  br  : Used to reference all breakpoints\n"
        "  br0 : Breakpoint 0\n"
        "  br1 : Breakpoint 1\n"
        "  br2 : Breakpoint 2\n"
        "  br3 : Breakpoint 3\n"
        "\n"
        "Valid options are:\n"
        "\n"
        "  --help          Print help message and exit.\n"
        "  --disable       Disable the specified breakpoint and exit.\n"
        "  --mask=mask     Set an address match mask. This parameter modifies the\n"
        "                  specified \"break condition\". The mask parameter is a 22-bit\n"
        "                  constant that is masked against bits 14-35 of the address bus.\n"
        "                  Bits that are asserted in the address mask are ignored when\n"
        "                  performing the address match comparison. The default mask is\n"
        "                  0 and therefore all address bits are relevant to the address\n"
        "                  match logic.\n"
        "\n"
        "One (and only one) of the following \"break condtions\" must be provided:\n"
        "\n"
        "  --fetch=addr    Break on an instruction fetch at the specified address.\n"
        "  --mem=addr      Break on a memory read or memory write at the specified\n"
        "                  address.\n"
        "  --memrd=addr    Break on a memory read at the specified adress.\n"
        "  --memwr=addr    Break on a memory write at the specified adress.\n"
        "  --io=addr       Break on an IO read or an IO write at the specified address.\n"
        "  --iord=addr     Break on an IO read at the specified adress.\n"
        "  --iowr=addr     Break on an IO write at the specified adress.\n"
        "  --raw=brar,brmr Provide low level inputs to the Debug Breakpoint Address\n"
        "                  Register (BRAR) and Debug Breakpoint Mask Register (BRMR).\n"
        "                  See the register descriptions for usage.\n"
        "\n"
        "Note: it is a quirk of the KS10 Backplane Bus implementation one must set two\n"
        "breakpoints to break on either a read or a write.\n"
        "\n"
        "The addr, mask, brar and brmr parameters described above are 22-bit constants\n"
        "that are matched against the KS10 Backplane Bus address bits 14-35.\n"
        "\n"
        "Examples:\n"
        "  \"br\" with no options will print the status of all four breakpoints.\n"
        "  \"br0\" with no otions will print the status of breakpoint #0.\n"
        "  \"br --disable\" will disable all breakpoints.\n"
        "  \"br1 --disable\" will disable breakpoint #1\n"
        "  \"br2 --fetch 030000\" will configure breakpoint #2 to break on an\n"
        "      instruction fetch at address 030000.\n"
        "  \"br2 --fetch 030000 --mask 3\" will configure breakpoint #2 to break on any\n"
        "      instruction fetch between address 030000 and address 030003.\n"
        "  \"br2 --iord 03772440 --mask 037;br3 --iowr 03772440 --mask 037\" will\n"
        "      configure breakpoint #2 and breakpoint #3 to trigger on either a IO Read\n"
        "      or IO Write to the Magtape Controller. The Magtape Controller has and\n"
        "      IO addresses range of between 03772440 and 03772477 inclusive.\n"
        "\n";

    //
    // Command line options
    //

    static const struct option options[] = {
        {"help",    no_argument,       0, 0},  //  0
        {"disable", no_argument,       0, 0},  //  1
        {"fetch",   required_argument, 0, 0},  //  2
        {"mem",     required_argument, 0, 0},  //  3
        {"memrd",   required_argument, 0, 0},  //  4
        {"memwr",   required_argument, 0, 0},  //  5
        {"io",      required_argument, 0, 0},  //  6
        {"iord",    required_argument, 0, 0},  //  7
        {"iowr",    required_argument, 0, 0},  //  8
        {"mask",    required_argument, 0, 0},  //  9
        {"raw",     required_argument, 0, 0},  // 10
        {0,         0,                 0, 0},  // 11
    };

    //
    // Get breakpoint unit
    //

    char unit = argv[0][2];

    //
    // Print breakpoint status
    //

    if (argc == 1) {
        switch(unit) {
            case '0' ... '3':
                cmdBR_printStatus(unit);
                break;
            default:
                unit = ' ';
                for (int ch = '0'; ch < '4'; ch++) {
                    cmdBR_printStatus(ch);
                }
                break;
        }
        return true;
    }

    //
    // Process command line
    //

    int index = 0;
    ks10_t::addr_t addr = 0;
    ks10_t::addr_t brar = 0;
    ks10_t::addr_t brmr = 0;
    ks10_t::addr_t mask = 0;

    opterr = 0;
    for (;;) {
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("br: unrecognized option: %s\n", argv[optind-1]);
            return true;
        } else {
            switch(index) {
                case 0: // help
                    printf(usage);
                    return true;
                case 1: // disable
                    switch (unit) {
                        case '0':
                            ks10_t::writeBRAR(0, 0);
                            ks10_t::writeBRMR(0, 0);
                            printf("br0: breakpoint disabled\n");
                            break;
                        case '1':
                            ks10_t::writeBRAR(1, 0);
                            ks10_t::writeBRMR(1, 0);
                            printf("br1: breakpoint disabled\n");
                            break;
                        case '2':
                            ks10_t::writeBRAR(2, 0);
                            ks10_t::writeBRMR(2, 0);
                            printf("br2: breakpoint disabled\n");
                            break;
                        case '3':
                            ks10_t::writeBRAR(3, 0);
                            ks10_t::writeBRMR(3, 0);
                            printf("br3: breakpoint disabled\n");
                            break;
                        case 0:
                            for (int i = 0; i < 4; i++) {
                                ks10_t::writeBRAR(i, 0);
                                ks10_t::writeBRMR(i, 0);
                            }
                            printf("br: all breakpoints disabled\n");
                            break;
                    }
                    return true;
                case 2: //fetch
                    addr = ks10_t::brarMEMMASK & parseOctal(argv[optind-1]);
                    brar = ks10_t::brarFETCH | addr;
                    brmr = ks10_t::brmrFETCH | ks10_t::brmrMEMMASK;
                    break;
                case 3: // mem
                    // Setting both brarMEMWR and brarMEMRD isn't a valid bus
                    // cycle but we use this combination of bits to tell the
                    // trace hardware that we want to breakpoint on either an
                    // memory read or a memory write. The breakpoint hardware
                    // decodes this combination bits and does the right thing.
                    addr = ks10_t::brarMEMMASK & parseOctal(argv[optind-1]);
                    brar = ks10_t::brarMEMWR | ks10_t::brarMEMRD | addr;
                    brmr = ks10_t::brmrMEMWR | ks10_t::brmrMEMWR | ks10_t::brmrMEMMASK;
                    break;
                case 4: // memrd
                    addr = ks10_t::brarMEMMASK & parseOctal(argv[optind-1]);
                    brar = ks10_t::brarMEMRD | addr;
                    brmr = ks10_t::brmrMEMRD | ks10_t::brmrMEMMASK;
                    break;
                case 5: // memwr
                    addr = ks10_t::brarMEMMASK & parseOctal(argv[optind-1]);
                    brar = ks10_t::brarMEMWR | addr;
                    brmr = ks10_t::brmrMEMWR | ks10_t::brmrMEMMASK;
                    break;
                case 6: // io
                    // Setting both brarIOWR and brarIOMRD isn't a valid bus
                    // cycle but we use this combination of bits to tell the
                    // trace hardware that we want to breakpoint on either an
                    // IO read or an IO write. The breakpoint hardware decodes
                    // this combination of bits and does the right thing.
                    addr = ks10_t::brarIOMASK & parseOctal(argv[optind-1]);
                    brar = ks10_t::brarIORD | ks10_t::brarIOWR | addr;
                    brmr = ks10_t::brmrIORD | ks10_t::brmrIOWR | ks10_t::brmrIOMASK;
                    break;
                case 7: // iord
                    addr = ks10_t::brarIOMASK & parseOctal(argv[optind-1]);
                    brar = ks10_t::brarIORD | addr;
                    brmr = ks10_t::brmrIORD | ks10_t::brmrIOMASK;
                    break;
                case 8: // iowr
                    addr = ks10_t::brarIOMASK & parseOctal(argv[optind-1]);
                    brar = ks10_t::brarIOWR | addr;
                    brmr = ks10_t::brmrIOWR | ks10_t::brmrIOMASK;
                    break;
                case 9: // mask
                    mask = ks10_t::brarIOMASK & parseOctal(argv[optind-1]);
                    break;
                case 10: // raw
                    printf("br --raw not implemented.\n");
                    break;
            }
        }
    }

#if 1
    printf("argc = %d, index = %d, optind = %d\n", argc, index, optind);
    printf("arv[0] = %s\n", argv[0]);
    printf("arv[1] = %s\n", argv[1]);
    printf("arv[2] = %s\n", argv[2]);
    printf("arv[3] = %s\n", argv[3]);
    printf("arv[4] = %s\n", argv[4]);
    printf("arv[5] = %s\n", argv[5]);
#endif

    //
    // Set the breakpoint registers
    //

    switch(unit) {
        case '0':
            ks10_t::writeBRAR(0, brar);
            ks10_t::writeBRMR(0, brmr & ~mask);
            break;
        case '1':
            ks10_t::writeBRAR(1, brar);
            ks10_t::writeBRMR(1, brmr & ~mask);
            break;
        case '2':
            ks10_t::writeBRAR(2, brar);
            ks10_t::writeBRMR(2, brmr & ~mask);
            break;
        case '3':
            ks10_t::writeBRAR(3, brar);
            ks10_t::writeBRMR(3, brmr & ~mask);
            break;
    }

    return true;

}

//!
//! \brief
//!    Cache Enable
//!
//! \details
//!    The <b>CE</b> (Cache Enable) command controls the operation the KS10's
//!    cache.
//!
//!    - The <b>CE</b> command will display KS10's cache status.
//!    - The <b>CE --enable</b> command will enable the KS10's cache.
//!    - The <b>CE --disable</b> command will disable the KS10's cache.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

bool command_t::cmdCE(int argc, char *argv[]) {

    const char *usage =
        "\n"
        "The \"ce\" commands controls the operation of the KS10 cache.\n"
        "\n"
        "Usage: ce <options>\n"
        "ce without an option will display the cache status.\n"
        "\n"
        "Valid options are:\n"
        "\n"
        "  [--en[able]]  Enable the cache.\n"
        "  [--dis[able]] Disable the cache.\n"
        "\n"
        "Although this command tells the KS10 to enable the cache, it doesn\'t do\n"
        "anything. The KS10 FPGA uses very fast SSRAM memory and every memory\n"
        "cycle completes in a single KS10 clock cycle.\n"
        "\n";

    static const struct option options[] = {
        {"help",    no_argument, 0, 0},  // 0
        {"di",      no_argument, 0, 0},  // 1
        {"dis",     no_argument, 0, 0},  // 2
        {"disable", no_argument, 0, 0},  // 3
        {"en",      no_argument, 0, 0},  // 4
        {"enable",  no_argument, 0, 0},  // 5
        {0,         0,           0, 0},  // 6
    };

    //
    // No arguments
    //

    if (argc == 1) {
        printf("ce: the cache currently %s.\n", ks10_t::cacheEnable() ? "enabled" : "disabled");
        return true;
    }

    //
    // Process command line
    //

    opterr = 0;
    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("ce: unrecognized option \"%s\"\n\n%s", argv[optind-1], usage);
            return true;
        } else {
            switch(index) {
                case 0:
                    printf(usage);
                    return true;;
                case 1:
                case 2:
                case 3:
                    ks10_t::cacheEnable(false);
                    printf("ce: the cache is disabled\n");
                    return true;
                case 4:
                case 5:
                    ks10_t::cacheEnable(true);
                    printf("ce: the cache is enabled\n");
                    return true;
            }
        }
    }
    return true;
}

//!
//! \brief
//!    CPU
//!
//! \details
//!    The <b>CPU</b> command configures and controls the operation of the KS10
//!    CPU.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the argument.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

bool command_t::cmdCPU(int argc, char *argv[]) {

    const char *usage =
        "\n"
        "The \"CP[U]\" commands \n"
        "\n"
        "  --reset                           Reset the KS10 and peripherals\n"
        "  --stat[us]                        Display halt status\n"
        "  --co[ntinue]                      Continue\n"
        "  --ha[lt]                          Halt\n"
        "  --step[=count]                    Single step\n"
        "  --cache[={en[able] | di[sable]}]  Control cache\n"
        "  --timer[={en[able] | di[sable]}]  Enable timer\n"
        "  --trap[={en[able]  | di[sable]}]  Enable traps\n"
        "\n";

    static const struct option options[] = {
        {"help",     no_argument,       0, 0},  //  0
        {"reset",    no_argument,       0, 0},  //  1
        {"stat",     no_argument,       0, 0},  //  2
        {"status",   no_argument,       0, 0},  //  3
        {"cache",    optional_argument, 0, 0},  //  4
        {"timer",    optional_argument, 0, 0},  //  5
        {"trap",     optional_argument, 0, 0},  //  6
        {"co",       no_argument,       0, 0},  //  7
        {"cont",     no_argument,       0, 0},  //  8
        {"continue", no_argument,       0, 0},  //  9
        {"ha",       no_argument,       0, 0},  // 10
        {"halt",     no_argument,       0, 0},  // 11
        {"si",       optional_argument, 0, 0},  // 12
        {"step",     optional_argument, 0, 0},  // 13
        {0,          0,                 0, 0},  // 14
    };

    if (argc == 1) {
        printf("\n"
               "cp: Cache %s\n"
               "    Traps %s\n"
               "    Timer %s\n"
               "\n",
               ks10_t::cacheEnable() ? "enabled" : "disabled",
               ks10_t::trapEnable()  ? "enabled" : "disabled",
               ks10_t::timerEnable() ? "enabled" : "disabled");
        return true;
    }

    //
    // Process command line
    //

    opterr = 0;
    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("cp: unrecognized option \"%s\"\n\n%s", argv[optind-1], usage);
            return true;
        } else {
            switch (index) {
                case 0: // --help
                    printf(usage);
                    return true;
                case 1: // --reset
                    ks10_t::cpuReset(true);
                    usleep(100);
                    ks10_t::cpuReset(false);
                    while (!ks10_t::halt()) {
                        ;
                    }
                    printf("cp reset: CPU was reset.\n");
                    return false;
                case 2:
                case 3: // --stat
                    ks10_t::printHaltStatusBlock();
                    return true;
                case 4: // --cache
                    if (optarg == NULL) {
                        printf("cp cache: cache is %s\n", ks10_t::cacheEnable() ? "enabled" : "disabled");
                    } else {
                        if ((toupper(optarg[0]) == 'D') && (toupper(optarg[1]) == 'I')) {
                            ks10_t::cacheEnable(false);
                        } else if ((toupper(optarg[0]) == 'E') && (toupper(optarg[1]) == 'N')) {
                            ks10_t::cacheEnable(true);
                        } else {
                            printf("cp cache: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                        }
                    }
                    break;
                case 5: // --timer
                    if (optarg == NULL) {
                        printf("cp timer: timer is %s\n", ks10_t::timerEnable() ? "enabled" : "disabled");
                    } else {
                        if ((toupper(optarg[0]) == 'D') && (toupper(optarg[1]) == 'I')) {
                            ks10_t::timerEnable(false);
                        } else if ((toupper(optarg[0]) == 'E') && (toupper(optarg[1]) == 'N')) {
                            ks10_t::timerEnable(true);
                        } else {
                            printf("cp timer: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                        }
                    }
                    break;
                case 6: // --trap
                    if (optarg == NULL) {
                        printf("cp trap: traps are %s\n", ks10_t::trapEnable() ? "enabled" : "disabled");
                    } else {
                        if ((toupper(optarg[0]) == 'D') && (toupper(optarg[1]) == 'I')) {
                            ks10_t::trapEnable(false);
                        } else if ((toupper(optarg[0]) == 'E') && (toupper(optarg[1]) == 'N')) {
                            ks10_t::trapEnable(true);
                        } else {
                            printf("cp trap: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                        }
                    }
                    break;
                case 7:
                case 8:
                case 9:
                    printf("cp cont: continued.\n");
                    ks10_t::startCONT();
                    return consoleOutput();
                case 10:
                case 11:
                    ks10_t::run(false);
                    for (int i = 0; i < 100; i++) {
                        if (ks10_t::halt()) {
                            return true;
                        }
                        usleep(1000);
                    }
                    printf("cp halt: halted.\n");
                    return true;
                case 12:
                case 13:
                    if (optarg == NULL) {
                        ks10_t::startSTEP();
                        printf("cp step: KS10 single stepped\n");
                        return true;
                    } else {
                        if (isdigit(optarg[0])) {
                            unsigned int num = strtoul(optarg, NULL, 0);
                            for (unsigned int i = 0; i < num; i++) {
                                ks10_t::startSTEP();
                            }
                            printf("cp step: single stepped %d instructions\n", num);
                        } else {
                            printf("cp step: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                            return true;
                        }
                    }
                    break;
            }
        }
    }
    return true;
}

//!
//! \brief
//!    Continue
//!
//! \details
//!    The <b>CO</b> (Continue) command causes the KS10 to exit the <b>HALT</b>
//!    state and continue operation.
//!
//! \sa cmdHA, cmdSI
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \note
//!    If a breakpoint was previously armed, we will re-arm it before
//!    continuing.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

bool command_t::cmdCO(int argc, char *argv[]) {

    const char *usage =
        "\n"
        "The \"co\" command continues the KS10. If the KS10 is halted, this command will\n"
        "cause the KS10 to continue execution from the location where is was halted.\n"
        "If the KS10 has been running, the CTY output from the KS10 has been routed to\n"
        "the \"bit-bucket\". Whether the KS10 was halted or not, the command will attach\n"
        "the console to the running KS10 program.\n"
        "\n"
        "Usage: co [--help]\n"
        "\n";

    static const struct option options[] = {
        {"help",    no_argument, 0, 0},  // 0
        {0,         0,           0, 0},  // 1
    };

    //
    // Process command line
    //

    opterr = 0;
    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("co: unrecognized option \"%s\"\n\n%s", argv[optind-1], usage);
            return true;
        } else if (index == 0) {
            printf(usage);
            return true;
        }
    }

    if (argc > 2) {
        printf("co: additional arguments ignored\n");
    }

    ks10_t::startCONT();
    return consoleOutput();
}

//!
//! \brief
//!    Clear screen
//!
//! \details
//!    The <b>CL</b> clears the screen.
//!

bool command_t::cmdCL(int, char *[]) {
    printf("%s%s", vt100_hom, vt100_cls);
    return true;
}

//!
//! \brief
//!    Disassemble Memory
//!
//! \details
//!    The <b>DA</b> (Disassemble) disassembles the contents of a
//!    memory address.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

bool command_t::cmdDA(int argc, char *argv[]) {

    const char *usage =
        "\n"
        "The \"da\" (dasm) command is used to disassemble memory contents.\n"
        "\n"
        "Usage: da [--help] addr [length].\n"
        "\n";

    static const struct option options[] = {
        {"help",    no_argument, 0, 0},  // 0
        {0,         0,           0, 0},  // 1
    };

    //
    // Process command line
    //

    opterr = 0;
    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("da: unrecognized option \"%s\"\n\n%s", argv[optind-1], usage);
            return true;
        } else if (index == 0) {
            printf(usage);
            return true;
        }
    }

    switch (argc) {
        case 2:
            dasmMEM(parseOctal(argv[1]), 1);
            break;
        case 3:
            dasmMEM(parseOctal(argv[1]), parseOctal(argv[2]));
            break;
        default:
            printf("da: missing arguments\n%s", usage);
    }

    return true;

}

//!
//! \brief
//!    Configure DUP11
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the argument.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

static bool cmdDUP_CONF(int argc, char *argv[]) {

    uint32_t dupccr = ks10_t::readDUPCCR();

    static const char *usage =
        "\n"
        "The \"du[p] config\" command configures and displays the configuration the\n"
        "DUP11.\n"
        "\n"
        "Usage: dup config [option]\n"
        "\n"
        "Valid options are:\n"
        "   [--help]                     Print help.\n"
        "   [--loop={t[rue]} | {f[alse}] Set status of H325 loopback plug.\n"
        "   [--h325={t[rue]} | {f[alse}] Set status of H325 loopback plug.\n"
        "   [--ri={t[rue]}  | {f[alse}]  Set Ring Indication state.\n"
        "   [--ctr={t[rue]} | {f[alse}]  Set Clear to Send state.\n"
        "   [--dsr={t[rue]} | {f[alse}]  Set Data Set Ready state.\n"
        "   [--dcd={t[rue]} | {f[alse}]  Set Data Carrier Detect state.\n"
        "   [--w3={t[rue]} | {f[alse}]   Install or remove jumper W3.\n"
        "   [--w5={t[rue]} | {f[alse}]   Install or remove jumper W5.\n"
        "   [--w6={t[rue]} | {f[alse}]   Install or remove jumper W6.\n"
        "\n"
        "Examples:\n"
        "\n"
        "  dup config (with no options)\n"
        "\n"
        "    Prints the DUP configuration.\n"
        "\n"
        "  dup config --w3=true --dcd=true --ri=true --loop=true\n"
        "\n"
        "    Installs the W3 jumper, asserts Data Carrier Detect and Ring Indication\n"
        "    and installs the H325 loopback plug.\n"
        "\n";

    static const struct option options[] = {
        {"help",   no_argument,       0, 0},  //  0
        {"loop",   required_argument, 0, 0},  //  1
        {"h325",   required_argument, 0, 0},  //  2
        {"ri",     required_argument, 0, 0},  //  3
        {"cts",    required_argument, 0, 0},  //  4
        {"dsr",    required_argument, 0, 0},  //  5
        {"dcd",    required_argument, 0, 0},  //  6
        {"w3",     required_argument, 0, 0},  //  7
        {"w5",     required_argument, 0, 0},  //  8
        {"w6",     required_argument, 0, 0},  //  9
        {0,        0,                 0, 0},  // 10
    };

    //
    // No argument
    // Print status
    //

    if (argc == 2) {
        uint32_t dupccr = ks10_t::readDUPCCR();
        printf("        DUPCCR                    : 0x%08x\n"
               "        Ring Indication     (RI)  : %s\n"
               "        Clear to Send       (CTS) : %s\n"
               "        Data Set Ready      (DSR) : %s\n"
               "        Data Carrier Detect (DCD) : %s\n"
               "        Data Terminal Ready (DTR) : %s\n"
               "        Request to Send     (RTS) : %s\n"
               "        Jumper W3                 : %s\n"
               "        Jumper W5                 : %s\n"
               "        Jumper W6                 : %s\n"
               "        Loopback (H325 Installed) : %s\n",
               dupccr,
               ((dupccr >> (31- 4)) & 1) ? "True" : "False",
               ((dupccr >> (31- 5)) & 1) ? "True" : "False",
               ((dupccr >> (31- 6)) & 1) ? "True" : "False",
               ((dupccr >> (31- 7)) & 1) ? "True" : "False",
               ((dupccr >> (31-17)) & 1) ? "True" : "False",
               ((dupccr >> (31-18)) & 1) ? "True" : "False",
               ((dupccr >> (31-21)) & 1) ? "True" : "False",
               ((dupccr >> (31-22)) & 1) ? "True" : "False",
               ((dupccr >> (31-23)) & 1) ? "True" : "False",
               ((dupccr >> (31-20)) & 1) ? "True" : "False");
        return true;
    }

    //
    // Process command line
    //

    opterr = 0;
    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("dz config: unrecognized option \"%s\"\n\n%s", argv[optind-1], usage);
            return true;
        } else {
            switch (index) {
                case 0: // HELP
                    printf(usage);
                    return true;
                case 1: //LOOP
                case 2: //H325
                    if ((tolower(optarg[0]) == 'f') || (optarg[0] == '0')) {
                        dupccr &= ~(1 << (31-20));
                    } else if ((tolower(optarg[0]) == 't') || (optarg[0] == '1')) {
                        dupccr |=  (1 << (31-20));
                    } else {
                        printf("dup config: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    break;
                case 3: // RI
                    if ((tolower(optarg[0]) == 'f') || (optarg[0] == '0')) {
                        dupccr &= ~(1 << (31-4));
                    } else if ((tolower(optarg[0]) == 't') || (optarg[0] == '1')) {
                        dupccr |=  (1 << (31-4));
                    } else {
                        printf("dup config: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    break;
                case 4: // CTS
                    if ((tolower(optarg[0]) == 'f') || (optarg[0] == '0')) {
                        dupccr &= ~(1 << (31-5));
                    } else if ((tolower(optarg[0]) == 't') || (optarg[0] == '1')) {
                        dupccr |=  (1 << (31-5));
                    } else {
                        printf("dup config: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    break;
                case 5: // DSR
                    if ((tolower(optarg[0]) == 'f') || (optarg[0] == '0')) {
                        dupccr &= ~(1 << (31-6));
                    } else if ((tolower(optarg[0]) == 't') || (optarg[0] == '1')) {
                        dupccr |=  (1 << (31-6));
                    } else {
                        printf("dup config: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    break;
                case 6: // DCD
                    if ((tolower(optarg[0]) == 'f') || (optarg[0] == '0')) {
                        dupccr &= ~(1 << (31-7));
                    } else if ((tolower(optarg[0]) == 't') || (optarg[0] == '1')) {
                        dupccr |=  (1 << (31-7));
                    } else {
                        printf("dup config: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    break;
                case 7: // W3
                    if ((tolower(optarg[0]) == 'f') || (optarg[0] == '0')) {
                        dupccr &= ~(1 << (31-21));
                    } else if ((tolower(optarg[0]) == 't') || (optarg[0] == '1')) {
                        dupccr |=  (1 << (31-21));
                    } else {
                        printf("dup config: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    break;
                case 8: // W5
                    if ((tolower(optarg[0]) == 'f') || (optarg[0] == '0')) {
                        dupccr &= ~(1 << (31-22));
                    } else if ((tolower(optarg[0]) == 't') || (optarg[0] == '1')) {
                        dupccr |=  (1 << (31-22));
                    } else {
                        printf("dup config: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    break;
                case 9: // W6
                    if ((tolower(optarg[0]) == 'f') || (optarg[0] == '0')) {
                        dupccr &= ~(1 << (31-23));
                    } else if ((tolower(optarg[0]) == 't') || (optarg[0] == '1')) {
                        dupccr |=  (1 << (31-23));
                    } else {
                        printf("dup config: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    break;
            }
        }
    }
    ks10_t::writeDUPCCR(dupccr);
    return true;
}

//!
//! \brief
//!    Configure DUP11 Synchronous Serial Interface
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the argument.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

bool command_t::cmdDUP(int argc, char *argv[]) {

    const char *usageTop =
        "\n"
        "The \"du[p]command provides an interface to configure and test the DUP11\n"
        "hardware.\n"
        "\n"
        "Usage: dup [--help] [<command [<args>]]\n"
        "\n"
        "The dup command are:\n"
        "  conf[ig]  Configure the DUP11 device\n"
        "  dump      Dump DUP registers\n"
        "  stat[us]  Dump DUO registers\n"
        "\n"
        "See also:\n"
        "  du conf --help\n"
       "\n";

    //
    // No arguments applied.
    //

    if (argc == 1) {
        printf(usageTop);
        return true;
    }

    //
    // Process command line
    //

    if (strncasecmp(argv[1], "--help", 4) == 0) {
        printf(usageTop);
    } else if (strncasecmp(argv[1], "conf", 4) == 0) {
        cmdDUP_CONF(argc, argv);
    } else if (strncasecmp(argv[1], "dump", 4) == 0) {
        dp.dumpRegs();
    } else if (strncasecmp(argv[1], "stat", 4) == 0) {
        dp.dumpRegs();
    } else {
        printf("du: unrecognized command\n");
    }

    return true;
}

//!
//! \brief
//!    Configure DZ11
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the argument.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

static bool cmdDZ_CONF(int argc, char *argv[]) {

    uint32_t dzccr = ks10_t::readDZCCR();

    static const char *usage =
        "\n"
        "The \"dz config\" command configures and displays the configuration the\n"
        "DZ11.\n"
        "\n"
        "Usage: dz config [option]\n"
        "\n"
        "Valid options are:\n"
        "   [--help]                    Print help.\n"
        "   [--line=linenum]            Set line number.\n"
        "   [--co={t[rue]} | {f[alse}]  Set Carrier Sense state for the selected\n"
        "                               line number.\n"
        "   [--dtr={t[rue]} | {f[alse}] Set Data Terminal Ready state for the\n"
        "                               selected line number.\n"
        "   [--ri={t[rue]} | {f[alse}]  Set Ring Indication state for the\n"
        "                               selected line number.\n"
        "\n"
        "Examples:\n"
        "\n"
        "  dz config (with no options)\n"
        "\n"
        "    Prints the DZ configuration.\n"
        "\n"
        "  dz config --line=0 --ri=true --line=2 --co=false\n"
        "\n"
        "    Asserts Ring Indication on line 0 and negates Carrier Sense on\n"
        "    line 2.\n"
        "\n";

    static const struct option options[] = {
        {"help",   no_argument,       0, 0},  // 0
        {"line",   required_argument, 0, 0},  // 1
        {"co",     required_argument, 0, 0},  // 2
        {"ri",     required_argument, 0, 0},  // 3
        {0,        0,                 0, 0},  // 5
    };

    //
    // No argument
    // Print status
    //

    if (argc == 2) {
        printf("        CO = Carrier Sense\n"
               "        RI = Ring Indication\n"
               "        +------+----------+\n"
               "        | LINE | CO   RI  |\n"
               "        +------+----------+\n", dzccr);

        for (int i = 0; i < 8; i++) {
            printf("        |   %1d  |  %c    %c  |\n", i,
                   ((int)(dzccr >> ( 8 + i)) & 1) ? 'X' : ' ',
                   ((int)(dzccr >> ( 0 + i)) & 1) ? 'X' : ' ');
        }
        printf("        +------+----------+\n");
        return true;
    }

    //
    // Process command line
    //

    int line = -1;
    opterr = 0;
    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("dz config: unrecognized option \"%s\"\n\n%s", argv[optind-1], usage);
            return true;
        } else {
            switch (index) {
                case 0: // help
                    printf(usage);
                    return true;
                case 1: //line
                    if (isdigit(optarg[0])) {
                        if ((optarg[0] >= '0') && (optarg[0] <= '7')) {
                            line = optarg[0] - '0';
                        } else {
                            printf("dz config: parameter out of range \'--%s=%s\'\n", options[index].name, optarg);
                        }
                    } else {
                        printf("dz config: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                    }
                    break;
                case 2: // co
                    if (line < 0) {
                        printf("dz config: line not specified before \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    if ((tolower(optarg[0]) == 'f') || (optarg[0] == '0')) {
                        dzccr &= ~(1 << (8 + line));
                    } else if ((tolower(optarg[0]) == 't') || (optarg[0] == '1')) {
                        dzccr |=  (1 << (8 + line));
                    } else {
                        printf("dz config: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    break;
                case 3: // ri
                    if (line < 0) {
                        printf("dz config: line not specified before \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    if ((tolower(optarg[0]) == 'f') || (optarg[0] == '0')) {
                        dzccr &= ~(1 << (0 + line));
                    } else if ((tolower(optarg[0]) == 't') || (optarg[0] == '1')) {
                        dzccr |=  (1 << (0 + line));
                    } else {
                        printf("dz config: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    break;
            }
        }
    }
    ks10_t::writeDZCCR(dzccr);
    return true;
}

//!
//! \brief
//!    Test DZ11
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the argument.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

static bool cmdDZ_TEST(int argc, char *argv[]) {

    static const char *usage =
        "\n"
        "The \"dz test\" command performs various tests on the DZ11.\n"
        "\n"
        "Usage: dz test [option]\n"
        "\n"
        "The mt test commands are:\n"
        "   [--help]         Print help.\n"
        "   [--tx port]      Test  transmitter. This test  will transmit  a message out\n"
        "                    selected  serial  port  at 9600N81. Valid values of port is\n"
        "                    0-7.\n"
        "   [--rx port]      Test  receiver.  This   test  will  print  the  characters\n"
        "                    received  from the selected  serial port at  9600N81 on the\n"
        "                    console. Type ^C on the TTY to exit. Valid values of port\n"
        "                    is 0-7.\n"
        "   [--ec[ho] port]  Loopback transmitter to receiver at 9600N81. This will echo\n"
        "                    characters received on the selected serial port back to the\n"
        "                    associated serial port. Type ^C on the TTY to exit. Valid\n"
        "                    values of port is 0-7.\n"
        "\n";

    static const struct option options[] = {
        {"help",  no_argument,       0, 0},  // 0
        {"ec",    required_argument, 0, 0},  // 1
        {"echo",  required_argument, 0, 0},  // 2
        {"rx",    required_argument, 0, 0},  // 3
        {"tx",    required_argument, 0, 0},  // 4
        {0,       0,                 0, 0},  // 5
    };

    //
    // No argument
    //

    if (argc == 2) {
        printf("dz test: missing test argument\n%s", usage);
        return true;
    }

    //
    // Process command line
    //

    opterr = 0;
    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("dz test: unrecognized option \"%s\"\n\n%s", argv[optind-1], usage);
            return true;
        } else {
            switch (index) {
                case 0:
                    printf(usage);
                    return true;
                case 1:
                case 2:
                    if ((optarg[0] >= '0') && (optarg[0] <= '7')) {
                        dz.testECHO(optarg[0] - '0');
                    } else {
                        printf("dz test echo: port arguments out of range\n");
                    }
                    return true;
                case 3:
                    if ((optarg[0] >= '0') && (optarg[0] <= '7')) {
                        dz.testRX(optarg[0] - '0');
                    } else {
                        printf("dz test rx: port arguments out of range\n");
                    }
                    return true;
                case 4:
                    if ((optarg[0] >= '0') && (optarg[0] <= '7')) {
                        dz.testTX(optarg[0] - '0');
                    } else {
                        printf("dz test tx: port arguments out of range\n");
                    }
                    return true;
            }
        }
    }

    return true;
}

//!
//! \brief
//!    Test DZ11
//!
//!    The <b>DZ</b> (DZ11) tests the DZ11 Terminal Multiplexer
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

bool command_t::cmdDZ(int argc, char *argv[]) {

    const char *usageTop =
        "\n"
        "The \"dz\" command  provides an interface to configure and test the DZ11\n"
        "hardware.\n"
        "\n"
        "Usage: dz [--help] <command> [<args>]\n"
        "\n"
        "The dz command are:\n"
        "  conf[ig]  Configure the DZ11 device\n"
        "  dump      Dump DZ registers\n"
        "  test      Test DZ functionality\n"
        "  stat[us]  Dump DZ registers\n"
        "\n"
        "See also:\n"
        "  dz conf --help\n"
        "  dz test --help\n"
       "\n";

    //
    // No arguments applied.
    //

    if (argc == 1) {
        printf(usageTop);
        return true;
    }

    if (strncasecmp(argv[1], "--help", 4) == 0) {
        printf(usageTop);
        return true;
    } else if (strncasecmp(argv[1], "conf", 4) == 0) {
        return cmdDZ_CONF(argc, argv);
    } else if (strncasecmp(argv[1], "dump", 4) == 0) {
        dz.dumpRegs();
    } else if (strncasecmp(argv[1], "stat", 4) == 0) {
        dz.dumpRegs();
    } else if (strncasecmp(argv[1], "test", 4) == 0) {
        return cmdDZ_TEST(argc, argv);
    } else {
        printf("dz: unrecognized command\n");
    }

    return true;
}

//!
//! \brief
//!    Execute the next instruction
//!
//! \details
//!    The <b>EX</b> (Execute) command causes the KS10 to execute the
//!    instruction in provided by the argument and then return to the
//!    halt state.
//!
//! \sa cmdCO, cmdSI, cmdHA
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

bool command_t::cmdEX(int argc, char *argv[]) {

    const char *usage =
        "\n"
        "The \"ex\" command executes the instruction provided as an argument. It does\n"
        "by storing the instrucion in the Console Instruction Register (CIR) and\n"
        "executing it. The instruction is expected to be a 36-bit octal number.\n"
        "\n"
        "Usage: ex [--help] instruction\n"
        "\n";

    static const struct option options[] = {
        {"help",    no_argument, 0, 0},  // 0
        {0,         0,           0, 0},  // 1
    };

    //
    // No argument
    //

    if (argc == 1) {
        printf("ex: instruction argument required\n%s", usage);
        return true;
    }

    //
    // Process command line
    //

    opterr = 0;
    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("ex: unrecognized option \"%s\"\n\n%s", argv[optind-1], usage);
            return true;
       } else if (index == 0) {
            printf(usage);
            return true;
        }
    }

    ks10_t::data_t data = parseOctal(argv[1]);
    ks10_t::executeInstruction(data);
    if (argc >= 3) {
        printf("ex: additional arguments ignored\n");
    }

    return true;
}

//!
//! \brief
//!    Fix timing for DSDZA diagnostic
//!
//! \details
//!    This is required because the KS10 FPGA is faster than the DEC KS10
//!    and the DSDZA diagnostics will fail without this patch.
//!

void fixDSDZA(void) {

    ks10_t::writeMem(035650, 010000);    // 50
    ks10_t::writeMem(035651, 010000);    // 75
    ks10_t::writeMem(035652, 010000);    // 110
    ks10_t::writeMem(035653, 010000);    // 134`
    ks10_t::writeMem(035654, 010000);    // 150
    ks10_t::writeMem(035655, 010000);    // 300
    ks10_t::writeMem(035656, 010000);    // 600
    ks10_t::writeMem(035657, 010000);    // 1200
    ks10_t::writeMem(035660, 010000);    // 1800
    ks10_t::writeMem(035661, 010000);    // 2000
    ks10_t::writeMem(035662, 010000);    // 2400
    ks10_t::writeMem(035663, 010000);    // 3600
    ks10_t::writeMem(035664, 010000);    // 4800
    ks10_t::writeMem(035665, 010000);    // 7200
    ks10_t::writeMem(035666, 010000);    // 9600
    ks10_t::writeMem(035667, 010000);    // 19.2K
    printf("KS10: Patched DSDZA diagnostic.\n");
}

//!
//! \brief
//!    Patch the DSKAC diagnostic.
//!

void fixDSKAC(void) {

#if 0

    ks10_t::data_t data;
    ks10_t::addr_t addr;

    //
    // Create UPT (400000-777000)
    //

    data = 0540400540401;
    for (addr = 0200; addr <= 0400; addr++) {
        ks10_t::writeMem(addr, data);
        data += 02000002;
    }

    //
    // Create EPT (340000-377000)
    //

    data = 0540340540341;
    for (addr = 0400; addr <= 0420; addr++) {
        ks10_t::writeMem(addr, data);
        data += 02000002;
    }

    //
    // Create EPT (000000-337000)
    //

    data = 0540000540001;
    for (addr = 0600; addr <= 0757; addr++) {
        ks10_t::writeMem(addr, data);
        data += 02000002;
    }

#else

    ks10_t::addr_t addr = 020000;

    ks10_t::writeMem(000600, 0540000540001);                    // Page Table (000000-001777) (for temp addr)
    ks10_t::writeMem(000610, 0540020540021);                    // Page Table (020000-021777)
    ks10_t::writeMem(000614, 0540030540031);                    // Page Table (030000-031777)
    ks10_t::writeMem(000615, 0540032540033);                    // Page Table (032000-033777)

#endif

    ks10_t::writeMem(addr++, (ks10_t::opWREBR << 18) | 020000); // WREBR 20000
    ks10_t::writeMem(addr++, (ks10_t::opJRST  << 18) | 030000); // JRST  30000
    printf("KS10: Patched DSKAC diagnostic.\n");

}

//!
//! \brief
//!    Load a diagnostic monitor and optionally run a program
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

bool command_t::cmdGO(int argc, char *argv[]) {

    const char *usage =
        "\n"
        "The \"go\" command loads and executes either the disk diagnostic monitor or the\n"
        "magtape diagnostic monitor and optionally loads and executes a diagnostic\n"
        "program for that monitor program.\n"
        "\n"
        "Usage: go [--help] [<options>] [diagname.sav addr]\n"
        "\n"
        "Valid options are:\n"
        "\n"
        "--help  Print this usage message\n"
        "--mt    Load the magtape-based \"SMMAG\"  diagnostic monitor instead of the\n"
        "        disk-based  \"SMMON\" diagnostic monitor.\n"
        "\n"
        "With no arguments, this command will load the \"SMMON\" diagnostic\n"
        "monitor into memory and execute it. More specifically, this commmand\n"
        "will load the following executables into memory in the following order:\n"
        "   SUBSM from \"diag/subsm.sav\",\n"
        "   SMDDT from \"diag/smddt.sav\", and\n"
        "   SMMON from \"diag/smmon.sav\".\n"
        "\n"
        "When the \"--mt\" option is provided, this command will load the \"SMMAG\"\n"
        "diagnostic monitor into memory instead of the \"SMMON\" diagnostic montor\n"
        "in the following order:\n"
        "   SUBSM from \"diag/subsm.sav\",\n"
        "   SMDDT from \"diag/smddt.sav\", and\n"
        "   SMMAG from \"diag/smmag.sav\".\n"
        "\n"
        "If both the \"diagname.sav\" and \"addr\" parameters are provided, then\n"
        "after the diagnostic monitor is loaded per above and the diagnostic\n"
        "program is also loaded into memory. Program execution begins as\n"
        "at the address that is specified.\n"
        "\n"
        "Note: Loading diagnostic programs this way does not require a working\n"
        "boot device such as a disk drive or magtape because the console program\n"
        "writes the executable into memory.\n"
        "\n"
        "For example, the following command executes the DSDZA diagnostic using\n"
        "the \"SMMON\" diagnostic monitor\n"
        "\n"
        "go diag/dsdza.sav 30001\n"
        "\n";

    static const struct option options[] = {
        {"help",    no_argument, 0, 0},  // 0
        {"mt",      no_argument, 0, 0},  // 1
        {0,         0,           0, 0},  // 2
    };

    //
    // Process command line
    //

    int index = 0;
    opterr = 0;
    for (;;) {
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("go: unrecognized option: %s\n", argv[optind-1]);
            return true;
        } else {
            switch (index) {
                case 0:
                    printf(usage);
                    return true;
                case 1:
                    break;
            }
        }
    }

    // command            argc    index
    // ------------------ ------- --------
    // go                 1       0
    // go --mt            2       1
    // go diag addr       3       0
    // go --mt diag addr  4       1
    //

#if 1
    printf("argc = %d, index = %d\n", argc, index);
    printf("arv[0] = %s\n", argv[0]);
    printf("arv[1] = %s\n", argv[1]);
    printf("arv[2] = %s\n", argv[2]);
    printf("arv[3] = %s\n", argv[3]);
    printf("arv[4] = %s\n", argv[4]);
    printf("arv[5] = %s\n", argv[5]);
#endif

    //
    // Halt the KS10 if it is running.
    //

    if (ks10_t::run()) {
        printf("go: halting the KS10\n");
        ks10_t::run(false);
    }

    //
    // Load DSQDA diagnostic subroutines (SUBSM)
    //
#if 0
    printf("go: loading SUBSM.\n");
    if (!loadCode("diag/subsm.sav")) {
        printf("go: failed to load diag/subsm.sav\n");
    }

    //
    // Load DSQDB diagnostic debugger (SMDDT)
    //

    printf("go: loading SMDDT.\n");
    if (!loadCode("diag/smddt.sav")) {
        printf("go: failed to load diag/smddt.sav\n");
    }
#endif
    //
    // Load the proper the diagnostic monitor and set boot parameters.
    //

    if (index == 1) {

        mtSetBootParam(0);
        printf("go: loading SMMAG.\n");
        if (!loadCode("diag/smmag.sav")) {
            printf("go: failed to load diag/smmag.sav\n");
            return true;;
        }

    } else {

        rpSetBootParam();

        printf("go: loading SMMON.\n");
        if (!loadCode("diag/smmon.sav")) {
            printf("go: failed to load diag/smmon.sav\n");
            return true;;
        }
    }

    //
    // Determine if we should run a diagnostic program
    //

    if (((argc == 3) && (index == 0)) || ((argc == 4) && (index == 1))) {

        //
        // Read the diagnostic program into memory
        //

        if (!loadCode(argv[index + 1])) {
            printf("go: failed to load %s\n", argv[index + 1]);
            return true;
        }

        //
        // Set the starting address
        //

        ks10_t::data_t start = parseOctal(argv[index+2]);
        ks10_t::writeRegCIR(ks10_t::opJRST << 18 | start);
        printf("go: starting address set to %06llo\n", start);

        //
        // Patch the diagnostic, if necessary
        //

        if (strncasecmp("diag/dsdza.sav", argv[index + 1], 10) == 0) {
            fixDSDZA();
        } else if (strncasecmp("diag/dskac.sav", argv[index + 1], 10) == 0) {
            fixDSKAC();
        }
    } else if (((argc == 1) && (index == 0)) || ((argc == 2) && (index == 1))) {
        ;
    } else {
        printf("go: unrecognized command.\n%s", usage);
        return true;
    }

    //
    // Configure the CPU
    //

    ks10_t::cacheEnable(true);
    ks10_t::trapEnable(true);
    ks10_t::timerEnable(true);

    //
    // Start the KS10 running
    //

    ks10_t::startRUN();

    //
    // Write characters to KS10
    //

    return consoleOutput();

}

//!
//! \brief
//!    Halt the KS10
//!
//! \details
//!    The <b>HA</b> (Halt) command halts the KS10 CPU at the end of the current
//!    instruction. The KS10 will remain in the <b>HALT</b> state until it is
//!    single-stepped or it is commanded to continue.
//!
//!    This command negates the <b>RUN</b> bit in the Console Control Register
//!    and waits for the KS10 to halt.
//!
//! \sa cmdCO, cmdSI
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

bool command_t::cmdHA(int argc, char *argv[]) {

    const char *usage =
        "\n"
        "The \"ha\' command HALTs the KS10\n"
        "\n"
        "Usage: ha\n"
        "\n";

    static const struct option options[] = {
        {"help",    no_argument, 0, 0},  // 0
        {0,         0,           0, 0},  // 1
    };

    //
    // Process command line
    //

    opterr = 0;
    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("ha: unrecognized option: %s\n", argv[optind-1]);
            return true;
        } else if (index == 0) {
            printf(usage);
            return true;
        }
    }

    if (ks10_t::halt()) {
        printf("ha: already halted\n");
        return true;
    }

    ks10_t::run(false);

    for (int i = 0; i < 100; i++) {
        if (ks10_t::halt()) {
            return true;
        }
        usleep(1000);
    }
    printf("ha: failed to halt the KS10\n");
    return true;
}

//!
//! \brief
//!    Print help for each of the commands
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

bool command_t::cmdHE(int, char *[]) {

    const char *usage =
        "\n"

        "Console Commands\n"
        "------- --------\n"
        "\n"
        "  The terminal can be attached to the Console Processor. When this is the case,\n"
        "  the user will be presented the \"KS10> \" prompt and the following console\n"
        "  commands are available:\n"
        "\n"
        "   !: bang - escape to sub-shell or execute sub-program\n"
        "   ?: help - print summary of all commands\n"
        "  br: breakpoint\n"
        "  ce: cache enable\n"
        "  cl: clear screen\n"
        "  co: continue after halt\n"
        "  cp: control/configure the KS10 CPU\n"
        "  da: disassemble memory\n"
        "  dz: dz11 (tty) interface\n"
        "  ex: execute a single KS10 instruction and stop\n"
        "  go: load a program from console and optionally execute it\n"
        "  ha: halt the KS10 processor\n"
        "  he: print summary of all commands\n"
        "  hs: print halt status word\n"
        "  lp: lp20 (line printer) interface\n"
        "  mr: master reset\n"
        "  mt: mt (magtape) interface\n"
        "  qu: quit the console and exit\n"
        "  rd: read memory, IO, and registers\n"
        "  rp: rp (disk) interface\n"
        "  si: single step instruction(s)\n"
        "  sh: shutdown monitor\n"
        "  st: start program execution at address\n"
        "  te: system timer enable\n"
        "  tp: system traps enable\n"
        "  tr: trace buffer control\n"
        "  wr: write to memory and IO\n"
        "  zm: zero memory\n"
        "\n"
        "CTY Interface\n"
        "--- ---------\n"
        "\n"
        "  When the KS10 processor is started, the terminal is automatically detached\n"
        "  from the Console Processor and is automatically attached the KS10 CTY\n"
        "  interface. Similarly, when the KS10 processor is halted, the terminal is\n"
        "  detached from the KS10 CTY and is attached back to the Console Processor.\n"
        "\n"
        "  When the terminal is attached to the KS10 CTY interface, the following\n"
        "  character manipulation is performed by the terminal interface:\n"
        "\n"
        "  ^C is caught and sent to the KS10 monitor program instead of performing the\n"
        "     default \"INTR\" action to the console program.\n"
        "\n"
        "  ^E will detach the terminal from the KS10 CTY interface and attach back to the\n"
        "     Console Processor and provide the \"KS10> \" prompt. It does not halt the\n"
        "     KS10.\n"
        "\n"
        "     You can re-attach the terminal back to the KS10 at any time with the \"CO\"\n"
        "     (continue) command. If the KS10 is still running, the the CO command will\n"
        "     re-attach the terminal back to the KS10 CTY. If the KS10 is halted, the\n"
        "     \"CO\" command will \"continue\" the KS10 and then attach the terminal to\n"
        "     the KS10 CTY.\n"
        "\n"
        "     When you type ^E or when the KS10 halts, the default signal actions for\n"
        "     ^C (QUIT), ^Z (SUSP), and ^\\ (QUIT) characters are restored.\n"
        "\n"
        "     If you want to exit from a running KS10 program program back to the Linux\n"
        "     shell, type \"^E^C\".\n"
        "\n"
        "  ^L will set the printer on-line. This is useful for the interacting with the\n"
        "     DSLPA diagnostic that keeps settting the printer off-line.\n"
        "\n"
        "  ^T prints the current program counter, prints the memory contents at the\n"
        "     current program counter, and disassmbles the current instruction. This\n"
        "     command generally satifies my curiousity about \"What\'s it doing?\".\n"
        "     This capability is a hardware enhancement to the KS10 FPGA whereby the\n"
        "     contents of the Program Counter and Instruction Register are available\n"
        "     to the console and and does not require the KS10 to be operating. The\n"
        "     output looks something like:\n"
        "\n"
        "     057713  712153 000010   712 03 0 13 000010      RDIO    3,10(13)\n"
        "\n"
        "     or\n"
        "\n"
        "     021627  606000 000400   606 00 0 00 000400      TRNN    400\n"
        "\n"
        "  ^Z is caught and sent to the KS10 monitor program instead of performing\n"
        "     the default \"SUSP\" action to the console program.\n"
        "\n"
        "  ^\\ is caught and sent to the KS10 monitor program instead of performing\n"
        "     the default \"QUIT\" action to the console program.\n"
        "\n"
        "  <ESC> The escape key will escape the ^E, ^T, and ^L behavior described above\n"
        "     and send the ^E, ^T, or ^L character to the KS10 CTY.\n"
        "\n"
        "  <ESC><ESC> will send a single escape character to the KS10 CTY. The DEC\n"
        "     monitors will generally echo a \"$\" character in response to an escape\n"
        "     character. Note: I may want to select a different escape character.\n"
        "     This selection makes running DDT and TECO very challenging.\n"
        "\n"
        "Command Line Editor\n"
        "------- ---- ------\n"
        "\n"
        "  The console has a simple command line editor that provides both command\n"
        "  recall and command line editing capabilities. The command line editing\n"
        "  capabilities should be familiar to individuals with experience with the GNU\n"
        "  readline functionality that is used by GNU \"bash\" or with GNU \"emacs\".\n"
        "  The basic functionality is:\n"
        "\n"
        "  ^A  Move the cursor to the beginning of line. This is also attached to the\n"
        "      home key.\n"
        "  ^B  Move the cursor back one character. This is also attached to the left\n"
        "      arrow key.\n"
        "  ^D  Delete the character under the cursor. This is also attached to the\n"
        "      delete key.\n"
        "  ^E  Move the cursor to the end of the line. This is also attached to the end\n"
        "      key\n"
        "  ^F  Move the cursor forward one character. This is also attached to the right\n"
        "      arrow key.\n"
        "  ^G  Ring the bell or Alarm.\n"
        "  ^H  Delete the character under the cursor and move the cursor backward one\n"
        "      character. This is also attached to the backspace key.\n"
        "  ^K  Erase from the cursor to the end of line.\n"
        "  ^L  Redraw the command line.\n"
        "  ^N  Recall next command. This is also attatched to the down arrow key.\n"
        "  ^P  Recall previous command. This is also attached to the up arrow key.\n"
        "  ^T  Transpose the character under the cursor with the character preceeding the\n"
        "      cursor.\n"
        "  ^U  Clear the line.\n"
        "\n"
        "  The command line \"rp boot\" is preloaded to the command line history for\n"
        "  easy access to the boot command. My normal boot command is \"^P<RET>\".\n"
        "\n";

    printf(usage);
    return true;
}

//!
//! \brief
//!    Print the halt status block
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

bool command_t::cmdHS(int argc, char *argv[]) {

    const char *usage =
        "\n"
        "The \"hs\" command prints the contents of the \"Halt Status Block\".\n"
        "\n"
        "usage: hs [--help]\n"
        "\n";

    static const struct option options[] = {
        {"help",    no_argument, 0, 0},  // 0
        {0,         0,           0, 0},  // 2
    };

    //
    // Process command line
    //

    opterr = 0;
    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("hs: unrecognized option: %s\n", argv[optind-1]);
            return true;
        } else if (index == 0) {
            printf(usage);
            return true;
        }
   }

   if (argc == 1) {
       ks10_t::printHaltStatusBlock();
   } else {
       printf(usage);
   }

   return true;
}

//!
//! \brief
//!    Set LPxx breakpoint
//!

static bool cmdLP_BREAK(void) {
#if 0
    static const ks10_t::addr_t flagPhys = 0x008000000ULL;
    static const ks10_t::addr_t flagIO   = 0x002000000ULL;
    ks10_t::writeDBAR(flagPhys | flagIO | 003775400ULL);            // break on IO operations to
    ks10_t::writeDBMR(flagPhys | flagIO | 017777700ULL);            // range of addresses
    ks10_t::writeDCSR(ks10_t::dcsrBRCMD_MATCH | (ks10_t::readDCSR() & ~ks10_t::dcsrBRCMD));
    printf("lp break: breakpoint set\n");
#endif
    return true;
}

//!
//! \brief
//!    Configure LPxx printer
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the argument.
//!

static bool cmdLP_CONFIG(int argc, char *argv[]) {

    static const char *usage =
        "  [--help]                     Print help\n"
        "  [--baud[rate]=speed]         Sets printer baudrate. Valid speeds are:\n"
        "                                     50,     75,    110,  134.5,   150,   300,\n"
        "                                    600,   1200,   1800,   2000,  2400,  3600,\n"
        "                                   4800,   7200,   9600,  19200, 38400, 57600,\n"
        "                                 115200, 230400, 480800, 921600.\n"
        "                               The default baudrate is 115200 baud. Note: The\n"
        "                               baudrates are decimal numbers\n"
        "  [--bits=bitcnt]              Sets the number of bits per character. Valid\n"
        "                               bitcounts are 5, 6, 7, and 8 bits per character.\n"
        "                               The default is 8 bits per character. The printer\n"
        "                               will likely malfunction if the bitcnt is not set\n"
        "                               to 8. Don't change this unless you know what you\n"
        "                               are doing.\n"
        "  [--on[line]]                 Set printer on-line. The default is online.\n"
        "  [--off[line]]                Set printer off-line. The default is online.\n"
        "  [--par[ity]=par]             Set printer parity. Valid par values:\n"
        "                               \"no\"   - Use no parity\n"
        "                               \"even\" - Use even parity\n"
        "                               \"odd\"  - Use odd parity\n"
        "                               \"mark\" - Use mark parity\n"
        "                               The default is no parity\n"
        "  [--stop=nstop                Set printer number of stop bits. Valid number of:\n"
        "                               stop bits are 1 and 2. The default is 2 stop bits.\n"
        "  [--vfu=o[ptical],d[igital]}] Configure for Digital Vertical Format Unit (DVFU)\n"
        "                               or Optical Vertical Format Unit (OVFU). The\n"
        "                               is to use a DVFU\n"
        "\n";

    static const struct option options[] = {
        {"help",     no_argument,       0, 0},  //  0
        {"vfu",      required_argument, 0, 0},  //  1
        {"on",       no_argument,       0, 0},  //  2
        {"online",   no_argument,       0, 0},  //  3
        {"off",      no_argument,       0, 0},  //  4
        {"offline",  no_argument,       0, 0},  //  5
        {"baud",     required_argument, 0, 0},  //  6
        {"baudrate", required_argument, 0, 0},  //  7
        {"bits",     required_argument, 0, 0},  //  8
        {"par",      required_argument, 0, 0},  //  9
        {"parity",   required_argument, 0, 0},  // 10
        {"stop",     required_argument, 0, 0},  // 11
        {0,          0,                 0, 0},  // 12
    };

    uint32_t lpccr = ks10_t::readLPCCR();

    if (argc == 2) {

        uint32_t lpccr = ks10_t::readLPCCR();

        const char *baudrateTable[] = {
            "50",      "75",     "110",   "134.5",
            "150",     "300",     "600",    "1200",
            "1800",    "2000",    "2400",    "3600",
            "4800",    "7200",    "9600",   "19200",
            "38400",   "57600",  "115200",  "230400",
            "480800",  "921600", "Unknown", "Unknown",
            "Unknown", "Unknown"," Unknown", "Unknown",
            "Unknown", "Unknown"," Unknown", "Unknown",
        };

        const char *parityTable[] = {"N", "O", "E", "M"};

        printf("        LPCCR                     : 0x%08x\n"
               "        Vertical Format Unit      : %s\n"
               "        Printer Status            : %s, %d LPI\n"
               "        Printer Serial Config     : \"%s,%s,%1d,%1d,X\"\n",
               lpccr,
               (lpccr & ks10_t::lpOVFU  ) != 0 ? "Optical" : "Digital",
               (lpccr & ks10_t::lpONLINE) != 0 ? "Online"  : "Offline",
               (lpccr & ks10_t::lpSIXLPI) != 0 ? 6 : 8,
               baudrateTable[((lpccr & ks10_t::lpBAUDRATE) >> 21)],
               parityTable[((lpccr & ks10_t::lpPARITY)   >> 17)],
               ((lpccr & ks10_t::lpLENGTH)   >> 19) + 5,
               ((lpccr & ks10_t::lpSTOPBITS) >> 16) + 1);
        return true;
    }

    //
    // Process command line
    //

    opterr = 0;
    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("lp: unrecognized option: %s\n", argv[optind-1]);
            return true;
        } else {
            switch (index) {
                case 0:
                    printf(usage);
                    return true;
                case 1: // vfu
                    if (tolower(optarg[0]) == 'o') {
                        lpccr = lpccr | ks10_t::lpOVFU;
                    } else if (tolower(optarg[0]) == 'd') {
                        lpccr = lpccr & ~ks10_t::lpOVFU;
                    } else {
                        printf("lp config: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                    }
                    break;
                case 2: // on
                case 3: // online
                    lpccr = lpccr | ks10_t::lpONLINE;
                    break;
                case 4: // off
                case 5: // offline
                    lpccr = lpccr & ~ks10_t::lpONLINE;
                    break;
                case 6: // baud
                case 7: // baudrate
                    if (strncasecmp(optarg, "50", 6) == 0) {
                        lpccr = (0x00 << 21) | (lpccr &~ ks10_t::lpBAUDRATE);
                    } else if (strncasecmp(optarg, "75", 6) == 0) {
                        lpccr = (0x01 << 21) | (lpccr &~ ks10_t::lpBAUDRATE);
                    } else if (strncasecmp(optarg, "110", 6) == 0) {
                        lpccr = (0x02 << 21) | (lpccr &~ ks10_t::lpBAUDRATE);
                    } else if (strncasecmp(optarg, "134.5", 6) == 0) {
                        lpccr = (0x03 << 21) | (lpccr &~ ks10_t::lpBAUDRATE);
                    } else if (strncasecmp(optarg, "150", 6) == 0) {
                        lpccr = (0x04 << 21) | (lpccr &~ ks10_t::lpBAUDRATE);
                    } else if (strncasecmp(optarg, "300", 6) == 0) {
                        lpccr = (0x05 << 21) | (lpccr &~ ks10_t::lpBAUDRATE);
                    } else if (strncasecmp(optarg, "600", 6) == 0) {
                        lpccr = (0x06 << 21) | (lpccr &~ ks10_t::lpBAUDRATE);
                    } else if (strncasecmp(optarg, "1200", 6) == 0) {
                        lpccr = (0x07 << 21) | (lpccr &~ ks10_t::lpBAUDRATE);
                    } else if (strncasecmp(optarg, "1800", 6) == 0) {
                        lpccr = (0x08 << 21) | (lpccr &~ ks10_t::lpBAUDRATE);
                    } else if (strncasecmp(optarg, "2000", 6) == 0) {
                        lpccr = (0x09 << 21) | (lpccr &~ ks10_t::lpBAUDRATE);
                    } else if (strncasecmp(optarg, "2400", 6) == 0) {
                        lpccr = (0x0a << 21) | (lpccr &~ ks10_t::lpBAUDRATE);
                    } else if (strncasecmp(optarg, "3600", 6) == 0) {
                        lpccr = (0x0b << 21) | (lpccr &~ ks10_t::lpBAUDRATE);
                    } else if (strncasecmp(optarg, "4800", 6) == 0) {
                        lpccr = (0x0c << 21) | (lpccr &~ ks10_t::lpBAUDRATE);
                    } else if (strncasecmp(optarg, "7200", 6) == 0) {
                        lpccr = (0x0d << 21) | (lpccr &~ ks10_t::lpBAUDRATE);
                    } else if (strncasecmp(optarg, "9600", 6) == 0) {
                        lpccr = (0x0e << 21) | (lpccr &~ ks10_t::lpBAUDRATE);
                    } else if (strncasecmp(optarg, "19200", 6) == 0) {
                        lpccr = (0x0f << 21) | (lpccr &~ ks10_t::lpBAUDRATE);
                    } else if (strncasecmp(optarg, "38400", 6) == 0) {
                        lpccr = (0x10 << 21) | (lpccr &~ ks10_t::lpBAUDRATE);
                    } else if (strncasecmp(optarg, "57600", 6) == 0) {
                        lpccr = (0x11 << 21) | (lpccr &~ ks10_t::lpBAUDRATE);
                    } else if (strncasecmp(optarg, "115200", 6) == 0) {
                        lpccr = (0x12 << 21) | (lpccr &~ ks10_t::lpBAUDRATE);
                    } else if (strncasecmp(optarg, "230400", 6) == 0) {
                        lpccr = (0x13 << 21) | (lpccr &~ ks10_t::lpBAUDRATE);
                    } else if (strncasecmp(optarg, "460800", 6) == 0) {
                        lpccr = (0x14 << 21) | (lpccr &~ ks10_t::lpBAUDRATE);
                    } else if (strncasecmp(optarg, "921600", 6) == 0) {
                        lpccr = (0x15 << 21) | (lpccr &~ ks10_t::lpBAUDRATE);
                    } else {
                        printf("lp config: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                    }
                    break;
                case 8: // bits
                    if (optarg[0] == '5') {
                        lpccr = ks10_t::lpLENGTH_5 | (lpccr &~ ks10_t::lpLENGTH);
                    } else if (optarg[0] == '6') {
                        lpccr = ks10_t::lpLENGTH_6 | (lpccr &~ ks10_t::lpLENGTH);
                    } else if (optarg[0] == '7') {
                        lpccr = ks10_t::lpLENGTH_7 | (lpccr &~ ks10_t::lpLENGTH);
                    } else if (optarg[0] == '8') {
                        lpccr = ks10_t::lpLENGTH_8 | (lpccr &~ ks10_t::lpLENGTH);
                    } else {
                        printf("lp config: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                    }
                    break;
                case 9:  // par
                case 10: // parity
                    if (tolower(optarg[0]) == 'e') {
                        lpccr = ks10_t::lpPARITY_EVEN | (lpccr &~ ks10_t::lpPARITY);
                    } else if (tolower(optarg[0]) == 'o') {
                        lpccr = ks10_t::lpPARITY_ODD | (lpccr &~ ks10_t::lpPARITY);
                    } else if (tolower(optarg[0]) == 'n') {
                        lpccr = ks10_t::lpPARITY_NONE | (lpccr &~ ks10_t::lpPARITY);
                    } else if (tolower(optarg[0]) == 'm') {
                        lpccr = ks10_t::lpPARITY_MARK | (lpccr &~ ks10_t::lpPARITY);
                    } else {
                        printf("lp config: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                    }
                    break;
                case 11: // stop
                    if (optarg[0] == '1') {
                        lpccr = lpccr & ~ks10_t::lpSTOPBITS;
                    } else if (optarg[0] == '2') {
                        lpccr = lpccr | ks10_t::lpSTOPBITS;
                    } else {
                        printf("lp config: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                    }
                    break;
            }
        }
    }

    ks10_t::writeLPCCR(lpccr);
    return true;
}

//!
//! \brief
//!    Interface to LPxx printer
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the argument.
//!

bool command_t::cmdLP(int argc, char *argv[]) {

    const char *usageTop =
        "\n"
        "The \"lp\" command provides an interface to configure and test the LP20\n"
        "hardware.\n"
        "\n"
        "Usage: lp [--help] <command> [<args>]\n"
        "\n"
        "The lp commands are:\n"
        "  break          Breakpoint on LP IO accesses\n"
        "  config <args>  Configure the LP\n"
        "  dump           Dump the LP registers\n"
        "  print  <args>  Print a file to LP\n"
        "  test           Print test message to LP\n"
        "\n";

    if (argc < 2) {
        printf("lp : missing argument\n");
        printf(usageTop);
        return true;
    }

    if (strncasecmp(argv[1], "--help", 3) == 0) {
        printf(usageTop);
    } else if (strncasecmp(argv[1], "break", 4) == 0) {
        cmdLP_BREAK();
    } else if (strncasecmp(argv[1], "stat", 4) == 0) {
        lp.dumpRegs();
    } else if (strncasecmp(argv[1], "conf", 4) == 0) {
        cmdLP_CONFIG(argc, argv);
    } else if (strncasecmp(argv[1], "dump", 4) == 0) {
        lp.dumpRegs();
    } else if (strncasecmp(argv[1], "print", 4) == 0) {
        if (argc < 3) {
            printf("lp print: missing argument\n");
        } if (argc >= 3) {
            lp.printFile(argv[2]);
        }
    } else if (strncasecmp(argv[1], "test", 3) == 0) {
        lp.testRegs();
    } else {
        printf("lp: unrecognized argument\n");
    }

    return true;
}

//!
//! \brief
//!    Master Reset
//!
//! \details
//!    The <b>MR</b> (Master Reset) command hard resets the KS10 CPU.
//!
//!    When the KS10 is started from <b>RESET</b>, the KS10 will peform a
//!    selftest and initialize the ALU. When the microcode initialization is
//!    completed, the KS10 will enter the <b>HALT</b> state.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

bool command_t::cmdMR(int argc, char *argv[]) {

    const char *usage =
        "\n"
        "The \"mr\" command resets KS10 and all of the peripherals.\n"
        "\n"
        "Usage: mr <options>\n"
        "\n"
        "mr will with no options will momentarily reset the KS10 and\n"
        "then allow the KS10 to begin execution from cold start.\n"
        "\n"
        "The mr options are:\n"
        "\n"
        "--on       Continuously reset the KS10.\n"
        "--off      Unreset the KS10.\n"
        "--stat[us] Dislay reset status.\n"
        "\n";

    static const struct option options[] = {
        {"help",   no_argument, 0, 0},  // 0
        {"on",     no_argument, 0, 0},  // 1
        {"of",     no_argument, 0, 0},  // 2
        {"off",    no_argument, 0, 0},  // 3
        {"st",     no_argument, 0, 0},  // 4
        {"stat",   no_argument, 0, 0},  // 5
        {"status", no_argument, 0, 0},  // 6
        {0,        0,           0, 0},  // 7
    };

    //
    // No arguments
    //

    if (argc == 1) {
        ks10_t::cpuReset(true);
        usleep(100);
        ks10_t::cpuReset(false);
        while (!ks10_t::halt()) {
            ;
        }
        return false;
    }

    //
    // Process command line
    //

    opterr = 0;
    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("mr: unrecognized option: %s\n", argv[optind-1]);
            return true;
        } else {
            switch (index) {
                case 0:
                    printf(usage);
                    return true;
                case 1:
                    ks10_t::cpuReset(true);
                    printf("mr: The KS10 is reset.\n");
                    return false;
                case 2:
                case 3:
                    ks10_t::cpuReset(false);
                    printf("mr: The KS10 is unreset.\n");
                    return false;
                case 4:
                case 5:
                case 6:
                    printf("mr: The KS10 is %s.\n", ks10_t::cpuReset() ? "reset" : "not reset");
                    return true;
            }
        }
    }
    return true;
}

//!
//! \brief
//!    Read and parse TCU argument for MT utilities
//!

#define PARSE_TCU(PROG) \
({ \
    do { \
        if (isdigit(optarg[0])) { \
            tcu = strtoul(optarg, NULL, 0); \
            if (tcu > 7) { \
                printf("mt %s : parameter out of range \'--%s=%s\'\n", (PROG), options[index].name, optarg); \
                return true; \
            } \
            if (tcu != 0) { \
                printf("mt %s: Only tcu 0 is supported - you\'ve been warned. \'--%s=%s\'\n", (PROG), options[index].name, optarg); \
            } \
        } else { \
            printf("mt %s: unrecognized option \'--%s=%s\'\n", (PROG), options[index].name, optarg); \
            return true; \
        } \
    } while (0); \
})

//!
//! \brief
//!    Read and parse UNIT argument for MT utilities
//!

#define PARSE_UNIT(PROG, WARNZERO)                       \
({ \
    do { \
        if (isdigit(optarg[0])) { \
            unit = strtoul(optarg, NULL, 0); \
            if (unit > 7) { \
                printf("mt %s : parameter out of range \'--%s=%s\'\n", (PROG), options[index].name, optarg); \
                return true; \
            } \
            if ((unit != 0) && (WARNZERO)) {                           \
                printf("mt %s: Only unit 0 is full supported - you\'ve been warned. \'--%s=%s\'\n", (PROG), options[index].name, optarg); \
            } \
        } else { \
            printf("mt %s: unrecognized option \'--%s=%s\'\n", (PROG), options[index].name, optarg); \
            return true; \
        } \
    } while (0);                                \
})

//!
//! \brief
//!    Magtape boot interface
//!
//! \details
//!    The <b>MT BOOT</b> command is the console interface to the MT device.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

static bool cmdMT_BOOT(int argc, char *argv[]) {

    static const char *usage =
        "\n"
        "The \"mt boot\" command boots the KS10 from the Magtape media.\n"
        "\n"
        "Usage: mt boot [--help] <options> <mon[itor] | diag[nostic]>\n"
        "\n"
        "Valid options are:\n"
        "\n"
        "   [--help]            Print help.\n"
        "   [--base=addr]       Set the base address of the RH11. The default value of\n"
        "                       0772440 is the only correct base address for the MagTape.\n"
        "                       Don\'t change this unless you know what you are doing.\n"
        "                       The default base address is 0772440.\n"
        "   [--diag[nostic]]    Boot to the diagnostic monitor program instead of normal\n"
        "                       monitor.\n"
        "   [--slave=slave]     Set the Magtape Slave Device. Each TCU can support 8\n"
        "   [--tcu=tcunum]      Select the Magtape Tape Control Unit (TCU). Presumably the\n"
        "                       KS10 could support 8 TCUs (aka formatters; aka TM03s) and\n"
        "                       each TCU could support 8 Tape Drives. For now only TCU 0\n"
        "                       is implemented. Any non-zero argument will be rejected and\n"
        "                       generate an error message. The default TCU is 0.\n"
        "   [--uba=ubanum]      Set the Unibus Adapter (UBA) for the RH11. The default\n"
        "                       value of 3 is the only correct UBA for the MagTape.\n"
        "                       Don\'t change this unless you know what you are doing.\n"
        "                       The default UBA is 3.\n"
        "   [--unit=unitnum]    Select the Magtape Unit (Slave Device). Each TCU can\n"
        "                       support 8 Tape Drives. For now only Unit 0 is implemented.\n"
        "                       Any non-zero argument will generate an error message.\n"
        "                       The default Unit is 0.\n"
       "\n";

    static const struct option options[] = {
        {"help",        no_argument,       0, 0},  // 0
        {"base",        required_argument, 0, 0},  // 1
        {"slave",       required_argument, 0, 0},  // 2
        {"unit",        required_argument, 0, 0},  // 3
        {"tcu",         required_argument, 0, 0},  // 4
        {"uba",         required_argument, 0, 0},  // 5
        {"diag",        no_argument,       0, 0},  // 6
        {"diagnostic",  no_argument,       0, 0},  // 7
        {0,             0,                 0, 0},  // 8
    };

    if (argc < 2) {
        printf("mt boot: missing argument\n");
        return true;
    }

    uint32_t tcu  = 0;
    uint32_t unit = 0;
    opterr = 0;

    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("mt boot: unrecognized option: %s\n", argv[optind-1]);
            return true;
        } else {
            switch (index) {
                case 0:
                    // help switch
                    printf(usage);
                    return true;
                case 1:
                    // base switch
                    mt_cfg.baseaddr = (mt_cfg.baseaddr & 07000000) | (parseOctal(optarg) & 0777777);
                    break;
                case 2:
                case 3:
                    // unit switch
                    PARSE_UNIT("boot", true);
                    break;
                case 4:
                    // tcu switch
                    PARSE_TCU("boot");
                    break;
                case 5:
                    // uba switch
                    if ((optarg[0] == '1') || (optarg[0] == '3') || (optarg[0] == '4')) {
                        mt_cfg.baseaddr = (mt_cfg.baseaddr & 0777777) | ((optarg[0] - '0') << 18);
                    } else {
                        printf("mt boot: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                        return 0;
                    }
                    break;
                case 6:
                case 7:
                    mt_cfg.bootdiag = true;
                    break;
            }
        }
    }

    //
    // Configure the CPU
    //

    ks10_t::cacheEnable(true);
    ks10_t::trapEnable(true);
    ks10_t::timerEnable(true);

    //
    // Halt the KS10 if it is already running.
    //

    if (ks10_t::run()) {
        printf("KS10: Already running. Halting the KS10.\n");
        ks10_t::run(false);
    }

    //
    // Boot from disk using the selected boot image
    //

    mtSetBootParam(unit);
    mt.boot(tcu, mt_cfg.drive[unit].param, mt_cfg.bootdiag);

    return true;
}

//!
//! \brief
//!    Magtape Mount Interface
//!
//! \details
//!    The <b>MT MOUNT</b> command simulates all of the user's interactions with
//!    with the Tape Drive. This includes:
//!    #. Setting the Tape Drive Present or Not Present.
//!    #. Attaching a Tape File
//!    #. Setting the tape density
//!    #. Setting the tape format
//!    #. Setting the tape length
//!    #. Setting the tape write protection (Write Enabled or Write Locked)
//!    #. Setting the Tape Drive on-line or off-line
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

static bool cmdMT_MOUNT(int argc, char *argv[]) {

    uint32_t mtccr = ks10_t::readMTCCR();

    static const char *usage =
        "\n"
        "The \"mt mount\" command allows the Magtape configuration to be set. On a real\n"
        "system, these controls would be located on the Magtape drive. This includes\n"
        "selecting one of the many tape drives and then:\n"
        "  1. Setting the Tape Drive Present or Not Present\n"
        "  2. Attaching a Tape File\n"
        "  3. Setting the tape density\n"
        "  4. Setting the tape format\n"
        "  5. Setting the tape length\n"
        "  6. Setting the tape protection (Write Enabled or Write Locked)\n"
        "  7. Setting the Tape Drive on-line or off-line\n"
        "\n"
        "The KS10 system could support 8 Tape Formatters or Tape Control Units (TCUs)\n"
        "and each TCU could support 8 Tape Drives (Units). In the KS10 FPGA, not all\n"
        " TCU and slaves are implemented. See below.\n"
        "\n"
        "The Tape Drive can be unmounted by issuing the \"mt unload\" command.\n"
        "\n"
        "Usage: mt mount [--help] [options]\n"
        "\n"
        "Valid options are:\n"
        "\n"
        "   [--help]            Print help.\n"
        "   [--attach=filename] Attach the Tape File to the selected device. The file\n"
        "                       must have read permissions and must have write\n"
        "                       permissions if the device is not Write Locked. See below.\n"
        "                       This command will not create a new file. If you want to\n"
        "                       mount an empty Tape File, create a zero length file and\n"
        "                       attach it.\n"
        "   [--density=density] Set the Magtape density. Valid density arguments are:\n"
        "                       \"800\"  which is 800 BPI NRZ mode, or\n"
        "                       \"1600\" which  is 1600 BPI Phase Encoded mode.\n"
        "                       The default density is \"1600\".\n"
        "   [--format=format]   Set the Magtape format. Valid format arguments are:\n"
        "                       \"CORE\" which is PDP-10 Core Dump format, or\n"
        "                       \"NORM\" which is PDP-10 Normal Mode format.\n"
        "                       The default format is \"CORE\".\n"
        "   [--length=length]   Tape length in feet. The default tape length is 2400\n"
        "                       feet. This is just used to calcululate how long a rewind\n"
        "                       should take but is otherwise irrelevant. Valid tape\n"
        "                       lengths are 300 feet to 3600 feet.\n"
        "   [--online={t|f}]    Set the Media Online(MOL) status for the selected Tape\n"
        "                       Drive (slave). The default is offline.\n"
        "                       This setting is reflected in the Media On-line bit in\n"
        "                       the Magtape Drive Status Register (MTDS[MOL]) for the\n"
        "                       selected Tape Drive.\n"
        "   [--present={t|f}]   Set the \'Drive Present\' status for the selected Tape\n"
        "                       Drive (slave). The default is not present.\n"
        "                       This setting is reflected in the Drive Present bit in the\n"
        "                       Magtape Drive Status Register (MTDS[DPR]) for the\n"
        "                       selected Tape Drive.\n"
        "                       The default Unit is 0.\n"
        "   [--tcu=tcunum]      Select the Magtape Tape Control Unit (TCU). Presumably the\n"
        "                       KS10 could support 8 TCUs (aka formatters; aka TM03s) and\n"
        "                       each TCU could support 8 Tape Drives. For now only TCU 0\n"
        "                       is implemented. Any non-zero argument will be rejected and\n"
        "   [--unit=unitnum]    Select the Magtape Unit (Slave Device). Each TCU can\n"
        "                       support 8 Tape Drives. For now only Unit 0 is implemented.\n"
        "                       Any non-zero argument will generate an error message.\n"
        "                       generate an error message. The default Unit is 0.\n"
        "   [--wlock={t|f}]     Set Write Lock (WRL) status for the selected Tape Drive\n"
        "                       (slave). This simulates the \"write ring\" function\n"
        "                       that was provided by the tape media. The default is\n"
        "                       Write Locked.\n"
        "                       This setting is reflected in the Write Lock bit in the\n"
        "                       Magtape Drive Status Register (MTDS[WRL])for the\n"
        "                       selected Tape Drive.\n"
        "   [--print]           Print the configuration for all drives and exit.\n"
        "\n"
        "Example:\n"
        "\n"
        "mt mount --slave=0 --file=red405a2.tap --present=t --online=t --wprot=t --slave=2 --present=f\n"
        "\n"
        "Set Tape Drive 0 to indicate that the Tape Drive is present, on-line, and write\n"
        "protected; then set Tape Drive 2 to indicate not present.\n"
        "\n";

    static const struct option options[] = {
        {"help",    no_argument,       0, 0},  //  0
        {"slv",     required_argument, 0, 0},  //  1
        {"unit",    required_argument, 0, 0},  //  2
        {"slave",   required_argument, 0, 0},  //  3
        {"dpr",     required_argument, 0, 0},  //  4
        {"present", required_argument, 0, 0},  //  5
        {"mol",     required_argument, 0, 0},  //  6
        {"online",  required_argument, 0, 0},  //  7
        {"wrl",     required_argument, 0, 0},  //  8
        {"wprot",   required_argument, 0, 0},  //  9
        {"wlock",   required_argument, 0, 0},  // 10
        {"tcu",     required_argument, 0, 0},  // 11
        {"file",    required_argument, 0, 0},  // 12
        {"attach",  required_argument, 0, 0},  // 13
        {"len",     required_argument, 0, 0},  // 14
        {"length",  required_argument, 0, 0},  // 15
        {"den",     required_argument, 0, 0},  // 16
        {"density", required_argument, 0, 0},  // 17
        {"fmt",     required_argument, 0, 0},  // 18
        {"format",  required_argument, 0, 0},  // 19
        {0,         0,                 0, 0},  // 20
    };

    //
    // Print configuration
    //

    if (argc == 2) {
        printf("KS10: Mag Tape mount status is:\n"
               "\n"
               "        +------+-------+-------+-------+-------+-----------+----------------+------+-------------------------------+\n"
               "        | Unit | Drive | Online| Write |Mounted|  Format   |    Density     |Length|           Filename            |\n"
               "        |      |Present|       | Lock  |       |           |                |(feet)|                               |\n"
               "        +------+-------+-------+-------+-------+-----------+----------------+------+-------------------------------+\n");

        for (int i = 0; i < 8; i++) {
            printf("        |   %d  |   %c   |   %c   |   %c   |   %c   |%-11s|%-16s| %4d |%-31s|\n",
                   i,
                   mt_t::present(mtccr, i)   ? 'X' : ' ',
                   mt_t::online(mtccr, i)    ? 'X' : ' ',
                   mt_t::writeLock(mtccr, i) ? 'X' : ' ',
                   mt_cfg.drive[i].attached  ? 'X' : ' ',
                   mt_t::density(mt_cfg.drive[i].param),
                   mt_t::format(mt_cfg.drive[i].param),
                   mt_cfg.drive[i].length,
                   mt_cfg.drive[i].filename);
        }
        printf("        +------+-------+-------+-------+-------+-----------+----------------+-------+-------------------------------+\n"
               "\n");
        return true;
    }

    //
    // Process command line
    //

    uint32_t tcu = 0;
    uint32_t unit = 0;
    bool unitFound = false;
    opterr = 0;

    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("mt mount: unrecognized option: \"%s\"\n\n%s", argv[optind-1], usage);
            return true;
        } else {
            switch (index) {
                case 0:
                    // mount help switch
                    printf(usage);
                    return true;
                case 1:
                case 2:
                case 3:
                    // mount unit switch
                    PARSE_UNIT("mount", false);
                    unitFound = true;
                    break;
                case 4:
                case 5:
                    // mount dpr switch
                    if (!unitFound) {
                        printf("mt mount: unit not specified before \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    if ((optarg[0] == 'f') || (optarg[0] == 'F') || (optarg[0] == '0')) {
                        mtccr = mt_t::present(mtccr, unit, false);
                    } else if ((optarg[0] == 't') || (optarg[0] == 'T') || (optarg[0] == '1')) {
                        mtccr = mt_t::present(mtccr, unit, true);
                        mtccr = mt_t::online(mtccr, unit, false);
                        mtccr = mt_t::writeLock(mtccr, unit, true);
                    } else {
                        printf("mt mount: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    break;
                case 6:
                case 7:
                    // mount mol switch
                    if (!unitFound) {
                        printf("mt mount: unit not specified before \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    if (!mt_t::present(mtccr, unit)) {
                        printf("mt mount: drive %d must be present before setting it online: \'--%s=%s\'\n", unit, options[index].name, optarg);
                        return true;
                    }
                    if ((optarg[0] == 'f') || (optarg[0] == 'F')|| (optarg[0] == '0')) {
                        mtccr = mt_t::online(mtccr, unit, false);
                    } else if ((optarg[0] == 't') || (optarg[0] == 'T') || (optarg[0] == '1')) {
                        mtccr = mt_t::online(mtccr, unit, true);
                    } else {
                        printf("mt mount: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    break;
                case 8:
                case 9:
                case 10:
                    // mount wrl switch
                    if (!unitFound) {
                        printf("mt mount: unit not specified before \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    if (!mt_t::present(mtccr, unit)) {
                        printf("mt mount: drive %d must be present before write lock: \'--%s=%s\'\n", unit, options[index].name, optarg);
                        return true;
                    }
                    if ((optarg[0] == 'f')  || (optarg[0] == 'F') || (optarg[0] == '0')) {
                        mtccr = mt_t::writeLock(mtccr, unit, false);
                    } else if ((optarg[0] == 't') || (optarg[0] == 'T') || (optarg[0] == '1')) {
                        mtccr = mt_t::writeLock(mtccr, unit, true);
                    } else {
                        printf("mt mount: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    break;
                case 11:
                    // tcu switch
                    PARSE_TCU("mount");
                    break;
                case 12:
                case 13:
                    // mount attach switch
                    if (!unitFound) {
                        printf("mt mount: unit not specified before \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }

                    if (mt_cfg.drive[unit].fp != NULL) {
                        printf("mt mount: unit is already attached before \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }

                    // Check write lock. Open file appropriately.

                    mt_cfg.drive[unit].fp = fopen(optarg, mt_t::writeLock(mtccr, unit) ? "r" : "r+");
                    if (!mt_cfg.drive[unit].fp) {
                        printf("mt mount: Error opening file: %s. %s.\n", optarg, strerror(errno));
                        return true;
                    }

                    struct stat sb;
                    if (fstat(fileno(mt_cfg.drive[unit].fp), &sb) == -1) {
                        printf("mt mount: fstat(%s) failed: %s.\n", optarg, strerror(errno));
                        return true;
                    }

                    printf("KS10: Attached file \"%s\" to slave %d. (%ld bytes)\n", optarg, unit, sb.st_size);

                    mt_cfg.drive[unit].attached = true;
                    strncpy(mt_cfg.drive[unit].filename, optarg, sizeof(mt_cfg.drive[unit].filename));
                    mt_cfg.drive[unit].filename[31] = 0;
                    mt_cfg.drive[unit].tape = new tape_t(unit, mt_cfg.drive[unit].fp, mt_cfg.drive[unit].length, mt_cfg.drive[unit].attached, sb.st_size, mt_cfg.debugMask);
                    break;
                case 14:
                case 15:
                    // mount length switch
                    if (!unitFound) {
                        printf("mt mount: unit not specified before \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    mt_cfg.drive[unit].length = strtoul(optarg, NULL, 0);
                    if ((mt_cfg.drive[unit].length < 300) || (mt_cfg.drive[unit].length > 3600)) {
                        printf("mt mount: invalid tape length provided \'--%s=%s\'\n", options[index].name, optarg);
                        mt_cfg.drive[unit].length = 2400;
                        return true;
                    }
                    break;
                case 16:
                case 17:
                    // mt density switch
                    if (strncasecmp(optarg, "800", 3) == 0) {
                        mt_cfg.drive[unit].param = mt_t::density(mt_cfg.drive[unit].param, 3);
                    } else if (strncasecmp(optarg, "1600", 4) == 0) {
                        mt_cfg.drive[unit].param = mt_t::density(mt_cfg.drive[unit].param, 4);
                    } else {
                        if (isdigit(optarg[0])) {
                            unsigned int temp = strtoul(optarg, NULL, 0);
                            if (temp <= 15) {
                                mt_cfg.drive[unit].param = mt_t::density(mt_cfg.drive[unit].param, temp);
                            } else {
                                printf("mt boot: parameter out of range \'--%s=%s\'\n", options[index].name, optarg);
                                return true;
                            }
                        } else {
                            printf("mt boot: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                            return true;
                        }
                    }
                    break;
                case 18:
                case 19:
                    // format switch
                    if (strncasecmp(optarg, "CORE", 5) == 0) {
                        mt_cfg.drive[unit].param = mt_t::format(mt_cfg.drive[unit].param, 0);
                    } else if  (strncasecmp(optarg, "NORM", 5) == 0) {
                        mt_cfg.drive[unit].param = mt_t::format(mt_cfg.drive[unit].param, 3);
                    } else {
                        if (isdigit(optarg[0])) {
                            unsigned int temp = strtoul(optarg, NULL, 0);
                            if (temp <= 7) {
                                mt_cfg.drive[unit].param = mt_t::format(mt_cfg.drive[unit].param, temp);
                            } else {
                                printf("mt boot: parameter out of range \'--%s=%s\'\n", options[index].name, optarg);
                                return true;
                            }
                        } else {
                            printf("mt boot: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                            return true;
                        }
                    }
                    break;
            }
        }
    }

    ks10_t::writeMTCCR(mtccr);
    return true;
}

//!
//! \brief
//!    Magtape debug
//!
//! \details
//!    The <b>MT DEBUG</b> command configures MT tape file thread to
//!    print debugging messages.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

bool cmdMT_DEBUG(int argc, char *argv[]) {

    static const char *usage =
        "\n"
        "The \"mt debug\" command prints the contents of the magtape device registers.\n"
        "\n"
        "Usage: mt debug [options]\n"
        "\n"
        "Valid options are:\n"
        "\n"
        "   [--help]           Print help.\n"
        "   [--mask=debugmask] Select debug mask.\n"
        "\n"
        "The debug mask numbers are (see tape.hpp):\n"
        "\n"
        "   0x00000000 - NONE\n"
        "   0x00000001 - TOP\n"
        "   0x00000002 - HEADER\n"
        "   0x00000004 - UNLOAD\n"
        "   0x00000008 - REWIND\n"
        "   0x00000010 - PRESET\n"
        "   0x00000020 - ERASE\n"
        "   0x00000040 - WRTM\n"
        "   0x00000080 - RDFWD\n"
        "   0x00000100 - RDREV\n"
        "   0x00000200 - WRCHKFWD\n"
        "   0x00000400 - WRCHKREV\n"
        "   0x00000800 - WRFWD\n"
        "   0x00001000 - SPCFWD\n"
        "   0x00002000 - SPCREV\n"
        "   0x00004000 - BOTEOT\n"
        "   0x00008000 - DELAY\n"
        "   0x00010000 - VALIDATE\n"
        "   0x00020000 - DATA\n"
        "   0x00040000 - POS\n"
        "\n";

    static const struct option options[] = {
        {"help",    no_argument,       0, 0},  // 0
        {"mask",    required_argument, 0, 0},  // 1
        {0,         0,                 0, 0},  // 2
    };

    //
    // Process command line
    //

    opterr = 0;

    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("mt debug: unrecognized option \"%s\"\n\n%s", argv[optind-1], usage);
            return true;
        } else {
            switch (index) {
                case 0:
                    // help switch
                    printf(usage);
                    return true;
                case 1:
                    // mask switch
                    if (isdigit(optarg[0])) {
                        mt_cfg.debugMask = strtoul(optarg, NULL, 0);
                    } else {
                        printf("mt debug: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    break;
            }
        }
    }

    if (argc == 2) {
        printf("mt debug: debugMask is 0x%08x\n", mt_cfg.debugMask);
    }

    return true;
}

//!
//! \brief
//!    Magtape dump
//!
//! \details
//!    The <b>MT DUMP</b> command is the console interface to dump the
//!    MT device registers.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

bool cmdMT_DUMP(int argc, char *argv[]) {

    static const char *usage =
        "\n"
        "The \"mt dump\" command prints the contents of the magtape device registers.\n"
        "\n"
        "The KS10 system could support 8 Tape Formatters or Tape Control Units (TCUs)\n"
        "and each TCU could support 8 Tape Drives (Units). In the KS10 FPGA, not all\n"
        " TCU and slaves are implemented. See below.\n"
        "\n"
        "Usage: mt dump [options]\n"
        "\n"
        "Valid options are:\n"
        "\n"
        "   [--help]         Print help.\n"
        "   [--tcu=tcunum]   Select the Magtape Tape Control Unit (TCU). Presumably the\n"
        "                    KS10 could support 8 TCUs (aka formatters; aka TM03s) and\n"
        "                    each TCU could support 8 Tape Drives. For now only TCU 0\n"
        "                    is implemented. Any non-zero argument will be rejected and\n"
        "                    generate an error message. The default TCU is 0.\n"
        "   [--unit=unitnum] Select the Magtape Unit (Slave Device). Each TCU can\n"
        "                    support 8 Tape Drives. For now only Unit 0 is implemented.\n"
        "                    Any non-zero argument will generate an error message.\n"
        "                    The default Unit is 0.\n"
        "\n";

    static const struct option options[] = {
        {"help",    no_argument,       0, 0},  // 0
        {"tcu",     required_argument, 0, 0},  // 1
        {"slave",   required_argument, 0, 0},  // 2
        {"unit",    required_argument, 0, 0},  // 3
        {0,         0,                 0, 0},  // 4
    };

    //
    // Process command line
    //

    uint32_t tcu =  0;
    uint32_t unit = 0;
    opterr = 0;

    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("mt dump: unrecognized option \"%s\"\n\n%s", argv[optind-1], usage);
            return true;
        } else {
            switch (index) {
                case 0:
                    // help switch
                    printf(usage);
                    return true;
                case 1:
                    // tcu switch
                    PARSE_TCU("dump");
                    break;
                case 2:
                case 3:
                    // unit switch
                    PARSE_UNIT("dump", false);
                    break;
            }
        }
    }

    mt.dumpRegs(tcu, mt_cfg.drive[unit].param);
    return true;
}

//!
//! \brief
//!    Magtape erase
//!
//! \details
//!    The <b>MT ERASE</b> command writes an erase gap on the magtape media.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

bool cmdMT_ERASE(int argc, char *argv[]) {

    static const char *usage =
        "\n"
         "The \"mt erase\" command writes an erase gap on the magtape media.\n"
        "\n"
        "The KS10 system could support 8 Tape Formatters or Tape Control Units (TCUs)\n"
        "and each TCU could support 8 Tape Drives (Units). In the KS10 FPGA, not all\n"
        " TCU and slaves are implemented. See below.\n"
        "\n"
        "Usage: mt erase [options]\n"
        "\n"
        "Valid options are:\n"
        "\n"
        "   [--help]         Print help.\n"
        "   [--tcu=tcunum]   Select the Magtape Tape Control Unit (TCU). Presumably the\n"
        "                    KS10 could support 8 TCUs (aka formatters; aka TM03s) and\n"
        "                    each TCU could support 8 Tape Drives. For now only TCU 0\n"
        "                    is implemented. Any non-zero argument will be rejected and\n"
        "                    generate an error message. The default TCU is 0.\n"
        "   [--unit=unitnum] Select the Magtape Unit (Slave Device). Each TCU can\n"
        "                    support 8 Tape Drives. For now only Unit 0 is implemented.\n"
        "                    Any non-zero argument will generate an error message.\n"
        "                    The default Unit is 0.\n"
        "\n";

    static const struct option options[] = {
        {"help",    no_argument,       0, 0},  // 0
        {"tcu",     required_argument, 0, 0},  // 1
        {"slave",   required_argument, 0, 0},  // 2
        {"unit",    required_argument, 0, 0},  // 3
        {0,         0,                 0, 0},  // 4
    };

    //
    // Process command line
    //

    uint32_t tcu = 0;
    uint32_t unit = 0;
    opterr = 0;

    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("mt erase: unrecognized option \"%s\"\n\n%s", argv[optind-1], usage);
            return true;
        } else {
            switch (index) {
                case 0:
                    // help switch
                    printf(usage);
                    return true;
                case 1:
                    // tcu switch
                    PARSE_TCU("erase");
                    break;
                case 2:
                case 3:
                    // unit switch
                    PARSE_UNIT("erase", false);
                    break;
            }
        }
    }

    mt.cmdErase(tcu, mt_cfg.drive[unit].param);
    return true;
}

//!
//! \brief
//!    Magtape preset
//!
//! \details
//!    The <b>MT PRESET</b> command presets the magtape media.
//!    MT device registers.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

bool cmdMT_PRESET(int argc, char *argv[]) {

   static const char *usage =
       "\n"
        "The \"mt preset\" command presets the magtape media.\n"
        "\n"
        "The KS10 system could support 8 Tape Formatters or Tape Control Units (TCUs)\n"
        "and each TCU could support 8 Tape Drives (Units). In the KS10 FPGA, not all\n"
        " TCU and slaves are implemented. See below.\n"
        "\n"
        "Usage: mt preset [options]\n"
        "\n"
        "Valid options are:\n"
        "\n"
        "   [--help]         Print help.\n"
        "   [--tcu=tcunum]   Select the Magtape Tape Control Unit (TCU). Presumably the\n"
        "                    KS10 could support 8 TCUs (aka formatters; aka TM03s) and\n"
        "                    each TCU could support 8 Tape Drives. For now only TCU 0\n"
        "                    is implemented. Any non-zero argument will be rejected and\n"
        "                    generate an error message. The default TCU is 0.\n"
        "   [--unit=unitnum] Select the Magtape Unit (Slave Device). Each TCU can\n"
        "                    support 8 Tape Drives. For now only Unit 0 is implemented.\n"
        "                    Any non-zero argument will generate an error message.\n"
        "                    The default Unit is 0.\n"
        "\n";

    static const struct option options[] = {
        {"help",    no_argument,       0, 0},  // 0
        {"tcu",     required_argument, 0, 0},  // 1
        {"slave",   required_argument, 0, 0},  // 2
        {"unit",    required_argument, 0, 0},  // 3
        {0,         0,                 0, 0},  // 4
    };

    //
    // Process command line
    //

    uint32_t tcu = 0;
    uint32_t unit = 0;
    opterr = 0;

    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("mt preset: unrecognized option \"%s\"\n\n%s", argv[optind-1], usage);
            return true;
        } else {
            switch (index) {
                case 0:
                    printf(usage);
                    return true;
                case 1:
                    // tcu switch
                    PARSE_TCU("preset");
                    break;
                case 2:
                case 3:
                    // unit switch
                    PARSE_UNIT("preset", false);
                    break;
            }
        }
    }

    mt.cmdPreset(tcu, mt_cfg.drive[unit].param);

    return true;
}

//!
//! \brief
//!    Magtape reset
//!
//! \details
//!    The <b>MT RESET</b> command is the console interface to resest the
//!    MT device registers.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

bool cmdMT_RESET(int argc, char *argv[]) {

   static const char *usage =
       "\n"
        "The \"mt reset\" command resets the magtape controller and transport.\n"
        "\n"
        "The KS10 system could support 8 Tape Formatters or Tape Control Units (TCUs)\n"
        "and each TCU could support 8 Tape Drives (Units). In the KS10 FPGA, not all\n"
        " TCU and slaves are implemented. See below.\n"
        "\n"
        "Usage: mt reset [options]\n"
        "\n"
        "   [--help]         Print help.\n"
        "   [--tcu=tcunum]   Select the Magtape Tape Control Unit (TCU). Presumably the\n"
        "                    KS10 could support 8 TCUs (aka formatters; aka TM03s) and\n"
        "                    each TCU could support 8 Tape Drives. For now only TCU 0\n"
        "                    is implemented. Any non-zero argument will be rejected and\n"
        "                    generate an error message. The default TCU is 0.\n"
        "   [--unit=unitnum] Select the Magtape Unit (Slave Device). Each TCU can\n"
        "                    support 8 Tape Drives. For now only Unit 0 is implemented.\n"
        "                    Any non-zero argument will generate an error message.\n"
        "                    The default Unit is 0.\n"
        "\n";

    static const struct option options[] = {
        {"help",    no_argument, 0, 0},  // 0
        {"tcu",     required_argument, 0, 0},  // 1
        {"slave",   required_argument, 0, 0},  // 2
        {"unit",    required_argument, 0, 0},  // 3
        {0,         0,           0, 0},  // 1
    };

    //
    // Process command line
    //

    uint32_t tcu = 0;
    uint32_t unit = 0;
    opterr = 0;

    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("mt reset: unrecognized option \"%s\"\n\n%s", argv[optind-1], usage);
            return true;
        } else {
            switch (index) {
                case 0:
                    // help switch
                    printf(usage);
                    return true;
                case 1:
                    // tcu switch
                    PARSE_TCU("reset");
                    break;
                case 2:
                case 3:
                    // unit switch
                    PARSE_UNIT("reset", false);
                    break;
            }
        }
    }

#if 0
    mt.clear(tcu, mt_cfg.drive[unit].param);
#else
    (void) tcu;
    (void) unit;
    mt.clear();
#endif

    return true;
}

//!
//! \brief
//!    Magtape rewind
//!
//! \details
//!    The <b>MT REWIND</b> command rewinds the magtape media.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

bool cmdMT_REWIND(int argc, char *argv[]) {

   static const char *usage =
       "\n"
        "The \"mt rewind\" command rewinds the magtape media.\n"
        "\n"
        "The KS10 system could support 8 Tape Formatters or Tape Control Units (TCUs)\n"
        "and each TCU could support 8 Tape Drives (Units). In the KS10 FPGA, not all\n"
        " TCU and slaves are implemented. See below.\n"
        "\n"
        "Usage: mt reset [options]\n"
        "\n"
        "   [--help]         Print help.\n"
        "   [--tcu=tcunum]   Select the Magtape Tape Control Unit (TCU). Presumably the\n"
        "                    KS10 could support 8 TCUs (aka formatters; aka TM03s) and\n"
        "                    each TCU could support 8 Tape Drives. For now only TCU 0\n"
        "                    is implemented. Any non-zero argument will be rejected and\n"
        "                    generate an error message. The default TCU is 0.\n"
        "   [--unit=unitnum] Select the Magtape Unit (Slave Device). Each TCU can\n"
        "                    support 8 Tape Drives. For now only Unit 0 is implemented.\n"
        "                    Any non-zero argument will generate an error message.\n"
        "                    The default Unit is 0.\n"
        "\n";

    static const struct option options[] = {
        {"help",    no_argument, 0, 0},  // 0
        {"tcu",     required_argument, 0, 0},  // 1
        {"slave",   required_argument, 0, 0},  // 2
        {"unit",    required_argument, 0, 0},  // 3
        {0,         0,           0, 0},  // 1
    };

    //
    // Process command line
    //

    uint32_t tcu = 0;
    uint32_t unit = 0;
    opterr = 0;

    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("mt rewind: unrecognized option \"%s\"\n\n%s", argv[optind-1], usage);
            return true;
        } else {
            switch (index) {
                case 0:
                    // help switch
                    printf(usage);
                    return true;
                case 1:
                    // tcu switch
                    PARSE_TCU("rewind");
                    break;
                case 2:
                case 3:
                    // unit switch
                    PARSE_UNIT("rewind", false);
                    break;

            }
        }
    }

    mt.cmdRewind(tcu, mt_cfg.drive[unit].param);

    return true;
}

//!
//! \brief
//!    Magtape space
//!
//! \details
//!    The <b>MT SPACE</b> command is the console interface to the MT device.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

static bool cmdMT_SPACE(int argc, char *argv[]) {

    static const char *usage =
        "\n"
        "The \"mt space\" command allows the users to repostion the tape transport at\n"
        "various locations on the tape. With no options, the \"mt space\" command will\n"
        "space forward one record. You can space forward or space reverse and space over\n"
        "multiple records and/or multiple files using the options below:\n"
        "\n"
        "   [--help]         Print help.\n"
        "   [--fwd]          Space forward file[s] or records[s].\n"
        "   [--rev]          Space reverse file[s] or records[s].\n"
        "   [--files=param]  Space multiple files per the parameter.\n"
        "   [--recs=param]   Space multiple records per the parameter.\n"
        "   [--tcu=tcunum]   Select the Magtape Tape Control Unit (TCU). Presumably the\n"
        "                    KS10 could support 8 TCUs (aka formatters; aka TM03s) and\n"
        "                    each TCU could support 8 Tape Drives. For now only TCU 0\n"
        "                    is implemented. Any non-zero argument will be rejected and\n"
        "                    generate an error message. The default TCU is 0.\n"
        "   [--unit=unitnum] Select the Magtape Unit (Slave Device). Each TCU can\n"
        "                    support 8 Tape Drives. For now only Unit 0 is implemented.\n"
        "                    Any non-zero argument will generate an error message.\n"
        "                    The default Unit is 0.\n"
        "\n"
        "Note: Only of of the \"--files\" of \"--rec\" options can be provided. Not both.\n"
        "\n"
        "The default operation is to space forward one record.\n"
        "\n";

    static const struct option options[] = {
        {"help",    no_argument,       0, 0},  //  0
        {"fwd",     no_argument,       0, 0},  //  1
        {"for",     no_argument,       0, 0},  //  2
        {"forward", no_argument,       0, 0},  //  3
        {"rev",     no_argument,       0, 0},  //  4
        {"reverse", no_argument,       0, 0},  //  5
        {"fil",     required_argument, 0, 0},  //  6
        {"files",   required_argument, 0, 0},  //  7
        {"rec",     required_argument, 0, 0},  //  8
        {"recs",    required_argument, 0, 0},  //  9
        {"tcu",     required_argument, 0, 0},  // 10
        {"slave",   required_argument, 0, 0},  // 11
        {"unit",    required_argument, 0, 0},  // 12
        {0,         0,                 0, 0},  // 13
    };

    bool fwdFound   = false;
    bool revFound   = false;
    bool recsFound  = false;
    bool filesFound = false;
    int  recs  = 0;
    int  files = 0;

    //
    // Process command line
    //

    uint32_t tcu = 0;
    uint32_t unit = 0;
    opterr = 0;

    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("mt space: unrecognized option: %s\n", argv[optind-1]);
            return true;
        } else {
            switch (index) {
                case 0: // --help
                    printf(usage);
                    return true;
                case 1:
                case 2:
                case 3: // --fwd
                    fwdFound = true;
                    break;
                case 4:
                case 5: // --rev
                    revFound = true;
                    break;
                case 6:
                case 7: // --files
                    files = strtoul(optarg, NULL, 0);
                    filesFound = true;
                    if (files < 0) {
                        printf("mt space: \"--files\" parameter out of range: %s\n", argv[optind-1]);
                        return true;
                    }
                    break;
                case 8:
                case 9: // --recs
                    recs = strtoul(optarg, NULL, 0);
                    recsFound = true;
                    if (files < 0) {
                        printf("mt space: \"--recs\" parameter out of range: %s\n", argv[optind-1]);
                        return true;
                    }
                    break;
                case 10:
                    // tcu switch
                    PARSE_TCU("space");
                    break;
                case 11:
                case 12:
                    // unit switch
                    PARSE_UNIT("space", false);
                    break;
            }
        }
    }

    if (fwdFound && revFound) {
        printf("mt space: both \"--fwd\" and \"--rev\" options provided\"\n\n%s", usage);
        return true;
    }

    if (filesFound && recsFound) {
        printf("mt space: both \"--files\" and \"--recs\" options provided\"\n\n%s", usage);
        return true;
    }

    if (revFound) {

        //
        // Space reverse
        //

        if (filesFound) {
            for (int i = 0; i < files; i++) {
                mt.cmdSpaceRev(tcu, mt_cfg.drive[unit].param, 0);
            }
            printf("mt space: reverse %d files.\n", files);
        } else {
            if (recsFound) {
                mt.cmdSpaceRev(tcu, mt_cfg.drive[unit].param, recs);
                printf("mt space: reverse %d recs.\n", recs);
            } else {
                mt.cmdSpaceRev(tcu, mt_cfg.drive[unit].param, 1);
                printf("mt space: reverse %d recs.\n", 1);
            }
        }

    } else {

        //
        // Space Forward
        //

        if (filesFound) {
            for (int i = 0; i < files; i++) {
                mt.cmdSpaceFwd(tcu, mt_cfg.drive[unit].param, 0);
            }
            printf("mt space: forward %d files.\n", files);
        } else {
            if (recsFound) {
                mt.cmdSpaceFwd(tcu, mt_cfg.drive[unit].param, recs);
                printf("mt space: forward %d recs.\n", recs);
            } else {
                mt.cmdSpaceFwd(tcu, mt_cfg.drive[unit].param, 1);
                printf("mt space: forward %d recs.\n", 1);
            }
        }
    }

    return true;
}

//!
//! \brief
//!    Magtape status
//!
//! \details
//!    The <b>MT STAT</b> command is the console interface to print
//!    MT device status.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

bool cmdMT_STAT(int argc, char *argv[]) {

    static const char *usage =
        "\n"
        "The \"mt stat[us]\" prints the magtape controller status.\n"
        "\n"
        "Usage: mt stat[us] [--help]\n"
        "\n";

    static const struct option options[] = {
        {"help",    no_argument, 0, 0},  // 0
        {0,         0,           0, 0},  // 1
    };

    //
    // Process command line
    //

    opterr = 0;
    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("mt status: unrecognized option \"%s\"\n\n%s", argv[optind-1], usage);
            return true;
        } else if (index == 0) {
            printf(usage);
            return true;
        }
    }

    ks10_t::printMTDEBUG();
    return true;
}

//!
//! \brief
//!    Magtape test interface
//!
//! \details
//!    The <b>MT TEST</b> command is the console interface to the MT device.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

static bool cmdMT_TEST(int argc, char *argv[]) {

    static const char *usage =
        "\n"
        "The \"mt test\" command performs various tests on the RH11, TM03, and TU77 that\n"
        "that are attached to the KS10.\n"
        "\n"
        "Usage: mt test [options]\n"
        "\n"
        "Valid options are:\n"
        "   [--help]         Print help.\n"
        "   [--dump]         Dump registers\n"
        "   [--fifo]         Test RH11 FIFO (aka SILO)\n"
        "   [--init]         Test RH11/TM03/TU77 initialization\n"
        "   [--preset]       Preset tape\n"
        "   [--read]         Test read operation\n"
        "   [--rewind]       Rewind tape\n"
        "   [--unload]       Unload tape\n"
        "   [--writ[e]]      Test write operation\n"
        "   [--wrchk]        Test write check operation\n"
        "   [--reset]        Reset RH11/TM03/TU77 functions\n"
        "   [--tcu=tcunum]   Select the Magtape Tape Control Unit (TCU). Presumably the\n"
        "                    KS10 could support 8 TCUs (aka formatters; aka TM03s) and\n"
        "                    each TCU could support 8 Tape Drives. For now only TCU 0\n"
        "                    is implemented. Any non-zero argument will be rejected and\n"
        "                    generate an error message. The default TCU is 0.\n"
        "   [--unit=unitnum] Select the Magtape Unit (Slave Device). Each TCU can\n"
        "                    support 8 Tape Drives. For now only Unit 0 is implemented.\n"
        "                    Any non-zero argument will generate an error message.\n"
        "                    The default Unit is 0.\n"
        "\n";

    static const struct option options[] = {
        {"help",   no_argument,       0, 0},  //  0
        {"dump",   no_argument,       0, 0},  //  1
        {"fifo",   no_argument,       0, 0},  //  2
        {"init",   no_argument,       0, 0},  //  3
        {"reset",  no_argument,       0, 0},  //  4
        {"read",   no_argument,       0, 0},  //  5
        {"write",  no_argument,       0, 0},  //  6
        {"writ",   no_argument,       0, 0},  //  7
        {"wrchk",  no_argument,       0, 0},  //  8
        {"tcu",    required_argument, 0, 0},  //  9
        {"slave",  required_argument, 0, 0},  // 10
        {"unit",   required_argument, 0, 0},  // 11
        {0,        0,                 0, 0},  // 12
    };

    //
    // Process command line
    //

    uint32_t tcu = 0;
    uint32_t unit = 0;
    opterr = 0;

    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("mt test: unrecognized option: %s\n", argv[optind-1]);
            return true;
        } else {
            switch (index) {
                case 0:
                    printf(usage);
                    return true;
                case 1:
                    mt.dumpRegs(tcu, mt_cfg.drive[unit].param);
                    break;
                case 2:
                    mt.testFIFO();
                    break;
                case 3:
                    mt.testInit(tcu, mt_cfg.drive[unit].param);
                    break;
                case 4:
                    mt.clear();
                    break;
                case 5:
                    mt.testRead(tcu, mt_cfg.drive[unit].param);
                    break;
                case 6:
                case 7:
                    mt.testWrite(tcu, mt_cfg.drive[unit].param);
                    break;
                case 8:
                    mt.testWrchk(tcu, mt_cfg.drive[unit].param);
                    break;
                case 9:
                    // tcu switch
                    PARSE_TCU("test");
                    break;
                case 10:
                case 11:
                    // unit switch
                    PARSE_UNIT("test", false);
                    break;
            }
        }
    }
    return true;
}

//!
//! \brief
//!    Magtape unload
//!
//! \details
//!    The <b>MT UNLOAD</b> command is the console interface to unload/dismount
//!    the MT media.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

bool cmdMT_UNLOAD(int argc, char *argv[]) {

    static const char *usage =
        "\n"
        "The \"mt unload\" command unloads (unmounts) the magtape media, stops the tape\n"
        "thread that services that tape device, and closes the tape file associated with\n"
        "the tape device.\n"
        "\n"
        "The KS10 system could support 8 Tape Formatters or Tape Control Units (TCUs)\n"
        "and each TCU could support 8 Tape Drives (Units). In the KS10 FPGA, not all\n"
        " TCU and slaves are implemented. See below.\n"
        "\n"
        "Usage: mt unload [options]\n"
        "\n"
        "Valid options are:\n"
        "\n"
        "   [--help]            Print help.\n"
        "   [--unit=unitnum]    Select the Magtape Unit (Slave Device). Each TCU can\n"
        "                       support 8 Tape Drives. For now only Unit 0 is implemented.\n"
        "                       Any non-zero argument will generate an error message.\n"
        "                       The default Unit is 0.\n"
        "   [--tcu=tcunum]      Set the Magtape Tape Control Unit (TCU). For now only TCU 0\n"
        "                       is implemented. Any non-zero argument will be rejected and\n"
        "                       will generate an error message. The default TCU is 0.\n";

    static const struct option options[] = {
        {"help",    no_argument,       0, 0},  // 0
        {"tcu",     required_argument, 0, 0},  // 1
        {"slave",   required_argument, 0, 0},  // 2
        {"unit",    required_argument, 0, 0},  // 3
        {0,         0,                 0, 0},  // 4
    };

    //
    // Process command line
    //

    uint32_t tcu = 0;
    uint32_t unit = 0;
    opterr = 0;

    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("mt unload: unrecognized option \"%s\"\n\n%s", argv[optind-1], usage);
            return true;
        } else {
            switch (index) {
                case 0:
                    // unload help switch
                    printf(usage);
                    return true;
                case 1:
                    // tcu switch
                    PARSE_TCU("unload");
                    break;
                case 2:
                case 3:
                    // unit switch
                    PARSE_UNIT("unload", false);
                    break;
            }
        }
    }

    mtSetBootParam(unit);

    mt.cmdUnload(tcu, mt_cfg.drive[unit].param);

    if (mt_cfg.drive[unit].attached) {
        mt_cfg.drive[unit].fp          = NULL;
        mt_cfg.drive[unit].attached    = false;
        mt_cfg.drive[unit].length      = 2400;
        mt_cfg.drive[unit].filename[0] = 0;
    } else {
        printf("mt unload: unit %d is not mounted.\n", unit);
    }

    return true;
}

//!
//! \brief
//!    Magtape interface
//!
//! \details
//!    The <b>MT</b> command is the console interface to the MT device.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

bool command_t::cmdMT(int argc, char *argv[]) {

    //
    // Top level options and help
    //

    static const char *usage =
        "\n"
        "The mt command provides an interface to configure and test the Magtape\n"
        "hardware.\n"
        "\n"
        "Usage: mt [--help] | [command [args]]\n"
        "\n"
        "The mt commands are:\n"
        "  boo[t]   Boot from Magtape devices\n"
        "  con[fig] Configure Magtape\n"
        "  dum[p]   Dump MT related registers\n"
        "  era[se]  Write an erase gap on the Magtape\n"
        "  mou[nt]  Mount a Magtape\n"
        "  pre[set] Preset the Magtape\n"
        "  res[et]  Reset the Magtape hardware\n"
        "  rew[ind] Rewind the Magtape\n"
        "  spa[ce]  Skip records or files on the Magtape\n"
        "  sta[t]   Print MT status\n"
        "  tes[t]   Test MT functionality\n"
        "  unl[oad] Unload the Magtape\n"
        "\n"
        "See also:\n"
        "  mt boo[t]   --help\n"
        "  mt con[fig] --help\n"
        "  mt dum[p]   --help\n"
        "  mt era[se]  --help\n"
        "  mt mou[nt]  --help\n"
        "  mt pre[set] --help\n"
        "  mt res[et]  --help\n"
        "  mt rew[ind] --help\n"
        "  mt spa[ce]  --help\n"
        "  mt sta[t]   --help\n"
        "  mt tes[t]   --help\n"
        "  mt unl[oad] --help\n"
        "\n";

    //
    // No arguments applied.
    //

    if (argc == 1) {
        printf(usage);
        return true;
    }

    if (strncasecmp(argv[1], "--help", 4) == 0) {
        printf(usage);
        return true;
    } else if (strncasecmp(argv[1], "boot", 3) == 0) {
        return cmdMT_BOOT(argc, argv);
    } else if (strncasecmp(argv[1], "debug", 3) == 0) {
        return cmdMT_DEBUG(argc, argv);
    } else if (strncasecmp(argv[1], "dump", 3) == 0) {
        return cmdMT_DUMP(argc, argv);
    } else if (strncasecmp(argv[1], "erase", 3) == 0) {
        return cmdMT_ERASE(argc, argv);
    } else if (strncasecmp(argv[1], "mount", 3) == 0) {
        return cmdMT_MOUNT(argc, argv);
    } else if (strncasecmp(argv[1], "preset", 3) == 0) {
        return cmdMT_PRESET(argc, argv);
    } else if (strncasecmp(argv[1], "reset", 3) == 0) {
        return cmdMT_RESET(argc, argv);
    } else if (strncasecmp(argv[1], "rewind", 3) == 0) {
        return cmdMT_REWIND(argc, argv);
    } else if (strncasecmp(argv[1], "space", 3) == 0) {
        return cmdMT_SPACE(argc, argv);
    } else if (strncasecmp(argv[1], "stat", 3) == 0) {
        return cmdMT_STAT(argc, argv);
    } else if (strncasecmp(argv[1], "test", 3) == 0) {
        return cmdMT_TEST(argc, argv);
    } else if (strncasecmp(argv[1], "unload",3) == 0) {
        return cmdMT_UNLOAD(argc, argv);
    } else {
        printf("mt: unrecognized option \'%s\'\n", argv[1]);
    }

    return true;
}

//!
//! \brief
//!    Quit
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

bool command_t::cmdQU(int /*argc*/, char */*argv*/[]) {

    struct termios ctrl;
    tcgetattr(STDIN_FILENO, &ctrl);
    ctrl.c_lflag |= (ICANON | ECHO);
    tcsetattr(STDIN_FILENO, TCSANOW, &ctrl);

    exit(EXIT_SUCCESS);
}

//!
//! \brief
//!    Memory Read
//!
//! \details
//!    This function peforms memory reads.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the argument.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

bool command_t::cmdRD(int argc, char *argv[]) {

    const char *usage =
        "\n"
        "The \"rd\" command reads from memory, Unibus IO, APR IO, and ACs.\n"
        "\n"
        "Usage: rd [--help] <ac <reg>> | <io addr> | <mem addr <length>> | aprid |\n"
        "          apr | pi |ubr | ebr | spb | csb | cstm | pur | tim | int | hsb | pc\n"
        "\n";

    static const struct option options[] = {
        {"help",  no_argument, 0, 0},  // 0
        {0,       0,           0, 0},  // 1
    };

    //
    // Process command line
    //

    opterr = 0;
    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("rd: unrecognized option: %s\n", argv[optind-1]);
            return true;
        } else if (index == 0) {
            printf(usage);
            return true;
        }
    }

    if (!ks10_t::halt()) {
        printf("KS10: CPU is running. Halt it first.\n");
        return true;
    }

    if (strncasecmp(argv[1], "aprid", 5) == 0) {
        ks10_t::data_t data = ks10_t::rdAPRID();
        printf("KS10: APRID  : %012llo\n"
               "      INHCST : %llo\n"
               "      NOCST  : %llo\n"
               "      NONSTD : %llo\n"
               "      UBABLT : %llo\n"
               "      KIPAG  : %llo\n"
               "      KLPAG  : %llo\n"
               "      MCV    : %03llo\n"
               "      HO     : %llo\n"
               "      HSN    : %d\n",
               data,
               ((data >> 35) & 000001),
               ((data >> 34) & 000001),
               ((data >> 33) & 000001),
               ((data >> 32) & 000001),
               ((data >> 31) & 000001),
               ((data >> 30) & 000001),
               ((data >> 18) & 000777),
               ((data >> 15) & 000007),
               ((unsigned int)(data & 077777)));
    } else if (strncasecmp(argv[1], "apr", 3) == 0) {
        printf("KS10: APR is %012llo\n", ks10_t::rdAPR());
    } else if (strncasecmp(argv[1], "pi", 2) == 0) {
        printf("KS10: PI is %012llo\n", ks10_t::rdPI());
    } else if (strncasecmp(argv[1], "ubr", 3) == 0) {
        printf("KS10: UBR is %012llo\n", ks10_t::rdUBR());
    } else if (strncasecmp(argv[1], "ebr", 3) == 0) {
        ks10_t::data_t data = ks10_t::rdEBR();
        printf("KS10: EBR    : %012llo\n"
               "      T20PAG : %llo\n"
               "      ENBPAG : %llo\n"
               "      EBRPAG : %04llo\n",
               data,
               ((data >> 14) & 000001),
               ((data >> 13) & 000001),
               ((data >>  0) & 003777));
    } else if (strncasecmp(argv[1], "spb", 3) == 0) {
        printf("KS10: SPB is %012llo\n", ks10_t::rdSPB());
    } else if (strncasecmp(argv[1], "csb", 3) == 0) {
        printf("KS10: CSB is %012llo\n", ks10_t::rdCSB());
    } else if (strncasecmp(argv[1], "cstm", 4) == 0) {
        printf("KS10: CSTM is %012llo\n", ks10_t::rdCSTM());
    } else if (strncasecmp(argv[1], "pur", 3) == 0) {
        printf("KS10: PUR is %012llo\n", ks10_t::rdPUR());
    } else if (strncasecmp(argv[1], "tim", 3) == 0) {
        printf("KS10: TIM is %012llo\n", ks10_t::rdTIM());
    } else if (strncasecmp(argv[1], "int", 3) == 0) {
        printf("KS10: INT is %012llo\n", ks10_t::rdINT());
    } else if (strncasecmp(argv[1], "hsb", 3) == 0) {
        printf("KS10: HSB is %012llo\n", ks10_t::rdHSB());
    } else if (strncasecmp(argv[1], "pc", 2) == 0) {
        printPCIR(ks10_t::readPCIR());
    } else if (strncasecmp(argv[1], "ac", 2) == 0) {
        if (argc == 2) {
            for (unsigned int i = 0; i < 020; i++) {
                printf("%02o: %012llo\n", i, ks10_t::readAC(i));
            }
        } else if (argc == 3) {
            unsigned int regAC = parseOctal(argv[2]);
            if (regAC < 020) {
                printf("%012llo\n", ks10_t::readAC(regAC));
            } else {
                printf("rd ac: invalid AC number.\n");
            }
        } else {
            printf("rd ac: unrecognized command\n");
        }
    } else if (strncasecmp(argv[1], "mem", 3) == 0) {
        if (argc == 3) {
            ks10_t::addr_t addr = parseOctal(argv[2]);
            ks10_t::data_t data = ks10_t::readMem(addr);
            if (ks10_t::nxmnxd()) {
                printf("rd mem: memory access failed with NXM\n");
            } else {
                printf("%06llo: %012llo\n", addr, data);
            }
        } else if (argc == 4) {
            ks10_t::addr_t addr = parseOctal(argv[2]);
            unsigned int   len  = parseOctal(argv[3]);
            for (unsigned int i = 0; i < len; i++) {
                ks10_t::data_t data = ks10_t::readMem(addr);
                if (ks10_t::nxmnxd()) {
                    printf("rd mem: memory access failed with NXM\n");
                } else {
                    printf("%06llo: %012llo\n", addr, data);
                }
                addr++;
            }
        } else {
            printf("rd mem: unrecognized command\n");
        }
    } else if (strncasecmp(argv[1], "io", 2) == 0) {
        if (argc == 3) {
            ks10_t::addr_t addr = parseOctal(argv[2]);
            ks10_t::data_t data = ks10_t::readIO(addr);
            if (ks10_t::nxmnxd()) {
                printf("rd mem: IO access failed with NXM\n");
            } else {
                printf("%06llo: %012llo\n", addr, data);
            }
        } else {
            printf("rd io: unrecognized command\n");
        }
    } else {
        printf(usage);
    }

    return true;
}

//!
//! \brief
//!    Boot from RP
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the argument.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

static bool cmdRP_BOOT(int argc, char *argv[]) {

    static const char *usage =
        "\n"
        "The \"rp boot\" command boots the KS10 from a disk drive.\n"
        "\n"
        "Usage: rp boot [--help] <options>\n"
        "\n"
        "Valid options are:\n"
        "\n"
        "   [--help]          Print help.\n"
        "   [--base=addr]     Set the base address of the RH11. The default value of\n"
        "                     0776700 is the only correct base address for the disks.\n"
        "                     Don\'t change this unless you know what you are doing.\n"
        "                     The default base address is 0776700.\n"
        "   [--diag[nostic]]  Boot to the diagnostic monitor program instead of normal\n"
        "                     monitor.\n"
        "   [--print]         Print the boot parameters and exit. Do not boot.\n"
        "   [--uba=num]       Set the Unibus Adapter (UBA) for the RH11. The default\n"
        "                     value of 1 is the only correct UBA for the disk.\n"
        "                     Don\'t change this unless you know what you are doing.\n"
        "   [--unit=unit]     Set the boot disk unit. The default unit is 0.\n"
        "\n";

    static const struct option options[] = {
        {"help",        no_argument,       0, 0},  // 0
        {"base",        required_argument, 0, 0},  // 1
        {"uba",         required_argument, 0, 0},  // 2
        {"unit",        required_argument, 0, 0},  // 3
        {"print",       no_argument,       0, 0},  // 4
        {"diag",        no_argument,       0, 0},  // 5
        {"diagnostic",  no_argument,       0, 0},  // 6
        {"diagnostics", no_argument,       0, 0},  // 7
        {0,             0,                 0, 0},  // 8
    };

    if (argc < 2) {
        printf("rp boot: missing argument\n");
        return true;
    }

    //
    // Process command line
    //

    ks10_t::addr_t temp = 0;
    opterr = 0;
    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("rp boot: unrecognized option: %s\n", argv[optind-1]);
            return true;
        } else {
            switch (index) {
                case 0:
                    // help switch
                    printf(usage);
                    return true;
                case 1:
                    // base switch
                    temp = parseOctal(optarg);
                    rp_cfg.baseaddr = (rp_cfg.baseaddr & 07000000) | (temp & 0777777);
                    break;
                case 2:
                    // uba switch
                    if ((optarg[0] == '1') || (optarg[0] == '3') || (optarg[0] == '4')) {
                        rp_cfg.baseaddr = (rp_cfg.baseaddr & 0777777) | ((optarg[0] - '0') << 18);
                    } else {
                        printf("rp boot: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                    }
                    break;
                case 3:
                    // unit switch
                    if (isdigit(optarg[0])) {
                        unsigned int temp = strtoul(optarg, NULL, 0);
                        if (temp <= 7) {
                            rp_cfg.unit = temp;
                        } else {
                            printf("rp boot: parameter out of range \'--%s=%s\'\n", options[index].name, optarg);
                        }
                    } else {
                        printf("rp boot: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                    }
                    break;
                case 4:
                    // print switch
                    printf("rp boot: params are:\n"
                           "      UBA  = %o\n"
                           "      BASE = 0%06o\n"
                           "      UNIT = %d\n",
                           static_cast<unsigned int>((rp_cfg.baseaddr >> 18) & 0000007),
                           static_cast<unsigned int>((rp_cfg.baseaddr >>  0) & 0777777),
                           static_cast<unsigned int>((rp_cfg.unit     >>  0) & 0000007));
                    return true;
                case 5:
                case 6:
                case 7:
                    rp_cfg.bootdiag = true;
                    break;
            }
        }
    }

    //
    // Configure the CPU
    //

    ks10_t::cacheEnable(true);
    ks10_t::trapEnable(true);
    ks10_t::timerEnable(true);

    //
    // Set RP Boot Parameters
    //

    ks10_t::writeMem(ks10_t::rhbaseADDR, rp_cfg.baseaddr);
    ks10_t::writeMem(ks10_t::rhunitADDR, rp_cfg.unit);

    //
    // Halt the KS10 if it is already running.
    //

    if (ks10_t::run()) {
        printf("KS10: Already running. Halting the KS10.\n");
        ks10_t::run(false);
    }

    //
    // Boot from disk using the selected boot image
    //

    rp.boot(rp_cfg.unit, rp_cfg.bootdiag);

    return true;
}

//!
//! \brief
//!    Configure RP
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the argument.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

static bool cmdRP_CONF(int argc, char *argv[]) {

    uint32_t rpccr = ks10_t::readRPCCR();

    static const char *usage =
        "\n"
        "The \"rp config\" command allows the RP configuration to be set and\n"
        "stored on the file system. On a real system, these controls would be\n"
        "located on the disk drive. The configurations provided with this\n"
        "command is written to the RP Console Control Register (RPCCR)\n"
        "\n"
        "Usage: rp config [--help] [--unit=[0-7] <options> [unit=[0-7] <options>]]\n"
        "\n"
        "Valid options are:\n"
        "\n"
        "   [--help]         Print help.\n"
        "   [--dpr={t[rue]|f[alse]}]\n"
        "                    Set the Drive Present status for the selected Disk Drive\n"
        "                    This setting is reflected in the Drive Present bit in\n"
        "                    the Disk Drive Status Register (RPDS[DPR]) for the\n"
        "                    selected Disk Drive.\n"
        "   [--mol={t[rue]|f[alse]}]\n"
        "                    Set the Media Online(MOL) status for the selected Disk\n"
        "                    Drive. This setting is reflected in the Media On-line\n"
        "                    bit in the Disk Drive Status Register (RPDS[MOL]) for\n"
        "                    the selected Disk Drive.\n"
        "   [--wrl={t[rue]|f[alse]}]\n"
        "                    Set Write Lock (WRL) status for the selected Disk Drive.\n"
        "                    This setting is reflected in the Write Lock bit in the\n"
        "                    Disk Drive Status Register (RPDS[WRL]) for the selected\n"
        "                    Disk Drive.\n"
        "   [--unit=unit]    Disk Drive selection. This parameter must be provided.\n"
        "                    See example below.\n"
        "\n"
        "Example:\n"
        "\n"
        "rp config --unit=0 --dpr=t --mol=t --wrl=t --unit=2 --dpr=f --print\n"
        "\n"
        "Set Disk Drive 0 to indicate drive present, on-line, and write protected; then\n"
        "set Disk Drive 2 to indicate not present; then print the configuration of all\n"
        "Disk Drives.\n"
        "\n";

    static const struct option options[] = {
        {"help",    no_argument,       0, 0},   // 0
        {"unit",    required_argument, 0, 0},   // 1
        {"dpr",     required_argument, 0, 0},   // 2
        {"present", required_argument, 0, 0},   // 3
        {"mol",     required_argument, 0, 0},   // 4
        {"online",  required_argument, 0, 0},   // 5
        {"wrl",     required_argument, 0, 0},   // 6
        {"wprot",   required_argument, 0, 0},   // 7
        {0,         0,                 0, 0},   // 8
    };

    //
    // Print configuration
    //

    if (argc == 2) {
        printf("        DPR = Drive Present\n"
               "        MOL = Media On-Line\n"
               "        WRL = Write Locked\n"
               "        +------+-------------+\n"
               "        | UNIT | DPR MOL WRL |\n"
               "        +------+-------------+\n");

        for (int i = 0; i < 8; i++) {
            printf("        |   %1d  |  %c   %c   %c  |\n", i,
                   ((int)(rpccr >> (16 + i)) & 1) ? 'X' : ' ',
                   ((int)(rpccr >> ( 8 + i)) & 1) ? 'X' : ' ',
                   ((int)(rpccr >> ( 0 + i)) & 1) ? 'X' : ' ');
        }
        printf("        +------+-------------+\n");
        return true;
    }

    //
    // Process command line
    //

    int unit = -1;
    opterr = 0;
    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("rp conf: unrecognized option: %s\n", argv[optind-1]);
            return true;
        } else {
            switch (index) {
                case 0:
                    // conf help switch
                    printf(usage);
                    break;
                case 1:
                    // conf unit switch
                    if (isdigit(optarg[0])) {
                        unsigned int temp = strtoul(optarg, NULL, 0);
                        if (temp <= 7) {
                            unit = temp;
                        } else {
                            printf("rp: parameter out of range \'--%s=%s\'\n", options[index].name, optarg);
                        }
                    } else {
                        printf("rp: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                    }
                    break;
                case 2:
                case 3:
                    // conf dpr switch
                    if (unit < 0) {
                        printf("rp boot: unit not specified before \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    if ((optarg[0] == 'f') || (optarg[0] == '0')) {
                        rpccr &= ~(1 << (16 + unit));
                    } else if ((optarg[0] == 't') || (optarg[0] == '1')) {
                        rpccr |=  (1 << (16 + unit));
                    } else {
                        printf("rp: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    break;
                case 4:
                case 5:
                    // conf mol switch
                    if (unit < 0) {
                        printf("rp boot: unit not specified before \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    if ((optarg[0] == 'f') || (optarg[0] == '0')) {
                        rpccr &= ~(1 << (8 + unit));
                    } else if ((optarg[0] == 't') || (optarg[0] == '1')) {
                        rpccr |=  (1 << (8 + unit));
                    } else {
                        printf("rp: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    break;
                case 6:
                case 7:
                    // conf wrl switch
                    if (unit < 0) {
                        printf("rp boot: unit not specified before \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    if ((optarg[0] == 'f') || (optarg[0] == '0')) {
                        rpccr &= ~(1 << unit);
                    } else if ((optarg[0] == 't') || (optarg[0] == '1')) {
                        rpccr |=  (1 << unit);
                    } else {
                        printf("rp: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    break;
            }
        }
    }
    ks10_t::writeRPCCR(rpccr);
    return true;
}

//!
//! \brief
//!    Print RP Status
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the argument.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

static bool cmdRP_STAT(int argc, char *argv[]) {

   static const char *usage =
        "\n"
        "The \"rp stat\" command print the status of the RP state machine.\n"

        "\n"
        "Usage: rp stat [--help] command\n"
        "\n"
        "The rp stat commands are:\n"
        "   [--help]      Print help.\n"
        "   [--sum[mary]] Print summary only.\n"
        "\n";

    static const struct option options[] = {
        {"help",    no_argument, 0, 0},  // 0
        {"sum",     no_argument, 0, 0},  // 1
        {"summary", no_argument, 0, 0},  // 2
        {0,         0,           0, 0},  // 3
    };

    //
    // Process command line
    //

    bool summary = false;
    opterr = 0;

    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("rp test: unrecognized option: %s\n", argv[optind-1]);
            return true;
        } else {
            switch (index) {
                case 0:
                    // help
                    printf(usage);
                    return true;
                case 1:
                case 2:
                    // summary
                    summary = true;
                    break;
            }
        }
    }

    if (summary) {
        uint64_t rpdebug = ks10_t::getRPDEBUG();
        if (rpdebug >> 56 == ks10_t::rpIDLE) {
            printf("KS10: RP06 successfully initialized SDHC media.\n");
        } else if (rpdebug >> 40 == 0x7e0c80) {
            printf("KS10: %sRP06 cannot utilize SDSC media.  Use SDHC media.%s\n", vt100fg_red, vt100at_rst);
        } else {
            printf("KS10: %sRP06 failed to initialize SDHC media.%s\n", vt100fg_red, vt100at_rst);
            ks10_t::printRPDEBUG();
        }
    } else {
        ks10_t::printRPDEBUG();
    }

    return true;

}

//!
//! \brief
//!    Test RP
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the argument.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

static bool cmdRP_TEST(int argc, char *argv[]) {

    static const char *usage =
        "\n"
        "The \"rp test\" command performs various tests on the RH11, and RP disks\n"
        "that are attached to the KS10.\n"
        "\n"
        "Usage: rp test [--help] command\n"
        "\n"
        "The rp test commands are:\n"
        "   [--help]   Print help.\n"
        "   [--dump]   Dump registers\n"
        "   [--fifo]   Test RH11 FIFO (aka SILO)\n"
        "   [--init]   Test RH11 and RP initialization\n"
        "   [--read]   Test RP read operations\n"
        "   [--reset]  Reset RH11 and RP functions\n"
        "   [--write]  Test RP write operations\n"
        "   [--wrchk]  Test RP write check operation\n"
        "\n";

    static const struct option options[] = {
        {"help",  no_argument, 0, 0},  // 0
        {"dump",  no_argument, 0, 0},  // 1
        {"fifo",  no_argument, 0, 0},  // 2
        {"init",  no_argument, 0, 0},  // 3
        {"reset", no_argument, 0, 0},  // 4
        {"read",  no_argument, 0, 0},  // 5
        {"write", no_argument, 0, 0},  // 6
        {"wrchk", no_argument, 0, 0},  // 7
        {0,       0,           0, 0},  // 8
    };

    if (argc == 2) {
        printf("rp test: missing test command\n%s", usage);
        return true;
    }

    //
    // Process command line
    //

    opterr = 0;
    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("rp test: unrecognized option: %s\n", argv[optind-1]);
            return true;
        } else {
            switch (index) {
                case 0:
                    printf(usage);
                    return true;
                case 1:
                    rp.dumpRegs();
                    break;
                case 2:
                    rp.testFIFO();
                    break;
                case 3:
                    rp.testInit(rp_cfg.unit);
                    break;
                case 4:
                    rp.clear();
                    break;
                case 5:
                    rp.testRead(rp_cfg.unit);
                    break;
                case 6:
                    rp.testWrite(rp_cfg.unit);
                    break;
                case 7:
                    rp.testWrchk(rp_cfg.unit);
                    break;
            }
        }
    }
    return true;
}

//!
//! \brief
//!    Configure RPxx
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the argument.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

bool command_t::cmdRP(int argc, char *argv[]) {

    //
    // Top level options and help
    //

    static const char *usageTop =
        "\n"
        "The \"rp\" command provides an interface to configure and test the disk drive\n"
        "hardware.\n"
        "\n"
        "Usage: rp [--help] <command> [<args>]\n"
        "\n"
        "The rp commands are:\n"
        "  boot   Boot from RP devices\n"
        "  conf   Configure RP devices\n"
        "  dump   Dump RP related registers\n"
        "  reset  Reset the RP hardware\n"
        "  stat   Print RP status\n"
        "  test   Test RP functionality\n"
        "\n"
        "See also:\n"
        "  rp boot --help\n"
        "  rp conf --help\n"
        "  rp test --help\n"
        "\n";

    //
    // No arguments applied.
    //

    if (argc == 1) {
        printf(usageTop);
        return true;
    }

    if (strncasecmp(argv[1], "--help", 4) == 0) {
        printf(usageTop);
        return true;
    } else if (strncasecmp(argv[1], "boot", 4) == 0) {
        return cmdRP_BOOT(argc, argv);
    } else if (strncasecmp(argv[1], "conf", 4) == 0) {
        return cmdRP_CONF(argc, argv);
    } else if (strncasecmp(argv[1], "dump", 4) == 0) {
        rp.dumpRegs();
        printf("RPCCR = 0x%08x\n", ks10_t::readRPCCR());
    } else if (strncasecmp(argv[1], "reset", 4) == 0) {
        rp.clear();
    } else if (strncasecmp(argv[1], "stat", 4) == 0) {
        cmdRP_STAT(argc, argv);
    } else if (strncasecmp(argv[1], "test", 4) == 0) {
        return cmdRP_TEST(argc, argv);
    } else {
        printf("rp: unrecognized option \'%s\'\n", argv[1]);
    }

   return true;
}

//!
//! \brief
//!    Single Step
//!
//! \details
//!    The <b>SI</b> (Step Instruction) single steps the KS10 CPU.
//!
//! \sa cmdHA, cmdCO
//!
//! \param [in] argc
//!    Number of arguments.
//!
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

bool command_t::cmdSI(int argc, char *argv[]) {

    const char *usage =
        "\n"
        "The command \"si\" single steps the KS10.\n"
        "\n"
        "Usage: si [--help] [step count]\n"
        "\n";

    static const struct option options[] = {
        {"help",    no_argument, 0, 0},  // 0
        {0,         0,           0, 0},  // 1
    };

    //
    // Process command line
    //

    opterr = 0;
    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("si: unrecognized option: %s\n", argv[optind-1]);
            return true;
        } else if (index == 0) {
            printf(usage);
            return true;
        }
    }

    if (argc == 1) {
        ks10_t::startSTEP();
        printPCIR(ks10_t::readPCIR());
        printf("si: single stepped\n");
    } else if (argc >= 2) {
        unsigned int num = parseOctal(argv[1]);
        for (unsigned int i = 0; i < num; i++) {
            ks10_t::startSTEP();
            printPCIR(ks10_t::readPCIR());
        }
        printf("si: single stepped %d instructions\n", num);
        if (argc >= 3) {
            printf("si: additional arguments ignored\n");
        }
    }

    return true;
}

//!
//! \brief
//!    Shutdown Command
//!
//! \details
//!    The <b>SH</b> (Shutdown) command deposits non-zero data in KS10 memory
//!    location 30. This causes TOPS20 to shut down without issuing a warning.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

bool command_t::cmdSH(int argc, char *argv[]) {
    const char *usage =
        "\n"
        "The command \"sh\" shuts-down TOPS20.\n"
        "\n"
        "Usage: sh [--help]\n"
        "\n";

    static const struct option options[] = {
        {"help",    no_argument, 0, 0},  // 0
        {0,         0,           0, 0},  // 1
    };

    //
    // Process command line
    //

    opterr = 0;
    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("sh: unrecognized option: %s\n", argv[optind-1]);
            return true;
        } else if (index == 0) {
            printf(usage);
            return true;
        }
    }

    ks10_t::writeMem(ks10_t::switchADDR, 1);
    printf("sh: data deposited in switch register\n");
    if (argc >= 2) {
        printf("sh: additional arguments ignored\n");
    }

    return true;
}

//!
//! \brief
//!    Start Command
//!
//! \details
//!    The <b>ST</b> (Start) command stuffs a JRST instruction into the
//!    <b>Console Instruction Register</b> and begins execution starting
//!    with that instruction.
//!
//!    The address must be a virtual address and is therefore limited to
//!    0777777.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

bool command_t::cmdST(int argc, char *argv[]) {

    const char *usage =
        "\n"
        "The \"st\" command starts the KS10 at supplied address. It essentially sets\n"
        "the program counter at the specified location and begins execution.\n"
        "\n"
        "Usage: st <--help> addr\n"
        "\n";

    static const struct option options[] = {
        {"help",    no_argument, 0, 0},  // 0
        {0,         0,           0, 0},  // 1
    };

    //
    // Process command line
    //

    opterr = 0;
    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("st: unrecognized option: %s\n", argv[optind-1]);
            return true;
        } else if (index == 0) {
            printf(usage);
            return true;
        }
    }

    if (argc == 1) {
        printf("st: address argument required\n");
    } else if (argc >= 2) {
        ks10_t::addr_t addr = parseOctal(argv[1]);
        if (addr <= ks10_t::maxVirtAddr) {
            ks10_t::writeRegCIR((ks10_t::opJRST << 18) | (addr & 0777777));
            ks10_t::startRUN();
            return consoleOutput();
        } else {
            printf("st: valid addresses are %08llo-%08llo\n",
                   ks10_t::memStart, ks10_t::maxVirtAddr);
        }
        if (argc >= 3) {
            printf("st: additional arguments ignored\n");
        }
    }

    return true;
}

//!
//! \brief
//!    Timer Enable
//!
//! \details
//!    The <b>TE</b> (Timer Enable) command controls the operation the KS10's
//!    one millisecond system timer.
//!
//!    - The <b>te</b> command will display the state of the KS10's system timer.
//!    - The <b>te --disable</b> command will disable the KS10's system timer.
//!    - The <b>te --enable</b> command will enable the KS10's system timer
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

bool command_t::cmdTE(int argc, char *argv[]) {

    const char *usage =
        "\n"
        "The \"te\" commands controls the operation of the KS10 system timer.\n"
        "\n"
        "Usage: te <options>\n"
        "       te without an option will display the current timer status.\n"
        "\n"
        "Valid options are:\n"
        "\n"
        "  [--en[able]]  Enable the timer.\n"
        "  [--dis[able]] Disable the timer.\n"
        "\n";

    static const struct option options[] = {
        {"help",    no_argument, 0, 0},  // 0
        {"dis",     no_argument, 0, 0},  // 1
        {"disable", no_argument, 0, 0},  // 2
        {"en",      no_argument, 0, 0},  // 3
        {"enable",  no_argument, 0, 0},  // 4
        {0,         0,           0, 0},  // 5
    };

    //
    // No arguments
    //

    if (argc == 1) {
        printf("tp: the timer currently %s.\n", ks10_t::trapEnable() ? "enabled" : "disabled");
        return true;
    }

    //
    // Process command line
    //

    opterr = 0;
    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("te: unrecognized option: %s\n", argv[optind-1]);
            return true;
        } else {
            switch(index) {
                case 0:
                    printf(usage);
                    return true;
                case 1:
                case 2:
                    ks10_t::trapEnable(false);
                    printf("tp: the timer is disabled\n");
                    return true;
                case 3:
                case 4:
                    ks10_t::trapEnable(true);
                    printf("tp: the timer is enabled\n");
                    return true;
            }
        }
    }

    return true;
}

//!
//! \brief
//!    Traps Enable
//!
//! \details
//!    The <b>TP</b> (Trap Enable) command controls the operation the KS10's
//!    trap system.
//!
//!    - The <b>TP</b> command will display the state of the KS10's traps.
//!    - The <b>TP --disable</b> command will disable the KS10's traps.
//!    - The <b>TP --enablle</b> command will enable the KS10's traps.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

bool command_t::cmdTP(int argc, char *argv[]) {

    const char *usage =
        "\n"
        "The \"tp\" commands controls the operation of the KS10 trap system.\n"
        "\n"
        "Usage: te <options>\n"
        "       te without an option will display the current trap system status.\n"
        "\n"
        "Valid options are:\n"
        "\n"
        "  [--en[able]]  Enable traps.\n"
        "  [--dis[able]] Disable traps.\n"
        "\n";

    static const struct option options[] = {
        {"help",    no_argument, 0, 0},  // 0
        {"dis",     no_argument, 0, 0},  // 1
        {"disable", no_argument, 0, 0},  // 2
        {"en",      no_argument, 0, 0},  // 3
        {"enable",  no_argument, 0, 0},  // 4
        {0,         0,           0, 0},  // 5
    };

    //
    // No arguments
    //

    if (argc == 1) {
        printf("tp: traps are currently %s.\n", ks10_t::trapEnable() ? "enabled" : "disabled");
        return true;
    }

    //
    // Process command line
    //

    opterr = 0;
    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("tp: unrecognized option: %s\n", argv[optind-1]);
            return true;
        } else {
            switch(index) {
                case 0:
                    printf(usage);
                    return true;
                case 1:
                case 2:
                    ks10_t::trapEnable(false);
                    printf("tp: traps are disabled\n");
                    return true;
                case 3:
                case 4:
                    ks10_t::trapEnable(true);
                    printf("tp: traps are enabled\n");
                    return true;
            }
        }
    }

    return true;
}

//!
//! \brief
//!    Control the Trace Buffer
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

bool command_t::cmdTR(int argc, char *argv[]) {

    static const char *usage =
        "\n"
        "The \"tr\" comand controls the instruction trace hardware.\n"
        "\n"
        "Usage: TR <options> <length>\n"
        "\n"
        "Valid options are:\n"
        "  --help         Help\n"
        "  --clr          Reset/Clear the trace buffer\n"
        "  --clear        Reset/Clear the trace buffer\n"
        "  --reset        Reset/Clear the trace buffer\n"
        "  --rst          Reset/Clear the trace buffer\n"
        "  --size         Prints the trace buffer size. The trace buffer size is fixed\n"
        "                 when the FPGA is built. The maximum buffer size is only\n"
        "                 limited by the amount of memory available in the FPGA.\n"
        "\n"
        "If the length is not provided, the default length is 32. If the length is\n"
        "provided the length can be given in decimal, octal, or hex. If the length is\n"
        " longer than the buffer size, the trace stops when the buffer is empty.\n"
        "\n"
        "Examples:\n"
        "tr               Prints the last 32 samples of trace buffer.\n"
        "tr 1024          Prints the last 1024 samples of the trace buffer is at least\n"
        "                 1024 entries in length.\n"
        "\n"
        "I never remember the proper command to clear the trace buffer - so I added\n"
        "them all.\n";

    static const struct option options[] = {
        {"help",  no_argument, 0, 0},  // 0
        {"clr",   no_argument, 0, 1},  // 1
        {"clear", no_argument, 0, 2},  // 2
        {"reset", no_argument, 0, 3},  // 3
        {"rst",   no_argument, 0, 4},  // 4
        {"size",  no_argument, 0, 5},  // 5
        {0,       0,           0, 6},  // 6
    };

    static const char *header =
        "Dump of Trace Buffer:\n"
        " Entry     PC      HI     LO    OPC AC I XR   EA  \n"
        "-------  ------  ------ ------  --- -- - -- ------\n";

    static const uint64_t itrCLR   = 0x8000000000000000;
//  static const uint64_t itrFULL  = 0x4000000000000000;
    static const uint64_t itrEMPTY = 0x2000000000000000;

    //
    // Process command line
    //

    opterr = 0;
    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("tr: unrecognized option: %s\n", argv[optind-1]);
            return true;
        } else {
            switch(index) {
                case 0:
                    printf(usage);
                    return true;
                case 1:
                case 2:
                case 3:
                case 4:
                    ks10_t::writeITR(itrCLR);
                    printf("tr: trace buffer cleared\n");
                    return true;
                case 5:
                    printf("tr: the trace buffer size is %d entries\n",
                           1 << (int)((ks10_t::readITR() >> 56) & 0x1f));
                    return true;
            }
        }
    }

    int num = 32;
    if (argc == 2) {
        num = strtoul(argv[1], NULL, 0);
    }

    bool first = true;
    for (int i = 0; i < num; i++) {
        uint64_t itr = ks10_t::readITR();
//      printf("0x%016llx\n", itr);
        if (first) {
            if (itr & itrEMPTY) {
                printf("tr: trace buffer is empty\n");
                return true;
            } else {
                printf(header);
            }
        } else {
            printf("%7d  ", -i);
            printPCIR(itr);
            if ((itr & itrEMPTY) != 0) {
                printf("tr: trace buffer is empty\n");
                return true;
            }
        }
        first = false;
    }

    printf("tr: trace finished\n"
           "tr: more trace is available\n");
    return true;
}

//!
//! \brief
//!    Memory Write
//!
//! \details
//!    This function peforms writes to memory.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!

bool command_t::cmdWR(int argc, char *argv[]) {

    const char *usage =
        "\n"
        "The \"wr\" command writes to memory or Unibus IO.\n"
        "\n"
        "Usage: wr [--help] <io_addr data> | <mem_addr data>\n"
        "\n";

    static const struct option options[] = {
        {"help",  no_argument, 0, 0},  // 0
        {0,       0,           0, 0},  // 1
    };

    //
    // Process command line
    //

    opterr = 0;
    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("wr: unrecognized option: %s\n", argv[optind-1]);
            return true;
        } else if (index == 0) {
            printf(usage);
            return true;
        }
    }

    if (argc < 2) {
        printf("wr: missing arguments\n");
        return true;
    }

    if (strncasecmp(argv[1], "io", 2) == 0) {
        if (argc < 4) {
            printf("wr io: missing arguments\n");
            return true;
        }
        ks10_t::addr_t addr = parseOctal(argv[2]);
        ks10_t::data_t data = parseOctal(argv[3]);
        ks10_t::writeIO(addr, data);
        printf("wr io: data written\n");
        if (ks10_t::nxmnxd()) {
            printf("wr io: IO access failed with NXM\n");
        }
        if (argc > 4) {
            printf("wr io: additional arguments ignored\n");
        }
    } else if (strncasecmp(argv[1], "mem", 3) == 0) {
        if (argc < 4) {
            printf("wr mem: missing arguments\n");
            return true;
        }
        ks10_t::addr_t addr = parseOctal(argv[2]);
        ks10_t::data_t data = parseOctal(argv[3]);
        ks10_t::writeMem(addr, data);
        printf("wr mem: data written.\n");
        if (ks10_t::nxmnxd()) {
            printf("wr mem: memory access failed with NXM\n");
        }
        if (argc > 4) {
            printf("wr mem: additional arguments ignored\n");
        }
    } else {
        printf("wr: unrecognized command\n");
    }

    return true;
}

//!
//! \brief
//!    Zero memory
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

bool command_t::cmdZM(int argc, char *argv[]) {

    const char *usage =
        "\n"
        "The 'zm' command zeros all KS10 memory.\n"
        "\n"
        "Usage: zm\n"
        "\n";

    static const struct option options[] = {
        {"help",  no_argument, 0, 0},  // 0
        {0,       0,           0, 0},  // 1
    };

    //
    // Process command line
    //

    opterr = 0;
    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("zm: unrecognized option: %s\n", argv[optind-1]);
            return true;
        } else if (index == 0) {
            printf(usage);
            return true;
        }
    }

    if (argc == 1) {
        const ks10_t::addr_t memSize = 1024 * 1024;
        printf("zm: Zeroing memory (%d kW). This takes about 30 seconds.\n", 1024);
        for (ks10_t::addr_t i = 0; i < memSize; i++) {
            ks10_t::writeMem(i, 0);
        }
    } else {
        printf("zm: additional arguments ignored\n");
    }

    return true;
}

//!
//! \brief
//!    Test function
//!
//! \details
//!    This function tests the printf() function and a bunch of other junk
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

bool command_t::cmdZZ(int argc, char *argv[]) {

    printf("%s\n", dasm(0213000000000ULL));  // "MOVNS"
    printf("%s\n", dasm(0213200000000ULL));  // "MOVNS 4,0"
    printf("%s\n", dasm(0213210002020ULL));  // "MOVNS 2020(10)"
    printf("%s\n", dasm(0213020000000ULL));  // "MOVNS @0"
    printf("%s\n", dasm(0213032000000ULL));  // "MOVNS @0(12)"
    printf("%s\n", dasm(0213232000000ULL));  // "MOVNS 4,@0(12)"
    printf("\n");
    printf("%s\n", dasm(0213000777777ULL));  // "MOVNS -1"
    printf("%s\n", dasm(0213200777777ULL));  // "MOVNS 4,-1"

    printf("%s\n", dasm(0213217777777ULL));  // "MOVNS -1(17)"

    printf("%s\n", dasm(0213020777777ULL));  // "MOVNS @-1"
    printf("%s\n", dasm(0213032777777ULL));  // "MOVNS @-1(12)"
    printf("%s\n", dasm(0213232777777ULL));  // "MOVNS 4,@-1(12)"
    printf("\n");
    printf("%s\n", dasm(0213000003456ULL));  // "MOVNS 3456"
    printf("%s\n", dasm(0213200003456ULL));  // "MOVNS 4,3456"
    printf("%s\n", dasm(0213020003456ULL));  // "MOVNS @3456"
    printf("%s\n", dasm(0213032003456ULL));  // "MOVNS @3456(12)"
    printf("%s\n", dasm(0213232003456ULL));  // "MOVNS 4,@3456(12)"
    printf("\n");
    printf("%s\n", dasm(0254000000000ULL));  // "JRST"
    printf("%s\n", dasm(0254040000000ULL));  // "PORTAL"
    printf("%s\n", dasm(0254100000000ULL));  // "JRSTF"
    printf("%s\n", dasm(0254140000000ULL));  // "INVALID"
    printf("%s\n", dasm(0254200000000ULL));  // "HALT"
    printf("%s\n", dasm(0254240000000ULL));  // "XJRSTF"
    printf("%s\n", dasm(0254300000000ULL));  // "XJEN"
    printf("%s\n", dasm(0254340000000ULL));  // "XPCW"
    printf("%s\n", dasm(0254400000000ULL));  // "INVALID"
    printf("%s\n", dasm(0254440000000ULL));  // "INVALID"
    printf("%s\n", dasm(0254500000000ULL));  // "JEN"
    printf("%s\n", dasm(0254540000000ULL));  // "PORTAL"
    printf("%s\n", dasm(0254600000000ULL));  // "INVALID"
    printf("%s\n", dasm(0254640000000ULL));  // "SFM"
    printf("%s\n", dasm(0254700000000ULL));  // "INVALID"
    printf("%s\n", dasm(0254740000000ULL));  // "INVALID"
    printf("\n");
    printf("%s\n", dasm(0254200000000ULL));  // "HALT"
    printf("%s\n", dasm(0254200300000ULL));  // "HALT 30000"
    printf("%s\n", dasm(0254220000001ULL));  // "HALT @0"
    printf("%s\n", dasm(0254220000002ULL));  // "HALT @1"
    printf("%s\n", dasm(0254225000003ULL));  // "HALT @3(5)"
    printf("%s\n", dasm(0254225000004ULL));  // "HALT @4(5)"
    printf("\n");
    printf("%s\n", dasm(0700000000000ULL));  // "APRID"
    printf("%s\n", dasm(0700040000000ULL));  // "70004"
    printf("%s\n", dasm(0700100000000ULL));  // "70010"
    printf("%s\n", dasm(0700140000000ULL));  // "70014"
    printf("%s\n", dasm(0700200000000ULL));  // "WRAPR"
    printf("%s\n", dasm(0700240000000ULL));  // "RDAPR"
    printf("%s\n", dasm(0700300000000ULL));  // "70030"
    printf("%s\n", dasm(0700340000000ULL));  // "70034"
    printf("%s\n", dasm(0700400000000ULL));  // "70040"
    printf("%s\n", dasm(0700440000000ULL));  // "70044"
    printf("%s\n", dasm(0700500000000ULL));  // "70050"
    printf("%s\n", dasm(0700540000000ULL));  // "70054"
    printf("%s\n", dasm(0700600000000ULL));  // "WRPI"
    printf("%s\n", dasm(0700640000000ULL));  // "RDPI"
    printf("%s\n", dasm(0700700000000ULL));  // "70070"
    printf("%s\n", dasm(0700740000000ULL));  // "70014"
    printf("%s\n", dasm(0701000000000ULL));  // "70100"
    printf("%s\n", dasm(0701040000000ULL));  // "RDUBR"
    printf("%s\n", dasm(0701100000000ULL));  // "CLRPT"
    printf("%s\n", dasm(0701140000000ULL));  // "WRUBR"
    printf("%s\n", dasm(0701200000000ULL));  // "WREBR"
    printf("%s\n", dasm(0701240000000ULL));  // "RDEBR"
    printf("%s\n", dasm(0701300000000ULL));  // "70130"
    printf("%s\n", dasm(0701340000000ULL));  // "70134"
    printf("%s\n", dasm(0701400000000ULL));  // "70140"
    printf("%s\n", dasm(0701440000000ULL));  // "70144"
    printf("%s\n", dasm(0701500000000ULL));  // "70150"
    printf("%s\n", dasm(0701540000000ULL));  // "70154"
    printf("%s\n", dasm(0701600000000ULL));  // "70160"
    printf("%s\n", dasm(0701640000000ULL));  // "70164"
    printf("%s\n", dasm(0701700000000ULL));  // "70170"
    printf("%s\n", dasm(0701740000000ULL));  // "70174"
    printf("%s\n", dasm(0702000000000ULL));  // "RDSPB"
    printf("%s\n", dasm(0702040000000ULL));  // "RDCSB"
    printf("%s\n", dasm(0702100000000ULL));  // "RDPUR"
    printf("%s\n", dasm(0702140000000ULL));  // "RDCSTM
    printf("%s\n", dasm(0702200000000ULL));  // "RDTIM"
    printf("%s\n", dasm(0702240000000ULL));  // "RDINT"
    printf("%s\n", dasm(0702300000000ULL));  // "RDHSB"
    printf("%s\n", dasm(0702340000000ULL));  // "70234"
    printf("%s\n", dasm(0702400000000ULL));  // "WRSPB"
    printf("%s\n", dasm(0702440000000ULL));  // "WRCSB"
    printf("%s\n", dasm(0702500000000ULL));  // "WRPUR"
    printf("%s\n", dasm(0702540000000ULL));  // "WRCSTM
    printf("%s\n", dasm(0702600000000ULL));  // "WRTIM"
    printf("%s\n", dasm(0702640000000ULL));  // "WRINT"
    printf("%s\n", dasm(0702700000000ULL));  // "WRHSB"
    printf("%s\n", dasm(0702740000000ULL));  // "70274"
    printf("\n");
    printf("%s\n", dasm(0700000000000ULL));  // "APRID"
    printf("%s\n", dasm(0700000000001ULL));  // "APRID 1"
    printf("%s\n", dasm(0700006000002ULL));  // "APRID 2(6)
    printf("%s\n", dasm(0700020000003ULL));  // "APRID @3"
    printf("%s\n", dasm(0700037000004ULL));  // "APRID @4(17)"


    if (argc == 1) {

        printf("This is a test (int decimal) %d\n", 23456);
        printf("This is a test (int hex    ) %x\n", 0x123456);
        printf("This is a test (int octal  ) %o\n", 01234567);
        printf("This is a test (long decimal) %ld\n", 345699234ul);
        printf("This is a test (long hex    ) %lx\n", 0x1234567aul);
        printf("This is a test (long octal  ) %lo\n", 012345676543ul);
        printf("This is a test (long long decimal) %lld\n", 345699234ull);
        printf("This is a test (long long hex    ) %llx \n", 0x95232633ull);
        printf("This is a test (long long octal  ) %012llo\n", 0123456ull);
        printf("This is a test (long long hex    ) 0x%llx\n", 0x0123456789abcdefULL);
        printf("This is a test (long long hex    ) 0x%llx\n", 0x95232633579bfe34ull);

    } else if (argc == 2) {
        if (strncasecmp(argv[1], "on", 2) == 0) {
            ks10_t::cpuReset(true);
            printf("KS10 held in reset\n");
        } else if (strncasecmp(argv[1], "off", 2) == 0) {
            ks10_t::cpuReset(false);
            printf("KS10 unreset\n");
        }
    }

    return true;
}

//!
//! \brief
//!    Command processing task
//!
//! \details
//!    This function parses the commands and dispatches to the various handler
//!    functions.
//!
//! \param [in] buf
//!    command line buffer
//!
//! \returns
//!    True if the interpreter should print a prompt after completion;
//!    otherwise false.
//!

bool command_t::execute(char * buf) {

    //
    // List of Commands
    //

    struct cmdList_t {
        const char * name;
            bool (command_t::*function)(int argc, char *argv[]);
    };

    static const cmdList_t cmdList[] = {
        {"!",  &command_t::cmdBA},          // Bang
        {"?",  &command_t::cmdHE},          // Help
        {"BR", &command_t::cmdBR},          // Breakpoint
        {"CE", &command_t::cmdCE},          // Cache enable
        {"CO", &command_t::cmdCO},          // Continue
        {"CL", &command_t::cmdCL},          // Clear screen
        {"CP", &command_t::cmdCPU},         // CPU
        {"DA", &command_t::cmdDA},          // Disassemble
        {"DU", &command_t::cmdDUP},         // DUP11 Test
        {"DZ", &command_t::cmdDZ},          // DZ11 Test
        {"EX", &command_t::cmdEX},          // Execute
        {"GO", &command_t::cmdGO},          // GO
        {"HA", &command_t::cmdHA},          // Halt
        {"HE", &command_t::cmdHE},          // Help
        {"HS", &command_t::cmdHS},          // Halt status
        {"LP", &command_t::cmdLP},          // LPxx configuration
        {"MR", &command_t::cmdMR},
        {"MT", &command_t::cmdMT},          // Magtape boot
        {"QU", &command_t::cmdQU},          // Quit
        {"RD", &command_t::cmdRD},          // Simple memory read
        {"RP", &command_t::cmdRP},          // RPxx Configuration
        {"SH", &command_t::cmdSH},           // Escape to shell
        {"SI", &command_t::cmdSI},          // Step instruction
        {"ST", &command_t::cmdST},          // Start
        {"TE", &command_t::cmdTE},          // Timer enable
        {"TP", &command_t::cmdTP},          // Trap enable
        {"TR", &command_t::cmdTR},          // Trace
        {"WR", &command_t::cmdWR},          // Simple memory write
        {"ZM", &command_t::cmdZM},          // Zero memory
        {"ZZ", &command_t::cmdZZ},          // Testing
    };

    const int numCMD = sizeof(cmdList)/sizeof(cmdList_t);

    //
    // Handle signals
    //

    sa.sa_handler = sigHandler;
    sigaction(SIGINT, &sa, NULL);
    if (setjmp(env)) {
        sa.sa_handler = SIG_DFL;
        sigaction(SIGINT, &sa, NULL);
        printf("KS10: Command aborted. Caught SIGINT.\n");
        return true;
    }

    //
    // From argument parser
    //

    extern int optind;
    optind = 0;

    //
    // Process command line. Handle multiple commands separated by ';'
    //

    bool ret = true;
    bool more = false;
    char *p = buf;

    do {

        int argc = 0;
        static const int maxarg = 16;
        static char *argv[maxarg];

        //
        // Form argc and argv
        //

        bool process = true;
        while (*p != 0 && *p != ';') {
            if (*p == ' ') {
                *p = 0;
                process = true;
            } else if (process && (argc < maxarg)) {
                argv[argc++] = p;
                process = false;
            }
            p++;
        }

        more = (*p == ';');
        *p = 0;

        //
        // Execute commands
        //   argc = 0 when no command <cr> is entered
        //   argv[0] is the command
        //   argv[1] is the first argument
        //

        bool found = false;
        if (argc != 0) {
            for (int i = 0; i < numCMD; i++) {
                if ((cmdList[i].name[0] == toupper(argv[0][0])) &&
                    (cmdList[i].name[1] == toupper(argv[0][1]))) {
                    ret = (this->*cmdList[i].function)(argc, argv);
                    found = true;
                    break;
                }
            }
            if (!found) {
                printf("%s: Command not found.\n", argv[0]);
            }
        }
        p++;
    } while (more);

    sa.sa_handler = SIG_DFL;
    sigaction(SIGINT, &sa, NULL);

    return ret;
}
