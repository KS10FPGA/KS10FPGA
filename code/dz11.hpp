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
// Copyright (C) 2013-2022 Rob Doyle
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

#include "uba.hpp"
#include "ks10.hpp"

//!
//! \brief
//!    DZ11 Interface Object
//!

class dz11_t {
    private:

        //
        // Register offsets
        //

        const ks10_t::addr_t offsetCSR  = 00;
        const ks10_t::addr_t offsetRBUF = 02;
        const ks10_t::addr_t offsetLPR  = 02;
        const ks10_t::addr_t offsetTCR  = 04;
        const ks10_t::addr_t offsetMSR  = 06;
        const ks10_t::addr_t offsetTDR  = 06;

        //
        // Register Addresses
        //

        const ks10_t::addr_t addrCSR;
        const ks10_t::addr_t addrRBUF;
        const ks10_t::addr_t addrLPR;
        const ks10_t::addr_t addrTCR;
        const ks10_t::addr_t addrMSR;
        const ks10_t::addr_t addrTDR;

        //
        // UBA object
        //

        uba_t uba;

        void setup(unsigned int line);

    public:

        uint16_t readTCR(void) {
            return ks10_t::readIO16(addrTCR);
        }

        void writeTCR(uint16_t data) {
            ks10_t::writeIO16(addrTCR, data);
        }

        //
        // DZ11 Base Addresses
        //

        static const uint32_t baseADDR1 = 03760010;      //!< base address #1
        static const uint32_t baseADDR2 = 03760020;      //!< base address #2
        static const uint32_t baseADDR3 = 03760030;      //!< base address #3
        static const uint32_t baseADDR4 = 03760040;      //!< base address #4

        //
        //! Control and Status Register (CSR) definitions
        //

        static const ks10_t::data_t DZCSR_TRDY  = 0x8000;         //!< Transmit Ready
        static const ks10_t::data_t DZCSR_RDONE = 0x0080;         //!< Receiver Done
        static const ks10_t::data_t DZCSR_MSE   = 0x0020;         //!< Master Scan Enable
        static const ks10_t::data_t DZCSR_CLR   = 0x0010;         //!< Clear

        //
        // Public Functions
        //

        void testTX(int line);
        void testRX(int line);
        void testECHO(int line);
        void dumpRegs(void);

        //!
        //! \brief
        //!    Constructor. Setup register addresses.
        //!

        dz11_t(uint32_t baseADDR = baseADDR1) :
            addrCSR ((baseADDR & 07777770) + offsetCSR ),
            addrRBUF((baseADDR & 07777770) + offsetRBUF),
            addrLPR ((baseADDR & 07777770) + offsetLPR ),
            addrTCR ((baseADDR & 07777770) + offsetTCR ),
            addrMSR ((baseADDR & 07777770) + offsetMSR ),
            addrTDR ((baseADDR & 07777770) + offsetTDR ),
            uba(baseADDR) {
                ;
        }
};

#endif
