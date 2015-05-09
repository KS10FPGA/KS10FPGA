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
//   There are 672 bytes per sector and therefore 12768 bytes per track.  Of
//   the 672 bytes of data per sector, 576 bytes are payload and 96 bytes are
//   pre-header, header, header gap, ECC, data gap, and tolerance gap.
//
//   When RPMR[FMT22] is asserted (16-bit mode), there are 22 sectors per track.
//   There are 608 bytes per sector and therefore 12768 bytes per track. Of
//   the 608 bytes of data per sector, 512 bytes are payload and 96 bytes are
//   pre-header, header, header gap, ECC, data gap, and tolerance gap.
//
//   Notice that the number of bytes per track does not change with mode.
//
//   The RPXX has special Diagnostic Mode hardware that allows this all to be
//   tested via the Maintenance Mode Register (RPMR) and the Look Ahead Register
//   (RPLA).  This is enabled when the unit is in Diagnostic Mode (RPMR[DMD]
//   asserted).
//
//   The sector byte counter can be reset by generating an index pulse via the
//   Diagnostic Index Pulse bit of the Maintenance Register (RPMR[DIND]).
//   Thereafter, the byte counter can be incremented by bit-banging a
//   Diagnostic Sector Clock via the RPMR[DSCK] bit.  The result can be
//   observed via the Look Ahead Register.
//
// File
//   rpla.v
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

`include "rpmr.vh"

module RPLA (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire         clr,                  // Clear
      input  wire         rpFMT22,              // 22 (octal) sector mode
      input  wire [15: 0] rpMR,                 // Maintenance register
      input  wire [ 5: 0] rpSA,                 // Sector address
      output reg  [15: 0] rpLA                  // Look ahead register
   );

   //
   // Decode rpMR
   //

   wire rpDSCK = `rpMR_DSCK(rpMR);              // Diagnostic sector clock
   wire rpDIND = `rpMR_DIND(rpMR);              // Diagnostic index pulse
   wire rpDMD  = `rpMR_DMD(rpMR);               // Diagnostic mode

   //
   // Create clock enable
   //

   wire clken;
   EDGETRIG FIFOWR(clk, rst, 1'b1, 1'b1, rpDSCK, clken);

   //
   // Prescaler. Divides by 609 or 672 depending on mode.
   //

   reg [9:0] bytecnt;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          bytecnt <= 0;
        else
          if (clken)
            begin
               if (rpDIND)
                 bytecnt <= 0;
               else if (incsector)
                 bytecnt <= 0;
               else
                 bytecnt <= bytecnt + 1'b1;
            end
     end

   //
   // Increment Sector
   //

   wire incsector = ((!rpFMT22 & (bytecnt == 671)) |    // 672 bytes per sector
                     ( rpFMT22 & (bytecnt == 608)));    // 609 bytes per sector

   //
   // Increment Extension Counter
   //

   wire incextcnt = ((bytecnt == 127) |
                     (bytecnt == 255) |
                     (bytecnt == 511) |
                     ((bytecnt == 608) &  rpFMT22) |
                     ((bytecnt == 671) & !rpFMT22));

   //
   // Extension counter
   //

   reg [1:0] extcnt;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          extcnt <= 0;
        else
          if (clken)
            begin
               if (rpDIND)
                 extcnt <= 0;
               else if (incextcnt)
                 extcnt <= extcnt + 1'b1;
            end
     end

   //
   // Sector counter
   //

   reg [11:6] sectorcnt;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          sectorcnt <= 0;
        else
          if (clken)
            begin
               if (rpDIND)
                 sectorcnt <= 0;
               else if (incsector)
                 if ((!rpFMT22 & (sectorcnt == 18)) |
                     ( rpFMT22 & (sectorcnt == 21)))
                   sectorcnt <= 0;
                 else
                   sectorcnt <= sectorcnt + 1'b1;
            end
     end

   //
   // RPLA Register
   //

   always @*
     begin
        if (rpDMD)
          rpLA <= {4'b0, sectorcnt, extcnt, 4'b0};
        else
          rpLA <= {4'b0, rpSA, 6'b0};
     end

endmodule
