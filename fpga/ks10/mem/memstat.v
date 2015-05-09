////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Memory Status Register
//
// Details
//   This module implements the KS10 Memory Status Register.
//
//   Memory Status Register Write (IO addresses o100000)
//
//           0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17
//          +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//    (LH)  |EH|UE|RE|PE|EE|                    |PF| 0|           |
//          +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//
//          18 19 20 21 22 23 24 25 26 27  28 29 30 31 32 33 34 35
//          +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//    (RH)  |                             |       FCB          |ED|
//          +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//
//   Memory Status Register Read (IO addresses o100000)
//
//           0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17
//          +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//    (LH)  |EH|UE|RE|PE|EE|         ECP        |PF| 0|   ERA     |
//          +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//
//           18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
//          +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//    (RH)  |                     ERA                             |
//          +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//
//   EH  : Error Hold          - Always read as 0.  Writes ignored.
//   UE  : Uncorrectable Error - Always read as 0.  Writes ignored.
//   RE  : Refresh Error       - Always read as 0.  Writes ignored.
//   PE  : Parity Error        - Read/Writes PE bit.
//   EE  : ECC Enable          - Reads back inverse value set by write to the
//                               ED bit.  Writes ignored. See ED bit below.
//   ECP : ECC Parity          - Always read as 0.  Writes ignored.
//   PF  : Power Failure       - Initialized to 1 at power-up.  Cleared by
//                               writing 0.
//   ERA : Error Read Address  - Always read as 0.  Writes ignored.
//   FCB : Force Check Bits    - Always read as 0.  Writes ignored.
//   ED  : ECC Disable         - Always read as 0.  Writing zero sets EE bit,
//                               Writing one clears EE bit.
//
// File
//   memstat.v
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

`include "memstat.vh"

module MEMSTAT (
      input  wire        clk,                   // Clock
      input  wire        rst,                   // Reset
      input  wire [0:35] busDATAI,              // Bus data
      input  wire        msrWRITE,              // Write to MSR
      output wire [0:35] regSTAT                // Status Register
   );

   //
   // Memory Status Register Parity Error (PE) bit
   //
   // The Parity Error bit is read/write but does nothing.
   //
   // Trace
   //  MMC5/E45
   //  MMC5/E46
   //  MMC5/E54
   //  MMC5/E62
   //

   reg statPE;

   always @(negedge clk or posedge rst)
     begin
        if (rst)
          statPE <= 0;
        else
          if (msrWRITE)
            statPE <= `memSTAT_PE(busDATAI);
     end

   //
   // Memory Status Register Power Fail (PF) bit
   //
   // The Power Fail bit is initialized to 1 at power-up.  Writing a 0 clears
   // the power fail indication.
   //
   // Trace
   //   MMC5/E58
   //   MMC5/E51
   //   MMC5/E57
   //   MMC5/E61
   //

   reg statPF;

   always @(negedge clk or posedge rst)
     begin
        if (rst)
          statPF <= 1'b1;
        else
          if (msrWRITE)
            statPF <= statPF & `memSTAT_PF(busDATAI);
     end

   //
   // Memory Status Register ECC Enable (EE) bit
   //
   // Trace
   //  MMC5/E90
   //  MMC3/E131
   //

   reg statEE;

   always @(negedge clk or posedge rst)
     begin
        if (rst)
          statEE <= 1'b1;
        else
          if (msrWRITE)
            statEE <= !`memSTAT_ED(busDATAI);
     end

   //
   // Build Memory Status Register
   //

   assign regSTAT = {3'b0, statPE, statEE, 7'b0, statPF, 23'b0};

endmodule
