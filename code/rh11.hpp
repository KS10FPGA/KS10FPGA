//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    RH11 Interface Object
//!
//! \details
//!    This object allows the console to interact with the RH11 Massbus
//!    controller.
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

#ifndef __RH11_HPP
#define __RH11_HPP

#include <stdio.h>
#include <stdint.h>

#include "uba.hpp"
#include "ks10.hpp"

//!
//! \brief
//!    RH11 Interface Object
//!

class rh11_t {

    private:

        //
        // Register offsets
        //

        const ks10_t::addr_t offsetCS1 = 000;
        const ks10_t::addr_t offsetWC  = 002;
        const ks10_t::addr_t offsetBA  = 004;
        const ks10_t::addr_t offsetDA  = 006;
        const ks10_t::addr_t offsetFC  = 006;
        const ks10_t::addr_t offsetCS2 = 010;
        const ks10_t::addr_t offsetDS  = 012;
        const ks10_t::addr_t offsetER  = 014;
        const ks10_t::addr_t offsetAS  = 016;
        const ks10_t::addr_t offsetLA  = 020;
        const ks10_t::addr_t offsetCC  = 020;
        const ks10_t::addr_t offsetDB  = 022;
        const ks10_t::addr_t offsetMR  = 024;
        const ks10_t::addr_t offsetDT  = 026;
        const ks10_t::addr_t offsetSN  = 030;
        const ks10_t::addr_t offsetOF  = 032;
        const ks10_t::addr_t offsetTC  = 032;
        const ks10_t::addr_t offsetDC  = 034;

    protected:

        //
        // Register Addresses
        //

        const ks10_t::addr_t addrCS1;
        const ks10_t::addr_t addrWC;
        const ks10_t::addr_t addrBA;
        const ks10_t::addr_t addrDA;
        const ks10_t::addr_t addrFC;
        const ks10_t::addr_t addrCS2;
        const ks10_t::addr_t addrDS;
        const ks10_t::addr_t addrER;
        const ks10_t::addr_t addrAS;
        const ks10_t::addr_t addrLA;
        const ks10_t::addr_t addrCC;
        const ks10_t::addr_t addrDB;
        const ks10_t::addr_t addrMR;
        const ks10_t::addr_t addrDT;
        const ks10_t::addr_t addrSN;
        const ks10_t::addr_t addrOF;
        const ks10_t::addr_t addrTC;
        const ks10_t::addr_t addrDC;

        //
        // RH11 Control and Status Register #1 (RHCS1)
        //

        static const uint16_t RHCS1_SC     = 0100000;
        static const uint16_t RHCS1_RDY    = 0000200;
        static const uint16_t RHCS1_CMDRD  = 0000070;
        static const uint16_t RHCS1_CMDWR  = 0000060;
        static const uint16_t RHCS1_CMDWCH = 0000050;
        static const uint16_t RHCS1_CMDPRE = 0000020;
        static const uint16_t RHCS1_CMDCLR = 0000010;
        static const uint16_t RHCS1_GO     = 0000001;

        //
        // RH11 Control and Status Register #2 (RHCS2)
        //

        static const uint16_t RHCS2_WCE    = 0040000;
        static const uint16_t RHCS2_OR     = 0000200;
        static const uint16_t RHCS2_IR     = 0000100;
        static const uint16_t RHCS2_CLR    = 0000040;
        static const uint16_t RHCS2_UNIT   = 0000007;

        //
        // UBA object
        //

        uba_t uba;

        //
        // Protected functions
        //

        bool wait(bool verbose = false);

    public:

        //
        // Public functions
        //

        void clear(void);
        void testFIFO(void);
        void testInit(uint16_t unit);
        void boot(uint16_t unit, bool diagmode = false);

        //!
        //! \brief
        //!    Constructor
        //!
        //! \param baseADDR -
        //!    Base address of RH11 address
        //!

        rh11_t (uint32_t baseADDR) :
            addrCS1((baseADDR & 07777740) + offsetCS1),
            addrWC ((baseADDR & 07777740) + offsetWC ),
            addrBA ((baseADDR & 07777740) + offsetBA ),
            addrDA ((baseADDR & 07777740) + offsetDA ),
            addrFC ((baseADDR & 07777740) + offsetFC ),
            addrCS2((baseADDR & 07777740) + offsetCS2),
            addrDS ((baseADDR & 07777740) + offsetDS ),
            addrER ((baseADDR & 07777740) + offsetER ),
            addrAS ((baseADDR & 07777740) + offsetAS ),
            addrLA ((baseADDR & 07777740) + offsetLA ),
            addrCC ((baseADDR & 07777740) + offsetCC ),
            addrDB ((baseADDR & 07777740) + offsetDB ),
            addrMR ((baseADDR & 07777740) + offsetMR ),
            addrDT ((baseADDR & 07777740) + offsetDT ),
            addrSN ((baseADDR & 07777740) + offsetSN ),
            addrOF ((baseADDR & 07777740) + offsetOF ),
            addrTC ((baseADDR & 07777740) + offsetTC ),
            addrDC ((baseADDR & 07777740) + offsetDC ),
            uba(baseADDR) {
            ;
        }
};

#endif
