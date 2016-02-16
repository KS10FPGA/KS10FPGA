////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   LP20 Bus Address Register (BAR)
//
// Details
//   The module implements the LP20 BAR Register.
//
// File
//   lpbar.v
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

`include "lpcsra.vh"
`include "lpbar.vh"

module LPBAR (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire         devLOBYTE,            // Device low byte
      input  wire [35: 0] lpDATAI,              // Bus data in
      input  wire         barWRITE,             // Write to BAR
      input  wire         csraWRITE,            // Write to CSRA
      input  wire         lpINIT,               // Initialize
      input  wire         lpINCBAR,             // Increment BAR
      output reg  [17: 0] regBAR                // BAR Output
   );

   //
   // Bus address register
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          regBAR <= 0;
        else
          begin
             if (lpINIT)
               regBAR <= 0;
             else if (csraWRITE & devLOBYTE)
               regBAR[17:16] <= `lpCSRA_ADDR(lpDATAI);
             else if (barWRITE)
               regBAR[15: 0] <= `lpBAR_ADDR(lpDATAI);
             else if (lpINCBAR)
               regBAR <= regBAR + 1'b1;
          end
     end

endmodule
