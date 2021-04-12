////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   UBA Paging Flag Definitions
//
// Details
//   This module provides the bit definitions for the IO Bridge Paging Flags
//
// File
//   ubapage.vh
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

`ifndef __UBAPAGE_VH
`define __UBAPAGE_VH

//
// UBA Paging Flags
//

`define flagsRPW(bus)    (bus[0])            // Reverse read
`define flagsE16(bus)    (bus[1])            // Enable 16-bit transfers
`define flagsFTM(bus)    (bus[2])            // Fast transfer mode
`define flagsVLD(bus)    (bus[3])            // Paging valid

`endif
