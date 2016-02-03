////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   UBA Status Register (UBASR) Definitions
//
// Details
//   This module provides the bit definitions for the IO Bridge Status Register
//   (UBASR)
//
// File
//   ubasr.vh
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

`ifndef __UBASR_VH
`define __UBASR_VH

//
// UBASR Register Bits
//

`define statTMO(bus)    (bus[18])               // Timeout/NXM
`define statBMD(bus)    (bus[19])               // Bad memory data
`define statBPE(bus)    (bus[20])               // Bus parity error
`define statNXD(bus)    (bus[21])               // Non-existant device
`define statHI(bus)     (bus[24])               // Hi interrupt
`define statLO(bus)     (bus[25])               // Lo interrupt
`define statPWR(bus)    (bus[26])               // Powerfail
`define statDXF(bus)    (bus[28])               // Disable transfer
`define statINI(bus)    (bus[29])               // Initialized
`define statPIH(bus)    (bus[30:32])            // Hi priority PIA
`define statPIL(bus)    (bus[33:35])            // Lo priority PIA

`endif
