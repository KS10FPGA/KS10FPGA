////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   UBA Bus Bit Definitions
//
// Details
//
// File
//   ubabus.vh
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

`ifndef __UBABUS_VH
`define __UBABUS_VH

//
// UBA Bus Definitions
//

`define devUSER(dev)     (dev[ 0])      // User Mode
`define devFETCH(dev)    (dev[ 2])      // Fetch cycle
`define devREAD(dev)     (dev[ 3])      // Read cycle (IO or Memory)
`define devWRTEST(dev)   (dev[ 4])      // Write test cycle
`define devWRITE(dev)    (dev[ 5])      // Write cycle (IO or Memory)
`define devCACHEINH(dev) (dev[ 7])      // Cache inhibit
`define devPHYS(dev)     (dev[ 8])      // Physical address
`define devPREV(dev)     (dev[ 9])      // Previous context
`define devIO(dev)       (dev[10])      // IO cycle
`define devWRU(dev)      (dev[11])      // Who are you cycle
`define devVECT(dev)     (dev[12])      // Read interrupt vector
`define devIOBYTE(dev)   (dev[13])      // Byte IO cycle
`define devDEV(dev)      (dev[14:17])   // Device number
`define devPI(dev)       (dev[15:17])   // PI request/PI acknowledge

//
// Addressing
//

`define devADDR(dev)     ({dev[18:34],1'b0})    // Device Address

//
// This are valid during IOBYTE operations
//

`define devHIBYTE(dev)   (( dev[35] & `devIOBYTE(dev)) | !`devIOBYTE(dev))  // High byte select
`define devLOBYTE(dev)   ((!dev[35] & `devIOBYTE(dev)) | !`devIOBYTE(dev))  // Low byte select

//
// Byte and word selects
//

`define devWORDSEL(dev)  (dev[34])
`define devBYTESEL(dev)  (dev[35])

`endif
