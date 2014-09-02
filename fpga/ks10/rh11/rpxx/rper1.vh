////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RPER1 Register Definitions
//
// File
//   rper1.vh
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

`ifndef __RPER1_VH
`define __RPER1_VH

//
// RPER1 Register Bits
//

`define rpER1_DCK(bus)  (bus[15])       // Data check
`define rpER1_UNS(bus)  (bus[14])       // Unsafe
`define rpER1_OPI(bus)  (bus[13])       // Operation incomplete
`define rpER1_DTE(bus)  (bus[12])       // Drive timing error
`define rpER1_WLE(bus)  (bus[11])       // Write lock error
`define rpER1_IAE(bus)  (bus[10])       // Invalid address error
`define rpER1_AOE(bus)  (bus[ 9])       // Address overflow error
`define rpER1_HCRC(bus) (bus[ 8])       // Header CRC error
`define rpER1_HCE(bus)  (bus[ 7])       // Header compare error
`define rpER1_ECH(bus)  (bus[ 6])       // ECC hard failure
`define rpER1_WCF(bus)  (bus[ 5])       // Write clock fail
`define rpER1_FER(bus)  (bus[ 4])       // Format error
`define rpER1_PAR(bus)  (bus[ 3])       // Parity error
`define rpER1_RMR(bus)  (bus[ 2])       // Register Modification Refused
`define rpER1_ILR(bus)  (bus[ 1])       // Illegal register
`define rpER1_ILF(bus)  (bus[ 0])       // Illegal function

`endif
