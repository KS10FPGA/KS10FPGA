////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Next Instruction Dispatch
//
// Details
//   This is a 16-way dispatch base on the next instruction.
//
// Note:
//   Trap 1 is an arithmetic overflow.
//   Trap 2 is a stack overflow.
//   Trap 3 is a software trap.
//
// File
//   disp_ni.v
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

`default_nettype none
`timescale 1ns/1ps

`include "apr.vh"
`include "pcflags.vh"
`include "useq/crom.vh"

module DISP_NI (
      input  wire          clk,         // Clock
      input  wire          rst,         // Reset
      input  wire          clken,       // Clock Enable
      input  wire [ 0:107] crom,        // Control ROM Data
      input  wire [ 0: 17] pcFLAGS,     // PC Flags
      input  wire [22: 35] aprFLAGS,    // APR Flags
      input  wire          cslTRAPEN,   // Console Trap Enable
      input  wire          cpuRUN,      // Run
      input  wire          memory_cycle,// Memory Cycle
      output reg  [ 8: 11] dispNI,      // Next Instruction dispatch
      output reg           trapCYCLE    // Trap Cycle
   );

   //
   // Microcode Decode
   //

   wire specNICOND = `cromSPEC_EN_10 & (`cromSPEC_SEL == `cromSPEC_SEL_LOADNICOND);

   //
   // APR Flags
   //

   wire flagTRAPEN = `flagTRAPEN(aprFLAGS);

   //
   // PC Flags
   //

   wire flagTRAP2 = `flagTRAP2(pcFLAGS);
   wire flagTRAP1 = `flagTRAP1(pcFLAGS);

   //
   // NICOND Dispatch
   //
   // A dispatch value of 1, 2, or 3 causes the microcode to dispath to a trap
   // handler.
   //
   // A dispatch value of 5 (caused by ~cpuRUN) causes the microcode to enter
   // the HALT loop.
   //
   // A dispatch value of 7 cause the microcode to begin to execute the next
   // instruction after the instruction has completed.
   //
   // Trace
   //  CRA2/E147
   //  DPE9/E125
   //

   always @*
     begin
        if (cslTRAPEN & flagTRAPEN)
          if (flagTRAP1 & flagTRAP2)
            dispNI[9:11] = 3'd1;
          else if (flagTRAP2)
            dispNI[9:11] = 3'd2;
          else if (flagTRAP1)
            dispNI[9:11] = 3'd3;
          else if (~cpuRUN)
            dispNI[9:11] = 3'd5;
          else
            dispNI[9:11] = 3'd7;
        else if (~cpuRUN)
          dispNI[9:11] = 3'd5;
        else
          dispNI[9:11] = 3'd7;
        dispNI[8] = memory_cycle;
     end

   //
   // Trap Cycle
   //
   // Trace
   //  CRA2/E159
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          trapCYCLE <= 0;
        else if (clken & specNICOND)
          trapCYCLE <= cslTRAPEN & flagTRAPEN & (flagTRAP1 | flagTRAP2);
     end

endmodule
