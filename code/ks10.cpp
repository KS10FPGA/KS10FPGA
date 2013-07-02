/*!
********************************************************************************
**
** KS10 Console Microcontroller
**
** \brief
**     KS10 Interface Object
**
** \details
**     This object provides the interfaces that are required to interact with
**     the KS10 FPGA.
**
** \file
**     ks10.cpp
**
** \author
**     Rob Doyle - doyle (at) cox (dot) net
**
********************************************************************************
*/
/* Copyright (C) 2013 Rob Doyle
**
** This program is free software; you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation; either version 2 of the License, or
** (at your option) any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program; if not, write to the Free Software
** Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
**
********************************************************************************
*/

#include "ks10.hpp"

//!
//! \brief

//!
//! \brief
//!     This function to reads a 36-bit word from KS10 memory.
//!
//! \param
//!     addr is the address in the KS10 memory space which is to be read.
//!
//! \see
//!     readIO() for 36-bit IO reads, and readIObyte() for UNIBUS reads.
//!
//! \returns
//!     Contents of the KS10 memory that was read.
//!

ks10_t::data_t ks10_t::readMem(addr_t addr) {
    writeReg(regAddr, (addr & addrMask) | read);
    go();
    return readReg(regData);
}

//!
//! \brief
//!     This function reads a 36-bit word from KS10 IO.
//!
//! \param
//!     addr is the address in the KS10 IO space which is to be read.
//!
//! \see
//!     readMem() for 36-bit memory reads, and readIObyte() for UNIBUS reads.
//!
//! \returns
//!     Contents of the KS10 IO that was read.
//!

ks10_t::data_t ks10_t::readIO(addr_t addr) {
    writeReg(regAddr, (addr & addrMask) | read | io);
    go();
    return readByte(regData);
}

//!
//! \brief
//!     This function reads an 8-bit (or 16-bit) byte from KS10 UNIBUS IO.
//!
//! \param
//!     addr is the address in the Unibus IO space which is to be read.
//!
//! \see
//!     readMem() for 36-bit memory reads, and readIObyte() for UNIBUS
//!     reads.
//!
//! \returns
//!     Contents of the KS10 Unibus IO that was read.
//!

uint8_t ks10_t::readIObyte(addr_t addr) {
    writeReg(regAddr, (addr & addrMask) | read | io | byte);
    go();
    return readReg(regData);
}

//!
//! \brief
//!     This function writes a 36-bit word to KS10 memory.
//!
//! \param
//!     addr is the address in the KS10 memory space which is to be written.
//!
//! \param
//!     data is the data to be written to the KS10 memory.
//!
//! \see
//!     writeIO() for 36-bit IO writes, and writeIObyte() for UNIBUS writes.
//!
//! \returns
//!     Nothing.
//!

void ks10_t::writeMem(addr_t addr, data_t data) {
    writeReg(regAddr, (addr & addrMask) | write);
    go();
    writeReg(regData, data);
}

//!
//! \brief
//!     This function writes a 36-bit word to the KS10 IO.
//!
//! \param
//!     addr is the address in the KS10 IO space which is to be written.
//!
//! \param
//!     data is the data to be written to the KS10 IO.
//!
//! \details
//!     This function is used to write to 36-bit KS10 IO and is not to be
//!     used to write to UNIBUS style IO.  
//!
//! \see
//!     writeMem() for memory writes, and writeIObyte() for UNIBUS writes.
//!
//! \returns
//!     Nothing.
//!

void ks10_t::writeIO(addr_t addr, data_t data) {
    writeReg(regAddr, (addr & addrMask) | write | io);
    go();
    writeReg(regData, data);
}

//!
//! \brief
//!     This function writes 8-bit (or 16-bit) byte to KS10 Unibus IO.
//!
//! \param
//!     addr is the address in the KS10 Unibus IO space which is to be written.
//!
//! \param
//!     data is the data to be written to the KS10 
//!     Unibus IO.
//!
//! \returns
//!     Nothing.
//!

void ks10_t::writeIObyte(addr_t addr, uint8_t data) {
    writeReg(regAddr, (addr & addrMask) | write | io | byte);
    go();
    writeByte(regData, data);
}

//!
//! \brief
//!     This function builds a 36-bit data word from the
//!     contents of the .SAV file.
//!
//! \param
//!     b is a pointer to the input data
//!
//! \returns
//!     36-bit data word
//! 

ks10_t::data_t ks10_t::rdword(const uint8_t *b) {
    return (((uint64_t)b[0] << 28) |
            ((uint64_t)b[1] << 20) |
            ((uint64_t)b[2] << 12) |
            ((uint64_t)b[3] <<  4) |
            ((uint64_t)b[4] <<  0));
}

//!
//! \brief
//!     Get Halt Status Word
//!
//! \details
//!     This function return the contents of the Halt Status Word.
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
//!     Get Halt Status Word.
//!
//! \details
//!     This function return the contents of the Halt Status Block.
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
