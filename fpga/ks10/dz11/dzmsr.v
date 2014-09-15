////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DZ11 Modem Status Register (MSR)
//
// Details
//   The module implements the DZ11 MSR Register.
//
// File
//   dzmsr.v
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

  module DZMSR(clk, rst, dz11CO, dz11RI, regMSR);

   input         clk;                           // Clock
   input         rst;                           // Reset
   input  [ 7:0] dz11CO;                        // DZ11 Carrier Detect
   input  [ 7:0] dz11RI;                        // DZ11 Ring Indicator
   output [15:0] regMSR;                        // MSR Output

   //
   // The MSR Register is just a synchronizer
   //

   reg [15:0] regMSR;
   reg [15:0] tmpMSR;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             tmpMSR <= 16'b0;
             regMSR <= 16'b0;
          end
        else
          begin
             tmpMSR <= {dz11CO, dz11RI};
             regMSR <= tmpMSR;
          end
     end

endmodule
