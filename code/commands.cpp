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
// Copyright (C) 2013-2016 Rob Doyle
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
#include <stdint.h>
#include <string.h>

#include "sd.h"
#include "stdio.h"
#include "dasm.hpp"
#include "dz11.hpp"
#include "ks10.hpp"
#include "rh11.hpp"
#include "align.hpp"
#include "prompt.hpp"
#include "commands.hpp"
#include "taskutil.hpp"
#include "fatfslib/dir.h"
#include "fatfslib/ff.h"
#include "driverlib/rom.h"
#include "driverlib/sysctl.h"
#include "driverlib/inc/hw_memmap.h"
#include "SafeRTOS/SafeRTOS_API.h"
#include "lwiplib/lwiplib.h"

#define DEBUG_COMMANDS

#ifdef DEBUG_COMMANDS
#define debug(...) printf(__VA_ARGS__)
#else
#define debug(...)
#endif

#define CUSTOM_CMD

//
// Current address set by cmdLI or cmdLA
//

static ks10_t::addr_t address;

//
// RH11 Parameters
//

static unsigned int rhbase = 01776700;          // !< RH11 base address
static unsigned int rhunit = 0;                 // !< RH11 Unit number

//
// Memory or IO address
//

static enum access_t {
    accessMEM = 0,              //!< KS10 Memory Access
    accessIO,                   //!< KS10 IO Access
} access;

//
// Write characters to the KS10
//

bool running = false;

//!
//! \brief
//!    Function to output from KS10 console
//!

void consoleOutput(void) {
    const char cntl_e = 0x05;
    running = true;
    while (!ks10_t::halt()) {
        int ch = getchar();
        if (ch == cntl_e) {
            printf("\n");
            break;
        } else if (ch != -1) {
            ks10_t::putchar(ch);
        }
    }
    running = false;
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
    printf("Patched executable with a %012llo instruction at address %06llo.\n", data, addr);
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

//!
//! \brief
//!    Read an AC from the KS10.
//!
//! \details
//!    Reading a register is a convoluted process.
//!
//!    -# Create a temporary memory location in the KS10 memory in which may be
//!       used to stash the contents AC.  Read the data at that location
//!       (addr 0100) and save the data in the  MCU.  We'll restore it when
//!       we're done.
//!    -# Execute a MOVEM instruction to move the register contents to the
//!       temporary memory location.
//!    -# The MCU can read the contents of the AC from the temporary memoy
//!       location.
//!    -# Restore the contents of the temporary memory locaction
//!
//! \param regAC -
//!    AC number
//!
//! \returns
//!    contens of the register
//!

ks10_t::data_t readAC(ks10_t::data_t regAC) {

    regAC &= 017;

    const ks10_t::addr_t tempAddr = 0100;
    const ks10_t::data_t tempData = ks10_t::readMem(tempAddr);
    ks10_t::executeInstruction((ks10_t::opMOVEM << 18) | (regAC << 23) | tempAddr);
    ks10_t::addr_t data = ks10_t::readMem(tempAddr);
    ks10_t::writeMem(tempAddr, tempData);

    return data;
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

ks10_t::data_t getdata(FIL *fp) {

    uint8_t buffer[5];
    unsigned int numbytes;

    FRESULT status = f_read(fp, buffer, sizeof(buffer), &numbytes);
    if (status != FR_OK) {
        debug("KS10: f_read() returned %d\n", status);
    }

    return rdword(buffer);
}

//!
//! \brief
//!    Load code into the KS10
//!
//! \details
//!    This function reads a .SAV file and writes the contents of that file to
//!    the KS10 memory.  The .SAV file also contains the starting address of
//!    the executable.  This address is loaded into the Console Instruction
//!    Register.
//!
//! \param [in] filename
//!    filename of the .SAV file
//!

static bool loadCode(const char * filename) {

    FIL fp;
    FRESULT status = f_open(&fp, filename, FA_READ);
    if (status != FR_OK) {
        debug("KS10: f_open() returned %d\n", status);
        return false;
    }

    for (;;) {

        //
        // The data36 format is:  -n,,a-1
        //

        ks10_t::data_t data36 = getdata(&fp);
        unsigned int words    = ks10_t::lh(data36);
        unsigned int addr     = ks10_t::rh(data36);
#if 0
        debug("addr is %06o, words is %06o\n", addr, words);
#endif

        //
        // Check for end
        //

        if ((words & 0400000) == 0) {
            if (words == ks10_t::opJRST) {

                //
                // Create JRST to starting address.
                //

                debug("KS10: Starting Address: %06lo,,%06lo\n", ks10_t::lh(data36), ks10_t::rh(data36));
                ks10_t::writeRegCIR(data36);
            }
            FRESULT status = f_close(&fp);
            if (status != FR_OK) {
                debug("KS10: f_close() returned %d\n", status);
            }
            return true;
        }

        //
        // Read record
        //

        while ((words & 0400000) != 0) {
            ks10_t::data_t data36 = getdata(&fp);
            addr  = (addr  + 1) & 0777777;
            ks10_t::writeMem(addr, data36);
#if 0
            debug("%06o: %012llo\n", addr, data36);
            printf("%06o\t%s\n", addr, dasm(data36));
#endif
            words = (words + 1) & 0777777;
        }
    }
}

//!
//! \brief
//!    Print RH11 Debug Word
//!

void printRH11Debug(void) {
    uint64_t rh11stat = ks10_t::getRH11debug();
    ks10_t::rh11debug_t *rh11debug = reinterpret_cast<ks10_t::rh11debug_t *>(&rh11stat);

    printf("KS10: RH11 status is 0x%016llx\n"
           "  State = %d\n"
           "  Err   = %d\n"
           "  Val   = %d\n"
           "  WrCnt = %d\n"
           "  RdCnt = %d\n"
           "  Res1  = 0x%02x\n"
           "  Res2  = 0x%02x\n"
           "  Res3  = 0x%02x\n"
           "",
           rh11stat,
           rh11debug->state,
           rh11debug->err,
           rh11debug->val,
           rh11debug->wrcnt,
           rh11debug->rdcnt,
           rh11debug->res1,
           rh11debug->res2,
           rh11debug->res3);
}

//!
//! \brief
//!    Print Halt Status
//!
//! \details
//!    This function prints the Halt Status Word and the Halt Status Block.
//!
//!    The code executes a RDHSB instruction in the Console Instruction
//!    Register to get the address of the Halt Status Block from the CPU.
//!

void printHaltStatus(void) {

    const ks10_t::haltStatusWord_t haltStatusWord = ks10_t::getHaltStatusWord();

    printf("KS10: Halt Cause: %s (PC=%06llo)\n",
           (haltStatusWord.status == 00000 ? "Microcode Startup."                     :
            (haltStatusWord.status == 00001 ? "Halt Instruction."                     :
             (haltStatusWord.status == 00002 ? "Console Halt."                        :
              (haltStatusWord.status == 00100 ? "IO Page Failure."                    :
               (haltStatusWord.status == 00101 ? "Illegal Interrupt Instruction."     :
                (haltStatusWord.status == 00102 ? "Pointer to Unibus Vector is zero." :
                 (haltStatusWord.status == 01000 ? "Illegal Microcode Dispatch."      :
                  (haltStatusWord.status == 01005 ? "Microcode Startup Check Failed." :
                   "Unknown.")))))))),
           haltStatusWord.pc);

#if 1

    //
    // Create a temporary memory location to stash the address of the Halt
    // Status Block.  Save the data in the console.  We'll restore it when
    // we're done.
    //

    const ks10_t::addr_t tempAddr = 0100;
    const ks10_t::data_t tempData = ks10_t::readMem(tempAddr);

    //
    // Load an RDHSB instruction into the CIR and execute it.
    //

    ks10_t::executeInstruction((ks10_t::opRDHSB << 18) | tempAddr);

    //
    // Read the address of the Halt Status Block from the temporary location
    // then restore the data at the temporary location.
    //

    ks10_t::addr_t hsbAddr = ks10_t::readMem(tempAddr);
    ks10_t::writeMem(tempAddr, tempData);

#else

    ks10_t::addr_t hsbAddr = 0376000ULL;

#endif

    //
    // Retrieve and print the Halt Status Block
    //

    const ks10_t::haltStatusBlock_t haltStatusBlock = ks10_t::getHaltStatusBlock(hsbAddr);
    printf("  Halt Status Block Address is %06llo\n"
           "  PC  is %012llo     HR  is %012llo\n"
           "  MAG is %012llo     ONE is %012llo\n"
           "  AR  is %012llo     ARX is %012llo\n"
           "  BR  is %012llo     BRX is %012llo\n"
           "  EBR is %012llo     UBR is %012llo\n"
           "  MSK is %012llo     FLG is %012llo\n"
           "  PI  is %012llo     X1  is %012llo\n"
           "  TO  is %012llo     T1  is %012llo \n"
           "  VMA is %012llo\n",
           hsbAddr,
           haltStatusBlock.pc,
           haltStatusBlock.hr,
           haltStatusBlock.mag,
           haltStatusBlock.one,
           haltStatusBlock.ar,
           haltStatusBlock.arx,
           haltStatusBlock.br,
           haltStatusBlock.brx,
           haltStatusBlock.ebr,
           haltStatusBlock.ubr,
           haltStatusBlock.mask,
           haltStatusBlock.flg,
           haltStatusBlock.pi,
           haltStatusBlock.x1,
           haltStatusBlock.t0,
           haltStatusBlock.t1,
           haltStatusBlock.vma);
}

#ifdef CUSTOM_CMD

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

static void cmdBR(int argc, char *argv[]) {
    const char *usage =
        "Usage: BR {FETCH | MEMRD | MEMWR | IORD | IOWR} Address\n"
        "       BR OFF - disable beakpoint\n"
        "       BR ON  - re-enable breakpoint\n"
        "Control the hardware breakpoint facility.\n";

    ks10_t::data_t addr;

    switch (argc) {
        case 1:
            printf("Debug Control/Status Register     : %012llo\n", ks10_t::readDCSR());
            printf("Debug Breakpoint Address Register : %012llo\n", ks10_t::readDBAR());
            printf("Debug Breakpoint Mask Register    : %012llo\n", ks10_t::readDBMR());
            printf(usage);
            break;
        case 2:
            if (strnicmp(argv[1], "off", 3) == 0) {
                ks10_t::writeDCSR(ks10_t::readDCSR() & ~ks10_t::dcsrBREN_RES);
            } else if (strnicmp(argv[1], "on", 2) == 0) {
                ks10_t::writeDCSR(ks10_t::readDCSR() | ks10_t::dcsrBREN_MAT);
            } else {
                printf(usage);
                return;
            }
            break;
        case 3:
            addr = parseOctal(argv[2]);
            if (strnicmp(argv[1], "fetch", 5) == 0) {
                ks10_t::writeDCSR(ks10_t::dcsrBREN_MAT);
                ks10_t::writeDBAR(ks10_t::dbarFETCH | addr);
                ks10_t::writeDBMR(ks10_t::dbmrFETCH | ks10_t::dbmrMEM);
            } else if (strnicmp(argv[1], "memrd", 5) == 0) {
                ks10_t::writeDCSR(ks10_t::dcsrBREN_MAT);
                ks10_t::writeDBAR(ks10_t::dbarMEMRD | addr);
                ks10_t::writeDBMR(ks10_t::dbmrMEMRD | ks10_t::dbmrMEM);
            } else if (strnicmp(argv[1], "memwr", 5) == 0) {
                ks10_t::writeDCSR(ks10_t::dcsrBREN_MAT);
                ks10_t::writeDBAR(ks10_t::dbarMEMWR | addr);
                ks10_t::writeDBMR(ks10_t::dbmrMEMWR | ks10_t::dbmrMEM);
            } else if (strnicmp(argv[1], "iord", 4) == 0) {
                ks10_t::writeDCSR(ks10_t::dcsrBREN_MAT);
                ks10_t::writeDBAR(ks10_t::dbarIORD | addr);
                ks10_t::writeDBMR(ks10_t::dbmrIORD | ks10_t::dbmrIO);
            } else if (strnicmp(argv[1], "iowr", 4) == 0) {
                ks10_t::writeDCSR(ks10_t::dcsrBREN_MAT);
                ks10_t::writeDBAR(ks10_t::dbarIOWR | addr);
                ks10_t::writeDBMR(ks10_t::dbmrIOWR | ks10_t::dbmrIO);
             } else {
                printf(usage);
                return;
            }
            break;
        default:
            printf(usage);
    }
}

#endif

//!
//! \brief
//!    Boot System
//!
//! \details
//!    The <b>BT</b> (Boot) command will read the directory information
//!    from the selected RPxx disk drive, find the appropriate file, load the
//!    the file into memory, and begin execution.
//!
//!    If the second argument is omitted, it will load the Monitor.  If the
//!    second argument is 1, it will load the Diagnostic Monitor.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!

static void cmdBT(int argc, char *argv[]) {
    const char *usage =
        "Usage: BT [1]\n"
        "       Load software into the KS10 processor.\n"
        "       BT   - Boot monitor on selected disk.\n"
        "       BT 1 - Boot diagnostic monitor on selected disk.\n"
        "       (see DS command)\n";

    //
    // Set RH11 Boot Parameters
    //

    ks10_t::writeMem(ks10_t::rhbase_addr, rhbase);
    ks10_t::writeMem(ks10_t::rhunit_addr, rhunit);
    rh11_t rh11(rhbase);

    switch (argc) {
        case 1:
            rh11.boot(rhunit, false);
            break;
        case 2:
            if (*argv[1] == '1') {
                rh11.boot(rhunit, true);
            } else {
                printf(usage);
            }
            break;
        default:
            printf(usage);
    }
}

//!
//! \brief
//!    Cache Enable
//!
//! \details
//!    The <b>CE</b> (Cache Enable) command controls the operation the KS10's
//!    cache.
//!
//!    - The <b>CE 0</b> command will disable the KS10's cache.
//!    - The <b>CE 1</b> command will enable the KS10's cache.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!

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

static void cmdCO(int argc, char *[]) {
    const char *usage =
        "Usage: CO\n"
        "Continue the KS10 from the HALT state.\n";

    if (argc == 1) {
        ks10_t::contin();
        consoleOutput();
    } else {
        printf(usage);
    }
}

//!
//! \brief
//!    Deposit IO
//!
//! \details
//!    The <b>DI</b> (Deposit IO) deposits data into the IO address previously
//!    loaded by the <b>LA</b> (Load Address) command.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!

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

//!
//! \brief
//!    Deposit Memory
//!
//! \details
//!    The <b>DM</b> (Deposit Memory) deposits data into the memory address
//!    previously loaded by the <b>LA</b> (Load Address) command.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!

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
//! \brief
//!    Deposit Next
//!
//! \details
//!    The <b>DN</b> (Deposit Next) command deposits data into the next memory
//!    or IO address depending on the last <b>DM</b> or <b>DI</b> command.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!

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
//! \brief
//!    Disk Select
//!
//! \details
//!    The <b>DS</b> (Disk Select) select the Unibus Adapter, RH11 Base address,
//!    and Unit for booting.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!

static void cmdDS(int argc, char *argv[]) {
   const char *usage =
       "Usage:\n"
       "  Set boot parameters:\n"
       "    DS {UBA=n} {BASE=nnnnnn} {UNIT=n}\n"
       "      Valid UBA is 1-4\n"
       "      Valid BASE is 776700\n"
       "      Valid UNIT is 0-7\n"
       "      Default is DS UBA=1 BASE=776700 UNIT=0\n"
       "      BASE must be 776700.  All others are invalid.\n"
       "  Display boot parameters:\n"
       "    DS\n";

   if (argc == 1 || argc > 4) {
       printf("Boot Parameters are:\n"
              "  UBA = %o\n"
              "  BASE = %06o\n"
              "  UNIT = %o\n"
              "\n"
              "%s",
              static_cast<unsigned int>((rhbase >> 18) & 0000007),
              static_cast<unsigned int>((rhbase >>  0) & 0777777),
              static_cast<unsigned int>((rhunit >>  0) & 0000007),
              usage);
   } else {
       for (int i = 1; i < argc; i++) {
           if (strnicmp(argv[i], "uba=", 4) == 0) {
               unsigned int temp = parseOctal(&argv[i][4]);
               if (temp > 4) {
                   printf("Parameter out of range: \"%s\".\n", argv[i]);
                   printf(usage);
               } else {
                   if (temp == 0) {
                       temp = 1;
                   }
                   rhbase = (rhbase & 0777777) | (temp << 18);
               }
           } else if (strnicmp(argv[i], "base=", 5) == 0) {
               unsigned int temp = parseOctal(&argv[i][5]);
               if (temp != 0776700) {
                   printf("Parameter must be 776700: \"%s\".\n", argv[i]);
                   printf(usage);
               } else {
                   rhbase = (rhbase & 07000000) | (temp & 0777777);
               }
           } else if (strnicmp(argv[i], "unit=", 5) == 0) {
               unsigned int temp = parseOctal(&argv[i][5]);
               if (temp > 7) {
                   printf("Parameter out of range: \"%s\".\n", argv[i]);
                   printf(usage);
               } else {
                   rhunit = temp;
               }
           } else {
               printf("Unrecognized parameter: \"%s\".\n", argv[i]);
               printf(usage);
               break;
           }
       }
   }
}

#ifdef CUSTOM_CMD

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

static void cmdDZ(int argc, char *argv[]) {
    const char *usage =
        "Usage: DZ {TX port | RX port | EC[HO] port}.\n"
        "DZ11 Tests.\n"
        "  DZ TX port - Test one of the DZ11 Transmitters.\n"
        "  DZ RX port - Test one of the DZ11 Receivers.\n"
        "  DZ ECHO port - Echo receiver back to transmitter."
        "  Valid ports are 0-7.\n"
        "  Note: This is all 9600 baud, no parity, 8 data bit, 1 stop bit.\n";

    if (argc == 3) {
        if (strnicmp(argv[1], "tx", 2) == 0) {
            if ((*argv[2] >= '0') && (*argv[2] <= '7')) {
                dz11_t::testTX(*argv[2]);
            } else {
                printf(usage);
            }

        } else if (strnicmp(argv[1], "rx", 2) == 0) {
            if ((*argv[2] >= '0') && (*argv[2] <= '7')) {
                dz11_t::testRX(*argv[2]);
            } else {
                printf(usage);
            }

        } else if (strnicmp(argv[1], "ec", 2) == 0) {
            if ((*argv[2] >= '0') && (*argv[2] <= '7')) {
                dz11_t::testECHO(*argv[2]);
            } else {
                printf(usage);
            }
        } else {
            printf(usage);
        }
    } else {
        printf(usage);
    }
}

#endif

//!
//! \brief
//!    Examine IO
//!
//! \details
//!    The <b>EI</b> (Examine IO) command reads from the last IO address
//!    specified.
//!
//! \param [in] argc
//!    Number of arguments.
//!

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

//!
//! \brief
//!    Examine Memory
//!
//! \details
//!    The <b>EM</b> (Examine Memory) command reads from the last memory address
//!    specified.
//!
//! \sa cmdLA, cmdEI, cmdEN
//!
//! \param [in] argc
//!    Number of arguments.
//!

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

//!
//! \brief
//!    Examine Next
//!
//! \details
//!    The <b>EN</b> (Examine Next) command reads from next IO or memory
//!    address.
//!
//! \sa cmdLA, cmdEI, cmdEM, cmdEN
//!
//! \param [in] argc
//!    Number of arguments.
//!

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

//!
//! \brief
//!    Execute the next instruction
//!
//! \details
//!    The <b>EX</b> (Execute) command causes the KS10 to execute the
//!    instruction in the Console Instruction Register, then return to the
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

static void cmdEX(int argc, char *argv[]) {
    const char *usage =
        "Usage: EX Instruction\n"
        "Put and instruction in the CIR and execute it.\n";

    if (argc == 2) {
        ks10_t::data_t data = parseOctal(argv[1]);
        ks10_t::writeRegCIR(data);
        ks10_t::execute();
    } else {
        printf(usage);
    }
}

#ifdef CUSTOM_CMD

//!
//! \brief
//!    Begin execution of KS10
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!

static void cmdGO(int argc, char *argv[]) {
    const char *usage =
        "Usage: GO diagname.sav address\n"
        "Run a diagnostic program\n";

    if (argc == 1) {

        //
        // Set RH11 Boot Parameters
        //

        ks10_t::writeMem(ks10_t::rhbase_addr, rhbase);
        ks10_t::writeMem(ks10_t::rhunit_addr, rhunit);

#if 0

        //
        // Load DSQDA diagnostic subroutines (SUBSM)
        //

        printf("KS10: Loading SUBSM.\n");
        if (!loadCode("diag/subsm.sav")) {
            printf("Failed to load DIAG/SUBSM.SAV\n");
        }

        //
        // Load DSQDB diagnostic debugger (SMDDT)
        //

        printf("KS10: Loading SMDDT.\n");
        if (!loadCode("diag/smddt.sav")) {
            printf("Failed to load DIAG/SMDDT.SAV\n");
        }

#endif

        //
        // Load DSQDC the diagnostic monitor (SMMON)
        //

        printf("KS10: Loading SMMON.\n");
        if (!loadCode("diag/smmon.sav")) {
            printf("Failed to load DIAG/SMMON.SAV\n");
            return;
        }

    } else if (argc == 3) {

        //
        // Set RH11 Boot Parameters
        //

        ks10_t::writeMem(ks10_t::rhbase_addr, rhbase);
        ks10_t::writeMem(ks10_t::rhunit_addr, rhunit);

#if 0

        //
        // Load DSQDA diagnostic subroutines (SUBSM)
        //

        printf("KS10: Loading SUBSM.\n");
        if (!loadCode("diag/subsm.sav")) {
            printf("Failed to load DIAG/SUBSM.SAV\n");
        }

        //
        // Load DSQDB diagnostic debugger (SMDDT)
        //

        printf("KS10: Loading SMDDT.\n");
        if (!loadCode("diag/smddt.sav")) {
            printf("Failed to load DIAG/SMDDT.SAV\n");
        }

#endif
        //
        // Load the diagnostic monitor into memory
        //

        printf("KS10: Loading SMMON.\n");
        if (!loadCode("diag/smmon.sav")) {
            printf("Failed to load diag/smmon.sav\n");
            return;
        }

        //
        // Read the diagnostic program into memory
        //

        if (!loadCode(argv[1])) {
            printf("Failed to load %s\n", argv[1]);
            return;
        }

        //
        // Set the starting address
        //

        ks10_t::data_t start = parseOctal(argv[2]);
        ks10_t::writeRegCIR(ks10_t::opJRST << 18 | start);
        printf("KS10: Starting Address: %06llo,,%06llo\n", ks10_t::opJRST, start);

        //
        // Fix timing for DSDZA diagnostic
        // This is required because the KS10 FPGA is faster than the DEC KS10
        // and the DSDZA diagnostics will fail without this patch.
        //

        if (strnicmp("diag/dsdza.sav", argv[1], 10) == 0) {
            ks10_t::writeMem(035650, 60000);    // 50
            ks10_t::writeMem(035651, 60000);    // 75
            ks10_t::writeMem(035652, 60000);    // 110
            ks10_t::writeMem(035653, 60000);    // 134`
            ks10_t::writeMem(035654, 60000);    // 150
            ks10_t::writeMem(035655, 60000);    // 300
            ks10_t::writeMem(035656, 60000);    // 600
            ks10_t::writeMem(035657, 60000);    // 1200
            ks10_t::writeMem(035660, 60000);    // 1800
            ks10_t::writeMem(035661, 60000);    // 2000
            ks10_t::writeMem(035662, 60000);    // 2400
            ks10_t::writeMem(035663, 60000);    // 3600
            ks10_t::writeMem(035664, 60000);    // 4800
            ks10_t::writeMem(035665, 60000);    // 7200
            ks10_t::writeMem(035666, 60000);    // 9600
            ks10_t::writeMem(035667, 60000);    // 19.2K
            printf("Patched DSDZA diagnostic.\n");
        }

    } else {
        printf(usage);
        return;
    }

    //
    // Configure the CPU
    //

    ks10_t::cacheEnable(true);
    ks10_t::trapEnable(true);
    ks10_t::timerEnable(true);

    //
    // Insert Halt Instruction at end of standalone diagnostic test
    //

#if 0

    patchCode(030057, ks10_t::opHALT << 18 | 030060):

#endif

    //
    // Start the KS10 running
    //

    ks10_t::begin();

    //
    // Write character to KS10
    //

    consoleOutput();
}

#endif

//!
//! \brief
//!    Halt the KS10
//!
//! \details
//!    The <b>HA</b> (Halt) command halts the KS10 CPU at the end of the current
//!    instruction.  The KS10 will remain in the <b>HALT</b> state until it is
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

static void cmdHA(int argc, char *[]) {
    const char *usage =
        "Usage: HA\n"
        "HALT the KS10\n";

    if (argc == 1) {
        ks10_t::run(false);
        while (!ks10_t::halt()) {
            ;
        }
        printf("Halted\n");
    } else {
        printf(usage);
    }
}

#ifdef CUSTOM_CMD

//!
//! \brief
//!    Print the halt status word
//!

static void cmdHS(int , char *[]) {
    printHaltStatus();
}

#endif

//!
//! \brief
//!    Load Memory Address
//!
//! \details
//!    The <b>LA</b> (Load Memory Address) command sets the memory address for
//!    the next commands.
//!
//! \sa cmdLI
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!

static void cmdLA(int argc, char *argv[]) {
    access = accessMEM;
    const char *usage =
        "Usage: LA address\n"
        "Set the memory address for the next commands.\n"
        "Valid addresses are %08llo-%08llo\n";

    if (argc == 2) {
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
        printf("Address is %08llo\n", ks10_t::readRegAddr());
    }
}

//!
//! \brief
//!    Load Boot
//!
//! \details
//!    The <b>LB</b> (Load Boot) command will read the directory information
//!    from the selected RPxx disk drive, find the appropriate file, load the
//!    the file into memory, and begin execution.
//!
//!    If the second argument is omitted, it will load the Monitor.  If the
//!    second argument is 1, it will load the Diagnostic Monitor.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!

static void cmdLB(int argc, char *argv[]) {
    const char *usage =
        "Usage: LB [1]\n"
        "       Load software into the KS10 processor.\n"
        "       LB   - Boot monitor on selected disk.\n"
        "       LB 1 - Boot diagnostic monitor on selected disk.\n"
        "       (see DS command)\n";

    //
    // Set RH11 Boot Parameters
    //

    ks10_t::writeMem(ks10_t::rhbase_addr, rhbase);
    ks10_t::writeMem(ks10_t::rhunit_addr, rhunit);
    rh11_t rh11(rhbase);

    switch (argc) {
        case 1:
            rh11.boot(rhunit, false);
            break;
        case 2:
            if (*argv[1] == '1') {
                rh11.boot(rhunit, true);
            } else {
                printf(usage);
            }
            break;
        default:
            printf(usage);
    }
}

//!
//! \brief
//!    Load IO Address
//!
//! \details
//!    The <b>LI</b> (Load IO Address) command sets the IO address for the next
//!    commands.
//!
//! \sa cmdLI
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!

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
        printf("Address is %08llo\n", ks10_t::readRegAddr());
    }
}

//!
//! \brief
//!    Master Reset
//!
//! \details
//!    The <b>MR</b> (Master Reset) command hard resets the KS10 CPU.
//!
//!    When the KS10 is started from <b>RESET</b>, the KS10 will peform a
//!    selftest and initialize the ALU.  When the microcode initialization is
//!    completed, the KS10 will enter the <b>HALT</b> state.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!

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
        if (strnicmp(argv[1], "on", 2) == 0) {
            ks10_t::cpuReset(true);
            printf("KS10 is reset\n");
        } else if (strnicmp(argv[1], "off", 2) == 0) {
            ks10_t::cpuReset(false);
            printf("KS10 is unreset\n");
        }
    } else {
        printf(usage);
    }
}

#ifdef CUSTOM_CMD

//!
//! \brief
//!    Network Interface
//!
//! \details
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the argument.
//!

static void cmdNE(int argc, char *argv[]) {
    const char *usage =
        "Usage: NE STAT\n"
        " NE STAT  - Display Network Addresses.\n";

    if (argc == 2) {
        if (strnicmp(argv[1], "stat", 4) == 0) {
            uint32_t addr = lwIPGetIPAddr();
            if (addr == 0) {
                printf("  Unable to obtain IP Address.\n");
            } else {
                printf("  IP Address      : %ld.%ld.%ld.%ld\n",
                       ((addr >>  0) & 0xff),
                       ((addr >>  8) & 0xff),
                       ((addr >> 16) & 0xff),
                       ((addr >> 24) & 0xff));
                addr = lwIPGetNetMask();
                printf("  Net Mask        : %ld.%ld.%ld.%ld\n",
                       ((addr >>  0) & 0xff),
                       ((addr >>  8) & 0xff),
                       ((addr >> 16) & 0xff),
                       ((addr >> 24) & 0xff));
                addr = lwIPGetGWAddr();
                printf("  Gateway Address : %ld.%ld.%ld.%ld\n",
                       ((addr >>  0) & 0xff),
                       ((addr >>  8) & 0xff),
                       ((addr >> 16) & 0xff),
                       ((addr >> 24) & 0xff));
                uint8_t buffer[6];
                ROM_EthernetMACAddrGet(ETH_BASE, buffer);
                printf("  MAC Address     : %02x:%02x:%02x:%02x:%02x:%02x\n",
                       buffer[0], buffer[1], buffer[2],
                       buffer[3], buffer[4], buffer[5]);
            }
        } else {
            printf(usage);
        }
    } else {
        printf(usage);
    }
}

#endif

#ifdef CUSTOM_CMD

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

static void cmdRD(int argc, char *argv[]) {
    if (argc == 2) {
        ks10_t::addr_t addr = parseOctal(argv[1]);
        ks10_t::data_t data = ks10_t::readMem(addr);
        if (ks10_t::nxmnxd()) {
            printf("Memory read failed. (NXM)\n");
        } else {
            printf("%012llo\n", data);
        }
    } else {
        printf("Usage: RD Addr\n");
    }
}

#endif

#ifdef CUSTOM_CMD

//!
//! \brief
//!    Execute RH11 tests
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the argument.
//!

static void cmdRH(int argc, char *argv[]) {
    const char *usage =
        "Usage: RH {CLR | BOOT | STAT | FIFO | RPLA | READ | WRITE | WRCHK}\n"
        "RH11 Tests.\n"
        " RH BOOT - Load Monitor Boot into memory\n"
        " RH CLR  - RH11 Controller Clear\n"
        " RH FIFO - Test RH11 FIFO\n"
        " RH INIT - Test RH11 Initialization\n"
        " RH READ - Test RH11 Disk Read\n"
        " RH RPLA - Test RH11 RPLA\n"
        " RH STAT - Print Debug Register\n"
        " RH WRITE - Test RH11 Disk Write\n"
        " RH WRCHK - Test RH11 Disk Write Check\n";

    //
    // Set RH11 Boot Parameters
    //

    ks10_t::writeMem(ks10_t::rhbase_addr, rhbase);
    ks10_t::writeMem(ks10_t::rhunit_addr, rhunit);
    rh11_t rh11(rhbase);

    if (argc == 2) {
        if (strnicmp(argv[1], "boot", 4) == 0) {
            rh11.boot(rhunit);
        } else if (strnicmp(argv[1], "clr", 3) == 0) {
            rh11.clear();
        } else if (strnicmp(argv[1], "fifo", 4) == 0) {
            rh11.testFIFO();
        } else if (strnicmp(argv[1], "init", 4) == 0) {
            rh11.testInit(rhunit);
        } else if (strnicmp(argv[1], "read", 4) == 0) {
            rh11.testRead(rhunit);
        } else if (strnicmp(argv[1], "rpla", 4) == 0) {
            rh11.testRPLA(rhunit);
        } else if (strnicmp(argv[1], "stat", 4) == 0) {
            printRH11Debug();
        } else if (strnicmp(argv[1], "wrchk", 5) == 0) {
            rh11.testWrchk(rhunit);
        } else if (strnicmp(argv[1], "write", 5) == 0) {
            rh11.testWrite(rhunit);
        } else {
            printf(usage);
        }
    } else {
        printf(usage);
    }
}

#endif

#ifdef CUSTOM_CMD

//!
//! \brief
//!    Read register
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the argument.
//!

static void cmdRR(int argc, char *argv[]) {
    const char *usage =
        "Usage: RR {Reg}\n"
        " RR is octal must be 0 - 17\n"
        " if Reg is omitted, all register will be displayed\n"
        " Note: the KS10 must be halted for this to succeed\n";

    if (argc == 1) {
        if (!ks10_t::halt()) {
            printf("KS10: CPU is running.   Halt it first.\n");
        } else {
            printf("Dump of AC contents:\n");
            for (unsigned int i = 0; i < 020; i++) {
                printf("%02o: %012llo\n", i, readAC(i));
            }
        }
    } else if (argc == 2) {
        if (!ks10_t::halt()) {
            printf("KS10: CPU is running.   Halt it first.\n");
        } else {
            ks10_t::data_t regAC = parseOctal(argv[1]);
            if (regAC < 020) {
                printf("%012llo\n", readAC(regAC));
            } else {
                printf(usage);
            }
        }
    } else {
        printf(usage);
    }
}
#endif

//!
//! \brief
//!   SD Card Commands
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!

#ifdef CUSTOM_CMD

static void cmdSD(int argc, char *argv[]) {
    const char *usage =
        "Usage: SD DIR\n"
        "Print directory of SD Card.\n";

    if (argc == 2) {
        if (strnicmp(argv[1], "dir", 3) == 0) {
            FRESULT status = directory("");
            if (status != FR_OK) {
                debug("Directory command failed. Status was %d.\n", status);
            }
        }
    } else {
        printf(usage);
    }
}

#endif

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

static void cmdSI(int argc, char *[]) {
    const char *usage =
        "Usage: SI\n"
        "Step Instruction: Single step the KS10.\n";

    if (argc == 1) {
        ks10_t::step();
    } else {
        printf(usage);
    }
}

//!
//! \brief
//!    Shutdown Command
//!
//! \details
//!    The <b>SH</b> (Shutdown) command deposits non-zero data in KS10 memory
//!    location 30.  This causes TOPS20 to shut down without issuing a warning.
//!
//! \param [in] argc
//!    Number of arguments.
//!

static void cmdSH(int argc, char *[]) {
    const char *usage =
        "Usage: SH\n"
        "Shutdown.  Shutdown TOPS20.\n";

    if (argc == 1) {
        ks10_t::writeMem(ks10_t::switch_addr, 1ULL);
    } else {
        printf(usage);
    }
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

static void cmdST(int argc, char *argv[]) {
    const char *usage =
        "Usage: ST address\n"
        "Start the KS10 at supplied address.\n";

    if (argc == 2) {
        ks10_t::addr_t addr = parseOctal(argv[1]);
        if (addr <= ks10_t::maxVirtAddr) {
            ks10_t::writeRegCIR((ks10_t::opJRST << 18) | (addr & 0777777));
            ks10_t::begin();
            consoleOutput();
        } else {
            printf(usage);
            printf("Invalid Address\n"
                   "Valid addresses are %08llo-%08llo\n",
                   ks10_t::memStart, ks10_t::maxVirtAddr);
        }
    } else {
        printf(usage);
    }
}

//!
//! \brief
//!    Timer Enable
//!
//! \details
//!    The <b>TE</b> (Timer Enable) command controls the operation the KS10's
//!    one millisecond system timer.
//!
//!    - The <b>TE 0</b> command will disable the KS10's system timer.
//!    - The <b>TE 1</b> command will enable the KS10's system timer
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!

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

//!
//! \brief
//!    Traps Enable
//!
//! \details
//!    The <b>TP</b> (Trap Enable) command controls the operation the KS10's
//!    trap system.
//!
//!    - The <b>TP 0</b> command will disable the KS10's traps.
//!    - The <b>TP 1</b> command will enable the KS10's traps.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!

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

#ifdef CUSTOM_CMD

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

static void cmdTR(int argc, char *argv[]) {
    const char *usage =
        "Usage: TR {ON OFF RESET TRIG DUMP}\n"
        "Control the hardware trace facility.\n"
        "TR ON    : re-enables the traced facility\n"
        "TR OFF   : disables the trace facility\n"
        "TR RESET : resets the trace buffer FIFO.  The FIFO will be empty\n"
        "TR TRIG  : probably does not work\n"
        "TR DUMP  : prints the contents of the trace buffer\n";

    switch (argc) {
        case 1:
            printf("Debug Control/Status Register     : %012llo\n", ks10_t::readDCSR());
            printf("Debug Instruction Trace Register  : %018llo\n", ks10_t::readDITR());
            printf(usage);
            break;
        case 2:
            if (strnicmp(argv[1], "on", 2) == 0) {
               ks10_t::writeDCSR(ks10_t::readDCSR() | ks10_t::dcsrTREN_EN);
            } else if (strnicmp(argv[1], "off", 3) == 0) {
               ks10_t::writeDCSR(ks10_t::readDCSR() & ~ks10_t::dcsrTREN_RES);
            } else if (strnicmp(argv[1], "reset", 5) == 0) {
                ks10_t::writeDCSR(ks10_t::dcsrRESET);
            } else if (strnicmp(argv[1], "trig", 4) == 0) {
               ks10_t::writeDCSR(ks10_t::readDCSR() | ks10_t::dcsrTREN_MAT);
            } else if (strnicmp(argv[1], "dump", 4) == 0) {
                // Disable further trace acquisition
                ks10_t::writeDCSR(ks10_t::readDCSR() & ~ks10_t::dcsrTREN_RES);
                printf("Dump of Trace Buffer:\n"
                       "Entry\t  PC  \tOPC AC I XR   EA  \n"
                       "-----\t------\t--- -- - -- ------\n");
                for (int i = 0; (ks10_t::readDCSR() & ks10_t::dcsrEMPTY) != ks10_t::dcsrEMPTY; i++) {
                    uint64_t data = ks10_t::readDITR();
                    unsigned int pc = (data >> 36) &  0777777;
                    unsigned long long ir = (data >>  0) & 0777777777777;
                    printf("%5d\t%06o\t%s\n", i, pc, dasm(ir));
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
}

#endif

#ifdef CUSTOM_CMD

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

static void cmdWR(int argc, char *argv[]) {
    if (argc == 3) {
        ks10_t::addr_t addr = parseOctal(argv[1]);
        ks10_t::data_t data = parseOctal(argv[2]);
        ks10_t::writeMem(addr, data);
        if (ks10_t::nxmnxd()) {
            printf("Memory write failed. (NXM)\n");
        }
    } else {
        printf("Usage: WR Addr Data\n");
    }
}

#endif

//!
//! \brief
//!    Not implemented
//!
//! \details
//!    This function handles commands that are not implemented.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//!

static void cmdXX(int, char *argv[]) {
    printf("Command \"%s\" is not implemented.\n", argv[0]);
}

//!
//! \brief
//!    Zero memory
//!
//! \param [in] argc
//!    Number of arguments.
//!

static void cmdZM(int argc, char */*argv*/[]) {
    const char *usage =
        "Usage: ZM\n"
        "Zero KS10 Memory.\n";

    if (argc == 1) {
        const ks10_t::addr_t memSize = 1024 * 1024;
        printf("Zeroing memory (%d kW).  This takes about 30 seconds.\n", 1024);
        for (ks10_t::addr_t i = 0; i < memSize; i++) {
            ks10_t::writeMem(i, 0);
        }
    } else {
        printf(usage);
    }
}

#ifdef CUSTOM_CMD

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

static void cmdZZ(int argc, char *argv[]) {

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
        if (strnicmp(argv[1], "on", 2) == 0) {
            ks10_t::cpuReset(true);
            printf("KS10 held in reset\n");
        } else if (strnicmp(argv[1], "off", 2) == 0) {
            ks10_t::cpuReset(false);
            printf("KS10 unreset\n");
        }
    } else if (argc == 3) {
        if (*argv[1] == 'R') {
            if (strnicmp(argv[2], "regaddr", 4) == 0) {
                printf("  Address Register: %012llo.\n", ks10_t::readRegAddr());
            } else if (strnicmp(argv[2], "regdata", 4) == 0) {
                printf("  Data Register: %012llo.\n", ks10_t::readRegData());
            } else if (strnicmp(argv[2], "regcir", 4) == 0) {
                printf("  CIR Register: %012llo.\n", ks10_t::readRegCIR());
            } else if (strnicmp(argv[2], "regstat", 4) == 0) {
                printf("  Status Register: %012llo.\n", ks10_t::readRegStat());
            } else if (strnicmp(argv[2], "rh11debug", 4) == 0) {
                printRH11Debug();
            }
        } else if (*argv[1] == 'W') {
            if (strnicmp(argv[2], "regcir", 4) == 0) {
                ks10_t::writeRegCIR(0254000020000);
                printf(" CIR Register written.\n");
            } else if (strnicmp(argv[2], "regdir", 4) == 0) {
                ks10_t::writeRegCIR(0);
                printf(" CIR Register written.\n");
            }
        }
    }
}

#endif

//!
//! \brief
//!    Command processing task
//!
//! \details
//!    This function parses the commands and dispatches to the various handler
//!    functions.
//!
//! \param [in] param
//!    command line
//!

void taskCommand(void * param) {

    //
    // List of Commands
    //

    struct cmdList_t {
        const char * name;
        void (*function)(int argc, char *argv[]);
    };

    static const cmdList_t cmdList[] = {
#ifdef CUSTOM_CMD
        {"BR", cmdBR},          // Breakpoint
#endif
        {"BT", cmdBT},          // Boot
        {"CE", cmdCE},          // Cache enable
        {"CH", cmdXX},          // Not implemented.
        {"CO", cmdCO},          // Continue
        {"CP", cmdXX},          // Not implemented.
        {"CS", cmdXX},          // Not implemented.
        {"DB", cmdXX},          // Not implemented.
        {"DC", cmdXX},          // Not implemented.
        {"DF", cmdXX},          // Not implemented.
        {"DK", cmdXX},          // Not implemented.
        {"DI", cmdDI},          // Deposit IO
        {"DM", cmdDM},          // Deposit Memory
        {"DN", cmdDN},
        {"DR", cmdXX},          // Not implemented.
        {"DS", cmdDS},
#ifdef CUSTOM_CMD
        {"DZ", cmdDZ},          // DZ11 Test
#endif
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
#ifdef CUSTOM_CMD
        {"GO", cmdGO},
#endif
        {"HA", cmdHA},
#ifdef CUSTOM_CMD
        {"HS", cmdHS},
#endif
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
#ifdef CUSTOM_CMD
        {"NE", cmdNE},          // Network info
#endif
        {"PE", cmdXX},          // Not implemented.
        {"PM", cmdXX},          // Not implemented.
        {"PW", cmdXX},          // Not implemented.
        {"RC", cmdXX},          // Not implemented.
        {"RP", cmdXX},          // Not implemented.
#ifdef CUSTOM_CMD
        {"RD", cmdRD},          // Simple memory read
#endif
#ifdef CUSTOM_CMD
        {"RH", cmdRH},          // RH11 Tests
#endif
#ifdef CUSTOM_CMD
        {"RR", cmdRR},          // Read register
#endif
        {"SC", cmdXX},          // Not implemented.
        {"SD", cmdSD},
        {"SH", cmdSH},
        {"SI", cmdSI},
        {"ST", cmdST},
        {"TE", cmdTE},
        {"TP", cmdTP},
#ifdef CUSTOM_CMD
        {"TR", cmdTR},          // Trace
#endif
        {"TT", cmdXX},          // Not implemented.
        {"UM", cmdXX},          // Not implemented.
        {"VD", cmdXX},          // Not implemented.
        {"VT", cmdXX},          // Not implemented.
        {"VM", cmdXX},          // Not implemented.
#ifdef CUSTOM_CMD
        {"WR", cmdWR},          // Simple memory write
#endif
        {"ZM", cmdZM},          // Zero memory
#ifdef CUSTOM_CMD
        {"ZZ", cmdZZ},          // Testing
#endif
    };

    char * buf = reinterpret_cast<char *>(param);
    const int numCMD = sizeof(cmdList)/sizeof(cmdList_t);

    //
    // Process command line.  Handle multiple commands seperated by ';'
    //

    char *p = buf;
    bool more = false;
    do {

        int argc = 0;
        static const int maxarg = 5;
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
                    (*cmdList[i].function)(argc, argv);
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

    printf(PROMPT);
    xTaskDelete(NULL);
}

//!
//! \brief
//!    Command Processing
//!
//! \note
//!    Command processing is implemented as a task so that it can be:
//!    - suspended with a ^S keystoke
//!    - resumed with a ^Q keystroke
//!    - deleted with a ^C keystroke
//!
//! \note
//!    This function executes within the context of the Console Task and not
//!    the command processing task.
//!

void startCommandTask(char *lineBuffer, xTaskHandle &taskHandle) {

    //
    // Don't start the next command until the previous command completes.
    //

    while (taskIsRunning(taskHandle)) {
        xTaskDelay(1);
    }

    //
    // Store a copy of the command line locally.  The line buffer will be destroyed before the
    // command completes
    //

    static char buffer[128];
    strncpy(buffer, lineBuffer, sizeof(buffer));

    //
    // Create a task to execute the command
    //

    static signed char __align64 stack[4096-4];
    portBASE_TYPE status = xTaskCreate(taskCommand, reinterpret_cast<const signed char *>("Command"),
                                       stack, sizeof(stack), buffer, taskCommandPriority, &taskHandle);
    if (status != pdPASS) {
        debug("RTOS: Failed to create Command task.  Status was %s.\n", taskError(status));
    }
}
