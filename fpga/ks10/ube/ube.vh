////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Unibus Excerciser definitions
//
// Details
//   This file contains configuration parameters
//
// File
//   ube.vh
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

`ifndef __UBE_VH
`define __UBE_VH

`include "../uba/uba.vh"

//
// UBE Device 1 Parameters
//

`define ube1DEV  (`devUBA4)            // Device 1
`define ube1VECT (18'o000510)          // Interrupt Vector
`define ube1ADDR (18'o770000)          // Base Address

//
// UBE Device 2 Parameters
//

`define ube2DEV  (`devUBA4)             // Device 2
`define ube2VECT (18'o000520)           // Interrupt Vector
`define ube2ADDR (18'o770020)           // Base Address

//
// UBE Device 3 Parameters
//

`define ube3DEV  (`devUBA4)             // Device 3
`define ube3VECT (18'o000530)           // Interrupt Vector
`define ube3ADDR (18'o770040)           // Base Address

//
// UBE Device 4 Parameters
//

`define ube4DEV  (`devUBA4)             // Device 4
`define ube4VECT (18'o000540)           // Interrupt Vector
`define ube4ADDR (18'o770060)           // Base Address

//
// UBE Device 5 Parameters
//

`define ube5DEV  (`devUBA4)             // Device 5
`define ube5VECT (18'o00550)            // Interrupt Vector
`define ube5ADDR (18'o770100)           // Base Address

//
// UBE Device 6 Parameters
//

`define ube6DEV  (`devUBA4)             // Device 6
`define ube6VECT (18'o000560)           // Interrupt Vector
`define ube6ADDR (18'o770120)           // Base Address

//
// UBE Device 7 Parameters
//

`define ube7DEV  (`devUBA4)             // Device 7
`define ube7VECT (18'o000570)           // Interrupt Vector
`define ube7ADDR (18'o770140)           // Base Address

//
// UBE Device 8 Parameters
//

`define ube8DEV  (`devUBA4)             // Device 8
`define ube8VECT (18'o000600)           // Interrupt Vector
`define ube8ADDR (18'o770160)           // Base Address

//
// UBE Device 9 Parameters
//

`define ube9DEV  (`devUBA4)             // Device 9
`define ube9VECT (18'o00610)            // Interrupt Vector
`define ube9ADDR (18'o770200)           // Base Address

//
// UBE Device 10 Parameters
//

`define ube10DEV  (`devUBA4)            // Device 10
`define ube10VECT (18'o000620)          // Interrupt Vector
`define ube10ADDR (18'o770220)          // Base Address

//
// UBE Device 11 Parameters
//

`define ube11DEV  (`devUBA4)            // Device 11
`define ube11VECT (18'o000630)          // Interrupt Vector
`define ube11ADDR (18'o770240)          // Base Address

//
// UBE Device 12 Parameters
//

`define ube12DEV  (`devUBA4)            // Device 12
`define ube12VECT (18'o000640)          // Interrupt Vector
`define ube12ADDR (18'o770260)          // Base Address

//
// Global addresses
//

`define ubesimgoADDR (18'o770014)       // UBE Simultaneous GO               ( W)

//
// UBE Register Address Offsets
//

`define ubedbOFFSET   (4'o00)           // UBE Data Buffer Register Offset   (RW)
`define ubeccOFFSET   (4'o02)           // UBE Cycle Counter Register Offset (RW)
`define ubebaOFFSET   (4'o04)           // UBE Base Address Register Offset  (RW)
`define ubec1OFFSET   (4'o06)           // UBE Control Register #1 Offset    (RW)
`define ubeclrOFFSET  (4'o10)           // UBE Clear Error Bits              ( W)
`define ubec2OFFSET   (4'o16)           // UBE Control Register #2 Offset    (RW)

`define ubeSIMGO(reg) (reg[0])          // Simultaneous GO
`define ubeCLRERR(reg)(reg[0])          // Reset errors

`endif
