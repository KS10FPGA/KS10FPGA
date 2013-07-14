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
//! KS10 Interface Object
//!

class ks10_t {
    public:

        //
        // KS10 Address and Data Type
        //

        typedef uint64_t addr_t;                        //!< KS10 Address Typedef
        typedef uint64_t data_t;                        //!< KS10 Data Typedef

        //
        //! Halt Status Word Type
        //

        struct haltStatusWord_t {
            data_t status;                              //!< Halt Status
            data_t pc;                                  //!< Halt Program Counter
        };

        //
        //! Halt Status Block Type
        //

        struct haltStatusBlock_t {
            data_t mag;                                 //!< Magnitude Mask
            data_t pc;                                  //!< Program Counter
            data_t hr;                                  //!< Instruction Register
            data_t ar;                                  //!< AR Register
            data_t arx;                                 //!< ARX Register
            data_t br;                                  //!< BR Register
            data_t brx;                                 //!< BRX Register
            data_t one;                                 //!< ONE Register
            data_t ebr;                                 //!< EBR Register
            data_t ubr;                                 //!< UBR Register
            data_t mask;                                //!< Mask Register
            data_t flg;                                 //!< Flag Register
            data_t pi;                                  //!< PI Register
            data_t x1;                                  //!< X1 Register
            data_t t0;                                  //!< T0 Register
            data_t t1;                                  //!< T1 Register
            data_t vma;                                 //!< VMA Register
            data_t fe;                                  //!< FE Register
        };

        //
        // Opcodes
        //

        static const uint32_t opJRST = 0254000;         //!< JRST Instruction

        //
        // KS10 addresses
        //

        static const addr_t invalidAddr = (addr_t) -1;  //!< Guaranteed invalid address
        static const addr_t maxVirtAddr = 000777777;    //!< Last virtual address (18-bit)
        static const addr_t maxMemAddr  = 003777777;    //!< Last memory address (20-bit)
        static const addr_t maxIOAddr   = 017777777;    //!< Last IO address (22-bit)
        static const data_t dataMask    = 0777777777777;

        //
        // Functions
        //

        ks10_t(void (*)(void));
        static uint32_t lh(data_t data);
        static uint32_t rh(data_t data);
        static data_t   readStatus(void);
        static void     writeStatus(data_t data);
        static data_t   readCIR(void);
        static void     writeCIR(data_t data);
        static data_t   readMem(addr_t addr);
        static void     writeMem(addr_t addr, data_t data);
        static data_t   readIO(addr_t addr);
        static void     writeIO(addr_t addr, data_t data);
        static uint16_t readIObyte(addr_t addr);
        static void     writeIObyte(addr_t addr, uint16_t data);
        static void     run(bool enable);
        static bool     run(void);
        static void     halt(bool enable);
        static bool     halt(void);
        static void     step(void);
        static void     exec(void);
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
        static bool     nxmnxd(void);
        static haltStatusWord_t  &getHaltStatusWord(void);
        static haltStatusBlock_t &getHaltStatusBlock(addr_t addr);
        static const char *getFirmwareRev(void);
        static void     (*consIntrHandler)(void);

    private:

        //
        // Misc constants
        //

        static const uint32_t epiOffset = 0x60000000;   //!< EPI Address Offset
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

        static constexpr uint8_t * const regAddr      =
            reinterpret_cast<uint8_t * const>(epiOffset + 0x00); //!< KS10 Address Register
        static constexpr uint8_t * const regData      =
            reinterpret_cast<uint8_t * const>(epiOffset + 0x10); //!< KS10 Data Register
        static constexpr uint8_t * const regStat      =
            reinterpret_cast<uint8_t * const>(epiOffset + 0x20); //!< KS10 Status Regsiter
        static constexpr uint8_t * const regCIR       =
            reinterpret_cast<uint8_t * const>(epiOffset + 0x30); //!< KS10 Console Instruction Register
        static constexpr uint8_t * const regRH11debug =
            reinterpret_cast<uint8_t * const>(epiOffset + 0xe8); //!< RH11 Debug Register
        static constexpr uint8_t * const regFirmwareVersion =
            reinterpret_cast<uint8_t * const>(epiOffset + 0xf8); //!< Firmware Version Register

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
        static const uint8_t statNXMNXD  = 0x01;
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
//! This function reads a byte from the FPGA
//!
//! The address is the register address mapped through the EPI.
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
//! The address is the register address mapped through the EPI.
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
//! The address is the register address mapped through the EPI.
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
//! The address is the register address mapped through the EPI.
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
//!  This function returns the state of the <b>NXM/NXD</b> bit of the
//!  <b>Console Control/Status Register</b>.
//!
//!  This function will reset the state of the <b>NXM/NXD</b> bit once it is
//!  read.
//

inline bool ks10_t::nxmnxd(void) {
    bool ret = readByte(regStat + 1) & statNXMNXD;
    writeByte(regStat + 1, 0);
    return ret;
}

#endif
