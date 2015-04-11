////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Read/Write Timing
//
// Details
//
// File
//   timing.v
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

`include "useq/crom.vh"
`include "useq/drom.vh"

module TIMING(clk, rst, crom, feSIGN, busWAIT, clkenDP, clkenCR);

   parameter cromWidth = `CROM_WIDTH;

   input                  clk;          // Clock
   input                  rst;          // Reset
   input  [0:cromWidth-1] crom;         // Control ROM Data
   input                  feSIGN;       // FE Sign
   input                  busWAIT;      // Memory Wait
   output                 clkenDP;      // Clock Enable
   output                 clkenCR;      // Clock Enable Microsequencer

   //
   // Fast Shift
   //
   // Details:
   //  The KS10 fast shifts while the FE is negative.
   //
   // Note:
   //  The obvious implementation shifts one count too many and shifts by one
   //  when the count is zero.  This is very counter-intuitive.
   //
   //  Be careful.  When the shift count is zero (FE = -1 or 1777) no shifts
   //  should be peformed.
   //
   // FIXME:
   //  This crazy fast shift stuff should be replaced by a microcode hack.
   //  The FPGA doesn't really require this fast shift implementation.
   //
   // Trace
   //  CSL5/E33
   //  CSL5/E44
   //  CSL5/E45
   //  CSL5/E52
   //  CSL5/E53
   //  CSL5/E54
   //  CSL5/E71
   //

   reg done;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          done = 0;
        else
          done = feSIGN & `cromMULTISHIFT;
     end

   //
   // Clock enables
   //
   // Details
   //  In the KS10, the Control ROM (KS10 CRA/M) and the Data Path (KS10 DPE/M)
   //  are clock enabled independantly.
   //
   // Trace
   //  CSL5/E33
   //  CSL5/E54
   //

   assign clkenCR = !((`cromMULTISHIFT &  feSIGN)                    | busWAIT);
   assign clkenDP = !((`cromMULTISHIFT & !feSIGN) | (done & clkenCR) | busWAIT);

endmodule
