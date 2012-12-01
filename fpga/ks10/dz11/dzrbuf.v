////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      FIFO
//!
//! \details
//!
//! \todo
//!
//! \file
//!      fifo64x11.v
//!
//! \author
//!      Rob Doyle - doyle (at) cox (dot) net
//!
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
//
// Comments are formatted for doxygen
//

`default_nettype none

module fifo64x11(clk, rst, clken,
                 din, wr, dout, rd, full, empty);

   input         clk;           // Clock
   input         rst;           // Reset
   input         clken;         // Clock enable
   input  [0:10] din;           // Data Input
   input         wr;            // Push Data into FIFO
   output [0:10] dout;          // Data Output
   input         rd;            // Pop Data from FIFO
   output        full;          // FIFO full
   output        empty;         // FIFO empty

   //
   // Write Pointer
   //

   reg [0:5] wr_pointer;
   always @ (posedge clk or posedge rst)
   begin
     if (rst)
       wr_pointer <= 0;
     else if (wr)
       wr_pointer <= wr_pointer + 6'b1;
   end

   //
   // Read Pointer
   //

   reg [0:5] rd_pointer;
   always @ (posedge clk or posedge rst)
   begin
     if (rst)
       rd_pointer <= 0;
     else if (rd)
       rd_pointer <= rd_pointer + 6'b1;
   end

   //
   // FIFO Empty
   //
   // Details
   //  The FIFO is empty when the read pointer is the same as
   //  the write pointer.
   //

   assign empty = (rd_pointer == wr_pointer);

   //
   // FIFO Full
   //
   // Details
   //  The FIFO is full when the write pointer is one behind
   //  the read pointer.  I.e., if you add another item to
   //  the FIFO, the FIFO will indicate empty.
   //

   wire [0:6] next = wr_pointer + 1'b1;
   assign full = (rd_pointer == next);

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
               DPRAM[wr_pointer] = din;
             dout <= DPRAM[rd_pointer];
          end
     end

endmodule
