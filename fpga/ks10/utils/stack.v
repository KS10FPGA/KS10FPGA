////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Paarameterized Synchronous Clock Dual Port Stack (or LIFO)
//
// Details
//   The LIFO is dual ported.   Writes occur on one port and reads occur on
//   the other port.   Simultaneous read and writes are supported as long as
//   the LIFO is not empty or full.
//
// File
//   stack.v
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

module STACK #(
      parameter SIZE  = 64,
      parameter WIDTH = 16
   ) (
      input  wire             clk,      // Clock
      input  wire             rst,      // Reset
      input  wire             clken,    // Clock Enable
      input  wire             clr,      // Clear
      input  wire             push,     // Push onto stack
      input  wire             pop,      // Pop from stack
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
   // example: a 100 word FIFO would have a 128 word buffer.  The buffer
   // pointers would wrap from 127 to zero (on a write) or from 0 to 127 on
   // a read.
   //

   localparam BUFSZ = 2**ADDR_WIDTH;

   //
   // Registers
   //

   reg  [ADDR_WIDTH-1:0] rd_addr;
   wire [ADDR_WIDTH-1:0] wr_addr = rd_addr + 1'b1;

   //
   // Stack Status
   //

   assign empty = (wr_addr == 0);
   assign full  = (wr_addr == BUFSZ - 1);

   //
   // Read Address
   //
   // Details
   //  The stack pointer is incremented on a 'push' and decremented on a 'pop'
   //  operation - otherwise the stack pointer does not change.
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rd_addr <= BUFSZ-1;
        else if (clken)
          begin
             if (push)
               rd_addr <= rd_addr + 1'b1;
             else if (pop)
               rd_addr <= rd_addr - 1'b1;
          end
     end

   //
   // Dual Ported Stack
   //
   // Details
   //

   reg [WIDTH-1:0] mem[BUFSZ-1:0];

   always @(posedge clk)
     begin
        if (clken & push)
          mem[wr_addr] <= in;
     end

   //
   // The stack read is synchronous from rd_addr
   //

   assign out = mem[rd_addr];

endmodule
