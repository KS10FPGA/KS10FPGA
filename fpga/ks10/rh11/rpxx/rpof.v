////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RPxx Offset Register (RPOF)
//
// File
//   rpof.v
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

`include "rpof.vh"

module RPOF (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire         clr,                  // Clear
      input  wire         rpCENTER,             // Center command
      input  wire         rpPRESET,             // Preset command
      input  wire [35: 0] rpDATAI,              // RP Data In
      input  wire         rpofWRITE,            // OF Write
      input  wire         rpDRY,                // Drive ready
      output wire [15: 0] rpOF                  // rpOF Output
   );

   //
   // RPOF Format 16 bit (FMT22)
   //  Not implemented.
   //
   // Trace
   //  M7774/RG1/E1
   //

   reg ofFMT22;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          ofFMT22 <= 0;
        else
          if (rpPRESET)
            ofFMT22 <= 0;
          else if (rpofWRITE & rpDRY)
            ofFMT22 <= `rpOF_FMT22(rpDATAI);
     end

   //
   // RPOF Error Correction Inihibit (ECI)
   //  Not implemented.
   //
   // Trace
   //  M7774/RG1/E1
   //

   reg ofECI;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          ofECI <= 0;
        else
          if (rpPRESET)
            ofECI <= 0;
          else if (rpofWRITE & rpDRY)
            ofECI <= `rpOF_ECI(rpDATAI);
     end

   //
   // RPOF Header Correction Inihibit (HCI)
   //  Not implemented.
   //
   // Trace
   //  M7774/RG1/E1
   //

   reg ofHCI;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          ofHCI <= 0;
        else
          if (rpPRESET)
            ofHCI <= 0;
          else if (rpofWRITE & rpDRY)
            ofHCI <= `rpOF_HCI(rpDATAI);
     end

   //
   // RPOF Head Offset Direction (OFD)
   //  Not implemented.
   //
   // Trace
   //  M7774/RG1/E8
   //

   reg ofOFD;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          ofOFD <= 0;
        else
          if (clr | rpCENTER)
            ofOFD <= 0;
          else if (rpofWRITE & rpDRY)
            ofOFD <= `rpOF_OFD(rpDATAI);
     end

   //
   // RPOF Head Offset (OFS)
   //  Not implemented.
   //
   // Trace
   //  M7774/RG1/E7
   //  M7774/RG1/E8
   //

   reg [6:0] ofOFS;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          ofOFS <= 0;
        else
          if (clr | rpCENTER)
            ofOFS <= 0;
          else if (rpofWRITE & rpDRY)
            ofOFS <= `rpOF_OFS(rpDATAI);
     end

   //
   // Build the RPOF Register
   //

   assign rpOF = {3'b0, ofFMT22, ofECI, ofHCI, 2'b0, ofOFD, ofOFS};

endmodule
