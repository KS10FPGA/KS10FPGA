////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RHCS2 definitions
//
// File
//   rhcs2.vh
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

`ifndef __RHCS2_VH
`define __RHCS2_VH

//
// RHCS2 Register Bits
//

`define rhCS2_DLT(bus)  (bus[15])       // Device late
`define rhCS2_WCE(bus)  (bus[14])       // Write check error
`define rhCS2_PE(bus)   (bus[13])       // Parity error
`define rhCS2_NED(bus)  (bus[12])       // Non-existent drive
`define rhCS2_NEM(bus)  (bus[11])       // Non-existent memory
`define rhCS2_PGE(bus)  (bus[10])       // Program error
`define rhCS2_MXF(bus)  (bus[ 9])       // Missed xfer
`define rhCS2_MDPE(bus) (bus[ 8])       // Massbus data parity error
`define rhCS2_OR(bus)   (bus[ 7])       // Output ready
`define rhCS2_IR(bus)   (bus[ 6])       // Input ready
`define rhCS2_CLR(bus)  (bus[ 5])       // Controller clear
`define rhCS2_PAT(bus)  (bus[ 4])       // Parity test
`define rhCS2_BAI(bus)  (bus[ 3])       // Bus address increment inhibit
`define rhCS2_UNIT(bus) (bus[2:0])      // Unit select

`endif
