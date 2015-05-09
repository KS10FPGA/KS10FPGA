////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KS10 IO Bus Bridge Paging
//
// Details
//   This module implements the KS10 IO Bus Bridge paging.
//
// IO Bus Bridge Pager:
//
//   The page table translates IO Bridge addresses to phyical addresses.  There
//   are 64 virtual pages which map to 2048 physical pages.
//
//   The IO Bridge Paging RAM is 64x15 bits.
//
//   The implementation is different than the KS10 implementation. I have
//   chosen to use a Dual Port RAM which allows the KS10 bus interface to be
//   implemented on one port (Read/Write) and the IO Bridge Paging to be
//   implemented on the second port (Read-only).
//
//   This saves a whole ton of multiplexers and uses some free DPRAM.
//
//   The IO Bridge addressing was little endian.  This has all been converted
//   to big-endian to keep things consistent.
//
//            18 19                24 25                33 34 35
//          +--+--------------------+--------------------+--+--+
//          | 0| Virtual Page Number|      Word Number   |W | B|
//          +--+--------------------+--------------------+--+--+
//                      |6                      |9
//                      |                       |
//                     \ /                      |
//              +-------+-------+               |
//              |      Page     |               |
//              |  Translation  |               |
//              +-------+-------+               |
//                      |                       |
//                      |                       |
//                     \ /11                   \ /9
//          +------------------------+-------------------------+
//          |  Physical Page Number  |        Word Number      |
//          +------------------------+-------------------------+
//           16                    26 27                     35
//
//   Paging RAM Write
//
//            0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17
//          +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
//    (LH)  |                                                                       |
//          +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
//
//           18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35
//          +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
//    (RH)  |RPW|E16|FTM|VLD| 0 | 0 | 0 |                    PPN                    |
//          +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
//
//   Paging RAM Read
//
//            0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17
//          +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
//    (LH)  |               | 0 |RPW|E16|FTM|VLD|                           |  PPN  |
//          +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
//
//           18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35
//          +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
//    (RH)  |           PPN (cont)          |                                       |
//          +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
//
//   Paging RAM Internal Format:
//
//            0   1   2   3   4   5   6   7   8   9  10  11  12  13  14
//          +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
//          |RPW|E16|FTM|VLD|                PPN                        |
//          +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
//
//   Paging RAM Definitions
//
//      RPW : Force Read-Pause-Write (AKA Read Reverse in the documents).
//      E16 : Enable 16-bit IO Bridge Transfers.  Disable 18-bit IO Bridge
//            transfers.
//      FTM : Fast Transfer Mode.  In this mode, both odd and even words of IO
//            Bridge data are transferred during a single KS10 memory operation
//            (i.e., all 36 bits).
//      VLD : Page valid.  This bit is set to one when the page data is loaded.
//      PPN : Physical Page Number.
//
// File
//      ubapage.v
//
// Author
//      Rob Doyle - doyle (at) cox (dot) net
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

`include "uba.vh"
`include "ubapage.vh"
`include "../ks10.vh"

module UBAPAGE (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire         busREQO,              // IO Device Request In
      input  wire [ 0:35] busADDRI,             // KS10 Bus Address In
      input  wire [ 0:35] busDATAI,             // KS10 Bus Data In
      output wire [ 0:35] busADDRO,             // KS10 Bus Address Out (paged)
      input  wire         pageWRITE,            // Page RAM write
      output wire [ 0:35] pageDATAO,            // Paging RAM Data Out
      input  wire [ 0:35] pageADDRI,            // IO Device Address In
      output wire [ 0: 3] pageFLAGS,            // Page flags
      output wire         pageFAIL              // Page NXM
   );

   //
   // Paging addresses
   //

   wire [0:5] virtPAGE = pageADDRI[19:24];      // Address from device
   wire [0:5] pageADDR = busADDRI[30:35];       // Address from KS10

   //
   // UBA Paging RAM
   //

   reg [0:14] pageRAM[0:63];
   always @(negedge clk)
     begin
        if (pageWRITE)
          pageRAM[pageADDR] <= {busDATAI[18:21], busDATAI[25:35]};
     end

   assign pageDATAO = {5'b0, pageRAM[pageADDR][0:3], 7'b0, pageRAM[pageADDR][4:14], 9'b0};

   //
   // IO Bus Paging
   //  ADDR Flags were already added by the device
   //

   assign busADDRO  = {pageADDRI[0:15], pageRAM[virtPAGE][4:14], pageADDRI[25:33]};
   assign pageFLAGS = pageRAM[virtPAGE][0:3];

   //
   // NXM generated when:
   //   - UBA A17 not zero
   //   - Page not valid
   //

   assign pageFAIL = ((busREQO & pageADDRI[18]) |
                      (busREQO & !`flagsVLD(pageFLAGS)));

endmodule
