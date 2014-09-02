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
// Copyright (C) 2012-2014 Rob Doyle
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

`define rpCS1_DVA(bus)  (bus[11])       // Drive available
`define rpCS1_FUN(bus)  (bus[5:1])      // Function
`define rpCS1_GO(bus)   (bus[ 0])       // Go

//
// RP/RM Functions
//
// Note
//  The function code numbering in the book is a little strange -
//  It includes the GO bit, apparently.  The LSB is always set.
//

`define funNOP     6'o00        // 01
`define funUNLOAD  6'o01        // 03
`define funSEEK    6'o02        // 05
`define funRECAL   6'o03        // 07
`define funCLEAR   6'o04        // 11
`define funRELEASE 6'o05        // 13
`define funOFFSET  6'o06        // 15
`define funRETURN  6'o07        // 17
`define funPRESET  6'o10        // 21
`define funPAKACK  6'o11        // 23
`define funSEARCH  6'o14        // 31
`define funWRCHK   6'o24        // 51
`define funWRCHKH  6'o25        // 53
`define funWRITE   6'o30        // 61
`define funWRITEH  6'o31        // 63
`define funREAD    6'o34        // 71
`define funREADH   6'o35        // 73

`endif
