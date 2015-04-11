////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Memory Status Register definitions
//
// Details
//   This file contains the bit definitions for the Memory Status Register
//
// File
//   memstat.vh
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2015 Rob Doyle
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

`ifndef __MEMSTAT_VH
`define __MEMSTAT_VH

//
// Memory Status Register Bits
//

`define memSTAT_EH(bus) (bus[ 0])       // Error Hold
`define memSTAT_UE(bus) (bus[ 1])       // Uncorrectable error
`define memSTAT_RE(bus) (bus[ 2])       // Refresh error
`define memSTAT_PE(bus) (bus[ 3])       // Parity error
`define memSTAT_EE(bus) (bus[ 4])       // ECC Enable
`define memSTAT_PF(bus) (bus[12])       // Power Fail
`define memSTAT_ED(bus) (bus[35])       // ECC Disable

`endif
