////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RH11 Word Count Register (RHWC)
//
// Details
//   The module implements the RH11 Word Count Register (RHWC)
//
// File
//   rhwc.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2014 Rob Doyle
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

`include "rhwc.vh"

  module RHWC(clk, rst, clr,
              devLOBYTE, devHIBYTE, devDATAI, rhwcWRITE, rhINCWC, rhWC);

   input          clk;                          // Clock
   input          rst;                          // Reset
   input          clr;                          // Clear
   input          devLOBYTE;                    // Device Low Byte
   input          devHIBYTE;                    // Device High Byte
   input  [ 0:35] devDATAI;                     // Device Data In
   input          rhwcWRITE;                    // Write to WC
   input          rhINCWC;                      // Increment WC
   output [15: 0] rhWC;                         // WC Output

   //
   // Big-endian to little-endian data bus swap
   //

   wire [35:0] rhDATAI = devDATAI[0:35];

   //
   // RH11 Word Count (RHWC) Register
   //
   // Trace
   //  M7295/BCTD/E41
   //  M7295/BCTD/E42
   //  M7295/BCTD/E43
   //  M7295/BCTD/E44
   //  M7295/BCTD/E45
   //  M7295/BCTD/E46
   //  M7295/BCTD/E49
   //  M7295/BCTD/E50
   //  M7295/BCTD/E51
   //  M7295/BCTD/E52
   //  M7295/BCTD/E53
   //  M7295/BCTD/E54
   //

   reg [15:0] rhWC;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rhWC <= 0;
        else
          begin
             if (clr)
               rhWC <= 0;
             else
               if (rhwcWRITE)
                 begin
                    if (devHIBYTE)
                      rhWC[15:8] <= `rhWC_HI(rhDATAI);
                    if (devLOBYTE)
                      rhWC[ 7:0] <= `rhWC_LO(rhDATAI);
                 end
               else if (rhINCWC)
                 rhWC <= rhWC + 1'b1;
          end
     end

endmodule
