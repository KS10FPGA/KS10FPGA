////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   LP20 Translation RAM (RAMD) definitions.
//
// Details
//   This file contains the bit definitions for the LP20 translation RAM
//   register.
//
// File
//   lpramd.vh
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

`ifndef __LPRAMD_VH
`define __LPRAMD_VH

//
// lpRAMD Register Bits
//

`define lpRAMD_RAP(bus)  (bus[12])      // RAM Parity
`define lpRAMD_INT(bus)  (bus[11])      // Interrupt
`define lpRAMD_DEL(bus)  (bus[10])      // Delimiter instruction
`define lpRAMD_TRANS(bus)(bus[9])       // Translation bit
`define lpRAMD_PI(bus)   (bus[8])       // Paper instruction
`define lpRAMD_SLEW(bus) (bus[4])       // Slew bit
`define lpRAMD_CHAN(bus) (bus[3:0])     // Channel data
`define lpRAMD_CTRL(bus) (bus[11:8])    // RAM Control
`define lpRAMD_DATA(bus) (bus[ 7:0])    // RAM Data

`endif
