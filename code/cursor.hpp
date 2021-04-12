//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    Cursor Control
//!
//! \file
//!    cursor.hpp
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

#ifndef __CURSOR_HPP
#define __CURSOR_HPP

#include <stdio.h>

class cursor_t {
    private:
        unsigned char curpos;
        unsigned char cursav;
        const unsigned int ps;
    public:
        cursor_t(unsigned int promptSize) : ps(promptSize) {
            curpos = 0;
        };
        unsigned char pos(void) {
            return curpos;
        }
        void fwd(unsigned char offset = 1) {
            if (offset != 0) {
                curpos += offset;
                printf("\033[%dC", offset);
            }
        }
        void back(unsigned char offset = 1) {
            if (offset != 0) {
                curpos -= offset;
                printf("\033[%dD", offset);
            }
        }
        void move(unsigned char pos) {
            back(99);
            fwd(ps + pos);
            curpos = pos;
        }
        void eraseeol(void) {
            printf("\033[K");
        }
        void save(void) {
            cursav = curpos;
            printf("\033[s");
        }
        void restore(void) {
            curpos = cursav;
            printf("\033[u");
        }
        void putchar(char ch) {
            printf("%c", ch);
            switch(ch) {
                case '\a':           ; break;
                case '\b': curpos--  ; break;
                case '\n': curpos = 0; break;
                default  : curpos++  ; break;
            }
        }
};

#endif
