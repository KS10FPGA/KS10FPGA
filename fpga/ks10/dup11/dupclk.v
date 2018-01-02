////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DUP11 Transmit/Receive Serial Clock
//
// Details
//   This file provides the implementation of the Serial Data clocking
//
// File
//   dupclk.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2018 Rob Doyle
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

`include "../ks10.vh"
`include "duptxcsr.vh"

module DUPCLK (
      input  wire         clk,          // Clock
      input  wire         rst,          // Reset
      input  wire [12:11] dupMSEL,      // Maintenance mode select
      input  wire         dupMCO,       // Maintenance clock
      output wire         dupMNTT,      // Maintenance timer
      output wire         dupCLK,       // Serial clock output
      input  wire         dupRXC,       // Receiver clock
      input  wire         dupTXC,       // Transmitter clock
      output wire         dupRXCEN,     // Receiver clock enable
      output wire         dupTXCEN      // Transmitter clock enable
   );

   //
   // Serial clock parameters
   //  This is for a 10KHz clock
   //

`ifdef DUP11_FASTCLK
   parameter CLKFREQ = 100000;
`else
   parameter CLKFREQ = 10000;
`endif
   parameter [10:0] clkdiv  = `CLKFRQ / CLKFREQ / 2;

   //
   // Clock divider
   //
   // The clock does not run in diagnostic mode. In this mode, the KS10
   // bit-bangs clock signal.
   //

   reg [10:0] count;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          count <= clkdiv;
        else
          if (dupMSEL == `dupTXCSR_MSEL_DIAG)
            count <= clkdiv;
          else
            if (count == 0)
              count <= clkdiv;
            else
              count <= count - 1'b1;
     end

   //
   // On the DEC KS10, the baudrate is 10Kbps
   //

   reg clk10KHz;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          clk10KHz <= 0;
        else
          if (dupMSEL == `dupTXCSR_MSEL_DIAG)
            clk10KHz <= 0;
          else if (count == 0)
            clk10KHz <= !clk10KHz;
     end

   //
   // The Maintenance Timer is half the baudrate or 5 KHz.
   //

   reg clk5KHz;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          clk5KHz  <= 0;
        else
          if (dupMSEL == `dupTXCSR_MSEL_DIAG)
            clk5KHz <= 0;
          else if ((count == 0) & clk10KHz)
            clk5KHz <= !clk5KHz;
     end

   //
   // Maintenance Timer
   //

   assign dupMNTT = ((clk5KHz & (dupMSEL == `dupTXCSR_MSEL_MEXT)) |
                     (clk5KHz & (dupMSEL == `dupTXCSR_MSEL_MINT)));

   //
   // Clock selector
   //

   assign dupCLK = (dupMSEL == `dupTXCSR_MSEL_DIAG) ? dupMCO : clk5KHz;

   //
   // Transmitter clock output
   //
   // The transmitter data changes on the rising edge of the serial clock
   //

   reg lastTXC;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          lastTXC <= 0;
        else
          lastTXC <= dupTXC;
     end

   assign dupTXCEN = dupTXC & !lastTXC;

   //
   // Clock enable outputs
   //
   // The receiver data is sampled on the falling edge of the serial clock
   //

   reg lastRXC;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          lastRXC <= 0;
        else
          lastRXC <= dupRXC;
     end

   assign dupRXCEN = !dupRXC & lastRXC;

endmodule
