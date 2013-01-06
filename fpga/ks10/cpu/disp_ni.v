////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//    Next Instruction Dispatch
//
// Details
//    This is a 16-way dispatch base on the next instruction.
//
// Todo
//
// File
//    ni_disp.v
//
// Author
//    Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2012 Rob Doyle
//
// This source file may be used and distributed without
// restriction provided that this copyright statement is not
// removed from the file and that any derivative work contains
// the original copyright notice and the associated disclaimer.
//
// This source file is free software; you can redistribute it
// and/or modify it under the terms of the GNU Lesser General
// Public License as published by the Free Software Foundation;
// version 2.1 of the License.
//
// This source is distributed in the hope that it will be
// useful, but WITHOUT ANY WARRANTY; without even the implied
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
// PURPOSE. See the GNU Lesser General Public License for more
// details.
//
// You should have received a copy of the GNU Lesser General
// Public License along with this source; if not, download it
// from http://www.gnu.org/licenses/lgpl.txt
//
////////////////////////////////////////////////////////////////////

`default_nettype none
`include "apr.vh"
`include "pcflags.vh"
`include "useq/crom.vh"
  
module NI_DISP (clk, rst, clken, crom, aprFLAGS, pcFLAGS, cslTRAPEN,
                cpuRUN, memory_cycle, dispNI, trapCYCLE);
   
   parameter cromWidth = `CROM_WIDTH;

   input                   clk;         // Clock
   input                   rst;         // Reset
   input                   clken;       // Clock Enable
   input  [ 0:cromWidth-1] crom;        // Control ROM Data
   input  [ 0:17]          pcFLAGS;   	// PC Flags
   input  [22:35]          aprFLAGS;    // APR Flags
   input                   cslTRAPEN;   // Console Trap Enable
   input                   cpuRUN;      // Run
   input                   memory_cycle;// Memory Cycle
   output [ 8:11]          dispNI;      // Next Instruction dispatch
   output                  trapCYCLE;   // Trap Cycle
 
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
   // Trace
   //  CRA2/E147
   //

   reg [8:11] dispNI;
   always @(cslTRAPEN or flagTRAPEN or flagTRAP1 or flagTRAP2 or cpuRUN or memory_cycle)
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

   reg trapCYCLE;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          trapCYCLE <= 0;
        else if (clken & specNICOND)
          begin
             if ((cslTRAPEN & flagTRAPEN & flagTRAP1) |
                 (cslTRAPEN & flagTRAPEN & flagTRAP2))
               trapCYCLE <= 1;
             else
               trapCYCLE <= 0;
          end
     end
   
endmodule
