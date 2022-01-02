////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   MT definitions
//
// Details
//   This file provides definitions for the various types of tape drives.
//
// File
//   mt.vh
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2021 Rob Doyle
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

`ifndef __MT_VH
`define __MT_VH

`include "../rh11/rh11.vh"
`include "../rh11/rhcs2.vh"
`include "../uba/ubabus.vh"

//
// MT Serial Numbers (MTSN Register)
//

`define mtSN_SN0 16'o000030
`define mtSN_SN1 16'o000031
`define mtSN_SN2 16'o000032
`define mtSN_SN3 16'o000033
`define mtSN_SN4 16'o000034
`define mtSN_SN5 16'o000035
`define mtSN_SN6 16'o000036
`define mtSN_SN7 16'o000037

//
// MT Drive Types (MTDT Register)
//

`define mtDT_TM02 16'o000000
`define mtDT_TM03 16'o000040
`define mtDT_NONE 16'o142050
`define mtDT_TU45 16'o142012
`define mtDT_TU77 16'o142014

//
// MT Slave Address
//

`define mtSLV_SLV0 3'o0
`define mtSLV_SLV1 3'o1
`define mtSLV_SLV2 3'o2
`define mtSLV_SLV3 3'o3
`define mtSLV_SLV4 3'o4
`define mtSLV_SLV5 3'o5
`define mtSLV_SLV6 3'o6
`define mtSLV_SLV7 3'o7

//
// Get Serial Number
//

`define getMTSN(slv)(((slv) == 3'd0) ? `mtSN_SN0 : \
                     (((slv) == 3'd1) ? `mtSN_SN1 : \
                      (((slv) == 3'd2) ? `mtSN_SN2 : \
                       (((slv) == 3'd3) ? `mtSN_SN3 : \
                        (((slv) == 3'd4) ? `mtSN_SN4 : \
                         (((slv) == 3'd5) ? `mtSN_SN5 : \
                          (((slv) == 3'd6) ? `mtSN_SN6 : \
                           `mtSN_SN7)))))))

//
// Get Drive Type
//

`define getMTDT(slv)(((slv) == 3'd0) ? (`mtDT_TM03|`mtDT_TU77) : \
                     (((slv) == 3'd1) ? (`mtDT_TM03|`mtDT_TU77) : \
                      (((slv) == 3'd2) ? (`mtDT_TM03|`mtDT_TU77) : \
                       (((slv) == 3'd3) ? (`mtDT_TM03|`mtDT_TU77) : \
                        (((slv) == 3'd4) ? (`mtDT_TM03|`mtDT_TU77) : \
                         (((slv) == 3'd5) ? (`mtDT_TM03|`mtDT_TU77) : \
                          (((slv) == 3'd6) ? (`mtDT_TM03|`mtDT_TU77) : \
                           (`mtDT_TM03|`mtDT_TU77)7)))))))


`endif
