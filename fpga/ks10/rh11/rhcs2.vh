////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RHCS2 definitions
//
// File
//   rhcs2.vh
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

`ifndef __RHCS2_VH
`define __RHCS2_VH

//
// RHCS2 Register Bits
//

`define rhCS2_DLT(reg)  (reg[15])       // Device late
`define rhCS2_WCE(reg)  (reg[14])       // Write check error
`define rhCS2_UPE(reg)  (reg[13])       // Unireg Parity error
`define rhCS2_NED(reg)  (reg[12])       // Non-existent drive
`define rhCS2_NEM(reg)  (reg[11])       // Non-existent memory
`define rhCS2_PGE(reg)  (reg[10])       // Program error
`define rhCS2_MXF(reg)  (reg[ 9])       // Missed xfer
`define rhCS2_DPE(reg)  (reg[ 8])       // Data parity error
`define rhCS2_OR(reg)   (reg[ 7])       // Output ready
`define rhCS2_IR(reg)   (reg[ 6])       // Input ready
`define rhCS2_CLR(reg)  (reg[ 5])       // Controller clear
`define rhCS2_PAT(reg)  (reg[ 4])       // Parity test
`define rhCS2_BAI(reg)  (reg[ 3])       // Bus address increment inhibit
`define rhCS2_UNIT(reg) (reg[2:0])      // Unit select

`endif
