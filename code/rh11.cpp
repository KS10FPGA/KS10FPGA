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
#include "uba.hpp"
#include "rh11.hpp"
#include "vt100.hpp"
#include "commands.hpp"

#undef RH11_VERBOSE

//!
//! \brief
//!   Check Signature for sixbit/HOM/,,000000
//!
//! \param [in] addr -
//!   Address to check for HOM signature
//!
//! \returns
//!   True if signature is found.  False otherwise.
//!

bool rh11_t::isHomBlock(ks10_t::addr_t addr) {
    return ks10_t::readMem(addr) == 0505755000000;
}

//
//! \brief
//!    RH11 Controller Clear
//

void rh11_t::clear(void) {
    cs2_write(cs2_clr);
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

    if (!(cs1_read() & cs1_rdy)) {
        success = false;
        if (verbose) {
            printf("KS10: Error: Disk should be busy.\n");
        }
    }

    //
    // Wait for disk operation to complete
    //

    for (int i = 0; i < 1000; i++) {
        if (cs1_read() & cs1_rdy) {
            break;
        }
        usleep(100);
    }

    //
    // Check ready status
    //

    if (!(cs1_read() & cs1_rdy)) {
        success = false;
        if (verbose) {
            printf("KS10: Error: Disk Timeout.\n");
        }
    }

    //
    // Check for disk errors
    //

#if 0
    if (cs1_read() & cs1_sc) {
        success = false;
        if (verbose) {
            printf("KS10: Error: CS1 = %012llo\n", cs1_read());
            printf("             CS2 = %012llo\n", cs2_read());
            printf("             DS  = %012llo\n", ds_read());
        }
    }
#endif

    return success;
}

//!
//! \brief
//!    Read a block of data from the RH11
//!
//! \param [in] vaddr -
//!    Adapter virtual address
//!
//! \param [in] daddr -
//!    Disk address in CHS format
//!
//! \returns
//!    True if no error, false otherwise.
//!

bool rh11_t::readBlock(ks10_t::addr_t vaddr, ks10_t::data_t daddr) {

#ifdef RH11_VERBOSE
    printf("KS10: Readblock: vaddr=%06llo, daddr=%012llo\n", vaddr, daddr);
#endif

    //
    // Configure RHWC
    //  Read one page from disk
    //

    wc_write(-512*2);

    //
    // Configure RHBA
    //  Set UBA virtual address
    //

    ba_write(vaddr);

    //
    // Configure RPDA
    //

    da_write(daddr);

    //
    // Configure RPDC
    //

    dc_write(daddr >> 24);

    //
    // Issue read command
    //

    cs1_write(cs1_cmdrd | cs1_go);

    //
    // Wait for read to complete
    //

    wait();

    //
    // Check for errors
    //

    if (cs1_read() & cs1_sc) {
        printf("KS10: Disk error reading boot sector.\n");
#ifdef RH11_VERBOSE
        printf("KS10: RHCS1 is 0x%04x\n"
               "      RPDS  is 0x%04x\n"
               "      RPER1 is 0x%04x\n",
               cs1_read(), ds_read(), er1_read());
#endif
        return false;
    }

    return true;

}

//!
//! \brief
//!    Attempt to boot from the specified Home Block.
//!
//! \param [in] paddr -
//!    Physical address (KS10 address) of the disk buffer.
//!
//! \param [in] vaddr -
//!    Virtual address (RH11 address) of the disk buffer.
//!
//! \param [in] daddr -
//!    Disk address (in CHS format) of the data to read.
//!
//! \param [in] offset -
//!    Offset in HOM block
//!
//! \returns
//!    True if successful, false otherwise.
//!
//
//  The disk format is as follows:
//
//    HOME BLOCK
//
//     The relevant structure of this page is as follows:
//
//     Offset    Description
//     ------    --------------------------------------------
//
//         0      SIGNATURE.  CONTAINS SIXBIT/HOM/,,000000
//       101      DISK ADDRESS OF FE-FILE AREA (SECTOR #)
//       102      LENGTH (# OF SECTORS)
//       103      8080 TRACK/CYL/SECTOR
//
//    FE FILE AREA:
//
//     The first page in the FE File Area is a directory for the front-end and
//     contains the physical disk addresses and lengths for the files contained
//     in the remainder of the FE File Area.
//
//     The structure of this page is as follows:
//
//     Offset    Description
//     ------    --------------------------------------------
//
//         0      POINTER TO FREE SPACE
//         1        PAGE #,,LENGTH
//
//         2      POINTER TO MICROCODE
//         3        PAGE #,,LENGTH
//
//         4      POINTER TO MONITOR PRE-BOOT
//         5        PAGE #,,LENGTH
//
//         6      POINTER TO DIAGNOSTIC PRE-BOOT
//         7        PAGE #,,LENGTH
//
//        10      POINTER TO BOOTCHECK 1 MICROCODE
//        11        PAGE #,,LENGTH
//
//        12      POINTER TO BOOTCHECK 2 PRE-BOOT
//        13        PAGE #,,LENGTH
//
//        14      POINTER TO MONITOR BOOT
//        15        PAGE #,,LENGTH
//
//        16      POINTER TO DIAGNOSTIC BOOT
//        17        PAGE #,,LENGTH
//
//        20      POINTER TO BOOTCHECK 2
//        21        PAGE #,,LENGTH
//
//        22      POINTER TO INDIRECT FILE 0
//        23        PAGE #,,LENGTH
//
//        24      POINTER TO INDIRECT FILE 1
//        25        PAGE #,,LENGTH
//
//        ..      ...
//
//       776      POINTER TO INDIRECT FILE 366(8)
//       777        PAGE #,,LENGTH
//
//     The pointers are physical disk addresses (Cylinder/Head/Sector) which
//     are formatted as follows:
//
//        Bits [ 0: 2] - Zero
//        Bits [ 3:11] - Cylinder
//        Bits [12:22] - Zero
//        Bits [23:27] - Track (Head)
//        Bits [28:30] - Zero
//        Bits [31:35] - Sector
//
//        Bits [20:35] are formatted as required by the RPDA register
//        Bits [ 0:11] are formatted as required by the RPDS register once
//                     shifted into the proper place.
//
//     This is documented in the SMFILE source code entitled:
//     DSQDFC0 DECSYSTEM 2020 DIAGNOSTICS FE-FILE PROGRAM
//

bool rh11_t::bootBlock(ks10_t::addr_t paddr, ks10_t::addr_t vaddr,
                       ks10_t::data_t daddr, ks10_t::addr_t offset) {

    //
    // Read the Home Block
    //

    printf("KS10: Reading Home Block.\n");
    bool success = readBlock(vaddr, daddr);
    if (success) {
        if (isHomBlock(paddr)) {
#ifdef RH11_VERBOSE
            printf("KS10: Successfully read HOM block.\n");
#endif
            //
            // Get the disk address of the FE File Page from the Home Block
            //

            ks10_t::addr_t fe_file_offset = 0103;
            ks10_t::data_t daddr = ks10_t::readMem(paddr + fe_file_offset);
            if (daddr != 0) {

                //
                // Read the FE File Page (a.k.a. Page of Pointers).
                //

                printf("KS10: Reading FE File Page.\n");
                success = readBlock(vaddr, daddr);
                if (success) {

                    //
                    // Get the disk address of the Monitor Pre-Boot from the FE File
                    // Page.
                    //

                    daddr = ks10_t::readMem(paddr + offset);
                    if (daddr != 0) {

                        //
                        // Read the Monitor Pre-boot.
                        //

                        printf("KS10: Reading Monitor Pre-Boot Page.\n");
                        success = readBlock(vaddr, daddr);
                        if (success) {
#ifdef RH11_VERBOSE
                            for (int i = 0; i < 020; i++) {
                                printf("KS10: data[%o] = %012llo\n", 01000 + i, ks10_t::readMem(paddr + i));
                            }
#endif
                            if (ks10_t::readMem(paddr) != 0) {
#ifdef RH11_VERBOSE
                                printf("KS10: Monitor Pre-Boot read successfully.\n");
#endif
                                printf("KS10: Booting from address %07llo.\n", paddr);
                                ks10_t::writeRegCIR((ks10_t::opJRST << 18) | paddr);
                                ks10_t::startRUN();
                                consoleOutput();
                                return true;
                            } else {
                                printf("KS10: Monitor Pre-Boot is invalid.\n");
                                return false;
                            }
                        } else {
                            printf("KS10: Unable to read Monitor Pre-Boot.\n");
                            return false;
                        }
                    } else {
                        printf("KS10: Invalid Monitor Pre-Boot disk address.\n");
                        return false;
                    }
                } else {
                    printf("KS10: Unreadable FE File Page.\n");
                    return false;
                }
            } else {
                printf("KS10: Home Block has invalid address of FE File Page.\n");
                return false;
            }
        } else {
            printf("KS10: Home Block not found.\n");
            return false;
        }
    } else {
        printf("KS10: Home Block is unreadable.\n");
        return false;
    }
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
    cs2_write(cs2_clr);
#endif

    //
    // Test buffer operation
    //

    for (int i = 0; i < 70; i++) {

        //
        // Read CS2
        //

        ks10_t::data_t cs2 = cs2_read();

        //
        // Check results
        //

        switch (i) {
            case 0:
                if (!(cs2 & cs2_ir)) {
                    fail = true;
                    printf("KS10: CS2[IR] should be set after reset\n");
                }
                if (cs2 & cs2_or) {
                    fail = true;
                    printf("KS10: CS2[OR] Should be clear after reset\n");
                }
                break;
            case 1 ... 65:
                if (!(cs2 & cs2_ir)) {
                    fail = true;
                    printf("KS10: CS2[IR] should be set after %d entries.\n", i);
                }
                if (!(cs2 & cs2_or)) {
                    fail = true;
                    printf("KS10: CS2[OR] Should be set after %d entries.\n", i);
                }
                break;
            case 66 ... 75:
                if (cs2 & cs2_ir) {
                    fail = true;
                    printf("KS10: CS2[IR] should be clear after %d entries.\n", i);
                }
                if (!(cs2 & cs2_or)) {
                    fail = true;
                    printf("KS10: CS2[OR] Should be set after %d entries.\n", i);
                }
                break;
        }

        //
        // Write data to RHDB
        //

        db_write(static_cast<ks10_t::data_t>(0xff00 + i));

    }

    //
    // Uload the FIFO.   Check for correctness.
    //

    for (unsigned int i = 0; i < 70; i++) {

        //
        // Read data from FIFO
        //

        ks10_t::data_t rhdb = db_read();

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

//!
//! \brief
//!    This tests the operation of the Sector Counter in 18-bit mode.
//!
//! \details
//!    In this mode, there are 20 sectors per track.
//!
//! \param [in] unit -
//!    Selected disk unit
//!

void rh11_t::testRPLA20(ks10_t::data_t unit) {

    //
    // Controller Clear
    //

#if 0
    cs2_write(cs2_clr);
#endif

    //
    // Select disk (unit)
    //

    cs2_write((cs2_read() & ~cs2_unit) | (unit & 7));

    //
    // Put unit in 18-bit (20 sector) mode
    //

    of_write(0);

    //
    // Put unit in diagnostic mode.  Assert DMD.
    //

    mr_write(mr_dmd);

    //
    // Create index pulse.  Clear byte counter.
    //  DIND asserted with DSCK clock.  Don't reset DMD.
    //

    mr_write(mr_dind | mr_dsck | mr_dmd);
    mr_write(mr_dmd);

    //
    // Start clocking bytes
    //

    bool fail = false;
    for (int i = 0; i <= 12768; i++) {

        //
        // Read look ahead register RPLA
        //

        unsigned int rpla = la_read();

        //
        // Check results
        //

        switch (i) {
            case 0 ... 127:
                if (rpla != 0x0000) {
                    fail = true;
                    printf("KS10: RPLA SEC should be 0, EXT should be 00 after %3d clocks\n", i);
                }
                break;
            case 128 ... 255:
                if (rpla != 0x0010) {
                    fail = true;
                    printf("KS10: RPLA SEC should be 0, EXT should be 20 after %3d clocks\n", i);
                }
                break;
            case 256 ... 511:
                if (rpla != 0x0020) {
                    fail = true;
                    printf("KS10: RPLA SEC should be 0, EXT should be 40 after %3d clocks\n", i);
                }
                break;
            case 512 ... 671:
                if (rpla != 0x0030) {
                    fail = true;
                    printf("KS10: RPLA SEC should be 0, EXT should be 60 after %3d clocks\n", i);
                }
                break;
            case 672 ... 799:
                if (rpla != 0x0040) {
                    fail = true;
                    printf("KS10: RPLA SEC should be 1, EXT should be 00 after %3d clocks\n", i);
                }
                break;
            case 800 ... 927:
                if (rpla != 0x0050) {
                    fail = true;
                    printf("KS10: RPLA SEC should be 1, EXT should be 20 after %3d clocks\n", i);
                }
                break;
            case 928 ... 1183:
                if (rpla != 0x0060) {
                    fail = true;
                    printf("KS10: RPLA SEC should be 1, EXT should be 40 after %3d clocks\n", i);
                }
                break;
            case 12608 ... 12767:
                if (rpla != 0x04b0) {
                    fail = true;
                    printf("KS10: RPLA SEC should be 18, EXT should be 60 after %3d clocks\n", i);
                }
                break;
            case 12768 ... 12895:
                if (rpla != 0x04c0) {
                    fail = true;
                    printf("KS10: RPLA SEC should be 19, EXT should be 00 after %3d clocks\n", i);
                }
                break;
            case 12896 ... 13023:
                if (rpla != 0x04d0) {
                    fail = true;
                    printf("KS10: RPLA SEC should be 19, EXT should be 20 after %3d clocks\n", i);
                }
                break;
            case 13024 ... 13279:
                if (rpla != 0x04e0) {
                    fail = true;
                    printf("KS10: RPLA SEC should be 19, EXT should be 40 after %3d clocks\n", i);
                }
                break;
            case 13280 ... 13439:
                if (rpla != 0x04f0) {
                    fail = true;
                    printf("KS10: RPLA SEC should be 19, EXT should be 60 after %3d clocks\n", i);
                }
                break;
            case 13440 ... 13567:
                if (rpla != 0x04c0) {
                    fail = true;
                    printf("KS10: RPLA SEC should be 19, EXT should be 00 after %3d clocks\n", i);
                }
                break;


        }

        //
        // Create clock pulse
        //

        mr_write(mr_dsck | mr_dmd);
        mr_write(mr_dmd);

    }

    //
    // Print results
    //

    printf("KS10: RPLA/RPMR sector counter test (20 sector mode) %s.\n", fail ? "failed" : "passed");
}

//!
//! \brief
//!   This tests the operation of the sector byte counter in 16-bit mode.
//!
//! \details
//!   In this mode, there are 22 sectors per track.
//!
//! \param [in] unit -
//!    Selected disk unit
//!

void rh11_t::testRPLA22(ks10_t::data_t unit) {

    //
    // Controller Clear
    //

#if 0
    cs2_write(cs2_clr);
#endif

    //
    // Select disk (unit)
    //

    cs2_write((cs2_read() & ~cs2_unit) | (unit & 7));

    //
    // Put unit in 16-bit (22 sector) mode
    //

    of_write(of_fmt22);

    //
    // Put unit in diagnostic mode.  Assert DMD.
    //

    mr_write(mr_dmd);

    //
    // Create index pulse.  Clear byte counter.
    //  DIND asserted with DSCK clock.  Don't reset DMD.
    //

    mr_write(mr_dind | mr_dsck | mr_dmd);
    mr_write(mr_dmd);

    //
    // Start clocking bytes
    //

    bool fail = false;
    for (int i = 0; i <= 12768; i++) {

        //
        // Read look ahead register RPLA
        //

        unsigned int rpla = la_read();

        //
        // Check results
        //

        switch (i) {
            case 0 ... 127:
                if (rpla != 0x0000) {
                    fail = true;
                    printf("KS10: RPLA SEC should be 0, EXT should be 00 after %3d clocks\n", i);
                }
                break;
            case 128 ... 255:
                if (rpla != 0x0010) {
                    fail = true;
                    printf("KS10: RPLA SEC should be 0, EXT should be 20 after %3d clocks.\n", i);
                }
                break;
            case 256 ... 511:
                if (rpla != 0x0020) {
                    fail = true;
                    printf("KS10: RPLA SEC should be 0, EXT should be 40 after %3d clocks\n", i);
                }
                break;
            case 512 ... 608:
                if (rpla != 0x0030) {
                    fail = true;
                    printf("KS10: RPLA SEC should be 0, EXT should be 60 after %3d clocks\n", i);
                }
                break;
            case 609 ... 736:
                if (rpla != 0x0040) {
                    fail = true;
                    printf("KS10: RPLA SEC should be 1, EXT should be 00 after %3d clocks\n", i);
                }
                break;
            case 737 ... 864:
                if (rpla != 0x0050) {
                    fail = true;
                    printf("KS10: RPLA SEC should be 1, EXT should be 20 after %3d clocks\n", i);
                }
                break;
            case 865 ... 1120:
                if (rpla != 0x0060) {
                    fail = true;
                    printf("KS10: RPLA SEC should be 1, EXT should be 40 after %3d clocks\n", i);
                }
                break;
            case 1121 ... 1217:
                if (rpla != 0x0070) {
                    fail = true;
                    printf("KS10: RPLA SEC should be 1, EXT should be 40 after %3d clocks\n", i);
                }
                break;
            case 12692 ... 12788:
                if (rpla != 0x0530) {
                    fail = true;
                    printf("KS10: RPLA SEC should be 20, EXT should be 60 after %3d clocks\n", i);
                }
                break;
            case 12789 ... 12916:
                if (rpla != 0x0540) {
                    fail = true;
                    printf("KS10: RPLA SEC should be 21, EXT should be 00 after %3d clocks\n", i);
                }
                break;
            case 12917 ... 13044:
                if (rpla != 0x0550) {
                    fail = true;
                    printf("KS10: RPLA SEC should be 21, EXT should be 20 after %3d clocks\n", i);
                }
                break;
            case 13045 ... 13300:
                if (rpla != 0x0560) {
                    fail = true;
                    printf("KS10: RPLA SEC should be 21, EXT should be 40 after %3d clocks\n", i);
                }
                break;
            case 13301 ... 13397:
                if (rpla != 0x0570) {
                    fail = true;
                    printf("KS10: RPLA SEC should be 21, EXT should be 60 after %3d clocks\n", i);
                }
                break;
            case 13398 ... 13525:
                if (rpla != 0x0540) {
                    fail = true;
                    printf("KS10: RPLA SEC should be 21, EXT should be 00 after %3d clocks\n", i);
                }
                break;
        }

        //
        // Create clock pulse
        //

        mr_write(mr_dsck | mr_dmd);
        mr_write(mr_dmd);

    }

    //
    // Print results
    //

    printf("KS10: RPLA/RPMR sector counter test (22 sector mode) %s.\n", fail ? "failed" : "passed");
}

//!
//! \brief
//!    This tests the operation of the Sector Counter in 20 sector mode and in
//!    22 sector mode.
//!
//! \param [in] unit -
//!    Selected disk unit
//!

void rh11_t::testRPLA(ks10_t::data_t unit) {
    testRPLA20(unit);
    testRPLA22(unit);
}

//!
//! \brief
//!    Test Disk Initialization
//!
//! \param [in] unit -
//!    Selected disk unit
//!

void rh11_t::testInit(ks10_t::data_t unit) {
    bool fail = false;

    //
    // Controller Clear
    //

#if 0
    cs2_write(cs2_clr);
#endif

    //
    // Select disk (unit)
    //

    cs2_write((cs2_read() & ~cs2_unit) | (unit & 7));

    //
    // Check if disk in on-line
    //

    if (!(ds_read() & ds_mol)) {
        printf("KS10: Disk is off-line.\n");
        return;
    }

    //
    // Wait for initialization to complete
    //

    for (int i = 0; i < 1000; i++) {
        if (ds_read() & ds_mol) {
            break;
        }
        usleep(100);
    }

    if (!(ds_read() & ds_mol)) {
        fail = true;
        printf("KS10: Disk initialization timeout.\n");
    }

    //
    // Check Volume Valid
    //

    if (ds_read() & ds_vv) {
        fail = true;
        printf("KS10: Volume Valid should not be set after initialization.\n");
    }

    //
    // Issue Reading Preset Command
    //

    cs1_write(cs1_cmdpre | cs1_go);

    //
    // Recheck Volume Valid
    //

    if (!(ds_read() & ds_vv)) {
        fail = true;
        printf("KS10: Volume Valid should be set after preset command.\n");
    }

    //
    // Print results
    //

    printf("KS10: Disk initialization test %s.\n", fail ? "failed" : "passed");

}

//!
//! \brief
//!    Test Disk Read
//!
//! \param [in] unit -
//!    Selected disk unit
//!

void rh11_t::testRead(ks10_t::data_t unit) {
    bool pass = true;
    const unsigned int words     = 128;
    const ks10_t::addr_t vaddr   = 004000;
    const ks10_t::addr_t paddr   = 070000;
    const ks10_t::data_t pattern = 0525252525252;

    //
    // Controller Clear
    //

#if 0
    cs2_write(cs2_clr);
#endif

    //
    // Select disk
    //

    cs2_write((cs2_read() & ~cs2_unit) | (unit & 7));

    //
    // Check if disk in on-line
    //

    if (!(ds_read() & ds_mol)) {
        printf("KS10: Disk is off-line.\n");
        return;
    }

    //
    // Configure RHWC
    //

    wc_write(-words*2);

    //
    // Set Unibus mapping
    //  This will page the destination to 070000
    //

    uba.writePAG(1, uba_t::PAG_FTM | uba_t::PAG_VLD | uba_t::addr2page(paddr));

    //
    // Set destination address
    //

    ba_write(vaddr);

    //
    // Fill destination with data
    //

    for (unsigned int i = 0; i < words+2; i++) {
        ks10_t::writeMem(paddr - 1 + i, pattern);
    }

    //
    // Set disk address
    //  Cylinders 809-814 are maintenance cylinders and can be
    //  scribbled without permission.
    //

    const unsigned int cylinder = 809;
    const unsigned int track    = 0;
    const unsigned int sector   = 1;

    da_write(((track & 077) << 8) | ((sector & 077) << 0));
    dc_write(cylinder);

    //
    // Issue read command
    //

    cs1_write(cs1_cmdrd | cs1_go);

    //
    // Wait for read to complete
    //

    pass &= wait();

    //
    // CS1[GO] bit should be negated.
    //

    if (cs1_read() & cs1_go) {
        pass = false;
        printf("KS10: CS1[GO] should be negated.\n");
    }

    //
    // CS1[FUN] should still be set
    //

    if ((cs1_read() & 0x003e) != cs1_cmdrd) {
        pass = false;
        printf("KS10: CS1[FUN] should be a read command.\n");
    }

    //
    // Check RH11 Word Count (RHWC) register
    //

    if (wc_read() != 0) {
        pass = false;
        printf("KS10: RH11 Word Count Register (RHWC) should be 0.\n"
               "      RH11 Word Count Register (RHWC) was 0x%04x\n",
               wc_read());
    }

    //
    // Check RH11 Bus Address (RHBA) register
    //

    if (ba_read() != vaddr + 4 * words) {
        pass = false;
        printf("KS10: RH11 Bus Address Register (RHBA) should be %06llo.\n"
               "      RH11 Bus Address Register (RHBA) was %06o\n",
               vaddr + 4 * words, ba_read());
    }

    //
    // Check memory
    //

    if (pattern != ks10_t::readMem(paddr - 1)) {
        pass = false;
        printf("KS10: RH11 Memory immediately before buffer was modified.\n");
    }

    for (unsigned int i = 0; i < words; i++) {
        printf("KS10: RH11 read %d = %012llo\n", i, ks10_t::readMem(paddr + i));
        if (pattern == ks10_t::readMem(paddr + i)) {
            pass = false;
            printf("KS10: RH11 Memory buffer was not modified by disk read.\n");
        }
    }

    if (pattern != ks10_t::readMem(paddr + words)) {
        pass = false;
        printf("KS10: RH11 Memory immediately after buffer was modified.\n");
    }

    //
    // Print results
    //

    printf("KS10: RH11 disk read test %s.\n", pass ? "passed" : "failed");

}

//!
//! \brief
//!    Test Disk Write
//!
//! \param [in] unit -
//!    Selected disk unit
//!

void rh11_t::testWrite(ks10_t::data_t unit) {
    bool pass = true;
    const unsigned int words     = 128;
    const ks10_t::addr_t vaddr   = 004000;
    const ks10_t::addr_t paddr   = 070000;
    const ks10_t::data_t pattern = 0123456654321;

    //
    // Controller Clear
    //

#if 0
    cs2_write(cs2_clr);
#endif

    //
    // Select disk
    //

    cs2_write((cs2_read() & ~cs2_unit) | (unit & 7));

    //
    // Check if disk in on-line
    //

    if (!(ds_read() & ds_mol)) {
        printf("KS10: Disk is off-line.\n");
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

    wc_write(-words*2);

    //
    // Set Unibus mapping
    //  This will page the destination to 070000
    //

    uba.writePAG(1, uba_t::PAG_FTM | uba_t::PAG_VLD | uba_t::addr2page(paddr));

    //
    // Set destination address
    //

    ba_write(vaddr);

    //
    // Set disk address
    //  Cylinders 809-814 are maintenance cylinders and can be
    //  scribbled without permission.
    //

    const unsigned int cylinder = 809;
    const unsigned int track    = 0;
    const unsigned int sector   = 1;

    da_write(((track & 077) << 8) | ((sector & 077) << 0));
    dc_write(cylinder);

    //
    // Issue write command
    //

    cs1_write(cs1_cmdwr | cs1_go);

    //
    // Wait for write to complete
    //

    pass &= wait(true);

    //
    // CS1[GO] bit should be negated.
    //

    if (cs1_read() & cs1_go) {
        pass = false;
        printf("KS10: CS1[GO] should be negated.\n");
    }

    //
    // CS1[FUN] should still be set
    //

    if ((cs1_read() & 0x003e) != cs1_cmdwr) {
        pass = false;
        printf("KS10: CS1[FUN] should be a write command.\n");
    }

    //
    // Check RH11 Word Count (RHWC) register
    //

    if (wc_read() != 0) {
        pass = false;
        printf("KS10: RH11 Word Count Register (RHWC) should be 0.\n"
               "      RH11 Word Count Register (RHWC) was 0x%04x\n",
               wc_read());
    }

    //
    // Check RH11 Bus Address (RHBA) register
    //

    if (ba_read() != vaddr + 4 * words) {
        pass = false;
        printf("KS10: RH11 Bus Address Register (RHBA) should be %06llo.\n"
               "      RH11 Bus Address Register (RHBA) was %06o\n",
               vaddr + 4 * words, ba_read());
    }

    //
    // Print results
    //

    printf("KS10: RH11 disk write test %s.\n", pass ? "passed" : "failed");

}

//!
//! \brief
//!    Test Disk Write Check Command
//!
//! \param [in] unit -
//!    Selected disk unit
//!

void rh11_t::testWrchk(ks10_t::data_t unit) {
    bool pass = true;
    const unsigned int words     = 128;
    const unsigned int vaddr     = 004000;
    const unsigned int paddr     = 070000;
    const ks10_t::data_t pattern = 0123456654321;

    //
    // Controller Clear
    //

#if 0
    cs2_write(cs2_clr);
#endif

    //
    // Select disk (unit)
    //

    cs2_write((cs2_read() & ~cs2_unit) | (unit & 7));

    //
    // Check if disk in on-line
    //

    if (!(ds_read() & ds_mol)) {
        printf("KS10: Disk is off-line.\n");
        return;
    }

#if 1

    {
        //wc_write(-words*2);
        wc_write(-2);
        cs1_write(cs1_cmdrd | cs1_go);
        for (int i = 0; i < 1000; i++) {
            if (cs1_read() & cs1_rdy) {
                break;
            }
            usleep(100);
        }
    }

#endif

    //
    // Create data pattern
    //

    for (unsigned int i = 0; i < words; i++) {
        ks10_t::writeMem(paddr + i, pattern);
    }

    //
    // Configure RHWC
    //

    wc_write(-words*2);

    //
    // Set Unibus mapping
    //  This will page the destination to 070000
    //

    uba.writePAG(1, uba_t::PAG_FTM | uba_t::PAG_VLD | uba_t::addr2page(paddr));

    //
    // Set destination address
    //

    ba_write(vaddr);

    //
    // Set disk address
    //  Cylinders 809-814 are maintenance cylinders and can be
    //  scribbled without permission.
    //

    const unsigned int cylinder = 809;
    const unsigned int track    = 0;
    const unsigned int sector   = 1;

    da_write(((track & 077) << 8) | ((sector & 077) << 0));
    dc_write(cylinder);

    //
    // Select disk
    //

    cs2_write((cs2_read() & ~cs2_unit) | (unit & 7));

#if 0

    //
    // Configure RHWC
    //

    wc_write(-words*2);

    //
    // Issue write command
    //

    cs1_write(cs1_cmdwr | cs1_go);

    //
    // Wait for write to complete
    //

    pass &= wait(false);

#endif

    //
    // Configure RHWC
    //

    wc_write(-words*2);

    //
    // Issue write check command (correct data)
    //

    cs1_write(cs1_cmdwch | cs1_go);

    //
    // Wait for write check to complete
    //

    pass &= wait(true);

    //
    // CS2[WCE] should not be asserted.
    //

    if (cs2_read() & cs2_wce) {
        pass = false;
        printf("KS10: Write check error on matching data.\n");
    }

    printf("KS10: CS2 Register is 0x%04x (1)\n", cs2_read());

    //
    // Change the pattern on one word.  This should create a CS2[WCE].
    //

    ks10_t::writeMem(paddr, ~pattern);

    //
    // Configure RHWC
    //

    wc_write(-words*2);

    //
    // Issue write check command (incorrect data)
    //

    cs1_write(cs1_cmdwch | cs1_go);

    //
    // Wait for write check to complete
    //

    pass &= wait(true);

    //
    // CS2[WCE] should be asserted.
    //

    if (!(cs2_read() & cs2_wce)) {
        pass = false;
        printf("KS10: No write check error on mismatching data.\n");
    }

    printf("KS10: CS2 Register is 0x%04x (2)\n", cs2_read());

    //
    // Print results
    //

    printf("KS10: RH11 disk wrchk test %s.\n", pass ? "passed" : "failed");

}

//!
//! \brief
//!    Bootstrap from RH11
//!
//! \param [in] unit -
//!    Selected disk unit
//!
//! \param [in] diagmode
//!    Boot to SMMON
//!

void rh11_t::boot(ks10_t::data_t unit, bool diagmode) {

    const ks10_t::addr_t paddr = 01000;         // KS10 address of disk buffer
    const ks10_t::addr_t vaddr = 04000;         // UBA address of disk buffer

    //
    // Homeblock numbers (octal)
    //

    enum homeBlock_t {
        priHomeBlock = 001,
        secHomeBlock = 012,
    };

    enum offset_t {
        microCodeOffset   = 002,
        monPrebootOffset  = 004,
        diagPrebootOffset = 006,
        diagBootOffset    = 016,
    };

    ks10_t::addr_t offset = diagmode ? diagPrebootOffset : monPrebootOffset;

#ifdef RH11_VERBOSE

    printf("RPCS1 = %06o\n"
           "RPDT  = %06o\n"
           "RPSN  = %06o\n"
           "RPDS  = %06o\n",
           cs1_read(),
           dt_read(),
           sn_read(),
           ds_read());

#endif

    //
    // Controller clear
    //

    cs2_write(cs2_clr);

    //
    // Select disk (unit)
    //

    cs2_write((cs2_read() & ~cs2_unit) | (unit & 7));

    //
    // Check if disk in on-line
    //

    if (!(ds_read() & ds_mol)) {
        printf("KS10: Disk is off-line.\n");
        return;
    }

    //
    // Set Unibus mapping
    //  This will page the destination to 01000

    //

    uba.writePAG(1, uba_t::PAG_FTM | uba_t::PAG_VLD | uba_t::addr2page(paddr));

    //
    // Clear Attentions
    //

    as_write(0x00ff);

    //
    // Execute Read in Preset Command
    //

    cs1_write(cs1_cmdpre | cs1_go);

    //
    // Attempt to read Monitor Pre-Boot code from one of the Home Blocks
    //

    bool success = bootBlock(paddr, vaddr, priHomeBlock, offset);
    if (!success) {
        printf("KS10: Trying Secondary Home Block.\n");
        success = bootBlock(paddr, vaddr, secHomeBlock, offset);
        if (!success) {
            printf("KS10: Unable to boot from this disk.\n");
        }
    }
}
