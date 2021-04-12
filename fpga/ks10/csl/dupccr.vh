////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DUP11 Console Control/Status Register Header File
//
// Details
//   This file contains the DUP11 Control/Status Register bit definitions.
//
// File
//   dupccr.vh
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2020-2021 Rob Doyle
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

`ifndef __DUPCCR_VH
`define __DUPCCR_VH

//
// DUPCCR bits
//

`define dupccrTXE(reg)     (reg[1])     // Transmitter FIFO empty
`define dupccrRI(reg)      (reg[4])     // Ring indication
`define dupccrCTS(reg)     (reg[5])     // Clear to send
`define dupccrDSR(reg)     (reg[6])     // Data set ready
`define dupccrDCD(reg)     (reg[7])     // Data carrier detect
`define dupccrTXFIFO(reg)  (reg[8:15])  // Transmitter FIFO
`define dupccrRXF(reg)     (reg[16])    // Receiver FIFO full
`define dupccrDTR(reg)     (reg[17])    // Data terminal ready
`define dupccrRTS(reg)     (reg[18])    // Request to send
`define dupccrH325(reg)    (reg[20])    // Enable H325 loopback adapter
`define dupccrW3(reg)      (reg[21])    // Jumper Wire #3
`define dupccrW5(reg)      (reg[22])    // Jumper Wire #5
`define dupccrW6(reg)      (reg[23])    // Jumper Wire #26
`define dupccrRXFIFO(reg)  (reg[24:31]) // Receiver FIFO

`endif
