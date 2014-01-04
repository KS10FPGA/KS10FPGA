//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! External Peripheral Interface (EPI) Object
//!
//! This object abstracts the EPI interface. The console microcontroller
//! interfaces to the KS10 FPGA over the EPI interface.
//!
//! \file
//!    epi.cpp
//!
//! \author
//!    Rob Doyle - doyle (at) cox (dot) net
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

#include "epi.h"
#include "driverlib/rom.h"
#include "driverlib/epi.h"
#include "driverlib/gpio.h"
#include "driverlib/sysctl.h"
#include "driverlib/inc/hw_memmap.h"

//!
//! Constructor
//!
//! The constructor initializes this object.
//!
//! \returns
//!     Nothing.
//!

void EPIInitialize(void) {

    //
    // Enable EPI0
    //

    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_EPI0);

    //
    // Enable GPIO
    //

    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOA);
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOB);
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOC);
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOD);
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOE);
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOF);
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOG);
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOH);
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOJ);

    //
    // Configure the GPIO pins for EPI mode
    //
    // EPI0S30 (CS#) and EPI0S31 (CLK) are not configured for EPI use
    //

    ROM_GPIOPinTypeEPI(GPIO_PORTA_BASE, 0);
    ROM_GPIOPinTypeEPI(GPIO_PORTB_BASE, (GPIO_PIN_5 |   // EPI0S22
                                         GPIO_PIN_4));  // EPI0S23
    ROM_GPIOPinTypeEPI(GPIO_PORTC_BASE, (GPIO_PIN_7 |   // EPI0S5
                                         GPIO_PIN_6 |   // EPI0S4
                                         GPIO_PIN_5 |   // EPI0S3
                                         GPIO_PIN_4));  // EPI0S2
    ROM_GPIOPinTypeEPI(GPIO_PORTD_BASE, (GPIO_PIN_4 |   // EPI0S19
                                         GPIO_PIN_3 |   // EPI0S21
                                         GPIO_PIN_2));  // EPI0S20
    ROM_GPIOPinTypeEPI(GPIO_PORTE_BASE, (GPIO_PIN_3 |   // EPI0S25
                                         GPIO_PIN_2 |   // EPI0S24
                                         GPIO_PIN_1 |   // EPI0S9
                                         GPIO_PIN_0));  // EPI0S8
    ROM_GPIOPinTypeEPI(GPIO_PORTF_BASE, (GPIO_PIN_5 |   // EPI0S15
                                         GPIO_PIN_4));  // EPI0S12
    ROM_GPIOPinTypeEPI(GPIO_PORTG_BASE, (GPIO_PIN_1 |   // EPI0S14
                                         GPIO_PIN_0));  // EPI0S13
    ROM_GPIOPinTypeEPI(GPIO_PORTH_BASE, (GPIO_PIN_7 |   // EPI0S27
                                         GPIO_PIN_6 |   // EPI0S26
                                         GPIO_PIN_5 |   // EPI0S11
                                         GPIO_PIN_4 |   // EPI0S10
                                         GPIO_PIN_3 |   // EPI0S0
                                         GPIO_PIN_2 |   // EPI0S1
                                         GPIO_PIN_1 |   // EPI0S7
                                         GPIO_PIN_0));  // EPI0S6
    ROM_GPIOPinTypeEPI(GPIO_PORTJ_BASE, (GPIO_PIN_5 |   // EPI0S29
                                         GPIO_PIN_4 |   // EPI0S28
                                         GPIO_PIN_2 |   // EPI0S18
                                         GPIO_PIN_1 |   // EPI0S17
                                         GPIO_PIN_0));  // EPI0S16

    //
    // Configure EPI Pins
    //
    // EPI0S30 (CS#) and EPI0S31 (CLK) are not configured for EPI use
    //

    ROM_GPIOPinConfigure(GPIO_PH3_EPI0S0);
    ROM_GPIOPinConfigure(GPIO_PH2_EPI0S1);
    ROM_GPIOPinConfigure(GPIO_PC4_EPI0S2);
    ROM_GPIOPinConfigure(GPIO_PC5_EPI0S3);
    ROM_GPIOPinConfigure(GPIO_PC6_EPI0S4);
    ROM_GPIOPinConfigure(GPIO_PC7_EPI0S5);
    ROM_GPIOPinConfigure(GPIO_PH0_EPI0S6);
    ROM_GPIOPinConfigure(GPIO_PH1_EPI0S7);
    ROM_GPIOPinConfigure(GPIO_PE0_EPI0S8);
    ROM_GPIOPinConfigure(GPIO_PE1_EPI0S9);
    ROM_GPIOPinConfigure(GPIO_PH4_EPI0S10);
    ROM_GPIOPinConfigure(GPIO_PH5_EPI0S11);
    ROM_GPIOPinConfigure(GPIO_PF4_EPI0S12);
    ROM_GPIOPinConfigure(GPIO_PG0_EPI0S13);
    ROM_GPIOPinConfigure(GPIO_PG1_EPI0S14);
    ROM_GPIOPinConfigure(GPIO_PF5_EPI0S15);
    ROM_GPIOPinConfigure(GPIO_PJ0_EPI0S16);
    ROM_GPIOPinConfigure(GPIO_PJ1_EPI0S17);
    ROM_GPIOPinConfigure(GPIO_PJ2_EPI0S18);
    ROM_GPIOPinConfigure(GPIO_PD4_EPI0S19);
    ROM_GPIOPinConfigure(GPIO_PD2_EPI0S20);
    ROM_GPIOPinConfigure(GPIO_PD3_EPI0S21);
    ROM_GPIOPinConfigure(GPIO_PB5_EPI0S22);
    ROM_GPIOPinConfigure(GPIO_PB4_EPI0S23);
    ROM_GPIOPinConfigure(GPIO_PE2_EPI0S24);
    ROM_GPIOPinConfigure(GPIO_PE3_EPI0S25);
    ROM_GPIOPinConfigure(GPIO_PH6_EPI0S26);
    ROM_GPIOPinConfigure(GPIO_PH7_EPI0S27);
    ROM_GPIOPinConfigure(GPIO_PJ4_EPI0S28);
    ROM_GPIOPinConfigure(GPIO_PJ5_EPI0S29);

    //
    // Configure EPI
    //

    ROM_EPIModeSet(EPI0_BASE, EPI_MODE_HB16);
    ROM_EPIDividerSet(EPI0_BASE, 0);
    ROM_EPIConfigHB16Set(EPI0_BASE, (EPI_HB16_MODE_ADDEMUX  |
                                     EPI_HB16_WRWAIT_0      |
                                     EPI_HB16_RDWAIT_0      |
                                     EPI_HB16_BSEL          |
                                     EPI_HB16_WORD_ACCESS   |
                                     EPI_HB16_CSCFG_CS), 0);

    //
    // Set EPI address map
    //

    ROM_EPIAddressMapSet(EPI0_BASE, (EPI_ADDR_RAM_SIZE_256B |
                                     EPI_ADDR_RAM_BASE_6));
}

//
//! Return EPI Address
//

unsigned long EPIAddressMapGet(void) {
    return 0x60000000;
}
