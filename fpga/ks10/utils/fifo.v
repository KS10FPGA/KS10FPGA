////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Parameterized Synchronous Single Clock Dual Port FIFO
//
// Details
//   The FIFO is dual ported.   Writes occur on one port and reads occur on
//   the other port.   Simultaneous read and writes are supported as long as
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

module FIFO #(
      parameter SIZE  = 64,
      parameter WIDTH = 16
   ) (
      input  wire             clk,      // Clock
      input  wire             clr,      // Clear
      input  wire             rst,      // Reset
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

   localparam ADDR_WIDTH = log2(SIZE-1);

   //
   // The buffer is the next larger power-of-two than the FIFO size.  For
   // example: a 100 word FIFO would have a 128 word buffer.  The buffer
   // pointers would wrap from 127 to zero (on a write) or from 0 to 127 on
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
   assign full  = (depth == SIZE-1);

   //
   // Read Address
   //
   // Note: This relies on the rd_addr wrapping back to zero.
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rd_addr <= 0;
        else
          if (clr)
            rd_addr <= 0;
          else if (clken & rd & !empty)
            rd_addr <= rd_addr + 1'b1;
     end

   //
   // Write Address
   //
   // Note: This relies on the wr_addr wrapping back to zero.
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          wr_addr <= 0;
        else
          if (clr)
            wr_addr <= 0;
          else if (clken & wr & !full)
            wr_addr <= wr_addr + 1'b1;
     end

   //
   // Buffer Depth
   //
   // Note: The FIFO Depth is not allowed to wrap.
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          depth <= 0;
        else
          if (clr)
            depth <= 0;
          else if (clken & rd & !wr & !empty)
            depth <= depth - 1'b1;
          else if (clken & wr & !rd & !full)
            depth <= depth + 1'b1;
     end

   //
   // Dual Port RAM circular buffer
   //

`ifndef SYNTHESIS
   integer i;
`endif

   reg [WIDTH-1:0] mem[0:BUFSZ-1];

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
`ifndef SYNTHESIS
             for (i = 0; i < BUFSZ; i = i + 1)
               mem[i] <= 0;
`endif
          end
        else
          begin
             if (clken & wr & !full)
               mem[wr_addr] <= in;
             out <= mem[rd_addr];
          end
     end

initial
  begin
     $display("SIZE is %d", SIZE);
     $display("WIDTH is %d", WIDTH);
     $display("ADDR_WIDTH is %d", ADDR_WIDTH);
     $display("BUFSZ is %d", BUFSZ);
  end

endmodule
