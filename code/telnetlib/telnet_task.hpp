//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! Telnet Task
//!
//! This module initializes lwIP and the telnet task
//!
//! \file
//!      telnet_task.hpp
//!
//! \author
//!      Rob Doyle - doyle (at) cox (dot) net
//
//******************************************************************************
//
// Copyright (C) 2014-2016 Rob Doyle
//
// This program is free software; you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation; either version 2 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 59 Temple
// Place - Suite 330, Boston, MA 02111-1307, USA.
//
//******************************************************************************

#ifndef __TELNET_TASK_HPP
#define __TELNET_TASK_HPP

#include "telnet.hpp"
#include "taskutil.hpp"

extern telnet_t * telnet23;
extern telnet_t * telnet2000;

void startTelnetTask(param_t *param);

#endif
