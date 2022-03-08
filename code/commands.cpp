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
#include <sys/select.h>

#include "mt.hpp"
#include "rp.hpp"
#include "dasm.hpp"
#include "dz11.hpp"
#include "ks10.hpp"
#include "lp20.hpp"
#include "rh11.hpp"
#include "dup11.hpp"
#include "config.hpp"
#include "commands.hpp"

#define __unused __attribute__((unused))

//!
//! \brief
//!    Construct object to abstract the hardware
//!

rp_t    rp;             //!< Construct RP (disk) device
mt_t    mt;             //!< Construct MT (tape) device
lp20_t  lp;             //!< Construct LP (printer) device
dz11_t  dz;             //!< Construct DZ (tty) device
dup11_t dp;             //!< Construct DUP (serial com) device

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

#if 0

static struct cpucfg_t {
    bool cacheEnable;
    bool trapEnable;
    bool timerEnable;
} cpucfg;

static const char *cpucfg_file = ".ks10/cpu.cfg";

#endif

//!
//! \brief
//!    Recall Configuration
//!

void recallConfig(void) {

    //
    // Initialize the device objects
    //

    dp.recallConfig();
    dz.recallConfig();
    lp.recallConfig();
    mt.recallConfig();
    rp.recallConfig();

    //
    // Initialize the Console Communications memory area
    //

    ks10_t::writeMem(ks10_t::switchADDR,  0400000400000);       // Initialize switch register
    ks10_t::writeMem(ks10_t::kaswADDR,    0003740000000);       // Initialize keep-alive and status word
    ks10_t::writeMem(ks10_t::ctyinADDR,   0000000000000);       // Initialize CTY input word
    ks10_t::writeMem(ks10_t::ctyoutADDR,  0000000000000);       // Initialize CTY output word
    ks10_t::writeMem(ks10_t::klninADDR,   0000000000000);       // Initialize KLINIK input word
    ks10_t::writeMem(ks10_t::klnoutADDR,  0000000000000);       // Initialize KLINIK output word
    ks10_t::writeMem(ks10_t::rhbaseADDR,  rp.cfg.baseaddr);     // Initialize RH11 base address
    ks10_t::writeMem(ks10_t::rhunitADDR,  rp.cfg.unit);         // Initialize UNIT number
    ks10_t::writeMem(ks10_t::mtparmADDR,  mt.cfg.param);        // Initialize magtape params
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

bool consoleOutput(void) {
    void printPCIR(uint64_t data);
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
                printPCIR(ks10_t::readDPCIR());
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
//!    Dump DBAR
//!

static void printDBAR(void) {
    ks10_t::data_t dbar = ks10_t::readDBAR();
    printf("DBAR      : %012llo\n"
           "        FLAGS   :   %s%s%s%s%s%s\n"
           "        ADDRESS :   %08llo\n",
           dbar,
           dbar & ks10_t::flagFetch ? "Fetch "    : "",
           dbar & ks10_t::flagRead  ? "Read "     : "",
           dbar & ks10_t::flagWrite ? "Write "    : "",
           dbar & ks10_t::flagPhys  ? "Physical " : "",
           dbar & ks10_t::flagIO    ? "IO "       : "",
           dbar & ks10_t::flagByte  ? "Byte "     : "",
           (dbar & ks10_t::flagIO)  ? dbar & ks10_t::dbarIOMASK : dbar & ks10_t::dbarMEMMASK);
}

//!
//! \brief
//!    Dump DBMR
//!

static void printDBMR(void) {
    ks10_t::data_t dbmr = ks10_t::readDBMR();
    printf("DBMR      : %012llo\n"
           "        FLAGS   :   %s%s%s%s%s%s\n"
           "        ADDRESS :   %08llo\n",
           dbmr,
           dbmr & ks10_t::flagFetch ? "Fetch "    : "",
           dbmr & ks10_t::flagRead  ? "Read "     : "",
           dbmr & ks10_t::flagWrite ? "Write "    : "",
           dbmr & ks10_t::flagPhys  ? "Physical " : "",
           dbmr & ks10_t::flagIO    ? "IO "       : "",
           dbmr & ks10_t::flagByte  ? "Byte "     : "",
           (dbmr & ks10_t::flagIO)  ? dbmr & ks10_t::dbmrIOMASK : dbmr & ks10_t::dbmrMEMMASK);
}

//!
//! \brief
//!   Function to print breakpoint trace hardware status
//!

static void printDEBUG(void) {
    ks10_t::data_t dcsr = ks10_t::readDCSR();

    printf("Breakpoint and Trace System Status: \n"
           "  DCSR      : %012llo\n"
           "    TREMPTY :   %s\n"
           "    TRFULL  :   %s\n"
           "    TRSTATE :   %s\n"
           "    TRCMD   :   %s\n"
           "    BRSTATE :   %s\n"
           "    BRCMD   :   %s\n",
           dcsr,
           dcsr & ks10_t::dcsrEMPTY ? "True" : "False",
           dcsr & ks10_t::dcsrFULL  ? "True" : "False",
           (((dcsr & ks10_t::dcsrTRSTATE) == ks10_t::dcsrTRSTATE_IDLE) ? "Idle" :
            (((dcsr & ks10_t::dcsrTRSTATE) == ks10_t::dcsrTRSTATE_ARMED) ? "Armed" :
             (((dcsr & ks10_t::dcsrTRSTATE) == ks10_t::dcsrTRSTATE_ACTIVE) ? "Active" :
              (((dcsr & ks10_t::dcsrTRSTATE) == ks10_t::dcsrTRSTATE_DONE) ? "Done" :
               "Unknown")))),
           (((dcsr & ks10_t::dcsrTRCMD) == ks10_t::dcsrTRCMD_RESET) ? "Reset" :
            (((dcsr & ks10_t::dcsrTRCMD) == ks10_t::dcsrTRCMD_TRIG) ? "Trigger" :
             (((dcsr & ks10_t::dcsrTRCMD) == ks10_t::dcsrTRCMD_MATCH) ? "Address Match" :
              (((dcsr & ks10_t::dcsrTRCMD) == ks10_t::dcsrTRCMD_STOP) ? "Stop" :
               "Unknown")))),
           (((dcsr & ks10_t::dcsrBRSTATE) == ks10_t::dcsrBRSTATE_IDLE) ? "Idle" :
            (((dcsr & ks10_t::dcsrBRSTATE) == ks10_t::dcsrBRSTATE_ARMED) ? "Armed" :
             "Unknown")),
           (((dcsr & ks10_t::dcsrBRCMD) == ks10_t::dcsrBRCMD_DISABLE) ? "Disable" :
            (((dcsr & ks10_t::dcsrBRCMD) == ks10_t::dcsrBRCMD_MATCH) ? "Address Match" :
             (((dcsr & ks10_t::dcsrBRCMD) == ks10_t::dcsrBRCMD_FULL) ? "Trace Full" :
              (((dcsr & ks10_t::dcsrBRCMD) == ks10_t::dcsrBRCMD_BOTH) ? "Address Match or Trace Full" :
               "Unknown")))));
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

static bool cmdBA(int argc, char *argv[]) {

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
//!   Breakpoint control
//!
//! \details
//!    The <b>BR</b> (Breakpoint) command creates a hardware breakpoint.
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

static bool cmdBR(int argc, char *argv[]) {

    const char *usage =
        "\n"
        "The \"br\" command controls the breakpoint and trace hardware.\n"
        "\n"
        "When a breakpoint is triggered, the processor will halt and the trace buffer\n"
        "contains a list the previously executed instructions. For example, assume for\n"
        "discussion that the trace buffer size is 1024 entries. When a breakpoint is\n"
        "encountered, the trace buffer would contain the previous 1024 instructions.\n"
        "Instructions executed before that are discarded from the trace buffer FIFO. Note:\n"
        "The size of the trace buffer is a FPGA parameter which can be easily modified\n"
        "but will required the FPGA firmware to be re-built. The trace buffer size is\n"
        "limited by the amount of FPGA memory.\n"
        "\n"
        "When a tracepoint is triggered, the trace buffer will begin acquiring data. When\n"
        "the trace buffer is full, the processor will halt.\n"
        "\n"
        "In summary, the breakpoint provides trace data before the trigger. The\n"
        "tracepoint provides trace data after the trigger.\n"
        "\n"
        "usage: br [--help] [--mask=mask] [--trace] [trigger_condition]\n"
        "\n"
        "Valid options are:\n"
        "\n"
        "  --help        Print help.\n"
        "  --tr[ace]     Start tracing on a trigger condition instead of breakpoint on\n"
        "                trigger conditions.\n"
        "  --mask=mask   Set an address match mask. The mask parameter is a 22-bit octal\n"
        "                constant that is masked against bits 14-35 of the address bus.\n"
        "                Bits that are one in the mask argument are ignored when\n"
        "                performing the address match comparison. The default mask is 0\n"
        "                which includes all relevant address bits in the address match\n"
        "                comparison. This allows breakpointing on a range of addresses\n"
        "                with some limitations. See example below. This command sets the\n"
        "                the Debug Breakpoint Mask Register (DBMR) albeit the bits are\n"
        "                inverted to save typing on common uses.\n"
        "\n"
        "br with no trigger_condition will print the breakpoint status\n"
        "\n"
        "Valid trigger conditions are:\n"
        "  <fetch addr>  Trigger on an instruction fetch operation and address match.\n"
        "  <memrd addr>  Trigger on a memory read operation and address match.\n"
        "  <memwr addr>  Trigger on a memory write operation and address match.\n"
        "  <iord  addr>  Trigger on an IO read operation and address match.\n"
        "  <iowr  addr>  Trigger on an IO write operation and address match.\n"
        "\n"
        "The addr (address) parameter described above is a 22-bit octal constant that\n"
        "is matched against bits 14-35 of the address bus. Only one break option is\n"
        "permitted. These commands set the Debug Breakpoint Address Register (DBAR).\n"
        "\n"
        "Note: The trigger hardware cannot trigger on a memory read OR write condition\n"
        "or a IO read OR write conditions.  This would require two trigger devices.\n"
        "\n"
        "The following command will break on an instruction fetch a address 030000.\n"
        "\n"
        "br fetch 030000\n"
        "\n"
        "The following command will breakpoint on any access to the magtape controller\n"
        "which has io addresses in the range of 03772440 and 03772477.\n"
        "\n"
        "br io 03772440 --mask 037\n"
        "\n";

    static const struct option options[] = {
        {"help",   no_argument,       0, 0},  // 0
        {"tr",     no_argument,       0, 0},  // 1
        {"trace",  no_argument,       0, 0},  // 2
        {"mask",   required_argument, 0, 0},  // 3
        {0,        0,                 0, 0},  // 4
    };

    if (argc == 1) {
        printf("br: status is:\n");
        return true;
    }

    int index = 0;
    bool trace = false;
    ks10_t::data_t mask = 0;

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
                case 0:
                    printf(usage);
                    return true;
                case 1:
                case 2:
                    trace = true;
                    break;
                case 3:
                    mask = parseOctal(optarg);
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

    printf("mask is 0%012llo. trace is %s\n", mask, trace ? "true" : "false");

#endif

    if (argc < optind + 2) {
        printf("br: missing trigger condition\n%s", usage);
        return true;
    }

    //
    // Process trigger conditions
    //

    ks10_t::data_t addr = ks10_t::dbmrMEMMASK & parseOctal(argv[optind+1]);

    if (strncasecmp(argv[1], "fetch", 3) == 0) {
        addr =  addr & ks10_t::dbarMEMMASK;
        mask = ~mask & ks10_t::dbmrMEMMASK;
        ks10_t::writeDBAR(ks10_t::dbarFETCH | addr);
        ks10_t::writeDBMR(ks10_t::dbmrFETCH | mask);
    } else if (strncasecmp(argv[1], "iord", 3) == 0) {
        addr =  addr & ks10_t::dbarIOMASK;
        mask = ~mask & ks10_t::dbmrIOMASK;
        ks10_t::writeDBAR(ks10_t::dbarIORD | addr);
        ks10_t::writeDBMR(ks10_t::dbmrIORD | ks10_t::dbmrIOMASK);
    } else if (strncasecmp(argv[1], "iowr", 3) == 0) {
        addr =  addr & ks10_t::dbarIOMASK;
        mask = ~mask & ks10_t::dbmrIOMASK;
        ks10_t::writeDBAR(ks10_t::dbarIOWR | addr);
        ks10_t::writeDBMR(ks10_t::dbmrIOWR | mask);
    } else if (strncasecmp(argv[1], "memrd", 4) == 0) {
        addr =  addr & ks10_t::dbarMEMMASK;
        mask = ~mask & ks10_t::dbmrMEMMASK;
        ks10_t::writeDBAR(ks10_t::dbarMEMRD | addr);
        ks10_t::writeDBMR(ks10_t::dbmrMEMRD | mask);
    } else if (strncasecmp(argv[1], "memwr", 4) == 0) {
        mask = ~mask & ks10_t::dbmrMEMMASK;
        ks10_t::writeDBAR(ks10_t::dbarMEMWR | addr);
        ks10_t::writeDBMR(ks10_t::dbmrMEMWR | ks10_t::dbmrMEMMASK);
    } else {
        printf(usage);
        return true;
    }

    printf("Fetch: addr - 0%012llo, mask - 0%012llo\n", ks10_t::readDBAR(), ks10_t::readDBMR());

    printDBAR();
    printDBMR();

    return true;

}


#ifdef OLDBR

    const char *usage =
        "\n"
        "Control the breakpoint hardware.\n"
        "\n"
        "Usage: BR {FETCH | MEMRD | MEMWR | IORD | IOWR} Address\n"
        "       BR OFF   - disable breakpoint\n"
        "       BR MATCH - break on address match\n"
        "       BR FULL  - break on trace buffer full\n"
        "       BR BOTH  - break on buffer full or address match\n"
        "       BR STAT  - display breakpoint registers\n";


    ks10_t::data_t addr;

    switch (argc) {
        case 1:
            printf(usage);
            break;
        case 2:
            if (strncasecmp(argv[1], "off", 2) == 0) {
                ks10_t::writeDCSR(ks10_t::dcsrBRCMD_DISABLE | (ks10_t::readDCSR() & ~ks10_t::dcsrBRCMD));
            } else if (strncasecmp(argv[1], "match", 2) == 0) {
                ks10_t::writeDCSR(ks10_t::dcsrBRCMD_MATCH   | (ks10_t::readDCSR() & ~ks10_t::dcsrBRCMD));
            } else if (strncasecmp(argv[1], "full", 2) == 0) {
                ks10_t::writeDCSR(ks10_t::dcsrBRCMD_FULL    | (ks10_t::readDCSR() & ~ks10_t::dcsrBRCMD));
            } else if (strncasecmp(argv[1], "both", 2) == 0) {
                ks10_t::writeDCSR(ks10_t::dcsrBRCMD_BOTH    | (ks10_t::readDCSR() & ~ks10_t::dcsrBRCMD));
            } else if (strncasecmp(argv[1], "stat", 2) == 0) {
                printDEBUG();
            } else {
                printf(usage);
                return true;
            }
            break;
        case 3:
            addr = parseOctal(argv[2]);
            if (strncasecmp(argv[1], "fetch", 5) == 0) {
            } else if (strncasecmp(argv[1], "memrd", 5) == 0) {
                ks10_t::writeDBAR(ks10_t::dbarMEMRD | addr);
                ks10_t::writeDBMR(ks10_t::dbmrMEMRD | ks10_t::dbmrMEM);
            } else if (strncasecmp(argv[1], "memwr", 5) == 0) {
                ks10_t::writeDBAR(ks10_t::dbarMEMWR | addr);
                ks10_t::writeDBMR(ks10_t::dbmrMEMWR | ks10_t::dbmrMEM);
            } else if (strncasecmp(argv[1], "iord", 4) == 0) {
                ks10_t::writeDBAR(ks10_t::dbarIORD | addr);
                ks10_t::writeDBMR(ks10_t::dbmrIORD | ks10_t::dbmrIO);
            } else if (strncasecmp(argv[1], "iowr", 4) == 0) {
                ks10_t::writeDBAR(ks10_t::dbarIOWR | addr);
                ks10_t::writeDBMR(ks10_t::dbmrIOWR | ks10_t::dbmrIO);
             } else {
                printf(usage);
                return true;
            }
            break;
        default:
            printf(usage);
    }
    return true;

}


#endif


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

static bool cmdCE(int argc, char *argv[]) {
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
                    break;
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

static bool cmdCP(int argc, char *argv[]) {
    const char *usage =
        "\n"
        "The \"CP[U]\" commands \n"
        "\n"
        "  --reset                           Reset the KS10\n"
        "  --stat[us]                        Display halt status\n"
        "  --cont[inue]                      Continue\n"
        "  --halt                            Halt\n"
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
                        printf("\ncp cache: Cache is %s\n", ks10_t::cacheEnable() ? "enabled" : "disabled");
                    } else {
                        if ((toupper(optarg[0]) == 'D') && (toupper(optarg[1]) == 'I')) {
                            ks10_t::cacheEnable(false);
                            printf("cp cache: cache is disabled\n");
                        } else if ((toupper(optarg[0]) == 'E') && (toupper(optarg[1]) == 'N')) {
                            ks10_t::cacheEnable(true);
                            printf("cp cache: cache is enabled\n");
                        } else {
                            printf("cp cache: option not recognized\n");
                        }
                    }
                    return true;
                case 5: // --timer
                    if (optarg == NULL) {
                        printf("\ncp timer: timer is %s\n", ks10_t::timerEnable() ? "enabled" : "disabled");
                    } else {
                        if ((toupper(optarg[0]) == 'D') && (toupper(optarg[1]) == 'I')) {
                            ks10_t::timerEnable(false);
                            printf("cp timer: timer is disabled\n");
                        } else if ((toupper(optarg[0]) == 'E') && (toupper(optarg[1]) == 'N')) {
                            ks10_t::timerEnable(true);
                            printf("cp timer: timer is enabled\n");
                        } else {
                            printf("cp timer: option not recognized\n");
                        }
                    }
                    return true;
                case 6: // --trap
                    if (optarg == NULL) {
                        printf("\ncp trap: Trap is %s\n", ks10_t::trapEnable() ? "enabled" : "disabled");
                    } else {
                        if ((toupper(optarg[0]) == 'D') && (toupper(optarg[1]) == 'I')) {
                            ks10_t::trapEnable(false);
                            printf("cp trap: trap is disabled\n");
                        } else if ((toupper(optarg[0]) == 'E') && (toupper(optarg[1]) == 'N')) {
                            ks10_t::trapEnable(true);
                            printf("cp trap: trap is enabled\n");
                        } else {
                            printf("cp trap: option not recognized\n");
                        }
                    }
                    return true;
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
                        int num = strtol(optarg, NULL, 0);
                        if (num > 0) {
                            for (int i = 0; i < num; i++) {
                                ks10_t::startSTEP();
                            }
                            printf("cp step: single stepped %d instructions\n", num);
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

static bool cmdCO(int argc, char *argv[]) {
    const char *usage =
        "\n"
        "The \"co\" command continues the KS10. If the KS10 is halted, this command will\n"
        "cause the KS10 to continue execution from the location where is was halted.\n"
        "If the KS10 has been running, the CTY output from the KS10 has been routed to\n"
        "the \"bit-bucket\". Whether the KS10 was halted or not, the command will attach\n"
        "the console to the running KS10 program.\n"
        "\n"
        "If the breakpoint hardware has been \"triggered\", we assume that we halted\n"
        "because of the breakpoint, and this command will \"re-arm\" the breakpoint. See\n"
        "the breakpoint command for more information.\n"
        "\n"
        "Usage: co [--help]\n"
        "\n";

    static const struct option options[] = {
        {"help",    no_argument, 0, 0},  // 0
        {0,         0,           0, 0},  // 1
    };

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

    ks10_t::data_t dcsr = ks10_t::readDCSR();
    if (((dcsr & ks10_t::dcsrBRCMD) == ks10_t::dcsrBRCMD_MATCH) && ((dcsr & ks10_t::dcsrBRSTATE) == ks10_t::dcsrBRSTATE_IDLE)) {
        ks10_t::writeDCSR(ks10_t::dcsrBRCMD_MATCH | dcsr);
        printf("co: re-arming breakpoint\n");
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

static bool cmdCL(int, char *[]) {
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

static bool cmdDA(int argc, char *argv[]) {

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

static bool cmdDP(int argc, char *argv[]) {
    (void)argc;
    (void)argv;
    printf("dp: command not implemented.\n");
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
    (void)argc;
    (void)argv;

    printf("dz config: Not implemented.\n");
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
        "Usage: dz test [--help] command\n"
        "\n"
        "The mt test commands are:\n"
        "   [--help]         Print help.\n"
        "   [--tx port]      Test transmitter. This test will transmit a message out\n"
        "                    selected serial port. Valid values of port is 0-7.\n"
        "   [--rx port]      Test receiver. This test will print the characters\n"
        "                    received  from the selected serial on the console.\n"
        "                    Type ^C to exit. Valid values of port is 0-7.\n"
        "   [--ec[ho] port]  Loopback transmitter to receiver. This will echo characters\n"
        "                    received on the selected serial port back to the associated\n"
        "                    serial transmitter. Type ^C to exit. Valid values of port\n"
        "                    is 0-7.\n"
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
                    if ((*optarg >= '0') && (*optarg <= '7')) {
                        printf("optarg is %c\n", *optarg);
                        dz.testECHO(*optarg - '0');
                    } else {
                        printf("dz test echo: port arguments out of range\n");
                    }
                    return true;
                case 3:
                    if ((*optarg >= '0') && (*optarg <= '7')) {
                        dz.testRX(*optarg - '0');
                    } else {
                        printf("dz test rx: port arguments out of range\n");
                    }
                    return true;
                case 4:
                    if ((*optarg >= '0') && (*optarg <= '7')) {
                        dz.testTX(*optarg - '0');
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

static bool cmdDZ(int argc, char *argv[]) {

    const char *usageTop =
        "\n"
        "The \"dz\" command  provides an interface to configure and test the DZ11\n"
        "hardware.\n"
        "\n"
        "Usage: dz [--help] <command> [<args>]\n"
        "\n"
        "The dz command are:\n"
        "  conf[ig]  Configure the DZ11 device\n"
        "  dump      Dump DZ releated registers\n"
        "  test      Test DZ functionality\n"
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
    } else if (strncasecmp(argv[1], "config", 4) == 0) {
        return cmdDZ_CONF(argc, argv);
    } else if (strncasecmp(argv[1], "dump", 4) == 0) {
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

static bool cmdEX(int argc, char *argv[]) {
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

static bool cmdGO(int argc, char *argv[]) {

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

#if 0
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

    //
    // Load the proper the diagnostic monitor and set boot parameters.
    //

    if (index == 1) {

        ks10_t::writeMem(ks10_t::rhbaseADDR, mt.cfg.baseaddr);
        ks10_t::writeMem(ks10_t::rhunitADDR, mt.cfg.unit);
        ks10_t::writeMem(ks10_t::mtparmADDR, mt.cfg.param);

        printf("go: loading SMMAG.\n");
        if (!loadCode("diag/smmag.sav")) {
            printf("go: failed to load diag/smmag.sav\n");
            return true;;
        }

    } else {

        ks10_t::writeMem(ks10_t::rhbaseADDR, rp.cfg.baseaddr);
        ks10_t::writeMem(ks10_t::rhunitADDR, rp.cfg.unit);

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

static bool cmdHA(int argc, char *argv[]) {
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

static bool cmdHE(int argc, char *argv[]) {

    const char *usage =
        "\n"
        "For information about the command line processor, type:\n"
        "\n"
        "he --cmd[line]\n"
        "\n"
        "When the console is not connected to the KS10 (i.e., KS10> prompt is\n"
        "present) the following commands are available:\n"
        "\n"
        " !: bang - escape to sub-shell or execute sub-program\n"
        " ?: help - print summary of all commands\n"
        "br: breakpoint\n"
        "bt: boot\n"
        "ce: cache enable\n"
        "co: continue after halt\n"
        "da: disassemble memory\n"
        "dz: dz (tty) interface\n"
        "ex: execute a command\n"
        "go: load a program from console and run it\n"
        "ha: halt the processor\n"
        "he: print summary of all commands\n"
        "hs: print halt status word\n"
        "lp: lp (line printer) interface\n"
        "mr: master reset\n"
        "mt: mt (magtape) interface\n"
        "qu: quit the console and exit\n"
        "rd: read memory, IO, and registers\n"
        "rp: rp (disk) interface\n"
        "si: single step instruction\n"
        "sh: shutdown monitor\n"
        "st: start program execution at addres\n"
        "te: system timer enable\n"
        "tp: system traps enable\n"
        "tr: trace buffer control\n"
        "wr: write memory and IO\n"
        "zm: zero memory\n"
        "\n"
        "When the console is connected to a running KS10 program, the following\n"
        "character manipulation is performed by the console:\n"
        "\n"
        "^C is caught and sent to the KS10 monitor program instead of performing\n"
        "   the default \"INTR\" action to the console program.\n"
        "\n"
        "^E will disconnect the console from the running KS10 CTY and escape back to\n"
        "   the \"KS10> \" console prompt. You can re-connect back to the KS10\n"
        "   at any time with the CO command. When you type ^E, the default signal\n"
        "   actions for ^C (QUIT), ^Z (SUSP), and ^\\ (QUIT) characters are restored.\n"
        "\n"
        "   If you want to exit from a running KS10 program program back to the\n"
        "   Linux shell, type \"^E^C\".\n"
        "\n"
        "^L will set the printer on-line. This is useful for the interacting\n"
        "   with the DSLPA diagnostic that keeps settting the printer off-line.\n"
        "\n"
        "^T prints the current program counter, prints the memory contents at the\n"
        "   current program counter, and disassmbles the current instruction. This\n"
        "   command generally satifies my curiousity about \"what\'s it doing?\".\n"
        "   This capability is a hardware enhancement to the KS10 FPGA whereby the\n"
        "   contents of the Program Counter and Instruction Register are available\n"
        "   to the console and and does not require the KS10 to be operating. The\n"
        "   output looks something like:\n"
        "\n"
        "   057713  712153 000010   712 03 0 13 000010      RDIO    3,10(13)\n"
        "\n"
        "   or\n"
        "\n"
        "   021627  606000 000400   606 00 0 00 000400      TRNN    400\n"
        "\n"
        "^Z is caught and sent to the KS10 monitor program instead of performing\n"
        "   the default \"SUSP\" action to the console program.\n"
        "\n"
        "^\\ is caught and sent to the KS10 monitor program instead of performing\n"
        "   the default \"QUIT\" action to the console program.\n"
        "\n"
        "You can type an escape character before the ^E, ^T, and ^L which will send\n"
        "the ^E, ^T, or ^L character to the monitor running on the KS10 instead of\n"
        "performing the operations described above.\n"
        "\n";

    static const struct option options[] = {
        {"cmd",     no_argument, 0, 0},  // 0
        {"cmdline", no_argument, 0, 0},  // 1
        {0,         0,           0, 0},  // 2
    };

    const char *cmdline_usage =
        "\n"
        "The console has a simple command line processor that provides both command\n"
        "recall and command line editing capabilities. The command line editing\n"
        "capabilities should be familiar to individuals with experience with the GNU\n"
        "readline functionality that is used by GNU \"bash\" or with GNU \"emacs\".\n"
        "The basic functionality is:\n"
        "\n"
        "^A  Move the cursor to the beginning of line. This is also attached to the\n"
        "    home key.\n"
        "^B  Move the cursor back one character. This is also attached to the left\n"
        "    arrow key.\n"
        "^D  Delete the character under the cursor. This is also attached to the\n"
        "    delete key.\n"
        "^E  Move the cursor to the end of the line. This is also attached to the end\n"
        "    key\n"
        "^F  Move the cursor forward one character. This is also attached to the right\n"
        "    arrow key.\n"
        "^G  Ring the bell or Alarm.\n"
        "^H  Delete the character under the cursor and move the cursor backward one\n"
        "    character. This is also attached to the backspace key.\n"
        "^K  Erase from the cursor to the end of line.\n"
        "^L  Redraw the command line.\n"
        "^N  Recall next command. This is also attatched to the down arrow key.\n"
        "^P  Recall previous command. This is also attached to the up arrow key.\n"
        "^T  Transpose the character under the cursor with the character preceeding the\n"
        "    cursor.\n"
        "^U  Clear the line.\n";

    //
    // No argument
    //

    if (argc == 1) {
        printf(usage);
        return true;
    }

    opterr = 0;
    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("help: unrecognized option: %s\n", argv[optind-1]);
            return true;
        } else {
            switch (index) {
                case 0:
                case 1:
                    printf(cmdline_usage);
                    return true;
            }
        }
    }

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

static bool cmdHS(int argc, char *argv[]) {

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
//!    Configure LPxx printer
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the argument.
//!
//! \todo
//!    You can't change the serial configuration without recompiling.
//!

static bool cmdLP(int argc, char *argv[]) {

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
        return true;
    }

    if (strncasecmp(argv[1], "--help", 3) == 0) {

        printf(usageTop);

    } else if (strncasecmp(argv[1], "break", 3) == 0) {

        static const ks10_t::addr_t flagPhys = 0x008000000ULL;
        static const ks10_t::addr_t flagIO   = 0x002000000ULL;
        ks10_t::writeDBAR(flagPhys | flagIO | 003775400ULL);            // break on IO operations to
        ks10_t::writeDBMR(flagPhys | flagIO | 017777700ULL);            // range of addresses
        ks10_t::writeDCSR(ks10_t::dcsrBRCMD_MATCH | (ks10_t::readDCSR() & ~ks10_t::dcsrBRCMD));
        printf("lp break: breakpoint set\n");
        return true;

    } else if (strncasecmp(argv[1], "config", 3) == 0) {

        //
        // Print configuration
        //

        static const char *usageConfig =
            "  [--help]      Print help\n"
            "  [--dvfu]      Configure for digital vertical format unit (DVFU)\n"
            "  [--ovfu]      Configure for optical vertical format unit (OVFU)\n"
            "  [--on[line]]  Set printer on-line\n"
            "  [--off[line]] Set printer off-line\n"
            "  [--save]      Save LP configuration\n"
            "\n";

        static const struct option optionsConfig[] = {
            {"help",    no_argument, 0, 0},  // 0
            {"dvfu",    no_argument, 0, 0},  // 1
            {"ovfu",    no_argument, 0, 0},  // 2
            {"on",      no_argument, 0, 0},  // 3
            {"online",  no_argument, 0, 0},  // 4
            {"off",     no_argument, 0, 0},  // 5
            {"offline", no_argument, 0, 0},  // 6
            {"save",    no_argument, 0, 0},  // 7
            {0,         0,           0, 0},  // 8
        };

        if (argc == 2) {

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

            const char *parityTable[] = {"N", "E", "O", "*"};

            unsigned int lpccr = ks10_t::readLPCCR();
            printf("lp print: LP26 #1 Printer Configuration is:\n"
                   "                LPCCR is 0x%08x.\n"
                   "                Vertical Format Unit  : %s\n"
                   "                Printer Status        : %s, %d LPI\n"
                   "                Printer Serial Config : \"%s,%s,%1d,%1d,X\"\n",
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

        opterr = 0;
        for (;;) {
            int index = 0;
            int ret = getopt_long(argc, argv, "", optionsConfig, &index);
            if (ret == -1) {
                break;
            } else if (ret == '?') {
                printf("lp: unrecognized option: %s\n", argv[optind-1]);
                return true;
            } else {
                switch (index) {
                    case 0:
                        printf(usageConfig);
                        return true;
                    case 1:
                        ks10_t::writeLPCCR(ks10_t::readLPCCR() & ~ks10_t::lpOVFU);
                        break;
                    case 2:
                        ks10_t::writeLPCCR(ks10_t::readLPCCR() | ks10_t::lpOVFU);
                        break;
                    case 3:
                    case 4:
                        ks10_t::writeLPCCR(ks10_t::readLPCCR() | ks10_t::lpONLINE);
                        break;
                    case 5:
                    case 6:
                        ks10_t::writeLPCCR(ks10_t::readLPCCR() & ~ks10_t::lpONLINE);
                        break;
                    case 7:
                        lp.saveConfig();
                        break;
                }
            }
        }

    } else if (strncasecmp(argv[1], "dump", 4) == 0) {

        lp.dumpRegs();

    } else if (strncasecmp(argv[1], "print", 3) == 0) {

        if (argc < 3) {
            printf("lp print: missing argument\n");
        } if (argc >= 3) {
            lp.printFile(argv[2]);
            return true;
            if (argc > 3) {
                printf("lp print: additional argument ignored\n");
            }
        }
        return true;

    } else if (strncasecmp(argv[1], "test", 3) == 0) {

        lp.testRegs();
        return true;

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

static bool cmdMR(int argc, char *argv[]) {

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
        "   [--density=density] Set the Magtape density. Valid density arguments are:\n"
        "                       \"800\"  which is 800 BPI NRZ mode, or\n"
        "                       \"1600\" which  is 1600 BPI Phase Encoded mode.\n"
        "                       The default density is \"1600\".\n"
        "   [--diag[nostic]]    Boot to the diagnostic monitor program instead of normal\n"
        "                       monitor.\n"
        "   [--format=format]   Set the Magtape format. Valid format arguments are:\n"
        "                       \"CORE\" which is PDP-10 Core Dump format, or\n"
        "                       \"NORM\" which is PDP-10 Normal Mode format.\n"
        "                       The default format is \"CORE\".\n"
        "   [--slave=slave]     Set the Magtape Slave Device. Each TCU can support 8\n"
        "                       Tape Drives. For now only Slave 0 is implemented. Any\n"
        "                       Any non-zero argument will be rejected and generate an\n"
        "                       error message. The default Slave is 0.\n"
        "   [--tcu=unit]        Set the Magtape Tape Control Unit (TCU). Presumably the\n"
        "                       KS10 could support 8 TCUs (aka formatters; aka TM03s) and\n"
        "                       each TCU could support 8 Tape Drives. For now only TCU 0\n"
        "                       is implemented. Any non-zero argument will be rejected and\n"
        "                       generate an error message. The default TCU is 0.\n"
        "   [--uba=num]         Set the Unibus Adapter (UBA) for the RH11. The default\n"
        "                       value of 3 is the only correct UBA for the MagTape.\n"
        "                       Don\'t change this unless you know what you are doing.\n"
        "                       The default UBA is 3.\n"
        "\n";

    static const struct option options[] = {
        {"help",        no_argument,       0, 0},  //  0
        {"base",        required_argument, 0, 0},  //  1
        {"den",         required_argument, 0, 0},  //  2
        {"density",     required_argument, 0, 0},  //  3
        {"fmt",         required_argument, 0, 0},  //  4
        {"format",      required_argument, 0, 0},  //  5
        {"slv",         required_argument, 0, 0},  //  6
        {"sla",         required_argument, 0, 0},  //  7
        {"slave",       required_argument, 0, 0},  //  8
        {"tcu",         required_argument, 0, 0},  //  9
        {"uba",         required_argument, 0, 0},  // 10
        {"print",       no_argument,       0, 0},  // 11
        {"diag",        no_argument,       0, 0},  // 12
        {"diagnostic",  no_argument,       0, 0},  // 13
        {"diagnostics", no_argument,       0, 0},  // 14
        {0,             0,                 0, 0},  // 15
    };

    static const unsigned int denmask = 003400;
    static const unsigned int fmtmask = 000360;
    static const unsigned int slvmask = 000007;

    static const char *dentxt[] = {
        "Unknown",              // 0
        "800 BPI NRZ",          // 1
        "Unknown",              // 2
        "800 BPI NRZ",          // 3
        "1600 BPI PE",          // 4
        "Unknown",              // 5
        "Unknown",              // 6
        "Unknown",              // 7
    };

    static const char *fmttxt[] = {
        "PDP-10 Core Dump",     //  0
        "PDP-15 Core Dump",     //  1
        "Unknown",              //  2
        "PDP-10 Normal",        //  3
        "Unknown",              //  4
        "Unknown",              //  5
        "Unknown",              //  6
        "Unknown",              //  7
        "Unknown",              //  8
        "Unknown",              //  9
        "PDP-11 Normal",        // 10
        "PDP-11 Core Dump",     // 11
        "PDP-15 Normal",        // 12
        "Unknown",              // 13
        "Unknown",              // 14
        "Unknown",              // 15
    };

    if (argc < 2) {
        printf("mt boot: missing argument\n");
        return true;
    }

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
                    break;
                case 1:
                    // base switch
                    {
                        unsigned long long temp = parseOctal(optarg);
                        mt.cfg.baseaddr = (mt.cfg.baseaddr & 07000000) | (temp & 0777777);
                    }
                    break;
                case 2:
                case 3:
                    // density switch
                    if (strncasecmp(optarg, "800", 3) == 0) {
                        const unsigned int den800 = 3;
                        mt.cfg.param = (mt.cfg.param & ~denmask) | den800 << 8;
                    } else if (strncasecmp(optarg, "1600", 4) == 0) {
                        const unsigned int den1600 = 4;
                        mt.cfg.param = (mt.cfg.param & ~denmask) | den1600 << 8;
                    } else {
                        if (isdigit(*optarg)) {
                            unsigned int temp = strtol(optarg, NULL, 0);
                            if (temp <= 15) {
                                mt.cfg.param = (mt.cfg.param & ~denmask) | temp << 8;
                            } else {
                                printf("mt boot: parameter out of range \'--%s=%s\'\n", options[index].name, optarg);
                            }
                        } else {
                            printf("mt boot: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                        }
                    }
                    break;
                case 4:
                case 5:
                    // format switch
                    if (strncasecmp(optarg, "CORE", 5) == 0) {
                        const unsigned int fcore = 0;
                        mt.cfg.param = (mt.cfg.param & ~fmtmask) | fcore << 4;
                    } else if  (strncasecmp(optarg, "NORM", 5) == 0) {
                        const unsigned int fnorm = 0;
                        mt.cfg.param = (mt.cfg.param & ~fmtmask) | fnorm << 4;
                    } else {
                        if (isdigit(*optarg)) {
                            unsigned int temp = strtol(optarg, NULL, 0);
                            if (temp <= 7) {
                                mt.cfg.param = (mt.cfg.param & ~fmtmask) | temp << 4;
                            } else {
                                printf("mt boot: parameter out of range \'--%s=%s\'\n", options[index].name, optarg);
                            }
                        } else {
                            printf("mt boot: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                        }
                    }
                    break;
                case 6:
                case 7:
                case 8:
                    // slave switch
                    if (isdigit(*optarg)) {
                        unsigned int temp = strtol(optarg, NULL, 0);
                        if (temp <= 7) {
                            mt.cfg.param = (mt.cfg.param & ~slvmask) | temp << 0;
                        } else {
                            printf("mt boot: parameter out of range \'--%s=%s\'\n", options[index].name, optarg);
                        }
                    } else {
                        printf("mt boot: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                    }
                    break;
                case 9:
                    // tcu switch
                    if (*optarg != 0) {
                        printf("mt boot: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                    }
                    mt.cfg.unit = 0;
                    break;
                case 10:
                    // uba switch
                    if ((*optarg == '1') || (*optarg == '3') || (*optarg == '4')) {
                        mt.cfg.baseaddr = (mt.cfg.baseaddr & 0777777) | ((*optarg - '0') << 18);
                    } else {
                        printf("mt boot: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                    }
                    break;
                case 11:
                    // print switch
                    printf("KS10: mt boot: params are:\n"
                           "      UBA     = %o\n"
                           "      BASE    = 0%06o\n"
                           "      TCU     = %o\n"
                           "      DENSITY = %d (%s)\n"
                           "      FORMAT  = %d (%s)\n"
                           "      SLAVE   = %d\n",
                           static_cast<unsigned int>((mt.cfg.baseaddr >> 18) & 0000007),
                           static_cast<unsigned int>((mt.cfg.baseaddr >>  0) & 0777777),
                           static_cast<unsigned int>((mt.cfg.unit     >>  0) & 0000007),
                           (mt.cfg.param & denmask) >> 8, dentxt[(mt.cfg.param & denmask) >> 8],
                           (mt.cfg.param & fmtmask) >> 4, fmttxt[(mt.cfg.param & fmtmask) >> 4],
                           (mt.cfg.param & 07));
                    break;
                case 12:
                case 13:
                case 14:
                    mt.cfg.bootdiag = true;
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
    // Set MT Boot Parameters
    //

    ks10_t::writeMem(ks10_t::rhbaseADDR, mt.cfg.baseaddr);
    ks10_t::writeMem(ks10_t::rhunitADDR, mt.cfg.unit);

    //
    // Set MTCCR
    //

    ks10_t::writeMTCCR(mt.cfg.mtccr);

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

    mt.boot(mt.cfg.unit, mt.cfg.param, mt.cfg.bootdiag);

    return true;
}

//!
//! \brief
//!    Magtape configuration interface
//!
//! \details
//!    The <b>MT CONFIG</b> command is the console interface to the MT device.
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

static bool cmdMT_CONF(int argc, char *argv[]) {

    static const char *usage =
        "\n"
        "The \"mt config\" command allows the Magtape configuration to be set and\n"
        "stored on the file system. On a real system, these controls would be\n"
        "located on the Magtape drive.\n"
        "\n"
        "Presumably the KS10 system could support 8 Tape Formatters (or Tape Control\n"
        "Units (TCUs)) and each Tape Formatter can support 8 Tape Drives. In the\n"
        "KS10 FPGA implementation, only Tape Formatter Unit 0 is supported and is not\n"
        "selectable.  The tape drive is selectable and is commonly called a slave\n"
        "device.\n"
        "\n"
        "The configurations provided with this command is written to the Magatape\n"
        "Console Control Register (MTCCR).\n"
        "\n"
        "Usage: mt config [--help] [--slave=[0-7] <options> [slave=[0-7] <options>]]\n"
        "\n"
        "Valid options are:\n"
        "\n"
        "   [--help]         Print help.\n"
        "   [--dpr={t[rue]|f[alse]}]\n"
        "                    Set the Drive Present status for the selected Tape Drive\n"
        "                    (slave). This setting is reflected in the Drive Present\n"
        "                    bit in the Magtape Drive Status Register (MTDS[DPR]) for\n"
        "                    the selected Tape Drive.\n"
        "   [--mol={t[rue]|f[alse]}]\n"
        "                    Set the Media Online(MOL) status for the selected Tape\n"
        "                    Drive (slave). This setting is reflected in the Media\n"
        "                    On-line bit in the Magtape Drive Status Register\n"
        "                    (MTDS[MOL]) for the selected Tape Drive.\n"
        "   [--wrl={t[rue]|f[alse]}]\n"
        "                    Set Write Lock (WRL) status for the selected Tape Drive\n"
        "                    (slave). This simulates the \"write ring\" function\n"
        "                    that was provided by the tape media. This setting is\n"
        "                    reflected in the Write Lock bit in the Magtape Drive\n"
        "                    Status Register (MTDS[WRL]) for the selected Tape Drive.\n"
        "   [--slave=slave]  Tape Drive (Slave) selection. This parameter must be\n"
        "                    provided before the \'--dpr\', \'--mol\', or \'-wrl\'\n"
        "                    options.  Valid values of slave are 0-7. See example\n"
        "                    below.\n"
        "   [--tcu=unit]     Set the Magtape Tape Control Unit (TCU). Presumably the\n"
        "                    KS10 could support 8 TCUs (aka formatters; aka TM03s) and\n"
        "                    each TCU could support 8 Tape Drives. For now only TCU 0\n"
        "                    is implemented. Any non-zero argument will be rejected and\n"
        "                    generate an error message. The default TCU is 0.\n"
        "   [--save]         Save the configuration to file.\n"
        "\n"
        "Note: The configuration files is \".ks10/mt.cfg\"\n"
        "\n"
        "Example:\n"
        "\n"
        "mt config --slave=0 --dpr=t --mol=t --wrl=t --slave=2 --dpr=f\n"
        "\n"
        "Set Tape Drive 0 to indicate drive present, on-line, and write protected; then\n"
        "set Tape Drive 2 to indicate not present.\n"
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
        {"tcu",     required_argument, 0, 0},  // 10
        {"save",    no_argument,       0, 0},  // 11
        {0,         0,                 0, 0},  // 12
    };

    if (argc == 2) {

        printf("mt boot to diagnostics: %s\n"
               "      mt boot slave is %d\n"
               "      mt parameters are:\n"
               "\n"
               "      UNIT:   DPR MOL WRL BOOT\n",
               mt.cfg.bootdiag ? "true" : "false",
               mt.cfg.param & 7);

        for (int i = 0; i < 8; i++) {
            printf("  %1d :    %c   %c   %c   %c\n", i,
                   ((int)(mt.cfg.mtccr >> (16 + i)) & 1) ? 'X' : ' ',
                   ((int)(mt.cfg.mtccr >> ( 8 + i)) & 1) ? 'X' : ' ',
                   ((int)(mt.cfg.mtccr >> ( 0 + i)) & 1) ? 'X' : ' ',
                   (i == mt.cfg.unit) ? 'X' : ' ');
        }

        printf("\n"
               "      DPR  = Drive Present\n"
               "      MOL  = Media On-Line\n"
               "      WRL  = Write Locked\n"
               "      BOOT = Default Boot Unit\n"
               "\n");

        return true;
    }

    int unit = -1;
    opterr = 0;
    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("mt conf: unrecognized option: %s\n", argv[optind-1]);
            return true;
        } else {
            switch (index) {
                case 0:
                    // conf help switch
                    printf(usage);
                    break;
                case 1:
                case 2:
                case 3:
                    // conf unit switch
                    if (isdigit(*optarg)) {
                        unsigned int temp = strtol(optarg, NULL, 0);
                        if (temp <= 7) {
                            unit = temp;
                        } else {
                            printf("mt conf: parameter out of range \'--%s=%s\'\n", options[index].name, optarg);
                        }
                    } else {
                        printf("mt conf: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                    }
                    break;
                case 4:
                case 5:
                    // conf dpr switch
                    if (unit < 0) {
                        printf("mt conf: unit not specified before \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    if ((*optarg == 'f') || (*optarg == 'F') || (*optarg == '0')) {
                        mt.cfg.mtccr &= ~(1 << (16 + unit));
                    } else if ((*optarg == 't') || (*optarg == 'T') || (*optarg == '1')) {
                        mt.cfg.mtccr |=  (1 << (16 + unit));
                    } else {
                        printf("mt conf: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    ks10_t::writeMTCCR(mt.cfg.mtccr);
                    break;
                case 6:
                case 7:
                    // conf mol switch
                    if (unit < 0) {
                        printf("mt conf: unit not specified before \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    if ((*optarg == 'f') || (*optarg == 'F')|| (*optarg == '0')) {
                        mt.cfg.mtccr &= ~(1 << (8 + unit));
                    } else if ((*optarg == 't') || (*optarg == 'T') || (*optarg == '1')) {
                        mt.cfg.mtccr |=  (1 << (8 + unit));
                    } else {
                        printf("mt conf: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    ks10_t::writeMTCCR(mt.cfg.mtccr);
                    break;
                case 8:
                case 9:
                    // conf wrl switch
                    if (unit < 0) {
                        printf("mt conf: unit not specified before \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    if ((*optarg == 'f')  || (*optarg == 'F') || (*optarg == '0')) {
                        mt.cfg.mtccr &= ~(1 << unit);
                    } else if ((*optarg == 't') || (*optarg == 'T') || (*optarg == '1')) {
                        mt.cfg.mtccr |=  (1 << unit);
                    } else {
                        printf("mt conf: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    ks10_t::writeMTCCR(mt.cfg.mtccr);
                    break;
                case 10:
                    // tcu switch
                    if (*optarg != 0) {
                        printf("mt conf: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                    }
                    mt.cfg.unit = 0;
                    break;
                case 11:
                    // conf save parameter
                    mt.saveConfig();
                    return true;
            }
        }
    }
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
        "   [--fwd]]         Space forward file[s] or records[s].\n"
        "   [--rev]          Space reverse file[s] or records[s].\n"
        "   [--files=param]  Space multiple files per the parameter.\n"
        "   [--recs=param]   Space multiple records per the parameter.\n"
        "\n"
        "Note: Only of of the \"--files\" of \"--rec\" options can be provided. Not both.\n"
        "\n";

    static const struct option options[] = {
        {"help",    no_argument,       0, 0},  // 0
        {"fwd",     no_argument,       0, 0},  // 1
        {"forward", no_argument,       0, 0},  // 2
        {"rev",     no_argument,       0, 0},  // 3
        {"reverse", no_argument,       0, 0},  // 4
        {"files",   required_argument, 0, 0},  // 5
        {"recs",    required_argument, 0, 0},  // 6
        {0,         0,                 0, 0},  // 7
    };

    bool fwdFound   = false;
    bool revFound   = false;
    bool recsFound  = false;
    bool filesFound = false;
    int  recs  = 0;
    int  files = 0;

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
                    break;
                case 1:
                case 2: // --fwd
                    fwdFound = true;
                    break;
                case 3:
                case 4: // --rev
                    revFound = true;
                    break;
                case 5: // --files
                    files = strtol(optarg, NULL, 0);
                    filesFound = true;
                    if (files < 0) {
                        printf("mt space: \"--files\" parameter out of range: %s\n", argv[optind-1]);
                        return true;
                    }
                    break;
                case 6: // --recs
                    recs = strtol(optarg, NULL, 0);
                    recsFound = true;
                    if (files < 0) {
                        printf("mt space: \"--recs\" parameter out of range: %s\n", argv[optind-1]);
                        return true;
                    }
                    break;
            }
        }
    }

    if (fwdFound && revFound) {
        printf("mt space: both \"--fwd\" and \"--rev\" options provided\"\n\n%s", usage);
        return true;
    }

    if (filesFound && recsFound) {
        printf("mt space: both \"--files\" and \"--rec\" options provided\"\n\n%s", usage);
        return true;
    }

    if (revFound) {

        //
        // Space reverse
        //

        if (filesFound) {
            for (int i = 0; i < files; i++) {
                mt.cmdSpaceRev(mt.cfg.param, 0);
            }
        } else {
            if (recsFound) {
                mt.cmdSpaceRev(mt.cfg.param, recs);
            } else {
                mt.cmdSpaceRev(mt.cfg.param, 1);
            }
        }

    } else {

        //
        // Space Forward
        //

        if (filesFound) {
            for (int i = 0; i < files; i++) {
                mt.cmdSpaceFwd(mt.cfg.param, 0);
            }
        } else {
            if (recsFound) {
                mt.cmdSpaceFwd(mt.cfg.param, recs);
            } else {
                mt.cmdSpaceFwd(mt.cfg.param, 1);
            }
        }
    }

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
        "Usage: mt test [--help] command\n"
        "\n"
        "The mt test commands are:\n"
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
        "\n";

    static const struct option options[] = {
        {"help",   no_argument, 0, 0},  // 0
        {"dump",   no_argument, 0, 0},  // 1
        {"fifo",   no_argument, 0, 0},  // 2
        {"init",   no_argument, 0, 0},  // 3
        {"reset",  no_argument, 0, 0},  // 4
        {"read",   no_argument, 0, 0},  // 5
        {"write",  no_argument, 0, 0},  // 6
        {"writ",   no_argument, 0, 0},  // 7
        {"wrchk",  no_argument, 0, 0},  // 8
        {"rewind", no_argument, 0, 0},  // 9
        {"preset", no_argument, 0, 0},  // 10
        {"unload", no_argument, 0, 0},  // 11
        {0,        0,           0, 0},  // 12
    };

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
                    break;
                case 1:
                    mt.dumpRegs();
                    break;
                case 2:
                    mt.testFIFO();
                    break;
                case 3:
                    mt.testInit(mt.cfg.param);
                    break;
                case 4:
                    printf("mt test: Reset not implemented yet\n");
                    //                      mt.reset(mt.cfg.param);
                    break;
                case 5:
                    mt.testRead(mt.cfg.param);
                    break;
                case 6:
                case 7:
                    mt.testWrite(mt.cfg.param);
                    break;
                case 8:
                    mt.testWrchk(mt.cfg.param);
                    break;
                case 9:
                    mt.cmdRewind(mt.cfg.param);
                    break;
                case 10:
                    mt.cmdPreset(mt.cfg.param);
                    break;
                case 11:
                    mt.cmdUnload(mt.cfg.param);
                    break;
            }
        }
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

static bool cmdMT(int argc, char *argv[]) {

    //
    // Top level options and help
    //

    static const char *usageTop =
        "\n"
        "The mt command provides an interface to configure and test the Magtape\n"
        "hardware.\n"
        "\n"
        "Usage: mt [--help] <command> [<args>]\n"
        "\n"
        "The mt commands are:\n"
        "  boot      Boot from Magtape devices\n"
        "  config    Configure Magtape\n"
        "  dismount  Dismount the Magtape\n"
        "  dump      Dump MT related registers\n"
        "  preset    Preset the Magtape\n"
        "  reset     Reset the Magtape hardware\n"
        "  rewind    Rewind the Magtape\n"
        "  space     Skip records on the Magtape\n"
        "  stat      Print MT status\n"
        "  test      Test MT functionality\n"
        "  unload    Unload the Magtape\n"
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
        return cmdMT_BOOT(argc, argv);
    } else if (strncasecmp(argv[1], "conf", 4) == 0) {
        return cmdMT_CONF(argc, argv);
    } else if (strncasecmp(argv[1], "dismount", 4) == 0) {
        mt.cmdUnload(mt.cfg.param);
    } else if (strncasecmp(argv[1], "dump", 4) == 0) {
        mt.dumpRegs();
    } else if (strncasecmp(argv[1], "preset", 4) == 0) {
        mt.cmdPreset(mt.cfg.param);
    } else if (strncasecmp(argv[1], "reset", 4) == 0) {
        mt.clear();
    } else if (strncasecmp(argv[1], "rewind", 4) == 0) {
        mt.cmdRewind(mt.cfg.param);
    } else if (strncasecmp(argv[1], "space", 4) == 0) {
        return cmdMT_SPACE(argc, argv);
    } else if (strncasecmp(argv[1], "stat", 4) == 0) {
        ks10_t::printMTDEBUG();
    } else if (strncasecmp(argv[1], "test", 4) == 0) {
        return cmdMT_TEST(argc, argv);
    } else if (strncasecmp(argv[1], "unload", 4) == 0) {
        mt.cmdUnload(mt.cfg.param);
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

static bool cmdQU(int /*argc*/, char */*argv*/[]) {

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

static bool cmdRD(int argc, char *argv[]) {
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
        printPCIR(ks10_t::readDITR());
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
        "   [--uba=num]       Set the Unibus Adapter (UBA) for the RH11. The default\n"
        "                     value of 3 is the only correct UBA for the disk.\n"
        "                     Don\'t change this unless you know what you are doing.\n"
        "                     The default UBA is 3.\n"
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
                    break;
                case 1:
                    // base switch
                    {
                        unsigned long long temp = parseOctal(optarg);
                        rp.cfg.baseaddr = (rp.cfg.baseaddr & 07000000) | (temp & 0777777);
                        printf("Base = 0%08llo\n", temp);
                    }
                    break;
                case 2:
                    // uba switch
                    if ((*optarg == '1') || (*optarg == '3') || (*optarg == '4')) {
                        rp.cfg.baseaddr = (rp.cfg.baseaddr & 0777777) | ((*optarg - '0') << 18);
                        printf("UBA = %d\n", (*optarg - '0'));
                    } else {
                        printf("rp boot: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                    }
                    break;
                case 3:
                    // unit switch
                    if (isdigit(*optarg)) {
                        unsigned int temp = strtol(optarg, NULL, 0);
                        if (temp <= 7) {
                            rp.cfg.unit = temp;
                            printf("UNIT = %d\n", temp);
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
                           static_cast<unsigned int>((rp.cfg.baseaddr >> 18) & 0000007),
                           static_cast<unsigned int>((rp.cfg.baseaddr >>  0) & 0777777),
                           static_cast<unsigned int>((rp.cfg.unit     >>  0) & 0000007));
                    break;
                case 5:
                case 6:
                case 7:
                    rp.cfg.bootdiag = true;
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

    ks10_t::writeMem(ks10_t::rhbaseADDR, rp.cfg.baseaddr);
    ks10_t::writeMem(ks10_t::rhunitADDR, rp.cfg.unit);

    //
    // Set RPCCR
    //

    ks10_t::writeRPCCR(rp.cfg.rpccr);

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

    rp.boot(rp.cfg.unit, rp.cfg.bootdiag);

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
        "   [--bootdiag={t[rue]|f[alse]}]\n"
        "                    Set default boot image type. If false, the default boot\n"
        "                    process will be to the normal monitor, otherwise if true,\n"
        "                    the system will boot to the diagnostic monitor. This\n"
        "                    default can be overwritten by the boot command.\n"
        "   [--bootunit]     Set default disk drive for booting. This default can be\n"
        "                    overwritten by the boot command.\n"
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
        "   [--save]         Save the configuration to file.\n"
        "Note: The configuration files is \".ks10/rp.cfg\"\n"
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
        {"help",     no_argument,       0, 0},  //  0
        {"unit",     required_argument, 0, 0},  //  1
        {"dpr",      required_argument, 0, 0},  //  2
        {"present",  required_argument, 0, 0},  //  3
        {"mol",      required_argument, 0, 0},  //  4
        {"online",   required_argument, 0, 0},  //  5
        {"wrl",      required_argument, 0, 0},  //  6
        {"wprot",    required_argument, 0, 0},  //  7
        {"save",     no_argument,       0, 0},  //  8
        {"bootunit", no_argument,       0, 0},  //  9
        {"bootdiag", required_argument, 0, 0},  // 10
        {0,          0,                 0, 0},  // 11
    };

    //
    // Print configuration
    //

    if (argc == 2) {
        printf("rp boot to diagnostics: %s\n"
               "      rp parameters are:\n"
               "\n"
               "      UNIT:   DPR MOL WRL BOOT\n",
               rp.cfg.bootdiag ? "true" : "false");

        for (int i = 0; i < 8; i++) {
            printf("  %1d :    %c   %c   %c   %c\n", i,
                   ((int)(rp.cfg.rpccr >> (16 + i)) & 1) ? 'X' : ' ',
                   ((int)(rp.cfg.rpccr >> ( 8 + i)) & 1) ? 'X' : ' ',
                   ((int)(rp.cfg.rpccr >> ( 0 + i)) & 1) ? 'X' : ' ',
                   (i == rp.cfg.unit) ? 'X' : ' ');
        }

        printf("\n"
               "      DPR  = Drive Present\n"
               "      MOL  = Media On-Line\n"
               "      WRL  = Write Locked\n"
               "      BOOT = Default Boot Unit\n"
               "\n");

        return true;
    }

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
                    if (isdigit(*optarg)) {
                        unsigned int temp = strtol(optarg, NULL, 0);
                        if (temp <= 7) {
                            unit = temp;
                        } else {
                            printf("rp: parameter out of range \'--%s=%s\'\n", options[index].name, optarg);
                        }
                    } else {
                        printf("rp: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                    }
                    printf("Unit = %d\n", unit);
                    break;
                case 2:
                case 3:
                    // conf dpr switch
                    if (unit < 0) {
                        printf("rp boot: unit not specified before \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    if ((*optarg == 'f') || (*optarg == '0')) {
                        rp.cfg.rpccr &= ~(1 << (16 + unit));
                    } else if ((*optarg == 't') || (*optarg == '1')) {
                        rp.cfg.rpccr |=  (1 << (16 + unit));
                    } else {
                        printf("rp: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    ks10_t::writeRPCCR(rp.cfg.rpccr);
                    printf("DPR\n");
                    break;
                case 4:
                case 5:
                    // conf mol switch
                    if (unit < 0) {
                        printf("rp boot: unit not specified before \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    if ((*optarg == 'f') || (*optarg == '0')) {
                        rp.cfg.rpccr &= ~(1 << (8 + unit));
                    } else if ((*optarg == 't') || (*optarg == '1')) {
                        rp.cfg.rpccr |=  (1 << (8 + unit));
                    } else {
                        printf("rp: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    ks10_t::writeRPCCR(rp.cfg.rpccr);
                    printf("MOL\n");
                    break;
                case 6:
                case 7:
                    // conf wrl switch
                    if (unit < 0) {
                        printf("rp boot: unit not specified before \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    if ((*optarg == 'f') || (*optarg == '0')) {
                        rp.cfg.rpccr &= ~(1 << unit);
                    } else if ((*optarg == 't') || (*optarg == '1')) {
                        rp.cfg.rpccr |=  (1 << unit);
                    } else {
                        printf("rp: unrecognized option \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    ks10_t::writeRPCCR(rp.cfg.rpccr);
                    printf("WRL\n");
                    break;
                case 8:
                    // conf save parameter
                    rp.saveConfig();
                    return true;
                case 9:
                    // bootunit parameter
                    if (unit < 0) {
                        printf("rp boot: unit not specified before \'--%s=%s\'\n", options[index].name, optarg);
                        return true;
                    }
                    rp.cfg.unit = unit;
                    break;
                case 10:
                    // bootdiag parameter
                    if ((*optarg == 'f') || (*optarg == '0')) {
                        rp.cfg.bootdiag = false;
                    } else if ((*optarg == 't') || (*optarg == '1')) {
                        rp.cfg.bootdiag = true;
                    }
                    break;
            }
        }
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
        "The \"rp test\" command performs various tests on the RH11, TM03, and\n"
        "TU45 that are attached to the KS10.\n"
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
                    break;
                case 1:
                    rp.dumpRegs();
                    break;
                case 2:
                    rp.testFIFO();
                    break;
                case 3:
                    rp.testInit(rp.cfg.unit);
                    break;
                case 4:
                    rp.clear();
                    break;
                case 5:
                    rp.testRead(rp.cfg.unit);
                    break;
                case 6:
                    rp.testWrite(rp.cfg.unit);
                    break;
                case 7:
                    rp.testWrchk(rp.cfg.unit);
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

static bool cmdRP(int argc, char *argv[]) {

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
        "  boot    Boot from RP devices\n"
        "  config  Configure RP devices\n"
        "  dump    Dump RP related registers\n"
        "  reset   Reset the RP hardware\n"
        "  stat    Print RP status\n"
        "  test    Test RP functionality\n"
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
        ks10_t::printRPDEBUG();
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

static bool cmdSI(int argc, char *argv[]) {
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
        printf("si: single stepped\n");
    } else if (argc >= 2) {
        unsigned int num = parseOctal(argv[1]);
        for (unsigned int i = 0; i < num; i++) {
            ks10_t::startSTEP();
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

static bool cmdSH(int argc, char *argv[]) {
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

static bool cmdST(int argc, char *argv[]) {
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

static bool cmdTE(int argc, char *argv[]) {
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
                    break;
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

static bool cmdTP(int argc, char *argv[]) {
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
                    break;
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

static bool cmdTR(int argc, char *argv[]) {
    static const char *usage =
        "\n"
        "Control the instruction trace hardware.\n"
        "Usage: TR {RESET TRIG MATCH SINGLE DUMP}\n"
        "       TR RESET  : disables trace and flush the trace buffer\n"
        "       TR TRIG   : trigger trace immediately\n"
        "       TR MATCH  : trigger trace on address match\n"
        "       TR STOP   : stop acquiring trace data\n"
        "       TR STAT   : display instruction trace registers\n"
        "       TR DUMP   : print the contents of the trace buffer\n"
        "\n";

    static const char *header =
        "Dump of Trace Buffer:\n"
        "Entry\t  PC  \tOPC AC I XR   EA  \n"
        "-----\t------\t--- -- - -- ------\n";

    switch (argc) {
        case 1:
            printf("Debug Control/Status Register     : %012o\n", ks10_t::readDCSR());
            printf("Debug Instruction Trace Register  : %018llo\n", ks10_t::readDITR());
            printf(usage);
            break;
        case 2:
            if (strncasecmp(argv[1], "reset", 2) ==   0) {
                ks10_t::writeDCSR(ks10_t::dcsrTRCMD_RESET | (ks10_t::readDCSR() & ~ks10_t::dcsrTRCMD));
            } else if (strncasecmp(argv[1], "trig",   2) == 0) {
                ks10_t::writeDCSR(ks10_t::dcsrTRCMD_TRIG  | (ks10_t::readDCSR() & ~ks10_t::dcsrTRCMD));
            } else if (strncasecmp(argv[1], "match",  2) == 0) {
               ks10_t::writeDCSR(ks10_t::dcsrTRCMD_MATCH  | (ks10_t::readDCSR() & ~ks10_t::dcsrTRCMD));
            } else if (strncasecmp(argv[1], "stop",   4) == 0) {
               ks10_t::writeDCSR(ks10_t::dcsrTRCMD_STOP   | (ks10_t::readDCSR() & ~ks10_t::dcsrTRCMD));
            } else if (strncasecmp(argv[1], "stat",   4) == 0) {
                printDEBUG();
            } else if (strncasecmp(argv[1], "dump",   4) == 0) {
                // Disable further trace acquisition
                ks10_t::writeDCSR(ks10_t::dcsrTRCMD_STOP  | (ks10_t::readDCSR() & ~ks10_t::dcsrTRCMD));
                printf(header);
                for (int i = 0; (ks10_t::readDCSR() & ks10_t::dcsrEMPTY) != ks10_t::dcsrEMPTY; i++) {
                    printf("%5d\t", i);
                    printPCIR(ks10_t::readDITR());
                }
                printf("Trace Finished\n");
            } else {
                printf(usage);
            }
            break;
        default:
            printf(usage);
            break;
    }
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

static bool cmdWR(int argc, char *argv[]) {
    const char *usage =
        "\n"
        "The \"wr\" command writes to memory or Unibus IO.\n"
        "\n"
        "Usage: wr [--help] <io addr data> | <mem addr data>\n"
        "\n";

    static const struct option options[] = {
        {"help",  no_argument, 0, 0},  // 0
        {0,       0,           0, 0},  // 1
    };

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

static bool cmdZM(int argc, char *argv[]) {

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

static bool cmdZZ(int argc, char *argv[]) {

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

bool executeCommand(char * buf) {

    //
    // List of Commands
    //

    struct cmdList_t {
        const char * name;
        bool (*function)(int argc, char *argv[]);
    };

    static const cmdList_t cmdList[] = {
        {"!",  cmdBA},          // Bang
        {"?",  cmdHE},          // Help
        {"BR", cmdBR},          // Breakpoint
        {"CE", cmdCE},          // Cache enable
        {"CO", cmdCO},          // Continue
        {"CL", cmdCL},          // Clear screen
        {"CP", cmdCP},          // CPU
        {"DA", cmdDA},          // Disassemble
        {"DP", cmdDP},          // DUP11 Test
        {"DZ", cmdDZ},          // DZ11 Test
        {"EX", cmdEX},          // Execute
        {"GO", cmdGO},          // GO
        {"HA", cmdHA},          // Halt
        {"HE", cmdHE},          // Help
        {"HS", cmdHS},          // Halt status
        {"LP", cmdLP},          // LPxx configuration
        {"MR", cmdMR},
        {"MT", cmdMT},          // Magtape boot
        {"QU", cmdQU},          // Quit
        {"RD", cmdRD},          // Simple memory read
        {"RP", cmdRP},          // RPxx Configuration
        {"SH", cmdSH},
        {"SI", cmdSI},
        {"ST", cmdST},
        {"TE", cmdTE},
        {"TP", cmdTP},
        {"TR", cmdTR},          // Trace
        {"WR", cmdWR},          // Simple memory write
        {"ZM", cmdZM},          // Zero memory
        {"ZZ", cmdZZ},          // Testing
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
                    ret = (*cmdList[i].function)(argc, argv);
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
