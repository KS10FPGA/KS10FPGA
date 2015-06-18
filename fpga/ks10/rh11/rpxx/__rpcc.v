////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RPxx Current Cylinder Address Register (RPCC)
//
// File
//   rpcc.v
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

`include "rpcc.vh"

module RPCC (
       input  wire         clk,                 // Clock
       input  wire         rst,                 // Reset
       input  wire         rpPRESET,            // Preset command
       input  wire         rpRECAL,             // Recalibrate command
       input  wire         rpDMD,		// Diagnostic mode
       input  wire         rpccWRITE,           // Update current cylinder
       input  wire [15: 0] rpDC,                // Desired Cylinder
       output wire [15: 0] rpCC                 // Current Cylinder
   );

   //
   // RPCC Current Cylinder Address (CCA)
   //
   // Trace
   //  M7786/SS1/E2
   //  M7786/SS1/E5
   //  M7786/SS1/E21
   //
   // FIXME
   //  rpCCA should be cleared by recalibrate command
   //

   reg [9:0] rpCCA;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpCCA <= 0;
        else
          if (rpPRESET | rpRECAL)
            rpCCA <= 0;
          else if (rpccWRITE | rpDMD)
            rpCCA <= `rpCC_CCA(rpDC);
     end

   //
   // Build the RPCC Register
   //

   assign rpCC = {6'b0, rpCCA};

endmodule
