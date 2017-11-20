////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   LP20 Control and Status Register A (CSRA) definitions.
//
// Details
//   This file contains the bit definitions for the LP20 CSRA register.
//
// File
//   lpcsra.vh
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2017 Rob Doyle
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

`ifndef __LPCSRA_VH
`define __LPCSRA_VH

//
// lpCSRA Register Bits
//

`define lpCSRA_ERR(bus)  (bus[15])      // Error
`define lpCSRA_PCZ(bus)  (bus[14])      // Page counter zero
`define lpCSRA_UNDC(bus) (bus[13])      // Undefined character
`define lpCSRA_VFUR(bus) (bus[12])      // DAVFU ready
`define lpCSRA_ONLN(bus) (bus[11])      // On line
`define lpCSRA_DHLD(bus) (bus[10])      // Delimiter hold
`define lpCSRA_ECLR(bus) (bus[ 9])      // Error clear
`define lpCSRA_INIT(bus) (bus[ 8])      // Initialize
`define lpCSRA_DONE(bus) (bus[ 7])      // Done
`define lpCSRA_IE(bus)   (bus[ 6])      // Interrupt enable
`define lpCSRA_ADDR(bus) (bus[5:4])     // Bus addr extension (ADDR[17:16])
`define lpCSRA_MODE(bus) (bus[3:2])     // Mode
`define lpCSRA_PAR(bus)  (bus[ 1])      // Parity enabled
`define lpCSRA_GO(bus)   (bus[ 0])      // Go

//
// Mode bits
//

`define lpCSRA_MODE_PRINT 2'b00         // Normal mode
`define lpCSRA_MODE_TEST  2'b01         // Don't print.  Loopback printer interface.
`define lpCSRA_MODE_DAVFU 2'b10         // DMA data into DAVFU
`define lpCSRA_MODE_RAM   2'b11         // DMA data into translation RAM

`endif
