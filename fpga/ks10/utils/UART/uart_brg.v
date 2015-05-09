////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DZ11 UART Baud Rate Generator
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

`include "../dzuart.vh"
`include "../../../ks10.vh"

module UART_BRG (
      input  wire       clk,                    // Clock
      input  wire       rst,                    // Reset
      input  wire [3:0] speed,                  // Speed Select
      output wire       brgCLKEN                // BRG Clock Enable
   );

   //
   // Divider constants
   //

   localparam CLKFRQ = `CLKFRQ;                 // Clock frequency
   localparam CLKDIV = `CLKDIV;                 // 16x Clock

   //
   // Fractional N increment ROM
   //

   reg [0:31] rom[0:15];

   initial
     begin

`ifdef SYNTHESIS

        //
        // This table is for synthesis.  The fraction is rounded to
        // the nearest integer
        //

        rom[    `UARTBR_50] = $rtoi((2.0**32.0) * CLKDIV *     50.0 / CLKFRQ + 0.5);
        rom[    `UARTBR_75] = $rtoi((2.0**32.0) * CLKDIV *     75.0 / CLKFRQ + 0.5);
        rom[   `UARTBR_110] = $rtoi((2.0**32.0) * CLKDIV *    110.0 / CLKFRQ + 0.5);
        rom[   `UARTBR_134] = $rtoi((2.0**32.0) * CLKDIV *    134.5 / CLKFRQ + 0.5);
        rom[   `UARTBR_150] = $rtoi((2.0**32.0) * CLKDIV *    150.0 / CLKFRQ + 0.5);
        rom[   `UARTBR_300] = $rtoi((2.0**32.0) * CLKDIV *    300.0 / CLKFRQ + 0.5);
        rom[   `UARTBR_600] = $rtoi((2.0**32.0) * CLKDIV *    600.0 / CLKFRQ + 0.5);
        rom[  `UARTBR_1200] = $rtoi((2.0**32.0) * CLKDIV *   1200.0 / CLKFRQ + 0.5);
        rom[  `UARTBR_1800] = $rtoi((2.0**32.0) * CLKDIV *   1800.0 / CLKFRQ + 0.5);
        rom[  `UARTBR_2000] = $rtoi((2.0**32.0) * CLKDIV *   2000.0 / CLKFRQ + 0.5);
        rom[  `UARTBR_2400] = $rtoi((2.0**32.0) * CLKDIV *   2400.0 / CLKFRQ + 0.5);
        rom[  `UARTBR_3600] = $rtoi((2.0**32.0) * CLKDIV *   3600.0 / CLKFRQ + 0.5);
        rom[  `UARTBR_4800] = $rtoi((2.0**32.0) * CLKDIV *   4800.0 / CLKFRQ + 0.5);
        rom[  `UARTBR_7200] = $rtoi((2.0**32.0) * CLKDIV *   7200.0 / CLKFRQ + 0.5);
        rom[  `UARTBR_9600] = $rtoi((2.0**32.0) * CLKDIV *   9600.0 / CLKFRQ + 0.5);
        rom[`UARTBR_115200] = $rtoi((2.0**32.0) * CLKDIV * 115200.0 / CLKFRQ + 0.5);

`else

        //
        // This table is for simulation.  The baud rates are hacked to
        // speed up the simulation.  The DSDZA diagnostic expects the
        // baud rate to increase monotonically.  Tests with slower
        // data rates should take longer than tests with faster data
        // rates.
        //

        rom[    `UARTBR_50] = $rtoi((2.0**32.0) * CLKDIV *  14865.0 / CLKFRQ + 0.5);
        rom[    `UARTBR_75] = $rtoi((2.0**32.0) * CLKDIV *  17677.0 / CLKFRQ + 0.5);
        rom[   `UARTBR_110] = $rtoi((2.0**32.0) * CLKDIV *  21020.0 / CLKFRQ + 0.5);
        rom[   `UARTBR_134] = $rtoi((2.0**32.0) * CLKDIV *  25000.0 / CLKFRQ + 0.5);
        rom[   `UARTBR_150] = $rtoi((2.0**32.0) * CLKDIV *  30050.0 / CLKFRQ + 0.5);
        rom[   `UARTBR_300] = $rtoi((2.0**32.0) * CLKDIV *  35300.0 / CLKFRQ + 0.5);
        rom[   `UARTBR_600] = $rtoi((2.0**32.0) * CLKDIV *  42000.0 / CLKFRQ + 0.5);
        rom[  `UARTBR_1200] = $rtoi((2.0**32.0) * CLKDIV *  50000.0 / CLKFRQ + 0.5);
        rom[  `UARTBR_1800] = $rtoi((2.0**32.0) * CLKDIV *  60000.0 / CLKFRQ + 0.5);
        rom[  `UARTBR_2000] = $rtoi((2.0**32.0) * CLKDIV *  71000.0 / CLKFRQ + 0.5);
        rom[  `UARTBR_2400] = $rtoi((2.0**32.0) * CLKDIV *  84000.0 / CLKFRQ + 0.5);
        rom[  `UARTBR_3600] = $rtoi((2.0**32.0) * CLKDIV * 100000.0 / CLKFRQ + 0.5);
        rom[  `UARTBR_4800] = $rtoi((2.0**32.0) * CLKDIV * 119000.0 / CLKFRQ + 0.5);
        rom[  `UARTBR_7200] = $rtoi((2.0**32.0) * CLKDIV * 141000.0 / CLKFRQ + 0.5);
        rom[  `UARTBR_9600] = $rtoi((2.0**32.0) * CLKDIV * 168000.0 / CLKFRQ + 0.5);
        rom[`UARTBR_115200] = $rtoi((2.0**32.0) * CLKDIV * 200000.0 / CLKFRQ + 0.5);

`endif

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

   assign brgCLKEN = carry;

endmodule
