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
// Copyright (C) 2013-2020 Rob Doyle
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

#include <stdio.h>
#include <fcntl.h>
#include <pthread.h>
#include <sys/mman.h>

#include "ks10.hpp"

int ks10_t::fd;                                         //!< /dev/mem file descriptor
bool ks10_t::debug;                                     //!< Debug mode
pthread_mutex_t ks10_t::lock;                           //!< FPGA access mutex
pthread_mutexattr_t ks10_t::attr;                       //!< FPGA access mutex attributes
char *ks10_t::fpgaAddrVirt;                             //!< FPGA Base Virtual Address

volatile ks10_t::addr_t *ks10_t::regAddr;               //!< Console Address Register
volatile ks10_t::data_t *ks10_t::regData;               //!< Console Data Register
volatile ks10_t::data_t *ks10_t::regCIR;                //!< KS10 Console Instruction Register
volatile uint32_t *ks10_t::regStat;                     //!< Console Control/Status Register
volatile uint32_t *ks10_t::regDZCCR;                    //!< DZ11 Console Control Register
volatile uint32_t *ks10_t::regLPCCR;                    //!< LP20 Console Control Register
volatile uint32_t *ks10_t::regRPCCR;                    //!< RPxx Console Control Register
volatile uint32_t *ks10_t::regDUPCCR;                   //!< DUP11 Console Control Register
volatile uint32_t *ks10_t::regDEBCSR ;                  //!< Debug Control/Status Register
volatile ks10_t::addr_t *ks10_t::regDEBBAR;             //!< Debug Breakpoint Address Register
volatile ks10_t::addr_t *ks10_t::regDEBBMR;             //!< Debug Breakpoint Mask Register
volatile uint64_t *ks10_t::regDEBITR;                   //!< Debug Instruction Trace Register
volatile uint64_t *ks10_t::regDEBPCIR ;                 //!< Debug Program Counter and Instruction Register
volatile const uint64_t *ks10_t::regRH11Debug;          //!< RH11 Debug Register
const char *ks10_t::regVers;                            //!< Firmware Version Register

//!
//! \brief
//!    Constructor
//!
//! \param debug
//!    <b>True</b> enables debug mode.
//!
//! \details
//!    The constructor initializes this object. It mmaps the FPGA address space.
//!

ks10_t::ks10_t(bool debug) {

    ks10_t::debug = debug;

    //
    // Open /dev/mem
    //

    int fd;
    if ((fd = open("/dev/mem", (O_RDWR | O_SYNC))) == -1) {
        printf("KS10: open(\"/dev/mem\") failed.\n"
               "      Aborting.\n");
        if (!debug) {
            exit(EXIT_FAILURE);
        }
    }

    //
    // Map FPGA Physical Address to Virtual Address
    //

    char *fpgaAddrVirt = (char *)mmap(NULL, fpgaAddrSize, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, fpgaAddrPhys);
    if (fpgaAddrVirt == MAP_FAILED) {
        printf("KS10: mmap(\"/dev/mem\") failed.\n"
               "      Aborting.\n");
        if (!debug) {
            exit(EXIT_FAILURE);
        }
    }

    //
    // Create a pthread mutex
    //

    int status;
    if ((status = pthread_mutexattr_init(&attr)) != 0) {
        printf("KS10: pthread_mutexattr_init() returned %d.\n"
               "      Aborting.\n", status);
        if (!debug) {
            exit(EXIT_FAILURE);
        }
    }

    if ((status = pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_ERRORCHECK)) != 0) {
        printf("KS10: pthread_mutexattr_settype() returned %d.\n"
               "      Aborting.\n", status);
        if (!debug) {
            exit(EXIT_FAILURE);
        }
    }

    if ((status = pthread_mutex_init(&lock, &attr)) != 0) {
        printf("KS10: pthread_mutex_init() returned %d.\n"
               "      Aborting.\n", status);
        if (!debug) {
            exit(EXIT_FAILURE);
        }
    }

    regAddr      = reinterpret_cast<volatile       addr_t   *>(&fpgaAddrVirt[regCONAROffset]);    //!< Console Address Register
    regData      = reinterpret_cast<volatile       data_t   *>(&fpgaAddrVirt[regCONDROffset]);    //!< Console Data Register
    regCIR       = reinterpret_cast<volatile       data_t   *>(&fpgaAddrVirt[regCONIROffset]);    //!< KS10 Console Instruction Register
    regStat      = reinterpret_cast<volatile       uint32_t *>(&fpgaAddrVirt[regCONCSROffset]);   //!< Console Control/Status Register
    regDZCCR     = reinterpret_cast<volatile       uint32_t *>(&fpgaAddrVirt[regDZCCROffset]);    //!< DZ11 Console Control Register
    regLPCCR     = reinterpret_cast<volatile       uint32_t *>(&fpgaAddrVirt[regLPCCROffset]);    //!< LP20 Console Control Register
    regRPCCR     = reinterpret_cast<volatile       uint32_t *>(&fpgaAddrVirt[regRPCCROffset]);    //!< RPxx Console Control Register
    regDUPCCR    = reinterpret_cast<volatile       uint32_t *>(&fpgaAddrVirt[regDUPCCROffset]);   //!< DUP11 Console Control Register
    regDEBCSR    = reinterpret_cast<volatile       uint32_t *>(&fpgaAddrVirt[regDEBCSROffset]);   //!< Debug Control/Status Register
    regDEBBAR    = reinterpret_cast<volatile       addr_t   *>(&fpgaAddrVirt[regDEBBAROffset]);   //!< Debug Breakpoint Address Register
    regDEBBMR    = reinterpret_cast<volatile       addr_t   *>(&fpgaAddrVirt[regDEBBMROffset]);   //!< Debug Breakpoint Mask Register
    regDEBITR    = reinterpret_cast<volatile       uint64_t *>(&fpgaAddrVirt[regDEBITROffset]);   //!< Debug Instruction Trace Register
    regDEBPCIR   = reinterpret_cast<volatile       uint64_t *>(&fpgaAddrVirt[regDEBPCIROffset]);  //!< Debug Program Counter and Instruction Register
    regRH11Debug = reinterpret_cast<volatile const uint64_t *>(&fpgaAddrVirt[regRH11Offset]);     //!< RH11 Debug Register
    regVers      = reinterpret_cast<         const char     *>(&fpgaAddrVirt[regVERSOffset]);     //!< Firmware Version Register
}

//!
//! \brief
//!    Destructor
//!
//! \details
//!    The destructor destroys this object. This function:
//!       #.  destroys the mutex, and
//!       #.  unmmaps the FPGA address space.
//!

ks10_t::~ks10_t(void) {
    pthread_mutex_destroy(&lock);
    if (munmap(fpgaAddrVirt, fpgaAddrSize) != 0) {
        printf("KS10: munmap() failed.\n");
    }
    close(fd);
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

void ks10_t::__go(void) {
    writeRegStat(readRegStat() | statGO);
    for (int i = 0; i < 100; i++) {
        if ((readRegStat() & statGO) == 0) {
           return;
        }
        usleep(1000);
    }
    printf("KS10: GO-bit timeout\n");
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
//!    This function is thread safe.
//!

void ks10_t::go(void) {
    lockMutex();
    writeRegStat(readRegStat() | statGO);
    unlockMutex();
    for (int i = 0; i < 100; i++) {
        if ((readRegStat() & statGO) == 0) {
           return;
        }
        usleep(1000);
    }
    printf("KS10: GO-bit timeout\n");
}

//!
//! \brief
//!    Boot (Unreset) the KS10
//!
//! \note
//!    This function is thread safe.
//!

void ks10_t::boot(void) {

    if (!cpuReset()) {
        cpuReset(true);
        if (!cpuReset()) {
            printf("KS10: CPU reset failed.\n");
            if (!debug) {
                exit(EXIT_FAILURE);
            }
        }
    }

    if (__halt()) {
        printf("KS10: CPU should not be halted.\n");
        if (!debug) {
            exit(EXIT_FAILURE);
        }
    }

    if (run()) {
        printf("KS10: CPU should not be running.\n");
        if (!debug) {
            exit(EXIT_FAILURE);
        }
    }

    cpuReset(false);

    if (cpuReset()) {
        printf("KS10: CPU should be not be reset.\n");
        if (!debug) {
            exit(EXIT_FAILURE);
        }
    }

    if (__halt()) {
        printf("KS10: CPU should not be halted.\n");
        if (!debug) {
            exit(EXIT_FAILURE);
        }
    }

    if (run()) {
        printf("KS10: CPU should not be running.\n");
        if (!debug) {
            exit(EXIT_FAILURE);
        }
    }

    for (int i = 0; i < 100; i++) {
        if (__halt()) {
            return;
        }
        usleep(1000);
    }

    printf("KS10: Timeout waiting for KS10 to initialize.\n");
    if (!debug) {
        exit(EXIT_FAILURE);
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
//! \note
//!    This function is thread safe.
//!

void ks10_t::checkFirmware(void) {
    const char *buf = regVers;
    if ((buf[0] == 'R') && (buf[1] == 'E') && (buf[2] == 'V') && (buf[5] == '.')) {
        printf("KS10: FPGA Firmware is %c%c%c %c%c%c%c%c\n",
               buf[0], buf[1], buf[2], buf[3], buf[4], buf[5], buf[6], buf[7]);
    } else if (debug) {
        printf("KS10: FPGA Firmware is %02x%02x%02x%02x%02x%02x%02x%02x\n",
               buf[0], buf[1], buf[2], buf[3], buf[4], buf[5], buf[6], buf[7]);
    } else {
        printf("KS10: Unable to communicate with the KS10 FPGA.\n"
               "KS10: Is the FPGA programmed?\n"
               "KS10: Console exiting.\n");
        exit(EXIT_FAILURE);
    }
}

//!
//! \brief
//!    This function tests 64-bit console interface registers.
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
//! \param mask -
//!    allows masking unimplemented register bits.  This is used to test 36-bit
//!    registers using the 64-bit interface.
//!
//! \returns
//!    True if test pass, false otherwise.
//!
//! \note
//!    This function is NOT thread safe.  Selftest should be performed as a
//!    single thread application.
//!

bool ks10_t::testReg64(volatile void * addr, const char *name, uint64_t mask) {
    if (debug) {
        printf("KS10:  %s: Checking 64-bit accesses.\n", name);
    }

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
        if ((read64 & mask) != (write64 & mask)) {
            if (debug) {
                printf("KS10:  %s: Register failure.  Was 0x%016llx.  Should be 0x%016llx\n", name, read64, write64);
            }
            success = false;
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
//!    This function tests 32-bit console interface registers.
//!
//! \details
//!    This test performs a 32-bit "walking ones test" on the the register.
//!    This verified both the register and the bus interface between the MCU and
//!    the FPGA.
//!
//! \param addr -
//!    address of the register in the EPI address space.
//!
//! \param name -
//!    name of the register used in verbose debugging messages
//!
//! \param mask -
//!    allows masking unimplemented register bits.  This is used to test 36-bit
//!    registers using the 64-bit interface.
//!
//! \returns
//!    True if test pass, false otherwise.
//!
//! \note
//!    This function is NOT thread safe.  Selftest should be performed as a
//!    single thread application.
//!

bool ks10_t::testReg32(volatile void * addr, const char *name, uint32_t mask) {

    if (debug) {
        printf("KS10:  %s: Checking 32-bit accesses.\n", name);
    }

    //
    // Save register contents
    //

    uint32_t save = readReg32(addr);

    //
    // Perform test
    //

    bool success = true;
    volatile uint32_t * reg32 = reinterpret_cast<volatile uint32_t *>(addr);

    for (uint32_t write32 = 1; write32 != 0; write32 <<= 1) {
        *reg32 = write32;
        uint32_t read32 = *reg32;
        if ((read32 & mask) != (write32 & mask)) {
            if (debug) {
                printf("KS10:  %s: Register failure.  Was 0x%08x.  Should be 0x%08x\n", name, read32, write32);
            }
            success = false;
        }
    }

    //
    // Restore register contents
    //

    writeReg32(addr, save);

    return success;
}

//!
//! \brief
//!    Test all of the KS10 Registers
//!
//! \returns
//!    True if all of the tests pass, false otherwise.
//!
//! \note
//!    This function is NOT thread safe.  Selftest should be performed as a
//!    single thread application.
//!

void ks10_t::testRegs(void) {
    bool success = true;
    if (debug) {
        printf("KS10: Console Interface Register test.\n");
    }
    success &= testReg64(regAddr,   "regADDR  ", 0xfffffffff);
    success &= testReg64(regData,   "regDATA  ", 0xfffffffff);
    success &= testReg64(regCIR,    "regCIR   ", 0xfffffffff);
    success &= testReg32(regStat,   "regStat  ", 0x0000021d);
    success &= testReg32(regDZCCR,  "regDZCCR ", 0xffffffff);
    success &= testReg32(regLPCCR,  "regLPCCR ", 0x03ff0002);
    success &= testReg32(regRPCCR,  "regRPCCR ", 0xffffffff);
    success &= testReg32(regDUPCCR, "regDUPCCR", 0x0f000e00);
    success &= testReg32(regDEBCSR, "regDEBCSR", 0x007000e0);
    success &= testReg64(regDEBBAR, "regDEBBAR", 0xfffffffff);
    success &= testReg64(regDEBBMR, "regDEBBMR", 0xfffffffff);
    if (success) {
        printf("KS10: Console Interface Register test completed successfully.\n");
    } else {
        printf("KS10: Fatal - Console Interface Register test failed.\n");
        if (!debug) {
            exit(EXIT_FAILURE);
        }
    }
}

//!
//! \brief
//!    Write a character to the KS10
//!
//! \param ch -
//!    Character to write to the KS10
//!
//! \note
//!    This function is thread safe.
//!

void ks10_t::putchar(int ch) {
    lockMutex();
    data_t data = __readMem(ctyinADDR);
    if ((data & ctyVALID) == 0) {
        __writeMem(ctyinADDR, ctyVALID | (ch & 0xff));
        unlockMutex();
        cpuIntr();
        return;
    }
    unlockMutex();
}

//!
//! \brief
//!    Read a character from the KS10
//!
//! \returns
//!    Character from the KS10
//!
//! \note
//!    This function is thread safe.
//!

int ks10_t::getchar(void) {
    lockMutex();
    data_t ch = __readMem(ctyoutADDR);
    if ((ch & ctyVALID) != 0) {
        __writeMem(ctyoutADDR, 0);
        unlockMutex();
        return ch & 0x7f;
    }
    unlockMutex();
    return -1;
}

//!
//! \brief
//!    Store data into memory and then execute a single instruction
//!
//! \details
//!    This function puts data into memory and then executes a single
//!    instruction that uses that memory.  The contents of the memory location
//!    saved prior to storing the data and restored after executing the
//!    instruction.
//!
//! \param insn -
//!    Instruction to execute
//!
//! \param tempAddr -
//!    Temporary address for results.
//!
//! \param data -
//!    Data to store in temporary memory location
//!
//! \note
//!    This function is thread safe.
//!

void ks10_t::setDataAndExecuteInstruction(data_t insn, data_t data, addr_t tempAddr) {
    lockMutex();
    const data_t tempData = __readMem(tempAddr);
    __writeMem(tempAddr, data);
    __executeInstruction(insn);
    __writeMem(tempAddr, tempData);
    unlockMutex();
}

//!
//! \brief
//!    Execute a single instruction and return data
//!
//! \details
//!    This function executes an instruction that modifies memory.  The
//!    contents of the destination address are saved prior to executing the
//!    instruction and restored after executing the instruction.
//!
//! \param insn -
//!    Instruction to execute
//!
//! \param tempAddr -
//!    Temporary address for results.
//!
//! \returns
//!    Returns data from instruction execution.
//!
//! \note
//!    This function is NOT thread safe.
//!

#if 1
ks10_t::data_t ks10_t::__executeInstructionAndGetData(data_t insn, addr_t tempAddr) {
    const data_t tempData = __readMem(tempAddr);
    __executeInstruction(insn);
    data_t data = __readMem(tempAddr);
    __writeMem(tempAddr, tempData);
    return data;
}
#endif

//!
//! \brief
//!    Execute a single instruction and return data
//!
//! \details
//!    This function executes an instruction that modifies memory.  The
//!    contents of the destination address are saved prior to executing the
//!    instruction and restored after executing the instruction.
//!
//! \param insn -
//!    Instruction to execute
//!
//! \param tempAddr -
//!    Temporary address for results.
//!
//! \returns
//!    Returns data from instruction execution.
//!
//! \note
//!    This function is thread safe.
//!

ks10_t::data_t ks10_t::executeInstructionAndGetData(data_t insn, addr_t tempAddr) {
    lockMutex();
    const data_t tempData = __readMem(tempAddr);
    __executeInstruction(insn);
    data_t data = __readMem(tempAddr);
    __writeMem(tempAddr, tempData);
    unlockMutex();
    return data;
}

//!
//! \brief
//!   Function to print APRID
//!
//! \note
//!    This function is thread safe.
//!

ks10_t::data_t ks10_t::rdAPRID(void) {
    const addr_t tempAddr  = 0100;
    const data_t insnAPRID = (opAPRID << 18) | tempAddr;
    return executeInstructionAndGetData(insnAPRID, tempAddr);
}

//!
//! \brief
//!   Function to return RDAPR
//!
//! \note
//!    This function is thread safe.
//!

ks10_t::data_t ks10_t::rdAPR(void) {
    const addr_t tempAddr  = 0100;
    const data_t insnRDAPR = (opRDAPR << 18) | tempAddr;
    return executeInstructionAndGetData(insnRDAPR, tempAddr);
}

//!
//! \brief
//!   Function to return RDPI
//!
//! \note
//!    This function is thread safe.
//!

ks10_t::data_t ks10_t::rdPI(void) {
    const addr_t tempAddr = 0100;
    const data_t insnRDPI = (opRDPI << 18) | tempAddr;
    return executeInstructionAndGetData(insnRDPI, tempAddr);
}

//!
//! \brief
//!   Function to return RDUBR
//!
//! \note
//!    This function is thread safe.
//!

ks10_t::data_t ks10_t::rdUBR(void) {
    const addr_t tempAddr  = 0100;
    const data_t insnRDUBR = (opRDUBR << 18) | tempAddr;
    return executeInstructionAndGetData(insnRDUBR, tempAddr);
}

//!
//! \brief
//!   Function to return RDEBR
//!
//! \note
//!    This function is thread safe.
//!

ks10_t::data_t ks10_t::rdEBR(void) {
    const addr_t tempAddr  = 0100;
    const data_t insnRDEBR = (opRDEBR << 18) | tempAddr;
    return executeInstructionAndGetData(insnRDEBR, tempAddr);
}

//!
//! \brief
//!   Function to return RDEBR
//!
//! \note
//!    This function is thread safe.
//!

ks10_t::data_t ks10_t::rdSPB(void) {
    const addr_t tempAddr  = 0100;
    const data_t insnRDSPB = (opRDSPB << 18) | tempAddr;
    return executeInstructionAndGetData(insnRDSPB, tempAddr);
}

//!
//! \brief
//!   Function to return RDCSB
//!
//! \note
//!    This function is thread safe.
//!

ks10_t::data_t ks10_t::rdCSB(void) {
    const addr_t tempAddr  = 0100;
    const data_t insnRDCSB = (opRDCSB << 18) | tempAddr;
    return executeInstructionAndGetData(insnRDCSB, tempAddr);
}

//!
//! \brief
//!   Function to return RDCSTM
//!
//! \note
//!    This function is thread safe.
//!

ks10_t::data_t ks10_t::rdCSTM(void) {
    const addr_t tempAddr   = 0100;
    const data_t insnRDCSTM = (opRDCSTM << 18) | tempAddr;
    return executeInstructionAndGetData(insnRDCSTM, tempAddr);
}

//!
//! \brief
//!   Function to return RDPUR
//!
//! \note
//!    This function is thread safe.
//!

ks10_t::data_t ks10_t::rdPUR(void) {
    const addr_t tempAddr  = 0100;
    const data_t insnRDPUR = (opRDPUR << 18) | tempAddr;
    return executeInstructionAndGetData(insnRDPUR, tempAddr);
}

//!
//! \brief
//!   Function to return RDTIM
//!
//! \note
//!    This function is thread safe.
//!

ks10_t::data_t ks10_t::rdTIM(void) {
    const addr_t tempAddr  = 0100;
    const data_t insnRDTIM = (opRDTIM << 18) | tempAddr;
    return executeInstructionAndGetData(insnRDTIM, tempAddr);
}

//!
//! \brief
//!   Function to return RDINT
//!
//! \note
//!    This function is thread safe.
//!

ks10_t::data_t ks10_t::rdINT(void) {
    const addr_t tempAddr  = 0100;
    const data_t insnRDINT = (opRDINT << 18) | tempAddr;
    return executeInstructionAndGetData(insnRDINT, tempAddr);
}

//!
//! \brief
//!   Function to return RDHSB
//!
//! \note
//!    This function is thread safe.
//!

ks10_t::data_t ks10_t::rdHSB(void) {
    const addr_t tempAddr  = 0100;
    const data_t insnRDHSB = (opRDHSB << 18) | tempAddr;
    return executeInstructionAndGetData(insnRDHSB, tempAddr);
}

//!
//! \brief
//!    Read an AC from the KS10.
//!
//! \details
//!    Reading a register is a convoluted process.
//!
//!    -# Create a temporary memory location in the KS10 memory in which may be
//!       used to stash the contents AC.  Read the data at that location
//!       (addr 0100) and save the data in the  MCU.  We'll restore it when
//!       we're done.
//!    -# Execute a MOVEM instruction to move the register contents to the
//!       temporary memory location.
//!    -# The MCU can read the contents of the AC from the temporary memoy
//!       location.
//!    -# Restore the contents of the temporary memory locaction
//!
//! \param regAC -
//!    AC number
//!
//! \returns
//!    contents of the register
//!
//! \note
//!    This function is thread safe.
//!

ks10_t::data_t ks10_t::readAC(ks10_t::data_t regAC) {
    regAC &= 017;
    const addr_t tempAddr  = 0100;
    const data_t insnMOVEM = (opMOVEM << 18) | (regAC << 23) | tempAddr;
    return executeInstructionAndGetData(insnMOVEM, tempAddr);
}

//!
//! \brief
//!    Print Halt Status Word
//!
//! \details
//!    This function prints the Halt Status Word
//!
//! \note
//!    This function is thread safe.
//!

void ks10_t::printHaltStatusWord(void) {
    lockMutex();
    data_t hswStatus = __readMem(0);
    data_t hswPC     = __readMem(1);

    printf("KS10: Halt Cause: %s (PC=%06llo)\n",
           (hswStatus== 00000 ? "Microcode Startup."                     :
            (hswStatus== 00001 ? "Halt Instruction."                     :
             (hswStatus== 00002 ? "Console Halt."                        :
              (hswStatus== 00100 ? "IO Page Failure."                    :
               (hswStatus== 00101 ? "Illegal Interrupt Instruction."     :
                (hswStatus== 00102 ? "Pointer to Unibus Vector is zero." :
                 (hswStatus== 01000 ? "Illegal Microcode Dispatch."      :
                  (hswStatus== 01005 ? "Microcode Startup Check Failed." :
                   "Unknown.")))))))),
           hswPC);
    unlockMutex();
}

//!
//! \brief
//!    Print Halt Status Block
//!
//! \details
//!    This function prints the Halt Status Word and the Halt Status Block.
//!
//!    The code executes a RDHSB instruction in the Console Instruction
//!    Register to get the address of the Halt Status Block from the CPU.
//!
//! \note
//!    The KS10 Technical Manual shows that the Halt Status Block include the
//!    FE and SC register.  This is incorrect.   See ksrefRev2 document.
//!
//! \note
//!    This function is thread safe.
//!

void ks10_t::printHaltStatusBlock(void) {

    lockMutex();
    data_t hswStatus = __readMem(0);
    data_t hswPC     = __readMem(1);

    printf("KS10: Halt Cause: %s (PC=%06llo)\n",
           (hswStatus== 00000 ? "Microcode Startup."                     :
            (hswStatus== 00001 ? "Halt Instruction."                     :
             (hswStatus== 00002 ? "Console Halt."                        :
              (hswStatus== 00100 ? "IO Page Failure."                    :
               (hswStatus== 00101 ? "Illegal Interrupt Instruction."     :
                (hswStatus== 00102 ? "Pointer to Unibus Vector is zero." :
                 (hswStatus== 01000 ? "Illegal Microcode Dispatch."      :
                  (hswStatus== 01005 ? "Microcode Startup Check Failed." :
                   "Unknown.")))))))),
           hswPC);

#if 1

    //
    // Check CPU status
    //

    if (!ks10_t::__halt()) {
        printf("KS10: CPU is running. Halt it first.\n");
        return;
    }

    //
    // Read the address of the Halt Status Block
    //

    const addr_t tempAddr  = 0100;
    const data_t insnRDHSB = opRDHSB << 18 | tempAddr;
    ks10_t::addr_t hsbAddr = __executeInstructionAndGetData(insnRDHSB, tempAddr);

#else

    ks10_t::addr_t hsbAddr = 0376000ULL;

#endif

    //
    // Print the Halt Status Block
    //

    printf("  Halt Status Block Address is %06llo\n"
           "  PC  is %012llo     HR  is %012llo\n"
           "  MAG is %012llo     ONE is %012llo\n"
           "  AR  is %012llo     ARX is %012llo\n"
           "  BR  is %012llo     BRX is %012llo\n"
           "  EBR is %012llo     UBR is %012llo\n"
           "  MSK is %012llo     FLG is %012llo\n"
           "  PI  is %012llo     X1  is %012llo\n"
           "  TO  is %012llo     T1  is %012llo \n"
           "  VMA is %012llo\n",
           hsbAddr,
           __readMem(hsbAddr +  1),     // PC
           __readMem(hsbAddr +  2),     // HR
           __readMem(hsbAddr +  0),     // MAG
           __readMem(hsbAddr +  7),     // ONE
           __readMem(hsbAddr +  3),     // AR
           __readMem(hsbAddr +  4),     // ARX
           __readMem(hsbAddr +  5),     // BR
           __readMem(hsbAddr +  6),     // BRX
           __readMem(hsbAddr +  8),     // EBR
           __readMem(hsbAddr +  9),     // UBR
           __readMem(hsbAddr + 10),     // MASK
           __readMem(hsbAddr + 11),     // FLG
           __readMem(hsbAddr + 12),     // PI
           __readMem(hsbAddr + 13),     // X1
           __readMem(hsbAddr + 14),     // T0
           __readMem(hsbAddr + 15),     // T1
           __readMem(hsbAddr + 16));    // VMA
    unlockMutex();
}


//!
//! \brief
//!    Print RH11 Debug Word
//!
//! \note
//!    This function is thread safe.
//!

void ks10_t::printRH11Debug(void) {

    uint64_t rh11stat = getRH11debug();
    rh11debug_t *rh11debug = reinterpret_cast<rh11debug_t *>(&rh11stat);

    printf("KS10: RH11 status is 0x%016llx\n"
           "  State  = %d\n"
           "  ErrNum = %d\n"
           "  ErrVal = %d\n"
           "  WrCnt  = %d\n"
           "  RdCnt  = %d\n"
           "  LEDs   = 0x%02x\n"
           "",
           rh11stat,
           rh11debug->state,
           rh11debug->errnum,
           rh11debug->errval,
           rh11debug->wrcnt,
           rh11debug->rdcnt,
           rh11debug->LEDs);
}


//
//! @}
//
