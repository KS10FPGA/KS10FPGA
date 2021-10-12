//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    RH11 Interface Object
//!
//! \details
//!    This object allows the console to interact with the RP Disk Controller.
//!
//! \file
//!    rh11.hpp
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
//

#ifndef __RP_HPP
#define __RP_HPP

#include <stdio.h>
#include <stdint.h>

#include "uba.hpp"
#include "ks10.hpp"
#include "rh11.hpp"

//!
//! \brief
//!    RP Interface Object
//!

class rp_t : public rh11_t {

    private:

        //
        // RPxx Offset Register (RPOF)
        //

        static const uint16_t RPOF_FMT22   = 0010000;

        //
        // RPxx Maintenance Register (RPMR)
        //

        static const uint16_t RPMR_DSCK    = 0000010;
        static const uint16_t RPMR_DIND    = 0000004;
        static const uint16_t RPMR_DCLK    = 0000002;
        static const uint16_t RPMR_DMD     = 0000001;

        //
        // RPxx Drive Status Register (RPDS)
        //

        static const uint16_t RPDS_MOL     = 0010000;
        static const uint16_t RPDS_VV      = 0000100;

        //
        // Private functions
        //

        void testRPLA20(uint16_t unit);
        void testRPLA22(uint16_t unit);
        bool isHomBlock(ks10_t::addr_t addr);
        bool readBlock(ks10_t::addr_t vaddr, ks10_t::data_t daddr);
        bool bootBlock(ks10_t::addr_t paddr, ks10_t::addr_t vaddr, ks10_t::data_t daddr, ks10_t::addr_t offset);

    public:

        static const uint32_t baseADDR_RP = 01776700;

        //
        // RP non-volatile configuration
        //

        struct cfg_t {
            uint32_t rpccr;             // Console control register
            uint32_t baseaddr;          // Base address (includes UBA field)
            uint8_t  unit;              // Selected disk unit
            bool     bootdiag;          // Boot to diagnostic monitor
        } cfg;

        //
        // Public Functions
        //

        void dumpRegs(void);
        void testInit(uint16_t unit);
        void testRPLA(uint16_t unit);
        void testRead(uint16_t unit);
        void testWrite(uint16_t unit);
        void testWrchk(uint16_t unit);
        void recallConfig(void);
        void saveConfig(void);
        void boot(uint16_t unit, bool diagmode = false);
        rp_t(uint32_t baseADDR = baseADDR_RP) : rh11_t(baseADDR) {
            ;
        }
};

#endif
