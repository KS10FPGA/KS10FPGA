////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   UBA Maintenance Register (UBAMR)
//
// Details
//   This module implements the IO Bridge Status Register (UBAMR).
//
//   The IO Bridge Maintenance Register is defined as follows:
//
//     0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17
//   +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
//   |                                                                       |
//   +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
//
//    18  19  20  21  22  23  24 25 26 27 28 29 30 31 32 33 34 35
//   +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
//   |                                                                   |CR |
//   +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
//
//   Register Definitions
//
//      CR  : Change Register - Always read as 0.
//
//      SIMH does not implement the UBAMR.
//
// File
//   ubamr.v
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

`include "ubamr.vh"
`include "../cpu/bus.vh"

module UBAMR(clk, rst, busDATAI, maintWRITE, regUBAMR);

   input         clk;                           // Clock
   input         rst;                           // Reset
   input [ 0:35] busDATAI;                      // Backplane bus data in
   input         maintWRITE;                    // Write to register
   output        regUBAMR;                      // Maintenance Register

   //
   // Maintenance Register
   //

   reg regUBAMR;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          regUBAMR <= 0;
        else
          if (maintWRITE)
            regUBAMR <= `maintCR(busDATAI);
     end

endmodule
