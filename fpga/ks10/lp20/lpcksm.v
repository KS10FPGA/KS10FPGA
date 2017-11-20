////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   LP20 Checksum Register (CKSM) implementation.
//
// Details
//   This file provides the implementation of the LP20 CKSM Register.
//
// File
//   lpcksm.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2017 Rob Doyle
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

module LPCKSM (
      input  wire        clk,           // Clock
      input  wire        rst,           // Reset
      input  wire        devREQO,       // Device request in
      input  wire        devACKI,       // Device acknowledge out
      input  wire [35:0] lpDATAI,       // Bus data in
      input  wire        lpCMDGO,       // Start DMA
      input  wire [17:0] regBAR,        // Base address
      output reg  [ 7:0] regCKSM        // CKSM output
   );

   //
   // Checksum register
   //
   // Trace
   //  M8585/LPC10/E62
   //  M8586/LPC10/E67
   //  M8585/LPC10/E72
   //  M8585/LPC10/E57
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          regCKSM <= 0;
        else
          begin
             if (lpCMDGO)
               regCKSM <= 0;
             else if (devREQO & devACKI)
               case (regBAR[1:0])
                 2'b00: // Even word, low byte
                   regCKSM <= regCKSM + lpDATAI[25:18];
                 2'b01: // Even word, high byte
                   regCKSM <= regCKSM + lpDATAI[33:26];
                 2'b10: // Odd word, low byte
                   regCKSM <= regCKSM + lpDATAI[ 7: 0];
                 2'b11: // Odd word, high byte
                   regCKSM <= regCKSM + lpDATAI[15: 8];
               endcase
          end
     end

endmodule
