////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Parameterized Synchronous Single Clock Dual Port FIFO
//
// Details
//   The FIFO is dual ported. Writes occur on one port and reads occur on
//   the other port. Simultaneous read and writes are supported as long as
//   the FIFO is not empty or full.
//
// File
//   fifo.v
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

module FIFO #(
      parameter SIZE  = 64,
      parameter WIDTH = 16
   ) (
      input  wire             clk,      // Clock
      input  wire             rst,      // Reset
      input  wire             clr,      // Clear
      input  wire             clken,    // Clock Enable
      input  wire             rd,       // Read
      input  wire             wr,       // Write
      input  wire [WIDTH-1:0] in,       // Input
      output reg  [WIDTH-1:0] out,      // Output
      output wire             full,     // Full
      output wire             empty     // Empty
   );

   //
   // log2() function
   //

   function integer log2;
      input [31:0] val;
      begin
         val = val - 1;
         for(log2 = 0; val > 0; log2 = log2 + 1)
           val = val >> 1;
      end
   endfunction

   //
   // Calculate RAM address bus size
   //

   localparam ADDR_WIDTH = log2(SIZE);

   //
   // The buffer is the next larger power-of-two than the FIFO size.  For
   // example: a 100 word FIFO would have a 128 word buffer. The buffer
   // pointers would wrap from 99 to zero on a write or from zero to 99 on
   // a read.
   //

   localparam BUFSZ = 2**ADDR_WIDTH;

   //
   // Registers
   //

   reg [ADDR_WIDTH-1:0] rd_addr;
   reg [ADDR_WIDTH-1:0] wr_addr;
   reg [ADDR_WIDTH  :0] depth;

   //
   // FIFO Status
   //

   assign empty = (depth == 0);
   assign full  = (depth == SIZE - 1);

   //
   // Read Address
   //

   always @(posedge clk)
     begin
        if (rst | clr)
          rd_addr <= 0;
        else if (clken & rd & !wr & !empty)
          if (rd_addr == SIZE - 1)
            rd_addr <= 0;
          else
            rd_addr <= rd_addr + 1'b1;
     end

   //
   // Write Address
   //

   always @(posedge clk)
     begin
        if (rst | clr)
          wr_addr <= 0;
        else if (clken & wr & !rd & !full)
          if (wr_addr == SIZE - 1)
            wr_addr <= 0;
          else
            wr_addr <= wr_addr + 1'b1;
     end

   //
   // Buffer Depth
   //
   // Note: The FIFO Depth is not allowed to wrap.
   //

   always @(posedge clk)
     begin
        if (rst | clr)
          depth <= 0;
        else if (clken & rd & !wr & !empty)
          depth <= depth - 1'b1;
        else if (clken & wr & !rd & !full)
          depth <= depth + 1'b1;
     end

   //
   // Dual Port RAM
   //
   // Details
   //  When the FIFO is full, the last element in the FIFO is replaced with the
   //  current element.
   //

`ifndef SYNTHESIS
   integer i;
`endif

   reg [WIDTH-1:0] mem[BUFSZ-1:0];

   always @(posedge clk)
     begin
        if (rst)
`ifdef SYNTHESIS
          ;
`else
          for (i = 0; i < BUFSZ; i = i + 1)
            mem[i] <= 0;
`endif
        else
          begin
             if (clken & wr)
               mem[wr_addr] <= in;
             out <= mem[rd_addr];
          end
     end

endmodule
