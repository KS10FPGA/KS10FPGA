////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Debug Control/Status Register Header File
//
// Details
//   This file contains the Debug Control/Status Register bit definitions.
//
// File
//   debcsr.vh
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2020-2021 Rob Doyle
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

`ifndef __DEBCSR_VH
`define __DEBCSR_VH

//
// RPCCR bits
//

`define dcsrBRCMD(reg)   (reg[ 9:11])  // Breakpoint command
`define dcsrBRSTATE(reg) (reg[13:15])  // Breakpoint state
`define dcsrTRCMD(reg)   (reg[24:26])  // Trace command
`define dcsrTRSTATE(reg) (reg[27:29])  // Trace state
`define dcsrTRFULL(reg)  (reg[30])     // Trace full
`define dcsrTREMPTY(reg) (reg[31])     // Trace empty

`endif
