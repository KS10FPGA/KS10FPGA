////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Unibus Excerciser Control/Status Register #2 (UBECSR2) bit definitions.
//
// Details
//   This file contains the bit definitions for the UBE Control/Status
//   Register #2.
//
// File
//   ubecsr2.vh
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

`ifndef __UBECSR2_VH
`define __UBECSR2_VH

`define ubeCSR2_TMO(reg)   (reg[15])    // (R  ) Timeout
`define ubeCSR2_BMD(reg)   (reg[14])    // (R  ) Bad Memory Data
`define ubeCSR2_BPE(reg)   (reg[13])    // (R  ) Bus Parity Error
`define ubeCSR2_NXD(reg)   (reg[12])    // (R  ) Non Existent Device
`define ubeCSR2_USSE(reg)  (reg[11])    // (R  ) Unibus Interrupt Slave SSYNC Error
`define ubeCSR2_UNGG(reg)  (reg[10])    // (R  ) Unibus No Grant or Not One Grant
`define ubeCSR2_UWAL(reg)  (reg[ 9])    // (R  ) Unibus Wrong A Lines
`define ubeCSR2_UNSE(reg)  (reg[ 8])    // (R  ) Unibus No SSYN Error
`define ubeCSR2_UNST(reg)  (reg[ 7])    // (R  ) Unibus No No SACK Timeout
`define ubeCSR2_UMLE(reg)  (reg[ 6])    // (R  ) Unibus Max Late Error
`define ubeCSR2_UWGB(reg)  (reg[ 5])    // (R  ) Unibus Wrong Grant Back
`define ubeCSR2_ACLO(reg)  (reg[ 4])    // (R/W) ACLO (Power)
`define ubeCSR2_USED3(reg) (reg[ 3])    // (R/W) ???
`define ubeCSR2_USED2(reg) (reg[ 2])    // (R/W) ???
`define ubeCSR2_USED1(reg) (reg[ 1])    // (R/W) EA[17] Extended Address??
`define ubeCSR2_USED0(reg) (reg[ 0])    // (R/W) EA[16] Extended Address??

`endif
