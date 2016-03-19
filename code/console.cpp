//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    Console Interface
//!
//! \details
//!    This task implements the console system.
//!
//! \file
//!    console.cpp
//!
//! \note:
//!    Regarding Errata 34-172-ERR-1-003-004:
//!
//!    The task stacks must be aligned to an 8-byte boundary for printf() to
//!    work properly.  This requires two things:
//!
//!    -#.  The first byte of the stack buffer must reside at an address
//!         that is aligned to an 8 byte boundary; (see __align64 macro).
//!    -#.  The size of the stack (in bytes) must be a number that is
//!         divisible by 4 but not by 8 e.g. 500.
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

#include <ctype.h>

#include "sd.h"
#include "uart.h"
#include "stdio.h"
#include "epi.hpp"
#include "ks10.hpp"
#include "align.hpp"
#include "fatal.hpp"
#include "vt100.hpp"
#include "prompt.hpp"
#include "console.hpp"
#include "commands.hpp"
#include "taskutil.hpp"
#include "driverlib/rom.h"
#include "cmdlinelib/cmdline.hpp"
#include "telnetlib/telnet_task.hpp"
#include "SafeRTOS/SafeRTOS_API.h"

//!
//! \brief
//!    Serial Input Queue
//!
//! \details
//!    The Serial Input Queue is the interface between the UART input interrupt
//!    and the Console Task
//!

xQueueHandle serialQueueHandle;

//!
//! \brief
//!    Create the serial input queue
//!

void createSerialQueue(void) {
    const unsigned long queueLen    = 128;
    const unsigned long queueSize   = sizeof(char);
    const unsigned long queueBufLen = (queueLen * queueSize) + portQUEUE_OVERHEAD_BYTES;
    static signed char serialBuffer[queueBufLen];

    portBASE_TYPE status = xQueueCreate(serialBuffer, queueBufLen, queueLen, queueSize, &serialQueueHandle);
    if (status != pdPASS) {
        printf("RTOS: Failed to create serial input queue.  Status was %s\n", taskError(status));
        fatal();
    }
}

//!
//! \brief
//!    This interrupt is triggered by the KS10 when it wants to receive a
//!    character or send a character.
//!

void consInterrupt(void) {
    int ch = ks10_t::getchar();
    if (ch != -1) {
        printf("%c", ch);
    }
}

//!
//! \brief
//!    This interrupt is triggered when KS10 changes run/halt state.
//!

void haltInterrupt(void) {
    if (ks10_t::halt()) {
        printf("KS10: %sHalted.%s\n", vt100fg_red, vt100at_rst);
        printHaltStatus();
    } else {
        printf("KS10: %sRunning.%s\n", vt100fg_grn, vt100at_rst);
    }
}

//!
//! \brief
//!    Console Task
//!

void taskConsole(void* arg) {

    debug_t *debug = static_cast<debug_t *>(arg);

    //
    // Start the SD task
    //

    startSdTask(debug);

    //
    // Initialize KS10 object
    //

    ks10_t ks10;

    //
    // Program the firmware
    //

#if 1

    ks10.programFirmware(debug->debugKS10);

#else

    ks10.programFirmware(debug->debugKS10, "firmware.bin");

#endif

    //
    // Check the firmware revsion.
    //

    ks10.checkFirmware(debug->debugKS10);

    //
    // Test the Console Interface Registers
    //

    ks10.testRegs(debug->debugKS10);

    //
    // Enable KS10 Interrupts
    //

    ks10.enableInterrupts(consInterrupt, haltInterrupt);

    //
    // Boot the KS10
    //

    ks10.boot(debug->debugKS10);

    //
    // Wait for the KS10 to peform the selftest and initialize the ALU.  When
    // the microcode initialization is completed, the KS10 will enter a HALT
    // state.
    //

    ks10.waitHalt(debug->debugKS10);

    //
    // Create serial input queue.  This is the interface between the UART
    // interrupt and the RTOS.
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

    ks10.writeMem(ks10_t::switch_addr, 000000000000);           // Initialize switch register
    ks10.writeMem(ks10_t::kasw_addr,   003740000000);           // Initialize keep-alive and status word (KASW)
    ks10.writeMem(ks10_t::ctyin_addr,  000000000000);           // Initialize CTY input word
    ks10.writeMem(ks10_t::ctyout_addr, 000000000000);           // Initialize CTY output word
    ks10.writeMem(ks10_t::klnin_addr,  000000000000);           // Initialize KLINIK input word
    ks10.writeMem(ks10_t::klnout_addr, 000000000000);           // Initialize KLINIK output word
    ks10.writeMem(ks10_t::rhbase_addr, 000001776700);           // Initialize RH11 base address
    ks10.writeMem(ks10_t::rhunit_addr, 000000000000);           // Initialize UNIT number
    ks10.writeMem(ks10_t::mtparm_addr, 000000000000);           // Initialize magtape params.

    //
    // Initialize contol registers
    //

    ks10.writeDZCCR(0x000000000000ff00ULL);                     // Initialize the DZ11 Console Control Register
    ks10.writeRHCCR(0x00000000070707f8ULL);                     // Initialize the RH11 Console Control Registrer
    ks10.writeDBAR (0x0000000000000000ULL);                     // Initialize the Debug Breakpoint Address Register
    ks10.writeDBAR (0x0000000000000000ULL);                     // Initialize the Debug Breakpoint Address Register
    ks10.writeDBMR (0x0000000000000000ULL);                     // Initialize the Debug Breakpoint Mask Register

    //
    // Check RH11 Initialization Status
    //

    uint64_t rh11debug = ks10.getRH11debug();
    if (rh11debug >> 56 == ks10_t::rh11IDLE) {
        printf("KS10: RH11 successfully initialized SDHC media.\n");
    } else if (rh11debug >> 40 == 0x7e0c80) {
        printf("KS10: %sRH11 cannot utilize SDSC media.  Use SDHC media.%s\n", vt100fg_red, vt100at_rst);
    } else {
        printf("KS10: %sRH11 failed to initialize SDHC media.%s\n", vt100fg_red, vt100at_rst);
        printRH11Debug();
    }

    //
    // Process commands
    //
    // The command processing is implemented as a task so that it can be:
    // - suspended with a ^S keystoke
    // - resumed with a ^Q keystroke
    // - deleted with a ^C keystroke
    //

    printf(PROMPT);
    xTaskHandle taskHandle = NULL;
    cmdline_t cmdline(taskHandle, startCommandTask);

    for (;;) {
        extern bool running;
        if (running) {
            xTaskDelay(1);
        } else {
            int ch = getchar();
            switch (ch) {
                case -1:
                    xTaskDelay(1);
                    break;
                case 0x03: // ^C
                    xTaskDelete(taskHandle);
                    printf("^C\r\n%s", PROMPT);
                    cmdline.process(ch);
                    break;
                case 0x11: // ^Q
                    xTaskResume(taskHandle);
                    printf("^Q");
                    cmdline.process(ch);
                    break;
                case 0x13: // ^S
                    xTaskSuspend(taskHandle);
                    printf("^S");
                    cmdline.process(ch);
                    break;
                default:
                    cmdline.process(ch);
                    break;
            }
        }
    }
}

//!
//! \brief
//!    Start the console task
//!
//! \param debug -
//!    Enables debug messages
//!

void startConsoleTask(debug_t *debug) {

    static signed char __align64 stack[4096-4];
    portBASE_TYPE status = xTaskCreate(taskConsole, reinterpret_cast<const signed char *>("console"),
                                       stack, sizeof(stack), debug, taskConsolePriority, NULL);
    if (status != pdPASS) {
        printf("RTOS: Failed to create console task.  Status was %s.\n", taskError(status));
        fatal();
    }
}

//!
//! \brief
//!    This function starts the RTOS scheduler
//!
//! \param debug -
//!    Debugging parameters
//!

void startConsole(debug_t *debug) {

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

    static signed char __align64 idleTaskStack[512-4];
    vTaskInitializeScheduler(idleTaskStack, sizeof(idleTaskStack), 0, &initParams);

    //
    // Start the telnet task
    //

    startTelnetTask(debug);

    //
    // Start the console task
    //

    startConsoleTask(debug);

    //
    // Start the scheduler.  This should not return.
    //

    portBASE_TYPE status = xTaskStartScheduler(pdTRUE);
    printf("RTOS: Scheduler returned.  Status was %s.\n", taskError(status));
    fatal();
}
