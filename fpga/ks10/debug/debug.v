////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Debug Interface
//
// Details
//   This module provides KS10 breakpoint and instruction trace capabilities.
//   - the breakpoint is accomplished by examining the CPU Address Bus.
//   - the trace accesses the Program Counter (PC) and the Instruction Register
//     (IR).
//
// File
//   debug.v
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

`include "debug.vh"

module DEBUG (
      input  wire         rst,          // Reset
      input  wire         clk,          // Clock
      input  wire [ 0:35] cpuADDR,      // Backplane address from CPU
      input  wire [18:35] cpuPC,        // Program counter
      input  wire [ 0:35] cpuHR,        // Instruction register
      input  wire         regsLOAD,     // Load registers
      input  wire         vmaLOAD,      // Load VMA
      output wire [ 0:35] debugCSR,     // Control/Status Register
      input  wire [ 0:35] debugBAR,     // Breakpoint Address Register
      input  wire [ 0:35] debugBMR,     // Breakpoint Mask Register
      output wire [ 0:63] debugITR,     // Instruction Trace Register
      input  wire [ 1: 0] debugBRKEN,   // Break Enable
      input  wire [ 1: 0] debugTREN,    // Trace Enable
      input  wire         debugTRRESET, // Trace Reset
      input  wire         debugREADITR, // Read Instruction Trace Register
      output wire         debugHALT     // Halt signal to CPU
   );

   //
   // Match and mask
   //

   wire match = (cpuADDR & debugBMR) == (debugBAR & debugBMR);

   //
   // Trace Triggered
   //

   reg debugACQ;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          debugACQ <= 0;
        else
          if (debugTRRESET)
            debugACQ <= 0;
          else if (((debugTREN == `debug_TRCEN)) |
                   ((debugTREN == `debug_TRCMAT) & match))
            debugACQ <= 1;
     end

   //
   // Trace Buffer Read/Write/Clear
   //

   wire rd;
   wire wr;
   wire clr = debugTRRESET;
   wire debugWRITITR = debugACQ & regsLOAD;

   EDGETRIG #(.POSEDGE(0)) traceRD(clk, rst, 1'b1, debugREADITR, rd);
   EDGETRIG #(.POSEDGE(1)) traceWR(clk, rst, 1'b1, debugWRITITR, wr);

   //
   // Instruction Trace Buffer
   //

   wire [ 0:35] fifoHR;
   wire [18:35] fifoPC;
   wire         full;
   wire         empty;

   FIFO #(
      .SIZE       (16*1024),
      .WIDTH      (54)
   ) TRACE_BUFFER (
      .clk        (clk),
      .rst        (rst),
      .clr        (clr),
      .clken      (1'b1),
      .rd         (rd),
      .wr         (wr),
      .in         ({cpuPC, cpuHR}),
      .out        ({fifoPC, fifoHR}),
      .full       (full),
      .empty      (empty)
   );

   //
   // Build Control/Status Register
   //

   assign debugCSR = {20'b0, debugBRKEN, 6'b0, debugTREN, 2'b0, debugACQ, full, empty, 1'b0};

   //
   // Build Instruction Trace Register
   //

   assign debugITR = {10'b0, fifoPC, fifoHR};

   //
   // Breakpoint Halt
   //

   assign debugHALT = (debugBRKEN == `debug_BRKMAT) & match;

   //
   // Simulation Support
   //
   //  This code is used by the simulator to print the program counter on the
   //  console display as the code executes.   A modified PC does not mean that
   //  the instruction was actually executed.  For example, the PC is always
   //  incremented after the instruction is fetched but the PC may be modified
   //  (again) later by a branch instruction.   This code prints the program
   //  counter when the instruction register is loaded.  This occurs once during
   //  the instruction execution.
   //
   //  This module also has some code that attempts to halt the simulation if
   //  the CPU gets stuck.  It does this by watching for VMA changes and PC
   //  changes.
   //
   //  The PC will appear to be stuck for long period of time when doing BLT
   //  operations therefore watching for just PC changes is not sufficient.
   //

`ifndef SYNTHESIS

   //
   // Remember last time VMA was updated
   //

   time lastVMA;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          lastVMA = 0;
        else
          if (vmaLOAD)
            lastVMA = $time;
     end

   //
   // Remember last time IR was updated
   //

   time lastIR;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          lastIR = 0;
        else
          if (regsLOAD)
            lastIR = $time;

          //
          // Whine if the PC but not the VMA gets stuck for 1 ms
          //

          else if ((($time - lastIR) > 1000000) && (($time - lastVMA) < 1000000))
            begin
               lastIR = $time;
               $display("[%11.3f] %15s: PC is %06o (not stuck).", $time/1.0e3, test, PC);
            end

          //
          // Whine if both the PC and the VMA gets stuck for 1 ms
          //

          else if ((($time - lastIR) > 1000000) && (($time - lastVMA) > 1000000))
            begin
               lastIR = $time;
               $display("[%11.3f] %15s: PC is %06o (stuck).", $time/1.0e3, test, PC);
`ifdef STOP_ON_STUCK_PC
               $stop;
`endif
            end
     end

   //
   // Print out Program Counter in the Simulator
   //

   reg [18:35] PC;
   reg [14*8:1] test;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             PC   = 0;
             test = "";
          end
        else
          if (regsLOAD)
            begin
               PC     = cpuPC;
               lastIR = $time;

               if (PC == 18'o030057)
                 begin
                    $display("Test Completed.");
`ifdef STOP_ON_COMPLETE
                    $stop;
`endif
                 end

                 `ifdef DEBUG_DSKAH
                    `include "debug_dskah.vh"
                 `elsif DEBUG_DSKBA
                    `include "debug_dskba.vh"
                 `elsif DEBUG_DSKCG
                   `include "debug_dskcg.vh"
                 `elsif DEBUG_DSKEA
                    `include "debug_dskea.vh"
                 `elsif DEBUG_DSKEB
                    `include "debug_dskeb.vh"
                 `elsif DEBUG_DSKEC
                    `include "debug_dskec.vh"
                 `elsif DEBUG_DSDZA
                    `include "debug_dsdza.vh"
                 `elsif DEBUG_DSUBA
                    `include "debug_dsuba.vh"
                 `else
                    `include "debug_default.vh"
                 `endif
                 `include "debug_smmon.vh"

                 $display("[%11.3f] %15s: PC is %06o", $time/1.0e3, test, PC);
            end
     end

`endif

endmodule
