////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RPxx Disk Cylinder Address Register (RPDC)
//
// File
//   rpdc.v
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

`include "rpdc.vh"

 module RPDC (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire [35: 0] rpDATAI,              // Data in
      input  wire         rpPRESET,             // Preset command
      input  wire         rpRECAL,              // Recalibrate command
      input  wire         rpdcWRITE,            // Write RPDC
      input  wire         rpINCCYL,             // Increment cylinder
      input  wire         rpDRY,                // Drive ready
      output wire [15: 0] rpDC                  // rpDC Output
   );

   //
   // RPDC Desired Cylinder Address (DCA)
   //
   // Trace
   //  M7786/SS1/E9
   //  M7786/SS1/E11
   //  M7786/SS1/E12
   //

   reg [9:0] rpDCA;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpDCA <= 0;
        else
          if (rpPRESET | rpRECAL)
            rpDCA <= 0;
          else if (rpdcWRITE & rpDRY)
            rpDCA <= `rpDC_DCA(rpDATAI);
          else if (rpINCCYL)
            rpDCA <= rpDCA + 1'b1;
     end

   //
   // Build the RPDC Register
   //

   assign rpDC = {6'b0, rpDCA};

endmodule
