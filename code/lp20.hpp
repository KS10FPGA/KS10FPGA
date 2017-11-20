//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    LP20 Interface Object
//!
//! \details
//!    This object allows the console to interact with the LP20 Line Printer
//!    Controller
//!
//! \file
//!    lp20.hpp
//!
//! \author
//!    Rob Doyle - doyle (at) cox (dot) net
//
//******************************************************************************
//
// Copyright (C) 2013-2017 Rob Doyle
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

#ifndef __LP20_HPP
#define __LP20_HPP

#include "ks10.hpp"

//!
//! \brief
//!    LP20 Interface Object
//!

class lp20_t {
    private:

        //
        //! Control and Status Register A (CSRA) definitions
        //

        static const ks10_t::addr_t csra_addr = 03775400;       //!< CSRA Address
        static const ks10_t::data_t csra_onln = 0x0800;         //!< Online
        static const ks10_t::data_t csra_init = 0x0100;         //!< Clear
        static const ks10_t::data_t csra_done = 0x0080;         //!< DMA Done
        static const ks10_t::data_t csra_ie   = 0x0040;         //!< Interrupt enable
        static const ks10_t::data_t csra_go   = 0x0001;         //!< Go

        //
        //! Control and Status Register B (CSRB) definitions
        //

        static const ks10_t::addr_t csrb_addr = 03775402;

        //
        //! Bus Address Register (BAR) definitions
        //

        static const ks10_t::addr_t bar_addr = 03775404;

        //
        //! Byte Count Register (BCTR)
        //

        static const ks10_t::addr_t bctr_addr = 03775406;

        //
        //! Page Count Register (PCTR)
        //

        static const ks10_t::addr_t pctr_addr = 03775410;

        //
        //! RAM Data Register (RAMD)
        //

        static const ks10_t::addr_t ramd_addr = 03775412;

        //
        //! Character Buffer Register (CBUF)
        //! Column Counter Register (CCTR)
        //

        static const ks10_t::addr_t cbuf_addr = 03775414;

        //
        //! Printer Data Register (PDAT)
        //! Checksum Register (CKSM)
        //

        static const ks10_t::addr_t pdat_addr = 03775416;

        static void setup(unsigned int line);

    public:

        //
        // LP20 Base Addresses
        //

        static const ks10_t::addr_t base_addr1 = 03775400;      //!< base address #1
        static const ks10_t::addr_t base_addr2 = 03775420;      //!< base address #2

        static void initialize(void);
        static void testRegs(void);
        static void dumpRegs(void);
};

#endif
