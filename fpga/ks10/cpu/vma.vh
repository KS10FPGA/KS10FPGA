////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Virtual Memory Address (VMA) Flag Definitions
//
// Details
//   Contains definitions that are useful to access VMA Flags
//
// File
//   vma.vh
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2014 Rob Doyle
//
// This source file may be used and distributed without restriction provided
// that this copyright statement is not removed from the file and that any
// derivative work contains the original copyright notice and the associated
// disclaimer.
//
// This source file is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as published by the
// Free Software Foundation; version 2.1 of the License.
//
// This source is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License
// for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this source; if not, download it from
// http://www.gnu.org/licenses/lgpl.txt
//
////////////////////////////////////////////////////////////////////////////////

`ifndef __VMA_VH
`define __VMA_VH

//
// VMA Flags
//

`define vmaUSER(reg)        (reg[ 0])   // 1 = User Mode
`define vmaEXEC(reg)        (reg[ 1])   // 1 = Exec Mode
`define vmaFETCH(reg)       (reg[ 2])   // 1 = Instruction fetch
`define vmaREADCYCLE(reg)   (reg[ 3])   // 1 = Read Cycle (IO or Memory)
`define vmaWRTESTCYCLE(reg) (reg[ 4])   // 1 = Perform write test for page fail
`define vmaWRITECYCLE(reg)  (reg[ 5])   // 1 = Write Cycle (IO or Memory)
`define vmaUNUSED(reg)      (reg[ 6])   // Spare/Unused bit
`define vmaCACHEIHN(reg)    (reg[ 7])   // 1 = Cache is inhibited
`define vmaPHYSICAL(reg)    (reg[ 8])   // 1 = Physical reference
`define vmaPREVIOUS(reg)    (reg[ 9])   // 1 = VMA Previous Context
`define vmaIOCYCLE(reg)     (reg[10])   // 1 = IO Cycle, 0 = Memory Cycle
`define vmaWRUCYCLE(reg)    (reg[11])   // 1 = Read interrupt controller number
`define vmaVECTORCYCLE(reg) (reg[12])   // 1 = Read interrupt vector
`define vmaIOBYTECYCLE(reg) (reg[13])   // 1 = Unibus Byte IO Operation

`endif
