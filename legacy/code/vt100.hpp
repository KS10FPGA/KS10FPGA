//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    VT100 Escape Sequences
//!
//! \file
//!    vt100.hpp
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

#ifndef __VT100_HPP
#define __VT100_HPP

//
// VT100 display Attributes
//

static const char vt100at_rst[] = "\e[0m";
static const char vt100at_brt[] = "\e[1m";
static const char vt100at_dim[] = "\e[2m";
static const char vt100at_und[] = "\e[4m";
static const char vt100at_bnk[] = "\e[5m";
static const char vt100at_rev[] = "\e[7m";
static const char vt100at_hid[] = "\e[8m";

//
// VT100 display foreground colors
//

static const char vt100fg_blk[] = "\e[0;30m";
static const char vt100fg_red[] = "\e[0;31m";
static const char vt100fg_grn[] = "\e[0;32m";
static const char vt100fg_yel[] = "\e[0;33m";
static const char vt100fg_blu[] = "\e[0;34m";
static const char vt100fg_mag[] = "\e[0;35m";
static const char vt100fg_cyn[] = "\e[0;36m";
static const char vt100fg_wht[] = "\e[0;37m";

//
// VT100 display background colors
//

static const char vt100bg_blk[] = "\e[0;40m";
static const char vt100bg_red[] = "\e[0;41m";
static const char vt100bg_grn[] = "\e[0;42m";
static const char vt100bg_yel[] = "\e[0;43m";
static const char vt100bg_blu[] = "\e[0;44m";
static const char vt100bg_mag[] = "\e[0;45m";
static const char vt100bg_cyn[] = "\e[0;46m";
static const char vt100bg_wht[] = "\e[0;47m";

#endif
