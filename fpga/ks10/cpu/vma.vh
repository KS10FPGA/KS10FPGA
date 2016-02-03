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
// Copyright (C) 2012-2016 Rob Doyle
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
// VMA Bit Definitions
//

`define vmaUSER(reg)     reg[ 0]        // User Mode
`define vmaEXEC(reg)     reg[ 1]        // Exec Mode
`define vmaFETCH(reg)    reg[ 2]        // Instruction fetch
`define vmaREAD(reg)     reg[ 3]        // Read cycle
`define vmaWRTEST(reg)   reg[ 4]        // Write test cycle
`define vmaWRITE(reg)    reg[ 5]        // Write cycle
`define vmaEXTD(reg)     reg[ 6]        // Extended address
`define vmaCACHEINH(reg) reg[ 7]        // Cache is inhibited
`define vmaPHYS(reg)     reg[ 8]        // Physical address
`define vmaPREV(reg)     reg[ 9]        // Previous context
`define vmaIO(reg)       reg[10]        // IO cycle
`define vmaWRU(reg)      reg[11]        // Who are you cycle
`define vmaVECT(reg)     reg[12]        // Read interrupt vector
`define vmaIOBYTE(reg)   reg[13]        // Byte IO cycle

`define vmaFLAGS(reg)    reg[ 0:13]     // Flags
`define vmaADDR(reg)     reg[14:35]     // Address

//
//  The ACs are addresses 0 to 15.  The ACs are never physically addressed.
//
//  Trace
//   DPM4/E160
//   DPM4/E168
//   DPM4/E191
//

`define vmaACREF(reg)    (!`vmaPHYS(reg) & (reg[18:31] == 14'b0))

`endif
