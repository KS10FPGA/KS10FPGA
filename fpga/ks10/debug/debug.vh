////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Debug Register Definitions
//
// File
//   brkpt.vh
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2016 Rob Doyle
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

`ifndef __BRKPT_VH
`define __BRKPT_VH

//
// Debug Control/Status Register Bits
//

`define debug_BRKDIS 2'b00      // Breakpoint Disable
`define debug_BRKMAT 2'b01      // Breakpoint on Address Match
`define debug_BRKTBF 2'b10      // Breakpoint on Trace Buffer Full
`define debug_BRKRES 2'b11      // Reserved

`define debug_TRCDIS 2'b00      // Trace Disable
`define debug_TRCMAT 2'b01      // Trace on Address Match
`define debug_TRCEN  2'b10      // Trace Enable
`define debug_TRCRES 2'b11      // Reserved

`endif
