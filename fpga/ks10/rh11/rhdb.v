////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RH11 Data Buffer Register (RHDB)
//
// File
//   rhdb.v
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

`include "rhdb.vh"

`define SIZE 66

module RHDB (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire         devRESET,             // Device clear
      input  wire         devLOBYTE,            // Device low byte
      input  wire         devHIBYTE,            // Device high byte
      input  wire [35: 0] rhDATAI,              // Data in
      input  wire         rhCLRGO,              // Command clear
      input  wire         rhCLRTRE,             // Transfer error clear
      input  wire         rhCLR,                // Controller clear
      input  wire         rhdbREAD,             // Read from DB
      input  wire         rhdbWRITE,            // Write to DB
      output wire         rhSETDLT,             // Set DLT
      output wire         rhBUFIR,              // Status IR
      output wire         rhBUFOR,              // Status OR
      output reg  [15: 0] rhDB                  // rhDB output
   );

   //
   // The FIFO state is updated after the read and write signals.
   //

   wire wr;
   wire rd;
   EDGETRIG #(.POSEDGE(0)) FIFORD(clk, rst, 1'b1, rhdbWRITE, wr);
   EDGETRIG #(.POSEDGE(0)) FIFOWR(clk, rst, 1'b1, rhdbREAD,  rd);

   //
   // FIFO Interface
   //

   reg [6:0] depth;
   reg [6:0] rd_ptr;
   reg [6:0] wr_ptr;

   wire empty = (depth == 0);
   wire full  = (depth == `SIZE);

   //
   // FIFO State
   //

   always @(posedge clk)
     begin
        if (rst | devRESET | rhCLR | rhCLRTRE | rhCLRGO)
          begin
             depth  <= 0;
             rd_ptr <= 0;
             wr_ptr <= 0;
          end
        else if (rd & !wr & !empty)
          begin
             depth <= depth - 1'b1;
             if (rd_ptr == 7'd127)
               rd_ptr <= 0;
             else
               rd_ptr <= rd_ptr + 1'b1;
          end
        else if (wr & !rd & !full)
          begin
             depth <= depth + 1'b1;
             if (wr_ptr == 7'd127)
               wr_ptr <= 0;
             else
               wr_ptr <= wr_ptr + 1'b1;
          end
     end

   //
   // Dual Port RAM circular buffer
   //
   // Details
   //

`ifndef SYNTHESIS
   integer i;
`endif

   reg [15:0] mem[0:127];

   always @(posedge clk)
     begin
        if (rst)
          begin
`ifndef SYNTHESIS
             for (i = 0; i <= 127; i = i + 1)
               mem[i] <= 0;
`endif
          end
        else
          begin
             if (rhdbWRITE & !full)
               mem[wr_ptr] <= {`rhDB_HI(rhDATAI), `rhDB_LO(rhDATAI)};
             rhDB <= mem[rd_ptr];
          end
     end

   //
   // Device Late, Input Ready, and Output Ready
   //

   assign rhSETDLT = (empty & rhdbREAD) | (full & rhdbWRITE);
   assign rhBUFIR  = !full;
   assign rhBUFOR  = !empty;

endmodule
