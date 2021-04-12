////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RHCS1 Register Definitions
//
// File
//   rhcs1.vh
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2021 Rob Doyle
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

`ifndef __RHCS1_VH
`define __RHCS1_VH

//
// RHCS1 Register Bits
//

`define rhCS1_SC(reg)   (reg[15])       // Special conditions
`define rhCS1_TRE(reg)  (reg[14])       // Transfer error
`define rhCS1_CPE(reg)  (reg[13])       // Control parity error
`define rhCS1_DVA(reg)  (reg[11])       // Drive available
`define rhCS1_PSEL(reg) (reg[10])       // Port select
`define rhCS1_BAE(reg)  (reg[9:8])      // Bus address extension (A17/A16)
`define rhCS1_RDY(reg)  (reg[ 7])       // Ready
`define rhCS1_IE(reg)   (reg[ 6])       // Interrupt enable
`define rhCS1_FUN(reg)  (reg[5:1])      // Function
`define rhCS1_GO(reg)   (reg[ 0])       // Go

`endif
