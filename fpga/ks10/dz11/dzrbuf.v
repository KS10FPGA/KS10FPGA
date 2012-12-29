////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// brief
//      DZ-11 SILO FIFO
//
// details
//
// todo
//
// file
//      fifo64x11.v
//
// author
//      Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2012 Rob Doyle
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

module dzfifo(clk, rst, clken, din, wr, dout, rd, full, alarm, empty);

   input         clk;           // Clock
   input         rst;           // Reset
   input         clken;         // Clock enable
   input  [0:10] din;           // Data Input
   input         wr;            // Push Data into FIFO
   output [0:10] dout;          // Data Output
   input         rd;            // Pop Data from FIFO
   output        full;          // FIFO full
   output        alarm;         // FIFO full enough
   output        empty;         // FIFO empty

   //
   // Write Pointer
   //

   reg [0:5] wr_curr;
   
   always @(posedge clk)
   begin
     if (rst)
       wr_curr <= 0;
     else if (clken & wr)
       wr_curr <= wr_curr + 1'b1;
   end

   //
   // Read Pointer
   //

   reg [0:5] rd_curr;
   
   always @(posedge clk)
   begin
     if (rst)
       rd_curr <= 0;
     else if (clken & rd)
       rd_curr <= rd_curr + 1'b1;
   end

   //
   // FIFO Depth
   //

   reg [0:5] depth;
   
   always @(posedge clk)
   begin
     if (rst)
       depth <= 0;
     else if (clken & rd & ~wr & (depth !=  0))
       depth <= depth - 1'b1;
     else if (clken & wr & ~rd & (depth != 63))
       depth <= depth + 1'b1;
   end

   //
   // Dual Port RAM
   //

   reg [0:10] DPRAM[0:63];
   reg [0:10] dout;
   
   always @(posedge clk)
     begin
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
   // FIFO Full
   //

   assign full = (depth == 63);

   //
   // FIFO Alarm
   //
   
   assign alarm = (depth > 16);

endmodule
