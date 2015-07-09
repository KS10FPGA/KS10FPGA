////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RPxx Maintenace (RPMR) Register
//
// File
//   rpmr.v
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

`include "rpmr.vh"

module RPMR (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire         clr,                  // Clear
      input  wire         rpDRVCLR,             // Drive clear
      input  wire [35: 0] rpDATAI,              // Data In
      input  wire         rpmrWRITE,            // Write
      input  wire         rpDRY,                // Drive ready
      input  wire         rpDFE,                // Data field envelope
      input  wire         rpECE,                // ECC field envelope
      output wire [15: 0] rpMR                  // MR Output
   );

   //
   // RPMR Diagnostic Data (rpDDAT)
   //
   // Trace
   //   M7774/RG6/E20
   //

   reg rpDDAT;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpDDAT <= 0;
        else
          if (!rpDMD)
            rpDDAT <= 0;
          else if (rpmrWRITE)
            rpDDAT <= `rpMR_DDAT(rpDATAI);
     end

   //
   // RPMR Diagnostic Sector Clock (rpDSCK)
   //
   // Trace
   //   M7774/RG6/E20
   //

   reg rpDSCK;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpDSCK <= 0;
        else
          if (!rpDMD)
            rpDSCK <= 0;
          else if (rpmrWRITE)
            rpDSCK <= `rpMR_DSCK(rpDATAI);
     end

   //
   // RPMR Diagnostic Index Pulse (rpDIND)
   //
   // Trace
   //   M7774/RG6/E20
   //

   reg rpDIND;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpDIND <= 0;
        else
          if (!rpDMD)
            rpDIND <= 0;
          else if (rpmrWRITE)
            rpDIND <= `rpMR_DIND(rpDATAI);
     end

   //
   // RPMR Diagnostic Clock (rpDCLK)
   //
   // Trace
   //   M7774/RG6/E20
   //

   reg rpDCLK;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpDCLK <= 0;
        else
          if (!rpDMD)
            rpDCLK <= 0;
          else if (rpmrWRITE)
            rpDCLK <= `rpMR_DCLK(rpDATAI);
     end

   //
   // RPMR Diagnostics Mode (rpDMD)
   //
   // Trace
   //   M7774/RG6/E40
   //   M7774/RG6/E48
   //

   reg rpDMD;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpDMD <= 0;
        else
          if (clr | rpDRVCLR)
            rpDMD <= 0;
          else if (rpmrWRITE & rpDRY)
            rpDMD <= `rpMR_DMD(rpDATAI);
     end

   //
   // Build RPMR
   //
   // Trace
   //   M7774/RG2/E11
   //   M7774/RG2/E12
   //   M7774/RG2/E13
   //   M7774/RG2/E19
   //

   assign rpMR = {8'b0, rpDFE, rpECE, 1'b0, rpDDAT, rpDSCK, rpDIND, rpDCLK, rpDMD};

endmodule
