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
#include "telnetlib/telnet.h"
#include "SafeRTOS/SafeRTOS_API.h"

#define DEBUG_COMMANDS

#ifdef DEBUG_COMMANDS
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
//! Parses an octal number
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

#if 0
//
//! Parses a hex number
//!
//! \param [in] buf
//!     Pointer to line buffer.
//!
//! \returns
//!     Number
//

static ks10_t::data_t parseHex(const char *buf) {

    ks10_t::data_t num = 0;

    for (int i = 0; i < 64; i += 4) {
        if (*buf >= '0' && *buf <= '7') {
            num += *buf++ - '0';
            num <<= 4;
        } else if (*buf >= 'A' && *buf <= 'F') {
            num += *buf++ - 0x37;
            num <<= 4;
        } else if (*buf >= 'a' && *buf <= 'f') {
            num += *buf++ - 0x57;
            num <<= 4;
        } else {
            if (*buf != 0) {
                printf("Parsed invalid character.\n");
            }
            break;
        }
    }
    num >>= 4;

    return num;
}
#endif

//
//! This function builds a 36-bit data word from the contents of the .SAV file.
//!
//! \param
//!     b is a pointer to the input data
//!
//! \details
//!     Data is in the format:
//!
//!       Byte 0:   0  B00 B01 B02 B03 B04 B05 B06
//!       Byte 1:   0  B07 B08 B09 B10 B11 B12 B13
//!       Byte 2:   0  B14 B15 B16 B17 B18 B19 B20
//!       Byte 3:   0  B21 B22 B23 B24 B25 B26 B27
//!       Byte 4:  B35 B28 B29 B30 B31 B32 B33 B34
//!
//!       Note the position of B35!
//!
//!     See "TOPS-10 Tape Processing Manual" Section 6.4 entitled "ANSI-ASCII
//!     Mode" for format definition.
//!
//!     See also document entitled "Dumper and Backup Tape Formats".
//!
//! \returns
//!     36-bit data word
//!

ks10_t::data_t rdword(const uint8_t *b) {
    return ((((ks10_t::data_t)(b[0] & 0x7f)) << 29) |   // Bit  0 - Bit  6
            (((ks10_t::data_t)(b[1] & 0x7f)) << 22) |   // Bit  7 - Bit 13
            (((ks10_t::data_t)(b[2] & 0x7f)) << 15) |   // Bit 14 - Bit 20
            (((ks10_t::data_t)(b[3] & 0x7f)) <<  8) |   // Bit 21 - Bit 27
            (((ks10_t::data_t)(b[4] & 0x7f)) <<  1) |   // Bit 28 - Bit 34
            (((ks10_t::data_t)(b[4] & 0x80)) >>  7));   // Bit 35
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
            addr  = (addr  + 1) & 0777777;
            ks10_t::writeMem(addr, data36);
#if 0
            debug("%06o: %06lo%06lo\n", addr, ks10_t::lh(data36), ks10_t::rh(data36));
#endif
            words = (words + 1) & 0777777;
        }
    }
}

#if 0

//
//! Load code into the KS10 from a DAT file
//!
//! This function reads the .DAT file and writes the contents to to the KS10.
//!
//! \param [in] filename
//!     filename of the .DAT file
//!
//! \note
//!     The DAT file is in the same format as a verilog file
//

static int fgetc(FIL *fp) {
    char ch;
    unsigned int numbytes;

    FRESULT status = f_read(fp, &ch, 1, &numbytes);
    if (status != FR_OK || numbytes == 0) {
        debug("f_read() returned %d\n", status);
        return -1;
    }
    return ch;
}

static int gettoken(FIL *fp, ks10_t::data_t& data) {

    data = 0;
    int ch = 0;
    int prevch = 0;
    bool addrFlag = false;

    do {

        ch = fgetc(fp);

        //fprintf(stdout, "Read1 %c\n", ch);

        switch (ch) {
            case '0' ... '9':
            case 'a' ... 'f':
            case 'A' ... 'F':
                //printf("BEGIN HEX NUMBER\n");
                for (;;) {
                    switch(ch) {
                        case '0' ... '9':
                            data = (data << 4) + ch - '0';
                            break;
                        case 'A' ... 'F':
                            data = (data << 4) + ch - 'A' + 10;
                            break;
                        case 'a' ... 'f':
                            data = (data << 4) + ch - 'a' + 10;
                            break;
                        default:
                            //printf("END HEX NUMBER - %09llx\n", data);
                            return addrFlag ? 1 : 2;
                    }
                    ch = fgetc(fp);
                    //fprintf(stdout, "Read4 %c\n", ch);
                }
                break;
            case '@':
                //printf("FOUND ADDRFLAG\n");
                addrFlag = true;
                break;
            case '\n':
                addrFlag = false;
                ch = 0;
                break;
            case '/':
                if (prevch == '/') {
                    //printf("BEGIN EOL COMMENT\n");
                    for (;;) {
                        prevch = ch;
                        ch = fgetc(fp);
                        //fprintf(stdout, "Read3 %c\n", ch);
                        if (ch == '\n') {
                            break;
                        }
                    }
                    //printf("END EOL COMMENT\n");
                    return 0;
                }
                break;
            case '*':
                if (prevch == '/') {
                    //printf("BEGIN COMMENT\n");
                    for (;;) {
                        prevch = ch;
                        ch = fgetc(fp);
                        //fprintf(stdout, "Read2 %c\n", ch);
                        if (ch == '/' && prevch == '*') {
                            break;
                        }
                    }
                    //printf("END COMMENT\n");
                    return 0;
                }
                break;
            case -1:
                return -1;
            default:
                break;
        }
        prevch = ch;
    } while (ch != 0);

    return 0;
}

static bool readDatFile(const char * filename) {

    FIL fp;
    FRESULT status = f_open(&fp, filename, FA_READ);
    if (status != FR_OK) {
        debug("f_open() returned %d\n", status);
        return false;
    }

    ks10_t::addr_t addr = 0;

    for (;;) {
        ks10_t::data_t data;
        int status = gettoken(&fp, data);

        //printf("gettoken() returned %012llo\n", data);

        switch (status) {
            case -1:
                return true;
            case 0:
                break;
            case 1:
                addr = data;
                //debug("addr set to %06o\n", addr);
                break;
            case 2:
                if (addr > 035122) {
                    //    debug("%06llo: %06lo,,%06lo\n", addr, ks10_t::lh(data), ks10_t::rh(data));
                }
                ks10_t::writeMem(addr++, data);
                break;
        }
    }
}
#endif

//
//! Print RH11 Debug Word
//

void printRH11Debug(void) {
    volatile ks10_t::rh11debug_t * rh11debug = ks10_t::getRH11debug();
    printf("RH11 Status summary: 0x%016llx\n"
           "  State = %d\n"
           "  Err   = %d\n"
           "  Val   = %d\n"
           "  WrCnt = %d\n"
           "  RdCnt = %d\n"
           "  Res1  = 0x%02x\n"
           "  Res2  = 0x%02x\n"
           "  Res3  = 0x%02x\n"
           "",
           *reinterpret_cast<volatile uint64_t*>(rh11debug),
           rh11debug->state,
           rh11debug->err,
           rh11debug->val,
           rh11debug->wrcnt,
           rh11debug->rdcnt,
           rh11debug->res1,
           rh11debug->res2,
           rh11debug->res3);
}

//
//! Print Halt Status
//!
//! This function prints the Halt Status Word and the Halt Status Block.
//!
//! \details
//!     The code executes a RDHSB instruction in the Console Instruction
//!     Register to get the address of the Halt Status Block from the CPU.
//!
//! \todo
//!     The microcode doesn't seem to store the FE/SC registers like the
//!     documents describe.   Delete it?
//

void printHaltStatus(void) {

    //
    // Retreive and print the Halt Status Word
    //

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

    //
    // Print the Halt Status Block when not at Microcode Startup
    //

    if (haltStatusWord.status != 0) {

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

        ks10_t::writeRegCIR((ks10_t::opRDHSB << 18) | tempAddr);
        ks10_t::execute();

        //
        // Wait for the processor to HALT.
        //

        while (!ks10_t::halt()) {
            ;
        }

        //
        // Read the address of the Halt Status Block from the temporary location
        // then restore the data at the temporary location.
        //

        ks10_t::addr_t hsbAddr = ks10_t::readMem(tempAddr);
        ks10_t::writeMem(tempAddr, tempData);

        //
        // Retreive and print the Halt Status Block
        //

        const ks10_t::haltStatusBlock_t haltStatusBlock = ks10_t::getHaltStatusBlock(hsbAddr);
        printf("  PC  is %012llo     HR  is %012llo\n"
               "  MAG is %012llo     ONE is %012llo\n"
               "  AR  is %012llo     ARX is %012llo\n"
               "  BR  is %012llo     BRX is %012llo\n"
               "  EBR is %012llo     UBR is %012llo\n"
               "  MSK is %012llo     FLG is %012llo\n"
               "  PI  is %012llo     X1  is %012llo\n"
               "  TO  is %012llo     T1  is %012llo \n"
               "  VMA is %012llo     FE  is %012llo\n"
               "KS10> ",
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
               haltStatusBlock.vma,
               haltStatusBlock.fe);
    }
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
#if 0
        ks10_t::run(true);
#endif
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
        ks10_t::contin();
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

#if 1

//!
//! Test DZ11
//!
//! The <b>DZ</b> (DZ11) tests the DZ11 Terminal Multiplexer
//

static void cmdDZ(int argc, char *argv[]) {
    const char *usage =
        "Usage: DZ {TX port | RX port | EC[HO] port}.\n"
        "DZ11 Tests.\n"
        "  DZ TX port - Test one of the DZ11 Transmitters.\n"
        "  DZ RX port - Test one of the DZ11 Receivers.\n"
        "  DZ ECHO port - Echo receiver back to transmitter."
        "  Valid ports are 0-7.\n"
        "  Note: This is all 9600 baud, no parity, 8 data bit, 1 stop bit.\n";

    char *buf = argv[1];
    if ((argc == 3) && (buf[0] =='T') && (buf[1] >= 'X')) {
        if ((*argv[2] >= '0') && (*argv[2] <= '7')) {
            dz11_t::testTX(*argv[2]);
        } else {
            printf(usage);
        }
    } else if ((argc == 3) && (buf[0] =='R') && (buf[1] >= 'X')) {
        if ((*argv[2] >= '0') && (*argv[2] <= '7')) {
            dz11_t::testRX(*argv[2]);
        } else {
            printf(usage);
        }
    } else if ((argc == 3) && (buf[0] =='E') && (buf[1] >= 'C')) {
        if ((*argv[2] >= '0') && (*argv[2] <= '7')) {
            dz11_t::testECHO(*argv[2]);
        } else {
            printf(usage);
        }
    } else {
        printf(usage);
    }
}

#endif

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

bool running = false;

#if 1
static void cmdGO(int argc, char *argv[]) {
    const char *usage =
        "Usage: GO\n"
        "Set the RUN, EXEC, and CONT bits\n";

    if (argc == 3) {
        ks10_t::writeMem(000030, 0000000000000);        // Initialize switch register
        ks10_t::writeMem(000031, 0000000000000);        // Initialize keep-alive
        ks10_t::writeMem(000032, 0000000000000);        // Initialize CTY input word
        ks10_t::writeMem(000033, 0000000000000);        // Initialize CTY output word
        ks10_t::writeMem(000034, 0000000000000);        // Initialize KTY input word
        ks10_t::writeMem(000035, 0000000000000);        // Initialize KTY output word
        ks10_t::writeMem(000036, 0000000000000);        // Initialize RH11 base address
        ks10_t::writeMem(000037, 0000000000000);        // Initialize UNIT number
        ks10_t::writeMem(000040, 0000000000000);        // Initialize magtape params.

        ks10_t::trapEnable(true);
        ks10_t::timerEnable(false);

        printf("COM block initialized\n");
        loadCode("diag/subsm.sav");
        printf("Loaded diag/subsm.sav\n");
        loadCode("diag/smddt.sav");
        printf("Loaded diag/smddt.sav\n");
        loadCode("diag/smmon.sav");
        printf("Loaded diag/smmon.sav\n");
        loadCode(argv[1]);
        //readDatFile(argv[1]);
        printf  ("Loaded %s\n", argv[1]);

#if 0
        loadCode("diag/dskea.sav");
        printf  ("Loaded diag/dskea.sav\n");
#endif
#if 0
        loadCode("diag/dsrpa.sav");
        printf  ("Loaded diag/dsrpa.sav\n");
#endif
#if 0
        loadCode("diag/dsmmc.sav");
        printf  ("Loaded diag/dsmmc.sav\n");
#endif
#if 0
        loadCode("diag/dskaa.sav");
        printf("Loaded diag/dskaa.sav\n");
#endif
        ks10_t::data_t start = parseOctal(argv[2]);

        ks10_t::writeRegCIR(0254000000000 | start);
        //ks10_t::writeRegCIR(0254000030010);
        printf("Wrote CIR\n");
        ks10_t::writeMem(030057, 0254200030060);        // Halt
        ks10_t::writeMem(025163, 0254000025172);        // Skip disk

        //ks10_t::writeMem(007304, 000000000600);
        //ks10_t::writeMem(007366, 000000000100);

        printf("Patched code\n");
        //intf("Starting up...\n");
        if (ks10_t::cpuReset()) {
            printf("????? KS10 should not be reset.\n");
        }
        if (!ks10_t::halt()) {
            printf("????? KS10 should be halted.\n");
        }
        running = true;
        ks10_t::begin();
        if (!ks10_t::run()) {
            printf("????? KS10 should be running.\n");
        }
        while (!ks10_t::halt()) {
            ks10_t::data_t cty_out = ks10_t::readMem(000033);
            if ((cty_out & 0x0100) != 0) {
                printf("%c", ((unsigned char)(cty_out & 0x7f)));
                ks10_t::writeMem(000033, 0000000000000);
            }
            int ch = getchar();
            if (ch != -1) {
                ks10_t::data_t cty_in = ks10_t::readMem(000032);
                if ((cty_in & 0x0100) == 0) {
                    ks10_t::writeMem(000032, 0x0100 | (ch & 0xff));
                    ks10_t::cpuIntr();
                }
            }
        }
        running = false;
    } else {
        printf(usage);
    }
}

#endif

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
        printf("Halted\n");
    } else {
        printf(usage);
    }
}

#if 1

static void cmdHS(int , char *[]) {
    printHaltStatus();
}

#endif

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
        printf("Address is %08llo\n", ks10_t::readRegAddr());
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

#if 1

//
//! Memory Read
//!
//! This function peforms memory reads.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the argument.
//

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

#if 1

//
// Test RH11
//

static void cmdRH(int argc, char *argv[]) {
    const char *usage =
        "Usage: RH {CLR | STAT | FIFO | RPLA | `READ | WRITE}\n"
        "RH11 Tests.\n"
        " RH CLR - RH11 Controller Clear\n"
        " RH STAT - Print Debug Register\n"
        " RH FIFO - Test RH11 FIFO\n"
        " RH RPLA - Test RH11 RPLA\n"
        " RH READ - Test RH11 Disk Read\n"
        " RH WRITE - Test RH11 Disk Write\n";

    char *buf = argv[1];
    if ((argc == 2) && (buf[0] == 'F' && buf[1] == 'I' && buf[2] == 'F' && buf[3] == 'O')) {
        rh11_t::testFIFO();
    } else if ((argc == 2) && (buf[0] == 'R' && buf[1] == 'P' && buf[2] == 'L' && buf[3] == 'A')) {
        rh11_t::testRPLA();
    } else if ((argc == 2) && (buf[0] == 'R' && buf[1] == 'E' && buf[2] == 'A' && buf[3] == 'D')) {
        rh11_t::testRead(0);
    } else if ((argc == 2) && (buf[0] == 'W' && buf[1] == 'R' && buf[2] == 'I' && buf[3] == 'T')) {
        rh11_t::testWrite(0);
    } else if ((argc == 2) && (buf[0] == 'C' && buf[1] == 'L' && buf[2] == 'R')) {
        rh11_t::clear();
    } else if ((argc == 2) && (buf[0] == 'S' && buf[1] == 'T' && buf[2] == 'A' && buf[3] == 'T')) {
        printRH11Debug();
    } else {
        printf(usage);
    }
}

#endif

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
        ks10_t::step();
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
            ks10_t::begin();
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

#if 1

//
//! Memory Write
//!
//! This function peforms writes to memory.
//!
//! \param [in] argc
//!    Number of arguments.
//!
//! \param [in] argv
//!    Array of pointers to the arguments.
//

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
            } else if (strncmp(argv[2], "REGCIR", 4) == 0) {
                printf("  CIR Register: %012llo.\n", ks10_t::readRegCIR());
            } else if (strncmp(argv[2], "REGSTAT", 4) == 0) {
                printf("  Status Register: %012llo.\n", ks10_t::readRegStat());
            } else if (strncmp(argv[2], "RH11DEBUG", 4) == 0) {
                printRH11Debug();
            }
        } else if (*argv[1] == 'W') {
            if (strncmp(argv[2], "REGCIR", 4) == 0) {
                ks10_t::writeRegCIR(0254000020000);
                printf(" CIR Register written.\n");
            } else if (strncmp(argv[2], "REGDIR", 4) == 0) {
                ks10_t::writeRegCIR(0);
                printf(" CIR Register written.\n");
            }
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

static void parseCommand(char * buf) {

//static void taskCommand(void * param) {
//    char * buf = reinterpret_cast<char *>(param);

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
#if 1
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
#if 1
        {"GO", cmdGO},
#endif
        {"HA", cmdHA},
#if 1
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
        {"PE", cmdXX},          // Not implemented.
        {"PM", cmdXX},          // Not implemented.
        {"PW", cmdXX},          // Not implemented.
        {"RC", cmdXX},          // Not implemented.
        {"RP", cmdXX},          // Not implemented.
#if 1
        {"RD", cmdRD},          // Simple memory read
#endif
#if 1
        {"RH", cmdRH},          // RH11 Tests
#endif
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
#if 1
        {"WR", cmdWR},          // Simple memory write
#endif
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
    //printf("%s ", prompt);
    //xTaskDelete(NULL);
}

//
//! Command processing task
//!
//! \param
//!    param - pointer to command line buffer
//!
//! \note
//!    When the command finishes executing, the task deletes itself.
//

void taskCommand(void * param) {
    char * buf = reinterpret_cast<char *>(param);
    parseCommand(buf);
    printf(PROMPT);
    xTaskDelete(NULL);
}

//
//! Command Processing
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
//

void startCommandTask(char *lineBuffer, xTaskHandle &taskHandle) {

    static char __align64 stack[4096-4];
    portBASE_TYPE status = xTaskCreate(taskCommand, "Command", stack, sizeof(stack), lineBuffer, taskCommandPriority, &taskHandle);
    if (status != pdPASS) {
        debug("RTOS: Failed to create Command task.  Status was %s.\n", taskError(status));
    }

}
