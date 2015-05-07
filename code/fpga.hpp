//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! FPGA Interface Object
//!
//! This object provides the interfaces that are required to load/program the
//! FPGA.
//!  
//! The FPGA provides 3 interface signals to the console microcontroller:
//! -#  PROG# output.  When asserted (low), this signal causes the FPGA to
//!      begin to load firmware from the serial flash memory device.
//! -#  INIT# input.  This signal is asserted (low) if a CRC error occurs
//!      when configuring the FPGA.
//! -#  DONE input.  This signal is asserted (high) when the FPGA has been
//!      configured successfully.
//! \file
//!      fpga.h
//!
//! \author
//!      Rob Doyle - doyle (at) cox (dot) net
//
//******************************************************************************
//
// Copyright (C) 2013-2015 Rob Doyle
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//
//******************************************************************************

#ifndef __FPGA_H
#define __FPGA_H

bool fpgaProg(void);

#endif
