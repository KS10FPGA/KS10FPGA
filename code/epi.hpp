//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    External Peripheral Interface (EPI) Object
//!
//! \details
//!    This object abstracts the EPI interface. The console microcontroller
//!    interfaces to the KS10 FPGA over the EPI interface.
//!
//! \file
//!    epi.hpp
//!
//! \author
//!    Rob Doyle - doyle (at) cox (dot) net
//
//******************************************************************************
//
// Copyright (C) 2013-2016 Rob Doyle
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

#ifndef __EPI_H
#define __EPI_H

void          EPIInitialize(void);
unsigned long EPIGetAddressMap(void);

#endif
