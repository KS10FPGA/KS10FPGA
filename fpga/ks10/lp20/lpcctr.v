////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   LP20 Column Count Register (CCTR) implementation
//
// Details
//   This file provides the implementation of the LP20 CCTR Register.
//
// File
//   lpbctr.v
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

`include "lpcctr.vh"

module LPCCTR (
      input  wire         clk,          // Clock
      input  wire         rst,          // Reset
      input  wire         lpINIT,       // Initialize
      input  wire [35: 0] lpDATAI,      // Bus data in
      input  wire         cctrWRITE,    // Write to CCTR
      input  wire         lpCLRCCTR,    // Clear CCTR
      input  wire         lpINCCCTR,    // Increment CCTR
      output reg  [ 7: 0] regCCTR       // CCTR output
   );

   //
   // Column counter register
   //
   // Trace
   //  M8587/LPD5/E47
   //  M8587/LPD5/E48
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          regCCTR <= 0;
        else
          begin
             if (lpINIT | lpCLRCCTR)
               regCCTR <= 0;
             else if (cctrWRITE)
               regCCTR <= `lpCCTR_DAT(lpDATAI);
             else if (lpINCCCTR)
               regCCTR <= regCCTR + 1'b1;
          end
     end

endmodule
