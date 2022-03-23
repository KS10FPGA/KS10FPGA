////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//  Trace Interface
//
// Details
//   This module provides KS10 instruction trace capabilities. The trace
//   device stores the accesses the Program Counter (PC) and the Instruction
//   Register (IR) on a stack for last-in first-out (LIFO) access.
//
// File
//   trace.sv
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

module TRACE (
      trcslbus.tr         trDATA,      // Interface from CSL
      input  wire [18:35] cpuPC,        // Program counter
      input  wire [ 0:35] cpuHR,        // Instruction register
      input  wire         regsLOAD      // Load PC and IR
   );

   //
   // Fixup inputs
   //

   wire clk = trDATA.clk;
   wire rst = trDATA.rst;
   wire clr = trDATA.trCLR;

   //
   // Capture Program Counter and Instruction Register when loaded.
   //  The IR is 36-bits
   //  The PC is 18-bits.
   //

   logic [0:53] trPCIR;

   always_ff @(posedge clk)
     begin
        if (rst)
          trPCIR <= 0;
        else if (regsLOAD)
          trPCIR <= {cpuPC, cpuHR};
     end

   //
   // Push Edge Detector
   //  The push signal needs to be one clock wide
   //  We push trace simultaneouly with regsLOAD asserting
   //

   logic push;
   logic d_push;

   always_ff @(posedge clk)
     begin
        if (rst)
          d_push <= 0;
        else
          d_push <= regsLOAD;
     end

   assign push = regsLOAD & !d_push;

   //
   // Pop Edge Detector
   //  The pop signal need to be asserted after the read pulse
   //

   logic pop;
   logic d_pop;

   always_ff @(posedge clk)
     begin
        if (rst)
          d_pop <= 0;
        else
          d_pop <= trDATA.trADV;
     end

   assign pop = !trDATA.trADV & d_pop;

   //
   // Trace Stack
   //

   logic full;
   logic empty;
   logic [53:0] trITR;
   localparam [4:0] log2size = 5'd12;           // 4K buffer size

   LIFO #(
      .SIZE             (2**log2size),          // Stack depth
      .WIDTH            (54)                    // Stack width
   ) TRACEBUF (
      .rst              (rst),                  // Clock
      .clk              (clk),                  // Reset
      .clken            (1'b1),                 // Clock Enable
      .clr              (clr),                  // Clear
      .push             (push),                 // Push onto stack
      .pop              (pop),                  // Pop from stack
      .in               ({cpuPC, cpuHR}),       // Input
      .out              (trITR),                // Output
      .full             (full),                 // Full
      .empty            (empty)                 // Empty
   );

   //
   // Fixup outputs
   //

   assign trDATA.trPCIR = {10'b0, trPCIR};
   assign trDATA.trITR  = {1'b0, full, empty, log2size, 2'b0, trITR};

endmodule
