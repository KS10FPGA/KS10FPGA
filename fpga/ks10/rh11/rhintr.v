////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RH11 Interrupt
//
// Details
//   The module implements the RH11 interrupt controller.
//
// File
//   rhintr.v
//
// Notes
//   RH11 interrupts are a little strange.
//
//   Please read the white pager entited "PDP-11 Interrupts: Variations On A
//   Theme", Bob Supnik, 03-Feb-2002 [revised 20-Feb-2004]
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

module RHINTR(clk, rst, clr,
              rhIFF);


   input          clk;                          // Clock
   input          rst;                          // Reset
   input          clr;                          // Clear

   output rhIFF;

/*
   FIXME

   reg rhIFF;
             if (devINTA == rhINTR)
               rhIFF <= 0;
             else if (rhRDY & ~lastRDY)
               rhIFF <= rhIE;
*/

   assign rhIFF = 0;

endmodule
