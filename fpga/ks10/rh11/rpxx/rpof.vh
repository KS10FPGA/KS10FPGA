////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RPOF Register Definitions
//
// File
//   rpof.vh
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

`ifndef __RPOF_VH
`define __RPOF_VH

//
// RPOF Register Bits
//

`define rpOF_F16(bus)   (bus[12])       // 16-bit format
`define rpOF_ECI(bus)   (bus[11])       // Error correction inhibit
`define rpOF_HCI(bus)   (bus[10])       // Header compare inhibit
`define rpOF_OFD(bus)   (bus[ 7])       // Offset direction
`define rpOF_OFS(bus)   (bus[6:0])      // Offset magnitude

`endif
