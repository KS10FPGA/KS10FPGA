//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! Task Utilities
//!
//! \file
//!   taskutil.cpp
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

#include "stdio.h"

#include "fatal.hpp"
#include "taskutil.hpp"
#include "SafeRTOS/SafeRTOS_API.h"

//
//! Lookup error message
//

const char *taskError(portBASE_TYPE error) {
    switch (error) {
        case errSUPPLIED_BUFFER_TOO_SMALL:
            return "Buffer toosmall";
        case errINVALID_PRIORITY:
            return "Invalid priority";
        case errQUEUE_FULL:
            return "Queue full";
        case errINVALID_BYTE_ALIGNMENT:
            return "Invalid byte alignment";
        case errNULL_PARAMETER_SUPPLIED:
            return "Null parameter supplied";
        case errINVALID_QUEUE_LENGTH:
            return "Invalid queue length";
        case errINVALID_TASK_CODE_POINTER:
            return "Invalid task code pointer";
        case errSCHEDULER_IS_SUSPENDED:
            return "Scheduler is suspended";
        case errINVALID_TASK_HANDLE:
            return "Invalid task handle";
        case errDID_NOT_YIELD:
            return "Did not yield";
        case errTASK_ALREADY_SUSPENDED:
            return "Task alread suspended";
        case errTASK_WAS_NOT_SUSPENDED:
            return "Task was not suspended";
        case errNO_TASKS_CREATED:
            return "No task created";
        case errSCHEDULER_ALREADY_RUNNING:
            return "Scheduler already running";
        case errINVALID_QUEUE_HANDLE:
            return "Invalid queue handle";
        case errERRONEOUS_UNBLOCK:
            return "Erroneous unblock";
        case errQUEUE_EMPTY:
            return "Queue empty";
        case errINVALID_TICK_VALUE:
            return "Invalid tick value";
        case errINVALID_TASK_SELECTED:
            return "Invalid task selected";
        case errTASK_STACK_OVERFLOW:
            return "Task stack overflow";
        case errSCHEDULER_WAS_NOT_SUSPENDED:
            return "Scheduler was not suspended";
        case errINVALID_BUFFER_SIZE:
            return "Invalid buffer size";
        case errBAD_OR_NO_TICK_RATE_CONFIGURATION:
            return "Bad or no tick rate configuration";
        case errBAD_HOOK_FUNCTION_ADDRESS:
            return "Bad hook function address";
        case errERROR_IN_VECTOR_TABLE:
            return "Error in vector table";
        case errINVALID_portQUEUE_OVERHEAD_BYTES_SETTING:
            return "Invalid port queue overhead bytes setting";
        case errINVALID_SIZEOF_TCB:
            return "Invalid TCB size";
        case errINVALID_SIZEOF_QUEUE_STRUCTURE:
            return "Invalid queue structure size";
        default:
            return "Unknown";
    }
}

//
//! Task Error Hook
//

void taskErrorHook(xTaskHandle handle, signed portCHAR *name, portBASE_TYPE error) {
    fatal("\nSafeRTOS Error: task=\"%s\": %s (handle = 0x%08lx)\n", name, taskError(error), (unsigned long)handle);
}

//
//! Task Delete Hook
//

void taskDeleteHook(xTaskHandle /* xTaskToDelete */) {
    ;
}

//
//! Idle Task
//

void taskIdleHook(void) {
    ;
}
