////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RH11 Non-existent Memory
//
// File
//   rhnem.v
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

module RHNEM (
      input  wire clk,                          // Clock
      input  wire rst,                          // Reset
      input  wire devREQO,                      // Memory request
      input  wire devACKI,                      // Memory acknowledge
      output wire setNEM                        // Set NEM
   );

   //
   // Non-existent memory monitor
   //
   // Details
   //  Wait for Bus ACK on memory requests.  Timeout on missing ACK.
   //
   // Trace
   //  M7294/DBCA/E83
   //  M7294/DBCA/E85
   //

   localparam [0:5] nxmTimeout = 63;
   reg        [0:5] nxmCount;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          nxmCount <= nxmTimeout;
        else
          if (devREQO & !devACKI)
            begin
               if (nxmCount != 0)
                 nxmCount <= nxmCount - 1'b1;
            end
          else
            nxmCount <= nxmTimeout;
     end

   assign setNEM = (nxmCount == 1);

endmodule
