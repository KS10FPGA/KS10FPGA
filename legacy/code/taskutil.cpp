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
//!    taskutil.cpp
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

#include "stdio.h"

#include "fatal.hpp"
#include "taskutil.hpp"
#include "SafeRTOS/SafeRTOS_API.h"

//!
//! \brief
//!    Lookup error message
//!
//! \param error -
//!    SafeRTOS error number
//!
//! \returns
//!    Pointer to character string with error message.
//!

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

//!
//! \brief
//!    Task Error Hook
//!
//! \details
//!    This function is called whenever a task error occurs.
//!
//! \param handle -
//!    handle of the failed task
//!
//! \param name -
//!    name of the failed task
//!
//! \param error -
//!    error number of the failed task
//!

void taskErrorHook(xTaskHandle handle, signed portCHAR *name, portBASE_TYPE error) {
    printf("\nSafeRTOS Error: task=\"%s\": %s (handle = 0x%08lx)\n", name, taskError(error), (unsigned long)handle);
    fatal();
}

//!
//! \brief
//!    Task Delete Hook
//!
//! \details
//!    This function is execute whenever a task is deleted.
//!

void taskDeleteHook(xTaskHandle /* xTaskToDelete */) {
    ;
}

//!
//! \brief
//!    Idle Task
//!
//! \details
//!    This function is executed whenever there is no task to execute.

void taskIdleHook(void) {
    ;
}

//!
//! \brief
//!    Determine if a task is running.
//!
//! \details
//!    Query the task priority.  If the task isn't running the returned status
//!    should be errINVALID_TASK_HANDLE.  If the taskHandle is NULL (first
//!    invocation) be careful not to check the priority - you'll get the
//!    priority of the console process.
//!

bool taskIsRunning(xTaskHandle taskHandle) {
    if (taskHandle == NULL) {
        return false;
    }
    unsigned portBASE_TYPE priority;
    portBASE_TYPE status = xTaskPriorityGet(taskHandle, &priority);
    return (status == pdPASS);
}
