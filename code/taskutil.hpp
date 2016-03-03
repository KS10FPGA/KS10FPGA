//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    Task Utilities
//!
//! \details
//!    These functions are generically useful for the SafeRTOS tasking
//!
//! \file
//!    taskutil.hpp
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

#ifndef __TASKUTIL_HPP
#define __TASKUTIL_HPP

#include "SafeRTOS/SafeRTOS_API.h"

#ifdef __cplusplus
extern "C" {
#endif

//!
//! Task parameters
//!
//! \brief
//!    All of the tasks are create with the task parameter pointing at a struct
//!    of this type.
//!

struct debug_t {
    bool debugCPU;
    bool debugKS10;
    bool debugSDHC;
    bool debugTelnet;
};

//!
//! Task priorities
//!

enum {
    taskIdlePriority    = 0,    // lowest priority
    taskCommandPriority = 1,
    taskConsolePriority = 2,
    taskHaltPriority    = 3,
    taskSDPriority      = 4,    // highest priority
};

//
// Task utilities
//

const char *taskError(portBASE_TYPE error);
void taskErrorHook(xTaskHandle handle, signed portCHAR *name, portBASE_TYPE error);
void taskDeleteHook(xTaskHandle xTaskToDelete);
void taskIdleHook(void);

#ifdef __cplusplus
}
#endif

#endif // __TASKUTIL_HPP
