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
// Copyright (C) 2012-2015 Rob Doyle
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

`define FIFO

module RHDB (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire         devRESET,             // Device clear
      input  wire         devLOBYTE,            // Device low byte
      input  wire         devHIBYTE,            // Device high byte
      input  wire [ 0:35] devDATAI,             // Device data in
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
   // Big-endian to little-endian data bus swap
   //

   wire [35:0] rhDATAI = devDATAI[0:35];

   //
   // RH11 Data Buffer (RHDB) Register
   //
   // Trace
   //

`ifndef FIFO

   reg [15:0] rhDB;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rhDB <= 0;
        else
          if (devRESET | rhCLR)
            rhDB <= 0;
          else if (rhdbWRITE)
            begin
               if (devHIBYTE)
                 rhDB[15:8] <= `rhDB_HI(rhDATAI);
               if (devLOBYTE)
                 rhDB[ 7:0] <= `rhDB_LO(rhDATAI);
            end
     end

`endif

   //
   // The FIFO state is updated after the read and write signals.
   //

   wire wr;
   wire rd;
   EDGETRIG FIFORD(clk, rst, 1'b1, 1'b0, rhdbWRITE, wr);
   EDGETRIG FIFOWR(clk, rst, 1'b1, 1'b0, rhdbREAD,  rd);

   //
   // FIFO Interface
   //

   reg [6:0] depth;
   reg [6:0] rd_ptr;
   reg [6:0] wr_ptr;

   //
   // FIFO State
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             depth  <= 0;
             rd_ptr <= 0;
             wr_ptr <= 0;
          end
        else
          if (devRESET | rhCLR | rhCLRTRE | rhCLRGO)
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
   // FIFO Status
   //

   wire empty = (depth == 0);
   wire full  = (depth == `SIZE);

   //
   // Dual Port RAM circular buffer
   //
   // Details
   //

`ifdef FIFO

`ifndef SYNTHESIS
   integer i;
`endif

   reg [15:0] mem[0:127];

   always @(posedge clk or posedge rst)
     begin
        if (rst)
`ifdef SYNTHESIS
          ;
`else
          for (i = 0; i <= 127; i = i + 1)
            mem[i] <= 0;
`endif
        else
          begin
             if (rhdbWRITE & !full)
               mem[wr_ptr] <= {`rhDB_HI(rhDATAI), `rhDB_LO(rhDATAI)};
             rhDB <= mem[rd_ptr];
          end
     end

`endif

   //
   // Device Late, Input Ready, and Output Ready
   //

   assign rhSETDLT = (empty & rhdbREAD) | (full & rhdbWRITE);
   assign rhBUFIR  = !full;
   assign rhBUFOR  = !empty;

endmodule
