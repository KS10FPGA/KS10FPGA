//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    DZ11 Interface Object
//!
//! \details
//!    This object allows the console to interact with the DZ11 Terminal
//!    Multiplexer.   This is mostly for testing the DZ11 from the console.
//!
//! \file
//!    dz11.cpp
//!
//! \author
//!    Rob Doyle - doyle (at) cox (dot) net
//
//******************************************************************************
//
// Copyright (C) 2013-2016 Rob Doyle
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
//

#include "stdio.h"
#include "dz11.hpp"

//!
//! \brief
//!    Setup a DZ11 line
//!
//! \param line -
//!    line number
//!

void dz11_t::setup(unsigned int line) {

    //
    // Assert Device Clear
    //

    ks10_t::writeIO(csr_addr, csr_clr);

    //
    // Wait for Device Clear to negate.  This takes about 15 uS.
    //

    while (ks10_t::readIO(csr_addr) & csr_clr) {
        ;
    }

    //
    // Configure Line Parameter Register for 9600,N,8,1
    //

    ks10_t::writeIO(lpr_addr, 0x1e18 | line);

    //
    // Enable selected line
    //

    ks10_t::writeIO(tcr_addr, (1 << line));

    //
    // Enable Master Scan Enable
    //

    ks10_t::writeIO(csr_addr, csr_mse);
}

//!
//! \brief
//!    Print a test message on the selected DZ11 output
//!
//! \param line
//!    ASCII line number
//!

void dz11_t::testTX(char line) {

    //
    // Initialize the DZ11 for this line
    //

    setup((line - '0') & 0x0007);

    //
    // Print test message
    //

    char testmsg[] = "This is a test on DZ11 line ?.\r\n";
    testmsg[28] = line;
    char *s = testmsg;

    while (*s != 0) {

        //
        // Wait for Transmitter Ready (TRDY) to be asserted.
        //

        while ((ks10_t::readIO(csr_addr) & csr_trdy) == 0) {
            ;
        }

        //
        // Output character to Transmitter Data Register
        //

        ks10_t::writeIO(tdr_addr, *s++);
    }
}

//!
//! \brief
//!    Echo the selected TTY input to the console.
//!
//! \param line
//!    ASCII line number
//!

void dz11_t::testRX(char line) {

    printf("Characters typed on TTY%c should echo on the console. ^C to exit.\n", line);

    //
    // Initialize the DZ11 for this line
    //

    setup((line - '0') & 0x0007);

    //
    // Test receiver
    //

    for (;;) {

        //
        // Wait for Receiver Done (RDONE) to be asserted.
        //

        if (ks10_t::readIO(csr_addr) & csr_rdone) {

            //
            // Wait for Transmitter Ready (TRDY) to be asserted
            //

            while (!(ks10_t::readIO(csr_addr) & csr_trdy)) {
                ;
            }

            //
            // Read character from Receiver Buffer (RBUF)
            //

            char ch = ks10_t::readIO(rbuf_addr) & 0xff;

            //
            // Abort on CTRL-C
            //

            if (ch == 3) {
                return;
            }

            printf("%c", ch);

        }
    }
}

//!
//! \brief
//!    Echo the selected TTY input to the back to the TTY output.
//!
//! \param line
//!    ASCII line number
//!

void dz11_t::testECHO(char line) {

    printf("Characters typed on TTY%c should echo. ^C to exit.\n", line);

    //
    // Initialize the DZ11 for this line
    //

    setup((line - '0') & 0x0007);

    //
    // Test echo
    //

    for (;;) {

        //
        // Wait for Receiver Done (RDONE) to be asserted.
        //

        if (ks10_t::readIO(csr_addr) & csr_rdone) {

            //
            // Wait for Transmitter Ready (TRDY) to be asserted
            //

            while (!ks10_t::readIO(csr_addr) & csr_trdy) {
                ;
            }

            //
            // Read character from Receiver Buffer (RBUF)
            //

            char ch = ks10_t::readIO(rbuf_addr) & 0xff;

            //
            // Abort on CTRL-C
            //

            if (ch == 3) {
                return;
            }

            //
            // Echo character to Transmitter Data Register (TDR)
            //

            ks10_t::writeIO(tdr_addr, ch);

        }
    }
}
