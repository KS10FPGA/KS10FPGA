////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   UBA Timeout State Machine
//
// Details
//   TMO is asserted on an 'un-acked' KS10 bus requests
//
// File
//   ubatmo.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2021 Rob Doyle
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

module UBATMO (
      input  wire clk,                          // Clock
      input  wire rst,                          // Reset
      input  wire busREQO,                      // Bus Request
      input  wire busACKI,                      // Bus Acknowledge
      output wire setTMO                        // Set TMO
   );

   //
   // TMO Timout
   //

   localparam [ 0: 3] timeout = 12;

   //
   // TMO Bus Monitor
   //

   reg [0:3] count;

   always @(posedge clk)
     begin
        if (rst)
          count <= 0;
        else if (busREQO & !busACKI)
          count <= timeout;
        else if (busACKI)
          count <= 0;
        else if (count != 0)
          count <= count - 1'b1;
     end

   assign setTMO = (count == 1);

endmodule
