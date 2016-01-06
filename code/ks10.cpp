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
// Copyright (C) 2013-2015 Rob Doyle
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option)
// any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
// more details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 59 Temple
// Place - Suite 330, Boston, MA 02111-1307, USA.
//
//******************************************************************************
//
//! \addtogroup ks10_api
//! @{
//

#include "epi.hpp"
#include "stdio.h"
#include "ks10.hpp"
#include "fatal.hpp"
#include "driverlib/rom.h"
#include "driverlib/gpio.h"
#include "driverlib/sysctl.h"
#include "driverlib/inc/hw_gpio.h"
#include "driverlib/inc/hw_ints.h"
#include "driverlib/inc/hw_types.h"
#include "driverlib/inc/hw_memmap.h"
#include "SafeRTOS/SafeRTOS_API.h"

#define GPIO_HALT_LED  GPIO_PIN_7

void (*ks10_t::consIntrHandler)(void);
void (*ks10_t::haltIntrHandler)(void);

//
//! Constructor
//!
//! The constructor initializes this object.
//!
//! For the most part, this function initializes the EPI object and configures
//! the GPIO for the console interrupt.
//!
//! We use PB7 for the Console Interrupt from the KS10.  Normally PB7 is the
//! NMI but we don't want NMI semantics.  Therefore this code configures PB7
//! to be a normal active low GPIO-based interrupt.
//!
//! We use PD7 for the Halt Interrupt.  It is triggered on both edges to detect
//! Halt transitions.
//

ks10_t::ks10_t(void (*consIntrHandler)(void), void (*haltIntrHandler)(void)) {
    ks10_t::consIntrHandler = consIntrHandler;
    ks10_t::haltIntrHandler = haltIntrHandler;

    EPIInitialize();

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

//
//! Halt Interrupt Wrapper
//

extern "C" void gpiodIntHandler(void) {
    (*ks10_t::haltIntrHandler)();
    ROM_GPIOPinIntClear(GPIO_PORTD_BASE, GPIO_PIN_7);
}

//
//! Console Interrupt Wrapper
//

extern "C" void gpiobIntHandler(void) {
    ROM_GPIOPinIntClear(GPIO_PORTB_BASE, GPIO_PIN_7);
    (*ks10_t::consIntrHandler)();
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
    writeRegStat(readRegStat() | statGO);
    for (int i = 0; i < 100; i++) {
        if ((readRegStat() & statGO) == 0) {
           return;
        }
        taskYIELD();
    }
    printf("GO-bit timeout\n");
}

//
//! This function reads from <b>Console Status Register</b>
//!
//! \returns
//!     Contents of the <b>Console Status Register</b>.
//

ks10_t::data_t ks10_t::readRegStat(void) {
    return readReg(regStat);
}

//
//! This function writes to <b>Console Status Register</b>
//!
//! \param data
//!     data to be written to the <b>Console Status Register</b>.
//

void ks10_t::writeRegStat(data_t data) {
    writeReg(regStat, data);
}

//
//! This function reads from <b>Console Address Register</b>
//!
//! \returns
//!     Contents of the <b>Console Address Register</b>.
//

ks10_t::data_t ks10_t::readRegAddr(void) {
    return readReg(regAddr);
}

//
//! This function writes to <b>Console Address Register</b>
//!
//! \param data
//!     data to be written to the <b>Console Address Register</b>.
//

void ks10_t::writeRegAddr(data_t data) {
    writeReg(regAddr, data);
}

//
//! This function reads from <b>Console Data Register</b>
//!
//! \returns
//!     Contents of the <b>Console Data Register</b>.
//

ks10_t::data_t ks10_t::readRegData(void) {
    return readReg(regData);
}

//
//! This function writes to <b>Console Data Register</b>
//!
//! \param data
//!     data to be written to the <b>Console Data Register</b>.
//

void ks10_t::writeRegData(data_t data) {
    writeReg(regData, data);
}

//
//! This function reads the <b>Console Instruction Register</b>
//!
//! \returns
//!     Contents of the <b>Console Instruction Register</b>
//

ks10_t::data_t ks10_t::readRegCIR(void) {
    return readReg(regCIR);
}

//
//! Function to write to the <b>Console Instruction Register</b>
//!
//! \param
//!     data is the data to be written to the <b>Console Instruction
//!     Register.</b>
//

void ks10_t::writeRegCIR(data_t data) {
    writeReg(regCIR, data);
}

//
//! This function to reads a 36-bit word from KS10 memory.
//!
//! \details
//!     This is a physical address write.  Writes to address 0 to 17 (octal)
//!     go to memory not to registers.
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
    writeReg(regAddr, (addr & memAddrMask) | flagRead | flagPhys);
    go();
    return dataMask & readReg(regData);
}

//
//! This function writes a 36-bit word to KS10 memory.
//!
//! \details
//!     This is a physical address write.  Writes to address 0 to 17 (octal)
//!     go to memory not to registers.
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
    writeReg(regAddr, (addr & memAddrMask) | flagWrite | flagPhys);
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
    writeReg(regAddr, (addr & ioAddrMask) | flagRead | flagPhys | flagIO);
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
    writeReg(regAddr, (addr & ioAddrMask) | flagWrite | flagPhys | flagIO);
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
    writeReg(regAddr, (addr & ioAddrMask) | flagRead | flagPhys | flagIO | flagByte);
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
    writeReg(regAddr, (addr & ioAddrMask) | flagWrite | flagPhys | flagIO | flagByte);
    writeReg(regData, data);
    go();
}

//
//! This function reads a 64-bit value from the DZCCR
//

uint64_t ks10_t::readDZCCR(void) {
    return *regDZCCR;
}

//
//! This function writes a 64-bit value to the DZCCR
//!
//! \param
//!     data is the data to be written to the DZCCR
//

void ks10_t::writeDZCCR(uint64_t data) {
    *regDZCCR = data;
}

//
//! This function reads a 64-bit value from the RHCCR
//

uint64_t ks10_t::readRHCCR(void) {
    return *regRHCCR;
}

//
//! This function writes a 64-bit value to the RHCCR
//!
//! \param
//!     data is the data to be written to the RHCCR
//

void ks10_t::writeRHCCR(uint64_t data) {
    *regRHCCR = data;
}

//
//! This function reads a 64-bit value from the breakpoint register
//

uint64_t ks10_t::readBRKPT(void) {
    return *regBRKPT;
}

//
//! This function writes a 64-bit value to the breakpoint register
//!
//! \param
//!     data is the data to be written to the breakpoint register
//

void ks10_t::writeBRKPT(uint64_t data) {
    *regBRKPT = data;
}

//
//! This function reads a 64-bit value from the trace register
//

uint64_t ks10_t::readTRACE(void) {
    return *regTRACE;
}

//
//! This function writes a 64-bit value to the trace register
//!
//! \param
//!     data is the data to be written to the trace register
//

void ks10_t::writeTRACE(uint64_t data) {
    *regTRACE = data;
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
//!     <b>true</b> if the KS10 is in <b>RUN</b> mode, <b>false</b> if the KS10
//!     is in <b>HALT</b> mode..
//

bool ks10_t::run(void) {
    return readReg(regStat) & statRUN;
}

//
//! This function checks the KS10 <b>CONT</b> status.
//!
//! This function examines the <b>CONT</b> bit in the <b>Console Control/Status
//! Register</b>.
//!
//! \returns
//!     <b>true</b> if the KS10 is in <b>CONT</b> mode, false otherwise.
//!
//

bool ks10_t::cont(void) {
    return readReg(regStat) & statCONT;
}

//
//! Execute a single instruction in the CIR
//
//

void ks10_t::execute(void) {
    writeReg(regStat, statCONT | statEXEC | readReg(regStat));
}

//
//! Execute a single instruction at the current PC
//

void ks10_t::step(void) {
    writeReg(regStat, statCONT | readReg(regStat));
}

//
//! Continue execution at the current PC.
//

void ks10_t::contin(void) {
    writeReg(regStat, statRUN | statCONT | readReg(regStat));
}

//
//! Begin execution with instruction in the CIR.
//

void ks10_t::begin(void) {
    data_t status = readReg(regStat);
    writeReg(regStat, status | statRUN | statCONT | statEXEC);
}

//
//! This function checks the KS10 <b>EXEC</b> status.
//!
//! This function examines the <b>EXEC</b> bit in the <b>Console Control/Status
//! Register</b>.
//!
//! \returns
//!     <b>true</b> if the KS10 is in <b>EXEC</b> mode, false otherwise.
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
    return ROM_GPIOPinRead(GPIO_PORTD_BASE, GPIO_HALT_LED) == GPIO_HALT_LED;
}

//
//! Boot the KS10
//!
//

void ks10_t::boot(void) {

    //
    // Unreset the CPU
    //

    if (!ks10_t::cpuReset()) {
        fatal("KS10 should be reset.\n");
    }

    if (ks10_t::halt()) {
        fatal("KS10 should not be halted.\n");
    }

    if (ks10_t::run()) {
        fatal("KS10 should not be running.\n");
    }

    ks10_t::cpuReset(false);

    if (ks10_t::cpuReset()) {
        fatal("KS10 should be unreset.\n");
    }

    if (ks10_t::halt()) {
        fatal("KS10 should not be halted.\n");
    }

    if (ks10_t::run()) {
        fatal("KS10 should not be running.\n");
    }
}

//
//! Wait for halt to be asserted.
//!
//! This function waits for upto one second for halt to be asserted.
//!
//! \returns
//!     This function returns true if halt is asserted within one second,
//!     false otherwise.
//

bool ks10_t::waitHalt(void) {
    for (int i = 0; i < 1000; i++) {
        if (ks10_t::halt()) {
            return true;
        }
        taskYIELD();
    }
    return false;
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
//! This function prints the firmware revision of the KS10 FPGA.
//!
//! The FPGA should respond with "REVxx.yy" where xx is the major revision and
//! yy is the minor revision.
//!
//! \returns
//!     True if the version string is valid, false otherwise.
//

bool ks10_t::printFirmwareRev(void) {
    const char *buf = regVers;
    if ((buf[0] == 'R') && (buf[1] == 'E') && (buf[2] == 'V') && (buf[5] == 0xae)) {
        printf("FPGA: Firmware is %c%c%c %c%c%c%c%c\n",
               buf[0] & 0x7f, buf[1] & 0x7f, buf[2] & 0x7f, buf[3] & 0x7f,
               buf[4] & 0x7f, buf[5] & 0x7f, buf[6] & 0x7f, buf[7] & 0x7f);
        return true;
    }
    return false;
}

//
//! Get Halt Status Word
//!
//! This function return the contents of the Halt Status Word.
//!
//! \returns
//!     Contents of the Halt Status Word
//

ks10_t::haltStatusWord_t &ks10_t::getHaltStatusWord(void) {
    static haltStatusWord_t haltStatusWord;

    haltStatusWord.status = readMem(0);
    haltStatusWord.pc     = readMem(1);

    return haltStatusWord;
}

//
//! This function tests a console interface register doing 64-bit
//! writes and reads.
//!
//! \returns
//!     True if test pass, false otherwise.
//

bool ks10_t::testReg64(volatile void * addr, const char *name, bool verbose, uint64_t mask) {
    if (verbose) {
        printf("FPGA:  %s: Checking 64-bit accesses.\n", name);
    }
    bool ret = true;
    volatile uint64_t * reg64 = (uint64_t*)addr;
    uint64_t write64 = 0;

    for (unsigned int i = 0; i < 9; i++) {
        *reg64 = write64;
        uint64_t read64 = *reg64;
        if (read64 != (write64 & mask)) {
            if (verbose) {
                printf("FPGA:  %s: Register failure.  Was 0x%016llx.  Should be 0x%016llx\n", name, read64, write64);
            }
            ret = false;
        }
        write64 = (write64 << 8) | 0xff;
    }
    *reg64 = 0;
    return ret;
}

//
//! This function tests a console interface register doing 8-bit
//! writes and 64-bit reads.  Writes use the byte lanes, reads
//! ignore the byte lanes.
//!
//! \returns
//!     True if test pass, false otherwise.
//

bool ks10_t::testReg08(volatile void * addr, const char *name, bool verbose, uint64_t mask) {

    if (verbose) {
        printf("FPGA:  %s: Checking 8-bit accesses.\n", name);
    }

    bool ret = true;
    volatile uint64_t * addr64 = (uint64_t *)addr;
    volatile uint8_t  * addr08 = (uint8_t  *)addr;

    uint64_t test64 = 0xffull;
    for (unsigned int i = 0; i < 9; i++) {
        *addr08 = 0xff;
        uint64_t read64 = *addr64;
        if (read64 != (test64 & mask)) {
            if (verbose) {
                printf("FPGA:  %s: Register failure.  Was 0x%016llx.  Should be 0x%016llx\n", name, read64, test64);
            }
            ret = false;
        }
        addr08++;
        test64 = (test64 << 8) | 0xff;
    }
    *addr64 = 0;
    return ret;
}

//
//!
//! This function tests a KS10 register
//!
//! \returns
//!     True if test pass, false otherwise.
//

bool ks10_t::testRegister(volatile void * addr, const char *name, bool verbose, uint64_t mask) {
    bool success = true;

    //
    // Save register contents
    //

    uint64_t save = readReg(addr);

    //
    // Perform tests
    //

    success &= testReg64(addr, name, verbose, mask);
    success &= testReg08(addr, name, verbose, mask);

    //
    // Restore register contents
    //

    writeReg(addr, save);
    return success;
}

//
//! Test all of the KS10 Registers
//!
//! \returns
//!     True if test pass, false otherwise.
//

bool ks10_t::testRegs(bool verbose) {
    bool success = true;
    if (verbose) {
        printf("FPGA: Testing KS10 Interface Registers.\n");
    }
    success &= testRegister(regAddr,  "regADDR",  verbose, 0xfffffffff);
    success &= testRegister(regData,  "regDATA",  verbose, 0xfffffffff);
    success &= testRegister(regCIR,   "regCIR ",  verbose, 0xfffffffff);
    success &= testRegister(regDZCCR, "regDZCCR", verbose);
    success &= testRegister(regRHCCR, "regRHCCR", verbose);
    success &= testRegister(regBRKPT, "regBRKPT", verbose);
    success &= testRegister(regTRACE, "regTRACE", verbose);
    if (success) {
        printf("FPGA: Register test completed successfully.\n");
    }
    return success;
}

//
//! Get Halt Status Word.
//!
//! This function return the contents of the Halt Status Block.
//!
//! \returns
//!     Contents of the Halt Status Block.
//!
//! \note
//!     The KS10 Technical Manual shows that the Halt Status Block include the
//!     FE and SC register.  This is incorrect.   See ksrefRev2 document.
//

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

//
//! Get Contents of RH11 Debug Register
//!
//! This function return the contents of the RH11 Debug Register
//!
//! \returns
//!     Contents of the RH11 Debug Register
//

volatile ks10_t::rh11debug_t * ks10_t::getRH11debug(void) {
    return regRH11Debug;
}

//
// Write a character to the KS10
//

void ks10_t::putchar(int ch) {
    data_t cty_in = readMem(ctyin_addr);
    if ((cty_in & cty_valid) == 0) {
        ks10_t::writeMem(ctyin_addr, cty_valid | (ch & 0xff));
        ks10_t::cpuIntr();
    }
}

//
// Read a character from the KS10
//

int ks10_t::getchar(void) {
    data_t cty_out = readMem(ctyout_addr);
    if ((cty_out & cty_valid) != 0) {
        writeMem(ctyout_addr, 0);
        return cty_out & 0x7f;
    } else {
        return -1;
    }
}

//
//! @}
//
