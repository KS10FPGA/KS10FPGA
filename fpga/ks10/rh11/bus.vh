////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Bus Bit Definitions
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

`ifndef __BUS_VH
`define __BUS_VH

//
// Bus Bit Definitions
//

`define devUSER(bus)    (bus[ 0])       // User Mode
`define devFETCH(bus)   (bus[ 2])       // Fetch cycle
`define devREAD(bus)    (bus[ 3])       // Read cycle (IO or Memory)
`define devWRTEST(bus)  (bus[ 4])       // Write test cycle
`define devWRITE(bus)   (bus[ 5])       // Write cycle (IO or Memory)
`define devCACHINH(bus) (bus[ 7])       // Cache inhibit
`define devPHYS(bus)    (bus[ 8])       // Physical address
`define devPREV(bus)    (bus[ 9])       // Previous context
`define devIO(bus)      (bus[10])       // IO Cycle
`define devWRU(bus)     (bus[11])       // Who are you cycle
`define devVECT(bus)    (bus[12])       // Read interrupt vector
`define devIOBYTE(bus)  (bus[13])       // Byte IO cycle
`define devDEV(bus)     (bus[14:17])    // Device Number
`define devADDR(bus)    (bus[18:34])    // Device Address
`define devHIBYTE(bus)  (bus[35])       // High byte (on byte cycle)
`define devLOBYTE(bus)  (~devHIBYTE)    // Low byte (on byte cycle)

`endif
