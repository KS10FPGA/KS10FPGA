////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   LP20 Checksum Register (CKSM)
//
// Details
//   The module implements the LP20 CKSM Register.
//
// File
//   lpcksm.v
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

`include "lpcksm.vh"

module LPCKSM (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire         lpGOCLR,              // Go clear
      input  wire [ 7: 0] lpDATA,               // Data input
      input  wire         lpINCCKSM,            // Update CKSM
      output reg  [ 7: 0] regCKSM               // CKSM output
   );

   //
   // Checksum register
   //
   // Trace
   //  M8585/LPI0/E62
   //  M8586/LPI0/E67
   //  M8585/LPI0/E72
   //  M8585/LPI0/E57
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          regCKSM <= 0;
        else
          begin
             if (lpGOCLR)
               regCKSM <= 0;
             else if (lpINCCKSM)
               regCKSM <= regCKSM + lpDATA;
          end
     end

endmodule
