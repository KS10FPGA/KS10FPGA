////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KMC11 Maintenance Register bit definitions
//
// Details
//   This file contains the bit definitions Maintenance Register.
//
// File
//   kmcmaint.vh
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

`ifndef __KMCMAINT_VH
`define __KMCMAINT_VH

//
// kmcCSR1 Register Bits
//

`define kmcMAINT_RUN(bus)     (bus[15])  // Run
`define kmcMAINT_MCLR(bus)    (bus[14])  // Master Clear
`define kmcMAINT_CRAMWR(bus)  (bus[13])  // CRAM Write
`define kmcMAINT_LUSTEP(bus)  (bus[12])  // Line Unit Step
`define kmcMAINT_LULOOP(bus)  (bus[11])  // Line Unit Loopback
`define kmcMAINT_CRAMOUT(bus) (bus[10])  // CRAM Out
`define kmcMAINT_CRAMIN(bus)  (bus[ 9])  // CRAM In
`define kmcMAINT_STEP(bus)    (bus[ 8])  // Step microprocessor

`endif
