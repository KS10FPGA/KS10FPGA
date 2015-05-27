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
#include "uba.hpp"
#include "rh11.hpp"
#include "SafeRTOS/SafeRTOS_API.h"

//
//! RH11 Controller Clear
//

void rh11_t::clear(void) {
    ks10_t::writeIO(rhcs2_addr, rhcs2_clr);
}

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

//
// Test Disk Read
//

void rh11_t::testRead(unsigned int disk) {
    bool pass = true;
    const unsigned int words          = 128;
    const unsigned int dest_addr_virt = 004000;
    const unsigned int dest_addr_phys = 070000;
    const ks10_t::data_t pattern = 0525252525252;

    //
    // UBA Reset
    //

#if 0
    ks10_t::writeIO(uba_t::csr_addr, 0000100);
#endif
   
    //
    // Controller Reset
    //

#if 0
    ks10_t::writeIO(rhcs2_addr, rhcs2_clr);
#endif

    //
    // Configure RHWC
    //

    ks10_t::writeIO(rhwc_addr, -words*2);

    //
    // Set Unibus mapping
    //  This will page the destination to 070000
    //

    ks10_t::writeIO(uba_t::pag_addr + 1, uba_t::pag_ftm | uba_t::pag_vld | uba_t::page70);

    //
    // Set destination address
    //

    ks10_t::writeIO(rhba_addr, dest_addr_virt);

    //
    // Fill destination with data
    //

    for (unsigned int i = 0; i < words+2; i++) {
        ks10_t::writeMem(dest_addr_phys - 1 + i, pattern);
    }

    //
    // Select disk
    //

    ks10_t::writeIO(rhcs2_addr, disk & 0x0007);

    //
    // Issue read command
    //

    ks10_t::writeIO(rhcs1_addr, rhcs1_read | rhcs1_go);

    //
    // Verify that disk goes busy
    //

    ks10_t::data_t rhcs1 = ks10_t::readIO(rhcs1_addr);
    if (!rhcs1 & rhcs1_rdy) {
        pass = false;
        printf("Disk should be busy.\n");
    }

    //
    // Wait for read to complete
    //

    rhcs1 = ks10_t::readIO(rhcs1_addr);
    for (int i = 0; i < 1000; i++) {
        if (rhcs1 & rhcs1_rdy) {
            break;
        }
        xTaskDelay(1);
        rhcs1 = ks10_t::readIO(rhcs1_addr);
    }

    //
    // Check ready status
    //

    if ((rhcs1 & rhcs1_rdy) == 0) {
        pass = false;
        printf("Timeout waiting for disk\n");
    }

    //
    // RHCS1[GO] bit should be negated.
    //

    if ((rhcs1 & rhcs1_go) != 0) {
        pass = false;
        printf("RHCS1[GO] should be negated.\n");
    }
    
    //
    // RHCS1[FUN] should still be set
    //

    if ((rhcs1 & 0x003e) != rhcs1_read) {
        pass = false;
        printf("RHCS1[FUN] should be a read command.\n");
    }

    //
    // Check RH11 Word Count (RHWC) register
    //

    ks10_t::data_t rhwc = ks10_t::readIO(rhwc_addr);
    if (rhwc != 0) {
        pass = false;
        printf("RH11 Word Count Register (RHWC) should be 0.\n"
               "RH11 Word Count Register (RHWC) was 0x%04llx\n", rhwc);
    }

    //
    // Check RH11 Bus Address (RHBA) register
    //

    ks10_t::data_t rhba = ks10_t::readIO(rhba_addr);
    if (rhba != dest_addr_virt + 4*words) {
        pass = false;
        printf("RH11 Bus Address Register (RHBA) should be %06o.\n"
               "RH11 Bus Address Register (RHBA) was %06llo\n",
               dest_addr_virt + 4*words, rhba);
    }

    //
    // Check memory
    //
    
    if (pattern != ks10_t::readMem(dest_addr_phys - 1)) {
        pass = false;
        printf("RH11 Memory immediately before buffer was modified.\n");
    }

    for (unsigned int i = 0; i < words; i++) {
        if (pattern == ks10_t::readMem(dest_addr_phys + i)) {
            pass = false;
            printf("RH11 Memory buffer was not modified by disk read.\n");
        }
    }

    if (pattern != ks10_t::readMem(dest_addr_phys + words)) {
        pass = false;
        printf("RH11 Memory immediately after buffer was modified.\n");
    }


    //printf("RHBA Register is 0x%04llx\n", ks10_t::readIO(rhba_addr));

    //printf("RHCS1 Register is 0x%04llx\n", rhcs1);

    //printf("ubacsr is %06llo (after)\n", ks10_t::readIO(uba_t::csr_addr));

    //
    // Print results
    //

    printf("RH11 disk read test %s.\n", pass ? "passed" : "failed");

}

//
// Test Disk Write
//

void rh11_t::testWrite(unsigned int disk) {
    bool pass = true;
    const unsigned int words          = 256;
    const unsigned int dest_addr_virt = 004000;
    const unsigned int dest_addr_phys = 070000;
    const ks10_t::data_t pattern = 0123456654321;

    //
    // UBA Reset
    //

#if 0
    ks10_t::writeIO(uba_t::csr_addr, 0000100);
#endif
   
    //
    // Controller Reset
    //

#if 0
    ks10_t::writeIO(rhcs2_addr, rhcs2_clr);
#endif

    //
    // Create data pattern
    //
    
    for (unsigned int i = 0; i < words; i++) {
        ks10_t::writeMem(dest_addr_phys + i, pattern);
    }

    //
    // Configure RHWC
    //

    ks10_t::writeIO(rhwc_addr, -words*2);

    //
    // Set Unibus mapping
    //  This will page the destination to 070000
    //

    ks10_t::writeIO(uba_t::pag_addr + 1, uba_t::pag_ftm | uba_t::pag_vld | uba_t::page70);

    //
    // Set destination address
    //

    ks10_t::writeIO(rhba_addr, dest_addr_virt);

    //
    // Select disk
    //

    ks10_t::writeIO(rhcs2_addr, disk & 0x0007);

    //
    // Issue write command
    //

    ks10_t::writeIO(rhcs1_addr, rhcs1_write | rhcs1_go);

    //
    // Verify that disk goes busy
    //

    ks10_t::data_t rhcs1 = ks10_t::readIO(rhcs1_addr);
    if (!rhcs1 & rhcs1_rdy) {
        pass = false;
        printf("Disk should be busy.\n");
    }

    //
    // Wait for write to complete
    //

    rhcs1 = ks10_t::readIO(rhcs1_addr);
    for (int i = 0; i < 1000; i++) {
        if (rhcs1 & rhcs1_rdy) {
            break;
        }
        xTaskDelay(1);
        rhcs1 = ks10_t::readIO(rhcs1_addr);
    }

    //
    // Check ready status
    //

    if ((rhcs1 & rhcs1_rdy) == 0) {
        pass = false;
        printf("Timeout waiting for disk\n");
    }

    //
    // RHCS1[GO] bit should be negated.
    //

    if ((rhcs1 & rhcs1_go) != 0) {
        pass = false;
        printf("RHCS1[GO] should be negated.\n");
    }
    
    //
    // RHCS1[FUN] should still be set
    //

    if ((rhcs1 & 0x003e) != rhcs1_read) {
        pass = false;
        printf("RHCS1[FUN] should be a read command.\n");
    }

    //
    // Check RH11 Word Count (RHWC) register
    //

    ks10_t::data_t rhwc = ks10_t::readIO(rhwc_addr);
    if (rhwc != 0) {
        pass = false;
        printf("RH11 Word Count Register (RHWC) should be 0.\n"
               "RH11 Word Count Register (RHWC) was 0x%04llx\n", rhwc);
    }

    //
    // Check RH11 Bus Address (RHBA) register
    //

    ks10_t::data_t rhba = ks10_t::readIO(rhba_addr);
    if (rhba != dest_addr_virt + 4*words) {
        pass = false;
        printf("RH11 Bus Address Register (RHBA) should be %06o.\n"
               "RH11 Bus Address Register (RHBA) was %06llo\n",
               dest_addr_virt + 4*words, rhba);
    }

    //printf("RHBA Register is 0x%04llx\n", ks10_t::readIO(rhba_addr));

    //printf("RHCS1 Register is 0x%04llx\n", rhcs1);

    printf("ubacsr is %06llo (after)\n", ks10_t::readIO(uba_t::csr_addr));

    //
    // Print results
    //

    printf("RH11 disk read test %s.\n", pass ? "passed" : "failed");

}
