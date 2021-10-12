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
        // Register offsets
        //

        const ks10_t::addr_t offsetCSRA = 000;
        const ks10_t::addr_t offsetCSRB = 002;
        const ks10_t::addr_t offsetBAR  = 004;
        const ks10_t::addr_t offsetBCTR = 006;
        const ks10_t::addr_t offsetPCTR = 010;
        const ks10_t::addr_t offsetRAMD = 012;
        const ks10_t::addr_t offsetCBUF = 014;
        const ks10_t::addr_t offsetPDAT = 016;

        //
        // Register Addresses
        //

        const ks10_t::addr_t addrCSRA;
        const ks10_t::addr_t addrCSRB;
        const ks10_t::addr_t addrBAR;
        const ks10_t::addr_t addrBCTR;
        const ks10_t::addr_t addrPCTR;
        const ks10_t::addr_t addrRAMD;
        const ks10_t::addr_t addrCBUF;
        const ks10_t::addr_t addrPDAT;

        //!
        //! Control and Status Register A (CSRA) definitions
        //!

        static const ks10_t::data_t LPCSRA_ONLN = 0x0800;         //!< Online
        static const ks10_t::data_t LPCSRA_INIT = 0x0100;         //!< Clear
        static const ks10_t::data_t LPCSRA_DONE = 0x0080;         //!< DMA Done
        static const ks10_t::data_t LPCSRA_IE   = 0x0040;         //!< Interrupt enable
        static const ks10_t::data_t LPCSRA_GO   = 0x0001;         //!< Go

        //
        // UBA object
        //

        uba_t uba;

        //
        // LP non-volatile configuration
        //

        struct lpcfg_t {
            uint32_t lpccr;
        } cfg;

    public:

        //
        // LP20 Base Addresses
        //

        static const uint32_t baseADDR1 = 03775400;      //!< base address #1
        static const uint32_t baseADDR2 = 03775420;      //!< base address #2

        //
        // Public Functions
        //

        void recallConfig(void);
        void saveConfig(void);
        void initialize(void);
        void testRegs(void);
        void dumpRegs(void);
        void printFile(const char *filename);

        lp20_t(uint32_t baseADDR = baseADDR1) :
            addrCSRA((baseADDR & 07777760) + offsetCSRA),
            addrCSRB((baseADDR & 07777760) + offsetCSRB),
            addrBAR ((baseADDR & 07777760) + offsetBAR ),
            addrBCTR((baseADDR & 07777760) + offsetBCTR),
            addrPCTR((baseADDR & 07777760) + offsetPCTR),
            addrRAMD((baseADDR & 07777760) + offsetRAMD),
            addrCBUF((baseADDR & 07777760) + offsetCBUF),
            addrPDAT((baseADDR & 07777760) + offsetPDAT),
            uba(baseADDR) {
            ;
        }
};

#endif
