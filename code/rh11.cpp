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
//! Check Signature for sixbit/HOM/,,000000
//!
//! \param [in] addr
//!   Address to check for HOM signature
//!
//! \returns
//!   True if signature is found.  False otherwise.
//

bool rh11_t::isHomBlock(ks10_t::addr_t addr) {
    return ks10_t::readMem(addr) == 0505755000000;
}

//
//! RH11 Controller Clear
//

void rh11_t::clear(void) {
    cs2_write(cs2_clr);
}

//
//! Wait for disk operation to complete and check for errors
//!
//! \param [in] verbose
//!     Whine about errors if true.
//!
//! \returns
//!     True if no errors, false otherwise.
//


bool rh11_t::wait(bool verbose) {

    bool success = true;

    //
    // Verify that disk goes busy
    //

    if (!cs1_read() & cs1_rdy) {
        success = false;
        if (verbose) {
            printf("Disk should be busy.\n");
        }
    }

    //
    // Wait for disk operation to complete
    //

    for (int i = 0; i < 1000; i++) {
        if (cs1_read() & cs1_rdy) {
            break;
        }
        xTaskDelay(1);
    }

    //
    // Check ready status
    //

    if (!cs1_read() & cs1_rdy) {
        success = false;
        if (verbose) {
            printf("Disk Timeout.\n");
        }
    }

    //
    // Check for disk errors
    //

#if 0
    if (cs1_read() & cs1_sc) {
        success = false;
        if (verbose) {
            printf("Disk error.  CS1 = %012llo\n", cs1_read());
        }
    }
#endif

    // FIXME

    return success;
}

//
//! Read a block of data from the RH11
//!
//! \param [in] vaddr
//!     Adapter virtual address
//!
//! \param [in] daddr
//!     Disk address in CHS format
//!
//! \returns
//!     True if no error, false otherwise.
//

bool rh11_t::readBlock(ks10_t::addr_t vaddr, ks10_t::data_t daddr) {

    printf("Readblock: vaddr=%06o, daddr=%012llo\n", vaddr, daddr);

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
    // Configure CS2
    //  Set disk (unit)
    //

    cs2_write(unit & 000007);

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
        printf("Disk error reading boot sector\n");
        return false;
    }

    return true;

}

//
//! Attempt to boot from the specified Home Block.
//!
//! \param [in] paddr
//!     Physical address (KS10 address) of the disk buffer.
//!
//! \param [in] vaddr
//!     Virtual address (RH11 address) of the disk buffer.
//!
//! \param [in] daddr
//!     Disk address (in CHS format) of the data to read.
//!
//! \param [in] name
//!     Name of Home Block used when printing error messages.
//!
//! \details
//!
//!   HOME BLOCK
//!
//!     The relavant structure of this page is as follows:
//!
//!     Offset    Description
//!     ------    --------------------------------------------
//!
//!        0      SIGNATURE.  CONTAINS SIXBIT/HOM/,,000000
//!      101      DISK ADDRESS OF FE-FILE AREA (SECTOR #)
//!      102      LENGTH (# OF SECTORS)
//!      103      8080 TRACK/CYL/SECTOR
//!
//!   FE FILE AREA:
//!
//!     The first page in the FE File Area is a directory for the front-end and
//!     contains the physical disk addresses and lengths for the files contained
//!     in the remainder of the FE File Area.
//!
//!     The structure of this page is as follows:
//!
//!     Offset    Description
//!     ------    --------------------------------------------
//!
//!        0      POINTER TO FREE SPACE
//!        1        PAGE #,,LENGTH
//!
//!        2      POINTER TO MICROCODE
//!        3        PAGE #,,LENGTH
//!
//!        4      POINTER TO MONITOR PRE-BOOT
//!        5        PAGE #,,LENGTH
//!
//!        6      POINTER TO DIAGNOSTIC PRE-BOOT
//!        7        PAGE #,,LENGTH
//!
//!       10      POINTER TO BOOTCHECK 1 MICROCODE
//!       11        PAGE #,,LENGTH
//!
//!       12      POINTER TO BOOTCHECK 2 PRE-BOOT
//!       13        PAGE #,,LENGTH
//!
//!       14      POINTER TO MONITOR BOOT
//!       15        PAGE #,,LENGTH
//!
//!       16      POINTER TO DIAGNOSTIC BOOT
//!       17        PAGE #,,LENGTH
//!
//!       20      POINTER TO BOOTCHECK 2
//!       21        PAGE #,,LENGTH
//!
//!       22      POINTER TO INDIRECT FILE 0
//!       23        PAGE #,,LENGTH
//!
//!       24      POINTER TO INDIRECT FILE 1
//!       25        PAGE #,,LENGTH
//!
//!       ..      ...
//!
//!      776      POINTER TO INDIRECT FILE 366(8)
//!      777        PAGE #,,LENGTH
//!
//!     The pointers are physical disk addresses (Cylinder/Head/Sector) which
//!     are formatted as follows:
//!
//!       Bits [ 0: 2] - Zero
//!       Bits [ 3:11] - Cylinder
//!       Bits [12:22] - Zero
//!       Bits [23:27] - Track (Head)
//!       Bits [28:30] - Zero
//!       Bits [31:35] - Sector
//!
//!       Bits [20:35] are formatted as required by the RPDA register
//!       Bits [ 3:11] are formatted as required by the RPDS register once
//!                    shifted into the proper place.
//!
//!   This is documented in the SMFILE source code entitled:
//!   DSQDFC0 DECSYSTEM 2020 DIAGNOSTICS FE-FILE PROGRAM
//!
//! \returns
//!   True if sucessful, false otherwise.
//!
//

bool rh11_t::bootBlock(ks10_t::addr_t paddr, ks10_t::addr_t vaddr,
                       ks10_t::data_t daddr, const char *name) {

    //
    // Read the Home Block
    //

    bool success = readBlock(vaddr, daddr);
    for (int i = 0; i < 10; i++) {
        printf("data[%d] = %012llo\n", i, ks10_t::readMem(paddr + i));
    }
    if (success) {
        if (isHomBlock(paddr)) {

            //
            // Get the disk address of the FE File Page from the Home Block
            //

            ks10_t::addr_t fe_file_offset = 0103;
            ks10_t::data_t daddr = ks10_t::readMem(paddr + fe_file_offset);
            if (daddr != 0) {

                //
                // Read the FE File Page (a.k.a. Page of Pointers).
                //

                success = readBlock(vaddr, daddr);
                if (success) {

                    //
                    // Get the disk address of the Monitor Pre-boot from the FE File
                    // Page.
                    //

                    ks10_t::addr_t mon_preboot_offset = 4;
                    daddr = ks10_t::readMem(paddr + mon_preboot_offset);
                    if (daddr != 0) {

                        //
                        // Read the Monitor Pre-boot.
                        //

                        success = readBlock(vaddr, daddr);
                        if (success) {
                            ks10_t::writeRegCIR((ks10_t::opJRST << 18) | paddr);
                            printf("%s Monitor pre-boot read successfully\n", name);
                            printf("boot with \"ST 1000\"\n");
                            return true;
                        } else {
                            printf("%s Monitor pre-boot is unreadable.\n", name);
                            return false;
                        }
                    } else {
                        printf("%s Invalid monitor pre-boot address.\n", name);
                        return false;
                    }
                } else {
                    printf("%s Unreadable FE File Page.\n", name);
                    return false;
                }
            } else {
                printf("%s Home Block has invalid address of FE File Page.\n", name);
                return false;
            }
        } else {
            printf("%s Home Block not found.\n", name);
            return false;
        }
    } else {
        printf("%s Home Block is unreadable.\n", name);
        return false;
    }
}

//
//! This tests the operation of the RH11 FIFO (aka SILO)
//

void rh11_t::testFIFO(void) {

    //
    // Controller Reset
    //

    cs2_write(cs2_clr);

    //
    // Test buffer operation
    //

    bool fail = false;
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
                if (!cs2 & cs2_ir) {
                    fail = true;
                    printf("CS2[IR] should be set after reset\n");
                }
                if (cs2 & cs2_or) {
                    fail = true;
                    printf("CS2[OR] Should be clear after reset\n");
                }
                break;
            case 1 ... 65:
                if (!cs2 & cs2_ir) {
                    fail = true;
                    printf("CS2[IR] should be set after %d entries.\n", i);
                }
                if (!cs2 & cs2_or) {
                    fail = true;
                    printf("CS2[OR] Should be set after %d entries.\n", i);
                }
                break;
            case 66 ... 75:
                if (cs2 & cs2_ir) {
                    fail = true;
                    printf("CS2[IR] should be clear after %d entries.\n", i);
                }
                if (!cs2 & cs2_or) {
                    fail = true;
                    printf("CS2[OR] Should be set after %d entries.\n", i);
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
                    printf("Data from FIFO is incorrect on word %d.\n"
                           "Expected 0x%04llx.  Received 0x%04llx.\n",
                           i, 0xff00 + i, rhdb);
                }
                break;
            case 66 ... 75:
                if (rhdb != 0) {
                    fail = true;
                    printf("Data from FIFO is incorrect on word %d.\n"
                           "Expected 0x%04llx.  Received 0x%04llx.\n",
                           i, 0, rhdb);
                }
        }
    }

    //
    // Print results
    //

    printf("RHDB FIFO test %s.\n", fail ? "failed" : "passed");

}

//
//! This tests the operation of the sector byte counter
//

void rh11_t::testRPLA(void) {

    //
    // Controller Reset
    //

    cs2_write(cs2_clr);

    //
    // Configure CS2
    //  Set disk (unit)
    //

    cs2_write(unit & 000007);

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
                    printf("RPLA SEC should be 0, EXT should be 0 after %3d clocks\n", i);
                }
                break;
            case 128 ... 255:
                if (rpla != 0x0010) {
                    fail = true;
                    printf("RPLA SEC should be 0, EXT should be 20 after %3d clocks\n", i);
                }
                break;
            case 256 ... 511:
                if (rpla != 0x0020) {
                    fail = true;
                    printf("RPLA SEC should be 0, EXT should be 40 after %3d clocks\n", i);
                }
                break;
            case 512 ... 671:
                if (rpla != 0x0030) {
                    fail = true;
                    printf("RPLA SEC should be 0, EXT should be 60 after %3d clocks\n", i);
                }
                break;
            case 672 ... 799:
                if (rpla != 0x0040) {
                    fail = true;
                    printf("RPLA SEC should be 1, EXT should be 00 after %3d clocks\n", i);
                }
                break;
            case 800 ... 927:
                if (rpla != 0x0050) {
                    fail = true;
                    printf(" RPLA SEC should be 0, EXT should be 20 after %3d clocks\n", i);
                }
                break;
            case 928 ... 1183:
                if (rpla != 0x0060) {
                    fail = true;
                    printf("RPLA SEC should be 0, EXT should be 40 after %3d clocks\n", i);
                }
                break;
            case 12608 ... 12767:
                if (rpla != 0x04b0) {
                    fail = true;
                    printf("RPLA SEC should be 1, EXT should be 00 after %3d clocks\n", i);
                }
                break;
            case 12768:
                if (rpla != 0x0000) {
                    fail = true;
                    printf("RPLA SEC should be 0, EXT should be 00 after %3d clocks\n", i);
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

    printf("RPLA/RPMR byte counter test %s.\n", fail ? "failed" : "passed");
}

//
// Test Disk Read
//

void rh11_t::testRead(void) {
    bool pass = true;
    const unsigned int words     = 128;
    const ks10_t::addr_t vaddr   = 004000;
    const ks10_t::addr_t paddr   = 070000;
    const ks10_t::data_t pattern = 0525252525252;

    //
    // Configure RHWC
    //

    wc_write(-words*2);

    //
    // Set Unibus mapping
    //  This will page the destination to 070000
    //

    uba.pag_write(1, uba_t::pag_ftm | uba_t::pag_vld | uba_t::addr2page(paddr));

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
    // Set disk addressing
    //

    da_write(1);
    dc_write(0);

    //
    // Select disk
    //

    cs2_write(unit & 000007);

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
        printf("CS1[GO] should be negated.\n");
    }

    //
    // CS1[FUN] should still be set
    //

    if ((cs1_read() & 0x003e) != cs1_cmdrd) {
        pass = false;
        printf("CS1[FUN] should be a read command.\n");
    }

    //
    // Check RH11 Word Count (RHWC) register
    //

    if (wc_read() != 0) {
        pass = false;
        printf("RH11 Word Count Register (RHWC) should be 0.\n"
               "RH11 Word Count Register (RHWC) was 0x%04llx\n",
               wc_read());
    }

    //
    // Check RH11 Bus Address (RHBA) register
    //

    if (ba_read() != vaddr + 4 * words) {
        pass = false;
        printf("RH11 Bus Address Register (RHBA) should be %06o.\n"
               "RH11 Bus Address Register (RHBA) was %06llo\n",
               vaddr + 4 * words, ba_read());
    }

    //
    // Check memory
    //

    if (pattern != ks10_t::readMem(paddr - 1)) {
        pass = false;
        printf("RH11 Memory immediately before buffer was modified.\n");
    }

    for (unsigned int i = 0; i < words; i++) {
        printf("RH11 read %d = %012llo\n", i, ks10_t::readMem(paddr + i));
        if (pattern == ks10_t::readMem(paddr + i)) {
            pass = false;
            printf("RH11 Memory buffer was not modified by disk read.\n");
        }
    }

    if (pattern != ks10_t::readMem(paddr + words)) {
        pass = false;
        printf("RH11 Memory immediately after buffer was modified.\n");
    }

    //
    // Print results
    //

    printf("RH11 disk read test %s.\n", pass ? "passed" : "failed");

}

//
// Test Disk Write
//

void rh11_t::testWrite(void) {
    bool pass = true;
    const unsigned int words     = 128;
    const ks10_t::addr_t vaddr   = 004000;
    const ks10_t::addr_t paddr   = 070000;
    const ks10_t::data_t pattern = 0123456654321;

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

    uba.pag_write(1, uba_t::pag_ftm | uba_t::pag_vld | uba_t::addr2page(paddr));

    //
    // Set destination address
    //

    ba_write(vaddr);

    //
    // Select disk
    //

    cs2_write(unit & 000007);

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
        printf("CS1[GO] should be negated.\n");
    }

    //
    // CS1[FUN] should still be set
    //

    if ((cs1_read() & 0x003e) != cs1_cmdwr) {
        pass = false;
        printf("CS1[FUN] should be a write command.\n");
    }

    //
    // Check RH11 Word Count (RHWC) register
    //

    if (wc_read() != 0) {
        pass = false;
        printf("RH11 Word Count Register (RHWC) should be 0.\n"
               "RH11 Word Count Register (RHWC) was 0x%04llx\n",
               wc_read());
    }

    //
    // Check RH11 Bus Address (RHBA) register
    //

    if (ba_read() != vaddr + 4 * words) {
        pass = false;
        printf("RH11 Bus Address Register (RHBA) should be %06o.\n"
               "RH11 Bus Address Register (RHBA) was %06llo\n",
               vaddr + 4 * words, ba_read());
    }

    //
    // Print results
    //

    printf("RH11 disk read test %s.\n", pass ? "passed" : "failed");

}

//
// Test Disk Write Check Command
//

void rh11_t::testWrchk(void) {
    bool pass = true;
    const unsigned int words     = 128;
    const unsigned int vaddr     = 004000;
    const unsigned int paddr     = 070000;
    const ks10_t::data_t pattern = 0123456654321;

#if 1

    {
        wc_write(0);
        cs1_write(cs1_cmdrd | cs1_go);
        for (int i = 0; i < 1000; i++) {
            if (cs1_read() & cs1_rdy) {
                break;
            }
            xTaskDelay(1);
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

    uba.pag_write(1, uba_t::pag_ftm | uba_t::pag_vld | uba_t::addr2page(paddr));

    //
    // Set destination address
    //

    ba_write(vaddr);

    //
    // Select disk
    //

    cs2_write(unit & 000007);

#if 0

    //
    // Configure RHWC
    //
    
    wc_write(-words*2);

    //
    // Issue write command
    //

    cs1_write(cs1_write | cs1_go);

    //
    // Wait for write to complete
    //

    pass &= wait(rh_base, false);

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
        printf("Write check error on matching data.\n");
    }

    printf("CS2 Register is 0x%04llx (1)\n", cs2_read());

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

    if (!cs2_read() & cs2_wce) {
        pass = false;
        printf("No write check error on mismatching data.\n");
    }

    printf("CS2 Register is 0x%04llx (2)\n", cs2_read());

    //
    // Print results
    //

    printf("RH11 disk wrchk test %s.\n", pass ? "passed" : "failed");

}

//
// Bootstrap from RH11
//

void rh11_t::boot(void) {

    const ks10_t::addr_t paddr = 01000;         // KS10 address of disk buffer
    const ks10_t::addr_t vaddr = 04000;         // UBA address of disk buffer

    const unsigned int priHomeBlock =  1;
    const unsigned int altHomeBlock =  8;
    const unsigned int secHomeBlock = 10;

    //
    // Set Unibus mapping
    //  This will page the destination to 01000
    //

    uba.pag_write(1, uba_t::pag_ftm | uba_t::pag_vld | uba_t::addr2page(paddr));

    //
    // Controller clear
    //

    clear();

    //
    // Execute Read in Preset Command
    //

    cs1_write(cs1_cmdpre | cs1_go);

    //
    // Attempt to read Monitor Pre-Boot code from one of the Home Blocks
    //

    bool success = bootBlock(paddr, vaddr, priHomeBlock, "Primary");
    if (!success) {
        printf("Trying Alternate Home Block.\n");
        success = bootBlock(paddr, vaddr, altHomeBlock, "Alternate");
        if (!success) {
            printf("Trying Secondary Home Block.\n");
            success = bootBlock(paddr, vaddr, secHomeBlock, "Secondary");
            if (!success) {
                printf("Unable to boot from this disk.\n");
            }
        }
    }
}


#if 0

#define BOOT_START      0377000                         // start

static const d10 boot_rom_dec[] = {
    0515040000001,                          /* boot:hrlzi 1,1       ; uba # */
    0201000140001,                          /*      movei 0,140001  ; vld,fst,pg 1 */
    0713001000000+(IOBA_UBMAP+1 & RMASK),   /*      wrio 0,763001(1); set ubmap */
    0435040000000+(IOBA_RP & RMASK),        /*      iori 1,776700   ; rh addr */
    0202040000000+FE_RHBASE,                /*      movem 1,FE_RHBASE */
    0201000000040,                          /*      movei 0,40      ; ctrl reset */
    0713001000010,                          /*      wrio 0,10(1)    ; ->RPCS2 */
    0201000000021,                          /*      movei 0,21      ; preset */
    0713001000000,                          /*      wrio 0,0(1)     ; ->RPCS1 */
    0201100000001,                          /*      movei 2,1       ; blk #1 */
    0265740377032,                          /*      jsp 17,rdbl     ; read */
    0204140001000,                          /*      movs 3,1000     ; id word */
    0306140505755,                          /*      cain 3,sixbit /HOM/ */
    0254000377023,                          /*      jrst .+6        ; match */
    0201100000010,                          /*      movei 2,10      ; blk #10 */
    0265740377032,                          /*      jsp 17,rdbl     ; read */
    0204140001000,                          /*      movs 3,1000     ; id word */
    0302140505755,                          /*      caie 3,sixbit /HOM/ */
    0254200377022,                          /*      halt .          ; inv home */
    0336100001103,                          /*      skipn 2,1103    ; pg of ptrs */
    0254200377024,                          /*      halt .          ; inv ptr */
    0265740377032,                          /*      jsp 17,rdbl     ; read */
    0336100001004,                          /*      skipn 2,1004    ; mon boot */
    0254200377027,                          /*      halt .          ; inv ptr */
    0265740377032,                          /*      jsp 17,rdbl     ; read */
    0254000001000,                          /*      jrst 1000       ; start */
    0201140176000,                          /* rdbl:movei 3,176000  ; wd cnt */
    0201200004000,                          /*      movei 4,4000    ; addr */
    0200240000000+FE_UNIT,                  /*      move 5,FE_UNIT  ; unit */
    0200300000002,                          /*      move 6,2 */
    0242300777750,                          /*      lsh 6,-24.      ; cyl */
    0713141000002,                          /*      wrio 3,2(1)     ; ->RPWC */
    0713201000004,                          /*      wrio 4,4(1)     ; ->RPBA */
    0713101000006,                          /*      wrio 2,6(1)     ; ->RPDA */
    0713241000010,                          /*      wrio 5,10(1)    ; ->RPCS2 */
    0713301000034,                          /*      wrio 6,34(1)    ; ->RPDC */
    0201000000071,                          /*      movei 0,71      ; read+go */
    0713001000000,                          /*      wrio 0,0(1)     ; ->RPCS1 */
    0712341000000,                          /*      rdio 7,0(1)     ; read csr */
    0606340000200,                          /*      trnn 7,200      ; test rdy */
    0254000377046,                          /*      jrst .-2        ; loop */
    0602340100000,                          /*      trne 7,100000   ; test err */
    0254200377052,                          /*      halt */
    0254017000000,                          /*      jrst 0(17)      ; return */
    };



#define BOOT_START      0377000                         /* start */
#define BOOT_LEN (sizeof (boot_rom_dec) / sizeof (d10))

static const d10 boot_rom_dec[] = {
    INT64_C(0510040000000)+FE_RHBASE,                   /* boot:hllz 1,FE_RHBASE   ; uba # */
    INT64_C(0201000140001),                             /*      movei 0,140001  ; vld,fst,pg 1 */
    INT64_C(0713001000000)+(IOBA_UBMAP+1 & RMASK),  /*      wrio 0,763001(1); set ubmap */
    INT64_C(0200040000000)+FE_RHBASE,                   /*      move 1,FE_RHBASE */
    INT64_C(0201000000040),                             /*      movei 0,40      ; ctrl reset */
    INT64_C(0713001000010),                             /*      wrio 0,10(1)    ; ->RPCS2 */
    INT64_C(0200240000000)+FE_UNIT,                     /*      move 5,FE_UNIT  ; unit */
    INT64_C(0713241000010),                             /*      wrio 5,10(1)    ; select ->RPCS2 */

    INT64_C(0712001000012),                             /*10    rdio 0,12(1)    ; RPDS */
    INT64_C(0640000010600),                             /*      trc  0,10600    ; MOL + DPR + RDY */
    INT64_C(0642000010600),                             /*      trce 0,10600    ; */
    INT64_C(0254000377010),                             /*      jrst .-3        ; wait */
    INT64_C(0201000000377),                             /*      movei 0,377     ; All units */
    INT64_C(0713001000016),                             /*      wrio 0,16(1)    ; Clear on-line attns */
    INT64_C(0201000000021),                             /*      movei 0,21      ; preset */
    INT64_C(0713001000000),                             /*      wrio 0,0(1)     ; ->RPCS1 */

    INT64_C(0201100000001),                             /*20    movei 2,1       ; blk #1 */
    INT64_C(0265740377041),                             /*      jsp 17,rdbl     ; read */
    INT64_C(0204140001000),                             /*      movs 3,1000     ; id word */
    INT64_C(0306140505755),                             /*      cain 3,sixbit /HOM/ */
    INT64_C(0254000377032),                             /*      jrst pg         ; match */
    INT64_C(0201100000010),                             /*      movei 2,10      ; blk #10 */
    INT64_C(0265740377041),                             /*      jsp 17,rdbl     ; read */
    INT64_C(0204140001000),                                 /*      movs 3,1000     ; id word */

    INT64_C(0302140505755),                             /*30    caie 3,sixbit /HOM/ */
    INT64_C(0254000377061),                             /*      jrst alt2        ; inv home */
    INT64_C(0336100001103),                             /* pg:  skipn 2,1103    ; pg of ptrs */
    INT64_C(0254200377033),                             /*      halt .          ; inv ptr */
    INT64_C(0265740377041),                             /*      jsp 17,rdbl     ; read */
    INT64_C(0336100001004),                             /*      skipn 2,1004    ; mon boot */
    INT64_C(0254200377036),                             /*      halt .          ; inv ptr */
    INT64_C(0265740377041),                             /*      jsp 17,rdbl     ; read */

    INT64_C(0254000001000),                             /*40    jrst 1000       ; start */
    INT64_C(0201140176000),                             /* rdbl:movei 3,176000  ; wd cnt 1P = -512*2 */
    INT64_C(0201200004000),                             /*      movei 4,4000    ; 11 addr => M[1000] */
    INT64_C(0200300000002),                             /*      move 6,2 */
    INT64_C(0242300777750),                             /*      lsh 6,-24.      ; cyl */
    INT64_C(0713141000002),                             /*      wrio 3,2(1)     ; ->RPWC */
    INT64_C(0713201000004),                             /*      wrio 4,4(1)     ; ->RPBA */
    INT64_C(0713101000006),                             /*      wrio 2,6(1)     ; ->RPDA */

    INT64_C(0713301000034),                             /*50    wrio 6,34(1)    ; ->RPDC */
    INT64_C(0201000000071),                             /*      movei 0,71      ; read+go */
    INT64_C(0713001000000),                             /*      wrio 0,0(1)     ; ->RPCS1 */
    INT64_C(0712341000000),                             /*      rdio 7,0(1)     ; read csr */
    INT64_C(0606340000200),                             /*      trnn 7,200      ; test rdy */
    INT64_C(0254000377053),                             /*      jrst .-2        ; loop */
    INT64_C(0602340100000),                             /*      trne 7,100000   ; test err */
    INT64_C(0254200377057),                             /*      halt . */

    INT64_C(0254017000000),                             /*60    jrst 0(17)      ; return */
    INT64_C(0201100000012),                             /*alt2: movei 2,10.     ; blk #10. */
    INT64_C(0265740377041),                             /*      jsp 17,rdbl     ; read */
    INT64_C(0204140001000),                             /*      movs 3,1000     ; id word */
    INT64_C(0302140505755),                             /*      caie 3,sixbit /HOM/ */
    INT64_C(0254200377065),                             /*      halt .          ; inv home */
    INT64_C(0254000377032),                             /*      jrst pg         ; Read ptrs */
    };

#endif
