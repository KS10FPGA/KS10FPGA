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

`define mtMR_MDF(reg)   (reg[15:7])             // Maintenance data field
`define mtMR_BPICLK(reg)(reg[6])                // BPI CLock (15 KHz)
`define mtMR_MC(reg)    (reg[5])                // Maintenance clock
`define mtMR_MOP(reg)   (reg[4:1])              // Maintenance opcode
`define mtMR_MM(reg)    (reg[0])                // Maintenance mode enable

//
// MT Maintenance Op Codes
//

localparam [4:1] mtMROP_NOP    = 4'o00,         // No Op
                 mtMROP_IRD    = 4'o01,         // Interchange read
                 mtMROP_EVPAR  = 4'o02,         // Even parity
                 mtMROP_WRP0   = 4'o03,         // Data wrap, global (WRP0)
                 mtMROP_WRP1   = 4'o04,         // Data wrap, partial (WRP1)
                 mtMROP_WRP2   = 4'o05,         // Data wrap, formatter write (WRP2)
                 mtMROP_WRP3   = 4'o06,         // Data wrap, formatter read (WRP3)
                 mtMROP_CROCC  = 4'o07,         // Cripple reception of OCC
                 mtMROP_ILCC1  = 4'o10,         // Suppress CRC in NRZI mode
                 mtMROP_ITM12  = 4'o11,         // Set Bit-5 of tape date in NRZI mode.
                 mtMROP_MMEOR  = 4'o12,         // Maintenance Mode end-of-record
                 mtMROP_INCPRE = 4'o13;         // Invert Bit-1 of preamble and postamle in PE mode.

`endif
