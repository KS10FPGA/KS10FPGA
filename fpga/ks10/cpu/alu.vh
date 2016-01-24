////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Arithmetic Logic Unit (ALU) Flag Definitions
//
// Details
//   Contains definitions that are useful to access ALU Flags
//
// File
//   alu.vh
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2015 Rob Doyle
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

`ifndef __ALU_VH
`define __ALU_VH

//
// ALU Flags
//

`define aluQR37(reg)   (reg[0])         // ALU Q Register LSB
`define aluLZERO(reg)  (reg[1])         // ALU left-half is zero
`define aluRZERO(reg)  (reg[2])         // ALU right-half is zero
`define aluLSIGN(reg)  (reg[3])         // ALU left-half sign
`define aluRSIGN(reg)  (reg[4])         // ALU right-half sign
`define aluAOV(reg)    (reg[5])         // ALU arithmetic overflow
`define aluCRY0(reg)   (reg[6])         // ALU carry into bit 0
`define aluCRY1(reg)   (reg[7])         // ALU carry into bit 1
`define aluCRY2(reg)   (reg[8])         // ALU carry into bit 2

`define aluSIGN(reg)   (reg[3])
`define aluZERO(reg)   ((reg[1]) & (reg[2]))

//
// Register Addresses
//

`define aluMAG          (4'o00)
`define aluPC           (4'o01)
`define aluHR           (4'o02)
`define aluAR           (4'o03)
`define aluARX          (4'o04)
`define aluBR           (4'o05)
`define aluBRX          (4'o06)
`define aluONE          (4'o07)
`define aluEBR          (4'o10)
`define aluUBR          (4'o11)
`define aluMASK         (4'o12)
`define aluFLG          (4'o13)
`define aluPI           (4'o14)
`define aluXWD1         (4'o15)
`define aluT0           (4'o16)
`define aluT1           (4'o17)

`endif
