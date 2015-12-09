////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RPxx Error Correction Code
//
// File
//   rpecc.v
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

`include "rpecc.vh"

module RPECC (
      input  wire         clk,          // Clock
      input  wire         rst,          // Reset
      input  wire         clken,        // Clock enable
      input  wire [ 1: 0] opECC,        // ECC operation
      input  wire         crc_in,       // CRC input
      output wire         crc_out,      // CRC output

      output wire [15: 0] rpEC1,        // Error position register
      output wire [15: 0] rpEC2,        // Error pattern register
      output wire         rpZD          // Zero detect
   );

   //
   // Error Correcting Code Polynomial (Fire Code)
   //
   // CRC Polynomial is x^32 + x^23 + x^21 + x^11 + x^2 + 1
   //
   // Trace
   //  M7776/EC1/E7
   //  M7776/EC1/E47
   //

   function [31:0]        crc32;
      input        d;           // Input data bit
      input [31:0] i;           // CRC in
      begin
         crc32[ 0] =         d ^ i[31];
         crc32[ 1] = i[ 0];
         crc32[ 2] = i[ 1] ^ d ^ i[31];
         crc32[ 3] = i[ 2];
         crc32[ 4] = i[ 3];
         crc32[ 5] = i[ 4];
         crc32[ 6] = i[ 5];
         crc32[ 7] = i[ 6];
         crc32[ 8] = i[ 7];
         crc32[ 9] = i[ 8];
         crc32[10] = i[ 9];
         crc32[11] = i[10] ^ d ^ i[31];
         crc32[12] = i[11];
         crc32[13] = i[12];
         crc32[14] = i[13];
         crc32[15] = i[14];
         crc32[16] = i[15];
         crc32[17] = i[16];
         crc32[18] = i[17];
         crc32[19] = i[18];
         crc32[20] = i[19];
         crc32[21] = i[20] ^ d ^ i[31];
         crc32[22] = i[21];
         crc32[23] = i[22] ^ d ^ i[31];
         crc32[24] = i[23];
         crc32[25] = i[24];
         crc32[26] = i[25];
         crc32[27] = i[26];
         crc32[28] = i[27];
         crc32[29] = i[28];
         crc32[30] = i[29];
         crc32[31] = i[30];
      end
   endfunction

   //
   // Perform CRC
   //
   // Trace
   //  M7776/EC1/E2
   //  M7776/EC1/E3
   //  M7776/EC1/E6
   //  M7776/EC1/E9
   //  M7776/EC1/E10
   //  M7776/EC1/E11
   //

   reg [31:0] crc;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          crc <= 0;
        else
          if (clken)
            case (opHCRC)
              `opHCRC_RST:
                crc <= 0;
              `opHCRC_IN:
                crc <= crc16(crc_in, crc);
              `opHCRC_OUT:
                crc <= crc16(1'b0, crc);
              `opHCRC_IDLE:
                crc <= crc;
            endcase
     end

   //
   // Zero Detect
   //
   // Trace
   //  M7776/EC1/E1
   //  M7776/EC1/E4
   //  M7776/EC1/E5
   //

   assign rpZD = (crc[20:0] = 0);

   //
   //
   //


endmodule

//
// Comparitor
//

//
// N    A
//
// 15   1
// 14   0
// 13   NCODE_HICNT(1)H   (initially lo)
// 12   NCODE_HICNT(0)H   (initially hi)
//
// 11   0
// 10   1
//  9   NCODE_HICNT(1)H | 22_FMT_H  (initially low 18-bit/initially hi 16-bit)
//  8   1
//
//  7   1
//  6   1
//  5   NCODE_HICNT(1)H   (initially lo)
//  4   0
//
//  3   1
//  2   0
//  1   1
//  0   0
//
//22FMT NCODE_HICNT(0)H  VAL
//    0    0     1010 0101 1110 1010 = a5ea = 42469
//    1    0     1010 0111 1110 1010 = a7ea = 42986 (ntot - 1)
//    0    1     1001 0111 1100 1010 = 97ca = 38858
//    1    1     1001 0111 1100 1010 = 97ca = 38858
//
// 18-bit 38347 = 95cb = 1001 0101 1100 1011
// 16-bit 38859 = 97cb = 1001 0111 1100 1011
// Tot    42987 = a7eb = 1010 0111 1110 1011
//
// 16-bit mode:
//   38347 + 4608 + 32 = 42987 = 21 * 2047  (zero + data + crc)
//
// 18-bit mode:
//   38859 + 4096 + 32 = 42987 = 21 * 2047  (zero + data + crc)
//
// TRUTH TABLE
// 22FMT NCODE         BINARY      HEX  DECIMAL DESCRIPTION
// ----- ----- ------------------- ---- ------- ------------
//   0     0   1001 0101 1100 1010 95ca  38346  (pre 18-bit)
//   1     0   1001 0111 1100 1010 97ca  38858  (pre 16-bit)
//   x     1   1010 0111 1110 1010 a7ea  42986  (post)
//
