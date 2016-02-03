////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Dispatch ROM (DROM) Definitions
//
// Details
//   The Dispatch ROM is addressed by the instruction OPCODE and provides a
//   microcode dispatch address to handle the instruction as well as some other
//   instruction specific information.
//
// File
//   drom.vh
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

`ifndef __DROM_VH
`define __DROM_VH

`define DROM_WIDTH      36              // DROM Width

//
// Dispatch ROM Fields
//
// Details:
//  The Dispatch ROM is addressed by the instruction OPCODE and provides a
//  microcode dispatch address to handle the instruction as well as some other
//  instruction specific information.
//
// Notes
//  See page 5-39 of EK-0KS10-TM-002 for info about dromTXXXEN.  The bit is not
//  replicated into DROM DPEA/E114[2].
//
//  The microcode constrains the jump address ("cromJ") to be between o1400 and
//  o1777.  With this constraint, the four upper address bits of the "cromJ"
//  field are always b"0001".  This allows these four bits of data to be elided
//  from the DISPATCH ROM.  The KS10 then hard-wires these bits into the
//  dispatch logic.
//
//  This works nicely but creates a design that is somewhat difficult to
//  understand.   This specialization has been removed from the verilog design
//  - with no ill effects.
//
//  The verilog synthesis tool is smart and discovers that the contents of these
//  DISPATCH ROM bits are constant and replaces these ROM bit with hard-wired
//  logic anyway.
//
//  dromI and dromAEQJ are aliases of each other.
//
//  The dromTXXXEN usage is used in the schematic but it's definition is buried
//  deeply in the microcode.   The microcode states that  for the purposes of
//  the "Test Group" dispatch that "... bit 1 of the B field is used to
//  determine the sense"
//

`define dromA           drom[ 2: 5]     // Operand Fetch Mode
`define dromB           drom[ 8:11]     // Store result as:
`define dromROUND       drom[ 8]        // Round the result
`define dromMODE        drom[ 9]        // Seperate Add/Sub & Mul/Div
`define dromTXXXEN      drom[ 9]        // Test Instruction sense
`define dromFL_B        drom[10:11]     // Store Floating-point results as
`define dromJ           drom[12:23]     // Dispatch "Jump" address
`define dromACDISP      drom[24]        // Dispatch on AC Field
`define dromI           drom[25]        // Immediate dispatch on J field.
`define dromAEQJ        drom[25]        // Immediate dispatch on J field.
`define dromREADCYCLE   drom[26]        // Start a read at AREAD
`define dromWRTESTCYCLE drom[27]        // Start a write test at AREAD
`define dromCOND_FUNC   drom[28]        // Start a memory cycle on BWRITE
`define dromVMA         drom[29]        // Load the VMA on AREAD
`define dromWRITECYCLE  drom[30]        // Start a write on AREAD

`endif
