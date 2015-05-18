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

#include "ks10.hpp"

//!
//! RH11 Interface Object
//!

class rh11_t {
    private:

        //
        // RH11 Control and Status Register #1 (RHCS1)
        //

        static const ks10_t::addr_t rhcs1_addr = 01776700;
        static const ks10_t::data_t rhcs1_go   = 0x0001;
        static const ks10_t::data_t rhcs1_read = 0x0038;
        static const ks10_t::data_t rhcs1_rdy  = 0x0080;


        //
        // RH11 Word Count Register (RHWC)
        //

        static const ks10_t::addr_t rhwc_addr  = 01776702;

        //
        // RH11 Bus Address Register (RHBA)
        //

        static const ks10_t::addr_t rhba_addr  = 01776704;

        //
        // RPxx Disk Address Register (RPDA)
        //

        static const ks10_t::addr_t rpda_addr  = 01776706;

        //
        // RH11 Control and Status Register #2 (RHCS2) definitions
        //

        static const ks10_t::addr_t rhcs2_addr = 01776710;
        static const ks10_t::data_t rhcs2_or   = 0x0080;
        static const ks10_t::data_t rhcs2_ir   = 0x0040;
        static const ks10_t::data_t rhcs2_clr  = 0x0020;

        //
        // RPxx Look Ahead Register (RPLA)
        //

        static const ks10_t::addr_t rpla_addr  = 01776720;

        //
        // RH11 Data Buffer Register (RHDB)
        //

        static const ks10_t::addr_t rhdb_addr  = 01776722;

        //
        // RPxx Maintenance Register (RPMR) Definitions
        //

        static const ks10_t::addr_t rpmr_addr  = 01776724;
        static const ks10_t::data_t mr_dmd     = 0x0001;
        static const ks10_t::data_t mr_dclk    = 0x0002;
        static const ks10_t::data_t mr_dind    = 0x0004;
        static const ks10_t::data_t mr_dsck    = 0x0008;

    public:

        static void testFIFO(void);
        static void testRPLA(void);
        static void testRead(unsigned int disk);

};

#endif
