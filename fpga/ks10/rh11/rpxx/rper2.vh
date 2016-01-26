////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RPER2 Register Definitions
//
// File
//   rper2.vh
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

`ifndef __RPER2_VH
`define __RPER2_VH

//
// RPER2 Register Bits
//

`define rpER2_PLO(bus)  (bus[13])       // PLO unsafe
`define rpER2_IXE(bus)  (bus[11])       // Index error
`define rpER2_NHS(bus)  (bus[10])       // No head select
`define rpER2_MHS(bus)  (bus[ 9])       // Multiple head select
`define rpER2_WRU(bus)  (bus[ 8])       // Write read unsafe
`define rpER2_ABS(bus)  (bus[ 7])       // Abnormal stop
`define rpER2_TUF(bus)  (bus[ 6])       // Transition unsafe
`define rpER2_TDF(bus)  (bus[ 5])       // Transitions detected failure
`define rpER2_RAW(bus)  (bus[ 4])       // Read and write
`define rpER2_CSU(bus)  (bus[ 3])       // Current switch unsafe
`define rpER2_WSU(bus)  (bus[ 2])       // Write select unsafe
`define rpER2_CSF(bus)  (bus[ 1])       // Current sink failure
`define rpER2_WCU(bus)  (bus[ 0])       // Write current unsafe

`endif
