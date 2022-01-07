////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   MTDS Register Definitions
//
// File
//   mtds.vh
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2021-2022 Rob Doyle
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

`ifndef __MTDS_VH
`define __MTDS_VH

//
// MTDS Register Bits
//

`define mtDS_ATA(bus)  (bus[15])        // Attention
`define mtDS_ERR(bus)  (bus[14])        // Composite error
`define mtDS_PIP(bus)  (bus[13])        // Positioning in progress
`define mtDS_MOL(bus)  (bus[12])        // Media on-line
`define mtDS_WRL(bus)  (bus[11])        // Write lock
`define mtDS_EOT(bus)  (bus[10])        // End of tape
`define mtDS_UN9(bus)  (bus[ 9])        // Unused
`define mtDS_DPR(bus)  (bus[ 8])        // Drive present
`define mtDS_DRY(bus)  (bus[ 7])        // Drive ready
`define mtDS_SSC(bus)  (bus[ 6])        // Slave status change
`define mtDS_PES(bus)  (bus[ 5])        // Phase encode status
`define mtDS_SDWN(bus) (bus[ 4])        // Slowing down
`define mtDS_IDB(bus)  (bus[ 3])        // Identifcation burse
`define mtDS_TM(bus)   (bus[ 2])        // Tape mark
`define mtDS_BOT(bus)  (bus[ 1])        // Beginning of Tape
`define mtDS_SLA(bus)  (bus[ 0])        // Slave attention

`endif
