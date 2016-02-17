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
//!    ks10.hpp
//!
//! \author
//!    Rob Doyle - doyle (at) cox (dot) net
//
//******************************************************************************
//
// Copyright (C) 2013-2016 Rob Doyle
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
        };

        //
        //! RH11 Debug Register
        //

        struct rh11debug_t {
            uint8_t res3;                               //!< Reserved
            uint8_t res2;                               //!< Reserved
            uint8_t res1;                               //!< Reserved
            uint8_t rdcnt;                              //!< Read count
            uint8_t wrcnt;                              //!< Write count
            uint8_t val;                                //!< Error value
            uint8_t err;                                //!< Error number (MSB)
            uint8_t state;                              //!< Controller state
        };

        //
        // Opcodes
        //

        static const data_t opJRST  = 0254000;          //!< JRST Instruction
        static const data_t opRDHSB = 0702300;          //!< RDHSB Instruction

        //
        // KS10 addresses
        //

        static const addr_t invalidAddr = (addr_t) -1;  //!< Guaranteed invalid address
        static const addr_t memStart    = 0;            //!< Start of memory.
        static const addr_t maxVirtAddr = 000777777;    //!< Last virtual address (18-bit)
        static const addr_t maxMemAddr  = 003777777;    //!< Last memory address (20-bit)
        static const addr_t maxIOAddr   = 017777777;    //!< Last IO address (22-bit)
        static const data_t dataMask    = 0777777777777;//!< 36-bit mask

        //
        // Communications block addresses
        //

        static const addr_t switch_addr = 000030;       //!< Switch address
        static const addr_t kasw_addr   = 000031;       //!< Keep alive address
        static const addr_t ctyin_addr  = 000032;       //!< CTY input address
        static const addr_t ctyout_addr = 000033;       //!< CTY output address
        static const addr_t klnin_addr  = 000034;       //!< KLINIK input address
        static const addr_t klnout_addr = 000035;       //!< KLINIK output address
        static const addr_t rhbase_addr = 000036;       //!< RH11 base address
        static const addr_t rhunit_addr = 000037;       //!< RH11 unit number
        static const addr_t mtparm_addr = 000040;       //!< Magtape parameters

        static const data_t cty_valid   = 0x100;        //!< Input/Output character valid

        //
        // Functions
        //

        ks10_t(void);
        static void enableInterrupts (void (*consIntrHandler)(void), void (*haltIntrHandler)(void));
        static uint32_t lh(data_t data);
        static uint32_t rh(data_t data);
        static data_t readRegStat(void);
        static void writeRegStat(data_t data);
        static data_t readRegAddr(void);
        static void writeRegAddr(data_t data);
        static data_t readRegData(void);
        static void writeRegData(data_t data);
        static data_t readRegCIR(void);
        static void writeRegCIR(data_t data);
        static data_t readMem(addr_t addr);
        static void writeMem(addr_t addr, data_t data);
        static data_t readIO(addr_t addr);
        static void writeIO(addr_t addr, data_t data);
        static uint16_t readIObyte(addr_t addr);
        static void writeIObyte(addr_t addr, uint16_t data);
        static uint64_t readDZCCR(void);
        static void writeDZCCR(uint64_t data);
        static uint64_t readRHCCR(void);
        static void writeRHCCR(uint64_t data);
        static data_t readDCSR(void);
        static void writeDCSR(data_t data);
        static data_t readDBAR(void);
        static void writeDBAR(data_t data);
        static data_t readDBMR(void);
        static void writeDBMR(data_t data);
        static data_t readDITR(void);
        static bool run(void);
        static void run(bool);
        static bool cont(void);
        static bool exec(void);
        static bool halt(void);
        static void execute(void);
        static void step(void);
        static void contin(void);
        static void begin(void);
        static void boot(bool debug);
        static void waitHalt(bool debug);
        static bool timerEnable(void);
        static void timerEnable(bool enable);
        static bool trapEnable(void);
        static void trapEnable(bool enable);
        static bool cacheEnable(void);
        static void cacheEnable(bool enable);
        static bool cpuReset(void);
        static void cpuReset(bool enable);
        static void cpuIntr(void);
        static bool nxmnxd(void);
        static void testRegs(bool debug);
        static haltStatusWord_t &getHaltStatusWord(void);
        static haltStatusBlock_t &getHaltStatusBlock(addr_t addr);
        static uint64_t getRH11debug(void);
        static void programFirmware(bool debug);
        static void checkFirmware(bool debug);
        static void (*consIntrHandler)(void);
        static void (*haltIntrHandler)(void);
        static void putchar(int ch);
        static int getchar(void);

    private:

        //
        // Misc constants
        //

        static const uint32_t epiOffset   = 0x60000000;         //!< EPI Address Offset
        static const addr_t   memAddrMask = 003777777ULL;       //!< KS10 20-bit Address Mask
        static const addr_t   ioAddrMask  = 017777777ULL;       //!< KS10 22-bit Address Mask

        //
        // KS10 Read/Write Address Modes
        //

        static const addr_t flagFetch = 0x200000000ULL;         //!< Fetch flags
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
        static constexpr volatile void * regStat = reinterpret_cast<void *>(epiOffset + 0x10);

        //!< KS10 Console Instruction Register
        static constexpr volatile void * regCIR  = reinterpret_cast<void *>(epiOffset + 0x18);

        //!< DZ11 Console Control Register
        static constexpr volatile uint64_t * regDZCCR = reinterpret_cast<uint64_t *>(epiOffset + 0x20);

        //!< RH11 Console Control Register
        static constexpr volatile uint64_t * regRHCCR = reinterpret_cast<uint64_t *>(epiOffset + 0x28);

        //!< RH11 Debug Register
        static constexpr volatile uint64_t * regRH11Debug = reinterpret_cast<uint64_t *>(epiOffset + 0x30);

        //!< Debug Control/Status Register
        static constexpr volatile uint64_t * regDCSR = reinterpret_cast<uint64_t *>(epiOffset + 0x38);

        //!< Debug Breakpoint Address Register
        static constexpr volatile uint64_t * regDBAR = reinterpret_cast<uint64_t *>(epiOffset + 0x40);

        //!< Debug Breakpoint Mask Register
        static constexpr volatile uint64_t * regDBMR = reinterpret_cast<uint64_t *>(epiOffset + 0x48);

        //!< Debug Instruction Trace Register
        static constexpr volatile uint64_t * regDITR = reinterpret_cast<uint64_t *>(epiOffset + 0x50);

        //!< Firmware Version Register
        static constexpr const char * regVers = reinterpret_cast<const char *>(epiOffset + 0x78);

        //
        // Low level interface functions
        //

        static void go(void);
        static data_t readReg64(volatile void * reg);
        static void writeReg64(volatile void * reg, data_t data);
        static bool testReg64(volatile void * addr, const char *name, bool verbose, uint64_t mask = 0xffffffffffffffffull);

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

    public:

        //
        // Debug Control/Status Register Constants
        //

        static const data_t dcsrBREN_RES = 0x00000c000ULL;
        static const data_t dcsrBREN_TBF = 0x000008000ULL;
        static const data_t dcsrBREN_MAT = 0x000004000ULL;
        static const data_t dcsrBREN_DIS = 0x000000000ULL;
        static const data_t dcsrTREN_RES = 0x0000000c0ULL;
        static const data_t dcsrTREN_EN  = 0x000000080ULL;
        static const data_t dcsrTREN_MAT = 0x000000040ULL;
        static const data_t dcsrTREN_DIS = 0x000000000ULL;
        static const data_t dcsrTRACQ    = 0x000000008ULL;
        static const data_t dcsrFULL     = 0x000000004ULL;
        static const data_t dcsrEMPTY    = 0x000000002ULL;
        static const data_t dcsrRESET    = 0x000000001ULL;

        //
        // Debug Breakpoint Address Register Constants
        //

        static const data_t dbarFETCH  = (flagFetch | flagRead          );
        static const data_t dbarMEMRD  = (            flagRead          );
        static const data_t dbarMEMWR  = (            flagWrite         );
        static const data_t dbarIORD   = (            flagRead  | flagIO);
        static const data_t dbarIOWR   = (            flagWrite | flagIO);

        //
        // Debug Breakpoint Mask Register Constants
        //

        static const data_t dbmrMEM    = 003777777ULL;          // 1024K
        static const data_t dbmrIO     = 017777777ULL;

        static const data_t dbmrFETCH  = (flagFetch | flagRead          );
        static const data_t dbmrMEMRD  = (            flagRead  | flagIO);
        static const data_t dbmrMEMWR  = (            flagWrite | flagIO);
        static const data_t dbmrIORD   = (            flagRead  | flagIO);
        static const data_t dbmrIOWR   = (            flagWrite | flagIO);

        //
        // RH11 Controller State
        //

        static const uint8_t rh11INIT00 =   1;
        static const uint8_t rh11IDLE   = 124;
        static const uint8_t rh11INFAIL = 126;

};

//!
//! \brief
//!    This function returns the left-half of a data word
//!
//! \param data -
//!    data is the value of the 36-bit word
//!
//! \returns
//!    18-bit left-half of 36-bit data word
//!

inline uint32_t ks10_t::lh(data_t data) {
    return ((data >> 18) & 0777777);
}

//!
//! \brief
//!    This function returns the right-half of a data word
//!
//! \param data -
//!    data is the value of the 36-bit word
//!
//! \returns
//!    18-bit right-half of 36-bit data word
//!

inline uint32_t ks10_t::rh(data_t data) {
    return (data & 0777777);
}

//!
//! \brief
//!    This function reads a 36-bit register from FPGA.
//!
//! \details
//!    The address is the register address mapped through the EPI.
//!
//! \param reg -
//!    base address of the register.
//!
//! \returns
//!    Register contents.
//!

inline ks10_t::data_t ks10_t::readReg64(volatile void * reg) {
    return *reinterpret_cast<volatile data_t*>(reg);
}

//!
//! \brief
//!    This function writes to a 36-bit register in the FPGA.
//!
//! \details
//!    The address is the register address mapped through the EPI.
//!
//! \param reg -
//!    base address of the register.
//!
//! \param data -
//!    data is the data to be written to the register.
//!

inline void ks10_t::writeReg64(volatile void * reg, data_t data) {
    *reinterpret_cast<volatile data_t *>(reg) = data;
}

#endif
