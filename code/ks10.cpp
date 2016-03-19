//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    KS10 Interface Object
//!
//! \details
//!    This object provides the interfaces that are required to interact with
//!    the KS10 FPGA.
//!
//! \file
//!    ks10.cpp
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
//! \addtogroup ks10_api
//! @{
//

#include "epi.hpp"
#include "stdio.h"
#include "ks10.hpp"
#include "debug.hpp"
#include "fatal.hpp"
#include "fatfslib/ff.h"
#include "driverlib/rom.h"
#include "driverlib/gpio.h"
#include "driverlib/sysctl.h"
#include "driverlib/inc/hw_gpio.h"
#include "driverlib/inc/hw_ints.h"
#include "driverlib/inc/hw_types.h"
#include "driverlib/inc/hw_memmap.h"
#include "SafeRTOS/SafeRTOS_API.h"

//
// GPIO Bit Definitions
//

#define GPIO_HALT_LED  GPIO_PIN_7       // PD7

//
// Pointers to interrupt handler functions
//

void (*ks10_t::consIntrHandler)(void);
void (*ks10_t::haltIntrHandler)(void);

//!
//! \brief
//!    Constructor
//!
//! \details
//!    The constructor initializes this object.  For the most part, this
//!    function initializes the EPI object.
//!

ks10_t::ks10_t(void) {
    EPIInitialize();
    printf("KS10: EPI interface initialized.\n");
}

//!
//! \brief
//!    This function configures the GPIO for the interrupts and enables the
//!    interrupts.
//!
//! \details
//!    We use PB7 for the Console Interrupt from the KS10.  Normally PB7 is the
//!    NMI but we don't want NMI semantics.  Therefore this code configures PB7
//!    to be a normal active low GPIO-based interrupt.
//!
//!    We use PD7 for the Halt Interrupt.  It is triggered on both edges to
//!    detect Halt transitions.
//!
//! \param consIntrHandler -
//!    pointer to Console Interrupt Handler function
//!
//! \param haltIntrHandler -
//!    pointer to Halt Interrupt Handler function
//!

void ks10_t::enableInterrupts(void (*consIntrHandler)(void), void (*haltIntrHandler)(void)) {
    ks10_t::consIntrHandler = consIntrHandler;
    ks10_t::haltIntrHandler = haltIntrHandler;

    // Enable  GPIOB and GPIOD
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOB);
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOD);

    // Configure the HALT LED input
    ROM_GPIOPinTypeGPIOInput(GPIO_PORTD_BASE, GPIO_HALT_LED);

    // Unlock and change PB7 behavior - default is NMI
    HWREG(GPIO_PORTB_BASE + GPIO_O_LOCK) = GPIO_LOCK_KEY_DD;

    // Change commit register
    HWREG(GPIO_PORTB_BASE + GPIO_O_CR) |= 0x00000080;

    // Configure PD7 as an input
    ROM_GPIODirModeSet(GPIO_PORTB_BASE, GPIO_PIN_7, GPIO_DIR_MODE_IN);
    ROM_GPIODirModeSet(GPIO_PORTD_BASE, GPIO_PIN_7, GPIO_DIR_MODE_IN);

    //Set max current 2mA and connect weak pull-up resistor
    ROM_GPIOPadConfigSet(GPIO_PORTB_BASE, GPIO_PIN_7, GPIO_STRENGTH_2MA, GPIO_PIN_TYPE_STD_WPU);
    ROM_GPIOPadConfigSet(GPIO_PORTB_BASE, GPIO_PIN_7, GPIO_STRENGTH_2MA, GPIO_PIN_TYPE_STD_WPU);

    // Set the interrupt type for Pin B7 and Pin D7
    ROM_GPIOIntTypeSet(GPIO_PORTB_BASE, GPIO_PIN_7, GPIO_FALLING_EDGE);
    ROM_GPIOIntTypeSet(GPIO_PORTD_BASE, GPIO_PIN_7, GPIO_BOTH_EDGES);

    // Enable interrupt
    ROM_GPIOPinIntEnable(GPIO_PORTB_BASE, GPIO_PIN_7);
    ROM_GPIOPinIntEnable(GPIO_PORTD_BASE, GPIO_PIN_7);

    // Enable interrupts on Port B and Port D
    ROM_IntEnable(INT_GPIOB);
    ROM_IntEnable(INT_GPIOD);
}

//!
//! \brief
//!    Halt Interrupt Wrapper
//!

static bool dispatchHaltInterrupt = true;
extern "C" void gpiodIntHandler(void) {
    if (dispatchHaltInterrupt) {
        (*ks10_t::haltIntrHandler)();
    }
    ROM_GPIOPinIntClear(GPIO_PORTD_BASE, GPIO_PIN_7);
}

//!
//! \brief
//!    Console Interrupt Wrapper
//!

extern "C" void gpiobIntHandler(void) {
    ROM_GPIOPinIntClear(GPIO_PORTB_BASE, GPIO_PIN_7);
    (*ks10_t::consIntrHandler)();
}

//!
//! \brief
//!    This function starts and completes a KS10 bus transaction
//!
//! \details
//!    A KS10 FPGA bus cycle begins when the <b>GO</b> bit is asserted.  The
//!    <b>GO</b> bit will remain asserted while the bus cycle is still active.
//!    The <b>Console Data Register</b> should not be accessed when the
//!    <b>GO</b> bit is asserted.
//!

void ks10_t::go(void) {
    writeRegStat(readRegStat() | statGO);
    for (int i = 0; i < 100; i++) {
        if ((readRegStat() & statGO) == 0) {
           return;
        }
        taskYIELD();
    }
    printf("GO-bit timeout\n");
}

//!
//! \brief
//!    This function reads from <b>Console Status Register</b>
//!
//! \returns
//!    Contents of the <b>Console Status Register</b>.
//!

ks10_t::data_t ks10_t::readRegStat(void) {
    return readReg64(regStat);
}

//!
//! \brief
//!    This function writes to <b>Console Status Register</b>
//!
//! \param data -
//!    data to be written to the <b>Console Status Register</b>.
//!

void ks10_t::writeRegStat(data_t data) {
    writeReg64(regStat, data);
}

//!
//! \brief
//!    This function reads from <b>Console Address Register</b>
//!
//! \returns
//!    Contents of the <b>Console Address Register</b>.
//!

ks10_t::data_t ks10_t::readRegAddr(void) {
    return readReg64(regAddr);
}

//!
//! \brief
//!    This function writes to <b>Console Address Register</b>
//!
//! \param data -
//!    data to be written to the <b>Console Address Register</b>.
//!

void ks10_t::writeRegAddr(data_t data) {
    writeReg64(regAddr, data);
}

//!
//! \brief
//!    This function reads from <b>Console Data Register</b>
//!
//! \returns
//!    Contents of the <b>Console Data Register</b>.
//!

ks10_t::data_t ks10_t::readRegData(void) {
    return readReg64(regData);
}

//!
//! \brief
//!    This function writes to <b>Console Data Register</b>
//!
//! \param data -
//!    data to be written to the <b>Console Data Register</b>.
//!

void ks10_t::writeRegData(data_t data) {
    writeReg64(regData, data);
}

//!
//! \brief
//!    This function reads the <b>Console Instruction Register</b>
//!
//! \returns
//!    Contents of the <b>Console Instruction Register</b>
//!

ks10_t::data_t ks10_t::readRegCIR(void) {
    return readReg64(regCIR);
}

//!
//! \brief
//!    Function to write to the <b>Console Instruction Register</b>
//!
//! \param data -
//!    data is the data to be written to the <b>Console Instruction
//!    Register.</b>
//!

void ks10_t::writeRegCIR(data_t data) {
    writeReg64(regCIR, data);
}

//!
//! \brief
//!    This function to reads a 36-bit word from KS10 memory.
//!
//! \details
//!    This is a physical address write.  Writes to address 0 to 17 (octal)
//!    go to memory not to registers.
//!
//! \param [in] addr -
//!    addr is the address in the KS10 memory space which is to be read.
//!
//! \see
//!    readIO() for 36-bit IO reads, and readIObyte() for UNIBUS reads.
//!
//! \returns
//!    Contents of the KS10 memory that was read.
//!

ks10_t::data_t ks10_t::readMem(addr_t addr) {
    writeRegAddr((addr & memAddrMask) | flagRead | flagPhys);
    go();
    return dataMask & readRegData();
}

//!
//! \brief
//!    This function writes a 36-bit word to KS10 memory.
//!
//! \details
//!    This is a physical address write.  Writes to address 0 to 17 (octal)
//!    go to memory not to registers.
//!
//! \param [in] addr -
//!    addr is the address in the KS10 memory space which is to be written.
//!
//! \param [in] data -
//!    data is the data to be written to the KS10 memory.
//!
//! \see
//!    writeIO() for 36-bit IO writes, and writeIObyte() for UNIBUS writes.
//!

void ks10_t::writeMem(addr_t addr, data_t data) {
    writeRegAddr((addr & memAddrMask) | flagWrite | flagPhys);
    writeRegData(data);
    go();
}

//!
//! \brief
//!    This function reads a 36-bit word from KS10 IO.
//!
//! \param [in] addr -
//!    addr is the address in the KS10 IO space which is to be read.
//!
//! \see
//!    readMem() for 36-bit memory reads, and readIObyte() for UNIBUS reads.
//!
//! \returns
//!    Contents of the KS10 IO that was read.
//!

ks10_t::data_t ks10_t::readIO(addr_t addr) {
    writeRegAddr((addr & ioAddrMask) | flagRead | flagPhys | flagIO);
    go();
    return dataMask & readRegData();
}

//!
//! \brief
//!    This function writes a 36-bit word to the KS10 IO.
//!
//! \details
//!    This function is used to write to 36-bit KS10 IO and is not to be
//!    used to write to UNIBUS style IO.
//!
//! \param [in] addr -
//!    addr is the address in the KS10 IO space which is to be written.
//!
//! \param [in] data -
//!    data is the data to be written to the KS10 IO.
//!
//! \see
//!    writeMem() for memory writes, and writeIObyte() for UNIBUS writes.
//!

void ks10_t::writeIO(addr_t addr, data_t data) {
    writeRegAddr((addr & ioAddrMask) | flagWrite | flagPhys | flagIO);
    writeRegData(data);
    go();
}

//!
//! \brief
//!    This function reads an 8-bit (or 16-bit) byte from KS10 UNIBUS IO.
//!
//! \param [in]
//!    addr is the address in the Unibus IO space which is to be read.
//!
//! \see
//!    readMem() for 36-bit memory reads, and readIObyte() for UNIBUS
//!    reads.
//!
//! \returns
//!    Contents of the KS10 Unibus IO that was read.
//!

uint16_t ks10_t::readIObyte(addr_t addr) {
    writeRegAddr((addr & ioAddrMask) | flagRead | flagPhys | flagIO | flagByte);
    go();
    return 0xffff & readRegData();
}

//!
//! \brief
//!    This function writes 8-bit (or 16-bit) byte to KS10 Unibus IO.
//!
//! \param
//!    addr is the address in the KS10 Unibus IO space which is to be written.
//!
//! \param data -
//!    data is the data to be written to the KS10 Unibus IO.
//!

void ks10_t::writeIObyte(addr_t addr, uint16_t data) {
    writeRegAddr((addr & ioAddrMask) | flagWrite | flagPhys | flagIO | flagByte);
    writeRegData(data);
    go();
}

//!
//! \brief
//!    This function reads a 64-bit value from the DZCCR
//!
//! \returns
//!    contents of the DZCCR register
//!

uint64_t ks10_t::readDZCCR(void) {
    return *regDZCCR;
}

//!
//! \brief
//!    This function writes a 64-bit value to the DZCCR
//!
//! \param data -
//!    data is the data to be written to the DZCCR
//!

void ks10_t::writeDZCCR(uint64_t data) {
    *regDZCCR = data;
}

//!
//! \brief
//!    This function reads a 64-bit value from the RHCCR
//!
//! \returns
//!    contents of the RHCCR register
//!

uint64_t ks10_t::readRHCCR(void) {
    return *regRHCCR;
}

//!
//! \brief
//!    This function writes a 64-bit value to the RHCCR
//!
//! \param data -
//!    data is the data to be written to the RHCCR
//!

void ks10_t::writeRHCCR(uint64_t data) {
    *regRHCCR = data;
}

//!
//! \brief
//!    This function reads a 36-bit value from the Debug Control/Status Register
//!
//! \returns
//!    contents of the DCSR register
//!

uint64_t ks10_t::readDCSR(void) {
    return readReg64(regDCSR);
}

//!
//! \brief
//!    This function writes a 36-bit value to the Debug Control/Status Register
//!
//! \param data -
//!    data is the data to be written to the Debug Control/Status Register
//!

void ks10_t::writeDCSR(uint64_t data) {
    writeReg64(regDCSR, data);
}

//!
//! \brief
//!    This function reads a 36-bit value from the Breakpoint Address Register
//!
//! \returns
//!    contents of the DBAR register
//!

uint64_t ks10_t::readDBAR(void) {
    return readReg64(regDBAR);
}

//!
//! \brief
//!    This function writes a 36-bit value to the Breakpoint Address Register
//!
//! \param data -
//!    data is the data to be written to the Breakpoint Address Register
//!

void ks10_t::writeDBAR(uint64_t data) {
    writeReg64(regDBAR, data);
}

//!
//! \brief
//!   This function reads a 36-bit value from the Breakpoint Mask Register
//!
//! \returns
//!    contents of the DBMR register
//!

uint64_t ks10_t::readDBMR(void) {
    return readReg64(regDBMR);
}

//!
//! \brief
//!    This function writes a 36-bit value to the Breakpoint Mask Register
//!
//! \param data -
//!    data is the data to be written to the Breakpoint Mask Register
//!

void ks10_t::writeDBMR(uint64_t data) {
    writeReg64(regDBMR, data);
}

//!
//! \brief
//!    This function reads a 36-bit value from the Debug Instrcution Trace
//!    Register.  The trace buffer automatically increments when the trace buffer
//!    is read.
//!
//! \note
//!    For some reason, a 64-bit load advances the Trace Buffer FIFO twice.
//!    This code explicity peforms four 16-bit loads across the 16-bit EPI bus.
//!
//! \returns
//!    contents of the DITR register
//!

#if 1

uint64_t ks10_t::readDITR(void) {

    static constexpr volatile uint16_t * temp = reinterpret_cast<volatile uint16_t *>(regDITR);
    return ((static_cast<uint64_t>(temp[0]) <<  0) |
            (static_cast<uint64_t>(temp[1]) << 16) |
            (static_cast<uint64_t>(temp[2]) << 32) |
            (static_cast<uint64_t>(temp[3]) << 48));

}

#else

uint64_t ks10_t::readDITR(void) {
    return *regDITR;
}

#endif

//!
//! \brief
//!    This function controls the <b>RUN</b> mode of the KS10.
//!
//! \param enable -
//!    <b>True</b> puts the KS10 in <b>RUN</b> mode.
//!    <b>False</b> puts the KS10 in <b>HALT</b> mode.
//!

void ks10_t::run(bool enable) {
    data_t status = readRegStat();
    if (enable) {
        writeRegStat(status | statRUN);
    } else {
        writeRegStat(status & ~statRUN);
    }
}

//!
//! \brief
//!    This function checks the KS10 <b>RUN</b> status.
//!
//! \details
//!    This function examines the <b>RUN</b> bit in the <b>Console Control/Status
//!    Register</b>.
//!
//! \returns
//!    <b>true</b> if the KS10 is in <b>RUN</b> mode, <b>false</b> if the KS10
//!    is in <b>HALT</b> mode..
//!

bool ks10_t::run(void) {
    return readRegStat() & statRUN;
}

//!
//! \brief
//!    This function checks the KS10 <b>CONT</b> status.
//!
//! \details
//!    This function examines the <b>CONT</b> bit in the <b>Console Control/Status
//!    Register</b>.
//!
//! \returns
//!    <b>true</b> if the KS10 is in <b>CONT</b> mode, false otherwise.
//!
//!

bool ks10_t::cont(void) {
    return readRegStat() & statCONT;
}

//!
//! \brief
//!    Execute a single instruction in the CIR
//!

void ks10_t::execute(void) {
    writeRegStat(statCONT | statEXEC | readRegStat());
}

//!
//! \brief
//!    Execute a single instruction at the current PC
//!

void ks10_t::step(void) {
    writeRegStat(statCONT | readRegStat());
}

//!
//! \brief
//!    Continue execution at the current PC.
//!

void ks10_t::contin(void) {
    writeRegStat(statRUN | statCONT | readRegStat());
}

//!
//! \brief
//!    Begin execution with instruction in the CIR.
//!

void ks10_t::begin(void) {
    writeRegStat(statRUN | statCONT | statEXEC | readRegStat());
}

//!
//! \brief
//!    This function checks the KS10 <b>EXEC</b> status.
//!
//! \details
//!    This function examines the <b>EXEC</b> bit in the <b>Console Control/Status
//!    Register</b>.
//!
//! \returns
//!    <b>true</b> if the KS10 is in <b>EXEC</b> mode, false otherwise.
//!

bool ks10_t::exec(void) {
    return readRegStat() & statEXEC;
}

//!
//! \brief
//!    This checks the KS10 in <b>HALT</b> status.
//!
//! \details
//!    This function examines the <b>HALT</b> bit in the <b>Console Control/Status
//!    Register</b>
//!
//! \returns
//!    This function returns true if the KS10 is halted, false otherwise.
//!

bool ks10_t::halt(void) {
    return ROM_GPIOPinRead(GPIO_PORTD_BASE, GPIO_HALT_LED) == GPIO_HALT_LED;
}

//!
//! \brief
//!    Boot (Unreset) the KS10
//!
//! \param debug
//!    <b>True</b> enables debug mode.
//!

void ks10_t::boot(bool debug) {

    if (!ks10_t::cpuReset()) {
        printf("KS10: CPU should be reset.\n");
        if (!debug) {
            fatal();
        }
    }

    if (ks10_t::halt()) {
        printf("KS10: CPU should not be halted.\n");
        if (!debug) {
            fatal();
        }
    }

    if (ks10_t::run()) {
        printf("KS10: CPU should not be running.\n");
        if (!debug) {
            fatal();
        }
    }

    ks10_t::cpuReset(false);

    if (ks10_t::cpuReset()) {
        printf("KS10: CPU should be not be reset.\n");
        if (!debug) {
            fatal();
        }
    }

    if (ks10_t::halt()) {
        printf("KS10: CPU should not be halted.\n");
        if (!debug) {
            fatal();
        }
    }

    if (ks10_t::run()) {
        printf("KS10: CPU should not be running.\n");
        if (!debug) {
            fatal();
        }
    }
}

//!
//! \brief
//!    Wait for halt to be asserted.
//!
//! \details
//!    This function waits for upto one second for halt to be asserted.
//!
//! \returns
//!    This function returns true if halt is asserted within one second,
//!    false otherwise.
//!

void ks10_t::waitHalt(bool debug) {
    for (int i = 0; i < 1000; i++) {
        if (ks10_t::halt()) {
            return;
        }
        taskYIELD();
    }
    printf("KS10: Timeout waiting for KS10 to initialize.\n");
    if (!debug) {
        fatal();
    }
}

//!
//! \brief
//! Report the state of the KS10's interval timer.
//!
//! \returns
//!    Returns <b>true</b> if the KS10 interval timer enabled and <b>false</b>
//!    otherwise.
//!

bool ks10_t::timerEnable(void) {
    return readRegStat() & statTIMEREN;
}

//!
//! \brief
//! Control the KS10 interval timer operation
//!
//! \param
//!     enable is <b>true</b> to enable the KS10 intervale timer or
//!     <b>false</b> to disable the KS10 timer.
//!

void ks10_t::timerEnable(bool enable) {
    data_t status = readRegStat();
    if (enable) {
        writeRegStat(status | statTIMEREN);
    } else {
        writeRegStat(status & ~statTIMEREN);
    }
}

//!
//! \brief
//!    Report the state of the KS10's traps.
//!
//! \returns
//!    Returns <b>true</b> if the KS10 traps enabled and <b>false</b>
//!    otherwise.
//!

bool ks10_t::trapEnable(void) {
    return readRegStat() & statTRAPEN;
}

//!
//! \brief
//!    Control the KS10 traps operation
//!
//! \details
//!    This function controls whether the KS10's trap are enabled.
//!
//! \param
//!    enable is <b>true</b> to enable the KS10 traps or <b>false</b> to
//!    disable the KS10 traps.
//!

void ks10_t::trapEnable(bool enable) {
    data_t status = readRegStat();
    if (enable) {
        writeRegStat(status | statTRAPEN);
    } else {
        writeRegStat(status & ~statTRAPEN);
    }
}

//!
//! \brief
//!    Report the state of the KS10's cache memory.
//!
//! \returns
//!    Returns <b>true</b> if the KS10 cache enabled and <b>false</b>
//!    otherwise.
//!

bool ks10_t::cacheEnable(void) {
    return readRegStat() & statCACHEEN;
}

//!
//! \brief
//!    Control the KS10 cache memory operation
//!
//! \details
//!    This function controls whether the KS10's cache is enabled.
//!
//! \param
//!    enable is <b>true</b> to enable the KS10 cache or <b>false</b> to
//!    disable the KS10 cache.
//!

void ks10_t::cacheEnable(bool enable) {
    data_t status = readRegStat();
    if (enable) {
        writeRegStat(status | statCACHEEN);
    } else {
        writeRegStat(status & ~statCACHEEN);
    }
}

//!
//! \brief
//!    Report the state of the KS10's reset signal.
//!
//! \returns
//!    Returns <b>true</b> if the KS10 is <b>reset</b> and <b>false</b>
//!    otherwise.
//!

bool ks10_t::cpuReset(void) {
    return readRegStat() & statRESET;
}

//!
//! \brief
//!    Reset the KS10
//!
//! \details
//!    This function controls whether the KS10's is reset.  When reset, the KS10 will
//!    reset on next clock cycle without completing the current operatoin.
//!
//! \param
//!    enable is <b>true</b> to assert <b>reset</b> to the KS10 or <b>false</b> to
//!    negate <b>reset</b> to the KS10.
//!
//!

void ks10_t::cpuReset(bool enable) {
    data_t status = readRegStat();
    if (enable) {
        writeRegStat(status | statRESET);
    } else {
        writeRegStat(status & ~statRESET);
    }
}

//!
//! \brief
//!    This function creates a KS10 interrupt.
//!
//! \details
//!    This function momentarily pulses the <b>KS10INTR</b> bit of the <b>Console
//!    Control/Status Register</b>.
//!
//!    The <b>KS10INTR</b> bit only need to be asserted for a single FPGA clock
//!    cycle in order to create an interrupt.
//!

void ks10_t::cpuIntr(void) {
    data_t status = readRegStat();
    writeRegStat(status | statINTR);
    ROM_SysCtlDelay(10);
    writeRegStat(status);
}

//!
//! \brief
//!    This function returns the state of the <b>NXM/NXD</b> bit of the
//!    <b>Console Control/Status Register</b>.
//!
//! \details
//!    The NXM/NXD bit is volatile.  This function will reset the state of the
//!    <b>NXM/NXD</b> bit when it is read.
//!

bool ks10_t::nxmnxd(void) {
    data_t reg = readRegStat();
    writeRegStat(reg & ~statNXMNXD);
    return reg & statNXMNXD;
}

//!
//! \brief
//!    Program the FPGA with firmware using the Serial Flash Device
//!
//! \param debug -
//!    <b>True</b> enables debug mode.
//!

void ks10_t::programFirmware(bool debug) {

    //
    // Construct FPGA object
    //

    fpga_t fpga;

    //
    // Program the FPGA
    //

    bool success = fpga.program();
    if (!success && !debug) {
        fatal();
    }

}

//!
//! \brief
//!    Program the FPGA with firmware using the data from the SDHC card.
//!
//! \param debug -
//!    <b>True</b> enables debug mode.
//!
//! \param filename -
//!    Filename of the firmware to load into the FPGA.
//!

void ks10_t::programFirmware(bool debug, const char *filename) {

    //
    // Attempt to open the firmware file
    //

    FIL fp;
    FRESULT status = f_open(&fp, filename, FA_READ);
    if (status != FR_OK) {
        printf("KS10: Unable to open firmware file \"%s\".  Status was %d\n", filename, status);
        return;
    } else {
        debug_printf(debug, "KS10: Opened firmware file \"%s\" for reading.\n", filename);
    }

    //
    // Construct FPGA object
    //

    fpga_t fpga;

    //
    // Program the FPGA
    //

    bool success = fpga.program(&fp);

    //
    // Close the file
    //

    status = f_close(&fp);
    if (status != FR_OK) {
        printf("KS10: Unable to close firmware file \"%s\".  Status was %d\n", filename, status);
    }

    //
    // Check status
    //

    if (!success && !debug) {
        fatal();
    }

}

//!
//! \brief
//!    This function verifies that the firmware is loaded into KS10 FPGA.
//!
//! \details
//!    The FPGA should respond with "REVxx.yy" where xx is the major revision
//!    and yy is the minor revision.
//!
//!

void ks10_t::checkFirmware(bool debug) {
    const char *buf = regVers;
    if ((buf[0] == 'R') && (buf[1] == 'E') && (buf[2] == 'V') && (buf[5] == 0xae)) {
        printf("KS10: FPGA Firmware is %c%c%c %c%c%c%c%c\n",
               buf[0] & 0x7f, buf[1] & 0x7f, buf[2] & 0x7f, buf[3] & 0x7f,
               buf[4] & 0x7f, buf[5] & 0x7f, buf[6] & 0x7f, buf[7] & 0x7f);
    } else if (debug) {
        printf("KS10: FPGA Firmware is %02x%02x%02x%02x%02x%02x%02x%02x\n",
               buf[0], buf[1], buf[2], buf[3], buf[4], buf[5], buf[6], buf[7]);
    } else {
        printf("KS10: Unable to communicate with the KS10 FPGA.\n");
        fatal();
    }
}

//!
//! \brief
//!    This function return the contents of the Halt Status Word.
//!
//! \returns
//!     Contents of the Halt Status Word
//!

ks10_t::haltStatusWord_t &ks10_t::getHaltStatusWord(void) {
    static haltStatusWord_t haltStatusWord;

    haltStatusWord.status = readMem(0);
    haltStatusWord.pc     = readMem(1);

    return haltStatusWord;
}

//!
//! \brief
//!    This function tests on a console interface register.
//!
//! \details
//!    This test performs a 64-bit "walking ones test" on the the register.
//!    This verified both the register and the bus interface between the MCU and
//!    the FPGA.
//!
//! \param addr -
//!    address of the register in the EPI address space.
//!
//! \param name -
//!    name of the register used in verbose debugging messages
//!
//! \param debug -
//!    enables debugging messages
//!
//! \param mask -
//!    allows masking unimplemented register bits.  This is used to test 36-bit
//!    registers using the 64-bit interface.
//!
//! \returns
//!    True if test pass, false otherwise.
//!

bool ks10_t::testReg64(volatile void * addr, const char *name, bool debug, uint64_t mask) {

    debug_printf(debug, "KS10:  %s: Checking 64-bit accesses.\n", name);

    //
    // Save register contents
    //

    uint64_t save = readReg64(addr);

    //
    // Perform test
    //

    bool success = true;
    volatile uint64_t * reg64 = reinterpret_cast<volatile uint64_t *>(addr);

    for (unsigned long long write64 = 1; write64 != 0; write64 <<= 1) {
        *reg64 = write64;
        uint64_t read64 = *reg64;
        if ((write64 & mask) != 0) {
            if (read64 != write64) {
                debug_printf(debug, "KS10:  %s: Register failure.  Was 0x%016llx.  Should be 0x%016llx\n", name, read64, write64);
                success = false;
            }
        }
    }

    //
    // Restore register contents
    //

    writeReg64(addr, save);

    return success;
}

//!
//! \brief
//!    Test all of the KS10 Registers
//!
//! \returns
//!    True if all of the tests pass, false otherwise.
//!

void ks10_t::testRegs(bool debug) {
    bool success = true;
    if (debug) {
        printf("KS10: Console Interface Register test.\n");
    }
    success &= testReg64(regAddr,  "regADDR ", debug, 0xfffffffff);
    success &= testReg64(regData,  "regDATA ", debug, 0xfffffffff);
    success &= testReg64(regCIR,   "regCIR  ", debug, 0xfffffffff);
    success &= testReg64(regDZCCR, "regDZCCR", debug);
    success &= testReg64(regRHCCR, "regRHCCR", debug);
    success &= testReg64(regDBAR,  "regDBAR ", debug, 0xfffffffff);
    success &= testReg64(regDBMR,  "regDBMR ", debug, 0xfffffffff);
    if (success) {
        printf("KS10: Console Interface Register test completed successfully.\n");
    } else {
        printf("KS10: Console Interface Register test failed.\n");
        if (!debug) {
            fatal();
        }
    }
}

//!
//! \brief
//!    Get Halt Status Word.
//!
//! \details
//!    This function return the contents of the Halt Status Block.
//!
//! \returns
//!    Contents of the Halt Status Block.
//!
//! \note
//!    The KS10 Technical Manual shows that the Halt Status Block include the
//!    FE and SC register.  This is incorrect.   See ksrefRev2 document.
//!

ks10_t::haltStatusBlock_t &ks10_t::getHaltStatusBlock(addr_t addr) {
    static haltStatusBlock_t haltStatusBlock;

    haltStatusBlock.mag  = readMem(addr +  0);
    haltStatusBlock.pc   = readMem(addr +  1);
    haltStatusBlock.hr   = readMem(addr +  2);
    haltStatusBlock.ar   = readMem(addr +  3);
    haltStatusBlock.arx  = readMem(addr +  4);
    haltStatusBlock.br   = readMem(addr +  5);
    haltStatusBlock.brx  = readMem(addr +  6);
    haltStatusBlock.one  = readMem(addr +  7);
    haltStatusBlock.ebr  = readMem(addr +  8);
    haltStatusBlock.ubr  = readMem(addr +  9);
    haltStatusBlock.mask = readMem(addr + 10);
    haltStatusBlock.flg  = readMem(addr + 11);
    haltStatusBlock.pi   = readMem(addr + 12);
    haltStatusBlock.x1   = readMem(addr + 13);
    haltStatusBlock.t0   = readMem(addr + 14);
    haltStatusBlock.t1   = readMem(addr + 15);
    haltStatusBlock.vma  = readMem(addr + 16);
    return haltStatusBlock;
}

//!
//! \brief
//!    Get Contents of RH11 Debug Register
//!
//! \brief
//!    This function return the contents of the RH11 Debug Register
//!
//! \returns
//!     Contents of the RH11 Debug Register
//!

uint64_t ks10_t::getRH11debug(void) {
    return *regRH11Debug;
}

//!
//! \brief
//!    Write a character to the KS10
//!
//! \param ch -
//!    Character to write to the KS10
//!

void ks10_t::putchar(int ch) {
    data_t cty_in = readMem(ctyin_addr);
    if ((cty_in & cty_valid) == 0) {
        ks10_t::writeMem(ctyin_addr, cty_valid | (ch & 0xff));
        ks10_t::cpuIntr();
    }
}

//!
//! \brief
//!    Read a character from the KS10
//!
//! \returns
//!    Character from the KS10
//!

int ks10_t::getchar(void) {
    data_t cty_out = readMem(ctyout_addr);
    if ((cty_out & cty_valid) != 0) {
        writeMem(ctyout_addr, 0);
        return cty_out & 0x7f;
    } else {
        return -1;
    }
}

//!
//! \brief
//!    Execute a single instruction
//!
//! \param insn -
//!    Instruction to execute
//!
//! \note
//!    This mucks with the halt interrupt so we don't get halt messages
//!    displayed during this.
//!

void ks10_t::executeInstruction(data_t insn) {
    dispatchHaltInterrupt = false;

    //
    // Stuff the instruction in the Console Insturction Register and
    // execute it.
    //

    ks10_t::writeRegCIR(insn);
    ks10_t::execute();

    //
    // Wait for the processor to HALT.
    //

    while (!ks10_t::halt()) {
        ;
    }

    dispatchHaltInterrupt = true;

}

//
//! @}
//
