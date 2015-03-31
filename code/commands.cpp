//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! Console commands
//!
//! All of the console commands are implemented in this file.
//!
//! \file
//!    commands.cpp
//!
//! \author
//!    Rob Doyle - doyle (at) cox (dot) net
//
//******************************************************************************
//
// Copyright (C) 2013-2015 Rob Doyle
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//
//******************************************************************************

#include <ctype.h>
#include <stdint.h>
#include <string.h>

#include "sd.h"
#include "stdio.h"
#include "ks10.hpp"
#include "commands.hpp"
#include "fatfslib/dir.h"
#include "fatfslib/ff.h"
#include "driverlib/rom.h"
#include "driverlib/sysctl.h"

//
// Debug macro
//

#define DEBUG

#ifdef DEBUG
#define debug(...) printf(__VA_ARGS__)
#else
#define debug(...)
#endif

//
// Current address set by cmdLI or cmdLA
//

static ks10_t::addr_t address;

//
// Memory or IO address
//

static enum access_t {
    accessMEM = 0,              //!< KS10 Memory Access
    accessIO,                   //!< KS10 IO Access
} access;

//
//! Parses an octal number from the command line
//!
//! \param [in] buf
//!     Pointer to line buffer.
//!
//! \returns
//!     Number
//

static ks10_t::data_t parseOctal(const char *buf) {

    ks10_t::data_t num = 0;

    for (int i = 0; i < 64; i += 3) {
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

//
//! This function builds a 36-bit data word from the contents of the .SAV file.
//!
//! \param
//!     b is a pointer to the input data
//!
//! \returns
//!     36-bit data word
//!

ks10_t::data_t rdword(const uint8_t *b) {
    return (((ks10_t::data_t)b[0] << 28) |
            ((ks10_t::data_t)b[1] << 20) |
            ((ks10_t::data_t)b[2] << 12) |
            ((ks10_t::data_t)b[3] <<  4) |
            ((ks10_t::data_t)b[4] <<  0));
}

//
//! Read the PDP10 .SAV file
//!
//! This function reads 5-byte buffers from the FAT filesytems and converts the
//! data into PDP10 words.
//!
//! \param [in] fp
//!     file pointer
//!
//! \pre
//!     The filesystem must be mounted and the file must be opened.
//!
//! \returns
//!     a 36-bit PDP10 word
//!
//! \note
//!     The .SAV file should be a multiple of 5 bytes in size.
//

ks10_t::data_t getdata(FIL *fp) {

    uint8_t buffer[5];
    unsigned int numbytes;

    FRESULT status = f_read(fp, buffer, sizeof(buffer), &numbytes);
    if (status != FR_OK) {
        debug("f_read() returned %d\n", status);
    }

    return rdword(buffer);
}

//
//! Load code into the KS10
//!
//! This function reads the .SAV file and writes the contents to to the KS10.
//!
//! \param [in] filename
//!     filename of the .SAV file
//!
//! \note
//!     This function sets the starting address in the Console Instruction
//!     Register with the starting address contained in the .SAV file.
//

static bool loadCode(const char * filename) {

    FIL fp;
    FRESULT status = f_open(&fp, filename, FA_READ);
    if (status != FR_OK) {
        debug("f_open() returned %d\n", status);
        return false;
    }

    for (;;) {

        //
        // The data36 format is:  -n,,a-1
        //

        ks10_t::data_t data36 = getdata(&fp);
        unsigned int words    = ks10_t::lh(data36);
        unsigned int addr     = ks10_t::rh(data36);

        //
        // Check for end
        //

        if ((words & 0400000) == 0) {
            if (words == ks10_t::opJRST) {

                //
                // Create JRST to starting address.
                //

                debug("Starting Address: %06lo,,%06lo\n", ks10_t::lh(data36), ks10_t::rh(data36));
                ks10_t::writeRegCIR(data36);
            }
            FRESULT status = f_close(&fp);
            if (status != FR_OK) {
                debug("f_close() returned %d\n", status);
            }
            return true;
        }

        //
        // Read record
        //

        while ((words & 0400000) != 0) {
            ks10_t::data_t data36 = getdata(&fp);
            ks10_t::writeMem(addr, data36);
            debug("%06o: %06lo%06lo\n", addr, ks10_t::lh(data36), ks10_t::rh(data36));
            addr  = (addr  + 1) & 0777777;
            words = (words + 1) & 0777777;
        }
    }
}

//
//! Print RH11 Debug Word
//

void printRH11Debug(void) {
    volatile ks10_t::rh11debug_t * rh11debug = ks10_t::getRH11debug();
    printf("KS10> RH11 Status summary: 0x%016llx\n"
           "KS10>   State  = %d\n"
           "KS10>   Err    = %d\n"
           "KS10>   Val    = %d\n"
           "KS10>   WrCnt  = %d\n"
           "KS10>   RdCnt  = %d\n"
           "KS10>   Res1   = 0x%02x\n"
           "KS10>   Res2   = 0x%02x\n"
           "KS10>   Status = 0x%02x\n"
           "",
           *reinterpret_cast<volatile uint64_t*>(rh11debug),
           rh11debug->state,
           rh11debug->err,
           rh11debug->val,
           rh11debug->wrcnt,
           rh11debug->rdcnt,
           rh11debug->res1,
           rh11debug->res2,
           rh11debug->status);
}

//
//! Print Halt Status
//!
//! This function prints the Halt Status Word and the Halt Status Block.
//!
//! \todo
//!     The microcode doesn't seem to store the FE/SC registers like the
//!     documents describe.   Delete it?
//!
//! \todo
//!     This has the Halt Status Block address hard coded.  It should execute
//!     a RDHSB instruction using the Console Instruction Register to get the
//!     address of the Halt Status Block.   The 0376000 address is only valid
//!     until TOPS10 or TOPS20 changes it.
//

void printHaltStatus(void) {

    //
    // Retreive the Halt Status Word
    //

    const ks10_t::haltStatusWord_t haltStatusWord = ks10_t::getHaltStatusWord();

    //
    // Halt Status Block address.  Assume default location.
    //

    ks10_t::addr_t hsbAddr = 0376000;

#warning FIXME: Stubbed code
#if 0

    //
    // We need a temporary memory location to stash the address of the Halt
    // Status Block by executing a RDHSB instruction.
    //

    const ks10_t::addr_t tempAddr = 0100;

    //
    // Save the data at that location so that it may be restored later.
    //

    const ks10_t::data_t tempData = ks10_t::readMem(tempAddr);

    //
    // Load an RDHSB instruction into the CIR.
    //

    ks10_t::writeRegCIR((ks10_t::opRDHSB << 18) | tempAddr);

    //
    // Execute the RDHSB instruction
    //

    ks10_t::cont(true);
    ks10_t::exec(true);
    ks10_t::run(false);

    //
    // Wait for the processor to HALT again.
    //

    while (!ks10_t::halt()) {
        ;
    }

    //
    // Read the address of the Halt Status Block from location 0
    //

    hsbAddr = ks10_t::readMem(tempAddr);

    //
    // Restore the data at the temporary location.
    //

    ks10_t::writeMem(tempAddr, tempData);

#endif

    //
    // Retreive and print the Halt Status Block
    //

    const ks10_t::haltStatusBlock_t haltStatusBlock = ks10_t::getHaltStatusBlock(hsbAddr);

    printf("KS10> Halt Cause: %s (PC=%012llo, A=%06llo)\n"
           "KS10>   PC  is %012llo     MAG is %012llo\n"
           "KS10>   PC  is %012llo     HR  is %012llo\n"
           "KS10>   AR  is %012llo     ARX is %012llo\n"
           "KS10>   BR  is %012llo     BRX is %012llo\n"
           "KS10>   ONE is %012llo     EBR is %012llo\n"
           "KS10>   UBR is %012llo     MSK is %012llo\n"
           "KS10>   FLG is %012llo     PI  is %012llo\n"
           "KS10>   X1  is %012llo     TO  is %012llo\n"
           "KS10>   T1  is %012llo     VMA is %012llo\n"
           "KS10>   FE  is %012llo                   \n",
           (haltStatusWord.status == 00000 ? "Microcode Startup."                     :
            (haltStatusWord.status == 00001 ? "Halt Instruction."                     :
             (haltStatusWord.status == 00002 ? "Console Halt."                        :
              (haltStatusWord.status == 00100 ? "IO Page Failure."                    :
               (haltStatusWord.status == 00101 ? "Illegal Interrupt Instruction."     :
                (haltStatusWord.status == 00102 ? "Pointer to Unibus Vector is zero." :
                 (haltStatusWord.status == 01000 ? "Illegal Microcode Dispatch."      :
                  (haltStatusWord.status == 01005 ? "Microcode Startup Check Failed." :
                   "Unknown.")))))))),
           haltStatusWord.status,
           hsbAddr,
           haltStatusWord.pc,
           haltStatusBlock.mag,
           haltStatusBlock.pc,
           haltStatusBlock.hr,
           haltStatusBlock.ar,
           haltStatusBlock.arx,
           haltStatusBlock.br,
           haltStatusBlock.brx,
           haltStatusBlock.one,
           haltStatusBlock.ebr,
           haltStatusBlock.ubr,
           haltStatusBlock.mask,
           haltStatusBlock.flg,
           haltStatusBlock.pi,
           haltStatusBlock.x1,
           haltStatusBlock.t0,
           haltStatusBlock.t1,
           haltStatusBlock.vma,
           haltStatusBlock.fe);
}

//
//! Boot System
//!
//! The <b>BT</b> (Boot) command loads code into KS10 memory and starts
//! execution.
//!
//! If a filename is supplied as an argument, the <b>BT</b> command will
//! attempt to load a file from the SD Card of that filename.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//

static void cmdBT(int argc, char *argv[]) {
    const char *usage =
        "Usage: BT [filename]\n"
        "Load boot software into the KS10 processor.\n";

    if (argc == 2) {
        ks10_t::cacheEnable(true);
        ks10_t::trapEnable(true);
        ks10_t::timerEnable(true);
        if (!loadCode(argv[1])) {
            printf("Unable to open file \"%s\".\n", argv[1]);
        }
        ks10_t::run(true);
    } else {
        printf(usage);
    }
}

//
//! Cache Enable
//!
//! The <b>CE</b> (Cache Enable) command controls the operation the KS10's
//! cache.
//!
//! - The <b>CE 0</b> command will disable the KS10's cache.
//! - The <b>CE 1</b> command will enable the KS10's cache.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//

static void cmdCE(int argc, char *argv[]) {
    const char *usage =
        "Usage: CE {0 | 1}\n"
        "Control the operation of the KS10 cache.\n"
        "\n"
        "CE 0 : disable cache\n"
        "CE 1 : enable cache\n";

    if (argc == 1) {
        printf("The cache is currently %s.\n",
               ks10_t::cacheEnable() ? "enabled" : "disabled");
    } else if (argc == 2) {
        if (*argv[1] == '0') {
            printf("The cache is disabled.\n");
            ks10_t::cacheEnable(false);
        } else if (*argv[1] == '1') {
            printf("The cache is enabled.\n");
            ks10_t::cacheEnable(true);
        } else {
            printf(usage);
        }
    } else {
        printf(usage);
    }
}

//
//! Continue
//!
//! The <b>CO</b> (Continue) command causes the KS10 to exit the <b>HALT</b>
//! state and continue operation.
//!
//! \sa cmdHA, cmdSI
//!
//! \param [in] argc
//!    Number of arguments.
//

static void cmdCO(int argc, char *[]) {
    const char *usage =
        "Usage: CO\n"
        "Continue the KS10 from the HALT state.\n";

    if (argc == 1) {
        ks10_t::cont();
    } else {
        printf(usage);
    }
}

//
//! Deposit IO
//!
//! The <b>DI</b> (Deposit IO) deposits data into the IO address previously
//! loaded by the <b>LA</b> (Load Address) command.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//

static void cmdDI(int argc, char *argv[]) {
    access = accessIO;
    const char *usage =
        "Usage: DI data.\n"
        "Deposit the data argument at the IO address previously supplied by\n"
        "the Load IO Address (LI) command\n";

    if (argc == 2) {
        ks10_t::data_t data = parseOctal(argv[1]);
        ks10_t::writeIO(address, data);
        if (ks10_t::nxmnxd()) {
            printf("Write failed. (NXD)\n");
        }
    } else {
        printf(usage);
    }
}

//
//! Deposit Memory
//!
//! The <b>DM</b> (Deposit Memory) deposits data into the memory address
//! previously loaded by the <b>LA</b> (Load Address) command.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//

static void cmdDM(int argc, char *argv[]) {
    access = accessMEM;
    const char *usage =
        "Usage: DM data.\n"
        "Deposit the data argument at the memory address previously supplied\n"
        "by the Load Address (LA) command\n";

    if (argc == 2) {
        ks10_t::data_t data = parseOctal(argv[1]);
        ks10_t::writeMem(address, data);
        if (ks10_t::nxmnxd()) {
            printf("Write failed. (NXM)\n");
        }
    } else {
        printf(usage);
    }
}

//!
//! Deposit Next
//!
//! The <b>DN</b> (Deposit Next) command deposits data into the next memory
//! or IO address depending on the last <b>DM</b> or <b>DI</b> command.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//

static void cmdDN(int argc, char *argv[]) {
    address += 1;
    const char *usage =
        "Usage: DN data.\n"
        "Deposit the data argument at the next memory address or IO address.\n";

    if (argc == 2) {
        ks10_t::data_t data = parseOctal(argv[1]);
        if (access == accessMEM) {
            ks10_t::writeMem(address, data);
            if (ks10_t::nxmnxd()) {
                printf("Write failed. (NXM)\n");
            }
        } else {
            ks10_t::writeIO(address, data);
            if (ks10_t::nxmnxd()) {
                printf("Write failed. (NXD)\n");
            }
        }
    } else {
        printf(usage);
    }
}

//!
//! Disk Select
//!
//! The <b>DS</b> (Disk Select) select the Unit, Unibus Adapter to load when
//!  booting.
//

static void cmdDS(int, char *[]) {
    printf("DS Command is not implemented, yet.\n");
}

//
//! Examine IO
//!
//! The <b>EI</b> (Examine IO) command reads from the last IO address
//! specified.
//!
//! \param [in] argc
//!    Number of arguments.
//

static void cmdEI(int argc, char *[]) {
    access = accessIO;
    const char *usage =
        "Usage: EI\n"
        "Examine data from the last IO address.\n";

    if (argc == 1) {
        if (ks10_t::nxmnxd()) {
            printf("IO read failed. (NXD)\n");
        } else {
            printf("%012llo\n", ks10_t::readIO(address));
        }
    } else {
        printf(usage);
    }
}

//
//! Examine Memory
//!
//! The <b>EM</b> (Examine Memory) command reads from the last memory address
//! specified.
//!
//! \sa cmdLA, cmdEI, cmdEN
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//

static void cmdEM(int argc, char *[]) {
    access = accessMEM;
    const char *usage =
        "Usage: EM\n"
        "Examine data from the last memory address.\n";

    if (argc == 1) {
        ks10_t::data_t data = ks10_t::readMem(address);
        if (ks10_t::nxmnxd()) {
            printf("Memory read failed. (NXM)\n");
        } else {
            printf("%012llo\n", data);
        }
    } else {
        printf(usage);
    }
}

//
//! Examine Next
//!
//! The <b>EN</b> (Examine Next) command reads from next IO or memory address.
//!
//! \sa cmdLA, cmdEI, cmdEM, cmdEN
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//

static void cmdEN(int argc, char *[]) {
    const char *usage =
        "Usage: EN\n"
        "Examine data from the next memory or IO address.\n";

    if (argc == 1) {
        address += 1;
        printf("incremented address to %06llo\n", address);
        if (access == accessMEM) {
            if (ks10_t::nxmnxd()) {
                printf("Memory read failed. (NXM)\n");
            } else {
                printf("%012llo\n", ks10_t::readMem(address));
            }
        } else {
            if (ks10_t::nxmnxd()) {
                printf("IO read failed. (NXD)\n");
            } else {
                printf("%012llo\n", ks10_t::readIO(address));
            }
        }
    } else {
        printf(usage);
    }
}

//
//! Execute the next instruction
//!
//! The <b>EX/b> (Execute) command causes the KS10 to execute the
//! instruction in the Console Instruction Register, then return to
//! the halt state.
//!
//! \sa cmdCO, cmdSI, cmdHA
//!
//! \param [in] argc
//!    Number of arguments.
///

static void cmdEX(int argc, char *[]) {
    const char *usage =
        "Usage: EX\n"
        "Execute the next instruction and then halt.\n";

    if (argc == 1) {
        ks10_t::run(false);
        ks10_t::exec(true);
        ks10_t::cont(true);
    } else {
        printf(usage);
    }
}

//
//! Halt the KS10
//!
//! The <b>HA</b> (Halt) command halts the KS10 CPU at the end of the current
//! instruction.  The KS10 will remain in the <b>HALT</b> state until it is
//! single-stepped or it is commanded to continue.
//!
//! This command negates the <b>RUN</b> bit in the Console Control Register and
//! waits for the KS10 to halt.
//!
//! \sa cmdCO, cmdSI
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//

static void cmdHA(int argc, char *[]) {
    const char *usage =
        "Usage: HA\n"
        "HALT the KS10\n";

    if (argc == 1) {
        ks10_t::run(false);
        while (!ks10_t::halt()) {
            ;
        }
        printf("KS10> Halted\n");
    } else {
        printf(usage);
    }
}

//
//! Load Memory Address
//!
//! The <b>LA</b> (Load Memory Address) command sets the memory address for the
//! next commands.
//!
//! \sa cmdLI
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//

static void cmdLA(int argc, char *argv[]) {
    access = accessMEM;
    const char *usage =
        "Usage: LA address\n"
        "Set the memory address for the next commands.\n"
        "Valid addresses are %08llo-%08llo\n";

#warning fIXME
    if (argc == 1) {
        printf("address is %08llo\n", ks10_t::readRegAddr());
    } else if (argc == 2) {
        ks10_t::addr_t addr = parseOctal(argv[1]);
        if (addr <= ks10_t::maxMemAddr) {
            address = addr;
            printf("Memory address set to %08llo\n", address);
            ks10_t::writeRegAddr(addr);
        } else {
            printf("Invalid memory address.\n");
            printf(usage, ks10_t::memStart, ks10_t::maxMemAddr);
        }
    } else {
        printf(usage, ks10_t::memStart, ks10_t::maxMemAddr);
    }
}

//
//! Load Diagnostic Monitor SMMON
//!
//! The <b>LB</b> (Load Diagnostic) command loads the diagnostic Monitor.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//

static void cmdLB(int, char *[]) {
    printf("LB Command is not implemented, yet.\n");
}

//
//! Load IO Address
//!
//! The <b>LI</b> (Load IO Address) command sets the IO address for the next
//! commands.
//!
//! \sa cmdLI
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//

static void cmdLI(int argc, char *argv[]) {
    access = accessIO;
    const char *usage =
        "Usage: LI address\n"
        "Set the IO address for the next commands.\n"
        "Valid addresses are %08llo-%08llo\n";

    if (argc == 2) {
        ks10_t::addr_t addr = parseOctal(argv[1]);
        if (addr <= ks10_t::maxIOAddr) {
            address = addr;
            printf("IO address set to %08llo\n", address);
        } else {
            printf("Invalid IO address.\n");
            printf(usage, ks10_t::memStart, ks10_t::maxIOAddr);
        }
    } else {
        printf(usage, ks10_t::memStart, ks10_t::maxIOAddr);
    }
}

//
//! Master Reset
//!
//! The <b>MR</b> (Master Reset) command hard resets the KS10 CPU.
//!
//! When the KS10 is started from <b>RESET</b>, the KS10 will peform a
//! selftest and initialize the ALU.  When the microcode initialization is
//! completed, the KS10 will enter the <b>HALT</b> state.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//

static void cmdMR(int argc, char *argv[]) {
    const char *usage =
        "Usage: MR\n"
        "RESET the KS10.\n";

    if (argc == 1) {
        ks10_t::cpuReset(true);
        ROM_SysCtlDelay(10);
        ks10_t::cpuReset(false);
        while (!ks10_t::halt()) {
            ;
        }
    } else if (argc == 2) {
        if (strncmp(argv[1], "ON", 2) == 0) {
            ks10_t::cpuReset(true);
            printf("KS10 is reset\n");
        } else if (strncmp(argv[1], "OFF", 2) == 0) {
            ks10_t::cpuReset(false);
            printf("KS10 is unreset\n");
        }
    } else {
        printf(usage);
    }
}

//
//! SD Card
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//

static void cmdSD(int argc, char *argv[]) {
    static FATFS fatFS;

    if (argc != 2) {
        return;
    }
    char *buf = argv[1];

    if (buf[0] == 'D' && buf[1] == 'I' && buf[2] == 'R') {
        FRESULT status = directory("");
        if (status != FR_OK) {
            debug("directory status was %d\n", status);
        }
    } else if (buf[0] == 'M' && buf[1] == 'O') {
        FRESULT status = f_mount(0, &fatFS);
        debug("open status was %d\n", status);
    } else if (buf[0] == 'I' && buf[1] == 'N') {
        sdInitialize();
    } else if (buf[0] == 'O' && buf[1] == 'P') {
        FIL fp;
        uint8_t buffer[256];
        unsigned int numbytes;
        FRESULT status = f_open(&fp, "asdf.txt", FA_READ);
        debug("open status was %d\n", status);
        status = f_read(&fp, &buffer, sizeof(buffer), &numbytes);
        for (unsigned int i = 0; i < numbytes; i++) {
            printf("%02x ", buffer[i]);
            if ((i % 16) == 15) {
                printf("\n");
            }
        }
        printf("\n");
        buffer[numbytes] = 0;
        printf("###%s###\n", buffer);
    } else if (buf[0] == 'R' && buf[1] == 'D') {
        unsigned char buffer[512];
        bool success = sdReadSector(buffer, 0);
        if (!success) {
            printf("SD Card Read Failure...\n");
            return;
        }
        for (int i = 0; i < 512; i++) {
            printf("%02x ", buffer[i]);
            if ((i%16) == 15) {
                printf("\n");
            }
        }
    }
}

//
//! Single Step
//!
//! The <b>SI</b> (Step Instruction) single steps the KS10 CPU.
//!
//! \sa cmdHA, cmdCO
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//

static void cmdSI(int argc, char *[]) {
    const char *usage =
        "Usage: SI\n"
        "Step Instruction: Single step the KS10.\n";

    if (argc == 1) {
        ks10_t::run(false);
        ks10_t::cont(true);
    } else {
        printf(usage);
    }
}

//
//! Shutdown Command
//!
//! The <b>SH</b> (Shutdown) command deposits non-zero data in KS10 memory
//! location 30.  This causes TOPS20 to shut down without issuing a warning.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//

static void cmdSH(int argc, char *[]) {
    const char *usage =
        "Usage: SH\n"
        "Shutdown.  Shutdown TOPS20.\n";

    if (argc == 1) {
        ks10_t::writeMem(030ULL, 1ULL);
    } else {
        printf(usage);
    }
}

//
//! Start Command
//!
//! The <b>ST</b> (Start) command stuffs a JRST instruction into the
//! <b>Console Instruction Register</b> and begins execution starting
//! with that instruction.
//!
//! The address must be a virtual address and is therefore limited to
//! 0777777.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//

static void cmdST(int argc, char *argv[]) {
    const char *usage =
        "Usage: ST address\n"
        "Start the KS10 at supplied address.\n";

    if (argc == 2) {
        ks10_t::addr_t addr = parseOctal(argv[1]);
        if (addr <= ks10_t::maxVirtAddr) {
            ks10_t::writeRegCIR((ks10_t::opJRST << 18) | (addr & 0777777));
            ks10_t::exec(true);
            ks10_t::run(true);
            ks10_t::cont(true);
        } else {
            printf("Invalid Address\n"
                   "Valid addresses are %08o-%08llo\n",
                   ks10_t::memStart, ks10_t::maxVirtAddr);
        }
    } else {
        printf(usage);
    }
}

//
//! Timer Enable
//!
//! The <b>TE</b> (Timer Enable) command controls the operation the KS10's
//! one millisecond system timer.
//!
//! - The <b>TE 0</b> command will disable the KS10's system timer.
//! - The <b>TE 1</b> command will enable the KS10's system timer
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//

void cmdTE(int argc, char *argv[]) {
    const char *usage =
        "Usage: TE {0 | 1}\n"
        "Control the operation of the KS10 system timer.\n"
        "\n"
        "TE 0 : disable timer\n"
        "TE 1 : enable timer\n";

    if (argc == 1) {
        printf("The timer is currently %s.\n",
               ks10_t::timerEnable() ? "enabled" : "disabled");
    } else if (argc == 2) {
        if (*argv[1] == '0') {
            printf("The timer is disabled.\n");
            ks10_t::timerEnable(false);
        } else if (*argv[1] == '1') {
            printf("The timer is enabled.\n");
            ks10_t::timerEnable(true);
        } else {
            printf(usage);
        }
    } else {
        printf(usage);
    }
}

//
//! Traps Enable
//!
//! The <b>TP</b> (Trap Enable) command controls the operation the KS10's
//! trap system.
//!
//! - The <b>TP 0</b> command will disable the KS10's traps.
//! - The <b>TP 1</b> command will enable the KS10's traps.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//

static void cmdTP(int argc, char *argv[]) {
    const char *usage =
        "Usage: TP {0 | 1}\n"
        "Control the operation of the KS10 trap system.\n"
        "\n"
        "TP 0 : disable traps\n"
        "TP 1 : enable traps\n";


    if (argc == 1) {
        printf("The traps are currently %s.\n",
               ks10_t::trapEnable() ? "enabled" : "disabled");
    } else if (argc == 2) {
        if (*argv[1] == '0') {
            printf("The traps are disabled.\n");
            ks10_t::trapEnable(false);
        } else if (*argv[1] == '1') {
            printf("The traps are enabled.\n");
            ks10_t::trapEnable(true);
        } else {
            printf(usage);
        }
    } else {
        printf(usage);
    }
}

//
//! Not implemented
//!
//! This function handles commands that are not implemented.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//

static void cmdXX(int, char *argv[]) {
    printf("Command \"%s\" is not implemented.\n", argv[0]);
}

//
//! Test function
//!
//! This function tests the printf() function.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//

static void cmdZZ(int argc, char *argv[]) {

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

        {
            address = 2;
            access  = accessMEM;
            ks10_t::data_t data = 1;
            ks10_t::writeMem(address, data);
            if (ks10_t::nxmnxd()) {
                printf("Write failed. (NXM)\n");
            }
            ks10_t::data_t data1 = ks10_t::readMem(address);
            if (ks10_t::nxmnxd()) {
                printf("Memory read failed. (NXM)\n");
            } else {
                printf("%012llo\n", data1);
            }
        }

    } else if (argc == 2) {
        if (strncmp(argv[1], "ON", 2) == 0) {
            ks10_t::cpuReset(true);
            printf("KS10 held in reset\n");
        } else if (strncmp(argv[1], "OFF", 2) == 0) {
            ks10_t::cpuReset(false);
            printf("KS10 unreset\n");
        }
    } else if (argc == 3) {
        if (*argv[1] == 'R') {
            if (strncmp(argv[2], "REGADDR", 4) == 0) {
                printf("  Address Register: %012llo.\n", ks10_t::readRegAddr());
            } else if (strncmp(argv[2], "REGDATA", 4) == 0) {
                printf("  Data Register: %012llo.\n", ks10_t::readRegData());
            } else if (strncmp(argv[2], "REGSTAT", 4) == 0) {
                printf("  Status Register: %012llo.\n", ks10_t::readRegStat());
            } else if (strncmp(argv[2], "RH11DEBUG", 4) == 0) {
                printRH11Debug();
            }
        } else if (*argv[1] == 'w') {
            ;
        }
    }
}

//
//! Parse Commands
//!
//! This function parses the commands and dispatches to the various handler
//! functions.
//!
//! \param [in] buf
//!    command line
//

void parseCommand(char * buf) {

    //
    // List of Commands
    //

    struct cmdList_t {
        const char * name;
        void (*function)(int argc, char *argv[]);
    };

    static const cmdList_t cmdList[] = {
        {"BT", cmdBT},
        {"CE", cmdCE},
        {"CH", cmdXX},          // Not implemented.
        {"CO", cmdCO},
        {"CP", cmdXX},          // Not implemented.
        {"CS", cmdXX},          // Not implemented.
        {"DB", cmdXX},          // Not implemented.
        {"DC", cmdXX},          // Not implemented.
        {"DF", cmdXX},          // Not implemented.
        {"DK", cmdXX},          // Not implemented.
        {"DI", cmdDI},
        {"DM", cmdDM},
        {"DN", cmdDN},
        {"DR", cmdXX},          // Not implemented.
        {"DS", cmdDS},
        {"EB", cmdXX},          // Not implemented.
        {"EC", cmdXX},          // Not implemented.
        {"EK", cmdXX},          // Not implemented.
        {"EI", cmdEI},
        {"EJ", cmdXX},          // Not implemented.
        {"EK", cmdXX},          // Not implemented.
        {"EM", cmdEM},
        {"EN", cmdEN},
        {"ER", cmdXX},          // Not implemented.
        {"EX", cmdEX},
        {"FI", cmdXX},          // Not implemented.
        {"HA", cmdHA},
        {"KL", cmdXX},          // Not implemented.
        {"LA", cmdLA},
        {"LB", cmdLB},
        {"LC", cmdXX},          // Not implemented.
        {"LF", cmdXX},          // Not implemented.
        {"LI", cmdLI},
        {"LK", cmdXX},          // Not implemented.
        {"LR", cmdXX},          // Not implemented.
        {"LT", cmdXX},          // Not implemented.
        {"MB", cmdXX},          // Not implemented.
        {"MK", cmdXX},          // Not implemented.
        {"MM", cmdXX},          // Not implemented.
        {"MR", cmdMR},
        {"MS", cmdXX},          // Not implemented.
        {"MT", cmdXX},          // Not implemented.
        {"PE", cmdXX},          // Not implemented.
        {"PM", cmdXX},          // Not implemented.
        {"PW", cmdXX},          // Not implemented.
        {"RC", cmdXX},          // Not implemented.
        {"RP", cmdXX},          // Not implemented.
        {"SC", cmdXX},          // Not implemented.
        {"SD", cmdSD},
        {"SH", cmdSH},
        {"SI", cmdSI},
        {"ST", cmdST},
        {"TE", cmdTE},
        {"TP", cmdTP},
        {"TT", cmdXX},          // Not implemented.
        {"UM", cmdXX},          // Not implemented.
        {"VD", cmdXX},          // Not implemented.
        {"VT", cmdXX},          // Not implemented.
        {"VM", cmdXX},          // Not implemented.
        {"ZZ", cmdZZ},          // Testing
    };

    const int numCMD = sizeof(cmdList)/sizeof(cmdList_t);

    int argc = 0;
    char *p = buf;
    static const int maxarg = 5;
    static char *argv[maxarg];

    //
    // Form argc and argv
    //

    bool process = true;
    while (*p) {
        if (*p == ' ') {
            *p = 0;
            process = true;
        } else if (process && (argc < maxarg)) {
            argv[argc++] = p;
            process = false;
        }
        p++;
    }

    //
    // Execute commands
    //   argc = 0 when no command <cr> is entered
    //   argv[0] is the command
    //   argv[1] is the first argument
    //

    if (argc != 0) {
        for (int i = 0; i < numCMD; i++) {
            if ((cmdList[i].name[0] == argv[0][0]) &&
                (cmdList[i].name[1] == argv[0][1])) {
                (*cmdList[i].function)(argc, argv);
                return;
            }
        }
        printf("Command not found.\n");
    }
}
