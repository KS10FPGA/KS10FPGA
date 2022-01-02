////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   MTCS1 Register Definitions
//
// File
//   mtcs1.vh
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

`ifndef __MTCS1_VH
`define __MTCS1_VH

//
// RPCS1 Register Bits
//

`define mtCS1_DVA(reg)  (reg[11])       // Drive available
`define mtCS1_FUN(reg)  (reg[5:1])      // Function
`define mtCS1_GO(reg)   (reg[0])        // Go

//
// MT Functions
//
// Note
//  The function code numbering in the book is a little strange -
//  It includes the GO bit, apparently.  The LSB is always set.
//

`define mtCS1_FUN_NOP      5'o00            // 01 : NOP
`define mtCS1_FUN_UNLOAD   5'o01            // 03 : Unload
`define mtCS1_FUN_REWIND   5'o03            // 07 : Rewind
`define mtCS1_FUN_DRVCLR   5'o04            // 11 : Drive clear
`define mtCS1_FUN_PRESET   5'o10            // 21 : Read-in preset
`define mtCS1_FUN_ERASE    5'o12            // 25 : Erase
`define mtCS1_FUN_WRTM     5'o13            // 27 : Write tape mark
`define mtCS1_FUN_SPCFWD   5'o14            // 31 : Space forward
`define mtCS1_FUN_SPCREV   5'o15            // 33 : Spare reverse
`define mtCS1_FUN_WRCHKFWD 5'o24            // 51 : Write check forward
`define mtCS1_FUN_WRCHKREV 5'o25            // 57 : Write check reverse
`define mtCS1_FUN_WRFWD    5'o30            // 61 : Write forward
`define mtCS1_FUN_RDFWD    5'o34            // 71 : Read forward
`define mtCS1_FUN_RDREV    5'o37            // 77 : Read reverse

`endif
