////////////////////////////////////////////////////////////////////
//
// KS10 Processor
//
// Brief
//   Utilities
//
// Details
//
// Notes
//
// File
//   sync.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2015 Rob Doyle
//
// This source file may be used and distributed without
// restriction provided that this copyright statement is not
// removed from the file and that any derivative work contains
// the original copyright notice and the associated disclaimer.
//
// This source file is free software; you can redistribute it
// and/or modify it under the terms of the GNU Lesser General
// Public License as published by the Free Software Foundation;
// version 2.1 of the License.
//
// This source is distributed in the hope that it will be
// useful, but WITHOUT ANY WARRANTY; without even the implied
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
// PURPOSE. See the GNU Lesser General Public License for more
// details.
//
// You should have received a copy of the GNU Lesser General
// Public License along with this source; if not, download it
// from http://www.gnu.org/licenses/lgpl.txt
//
////////////////////////////////////////////////////////////////////

`default_nettype none
`timescale 1ns/1ps

module SYNC(clk, rst, o, i);

   parameter INIT  = 0;
   parameter WIDTH = 1;

   input              clk;          // Clock
   input              rst;          // Reset
   output [WIDTH-1:0] o;            // Output
   input  [WIDTH-1:0] i;            // Input

   reg    [WIDTH-1:0] o;
   reg    [WIDTH-1:0] d;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             d <= INIT;
             o <= INIT;
          end
        else
          begin
             d <= i;
             o <= d;
          end
     end

endmodule
