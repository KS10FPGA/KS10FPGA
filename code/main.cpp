//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    Main Program
//!
//! \details
//!    This is the console program entry point.  This function does some simple
//!    hardware checks and then starts the console processing.
//!
//! \file
//!    main.cpp
//!
//! \author
//!    Rob Doyle - doyle (at) cox (dot) net
//
//******************************************************************************
//
// Copyright (C) 2013-2016 Rob Doyle
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
#include "console.hpp"
#include "taskutil.hpp"
#include "driverlib/rom.h"
#include "driverlib/gpio.h"
#include "driverlib/sysctl.h"
#include "driverlib/inc/hw_types.h"
#include "driverlib/inc/hw_memmap.h"
#include "driverlib/inc/hw_sysctl.h"

//!
//! Debugging parameters
//!

static param_t param;

//!
//! \brief
//!    Main Program
//!

int main(void) {

    param.debug = false;

    //
    // Enable Interrupts
    //

    __asm volatile ("cpsie i");

    //
    // Set the clocking to run at 80 MHz from the PLL.
    //

#if 0
    ROM_SysCtlClockSet(SYSCTL_SYSDIV_2_5 | SYSCTL_USE_PLL | SYSCTL_XTAL_8MHZ | SYSCTL_OSC_MAIN);
#endif

    //
    // Configure the Ethernet Blinky Lights
    //

    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOF);
    ROM_GPIOPinTypeGPIOOutput(GPIO_PORTF_BASE, GPIO_PIN_2 | GPIO_PIN_3);
    ROM_GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_2 | GPIO_PIN_3, 0);

    //
    // Print startup message
    //

    printf("\x1b[H\x1b[2J");
    printf("CPU : Console alive.\n");
    printf("CPU : Device identifier is 0x%08lx.\n", HWREG(SYSCTL_DID0));

    //
    // Device Rev C3 is required for the ROM functions.
    //

    if (!REVISION_IS_C3) {
        printf("CPU : Unsupported processor revision.\n");
        if (!param.debug) {
            fatal();
        }
    }

    //
    // Start Console.  This function should never return here.
    //

    startConsole(&param);

    return 0;
}
