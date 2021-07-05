////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KMC11 Data Multiplexor (DMUX)
//
// Details
//   This file provides the implementation of the DMUX.
//
// File
//   kmcdmux.v
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

`default_nettype none
`timescale 1ns/1ps

`include "kmccram.vh"

module KMCDMUX (
      input  wire [15:0] kmcCRAM,       // Control ROM
      input  wire [15:0] kmcNPRID,      // NPR in data
      input  wire [15:0] kmcNPROD,      // NPR out data
      input  wire [15:0] kmcNPRIA,      // NPR in address
      input  wire [15:0] kmcNPROA,      // NPR out address
      input  wire [15:0] kmcCSR0,       // CSR0
      input  wire [15:0] kmcCSR2,       // CSR2
      input  wire [15:0] kmcCSR4,       // CSR4
      input  wire [15:0] kmcCSR6,       // CSR5
      input  wire [ 7:0] kmcMISC,       // Misc register
      input  wire [ 7:0] kmcNPRC,       // DMA Control register
      input  wire [ 7:0] kmcBRG,        // Branch register
      input  wire [ 7:0] kmcMEM,        // Memory
      input  wire [15:0] kmcLUIBUS,     // LUI bus
      input  wire [ 9:0] kmcPC,         // Program counter
      input  wire [10:0] kmcMAR,        // Memory Address Register
      input  wire        kmcALUZ,       // ALU Zero
      input  wire        kmcALUC,       // ALU Carry
      output reg  [ 7:0] kmcDMUX        // DMUX Data
   );

   //
   // Microcode Decode
   //
   // This is done so that I can see the microcode in the simulator.
   //

   wire [15:13] kmcSRC   = `kmcCRAM_SRC (kmcCRAM);
   wire [ 7: 4] kmcIBUS  = `kmcCRAM_IBUS(kmcCRAM);
   wire [ 7: 4] kmcIBUSS = `kmcCRAM_IBUSS(kmcCRAM);

   //
   // DMUX
   //
   // Trace
   //   M8206/D7/E50
   //   M8206/D7/E61
   //   M8206/D7/E63
   //   M8206/D7/E51
   //   M8206/D7/E70
   //   M8206/D7/E72
   //   M8206/D7/E73
   //   M8206/D7/E80
   //

   always @*
     begin
        case (kmcSRC)
          `kmcCRAM_SRC_MOV_IMMED   : kmcDMUX <= kmcCRAM[7:0];
          `kmcCRAM_SRC_MOV_IBUS    :
            case (kmcIBUS)
              `kmcCRAM_IBUS_NPRIDL : kmcDMUX <= kmcNPRID[ 7:0];
              `kmcCRAM_IBUS_NPRIDH : kmcDMUX <= kmcNPRID[15:8];
              `kmcCRAM_IBUS_NPRODL : kmcDMUX <= kmcNPROD[ 7:0];
              `kmcCRAM_IBUS_NPRODH : kmcDMUX <= kmcNPROD[15:8];
              `kmcCRAM_IBUS_NPRIAL : kmcDMUX <= kmcNPRIA[ 7:0];
              `kmcCRAM_IBUS_NPRIAH : kmcDMUX <= kmcNPRIA[15:8];
              `kmcCRAM_IBUS_NPROAL : kmcDMUX <= kmcNPROA[ 7:0];
              `kmcCRAM_IBUS_NPROAH : kmcDMUX <= kmcNPROA[15:8];
              `kmcCRAM_IBUS_XREG0  : kmcDMUX <= kmcLUIBUS[ 7:0];
              `kmcCRAM_IBUS_XREG1  : kmcDMUX <= kmcLUIBUS[15:8];
              `kmcCRAM_IBUS_XREG2  : kmcDMUX <= kmcLUIBUS[ 7:0];
              `kmcCRAM_IBUS_XREG3  : kmcDMUX <= kmcLUIBUS[15:8];
              `kmcCRAM_IBUS_XREG4  : kmcDMUX <= kmcLUIBUS[ 7:0];
              `kmcCRAM_IBUS_XREG5  : kmcDMUX <= kmcLUIBUS[15:8];
              `kmcCRAM_IBUS_XREG6  : kmcDMUX <= kmcLUIBUS[ 7:0];
              `kmcCRAM_IBUS_XREG7  : kmcDMUX <= kmcLUIBUS[15:8];
            endcase
          `kmcCRAM_SRC_MOV_MEM     : kmcDMUX <= kmcMEM;
          `kmcCRAM_SRC_MOV_BRG     : kmcDMUX <= kmcBRG;
          `kmcCRAM_SRC_JMP_IMMED   : kmcDMUX <= kmcCRAM[7:0];
          `kmcCRAM_SRC_MOV_IBUSS   :
            case (kmcIBUSS)
              `kmcCRAM_IBUSS_CSR0  : kmcDMUX <= kmcCSR0[ 7:0];
              `kmcCRAM_IBUSS_CSR1  : kmcDMUX <= kmcCSR0[15:8];
              `kmcCRAM_IBUSS_CSR2  : kmcDMUX <= kmcCSR2[ 7:0];
              `kmcCRAM_IBUSS_CSR3  : kmcDMUX <= kmcCSR2[15:8];
              `kmcCRAM_IBUSS_CSR4  : kmcDMUX <= kmcCSR4[ 7:0];
              `kmcCRAM_IBUSS_CSR5  : kmcDMUX <= kmcCSR4[15:8];
              `kmcCRAM_IBUSS_CSR6  : kmcDMUX <= kmcCSR6[ 7:0];
              `kmcCRAM_IBUSS_CSR7  : kmcDMUX <= kmcCSR6[15:8];
              `kmcCRAM_IBUSS_NPRC  : kmcDMUX <= kmcNPRC;
              `kmcCRAM_IBUSS_MISC  : kmcDMUX <= kmcMISC;
              `kmcCRAM_IBUSS_UND12 : kmcDMUX <= 0;
              `kmcCRAM_IBUSS_UND13 : kmcDMUX <= 0;
              `kmcCRAM_IBUSS_UND14 : kmcDMUX <= 0;
              `kmcCRAM_IBUSS_UND15 : kmcDMUX <= 0;
              `kmcCRAM_IBUSS_UND16 : kmcDMUX <= 0;
              `kmcCRAM_IBUSS_UND17 : kmcDMUX <= 0;
            endcase
          `kmcCRAM_SRC_JMP_MEM     : kmcDMUX <= kmcMEM;
          `kmcCRAM_SRC_JMP_BRG     : kmcDMUX <= kmcBRG;
        endcase
     end

endmodule
