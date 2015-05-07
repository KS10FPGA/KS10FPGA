////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RPxx Error Status #3 (RPER3) Register
//
// Details
//   The RPER3 register is read/write as required by the diagnostics but is
//   otherwise not implemented.  Nothing inside the RPXX controller modifies
//   this register.
//
// File
//   rper3.v
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

module RPER3(clk, rst, clr, rpDRVCLR, rpDATAI, rper3WRITE, rpDRY, rpER3);

   input          clk;                          // Clock
   input          rst;                          // Reset
   input          clr;                          // Clear
   input          rpDRVCLR;                     // Drive clear command
   input  [35: 0] rpDATAI;                      // Data in
   input          rper3WRITE;                   // Write
   input          rpDRY;                        // Drive ready
   output [15: 0] rpER3;                        // ER3 Output

   //
   // RPER3 Register
   //  This register is read/write as required by the diagnostics but is
   //  otherwise not implemented.  Nothing inside the RPXX controller modifies
   //  this register.
   //
   // Trace
   //  M7776/EC7/E38
   //  M7776/EC7/E43
   //  M7776/EC7/E44
   //  M7776/EC7/E50
   //  M7776/EC7/E55
   //  M7776/EC7/E63
   //  M7776/EC7/E64
   //  M7776/EC7/E69
   //

   reg [15:0] rpER3;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpER3 <= 0;
        else
          if (clr | rpDRVCLR)
            rpER3 <= 0;
          else if (rper3WRITE & rpDRY)
            rpER3 <= rpDATAI;
     end

endmodule
