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
#include "epi.hpp"
#include "fpga.hpp"
#include "stdio.h"
#include "ks10.hpp"
#include "uart.h"
#include "commands.hpp"
#include "console.hpp"
#include "driverlib/rom.h"
#include "telnetlib/telnet.h"
#include "telnetlib/telnet_task.h"
#include "SafeRTOS/SafeRTOS_API.h"

//
// The task stacks must be aligned to 8 byte boundary.
// See Errata 34-172-ERR-1-003-004
//

#define __aligned __attribute__((aligned(8)))

//
// Fatal error macro
//

#define fatal(...)              \
    do {                        \
        ROM_IntMasterDisable(); \
        printf( __VA_ARGS__);   \
        for (;;) {              \
            ;                   \
        }                       \
    } while (1)

//
// Debug macro
//

#define DEBUG

#ifdef DEBUG
#define debug(...) printf(__VA_ARGS__)
#else
#define debug(...)
#endif

//
// Prompt string
//

const char * prompt = "KS10>";

//
// Serial Queue information
//

xQueueHandle serialQueueHandle;

//
// Task priorities
//

enum {
    taskIdlePriority    = 0,    // lowest priority
    taskCommandPriority = 1,
    taskConsolePriority = 2,
    taskHaltPriority    = 3,
    taskSDPriority      = 4,    // highest priority
};

//
// Lookup error message
//

const char *prerror(portBASE_TYPE error) {
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
//
// ! Initialize the Communications block.
//

static void initCOMBLK(void) {
    ks10_t::writeMem(000030, 0000000000000);	// Initialize switch register
    ks10_t::writeMem(000031, 0000000000000);	// Initialize keep-alive
    ks10_t::writeMem(000032, 0000000000000);	// Initialize CTY input word
    ks10_t::writeMem(000033, 0000000000000);	// Initialize CTY output word
    ks10_t::writeMem(000034, 0000000000000);	// Initialize KTY input word
    ks10_t::writeMem(000035, 0000000000000);	// Initialize KTY output word
    ks10_t::writeMem(000036, 0000000000000);	// Initialize RH11 base address
    ks10_t::writeMem(000037, 0000000000000);	// Initialize UNIT number
    ks10_t::writeMem(000040, 0000000000000);	// Initialize magtape params.
}


//
//! Read characters from the input and create a command line
//!
//! \param buf
//!    command line buffer
//!
//! \param len
//!    maximum lenght of command line
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
        char ch = getchar();
        switch (ch) {
            case cntl_c:
                status = xTaskDelete(taskHandle);
                if (status != pdPASS) {
                    //debug("xTaskDelete() failed.  Status was %s\n", prerror(status));
                }
                printf("^C\r\n%s ", prompt);
                return false;
            case cntl_q:
                status = xTaskResume(taskHandle);
                if (status != pdPASS) {
                    //debug("xTaskResume() failed.  Status was %s\n", prerror(status));
                }
                putchar('^');
                putchar('Q');
                break;
            case cntl_s:
                status = xTaskSuspend(taskHandle);
                if (status != pdPASS) {
                    //debug("xTaskSuspend() failed.  Status was %s\n", prerror(status));
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
// FIXME
//

void inline yield(void) {
    xTaskDelay(1);
}

//
// Task Error Hook
//

static void taskErrorHook(xTaskHandle handle, signed portCHAR *name,
                          portBASE_TYPE error) {

    fatal("\nFatal SafeRTOS Error: task=\"%s\": %s (handle = 0x%08lx)\n",
          name, prerror(error), (unsigned long)handle);
}

//
// Task Delete Hook
//

static void taskDeleteHook(xTaskHandle /* xTaskToDelete */) {
    ;
}

//
// Idle Task
//

static void taskIdleHook(void) {
    ;
}

//
// That halt task watches the KS10 for transtions of the halt status.
//

static void taskHalt(void * /*param*/) {
    bool lastHalt = false;
    for (;;) {
#warning FIXME Stubbed code
#if 0
        bool halt = ks10_t::halt();
        if (halt && !lastHalt) {
            printf("%s Halted.\n", prompt);
            printHaltStatus();
        } else if (!halt && lastHalt) {
            printf("Running.\n");
        }
        lastHalt = halt;
#endif
        yield();
    }
}

//
//! Command processing task
//!
//! \param
//!    param - pointer to command line buffer
//!
//! \note
//!    This is implemented as a task so that it can be:
//!    - suspended with a ^S keystoke
//!    - resumed with a ^Q keystroke
//!    - deleted with a ^C keystroke
//!
//! \note
//!    When the command finishes executing, the task deletes itself.
//!

static void taskCommand(void * param) {
    char * buf = reinterpret_cast<char *>(param);
    parseCommand(buf);
    printf("%s ", prompt);
    xTaskDelete(NULL);
}

//
// Console Task
//

void taskConsole(void * /*param*/) {
    portBASE_TYPE status;

    //
    // Program the FPGA
    //

    if (!fpgaProg()) {
        fatal("");
    }

    //
    // Initialize the EPI interface to the FPGA
    //

    EPIInitialize();
    printf("%s EPI interface initialized.\n", prompt);

    //
    //  Read the FPGA firmware revision register.  The FPGA should respond with
    //  "REVxx.yy" where xx is the major revision and yy is the minor revision.
    //
    //  If this fails, the FPGA is not programmed or the bus connection is
    //  broken.  Either way, there is no reason to continue.
    //

    const char *buf = ks10_t::getFirmwareRev();
    if ((buf[0] == 'R') && (buf[1] == 'E') &&
        (buf[2] == 'V') && (buf[5] == 0xae)) {
        printf("%s FPGA firmware is %c%c%c %c%c%c%c%c\n", prompt,
               buf[0] & 0x7f, buf[1] & 0x7f, buf[2] & 0x7f, buf[3] & 0x7f,
               buf[4] & 0x7f, buf[5] & 0x7f, buf[6] & 0x7f, buf[7] & 0x7f);
    } else {
        fatal("%s Unable to communicate with the KS10 FPGA.\n", prompt);
    }

    //
    // Create the SD task
    //  This task watches for SD Card insertions and removals.   When an
    //  SD Card is inserted, the this task attempts to initialize the SD
    //  Card.   If the card is successfully initialized, this taks also
    //  attempts to mount the FAT filesystem on top of the SD Card.
    //

    static char __aligned taskSDStack[5120-4];
    status = xTaskCreate(sdTask, "SD", taskSDStack, sizeof(taskSDStack), 0,
                         taskSDPriority, NULL);
    if (status != pdPASS) {
        fatal("%s Failed to create %s task.  Status was %s.\n", prompt, "SD",
              prerror(status));
    }

    //
    // Dump the RH11 Debug Register
    //

    printRH11Debug();

    //
    // Test the register interface
    //

    bool success = ks10_t::testRegs();
    if (!success) {
        fatal("%s Problem accessing KS10 control registers.\n", prompt);
    }

    //
    // Unreset the CPU
    //

    if (!ks10_t::cpuReset()) {
        fatal("%s KS10 should be reset.\n", prompt);
    }

    if (ks10_t::halt()) {
        fatal("%s KS10 should not be halted.\n", prompt);
    }

    if (ks10_t::run()) {
        fatal("%s KS10 should not be running.\n", prompt);
    }

    ks10_t::cpuReset(false);

    if (ks10_t::cpuReset()) {
        fatal("%s KS10 should be unreset.\n", prompt);
    }

    if (ks10_t::halt()) {
        fatal("%s KS10 should not be halted.\n", prompt);
    }

    if (ks10_t::run()) {
        fatal("%s KS10 should not be running.\n", prompt);
    }

    static char __aligned taskHaltStack[4096-4];
    status = xTaskCreate(taskHalt, "Halt", taskHaltStack, sizeof(taskHaltStack),
                         0, taskHaltPriority, NULL);
    if (status != pdPASS) {
        fatal("%s, Failed to create %s task.  Status was %s.\n", prompt,
              "Halt", prerror(status));
    }

    //
    // Wait for the KS10 to peform a selftest and initialize the ALU.  When
    // the microcode initialization is completed, the KS10 will enter a HALT
    // state.  Wait for that to occur.   Timeout if there is a problem.
    //

    success = ks10_t::waitHalt();
    if (!success) {
        fatal("%s Timeout waiting for KS10 to initialize.\n", prompt);
    }

    //
    // Create serial input queue
    //

    const unsigned long queueLen    = 128;
    const unsigned long queueSize   = sizeof(char);
    const unsigned long queueBufLen = (queueLen * queueSize) + portQUEUE_OVERHEAD_BYTES;
    static char serialBuffer[queueBufLen];
    status = xQueueCreate(serialBuffer, queueBufLen, queueLen, queueSize,
                          &serialQueueHandle);
    if (status != pdPASS) {
        fatal("%s Failed to create serial input queue.  Status was %s\n",
              prerror(status));
    }

    //
    // The serial input queue has been created.  Now enable the UART receiver
    // interrupts.  The interrupt will begin queuing characters to this task.
    //

    enableUARTIntr();

    //
    // Process commands
    //

    printf("%s ", prompt);
    xTaskHandle taskCommandHandle;
    const unsigned int linBufLen = 128;
    char linBuf[linBufLen];

    for (;;) {

        //
        // Gather up the command line from characters.
        // Note: commandLine() blocks until an newline character is received
        //

        if (commandLine(linBuf, linBufLen, taskCommandHandle)) {

            //
            // Create command processing task
            //

            static char __aligned taskCommandStack[4096-4];
            status = xTaskCreate(taskCommand, "Command", taskCommandStack,
                                 sizeof(taskCommandStack), linBuf,
                                 taskCommandPriority, &taskCommandHandle);
            if (status != pdPASS) {
                debug("%s Failed to create %s task.  Status was %s.\n",
                      "Command", prerror(status));
            }
        }
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

    static char __aligned idleTaskStack[512-4];
    vTaskInitializeScheduler(idleTaskStack, sizeof(idleTaskStack), 0,
                             &initParams);

#if 1
    if (telnetTaskInit() == 0) {
        printf("%s Successfully started telnet task.\n", prompt);
    } else {
        fatal("%s Failed to start telnet task.\n", prompt);
    }
#endif

    //
    // Start the console task
    //

    portBASE_TYPE status;
    static char __aligned taskConsoleStack[4096-4];
    status = xTaskCreate(taskConsole, "console", taskConsoleStack,
                         sizeof(taskConsoleStack), 0, taskConsolePriority,
                         NULL);
    if (status != pdPASS) {
        fatal("%s Failed to create %s task.  Status was %s.\n", prompt,
              "console", prerror(status));
    }

    //
    // Start the scheduler.  This should not return.
    //

    status = xTaskStartScheduler(pdTRUE);
    if (status != pdPASS) {
        fatal("%s Scheduler returned.  Status was %s.\n", prompt,
              prerror(status));
    }
}
