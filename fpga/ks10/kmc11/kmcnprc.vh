////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KMC11 NPR Control Register (NPRC) bit definitions
//
// Details
//   This file contains the bit definitions for the Microprocessor NPR Control
//   Register (NPRC).
//
// File
//   kmcnprc.vh
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

`ifndef __KMCNPRC_VH
`define __KMCNPRC_VH

//
// kmcNPRC Register Bits
//

`define kmcNPRC_BYTEXFER(bus)(bus[7])   // Do a byte-wide NPR
`define kmcNPRC_MAR10(bus)   (bus[6])   // MAR[12]
`define kmcNPRC_MAR8(bus)    (bus[5])   // MAR[8]
`define kmcNPRC_NPRO(bus)    (bus[4])   // Perform an NPR Out
`define kmcNPRC_BAEI(bus)    (bus[3:2]) // Bus address extension for DMA in
`define kmcNPRC_NLXFER(bus)  (bus[1])   // Not last transfer.
`define kmcNPRC_NPRRQ(bus)   (bus[0])   // Create NPR request

`endif
