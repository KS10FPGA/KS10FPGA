//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! IO Bridge Interface Object
//!
//! This object allows the console to interact with the IO Bridge Adapter.
//! This is mostly for testing the various devices from the console.
//!
//! \file
//!    uba.hpp
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

#ifndef __UBA_HPP
#define __UBA_HPP

#include "ks10.hpp"

//!
//! UBA Interface Object
//!

class uba_t {

    public:

        //
        // UBA Control Status Register (UBACSR)
        //

        static const ks10_t::addr_t csr_addr = 01763100;
        static const ks10_t::data_t csr_tmo  = 0400000;
        static const ks10_t::data_t csr_nxd  = 0040000;
        static const ks10_t::data_t csr_hi   = 0004000;
        static const ks10_t::data_t csr_lo   = 0002000;
        static const ks10_t::data_t csr_pwr  = 0002000;
        static const ks10_t::data_t csr_ini  = 0000100;

        //
        // UBA Paging RAM
        //

        static const ks10_t::addr_t pag_addr = 0176300;
        static const ks10_t::data_t pag_rpw  = 0400000;
        static const ks10_t::data_t pag_e16  = 0200000;
        static const ks10_t::data_t pag_ftm  = 0100000;
        static const ks10_t::data_t pag_vld  = 0040000;
        static const ks10_t::data_t page70   = 0000070;
};

#endif
