//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! UART Object
//!
//! \file
//!      uart.cpp
//!
//! \author
//!      Rob Doyle - doyle (at) cox (dot) net
//
//******************************************************************************
//
// Copyright (C) 2013 Rob Doyle
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
#include "driverlib/rom.h"
#include "driverlib/sysctl.h"
#include "driverlib/gpio.h"
#include "driverlib/uart.h"
#include "driverlib/inc/hw_memmap.h"
#include "driverlib/inc/hw_ints.h"

#ifdef CONFIG_KS10
#define SYSCTL_XTAL        SYSCTL_XTAL_8MHZ
#define GPIO_PORT_BASE     GPIO_PORTD_BASE
#define SYSCTL_PERIPH_UART SYSCTL_PERIPH_UART1
#define UART_BASE          UART1_BASE
#define UARTinterrupt      vectUART1
#define INT_UART           INT_UART1
#else
#define SYSCTL_XTAL        SYSCTL_XTAL_16MHZ
#define GPIO_PORT_BASE     GPIO_PORTA_BASE
#define SYSCTL_PERIPH_UART SYSCTL_PERIPH_UART0
#define UART_BASE          UART0_BASE
#define UARTinterrupt      vectUART0
#define INT_UART           INT_UART0
#endif

static const uint32_t baudrate = 9600;
static char rxbuf[128];
static volatile unsigned int index = 0;

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
                       SYSCTL_XTAL);

    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOA);
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOD);
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_UART);

    ROM_GPIOPinTypeUART(GPIO_PORT_BASE, GPIO_PIN_0 | GPIO_PIN_1);

    ROM_UARTConfigSetExpClk(UART_BASE, ROM_SysCtlClockGet(), 9600,
                            UART_CONFIG_PAR_NONE | UART_CONFIG_STOP_ONE |
                            UART_CONFIG_WLEN_8);

    ROM_IntEnable(INT_UART);
    ROM_UARTIntEnable(UART_BASE, UART_INT_RX | UART_INT_RT);
    ROM_UARTEnable(UART_BASE);
    putUART('\r');
    putUART('\n');
    putUART('0');
    putUART(',');
    putUART(' ');
}

//
//! This function returns the state of the UART Transmitter.
//!
//! \returns
//!     Returns true if the UART transmitter is full.  False otherwise.
//

#warning FIXME: This should be rom-able
bool txFull(void) {
    return UARTBusy(UART_BASE);
}

//
//! This function outputs a character to the UART transmitter.
//!
//! \param ch
//!     Character to output to UART transmitter.
//

void putUART(char ch) {
    ROM_UARTCharPut(UART_BASE, ch);
}

//
//! Check the state of the RX Buffer
//!
//! \returns
//!     True if the buffer is empty, false otherwise.
//

bool rxEmpty(void) {
    return index == 0;
}

//
//! This function gets a character from the UART receiver.
//!
//! \returns
//!     Character read from UART receiver.
//

char getUART(void) {
    while (index == 0) {
        ;
    }
    index = 0;
    return rxbuf[0];
}

//
//! Get the command line from the line buffer
//!
//! \param [out]
//!    buf address of a pointer to the line buffer.
//!
//! \returns
//!    true if a newline has been received, false otherwise.
//!

bool getLine(char **buf) {
    if (rxbuf[index] == '\n') {
        *buf = rxbuf;
        rxbuf[index] = 0;
        index = 0;
        return true;
    }
    return false;
}

//
//! UART Interrupt
//!
//! This function is an interrupt that buffers character that
//! have been received by the UART
//

void UARTinterrupt(void) {

    static const char cntl_c  = 0x03;
    static const char cntl_q  = 0x11;
    static const char cntl_s  = 0x13;
    static const char cntl_u  = 0x15;
    static const char cntl_fs = 0x1c;
    static const char backspace = 0x7f;

    ROM_UARTIntClear(UART_BASE, 0xffffffff);
    uint8_t ch = ROM_UARTCharGet(UART_BASE) & 0x7f;

    switch(ch) {
        case cntl_c:
            putUART('^');
            putUART('C');
            break;
        case cntl_q:
            putUART('^');
            putUART('Q');
            break;
        case cntl_s:
            putUART('^');
            putUART('S');
            break;
        case cntl_u:
            for (unsigned  int i = 0; i < index; i++) {
                putUART(0x7f);
            }
            index = 0;
            break;
        case cntl_fs:
            putUART('^');
            putUART('\\');
            break;
        case backspace:
            if (index > 0) {
                index -= 1;
                putUART(ch);
            }
            break;
        case '\r':
            rxbuf[index] = '\n';
            putUART('\r');
            putUART('\n');
            break;
        case '\n':
            break;
        default:
            if (index < sizeof(rxbuf)-1) {
                rxbuf[index++] = ch;
                putUART(ch);
            } else {
                rxbuf[index] = '\n';
                putUART('\n');
            }
            break;
    }
}
