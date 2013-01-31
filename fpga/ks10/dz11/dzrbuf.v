////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DZ-11 SILO FIFO
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

module DZFIFO(clk, rst, clken, din, wr, dout, rd, alarm, empty);

   input         clk;           // Clock
   input         rst;           // Reset
   input         clken;         // Clock enable
   input  [0:10] din;           // Data Input
   input         wr;            // Push Data into FIFO
   output [0:10] dout;          // Data Output
   input         rd;            // Pop Data from FIFO
   output        alarm;         // FIFO full enough
   output        empty;         // FIFO empty

   //
   // Read edge trigger
   //
   // Details:
   //  The read pointer is incremented on the trailing edge
   //  of the read pulse; i.e., after the read is done.
   //

   reg last_rd;

   always @(posedge clk or posedge rst)
   begin
      if (rst)
        last_rd <= 0;
      else
        last_rd <= rd;
   end

   wire edge_rd = ~rd & last_rd;

   //
   // Write Pointer
   //

   reg [0:5] wr_curr;

   always @(posedge clk or posedge rst)
   begin
     if (rst)
       wr_curr <= 0;
     else if (clken & wr & (depth != 63))
       wr_curr <= wr_curr + 1'b1;
   end

   //
   // Read Pointer
   //

   reg [0:5] rd_curr;

   always @(posedge clk or posedge rst)
   begin
     if (rst)
       rd_curr <= 0;
     else if (clken & edge_rd & (depth !=  0))
       rd_curr <= rd_curr + 1'b1;
   end

   //
   // FIFO Depth
   //

   reg [0:5] depth;

   always @(posedge clk or posedge rst)
   begin
     if (rst)
       depth <= 0;
     else if (clken & edge_rd & ~wr & (depth !=  0))
       depth <= depth - 1'b1;
     else if (clken & wr & ~edge_rd & (depth != 63))
       depth <= depth + 1'b1;
   end

   //
   // Dual Port RAM
   //

`ifndef SYNTHESIS
   integer i;
`endif

   reg [0:10] DPRAM[0:63];
   reg [0:10] dout;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
`ifdef SYNTHESIS
             ;
`else
             for (i = 0; i < 63; i = i + 1)
               begin
                  DPRAM[i] <= 0;
               end
`endif
          end
        if (clken)
          begin
             if (wr)
               DPRAM[wr_curr] <= din;
             dout <= DPRAM[rd_curr];
          end
     end

   //
   // FIFO Empty
   //

   assign empty = (depth == 0);

   //
   // FIFO Alarm
   //

   assign alarm = (depth > 16);

endmodule
