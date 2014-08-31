////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DZ-11 SILO/FIFO
//
// Details
//   This is an implementation of the DZ-11 SILO
//
// File
//   dzfifo.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2012-2014 Rob Doyle
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
`define SIZE 64

module DZFIFO(clk, rst, clr, din, wr, dout, rd, empty);

   input         clk;           // Clock
   input         rst;           // Reset
   input         clr;           // Clear
   input  [14:0] din;           // Data input
   input         wr;            // Push data into FIFO
   output [14:0] dout;          // Data output
   input         rd;            // Pop data from FIFO
   output        empty;         // FIFO Empty

   //
   // FIFO State
   //
   // Note: FIFOs have to count to 64 not 63.  Watch the counter sizes.
   //

   reg [0:6] depth;
   reg [0:6] rd_ptr;
   reg [0:6] wr_ptr;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             depth  <= 0;
             rd_ptr <= 0;
             wr_ptr <= 0;
          end
        else if (rd & ~wr & !empty)
          begin
             depth <= depth - 1'b1;
             if (rd_ptr == `SIZE)
               rd_ptr <= 0;
             else
               rd_ptr <= rd_ptr + 1'b1;
          end
        else if (wr & !rd & !full)
          begin
             depth <= depth + 1'b1;
             if (wr_ptr == `SIZE)
               wr_ptr <= 0;
             else
               wr_ptr <= wr_ptr + 1'b1;
          end
     end

   wire empty = (depth ==     0);
   wire full  = (depth == `SIZE);

   //
   // Dual Port RAM
   //
   // Details
   //  When the FIFO is full, the last character in the FIFO is replaced with
   //  the current character and the Overrun Error bit (RBUF[OVRE]) is asserted.
   //

`ifndef SYNTHESIS
   integer i;
`endif

   reg [14:0] dout;
   reg [14:0] DPRAM[0:`SIZE];

   always @(posedge clk or posedge rst)
     begin
        if (rst)
`ifdef SYNTHESIS
          ;
`else
          for (i = 0; i <= `SIZE; i = i + 1)
            DPRAM[i] <= 0;
`endif
        else
          begin
             if (wr)
               DPRAM[wr_ptr] <= {full, din[13:0]};
             dout <= DPRAM[rd_ptr];
          end
     end

endmodule
