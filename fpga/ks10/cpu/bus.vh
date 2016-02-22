////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KS10 Bus Bit Definitions
//
// Details
//   This file constains the KS10 bus definitions.  It is very similar to the
//   VMA definitions for obvious reasons.
//
// File
//   bus.vh
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

`ifndef __BUS_VH
`define __BUS_VH

//
// KS10 Bus Definitions
//

`define busUSER(bus)     (bus[ 0])      // User Mode
`define busFETCH(bus)    (bus[ 2])      // Fetch cycle
`define busREAD(bus)     (bus[ 3])      // Read cycle (IO or Memory)
`define busWRTEST(bus)   (bus[ 4])      // Write test cycle (IO or Memory)
`define busWRITE(bus)    (bus[ 5])      // Write cycle (IO or Memory)
`define busCACHEINH(bus) (bus[ 7])      // Cache inhibit
`define busPHYS(bus)     (bus[ 8])      // Physical address
`define busPREV(bus)     (bus[ 9])      // Previous context
`define busIO(bus)       (bus[10])      // IO cycle
`define busWRU(bus)      (bus[11])      // Who are you cycle
`define busVECT(bus)     (bus[12])      // Read interrupt vector cycle
`define busIOBYTE(bus)   (bus[13])      // Byte IO cycle
`define busDEV(bus)      (bus[14:17])   // Device number
`define busPI(bus)       (bus[15:17])   // PI request/PI acknowledge

//
// Addressing
//

`define busADDR(bus)     (bus[14:35])   // Full Address
`define busIOADDR(bus)   (bus[18:35])   // IO Address
`define busMEMADDR(bus)  (bus[16:35])   // Memory Address
`define busDEVADDR(dev)  (dev[18:34])   // UBA Device Address
`define busFLAGS(dev)    (dev[ 0:13])   // Address Flags

//
// This are valid during IOBYTE operations
//

`define busHIBYTE(dev)   (( dev[35] & `devIOBYTE(dev)) | !`devIOBYTE(dev))  // High byte select
`define busLOBYTE(dev)   ((!dev[35] & `devIOBYTE(dev)) | !`devIOBYTE(dev))  // Low byte select

//
// The ACs are addresses 0 to 15.  The ACs are never physically addressed.
//
// Trace
//  DPM4/E160
//  DPM4/E168
//  DPM4/E191
//

`define busACREF(bus)    (!`busPHYS(bus) & (bus[18:31] == 14'b0))

`endif
