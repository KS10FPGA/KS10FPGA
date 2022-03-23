////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Parameterized Synchronous Single Clock, Dual Port LIFO (stack)
//
// Details
//   The stack is dual ported. Writes occur on one port and reads occur on
//   the other port. Simultaneous read and writes are supported as long as
//   the stack is not empty or full.
//
// File
//   lifo.sv
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2022 Rob Doyle
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

module LIFO #(
      parameter SIZE  = 64,
      parameter WIDTH = 16
   ) (
      input  wire              clk,     // Clock
      input  wire              rst,     // Reset
      input  wire              clken,   // Clock Enable
      input  wire              clr,     // Clear
      input  wire              push,    // Push onto stack
      input  wire              pop,     // Pop from stack
      input  wire  [WIDTH-1:0] in,      // Input
      output logic [WIDTH-1:0] out,     // Output
      output logic             full,    // Full
      output logic             empty    // Empty
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
   // Useful typedefs
   //

   typedef logic [ADDR_WIDTH-1:0] ADDR_T;
   typedef logic [ADDR_WIDTH  :0] DEPTH_T;

   //
   // The buffer is the next larger power-of-two than the FIFO size.
   //

   localparam BUFSIZE = 2**ADDR_WIDTH;

   //
   // Registers
   //
   // Details
   //  The stack pointer is incremented on a 'push' and decremented on a 'pop'
   //  operation - otherwise the stack pointer does not change.
   //
   //  When the stack is full and writes occur, the earliest entries in the
   //  stack are overwritten by the newer entries.
   //

   logic [ADDR_WIDTH-1:0] rd_addr;
   logic [ADDR_WIDTH-1:0] wr_addr;
   logic [ADDR_WIDTH  :0] depth;

   //
   // Read address
   //

   always_ff @(posedge clk)
     begin
        if (rst | clr)
          rd_addr <= BUFSIZE - 1;
        else if (clken)
          begin
             if (push & !pop)
               rd_addr <= rd_addr + 1'b1;
             if (pop & !push)
               rd_addr <= rd_addr - 1'b1;
          end
     end

   //
   // Write address
   //

   always_ff @(posedge clk)
     begin
        if (rst | clr)
          wr_addr <= 0;
        else if (clken)
          begin
             if (push & !pop)
               wr_addr <= wr_addr + 1'b1;
             if (pop & !push)
               wr_addr <= wr_addr - 1'b1;
          end
     end

   //
   // Depth is protected so it cannot overflow or underflow.
   //

   always_ff @(posedge clk)
     begin
        if (rst | clr)
          depth <= 0;
        else if (clken)
          begin
             if (push & !pop & !full)
               depth <= depth + 1'b1;
             if (pop & !push & !empty)
               depth <= depth - 1'b1;
          end
     end

   //
   // Dual Ported Stack
   //

   logic [WIDTH-1:0] stack[BUFSIZE-1:0];

   always_ff @(posedge clk)
     begin
        if (clken & push)
          stack[wr_addr] <= in;
     end

   //
   // The stack read is synchronous from rd_addr
   //

   assign out = stack[rd_addr];

   //
   // Stack Status
   //

   assign empty = (depth == 0);
   assign full  = (depth == BUFSIZE - 1);

endmodule
