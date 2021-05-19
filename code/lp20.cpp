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
// Copyright (C) 2013-2020 Rob Doyle
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
    ks10_t::data_t temp = ks10_t::readIO(csra_addr);
    ks10_t::writeIO(csra_addr, temp | csra_init);
    ks10_t::writeIO(csra_addr, temp);
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

    ks10_t::data_t temp = ks10_t::readIO(csra_addr);
    if ((temp & csra_onln) == 0) {
        printf("KS10: Printer is offline.\n");
        return;
    }

    //
    // Clear tranlation RAM
    //

    for (int i = 0; i < 256; i++) {
        ks10_t::writeIO(cbuf_addr, i);
        ks10_t::writeIO(ramd_addr, 0);
    }

    //
    // Stuff message in KS10 memory for DMA
    //

    packBytes(paddr, test_msg, sizeof(test_msg));

    //
    // Set Unibus mapping
    //  This will page the destination to 070000
    //

    uba_t uba3(uba_t::uba3);
    uba3.pag_write(1, uba_t::pag_vld | (0 + uba_t::addr2page(paddr)));
    uba3.pag_write(2, uba_t::pag_vld | (1 + uba_t::addr2page(paddr)));
    uba3.pag_write(3, uba_t::pag_vld | (2 + uba_t::addr2page(paddr)));
    uba3.pag_write(4, uba_t::pag_vld | (3 + uba_t::addr2page(paddr)));

    //
    // Initialize
    //

    ks10_t::writeIO(csra_addr, csra_init);

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

        ks10_t::writeIO(bctr_addr, -bytes_to_send);
        printf("DMA %d bytes\n", bytes_to_send);

        //
        // Set destination address
        //

        ks10_t::writeIO(bar_addr, vaddr + bytes_sent);

        //
        // Start DMA
        //

        ks10_t::writeIO(csra_addr, csra_go);

        //
        // Wait for DMA to complete
        //

        while ((ks10_t::readIO(csra_addr) & csra_go) != 0) {
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

    uba_t uba3(uba_t::uba3);
    ks10_t::data_t mask16 = 0177777;
    ks10_t::data_t mask08 = 0000377;

    printf("KS10: Register Dump\n"
           "      UBAS: %012llo\n"
           "      CSRA: %06llo\n"
           "      CSRB: %06llo\n"
           "      BAR : %06llo\n"
           "      BCTR: %06llo\n"
           "      PCTR: %06llo\n"
           "      RAMD: %06llo\n"
           "      CCTR: %06llo\n"
           "      CBUF: %06llo\n"
           "      CKSM: %06llo\n"
           "      PDAT: %06llo\n",
           uba3.csr_read(),
           mask16 & ks10_t::readIO(csra_addr),
           mask16 & ks10_t::readIO(csrb_addr),
           mask16 & ks10_t::readIO(bar_addr),
           mask16 & ks10_t::readIO(bctr_addr),
           mask16 & ks10_t::readIO(pctr_addr),
           mask16 & ks10_t::readIO(ramd_addr),
           mask08 & (ks10_t::readIO(cbuf_addr) >> 8),
           mask08 & (ks10_t::readIO(cbuf_addr) >> 0),
           mask08 & (ks10_t::readIO(pdat_addr) >> 8),
           mask08 & (ks10_t::readIO(pdat_addr) >> 0));
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

    ks10_t::data_t temp = ks10_t::readIO(csra_addr);
    if ((temp & csra_onln) == 0) {
        printf("KS10: Printer is offline.\n");
        return;
    }

    //
    // Clear tranlation RAM
    //

    for (int i = 0; i < 256; i++) {
        ks10_t::writeIO(cbuf_addr, i);
        ks10_t::writeIO(ramd_addr, 0);
    }

    //
    // Create buffer
    //

    char buffer[128];

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
        // Set Unibus mapping
        //  This will page the destination to 070000
        //

        uba_t uba3(uba_t::uba3);
        uba3.pag_write(1, uba_t::pag_vld | (0 + uba_t::addr2page(paddr)));
        uba3.pag_write(2, uba_t::pag_vld | (1 + uba_t::addr2page(paddr)));
        uba3.pag_write(3, uba_t::pag_vld | (2 + uba_t::addr2page(paddr)));
        uba3.pag_write(4, uba_t::pag_vld | (3 + uba_t::addr2page(paddr)));

        //
        // Reset LP20
        //

        ks10_t::writeIO(csra_addr, csra_init);

        //
        // Set byte counter
        //

        ks10_t::writeIO(bctr_addr, -numbytes);

        //
        // Set destination address
        //

        ks10_t::writeIO(bar_addr, vaddr);

        //
        // Start DMA
        //

        ks10_t::writeIO(csra_addr, csra_go);

        //
        // Wait for DMA to complete
        //

        while ((ks10_t::readIO(csra_addr) & csra_go) != 0) {
            ;
        }

        usleep(100000);    // FIXME

    }
}
