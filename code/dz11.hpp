//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! DZ11 Interface Object
//!
//! This object allows the console to interact with the DZ11 Terminal
//! Multiplexer.   This is mostly for testing the DZ11 from the console.
//!
//! \file
//!    dz11.hpp
//!
//! \author
//!    Rob Doyle - doyle (at) cox (dot) net
//
//******************************************************************************
//
// Copyright (C) 2013-2015 Rob Doyle
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option)
// any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
// more details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 59 Temple
// Place - Suite 330, Boston, MA 02111-1307, USA.
//
//******************************************************************************

#ifndef __DZ11_HPP
#define __DZ11_HPP

#include "ks10.hpp"

//!
//! DZ11 Interface Object
//!

class dz11_t {
    private:

        //
        // Control and Status Register (CSR) definitions
        //

        static const ks10_t::addr_t csr_addr  = 03760010;
        static const ks10_t::data_t csr_trdy  = 0x8000;
        static const ks10_t::data_t csr_rdone = 0x0080;
        static const ks10_t::data_t csr_mse   = 0x0020;
        static const ks10_t::data_t csr_clr   = 0x0010;

        //
        // Receiver Buffer Register (RBUF) definitions
        //

        static const ks10_t::addr_t rbuf_addr = 03760012;

        //
        // Line Parameter Register (LPR) definitions
        //

        static const ks10_t::addr_t lpr_addr = 03760012;

        //
        // Transmit Control Register (TCR) definitions
        //

        static const ks10_t::addr_t tcr_addr = 03760014;

        //
        // Modem Status Register (MSR) definitions
        //

        static const ks10_t::addr_t msr_addr = 03760016;

        //
        // Transmit Data Register (TDR) definitions
        //

        static const ks10_t::addr_t tdr_addr = 03760016;

        static void setup(unsigned int line);

    public:

        //
        // DZ11 Base Addresses
        //

        static const ks10_t::addr_t base_addr1 = 03760010;
        static const ks10_t::addr_t base_addr2 = 03760020;
        static const ks10_t::addr_t base_addr3 = 03760030;
        static const ks10_t::addr_t base_addr4 = 03760040;

        static void testTX(char line);
        static void testRX(char line);
        static void testECHO(char line);
};

#endif
