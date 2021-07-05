////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   LP26 Printer Emulator
//
// Details
//   This file provides the implementation of a DEC LP26 printer.
//
// File
//   lp26.v
//
// Note:
//   Most of this information is from "LP26 Line Printer Maintenance Manual",
//   Dataproducts publication number 255182C
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

`define IGNORE_CTRL_CHARS

`include "lpdvfu.vh"
`include "../utils/ascii.vh"

module LP26 (
      input  wire         clk,          // Clock
      input  wire         rst,          // Reset
      input  wire         lpINIT,       // Printer reset
      input  wire [ 6:15] lpCONFIG,     // Printer serial configuration
      input  wire         lpOVFU,       // Printer should use optical VFU
      input  wire         lpRXD,        // Printer received data
      output wire         lpTXD,        // Printer transmitted data
      input  wire         lpSTROBE,     // Printer data stobe
      input  wire [ 8: 1] lpDATA,       // Printer data
      input  wire         lpDPAR,       // Printer data parity
      input  wire         lpPI,         // Printer paper instruction
      output wire         lpTOF,        // Printer is at top of form
      output wire         lpPARERR,     // Printer parity error
      output wire         lpSETOFFLN,   // Printer should go offline
      output reg          lpVFURDY,     // Printer VFU is ready
      output reg          lpSIXLPI,     // Printer is in 6 LPI mode
      output wire         lpDEMAND      // Printer is ready for another character
);

   //
   // Determine if the DVFU channel matches the channel command
   //  Note only the first 12 channels are valid
   //

   function [ 0:0] lpVFUMATCH;
      input [12:1] lpVFUDATA;
      input [ 8:1] lpDATA;
      reg   [ 4:1] channel;
      begin
         channel = lpDATA[4:1];
         case (channel)
            0: lpVFUMATCH = lpVFUDATA[ 1];
            1: lpVFUMATCH = lpVFUDATA[ 2];
            2: lpVFUMATCH = lpVFUDATA[ 3];
            3: lpVFUMATCH = lpVFUDATA[ 4];
            4: lpVFUMATCH = lpVFUDATA[ 5];
            5: lpVFUMATCH = lpVFUDATA[ 6];
            6: lpVFUMATCH = lpVFUDATA[ 7];
            7: lpVFUMATCH = lpVFUDATA[ 8];
            8: lpVFUMATCH = lpVFUDATA[ 9];
            9: lpVFUMATCH = lpVFUDATA[10];
           10: lpVFUMATCH = lpVFUDATA[11];
           11: lpVFUMATCH = lpVFUDATA[12];
           12: lpVFUMATCH = 0;
           13: lpVFUMATCH = 0;
           14: lpVFUMATCH = 0;
           15: lpVFUMATCH = 0;
         endcase
      end
   endfunction

   //
   // VFU Lengths
   //   Optical
   //   Digital
   //   Whatever is selected
   //

   reg        [7:0] lpDVFULEN;
   localparam [7:0] lpOVFULEN = 8'd66;
   wire       [7:0] lpVFULEN  = lpOVFU ? lpOVFULEN : lpDVFULEN;

   //
   // Optical VFU data.  It is read-only.
   //
   // Note
   //   The Optical VFU data is formatted as follows:
   //
   //   Chan   Description         Programming
   //   ----   ------------------  ----------------
   //    12    Bottom-of-form (MSB)
   //    11    User defined        Not programmed
   //    10    User defined        Not programmed
   //     9    User defined        Not programmed
   //     8    Printable
   //     7    User defined        Twenty spaces
   //     6    User defined        Ten spaces
   //     5    Slew
   //     4    User defined        Triple space
   //     3    User defined        Double space
   //     2    Vertical Tab        Thirty spaces
   //     1    Top-of-form (LSB)
   //

   reg [12:1] lpOVFUDAT[0:255];

   initial
     begin

        //
        // Initial OVFU Data
        //
        //                   111 000 000 000
        //                   210 987 654 321

        lpOVFUDAT[  0] = 12'b000_011_111_111;    // Line  0
        lpOVFUDAT[  1] = 12'b000_010_010_000;    // Line  1
        lpOVFUDAT[  2] = 12'b000_010_010_100;    // Line  2
        lpOVFUDAT[  3] = 12'b000_010_011_000;    // Line  3
        lpOVFUDAT[  4] = 12'b000_010_010_100;    // Line  4
        lpOVFUDAT[  5] = 12'b000_010_010_000;    // Line  5
        lpOVFUDAT[  6] = 12'b000_010_011_100;    // Line  6
        lpOVFUDAT[  7] = 12'b000_010_010_000;    // Line  7
        lpOVFUDAT[  8] = 12'b000_010_010_100;    // Line  8
        lpOVFUDAT[  9] = 12'b000_010_011_000;    // Line  9
        lpOVFUDAT[ 10] = 12'b000_010_110_100;    // Line 10
        lpOVFUDAT[ 11] = 12'b000_010_010_000;    // Line 11
        lpOVFUDAT[ 12] = 12'b000_010_011_100;    // Line 12
        lpOVFUDAT[ 13] = 12'b000_010_010_000;    // Line 13
        lpOVFUDAT[ 14] = 12'b000_010_010_100;    // Line 14
        lpOVFUDAT[ 15] = 12'b000_010_011_000;    // Line 15
        lpOVFUDAT[ 16] = 12'b000_010_010_100;    // Line 16
        lpOVFUDAT[ 17] = 12'b000_010_010_000;    // Line 17
        lpOVFUDAT[ 18] = 12'b000_010_011_100;    // Line 18
        lpOVFUDAT[ 19] = 12'b000_010_010_000;    // Line 19
        lpOVFUDAT[ 20] = 12'b000_011_110_100;    // Line 20
        lpOVFUDAT[ 21] = 12'b000_010_011_000;    // Line 21
        lpOVFUDAT[ 22] = 12'b000_010_010_100;    // Line 22
        lpOVFUDAT[ 23] = 12'b000_010_010_000;    // Line 23
        lpOVFUDAT[ 24] = 12'b000_010_011_100;    // Line 24
        lpOVFUDAT[ 25] = 12'b000_010_010_000;    // Line 25
        lpOVFUDAT[ 26] = 12'b000_010_010_100;    // Line 26
        lpOVFUDAT[ 27] = 12'b000_010_011_000;    // Line 27
        lpOVFUDAT[ 28] = 12'b000_010_010_100;    // Line 28
        lpOVFUDAT[ 29] = 12'b000_010_010_000;    // Line 29
        lpOVFUDAT[ 30] = 12'b000_010_111_110;    // Line 30
        lpOVFUDAT[ 31] = 12'b000_010_010_000;    // Line 31
        lpOVFUDAT[ 32] = 12'b000_010_010_100;    // Line 32
        lpOVFUDAT[ 33] = 12'b000_010_011_000;    // Line 33
        lpOVFUDAT[ 34] = 12'b000_010_010_100;    // Line 34
        lpOVFUDAT[ 35] = 12'b000_010_010_000;    // Line 35
        lpOVFUDAT[ 36] = 12'b000_010_011_100;    // Line 36
        lpOVFUDAT[ 37] = 12'b000_010_010_000;    // Line 37
        lpOVFUDAT[ 38] = 12'b000_010_010_100;    // Line 38
        lpOVFUDAT[ 39] = 12'b000_010_011_000;    // Line 39
        lpOVFUDAT[ 40] = 12'b000_011_110_100;    // Line 40
        lpOVFUDAT[ 41] = 12'b000_010_010_000;    // Line 41
        lpOVFUDAT[ 42] = 12'b000_010_011_100;    // Line 42
        lpOVFUDAT[ 43] = 12'b000_010_010_000;    // Line 43
        lpOVFUDAT[ 44] = 12'b000_010_010_100;    // Line 44
        lpOVFUDAT[ 45] = 12'b000_010_011_000;    // Line 45
        lpOVFUDAT[ 46] = 12'b000_010_010_100;    // Line 46
        lpOVFUDAT[ 47] = 12'b000_010_010_000;    // Line 47
        lpOVFUDAT[ 48] = 12'b000_010_011_100;    // Line 48
        lpOVFUDAT[ 49] = 12'b000_010_010_000;    // Line 49
        lpOVFUDAT[ 50] = 12'b000_010_110_100;    // Line 50
        lpOVFUDAT[ 51] = 12'b000_010_011_000;    // Line 51
        lpOVFUDAT[ 52] = 12'b000_010_010_100;    // Line 52
        lpOVFUDAT[ 53] = 12'b000_010_010_000;    // Line 53
        lpOVFUDAT[ 54] = 12'b000_010_011_100;    // Line 54
        lpOVFUDAT[ 55] = 12'b000_010_010_000;    // Line 55
        lpOVFUDAT[ 56] = 12'b000_010_010_100;    // Line 56
        lpOVFUDAT[ 57] = 12'b000_010_011_000;    // Line 57
        lpOVFUDAT[ 58] = 12'b000_010_010_100;    // Line 58
        lpOVFUDAT[ 59] = 12'b000_010_010_000;    // Line 59
        lpOVFUDAT[ 60] = 12'b000_000_010_000;    // Line 60
        lpOVFUDAT[ 61] = 12'b000_000_010_000;    // Line 61
        lpOVFUDAT[ 62] = 12'b000_000_010_000;    // Line 62
        lpOVFUDAT[ 63] = 12'b000_000_010_000;    // Line 63
        lpOVFUDAT[ 64] = 12'b000_000_010_000;    // Line 64
        lpOVFUDAT[ 65] = 12'b100_000_010_000;    // Line 65
        lpOVFUDAT[ 66] = 12'b000_000_000_000;
        lpOVFUDAT[ 67] = 12'b000_000_000_000;
        lpOVFUDAT[ 68] = 12'b000_000_000_000;
        lpOVFUDAT[ 69] = 12'b000_000_000_000;
        lpOVFUDAT[ 70] = 12'b000_000_000_000;
        lpOVFUDAT[ 71] = 12'b000_000_000_000;
        lpOVFUDAT[ 72] = 12'b000_000_000_000;
        lpOVFUDAT[ 73] = 12'b000_000_000_000;
        lpOVFUDAT[ 74] = 12'b000_000_000_000;
        lpOVFUDAT[ 75] = 12'b000_000_000_000;
        lpOVFUDAT[ 76] = 12'b000_000_000_000;
        lpOVFUDAT[ 77] = 12'b000_000_000_000;
        lpOVFUDAT[ 78] = 12'b000_000_000_000;
        lpOVFUDAT[ 79] = 12'b000_000_000_000;
        lpOVFUDAT[ 80] = 12'b000_000_000_000;
        lpOVFUDAT[ 81] = 12'b000_000_000_000;
        lpOVFUDAT[ 82] = 12'b000_000_000_000;
        lpOVFUDAT[ 83] = 12'b000_000_000_000;
        lpOVFUDAT[ 84] = 12'b000_000_000_000;
        lpOVFUDAT[ 85] = 12'b000_000_000_000;
        lpOVFUDAT[ 86] = 12'b000_000_000_000;
        lpOVFUDAT[ 87] = 12'b000_000_000_000;
        lpOVFUDAT[ 88] = 12'b000_000_000_000;
        lpOVFUDAT[ 89] = 12'b000_000_000_000;
        lpOVFUDAT[ 90] = 12'b000_000_000_000;
        lpOVFUDAT[ 91] = 12'b000_000_000_000;
        lpOVFUDAT[ 92] = 12'b000_000_000_000;
        lpOVFUDAT[ 93] = 12'b000_000_000_000;
        lpOVFUDAT[ 94] = 12'b000_000_000_000;
        lpOVFUDAT[ 95] = 12'b000_000_000_000;
        lpOVFUDAT[ 96] = 12'b000_000_000_000;
        lpOVFUDAT[ 97] = 12'b000_000_000_000;
        lpOVFUDAT[ 98] = 12'b000_000_000_000;
        lpOVFUDAT[ 99] = 12'b000_000_000_000;
        lpOVFUDAT[100] = 12'b000_000_000_000;
        lpOVFUDAT[101] = 12'b000_000_000_000;
        lpOVFUDAT[102] = 12'b000_000_000_000;
        lpOVFUDAT[103] = 12'b000_000_000_000;
        lpOVFUDAT[104] = 12'b000_000_000_000;
        lpOVFUDAT[105] = 12'b000_000_000_000;
        lpOVFUDAT[106] = 12'b000_000_000_000;
        lpOVFUDAT[107] = 12'b000_000_000_000;
        lpOVFUDAT[108] = 12'b000_000_000_000;
        lpOVFUDAT[109] = 12'b000_000_000_000;
        lpOVFUDAT[110] = 12'b000_000_000_000;
        lpOVFUDAT[111] = 12'b000_000_000_000;
        lpOVFUDAT[112] = 12'b000_000_000_000;
        lpOVFUDAT[113] = 12'b000_000_000_000;
        lpOVFUDAT[114] = 12'b000_000_000_000;
        lpOVFUDAT[115] = 12'b000_000_000_000;
        lpOVFUDAT[116] = 12'b000_000_000_000;
        lpOVFUDAT[117] = 12'b000_000_000_000;
        lpOVFUDAT[118] = 12'b000_000_000_000;
        lpOVFUDAT[119] = 12'b000_000_000_000;
        lpOVFUDAT[120] = 12'b000_000_000_000;
        lpOVFUDAT[121] = 12'b000_000_000_000;
        lpOVFUDAT[122] = 12'b000_000_000_000;
        lpOVFUDAT[123] = 12'b000_000_000_000;
        lpOVFUDAT[124] = 12'b000_000_000_000;
        lpOVFUDAT[125] = 12'b000_000_000_000;
        lpOVFUDAT[126] = 12'b000_000_000_000;
        lpOVFUDAT[127] = 12'b000_000_000_000;
        lpOVFUDAT[128] = 12'b000_000_000_000;
        lpOVFUDAT[129] = 12'b000_000_000_000;
        lpOVFUDAT[130] = 12'b000_000_000_000;
        lpOVFUDAT[131] = 12'b000_000_000_000;
        lpOVFUDAT[132] = 12'b000_000_000_000;
        lpOVFUDAT[133] = 12'b000_000_000_000;
        lpOVFUDAT[134] = 12'b000_000_000_000;
        lpOVFUDAT[135] = 12'b000_000_000_000;
        lpOVFUDAT[136] = 12'b000_000_000_000;
        lpOVFUDAT[137] = 12'b000_000_000_000;
        lpOVFUDAT[138] = 12'b000_000_000_000;
        lpOVFUDAT[139] = 12'b000_000_000_000;
        lpOVFUDAT[140] = 12'b000_000_000_000;
        lpOVFUDAT[141] = 12'b000_000_000_000;
        lpOVFUDAT[142] = 12'b000_000_000_000;
        lpOVFUDAT[143] = 12'b000_000_000_000;
        lpOVFUDAT[144] = 12'b000_000_000_000;
        lpOVFUDAT[145] = 12'b000_000_000_000;
        lpOVFUDAT[146] = 12'b000_000_000_000;
        lpOVFUDAT[147] = 12'b000_000_000_000;
        lpOVFUDAT[148] = 12'b000_000_000_000;
        lpOVFUDAT[149] = 12'b000_000_000_000;
        lpOVFUDAT[150] = 12'b000_000_000_000;
        lpOVFUDAT[151] = 12'b000_000_000_000;
        lpOVFUDAT[152] = 12'b000_000_000_000;
        lpOVFUDAT[153] = 12'b000_000_000_000;
        lpOVFUDAT[154] = 12'b000_000_000_000;
        lpOVFUDAT[155] = 12'b000_000_000_000;
        lpOVFUDAT[156] = 12'b000_000_000_000;
        lpOVFUDAT[157] = 12'b000_000_000_000;
        lpOVFUDAT[158] = 12'b000_000_000_000;
        lpOVFUDAT[159] = 12'b000_000_000_000;
        lpOVFUDAT[160] = 12'b000_000_000_000;
        lpOVFUDAT[161] = 12'b000_000_000_000;
        lpOVFUDAT[162] = 12'b000_000_000_000;
        lpOVFUDAT[163] = 12'b000_000_000_000;
        lpOVFUDAT[164] = 12'b000_000_000_000;
        lpOVFUDAT[165] = 12'b000_000_000_000;
        lpOVFUDAT[166] = 12'b000_000_000_000;
        lpOVFUDAT[167] = 12'b000_000_000_000;
        lpOVFUDAT[168] = 12'b000_000_000_000;
        lpOVFUDAT[169] = 12'b000_000_000_000;
        lpOVFUDAT[170] = 12'b000_000_000_000;
        lpOVFUDAT[171] = 12'b000_000_000_000;
        lpOVFUDAT[172] = 12'b000_000_000_000;
        lpOVFUDAT[173] = 12'b000_000_000_000;
        lpOVFUDAT[174] = 12'b000_000_000_000;
        lpOVFUDAT[175] = 12'b000_000_000_000;
        lpOVFUDAT[176] = 12'b000_000_000_000;
        lpOVFUDAT[177] = 12'b000_000_000_000;
        lpOVFUDAT[178] = 12'b000_000_000_000;
        lpOVFUDAT[179] = 12'b000_000_000_000;
        lpOVFUDAT[180] = 12'b000_000_000_000;
        lpOVFUDAT[181] = 12'b000_000_000_000;
        lpOVFUDAT[182] = 12'b000_000_000_000;
        lpOVFUDAT[183] = 12'b000_000_000_000;
        lpOVFUDAT[184] = 12'b000_000_000_000;
        lpOVFUDAT[185] = 12'b000_000_000_000;
        lpOVFUDAT[186] = 12'b000_000_000_000;
        lpOVFUDAT[187] = 12'b000_000_000_000;
        lpOVFUDAT[188] = 12'b000_000_000_000;
        lpOVFUDAT[189] = 12'b000_000_000_000;
        lpOVFUDAT[190] = 12'b000_000_000_000;
        lpOVFUDAT[191] = 12'b000_000_000_000;
        lpOVFUDAT[192] = 12'b000_000_000_000;
        lpOVFUDAT[193] = 12'b000_000_000_000;
        lpOVFUDAT[194] = 12'b000_000_000_000;
        lpOVFUDAT[195] = 12'b000_000_000_000;
        lpOVFUDAT[196] = 12'b000_000_000_000;
        lpOVFUDAT[197] = 12'b000_000_000_000;
        lpOVFUDAT[198] = 12'b000_000_000_000;
        lpOVFUDAT[199] = 12'b000_000_000_000;
        lpOVFUDAT[200] = 12'b000_000_000_000;
        lpOVFUDAT[201] = 12'b000_000_000_000;
        lpOVFUDAT[202] = 12'b000_000_000_000;
        lpOVFUDAT[203] = 12'b000_000_000_000;
        lpOVFUDAT[204] = 12'b000_000_000_000;
        lpOVFUDAT[205] = 12'b000_000_000_000;
        lpOVFUDAT[206] = 12'b000_000_000_000;
        lpOVFUDAT[207] = 12'b000_000_000_000;
        lpOVFUDAT[208] = 12'b000_000_000_000;
        lpOVFUDAT[209] = 12'b000_000_000_000;
        lpOVFUDAT[210] = 12'b000_000_000_000;
        lpOVFUDAT[211] = 12'b000_000_000_000;
        lpOVFUDAT[212] = 12'b000_000_000_000;
        lpOVFUDAT[213] = 12'b000_000_000_000;
        lpOVFUDAT[214] = 12'b000_000_000_000;
        lpOVFUDAT[215] = 12'b000_000_000_000;
        lpOVFUDAT[216] = 12'b000_000_000_000;
        lpOVFUDAT[217] = 12'b000_000_000_000;
        lpOVFUDAT[218] = 12'b000_000_000_000;
        lpOVFUDAT[219] = 12'b000_000_000_000;
        lpOVFUDAT[220] = 12'b000_000_000_000;
        lpOVFUDAT[221] = 12'b000_000_000_000;
        lpOVFUDAT[222] = 12'b000_000_000_000;
        lpOVFUDAT[223] = 12'b000_000_000_000;
        lpOVFUDAT[224] = 12'b000_000_000_000;
        lpOVFUDAT[225] = 12'b000_000_000_000;
        lpOVFUDAT[226] = 12'b000_000_000_000;
        lpOVFUDAT[227] = 12'b000_000_000_000;
        lpOVFUDAT[228] = 12'b000_000_000_000;
        lpOVFUDAT[229] = 12'b000_000_000_000;
        lpOVFUDAT[230] = 12'b000_000_000_000;
        lpOVFUDAT[231] = 12'b000_000_000_000;
        lpOVFUDAT[232] = 12'b000_000_000_000;
        lpOVFUDAT[233] = 12'b000_000_000_000;
        lpOVFUDAT[234] = 12'b000_000_000_000;
        lpOVFUDAT[235] = 12'b000_000_000_000;
        lpOVFUDAT[236] = 12'b000_000_000_000;
        lpOVFUDAT[237] = 12'b000_000_000_000;
        lpOVFUDAT[238] = 12'b000_000_000_000;
        lpOVFUDAT[239] = 12'b000_000_000_000;
        lpOVFUDAT[240] = 12'b000_000_000_000;
        lpOVFUDAT[241] = 12'b000_000_000_000;
        lpOVFUDAT[242] = 12'b000_000_000_000;
        lpOVFUDAT[243] = 12'b000_000_000_000;
        lpOVFUDAT[244] = 12'b000_000_000_000;
        lpOVFUDAT[245] = 12'b000_000_000_000;
        lpOVFUDAT[246] = 12'b000_000_000_000;
        lpOVFUDAT[247] = 12'b000_000_000_000;
        lpOVFUDAT[248] = 12'b000_000_000_000;
        lpOVFUDAT[249] = 12'b000_000_000_000;
        lpOVFUDAT[250] = 12'b000_000_000_000;
        lpOVFUDAT[251] = 12'b000_000_000_000;
        lpOVFUDAT[252] = 12'b000_000_000_000;
        lpOVFUDAT[253] = 12'b000_000_000_000;
        lpOVFUDAT[254] = 12'b000_000_000_000;
        lpOVFUDAT[255] = 12'b000_000_000_000;
     end

   //
   // Initial Digital VFU data.  It is read/write.
   //

   reg [12:1] lpDVFUDAT[0:255];

   initial
     begin

        //
        // Initial DAVFU Data
        //
        //                     111 000 000 000
        //                     210 987 654 321

        lpDVFUDAT[  0] = 12'b000_000_000_000;
        lpDVFUDAT[  1] = 12'b000_000_000_000;
        lpDVFUDAT[  2] = 12'b000_000_000_000;
        lpDVFUDAT[  3] = 12'b000_000_000_000;
        lpDVFUDAT[  4] = 12'b000_000_000_000;
        lpDVFUDAT[  5] = 12'b000_000_000_000;
        lpDVFUDAT[  6] = 12'b000_000_000_000;
        lpDVFUDAT[  7] = 12'b000_000_000_000;
        lpDVFUDAT[  8] = 12'b000_000_000_000;
        lpDVFUDAT[  9] = 12'b000_000_000_000;
        lpDVFUDAT[ 10] = 12'b000_000_000_000;
        lpDVFUDAT[ 11] = 12'b000_000_000_000;
        lpDVFUDAT[ 12] = 12'b000_000_000_000;
        lpDVFUDAT[ 13] = 12'b000_000_000_000;
        lpDVFUDAT[ 14] = 12'b000_000_000_000;
        lpDVFUDAT[ 15] = 12'b000_000_000_000;
        lpDVFUDAT[ 16] = 12'b000_000_000_000;
        lpDVFUDAT[ 17] = 12'b000_000_000_000;
        lpDVFUDAT[ 18] = 12'b000_000_000_000;
        lpDVFUDAT[ 19] = 12'b000_000_000_000;
        lpDVFUDAT[ 20] = 12'b000_000_000_000;
        lpDVFUDAT[ 21] = 12'b000_000_000_000;
        lpDVFUDAT[ 22] = 12'b000_000_000_000;
        lpDVFUDAT[ 23] = 12'b000_000_000_000;
        lpDVFUDAT[ 24] = 12'b000_000_000_000;
        lpDVFUDAT[ 25] = 12'b000_000_000_000;
        lpDVFUDAT[ 26] = 12'b000_000_000_000;
        lpDVFUDAT[ 27] = 12'b000_000_000_000;
        lpDVFUDAT[ 28] = 12'b000_000_000_000;
        lpDVFUDAT[ 29] = 12'b000_000_000_000;
        lpDVFUDAT[ 30] = 12'b000_000_000_000;
        lpDVFUDAT[ 31] = 12'b000_000_000_000;
        lpDVFUDAT[ 32] = 12'b000_000_000_000;
        lpDVFUDAT[ 33] = 12'b000_000_000_000;
        lpDVFUDAT[ 34] = 12'b000_000_000_000;
        lpDVFUDAT[ 35] = 12'b000_000_000_000;
        lpDVFUDAT[ 36] = 12'b000_000_000_000;
        lpDVFUDAT[ 37] = 12'b000_000_000_000;
        lpDVFUDAT[ 38] = 12'b000_000_000_000;
        lpDVFUDAT[ 39] = 12'b000_000_000_000;
        lpDVFUDAT[ 40] = 12'b000_000_000_000;
        lpDVFUDAT[ 41] = 12'b000_000_000_000;
        lpDVFUDAT[ 42] = 12'b000_000_000_000;
        lpDVFUDAT[ 43] = 12'b000_000_000_000;
        lpDVFUDAT[ 44] = 12'b000_000_000_000;
        lpDVFUDAT[ 45] = 12'b000_000_000_000;
        lpDVFUDAT[ 46] = 12'b000_000_000_000;
        lpDVFUDAT[ 47] = 12'b000_000_000_000;
        lpDVFUDAT[ 48] = 12'b000_000_000_000;
        lpDVFUDAT[ 49] = 12'b000_000_000_000;
        lpDVFUDAT[ 50] = 12'b000_000_000_000;
        lpDVFUDAT[ 51] = 12'b000_000_000_000;
        lpDVFUDAT[ 52] = 12'b000_000_000_000;
        lpDVFUDAT[ 53] = 12'b000_000_000_000;
        lpDVFUDAT[ 54] = 12'b000_000_000_000;
        lpDVFUDAT[ 55] = 12'b000_000_000_000;
        lpDVFUDAT[ 56] = 12'b000_000_000_000;
        lpDVFUDAT[ 57] = 12'b000_000_000_000;
        lpDVFUDAT[ 58] = 12'b000_000_000_000;
        lpDVFUDAT[ 59] = 12'b000_000_000_000;
        lpDVFUDAT[ 60] = 12'b000_000_000_000;
        lpDVFUDAT[ 61] = 12'b000_000_000_000;
        lpDVFUDAT[ 62] = 12'b000_000_000_000;
        lpDVFUDAT[ 63] = 12'b000_000_000_000;
        lpDVFUDAT[ 64] = 12'b000_000_000_000;
        lpDVFUDAT[ 65] = 12'b000_000_000_000;
        lpDVFUDAT[ 66] = 12'b000_000_000_000;
        lpDVFUDAT[ 67] = 12'b000_000_000_000;
        lpDVFUDAT[ 68] = 12'b000_000_000_000;
        lpDVFUDAT[ 69] = 12'b000_000_000_000;
        lpDVFUDAT[ 70] = 12'b000_000_000_000;
        lpDVFUDAT[ 71] = 12'b000_000_000_000;
        lpDVFUDAT[ 72] = 12'b000_000_000_000;
        lpDVFUDAT[ 73] = 12'b000_000_000_000;
        lpDVFUDAT[ 74] = 12'b000_000_000_000;
        lpDVFUDAT[ 75] = 12'b000_000_000_000;
        lpDVFUDAT[ 76] = 12'b000_000_000_000;
        lpDVFUDAT[ 77] = 12'b000_000_000_000;
        lpDVFUDAT[ 78] = 12'b000_000_000_000;
        lpDVFUDAT[ 79] = 12'b000_000_000_000;
        lpDVFUDAT[ 80] = 12'b000_000_000_000;
        lpDVFUDAT[ 81] = 12'b000_000_000_000;
        lpDVFUDAT[ 82] = 12'b000_000_000_000;
        lpDVFUDAT[ 83] = 12'b000_000_000_000;
        lpDVFUDAT[ 84] = 12'b000_000_000_000;
        lpDVFUDAT[ 85] = 12'b000_000_000_000;
        lpDVFUDAT[ 86] = 12'b000_000_000_000;
        lpDVFUDAT[ 87] = 12'b000_000_000_000;
        lpDVFUDAT[ 88] = 12'b000_000_000_000;
        lpDVFUDAT[ 89] = 12'b000_000_000_000;
        lpDVFUDAT[ 90] = 12'b000_000_000_000;
        lpDVFUDAT[ 91] = 12'b000_000_000_000;
        lpDVFUDAT[ 92] = 12'b000_000_000_000;
        lpDVFUDAT[ 93] = 12'b000_000_000_000;
        lpDVFUDAT[ 94] = 12'b000_000_000_000;
        lpDVFUDAT[ 95] = 12'b000_000_000_000;
        lpDVFUDAT[ 96] = 12'b000_000_000_000;
        lpDVFUDAT[ 97] = 12'b000_000_000_000;
        lpDVFUDAT[ 98] = 12'b000_000_000_000;
        lpDVFUDAT[ 99] = 12'b000_000_000_000;
        lpDVFUDAT[100] = 12'b000_000_000_000;
        lpDVFUDAT[101] = 12'b000_000_000_000;
        lpDVFUDAT[102] = 12'b000_000_000_000;
        lpDVFUDAT[103] = 12'b000_000_000_000;
        lpDVFUDAT[104] = 12'b000_000_000_000;
        lpDVFUDAT[105] = 12'b000_000_000_000;
        lpDVFUDAT[106] = 12'b000_000_000_000;
        lpDVFUDAT[107] = 12'b000_000_000_000;
        lpDVFUDAT[108] = 12'b000_000_000_000;
        lpDVFUDAT[109] = 12'b000_000_000_000;
        lpDVFUDAT[110] = 12'b000_000_000_000;
        lpDVFUDAT[111] = 12'b000_000_000_000;
        lpDVFUDAT[112] = 12'b000_000_000_000;
        lpDVFUDAT[113] = 12'b000_000_000_000;
        lpDVFUDAT[114] = 12'b000_000_000_000;
        lpDVFUDAT[115] = 12'b000_000_000_000;
        lpDVFUDAT[116] = 12'b000_000_000_000;
        lpDVFUDAT[117] = 12'b000_000_000_000;
        lpDVFUDAT[118] = 12'b000_000_000_000;
        lpDVFUDAT[119] = 12'b000_000_000_000;
        lpDVFUDAT[120] = 12'b000_000_000_000;
        lpDVFUDAT[121] = 12'b000_000_000_000;
        lpDVFUDAT[122] = 12'b000_000_000_000;
        lpDVFUDAT[123] = 12'b000_000_000_000;
        lpDVFUDAT[124] = 12'b000_000_000_000;
        lpDVFUDAT[125] = 12'b000_000_000_000;
        lpDVFUDAT[126] = 12'b000_000_000_000;
        lpDVFUDAT[127] = 12'b000_000_000_000;
        lpDVFUDAT[128] = 12'b000_000_000_000;
        lpDVFUDAT[129] = 12'b000_000_000_000;
        lpDVFUDAT[130] = 12'b000_000_000_000;
        lpDVFUDAT[131] = 12'b000_000_000_000;
        lpDVFUDAT[132] = 12'b000_000_000_000;
        lpDVFUDAT[133] = 12'b000_000_000_000;
        lpDVFUDAT[134] = 12'b000_000_000_000;
        lpDVFUDAT[135] = 12'b000_000_000_000;
        lpDVFUDAT[136] = 12'b000_000_000_000;
        lpDVFUDAT[137] = 12'b000_000_000_000;
        lpDVFUDAT[138] = 12'b000_000_000_000;
        lpDVFUDAT[139] = 12'b000_000_000_000;
        lpDVFUDAT[140] = 12'b000_000_000_000;
        lpDVFUDAT[141] = 12'b000_000_000_000;
        lpDVFUDAT[142] = 12'b000_000_000_000;
        lpDVFUDAT[143] = 12'b000_000_000_000;
        lpDVFUDAT[144] = 12'b000_000_000_000;
        lpDVFUDAT[145] = 12'b000_000_000_000;
        lpDVFUDAT[146] = 12'b000_000_000_000;
        lpDVFUDAT[147] = 12'b000_000_000_000;
        lpDVFUDAT[148] = 12'b000_000_000_000;
        lpDVFUDAT[149] = 12'b000_000_000_000;
        lpDVFUDAT[150] = 12'b000_000_000_000;
        lpDVFUDAT[151] = 12'b000_000_000_000;
        lpDVFUDAT[152] = 12'b000_000_000_000;
        lpDVFUDAT[153] = 12'b000_000_000_000;
        lpDVFUDAT[154] = 12'b000_000_000_000;
        lpDVFUDAT[155] = 12'b000_000_000_000;
        lpDVFUDAT[156] = 12'b000_000_000_000;
        lpDVFUDAT[157] = 12'b000_000_000_000;
        lpDVFUDAT[158] = 12'b000_000_000_000;
        lpDVFUDAT[159] = 12'b000_000_000_000;
        lpDVFUDAT[160] = 12'b000_000_000_000;
        lpDVFUDAT[161] = 12'b000_000_000_000;
        lpDVFUDAT[162] = 12'b000_000_000_000;
        lpDVFUDAT[163] = 12'b000_000_000_000;
        lpDVFUDAT[164] = 12'b000_000_000_000;
        lpDVFUDAT[165] = 12'b000_000_000_000;
        lpDVFUDAT[166] = 12'b000_000_000_000;
        lpDVFUDAT[167] = 12'b000_000_000_000;
        lpDVFUDAT[168] = 12'b000_000_000_000;
        lpDVFUDAT[169] = 12'b000_000_000_000;
        lpDVFUDAT[170] = 12'b000_000_000_000;
        lpDVFUDAT[171] = 12'b000_000_000_000;
        lpDVFUDAT[172] = 12'b000_000_000_000;
        lpDVFUDAT[173] = 12'b000_000_000_000;
        lpDVFUDAT[174] = 12'b000_000_000_000;
        lpDVFUDAT[175] = 12'b000_000_000_000;
        lpDVFUDAT[176] = 12'b000_000_000_000;
        lpDVFUDAT[177] = 12'b000_000_000_000;
        lpDVFUDAT[178] = 12'b000_000_000_000;
        lpDVFUDAT[179] = 12'b000_000_000_000;
        lpDVFUDAT[180] = 12'b000_000_000_000;
        lpDVFUDAT[181] = 12'b000_000_000_000;
        lpDVFUDAT[182] = 12'b000_000_000_000;
        lpDVFUDAT[183] = 12'b000_000_000_000;
        lpDVFUDAT[184] = 12'b000_000_000_000;
        lpDVFUDAT[185] = 12'b000_000_000_000;
        lpDVFUDAT[186] = 12'b000_000_000_000;
        lpDVFUDAT[187] = 12'b000_000_000_000;
        lpDVFUDAT[188] = 12'b000_000_000_000;
        lpDVFUDAT[189] = 12'b000_000_000_000;
        lpDVFUDAT[190] = 12'b000_000_000_000;
        lpDVFUDAT[191] = 12'b000_000_000_000;
        lpDVFUDAT[192] = 12'b000_000_000_000;
        lpDVFUDAT[193] = 12'b000_000_000_000;
        lpDVFUDAT[194] = 12'b000_000_000_000;
        lpDVFUDAT[195] = 12'b000_000_000_000;
        lpDVFUDAT[196] = 12'b000_000_000_000;
        lpDVFUDAT[197] = 12'b000_000_000_000;
        lpDVFUDAT[198] = 12'b000_000_000_000;
        lpDVFUDAT[199] = 12'b000_000_000_000;
        lpDVFUDAT[200] = 12'b000_000_000_000;
        lpDVFUDAT[201] = 12'b000_000_000_000;
        lpDVFUDAT[202] = 12'b000_000_000_000;
        lpDVFUDAT[203] = 12'b000_000_000_000;
        lpDVFUDAT[204] = 12'b000_000_000_000;
        lpDVFUDAT[205] = 12'b000_000_000_000;
        lpDVFUDAT[206] = 12'b000_000_000_000;
        lpDVFUDAT[207] = 12'b000_000_000_000;
        lpDVFUDAT[208] = 12'b000_000_000_000;
        lpDVFUDAT[209] = 12'b000_000_000_000;
        lpDVFUDAT[210] = 12'b000_000_000_000;
        lpDVFUDAT[211] = 12'b000_000_000_000;
        lpDVFUDAT[212] = 12'b000_000_000_000;
        lpDVFUDAT[213] = 12'b000_000_000_000;
        lpDVFUDAT[214] = 12'b000_000_000_000;
        lpDVFUDAT[215] = 12'b000_000_000_000;
        lpDVFUDAT[216] = 12'b000_000_000_000;
        lpDVFUDAT[217] = 12'b000_000_000_000;
        lpDVFUDAT[218] = 12'b000_000_000_000;
        lpDVFUDAT[219] = 12'b000_000_000_000;
        lpDVFUDAT[220] = 12'b000_000_000_000;
        lpDVFUDAT[221] = 12'b000_000_000_000;
        lpDVFUDAT[222] = 12'b000_000_000_000;
        lpDVFUDAT[223] = 12'b000_000_000_000;
        lpDVFUDAT[224] = 12'b000_000_000_000;
        lpDVFUDAT[225] = 12'b000_000_000_000;
        lpDVFUDAT[226] = 12'b000_000_000_000;
        lpDVFUDAT[227] = 12'b000_000_000_000;
        lpDVFUDAT[228] = 12'b000_000_000_000;
        lpDVFUDAT[229] = 12'b000_000_000_000;
        lpDVFUDAT[230] = 12'b000_000_000_000;
        lpDVFUDAT[231] = 12'b000_000_000_000;
        lpDVFUDAT[232] = 12'b000_000_000_000;
        lpDVFUDAT[233] = 12'b000_000_000_000;
        lpDVFUDAT[234] = 12'b000_000_000_000;
        lpDVFUDAT[235] = 12'b000_000_000_000;
        lpDVFUDAT[236] = 12'b000_000_000_000;
        lpDVFUDAT[237] = 12'b000_000_000_000;
        lpDVFUDAT[238] = 12'b000_000_000_000;
        lpDVFUDAT[239] = 12'b000_000_000_000;
        lpDVFUDAT[240] = 12'b000_000_000_000;
        lpDVFUDAT[241] = 12'b000_000_000_000;
        lpDVFUDAT[242] = 12'b000_000_000_000;
        lpDVFUDAT[243] = 12'b000_000_000_000;
        lpDVFUDAT[244] = 12'b000_000_000_000;
        lpDVFUDAT[245] = 12'b000_000_000_000;
        lpDVFUDAT[246] = 12'b000_000_000_000;
        lpDVFUDAT[247] = 12'b000_000_000_000;
        lpDVFUDAT[248] = 12'b000_000_000_000;
        lpDVFUDAT[249] = 12'b000_000_000_000;
        lpDVFUDAT[250] = 12'b000_000_000_000;
        lpDVFUDAT[251] = 12'b000_000_000_000;
        lpDVFUDAT[252] = 12'b000_000_000_000;
        lpDVFUDAT[253] = 12'b000_000_000_000;
        lpDVFUDAT[254] = 12'b000_000_000_000;
        lpDVFUDAT[255] = 12'b000_000_000_000;
     end

   //
   // Printer handshaking
   //

   reg  lpXON;
   wire lpRXFULL;
   wire [7:0] lpRXDAT;

   //
   // Line printer parity
   //
   //  Parity is only implemented on the LP07 printer and not the LP05, LP14, or
   //  LP26.  This is obviously not implemented correctly here because it fails
   //  DSLPA Test.107
   //
   //  To test this function, execute DSLPA as follows:
   //
   //   DECSYSTEM 2020 LINE PRINTER DIAGNOSTIC [DSLPA]
   //   VERSION 0.7, SV=0.3, CPU#=4097, MCV=130, MCO=470, HO=0, KASW=003740 000000
   //   TTY SWITCH CONTROL ? - 0,S OR Y <CR> - Y
   //
   //   LH SWITCHES <# OR ?> - 0
   //   RH SWITCHES <# OR ?> - 40
   //   SWITCHES = 000000 000040
   //
   //   IS THIS AN LP05, LP14 OR LP26 LINE PRINTER ? Y OR N <CR> - N
   //
   //   IS THIS AN LP07 LINE PRINTER ? Y OR N <CR> - Y
   //
   //   DOES THIS LPT HAVE A DAVFU ? Y OR N <CR> - Y
   //
   //   TYPE ? TO GET FORMAT ON TERMINAL,
   //   TYPE # TO GET FORMAT PRINTED ON THE LPT
   //   COMMANDS: XX OR XX-YY OR A OR D
   //
   //   *107
   //   PC=  034517
   //   SWITCHES = 000000 000040
   //   ERROR IN *LP20 STATIC TESTS* - TEST.107
   //   ERROR BITS INCORRECT WHEN BAD PARITY SENT TO LPT
   //
   //   UBAS    3763100:  000000 000011  HI PIA=1, LO PIA=1
   //   UBARAM  3763000:  PAGE ADDR=60, VALID,
   //   UBARAM  3763001:  PAGE ADDR=61, VALID,
   //   LPCSRA  3775400: 004202  ONLINE, DONE, PARENB,
   //   LPCSRB  3775402: 100100  VDATA, VFUERR,
   //   LPBSAD  3775404: 000001  BUS ADDR = 000001
   //   LPBCTR  3775406: 000000  BYTE CNT = 0
   //   LPPCTR  3775410: 002777  PAGE CNT = 2777
   //   LPRAMD  3775412: 010000  RAM DATA = 10000
   //   LPCBUF  3775414: 000440  CHAR BUF = 40 COL CNT = 1
   //   LPCKSM  3775416: 020040  CKSUM = 40 PRINTER DATA = 40
   //

   assign lpPARERR = ~^{lpDPAR, lpPI, lpDATA};

   //
   // VFU Start Load and Stop Load characters
   //

   localparam [7:0] charSTART1 = 8'o154,        // 6 LPI line spacing
                    charSTART2 = 8'o155,        // 8 LPI line spacing
                    charSTART3 = 8'o156,        // Current line spacing
                    charSTOP   = 8'o157;

   //
   // Line spacing
   //

   always @(posedge clk)
     begin
        if (rst)
          lpSIXLPI <= 1;
        else if (lpSTROBE & lpPI & (lpDATA == charSTART1))
          lpSIXLPI <= 1;
        else if (lpSTROBE & lpPI & (lpDATA == charSTART2))
          lpSIXLPI <= 0;
     end

   //
   // Printer state
   //

   localparam [4:0] stateIDLE      =  0,        // Wait for something to do
                    statePRINT     =  1,        // Print line buffer
                    stateVFUEVEN   =  2,        // Read even byte of VFU program
                    stateVFUODD    =  3,        // Read odd  byte of VFU program
                    stateVFUCHAN   =  4,        // Count channel linefeeds
                    stateVFUVT     =  5,        // Count vertical tab linefeeds
                    stateVFUSLEW   =  6,        // Count slew linefeeds.
                    stateVFUPRINT  =  7,        // VFU print buffer
                    stateVFUMOVE   =  8,        // Send zero or more LFs
                    stateVFUOFFLN  =  9,        // Set VFU offline
                    stateVFUNOTRDY = 10,        // Set VFU not ready
                    stateVFURDY    = 11,        // Set VFU ready
                    stateWAIT      = 12,        // Wait for UART to finish
                    stateDONE      = 13,        // Done
                    stateDLY1      = 14,
                    stateDLY2      = 15,
                    stateDLY3      = 16,
                    stateDLY4      = 17,
                    stateDLY5      = 18,
                    stateDLY6      = 19;

   //
   // Printer state machine
   //

   reg [4:0] state;                             // State variable
   reg [7:0] lpCCTR;                            // Character counter
   reg [6:1] lpTEMP;                            // Temporary byte storage
   reg [7:0] lpLCTR;                            // Line counter
   reg [7:0] lpLFCNT;                           // Nuber of line feeds for vertical motion
   reg [7:0] lpCOUNT;                           // Generic counter for misc things.
   reg [7:0] lpTXDAT;                           // UART transmit data
   reg       lpTXSTB;                           // UART transmit strobe
   wire      lpTXEMPTY;                         // UART is empty.  Send next character.
   reg [7:0] lpLINBUF[0:255];                   // Line buffer
   integer   j;

   always @(posedge clk)
     begin
        if (rst)
          begin
             lpCCTR    <= 0;
             lpLCTR    <= 0;
             lpTEMP    <= 0;
             lpTXSTB   <= 0;
             lpTXDAT   <= 0;
             lpLFCNT   <= 0;
             lpCOUNT   <= 0;
             lpDVFULEN <= 0;
             state     <= stateIDLE;

`ifndef SYNTHESIS
             for (j = 0; j < 256; j = j + 1)
               begin
                  lpLINBUF[j] <= 0;
               end
`endif

          end
        else
          begin

             lpTXSTB <= 0;

             case (state)

               //
               // stateIDLE
               //  Wait for something to do
               //

               stateIDLE:

                 if (lpSTROBE)

                   if (lpPI)

                     //
                     // DVFU operation
                     //

                     case (lpDATA)

                       //
                       // Start VFU load operation
                       //

                       charSTART1,
                       charSTART2,
                       charSTART3:
                         begin
                            lpDVFULEN <= 0;
                            state     <= stateVFUEVEN;
                          end

                        //
                        // Make VFU not ready
                        //

                       charSTOP:
                         state <= stateVFUNOTRDY;

                       //
                       // Print the buffer, print a carriage return, do VFU
                       // motion, and then reset the buffer pointer
                       //

                       default:
                         begin
                            lpLFCNT <= 0;
                            if (`VFU_SLEW(lpDATA))
                              state <= stateVFUSLEW;
                            else if (`VFU_CHAN(lpDATA) < 12)
                              begin
                                 lpCOUNT <= 0;
                                 lpLCTR  <= (lpLCTR == lpVFULEN) ? 8'b0 : lpLCTR + 1'b1;
                                 lpLFCNT <= lpLFCNT + 1'b1;
                                 state   <= stateVFUCHAN;
                              end
                            else
                              state <= stateVFUOFFLN;
                         end

                     endcase

                   else

                     //
                     // Printer operation
                     //

                     case (lpDATA)

                       //
                       // The Null character is ignored.
                       //

                       `asciiNUL:
                         state <= stateWAIT;

                       //
                       // Control characters are converted to spaces then
                       // buffered.
                       //
                       // This is tested by DSLPA TEST.135
                       //

                       `asciiSOH,
                       `asciiSTX,
                       `asciiETX,
                       `asciiEOT,
                       `asciiENQ,
                       `asciiACK,
                       `asciiBEL,
                       `asciiBS,
                       `asciiSO,
                       `asciiSI,
                       `asciiDLE,
                       `asciiDC1,
                       `asciiDC2,
                       `asciiDC3,
                       `asciiDC4,
                       `asciiNAK,
                       `asciiSYN,
                       `asciiETB,
                       `asciiCAN,
                       `asciiEM,
                       `asciiSUB,
                       `asciiESC,
                       `asciiFS,
                       `asciiGS,
                       `asciiRS,
                       `asciiUS,
                       `asciiDEL:
`ifdef IGNORE_CTRL_CHARS
                         state <= stateWAIT;
`else
                         begin
                            lpLINBUF[lpCCTR] <= asciiSP;
                            lpCCTR <= lpCCTR + 1'b1;
                         end
`endif

                       //
                       // A carriage return prints the buffered characters,
                       // prints a carriage return, and resets the buffer
                       // pointer.
                       //
                       // An LP07 will go offline if you overprint a line 8
                       // times without paper motion.  This is tested by
                       // DSLPA TEST.115.  An LP26 will overprint 140 times
                       // before it will declare a fault.  This is not tested
                       // by the diagnostics.
                       //
                       // For now, we do not support LP07-like operation.
                       //

                       `asciiCR:
                           begin
                              lpCOUNT <= 0;
                              state   <= statePRINT;
                           end

                       //
                       // A line feed prints the buffered characters, prints a
                       // line feed, advances the line counter, and resets the
                       // buffer pointer,
                       //

                       `asciiLF:
                         begin
                            lpCOUNT <= 0;
                            lpLCTR  <= (lpLCTR == lpVFULEN) ? 8'b0 : lpLCTR + 1'b1;
                            state   <= statePRINT;
                         end

                       //
                       // A form feed prints the buffered characters, prints a
                       // form feed, resets the line counter which increments
                       // the page counter, and resets the buffer pointer.
                       //

                       `asciiFF:
                         begin
                            lpCOUNT <= 0;
                            lpLCTR  <= 0;
                            state   <= statePRINT;
                         end

                       //
                       // A vertical tab prints the buffered characters, does
                       // the vertical tab, and resets the buffer pointer.
                       //

                       `asciiVT:
                         begin
                            lpLFCNT <= 0;
                            state   <= stateVFUVT;
                         end

                       //
                       // Everything else that is printable is buffered until
                       // a carriage return is received.
                       //

                       default:
                         begin
                            lpLINBUF[lpCCTR] <= lpDATA;
                            lpCCTR <= lpCCTR + 1'b1;
                         end

                     endcase

               //
               // statePRINT
               //  Print the line buffer.
               //  Send the character in lpDATA after the line is printed.
               //

               statePRINT:
                 begin
                    if (lpTXEMPTY & lpXON)
                      if (lpCOUNT == lpCCTR)
                        begin
                           lpCCTR  <= 0;
                           lpCOUNT <= 0;
                           lpTXSTB <= 1;
                           lpTXDAT <= lpDATA;
                           state   <= stateWAIT;
                        end
                      else
                        begin
                           lpTXSTB <= 1;
                           lpTXDAT <= lpLINBUF[lpCOUNT];
                           lpCOUNT <= lpCOUNT + 1'b1;
                           state   <= stateDLY1;
                        end
                 end

               stateDLY1:
                 state <= statePRINT;

               //
               // stateVFUEVEN
               //  Read the first byte of VFU data.  Save it for later.  This
               //  'byte' has the data for channels 1 through 6.
               //
               //  The start/stop characters will have the PI bit asserted. The
               //  DAVFU data will not have the PI bit asserted.
               //
               //  Receiving s START character in this state will discard the
               //  previously sent DAVFU data and begin loading the DAVFU
               //  again.
               //
               //  Receiving a STOP character in this state is valid only if
               //  another data word was received first - check the count.
               //

               stateVFUEVEN:
                 if (lpSTROBE)
                   if ((lpPI & (lpDATA == charSTART1)) |
                       (lpPI & (lpDATA == charSTART2)) |
                       (lpPI & (lpDATA == charSTART3)))
                     begin
                        lpDVFULEN <= 0;
                        state     <= stateVFUEVEN;
                     end
                   else if (lpPI & (lpDATA == charSTOP))
                     if (lpDVFULEN == 0)
                       state <= stateVFUNOTRDY;
                     else
                       state <= stateVFURDY;
                   else
                     begin
                        lpTEMP <= lpDATA[6:1];
                        state  <= stateVFUODD;
                     end

               //
               // stateVFUODD
               //  Read the second byte of VFU data.  Form the word from the two
               //  bytes and store it in the next location of DVFU RAM.
               //
               //  The start/stop character will have the PI bit asserted.
               //  DAVFU data will not have the PI bit asserted.
               //
               //  If the VFU is overrun (more than 143 lines), the printer is
               //  taken offline and will report that the DAVFU is not ready.
               //
               //  Receiving s START character in this state will discard the
               //  previously sent DAVFU data and begin loading the DAVFU
               //  again.
               //
               //  Receiving a STOP character in this state is never valid. In
               //  this case, the printer is taken offline and the DAVFU
               //  reports that it is not ready.
               //
               //  The VFU length limit of 143 is tested by DSLPA TEST.112
               //

               stateVFUODD:
                 if (lpSTROBE)
                   if ((lpPI & (lpDATA == charSTART1)) |
                       (lpPI & (lpDATA == charSTART2)) |
                       (lpPI & (lpDATA == charSTART3)))
                     begin
                        lpDVFULEN <= 0;
                        state     <= stateVFUEVEN;
                     end
                   else if (lpPI & (lpDATA == charSTOP))
                     state <= stateVFUOFFLN;
                   else if (lpDVFULEN == 143)
                     state <= stateVFUOFFLN;
                   else
                     begin
                        lpDVFUDAT[lpDVFULEN] <= {lpDATA[6:1], lpTEMP};
                        lpDVFULEN <= lpDVFULEN + 1'b1;
                        state <= stateVFUEVEN;
                     end

               //
               // stateVFUCHAN
               //  Count the number of linefeeds to move to the next channel
               //  marker.
               //
               //  This state doesn't actually print any linefeeds even though
               //  we update the line counter (lpLCTR).
               //
               //  We count the linefeeds and watch for overrun errors
               //  like this because the diagnostic software doesn't wait
               //  long enough to let us count the LFs as we send them.  See
               //  DSLPA TEST.114
               //

               stateVFUCHAN:
                 if (lpCOUNT == lpVFULEN)
                   state <= stateVFUOFFLN;
                 else
                   if (lpVFUMATCH(lpOVFU ? lpOVFUDAT[lpLCTR] : lpDVFUDAT[lpLCTR], lpDATA))
                     begin
                        lpCOUNT <= 0;
                        state   <= stateVFUPRINT;
                     end
                   else
                     begin
                        lpLCTR  <= (lpLCTR == lpVFULEN) ? 8'b0 : lpLCTR + 1'b1;
                        lpLFCNT <= lpLFCNT + 1'b1;
                        lpCOUNT <= lpCOUNT + 1'b1;
                        state   <= stateDLY2;
                     end

               stateDLY2:
                 state <= stateVFUCHAN;

               //
               // stateVFUVT
               //  Handle vertical tabs.  Vertical tabs are VFU channel 2.
               //
               //  This state doesn't actually print any linefeeds.
               //
               //  We count the linefeeds and watch for overrun errors
               //  like this because the software doesn't wait long enough to
               //  let us count the LFs as we send them.  See DSLPA TEST.114
               //

               stateVFUVT:
                 if (lpCOUNT == lpVFULEN)
                   state <= stateVFUOFFLN;
                 else
                   if (lpVFUMATCH(lpOVFU ? lpOVFUDAT[lpLCTR] : lpDVFUDAT[lpLCTR], 8'd1))
                     begin
                        lpCOUNT <= 0;
                        state   <= stateVFUPRINT;
                     end
                   else
                     begin
                        lpLCTR  <= (lpLCTR == lpVFULEN) ? 8'b0 : lpLCTR + 1'b1;
                        lpLFCNT <= lpLFCNT + 1'b1;
                        lpCOUNT <= lpCOUNT + 1'b1;
                        state   <= stateDLY3;
                     end

               stateDLY3:
                 state <= stateVFUVT;

               //
               // stateVFUSLEW
               //  We already know how many linefeeds but we still need to
               //  check for overrun errors.
               //

               stateVFUSLEW:
                 begin
                    lpLCTR  <= (lpLCTR == lpVFULEN) ? 8'b0 : lpLCTR + 1'b1;
                    lpLFCNT <= lpLFCNT + 1'b1;
                    if (lpLFCNT == `VFU_CHAN(lpDATA))
                      begin
                         lpCOUNT <= 0;
                         state   <= stateVFUPRINT;
                      end
                    else
                      state <= stateDLY4;
                 end

               stateDLY4:
                 state <= stateVFUSLEW;

               //
               // stateVFUPRINT
               //  Print the character buffer and then print a carriage
               //  return.
               //

               stateVFUPRINT:
                 if (lpTXEMPTY & lpXON)
                   if (lpCOUNT == lpCCTR)
                     begin
                        lpCCTR  <= 0;
                        lpCOUNT <= 0;
                        lpTXSTB <= 1;
                        lpTXDAT <= `asciiCR;
                        state   <= stateVFUMOVE;
                     end
                   else
                     begin
                        lpTXSTB <= 1;
                        lpTXDAT <= lpLINBUF[lpCOUNT];
                        lpCOUNT <= lpCOUNT + 1'b1;
                        state   <= stateDLY5;
                     end

               stateDLY5:
                 state <= stateVFUPRINT;

               //
               // stateVFUMOVE
               //  Move the printer vertically.
               //

               stateVFUMOVE:
                 if (lpTXEMPTY & lpXON)
                   if (lpLFCNT == 0)
                     state <= stateWAIT;
                   else
                     begin
                        lpTXSTB <= 1;
                        lpTXDAT <= `asciiLF;
                        lpLFCNT <= lpLFCNT - 1'b1;
                        state   <= stateDLY6;
                     end

               stateDLY6:
                 state <= stateVFUMOVE;

               //
               // stateVFUOFFLN
               //  Take the printer off-line, then make VFU not ready.
               //

               stateVFUOFFLN:
                 begin
                    lpCCTR  <= 0;
                    lpCOUNT <= 0;
                    lpLFCNT <= 0;
                    state   <= stateVFUNOTRDY;
                 end

               //
               // stateVFUNOTRDY
               //  Make DVFU not ready
               //

               stateVFUNOTRDY:
                 state <= stateWAIT;

               //
               // stateVFURDY
               //

               stateVFURDY:
                 begin
                    lpLCTR    <= 0;
                    lpDVFULEN <= lpDVFULEN - 1'b1;
                    state     <= stateWAIT;
                 end

               //
               //  Wait for UART to finish
               //

               stateWAIT:
                 if (lpTXEMPTY)
                   state <= stateDONE;

               //
               // stateDONE
               //  Get ready for next character
               //

               stateDONE:
                 state <= stateIDLE;

             endcase

          end
     end

   //
   // VFU ready
   //
   // VFU is always ready when using an OVFU
   //
   // Trace
   //  M8587/LPD6/E11
   //  M8587/LPD6/E50
   //  M8587/LPD6/E66
   //  M8587/LPD6/E74
   //

   always @(posedge clk)
     begin
        if (rst)
          lpVFURDY <= 0;
        else if (lpOVFU)
          lpVFURDY <= 1;
        else if (state == stateVFUNOTRDY)
          lpVFURDY <= 0;
        else if (state == stateVFURDY)
          lpVFURDY <= 1;
     end

   assign lpSETOFFLN = (state == stateVFUOFFLN);

   //
   // Software handshaking to printer
   //

   always @(posedge clk)
     begin
        if (rst | lpINIT)
          lpXON <= 1;
        else
          if (lpRXFULL)
            if (lpRXDAT == `asciiXON)
              lpXON <= 1;
            else if (lpRXDAT == `asciiXOFF)
              lpXON <= 0;
     end

   //
   // lpDEMAND
   //  Ready to receive next character.
   //

   assign lpDEMAND = ((!lpSTROBE & (state == stateIDLE   )) |
                      (!lpSTROBE & (state == stateVFUEVEN)) |
                      (!lpSTROBE & (state == stateVFUODD )));

   //
   // lpTOF
   //  Printer is at top-of-form
   //

   wire lpLINE0 = (lpLCTR == 0);

   reg lastLINE0;
   always @(posedge clk)
     begin
        if (rst)
          lastLINE0 <= 1;
        else
          lastLINE0 <= lpLINE0;
     end

   assign lpTOF = lpLINE0 & !lastLINE0;

   //
   // UART Baud Rate Generator
   //

   wire clken;

   UART_BRG ttyBRG (
      .clk     (clk),
      .rst     (rst),
      .speed   (lpCONFIG[6:10]),
      .clken   (clken)
   );

   //
   // UART Transmitter
   //  Data is adjusted to 7 bits before transmitting.
   //

   UART_TX TX (
       .clk    (clk),
       .rst    (rst),
       .clr    (1'b0),
       .clken  (clken),
       .length (lpCONFIG[11:12]),
       .parity (lpCONFIG[13:14]),
       .stop   (lpCONFIG[15]),
       .load   (lpTXSTB),
       .data   ({1'b0, lpTXDAT[6:0]}),
       .empty  (lpTXEMPTY),
       .intr   (),
       .txd    (lpTXD)
   );

   //
   // UART receiver
   //  The receiver is used for XON/XOFF handshaking

   UART_RX RX (
       .clk    (clk),
       .rst    (rst),
       .clr    (1'b0),
       .clken  (clken),
       .length (lpCONFIG[11:12]),
       .parity (lpCONFIG[13:14]),
       .stop   (lpCONFIG[15]),
       .rxd    (lpRXD),
       .rfull  (1'b0),
       .full   (),
       .intr   (lpRXFULL),
       .data   (lpRXDAT),
       .pare   (),
       .frme   (),
       .ovre   ()
   );

endmodule
