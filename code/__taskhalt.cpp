//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! Halt Task
//!
//! The halt task watches the KS10 for transtions of the halt status.
//!
//! \file
//!    taskhalt.cpp
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

#include "ks10.hpp"
#include "stdio.h"
#include "align.hpp"
#include "fatal.hpp"
#include "taskhalt.hpp"
#include "taskutil.hpp"
#include "commands.hpp"
#include "SafeRTOS/SafeRTOS_API.h"

//
//! Halt Task
//!
//! Prints a message when the KS10 changes halt state.
//!
//! \param [in] param (not used)
//!
//

static void taskHalt(void * /*param*/) {
    bool lastHalt = false;
    for (;;) {
        bool halt = ks10_t::halt();
        if (halt && !lastHalt) {
            printf("KS10: %sHalted.%s\n", "\e[0;31m", "\e[0m");
            printHaltStatus();
        } else if (!halt && lastHalt) {
            printf("KS10: %sRunning.%s\n", "\e[0;32m", "\e[0m");
        }
        lastHalt = halt;
        xTaskDelay(1);
    }
}

//
//! Start Halt Task
//

void startHaltTask(void) {

    static char __align64 taskHaltStack[4096-4];
    portBASE_TYPE status = xTaskCreate(taskHalt, "Halt", taskHaltStack, sizeof(taskHaltStack), 0, taskHaltPriority, NULL);
    if (status != pdPASS) {
        fatal("RTOS: Failed to create Halt task.  Status was %s.\n", taskError(status));
    }

}
