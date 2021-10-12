//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    RH11 Interface Object
//!
//! \details
//!    This object allows the console to interact with the RH11 Disk Controller.
//!    This is mostly for testing the RH11 from the console.
//!
//! \file
//!    rh11.cpp
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
#include "rp.hpp"
#include "uba.hpp"
#include "rh11.hpp"
#include "vt100.hpp"
#include "commands.hpp"

#undef RH11_VERBOSE

//
//! \brief
//!    RH11 Controller Clear
//

void rh11_t::clear(void) {
    ks10_t::writeIO(addrCS2, RHCS2_CLR);
}

//!
//! \brief
//!    Wait for disk operation to complete and check for errors
//!
//! \param [in] verbose -
//!    Whine about errors if true.
//!
//! \returns
//!    True if no errors, false otherwise.
//!

bool rh11_t::wait(bool verbose) {

    bool success = true;

    //
    // Verify that disk goes busy
    //

    if (!(ks10_t::readIO16(addrCS1) & RHCS1_RDY)) {
        success = false;
        if (verbose) {
            printf("KS10: Error: Disk should be busy.\n");
        }
    }

    //
    // Wait for disk or tape operation to complete
    //

    for (int i = 0; i < 1000; i++) {
        if (ks10_t::readIO16(addrCS1) & RHCS1_RDY) {
            break;
        }
        usleep(100);
    }

    //
    // Check ready status
    //

    if (!(ks10_t::readIO16(addrCS1) & RHCS1_RDY)) {
        success = false;
        if (verbose) {
            printf("KS10: Error: Disk Timeout.\n");
        }
    }

    //
    // Check for disk/tape errors
    //

#if 0
    if (ks10_t::readIO16addrCS1) & RHCS1_SC) {
        success = false;
        if (verbose) {
            printf("KS10: Error: CS1 = %012llo\n", ks10_t::readIO16addrCS1));
            printf("             CS2 = %012llo\n", ks10_t::readIO16addrCS2));
            printf("             DS  = %012llo\n", ks10_t::readIO16addrDS));
        }
    }
#endif

    return success;
}

//!
//! \brief
//!    This tests the operation of the RH11 FIFO (aka SILO)
//!

void rh11_t::testFIFO(void) {
    bool fail = false;

    //
    // Controller Clear
    //

#if 0
    ks10_t::writeIO(addrCS2, RHCS2_CLR);
#endif

    //
    // Test buffer operation
    //

    for (int i = 0; i < 70; i++) {

        //
        // Read CS2
        //

        ks10_t::data_t regCS2 = ks10_t::readIO(addrCS2);

        //
        // Check results
        //

        switch (i) {
            case 0:
                if (!(regCS2 & RHCS2_IR)) {
                    fail = true;
                    printf("KS10: RHCS2[IR] should be set after reset\n");
                }
                if (regCS2 & RHCS2_OR) {
                    fail = true;
                    printf("KS10: RHCS2[OR] Should be clear after reset\n");
                }
                break;
            case 1 ... 65:
                if (!(regCS2 & RHCS2_IR)) {
                    fail = true;
                    printf("KS10: RHCS2[IR] should be set after %d entries.\n", i);
                }
                if (!(regCS2 & RHCS2_OR)) {
                    fail = true;
                    printf("KS10: RHCS2[OR] Should be set after %d entries.\n", i);
                }
                break;
            case 66 ... 75:
                if (regCS2 & RHCS2_IR) {
                    fail = true;
                    printf("KS10: RHCS2[IR] should be clear after %d entries.\n", i);
                }
                if (!(regCS2 & RHCS2_OR)) {
                    fail = true;
                    printf("KS10: RHCS2[OR] Should be set after %d entries.\n", i);
                }
                break;
        }

        //
        // Write data to RHDB
        //

        ks10_t::writeIO(addrDB, static_cast<ks10_t::data_t>(0xff00 + i));

    }

    //
    // Uload the FIFO.   Check for correctness.
    //

    for (unsigned int i = 0; i < 70; i++) {

        //
        // Read data from FIFO
        //

        ks10_t::data_t rhdb = ks10_t::readIO(addrDB);

        //
        // Check results
        //

        switch (i) {
            case 0 ... 65:
                if (rhdb != (0xff00 + i)) {
                    fail = true;
                    printf("KS10: Data from FIFO is incorrect on word %d.\n"
                           "      Expected 0x%04x.  Received 0x%04llx.\n",
                           i, 0xff00 + i, rhdb);
                }
                break;
            case 66 ... 75:
                if (rhdb != 0) {
                    fail = true;
                    printf("KS10: Data from FIFO is incorrect on word %d.\n"
                           "      Expected 0x%04x.  Received 0x%04llx.\n",
                           i, 0, rhdb);
                }
        }
    }

    //
    // Print results
    //

    printf("KS10: RHDB FIFO test %s.\n", fail ? "failed" : "passed");

}
