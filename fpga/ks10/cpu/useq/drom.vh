////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// \brief
//      Dispatch ROM (DROM) Definitions 
//
// \details
//      In the KS-10 implementation, the Dispatch ROM is unclocked
//      an the address is supplied by the Instruction Register (IR).
//
//      In this implementation, the Dispatch ROM is address is
//      clocked when the Instruction Register is loaded.  This
//      allows the Dispatch ROM to be implemented in an FPGA
//      compatible fashion.
//     
// \notes
//
// \file
//      drom.vh
//
// \author
//      Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2009, 2012 Rob Doyle
//
// This source file may be used and distributed without
// restriction provided that this copyright statement is not
// removed from the file and that any derivative work contains
// the original copyright notice and the associated disclaimer.
//
// This source file is free software; you can redistribute it
// and/or modify it under the terms of the GNU Lesser General
// Public License as published by the Free Software Foundation;
// version 2.1 of the License.
//
// This source is distributed in the hope that it will be
// useful, but WITHOUT ANY WARRANTY; without even the implied
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
// PURPOSE. See the GNU Lesser General Public License for more
// details.
//
// You should have received a copy of the GNU Lesser General
// Public License along with this source; if not, download it
// from http://www.gnu.org/licenses/lgpl.txt
//
////////////////////////////////////////////////////////////////////
//
// Comments are formatted for doxygen
//

`define DROM_WIDTH      36              // DROM Width
`define DROM_DATA       "drom.bin"      // DROM Data File

//
// Dispatch ROM Fields
//   

`define dromA           drom[2: 5]      // Operand Fetch Mode
`define dromB           drom[8:11]      // Store result as
`define dromROUND       drom[8]      	// Round the result
`define dromMODE        drom[9]      	// Seperate Add/Sub & Mul/Div
`define dromFL_B        drom[10:11]    	// Store Floating-point results as
`define dromJ           drom[12:23]     // Jump
`define dromACDISP      drom[24]        // Dispatch on AC Field
`define dromI           drom[25]        // Immediate dispatch.  DISP/AREAD does a DISP/DROM
`define dromREAD        drom[26]        // Start a read at AREAD
`define dromTEST        drom[27]        // Start a write test at AREAD
`define dromCOND_FUNC   drom[28]        // Start a memory cycle on BWRITE
`define dromVMA         drom[29]        // Load the VMA on AREAD
`define dromWRITE       drom[30]        // Start a write on AREAD
