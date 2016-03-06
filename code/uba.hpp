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
        // Register Addresses
        //

        const ks10_t::addr_t csr_addr;
        const ks10_t::addr_t pag_addr;
        static const ks10_t::addr_t uba_offset = 0763000;

    public:

        //
        // UBA Base Addresses
        //

        static const ks10_t::addr_t pag_offset = 0000000;
        static const ks10_t::addr_t uba0       = (0 << 18) + uba_offset;
        static const ks10_t::addr_t uba1       = (1 << 18) + uba_offset;
        static const ks10_t::addr_t uba2       = (2 << 18) + uba_offset;
        static const ks10_t::addr_t uba3       = (3 << 18) + uba_offset;
        static const ks10_t::addr_t uba4       = (4 << 18) + uba_offset;

        //
        // UBA Control Status Register (UBACSR)
        //

        static const ks10_t::addr_t csr_offset = 0000100;
        static const ks10_t::data_t csr_tmo    = 0400000;
        static const ks10_t::data_t csr_nxd    = 0040000;
        static const ks10_t::data_t csr_hi     = 0004000;
        static const ks10_t::data_t csr_lo     = 0002000;
        static const ks10_t::data_t csr_pwr    = 0002000;
        static const ks10_t::data_t csr_ini    = 0000100;

        //
        // UBA Paging RAM
        //

        static const ks10_t::data_t pag_rpw    = 0400000;
        static const ks10_t::data_t pag_e16    = 0200000;
        static const ks10_t::data_t pag_ftm    = 0100000;
        static const ks10_t::data_t pag_vld    = 0040000;

        //!
        //! \brief
        //!    Constructor
        //!
        //! \param base_addr -
        //!    Base address of Unibus Address
        //!

        uba_t (ks10_t::addr_t base_addr) :
            csr_addr((base_addr & 07000000) + uba_offset + csr_offset),
            pag_addr((base_addr & 07000000) + uba_offset + pag_offset) {
            ;
        }

        //!
        //! \brief
        //!    Write to CSR
        //!
        //! \param data -
        //!    data to write to the CSR
        //!

        void csr_write(ks10_t::data_t data) {
            ks10_t::writeIO(csr_addr, data);
        }

        //!
        //! \brief
        //!    Read from CSR
        //!
        //! \return
        //!    Contents of CSR Register
        //!

        ks10_t::data_t csr_read(void) {
            return ks10_t::readIO(csr_addr);
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

        void pag_write(ks10_t::addr_t offset, ks10_t::data_t data) {
            ks10_t::writeIO(pag_addr + offset, data);
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

        ks10_t::data_t pag_read(ks10_t::addr_t offset) {
            return ks10_t::readIO(pag_addr + offset);
        }

        //!
        //! \brief
        //!    Function to convert address to page
        //!
        //! \param addr -
        //!    memory address
        //!
        //! \returns
        //!    page assocated with the address
        //!

        static inline ks10_t::data_t addr2page(ks10_t::addr_t addr) {
            return (addr >> 9) & 03777;
        }
};

#endif
