////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RAM 1Kx36
//
// Details
//
// File
//   ram1kx36.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2014 Rob Doyle
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

module RAM1Kx36(clk, rst, clken, wr, addr, din, dout);

   input         clk;           // Clock
   input         rst;           // Reset
   input         clken;         // Clock enable
   input         wr;            // Write
   input  [0: 9] addr;          // Address
   input  [0:35] din;           // Data in
   output [0:35] dout;          // Data out

   //
   // RAM 1kx36
   //
   // Note:
   //  There are places when the KS10 microcode reads uninitialized RAMFILE
   //  contents (TTG, for one).  This halts the simulation.  Therefore this
   //  implementation includes code to initialize the RAMFILE contents for
   //  simulation purposes.
   //
   // Trace
   //  DPE7/E906, DPE7/E907, DPE7/E908, DPE7/E909, DPE7/E910, DPE7/E911
   //  DPE7/E912, DPE7/E913, DPE7/E914, DPE7/E915, DPE7/E916, DPE7/E917
   //  DPE7/E918, DPE7/E919, DPE7/E920, DPE7/E921, DPE7/E922, DPE7/E923
   //  DPE7/E806, DPE7/E807, DPE7/E808, DPE7/E809, DPE7/E810, DPE7/E811
   //  DPE7/E812, DPE7/E813, DPE7/E814, DPE7/E815, DPE7/E816, DPE7/E817
   //  DPE7/E818, DPE7/E819, DPE7/E820, DPE7/E821, DPE7/E822, DPE7/E823
   //

`ifndef SYNTHESIS
   integer i;
`endif

   reg [0:35] ram [0:1023];
   reg [0: 9] rd_addr;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
`ifdef SYNTHESIS
             ;
`else
             for (i = 0; i < 1024; i = i + 1)
             begin
                ram[i] <= 0;
             end
             // FIXME
             // Initialize Stack Pointer
             ram[15] <= 36'o777577_030303;
`endif
          end
        else if (clken)
          begin
             if (wr)
               ram[addr] <= din;
             rd_addr <= addr;
          end
     end

   assign dout = ram[rd_addr];

endmodule
