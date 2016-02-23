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
//!    rh11.hpp
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

#ifndef __RH11_HPP
#define __RH11_HPP

#include <stdio.h>
#include "uba.hpp"
#include "ks10.hpp"

//!
//! \brief
//!    RH11 Interface Object
//!

class rh11_t {

    private:

        bool debug;

        //
        // Register Addresses
        //

        const ks10_t::addr_t cs1_addr;
        const ks10_t::addr_t wc_addr;
        const ks10_t::addr_t ba_addr;
        const ks10_t::addr_t da_addr;
        const ks10_t::addr_t cs2_addr;
        const ks10_t::addr_t ds_addr;
        const ks10_t::addr_t as_addr;
        const ks10_t::addr_t la_addr;
        const ks10_t::addr_t db_addr;
        const ks10_t::addr_t mr_addr;
        const ks10_t::addr_t of_addr;
        const ks10_t::addr_t dc_addr;

        //
        // UBA
        //

        uba_t uba;

        //
        // Register offsets
        //

        static const ks10_t::addr_t cs1_offset = 00;
        static const ks10_t::addr_t wc_offset  = 02;
        static const ks10_t::addr_t ba_offset  = 04;
        static const ks10_t::addr_t da_offset  = 06;
        static const ks10_t::addr_t cs2_offset = 010;
        static const ks10_t::addr_t ds_offset  = 012;
        static const ks10_t::addr_t er1_offset = 014;
        static const ks10_t::addr_t as_offset  = 016;
        static const ks10_t::addr_t la_offset  = 020;
        static const ks10_t::addr_t db_offset  = 022;
        static const ks10_t::addr_t mr_offset  = 024;
        static const ks10_t::addr_t of_offset  = 032;
        static const ks10_t::addr_t dc_offset  = 034;

        //
        // Private functions
        //

        void testRPLA20(ks10_t::data_t unit);
        void testRPLA22(ks10_t::data_t unit);
        bool wait(bool verbose = false);
        bool isHomBlock(ks10_t::addr_t addr);
        bool readBlock(ks10_t::addr_t vaddr, ks10_t::data_t block);
        bool bootBlock(ks10_t::addr_t paddr, ks10_t::addr_t vaddr, ks10_t::data_t block, ks10_t::addr_t offset);

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
        // Offset Register (RPOF) Definitions
        //

        static const ks10_t::data_t of_fmt22   = 0010000;

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
        void testInit(ks10_t::data_t unit);
        void testRPLA(ks10_t::data_t unit);
        void testRead(ks10_t::data_t unit);
        void testWrite(ks10_t::data_t unit);
        void testWrchk(ks10_t::data_t unit);
        void boot(ks10_t::data_t unit, bool diagmode = false);

        //!
        //! \brief
        //!    Constructor
        //!
        //! \param base_addr -
        //!    Base address of RH11 address
        //!

        rh11_t (ks10_t::addr_t base_addr, bool debug = false) :
            debug(debug),
            cs1_addr((base_addr & 07777700) + cs1_offset),
            wc_addr ((base_addr & 07777700) + wc_offset ),
            ba_addr ((base_addr & 07777700) + ba_offset ),
            da_addr ((base_addr & 07777700) + da_offset ),
            cs2_addr((base_addr & 07777700) + cs2_offset),
            ds_addr ((base_addr & 07777700) + ds_offset ),
            as_addr ((base_addr & 07777700) + as_offset ),
            la_addr ((base_addr & 07777700) + la_offset ),
            db_addr ((base_addr & 07777700) + db_offset ),
            mr_addr ((base_addr & 07777700) + mr_offset ),
            of_addr ((base_addr & 07777700) + of_offset ),
            dc_addr ((base_addr & 07777700) + dc_offset ),
            uba(base_addr) {
            ;
        }

        //!
        //! \brief
        //!    Write to CS1 register
        //!
        //! \param data -
        //!    data to be written to the CS1 register
        //!

        void cs1_write(ks10_t::data_t data) {
            ks10_t::writeIO(cs1_addr, data);
        }

        //!
        //! \brief
        //!    Read from CS1 register
        //!
        //! \returns
        //!    Contents of CS1 register
        //!

        ks10_t::data_t cs1_read(void) {
            return ks10_t::readIO(cs1_addr);
        }

        //!
        //! \brief
        //!    Write to WC register
        //!
        //! \param data -
        //!    data to be written to the WC register
        //!

        void wc_write(ks10_t::data_t data) {
            ks10_t::writeIO(wc_addr, data);
        }

        //
        //!
        //! \brief
        //!    Read from WC register
        //!
        //! \returns
        //!    Contents of WC register
        //!

        ks10_t::data_t wc_read(void) {
            return ks10_t::readIO(wc_addr);
        }

        //!
        //! \brief
        //!    Write to BA register
        //!
        //! \param data -
        //!    data to be written to the BA register
        //!

        void ba_write(ks10_t::data_t data) {
            ks10_t::writeIO(ba_addr, data);
        }

        //!
        //! \brief
        //!    Read from BA register
        //!
        //! \returns
        //!    Contents of BA register
        //!

        ks10_t::data_t ba_read(void) {
            return ks10_t::readIO(ba_addr);
        }

        //!
        //! \brief
        //!    Write to DA register
        //!
        //! \param data -
        //!    data to be written to the DA register
        //!

        void da_write(ks10_t::data_t data) {
            ks10_t::writeIO(da_addr, data);
        }

        //!
        //! \brief
        //!    Read from DA register
        //!
        //! \returns
        //!    Contents of DA register
        //!

        ks10_t::data_t da_read(void) {
            return ks10_t::readIO(da_addr);
        }

        //!
        //! \brief
        //!    Write to CS2 register
        //!
        //! \param data -
        //!    data to be written to the CS2 register
        //!

        void cs2_write(ks10_t::data_t data) {
            ks10_t::writeIO(cs2_addr, data);
        }

        //!
        //! \brief
        //!    Read from CS2 register
        //!
        //! \returns
        //!    Contents of CS2 register
        //!

        ks10_t::data_t cs2_read(void) {
            return ks10_t::readIO(cs2_addr);
        }

        //!
        //! \brief
        //!    Write to DS register
        //!
        //! \param data -
        //!    data to be written to the DS register
        //!

        void ds_write(ks10_t::data_t data) {
            ks10_t::writeIO(ds_addr, data);
        }

        //!
        //! \brief
        //!    Read from DS register
        //!
        //! \returns
        //!    Contents of DS register
        //!

        ks10_t::data_t ds_read(void) {
            return ks10_t::readIO(ds_addr);
        }

        //!
        //! \brief
        //!    Write to AS register
        //!
        //! \param data -
        //!    data to be written to the AS register
        //!

        void as_write(ks10_t::data_t data) {
            ks10_t::writeIO(as_addr, data);
        }

        //!
        //! \brief
        //!    Read from AS register
        //!
        //! \returns
        //!    Contents of AS register
        //!

        ks10_t::data_t as_read(void) {
            return ks10_t::readIO(as_addr);
        }

        //!
        //! \brief
        //!    Write to LA register
        //!
        //! \param data -
        //!    data to be written to the LA register
        //!

        void la_write(ks10_t::data_t data) {
            ks10_t::writeIO(la_addr, data);
        }

        //!
        //! \brief
        //!    Read from LA register
        //!
        //! \returns
        //!    Contents of LA register
        //!

        ks10_t::data_t la_read(void) {
            return ks10_t::readIO(la_addr);
        }

        //!
        //! \brief
        //!    Write to DB register
        //!
        //! \param data -
        //!    data to be written to the DB register
        //!

        void db_write(ks10_t::data_t data) {
            ks10_t::writeIO(db_addr, data);
        }

        //!
        //! \brief
        //!    Read from DB register
        //!
        //! \returns
        //!    Contents of DB register
        //!

        ks10_t::data_t db_read(void) {
            return ks10_t::readIO(db_addr);
        }

        //!
        //! \brief
        //!    Write to MR register
        //!
        //! \param data -
        //!    data to be written to the MR register
        //!

        void mr_write(ks10_t::data_t data) {
            ks10_t::writeIO(mr_addr, data);
        }

        //!
        //! \brief
        //!    Read from MR register
        //!
        //! \returns
        //!    Contents of MR register
        //!

        ks10_t::data_t mr_read(void) {
            return ks10_t::readIO(mr_addr);
        }

        //!
        //! \brief
        //!    Write to OF register
        //!
        //! \param data -
        //!    data to be written to the OF register
        //!

        void of_write(ks10_t::data_t data) {
            ks10_t::writeIO(of_addr, data);
        }

        //!
        //! \brief
        //!    Read from OF register
        //!
        //! \returns
        //!    Contents of OF register
        //!

        ks10_t::data_t of_read(void) {
            return ks10_t::readIO(of_addr);
        }

        //!
        //! \brief
        //!    Write to DC register
        //!
        //! \param data -
        //!    data to be written to the DC register
        //!

        void dc_write(ks10_t::data_t data) {
            ks10_t::writeIO(dc_addr, data);
        }

        //!
        //! \brief
        //!    Read from DC register
        //!
        //! \returns
        //!    Contents of DC register
        //!

        ks10_t::data_t dc_read(void) {
            return ks10_t::readIO(dc_addr);
        }

};

#endif
