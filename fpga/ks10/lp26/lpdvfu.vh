////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Line Printer Vertical Format Unit data.
//
// Details
//   The module provides printer's Vertical Format Unit memory contents for
//   LP05, LP14, and LP26 printers.
//
//   One memory is ROM-line and provides the contents of a DEC standard
//   Optical Vertical Format Unit punched-tape.
//
//   The other memory is RAM-like and is used by the Direct Access Vertical
//   Format Unit simulation.
//
// File
//   lpdvfu.vh
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

`ifndef __LPDVFU_VH
`define __LPDVFU_VH

`define VFU_SLEW(data) (data[5])
`define VFU_CHAN(data) (data[4:1])

`endif