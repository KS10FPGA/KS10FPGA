//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! KS10 Interface Object
//!
//! This object provides the interfaces that are required to interact with the
//! KS10 FPGA.
//!
//! \file
//!    ks10.cpp
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
//
//! \addtogroup ks10_api
//! @{
//

#include "epi.h"
#include "ks10.hpp"
#include "driverlib/rom.h"
#include "driverlib/gpio.h"
#include "driverlib/sysctl.h"
#include "driverlib/inc/hw_gpio.h"
#include "driverlib/inc/hw_ints.h"
#include "driverlib/inc/hw_types.h"
#include "driverlib/inc/hw_memmap.h"

#include "stdio.h"

void (*ks10_t::consIntrHandler)(void);

//
//! Constructor
//!
//! The constructor initializes this object.
//!
//! For the most part, this function initializes the EPI object and configures
//! the GPIO for the console interrupt.
//!
//! We use PB7 for the interrupt from the KS10.  Normally PB7 is the NMI but
//! we don't want NMI semantics.  Therefore this code configures PB7 to
//! be a normal active low GPIO-based interrupt.
///

ks10_t::ks10_t(void (*consIntrHandler)(void)) {
    ks10_t::consIntrHandler = consIntrHandler;

    EPIInitialize();

    // Unlock and change PB7 behavior - default is NMI
    HWREG(GPIO_PORTB_BASE + GPIO_O_LOCK) = GPIO_LOCK_KEY;

    // Change commit register
    HWREG(GPIO_PORTB_BASE + GPIO_O_CR) = 0x000000ff;

    // Configure PD7 as an input
    ROM_GPIODirModeSet(GPIO_PORTB_BASE, GPIO_PIN_7, GPIO_DIR_MODE_IN);

    // Set max current 2mA and connect weak pull-up resistor
    ROM_GPIOPadConfigSet(GPIO_PORTB_BASE, GPIO_PIN_7, GPIO_STRENGTH_2MA,
                         GPIO_PIN_TYPE_STD_WPU);

    // Set the interrupt type for each pin
    ROM_GPIOIntTypeSet(GPIO_PORTB_BASE, GPIO_PIN_7, GPIO_FALLING_EDGE);
    // (GPIO_FALLING_EDGE | GPIO_DISCRETE_INT)

    // Enable interrupt
    ROM_GPIOPinIntEnable(GPIO_PORTB_BASE, GPIO_PIN_7);

    // Enable interrupts on Port B
    ROM_IntEnable(INT_GPIOB);
}

//
//! Console Interrupt Wrapper
//

extern "C" void gpiobIntHandler(void) {
    (*ks10_t::consIntrHandler)();
    ROM_GPIOPinIntClear(GPIO_PORTB_BASE, GPIO_PIN_7);
}

//
//!  This function starts and completes a KS10 bus transaction
//!
//!  A KS10 FPGA bus cycle begins when the <b>GO</b> bit is asserted.  The
//!  <b>GO</b> bit will remain asserted while the bus cycle is still active.
//!  The <b>Console Data Register</b> should not be accessed when the <b>GO</b>
//!  bit is asserted.
//

void ks10_t::go(void) {
    writeReg(regStat, statGO);
    for (int i = 0; i < 1000; i++) {
        if (!(readReg(regStat) & statGO)) {
            return;
        }
        ROM_SysCtlDelay(1);
    }
}

//
//! This function reads from <b>Console Status Register</b>
//!
//! \returns
//!     Contents of the <b>Console Status Register</b>.
//

ks10_t::data_t ks10_t::readStatus(void) {
    return readReg(regStat);
}

//
//! This function writes to <b>Console Status Register</b>
//!
//! \param data
//!     data to be written to the <b>Console Status Register</b>.
//

void ks10_t::writeStatus(data_t data) {
    writeReg(regStat, data);
}

//
//! This function reads the <b>Console Instruction Register</b>
//!
//! \returns
//!     Contents of the <b>Console Instruction Register</b>
//

ks10_t::data_t ks10_t::readCIR(void) {
    return readReg(regCIR);
}

//
//! Function to write to the <b>Console Instruction Register</b>
//!
//! \param
//!     data is the data to be written to the <b>Console Instruction
//!     Register.</b>
//

void ks10_t::writeCIR(data_t data) {
    writeReg(regCIR, data);
}

//
//! This function to reads a 36-bit word from KS10 memory.
//!
//! \param [in]
//!     addr is the address in the KS10 memory space which is to be read.
//!
//! \see
//!     readIO() for 36-bit IO reads, and readIObyte() for UNIBUS reads.
//!
//! \returns
//!     Contents of the KS10 memory that was read.
//

ks10_t::data_t ks10_t::readMem(addr_t addr) {
    writeReg(regAddr, (addr & addrMask) | read);
    go();
    return dataMask & readReg(regData);
}

//
//! This function writes a 36-bit word to KS10 memory.
//!
//! \param [in]
//!     addr is the address in the KS10 memory space which is to be written.
//!
//! \param [in]
//!     data is the data to be written to the KS10 memory.
//!
//! \see
//!     writeIO() for 36-bit IO writes, and writeIObyte() for UNIBUS writes.
//

void ks10_t::writeMem(addr_t addr, data_t data) {
    writeReg(regAddr, (addr & addrMask) | write);
    writeReg(regData, data);
    go();
}

//
//! This function reads a 36-bit word from KS10 IO.
//!
//! \param [in]
//!     addr is the address in the KS10 IO space which is to be read.
//!
//! \see
//!     readMem() for 36-bit memory reads, and readIObyte() for UNIBUS reads.
//!
//! \returns
//!     Contents of the KS10 IO that was read.
//

ks10_t::data_t ks10_t::readIO(addr_t addr) {
    writeReg(regAddr, (addr & addrMask) | read | io);
    go();
    return dataMask & readReg(regData);
}

//
//! This function writes a 36-bit word to the KS10 IO.
//!
//! This function is used to write to 36-bit KS10 IO and is not to be
//! used to write to UNIBUS style IO.
//!
//! \param [in]
//!     addr is the address in the KS10 IO space which is to be written.
//!
//! \param [in]
//!     data is the data to be written to the KS10 IO.
//!
//! \see
//!     writeMem() for memory writes, and writeIObyte() for UNIBUS writes.
//

void ks10_t::writeIO(addr_t addr, data_t data) {
    writeReg(regAddr, (addr & addrMask) | write | io);
    writeReg(regData, data);
    go();
}

//
//! This function reads an 8-bit (or 16-bit) byte from KS10 UNIBUS IO.
//!
//! \param [in]
//!     addr is the address in the Unibus IO space which is to be read.
//!
//! \see
//!     readMem() for 36-bit memory reads, and readIObyte() for UNIBUS
//!     reads.
//!
//! \returns
//!     Contents of the KS10 Unibus IO that was read.
//

uint16_t ks10_t::readIObyte(addr_t addr) {
    writeReg(regAddr, (addr & addrMask) | read | io | byte);
    go();
    return 0xffff & readReg(regData);
}

//
//! This function writes 8-bit (or 16-bit) byte to KS10 Unibus IO.
//!
//! \param
//!     addr is the address in the KS10 Unibus IO space which is to be written.
//!
//! \param
//!     data is the data to be written to the KS10 Unibus IO.
//

void ks10_t::writeIObyte(addr_t addr, uint16_t data) {
    writeReg(regAddr, (addr & addrMask) | write | io | byte);
    writeReg(regData, data);
    go();
}

//
//! This function controls the <b>RUN</b> mode of the KS10.
//!
//! \param enable -
//!     <b>True</b> puts the KS10 in <b>RUN</b> mode.
//!     <b>False</b> puts the KS10 in <b>HALT</b> mode.
//

void ks10_t::run(bool enable) {
    data_t status = readReg(regStat);
    if (enable) {
        writeReg(regStat, status | statRUN);
    } else {
        writeReg(regStat, status & ~statRUN);
    }
}

//
//! This function checks the KS10 <b>RUN</b> status.
//!
//! This function examines the <b>RUN</b> bit in the <b>Console Control/Status
//! Register</b>.
//!
//! \returns
//!     <b>true</b> if the KS10 is in <b>RUN<\b> mode, <b>false</b> if the KS10
//!     is in <b>HALT</b> mode..
//

bool ks10_t::run(void) {
    return readReg(regStat) & statRUN;
}

//
//! This function controls the <b>CONT</b> mode of the KS10.
//!
//! \param enable -
//!     <b>True</b> puts the KS10 in <b>CONT</b> mode.
//!     <b>False</b> takes the KS10 out of <b>CONT</b> mode.
//

void ks10_t::cont(bool enable) {
    data_t status = readReg(regStat);
    if (enable) {
        writeReg(regStat, status | statCONT);
    } else {
        writeReg(regStat, status & ~statCONT);
    }
}

//
//! This function checks the KS10 <b>CONT</b> status.
//!
//! This function examines the <b>CONT</b> bit in the <b>Console Control/Status
//! Register</b>.
//!
//! \returns
//!     <b>true</b> if the KS10 is in <b>CONT<\b> mode, false otherwise.
//

bool ks10_t::cont(void) {
    return readReg(regStat) & statCONT;
}

//
//! This function controls the <b>EXEC</b> mode of the KS10.
//!
//! \param enable -
//!     <b>True</b> puts the KS10 in <b>EXEC</b> mode.
//!     <b>False</b> takes the KS10 out of <b>EXEC</b> mode.
//

void ks10_t::exec(bool enable) {
    data_t status = readReg(regStat);
    if (enable) {
        writeReg(regStat, status | statEXEC);
    } else {
        writeReg(regStat, status & ~statEXEC);
    }
}

//
//! This function checks the KS10 <b>EXEC</b> status.
//!
//! This function examines the <b>EXEC</b> bit in the <b>Console Control/Status
//! Register</b>.
//!
//! \returns
//!     <b>true</b> if the KS10 is in <b>EXEC<\b> mode, false otherwise.
//

bool ks10_t::exec(void) {
    return readReg(regStat) & statEXEC;
}

//
//! This checks the KS10 in <b>HALT</b> status.
//!
//! This function examines the <b>HALT</b> bit in the <b>Console Control/Status
//! Register</b>
//!
//! \returns
//!     This function returns true if the KS10 is halted, false otherwise.
//

bool ks10_t::halt(void) {
    return readReg(regStat) & statHALT;
}

//
//! Report the state of the KS10's interval timer.
//!
//! \returns
//!     Returns <b>true</b> if the KS10 interval timer enabled and <b>false</b>
//!     otherwise.
//

bool ks10_t::timerEnable(void) {
    return readReg(regStat) & statTIMEREN;
}

//
//! Control the KS10 interval timer operation
//!
//! \param
//!     enable is <b>true</b> to enable the KS10 intervale timer or
//!     <b>false</b> to disable the KS10 timer.
//

void ks10_t::timerEnable(bool enable) {
    data_t status = readReg(regStat);
    if (enable) {
        writeReg(regStat, status | statTIMEREN);
    } else {
        writeReg(regStat, status & ~statTIMEREN);
    }
}

//
//! Report the state of the KS10's traps.
//!
//! \returns
//!     Returns <b>true</b> if the KS10 traps enabled and <b>false</b>
//!     otherwise.
//

bool ks10_t::trapEnable(void) {
    return readReg(regStat) & statTRAPEN;
}

//
//! Control the KS10 traps operation
//!
//! This function controls whether the KS10's trap are enabled.
//!
//! \param
//!     enable is <b>true</b> to enable the KS10 traps or <b>false</b> to
//!     disable the KS10 traps.
//

void ks10_t::trapEnable(bool enable) {
    data_t status = readReg(regStat);
    if (enable) {
        writeReg(regStat, status | statTRAPEN);
    } else {
        writeReg(regStat, status & ~statTRAPEN);
    }
}

//
//! Report the state of the KS10's cache memory.
//!
//! \returns
//!     Returns <b>true</b> if the KS10 cache enabled and <b>false</b>
//!     otherwise.
//

bool ks10_t::cacheEnable(void) {
    return readReg(regStat) & statCACHEEN;
}

//
//! Control the KS10 cache memory operation
//!
//! This function controls whether the KS10's cache is enabled.
//!
//! \param
//!     enable is <b>true</b> to enable the KS10 cache or <b>false</b> to
//!     disable the KS10 cache.
//

void ks10_t::cacheEnable(bool enable) {
    data_t status = readReg(regStat);
    if (enable) {
        writeReg(regStat, status | statCACHEEN);
    } else {
        writeReg(regStat, status & ~statCACHEEN);
    }
}

//
//! Report the state of the KS10's reset signal.
//!
//! \returns
//!     Returns <b>true</b> if the KS10 is <b>reset</b> and <b>false</b>
//!     otherwise.
//

bool ks10_t::cpuReset(void) {
    return readReg(regStat) & statRESET;
}

//
//! Reset the KS10
//!
//! This function controls whether the KS10's is reset.  When reset, the KS10 will
//! reset on next clock cycle without completing the current operatoin.
//!
//! \param
//!     enable is <b>true</b> to assert <b>reset</b> to the KS10 or <b>false</b> to
//!     negate <b>reset</b> to the KS10.
//!
//

void ks10_t::cpuReset(bool enable) {
    data_t status = readReg(regStat);
    if (enable) {
        writeReg(regStat, status | statRESET);
    } else {
        writeReg(regStat, status & ~statRESET);
    }
}

//
//! This function creates a KS10 interrupt.
//!
//! This function momentarily pulses the <b>KS10INTR</b> bit of the <b>Console
//! Control/Status Register</b>.
//!
//! The <b>KS10INTR</b> bit only need to be asserted for a single FPGA clock
//! cycle in order to create an interrupt.
//

void ks10_t::cpuIntr(void) {
    data_t status = readReg(regStat);
    writeReg(regStat, status | statINTR);
    ROM_SysCtlDelay(10);
    writeReg(regStat, status);
}

//
//!  This function returns the state of the <b>NXM/NXD</b> bit of the
//!  <b>Console Control/Status Register</b>.
//!
//!  This function will reset the state of the <b>NXM/NXD</b> bit once it is
//!  read.
//

bool ks10_t::nxmnxd(void) {
    data_t reg = readReg(regStat);
    writeReg(regStat, reg & ~statNXMNXD);
    return reg & statNXMNXD;
}

//
//! Get the firmware revision of the KS10 FPGA firmware
//!
//! \returns
//!     character string with firmware information
//

const char *ks10_t::getFirmwareRev(void) {
    return regVers;
}

//!
//! Get Halt Status Word
//!
//! This function return the contents of the Halt Status Word.
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


bool ks10_t::testRegister(volatile void * addr, const char *name, uint64_t mask) {
    volatile uint64_t * reg64 = (uint64_t*)addr;

    uint64_t initialState = *reg64;
    printf("test: %s: Initial State = 0x%016llx\n", name, initialState);

    uint64_t vector64[] = {
        0x0000000000000000ull,
	0x00000000000000ffull,
	0x000000000000ffffull,
	0x0000000000ffffffull,
	0x00000000ffffffffull,
	0x000000ffffffffffull,
	0x0000ffffffffffffull,
	0x00ffffffffffffffull,
	0xffffffffffffffffull,
    };

    printf("test: %s: Checking 64-bit write.\n", name);
    for (unsigned int i = 0; i < sizeof(vector64)/sizeof(vector64[0]); i++) {
        *reg64 = vector64[i];
	uint64_t readback = *reg64;
	if (readback != (vector64[i] & mask)) {
  	    printf("test: %s, Register failure.  was 0x%016llx, should be 0x%016llx\n", name, readback, vector64[i]);
	}
    }

    printf("test: %s: Checking byte lanes.\n", name);
    volatile uint8_t * reg08 = (uint8_t*)addr;
    *reg64 = vector64[0];
    for (unsigned int i = 0; i < sizeof(vector64)/sizeof(vector64[0]); i++) {
	uint64_t readback = *reg64;
	if (readback != (vector64[i] & mask)) {
  	    printf("test: %s: Register failure.  was 0x%016llx, should be 0x%016llx\n", name, readback, vector64[i]);
	}
	*reg08++ = 0xff;
    }

    printf("test: %s: Checking bits\n", name);
    for (int i = 0; i < 64; i++) {
        uint64_t bit = 1ull << i;
	*reg64 = bit;
	volatile uint64_t readback = *reg64;
	if (readback != (bit & mask)) {
	    printf("test: %s: Register failure.  was 0x%016llx, should be 0x%016llx\n", name, readback, bit);
	}
    }

    *reg64 = initialState;
    return true;
}

bool ks10_t::testRegs(void) {
    bool success = true;
    success &= testRegister(regAddr, "regADDR", 0xfffffffff);
    success &= testRegister(regData, "regDATA", 0xfffffffff);
    success &= testRegister(regCIR,  "regCIR", 0xfffffffff);
    success &= testRegister(regTest, "regTEST");
    return success;
}

//!
//! Get Halt Status Word.
//!
//! This function return the contents of the Halt Status Block.
//!
//! \returns
//!     Contents of the Halt Status Block.
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
    haltStatusBlock.fe   = readMem(addr + 17);

    return haltStatusBlock;
}

//
//! @}
//
