////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DZRBUF definitions
//
// Details
//   This file contains the bit definitions for the DZ11 RBUF register.
//
// File
//   dzrbuf.vh
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

`ifndef __DZRBUF_VH
`define __DZRBUF_VH

//
// DZRBUF Register Bits
//

`define dzRBUF_VALID(bus) (bus[15])     // Data valid
`define dzRBUF_OVRE(bus)  (bus[14])     // Overrun error
`define dzRBUF_FRME(bus)  (bus[13])     // Framing error
`define dzRBUF_PARE(bus)  (bus[12])     // Parity error
`define dzRBUF_RXLINE(bus)(bus[10:8])   // Received line
`define dzRBUF_RXCHAR(bus)(bus[ 7:0])   // Received character

`endif
