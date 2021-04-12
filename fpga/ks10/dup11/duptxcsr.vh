////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DUP Transmitter Control and Status Register (TXCSR)
//
// Details
//   This file contains the bit definitions for the DUP TXCSR register.
//
// File
//   duptxcsr.vh
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

`ifndef __DUPTXCSR_VH
`define __DUPTXCSR_VH

//
// TXCSR Register Bits
//

`define dupTXCSR_TXDLE(bus)  (bus[15])          // Data late error
`define dupTXCSR_MDO(bus)    (bus[14])          // Maintenance data out
`define dupTXCSR_MCO(bus)    (bus[13])          // Maintenance clock out
`define dupTXCSR_MSEL(bus)   (bus[12:11])       // Maintenance select
`define dupTXCSR_MDI(bus)    (bus[10])          // Maintenance data in
`define dupTXCSR_TXACT       (bus[ 9])          // Transmitter active
`define dupTXCSR_INIT(bus)   (bus[ 8])          // Initialize
`define dupTXCSR_TXDONE(bus) (bus[ 7])          // Transmitter done
`define dupTXCSR_TXIE(bus)   (bus[ 6])          // Transmitter interrupt enable
`define dupTXCSR_SEND(bus)   (bus[ 4])          // Send
`define dupTXCSR_HDX(bus)    (bus[ 3])          // Half-duplex mode

`define dupTXCSR_MSEL_USER   (2'd0)             // User mode
`define dupTXCSR_MSEL_MEXT   (2'd1)             // System Test Mode
`define dupTXCSR_MSEL_MINT   (2'd2)             // External maintenance mode
`define dupTXCSR_MSEL_DIAG   (2'd3)             // Internal maintenance mode

`endif
