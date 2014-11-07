////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RH11 Bus Address Register (RHBA)
//
// Details
//   The module implements the RH11 Bus Address Register.
//
// File
//   rhba.v
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

`include "rhba.vh"

  module RHBA(clk, rst, clr,
              devLOBYTE, devHIBYTE, devDATAI, rhcs1WRITE,
              rhbaWRITE, rhRDY, rhINCBA, rhBA);

   input          clk;                          // Clock
   input          rst;                          // Reset
   input          clr;                          // Clear
   input          devLOBYTE;                    // Device Low Byte
   input          devHIBYTE;                    // Device High Byte
   input  [ 0:35] devDATAI;                     // Device Data In
   input          rhcs1WRITE;                   // Write to RHCS1
   input          rhbaWRITE;                    // Write to BA
   input          rhRDY;                        // Ready
   input          rhINCBA;                      // Increment BA
   output [17: 0] rhBA;                         // rhBA Output

   //
   // Big-endian to little-endian data bus swap
   //

   wire [35:0] rhDATAI = devDATAI[0:35];

   //
   // RH11 Bus Address (RHBA) Register
   //
   // Trace
   //  M7295/BCTC/E14
   //  M7295/BCTC/E22
   //  M7295/BCTC/E30
   //  M7295/BCTC/E36
   //  M7295/BCTC/E37
   //

   reg [17:0] rhBA;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rhBA[17:0] <= 0;
        else
          begin
             if (clr)
               rhBA[17:0] <= 0;
             else
               begin
                  if (rhcs1WRITE & devHIBYTE & rhRDY)
                    rhBA[17:16] <= `rhCS1_BAE(rhDATAI);
                  if (rhbaWRITE)
                    begin
                       if (devHIBYTE)
                         rhBA[15:8] <= `rhBA_HI(rhDATAI);
                       if (devLOBYTE)
                         rhBA[ 7:0] <= `rhBA_LO(rhDATAI);
                    end
                  else if (rhINCBA)
                    rhBA <= rhBA + 2'd2;
               end
          end
     end

endmodule
