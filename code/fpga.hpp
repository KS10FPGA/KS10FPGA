//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    FPGA Programming Object
//!
//! \details
//!    This object provides some very low level functions that can be used to
//!    program the KS10 FPGA.
//!
//! \file
//!    fpga.hpp
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

#ifndef __FPGA_HPP
#define __FPGA_HPP

#include <stdint.h>
#include "fatfslib/ff.h"

//!
//! \brief
//!    FPGA Programming Interface Object
//!

class fpga_t {
    private:
        static bool isDONE(void);
        static bool isINIT(void);
        static bool waitINIT(void);
        static void pulsePROG(void);
        static void programByte(uint8_t data);
    public:
        fpga_t();
        static bool program(void);
        static bool program(FIL *fp);
};

#endif
