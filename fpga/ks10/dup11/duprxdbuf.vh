////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DUP Receiver Data Buffer (RXDBUF)
//
// Details
//   This file contains the bit definitions for the DUP11 RXDBUF register.
//
// File
//   duprxdbuf.vh
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2018 Rob Doyle
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

`ifndef __DUPRXDBUF_VH
`define __DUPRXDBUF_VH

//
// RXDBUF Register Bits
//

`define dupRXDBUF_RXERR(bus)  (bus[15])         // Receiver Error
`define dupRXDBUF_RXOVR(bus)  (bus[14])         // Receiver Overrun Error
`define dupRXDBUF_RXCRC(bus)  (bus[12])         // Receiver CRC Error
`define dupRXDBUF_RXABRT(bus) (bus[10])         // Receiver Abort Error
`define dupRXDBUF_RXEOM(bus)  (bus[ 9])         // Receiver End of Message
`define dupRXDBUF_RXSOM(bus)  (bus[ 8])         // Receiver Start of Message
`define dupRXDBUF_RXDAT(bus)  (bus[7:0])        // Receiver Data

`endif
