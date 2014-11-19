////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RPxx Control Status Register #1 (RPCS1)
//
// File
//   rpcs1.v
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

`include "rpcs1.vh"

  module RPCS1(clk, rst, clrFUN, clrGO,
               devLOBYTE, devHIBYTE, devDATAI, rpcs1WRITE, rpCS1);

   input          clk;                          // Clock
   input          rst;                          // Reset
   input          clrFUN;                       // Clear function
   input          clrGO;                        // Clear Go bit
   input          devLOBYTE;                    // Device Low Byte
   input          devHIBYTE;                    // Device High Byte
   input  [ 0:35] devDATAI;                     // Device Data In
   input          rpcs1WRITE;                   // Write to CS1
   output [15: 0] rpCS1;                        // rpCS1 Output

   //
   // Big-endian to little-endian data bus swap
   //

   wire [35:0] rhDATAI = devDATAI[0:35];

   //
   // RPCS1 Data Valid (DVA)
   //
   // Trace
   //
   
   wire rpDVA = 1;
   
   //
   // RPCS1 Function (FUN)
   //
   // Trace
   //

   reg [5:1] rpFUN;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpFUN <= 0;
        else
          if (clrFUN)
            rpFUN <= 0;
          else if (rpcs1WRITE & devLOBYTE)
            rpFUN <= `rpCS1_FUN(rhDATAI);
     end
   
   //
   // RPCS1 GO
   //
   // Trace
   //
  
   reg rpGO;
   
    always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpGO <= 0;
        else
          if (clrGO)
            rpGO <= 0;
          else if (rpcs1WRITE & devLOBYTE)
            rpGO <= `rpCS1_GO(rhDATAI);
     end

   //
   // Build CS1 Register
   //
   
   wire [15:0] rpCS1 = {4'b0, rpDVA, 5'b0, rpFUN, rpGO};

endmodule
