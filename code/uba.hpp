//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    IO Bridge Interface Object
//!
//! \details
//!    This object allows the console to interact with the IO Bridge Adapter.
//!    This is mostly for testing the various devices from the console.
//!
//! \file
//!    uba.hpp
//!
//! \author
//!    Rob Doyle - doyle (at) cox (dot) net
//
//******************************************************************************
//
// Copyright (C) 2013-2020 Rob Doyle
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

#ifndef __UBA_HPP
#define __UBA_HPP

#include "ks10.hpp"

//!
//! \brief
//!    UBA Interface Object
//!

class uba_t {

    private:

        //
        // Register offsets
        //

        const ks10_t::addr_t offsetUBA = 0763000;
        const ks10_t::addr_t offsetPAG = 0000000;
        const ks10_t::addr_t offsetCSR = 0000100;
        const ks10_t::addr_t offsetMR  = 0000101;

        //
        // Register Addresses
        //

        const ks10_t::addr_t addrPAG;
        const ks10_t::addr_t addrCSR;
        const ks10_t::addr_t addrMR;

    public:

        //
        // UBA Base Addresses
        //

        static const ks10_t::addr_t uba1ADDR   = 01763000;
        static const ks10_t::addr_t uba2ADDR   = 02763000;
        static const ks10_t::addr_t uba3ADDR   = 03763000;
        static const ks10_t::addr_t uba4ADDR   = 04763000;

        //
        // UBA Control Status Register (UBACSR)
        //

        static const ks10_t::data_t UBACSR_TMO = 0400000;
        static const ks10_t::data_t UBACSR_NXD = 0040000;
        static const ks10_t::data_t UBACSR_HI  = 0004000;
        static const ks10_t::data_t UBACSR_LO  = 0002000;
        static const ks10_t::data_t UBACSR_PWR = 0002000;
        static const ks10_t::data_t UBACSR_INI = 0000100;

        //
        // UBA Paging RAM
        //

        static const ks10_t::data_t PAG_RPW    = 0400000;
        static const ks10_t::data_t PAG_E16    = 0200000;
        static const ks10_t::data_t PAG_FTM    = 0100000;
        static const ks10_t::data_t PAG_VLD    = 0040000;

        //!
        //! \brief
        //!    Constructor
        //!
        //! \param baseADDR
        //!    Base address of Unibus Address
        //!

        uba_t (ks10_t::addr_t baseADDR) :
            addrPAG((baseADDR & 07000000) + offsetUBA + offsetPAG),
            addrCSR((baseADDR & 07000000) + offsetUBA + offsetCSR),
            addrMR ((baseADDR & 07000000) + offsetUBA + offsetMR ) {
            ;
        }

        //!
        //! \brief
        //!    Write to CSR
        //!
        //! \param data -
        //!    data to write to the CSR
        //!

        void writeCSR(ks10_t::data_t data) {
            ks10_t::writeIO(addrCSR, data);
        }

        //!
        //! \brief
        //!    Read from CSR
        //!
        //! \return
        //!    Contents of CSR Register
        //!

        ks10_t::data_t readCSR(void) {
            return ks10_t::readIO(addrCSR);
        }

        //!
        //! \brief
        //!    Write to Paging Memory
        //!
        //! \param offset -
        //!    address of Paging Memory
        //!
        //! \param data -
        //!    data to write to Paging Memory
        //!

        void writePAG(ks10_t::addr_t offset, ks10_t::data_t data) {
            ks10_t::writeIO(addrPAG + offset, data);
        }

        //!
        //! \brief
        //!    Read from Paging Memory
        //!
        //! \param offset -
        //!    address of Paging Memory
        //!
        //! \returns
        //!    Contents of Paging Memmory
        //!

        ks10_t::data_t readPAG(ks10_t::addr_t offset) {
            return ks10_t::readIO(addrPAG + offset);
        }

        //!
        //! \brief
        //!    Function to convert address to page
        //!
        //! \param addr -
        //!    memory address
        //!
        //! \returns
        //!    page associated with the address
        //!

        static ks10_t::data_t addr2page(ks10_t::addr_t addr) {
            return (addr >> 9) & 03777;
        }
};

#endif
