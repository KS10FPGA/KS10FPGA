/*!
********************************************************************************
**
** KS10 Console Microcontroller
**
** \brief
**     FPGA Interface Object
**
** \details
**     This object provides the interfaces that are required to load/program the
**     FPGA.
**  
**     The FPGA provides 3 interface signals to the console microcontroller:
**     #.  PROG# output.  When asserted (low), this signal causes the FPGA to
**         begin to load firmware from the serial flash memory device.
**     #.  INIT# input.  This signal is asserted (low) if a CRC error occurs
**         when configuring the FPGA.
**     #.  DONE input.  This signal is asserted (high) when the FPGA has been
**         configured successfully.
** \file
**     fpga.cpp
**
** \author
**     Rob Doyle - doyle (at) cox (dot) net
**
********************************************************************************
*/
/* Copyright (C) 2013 Rob Doyle
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

#include "fpga.h"
#include "stdio.h"
#include "driverlib/rom.h"
#include "driverlib/inc/hw_types.h"
#include "driverlib/inc/hw_memmap.h"
#include "driverlib/gpio.h"
#include "driverlib/sysctl.h"

#define GPIO_PORT_BASE GPIO_PORTB_BASE
#define GPIO_PIN_PROG  GPIO_PIN_0
#define GPIO_PIN_INIT  GPIO_PIN_1
#define GPIO_PIN_DONE  GPIO_PIN_3
   
//!
//! \brief
//!     Program the FPGA with firmware.
//!
//! \returns
//!     Nothing.
//!
//! \note
//!     PROG# is on PB0, 
//!     INIT# is on PB1, and
//!     DONE is on PB3.
//!  

void programFPGA(void) {

    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOB);
    ROM_GPIOPinTypeGPIOOutput(GPIO_PORT_BASE, GPIO_PIN_PROG);
    ROM_GPIOPinTypeGPIOInput(GPIO_PORT_BASE, GPIO_PIN_INIT);
    ROM_GPIOPinTypeGPIOInput(GPIO_PORT_BASE, GPIO_PIN_DONE);

    //
    // Assert PROG# momentarily
    //

    printf("KS10> Programming FPGA with firmware\n");
    ROM_GPIOPinWrite(GPIO_PORT_BASE, GPIO_PIN_PROG, 0);
    SysCtlDelay(10);
    ROM_GPIOPinWrite(GPIO_PORT_BASE, GPIO_PIN_PROG, GPIO_PIN_PROG);
    SysCtlDelay(10);
    
    //
    // Verify DONE is negated.
    //
    
    if (ROM_GPIOPinRead(GPIO_PORT_BASE, GPIO_PIN_DONE) != 0) {
        printf("KS10> FPGA Programming Error.  FPGA Done should be negated.\n");
        return;
    }
        
    //
    // Wait for DONE to be asserted.
    //
    
    unsigned int delay = 0;
    do {
        if (ROM_GPIOPinRead(GPIO_PORT_BASE, GPIO_PIN_INIT) == 0) {
            printf("KS10> FPGA Programming Error.  CRC Failure.\n");
            return;
        }
        if (++delay == 1000000) {
            printf("KS10> FPGA Programming Error.  Timed Out waiting for DONE.\n");
            return;
        }
        SysCtlDelay(10);
    } while (ROM_GPIOPinRead(GPIO_PORT_BASE, GPIO_PIN_DONE) == 0);

    //
    // FPGA was successfully programmed.
    //
    
    printf("KS10> FPGA Programming Successfully.\n");
}
