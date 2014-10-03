////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DZLPR definitions
//
// Details
//   This file contains the bit definitions for the DZ11 LPR register.
//
// File
//   dzlpr.vh
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2012-2014 Rob Doyle
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

`ifndef __DZLPR_VH
`define __DZLPR_VH

//
// DZLPR Register Bits
//

`define dzLPR_DATA(bus)  (bus[12:3])    // Generic data

`define dzLPR_RXEN(bus)  (bus[12])      // Parity type
`define dzLPR_SPEED(bus) (bus[11:8])    // Baud rate
`define dzLPR_PAR(bus)   (bus[7:6])     // Parity type
`define dzLPR_STOP(bus)  (bus[5])       // Number of stop bits
`define dzLPR_LEN(bus)   (bus[4:3])     // Character length

`define dzLPR_LINE(bus)  (bus[2:0])     // Line number

`endif
