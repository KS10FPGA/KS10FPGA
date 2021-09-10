////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   MT Frame Count Register (MTFC)
//
// File
//   mtfc.v
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

`include "mtfc.vh"

 module MTFC (
      input  wire          clk,                 // Clock
      input  wire          rst,                 // Reset
      input  wire  [35: 0] mtDATAI,             // Data in
      input  wire          mtWRFC,              // Write MTFC
      input  wire          mtINCFC,             // Increment Frame Count
      output logic [15: 0] mtFC                 // mtFC Output
   );

   //
   // MT Frame Count
   //
   // Trace:
   //  M8909/MBI8/E84
   //  M8909/MBI8/E74
   //  M8909/MBI8/E69
   //  M8909/MBI8/E59
   //

   always_ff @(posedge clk)
     begin
        if (rst)
          mtFC <= 0;
        else if (mtWRFC)
          mtFC <= `mtfc_FC(mtDATAI);
        else if (mtINCFC)
          mtFC <= mtFC + 1'b1;
     end

endmodule
