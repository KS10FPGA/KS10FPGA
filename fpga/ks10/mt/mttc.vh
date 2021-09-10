////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   MTTC Register Definitions
//
// File
//   mttc.vh
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

`ifndef __MTTC_VH
`define __MTTC_VH

//
// RPTC Register Bits
//

`define mtTC_ACCL(reg)  (reg[15])      // R/O Drive accelerating
`define mtTC_FCS(reg)   (reg[14])      // R/O Frame count status
`define mtTC_TCW(reg)   (reg[13])      // R/W Tape control write
`define mtTC_EAODTE(reg)(reg[12])      // R/W Enable abort on data transfer errors
`define mtTC_UN11(reg)  (reg[11])      // R/W Unused (but still R/W)
`define mtTC_DEN(reg)   (reg[10:8])    // R/W Density select
`define mtTC_FMT(reg)   (reg[7:4])     // R/W Format select
`define mtTC_EVPAR(reg) (reg[3])       // R/W Even parity
`define mtTC_SS(reg)    (reg[2:0])     // R/W Slave select

`endif
