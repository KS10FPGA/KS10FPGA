////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   LP20 Character Buffer Register (CBUF) implementation.
//
// Details
//   The module implements the LP20 CBUF Register.
//
// File
//   lpcbuf.v
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

`include "lpcbuf.vh"

module LPCBUF (
      input  wire         clk,          // Clock
      input  wire         rst,          // Reset
      input  wire         devREQO,      // Device request out
      input  wire         devACKI,      // Device acknowledge in
      input  wire         cbufWRITE,    // Write to CBUF
      input  wire         lpINIT,       // Initialize
      input  wire [35: 0] lpDATAI,      // Bus data in
      input  wire         lpMODELDRAM,  // Load translation RAM
      input  wire [17: 0] regBAR,       // Bus Address
      output reg  [ 7: 0] regCBUF       // CBUF register
   );

   //
   // Byte selection logic
   //  This unpacks bytes from the 36-bit data word.
   //
   // Trace
   //  M8587/LPD2/E7
   //  M8587/LPD2/E15
   //

   reg [7:0] byteDATAI;
   always @*
     begin
        case (regBAR[1:0])
          2'b00: // Even word, low byte
            byteDATAI <= lpDATAI[25:18];
          2'b01: // Even word, high byte
            byteDATAI <= lpDATAI[33:26];
          2'b10: // Odd word, low byte
            byteDATAI <= lpDATAI[ 7: 0];
          2'b11: // Odd word, high byte
            byteDATAI <= lpDATAI[15: 8];
        endcase
     end

   //
   // Character Buffer Register
   //
   // This register is written by Normal IO and by DMA.
   // It is NOT altered when loading translation RAM.
   //
   // Trace
   //  M8587/LPD2/E7
   //  M8587/LPD2/E15
   //

   always @(posedge clk)
     begin
        if (rst | lpINIT)
          regCBUF <= 0;
        else if (cbufWRITE)
          regCBUF <= `lpCBUF_DAT(lpDATAI);
        else if (!lpMODELDRAM & devREQO & devACKI)
          regCBUF <= byteDATAI;
     end

endmodule
