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
// Copyright (C) 2012-2017 Rob Doyle
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
`include "../../ks10.vh"

module UART_BRG (
      input  wire       clk,            // Clock
      input  wire       rst,            // Reset
      input  wire [4:0] speed,          // Speed Select
      output wire       clken           // UART Clock Enable
   );

   //
   // Divider constants
   //

   parameter  CLKFRQ = `CLKFRQ;         // Clock frequency
   localparam CLKDIV = `CLKDIV;         // 16x Clock

   //
   // Fractional N increment ROM
   //

   reg [0:31] rom[0:31];

   initial
     begin

        rom[    `UARTBR_50] = $rtoi((2.0**32.0) * CLKDIV *     50.0 / CLKFRQ + 0.5);    // 0
        rom[    `UARTBR_75] = $rtoi((2.0**32.0) * CLKDIV *     75.0 / CLKFRQ + 0.5);    // 1
        rom[   `UARTBR_110] = $rtoi((2.0**32.0) * CLKDIV *    110.0 / CLKFRQ + 0.5);    // 2
        rom[   `UARTBR_134] = $rtoi((2.0**32.0) * CLKDIV *    134.5 / CLKFRQ + 0.5);    // 3
        rom[   `UARTBR_150] = $rtoi((2.0**32.0) * CLKDIV *    150.0 / CLKFRQ + 0.5);    // 4
        rom[   `UARTBR_300] = $rtoi((2.0**32.0) * CLKDIV *    300.0 / CLKFRQ + 0.5);    // 5
        rom[   `UARTBR_600] = $rtoi((2.0**32.0) * CLKDIV *    600.0 / CLKFRQ + 0.5);    // 6
        rom[  `UARTBR_1200] = $rtoi((2.0**32.0) * CLKDIV *   1200.0 / CLKFRQ + 0.5);    // 7
        rom[  `UARTBR_1800] = $rtoi((2.0**32.0) * CLKDIV *   1800.0 / CLKFRQ + 0.5);    // 8
        rom[  `UARTBR_2000] = $rtoi((2.0**32.0) * CLKDIV *   2000.0 / CLKFRQ + 0.5);    // 9
        rom[  `UARTBR_2400] = $rtoi((2.0**32.0) * CLKDIV *   2400.0 / CLKFRQ + 0.5);    // 10
        rom[  `UARTBR_3600] = $rtoi((2.0**32.0) * CLKDIV *   3600.0 / CLKFRQ + 0.5);    // 11
        rom[  `UARTBR_4800] = $rtoi((2.0**32.0) * CLKDIV *   4800.0 / CLKFRQ + 0.5);    // 12
        rom[  `UARTBR_7200] = $rtoi((2.0**32.0) * CLKDIV *   7200.0 / CLKFRQ + 0.5);    // 13
        rom[  `UARTBR_9600] = $rtoi((2.0**32.0) * CLKDIV *   9600.0 / CLKFRQ + 0.5);    // 14
        rom[ `UARTBR_19200] = $rtoi((2.0**32.0) * CLKDIV *  19200.0 / CLKFRQ + 0.5);    // 15
        rom[ `UARTBR_38400] = $rtoi((2.0**32.0) * CLKDIV *  38400.0 / CLKFRQ + 0.5);    // 16
        rom[ `UARTBR_57600] = $rtoi((2.0**32.0) * CLKDIV *  57600.0 / CLKFRQ + 0.5);    // 17
        rom[`UARTBR_115200] = $rtoi((2.0**32.0) * CLKDIV * 115200.0 / CLKFRQ + 0.5);    // 18
        rom[`UARTBR_230400] = $rtoi((2.0**32.0) * CLKDIV * 230400.0 / CLKFRQ + 0.5);    // 19
        rom[`UARTBR_460800] = $rtoi((2.0**32.0) * CLKDIV * 460800.0 / CLKFRQ + 0.5);    // 20
        rom[`UARTBR_921600] = $rtoi((2.0**32.0) * CLKDIV * 921600.0 / CLKFRQ + 0.5);    // 21
        rom[            22] = $rtoi((2.0**32.0) * CLKDIV *   9600.0 / CLKFRQ + 0.5);    // 22
        rom[            23] = $rtoi((2.0**32.0) * CLKDIV *   9600.0 / CLKFRQ + 0.5);    // 23
        rom[            24] = $rtoi((2.0**32.0) * CLKDIV *   9600.0 / CLKFRQ + 0.5);    // 24
        rom[            25] = $rtoi((2.0**32.0) * CLKDIV *   9600.0 / CLKFRQ + 0.5);    // 25
        rom[            26] = $rtoi((2.0**32.0) * CLKDIV *   9600.0 / CLKFRQ + 0.5);    // 26
        rom[            27] = $rtoi((2.0**32.0) * CLKDIV *   9600.0 / CLKFRQ + 0.5);    // 27
        rom[            28] = $rtoi((2.0**32.0) * CLKDIV *   9600.0 / CLKFRQ + 0.5);    // 28
        rom[            29] = $rtoi((2.0**32.0) * CLKDIV *   9600.0 / CLKFRQ + 0.5);    // 29
        rom[            30] = $rtoi((2.0**32.0) * CLKDIV *   9600.0 / CLKFRQ + 0.5);    // 30
        rom[            31] = $rtoi((2.0**32.0) * CLKDIV *   9600.0 / CLKFRQ + 0.5);    // 31

     end

   //
   // Lookup fraction from table
   //

   wire [0:31] incr = rom[speed];

   //
   // Fractional N divider
   //

   reg  [0:31] accum;
   reg         carry;

   always @(posedge clk or posedge rst)
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
