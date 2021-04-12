////////////////////////////////////////////////////////////////////
//
// KS10 Processor
//
// Brief
//   Parameterized CRC16 module
//
// File
//   crc16.v
//
// Notes:
//   Several polynomials are used by the KS10 system.  These are:
//
//   CRC-16/DDCMP   -  x**16 + x**15 + x**2 + 1
//     INIT=16'h0000, POLY=16'h8005
//
//   CRC-CCITT/SDLC - x**16 + x**12 + x**5 + 1
//     INIT=16'hffff, POLY=16'h1021
//
//   Most of the polynomial coefficents are the same.  We'll let
//   the logic optimizer figure this all out.
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2021 Rob Doyle
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
`timescale 1ns/1ps

`include "crc16.vh"

module CRC16 (
      input  wire        clk,
      input  wire        rst,
      input  wire        clken,
      input  wire        init,
      input  wire        decmode,
      input  wire        din,
      output reg  [15:0] crc
   );

   wire [15:0] poly = decmode ? `DDCMP_POLY : `SDLC_POLY;

   //
   // CRC Calculation
   //

   wire fb;
   always @(posedge clk)
     begin
        if (rst | init)
          crc <= decmode ? 16'h0000 : 16'hffff;
        else if (clken)
          begin
             crc[ 0] <=           (poly[ 0] & fb);
             crc[ 1] <= crc[ 0] ^ (poly[ 1] & fb);
             crc[ 2] <= crc[ 1] ^ (poly[ 2] & fb);
             crc[ 3] <= crc[ 2] ^ (poly[ 3] & fb);
             crc[ 4] <= crc[ 3] ^ (poly[ 4] & fb);
             crc[ 5] <= crc[ 4] ^ (poly[ 5] & fb);
             crc[ 6] <= crc[ 5] ^ (poly[ 6] & fb);
             crc[ 7] <= crc[ 6] ^ (poly[ 7] & fb);
             crc[ 8] <= crc[ 7] ^ (poly[ 8] & fb);
             crc[ 9] <= crc[ 8] ^ (poly[ 9] & fb);
             crc[10] <= crc[ 9] ^ (poly[10] & fb);
             crc[11] <= crc[10] ^ (poly[11] & fb);
             crc[12] <= crc[11] ^ (poly[12] & fb);
             crc[13] <= crc[12] ^ (poly[13] & fb);
             crc[14] <= crc[13] ^ (poly[14] & fb);
             crc[15] <= crc[14] ^ (poly[15] & fb);
          end
     end

   //
   // Feedback
   //

   assign fb = din ^ crc[15];

endmodule
