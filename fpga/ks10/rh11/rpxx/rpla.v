////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RPxx Look Ahead (RPLA) Register
//
// Details
//   The RPLA register is used to look at the data "under the head" in
//   real-time. In this FPGA, this is not implemented.  There is some
//   maintenance-mode magic that is implemented in order to pass the
//   diagnostics.
//
//   The following is true for an RP06.   For everything else, we don't care.
//   Only the RPDA diagnostic cares about this.
//
//   When RPMR[FMT22] is negated (18-bit mode), there are 20 sectors per track.
//   There are 672 bytes per sector and therefore 13440 bytes per track.  Of
//   the 672 bytes of data per sector, 576 bytes are payload and 96 bytes are
//   pre-header, header, header gap, ECC, data gap, and tolerance gap.
//
//   When RPMR[FMT22] is asserted (16-bit mode), there are 22 sectors per track.
//   There are 609 bytes per sector and therefore 13398 bytes per track. Of
//   the 609 bytes of data per sector, 512 bytes are payload and 96 bytes are
//   pre-header, header, header gap, ECC, data gap, and tolerance gap. By my
//   count, 1 byte is unaccounted.
//
//   Notice that the number of bytes per track almost does not change with mode.
//
//   The RP06 spins at 3600 RPM.  When RPMR[FMT22] is negated (18-bit mode)
//   this is 1200 sectors per second. This implies that the sector extension
//   counter must be incremented at 806.400 KHz.
//
//   When RPMR[FMT22] is asserted (16-bit mode), this is 1320 sectors per
//   second.  This implies that the sector extension counter must be
//   incremented at 803.880 KHz.
//
//   Thus the Sector Extension Counter will be clocked at 800 KHz which is close
//   enough.
//
//   The RPXX has special Diagnostic Mode hardware that allows this all to be
//   tested via the Maintenance Mode Register (RPMR) and the Look Ahead Register
//   (RPLA).  This is enabled when the unit is in Diagnostic Mode (RPMR[DMD]
//   asserted).
//
//   The sector extension counter can be reset by generating an index pulse via
//   the Diagnostic Index Pulse bit of the Maintenance Register (RPMR[DIND]).
//   Thereafter, the sector extension counter can be incremented by bit-banging
//   a Diagnostic Sector Clock via the RPMR[DSCK] bit.  The result can be
//   observed via the Look Ahead Register.
//
//   The sector extension that is reported in the RPLA register is as follows:
//
//     Extension   Extension
//      Counter      Report
//    ----------- ----------
//       0 - 127      0
//     128 - 255      1
//     256 - 512      2
//     512 -          3
//
// File
//   rpla.v
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

`include "rpmr.vh"
`include "../../ks10.vh"

`define FAST_SEARCH

module RPLA (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire         clr,                  // Clear
      input  wire         rpDSCK,               // Diagnostic sector clock
      input  wire         rpDIND,               // Diagnostic index pulse
      input  wire         rpDMD,                // Diagnostic mode
      input  wire [ 5: 0] rpSECNUM,             // Number of sectors
      input  wire [ 5: 0] rpSA,                 // Sector address
      output wire [15: 0] rpLA                  // Look ahead register
   );

   //
   // Fractional-N divider constants
   //

   localparam CLKFRQ = `CLKFRQ;                 // Clock frequency
`ifdef FAST_SEARCH
   localparam SECFRQ = 1600000;                 // Sector clock frequency (1.6 MHz)
`else
   localparam SECFRQ =  800000;                 // Sector clock frequency (800 KHz)
`endif

   //
   // "Nomal Mode" Sector Extension Counter clock generator.
   //
   // This simulates what real RP06 would generate for synchronous transfers.
   //
   // This is a Fractional-N divider.
   //

   wire [0:31] incr = $rtoi((2.0**32.0) * SECFRQ / CLKFRQ + 0.5);
   reg  [0:31] accum;
   reg         carry;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          {carry, accum} <= 33'b0;
        else
          {carry, accum} <= {1'b0, accum} + {1'b0, incr};
     end

   wire sect_clk = carry;

   //
   // Diagnostic sector clock
   //

   wire diag_clk;
   EDGETRIG #(.POSEDGE(1)) MAINTCLK(clk, rst, 1'b1, rpDSCK, diag_clk);

   //
   // Clock Multiplexer.  This switches between "Normal" and "Maintenance" mode
   // clocks.
   //
   // Trace
   //  M7787/DP6/E36
   //

   wire sect_clken = rpDMD ? diag_clk : sect_clk;

   //
   // Sector Extension Counter
   //
   // Trace
   //  M7787/DP6/E25
   //  M7787/DP6/E29
   //  M7787/DP6/E30
   //

   wire      sect_inc;
   reg [9:0] sect_ext;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          sect_ext <= 0;
        else
          if (sect_clken)
            begin
               if (rpDMD & rpDIND)
                 sect_ext <= 0;
               else if (sect_inc)
                 sect_ext <= 0;
               else
                 sect_ext <= sect_ext + 1'b1;
            end
     end

   //
   // Sector Increment
   //
   // Trace
   //  M7787/DP6/E16
   //  M7787/DP6/E17
   //  M7787/DP6/E20
   //  M7787/DP6/E24
   //  M7787/DP6/E43
   //  M7787/DP6/E51
   //  M7787/DP6/E53
   //

   assign sect_inc = (((rpSECNUM == 19) & (sect_ext == 671)) |    // 672 bytes per sector (18-bit mode)
                      ((rpSECNUM == 21) & (sect_ext == 608)));    // 609 bytes per sector (16-bit mode)

   //
   // Extension Register Contents
   //
   // Trace
   //  M7787/DP6/E64
   //  M7787/DP6/E63
   //  M7787/DP6/E65
   //

   reg [1:0] ext_cnt;

   always @*
     begin
        if (sect_ext < 128)
          ext_cnt <= 0;
        else if (sect_ext < 256)
          ext_cnt <= 1;
        else if (sect_ext < 512)
          ext_cnt <= 2;
        else
          ext_cnt <= 3;
     end

   //
   // Sector Counter
   //
   // The Sector Counter will not increment past the last sector.  In
   // maintenance mode, it will just stay on the last sector although the
   // sector extension will continue to increment.   In normal mode, the Index
   // Pulse will reset the counter to zero after the last sector.
   //
   // Trace
   //  M7787/DP6/E61
   //  M7787/DP6/E62
   //  M7787/DP6/E41
   //  M7787/DP6/E51
   //  M7787/DP6/E53
   //  M7787/DP6/E58
   //

   reg [11:6] sect_cnt;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          sect_cnt <= 0;
        else
          if (sect_clken)
            begin
               if (rpDMD & rpDIND)
                 sect_cnt <= 0;
               else if (sect_inc)
                 if (sect_cnt == rpSECNUM)
                   begin
                      if (!rpDMD)
                        sect_cnt <= 0;
                   end
                 else
                   sect_cnt <= sect_cnt + 1'b1;
            end
     end

   //
   // RPLA Register
   //
   // Trace
   //  M7786/SS6/E6
   //  M7786/SS6/E20
   //  M7786/SS6/E14
   //  M7786/SS6/E55
   //

   assign rpLA = {4'b0, sect_cnt, ext_cnt, 4'b0};

endmodule
