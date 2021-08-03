////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Unibus Excerciser Control/Status Register #1 (UBECSR1) bit definitions.
//
// Details
//   This file contains the bit definitions for the UBE Control/Status
//   Register #1.
//
// File
//   ubecsr1.vh
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

`ifndef __UBECSR1_VH
`define __UBECSR1_VH

`define ubeCSR1_ERR(reg)   (reg[15])    // (R  ) 100000 : Error
`define ubeCSR1_UNK5(reg)  (reg[14])    // (R/W) 040000 : ???
`define ubeCSR1_UNK4(reg)  (reg[13])    // (R/W) 020000 : ???
`define ubeCSR1_UNK3(reg)  (reg[12])    // (R/W) 010000 : ???
`define ubeCSR1_FTM(reg)   (reg[11])    // (R/W) 004000 : Fast Transfer Mode (back-to-back transfers)
`define ubeCSR1_XTCCO(reg) (reg[10])    // (R/W) 002000 : XFER til Cycle Count Register Overflow
`define ubeCSR1_NPRO(reg)  (reg[ 9])    // (R/W) 001000 : NPR Out  (Unibus C1 : 1=DATO, 0=DATI_
`define ubeCSR1_BYTE(reg)  (reg[ 8])    // (R/W) 000400 : NPR Byte (Unibus C0)
`define ubeCSR1_UNK2(reg)  (reg[ 7])    // (R  ) 000200 : ???
`define ubeCSR1_UNK1(reg)  (reg[ 6])    // (R/W) 000100 : ???
`define ubeCSR1_NPRS(reg)  (reg[ 5])    // (R/W) 000040 : Simulate NPR cycles
`define ubeCSR1_BR7(reg)   (reg[ 4])    // (R/W) 000020 : Unibus BR7 (Interrupt Level 7)
`define ubeCSR1_BR6(reg)   (reg[ 3])    // (R/W) 000010 : Unibus BR6 (Interrupt Level 6)
`define ubeCSR1_BR5(reg)   (reg[ 2])    // (R/W) 000004 : Unibus BR5 (Interrupt Level 5)
`define ubeCSR1_BR4(reg)   (reg[ 1])    // (R/W) 000002 : Unibus BR4 (Interrupt Level 4)
`define ubeCSR1_GO(reg)    (reg[ 0])    // (R/W) 000001 : GO

`define ubeCSR1_BR(reg)    (reg[4:1])   // (R/W) Unibus BR level

`endif
