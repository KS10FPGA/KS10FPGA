////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RPxx Disk Address Register (RPDA)
//
// File
//   rpda.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2015 Rob Doyle
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

`include "rpda.vh"

module RPDA (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire [35: 0] rpDATAI,              // RP Data In
      input  wire         rpdaWRITE,            // DA Write
      input  wire         rpPRESET,             // Preset command
      input  wire [ 5: 0] rpSECNUM,             // Last sector number
      input  wire [ 5: 0] rpTRKNUM,             // Last track number
      input  wire         rpINCSECT,            // Increment sect/track/cyl
      input  wire         rpDRY,                // Drive ready
      output wire [15: 0] rpDA                  // rpDA Output
   );

   //
   // RPDA Sector Address (RPSA)
   //
   // Trace
   //  M7766/SS3/E13
   //  M7766/SS3/E18
   //

   reg [5:0] rpSA;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpSA <= 0;
        else
          if (rpPRESET)
            rpSA <= 0;
          else if (rpdaWRITE & rpDRY)
            rpSA <= `rpDA_SA(rpDATAI);
          else if (rpINCSECT)
            begin
               if (rpSA == rpSECNUM)
                 rpSA <= 0;
               else
                 rpSA <= rpSA + 1'b1;
            end
     end

   //
   // RPDA Track Address (RPTA)
   //
   // Trace
   //  M7766/SS3/E16
   //  M7766/SS3/E17
   //

   reg [5:0] rpTA;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpTA <= 0;
        else
          if (rpPRESET)
            rpTA <= 0;
          else if (rpdaWRITE & rpDRY)
            rpTA <= `rpDA_TA(rpDATAI);
          else if (rpINCSECT & (rpSA == rpSECNUM))
            begin
               if (rpTA == rpTRKNUM)
                 rpTA <= 0;
               else
                 rpTA <= rpTA + 1'b1;
            end
     end

   //
   // Build the RPDA Register
   //

   assign rpDA = {2'b0, rpTA, 2'b0, rpSA};

endmodule
