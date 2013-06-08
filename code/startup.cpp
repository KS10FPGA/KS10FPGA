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


typedef void (*vector_t)(void);		//!< Interrupt Vector type

extern "C" int main(void);
extern "C" void vectReset(void);

bool intrCSL;
static void vectCSL(void);
static void vectNMI(void);
static void vectHard(void);
static void vectDefault(void);

//
// Addresses from linker
//

extern unsigned long _etext;		//!< Start of .data in ROM
extern unsigned long _data;		//!< Start of .data
extern unsigned long _edata;		//!< End of .data
extern unsigned long _bss;		//!< Start of .bss
extern unsigned long _ebss;		//!< End of .bss
extern unsigned long _stackend;		//!< End of .stack

//!
//! Vector List
//!

vector_t vectList[] __attribute__ ((section(".vectors"))) = {
    (vector_t)(&_stackend),		//  0 : Top of stack
    vectReset, 				//  1 : Reset vector
    vectNMI, 				//  2 : NMI vector
    vectHard, 				//  3 : Hard fault vector
    vectDefault, 			//  4 : The MPU fault vector
    vectDefault, 			//  5 : The bus fault vector
    vectDefault, 			//  6 : The usage fault vector
    vectDefault, 			//  7 : Reserved
    vectDefault, 			//  8 : Reserved
    vectDefault, 			//  9 : Reserved
    vectDefault, 			// 10 : Reserved
    vectDefault, 			// 11 : SVCall vector
    vectDefault, 			// 12 : Debug monitor vector
    vectDefault, 			// 13 : Reserved
    vectDefault, 			// 14 : The PendSV vector
    vectDefault, 			// 15 : The SysTick vector
    vectDefault, 			// 16 : GPIO Port A interrupt vector
    vectDefault, 			// 17 : GPIO Port B interrupt vector
    vectDefault, 			// 18 : GPIO Port C interrupt vector
    vectDefault, 			// 19 : GPIO Port D interrupt vector
    vectDefault, 			// 20 : GPIO Port E interrupt vector
    vectDefault, 			// 21 : UART0 interrupt vector
    vectDefault, 			// 22 : UART1 interrupt vector
    vectDefault, 			// 23 : SSI0 interrupt vector
    vectDefault, 			// 24 : I2C0 interrupt vector
    vectDefault, 			// 25 : PWM Fault interrupt vector
    vectDefault, 			// 26 : PWM0 interrupt vector
    vectDefault, 			// 27 : PWM1 interrupt vector
    vectDefault, 			// 28 : PWM2 interrupt vector
    vectDefault, 			// 29 : Quadrature Encoder 0 interrupt vector
    vectDefault, 			// 30 : ADC0 Sequence 0 interrupt vector
    vectDefault, 			// 31 : ADC0 Sequence 1 interrupt vector
    vectDefault, 			// 32 : ADC0 Sequence 2 interrupt vector
    vectDefault, 			// 33 : ADC0 Sequence 3 interrupt vector
    vectDefault, 			// 34 : Watchdog timer 0 and 1 interrupt vector
    vectDefault, 			// 35 : Timer 0 subtimer A interrupt vector
    vectDefault, 			// 36 : Timer 0 subtimer B interrupt vector
    vectDefault, 			// 37 : Timer 1 subtimer A interrupt vector
    vectDefault, 			// 38 : Timer 1 subtimer B interrupt vector
    vectDefault, 			// 39 : Timer 2 subtimer A interrupt vector
    vectDefault, 			// 40 : Timer 2 subtimer B interrupt vector
    vectDefault, 			// 41 : Analog Comparator 0 interrupt vector
    vectDefault, 			// 42 : Analog Comparator 1 interrupt vector
    vectDefault, 			// 43 : Analog Comparator 2 interrupt vector
    vectDefault, 			// 44 : System Control interrupt vector
    vectDefault, 			// 45 : FLASH memory Control
    vectDefault, 			// 46 : GPIO Port F interrupt vector
    vectDefault, 			// 47 : GPIO Port G interrupt vector
    vectDefault, 			// 48 : GPIO Port H interrupt vector
    vectDefault, 			// 49 : UART2 interrupt vector
    vectDefault, 			// 50 : SSI1 interrupt vector
    vectDefault, 			// 51 : Timer 3 subtimer A interrupt vector
    vectDefault, 			// 52 : Timer 3 subtimer B interrupt vector
    vectDefault, 			// 53 : I2C1  interrupt vector
    vectDefault, 			// 54 : Quadrature Encoder 1 interrupt vector
    vectDefault, 			// 55 : CAN0 interrupt vector
    vectDefault, 			// 56 : CAN1 interrupt vector
    vectDefault, 			// 57 : Reserved
    vectDefault, 			// 58 : Ethernet interrupt vector
    vectDefault, 			// 59 : Reserved
    vectDefault, 			// 60 : USB
    vectDefault, 			// 61 : PWM3 interrupt vector
    vectDefault, 			// 62 : uDMA Software
    vectDefault, 			// 63 : uDMA Error
    vectDefault, 			// 64 : ADC1 Sequence 0 interrupt vector
    vectDefault, 			// 65 : ADC1 Sequence 1 interrupt vector
    vectDefault, 			// 66 : ADC1 Sequence 2 interrupt vector
    vectDefault, 			// 67 : ADC1 Sequence 3 interrupt vector
    vectDefault, 			// 68 : I2S0 interrupt vector
    vectDefault, 			// 69 : EPI interrupt vector
    vectDefault 			// 70 : GPIO Port J interrupt vector
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

    __asm("ldr  	r0, =_bss\n"
          "\tldr	r1, =_ebss\n"
          "\tmov	r2, #0\n"
          "\t.thumb_func\n"
          "\t1:\n"
          "\tcmp	r0, r1\n"
          "\tit  	lt\n"
          "\tstrlt	r2, [r0], #4\n"
          "\tblt	1b");

    //
    // Execute static constructors
    //

    //
    // Call main()
    //

    main();
}

//!
//! \brief
//!     NMI Vector
//!
//! \details
//!     This code is placed at the non-maskable interrupt vector.
//!     It does nothing.
//!  
//! \returns
//!     Nothing.
//!

static void vectNMI(void) {
    ;
}

//!
//! \brief
//!     Hard Fault Vector
//!
//! \details
//!     This code is placed at the hard fault vector.  It loops forever
//!     if a hard fault ever occurs.
//!  
//! \returns
//!     Nothing.
//!

static void vectHard(void) {
    for (;;) {
        ;
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

static void vectDefault(void) {
    ;
}

//!
//! \brief
//!     Console Interrupt Vector
//!
//! \details
//!     This code just set the \e intrCSL variable which is polled by the
//!     console code.
//!  
//! \returns
//!     Nothing.
//!

static void vectCSL(void) {
    intrCSL = true;
}
