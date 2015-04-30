////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RPCS1 Register Definitions
//
// File
//   rpcs1.vh
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2015 Rob Doyle
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

`ifndef __RPCS1_VH
`define __RPCS1_VH

//
// RPCS1 Register Bits
//

`define rpCS1_DVA(reg)  (reg[11])       // Drive available
`define rpCS1_FUN(reg)  (reg[5:1])      // Function
`define rpCS1_GO(reg)   (reg[ 0])       // Go

//
// RP/RM Functions
//
// Note
//  The function code numbering in the book is a little strange -
//  It includes the GO bit, apparently.  The LSB is always set.
//

`define funNOP     5'o00        // 01
`define funUNLOAD  5'o01        // 03
`define funSEEK    5'o02        // 05
`define funRECAL   5'o03        // 07
`define funCLEAR   5'o04        // 11
`define funRELEASE 5'o05        // 13
`define funOFFSET  5'o06        // 15
`define funRETURN  5'o07        // 17
`define funPRESET  5'o10        // 21
`define funPAKACK  5'o11        // 23
`define funSEARCH  5'o14        // 31
`define funWRCHK   5'o24        // 51
`define funWRCHKH  5'o25        // 53
`define funWRITE   5'o30        // 61
`define funWRITEH  5'o31        // 63
`define funREAD    5'o34        // 71
`define funREADH   5'o35        // 73

`endif
