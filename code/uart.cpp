/*!
********************************************************************************
**
** KS10 Console Microcontroller
**
** \brief
**      UART Object
**
** \details
**      This object abstracts the UART.
**
** \file
**      uart.cpp
**
** \author
**      Rob Doyle - doyle (at) cox (dot) net
**
********************************************************************************
**
** Copyright (C) 2013 Rob Doyle
**
** This program is free software; you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation; either version 2 of the License, or
** (at your option) any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program; if not, write to the Free Software
** Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
**
********************************************************************************
*/

#include <stdint.h>
#include "uart.h"
#include "stdio.h"
#include "driverlib/rom.h"
#include "driverlib/sysctl.h"
#include "driverlib/gpio.h"
#include "driverlib/uart.h"
#include "driverlib/inc/hw_memmap.h"

static const uint32_t baudrate = 9600;

#ifdef CONFIG_KS10
#define SYSCTL_XTAL        SYSCTL_XTAL_8MHZ
#define GPIO_PORT_BASE     GPIO_PORTD_BASE
#define SYSCTL_PERIPH_UART SYSCTL_PERIPH_UART1
#define UART_BASE          UART1_BASE
#else
#define SYSCTL_XTAL        SYSCTL_XTAL_16MHZ
#define GPIO_PORT_BASE     GPIO_PORTA_BASE
#define SYSCTL_PERIPH_UART SYSCTL_PERIPH_UART0
#define UART_BASE          UART0_BASE
#endif

void initializeUART(void) __attribute__((constructor(101)));

//
//! \brief
//!     Initialize the UART
//!
//! \details
//!     This function is executed like a constructor so that the UART is
//!     initialize before main() is called.   This guarantees that this
//!     function is executed before all others since those functions may
//!     call UART or STDIO functions.
//!
//! \returns
//!     Nothing
//!

void initializeUART(void) {
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOA);
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOD);
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_UART);
    ROM_SysCtlClockSet(SYSCTL_SYSDIV_1 | SYSCTL_USE_OSC | SYSCTL_OSC_MAIN | SYSCTL_XTAL);
    ROM_GPIOPinTypeUART(GPIO_PORT_BASE, GPIO_PIN_0 | GPIO_PIN_1);
    ROM_UARTConfigSetExpClk(UART_BASE, SysCtlClockGet(), 9600, UART_CONFIG_PAR_NONE | UART_CONFIG_STOP_ONE | UART_CONFIG_WLEN_8);
    ROM_UARTEnable(UART_BASE);
    puts("\n0, ");
}

//!
//! \brief
//!     This function returns the state of the UART Receiver.
//!
//! \returns
//!     True if the UART receiver is empty.  False otherwise.
//!

bool rxEmpty(void) {
    return !ROM_UARTCharsAvail(UART_BASE);
}

//!
//! \brief
//!     This function gets a character from the UART receiver.
//!
//! \returns
//!     Character read from UART receiver.
//!

char getUART(void) {
    return ROM_UARTCharGet(UART_BASE) & 0x7f;
}

//!
//! \brief
//!     This function returns the state of the UART Transmitter.
//!
//! \returns
//!     Returns true if the UART transmitter is full.  False otherwise.
//!

#warning FIXME: This should be rom-able
bool txFull(void) {
    return UARTBusy(UART_BASE);
}

//!
//! \brief
//!     This function outputs a character to the UART transmitter.
//!
//! \param ch
//!     Character to output to UART transmitter.
//!
//! \returns
//!     None.
//!

void putUART(char ch) {
    ROM_UARTCharPut(UART_BASE, ch);
}
