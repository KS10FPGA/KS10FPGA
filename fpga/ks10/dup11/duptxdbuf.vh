////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DUP Transmitter Data Buffer (TXDBUF)
//
// Details
//   This file contains the bit definitions for the DUP TXDBUF register.
//
// File
//   duptxdbuf.vh
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2018Rob Doyle
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

`ifndef __DUPTXDBUF_VH
`define __DUPTXDBUF_VH

//
// TXDBUF Register Bits
//

`define dupTXDBUF_RXCRC(bus)  (bus[14])         // Receiver CRC register LSB
`define dupTXDBUF_TXCRC(bus)  (bus[12])         // Transmitter CRC register LSB
`define dupTXDBUF_MNTT(bus)   (bus[11])         // Maintenance timer
`define dupTXDBUF_TXABRT(bus) (bus[10])         // Transmitter abort
`define dupTXDBUF_TXEOM(bus)  (bus[ 9])         // Transmitter end of message
`define dupTXDBUF_TXSOM(bus)  (bus[ 8])         // Transmit start of message
`define dupTXDBUF_TXDAT(bus)  (bus[7:0])        // Trnasmit data

`endif
