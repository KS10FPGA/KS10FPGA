////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   MT Control Status Register #1 (MTCS1)
//
// File
//   mtcs1.v
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

`timescale 1ns/1ps
`default_nettype none

`include "mtcs1.vh"

module MTCS1 (
      input  wire          clk,                 // Clock
      input  wire          rst,                 // Reset
      input  wire  [35: 0] mtDATAI,             // RH Data In
      input  wire          mtWRCS1,            // Write to CS1
      input  wire          mtDRY,               // Drive ready
      output logic [15: 0] mtCS1                // mtCS1 Output
   );

   //
   // MTCS1 Data Valid (DVA)
   //
   // Trace
   //  M7774/RG6/E16
   //

   wire mtDVA = 1;

   //
   // MTCS1 Function (FUN)
   //
   // Trace
   //  M7774/RG3/E25
   //

   logic [5:1] mtFUN;

   always_ff @(posedge clk)
     begin
        if (rst)
          mtFUN <= 0;
        else if (mtWRCS1 & mtDRY)
          mtFUN <= `mtCS1_FUN(mtDATAI);
     end

   //
   // MTCS1 GO
   //
   // Trace
   //  M7774/RG3/E44
   //

   wire mtGO = !mtDRY;

   //
   // Build CS1 Register
   //

   assign mtCS1 = {4'b0, mtDVA, 5'b0, mtFUN, mtGO};

endmodule
