////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RPxx Error Status #3 (RPER3) Register
//
// Details
//   The RPER3 register is read/write as required by the diagnostics but is
//   otherwise not implemented.  Nothing inside the RPXX controller modifies
//   this register.
//
// File
//   rper3.v
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

`include "rper3.vh"

module RPER3 (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire         devRESET,             // Device Reset
      input  wire         rpDRVCLR,             // Drive clear command
      input  wire         rpSETSKI,             // Set seek incomplete
      input  wire [35: 0] rpDATAI,              // Data in
      input  wire         rpWRER3,              // Write ER3
      input  wire         rpDRY,                // Drive ready
      output wire [15: 0] rpER3                 // ER3 Output
   );

   //
   // RPER3 Off Cylinder Error (rpOCE)
   //
   // Trace
   //  M7776/EC7/E43
   //  M7776/EC7/E97
   //

   reg rpOCE;

   always @(posedge clk)
     begin
        if (rst | devRESET | rpDRVCLR)
          rpOCE <= 0;
        else if (rpWRER3 & rpDRY)
          rpOCE <= `rpER3_OCE(rpDATAI);
     end

   //
   // RPER3 Seek Incomplete (rpSKI)
   //
   // Trace
   //  M7776/EC7/E43
   //  M7776/EC7/E85
   //  M7776/EC7/E92
   //

   reg rpSKI;

   always @(posedge clk)
     begin
        if (rst | devRESET | rpDRVCLR)
          rpSKI <= 0;
        else if (rpSETSKI)
          rpSKI <= 1;
        else if (rpWRER3 & rpDRY)
          rpSKI <= `rpER3_SKI(rpDATAI);
     end

   //
   // RPER3 Unused bits 13-7
   //
   // Trace
   //  M7776/EC7/E38
   //  M7776/EC7/E44
   //  M7776/EC7/E50
   //  M7776/EC7/E55
   //

   reg [13:7] rpUN1;

   always @(posedge clk)
     begin
        if (rst | devRESET | rpDRVCLR)
          rpUN1 <= 0;
        else if (rpWRER3 & rpDRY)
          rpUN1 <= `rpER3_UN1(rpDATAI);
     end

   //
   // RPER3 AC Low (rpACL)
   //
   // Trace
   //  M7776/EC7/E55
   //

   reg rpACL;

   always @(posedge clk)
     begin
        if (rst | devRESET | rpDRVCLR)
          rpACL <= 0;
        else if (rpWRER3 & rpDRY)
          rpACL <= `rpER3_ACL(rpDATAI);
     end

   //
   // RPER3 DC Low (rpDCL)
   //
   // Trace
   //  M7776/EC7/E64
   //

   reg rpDCL;

   always @(posedge clk)
     begin
        if (rst | devRESET | rpDRVCLR)
          rpDCL <= 0;
        else if (rpWRER3 & rpDRY)
          rpDCL <= `rpER3_DCL(rpDATAI);
     end

   //
   // RPER3 35 Volt Regulator Failure (rpF35)
   //
   // Trace
   //  M7776/EC7/E64
   //

   reg rpF35;

   always @(posedge clk)
     begin
        if (rst | devRESET | rpDRVCLR)
          rpF35 <= 0;
        else if (rpWRER3 & rpDRY)
          rpF35 <= `rpER3_F35(rpDATAI);
     end

   //
   // RPER3 Unused bits 3 and 2
   //
   // Trace
   //  M7776/EC7/E69
   //

   reg [3:2] rpUN2;

   always @(posedge clk)
     begin
        if (rst | devRESET | rpDRVCLR)
          rpUN2 <= 0;
        else if (rpWRER3 & rpDRY)
          rpUN2 <= `rpER3_UN2(rpDATAI);
     end

   //
   // RPER3 Velocity Unsafe (rpVLU)
   //
   // Trace
   //  M7776/EC7/E63
   //

   reg rpVLU;

   always @(posedge clk)
     begin
        if (rst | devRESET | rpDRVCLR)
          rpVLU <= 0;
        else if (rpWRER3 & rpDRY)
          rpVLU <= `rpER3_VLU(rpDATAI);
     end

   //
   // RPER3 DC Unsafe (rpDCU)
   //
   // Trace
   //  M7776/EC7/E63
   //

   reg rpDCU;

   always @(posedge clk)
     begin
        if (rst | devRESET | rpDRVCLR)
          rpDCU <= 0;
        else if (rpWRER3 & rpDRY)
          rpDCU <= `rpER3_DCU(rpDATAI);
     end

   //
   // Build the RPER3 Register
   //

   assign rpER3 = {rpOCE, rpSKI, rpUN1, rpACL, rpDCL, rpF35, rpUN2, rpVLU, rpDCU};

endmodule
