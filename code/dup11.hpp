//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    DUP11 Interface Object
//!
//! \details
//!    This object allows the console to interact with the DUP11
//!
//! \file
//!    dup11.hpp
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

#ifndef __DUP11_HPP
#define __DUP11_HPP

#include "ks10.hpp"

//!
//! \brief
//!    DUP11 Interface Object
//!

class dup11_t {
    private:

        //
        // Register offsets
        //

        const ks10_t::addr_t offsetRXCSR  = 00;
        const ks10_t::addr_t offsetRXDBUF = 02;
        const ks10_t::addr_t offsetPARCSR = 02;
        const ks10_t::addr_t offsetTXCSR  = 04;
        const ks10_t::addr_t offsetTXDBUF = 06;

        //
        // Register Addresses
        //

        const ks10_t::addr_t addrRXCSR;
        const ks10_t::addr_t addrRXDBUF;
        const ks10_t::addr_t addrPARCSR;
        const ks10_t::addr_t addrTXCSR;
        const ks10_t::addr_t addrTXDBUF;

        //
        // UBA object
        //

        uba_t uba;

        //
        // LP non-volatile configuration
        //

        struct dzcfg_t {
            uint32_t dupccr;
        } cfg;

    public:

        //
        // DUP11 Base Addresses
        //

        static const uint32_t baseADDR1 = 03760300;      //!< base address #1
        static const uint32_t baseADDR2 = 03760310;      //!< base address #2

        //
        // Public Functions
        //

        void recallConfig(void);
        void saveConfig(void);
        void dumpRegs(void);

        dup11_t(uint32_t baseADDR = baseADDR1) :
            addrRXCSR ((baseADDR & 07777770) + offsetRXCSR ),
            addrRXDBUF((baseADDR & 07777770) + offsetRXDBUF),
            addrPARCSR((baseADDR & 07777770) + offsetPARCSR),
            addrTXCSR ((baseADDR & 07777770) + offsetTXCSR ),
            addrTXDBUF((baseADDR & 07777770) + offsetTXDBUF),
            uba(baseADDR) {
            ;
        }

};

#endif
