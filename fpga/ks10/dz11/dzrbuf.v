////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DZ-11 SILO/FIFO
//
// Details
//
// File
//   dzfifo.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2012-2013 Rob Doyle
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

module DZFIFO(clk, rst, din, wr, dout, rd, empty);

   input         clk;           // Clock
   input         rst;           // Reset
   input  [10:0] din;           // Data input
   input         wr;            // Push data into FIFO
   output [15:0] dout;          // Data output
   input         rd;            // Pop data from FIFO
   output        empty;         // FIFO Empty

   //
   // FIFO State
   //

   reg [0:6] depth;
   reg [0:6] rd_ptr;
   reg [0:6] wr_ptr;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             rd_ptr <= 0;
             wr_ptr <= 0;
             depth  <= 0;
          end
        else if (rd & ~wr & (depth !=  0))
          begin
             if (rd_ptr == 64)
               rd_ptr <= 0;
             else
               rd_ptr <= rd_ptr + 1'b1;
             depth  <= depth  - 1'b1;
          end
        else if (wr & ~rd & (depth != 64))
          begin
             if (wr_ptr == 64)
               wr_ptr <= 0;
             else
               wr_ptr <= wr_ptr + 1'b1;
             depth  <= depth  + 1'b1;
          end
     end

   //
   // Full/Empty Flag
   //

   reg full;
   reg empty;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             full  <= 0;
             empty <= 1;
          end
        else if (depth == 0)
          begin
             if (wr & ~rd)
               empty <= 0;
             else if (rd & ~wr)
               empty <= 1;
          end
        else if (depth == 64)
          begin
             if (wr & ~rd)
               full <= 1;
             else if (rd & ~wr)
               full <= 0;
          end
     end

   //
   // Overrun
   //

   reg overrun;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          overrun <= 0;
        else if (rd & empty)
          overrun <= 0;
        else if (wr & full)
          overrun <= 1;
     end

   //
   // Dual Port RAM
   //

`ifndef SYNTHESIS
   integer i;
`endif

   reg [10:0] DPRAM[0:64];
   reg [10:0] fifoDATA;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
`ifdef SYNTHESIS
          ;
`else
          for (i = 0; i < 65; i = i + 1)
            DPRAM[i] <= 0;
`endif
        else
          begin
             if (wr)
               DPRAM[wr_ptr] <= din;
             fifoDATA <= DPRAM[rd_ptr];
          end
     end

   //
   // FIFO Output
   //

   wire fifoOVR = (depth == 0) ? overrun : 0;
   assign dout = {~empty, fifoOVR, 3'b0, fifoDATA};

endmodule
