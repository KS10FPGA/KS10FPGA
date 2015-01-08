//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! Startup Code
//!
//! This module initializes the C/C++ Run Time environment.
//!
//! This code does the following:
//! -# Creates the interrupt vector table.
//! -# Clears .bss
//! -# Initializes the 'initialized data' from flash
//! -# Runs C++ static constructors.
//! -# Calls main()
//!
//! All interrupt vectors are weakly bound to a interrupt handler that does
//! nothing.  The use an interrupt vector, just create a function with
//! the proper name and it will override the weak binding.
//!
//! In C++, the preinit operations are not supported because shared
//! libraries are not supported and therefore static constructors from
//! shared libraries are not supported.
//!
//! C++ static destructors are also not implemented because main() should
//! never exit.
//!
//! Some of the interrupts have independant handlers so that theycan be caught
//! independantly by the debugger.
//!
//! \file
//!    startup.cpp
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

#include "SafeRTOS/SafeRTOS_API.h"

//
// Attributes
//

#define __naked   __attribute__((naked))
#define __weak    __attribute__((weak))
#define __alias   __attribute__((alias("nullIntHandler")))
#define __vectors __attribute__((section(".vectors")))

//
// Function Prototypes
//

extern "C" int main(void);
extern "C" void lwIPEthernetIntHandler(void);
extern "C" void nmiIntHandler(void);
extern "C" void faultIntHandler(void);
extern "C" void nullIntHandler(void);
extern "C" void __naked reset(void);

//
// Addresses from linker
//

extern unsigned long _etext;                            //!< Address of start of .data in ROM
extern unsigned long _data;                             //!< Address of start of .data
extern unsigned long _edata;                            //!< Address of end of .data
extern unsigned long _bss;                              //!< Address of start of .bss
extern unsigned long _ebss;                             //!< Address if end of .bss
extern unsigned long _stackend;                         //!< Address of end of stack
extern void __weak (*__init_array_start[])(void);       //!< Address of start of init function array
extern void __weak (*__init_array_end[])(void);         //!< Address of end of init function array

//
// Weak aliases for the vectors.  If you define 'real' functions
// they will override these default handlers.
//

void __weak __alias mpuIntHandler(void);                //!< MPU fault vector
void __weak __alias busIntHandler(void);                //!< Bus Fault vector
void __weak __alias usageIntHandler(void);              //!< Usage Fault vector
void __weak __alias svcallIntHandler(void);             //!< SVCall vector
void __weak __alias debugIntHandler(void);              //!< Debug monitor vector
void __weak __alias pendIntHandler(void);               //!< PendSV vector
void __weak __alias tickIntHandler(void);               //!< SysTick vector
void __weak __alias gpioaIntHandler(void);              //!< GPIO Port A interrupt vector
void __weak __alias gpiobIntHandler(void);              //!< GPIO Port B interrupt vector
void __weak __alias gpiocIntHandler(void);              //!< GPIO Port C interrupt vector
void __weak __alias gpiodIntHandler(void);              //!< GPIO Port D interrupt vector
void __weak __alias gpioeIntHandler(void);              //!< GPIO Port E interrupt vector
void __weak __alias uart0IntHandler(void);              //!< UART0 interrupt vector
void __weak __alias uart1IntHandler(void);              //!< UART1 interrupt vector
void __weak __alias ssi0IntHandler(void);               //!< SSI0 interrupt vector
void __weak __alias i2c0IntHandler(void);               //!< I2C0 interrupt vector
void __weak __alias pwmIntHandler(void);                //!< PWM interrupt vector
void __weak __alias pwm0IntHandler(void);               //!< PWM0 interrupt vector
void __weak __alias pwm1IntHandler(void);               //!< PWM1 interrupt vector
void __weak __alias pwm2IntHandler(void);               //!< PWM2 interrupt vector
void __weak __alias qec0IntHandler(void);               //!< Quadrature Encoder 0 interrupt vector
void __weak __alias adc0IntHandler(void);               //!< ADC0 Sequence 0 interrupt vector
void __weak __alias timer0IntHandler(void);             //!< Timer 0 interrupt vector
void __weak __alias timer1IntHandler(void);             //!< Timer 1 interrupt vector
void __weak __alias timer2IntHandler(void);             //!< Timer 2 interrupt vector
void __weak __alias timer3IntHandler(void);             //!< Timer 3 interrupt vector
void __weak __alias gpiofIntHandler(void);              //!< GPIO Port F interrupt vector
void __weak __alias gpiogIntHandler(void);              //!< GPIO Port G interrupt vector
void __weak __alias gpiohIntHandler(void);              //!< GPIO Port H interrupt vector
void __weak __alias uart2IntHandler(void);              //!< UART2 interrupt vector
void __weak __alias ssi1IntHandler(void);               //!< SSI1 interrupt vector
void __weak __alias can0IntHandler(void);               //!< CAN0 interrupt vector
void __weak __alias can1IntHandler(void);               //!< CAN1 interrupt vector
void __weak __alias enetIntHandler(void);               //!< Ethernet interrupt vector
void __weak __alias usbIntHandler(void);                //!< USB interrupt vector
void __weak __alias pwm3IntHandler(void);               //!< PWM3 interrupt vector
void __weak __alias i2s0IntHandler(void);               //!< I2S0 interrupt vector
void __weak __alias epiIntHandler(void);                //!< EPI interrupt vector
void __weak __alias gpiojIntHandler(void);              //!< GPIO Port J interrupt vector

//
// Macros to cast entry point addresses to pointers-to-functions.
//

#define svcallIntHandler   (void (*)(void))vSafeRTOS_SVC_Handler_Address
#define pendIntHandler     (void (*)(void))vSafeRTOS_PendSV_Handler_Address
#define tickIntHandler     (void (*)(void))vSafeRTOS_SysTick_Handler_Address
#define enetIntHandler     lwIPEthernetIntHandler

//
//! Vectors and Stack
//

struct vectStruct_t {
    unsigned long *stackEnd;    // Top of stack
    void (*vectorList[70])();   // Array of vectors
} vectStruct __vectors = {
    &_stackend, {               //  0 : Top of stack
        reset,                  //  1 : Reset vector
        nmiIntHandler,          //  2 : NMI vector
        faultIntHandler,        //  3 : Hard fault vector
        mpuIntHandler,          //  4 : MPU fault vector
        busIntHandler,          //  5 : Bus Fault vector
        usageIntHandler,        //  6 : Usage Fault vector
        nullIntHandler,         //  7 : Reserved
        nullIntHandler,         //  8 : Reserved
        nullIntHandler,         //  9 : Reserved
        nullIntHandler,         // 10 : Reserved
        svcallIntHandler,       // 11 : SVCall vector
        debugIntHandler,        // 12 : Debug monitor vector
        nullIntHandler,         // 13 : Reserved
        pendIntHandler,         // 14 : PendSV vector
        tickIntHandler,         // 15 : SysTick vector
        gpioaIntHandler,        // 16 : GPIO Port A interrupt vector
        gpiobIntHandler,        // 17 : GPIO Port B interrupt vector
        gpiocIntHandler,        // 18 : GPIO Port C interrupt vector
        gpiodIntHandler,        // 19 : GPIO Port D interrupt vector
        gpioeIntHandler,        // 20 : GPIO Port E interrupt vector
        uart0IntHandler,        // 21 : UART0 interrupt vector
        uart1IntHandler,        // 22 : UART1 interrupt vector
        ssi0IntHandler,         // 23 : SSI0 interrupt vector
        i2c0IntHandler,         // 24 : I2C0 interrupt vector
        pwmIntHandler,          // 25 : PWM Fault interrupt vector
        pwm0IntHandler,         // 26 : PWM0 interrupt vector
        pwm1IntHandler,         // 27 : PWM1 interrupt vector
        pwm2IntHandler,         // 28 : PWM2 interrupt vector
        qec0IntHandler,         // 29 : Quadrature Encoder 0 interrupt vector
        adc0IntHandler,         // 30 : ADC0 Sequence 0 interrupt vector
        nullIntHandler,         // 31 : ADC0 Sequence 1 interrupt vector
        nullIntHandler,         // 32 : ADC0 Sequence 2 interrupt vector
        nullIntHandler,         // 33 : ADC0 Sequence 3 interrupt vector
        nullIntHandler,         // 34 : Watchdog timer 0 and 1 interrupt vector
        timer0IntHandler,       // 35 : Timer 0 subtimer A interrupt vector
        nullIntHandler,         // 36 : Timer 0 subtimer B interrupt vector
        timer1IntHandler,       // 37 : Timer 1 subtimer A interrupt vector
        nullIntHandler,         // 38 : Timer 1 subtimer B interrupt vector
        timer2IntHandler,       // 39 : Timer 2 subtimer A interrupt vector
        nullIntHandler,         // 40 : Timer 2 subtimer B interrupt vector
        nullIntHandler,         // 41 : Analog Comparator 0 interrupt vector
        nullIntHandler,         // 42 : Analog Comparator 1 interrupt vector
        nullIntHandler,         // 43 : Analog Comparator 2 interrupt vector
        nullIntHandler,         // 44 : System Control interrupt vector
        nullIntHandler,         // 45 : FLASH memory Control
        gpiofIntHandler,        // 46 : GPIO Port F interrupt vector
        gpiogIntHandler,        // 47 : GPIO Port G interrupt vector
        gpiohIntHandler,        // 48 : GPIO Port H interrupt vector
        uart2IntHandler,        // 49 : UART2 interrupt vector
        ssi1IntHandler,         // 50 : SSI1 interrupt vector
        timer3IntHandler,       // 51 : Timer 3 subtimer A interrupt vector
        nullIntHandler,         // 52 : Timer 3 subtimer B interrupt vector
        nullIntHandler,         // 53 : I2C1     interrupt vector
        nullIntHandler,         // 54 : Quadrature Encoder 1 interrupt vector
        can0IntHandler,         // 55 : CAN0 interrupt vector
        can1IntHandler,         // 56 : CAN1 interrupt vector
        nullIntHandler,         // 57 : Reserved
        enetIntHandler,         // 58 : Ethernet interrupt vector
        nullIntHandler,         // 59 : Reserved
        usbIntHandler,          // 60 : USB interrupt vector
        pwm3IntHandler,         // 61 : PWM3 interrupt vector
        nullIntHandler,         // 62 : uDMA Software
        nullIntHandler,         // 63 : uDMA Error
        nullIntHandler,         // 64 : ADC1 Sequence 0 interrupt vector
        nullIntHandler,         // 65 : ADC1 Sequence 1 interrupt vector
        nullIntHandler,         // 66 : ADC1 Sequence 2 interrupt vector
        nullIntHandler,         // 67 : ADC1 Sequence 3 interrupt vector
        i2s0IntHandler,         // 68 : I2S0 interrupt vector
        epiIntHandler,          // 69 : EPI interrupt vector
        gpiojIntHandler,        // 70 : GPIO Port J interrupt vector
    }
};

//!
//! Reset Vector
//!
//! This code is placed at the reset vector.  It initializes the C/C++
//! run-time environment.  It does the following:
//!
//! -# Initializes the "initialized data"
//! -# Clears bss
//! -# Executes the static constructors.
//! -# Calls main()
//!

void reset(void) {

    //
    // Disable Interrupts
    //

    __asm volatile ("cpsid i");

    //
    // Initialize '.data'
    //

    unsigned long *src = &_etext;
    unsigned long *dst = &_data;
    while (dst < &_edata) {
        *dst++ = *src++;
    }

    //
    // Clear '.bss'
    //

    dst = &_bss;
    while (dst < &_ebss) {
        *dst++ = 0;
    }

    //
    // Execute static constructors
    //

    unsigned long count = __init_array_end - __init_array_start;
    for (unsigned long i = 0; i < count; i++) {
        __init_array_start[i]();
    }

    //
    // Call main()
    // Main should never return, but be smart if it does.
    //
    // The #()*#$ compiler warns about calling main().  Hide the call in
    // asm just to shut up the warning.
    //

    for (;;) {
        __asm("b.w      main");
    }
}

//
//! NMI Interrupt Handler
//!
//! This code halts the processor.
//

void nmiIntHandler(void) {
    for (;;) {
        ;
    }
}

//
//! Fault Interrupt Handler
//!
//! This code halts the processor.
//

void faultIntHandler(void) {
    for (;;) {
        ;
    }
}

//
//! Null Interrupt Handler
//!
//!  Otherwise unhandled interrupts come here.
//

void nullIntHandler(void) {
    for (;;) {
        ;
    }
}
