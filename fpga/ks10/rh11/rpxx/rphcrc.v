////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RPxx Sector Header CRC (RPHCRC)
//
// File
//   rphcrc.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2016 Rob Doyle
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

`include "rphcrc.vh"

module RPHCRC (
      input  wire        clk,           // Clock
      input  wire        rst,           // Reset
      input  wire        clken,         // Clock enable
      input  wire [ 1:0] opHCRC,        // HCRC operation
      input  wire        in,            // CRC input
      output reg  [15:0] crc            // CRC output
   );

   //
   // Sector Header CRC
   //
   // CRC Polynomial is x^16 + x^15 + x^2 + 1
   //
   // Trace
   //  M7786/SS7/E81
   //

   function [15:0] crc16;
      input        d;           // Input data bit
      input [15:0] i;           // CRC in
      begin
         crc16[ 0] =        d ^ i[15];
         crc16[ 1] = i[ 0];
         crc16[ 2] = i[ 1] ^d ^ i[15];
         crc16[ 3] = i[ 2];
         crc16[ 4] = i[ 3];
         crc16[ 5] = i[ 4];
         crc16[ 6] = i[ 5];
         crc16[ 7] = i[ 6];
         crc16[ 8] = i[ 7];
         crc16[ 9] = i[ 8];
         crc16[10] = i[ 9];
         crc16[11] = i[10];
         crc16[12] = i[11];
         crc16[13] = i[12];
         crc16[14] = i[13];
         crc16[15] = i[14] ^d ^ i[15];
      end
   endfunction

   //
   // Perform CRC
   //
   // Trace
   //  M7786/SS7/E83
   //  M7786/SS7/E84
   //  M7786/SS7/E89
   //

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
                crc <= crc16(in, crc);
              `opHCRC_OUT:
                crc <= crc16(1'b0, crc);
              `opHCRC_IDLE:
                crc <= crc;
            endcase
     end

endmodule
