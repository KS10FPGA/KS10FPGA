////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Control ROM (CRAM) Definitions
//
// Details
//   This file contains the Control ROM microcode field definitions.
//
//   Include it everywhere you need to access the Control ROM.
//
// File
//   cram.vh
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

`ifndef __KMCRAM_VH
`define __KMCRAM_VH

//
// SRC Field (All Instructions)
//

`define kmcCRAM_SRC(cram)       cram[15:13]
`define kmcCRAM_SRC_MOV_IMMED   3'b000          // MOV IMMEDiate
`define kmcCRAM_SRC_MOV_IBUS    3'b001          // MOV IBUS
`define kmcCRAM_SRC_MOV_MEM     3'b010          // MOV MEM
`define kmcCRAM_SRC_MOV_BRG     3'b011          // MOV BRG
`define kmcCRAM_SRC_JMP_IMMED   3'b100          // JMP IMMEDiate
`define kmcCRAM_SRC_MOV_IBUSS   3'b101          // MOV IBUS*
`define kmcCRAM_SRC_JMP_MEM     3'b110          // JMP MEM
`define kmcCRAM_SRC_JMP_BRG     3'b111          // JMP BRG

//
// MAR Field (All Instructions)
//

`define kmcCRAM_MAR(cram)       cram[12:11]
`define kmcCRAM_MAR_NOP         2'b00           // Don't alter MAR
`define kmcCRAM_MAR_LDHI        2'b01           // Load MAR HI (Page)
`define kmcCRAM_MAR_LDLO        2'b10           // Load MAR LO
`define kmcCRAM_MAR_INC         2'b11           // Increment MAR

//
// DEST Field (MOV Instructions)
//

`define kmcCRAM_DST(cram)       cram[10:8]
`define kmcCRAM_DST_NODST       3'b000          // No destination
`define kmcCRAM_DST_BRG         3'b001          // BRG
`define kmcCRAM_DST_OBUSS       3'b010          // OUTBUS* Register
`define kmcCRAM_DST_BRGSHR      3'b011          // BRG Shifted Right
`define kmcCRAM_DST_OBUS        3'b100          // OUTBUS Register
`define kmcCRAM_DST_MEM         3'b101          // Memory
`define kmcCRAM_DST_SP          3'b110          // Scratch Pad (SP)
`define kmcCRAM_DST_SPBRG       3'b111          // BRG and SP

//
// COND Field (JMP Instructions)
//

`define kmcCRAM_COND(cram)      cram[10:8]
`define kmcCRAM_COND_RESVD      3'b000          // Reserved
`define kmcCRAM_COND_ALWAYS     3'b001          // Always
`define kmcCRAM_COND_ALUC       3'b010          // ALU Carry
`define kmcCRAM_COND_ALUZ       3'b011          // ALU Zero
`define kmcCRAM_COND_BRG0       3'b100          // BRG0
`define kmcCRAM_COND_BRG1       3'b101          // BRG1
`define kmcCRAM_COND_BRG4       3'b110          // BRG4
`define kmcCRAM_COND_BRG7       3'b111          // BRG7

//
// ALU Function (All Instructions)
//

`define kmcCRAM_FUN(cram)       cram[7:4]
`define kmcCRAM_FUN_ADD         4'b0000         // A+B
`define kmcCRAM_FUN_ADDC        4'b0001         // A+B+C
`define kmcCRAM_FUN_SUBC        4'b0010         // A-B-C
`define kmcCRAM_FUN_INCA        4'b0011         // A+1
`define kmcCRAM_FUN_APLUSC      4'b0100         // A+C
`define kmcCRAM_FUN_TWOA        4'b0101         // A+A
`define kmcCRAM_FUN_TWOAC       4'b0110         // A+A+C
`define kmcCRAM_FUN_DECA        4'b0111         // A-1
`define kmcCRAM_FUN_SELA        4'b1000         // A
`define kmcCRAM_FUN_SELB        4'b1001         // B
`define kmcCRAM_FUN_AORNB       4'b1010         // A|~B
`define kmcCRAM_FUN_AANDB       4'b1011         // A&B
`define kmcCRAM_FUN_AORB        4'b1100         // A|B
`define kmcCRAM_FUN_AXORB       4'b1101         // A^B
`define kmcCRAM_FUN_SUB         4'b1110         // A-B
`define kmcCRAM_FUN_SUBOC       4'b1111         // A-B-1

//
// INBUS addresses
//

`define kmcCRAM_IBUS(cram)      cram[7:4]
`define kmcCRAM_IBUS_NPRIDL     4'b0000         // NPR input data LO
`define kmcCRAM_IBUS_NPRIDH     4'b0001         // NPR input data HI
`define kmcCRAM_IBUS_NPRODL     4'b0010         // NPR output data LO
`define kmcCRAM_IBUS_NPRODH     4'b0011         // NPR output data HI
`define kmcCRAM_IBUS_NPRIAL     4'b0100         // NPR input address LO
`define kmcCRAM_IBUS_NPRIAH     4'b0101         // NPR input address HI
`define kmcCRAM_IBUS_NPROAL     4'b0110         // NPR output address LO
`define kmcCRAM_IBUS_NPROAH     4'b0111         // NPR output address HI
`define kmcCRAM_IBUS_XREG0      4'b1000         // LU XREG0
`define kmcCRAM_IBUS_XREG1      4'b1001         // LU XREG1
`define kmcCRAM_IBUS_XREG2      4'b1010         // LU XREG2
`define kmcCRAM_IBUS_XREG3      4'b1011         // LU XREG3
`define kmcCRAM_IBUS_XREG4      4'b1100         // LU XREG4
`define kmcCRAM_IBUS_XREG5      4'b1101         // LU XREG5
`define kmcCRAM_IBUS_XREG6      4'b1110         // LU XREG6
`define kmcCRAM_IBUS_XREG7      4'b1111         // LU XREG7

//
// INBUS* addresses
//

`define kmcCRAM_IBUSS(cram)     cram[7:4]
`define kmcCRAM_IBUSS_CSR0      4'b0000         // CSR0
`define kmcCRAM_IBUSS_CSR1      4'b0001         // CSR1
`define kmcCRAM_IBUSS_CSR2      4'b0010         // CSR2
`define kmcCRAM_IBUSS_CSR3      4'b0011         // CSR3
`define kmcCRAM_IBUSS_CSR4      4'b0100         // CSR4
`define kmcCRAM_IBUSS_CSR5      4'b0101         // CSR5
`define kmcCRAM_IBUSS_CSR6      4'b0110         // CSR6
`define kmcCRAM_IBUSS_CSR7      4'b0111         // CSR7
`define kmcCRAM_IBUSS_NPRC      4'b1000         // NPR Control
`define kmcCRAM_IBUSS_MISC      4'b1001         // uP Misc
`define kmcCRAM_IBUSS_UND12     4'b1010         // UNDEF12
`define kmcCRAM_IBUSS_UND13     4'b1011         // UNDEF13
`define kmcCRAM_IBUSS_UND14     4'b1100         // UNDEF14
`define kmcCRAM_IBUSS_UND15     4'b1101         // UNDEF15
`define kmcCRAM_IBUSS_UND16     4'b1110         // UNDEF16
`define kmcCRAM_IBUSS_UND17     4'b1111         // UNDEF17

//
// OBUS addresses
//

`define kmcCRAM_OBUS(cram)      cram[3:0]
`define kmcCRAM_OBUS_NPRIDL     4'b0000         // NPR input data LO
`define kmcCRAM_OBUS_NPRIDH     4'b0001         // NPR input data HI
`define kmcCRAM_OBUS_NPRODL     4'b0010         // NPR output data LO
`define kmcCRAM_OBUS_NPRODH     4'b0011         // NPR output data HI
`define kmcCRAM_OBUS_NPRIAL     4'b0100         // NPR input address LO
`define kmcCRAM_OBUS_NPRIAH     4'b0101         // NPR input address HI
`define kmcCRAM_OBUS_NPROAL     4'b0110         // NPR output address LO
`define kmcCRAM_OBUS_NPROAH     4'b0111         // NPR output address HI
`define kmcCRAM_OBUS_XREG0      4'b1000         // LU XREG0
`define kmcCRAM_OBUS_XREG1      4'b1001         // LU XREG1
`define kmcCRAM_OBUS_XREG2      4'b1010         // LU XREG2
`define kmcCRAM_OBUS_XREG3      4'b1011         // LU XREG3
`define kmcCRAM_OBUS_XREG4      4'b1100         // LU XREG4
`define kmcCRAM_OBUS_XREG5      4'b1101         // LU XREG5
`define kmcCRAM_OBUS_XREG6      4'b1110         // LU XREG6
`define kmcCRAM_OBUS_XREG7      4'b1111         // LU XREG7

//
// OBUS* addresses
//

`define kmcCRAM_OBUSS(cram)     cram[3:0]
`define kmcCRAM_OBUSS_CSR0      4'b0000         // NPR input data LO
`define kmcCRAM_OBUSS_CSR1      4'b0001         // NPR input data HI
`define kmcCRAM_OBUSS_CSR2      4'b0010         // NPR output data LO
`define kmcCRAM_OBUSS_CSR3      4'b0011         // NPR output data HI
`define kmcCRAM_OBUSS_CSR4      4'b0100         // NPR input address LO
`define kmcCRAM_OBUSS_CSR5      4'b0101         // NPR input address HI
`define kmcCRAM_OBUSS_CSR6      4'b0110         // NPR output address LO
`define kmcCRAM_OBUSS_CSR7      4'b0111         // NPR output address HI
`define kmcCRAM_OBUSS_NPR       4'b1000         // NPR Control
`define kmcCRAM_OBUSS_UMISC     4'b1001         // up MISC
`define kmcCRAM_OBUSS_PCLO      4'b1010         // PC LO
`define kmcCRAM_OBUSS_PCHI      4'b1011         // PC HI
`define kmcCRAM_OBUSS_MARLO     4'b1100         // MAR LO
`define kmcCRAM_OBUSS_MARHI     4'b1101         // MAR HI
`define kmcCRAM_OBUSS_UND16     4'b1110         // UNDEF16
`define kmcCRAM_OBUSS_UND17     4'b1111         // UNDEF17

//
// Scratchpad Address (JMP Instructions)
//

`define kmcCRAM_SPADDR(cram)    cram[3:0]

//
// Immediate Operand (MOV and JMP Instructions)
//

`define kmcCRAM_IMMED           cram[7:0]

`endif
