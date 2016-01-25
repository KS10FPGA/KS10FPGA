////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Instruction Register (IR) Definitions
//
// Details
//   Contains definitions that are useful to access IR fields
//
// File
//   regir.vh
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

`ifndef __REGIR_VH
`define __REGIR_VH

//
// IR Register Field Access
//

`define IR_OPCODE(reg) (reg[ 0: 8])             // IR opcode Field
`define IR_AC(reg)     (reg[ 9:12])             // IR AC field
`define IR_I(reg)      (reg[   13])             // IR I field
`define IR_XR(reg)     (reg[14:17])             // IR XR field
`define acZERO(reg)    (reg[ 9:12] == 0)        // AC field is zero
`define xrZERO(reg)    (reg[14:17] == 0)        // XR field is zero

`endif
