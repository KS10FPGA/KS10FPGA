//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    DZ11 Interface Object
//!
//! \details
//!    This object allows the console to interact with the DZ11 Terminal
//!    Multiplexer.   This is mostly for testing the DZ11 from the console.
//!
//! \file
//!    dz11.hpp
//!
//! \author
//!    Rob Doyle - doyle (at) cox (dot) net
//
//******************************************************************************
//
// Copyright (C) 2013-2016 Rob Doyle
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

#ifndef __DZ11_HPP
#define __DZ11_HPP

#include "ks10.hpp"

//!
//! \brief
//!    DZ11 Interface Object
//!

class dz11_t {
    private:

        //
        //! Control and Status Register (CSR) definitions
        //

        static const ks10_t::addr_t csr_addr  = 03760010;       //!< CSR Address
        static const ks10_t::data_t csr_trdy  = 0x8000;         //!< Transmit Ready
        static const ks10_t::data_t csr_rdone = 0x0080;         //!< Receiver Done
        static const ks10_t::data_t csr_mse   = 0x0020;         //!< Master Scan Enable
        static const ks10_t::data_t csr_clr   = 0x0010;         //!< Clear

        //
        //! Receiver Buffer Register (RBUF) definitions
        //

        static const ks10_t::addr_t rbuf_addr = 03760012;

        //
        //! Line Parameter Register (LPR) definitions
        //

        static const ks10_t::addr_t lpr_addr = 03760012;

        //
        //! Transmit Control Register (TCR) definitions
        //

        static const ks10_t::addr_t tcr_addr = 03760014;

        //
        //! Modem Status Register (MSR) definitions
        //

        static const ks10_t::addr_t msr_addr = 03760016;

        //
        //! Transmit Data Register (TDR) definitions
        //

        static const ks10_t::addr_t tdr_addr = 03760016;

        static void setup(unsigned int line);

    public:

        //
        // DZ11 Base Addresses
        //

        static const ks10_t::addr_t base_addr1 = 03760010;      //!< base address #1
        static const ks10_t::addr_t base_addr2 = 03760020;      //!< base address #2
        static const ks10_t::addr_t base_addr3 = 03760030;      //!< base address #3
        static const ks10_t::addr_t base_addr4 = 03760040;      //!< base address #4

        static void testTX(char line);
        static void testRX(char line);
        static void testECHO(char line);
};

#endif
