////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DUP Receiver Control and Status Register (RXCSR)
//
// Details
//   This file contains the bit definitions for the DUP RXCSR register.
//
// File
//   duprxcsr.vh
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

`ifndef __DUPRXCSR_VH
`define __DUPRXCSR_VH

//
// RXCSR Register Bits
//

`define dupRXCSR_DSCA(bus)   (bus[15])  // Data set change A
`define dupRXCSR_RING(bus)   (bus[14])  // Ring indication
`define dupRXCSR_CTS(bus)    (bus[13])  // Clear to send
`define dupRXCSR_DCD(bus)    (bus[12])  // Data carrier detect
`define dupRXCSR_RXACT(bus)  (bus[11])  // Receiver active
`define dupRXCSR_SECRX(bus)  (bus[10])  // Secondary received data
`define dupRXCSR_DSR(bus)    (bus[ 9])  // Data set ready
`define dupRXCSR_STRSYN(bus) (bus[ 8])  // Strip sync
`define dupRXCSR_RXDONE(bus) (bus[ 7])  // Receive done
`define dupRXCSR_RXIE(bus)   (bus[ 6])  // Receiver interrupt enable
`define dupRXCSR_DSCIE(bus)  (bus[ 5])  // Data set change interrupt enable
`define dupRXCSR_RXEN(bus)   (bus[ 4])  // Receiver enable
`define dupRXCSR_SECTX(bus)  (bus[ 3])  // Secondary transmitted data
`define dupRXCSR_RTS(bus)    (bus[ 2])  // Request to send
`define dupRXCSR_DTR(bus)    (bus[ 1])  // Data terminal ready
`define dupRXCSR_DSCB(bus)   (bus[ 0])  // Data set change B

`endif
