////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   MTMR Register Definitions
//
// File
//   mtmr.vh
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2021-2022 Rob Doyle
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

`ifndef __MTMR_VH
`define __MTMR_VH

//
// MTMR Register Bits
//

`define mtMR_MDF(reg)   (reg[15:7])    // Maintenance data field
`define mtMR_BPICLK(reg)(reg[6])       // BPI CLock (15 KHz)
`define mtMR_MC(reg)    (reg[5])       // Maintenance clock
`define mtMR_MOP(reg)   (reg[4:1])     // Maintenance op code
`define mtMR_MM(reg)    (reg[0])       // Maintenance mode

//
// MT Maintenance Op Codes
//

`define mtMROP_NOP      4'o00           // No Op
`define mtMROP_INTCHRD  4'o01           // Interchange read
`define mtMROP_EVPAR    4'o02           // Even parity
`define mtMROP_DATAWRG  4'o03           // Data wrap, global
`define mtMROP_DATAWRP  4'o04           // Data wrap, partial
`define mtMROP_DATAWR   4'o05           // Data wrap, formatter write
`define mtMROP_DATARD   4'o06           // Data wrap, formatter read
`define mtMROP_NOOCC    4'o07           // Cripple reception of OCC
`define mtMROP_SUPRCRC  4'o10           // Suppress CRC in NRZI mode
`define mtMROP_SETBIT5  4'o11           // Set Bit-5 of tape date in NRZI mode.
`define mtMROP_MMEOR    4'o12           // Maintenance Mode end-of-record
`define mtMROP_INVBIT1  4'o13           // Invert Bit-1 of preamble and postamle in PE mode.

`endif
