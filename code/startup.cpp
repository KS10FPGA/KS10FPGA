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

#include <stdint.h>

extern "C" int main(void);
extern "C" void vectReset(void);
extern "C" void vectDefault(void);
extern "C" void vectTICK(void);

//
// Addresses from linker
//

extern unsigned long _etext;                                            //!< Address of start of .data in ROM
extern unsigned long _data;                                             //!< Address of start of .data
extern unsigned long _edata;                                            //!< Address of end of .data
extern unsigned long _bss;                                              //!< Address of start of .bss
extern unsigned long _ebss;                                             //!< Address if end of .bss
extern unsigned long _stackend;                                         //!< Address of end of stack
extern void (*__preinit_array_start[])(void) __attribute__((weak));     //!< Address of start of preinit array
extern void (*__preinit_array_end[])(void)   __attribute__((weak));     //!< Address of end of preinit array
extern void (*__init_array_start[])(void)    __attribute__((weak));     //!< Address of start of init array
extern void (*__init_array_end[])(void)      __attribute__((weak));     //!< Address of end of init array

//
// Weak aliases for the vectors.  If you define 'real' functions
// they will override these default handlers.
//

void vectNMI(void)    __attribute__ ((weak, alias("vectDefault")));     //!< NMI vector
void vectHard(void)   __attribute__ ((weak, alias("vectDefault")));     //!< Hard fault vector
void vectMPU(void)    __attribute__ ((weak, alias("vectDefault")));     //!< MPU fault vector
void vectBUS(void)    __attribute__ ((weak, alias("vectDefault")));     //!< Bus Fault vector
void vectUSAGE(void)  __attribute__ ((weak, alias("vectDefault")));     //!< Usage Fault vector
void vectSVCALL(void) __attribute__ ((weak, alias("vectDefault")));     //!< SVCall vector
void vectDEBUG(void)  __attribute__ ((weak, alias("vectDefault")));     //!< Debug monitor vector
void vectPEND(void)   __attribute__ ((weak, alias("vectDefault")));     //!< PendSV vector
void vectTICK0(void)  __attribute__ ((weak, alias("vectDefault")));     //!< SysTick vector
void vectTICK1(void)  __attribute__ ((weak, alias("vectDefault")));     //!< SysTick vector
void vectTICK2(void)  __attribute__ ((weak, alias("vectDefault")));     //!< SysTick vector
void vectTICK3(void)  __attribute__ ((weak, alias("vectDefault")));     //!< SysTick vector
void vectTICK4(void)  __attribute__ ((weak, alias("vectDefault")));     //!< SysTick vector
void vectGPIOA(void)  __attribute__ ((weak, alias("vectDefault")));     //!< GPIO Port A interrupt vector
void vectGPIOB(void)  __attribute__ ((weak, alias("vectDefault")));     //!< GPIO Port B interrupt vector
void vectGPIOC(void)  __attribute__ ((weak, alias("vectDefault")));     //!< GPIO Port C interrupt vector
void vectGPIOD(void)  __attribute__ ((weak, alias("vectDefault")));     //!< GPIO Port D interrupt vector
void vectGPIOE(void)  __attribute__ ((weak, alias("vectDefault")));     //!< GPIO Port E interrupt vector
void vectUART0(void)  __attribute__ ((weak, alias("vectDefault")));     //!< UART0 interrupt vector
void vectUART1(void)  __attribute__ ((weak, alias("vectDefault")));     //!< UART1 interrupt vector
void vectSSI0(void)   __attribute__ ((weak, alias("vectDefault")));     //!< SSI0 interrupt vector
void vectI2C0(void)   __attribute__ ((weak, alias("vectDefault")));     //!< I2C0 interrupt vector
void vectPWM(void)    __attribute__ ((weak, alias("vectDefault")));     //!< PWM interrupt vector
void vectPWM0(void)   __attribute__ ((weak, alias("vectDefault")));     //!< PWM0 interrupt vector
void vectPWM1(void)   __attribute__ ((weak, alias("vectDefault")));     //!< PWM1 interrupt vector
void vectPWM2(void)   __attribute__ ((weak, alias("vectDefault")));     //!< PWM2 interrupt vector
void vectQEC0(void)   __attribute__ ((weak, alias("vectDefault")));     //!< Quadrature Encoder 0 interrupt vector
void vectADC0(void)   __attribute__ ((weak, alias("vectDefault")));     //!< ADC0 Sequence 0 interrupt vector
void vectGPIOF(void)  __attribute__ ((weak, alias("vectDefault")));     //!< GPIO Port F interrupt vector
void vectGPIOG(void)  __attribute__ ((weak, alias("vectDefault")));     //!< GPIO Port G interrupt vector
void vectGPIOH(void)  __attribute__ ((weak, alias("vectDefault")));     //!< GPIO Port H interrupt vector
void vectUART2(void)  __attribute__ ((weak, alias("vectDefault")));     //!< UART2 interrupt vector
void vectSSI1(void)   __attribute__ ((weak, alias("vectDefault")));     //!< SSI1 interrupt vector
void vectCAN0(void)   __attribute__ ((weak, alias("vectDefault")));     //!< CAN0 interrupt vector
void vectCAN1(void)   __attribute__ ((weak, alias("vectDefault")));     //!< CAN1 interrupt vector
void vectENET(void)   __attribute__ ((weak, alias("vectDefault")));     //!< Ethernet interrupt vector
void vectUSB(void)    __attribute__ ((weak, alias("vectDefault")));     //!< USB interrupt vector
void vectPWM3(void)   __attribute__ ((weak, alias("vectDefault")));     //!< PWM3 interrupt vector
void vectI2S0(void)   __attribute__ ((weak, alias("vectDefault")));     //!< I2S0 interrupt vector
void vectEPI(void)    __attribute__ ((weak, alias("vectDefault")));     //!< EPI interrupt vector
void vectGPIOJ(void)  __attribute__ ((weak, alias("vectDefault")));     //!< GPIO Port J interrupt vector

//
//! Vectors and Stack
//

struct vectStruct_t {
    uint32_t *stackEnd;         // Top of stack
    void (*vectorList[70])();   // Array of vectors
} vectStruct __attribute__ ((section(".vectors"))) = {
    &_stackend, {               //  0 : Top of stack
        vectReset,              //  1 : Reset vector
        vectNMI,                //  2 : NMI vector
        vectHard,               //  3 : Hard fault vector
        vectMPU,                //  4 : MPU fault vector
        vectBUS,                //  5 : Bus Fault vector
        vectUSAGE,              //  6 : Usage Fault vector
        vectDefault,            //  7 : Reserved
        vectDefault,            //  8 : Reserved
        vectDefault,            //  9 : Reserved
        vectDefault,            // 10 : Reserved
        vectSVCALL,             // 11 : SVCall vector
        vectDEBUG,              // 12 : Debug monitor vector
        vectDefault,            // 13 : Reserved
        vectPEND,               // 14 : PendSV vector
        vectTICK,               // 15 : SysTick vector
        vectGPIOA,              // 16 : GPIO Port A interrupt vector
        vectGPIOB,              // 17 : GPIO Port B interrupt vector
        vectGPIOC,              // 18 : GPIO Port C interrupt vector
        vectGPIOD,              // 19 : GPIO Port D interrupt vector
        vectGPIOE,              // 20 : GPIO Port E interrupt vector
        vectUART0,              // 21 : UART0 interrupt vector
        vectUART1,              // 22 : UART1 interrupt vector
        vectSSI0,               // 23 : SSI0 interrupt vector
        vectI2C0,               // 24 : I2C0 interrupt vector
        vectPWM,                // 25 : PWM Fault interrupt vector
        vectPWM0,               // 26 : PWM0 interrupt vector
        vectPWM1,               // 27 : PWM1 interrupt vector
        vectPWM2,               // 28 : PWM2 interrupt vector
        vectQEC0,               // 29 : Quadrature Encoder 0 interrupt vector
        vectADC0,               // 30 : ADC0 Sequence 0 interrupt vector
        vectDefault,            // 31 : ADC0 Sequence 1 interrupt vector
        vectDefault,            // 32 : ADC0 Sequence 2 interrupt vector
        vectDefault,            // 33 : ADC0 Sequence 3 interrupt vector
        vectDefault,            // 34 : Watchdog timer 0 and 1 interrupt vector
        vectDefault,            // 35 : Timer 0 subtimer A interrupt vector
        vectDefault,            // 36 : Timer 0 subtimer B interrupt vector
        vectDefault,            // 37 : Timer 1 subtimer A interrupt vector
        vectDefault,            // 38 : Timer 1 subtimer B interrupt vector
        vectDefault,            // 39 : Timer 2 subtimer A interrupt vector
        vectDefault,            // 40 : Timer 2 subtimer B interrupt vector
        vectDefault,            // 41 : Analog Comparator 0 interrupt vector
        vectDefault,            // 42 : Analog Comparator 1 interrupt vector
        vectDefault,            // 43 : Analog Comparator 2 interrupt vector
        vectDefault,            // 44 : System Control interrupt vector
        vectDefault,            // 45 : FLASH memory Control
        vectGPIOF,              // 46 : GPIO Port F interrupt vector
        vectGPIOG,              // 47 : GPIO Port G interrupt vector
        vectGPIOH,              // 48 : GPIO Port H interrupt vector
        vectUART2,              // 49 : UART2 interrupt vector
        vectSSI1,               // 50 : SSI1 interrupt vector
        vectDefault,            // 51 : Timer 3 subtimer A interrupt vector
        vectDefault,            // 52 : Timer 3 subtimer B interrupt vector
        vectDefault,            // 53 : I2C1  interrupt vector
        vectDefault,            // 54 : Quadrature Encoder 1 interrupt vector
        vectCAN0,               // 55 : CAN0 interrupt vector
        vectCAN1,               // 56 : CAN1 interrupt vector
        vectDefault,            // 57 : Reserved
        vectENET,               // 58 : Ethernet interrupt vector
        vectDefault,            // 59 : Reserved
        vectUSB,                // 60 : USB interrupt vector
        vectPWM3,               // 61 : PWM3 interrupt vector
        vectDefault,            // 62 : uDMA Software
        vectDefault,            // 63 : uDMA Error
        vectDefault,            // 64 : ADC1 Sequence 0 interrupt vector
        vectDefault,            // 65 : ADC1 Sequence 1 interrupt vector
        vectDefault,            // 66 : ADC1 Sequence 2 interrupt vector
        vectDefault,            // 67 : ADC1 Sequence 3 interrupt vector
        vectI2S0,               // 68 : I2S0 interrupt vector
        vectEPI,                // 69 : EPI interrupt vector
        vectGPIOJ,              // 70 : GPIO Port J interrupt vector
    },
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

extern "C" void vectReset(void) {

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

    for (;;) {
        __asm("b.w      main");
    }
}

//
//! Default Vector
//!
//! This code is the default operation for all of the unused interrupt vectors.
//! It does asolutely noting.
//!
//

extern "C" void vectDefault(void) {
    ;
}

//
//! System Tick Timer Vector
//!
//! This code is the default operation for all of the System Tick Interrupt.
//! It allows several objects to get access to the System Tick Interrupt.
//!
//

extern "C" void vectTICK(void) {
    vectTICK0();
    vectTICK1();
    vectTICK2();
    vectTICK3();
    vectTICK4();
}
