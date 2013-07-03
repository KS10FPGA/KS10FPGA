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
//!    ks10.hpp
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

#ifndef __KS10_H
#define __KS10_H

#include <stdint.h>

//!
//! \brief
//!     KS10 Interface Object
//!

class ks10_t
{

    public:

        //
        // KS10 Address and Data Type
        //

        typedef uint64_t addr_t;              		//!< KS10 Address Typedef
        typedef uint64_t data_t;                	//!< KS10 Data Typedef

        // 
        //! Halt Status Word Type
        //

        struct haltStatusWord_t
        {
            data_t status;				//!< Halt Status
            data_t pc;					//!< Halt Program Counter
        };

        //
        //! Halt Status Block Type
        //

        struct haltStatusBlock_t
        {
            data_t mag;					// x +  0
            data_t pc;					// x +  1
            data_t hr;					// x +  2
            data_t ar;					// x +  3
            data_t arx;					// x +  4
            data_t br;					// x +  5
            data_t brx;					// x +  6
            data_t one;					// x +  7
            data_t ebr;					// x + 10
            data_t ubr;					// x + 11
            data_t mask;				// x + 12
            data_t flg;					// x + 13
            data_t pi;					// x + 14
            data_t x1;					// x + 15
            data_t t0;					// x + 16
            data_t t1;					// x + 17
            data_t vma;					// x + 20
            data_t fe;					// x + 21
        };

        //
        // Opcodes
        //

        static const uint32_t opJRST = 0254000;     	//!< JRST Instruction

        //
        // KS10 addresses
        //

        static const addr_t invalidAddr = (addr_t) -1;	//!< Guaranteed invalid address
        static const addr_t maxVirtAddr = 000777777; 	//!< Last virtual address (18-bit)
        static const addr_t maxMemAddr  = 003777777; 	//!< Last memory address (20-bit)
        static const addr_t maxIOAddr   = 017777777;	//!< Last IO address (22-bit)

        //
        // Functions
        //
 
        ks10_t(void);
        static data_t   readStatus(void);
        static data_t   readCIR(void);
        static data_t   readMem(addr_t addr);
        static data_t   readIO(addr_t addr);
        static uint8_t  readIObyte(addr_t addr);
        static void     writeStatus(data_t data);
        static void     writeCIR(data_t data); 
        static void     writeMem(addr_t addr, data_t data);
        static void     writeIO(addr_t addr, data_t data);
        static void     writeIObyte(addr_t addr, uint8_t data);
        static void     run(bool);
        static bool     run(void);
        static void     halt(bool enable);
        static bool     halt(void);
        static void     step(void);
        static void     exec(bool enable);
        static bool     exec(void);
        static void     cont(void);
        static bool     timerEnable(void);
        static void     timerEnable(bool enable);
        static bool     trapEnable(void);
        static void     trapEnable(bool enable);
        static bool     cacheEnable(void);
        static void     cacheEnable(bool enable);
        static bool     cpuReset(void);
        static void     cpuReset(bool enable);
        static void     cpuIntr(void);
        static void     delay(void);
        static uint32_t lh(data_t data);
        static uint32_t rh(data_t data);
        static haltStatusWord_t  &getHaltStatusWord(void);
        static haltStatusBlock_t &getHaltStatusBlock(addr_t addr);
        static unsigned int deviceAddr(addr_t);
        static data_t   rdword(const uint8_t *b);
    private:

        //
        // Misc constants
        //

        static const uint32_t epiOffset = 0x60000000;	//!< EPI Address Offset
        static const addr_t   addrMask  = 0x0fffffULL;  //!< KS10 20-bit Address Mask

        //
        // KS10 Read/Write Address Modes
        //

        static const addr_t read  = 0x100000000ULL;     //!< Read flags
        static const addr_t write = 0x040000000ULL;     //!< Write flags
        static const addr_t io    = 0x002000000ULL;     //!< IO flag
        static const addr_t byte  = 0x000400000ULL;     //!< BYTE IO flag

        //
        // KS10 FPGA Register Addresses
        //

        static constexpr uint8_t * const regAddr      = reinterpret_cast<uint8_t * const>(epiOffset + 0x00); //!< KS10 Address Register
        static constexpr uint8_t * const regData      = reinterpret_cast<uint8_t * const>(epiOffset + 0x10); //!< KS10 Data Register
        static constexpr uint8_t * const regStat      = reinterpret_cast<uint8_t * const>(epiOffset + 0x20); //!< KS10 Status Regsiter
        static constexpr uint8_t * const regCIR       = reinterpret_cast<uint8_t * const>(epiOffset + 0x30); //!< KS10 Console Instruction Register
        static constexpr uint8_t * const regRH11debug = reinterpret_cast<uint8_t * const>(epiOffset + 0xf0); //!< RH11 Debug Register

        //
        // Low level interface functions
        //

        static uint8_t readByte(const uint8_t * reg);
        static void    writeByte(uint8_t * reg, uint8_t data);
        static data_t  readReg(const uint8_t * reg);
        static void    writeReg(uint8_t * reg, data_t data);
        static void    go(void);

        //
        // Register Bits
        //

        static const uint8_t statGO      = 0x01;
        static const uint8_t statHALT    = 0x01;
        static const uint8_t statCACHEEN = 0x01;
        static const uint8_t statRESET   = 0x01;
        static const uint8_t statCONT    = 0x02;
        static const uint8_t statINTR    = 0x02;
        static const uint8_t statTRAPEN  = 0x02;
        static const uint8_t statEXEC    = 0x04;
        static const uint8_t statTIMEREN = 0x04;
        static const uint8_t statSTEP    = 0x08;
        static const uint8_t statRUN     = 0x10;
};

//
//! Constructor
//!
//! The constructor initializes this object.
//


inline ks10_t::ks10_t(void) {
    ;
}

//
//! This function reads a byte from the FPGA
//! 
//! The address is the register address \e mapped through the EPI.
//!
//! This is a low-level function.  There probably isn't any reason for an
//! application to access this function directly.
//! 
//! \param reg -
//!     address of the register.
//!
//! \returns
//!      Register contents.
//

inline uint8_t ks10_t::readByte(const uint8_t *reg) {
    return *reg;
}

//
//! This function writes a byte to the FPGA
//!
//! The address is the register address \e mapped through the EPI.
//!
//! This is a low-level function.  There probably isn't any reason for an
//! application to access this function directly.
//! 
//! \param
//!     reg is the address of the register.
//!
//! \param
//!     data is the data to be written to the register.
//

inline void ks10_t::writeByte(uint8_t * reg, uint8_t data) {
    *reg = data;
}

//
//! This function reads a 36-bit register from FPGA.
//!
//! The address is the register address \e mapped through the EPI.
//!
//! This is a low-level function.  There probably isn't any reason for an
//! application to access this function directly.
//! 
//! \param
//!     reg is the base address of the register.
//!
//! \returns
//!     Register contents.
//

inline ks10_t::data_t ks10_t::readReg(const uint8_t * reg) {
    return *reinterpret_cast<const data_t*>(reg);
}

//
//! This function writes to a 36-bit register in the FPGA.
//!
//! The address is the register address \e mapped through the EPI.
//!
//! This is a low-level function.  There probably isn't any reason for an
//! application to access this function directly.
//! 
//! \param
//!     reg is the base address of the register.
//!
//! \param
//!     data is the data to be written to the register.
//

inline void ks10_t::writeReg(uint8_t * reg, data_t data) {
    *reinterpret_cast<data_t *>(reg) = data;
}

//
//! This function writes to <b>Console Status Register</b>
//!
//! \param data
//!     data to be written to the <b>Console Status Register</b>.
//

inline void ks10_t::writeStatus(data_t data) {
    writeReg(regStat, data); 
}

//
//! This function reads from <b>Console Status Register</b>
//! 
//! \returns
//!     Contents of the <b>Console Status Register</b>.
//

inline ks10_t::data_t ks10_t::readStatus(void) {
    return readReg(regStat);
}

//
//! \brief
//!     Function to write to the <b>Console Instruction Register</b>
//!
//! \param
//!     data is the data to be written to the <b>Console Instruction
//!     Register.</b>
//

inline void ks10_t::writeCIR(data_t data) {
    writeReg(regCIR, data); 
}

//!
//! \brief
//!     This function reads from the <b>Console Instruction Register</b>
//! 
//! \returns
//!     Contents of the <b>Console Instruction Register</b>
//!

inline ks10_t::data_t ks10_t::readCIR(void) {
    return readReg(regCIR);
}

//
//!  This function starts and completes a KS10 bus transaction
//!
//!  A KS10 FPGA bus cycle begins when the <b>GO</b> bit is asserted.  The
//!  <b>GO</b> bit will remain asserted while the bus cycle is still active. 
//!  The <b>Console Data Register</b> should not be accessed when the <b>GO</b>
//!  bit is asserted.
//!
//!  This is a low-level function.  There probably isn't any reason for an
//!  application to access this function directly.
//

inline void ks10_t::go(void) {
    writeByte(regStat + 3, statGO);
    while (readByte(regStat + 3) & statGO) {
        ;
    }
}

//
//! This function spins for a short delay
//!
//! This is a low-level function.  There probably isn't any reason for an 
//! application to access this function directly.
//

inline void ks10_t::delay(void) {
    for (int i = 0; i < 1000; i++) {
        ;
    }
}

//
//! This function puts the KS10 in <b>HALT</b> mode.
//!
//! This function momentarily pulses the <b>HALT</b> bit of the <b>Console
//! Control/Status Register.</b>
//!
//! The <b>HALT</b> bit only need to be asserted for a single FPGA clock
//! cycle in order to enter <b>HALT</b> mode.
//!
//! \param enable -
//!     Must be true to alter the operation of the KS10.
//

inline void ks10_t::halt(bool enable) {
    if (enable) {
        uint8_t status = readByte(regStat + 5);
        writeByte(regStat + 5, status | statHALT);
    }
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

inline bool ks10_t::halt(void) {
    return readByte(regStat + 5) & statHALT;
}

//
//! This function <b>CONTINUEs</b> the KS10.
//!
//! This function momentarily pulses the <b>CONT</b> bit of the <b>Console
//! Control/Status Register</b>.
//!
//! The <b>CONT</b> bit only need to be asserted for a single FPGA clock
//! cycle in order to resume operation.
//

inline void ks10_t::cont(void) {
    uint8_t status = readByte(regStat + 5);
    writeByte(regStat + 5, status | statCONT);
}

//
//! This function sets the KS10 in <b>Execute Mode</b>.
//!
//! \param
//!     enable sets the state of the KS10 <b>Execute Mode</b>.
//

inline void ks10_t::exec(bool enable) {
    uint8_t status = readByte(regStat + 5);
    writeByte(regStat + 6, enable ? (status | statEXEC) : (status & ~statEXEC));
}

//
//! This function returns the status of the KS10 <b>Execute Mode</b>.
//!
//! \returns
//!      True if KS10 is in <b>Execute Mode</b>, false otherwise.
//!

inline bool ks10_t::exec(void) {
    return readByte(regStat + 5) & statEXEC;
}

//
//! This function <b>STEPs</b> the KS10.
//!
//! This function momentarily pulses the <b>STEP</b> bit of the <b>Console
//! Control/Status Register</b>.
//!
//! The <b>STEP</b> bit only need to be asserted for a single FPGA clock cycle
//! in order to single-step the KS10.
//

inline void ks10_t::step(void) {
    uint8_t status = readByte(regStat + 5);
    writeByte(regStat + 5, status | statSTEP);
}

//!
//! This function puts the KS10 in <b>RUN</b> mode.
//!
//! This function momentarily pulses the <b>RUN</b> bit of the <b>Console
//! Control/Status Register</b>.
//!
//! The <b>RUN</b> bit only need to be asserted for a single FPGA clock cycle
//! in order to single-step the KS10.
//!
//! \param enable -
//!     Must be true to alter the operation of the KS10.
//

inline void ks10_t::run(bool enable) {
    if (enable) {
        uint8_t status = readByte(regStat + 5);
        writeByte(regStat + 5, status | statRUN);
    }
}

//
//! This function checks the KS10 in <b>RUN</b> status.
//!
//! This function examines the <b>RUN</b> bit in the <b>Console Control/Status
//! Register</b>. 
//!
//! \returns
//!     This function returns true if the KS10 is running, false
//!     otherwise.
//

inline bool ks10_t::run(void) {
    return readByte(regStat + 5) & statRUN;
}

//
//! This function returns the status of the KS10 interval timer.
//!
//! \returns
//!     True if the KS10 interval timer is enabled.
//

inline bool ks10_t::timerEnable(void) {
    return readByte(regStat + 6) & statTIMEREN;
}

//
//! This function enables the KS10 interval timer.
//!
//! \param
//!     enable - when true, enables the interval timer.
//

inline void ks10_t::timerEnable(bool enable) {
    uint8_t status = readByte(regStat + 6);
    writeByte(regStat + 6, enable ? (status | statTIMEREN) : (status & ~statTIMEREN));
}

//
//! This function returns the status of the KS10 traps.
//!
//! \returns
//!     True if the KS10 traps enabled.
//

inline bool ks10_t::trapEnable(void) {
    return readByte(regStat + 6) & statTRAPEN;
}

//
//!  This function enables the KS10 traps.
//!
//! \param
//!     enable - when true, enables the KS10 traps.
//

inline void ks10_t::trapEnable(bool enable) {
    uint8_t status = readByte(regStat + 6);
    writeByte(regStat + 6, enable ? (status | statTRAPEN) : (status & ~statTRAPEN));
}

//
//! This function returns the status of the KS10 cache.
//!
//! \returns
//!     True if the KS10 cache enabled.
//

inline bool ks10_t::cacheEnable(void) {
    return readByte(regStat + 6) & statCACHEEN;
}

//
//! This function enables the KS10 cache.
//!
//! \param
//!     enable - when true, enables the KS10 cache.
//

inline void ks10_t::cacheEnable(bool enable) {
    uint8_t status = readByte(regStat + 6);
    writeByte(regStat + 6, enable ? (status | statCACHEEN) : (status & ~statCACHEEN));
}

//
//! This function returns the status of the KS10 reset.
//!
//! \returns
//!     True if the KS10 is held in reset.
//

inline bool ks10_t::cpuReset(void) {
    return readByte(regStat + 6) & statRESET;
}

//
//! This function controls the KS10 reset.
//!
//! \param
//!     enable - when true, holds the KS10 in reset.
//

inline void ks10_t::cpuReset(bool enable) {
    uint8_t status = readByte(regStat + 6);
    writeByte(regStat + 6, enable ? (status | statRESET) : (status & ~statRESET));
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

inline void ks10_t::cpuIntr(void) {
    uint8_t status = readByte(regStat + 6);
    writeByte(regStat + 6, status | statINTR);
}

//
//! This function returns the left-half of a data word
//!
//! \param
//!     data is the value of the 36-bit word
//!
//! \returns
//!     18-bit left-half of 36-bit data word
//

inline uint32_t ks10_t::lh(data_t data) {
    return ((data >> 18) & 0777777);
}

//
//! This function returns the right-half of a data word
//!
//! \param
//!     data is the value of the 36-bit word
//!
//! \returns
//!     18-bit right-half of 36-bit data word
//

inline uint32_t ks10_t::rh(data_t data) {
    return (data & 0777777);
}

//
//! Returns the Unibus device, if there is one.
//!
//! This function the Unbus Device given a PDP10 address.
//!
//! \returns
//!     Unibus Devices
//!

inline unsigned int ks10_t::deviceAddr(addr_t addr) {
    return (addr >> 18) & 017;
}

#endif
