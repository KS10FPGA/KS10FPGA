////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KS10 Bus Bit Definitions
//
// Details
//
// File
//   bus.vh
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2014 Rob Doyle
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

`ifndef __BUS_VH
`define __BUS_VH

//
// KS10 Bus Definitions
//

`define busUSER(bus)    (bus[ 0])       // User Mode
`define busFETCH(bus)   (bus[ 2])       // Fetch cycle
`define busREAD(bus)    (bus[ 3])       // Read cycle (IO or Memory)
`define busWRTEST(bus)  (bus[ 4])       // Write test cycle
`define busWRITE(bus)   (bus[ 5])       // Write cycle (IO or Memory)
`define busCACHINH(bus) (bus[ 7])       // Cache inhibit
`define busPHYS(bus)    (bus[ 8])       // Physical address
`define busPREV(bus)    (bus[ 9])       // Previous context
`define busIO(bus)      (bus[10])       // IO Cycle
`define busWRU(bus)     (bus[11])       // Who are you cycle
`define busVECT(bus)    (bus[12])       // Read interrupt vector
`define busIOBYTE(bus)  (bus[13])       // Byte IO cycle
`define busDEV(bus)     (bus[14:17])    // Device Number
`define busPI(bus)      (bus[15:17])    // PI request/ack
`define busADDR(bus)    (bus[18:35])    // IO/Mem Address
`define busADDR20(bus)  (bus[16:35])    // Mem Address

//
//  The ACs are addresses 0 to 15.  The ACs are never physically addressed.
//

`define busACREF(bus)   (!`busPHYS(bus) & (bus[18:31] == 14'b0))

`endif
