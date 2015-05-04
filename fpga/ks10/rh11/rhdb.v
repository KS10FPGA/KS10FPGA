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

module RHDB(clk, rst,
            devRESET, devLOBYTE, devHIBYTE, devDATAI, goCLR, treCLR, rhCLR,
            rhdbREAD, rhdbWRITE, rhSETDLT, rhBUFIR, rhBUFOR, rhDB);

   input          clk;                          // Clock
   input          rst;                          // Reset
   input          devRESET;                     // Device clear
   input          devLOBYTE;                    // Device low byte
   input          devHIBYTE;                    // Device high byte
   input  [ 0:35] devDATAI;                     // Device data in
   input          goCLR;                        // Command clear
   input          treCLR;                       // Transfer error clear
   input          rhCLR;                        // Controller clear
   input          rhdbREAD;                     // Read from DB
   input          rhdbWRITE;                    // Write to DB
   output         rhSETDLT;                     // Set DLT
   output         rhBUFIR;                      // Status IR
   output         rhBUFOR;                      // Status OR
   output [15: 0] rhDB;                         // rhDB output

   //
   // Big-endian to little-endian data bus swap
   //

   wire [35:0] rhDATAI = devDATAI[0:35];

   //
   // RH11 Data Buffer (RHDB) Register
   //
   // Trace
   //

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

   //
   // FIFO Interface
   //

   reg [6:0] depth;
   wire wr    = rhdbWRITE;
   wire rd    = rhdbWRITE;
   wire empty = (depth == 0);
   wire full  = (depth == `SIZE);

   //
   // FIFO State
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          depth <= 0;
        else
          if (devRESET | rhCLR | treCLR | goCLR)
            depth <= 0;
          else if (rd & !wr & !empty)
            depth <= depth - 1'b1;
          else if (wr & !rd & !full)
            depth <= depth + 1'b1;
     end

   //
   // Device Late
   //

   assign rhSETDLT = (empty & rhdbREAD) | (full & rhdbWRITE);
   assign rhBUFIR  = empty;
   assign rhBUFOR  = full;

endmodule
