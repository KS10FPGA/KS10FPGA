//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! RH11 Interface Object
//!
//! This object allows the console to interact with the RH11 Disk Controller.
//! This is mostly for testing the RH11 from the console.
//!
//! \file
//!    rh11.cpp
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
//

#include "stdio.h"
#include "rh11.hpp"

//
//! This tests the operation of the RH11 FIFO (aka SILO)
//

void rh11_t::testFIFO(void) {

    //
    // Controller Reset
    //

    ks10_t::writeIO(rhcs2_addr, rhcs2_clr);

    //
    // Read RHCS2
    //

    ks10_t::data_t rhcs2 = ks10_t::readIO(rhcs2_addr);

    //
    // Test buffer operation
    //

    bool fail = false;
    for (int i = 0; i < 70; i++) {

        //
        // Read RHCS2
        //

        rhcs2 = ks10_t::readIO(rhcs2_addr) & 0xffff;
#if 0
        printf("      %2d: RHCS2 is 0x%04llx (%d)\n", 0, rhcs2, i);
#endif

        //
        // Check results
        //

        switch (i) {
            case 0:
                if ((rhcs2 & rhcs2_ir) == 0) {
                    fail = true;
                    printf("      RHCS2[IR] should be set after reset\n");
                }
                if ((rhcs2 & rhcs2_or) != 0) {
                    fail = true;
                    printf("      RHCS2[OR] Should be clear after reset\n");
                }
                break;
            case 1 ... 65:
                if ((rhcs2 & rhcs2_ir) == 0) {
                    fail = true;
                    printf("      RHCS2[IR] should be set after %d entries.\n", i);
                }
                if ((rhcs2 & rhcs2_or) == 0) {
                    fail = true;
                    printf("      RHCS2[OR] Should be set after %d entries.\n", i);
                }
                break;
            case 66 ... 75:
                if ((rhcs2 & rhcs2_ir) != 0) {
                    fail = true;
                    printf("      RHCS2[IR] should be clear after %d entries.\n", i);
                }
                if ((rhcs2 & rhcs2_or) == 0) {
                    fail = true;
                    printf("      RHCS2[OR] Should be set after %d entries.\n", i);
                }
                break;
        }

        //
        // Write data to RHDB
        //

        ks10_t::writeIO(rhdb_addr, (ks10_t::data_t)(0xff00 + i));

    }

    //
    // Uload the FIFO.   Check for correctness.
    //

    for (unsigned int i = 0; i < 70; i++) {

        //
        // Read data from FIFO
        //

        ks10_t::data_t rhdb = ks10_t::readIO(rhdb_addr) & 0xffff;
#if 0
        printf("        ----> 0x%04llx \n", rhdb);
#endif

        //
        // Check results
        //

        switch (i) {
            case 0 ... 65:
                if (rhdb != (0xff00 + i)) {
                    fail = true;
                    printf("      Data from FIFO is incorrect on word %d.\n"
                           "Expected 0x%04llx.  Received 0x%04llx.\n",
                           i, 0xff00 + i, rhdb);
                }
                break;
            case 66 ... 75:
                if (rhdb != 0) {
                    fail = true;
                    printf("      Data from FIFO is incorrect on word %d.\n"
                           "Expected 0x%04llx.  Received 0x%04llx.\n",
                           i, 0, rhdb);
                }
        }
    }

    //
    // Print results
    //

    printf("      RHDB FIFO test %s.\n", fail ? "failed" : "passed");

}

//
//! This tests the operation of the sector byte counter
//

void rh11_t::testRPLA(void) {

    //
    // Controller Reset
    //

    ks10_t::writeIO(rhcs2_addr, rhcs2_clr);

    //
    // Put unit in diagnostic mode.  Assert DMD.
    //

    ks10_t::writeIO(rpmr_addr, mr_dmd);

    //
    // Create index pulse.  Clear byte counter.
    //  DIND asserted with DSCK clock.  Don't reset DMD.
    //

    ks10_t::writeIO(rpmr_addr, mr_dind | mr_dsck | mr_dmd);
    ks10_t::writeIO(rpmr_addr, mr_dmd);

    //
    // Start clocking bytes
    //

    bool fail = false;
    for (int i = 0; i <= 12768; i++) {

        //
        // Read look ahead register RPLA
        //

        unsigned int rpla = ks10_t::readIO(rpla_addr) & 0x0ff0;

        //
        // Check results
        //

        switch (i) {
            case 0 ... 127:
                if (rpla != 0x0000) {
                    fail = true;
                    printf("      RPLA SEC should be 0, EXT should be 0 after %3d clocks\n", i);
                }
                break;
            case 128 ... 255:
                if (rpla != 0x0010) {
                    fail = true;
                    printf("      RPLA SEC should be 0, EXT should be 20 after %3d clocks\n", i);
                }
                break;
            case 256 ... 511:
                if (rpla != 0x0020) {
                    fail = true;
                    printf("      RPLA SEC should be 0, EXT should be 40 after %3d clocks\n", i);
                }
                break;
            case 512 ... 671:
                if (rpla != 0x0030) {
                    fail = true;
                    printf("      RPLA SEC should be 0, EXT should be 60 after %3d clocks\n", i);
                }
                break;
            case 672 ... 799:
                if (rpla != 0x0040) {
                    fail = true;
                    printf("      RPLA SEC should be 1, EXT should be 00 after %3d clocks\n", i);
                }
                break;
            case 800 ... 927:
                if (rpla != 0x0050) {
                    fail = true;
                    printf("      RPLA SEC should be 0, EXT should be 20 after %3d clocks\n", i);
                }
                break;
            case 928 ... 1183:
                if (rpla != 0x0060) {
                    fail = true;
                    printf("      RPLA SEC should be 0, EXT should be 40 after %3d clocks\n", i);
                }
                break;
                //                case 12608 ... 12767:
            case 12767:
                if (rpla != 0x04b0) {
                    fail = true;
                    printf("      RPLA SEC should be 1, EXT should be 00 after %3d clocks\n", i);
                }
                break;
            case 12768:
                if (rpla != 0x0000) {
                    fail = true;
                    printf("      RPLA SEC should be 0, EXT should be 00 after %3d clocks\n", i);
                }
                break;
        }

        //
        // Create clock pulse
        //

        ks10_t::writeIO(rpmr_addr, mr_dsck | mr_dmd);
        ks10_t::writeIO(rpmr_addr, mr_dmd);

    }

    //
    // Print results
    //

    printf("      RPLA/RPMR byte counter test %s.\n", fail ? "failed" : "passed");
}
