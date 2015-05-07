//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! UART Object
//!
//! This object provide a UART abstraction.
//!
//! \file
//!    uart.cpp
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

#include <stdint.h>

#include "uart.h"
#include "stdio.h"
#include "console.hpp"
#include "driverlib/rom.h"
#include "driverlib/sysctl.h"
#include "driverlib/gpio.h"
#include "driverlib/uart.h"
#include "driverlib/inc/hw_memmap.h"
#include "driverlib/inc/hw_ints.h"
#include "SafeRTOS/SafeRTOS_API.h"

//
// Static variables
//

static const uint32_t baudrate = 9600;

void initializeUART(void) __attribute__((constructor(101)));

//
//! Initialize the UART
//!
//! This function is executed like a constructor so that the UART is
//! initialize before main() is called.  This guarantees that this function
//! is executed before all others.  This allows all functions called by main()
//! to use UART or STDIO functions.
//

void initializeUART(void) {

    ROM_SysCtlClockSet(SYSCTL_SYSDIV_1 | SYSCTL_USE_OSC | SYSCTL_OSC_MAIN |
                       SYSCTL_XTAL_8MHZ);

    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOA);
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOD);
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOJ);
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_UART1);

    ROM_GPIOPinTypeUART(GPIO_PORTD_BASE, GPIO_PIN_0 | GPIO_PIN_1);
    ROM_GPIOPinConfigure(GPIO_PD0_U1RX);
    ROM_GPIOPinConfigure(GPIO_PD1_U1TX);
    ROM_UARTConfigSetExpClk(UART1_BASE, ROM_SysCtlClockGet(), 9600,
                            UART_CONFIG_PAR_NONE | UART_CONFIG_STOP_ONE |
                            UART_CONFIG_WLEN_8);
}

//
//! Enable UART Interrupts
//!
//! This function enables the UART interrupts.  Interrupts should be enabled
//! after the serial interface queue has been created.
//

void enableUARTIntr(void) {
    ROM_IntEnable(INT_UART1);
    ROM_UARTIntEnable(UART1_BASE, UART_INT_RX | UART_INT_RT);
    ROM_UARTEnable(UART1_BASE);
}

//
//! This function returns the state of the UART Transmitter.
//!
//! \returns
//!     Returns true if the UART transmitter is full.  False otherwise.
//

bool txFull(void) {
    return ROM_UARTBusy(UART1_BASE);
}

//
//! This function outputs a character to the UART transmitter.
//!
//! \param ch
//!     Character to output to UART transmitter.
//

void putUART(char ch) {
    ROM_UARTCharPut(UART1_BASE, ch);
}

//
//! This function gets a character from the UART receiver queue.
//!
//! \returns
//!     Character read from UART receiver.
//

char getUART(void) {
    for (;;) {
        char ch;
        portBASE_TYPE status = xQueueReceive(serialQueueHandle, &ch, 0);
        switch (status) {
            case pdPASS:
                return ch;
            case errQUEUE_EMPTY:
                xTaskDelay(1);
                break;
            default:
                return 0;
        }
    }
}

//
//! This function queues a character to a handler task.
//

void uart1IntHandler(void) {

    char ch = ROM_UARTCharGet(UART1_BASE) & 0x7f;

    portBASE_TYPE taskWoken;
    portBASE_TYPE status = xQueueSendFromISR(serialQueueHandle, &ch, &taskWoken);
    if (status != pdPASS) {
        printf("queue(): Failed to send from ISR.  Status was %ld\n", status);
    }

    ROM_UARTIntClear(UART1_BASE, 0xffffffff);

    taskYIELD_FROM_ISR(taskWoken);
}
