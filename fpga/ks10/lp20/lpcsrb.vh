////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   LPCSRB definitions
//
// Details
//   This file contains the bit definitions for the LP20 CSRB register.
//
// File
//   lpcsrb.vh
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

`ifndef __LPCSRB_VH
`define __LPCSRB_VH

//
// lpCSRB Register Bits
//

`define lpCSRB_VAL(bus)  (bus[15])      // Valid
`define lpCSRB_LA180(bus)(bus[14])      // Reserved
`define lpCSRB_NRDY(bus) (bus[13])      // Not ready
`define lpCSRB_DPAR(bus) (bus[12])      // Data parity
`define lpCSRB_OVFU(bus) (bus[11])      // Optical vertical format unit
`define lpCSRB_TEST(bus) (bus[10:8])    // Test
`define lpCSRB_OFFL(bus) (bus[ 7])      // Off line
`define lpCSRB_DVOF(bus) (bus[ 6])      // DAVFU not ready
`define lpCSRB_LPE(bus)  (bus[ 5])      // LPT parity error
`define lpCSRB_MPE(bus)  (bus[ 4])      // MEM parity error
`define lpCSRB_RPE(bus)  (bus[ 3])      // RAM parity error
`define lpCSRB_MTE(bus)  (bus[ 2])      // Unibus time-out error
`define lpCSRB_DTE(bus)  (bus[ 1])      // Demand time-out error
`define lpCSRB_GOE(bus)  (bus[ 0])      // Go error

//
// Test bits
//

`define lpCSRB_TEST_NORM  3'b000
`define lpCSRB_TEST_DTE   3'b001
`define lpCSRB_TEST_MTE   3'b010
`define lpCSRB_TEST_RAM   3'b011
`define lpCSRB_TEST_MPE   3'b100
`define lpCSRB_TEST_LPE   3'b101
`define lpCSRB_TEST_PCTR  3'b110
`define lpCSRB_TEST_NU    3'b111

`endif
