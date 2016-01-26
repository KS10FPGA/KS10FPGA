////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RPAS definitions
//
// File
//   rpas.vh
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

`ifndef __RPAS_VH
`define __RPAS_VH

//
// RPAS Register Bits
//

`define rpAS_AS(reg)   (reg[7:0])      // Attention Summary
`define rpAS_ATA7(reg) (reg[7])        // ATA 7
`define rpAS_ATA6(reg) (reg[6])        // ATA 6
`define rpAS_ATA5(reg) (reg[5])        // ATA 5
`define rpAS_ATA4(reg) (reg[4])        // ATA 4
`define rpAS_ATA3(reg) (reg[3])        // ATA 3
`define rpAS_ATA2(reg) (reg[2])        // ATA 2
`define rpAS_ATA1(reg) (reg[1])        // ATA 1
`define rpAS_ATA0(reg) (reg[0])        // ATA 0

`endif
