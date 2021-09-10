////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   MTER Register Definitions
//
// File
//   mter.vh
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
// FITNESS FOR A PARTICULAR PUMTOSE. See the GNU Lesser General Public License
// for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this source; if not, download it from
// http://www.gnu.org/licenses/lgpl.txt
//
////////////////////////////////////////////////////////////////////////////////

`ifndef __MTER_VH
`define __MTER_VH

//
// MTER Register Bits
//

`define mtER_CORCRC(bus)(bus[15])      // Correctable Data or CRC Error
`define mtER_UNS(bus)   (bus[14])      // Unsafe
`define mtER_OPI(bus)   (bus[13])      // Operation Incomplete
`define mtER_DTE(bus)   (bus[12])      // Drive timing error
`define mtER_NEF(bus)   (bus[11])      // Non-executable function
`define mtER_CSIMT(bus) (bus[10])      // Correctable skew or illegal tape mark
`define mtER_FCE(bus)   (bus[ 9])      // Frame counter error
`define mtER_NSG(bus)   (bus[ 8])      // Non-standard gap
`define mtER_PEFLRC(bus)(bus[ 7])      // PE Format Error/LRC
`define mtER_INCVPE(bus)(bus[ 6])      // In-correctable Data / Vertical Parity Error
`define mtER_DPAR(bus)  (bus[ 5])      // Data parity error
`define mtER_FMTE(bus)  (bus[ 4])      // Format error
`define mtER_PAR(bus)   (bus[ 3])      // Parity error
`define mtER_RMR(bus)   (bus[ 2])      // Register Modification Refused
`define mtER_ILR(bus)   (bus[ 1])      // Illegal register
`define mtER_ILF(bus)   (bus[ 0])      // Illegal function

`endif
