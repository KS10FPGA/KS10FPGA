////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KMC11 Multiphase Clock Generator (CLK)
//
// Details
//   This file contains the implementation of the clock generator
//
// File
//   kmcclk.sv
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

module KMCCLK (
      input  wire  clk,                 // Clock
      input  wire  rst,                 // Reset
      input  wire  kmcINIT,             // Initialize
      input  wire  kmcSTEP,             // Single step
      input  wire  kmcRUN,              // Run
      output logic kmcCRAMCLKEN,        // CRAM clock enable
      output logic kmcALUCLKEN,         // ALU clock enable
      output logic kmcSPCLKEN,          // SP clock enable
      output logic kmcBRGCLKEN,         // BRG clock enable
      output logic kmcMARCLKEN,         // MAR clock enable
      output logic kmcMEMCLKEN,         // MEM clock enable
      output logic kmcMISCCLKEN,        // MISC clock enable
      output logic kmcNPRCLKEN,         // NPR clock enable
      output logic kmcPCCLKEN,          // PC clock enable
      output logic kmcREGCLKEN          // REG clock enable
   );

   //
   // State Machine
   //

   localparam [3:0] kmcSTATE_IDLE = 0,  // T0
                    kmcSTATE_CRAM = 1,  // T60
                    kmcSTATE_PC   = 2,  // T120
                    kmcSTATE_ALU  = 3,  // T180
                    kmcSTATE_DONE = 4;  // T240

   logic [3:0] state;

   always_ff @(posedge clk)
     begin
        if (rst | kmcINIT)
          state <= kmcSTATE_IDLE;
        else
          case (state)
            kmcSTATE_IDLE:
              if (kmcSTEP | kmcRUN)
                state <= kmcSTATE_CRAM;
            kmcSTATE_CRAM:
              state <= kmcSTATE_PC;
            kmcSTATE_PC:
              state <= kmcSTATE_ALU;
            kmcSTATE_ALU:
              state <= kmcSTATE_DONE;
            kmcSTATE_DONE:
              if (kmcRUN)
                state <= kmcSTATE_CRAM;
              else
                state <= kmcSTATE_IDLE;
          endcase
     end

   assign kmcCRAMCLKEN = state == kmcSTATE_CRAM;
   assign kmcPCCLKEN   = state == kmcSTATE_PC;
   assign kmcREGCLKEN  = state == kmcSTATE_PC;
   assign kmcMARCLKEN  = state == kmcSTATE_ALU;
   assign kmcALUCLKEN  = state == kmcSTATE_ALU;
   assign kmcBRGCLKEN  = state == kmcSTATE_ALU;
   assign kmcMEMCLKEN  = state == kmcSTATE_ALU;
   assign kmcMISCCLKEN = state == kmcSTATE_ALU;
   assign kmcNPRCLKEN  = state == kmcSTATE_ALU;
   assign kmcSPCLKEN   = state == kmcSTATE_DONE;

endmodule
