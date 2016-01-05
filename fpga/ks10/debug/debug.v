////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KS10 Breakpoint System
//
// Details
//   This block provides KS10 breakpoint hardware.  This is accomplished by
//   examining the CPU Address Bus.
//
// File
//   brkpt.v
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

module BRKPT (
      input  wire         rst,          // Reset
      input  wire         clk,          // Clock
      input  wire [ 0:35] cpuADDR,      // Backplane address from CPU
      input  wire [ 0:63] brkptREG,     // Breakpoint register
      output wire         brkptHALT     // Halt signal to CPU
   );

   //
   // Match and mask
   //
   // Only the flags are masked.  The address is not masked.
   //

   wire match = ((cpuADDR[0:35] & {brkptREG[14:27], {22{1'b1}}}) == brkptREG[28:63]);

   //
   // Breakpoint Halt
   //

   assign brkptHALT = brkptREG[0] & match;

endmodule
