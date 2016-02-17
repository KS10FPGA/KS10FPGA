//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! ConsoleTask
//!
//! This task implements the console.
//!
//! \file
//!    console.hpp
//!
//! \author
//!    Rob Doyle - doyle (at) cox (dot) net
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

#ifndef __CONSOLE_HPP
#define __CONSOLE_HPP

#include "SafeRTOS/SafeRTOS_API.h"

void startConsole(void);
extern xQueueHandle serialQueueHandle;

#endif  // __CONSOLE_HPP
