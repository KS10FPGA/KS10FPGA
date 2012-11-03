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
//  Copyright (C) 2012 Rob Doyle
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
//  Note : See page 5-39 of EK-0KS10-TM-002 for info about dromTXXXEN.
//   The bit is not replicated into DROM DPEA/E114[2].
//  Note : Four upper bits of dromJ are always "0001" (jump is always
//   between 1400 and 1777) and are hardwired in the KS10.   The dromJ
//   field is the 8 lower bits.
//  Note : See figure 5-20 of EK-0KS10-TM-002 for mapping to ROM.
//  Note : dromI and dromAEQJ are aliases of each other.
//

`define dromA           drom[ 2: 5]     // DROM DPEA/E114[ 0: 3] Operand Fetch Mode
`define dromB           drom[ 8:11]     // DROM DPEA/E114[ 4: 7] Store result as
`define dromROUND       drom[ 8]        // DROM DPEA/E114[4]     Round the result
`define dromMODE        drom[ 9]        // DROM DPEA/E114[5]     Seperate Add/Sub & Mul/Div
`define dromFL_B        drom[10:11]     // DROM DPEA/E114[ 6: 7] Store Floating-point results as
`define dromJ           drom[12:23]     // DROM DPEA/E115[ 0: 7] Jump (see notes)
`define dromACDISP      drom[24]        // DROM DPEA/E113[1]     Dispatch on AC Field
`define dromI           drom[25]        // DROM DPEA/E113[0]     Immediate dispatch on J field. (see notes)
`define dromAEQJ        drom[25]        // DROM DPEA/E113[0]     Immediate dispatch on J field. (see notes)
`define dromREADCYCLE   drom[26]        // DROM DPEA/E113[5]     Start a read at AREAD
`define dromWRTESTCYCLE drom[27]        // DROM DPEA/E113[7]     Start a write test at AREAD
`define dromCOND_FUNC   drom[28]        // DROM DPEA/E113[3]     Start a memory cycle on BWRITE
`define dromVMA         drom[29]        // DROM DPEA/E113[4]     Load the VMA on AREAD
`define dromWRITECYCLE  drom[30]        // DROM DPEA/E113[6]     Start a write on AREAD
`define dromTXXXEN      drom[ 9]        // DROM DPEA/E113[5]     Shown as DROM DPEA/E113[2] (see notes)
