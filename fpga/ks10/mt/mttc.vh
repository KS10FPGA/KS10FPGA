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
// Copyright (C) 2021-2022 Rob Doyle
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

`define mtTC_ACCL(reg)  (reg[15])       // R/O Drive accelerating
`define mtTC_FCS(reg)   (reg[14])       // R/O Frame count status
`define mtTC_SAC(reg)   (reg[13])       // R/W Slave access change
`define mtTC_EAODTE(reg)(reg[12])       // R/W Enable abort on data transfer errors
`define mtTC_UN11(reg)  (reg[11])       // R/W Unused (but still R/W)
`define mtTC_DEN(reg)   (reg[10:8])     // R/W Density select
`define mtTC_FMT(reg)   (reg[7:4])      // R/W Format select
`define mtTC_EVPAR(reg) (reg[3])        // R/W Even parity
`define mtTC_SS(reg)    (reg[2:0])      // R/W Slave select

`define mtTC_DEN_200    (3'd0)          // 200 BPI NRZI (MT02 only)
`define mtTC_DEN_556    (3'd1)          // 556 BPI NRZI (MT02 only)
`define mtTC_DEN_800A   (3'd2)          // 800 BPI NRZI (alternate)
`define mtTC_DEN_800    (3'd3)          // 800 BPI NRZI
`define mtTC_DEN_1600   (3'd4)          // 1600 BPI PE

`define mtTC_FMT_CORDMP (4'o0)          // Coredump
`define mtTC_FMT_7TRK   (4'o1)          // 7 track (not implemented on TM03)
`define mtTC_FMT_ASCII  (4'o2)          // ASCII (not implemented on TM03)
`define mtTC_FMT_COMPAT (4'o3)          // Compatible (or Normal)

`endif
