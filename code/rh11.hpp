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
//!    rh11.hpp
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

#ifndef __RH11_HPP
#define __RH11_HPP

#include <stdio.h>
#include "uba.hpp"
#include "ks10.hpp"

//!
//! RH11 Interface Object
//!

class rh11_t {

    private:

        //
        // Register Addresses
        //

        const ks10_t::addr_t cs1_addr;
        const ks10_t::addr_t wc_addr;
        const ks10_t::addr_t ba_addr;
        const ks10_t::addr_t da_addr;
        const ks10_t::addr_t cs2_addr;
        const ks10_t::addr_t ds_addr;
        const ks10_t::addr_t la_addr;
        const ks10_t::addr_t db_addr;
        const ks10_t::addr_t mr_addr;
        const ks10_t::addr_t dc_addr;

        //
        // Register offsets
        //

        static const ks10_t::addr_t cs1_offset = 00;
        static const ks10_t::addr_t wc_offset  = 02;
        static const ks10_t::addr_t ba_offset  = 04;
        static const ks10_t::addr_t da_offset  = 06;
        static const ks10_t::addr_t cs2_offset = 010;
        static const ks10_t::addr_t ds_offset  = 012;
        static const ks10_t::addr_t la_offset  = 020;
        static const ks10_t::addr_t db_offset  = 022;
        static const ks10_t::addr_t mr_offset  = 024;
        static const ks10_t::addr_t dc_offset  = 034;

        //
        // Unit
        //

        const unsigned int unit;

        //
        // UBA
        //

        uba_t &uba;

        //
        // Private functions
        //

        bool wait(bool verbose = false);
        bool isHomBlock(ks10_t::addr_t addr);
        bool readBlock(ks10_t::addr_t vaddr, ks10_t::data_t block);
        bool bootBlock(ks10_t::addr_t paddr, ks10_t::addr_t vaddr, ks10_t::data_t block, const char *name);

    public:

        static const ks10_t::addr_t rh11_offset = 0763000;

        //
        // RH11 Control and Status Register #1 (CS1)
        //

        static const ks10_t::data_t cs1_sc     = 0100000;
        static const ks10_t::data_t cs1_rdy    = 0000200;
        static const ks10_t::data_t cs1_cmdrd  = 0000070;
        static const ks10_t::data_t cs1_cmdwr  = 0000060;
        static const ks10_t::data_t cs1_cmdwch = 0000050;
        static const ks10_t::data_t cs1_cmdpre = 0000020;
        static const ks10_t::data_t cs1_go     = 0000001;

        //
        // RH11 Control and Status Register #2 (RHCS2) definitions
        //

        static const ks10_t::data_t cs2_wce    = 0040000;
        static const ks10_t::data_t cs2_or     = 0000200;
        static const ks10_t::data_t cs2_ir     = 0000100;
        static const ks10_t::data_t cs2_clr    = 0000040;
        static const ks10_t::data_t cs2_unit   = 0000007;

        //
        // RPxx Maintenance Register (RPMR) Definitions
        //

        static const ks10_t::data_t mr_dsck    = 0000010;
        static const ks10_t::data_t mr_dind    = 0000004;
        static const ks10_t::data_t mr_dclk    = 0000002;
        static const ks10_t::data_t mr_dmd     = 0000001;

        //
        // RPxx Drive Status Register (RPDS) Definitions
        //

        static const ks10_t::data_t ds_mol     = 0010000;
        static const ks10_t::data_t ds_vv      = 0000100;

        //
        // RH11 base Addresses
        //

        static const ks10_t::addr_t num1 = 01776700;
        static const ks10_t::addr_t num3 = 03772440;

        //
        // Public functions
        //

        void clear(void);
        void testFIFO(void);
        void testInit(void);
        void testRPLA(void);
        void testRead(void);
        void testWrite(void);
        void testWrchk(void);
        void boot(void);

        //
        // Constructor
        //

    rh11_t (ks10_t::addr_t base_addr, unsigned int unit, uba_t &uba) :
            cs1_addr((base_addr & 07777700) + cs1_offset),
            wc_addr ((base_addr & 07777700) + wc_offset ),
            ba_addr ((base_addr & 07777700) + ba_offset ),
            da_addr ((base_addr & 07777700) + da_offset ),
            cs2_addr((base_addr & 07777700) + cs2_offset),
            ds_addr ((base_addr & 07777700) + ds_offset ),
            la_addr ((base_addr & 07777700) + la_offset ),
            db_addr ((base_addr & 07777700) + db_offset ),
            mr_addr ((base_addr & 07777700) + mr_offset ),
            dc_addr ((base_addr & 07777700) + dc_offset ),
            unit(unit),
            uba(uba) {
        }

        //
        // Write to CS1
        //

        void cs1_write(ks10_t::data_t data) {
            ks10_t::writeIO(cs1_addr, data);
        }

        //
        // Read from CS1
        //

        ks10_t::data_t cs1_read(void) {
            return ks10_t::readIO(cs1_addr);
        }

        //
        // Write to WC
        //

        void wc_write(ks10_t::data_t data) {
            ks10_t::writeIO(wc_addr, data);
        }

        //
        // Read from WC
        //

        ks10_t::data_t wc_read(void) {
            return ks10_t::readIO(wc_addr);
        }

        //
        // Write to BA
        //

        void ba_write(ks10_t::data_t data) {
            ks10_t::writeIO(ba_addr, data);
        }

        //
        // Read from BA
        //

        ks10_t::data_t ba_read(void) {
            return ks10_t::readIO(ba_addr);
        }

        //
        // Write to DA
        //

        void da_write(ks10_t::data_t data) {
            ks10_t::writeIO(da_addr, data);
        }

        //
        // Read from DA
        //

        ks10_t::data_t da_read(void) {
            return ks10_t::readIO(da_addr);
        }

        //
        // Write to CS2
        //

        void cs2_write(ks10_t::data_t data) {
            ks10_t::writeIO(cs2_addr, data);
        }

        //
        // Read from CS2
        //

        ks10_t::data_t cs2_read(void) {
            return ks10_t::readIO(cs2_addr);
        }

        //
        // Write to DS
        //

        void ds_write(ks10_t::data_t data) {
            ks10_t::writeIO(ds_addr, data);
        }

        //
        // Read from DS
        //

        ks10_t::data_t ds_read(void) {
            return ks10_t::readIO(ds_addr);
        }

        //
        // Write to LA
        //

        void la_write(ks10_t::data_t data) {
            ks10_t::writeIO(la_addr, data);
        }

        //
        // Read from LA
        //

        ks10_t::data_t la_read(void) {
            return ks10_t::readIO(la_addr);
        }

        //
        // Write to DB
        //

        void db_write(ks10_t::data_t data) {
            ks10_t::writeIO(db_addr, data);
        }

        //
        // Read from DB
        //

        ks10_t::data_t db_read(void) {
            return ks10_t::readIO(db_addr);
        }

        //
        // Write to MR
        //

        void mr_write(ks10_t::data_t data) {
            ks10_t::writeIO(mr_addr, data);
        }

        //
        // Read from MR
        //

        ks10_t::data_t mr_read(void) {
            return ks10_t::readIO(mr_addr);
        }

        //
        // Write to DC
        //

        void dc_write(ks10_t::data_t data) {
            ks10_t::writeIO(dc_addr, data);
        }

        //
        // Read from DC
        //

        ks10_t::data_t dc_read(void) {
            return ks10_t::readIO(dc_addr);
        }

};

#endif
