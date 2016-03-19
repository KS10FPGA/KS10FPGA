//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    Command History Buffer
//!
//! \file
//!    hist.hpp
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

#ifndef __HIST_HPP
#define __HIST_HPP

class hist_t {
    private:
        char buffer[128];
        unsigned int head;
        unsigned int tail;
        unsigned int index;
        unsigned int wrap(unsigned int pos) const;
        void findfree(unsigned int size);
        unsigned int entries(void);
        unsigned int find(unsigned int head, unsigned int which, unsigned int index);
        int copybuffer(char* cmdline, unsigned int header);
        static const unsigned int bufsize = sizeof(buffer);
    public:
        enum dir_t {
            up,
            down,
        };
        hist_t(void);
        void dump(void);
        void save(const char* line, unsigned char len);
        int  recall(char* line, dir_t dir);
};

#endif
