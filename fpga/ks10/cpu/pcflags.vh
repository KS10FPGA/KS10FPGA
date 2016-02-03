////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Program Counter (PC) Flags Definitions
//
// Details
//   Contains definitions that are useful to access PC Flags
//
// File
//   pcflags.vh
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

`ifndef __PCFLAGS_VH
`define __PCFLAGS_VH

//
// PC Flags
//

`define flagAOV(reg)    (reg[ 0])       // Arithmetic overflow
`define flagCRY0(reg)   (reg[ 1])       // Carry into bit 0
`define flagCRY1(reg)   (reg[ 2])       // Carry into bit 1
`define flagFOV(reg)    (reg[ 3])       // Floating-poing overflow
`define flagFPD(reg)    (reg[ 4])       // First Part Done
`define flagUSER(reg)   (reg[ 5])       // User Mode
`define flagUSERIO(reg) (reg[ 6])       // User mode IO instructions
`define flagPCU(reg)    (reg[ 6])       // Previous Context User
`define flagTRAP2(reg)  (reg[ 9])       // Trap2
`define flagTRAP1(reg)  (reg[10])       // Trap1
`define flagFXU(reg)    (reg[11])       // Floating-point underflow
`define flagNODIV(reg)  (reg[12])       // Divide failure

`endif
