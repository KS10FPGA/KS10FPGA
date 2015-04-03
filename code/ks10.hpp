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
// Copyright (C) 2013-2014 Rob Doyle
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
        //! RH11 Debug Register
        //

        struct rh11debug_t {
            uint8_t status;                             //!< Status (LSB)
            uint8_t res1;                               //!< Reserved
            uint8_t res2;                               //!< Reserved
            uint8_t wrcnt;                              //!< Write count
            uint8_t rdcnt;                              //!< Read count
            uint8_t val;                                //!< Error value
            uint8_t state;                              //!< Controller state
            uint8_t err;                                //!< Error number (MSB)
        };

        //
        // Opcodes
        //

        static const uint32_t opJRST  = 0254000;        //!< JRST Instruction
        static const uint32_t opRDHSB = 0702300;        //!< RDHSB Instruction

        //
        // KS10 addresses
        //

        static const addr_t invalidAddr = (addr_t) -1;  //!< Guaranteed invalid address
        static const addr_t memStart    = 0;            //!< Start of memory.
        static const addr_t maxVirtAddr = 000777777;    //!< Last virtual address (18-bit)
        static const addr_t maxMemAddr  = 003777777;    //!< Last memory address (20-bit)
        static const addr_t maxIOAddr   = 017777777;    //!< Last IO address (22-bit)
        static const data_t dataMask    = 0777777777777;

        //
        // Functions
        //

                                           ks10_t(void (*)(void));
        static          uint32_t           lh(data_t data);
        static          uint32_t           rh(data_t data);
        static          data_t             readRegStat(void);
        static          void               writeRegStat(data_t data);
        static          data_t             readRegAddr(void);
        static          void               writeRegAddr(data_t data);
        static          data_t             readRegData(void);
        static          void               writeRegData(data_t data);
        static          data_t             readRegCIR(void);
        static          void               writeRegCIR(data_t data);
        static          data_t             readMem(addr_t addr);
        static          void               writeMem(addr_t addr, data_t data);
        static          data_t             readIO(addr_t addr);
        static          void               writeIO(addr_t addr, data_t data);
        static          uint16_t           readIObyte(addr_t addr);
        static          void               writeIObyte(addr_t addr, uint16_t data);
        static          void               run(bool enable);
        static          bool               run(void);
        static          void               cont(bool enable);
        static          bool               cont(void);
        static          void               exec(bool enable);
        static          bool               exec(void);
        static          bool               halt(void);
        static          bool               waitHalt(void);
        static          bool               timerEnable(void);
        static          void               timerEnable(bool enable);
        static          bool               trapEnable(void);
        static          void               trapEnable(bool enable);
        static          bool               cacheEnable(void);
        static          void               cacheEnable(bool enable);
        static          bool               cpuReset(void);
        static          void               cpuReset(bool enable);
        static          void               cpuIntr(void);
        static          bool               nxmnxd(void);
        static          bool               testRegs(void);
        static          haltStatusWord_t  &getHaltStatusWord(void);
        static          haltStatusBlock_t &getHaltStatusBlock(addr_t addr);
        static volatile rh11debug_t       *getRH11debug(void);
        static const    char              *getFirmwareRev(void);
        static          void              (*consIntrHandler)(void);

    private:

        //
        // Misc constants
        //

        static const uint32_t epiOffset = 0x60000000;           //!< EPI Address Offset
        static const addr_t   memAddrMask = 003777777ULL;       //!< KS10 20-bit Address Mask
        static const addr_t   ioAddrMask  = 017777777ULL;       //!< KS10 22-bit Address Mask

        //
        // KS10 Read/Write Address Modes
        //

        static const addr_t flagRead  = 0x100000000ULL;         //!< Read flags
        static const addr_t flagWrite = 0x040000000ULL;         //!< Write flags
        static const addr_t flagPhys  = 0x008000000ULL;         //!< Phys
        static const addr_t flagIO    = 0x002000000ULL;         //!< IO flag
        static const addr_t flagByte  = 0x000400000ULL;         //!< BYTE IO flag

        //
        // KS10 FPGA Register Addresses
        //

        //!< KS10 Address Register
        static constexpr volatile void * regAddr = reinterpret_cast<void *>(epiOffset + 0x00);

        //!< KS10 Data Register
        static constexpr volatile void * regData = reinterpret_cast<volatile void *>(epiOffset + 0x08);

        //!< KS10 Status Register
        static constexpr volatile void * regStat = reinterpret_cast<volatile void *>(epiOffset + 0x10);

        //!< KS10 Console Instruction Register
        static constexpr volatile void * regCIR  = reinterpret_cast<void *>(epiOffset + 0x18);

        //!< KS10 Test Register
        static constexpr volatile void * regTest = reinterpret_cast<void *>(0x60000000 + 0x20);

        //!< RH11 Debug Register
        static constexpr volatile rh11debug_t * regRH11Debug = reinterpret_cast<volatile rh11debug_t *>(epiOffset + 0x30);

        //!< Firmware Version Register
        static constexpr const char * regVers = reinterpret_cast<const char *>(epiOffset + 0x38);

        //
        // Low level interface functions
        //

        static data_t readReg(volatile void * reg);
        static void   writeReg(volatile void * reg, data_t data);
        static void   go(void);
        static bool   testReg08(volatile void * addr, const char *name, uint64_t mask);
        static bool   testReg64(volatile void * addr, const char *name, uint64_t mask);
        static bool   testRegister(volatile void * addr, const char *name, uint64_t mask = 0xffffffffffffffffull);

        //
        // Control/Status Register Bits
        //

        static const data_t statGO      = 0x00010000UL;
        static const data_t statNXMNXD  = 0x00000200UL;
        static const data_t statHALT    = 0x00000100UL;
        static const data_t statRUN     = 0x00000080UL;
        static const data_t statCONT    = 0x00000040UL;
        static const data_t statEXEC    = 0x00000020UL;
        static const data_t statTIMEREN = 0x00000010UL;
        static const data_t statTRAPEN  = 0x00000008UL;
        static const data_t statCACHEEN = 0x00000004UL;
        static const data_t statINTR    = 0x00000002UL;
        static const data_t statRESET   = 0x00000001UL;
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

inline ks10_t::data_t ks10_t::readReg(volatile void * reg) {
    return *reinterpret_cast<volatile data_t*>(reg);
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

inline void ks10_t::writeReg(volatile void * reg, data_t data) {
    *reinterpret_cast<volatile data_t *>(reg) = data;
}

#endif
