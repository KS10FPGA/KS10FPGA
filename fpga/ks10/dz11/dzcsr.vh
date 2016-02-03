////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DZCSR definitions
//
// Details
//   This file contains the bit definitions for the DZ11 CSR register.
//
// File
//   dzcsr.vh
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

`ifndef __DZCSR_VH
`define __DZCSR_VH

//
// DZCSR Register Bits
//

`define dzCSR_TRDY(bus) (bus[15])       // Transmitter ready
`define dzCSR_TIE(bus)  (bus[14])       // Transmitter interrupt enable
`define dzCSR_SA(bus)   (bus[13])       // Silo alarm
`define dzCSR_SAE(bus)  (bus[12])       // Silo alarm enable
`define dzCSR_TLINE(bus)(bus[10:8])     // Transmit line
`define dzCSR_RDONE(bus)(bus[ 7])       // Receiver done
`define dzCSR_RIE(bus)  (bus[ 6])       // Receiver interrupt enable
`define dzCSR_MSE(bus)  (bus[ 5])       // Master scan enable
`define dzCSR_CLR(bus)  (bus[ 4])       // Clear
`define dzCSR_MAINT(bus)(bus[ 3])       // Maintenance mode

`endif
