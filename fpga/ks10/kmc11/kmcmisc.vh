////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KMC11 Miscellaneous Register (MISC) bit definitions.
//
// Details
//   This file contains the bit definitions for the Microprocessor MISC
//   Register.
//
// File
//   kmcmisc.vh
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

`ifndef __KMCMISC_VH
`define __KMCMISC_VH

//
// kmcMISC Register Bits
//

`define kmcMISC_IRQO(bus)     (bus[7])  // Interrupt request out
`define kmcMISC_VECTXXX4(bus) (bus[6])  // Vector select
`define kmcMISC_LAT(bus)      (bus[5])  // Latch
`define kmcMISC_PGMCLK(bus)   (bus[4])  // Timer
`define kmcMISC_BAEO(bus)     (bus[3:2])// Bus address extension for NPR outs
`define kmcMISC_ACLO(bus)     (bus[1])  // AC LO (Reset KS10, not implemented)
`define kmcMISC_NXM(bus)      (bus[0])  // Non-existent Memory (not implemented)

`endif
