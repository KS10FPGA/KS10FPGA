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
// Copyright (C) 2013-2021 Rob Doyle
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

#ifndef __KS10_HPP
#define __KS10_HPP

#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>

#undef putchar
#undef getchar

//!
//! KS10 Interface Object
//!

class ks10_t {
    public:

        //
        // KS10 Address and Data Type
        //

        typedef uint64_t addr_t;                                //!< KS10 Address Typedef
        typedef uint64_t data_t;                                //!< KS10 Data Typedef

        //
        // Opcodes
        //

        static const data_t opJRST        = 0254000;            //!< JRST
        static const data_t opHALT        = 0254200;            //!< HALT
        static const data_t opMOVEM       = 0202000;            //!< MOVEM
        static const data_t opAPRID       = 0700000;            //!< APRID
        static const data_t opWRAPR       = 0700200;            //!< WRAPR
        static const data_t opRDAPR       = 0700240;            //!< RDAPR
        static const data_t opWRPI        = 0700600;            //!< WRPI
        static const data_t opRDPI        = 0700640;            //!< RDPI
        static const data_t opRDUBR       = 0701040;            //!< RDUBR
        static const data_t opCLRPT       = 0701100;            //!< CLRPT
        static const data_t opWRUBR       = 0701140;            //!< WRUBR
        static const data_t opWREBR       = 0701200;            //!< WREBR
        static const data_t opRDEBR       = 0701240;            //!< RDEBR
        static const data_t opRDSPB       = 0702000;            //!< RDSPB
        static const data_t opRDCSB       = 0702040;            //!< RDCSB
        static const data_t opRDPUR       = 0702100;            //!< RDPUR
        static const data_t opRDCSTM      = 0702140;            //!< RDCSTM
        static const data_t opRDTIM       = 0702200;            //!< RDTIM
        static const data_t opRDINT       = 0702240;            //!< RDINT
        static const data_t opRDHSB       = 0702300;            //!< RDHSB
        static const data_t opWRSPB       = 0702400;            //!< WRSPB
        static const data_t opWRCSB       = 0702440;            //!< WRCSB
        static const data_t opWRPUR       = 0702500;            //!< WRPUR
        static const data_t opWRCSTM      = 0702540;            //!< WRCSTM
        static const data_t opWRTIM       = 0702600;            //!< WRTIM
        static const data_t opWRINT       = 0702640;            //!< WRINT
        static const data_t opWRHSB       = 0702700;            //!< WRHSB

        //
        // KS10 addresses
        //

        static const addr_t invalidAddr   = (addr_t) -1;        //!< Guaranteed invalid address
        static const addr_t memStart      = 0;                  //!< Start of memory.
        static const addr_t maxVirtAddr   = 000777777;          //!< Last virtual address (18-bit)
        static const addr_t maxMemAddr    = 003777777;          //!< Last memory address (20-bit)
        static const addr_t maxIOAddr     = 017777777;          //!< Last IO address (22-bit)
        static const data_t dataMask      = 0777777777777;      //!< 36-bit mask
        static const addr_t memAddrMask   = 003777777ULL;       //!< KS10 20-bit Address Mask
        static const addr_t ioAddrMask    = 017777777ULL;       //!< KS10 22-bit Address Mask

        //
        // Console Addressable Register Offsets
        //

        static const int regCONAROffset   = 0x00;               //!< CONS  Address Register Offset
        static const int regCONDROffset   = 0x08;               //!< CONS  Data Register Offset
        static const int regCONIROffset   = 0x10;               //!< CONS  Instruction Register Offset
        static const int regCONCSROffset  = 0x18;               //!< CONS  Control/Status Register Offset
        static const int regDZCCROffset   = 0x1c;               //!< DZ11  Console Control Register
        static const int regLPCCROffset   = 0x20;               //!< LP20  Console Control Register
        static const int regRPCCROffset   = 0x24;               //!< RP    Console Control Register
        static const int regDUPCCROffset  = 0x28;               //!< DUP11 Console Control Register
        static const int regDEBCSROffset  = 0x3c;               //!< DEBUG Control/Status Register
        static const int regDEBBAROffset  = 0x40;               //!< DEBUG Breakpoint Address Register
        static const int regDEBBMROffset  = 0x48;               //!< DEBUG Breakpoint Mask Register
        static const int regDEBITROffset  = 0x50;               //!< DEBUG Instruction Trace Register
        static const int regDEBPCIROffset = 0x58;               //!< DEBUG Program Counter and Instruction Register
        static const int regRPDEBOffset   = 0x70;               //!< RP    Debug Register
        static const int regVERSOffset    = 0x78;               //!< FPGA  Version Register

        //
        // Communications block addresses
        //

        static const addr_t switchADDR    = 000030;             //!< Switch address
        static const addr_t kaswADDR      = 000031;             //!< Keep alive address
        static const addr_t ctyinADDR     = 000032;             //!< CTY input address
        static const addr_t ctyoutADDR    = 000033;             //!< CTY output address
        static const addr_t klninADDR     = 000034;             //!< KLINIK input address
        static const addr_t klnoutADDR    = 000035;             //!< KLINIK output address
        static const addr_t rhbaseADDR    = 000036;             //!< RH11 base address
        static const addr_t rhunitADDR    = 000037;             //!< RH11 unit number
        static const addr_t mtparmADDR    = 000040;             //!< Magtape parameters

        static const data_t ctyVALID      = 0x100;              //!< Input/Output character valid

        //
        // KS10 Read/Write Address Modes
        //

        static const addr_t flagFetch     = 0x200000000ULL;     //!< Fetch flags
        static const addr_t flagRead      = 0x100000000ULL;     //!< Read flags
        static const addr_t flagWrite     = 0x040000000ULL;     //!< Write flags
        static const addr_t flagPhys      = 0x008000000ULL;     //!< Phys
        static const addr_t flagIO        = 0x002000000ULL;     //!< IO flag
        static const addr_t flagByte      = 0x000400000ULL;     //!< BYTE IO flag

        //
        // Control/Status Register Bits
        //

        static const uint32_t statGO      = 0x00010000;         //!< GO
        static const uint32_t statNXMNXD  = 0x00000200;         //!< NXM/NXD
        static const uint32_t statHALT    = 0x00000100;         //!< HALT
        static const uint32_t statRUN     = 0x00000080;         //!< RUN
        static const uint32_t statCONT    = 0x00000040;         //!< CONT
        static const uint32_t statEXEC    = 0x00000020;         //!< EXEC
        static const uint32_t statTIMEREN = 0x00000010;         //!< Timer Enable
        static const uint32_t statTRAPEN  = 0x00000008;         //!< Trap Enable
        static const uint32_t statCACHEEN = 0x00000004;         //!< Cache Enable
        static const uint32_t statINTR    = 0x00000002;         //!< Interrupt
        static const uint32_t statRESET   = 0x00000001;         //!< Reset

        //
        // Debug Control/Status Register Constants
        //

        static const uint32_t dcsrBRCMD          = 0x00700000;
        static const uint32_t dcsrBRCMD_BOTH     = 0x00300000;
        static const uint32_t dcsrBRCMD_FULL     = 0x00200000;
        static const uint32_t dcsrBRCMD_MATCH    = 0x00100000;
        static const uint32_t dcsrBRCMD_DISABLE  = 0x00000000;
        static const uint32_t dcsrBRSTATE        = 0x00070000;
        static const uint32_t dcsrBRSTATE_ARMED  = 0x00010000;
        static const uint32_t dcsrBRSTATE_IDLE   = 0x00000000;
        static const uint32_t dcsrTRCMD          = 0x000000e0;
        static const uint32_t dcsrTRCMD_STOP     = 0x00000060;
        static const uint32_t dcsrTRCMD_MATCH    = 0x00000040;
        static const uint32_t dcsrTRCMD_TRIG     = 0x00000020;
        static const uint32_t dcsrTRCMD_RESET    = 0x00000000;
        static const uint32_t dcsrTRSTATE        = 0x0000001c;
        static const uint32_t dcsrTRSTATE_DONE   = 0x0000000c;
        static const uint32_t dcsrTRSTATE_ACTIVE = 0x00000008;
        static const uint32_t dcsrTRSTATE_ARMED  = 0x00000004;
        static const uint32_t dcsrTRSTATE_IDLE   = 0x00000000;
        static const uint32_t dcsrFULL           = 0x00000002;
        static const uint32_t dcsrEMPTY          = 0x00000001;

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
        // RP Controller State
        //

        static const uint8_t rpINIT00 =   1;
        static const uint8_t rpIDLE   = 124;
        static const uint8_t rpINFAIL = 126;

        //
        // DUP11 Configuration Bits
        //

        static const uint32_t dupTXE     = 0x80000000;
        static const uint32_t dupRI      = 0x08000000;
        static const uint32_t dupCTS     = 0x04000000;
        static const uint32_t dupDSR     = 0x02000000;
        static const uint32_t dupDCD     = 0x01000000;
        static const uint32_t dupTXFIFO  = 0x00ff0000;
        static const uint32_t dupRXF     = 0x00008000;
        static const uint32_t dupDTR     = 0x00004000;
        static const uint32_t dupRTS     = 0x00002000;
        static const uint32_t dupH325    = 0x00000800;
        static const uint32_t dupW3      = 0x00000400;
        static const uint32_t dupW5      = 0x00000200;
        static const uint32_t dupW6      = 0x00000100;
        static const uint32_t dupRXFIFO  = 0x000000ff;

        //
        // LPCCR Configuration Bits
        //

        static const uint32_t lpSTOPBITS = 0x00010000;
        static const uint32_t lpPARITY   = 0x00060000;
        static const uint32_t lpLENGTH   = 0x00180000;
        static const uint32_t lpBAUDRATE = 0x03e00000;
        static const uint32_t lpSIXLPI   = 0x00000004;
        static const uint32_t lpOVFU     = 0x00000002;
        static const uint32_t lpONLINE   = 0x00000001;

        //
        // Functions
        //

        ks10_t(bool debug);
        ~ks10_t(void);
        static uint32_t lh(data_t data);
        static uint32_t rh(data_t data);
        static data_t readRegCIR(void);
        static void writeRegCIR(data_t data);
        static data_t readMem(addr_t addr);
        static void writeMem(addr_t addr, data_t data);
        static data_t readIO(addr_t addr);
        static void writeIO(addr_t addr, data_t data);
        static uint16_t readIO16(addr_t addr);
        static void writeIO16(addr_t addr, uint16_t data);
        static uint8_t readIO8(addr_t addr);
        static void writeIO8(addr_t addr, uint8_t data);
        static uint32_t readDUPCCR(void);
        static void writeDUPCCR(uint32_t data);
        static uint32_t readDZCCR(void);
        static void writeDZCCR(uint32_t data);
        static uint32_t readLPCCR(void);
        static void writeLPCCR(uint32_t data);
        static uint32_t readRPCCR(void);
        static void writeRPCCR(uint32_t data);
        static uint32_t readDCSR(void);
        static void writeDCSR(uint32_t data);
        static data_t readDBAR(void);
        static void writeDBAR(data_t data);
        static data_t readDBMR(void);
        static void writeDBMR(data_t data);
        static data_t readDITR(void);
        static data_t readDPCIR(void);
        static uint64_t getRPDEBUG(void);
        static bool run(void);
        static void run(bool);
        static bool halt(void);
        static void boot(void);
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
        static void startRUN(void);
        static void startSTEP(void);
        static void startEXEC(void);
        static void startCONT(void);
        static void testRegs(void);
        static void printRPDEBUG(void);
        static void printHaltStatusWord(void);
        static void printHaltStatusBlock(void);
        static void checkFirmware(void);
        static void putchar(int ch);
        static int getchar(void);
        static void executeInstruction(data_t insn);
        static void setDataAndExecuteInstruction(data_t insn, data_t data, addr_t tempAddr);
        static data_t executeInstructionAndGetData(data_t insn, addr_t tempAddr);
        static data_t rdAPRID(void);
        static data_t rdAPR(void);
        static data_t rdPI(void);
        static data_t rdUBR(void);
        static data_t rdEBR(void);
        static data_t rdSPB(void);
        static data_t rdCSB(void);
        static data_t rdCSTM(void);
        static data_t rdPUR(void);
        static data_t rdTIM(void);
        static data_t rdINT(void);
        static data_t rdHSB(void);
        static data_t readAC(data_t regAC);
        static void lockMutex(void);
        static void unlockMutex(void);

    private:

        static int fd;                                          //!< /dev/mem file descriptor
        static bool debug;                                      //!< debug mode
        static pthread_mutex_t lock;                            //!< FPGA access mutex
        static pthread_mutexattr_t attr;                        //!< FPGA mutex attribute

        //
        // Misc constants
        //

        static char *fpgaAddrVirt;                              //!< FPGA Base Virtual Address
        static const uint32_t fpgaAddrPhys = 0xff200000;        //!< FPGA Base Physical Address
        static const uint32_t fpgaAddrSize = 0x00010000;        //!< FPGA Region Size

        //
        // KS10 FPGA Register Addresses
        //

        static volatile       addr_t   *regAddr;                //!< Console Address Register
        static volatile       data_t   *regData;                //!< Console Data Register
        static volatile       data_t   *regCIR;                 //!< KS10 Console Instruction Register
        static volatile       uint32_t *regStat;                //!< Console Control/Status Register
        static volatile       uint32_t *regDZCCR;               //!< DZ11 Console Control Register
        static volatile       uint32_t *regLPCCR;               //!< LP20 Console Control Register
        static volatile       uint32_t *regRPCCR;               //!< RP Console Control Register
        static volatile       uint32_t *regDUPCCR;              //!< DUP11 Console Control Register
        static volatile       uint32_t *regDEBCSR;              //!< Debug Control/Status Register
        static volatile       addr_t   *regDEBBAR;              //!< Debug Breakpoint Address Register
        static volatile       addr_t   *regDEBBMR;              //!< Debug Breakpoint Mask Register
        static volatile       uint64_t *regDEBITR;              //!< Debug Instruction Trace Register
        static volatile       uint64_t *regDEBPCIR;             //!< Debug Program Counter and Instruction Register
        static volatile const uint64_t *regRPDEBUG;             //!< RP Debug Register
        static          const char     *regVers;                //!< Firmware Version Register

        //
        // Low level interface functions
        //

        static void go(void);
        static uint32_t readReg32(volatile void * reg);
        static void writeReg32(volatile void * reg, uint32_t data);
        static uint64_t readReg64(volatile void * reg);
        static void writeReg64(volatile void * reg, uint64_t data);
        static bool testReg32(volatile void * addr, const char *name, uint32_t mask = 0xfffffffful);
        static bool testReg64(volatile void * addr, const char *name, uint64_t mask = 0xffffffffffffffffull);

        //
        // Private functions without mutex locks.  NOT thread safe.
        //  Use these with care.
        //

        static data_t __readRegAddr(void);
        static void __writeRegAddr(data_t data);
        static data_t __readRegData(void);
        static void __writeRegData(data_t data);
        static data_t __readRegCIR(void);
        static void __writeRegCIR(data_t data);
        static uint32_t __readRegStat(void);
        static void __writeRegStat(uint32_t data);
        static void __run(bool enable);
        static bool __run(void);
        static void __startEXEC(void);
        static void __startSTEP(void);
        static void __startCONT(void);
        static void __startRUN(void);
        static bool __halt(void);
        static bool __timerEnable(void);
        static void __timerEnable(bool enable);
        static bool __trapEnable(void);
        static void __trapEnable(bool enable);
        static bool __cacheEnable(void);
        static void __cacheEnable(bool enable);
        static bool __cpuReset(void);
        static void __cpuReset(bool enable);
        static void __statGO(void);
        static void __executeInstruction(data_t insn);
        static data_t __executeInstructionAndGetData(data_t insn, addr_t tempAddr);
        static data_t __readMem(addr_t addr);
        static void __writeMem(addr_t addr, data_t data);
        static data_t __readIO(addr_t addr);
        static void __writeIO(addr_t addr, data_t data);
        static uint16_t __readIO16(addr_t addr);
        static void __writeIO16(addr_t addr, uint16_t data);
        static uint8_t __readIO8(addr_t addr);
        static void __writeIO8(addr_t addr, uint8_t data);
};

//!
//! \brief
//!    This function locks the FPGA mutex
//!
//! \details
//!    The Console software is multi-threaded and therefore accesses to the
//!    FPGA IO must be protected by mutexes.
//!

inline void ks10_t::lockMutex(void) {
    pthread_mutex_lock(&lock);
}

//!
//! \brief
//!    This function unlocks the FPGA mutex
//!
//! \details
//!    The Console software is multi-threaded and therefore accesses to the
//!    FPGA IO must be protected by mutexes.
//!

inline void ks10_t::unlockMutex(void) {
    pthread_mutex_unlock(&lock);
}

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
//!    This function reads a 32-bit register from FPGA.
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
//! \note
//!    This function is thread safe.
//!

inline uint32_t ks10_t::readReg32(volatile void * reg) {
    return *reinterpret_cast<volatile uint32_t*>(reg);
}

//!
//! \brief
//!    This function writes to a 32-bit register in the FPGA.
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
//! \note
//!    This function is thread safe.
//!

inline void ks10_t::writeReg32(volatile void * reg, uint32_t data) {
    *reinterpret_cast<volatile uint32_t *>(reg) = data;
}

//!
//! \brief
//!    This function reads a 64-bit (or 36-bit) register from FPGA.
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
//! \note
//!    This function is NOT thread safe.
//!

inline uint64_t ks10_t::readReg64(volatile void * reg) {
    return *reinterpret_cast<volatile uint64_t *>(reg);
}

//!
//! \brief
//!    This function writes to a 64-bit (or 36-bit) register in the FPGA.
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
//! \note
//!    This function is NOT thread safe.
//!

inline void ks10_t::writeReg64(volatile void * reg, uint64_t data) {
    *reinterpret_cast<volatile uint64_t *>(reg) = data;
}

//!
//! \brief
//!    This function reads from <b>Console Address Register</b>
//!
//! \returns
//!    Contents of the <b>Console Address Register</b>.
//!
//! \note
//!    This function is NOT thread safe.
//!

inline ks10_t::data_t ks10_t::__readRegAddr(void) {
    return *regAddr;
}

//!
//! \brief
//!    This function writes to <b>Console Address Register</b>
//!
//! \param data -
//!    data to be written to the <b>Console Address Register</b>.
//!
//! \note
//!    This function is NOT thread safe.
//!

inline void ks10_t::__writeRegAddr(data_t data) {
    *regAddr = data;
}

//!    This function reads from <b>Console Data Register</b>
//!
//! \returns
//!    Contents of the <b>Console Data Register</b>.
//!
//! \note
//!    This function is NOT thread safe.
//!

inline ks10_t::data_t ks10_t::__readRegData(void) {
    return *regData;
}

//!
//! \brief
//!    This function writes to <b>Console Data Register</b>
//!
//! \param data -
//!    data to be written to the <b>Console Data Register</b>.
//!
//! \note
//!    This function is NOT thread safe.
//!

inline void ks10_t::__writeRegData(data_t data) {
    *regData = data;
}

//!
//! \brief
//!    This function reads the <b>Console Instruction Register</b>
//!
//! \returns
//!    Contents of the <b>Console Instruction Register</b>
//!
//! \note
//!    This function is thread safe.
//!

inline ks10_t::data_t ks10_t::__readRegCIR(void) {
    return *regCIR;
}

inline ks10_t::data_t ks10_t::readRegCIR(void) {
    lockMutex();
    data_t ret = __readRegCIR();
    unlockMutex();
    return ret;
}

//!
//! \brief
//!    Function to write to the <b>Console Instruction Register</b>
//!
//! \param data -
//!    data is the data to be written to the <b>Console Instruction
//!    Register.</b>
//!
//! \note
//!    This function is thread safe.
//!

inline void ks10_t::__writeRegCIR(data_t data) {
    *regCIR = data;
}

inline void ks10_t::writeRegCIR(data_t data) {
    lockMutex();
    __writeRegCIR(data);
    unlockMutex();
}

//!
//! \brief
//!    This function reads from <b>Console Status Register</b>
//!
//! \returns
//!    Contents of the <b>Console Status Register</b>.
//!
//! \note
//!    This function is NOT thread safe.
//!

inline uint32_t ks10_t::__readRegStat(void) {
    return *regStat;
}

//!
//! \brief
//!    This function writes to <b>Console Status Register</b>
//!
//! \param data -
//!    data to be written to the <b>Console Status Register</b>.
//!
//! \note
//!    This function is NOT thread safe.
//!

inline void ks10_t::__writeRegStat(uint32_t data) {
    *regStat = data;
}

//!
//! \brief
//!    This function reads a 32-bit value from the DZCCR
//!
//! \returns
//!    contents of the DZCCR register
//!
//! \note
//!    This function is thread safe.
//!

inline uint32_t ks10_t::readDZCCR(void) {
    return *regDZCCR;
}

//!
//! \brief
//!    This function writes a 32-bit value to the DZCCR
//!
//! \param data -
//!    data is the data to be written to the DZCCR
//!
//! \note
//!    This function is thread safe.
//!

inline void ks10_t::writeDZCCR(uint32_t data) {
    *regDZCCR = data;
}

//!
//! \brief
//!    This function reads a 32-bit value from the LPCCR
//!
//! \returns
//!    contents of the LPCCR register
//!
//! \note
//!    This function is thread safe.
//!

inline uint32_t ks10_t::readLPCCR(void) {
    return *regLPCCR;
}

//!
//! \brief
//!    This function writes a 32-bit value to the LPCCR
//!
//! \param data -
//!    data is the data to be written to the LPCCR
//!
//! \note
//!    This function is thread safe.
//!

inline void ks10_t::writeLPCCR(uint32_t data) {
    *regLPCCR = data;
}

//!
//! \brief
//!    This function reads a 32-bit value from the RPCCR
//!
//! \returns
//!    contents of the RPCCR register
//!
//! \note
//!    This function is thread safe.
//!

inline uint32_t ks10_t::readRPCCR(void) {
    return *regRPCCR;
}

//!
//! \brief
//!    This function writes a 32-bit value to the RPCCR
//!
//! \param data -
//!    data is the data to be written to the RPCCR
//!
//! \note
//!    This function is thread safe.
//!

inline void ks10_t::writeRPCCR(uint32_t data) {
    *regRPCCR = data;
}

//!
//! \brief
//!    This function reads a 32-bit value from the DUPCCR
//!
//! \returns
//!    contents of the DUPCCR register
//!
//! \note
//!    This function is thread safe.
//!

inline uint32_t ks10_t::readDUPCCR(void) {
    return *regDUPCCR;
}

//!
//! \brief
//!    This function writes a 32-bit value to the DUPCCR
//!
//! \param data -
//!    data is the data to be written to the DUPCCR
//!
//! \note
//!    This function is thread safe.
//!

inline void ks10_t::writeDUPCCR(uint32_t data) {
    *regDUPCCR = data;
}

//!
//! \brief
//!    This function reads a 32-bit value from the Debug Control/Status Register
//!
//! \returns
//!    contents of the DCSR register
//!
//! \note
//!    This function is thread safe.
//!

inline uint32_t ks10_t::readDCSR(void) {
    return *regDEBCSR;
}

//!
//! \brief
//!    This function writes a 36-bit value to the Debug Control/Status Register
//!
//! \param data -
//!    data is the data to be written to the Debug Control/Status Register
//!
//! \note
//!    This function is thread safe.
//!

inline void ks10_t::writeDCSR(uint32_t data) {
    *regDEBCSR = data;
}

//!
//! \brief
//!    This function reads a 36-bit value from the Breakpoint Address Register
//!
//! \returns
//!    contents of the DBAR register
//!
//! \note
//!    This function is thread safe.
//!

inline uint64_t ks10_t::readDBAR(void) {
    lockMutex();
    uint64_t ret = *regDEBBAR;
    unlockMutex();
    return ret;
}

//!
//! \brief
//!    This function writes a 36-bit value to the Breakpoint Address Register
//!
//! \param data -
//!    data is the data to be written to the Breakpoint Address Register
//!
//! \note
//!    This function is thread safe.
//!

inline void ks10_t::writeDBAR(uint64_t data) {
    lockMutex();
    *regDEBBAR = data;
    unlockMutex();
}

//!
//! \brief
//!   This function reads a 36-bit value from the Breakpoint Mask Register
//!
//! \returns
//!    contents of the DBMR register
//!
//! \note
//!    This function is thread safe.
//!

inline uint64_t ks10_t::readDBMR(void) {
    lockMutex();
    uint64_t ret = *regDEBBMR;
    unlockMutex();
    return ret;
}

//!
//! \brief
//!    This function writes a 36-bit value to the Breakpoint Mask Register
//!
//! \param data -
//!    data is the data to be written to the Breakpoint Mask Register
//!
//! \note
//!    This function is thread safe.
//!

inline void ks10_t::writeDBMR(uint64_t data) {
    lockMutex();
    *regDEBBMR = data;
    unlockMutex();
}

//!
//! \brief
//!    This function reads a 36-bit value from the Debug Instruction Trace
//!    Register.  The trace buffer automatically increments when the trace buffer
//!    is read.
//!
//! \note
//!    For some reason, a 64-bit load advances the Trace Buffer FIFO twice.
//!
//! \returns
//!    Contents of the DITR register
//!
//! \note
//!    This function is thread safe.
//!

inline uint64_t ks10_t::readDITR(void) {
    lockMutex();
    uint64_t ret = *regDEBITR;
    unlockMutex();
    return ret;
}

//!
//! \brief
//!    This function reads a 64-bit value from the Debug Program Counter and
//!    Instruction Register.
//!
//! \returns
//!    contents of the DPCIR register
//!
//! \note
//!    This function is thread safe.
//!

inline uint64_t ks10_t::readDPCIR(void) {
    lockMutex();
    uint64_t ret = *regDEBPCIR;
    unlockMutex();
    return ret;
}

//!
//! \brief
//!    Get Contents of RP Debug Register
//!
//! \brief
//!    This function return the contents of the RP Debug Register
//!
//! \returns
//!     Contents of the RP Debug Register
//!
//! \note
//!    This function is thread safe.
//!

inline uint64_t ks10_t::getRPDEBUG(void) {
    lockMutex();
    uint64_t ret = *regRPDEBUG;
    unlockMutex();
    return ret;
}

//!
//! \brief
//!    This function controls the <b>RUN</b> mode of the KS10.
//!
//! \param enable -
//!    <b>True</b> puts the KS10 in <b>RUN</b> mode.
//!    <b>False</b> puts the KS10 in <b>HALT</b> mode.
//!
//! \note
//!    This function is thread safe.
//!

inline void ks10_t::__run(bool enable) {
    if (enable) {
        __writeRegStat(__readRegStat() | statRUN);
    } else {
        __writeRegStat(__readRegStat() & ~statRUN);
    }
}

inline void ks10_t::run(bool enable) {
    lockMutex();
    __run(enable);
    unlockMutex();
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
//! \note
//!    This function is thread safe.
//!

inline bool ks10_t::__run(void) {
    return __readRegStat() & statRUN;
}

inline bool ks10_t::run(void) {
    lockMutex();
    bool ret = __run();
    unlockMutex();
    return ret;
}

//!
//! \brief
//!    Execute a single instruction in the CIR
//!
//! \note
//!    This function is thread safe.
//!

inline void ks10_t::__startEXEC(void) {
    __writeRegStat(statCONT | statEXEC | __readRegStat());
}

inline void ks10_t::startEXEC(void) {
    lockMutex();
    __startEXEC();
    unlockMutex();
}

//!
//! \brief
//!    Execute a single instruction at the current PC
//!
//! \note
//!    This function is thread safe.
//!

inline void ks10_t::__startSTEP(void) {
    __writeRegStat(statCONT | __readRegStat());
}

inline void ks10_t::startSTEP(void) {
    lockMutex();
    __startSTEP();
    unlockMutex();
}

//!
//! \brief
//!    Continue execution at the current PC.
//!
//! \note
//!    This function is thread safe.
//!

inline void ks10_t::__startCONT(void) {
    __writeRegStat(statRUN | statCONT | __readRegStat());
}

inline void ks10_t::startCONT(void) {
    lockMutex();
    __startCONT();
    unlockMutex();
}

//!
//! \brief
//!    Begin execution with instruction in the CIR.
//!
//! \note
//!    This function is thread safe.
//!

inline void ks10_t::__startRUN(void) {
    __writeRegStat(statRUN | statCONT | statEXEC | __readRegStat());
}

inline void ks10_t::startRUN(void) {
    lockMutex();
    __startRUN();
    unlockMutex();
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
//! \note
//!    This function is thread safe.
//!

inline bool ks10_t::__halt(void) {
    return __readRegStat() & statHALT;
}

inline bool ks10_t::halt(void) {
    lockMutex();
    bool ret = __halt();
    unlockMutex();
    return ret;
}

//!
//! \brief
//! Report the state of the KS10's interval timer.
//!
//! \returns
//!    Returns <b>true</b> if the KS10 interval timer enabled and <b>false</b>
//!    otherwise.
//!
//! \note
//!    This function is thread safe.
//!

inline bool ks10_t::__timerEnable(void) {
    return __readRegStat() & statTIMEREN;
}

inline bool ks10_t::timerEnable(void) {
    lockMutex();
    bool ret = __timerEnable();
    unlockMutex();
    return ret;
}

//!
//! \brief
//! Control the KS10 interval timer operation
//!
//! \param
//!     enable is <b>true</b> to enable the KS10 intervale timer or
//!     <b>false</b> to disable the KS10 timer.
//!
//! \note
//!    This function is thread safe.
//!

inline void ks10_t::__timerEnable(bool enable) {
    if (enable) {
        __writeRegStat(__readRegStat() | statTIMEREN);
    } else {
        __writeRegStat(__readRegStat() & ~statTIMEREN);
    }
}

inline void ks10_t::timerEnable(bool enable) {
    lockMutex();
    __timerEnable(enable);
    unlockMutex();
}

//!
//! \brief
//!    Report the state of the KS10's traps.
//!
//! \returns
//!    Returns <b>true</b> if the KS10 traps enabled and <b>false</b>
//!    otherwise.
//!
//! \note
//!    This function is thread safe.
//!

inline bool ks10_t::__trapEnable(void) {
    return __readRegStat() & statTRAPEN;
}

inline bool ks10_t::trapEnable(void) {
    lockMutex();
    bool ret = __trapEnable();
    unlockMutex();
    return ret;
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
//! \note
//!    This function is thread safe.
//!

inline void ks10_t::__trapEnable(bool enable) {
    if (enable) {
        __writeRegStat(__readRegStat() | statTRAPEN);
    } else {
        __writeRegStat(__readRegStat() & ~statTRAPEN);
    }
}

inline void ks10_t::trapEnable(bool enable) {
    lockMutex();
    __trapEnable(enable);
    unlockMutex();
}

//!
//! \brief
//!    Report the state of the KS10's cache memory.
//!
//! \returns
//!    Returns <b>true</b> if the KS10 cache enabled and <b>false</b>
//!    otherwise.
//!
//! \note
//!    This function is thread safe.
//!

inline bool ks10_t::__cacheEnable(void) {
    return __readRegStat() & statCACHEEN;
}

inline bool ks10_t::cacheEnable(void) {
    lockMutex();
    bool ret = __cacheEnable();
    unlockMutex();
    return ret;
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
//! \note
//!    This function is thread safe.
//!

inline void ks10_t::__cacheEnable(bool enable) {
    if (enable) {
        __writeRegStat(__readRegStat() | statCACHEEN);
    } else {
        __writeRegStat(__readRegStat() & ~statCACHEEN);
    }
}

inline void ks10_t::cacheEnable(bool enable) {
    lockMutex();
    __cacheEnable(enable);
    unlockMutex();
}

//!
//! \brief
//!    Report the state of the KS10's reset signal.
//!
//! \returns
//!    Returns <b>true</b> if the KS10 is <b>reset</b> and <b>false</b>
//!    otherwise.
//!
//! \note
//!    This function is thread safe.
//!

inline bool ks10_t::__cpuReset(void) {
    return __readRegStat() & statRESET;
}

inline bool ks10_t::cpuReset(void) {
    lockMutex();
    bool ret = __cpuReset();
    unlockMutex();
    return ret;
}

//!
//! \brief
//!    Reset the KS10
//!
//! \details
//!    This function controls whether the KS10's is reset.  When reset, the KS10 will
//!    reset on next clock cycle without completing the current operation.
//!
//! \param
//!    enable is <b>true</b> to assert <b>reset</b> to the KS10 or <b>false</b> to
//!    negate <b>reset</b> to the KS10.
//!
//! \note
//!    This function is thread safe.
//!

inline void ks10_t::__cpuReset(bool enable) {
    if (enable) {
        __writeRegStat(__readRegStat() | statRESET);
    } else {
        __writeRegStat(__readRegStat() & ~statRESET);
    }
}
inline void ks10_t::cpuReset(bool enable) {
    lockMutex();
    __cpuReset(enable);
    unlockMutex();
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
//! \note
//!    This function is thread safe.
//!



inline void ks10_t::cpuIntr(void) {
    lockMutex();
    __writeRegStat(__readRegStat() | statINTR);
    unlockMutex();
    usleep(10);
    lockMutex();
    __writeRegStat(__readRegStat() & ~statINTR);
    unlockMutex();
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
//! \note
//!    This function is thread safe.
//!

inline bool ks10_t::nxmnxd(void) {
    lockMutex();
    uint32_t reg = __readRegStat();
    __writeRegStat(reg & ~statNXMNXD);
    unlockMutex();
    return reg & statNXMNXD;
}

//!
//! \brief
//!    Execute a single instruction
//!
//! \param insn -
//!    Instruction to execute
//!
//! \note
//!    This function is thread safe.
//!

inline void ks10_t::__executeInstruction(data_t insn) {
    __writeRegCIR(insn);
    __startEXEC();
}

inline void ks10_t::executeInstruction(data_t insn) {
    lockMutex();
    __executeInstruction(insn);
    unlockMutex();
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
//! \note
//!    This function is NOT thread safe.
//!

inline void ks10_t::__statGO(void) {
    __writeRegStat(__readRegStat() | statGO);
    for (int i = 0; i < 100; i++) {
        if ((__readRegStat() & statGO) == 0) {
           return;
        }
        usleep(1000);
    }
    printf("KS10: GO-bit timeout\n");
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
//! \note
//!    This function is not thread safe.
//!

inline ks10_t::data_t ks10_t::__readMem(addr_t addr) {
    __writeRegAddr(addr | flagRead | flagPhys);
    __statGO();
    return dataMask & __readRegData();
}

inline ks10_t::data_t ks10_t::readMem(addr_t addr) {
    lockMutex();
    ks10_t::data_t ret = __readMem(addr);
    unlockMutex();
    return ret;
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
//!    writeIO() for 36-bit IO writes, and writeIObyte() for 8-bit IO writes.
//!
//! \note
//!    This function is thread safe.
//!

inline void ks10_t::__writeMem(addr_t addr, data_t data) {
    __writeRegAddr((addr & memAddrMask) | flagWrite | flagPhys);
    __writeRegData(data);
    __statGO();
}

inline void ks10_t::writeMem(addr_t addr, data_t data) {
    lockMutex();
    __writeMem(addr, data);
    unlockMutex();
}

//!
//! \brief
//!    This function reads a 36-bit word from KS10 IO.
//!
//! \param [in] addr -
//!    addr is the address in the KS10 IO space which is to be read.
//!
//! \see
//!    readMem() for 36-bit memory reads, readIO16() for 16-bit IO reads,
//!    amd readIO8 for 8-bit IO reads.
//!
//! \returns
//!    Contents of the KS10 IO that was read.
//!
//! \note
//!    This function is thread safe.
//!

inline ks10_t::data_t ks10_t::__readIO(addr_t addr) {
    __writeRegAddr((addr & ioAddrMask) | flagRead | flagPhys | flagIO);
    __statGO();
    return dataMask & __readRegData();
}

inline ks10_t::data_t ks10_t::readIO(addr_t addr) {
    lockMutex();
    ks10_t::data_t ret = __readIO(addr);
    unlockMutex();
    return ret;
}

//!
//! \brief
//!    This function writes a 36-bit word to the KS10 IO.
//!
//! \details
//!    This function is used to write to 36-bit KS10 IO
//!
//! \param [in] addr -
//!    addr is the address in the KS10 IO space which is to be written.
//!
//! \param [in] data -
//!    data is the data to be written to the KS10 IO.
//!
//! \see
//!    writeMem() for memory writes, writeIO16() for 16-bit IO writes, and
//!    writeIO8() for 8-bit IO writes.
//!
//! \note
//!    This function is thread safe.
//!

inline void ks10_t::__writeIO(addr_t addr, data_t data) {
    __writeRegAddr((addr & ioAddrMask) | flagWrite | flagPhys | flagIO);
    __writeRegData(data);
    __statGO();
}

inline void ks10_t::writeIO(addr_t addr, data_t data) {
    lockMutex();
    __writeIO(addr, data);
    unlockMutex();
}

//!
//! \brief
//!    This function reads an 16-word from KS10 UNIBUS IO.
//!
//! \param [in]
//!    addr is the address in the Unibus IO space which is to be read.
//!
//! \see
//!    readMem() for 36-bit memory reads, readIO() for 36-bit IO reads,
//!    and readIO8() for 8-bit IO reads.
//!
//! \returns
//!    Contents of the KS10 Unibus IO that was read.
//!
//! \note
//!    This function is thread safe.
//!

inline uint16_t ks10_t::__readIO16(addr_t addr) {
    __writeRegAddr((addr & ioAddrMask) | flagRead | flagPhys | flagIO | flagByte);
    __statGO();
    return 0xffff & __readRegData();
}

inline uint16_t ks10_t::readIO16(addr_t addr) {
    lockMutex();
    uint16_t ret = __readIO16(addr);
    unlockMutex();
    return ret;
}

//!
//! \brief
//!    This function writes 16-word to KS10 Unibus IO.
//!
//! \param
//!    addr is the address in the KS10 Unibus IO space which is to be written.
//!
//! \param data -
//!    data is the data to be written to the KS10 Unibus IO.
//!
//! \see
//!    writeMem() for 36-bit memory reads, writeIO() for 36-bit IO reads,
//!    and writeIO8() for 8-bit IO reads.
//!
//! \note
//!    This function is thread safe.
//!

inline void ks10_t::__writeIO16(addr_t addr, uint16_t data) {
    __writeRegAddr((addr & ioAddrMask) | flagWrite | flagPhys | flagIO | flagByte);
    __writeRegData(data);
    __statGO();
}

inline void ks10_t::writeIO16(addr_t addr, uint16_t data) {
    lockMutex();
    __writeIO16(addr, data);
    unlockMutex();
}

//!
//! \brief
//!    This function reads an 8-bit byte from KS10 UNIBUS IO.
//!
//! \param [in]
//!    addr is the address in the Unibus IO space which is to be read.
//!
//! \see
//!    readMem() for 36-bit memory reads, readIO() for 36-bit IO reads,
//!    and readIO16 for 16-bit IO reads.
//!
//! \returns
//!    Contents of the KS10 Unibus IO that was read.
//!
//! \note
//!    This function is thread safe.
//!

inline uint8_t ks10_t::__readIO8(addr_t addr) {
    __writeRegAddr((addr & ioAddrMask) | flagRead | flagPhys | flagIO | flagByte);
    __statGO();
    return 0xff & __readRegData();
}

inline uint8_t ks10_t::readIO8(addr_t addr) {
    lockMutex();
    uint8_t ret = __readIO8(addr);
    unlockMutex();
    return ret;
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
//! \see
//!    writeMem() for 36-bit memory writes, writeIO() for 36-bit IO reads,
//!    and writeIO16 for 16-bit IO reads.
//!
//! \note
//!    This function is thread safe.
//!

inline void ks10_t::__writeIO8(addr_t addr, uint8_t data) {
    __writeRegAddr((addr & ioAddrMask) | flagWrite | flagPhys | flagIO | flagByte);
    __writeRegData(data);
    __statGO();
}

inline void ks10_t::writeIO8(addr_t addr, uint8_t data) {
    lockMutex();
    __writeIO8(addr, data);
    unlockMutex();
}

#endif
