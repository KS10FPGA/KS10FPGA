//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    Command Line Processor
//!
//! \file
//!    cmdline.hpp
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

#ifndef __CMDLINE_HPP
#define __CMDLINE_HPP

#include <string.h>

#include "hist.hpp"
#include "cursor.hpp"

class cmdline_t {
    private:
        hist_t hist;
        cursor_t cursor;
        void get_hist(hist_t::dir_t dir);
        void update(void);
        void inschar(char ch);
        void delchar(void);
        void backspace(void);
        void transpose(void);
        bool newline(void);
        enum state_t {
            stateNONE,
            stateESC,
            stateESCBRK,
            statePFN,
            stateHOME,
            stateINS,
            stateEND,
            statePGUP,
            statePGDN,
        } state;
        char cmdline[80];
        unsigned int cmdlen;
    public:
        cmdline_t(unsigned int promptSize);
        bool process(int ch);
};

#endif
