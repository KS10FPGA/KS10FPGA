////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RPDS Register Definitions
//
// File
//   rpds.vh
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

`ifndef __RPDS_VH
`define __RPDS_VH

//
// RPDS Register Bits
//

`define rpDS_ATA(bus)  (bus[15])        // Attention
`define rpDS_ERR(bus)  (bus[14])        // Composite error
`define rpDS_PIP(bus)  (bus[13])        // Positioning in progress
`define rpDS_MOL(bus)  (bus[12])        // Media on-line
`define rpDS_WRL(bus)  (bus[11])        // Write lock
`define rpDS_LST(bus)  (bus[10])        // Last sector transferred
`define rpDS_PGM(bus)  (bus[ 9])        // Programmable
`define rpDS_DPR(bus)  (bus[ 8])        // Drive present
`define rpDS_DRY(bus)  (bus[ 7])        // Drive ready
`define rpDS_VV(bus)   (bus[ 6])        // Volume Valid
`define rpDS_OM(bus)   (bus[ 0])        // Offset mode

`endif
