//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    LP20 Interface Object
//!
//! \details
//!    This object allows the console to interact with the LP20 Line Printer
//!    Controller
//!
//! \file
//!    lp20.cpp
//!
//! \author
//!    Rob Doyle - doyle (at) cox (dot) net
//
//******************************************************************************
//
// Copyright (C) 2013-2021 Rob Doyle
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
#include "string.h"
#include "uba.hpp"
#include "lp20.hpp"
#include "config.hpp"

//!
//! \brief
//!    Configuration file name
//!

static const char *cfg_file = ".ks10/lp20.cfg";

//!
//! \brief
//!    Recall the non-volatile LP configuration from file
//!

void lp20_t::recallConfig(void) {
    if (!config_t::read(cfg_file, &cfg, sizeof(cfg))) {
        printf("KS10: Unable to read \"%s\".  Using defaults.\n", cfg_file);
        // Set baudrate to 115200 baud, no parity, 8 data bits, 2 stop bits, online
        cfg.lpccr = 0x02590001;
    }
    // Initialize the LP Console Control Register
    ks10_t::writeLPCCR(cfg.lpccr);
}

//!
//! \brief
//!    Save the non-volatile LP configuration to file
//!

void lp20_t::saveConfig(void) {
    cfg.lpccr = ks10_t::readLPCCR();
    if (config_t::write(cfg_file, &cfg, sizeof(cfg))) {
        printf("      lp: sucessfully wrote configuration file \"%s\".\n", cfg_file);
    }
}

//!
//! \brief
//!   DAVFU Data
//!
//! \note
//!   The DAVFU is 12-bits wide
//!

static const uint16_t davfu_data[] = {
    07777,
    00220,
    00224,
    00230,
    00224,
    00620,
    00234,
    00220,
    00224,
    00230,
    00664,
    00220,
    00234,
    00220,
    00224,
    01630,
    00224,
    00220,
    00234,
    00220,
    01764,
    00230,
    00224,
    00220,
    00234,
    02620,
    00224,
    00230,
    00224,
    00220,
    01276,
    00220,
    00224,
    00230,
    00224,
    00620,
    00234,
    00220,
    00224,
    00230,
    04764,
    00220,
    00234,
    00220,
    00224,
    01630,
    00224,
    00220,
    00224,
    00220,
    02664,
    00230,
    00224,
    00220,
    00234,
    00620,
    00224,
    00230,
    00224,
    00220,
    00020,
    00020,
    00020,
    00020,
    00020,
    00020,
};

//!
//! \brief
//!   Initialize the LP20.
//!
//! \details
//!   Briefly assert the INIT bit.
//!

void lp20_t::initialize(void) {
    ks10_t::data_t temp = ks10_t::readIO(addrCSRA);
    ks10_t::writeIO(addrCSRA, temp | LPCSRA_INIT);
    ks10_t::writeIO(addrCSRA, temp);
}

//!
//! \brief
//!    Build print buffer.  Pack the data correctly
//!
//! \details
//!    The print buffer is packed four 8-bit bytes to the KS10 word.  Bits
//!    16, 17, 34, and 35 are not used.
//!

void packBytes(ks10_t::addr_t addr, const char *s, unsigned int size) {

    for (unsigned int i = 0; i < size; i += 4) {
        ks10_t::data_t data = (((ks10_t::data_t)s[i+0] << 18) |
                               ((ks10_t::data_t)s[i+1] << 26) |
                               ((ks10_t::data_t)s[i+2] <<  0) |
                               ((ks10_t::data_t)s[i+3] <<  8));
        ks10_t::writeMem(addr++, data);
    }
}

//!
//! \brief
//!    Print a test message
//!

void lp20_t::testRegs(void) {
    static const char test_msg[] =
        "Hello! Test.\r\n"
        "One.  Two.  Three.  Four.  Five.\r\n";

    const ks10_t::addr_t vaddr = 004000;        // Virtual address (in UBA address space)
    const ks10_t::addr_t paddr = 070000;        // Physical address (in KS10 memory)

    //
    // Is printer online?
    //

    ks10_t::data_t temp = ks10_t::readIO(addrCSRA);
    if ((temp & LPCSRA_ONLN) == 0) {
        printf("KS10: Printer is offline.\n");
        return;
    }

    //
    // Clear tranlation RAM
    //

    for (int i = 0; i < 256; i++) {
        ks10_t::writeIO(addrCBUF, i);
        ks10_t::writeIO(addrRAMD, 0);
    }

    //
    // Stuff message in KS10 memory for DMA
    //

    packBytes(paddr, test_msg, sizeof(test_msg));

    //
    // Set Unibus mapping
    //  This will page the destination to 070000
    //

    uba.writePAG(1, uba_t::PAG_VLD | (0 + uba_t::addr2page(paddr)));
    uba.writePAG(2, uba_t::PAG_VLD | (1 + uba_t::addr2page(paddr)));
    uba.writePAG(3, uba_t::PAG_VLD | (2 + uba_t::addr2page(paddr)));
    uba.writePAG(4, uba_t::PAG_VLD | (3 + uba_t::addr2page(paddr)));

    //
    // Initialize
    //

    ks10_t::writeIO(addrCSRA, LPCSRA_INIT);

    //
    // DMA is limited to 4K words (BCTR is 12-bits)
    //

    unsigned int bytes_sent = 0;
    unsigned int msg_size = sizeof(test_msg);

    while (msg_size > 0) {

        const unsigned int bytes_per_dma = 4092;
        unsigned int bytes_to_send = msg_size;

        //
        // Set Byte Count
        //

        if (bytes_to_send > bytes_per_dma) {
            bytes_to_send = bytes_per_dma;
        }

        ks10_t::writeIO(addrBCTR, -bytes_to_send);
        printf("DMA %d bytes\n", bytes_to_send);

        //
        // Set destination address
        //

        ks10_t::writeIO(addrBAR, vaddr + bytes_sent);

        //
        // Start DMA
        //

        ks10_t::writeIO(addrCSRA, LPCSRA_GO);

        //
        // Wait for DMA to complete
        //

        while ((ks10_t::readIO(addrCSRA) & LPCSRA_GO) != 0) {
            ;
        }

        printf("DMA Completed\n");

        //
        // Adjust size
        //

        msg_size   -= bytes_to_send;
        bytes_sent += bytes_to_send;

    }

}

//!
//! \brief
//!    Dump LP20 registers
//!

void lp20_t::dumpRegs(void) {

    printf("KS10: Register Dump\n"
           "      UBAS: %012llo\n"
           "      CSRA: %06o\n"
           "      CSRB: %06o\n"
           "      BAR : %06o\n"
           "      BCTR: %06o\n"
           "      PCTR: %06o\n"
           "      RAMD: %06o\n"
           "      CCTR: %06o\n"
           "      CBUF: %06o\n"
           "      CKSM: %06o\n"
           "      PDAT: %06o\n"
           "      LPCCR: 0x%08x\n",
           uba.readCSR(),
           ks10_t::readIO16(addrCSRA),
           ks10_t::readIO16(addrCSRB),
           ks10_t::readIO16(addrBAR),
           ks10_t::readIO16(addrBCTR),
           ks10_t::readIO16(addrPCTR),
           ks10_t::readIO16(addrRAMD),
           (ks10_t::readIO16(addrCBUF) >> 8) & 0377,
           (ks10_t::readIO16(addrCBUF) >> 0) & 0377,
           (ks10_t::readIO16(addrPDAT) >> 8) & 0377,
           (ks10_t::readIO16(addrPDAT) >> 0) & 0377,
           ks10_t::readLPCCR());
}

//!
//! \brief
//!    Read a file from the SD card an print it.
//!

void lp20_t::printFile(const char *filename) {

    const ks10_t::addr_t vaddr = 004000;        // Virtual address (in UBA address space)
    const ks10_t::addr_t paddr = 070000;        // Physical address (in KS10 memory)

    FILE *fp = fopen(filename, "r");
    if (fp == NULL) {
        printf("KS10: fopen(%s) failed.\n", filename);
        return;
    }

    //
    // Is printer online?
    //

    ks10_t::data_t temp = ks10_t::readIO(addrCSRA);
    if ((temp & LPCSRA_ONLN) == 0) {
        printf("KS10: Printer is offline.\n");
        return;
    }

    //
    // Clear tranlation RAM
    //

    for (int i = 0; i < 256; i++) {
        ks10_t::writeIO(addrCBUF, i);
        ks10_t::writeIO(addrRAMD, 0);
    }

    //
    // Create buffer
    //

    char buffer[128];

    //
    // Set Unibus mapping
    //  This will page the destination to 070000
    //

    uba.writePAG(1, uba_t::PAG_VLD | (0 + uba_t::addr2page(paddr)));
    uba.writePAG(2, uba_t::PAG_VLD | (1 + uba_t::addr2page(paddr)));
    uba.writePAG(3, uba_t::PAG_VLD | (2 + uba_t::addr2page(paddr)));
    uba.writePAG(4, uba_t::PAG_VLD | (3 + uba_t::addr2page(paddr)));

    //
    // Read file from SD Card into buffer
    //

    while (!feof(fp)) {

        size_t numbytes = fread(buffer, 1, sizeof(buffer), fp);

        //
        // Stuff message in KS10 memory for DMA
        //

        packBytes(paddr, buffer, numbytes);

        //
        // Reset LP20
        //

        ks10_t::writeIO(addrCSRA, LPCSRA_INIT);

        //
        // Set byte counter
        //

        ks10_t::writeIO(addrBCTR, -numbytes);

        //
        // Set destination address
        //

        ks10_t::writeIO(addrBAR, vaddr);

        //
        // Start DMA
        //

        ks10_t::writeIO(addrCSRA, LPCSRA_GO);

        //
        // Wait for DMA to complete
        //

        while ((ks10_t::readIO(addrCSRA) & LPCSRA_GO) != 0) {
            ;
        }

    }
}
