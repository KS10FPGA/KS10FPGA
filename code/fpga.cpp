//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    FPGA Interface Object
//!
//! \details
//!    This object provides some very low level functions that can be used to
//!    program the KS10 FPGA.
//!
//!    Most of the come from the following document:
//!
//!    Spartan-6 FPGA Configuration User Guide UG380 (v2.8) November 3, 2015
//!
//! \file
//!    fpga.cpp
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
//
//! \addtogroup fpga_api
//! @{
//

#include "fpga.hpp"
#include "stdio.h"
#include "driverlib/rom.h"
#include "driverlib/gpio.h"
#include "driverlib/sysctl.h"
#include "driverlib/inc/hw_memmap.h"
#include "SafeRTOS/SafeRTOS_API.h"

//
// GPIO Definitions
//

#define GPIO_PIN_PROG  GPIO_PIN_0       // PB0
#define GPIO_PIN_INIT  GPIO_PIN_1       // PB1
#define GPIO_PIN_DONE  GPIO_PIN_3       // PB3
#define GPIO_PIN_DIN   GPIO_PIN_4       // PE4
#define GPIO_PIN_CCLK  GPIO_PIN_6       // PE6

//!
//! \brief
//!    This constructor initialize this object.
//!

fpga_t::fpga_t(void) {
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOB);
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOE);
    ROM_GPIOPinTypeGPIOOutput(GPIO_PORTB_BASE, GPIO_PIN_PROG);
    ROM_GPIOPinTypeGPIOInput(GPIO_PORTB_BASE, GPIO_PIN_INIT);
    ROM_GPIOPinTypeGPIOInput(GPIO_PORTB_BASE, GPIO_PIN_DONE);
    ROM_GPIOPinTypeGPIOOutput(GPIO_PORTE_BASE, GPIO_PIN_DIN);
    ROM_GPIOPinTypeGPIOOutput(GPIO_PORTE_BASE, GPIO_PIN_CCLK);
}

//!
//! \brief
//!    This function returns the state of the DONE pin.
//!
//! \returns
//!    <b>True</b> if the DONE pin is asserted, false otherwise.
//!

bool fpga_t::isDONE(void) {
    return ROM_GPIOPinRead(GPIO_PORTB_BASE, GPIO_PIN_DONE);
}

//!
//! \brief
//!    This function returns the state of the INIT# pin.
//!
//! \returns
//!    <b>True</b> if the INIT# pin is asserted, false otherwise.
//!

bool fpga_t::isINIT(void) {
    return !ROM_GPIOPinRead(GPIO_PORTB_BASE, GPIO_PIN_INIT);
}

//!
//! \brief
//!    This function asserts the PROG# pin of the FPGA for one millisecond.
//!    This starts the FPGA programming cycle.
//!

void fpga_t::pulsePROG(void) {
    ROM_GPIOPinWrite(GPIO_PORTB_BASE, GPIO_PIN_PROG, 0);
    xTaskDelay(1);
    ROM_GPIOPinWrite(GPIO_PORTB_BASE, GPIO_PIN_PROG, GPIO_PIN_PROG);
}

//!
//! \brief
//!    This function waits for the INIT# pin to be negated.  This signals
//!    that the FPGA is ready to receive serial programming data.
//!
//! \details
//!    This will 'time out' if the INIT# pin is still asserted after 100
//!    milliseconds.  Initialization should take a millisecond or two.
//!
//! \returns
//!    <b>True</b> if the INIT pulse is changes state properly, false
//!    otherwise.
//!

bool fpga_t::waitINIT(void) {
    for (int i = 0; i < 100; i++) {
        if (!isINIT()) {
            return true;
        }
        xTaskDelay(1);
    }
    return false;
}

//!
//! \brief
//!    This function will shift out 8 bits of data to the FPGA.
//!
//! \note
//!    Data is sent MSB first.  Data is sampled on the rising edge
//!    of the clock.
//!

void fpga_t::programByte(uint8_t data) {

        xTaskDelay(100);

    static int bitcnt = 0;
    printf("Byte was 0x%02x\n", data);
    for (int i = 0; i < 8; i++) {

        //
        // Set data and clear clock
        //

        ROM_GPIOPinWrite(GPIO_PORTE_BASE, GPIO_PIN_DIN | GPIO_PIN_CCLK, data & 0x80 ? GPIO_PIN_DIN : 0);

        //
        // Set clock
        //

        ROM_GPIOPinWrite(GPIO_PORTE_BASE, GPIO_PIN_CCLK, GPIO_PIN_CCLK);

        printf("Bit %d was %d\n", bitcnt++, !!(data & 0x80));

        //
        // Shift data
        //

        data <<= 1;


    }
}

//!
//! \brief
//!    Program the FPGA with firmware using the Serial Flash Device
//!

bool fpga_t::program(void) {

    //
    // Assert PROG# momentarily
    //

    pulsePROG();

    //
    // INIT goes low after PROG# is asserted while the FPGA initialize itself.
    //

    if (!isINIT()) {
        printf("FPGA: Programming Error.  INIT should be negated while initializing.\n");
       return false;
    }

    //
    // INIT goes high when the FPGA is ready for programming data.
    // Error on timeout.
    //

    if (!waitINIT()) {
        printf("FPGA: Programming Error.  INIT should be asserted before programming.\n");
        return false;
    }

    //
    // DONE goes high when the FPGA is done programming.  It shouldn't be
    // asserted now.
    //

    if (isDONE()) {
        printf("FPGA: Programming Error.  DONE should be negated before programming.\n");
        return false;
    }

    //
    // Print message
    //

    printf("FPGA: Programming with firmware from Serial Flash.");

    //
    // Wait for DONE to be asserted.  Error after 10 seconds.
    // The INIT# pin is asserted (low) if a CRC error occurs
    //

    for (int i = 0; i < 10; i++) {
        if (isDONE()) {
            printf("\nFPGA: Programmed successfully.\n");
            return true;
        }
        if (isINIT()) {
            printf("\nFPGA: Programming Error.  CRC Failure.\n");
            return false;
        }
        printf(" .");
        xTaskDelay(1000);
    }
    printf("\nFPGA: Programming Error.  Timeout waiting for DONE.\n");
    return false;
}

//!
//! \brief
//!    Program the FPGA with firmware using the SDHC Card
//!

bool fpga_t::program(FIL *fp) {

    //
    // Assert PROG# momentarily
    //

    pulsePROG();

    //
    // INIT goes low after PROG# is asserted while the FPGA initialize itself.
    //

    if (!isINIT()) {
        printf("FPGA: Programming Error.  INIT should be negated while initializing.\n");
        return false;
    }

    //
    // INIT goes high when the FPGA is ready for programming data.
    // Error on timeout.
    //

    if (!waitINIT()) {
        printf("FPGA: Programming Error.  INIT should be asserted before programming.\n");
        return false;
    }

    //
    // DONE goes high when the FPGA is done programming.  It shouldn't be
    // asserted now.
    //

    if (isDONE()) {
        printf("FPGA: Programming Error.  DONE should be negated before programming.\n");
        return false;
    }

    //
    // Print message
    //

    printf("FPGA: Programming with firmware from SDHC Card.");

    //
    // Program the FPGA sectors-by-sector from the SD Card.
    //

    int bytes = 0;
    for (unsigned int i = 0; ; i++) {

        //
        // Check for EOF
        //

        if (f_eof(fp)) {
            printf("FPGA: Programmed %d bytes.\n", bytes);
            break;
        }

        //
        // Print status (boring)
        //

        if ((i % 128) == 127) {
            printf(" .");
        }

        //
        // Attempt to read a 512 byte sector from the SD Card
        //

        uint8_t buffer[512];
        unsigned int numbytes;
        FRESULT status = f_read(fp, buffer, sizeof(buffer), &numbytes);
        if (status != FR_OK) {
            printf("\nFPGA: Programming Error.  Can't read firmware.  Status was %d\n", status);
        }

        //
        // Program upto 512 bytes into the FPGA.
        //

        for (unsigned int j = 0; j < numbytes; j++) {
            programByte(buffer[j]);

#if 1
            if (isDONE()) {
                printf("\nFPGA: Programmed successfully.  Byte is %d.\n", bytes);
            }

            if (isINIT()) {
                printf("\nFPGA: Programming Error.  CRC Failure.  Byte is %d.\n", bytes);
                return false;
            }
#endif

            bytes++;

        }


    }

    //
    //
    //

    for (;;) {

        //
        // If INIT is asserted there was a CRC error
        //

        if (isINIT()) {
            printf("\nFPGA: Programming Error.  CRC Failure.\n");
            return false;
        }

        if (isDONE()) {
            printf("\nFPGA: Programmed successfully.\n");
            programByte(0xff);
            return true;
        }

        //
        //
        //

        programByte(0xff);
    }

}



//
//! @}
//
