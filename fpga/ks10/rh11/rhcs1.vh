////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RHCS1 definitions
//
// File
//   rhcs1.vh
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

`ifndef __RHCS1_VH
`define __RHCS1_VH

//
// RHCS1 Register Bits
//

`define rhCS1_SC(bus)   (bus[15])       // Special conditions
`define rhCS1_TRE(bus)  (bus[14])       // Transfer error
`define rhCS1_MCPE(bus) (bus[13])       // Massbus control bus parity error
`define rhCS1_PSEL(bus) (bus[10])       // Port select
`define rhCS1_A17(bus)  (bus[ 9])       // A17 address extension
`define rhCS1_A16(bus)  (bus[ 8])       // A16 address extension
`define rhCS1_RDY(bus)  (bus[ 7])       // Ready
`define rhCS1_IE(bus)   (bus[ 6])       // Interrupt enable

`endif
