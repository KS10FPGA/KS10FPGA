/*!
********************************************************************************
**
** KS10 Console Microcontroller
**
** \brief
**      Startup Code
**
** \details
**      This module initializes the CPU.
**
** \file
**      startup.cpp
**
** \note
**      In C++, the preinit operations are not supported because shared
**      libraries are not supported and therefore static constructors from
**      shared libraries are not supported.   Also static destructors are not
**      supported because main() should never exit.
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

extern "C" int main(void);
extern "C" void vectReset(void);
extern "C" void vectDefault(void);

//
// Addresses from linker
//

extern unsigned long _etext;                                            //!< Start of .data in ROM
extern unsigned long _data;                                             //!< Start of .data
extern unsigned long _edata;                                            //!< End of .data
extern unsigned long _bss;                                              //!< Start of .bss
extern unsigned long _ebss;                                             //!< End of .bss
extern unsigned long _stackend;                                         //!< End of .stack
extern void (*__preinit_array_start[])(void) __attribute__((weak));     //!< start of preinit array
extern void (*__preinit_array_end[])(void)   __attribute__((weak));     //!< start of preinit array
extern void (*__init_array_start[])(void)    __attribute__((weak));     //!< start of init array
extern void (*__init_array_end[])(void)      __attribute__((weak));     //!< start of init array

//
//! Weak aliases for the vectors.  If you define 'real' functions
//! they will override these default handlers.
//

void vectNMI(void)    __attribute__ ((weak, alias("vectDefault")));
void vectHard(void)   __attribute__ ((weak, alias("vectDefault")));
void vectMPU(void)    __attribute__ ((weak, alias("vectDefault")));
void vectBUS(void)    __attribute__ ((weak, alias("vectDefault")));
void vectUSAGE(void)  __attribute__ ((weak, alias("vectDefault")));
void vectSVCALL(void) __attribute__ ((weak, alias("vectDefault")));
void vectDEBUG(void)  __attribute__ ((weak, alias("vectDefault")));
void vectPEND(void)   __attribute__ ((weak, alias("vectDefault")));
void vectTICK(void)   __attribute__ ((weak, alias("vectDefault")));
void vectGPIOA(void)  __attribute__ ((weak, alias("vectDefault")));
void vectGPIOB(void)  __attribute__ ((weak, alias("vectDefault")));
void vectGPIOC(void)  __attribute__ ((weak, alias("vectDefault")));
void vectGPIOD(void)  __attribute__ ((weak, alias("vectDefault")));
void vectGPIOE(void)  __attribute__ ((weak, alias("vectDefault")));
void vectUART0(void)  __attribute__ ((weak, alias("vectDefault")));
void vectUART1(void)  __attribute__ ((weak, alias("vectDefault")));
void vectSSI0(void)   __attribute__ ((weak, alias("vectDefault")));
void vectI2C0(void)   __attribute__ ((weak, alias("vectDefault")));
void vectPWM(void)    __attribute__ ((weak, alias("vectDefault")));
void vectPWM0(void)   __attribute__ ((weak, alias("vectDefault")));
void vectPWM1(void)   __attribute__ ((weak, alias("vectDefault")));
void vectPWM2(void)   __attribute__ ((weak, alias("vectDefault")));
void vectQEC0(void)   __attribute__ ((weak, alias("vectDefault")));
void vectADC0(void)   __attribute__ ((weak, alias("vectDefault")));
void vectGPIOF(void)  __attribute__ ((weak, alias("vectDefault")));
void vectGPIOG(void)  __attribute__ ((weak, alias("vectDefault")));
void vectGPIOH(void)  __attribute__ ((weak, alias("vectDefault")));
void vectUART2(void)  __attribute__ ((weak, alias("vectDefault")));
void vectSSI1(void)   __attribute__ ((weak, alias("vectDefault")));
void vectCAN0(void)   __attribute__ ((weak, alias("vectDefault")));
void vectCAN1(void)   __attribute__ ((weak, alias("vectDefault")));
void vectENET(void)   __attribute__ ((weak, alias("vectDefault")));
void vectUSB(void)    __attribute__ ((weak, alias("vectDefault")));
void vectPWM3(void)   __attribute__ ((weak, alias("vectDefault")));
void vectI2S0(void)   __attribute__ ((weak, alias("vectDefault")));
void vectEPI(void)    __attribute__ ((weak, alias("vectDefault")));
void vectGPIOJ(void)  __attribute__ ((weak, alias("vectDefault")));

//!
//! Vectors and Stack
//!

struct vectStruct_t {
    uint32_t *stackEnd;         // Top of stack
    void (*vectorList[70])();   // Array of vectors
} vectStruct __attribute__ ((section(".vectors"))) = {
    &_stackend, {               //  0 : Top of stack
        vectReset,              //  1 : Reset vector
        vectNMI,                //  2 : NMI vector
        vectHard,               //  3 : Hard fault vector
        vectMPU,                //  4 : The MPU fault vector
        vectBUS,                //  5 : The bus fault vector
        vectUSAGE,              //  6 : The usage fault vector
        vectDefault,            //  7 : Reserved
        vectDefault,            //  8 : Reserved
        vectDefault,            //  9 : Reserved
        vectDefault,            // 10 : Reserved
        vectSVCALL,             // 11 : SVCall vector
        vectDEBUG,              // 12 : Debug monitor vector
        vectDefault,            // 13 : Reserved
        vectPEND,               // 14 : The PendSV vector
        vectTICK,               // 15 : The SysTick vector
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
        vectUSB,                // 60 : USB
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
//! \brief
//!     Reset Vector
//!
//! \details
//!     This code is placed at the reset vector.  It initialized the C/C++
//!     run-time environment.  It does the following:
//!
//!     - Initializes the "initialized data"
//!     - Clears bss
//!     - Executes the static constructors.
//!
//! \returns
//!     Nothing.
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
    //  Main should never return, but be smart if it does.
    //

    for (;;) {
        __asm("b.w      main");
    }
}

//!
//! \brief
//!     Default Vector
//!
//! \details
//!     This code is the default operation for all of the unused interrupt
//!     vectors.  It does asolutely noting.
//!
//! \returns
//!     Nothing.
//!

extern "C" void vectDefault(void) {
    ;
}
