//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! Initialization Task
//!
//! This task initializes the console system.
//!
//! \file
//!      console.cpp
//!
//! \note:
//!      Regarding Errata 34-172-ERR-1-003-004:
//!
//!      The task stacks must be aligned to an 8-byte boundary for printf() to
//!      work properly.  This requires two things:
//!
//!      -#.  The first byte of the stack buffer must reside at an address
//!           that is aligned to an 8 byte boundary; (see __aligned macro).
//!      -#.  The size of the stack (in bytes) must be a number that is
//!           divisible by 4 but not by 8 e.g. 500.
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

#include <ctype.h>

#include "sd.h"
#include "uart.h"
#include "stdio.h"
#include "epi.hpp"
#include "fpga.hpp"
#include "ks10.hpp"
#include "align.hpp"
#include "fatal.hpp"
#include "prompt.hpp"
#include "console.hpp"
#include "commands.hpp"
#include "taskhalt.hpp"
#include "taskutil.hpp"
#include "driverlib/rom.h"
#include "telnetlib/telnet.h"
#include "telnetlib/telnet_task.h"
#include "SafeRTOS/SafeRTOS_API.h"

#define DEBUG_CONSOLE

#ifdef DEBUG_CONSOLE
#define debug(...) printf(__VA_ARGS__)
#else
#define debug(...)
#endif

//
//! Serial Input Queue
//!
//! The interface between the UART input interrupt and the background
//! processing is the Serial Input Queue.
//

xQueueHandle serialQueueHandle;

void createSerialQueue(void) {
    const unsigned long queueLen    = 128;
    const unsigned long queueSize   = sizeof(char);
    const unsigned long queueBufLen = (queueLen * queueSize) + portQUEUE_OVERHEAD_BYTES;
    static signed char serialBuffer[queueBufLen];

    portBASE_TYPE status = xQueueCreate(serialBuffer, queueBufLen, queueLen, queueSize, &serialQueueHandle);
    if (status != pdPASS) {
        fatal("RTOS: Failed to create serial input queue.  Status was %s\n", taskError(status));
    }
}

//
//! Initialize console communcations area
//

void initConsoleCommunications(void) {
    ks10_t::writeMem(ks10_t::switch_addr, 000000000000);        // Initialize switch register
    ks10_t::writeMem(ks10_t::keepa_addr,  000000000000);        // Initialize keep-alive
    ks10_t::writeMem(ks10_t::ctyin_addr,  000000000000);        // Initialize CTY input word
    ks10_t::writeMem(ks10_t::ctyout_addr, 000000000000);        // Initialize CTY output word
    ks10_t::writeMem(ks10_t::klnin_addr,  000000000000);        // Initialize KLINIK input word
    ks10_t::writeMem(ks10_t::klnout_addr, 000000000000);        // Initialize KLINIK output word
    ks10_t::writeMem(ks10_t::rhbase_addr, 000001776700);        // Initialize RH11 base address
    ks10_t::writeMem(ks10_t::rhunit_addr, 000000000000);        // Initialize UNIT number
    ks10_t::writeMem(ks10_t::mtparm_addr, 000000000000);        // Initialize magtape params.
}

//
//! Read characters from the input and create a command line
//!
//! \param buf
//!    command line buffer
//!
//! \param len
//!    maximum length of command line
//!
//! \param taskHandle
//!    reference to the command processing task
//!
//! \note
//!    Strings are converted to upper case for processing.
//

bool commandLine(char *buf, unsigned int len, xTaskHandle &taskHandle) {

    static const char cntl_c    = 0x03;
    static const char cntl_q    = 0x11;
    static const char cntl_s    = 0x13;
    static const char cntl_u    = 0x15;
    static const char cntl_fs   = 0x1c;
    static const char backspace = 0x08;

    unsigned int count = 0;

    for (;;) {
        portBASE_TYPE status;
        extern bool running;
        if (running) {
            xTaskDelay(1);
            continue;
        }
        int ch = getchar();
        switch (ch) {
            case cntl_c:
                status = xTaskDelete(taskHandle);
                if (status != pdPASS) {
                    debug("RTOS: xTaskDelete() failed.  Status was %s\n",
                    taskError(status));
                }
                printf("^C\r\n%s ", PROMPT);
                return false;
            case cntl_q:
                status = xTaskResume(taskHandle);
                if (status != pdPASS) {
                    debug("RTOS: xTaskResume() failed.  Status was %s\n",
                    taskError(status));
                }
                putchar('^');
                putchar('Q');
                break;
            case cntl_s:
                status = xTaskSuspend(taskHandle);
                if (status != pdPASS) {
                    debug("RTOS: xTaskSuspend() failed.  Status was %s\n",
                    taskError(status));
                }
                putchar('^');
                putchar('S');
                break;
            case cntl_u:
                do {
                    putchar(backspace);
                    putchar(' ');
                    putchar(backspace);
                } while (--count != 0);
                break;
            case cntl_fs:
                putchar('^');
                putchar('\\');
                break;
            case backspace:
                if (count > 0) {
                    putchar(backspace);
                    putchar(' ');
                    putchar(backspace);
                    count -= 1;
                }
                break;
            case '\r':
                buf[count++] = 0;
                putchar('\r');
                putchar('\n');
                return true;
            case '\n':
                break;
            case -1:
                xTaskDelay(1);
                break;
            default:
                if (count < len - 1) {
                    buf[count++] = toupper(ch);
                    putchar(ch);
                    lwip_putchar(handle23, ch);
                } else {
                    buf[count++] = 0;
                    putchar('\r');
                    putchar('\n');
                    return true;
                }
                break;
        }
    }
}

//
//! Console Task
//

void taskConsole(void * /*param*/) {

    //
    // Program the FPGA
    //

    bool success = fpgaProg();
    if (!success) {
        fatal("");
    }

    //
    // Initialize the EPI interface to the FPGA
    //

    EPIInitialize();
    printf("CPU : EPI interface initialized.\n");

    //
    // Print the firmware revsion.  If this fails, the FPGA is not programmed
    // or the bus connection is broken.  Either way, there is no reason to
    // continue.
    //

    success = ks10_t::printFirmwareRev();
    if (!success) {
        fatal("FPGA: Unable to communicate with the KS10 FPGA.\n");
    }

    //
    // Test the FPGA register interface
    //

    success = ks10_t::testRegs(false);
    if (!success) {
        fatal("FPGA: Problem accessing KS10 control registers.\n");
    }

    //
    // Start the SD task
    //

    startSdTask();

    //
    // Boot the KS10
    //

    ks10_t::boot();

    //
    // Create the Halt Task
    //

    startHaltTask();

    //
    // Wait for the KS10 to peform the selftest and initialize the ALU.  When
    // the microcode initialization is completed, the KS10 will enter a HALT
    // state.  Wait for that to occur.   Timeout if there is a problem.
    //

    success = ks10_t::waitHalt();
    if (!success) {
        fatal("KS10: Timeout waiting for KS10 to initialize.\n");
    }

    //
    // Create serial input queue
    //

    createSerialQueue();

    //
    // The serial input queue has been created.  Now enable the UART receiver
    // interrupts.  The interrupt will begin queuing characters to this task.
    //

    enableUARTIntr();
    
    //
    // Initialize the Console Communications memory area
    //

    initConsoleCommunications();
    
    //
    // Process commands
    //
    // The command processing is implemented as a task so that it can be:
    // - suspended with a ^S keystoke
    // - resumed with a ^Q keystroke
    // - deleted with a ^C keystroke
    //
    // Note: commandLine() blocks until an newline character is received
    //

    printf(PROMPT);
    xTaskHandle taskCommandHandle;
    char lineBuffer[128];

    for (;;) {
        if (commandLine(lineBuffer, sizeof(lineBuffer), taskCommandHandle)) {
            startCommandTask(lineBuffer, taskCommandHandle);
        }
    }
}

//
//! Start the console task
//

void startConsoleTask(void) {
    static char __align64 stack[4096-4];
    portBASE_TYPE status = xTaskCreate(taskConsole, "console", stack, sizeof(stack), 0, taskConsolePriority, NULL);
    if (status != pdPASS) {
        fatal("RTOS: Failed to create console task.  Status was %s.\n", taskError(status));
    }
}

//
// This function starts the RTOS scheduler
//

void startConsole(void) {

    //
    // RTOS Initialization Parameters
    //

    extern unsigned long _stackend;
    static const xPORT_INIT_PARAMETERS initParams = {
        8000000,                        // System clock rate
        1000 / portTICK_RATE_MS,        // Scheduler tick rate
        taskDeleteHook,                 // Task delete hook
        taskErrorHook,                  // Error hook
        taskIdleHook,                   // Idle hook
        &_stackend,                     // System stack location
        1024,                           // System stack size
        0                               // Location of vectors
    };

    //
    // Initialize the scheduler.
    //

    static char __align64 idleTaskStack[512-4];
    vTaskInitializeScheduler(idleTaskStack, sizeof(idleTaskStack), 0, &initParams);

    //
    // Start the telnet task
    //

    startTelnetTask();

    //
    // Start the console task
    //

    startConsoleTask();

    //
    // Start the scheduler.  This should not return.
    //

    portBASE_TYPE status = xTaskStartScheduler(pdTRUE);
    if (status != pdPASS) {
        fatal("RTOS: Scheduler returned.  Status was %s.\n", taskError(status));
    }
}
