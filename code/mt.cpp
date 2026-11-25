//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    MT Interface Object
//!
//! \details
//!    This object allows the console to interact with the RH11 Massbus
//!    Controller, MT03 Tape Formatter, and TU-45 Tape Drive.
//!
//! \file
//!    mt.hpp
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
//

#include "stdio.h"
#include "mt.hpp"
#include "uba.hpp"
#include "dasm.hpp"
#include "rh11.hpp"
#include "vt100.hpp"
#include "commands.hpp"

#define MT_VERBOSE

//!
//! \brief
//!    Print the tape density
//!

const char *mt_t::printDEN(uint16_t den) {
    static const char * const density[8] = {
        "200 BPI NRZ",          // 00
        "556 BPI NRZ",          // 01
        "800 BPI NRZ",          // 02
        "800 BPI NRZ",          // 03
        "1600 BPI PE",          // 04
        "DEN 5",                // 05
        "DEN 6",                // 06
        "DEN 7",                // 07
    };
    return density[den & 0x0007];
}

//!
//! \brief
//!    Print the tape format
//!

const char *mt_t::printFMT(uint16_t fmt) {
    static const char * const format[16] = {
        "PDP-10 Core Dump",     // 00
        "PDP-15 Core Dump",     // 01
        "PDP-10 ASCII",         // 02
        "PDP-10 Normal",        // 03
        "FMT 04",               // 04
        "FMT 05",               // 05
        "FMT 06",               // 06
        "FMT 07",               // 07
        "FMT 10",               // 10
        "FMT 11",               // 11
        "PDP-11 Normal",        // 12
        "PDP-11 Core Dump",     // 13
        "PDP-15 Normal",        // 14
        "FMT 15",               // 15
        "FMT 16",               // 16
        "FMT 17",               // 17
    };
    return format[fmt & 0x000f];
}

//!
//! \brief
//!    Print the function
//!

const char *mt_t::printFUN(uint16_t fun) {
    static const char * const function[32] = {
        "No-Op",                // 00
        "Unload",               // 01
        "Illegal Function",     // 02
        "Rewind",               // 03
        "Drive Clear",          // 04
        "Illegal Function",     // 05
        "Illegal Function",     // 06
        "Illegal Function",     // 07
        "Preset",               // 10
        "Illegal Function",     // 11
        "Erase",                // 12
        "Write Tape Mark",      // 13
        "Space Forward",        // 14
        "Space Reverse",        // 15
        "Illegal Function",     // 16
        "Illegal Function",     // 17
        "Illegal Function",     // 20
        "Illegal Function",     // 21
        "Illegal Function",     // 22
        "Illegal Function",     // 23
        "Write Check Forward",  // 24
        "Illegal Function",     // 25
        "Illegal Function",     // 26
        "Write Check Reverse",  // 27
        "Write Forward",        // 30
        "Illegal Function",     // 31
        "Illegal Function",     // 32
        "Illegal Function",     // 33
        "Read Forward",         // 34
        "Illegal Function",     // 35
        "Illegal Function",     // 36
        "Read Reverse",         // 37
    };
    return function[fun & 0x001f];
}

//!
//! \brief
//!    Print the Maintenance OPeration (MOP)
//!

const char *mt_t::printMOP(uint16_t mop) {
    static const char * const op[16] = {
        "NOP",                                  // 00
        "Interchange Read",                     // 01
        "Even Parity",                          // 02
        "Data Wraparound, Global",              // 03
        "Data Wraparound, Partial",             // 04
        "Data Wraparound, Formatter Write",     // 05
        "Data Wraparound, Formatter Read",      // 06
        "Cripple Reception of OCC",             // 07
        "Supress CRC check in NRZI mode",       // 10
        "Force Data Errors",                    // 11
        "MM EOF",                               // 12
        "Inv preamble/postamble in PE mode",    // 13
        "Unrecognized OP",                      // 14
        "Unrecognized OP",                      // 15
        "Unrecognized OP",                      // 16
        "Unrecognized OP",                      // 17
    };
    return op[mop & 0x000f];
}

//!
//! \brief
//!    Print MTCS1
//!

void mt_t::dumpMTCS1(ks10_t::addr_t addr) {
    uint16_t mtcs1 = ks10_t::readIO16(addr);
    printf("      MTCS1 = %06o %s%s%s%s%s%s%s%s%s%sFUN=%s%s\n",
           mtcs1,
           mtcs1 != 0     ? "("    : "",
           mtcs1 & 0x8000 ? "SC "  : "",
           mtcs1 & 0x4000 ? "TRE " : "",
           mtcs1 & 0x2000 ? "CPE " : "",
           mtcs1 & 0x0800 ? "DVA " : "",
           mtcs1 & 0x0200 ? "A17 " : "",
           mtcs1 & 0x0100 ? "A16 " : "",
           mtcs1 & 0x0080 ? "RDY " : "",
           mtcs1 & 0x0040 ? "IE "  : "",
           mtcs1 & 0x0001 ? "GO "  : "",
           printFUN((mtcs1 & 0x003e) >> 1),
           mtcs1 != 0     ? ")"     : "");
}

//!
//! \brief
//!    Print MTCS2
//!

void mt_t::dumpMTCS2(ks10_t::addr_t addr) {
    uint16_t mtcs2 = ks10_t::readIO16(addr);
    printf("      MTCS2 = %06o %s%s%s%s%s%s%s%s%s%s%s%s%s%sUNIT=%d%s\n",
           mtcs2,
           mtcs2 != 0     ? "("     : "",
           mtcs2 & 0x8000 ? "DLT "  : "",
           mtcs2 & 0x4000 ? "WCE "  : "",
           mtcs2 & 0x2000 ? "UPE "  : "",
           mtcs2 & 0x1000 ? "NED "  : "",
           mtcs2 & 0x0800 ? "NEM "  : "",
           mtcs2 & 0x0400 ? "PGE "  : "",
           mtcs2 & 0x0200 ? "MXF "  : "",
           mtcs2 & 0x0100 ? "MDPE " : "",
           mtcs2 & 0x0080 ? "OR "   : "",
           mtcs2 & 0x0040 ? "IR "   : "",
           mtcs2 & 0x0020 ? "CLR "  : "",
           mtcs2 & 0x0010 ? "PAT "  : "",
           mtcs2 & 0x0008 ? "BAI "  : "",
           (mtcs2 & 0x0007),
           mtcs2 != 0     ? ")"     : "");
}

//!
//! \brief
//!    Print MTDS
//!

void mt_t::dumpMTDS(ks10_t::addr_t addr) {
    uint16_t mtds = ks10_t::readIO16(addr);
    printf("      MTDS  = %06o %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n",
           mtds,
           mtds != 0     ? "("     : "",
           mtds & 0x8000 ? "ATA "  : "",
           mtds & 0x4000 ? "ERR "  : "",
           mtds & 0x2000 ? "PIP "  : "",
           mtds & 0x1000 ? "MOL "  : "",
           mtds & 0x0800 ? "WRL "  : "",
           mtds & 0x0400 ? "EOT "  : "",
           mtds & 0x0100 ? "DPR "  : "",
           mtds & 0x0080 ? "DRY "  : "",
           mtds & 0x0040 ? "SSC "  : "",
           mtds & 0x0020 ? "PES "  : "",
           mtds & 0x0010 ? "SDWN " : "",
           mtds & 0x0008 ? "IDB "  : "",
           mtds & 0x0004 ? "TM "   : "",
           mtds & 0x0002 ? "BOT "  : "",
           mtds & 0x0001 ? "SLA "  : "",
           mtds != 0     ? ")"     : "");
}

//!
//! \brief
//!    Print MTER
//!

void mt_t::dumpMTER(ks10_t::addr_t addr) {
    uint16_t mter = ks10_t::readIO16(addr);
    printf("      MTER  = %06o %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n",
           mter,
           mter != 0     ? "("        : "",
           mter & 0x8000 ? "COR/CRC " : "",
           mter & 0x4000 ? "UNS "     : "",
           mter & 0x2000 ? "OPI "     : "",
           mter & 0x1000 ? "DTE "     : "",
           mter & 0x0800 ? "NEF "     : "",
           mter & 0x0400 ? "CS/ITM "  : "",
           mter & 0x0200 ? "FCE "     : "",
           mter & 0x0100 ? "NSG "     : "",
           mter & 0x0080 ? "PEF/LRC " : "",
           mter & 0x0040 ? "INC/VPE " : "",
           mter & 0x0020 ? "DPAR "    : "",
           mter & 0x0010 ? "FMTE "    : "",
           mter & 0x0008 ? "PAR "     : "",
           mter & 0x0004 ? "RMR "     : "",
           mter & 0x0002 ? "ILR "     : "",
           mter & 0x0001 ? "ILF "     : "",
           mter != 0     ? ")"        : "");
}

//!
//! \brief
//!    Print MTMR
//!

void mt_t::dumpMTMR(ks10_t::addr_t addr) {
    uint16_t mtmr = ks10_t::readIO16(addr);
    printf("      MTMR  = %06o (%03o %s%s%s %s)\n",
           mtmr,
           (mtmr & 0xff80) >> 7,
           (mtmr & 0x0040) ? "SWC2 " : "",
           (mtmr & 0x0020) ? "MC "   : "",
           printMOP((mtmr & 0x001e) >> 1),
           (mtmr & 0x0001) ? "MM "   : "");
}

//!
//! \brief
//!    Print MTWC
//!

void mt_t::dumpMTWC(ks10_t::addr_t addr) {
    uint16_t mtwc = ks10_t::readIO16(addr);
    printf("      MTWC  = %06o (%u)\n", mtwc, 65536-mtwc);
}

//!
//! \brief
//!    Print MTFC
//!

void mt_t::dumpMTFC(ks10_t::addr_t addr) {
    uint16_t mtfc = ks10_t::readIO16(addr);
    printf("      MTFC  = %06o (%u, %u)\n", mtfc, mtfc, 65536-mtfc);
}

//!
//! \brief
//!    Print MTTC
//!

void mt_t::dumpMTTC(ks10_t::addr_t addr) {
    uint16_t mttc = ks10_t::readIO16(addr);
    printf("      MTTC  = %06o (%s%s%s%s%sDEN=\"%s\" FMT=\"%s\" Slave=%d)\n",
           mttc,
           mttc & 0x8000 ? "ACCL "    : "",
           mttc & 0x4000 ? "FCS "     : "",
           mttc & 0x2000 ? "SAC "     : "",
           mttc & 0x1000 ? "EAO/DTE " : "",
           mttc & 0x0010 ? "PAR "     : "",
           printDEN((mttc >> 8) & 0x07),
           printFMT((mttc >> 4) & 0x0f),
           ((mttc >> 0) & 0x07));
}

//!
//! \brief
//!   Dump MT registers
//!
//! \todo
//!   This doesn't select the drive correctly
//!

void mt_t::dumpRegs(uint16_t tcu, uint16_t param) {

    (void) tcu;
    (void) param;

    dumpMTCS1(addrCS1);
    dumpMTCS2(addrCS2);
    dumpMTDS(addrDS);
    dumpMTER(addrER);
    dumpMTWC(addrWC);
    dumpMTFC(addrFC);
    dumpMTTC(addrTC);
    printf("      MTBA  = %06o\n"
           "      MTAS  = %06o\n"
           "      MTCC  = %06o\n"
           "      MTDB  = %06o\n"
           "      MTMR  = %06o\n"
           "      MTDT  = %06o\n"
           "      MTSN  = %06o\n"
           "      MTCCR = 0x%08x\n",
           ks10_t::readIO16(addrBA),
           ks10_t::readIO16(addrAS),
           ks10_t::readIO16(addrCC),
           ks10_t::readIO16(addrDB),
           ks10_t::readIO16(addrMR),
           ks10_t::readIO16(addrDT),
           ks10_t::readIO16(addrSN),
           ks10_t::readMTCCR());
}

//!
//! \brief
//!   executeCommand()
//!

void mt_t::executeCommand(uint16_t tcu, uint16_t param, uint16_t cmd, uint16_t wordCnt, uint16_t frameCnt, ks10_t::addr_t vaddr) {

#if 1

    //
    // Mask off slave select
    //

    uint16_t unit = param & MTTC_SS;

    switch (cmd) {
        case MTCS1_FUN_DRVCLR:
            printf("KS10: Unit %d: Drive clear command.\n", unit);
            break;
        case MTCS1_FUN_REWIND:
            printf("KS10: Unit %d: Rewind commmand.\n", unit);
            break;
        case MTCS1_FUN_SPCFWD:
            printf("KS10: Unit %d: Space forward commmand.\n", unit);
            break;
        case MTCS1_FUN_RDFWD:
            printf("KS10: Unit %d: Read forward command.\n", unit);
            break;
    }

#endif

    //
    // Set MTTC
    //  Only set DEN[2:0], FMT[3:0], SS[2:0]
    //  Mask everything else off
    //

    ks10_t::writeIO(addrTC, param & 0x07f7);

    //
    // Controller clear
    //

    ks10_t::writeIO(addrCS2, MTCS2_CLR);

    //
    // Set word count (MTWC)
    //

    ks10_t::writeIO(addrWC, CMPL2(wordCnt));

    //
    // Configure RHBA
    //  Set UBA virtual address
    //

    ks10_t::writeIO(addrBA, vaddr);

    //
    // Configure MTFC
    //  Set to maximum value
    //

    ks10_t::writeIO(addrFC, CMPL2(frameCnt));

    //
    // Configure MTCS2
    //  Select tape control unit
    //  The unit is not selectable
    //

    ks10_t::writeIO(addrCS2, tcu & 7);

    //
    // Set MTTC
    //  Only set DEN[2:0], FMT[3:0], SS[2:0]
    //  Mask everything else off
    //

    ks10_t::writeIO(addrTC, param & 0x07f7);

    //
    // Execute the command
    //

    ks10_t::writeIO(addrCS1, (ks10_t::readIO16(addrCS1) & 0xffc0) | cmd);

    //
    // Check status after the command
    //

    if ((cmd == MTCS1_FUN_REWIND) || (cmd == MTCS1_FUN_UNLOAD) || (cmd == MTCS1_FUN_PRESET)) {

        //
        // Rewind-like commands may not show busy depending on tape position.
        //

        for (int i = 0; i < 20000; i++) {
            if (ks10_t::readIO16(addrDS) & MTDS_DRY) {
                ks10_t::writeIO(addrAS, 1 << tcu);
                break;
            }
            usleep(1000);
        }

        //
        // Wait for BOT to assert again to indicate that the rewind is complete
        //
        // Time out after 7 minutes
        //

        for (int i = 0; i < 420000; i++) {
            if (ks10_t::readIO16(addrDS) & MTDS_BOT) {
                ks10_t::writeIO(addrAS, 1 << tcu);
                break;
            }
            usleep(1000);
        }

    } else {

        //
        // Non rewind-like commands
        // Tape should be busy right after command
        //

        if (ks10_t::readIO16(addrDS) & MTDS_DRY) {
            printf("KS10: Tape Drive should be busy.\n");
        }

        //
        // Wait for the command to complete.
        //
        // Time out after twenty seconds
        //

        for (int i = 0;; i++) {
            if (ks10_t::readIO16(addrDS) & MTDS_DRY) {
                break;
            } else if (i > 20000) {
                printf("KS10: Drive timedout\n");
                break;
            }
            usleep(1000);
        }
    }

    //
    // Check for Frame Count Errors
    //
    //  A Space Forward with a Frame Count of zero spaces to the tape mark.
    //  The Frame Counter never reaches zero, so FCE is expected.
    //

    bool spaceToTM = (cmd == MTCS1_FUN_SPCFWD) && (frameCnt == 0);

    if (!spaceToTM && (ks10_t::readIO16(addrER) & MTER_FCE)) {
        printf("KS10: Frame Count Error\n");
    }

}

//!
//! \brief
//!    Rewind the selected tape transport
//!

void mt_t::cmdRewind(uint16_t tcu, uint16_t param) {
    executeCommand(tcu, param, MTCS1_FUN_REWIND);
}

//!
//! \brief
//!    Unload the selected tape transport
//!

void mt_t::cmdUnload(uint16_t tcu, uint16_t param) {
    executeCommand(tcu, param, MTCS1_FUN_UNLOAD);
}

//!
//! \brief
//!    Preset the selected tape transport
//!

void mt_t::cmdPreset(uint16_t tcu, uint16_t param) {
    executeCommand(tcu, param, MTCS1_FUN_PRESET);
}

//!
//! \brief
//!    Space forward command
//!

void mt_t::cmdSpaceFwd(uint16_t tcu, uint16_t param, uint16_t frameCount) {
    (void) tcu;
    (void) param;
    (void) frameCount;
    printf("mt cmdSpaceFwd() not implemented.\n");
//  executeCommand(MTCS1_FUN_SPCFWD, param, );
}

//!
//! \brief
//!    Space reverse command
//!

void mt_t::cmdSpaceRev(uint16_t tcu, uint16_t param, uint16_t frameCount) {
    (void) tcu;
    (void) param;
    (void) frameCount;
    printf("mt cmdSpaceRev() not implemented.\n");
//  executeCommand(MTCS1_FUN_SPCREV, param, );
}

//!
//! \brief
//!    Erase command
//!

void mt_t::cmdErase(uint16_t tcu, uint16_t param) {
    (void) tcu;
    (void) param;
    printf("mt cmdErase() not implemented.\n");
}

//!
//! \brief
//!    Test Tape Initialization
//!
//! \param [in] param -
//!    Selected tape parameters
//!

void mt_t::testInit(uint16_t tcu, uint16_t param) {

    bool fail = false;

    //
    // Select Controller Unit (TCU)
    // Tape Controller Unit is always 0
    //

    ks10_t::writeIO(addrCS2, (ks10_t::readIO(addrCS2) & ~MTCS2_UNIT) | (tcu & 7));

    //
    // Set MTTC
    //  Only set DEN[2:0], FMT[3:0], SS[2:0]
    //  Mask everything else off
    //

    ks10_t::writeIO(addrTC, param & 0x07f7);


    //
    // Controller Clear
    //

#if 1
    ks10_t::writeIO(addrCS2, MTCS2_CLR);
#endif


    //
    // Check if tape in on-line
    //

    if (!(ks10_t::readIO(addrDS) & MTDS_MOL)) {
        printf("KS10: Tape is off-line.\n");
        return;
    }

    //
    // Wait for initialization to complete
    //

    for (int i = 0; i < 1000; i++) {
        if (ks10_t::readIO(addrDS) & MTDS_MOL) {
            break;
        }
        usleep(100);
    }

    if (!(ks10_t::readIO(addrDS) & MTDS_MOL)) {
        fail = true;
        printf("KS10: Tape initialization timeout.\n");
    }

#if 0

    //
    // Check Volume Valid
    //

    if (ks10_t::readIO(addrDS) & MTDS_VV) {
        fail = true;
        printf("KS10: Volume Valid should not be set after initialization.\n");
    }

    //
    // Issue Reading Preset Command
    //

    ks10_t::writeIO(addrCS1, (ks10_t::readIO(addrCS1) & 0xffc0) | MTCS1_CMDPRE | MTCS1_GO);

    //
    // Recheck Volume Valid
    //

    if (!(ks10_t::readIO(addrDS) & MTDS_VV)) {
        fail = true;
        printf("KS10: Volume Valid should be set after preset command.\n");
    }

#endif

    //
    // Print results
    //

     printf("KS10: Tape initialization test %s.\n", fail ? "failed" : "passed");
}

//!
//! \brief
//!    Test Tape Read
//!
//! \param [in] param -
//!    Selected tape parameters
//!

void mt_t::testRead(uint16_t tcu, uint16_t param) {

    bool pass = true;
    const int words              = 128;
    const ks10_t::addr_t vaddr   = 004000;
    const ks10_t::addr_t paddr   = 070000;
    const ks10_t::data_t pattern = 0525252525252;

    //
    // Select tape
    //

    ks10_t::writeIO(addrCS2, (ks10_t::readIO(addrCS2) & ~MTCS2_UNIT) | (tcu & 7));

    //
    // Check if tape in on-line
    //

    if (!(ks10_t::readIO(addrDS) & MTDS_MOL)) {
        printf("KS10: Tape  is off-line.\n");
        return;
    }

    //
    // Set Unibus mapping
    //  This will page the destination address to 070000
    //

    uba.writePAG(1, uba_t::PAG_FTM | uba_t::PAG_VLD | uba_t::addr2page(paddr));

    //
    // Fill destination with data
    //

    for (int i = -1; i < words + 1; i++) {
        ks10_t::writeMem(paddr + i, pattern);
    }

    //
    // Read a record
    //  The Word Count Register counts 18-bit words, two per KS10 word.
    //

    executeCommand(tcu, param, MTCS1_FUN_RDFWD, 2 * words, 0, vaddr);

    //
    // Check that the words either side of the buffer were not changed
    //

    if (ks10_t::readMem(paddr - 1) != pattern) {
        printf("KS10: Tape read wrote below the buffer.\n");
        pass = false;
    }

    if (ks10_t::readMem(paddr + words) != pattern) {
        printf("KS10: Tape read wrote past the end of the buffer.\n");
        pass = false;
    }

    //
    // Check that some data was transferred
    //

    bool changed = false;
    for (int i = 0; i < words; i++) {
        if (ks10_t::readMem(paddr + i) != pattern) {
            changed = true;
            break;
        }
    }

    if (!changed) {
        printf("KS10: Tape read transferred no data.\n");
        pass = false;
    }

    printf("KS10: Tape read test %s.\n", pass ? "passed" : "failed");
}

//!
//! \brief
//!    Test Tape Write
//!
//! \param [in] param -
//!    Selected tape parameters
//!

void mt_t::testWrite(uint16_t tcu, uint16_t param) {

    bool pass = true;
    const unsigned int words     = 128;
    const ks10_t::addr_t vaddr   = 004000;
    const ks10_t::addr_t paddr   = 070000;
    const ks10_t::data_t pattern = 0123456654321;

#if 1
    (void)param;
#endif

    //
    // Controller Clear
    //

#if 0
    ks10_t::writeIO(addrCS2, MTCS2_CLR);
#endif

    //
    // Select tape
    //

    ks10_t::writeIO(addrCS2, (ks10_t::readIO(addrCS2) & ~MTCS2_UNIT) | (tcu & 7));

    //
    // Check if tape in on-line
    //

    if (!(ks10_t::readIO(addrDS) & MTDS_MOL)) {
        printf("KS10: Tape is off-line.\n");
        return;
    }

    //
    // Create data pattern
    //

    for (unsigned int i = 0; i < words; i++) {
        ks10_t::writeMem(paddr + i, pattern);
    }

    //
    // Configure RHWC
    //

    ks10_t::writeIO(addrWC, -words*2);

    //
    // Set Unibus mapping
    //  This will page the destination to 070000
    //

    uba.writePAG(1, uba_t::PAG_FTM | uba_t::PAG_VLD | uba_t::addr2page(paddr));

    //
    // Set destination address
    //

    ks10_t::writeIO(addrBA, vaddr);

    printf("KS10: Tape write test %s.\n", pass ? "passed" : "failed");
    printf("Not implemented.\n");

}

//!
//! \brief
//!    Test Tape Write Check Command
//!
//! \param [in] param
//!    Magtape paramters (or contents of MTTC register)
//!

void mt_t::testWrchk(uint16_t tcu, uint16_t param) {

    bool pass = true;
    const unsigned int words     = 128;
    const unsigned int vaddr     = 004000;
    const unsigned int paddr     = 070000;
    const ks10_t::data_t pattern = 0123456654321;

#if 1
    (void)vaddr;
    (void)param;
#endif

    //
    // Controller Clear
    //

#if 0
    ks10_t::writeIO(addrCS2, MTCS2_CLR);
#endif

    //
    // Select tape (unit)
    //

    ks10_t::writeIO(addrCS2, (ks10_t::readIO(addrCS2) & ~MTCS2_UNIT) | (tcu & 7));

    //
    // Check if tape in on-line
    //

    if (!(ks10_t::readIO(addrDS) & MTDS_MOL)) {
        printf("KS10: Tape is off-line.\n");
        return;
    }

    //
    // Create data pattern
    //

    for (unsigned int i = 0; i < words; i++) {
        ks10_t::writeMem(paddr + i, pattern);
    }

    //
    // Configure RHWC
    //

    ks10_t::writeIO(addrWC, -words*2);

    //
    // Set Unibus mapping
    //  This will page the destination to 070000
    //

    uba.writePAG(1, uba_t::PAG_FTM | uba_t::PAG_VLD | uba_t::addr2page(paddr));

    //
    // Set destination address
    //

    printf("KS10: Tape write check test %s.\n", pass ? "passed" : "failed");
    printf("Not implemented.\n");

}

//!
//! \brief
//!    Bootstrap from MT
//!
//! \param [in] tcu
//!    Selected tape control unit
//!
//! \param [in] param
//!    Magtape paramters (or contents of MTTC register)
//!
//! \param [in] diagmode
//!    Boot to SMMON
//!

void mt_t::boot(uint16_t tcu, uint16_t param, bool diagmode) {

    const ks10_t::addr_t paddr = 01000;         // KS10 address of tape buffer
    const ks10_t::addr_t vaddr = 04000;         // UBA address of tape buffer

    if (diagmode) {
        printf("KS10: mt boot: diagnostic mode\n");
    } else {
        printf("KS10: mt boot: monitor mode\n");
    }

    //
    // Controller clear
    //

    ks10_t::writeIO(addrCS2, MTCS2_CLR);

    //
    // Set Unibus mapping
    //  This will page the destination to 01000
    //

    uba.writePAG(1, uba_t::PAG_FTM | uba_t::PAG_VLD | uba_t::addr2page(paddr));

    //
    // Select tape control unit
    //

    ks10_t::writeIO(addrCS2, tcu & 7);

    //
    // Set MTTC
    //  Only set DEN[2:0], FMT[3:0], SS[2:0]
    //  Mask everything else off
    //

    ks10_t::writeIO(addrTC, param & 0x07f7);

    //
    // Check if tape is present, on-line, and ready
    //

    uint16_t mtds = ks10_t::readIO(addrDS);

    if (!(mtds & MTDS_DPR)) {
        printf("KS10: Tape Drive not present.\n");
        return;
    }

    if (!(mtds & MTDS_MOL)) {
        printf("KS10: Tape Drive is off-line.\n");
        return;
    }

    if (!(mtds & MTDS_DRY)) {
        printf("KS10: Tape Drive is not ready.\n");
        return;
    }

    //
    // Issue a Drive Clear command
    //

    ks10_t::writeIO(addrCS1, (ks10_t::readIO(addrCS1) & 0xffc0) | MTCS1_FUN_DRVCLR);

    //
    // Controller clear
    //

    ks10_t::writeIO(addrCS2, ks10_t::readIO(addrCS1) | MTCS2_CLR);

    //
    // If not at BOT, issue a rewind commnd
    //

    if (!(mtds & MTDS_BOT)) {
        executeCommand(tcu, param, MTCS1_FUN_REWIND);
    }

    //
    // Clear Attention Summary
    //

    ks10_t::writeIO(addrAS, 0x00ff);

    //
    // Issue a Space Forward Command
    //
    //  This command skips over the microcode
    //

    executeCommand(tcu, param, MTCS1_FUN_SPCFWD);

    //
    // This function reads the Magtape Monitor Boot Strap Program.  See
    //  MAINDEC-10-DSQDF.SEQ starting at line 4913 for more information.
    //

    executeCommand(tcu, param, MTCS1_FUN_RDFWD, 2*512, 0, vaddr);

    //
    // Start executing monitor
    //

    printf("KS10: mt boot: starting address %07llo.\n", paddr);
    ks10_t::writeRegCIR((ks10_t::opJRST << 18) | paddr);
    ks10_t::startRUN();
    command_t::consoleOutput();

}
