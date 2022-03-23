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
// Copyright (C) 2013-2022 Rob Doyle
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
// or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
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

//!
//! \brief
//!    Fix stdio macros.
//!

#undef putchar
#undef getchar

//!
//! \brief
//!    Lock debugging
//!

#define LOCK()
#define UNLOCK()

//!
//! \addtogroup ks10_api
//! \{

//!
//! KS10 Interface Object
//!

class ks10_t {
    public:

        //
        // KS10 Address and Data Type
        //

        typedef uint64_t addr_t;                        //!< KS10 address typedef
        typedef uint64_t data_t;                        //!< KS10 data typedef

        //!
        //! \brief
        //!    KS10 Opcodes that are used
        //!

        enum opcode_t : data_t {
            opJRST   = 0254000,                         //!< JRST opcode
            opHALT   = 0254200,                         //!< HALT opcode
            opMOVEM  = 0202000,                         //!< MOVEM opcode
            opAPRID  = 0700000,                         //!< APRID opcode
            opWRAPR  = 0700200,                         //!< WRAPR opcode
            opRDAPR  = 0700240,                         //!< RDAPR opcode
            opWRPI   = 0700600,                         //!< WRPI opcode
            opRDPI   = 0700640,                         //!< RDPI opcode
            opRDUBR  = 0701040,                         //!< RDUBR opcode
            opCLRPT  = 0701100,                         //!< CLRPT opcode
            opWRUBR  = 0701140,                         //!< WRUBR opcode
            opWREBR  = 0701200,                         //!< WREBR opcode
            opRDEBR  = 0701240,                         //!< RDEBR opcode
            opRDSPB  = 0702000,                         //!< RDSPB opcode
            opRDCSB  = 0702040,                         //!< RDCSB opcode
            opRDPUR  = 0702100,                         //!< RDPUR opcode
            opRDCSTM = 0702140,                         //!< RDCSTM opcode
            opRDTIM  = 0702200,                         //!< RDTIM opcode
            opRDINT  = 0702240,                         //!< RDINT opcode
            opRDHSB  = 0702300,                         //!< RDHSB opcode
            opWRSPB  = 0702400,                         //!< WRSPB opcode
            opWRCSB  = 0702440,                         //!< WRCSB opcode
            opWRPUR  = 0702500,                         //!< WRPUR opcode
            opWRCSTM = 0702540,                         //!< WRCSTM opcode
            opWRTIM  = 0702600,                         //!< WRTIM opcode
            opWRINT  = 0702640,                         //!< WRINT opcode
            opWRHSB  = 0702700,                         //!< WRHSB opcode
        };

        //!
        //! \brief
        //!    KS10 address limits
        //!

        enum reg_addr_limits_t : addr_t {
            memStart    = 0,                            //!< Start of memory.
            maxVirtAddr = 000777777,                    //!< Last virtual address (18-bit)
            maxMemAddr  = 003777777,                    //!< Last memory address (20-bit)
            maxIOAddr   = 017777777,                    //!< Last IO address (22-bit)
            memAddrMask = 003777777,                    //!< KS10 20-bit Address Mask
            ioAddrMask  = 017777777,                    //!< KS10 22-bit Address Mask
            invalidAddr = (addr_t) -1,                  //!< Guaranteed invalid address
        };

        static const data_t dataMask = 0777777777777;   //!< 36-bit data mask

        //!
        //! \brief
        //!    Console Addressable Register Offsets
        //!

        enum reg_offset_t : unsigned int {
            regCONAROffset   = 0x00,                    //!< CONS Address Register Offset
            regCONDROffset   = 0x08,                    //!< CONS Data Register Offset
            regCONIROffset   = 0x10,                    //!< CONS Instruction Register Offset
            regCONCSROffset  = 0x18,                    //!< CONS Control/Status Register Offset
            regDZCCROffset   = 0x1c,                    //!< DZ11 Console Control Register
            regLPCCROffset   = 0x20,                    //!< LP20 Console Control Register
            regRPCCROffset   = 0x24,                    //!< RP   Console Control Register
            regMTCCROffset   = 0x28,                    //!< MT   Console Control Register
            regDUPCCROffset  = 0x2c,                    //!< DUP  Console Control Register
            regKMCCCROffset  = 0x30,                    //!< KMC  Console Control Register
            regITROffset     = 0x50,                    //!< Instruction Trace Register
            regPCIROffset    = 0x58,                    //!< Program Counter and Instruction Register
            regMTDIROffset   = 0x60,                    //!< MT Data Interface Register
            regMTDEBOffset   = 0x68,                    //!< MT Debug Register
            regRPDEBOffset   = 0x70,                    //!< RP Debug Register
            regBRAR0Offset   = 0x80,                    //!< Breakpoint Address Register #0
            regBRMR0Offset   = 0x88,                    //!< Breakpoint Mask Register #0
            regBRAR1Offset   = 0x90,                    //!< Breakpoint Address Register #1
            regBRMR1Offset   = 0x98,                    //!< Breakpoint Mask Register #1
            regBRAR2Offset   = 0xa0,                    //!< Breakpoint Address Register #2
            regBRMR2Offset   = 0xa8,                    //!< Breakpoint Mask Register #2
            regBRAR3Offset   = 0xb0,                    //!< Breakpoint Address Register #3
            regBRMR3Offset   = 0xb8,                    //!< Breakpoint Mask Register #3
            regVERSOffset    = 0xf8,                    //!< FPGA Version Register
        };

        //!
        //! \brief
        //!    Console communications area addresses
        //!

        enum com_addr_t : addr_t {
            switchADDR = 000030,                        //!< Switch address
            kaswADDR   = 000031,                        //!< Keep alive address
            ctyinADDR  = 000032,                        //!< CTY input address
            ctyoutADDR = 000033,                        //!< CTY output address
            klninADDR  = 000034,                        //!< KLINIK input address
            klnoutADDR = 000035,                        //!< KLINIK output address
            rhbaseADDR = 000036,                        //!< RH11 base address
            rhunitADDR = 000037,                        //!< RH11 unit number
            mtparmADDR = 000040,                        //!< Magtape parameters
        };

        static const data_t ctyVALID = 0x100;           //!< Input/Output character valid

        //!
        //! \brief
        //!    KS10 Read/Write Address Modes
        //!

        enum addr_flags_t : addr_t {
            flagFetch = 0x200000000ULL,                 //!< Fetch flags
            flagRead  = 0x100000000ULL,                 //!< Read flags
            flagWrite = 0x040000000ULL,                 //!< Write flags
            flagPhys  = 0x008000000ULL,                 //!< Phys
            flagIO    = 0x002000000ULL,                 //!< IO flag
            flagByte  = 0x000400000ULL,                 //!< BYTE IO flag
        };

        //!
        //! \brief
        //!    Console Control/Status Register Bits
        //!

        enum concsr_bits_t : uint32_t {
            statGO      = 0x00010000,                   //!< GO
            statNXMNXD  = 0x00000200,                   //!< NXM/NXD
            statHALT    = 0x00000100,                   //!< HALT
            statRUN     = 0x00000080,                   //!< RUN
            statCONT    = 0x00000040,                   //!< CONT
            statEXEC    = 0x00000020,                   //!< EXEC
            statTIMEREN = 0x00000010,                   //!< Timer Enable
            statTRAPEN  = 0x00000008,                   //!< Trap Enable
            statCACHEEN = 0x00000004,                   //!< Cache Enable
            statINTR    = 0x00000002,                   //!< Interrupt
            statRESET   = 0x00000001,                   //!< Reset
        };

        //!
        //! \brief
        //!    Debug Control/Status Register Constants
        //!

        enum dcsr_bits_t : uint32_t {                   //!<
            dcsrBRCMD          = 0x00700000,            //!<
            dcsrBRCMD_BOTH     = 0x00300000,            //!<
            dcsrBRCMD_FULL     = 0x00200000,            //!<
            dcsrBRCMD_MATCH    = 0x00100000,            //!<
            dcsrBRCMD_DISABLE  = 0x00000000,            //!<
            dcsrBRSTATE        = 0x00070000,            //!<
            dcsrBRSTATE_ARMED  = 0x00010000,            //!<
            dcsrBRSTATE_IDLE   = 0x00000000,            //!<
            dcsrTRCMD          = 0x000000e0,            //!<
            dcsrTRCMD_STOP     = 0x00000060,            //!<
            dcsrTRCMD_MATCH    = 0x00000040,            //!<
            dcsrTRCMD_TRIG     = 0x00000020,            //!<
            dcsrTRCMD_RESET    = 0x00000000,            //!<
            dcsrTRSTATE        = 0x0000001c,            //!<
            dcsrTRSTATE_DONE   = 0x0000000c,            //!<
            dcsrTRSTATE_ACTIVE = 0x00000008,            //!<
            dcsrTRSTATE_ARMED  = 0x00000004,            //!<
            dcsrTRSTATE_IDLE   = 0x00000000,            //!<
            dcsrFULL           = 0x00000002,            //!<
            dcsrEMPTY          = 0x00000001,            //!<
        };

        //!
        //! \brief
        //!    Breakpoint Address Register Constants
        //!

        enum brar_flags_t : addr_t {
            brarMEMMASK = memAddrMask,                  //!< 20-bit Memory Address Mask
            brarIOMASK  = ioAddrMask,                   //!< 22-bit IO Address Mask
            brarFETCH   = (flagFetch | flagRead),       //!< Fetch flags
            brarMEMRD   = (flagRead            ),       //!< Memory read flags
            brarMEMWR   = (flagWrite           ),       //!< Memory write flags
            brarIORD    = (flagRead  | flagIO  ),       //!< IO read flags
            brarIOWR    = (flagWrite | flagIO  ),       //!< IO write flags
        };

        //!
        //! \brief
        //!    Breakpoint Mask Register Constants
        //!

        enum brmr_flags_t : addr_t {
            brmrMEMMASK = memAddrMask,                  //!< 20-bit Memory Address Mask
            brmrIOMASK  = ioAddrMask,                   //!< 22-bit IO Address Mask
            brmrFETCH   = (flagFetch | flagRead),       //!< Fetch flags
            brmrMEMRD   = (flagRead            ),       //!< Memory read flags
            brmrMEMWR   = (flagWrite           ),       //!< Memory write flags
            brmrIORD    = (flagRead  | flagIO  ),       //!< IO read flags
            brmrIOWR    = (flagWrite | flagIO  ),       //!< IO write flags
        };

        //!
        //! \brief
        //!    RP Controller State
        //!

        enum rp_state_t : uint8_t {
            rpINIT00 =   1,                             //!< Initializing state
            rpIDLE   = 124,                             //!< State Idle (Initialization succeeded)
            rpINFAIL = 126,                             //!< Initialization failed
        };

        //!
        //! \brief
        //!    DUPCCR Configuration Bits
        //!

        enum dupccr_bits_t : uint32_t {
            dupTXE    = 0x80000000,                     //!<
            dupRI     = 0x08000000,                     //!<
            dupCTS    = 0x04000000,                     //!<
            dupDSR    = 0x02000000,                     //!<
            dupDCD    = 0x01000000,                     //!<
            dupTXFIFO = 0x00ff0000,                     //!<
            dupRXF    = 0x00008000,                     //!<
            dupDTR    = 0x00004000,                     //!<
            dupRTS    = 0x00002000,                     //!<
            dupH325   = 0x00000800,                     //!<
            dupW3     = 0x00000400,                     //!<
            dupW5     = 0x00000200,                     //!<
            dupW6     = 0x00000100,                     //!<
            dupRXFIFO = 0x000000ff,                     //!<
        };

        //!
        //! \brief
        //!    LPCCR Configuration Bits
        //!

        enum lpccr_bits_t : uint32_t {
            lpSTOPBITS = 0x00010000,                    //!<
            lpPARITY   = 0x00060000,                    //!<
            lpLENGTH   = 0x00180000,                    //!<
            lpBAUDRATE = 0x03e00000,                    //!<
            lpSIXLPI   = 0x00000004,                    //!<
            lpOVFU     = 0x00000002,                    //!<
            lpONLINE   = 0x00000001,                    //!<
        };

        //!
        //! \brief
        //!    MTDIR Register Bit Definitions
        //!

        enum mtdir_bits_t : uint64_t {
            mtDIR_READ   = 0x8000000000000000ULL,       //!< MT function is a read operation
            mtDIR_STB    = 0x4000000000000000ULL,       //!< MT data strobe
            mtDIR_INIT   = 0x2000000000000000ULL,       //!< MT initialize
            mtDIR_READY  = 0x1000000000000000ULL,       //!< MT data is ready
            mtDIR_INCFC  = 0x0800000000000000ULL,       //!< MT increment frame count
            mtDIR_SS     = 0x0700000000000000ULL,       //!< MT slave select
            mtDIR_DEN    = 0x00e0000000000000ULL,       //!< MT tape density
            mtDIR_FUN    = 0x001f000000000000ULL,       //!< MT function
            mtDIR_FMT    = 0x0000f00000000000ULL,       //!< MT tape format
            mtDIR_WCZ    = 0x0000080000000000ULL,       //!< MT word cound is zero
            mtDIR_FCZ    = 0x0000040000000000ULL,       //!< MT frame count is zero
            mtDIR_SETBOT = 0x0000020000000000ULL,       //!< MT set beginning of tape
            mtDIR_CLRBOT = 0x0000010000000000ULL,       //!< MT clear beginning of tape
            mtDIR_SETEOT = 0x0000008000000000ULL,       //!< MT set end of tape
            mtDIR_CLREOT = 0x0000004000000000ULL,       //!< MT clear end of tape
            mtDIR_SETTM  = 0x0000002000000000ULL,       //!< MT set tape mark
            mtDIR_CLRTM  = 0x0000001000000000ULL,       //!< MT clear end of tape
            mtDIR_DATA   = 0x0000000fffffffffULL,       //!< MT data
        };

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
        static uint32_t readKMCCCR(void);
        static void writeKMCCCR(uint32_t data);
        static uint32_t readDUPCCR(void);
        static void writeDUPCCR(uint32_t data);
        static uint32_t readDZCCR(void);
        static void writeDZCCR(uint32_t data);
        static uint32_t readLPCCR(void);
        static void writeLPCCR(uint32_t data);
        static uint32_t readMTCCR(void);
        static void writeMTCCR(uint32_t data);
        static uint32_t readRPCCR(void);
        static void writeRPCCR(uint32_t data);
        static data_t readBRAR(int unit);
        static void writeBRAR(int unit, data_t data);
        static data_t readBRMR(int unit);
        static void writeBRMR(int unit, data_t data);
        static data_t readITR(void);
        static void writeITR(data_t data);
        static data_t readPCIR(void);
        static uint64_t getMTDEBUG(void);
        static uint64_t getRPDEBUG(void);
        static uint64_t readMTDIR(void);
        static void writeMTDIR(uint64_t data);
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
        static void printMTDEBUG(void);
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
        static volatile       uint32_t *regMTCCR;               //!< MT Console Control Register
        static volatile       uint32_t *regDUPCCR;              //!< DUP11 Console Control Register
        static volatile       uint32_t *regKMCCCR;              //!< KMC11 Console Control Register
        static volatile       uint64_t *regITR;                 //!< Instruction Trace Register
        static volatile       uint64_t *regPCIR;                //!< Program Counter and Instruction Register
        static volatile       uint64_t *regMTDIR;               //!< MT Data Interface Register
        static volatile const uint64_t *regMTDEBUG;             //!< MT Debug Register
        static volatile const uint64_t *regRPDEBUG;             //!< RP Debug Register
        static volatile       addr_t   *regBRAR0;               //!< Breakpoint Address Register #0
        static volatile       addr_t   *regBRMR0;               //!< Breakpoint Mask Register #0
        static volatile       addr_t   *regBRAR1;               //!< Breakpoint Address Register #1
        static volatile       addr_t   *regBRMR1;               //!< Breakpoint Mask Register #1
        static volatile       addr_t   *regBRAR2;               //!< Breakpoint Address Register #2
        static volatile       addr_t   *regBRMR2;               //!< Breakpoint Mask Register #2
        static volatile       addr_t   *regBRAR3;               //!< Breakpoint Address Register #3
        static volatile       addr_t   *regBRMR3;               //!< Breakpoint Mask Register #3
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
//! \addtogroup ks10_lowlevel_api
//! \{

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

//! \}

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

//! \addtogroup ks10_console_api
//! \{

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
//!    This function is not thread safe.
//!

inline ks10_t::data_t ks10_t::__readRegCIR(void) {
    return *regCIR;
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

inline ks10_t::data_t ks10_t::readRegCIR(void) {
    LOCK();
    data_t ret = __readRegCIR();
    UNLOCK();
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
//!    This function is not thread safe.
//!

inline void ks10_t::__writeRegCIR(data_t data) {
    *regCIR = data;
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

inline void ks10_t::writeRegCIR(data_t data) {
    LOCK();
    __writeRegCIR(data);
    UNLOCK();
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
//!    This function reads a 32-bit value from the MTCCR
//!
//! \returns
//!    contents of the MTCCR register
//!
//! \note
//!    This function is thread safe.
//!

inline uint32_t ks10_t::readMTCCR(void) {
    return *regMTCCR;
}

//!
//! \brief
//!    This function writes a 32-bit value to the MTCCR
//!
//! \param data -
//!    data is the data to be written to the MTCCR
//!
//! \note
//!    This function is thread safe.
//!

inline void ks10_t::writeMTCCR(uint32_t data) {
    *regMTCCR = data;
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
//!    This function reads a 32-bit value from the KMCCCR
//!
//! \returns
//!    contents of the KMCCCR register
//!
//! \note
//!    This function is thread safe.
//!

inline uint32_t ks10_t::readKMCCCR(void) {
    return *regKMCCCR;
}

//!
//! \brief
//!    This function writes a 32-bit value to the KMCCCR
//!
//! \param data -
//!    data is the data to be written to the KMCCCR
//!
//! \note
//!    This function is thread safe.
//!

inline void ks10_t::writeKMCCCR(uint32_t data) {
    *regKMCCCR = data;
}

//!
//! \brief
//!    This function reads a 36-bit value from the Breakpoint Address Register
//!
//! \returns
//!    contents of the BRAR register
//!
//! \note
//!    This function is thread safe.
//!

inline uint64_t ks10_t::readBRAR(int unit) {
    uint64_t ret;
    LOCK();
    switch(unit & 0x03) {
        case 0: ret = *regBRAR0; break;
        case 1: ret = *regBRAR1; break;
        case 2: ret = *regBRAR2; break;
        case 3: ret = *regBRAR3; break;
    }
    UNLOCK();
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

inline void ks10_t::writeBRAR(int unit, uint64_t data) {
    LOCK();
    switch(unit & 0x03) {
        case 0: *regBRAR0 = data; break;
        case 1: *regBRAR1 = data; break;
        case 2: *regBRAR2 = data; break;
        case 3: *regBRAR3 = data; break;
    }
    UNLOCK();
}

//!
//! \brief
//!   This function reads a 36-bit value from the Breakpoint Mask Register
//!
//! \returns
//!    contents of the BRMR register
//!
//! \note
//!    This function is thread safe.
//!

inline uint64_t ks10_t::readBRMR(int unit) {
    uint64_t ret;
    LOCK();
    switch(unit & 0x03) {
        case 0: ret = *regBRMR0; break;
        case 1: ret = *regBRMR1; break;
        case 2: ret = *regBRMR2; break;
        case 3: ret = *regBRMR3; break;
    }
    UNLOCK();
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

inline void ks10_t::writeBRMR(int unit, uint64_t data) {
    LOCK();
    switch(unit & 0x03) {
        case 0: *regBRMR0 = data; break;
        case 1: *regBRMR1 = data; break;
        case 2: *regBRMR2 = data; break;
        case 3: *regBRMR3 = data; break;
    }
     UNLOCK();
}

//!
//! \brief
//!    This function reads a 36-bit value from the Instruction Trace Register.
//!    The trace buffer automatically increments when the trace buffer is read.
//!
//! \returns
//!    Contents of the ITR register
//!
//! \note
//!    This function is thread safe.
//!

inline uint64_t ks10_t::readITR(void) {
    LOCK();
    uint64_t ret = *regITR;
    UNLOCK();
    return ret;
}

//!
//! \brief
//!    This function writess a 36-bit value to the Instruction Trace Register.
//!
//! \param data -
//!    data is the data to be written to the ITR
//!
//! \note
//!    This function is thread safe.
//!

inline void ks10_t::writeITR(uint64_t data) {
    LOCK();
    *regITR = data;
    UNLOCK();
}

//!
//! \brief
//!    This function reads a 64-bit value from the Debug Program Counter and
//!    Instruction Register.
//!
//! \param data -
//!    data is the data to be written to the MTDIR
//!
//! \note
//!    This function is thread safe.
//!

inline uint64_t ks10_t::readPCIR(void) {
    LOCK();
    uint64_t ret = *regPCIR;
    UNLOCK();
    return ret;
}

//!
//! \brief
//!    This function reads a 64-bit value from the MT Data Interface Register.
//!
//! \returns
//!    contents of the MTDIR register
//!
//! \note
//!    This function is thread safe.
//!

inline uint64_t ks10_t::readMTDIR(void) {
    LOCK();
    uint64_t ret = *regMTDIR;
    UNLOCK();
    return ret;
}

//!
//! \brief
//!    This function writes a 64-bit value to the MT Data Interface Register
//!
//! \param data -
//!    data is the data to be written to the MTDIR
//!
//! \note
//!    This function is thread safe.
//!

inline void ks10_t::writeMTDIR(uint64_t data) {
    LOCK();
    *regMTDIR = data;
    UNLOCK();
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
    LOCK();
    uint64_t ret = *regRPDEBUG;
    UNLOCK();
    return ret;
}

//!
//! \brief
//!    Get Contents of MT Debug Register
//!
//! \brief
//!    This function return the contents of the MT Debug Register
//!
//! \returns
//!     Contents of the MT Debug Register
//!
//! \note
//!    This function is thread safe.
//!

inline uint64_t ks10_t::getMTDEBUG(void) {
    LOCK();
    uint64_t ret = *regMTDEBUG;
    UNLOCK();
    return ret;
}

/* ks10_console_api */  //! \}
//! \addtogroup ks10_control_api
//! \{

//!
//! \brief
//!    This function controls the <b>RUN</b> mode of the KS10.
//!
//! \param enable -
//!    <b>True</b> puts the KS10 in <b>RUN</b> mode.
//!    <b>False</b> puts the KS10 in <b>HALT</b> mode.
//!
//! \note
//!    This function is not thread safe.
//!

inline void ks10_t::__run(bool enable) {
    if (enable) {
        __writeRegStat(__readRegStat() | statRUN);
    } else {
        __writeRegStat(__readRegStat() & ~statRUN);
    }
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
//!    This function is not thread safe.
//!

inline bool ks10_t::__run(void) {
    return __readRegStat() & statRUN;
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
//!    This function is not thread safe.
//!

inline void ks10_t::__startEXEC(void) {
    __writeRegStat(statCONT | statEXEC | __readRegStat());
}

//!
//! \brief
//!    Execute a single instruction in the CIR
//!
//! \note
//!    This function is thread safe.
//!

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
//!    This function is not thread safe.
//!

inline void ks10_t::__startSTEP(void) {
    __writeRegStat(statCONT | __readRegStat());
}

//!
//! \brief
//!    Execute a single instruction at the current PC
//!
//! \note
//!    This function is thread safe.
//!

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
//!    This function is not thread safe.
//!

inline void ks10_t::__startCONT(void) {
    __writeRegStat(statRUN | statCONT | __readRegStat());
}

//!
//! \brief
//!    Continue execution at the current PC.
//!
//! \note
//!    This function is thread safe.
//!

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
//!    This function is not thread safe.
//!

inline void ks10_t::__startRUN(void) {
    __writeRegStat(statRUN | statCONT | statEXEC | __readRegStat());
}

//!
//! \brief
//!    Begin execution with instruction in the CIR.
//!
//! \note
//!    This function is thread safe.
//!

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
//!    This function is not thread safe.
//!

inline bool ks10_t::__halt(void) {
    return __readRegStat() & statHALT;
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

inline bool ks10_t::halt(void) {
    lockMutex();
    bool ret = __halt();
    unlockMutex();
    return ret;
}

//!
//! \brief
//!    Report the state of the KS10's interval timer.
//!
//! \returns
//!    Returns <b>true</b> if the KS10 interval timer enabled and <b>false</b>
//!    otherwise.
//!
//! \note
//!    This function is not thread safe.
//!

inline bool ks10_t::__timerEnable(void) {
    return __readRegStat() & statTIMEREN;
}

//!
//! \brief
//!    Report the state of the KS10's interval timer.
//!
//! \returns
//!    Returns <b>true</b> if the KS10 interval timer enabled and <b>false</b>
//!    otherwise.
//!
//! \note
//!    This function is thread safe.
//!

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
//!    This function is not thread safe.
//!

inline void ks10_t::__timerEnable(bool enable) {
    if (enable) {
        __writeRegStat(__readRegStat() | statTIMEREN);
    } else {
        __writeRegStat(__readRegStat() & ~statTIMEREN);
    }
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
//!    This function is not thread safe.
//!

inline bool ks10_t::__trapEnable(void) {
    return __readRegStat() & statTRAPEN;
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
//!    This function is not thread safe.
//!

inline void ks10_t::__trapEnable(bool enable) {
    if (enable) {
        __writeRegStat(__readRegStat() | statTRAPEN);
    } else {
        __writeRegStat(__readRegStat() & ~statTRAPEN);
    }
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
//!    This function is not thread safe.
//!

inline bool ks10_t::__cacheEnable(void) {
    return __readRegStat() & statCACHEEN;
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
//!    This function is not thread safe.
//!

inline void ks10_t::__cacheEnable(bool enable) {
    if (enable) {
        __writeRegStat(__readRegStat() | statCACHEEN);
    } else {
        __writeRegStat(__readRegStat() & ~statCACHEEN);
    }
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
//!    This function is not thread safe.
//!

inline bool ks10_t::__cpuReset(void) {
    return __readRegStat() & statRESET;
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
//!    This function controls whether the KS10's is reset. When reset, the KS10 will
//!    reset on next clock cycle without completing the current operation.
//!
//! \param
//!    enable is <b>true</b> to assert <b>reset</b> to the KS10 or <b>false</b> to
//!    negate <b>reset</b> to the KS10.
//!
//! \note
//!    This function is not thread safe.
//!

inline void ks10_t::__cpuReset(bool enable) {
    if (enable) {
        __writeRegStat(__readRegStat() | statRESET);
    } else {
        __writeRegStat(__readRegStat() & ~statRESET);
    }
}

//!
//! \brief
//!    Reset the KS10
//!
//! \details
//!    This function controls whether the KS10's is reset. When reset, the KS10 will
//!    reset on next clock cycle without completing the current operation.
//!
//! \param
//!    enable is <b>true</b> to assert <b>reset</b> to the KS10 or <b>false</b> to
//!    negate <b>reset</b> to the KS10.
//!
//! \note
//!    This function is thread safe.
//!

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
//!    The NXM/NXD bit is volatile. This function will reset the state of the
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

/* ks10_control_api */ //! \}

//!
//! \brief
//!    Execute a single instruction
//!
//! \param insn -
//!    Instruction to execute
//!
//! \note
//!    This function is not thread safe.
//!
//! \addtogroup ks10_cpu_api
//! \{

inline void ks10_t::__executeInstruction(data_t insn) {
    __writeRegCIR(insn);
    __startEXEC();
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

inline void ks10_t::executeInstruction(data_t insn) {
    lockMutex();
    __executeInstruction(insn);
    unlockMutex();
}
/* ks10_cpu_api */ //! \}

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

//! \addtogroup ks10_mem_api
//! \{

//!
//! \brief
//!    This function to reads a 36-bit word from KS10 memory.
//!
//! \details
//!    This is a physical address write. Writes to address 0 to 17 (octal)
//!    go to memory not to registers.
//!
//! \param [in] addr -
//!    Memory address
//!
//! \see
//!    readIO() for 36-bit IO reads,<br>
//!    readIO16() for 16-bit IO reads,<br>
//!    and readIO8() for 8-bit IO reads.
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

//!
//! \brief
//!    This function to reads a 36-bit word from KS10 memory.
//!
//! \details
//!    This is a physical address write. Writes to address 0 to 17 (octal)
//!    go to memory not to registers.
//!
//! \param [in] addr -
//!    Memory address
//!
//! \see
//!    readIO() for 36-bit IO reads,<br>
//!    readIO16() for 16-bit IO reads,<br>
//!    and readIO8() for 8-bit IO reads.
//!
//! \returns
//!    Contents of the KS10 memory that was read.
//!
//! \note
//!    This function is thread safe.
//!

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
//!    This is a physical address write. Writes to address 0 to 17 (octal)
//!    go to memory not to registers.
//!
//! \param [in] addr -
//!    Memory address
//!
//! \param [in] data -
//!    Data to be written to memory
//!
//! \see
//!    writeIO() for 36-bit IO writes,<br>
//!    writeIO16() for 16-bit IO writes,<br>
//!    writeIO8() for 8-bit IO writes.
//!
//! \note
//!    This function is not thread safe.
//!

inline void ks10_t::__writeMem(addr_t addr, data_t data) {
    __writeRegAddr((addr & memAddrMask) | flagWrite | flagPhys);
    __writeRegData(data);
    __statGO();
}

//!
//! \brief
//!    This function writes a 36-bit word to KS10 memory.
//!
//! \details
//!    This is a physical address write. Writes to address 0 to 17 (octal)
//!    go to memory not to registers.
//!
//! \param [in] addr -
//!    Memory address
//!
//! \param [in] data -
//!    Data to be written to memory
//!
//! \see
//!    writeIO() for 36-bit IO writes,<br>
//!    writeIO16() for 16-bit IO writes,<br>
//!    writeIO8() for 8-bit IO writes.
//!
//! \note
//!    This function is thread safe.
//!

inline void ks10_t::writeMem(addr_t addr, data_t data) {
    lockMutex();
    __writeMem(addr, data);
    unlockMutex();
}

/* ks10_mem_api */ //! \}
//! \addtogroup ks10_io_api
//! \{

//!
//! \brief
//!    This function reads a 36-bit word from KS10 IO.
//!
//! \param [in] addr -
//!    IO address
//!
//! \see
//!    readMem() for 36-bit memory reads,<br>
//!    readIO16() for 16-bit IO reads,<br>
//!    and readIO8 for 8-bit IO reads.
//!
//! \returns
//!    Contents of the KS10 IO that was read.
//!
//! \note
//!    This function is not thread safe.
//!

inline ks10_t::data_t ks10_t::__readIO(addr_t addr) {
    __writeRegAddr((addr & ioAddrMask) | flagRead | flagPhys | flagIO);
    __statGO();
    return dataMask & __readRegData();
}

//!
//! \brief
//!    This function reads a 36-bit word from KS10 IO.
//!
//! \param [in] addr -
//!    IO address
//!
//! \see
//!    readMem() for 36-bit memory reads,<br>
//!    readIO16() for 16-bit IO reads,<br>
//!    and readIO8 for 8-bit IO reads.
//!
//! \returns
//!    Contents of the KS10 IO that was read.
//!
//! \note
//!    This function is thread safe.
//!

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
//!    IO address
//!
//! \param [in] data -
//!    Data to be written to the IO device
//!
//! \see
//!    writeMem() for memory writes,<br>
//!    writeIO16() for 16-bit IO writes,<br>
//!    and writeIO8() for 8-bit IO writes.
//!
//! \note
//!    This function is not thread safe.
//!

inline void ks10_t::__writeIO(addr_t addr, data_t data) {
    __writeRegAddr((addr & ioAddrMask) | flagWrite | flagPhys | flagIO);
    __writeRegData(data);
    __statGO();
}

//!
//! \brief
//!    This function writes a 36-bit word to the KS10 IO.
//!
//! \details
//!    This function is used to write to 36-bit KS10 IO
//!
//! \param [in] addr -
//!    IO address
//!    addr is the address in the KS10 IO space which is to be written.
//!
//! \param [in] data -
//!    Data to be written to the IO device
//!
//! \see
//!    writeMem() for memory writes,<br>
//!    writeIO16() for 16-bit IO writes,<br>
//!    and writeIO8() for 8-bit IO writes.
//!
//! \note
//!    This function is thread safe.
//!

inline void ks10_t::writeIO(addr_t addr, data_t data) {
    lockMutex();
    __writeIO(addr, data);
    unlockMutex();
}

//!
//! \brief
//!    This function reads an 16-word from KS10 Unibus IO.
//!
//! \param [in]
//!    IO address
//!    addr is the address in the Unibus IO space which is to be read.
//!
//! \see
//!    readMem() for 36-bit memory reads,<br>
//~    readIO() for 36-bit IO reads,<br>
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

//!
//! \brief
//!    This function reads an 16-word from KS10 Unibus IO.
//!
//! \param [in] addr -
//!    IO address
//!
//! \see
//!    readMem() for 36-bit memory reads,<br>
//!    readIO() for 36-bit IO reads,<br>
//!    and readIO8() for 8-bit IO reads.
//!
//! \returns
//!    Contents of the KS10 Unibus IO that was read.
//!
//! \note
//!    This function is not thread safe.
//!

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
//! \param addr -
//!    IO address
//!
//! \param data -
//!    Data to be written to the Unibus IO device
//!
//! \see
//!    writeMem() for 36-bit memory reads,<br>
//!    writeIO() for 36-bit IO reads,<br>
//!    and writeIO8() for 8-bit IO reads.
//!
//! \note
//!    This function is not thread safe.
//!

inline void ks10_t::__writeIO16(addr_t addr, uint16_t data) {
    __writeRegAddr((addr & ioAddrMask) | flagWrite | flagPhys | flagIO | flagByte);
    __writeRegData(data);
    __statGO();
}

//!
//! \brief
//!    This function writes 16-word to KS10 Unibus IO.
//!
//! \param [in] addr -
//!    IO address
//!
//! \param [in] data -
//!    Data to be written to the Unibus IO device
//!
//! \see
//!    writeMem() for 36-bit memory reads,<br>
//!    writeIO() for 36-bit IO reads,<br>
//!    and writeIO8() for 8-bit IO reads.
//!
//! \note
//!    This function is thread safe.
//!

inline void ks10_t::writeIO16(addr_t addr, uint16_t data) {
    lockMutex();
    __writeIO16(addr, data);
    unlockMutex();
}

//!
//! \brief
//!    This function reads an 8-bit byte from KS10 Unibus IO.
//!
//! \param [in] addr -
//!    IO address
//!
//! \see
//!    readMem() for 36-bit memory reads,<br>
//!    readIO() for 36-bit IO reads,<br>
//!    and readIO16 for 16-bit IO reads.
//!
//! \returns
//!    Contents of the KS10 Unibus IO that was read.
//!
//! \note
//!    This function is not thread safe.
//!

inline uint8_t ks10_t::__readIO8(addr_t addr) {
    __writeRegAddr((addr & ioAddrMask) | flagRead | flagPhys | flagIO | flagByte);
    __statGO();
    return 0xff & __readRegData();
}

//!
//! \brief
//!    This function reads an 8-bit byte from the KS10 Unibus IO.
//!
//! \param [in] addr -
//!    IO address
//!
//! \see
//!    readMem() for 36-bit memory reads,<br>
//!    readIO() for 36-bit IO reads,<br>
//!    and readIO16 for 16-bit IO reads.
//!
//! \returns
//!    Contents of the KS10 Unibus IO that was read.
//!
//! \note
//!    This function is thread safe.
//!

inline uint8_t ks10_t::readIO8(addr_t addr) {
    lockMutex();
    uint8_t ret = __readIO8(addr);
    unlockMutex();
    return ret;
}

//!
//! \brief
//!    This function writes and 8-bit byte to the KS10 Unibus IO.
//!
//! \param [in] addr -
//!    IO address
//!
//! \param [in] data -
//!    Data to be written to the Unibus IO device
//!
//! \see
//!    writeMem() for 36-bit memory writes,<br>
//!    writeIO() for 36-bit IO reads,<br>
//!    and writeIO16 for 16-bit IO reads.
//!
//! \note
//!    This function is not thread safe.
//!

inline void ks10_t::__writeIO8(addr_t addr, uint8_t data) {
    __writeRegAddr((addr & ioAddrMask) | flagWrite | flagPhys | flagIO | flagByte);
    __writeRegData(data);
    __statGO();
}

//!
//! \brief
//!    This function writes an 8-bit byte to the KS10 Unibus IO.
//!
//! \param [in] addr -
//!    IO address
//!
//! \param [in] data -
//!    Data to be written to the Unibus IO device
//!
//! \see
//!    writeMem() for 36-bit memory writes,<br>
//!    writeIO() for 36-bit IO reads,<br>
//!    and writeIO16 for 16-bit IO reads.
//!
//! \note
//!    This function is thread safe.
//!

inline void ks10_t::writeIO8(addr_t addr, uint8_t data) {
    lockMutex();
    __writeIO8(addr, data);
    unlockMutex();
}

/* ks10_io_api */ //! \}
/* ks10_api    */ //! \}

#endif
