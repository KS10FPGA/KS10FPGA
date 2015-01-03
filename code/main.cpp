//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! Main Program
//!
//! This is the console program entry point.  This function does some simple
//! hardware checks and then starts the console processing.
//!
//! \file
//!    main.cpp
//!
//! \author
//!    Rob Doyle - doyle (at) cox (dot) net
//
//******************************************************************************
//
// Copyright (C) 2014 Rob Doyle
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
#include "console.hpp"
#include "driverlib/rom.h"
#include "driverlib/inc/hw_types.h"
#include "driverlib/inc/hw_memmap.h"
#include "driverlib/inc/hw_sysctl.h"

//
// Main Program
//

int main(void) {

    //
    // Enable Interrupts
    //

    __asm volatile ("cpsie i");

    //
    // Set the clocking to run at 80 MHz from the PLL.
    //

    //ROM_SysCtlClockSet(SYSCTL_SYSDIV_2_5 | SYSCTL_USE_PLL | SYSCTL_XTAL_8MHZ | SYSCTL_OSC_MAIN);

    printf("\x1b[H\x1b[2J");
    printf("KS10> Console booted...\n");
    printf("KS10> CPU device identifier is 0x%08lx.\n", HWREG(SYSCTL_DID0));

    //
    // Device Rev C3 is required for the ROM functions.
    //

    if (!REVISION_IS_C3) {
        printf("KS10> Unsupported processor revision.\n");
        for (;;) {
            ;
        }
    }

    //
    // Start Console.  This function should never return here.
    //

    startConsole();

    return 0;
}
