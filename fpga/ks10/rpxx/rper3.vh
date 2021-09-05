////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RPER3 Register Definitions
//
// File
//   rper3.vh
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

`ifndef __RPER3_VH
`define __RPER3_VH

//
// RPER3 Register Bits
//

`define rpER3_OCE(bus)  (bus[15])       // Off cylinder error
`define rpER3_SKI(bus)  (bus[14])       // Seek incomplete
`define rpER3_UN1(bus)  (bus[13:7])     // Unused
`define rpER3_ACL(bus)  (bus[ 6])       // AC low
`define rpER3_DCL(bus)  (bus[ 5])       // DC low
`define rpER3_F35(bus)  (bus[ 4])       // 35V regulator failure
`define rpER3_UN2(bus)  (bus[3:2])      // Unused
`define rpER3_VLU(bus)  (bus[ 1])       // Velocity unsafe
`define rpER3_DCU(bus)  (bus[ 0])       // DC unsafe

`endif
