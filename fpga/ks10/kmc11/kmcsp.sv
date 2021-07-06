////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KMC11 Scratch Pad Memory
//
// Details
//   This module implements the Scratch Pad Memory.
//
// File
//   kmcsp.sv
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

module KMCSP (
      input  wire         rst,          // Reset
      input  wire         clk,          // Clock
      input  wire         kmcSPCLKEN,   // SP clock enable
      input  wire  [15:0] kmcCRAM,      // Control ROM Data
      input  wire  [ 7:0] kmcALU,       // ALU output
      output logic [ 7:0] kmcSP         // Scratchpad data
   );

   //
   // Microcode Decode
   //  This decodes MOV instructions
   //
   // Trace
   //   M8206/D7/E40
   //

   wire kmcSRCMOV = ((`kmcCRAM_SRC(kmcCRAM) == `kmcCRAM_SRC_MOV_IMMED) |
                     (`kmcCRAM_SRC(kmcCRAM) == `kmcCRAM_SRC_MOV_IBUS ) |
                     (`kmcCRAM_SRC(kmcCRAM) == `kmcCRAM_SRC_MOV_MEM  ) |
                     (`kmcCRAM_SRC(kmcCRAM) == `kmcCRAM_SRC_MOV_BRG  ) |
                     (`kmcCRAM_SRC(kmcCRAM) == `kmcCRAM_SRC_MOV_IBUSS));

   //
   // Microcode Decode
   //  This decodes instructions with a Scratch Pad (SP) destination
   //
   // Trace
   //   M8206/D1/E65
   //

   wire kmcDESTSP = ((`kmcCRAM_DST(kmcCRAM) == `kmcCRAM_DST_SP) |
                     (`kmcCRAM_DST(kmcCRAM) == `kmcCRAM_DST_SPBRG));

   //
   // Microcode Decode
   //  This decodes instructions with a OBUS or OBUSS destination
   //
   // Trace
   //   M8206/D1/E115
   //

   wire kmcWROUT = ((`kmcCRAM_DST(kmcCRAM) == `kmcCRAM_DST_OBUSS) |
                    (`kmcCRAM_DST(kmcCRAM) == `kmcCRAM_DST_OBUS));

   //
   // Write to Scratch Pad Register (SP)
   //  Only enabled on MOV instructions with SP destination
   //
   // Trace
   //   M8206/D1/E74
   //

   wire kmcWRSP = kmcSRCMOV & kmcDESTSP;

   //
   // Scratchpad Address Mux
   //
   // Trace
   //  M8206/D8/E105
   //

   logic [3:0] kmcSPADDR;

   always_comb
     begin
        if (kmcWROUT)
          kmcSPADDR <= 0;
        else
          kmcSPADDR <= `kmcCRAM_SPADDR(kmcCRAM);
     end

   //
   // Scratchpad Memory (8x16)
   //
   // Trace
   //  M8206/D8/E96
   //  M8206/D8/E97
   //

   logic [3:0] kmcRDADDR;
   logic [7:0] kmcSPDAT[0:15];

   always_ff @(posedge clk)
     begin
        if (rst)
          begin
             kmcSPDAT[ 0] <= 0;
             kmcSPDAT[ 1] <= 0;
             kmcSPDAT[ 2] <= 0;
             kmcSPDAT[ 3] <= 0;
             kmcSPDAT[ 4] <= 0;
             kmcSPDAT[ 5] <= 0;
             kmcSPDAT[ 6] <= 0;
             kmcSPDAT[ 7] <= 0;
             kmcSPDAT[ 8] <= 0;
             kmcSPDAT[ 9] <= 0;
             kmcSPDAT[10] <= 0;
             kmcSPDAT[11] <= 0;
             kmcSPDAT[12] <= 0;
             kmcSPDAT[13] <= 0;
             kmcSPDAT[14] <= 0;
             kmcSPDAT[15] <= 0;
          end
        else
          begin
             if (kmcWRSP & kmcSPCLKEN)
               kmcSPDAT[kmcSPADDR] <= kmcALU;
             kmcRDADDR <= kmcSPADDR;
          end
     end

   //
   // Read Scratch Pad Memory
   //

   assign kmcSP = kmcSPDAT[kmcRDADDR];

endmodule
