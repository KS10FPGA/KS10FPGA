////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KS10 Console Header file
//
// Details
//   This file contains the Console Register bit definitions.
//
// File
//   csl.vh
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2020-2021 Rob Doyle
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

`ifndef __CSL_VH
`define __CSL_VH

//
// conCSR bits
//

`define cslGO(reg)      (reg[15])
`define cslNXMNXD(reg)  (reg[22])
`define cslHALT(reg)    (reg[23])
`define cslRUN(reg)     (reg[24])
`define cslCONT(reg)    (reg[25])
`define cslEXEC(reg)    (reg[26])
`define cslTIMEREN(reg) (reg[27])
`define cslTRAPEN(reg)  (reg[28])
`define cslCACHEEN(reg) (reg[29])
`define cslINTR(reg)    (reg[30])
`define cslRESET(reg)   (reg[31])

//
// lpCSR bits
//

`define lpONLN(reg)     (reg[30])
`define lpOFFLN(reg)    (reg[31])

`endif
