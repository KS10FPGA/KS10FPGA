////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RPxx Error Status #2 (RPER2) Register
//
// Details
//   The RPER2 register is read/write as required by the diagnostics but is
//   otherwise not implemented.  Nothing inside the RPXX controller modifies
//   this register.
//
// File
//   rper2.v
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

module RPER2 (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire         clr,                  // Clear
      input  wire         rpDRVCLR,             // Drive clear
      input  wire [35: 0] rpDATAI,              // Data in
      input  wire         rper2WRITE,           // Write
      input  wire         rpDRY,                // Drive ready
      output reg  [15: 0] rpER2                 // ER2 Output
   );

   //
   // RPER2 Register
   //  This register is read/write as required by the diagnostics but is
   //  otherwise not implemented.  Nothing inside the RPXX controller modifies
   //  this register.
   //
   // Trace
   //  M7776/EC6/E48
   //  M7776/EC6/E53
   //  M7776/EC6/E54
   //  M7776/EC6/E58
   //  M7776/EC6/E70
   //  M7776/EC6/E74
   //  M7776/EC6/E75
   //  M7776/EC6/E79
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpER2 <= 0;
        else
          if (clr | rpDRVCLR)
            rpER2 <= 0;
          else if (rper2WRITE & rpDRY)
            rpER2 <= rpDATAI[15:0];
     end

endmodule
