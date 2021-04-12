////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   LP20 Console Control/Status Register Header File
//
// Details
//   This file contains the LP20 Control/Status Register bit definitions.
//
// File
//   lpccr.vh
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2020-2021 Rob Doyle
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

`ifndef __LPCCR_VH
`define __LPCCR_VH

//
// LPCCR bits
//

`define lpccrBAUDRATE(reg) (reg[6:10])  // Baud rate
`define lpccrLENGTH(reg)   (reg[11:12]) // Word length
`define lpccrPARITY(reg)   (reg[13:14]) // Number of parity bits
`define lpccrSTOP(reg)     (reg[15])    // Number of stop bits
`define lpccrSIXLPI(reg)   (reg[29])    // Six lines per inch
`define lpccrOVFU(reg)     (reg[30])    // Optical vertical format unit
`define lpccrONLINE(reg)   (reg[31])    // On line status

`define lpccrCONFIG(reg)   (reg[6:15])  // Printer serial configuration

`endif
