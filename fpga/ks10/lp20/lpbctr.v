////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   LP20 Byte Count Register (BCTR) implementation.
//
// Details
//   The module implements the LP20 BCTR Register.
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

`include "lpbctr.vh"

module LPBCTR (
      input  wire         clk,          // Clock
      input  wire         rst,          // Reset
      input  wire         lpINIT,       // Initialize
      input  wire [35: 0] lpDATAI,      // Bus data in
      input  wire         bctrWRITE,    // Write to BCTR
      input  wire         lpINCBCTR,    // Increment BCTR
      output wire         lpSETDONE,    // BCTR done
      output wire [15: 0] regBCTR       // BCTR output
   );

   //
   // Byte count register
   //
   // Trace
   //  M8585/LPR2/E5
   //  M8585/LPR2/E8
   //  M8585/LPR2/E11
   //

   reg [11:0] count;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          count <= 0;
        else
          begin
             if (lpINIT)
               count <= 0;
             else if (bctrWRITE)
               count <= `lpBCTR_DAT(lpDATAI);
             else if (lpINCBCTR)
               count <= count + 1'b1;
          end
     end

   //
   // Byte Counter Zero (DONE)
   //
   // Trace
   //  M8585/LPR2/E5
   //  M8586/LPC9/E35
   //  M8586/LPC9/E40
   //  M8586/LPC9/E65
   //

   assign lpSETDONE = (count == 12'o7777) & lpINCBCTR;

   //
   // Build BCTR Register
   //

   assign regBCTR = {4'b0, count};

endmodule
