////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   UART Baud Rate Generator
//
// Details
//   This module provides a baud rate generator for use by the UART transmitter
//   and the UART receiver modules.   It is implemented using a Fractional N
//   divider instead of a counter so that the frequencier are more accurate -
//   especially the higher frequencies.
//
// File
//   uart_brg.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2022 Rob Doyle
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

`include "uart.vh"

//
// Clock frequency.
//
//  The macro CLKFRQ must be set properly to acheive the proper baud rates.
//  We modify the clock rate under simulation to speed the simulation up.
//

`ifdef SYNTHESIS
   `define CLOCKFRQ (`CLKFRQ)
`else
   `define CLOCKFRQ ((`CLKFRQ)/25)
`endif

module UART_BRG (
      input  wire       clk,            // Clock
      input  wire       rst,            // Reset
      input  wire [4:0] speed,          // Speed Select
      output wire       clken           // UART Clock Enable
   );

   //
   // The first 16 baud rates are compatible with the DZ11.  The second 16
   // baud rates are extensions that I've made.
   //

   localparam [63:0] INCR_00 = ((2.0**32.0) * `CLKDIV *     50.0 / `CLOCKFRQ + 0.5);        //  0
   localparam [63:0] INCR_01 = ((2.0**32.0) * `CLKDIV *     75.0 / `CLOCKFRQ + 0.5);        //  1
   localparam [63:0] INCR_02 = ((2.0**32.0) * `CLKDIV *    110.0 / `CLOCKFRQ + 0.5);        //  2
   localparam [63:0] INCR_03 = ((2.0**32.0) * `CLKDIV *    134.5 / `CLOCKFRQ + 0.5);        //  3
   localparam [63:0] INCR_04 = ((2.0**32.0) * `CLKDIV *    150.0 / `CLOCKFRQ + 0.5);        //  4
   localparam [63:0] INCR_05 = ((2.0**32.0) * `CLKDIV *    300.0 / `CLOCKFRQ + 0.5);        //  5
   localparam [63:0] INCR_06 = ((2.0**32.0) * `CLKDIV *    600.0 / `CLOCKFRQ + 0.5);        //  6
   localparam [63:0] INCR_07 = ((2.0**32.0) * `CLKDIV *   1200.0 / `CLOCKFRQ + 0.5);        //  7
   localparam [63:0] INCR_08 = ((2.0**32.0) * `CLKDIV *   1800.0 / `CLOCKFRQ + 0.5);        //  8
   localparam [63:0] INCR_09 = ((2.0**32.0) * `CLKDIV *   2000.0 / `CLOCKFRQ + 0.5);        //  9
   localparam [63:0] INCR_10 = ((2.0**32.0) * `CLKDIV *   2400.0 / `CLOCKFRQ + 0.5);        // 10
   localparam [63:0] INCR_11 = ((2.0**32.0) * `CLKDIV *   3600.0 / `CLOCKFRQ + 0.5);        // 11
   localparam [63:0] INCR_12 = ((2.0**32.0) * `CLKDIV *   4800.0 / `CLOCKFRQ + 0.5);        // 12
   localparam [63:0] INCR_13 = ((2.0**32.0) * `CLKDIV *   7200.0 / `CLOCKFRQ + 0.5);        // 13
   localparam [63:0] INCR_14 = ((2.0**32.0) * `CLKDIV *   9600.0 / `CLOCKFRQ + 0.5);        // 14
   localparam [63:0] INCR_15 = ((2.0**32.0) * `CLKDIV *  19200.0 / `CLOCKFRQ + 0.5);        // 15
   localparam [63:0] INCR_16 = ((2.0**32.0) * `CLKDIV *  38400.0 / `CLOCKFRQ + 0.5);        // 16
   localparam [63:0] INCR_17 = ((2.0**32.0) * `CLKDIV *  57600.0 / `CLOCKFRQ + 0.5);        // 17
   localparam [63:0] INCR_18 = ((2.0**32.0) * `CLKDIV * 115200.0 / `CLOCKFRQ + 0.5);        // 18
   localparam [63:0] INCR_19 = ((2.0**32.0) * `CLKDIV * 230400.0 / `CLOCKFRQ + 0.5);        // 19
   localparam [63:0] INCR_20 = ((2.0**32.0) * `CLKDIV * 460800.0 / `CLOCKFRQ + 0.5);        // 20
   localparam [63:0] INCR_21 = ((2.0**32.0) * `CLKDIV * 921600.0 / `CLOCKFRQ + 0.5);        // 21

   //
   // Fractional N increment ROM
   //

   reg [0:31] incr;

   always @(posedge clk)
     begin
        case (speed)
          `UARTBR_50     : incr = INCR_00[31:0];     //  0
          `UARTBR_75     : incr = INCR_01[31:0];     //  1
          `UARTBR_110    : incr = INCR_02[31:0];     //  2
          `UARTBR_134    : incr = INCR_03[31:0];     //  3
          `UARTBR_150    : incr = INCR_04[31:0];     //  4
          `UARTBR_300    : incr = INCR_05[31:0];     //  5
          `UARTBR_600    : incr = INCR_06[31:0];     //  6
          `UARTBR_1200   : incr = INCR_07[31:0];     //  7
          `UARTBR_1800   : incr = INCR_08[31:0];     //  8
          `UARTBR_2000   : incr = INCR_09[31:0];     //  9
          `UARTBR_2400   : incr = INCR_10[31:0];     // 10
          `UARTBR_3600   : incr = INCR_11[31:0];     // 11
          `UARTBR_4800   : incr = INCR_12[31:0];     // 12
          `UARTBR_7200   : incr = INCR_13[31:0];     // 13
          `UARTBR_9600   : incr = INCR_14[31:0];     // 14
          `UARTBR_19200  : incr = INCR_15[31:0];     // 15
          `UARTBR_38400  : incr = INCR_16[31:0];     // 16
          `UARTBR_57600  : incr = INCR_17[31:0];     // 17
          `UARTBR_115200 : incr = INCR_18[31:0];     // 18
          `UARTBR_230400 : incr = INCR_19[31:0];     // 19
          `UARTBR_460800 : incr = INCR_20[31:0];     // 20
          `UARTBR_921600 : incr = INCR_21[31:0];     // 21
          default        : incr = INCR_14[31:0];     // 22-31
        endcase
     end

   //
   // Fractional N divider
   //

   reg  [0:31] accum;
   reg         carry;

   always @(posedge clk)
     begin
        if (rst)
          {carry, accum} <= 33'b0;
        else
          {carry, accum} <= {1'b0, accum} + {1'b0, incr};
     end

   //
   // Create output signal
   //

   assign clken = carry;

endmodule
