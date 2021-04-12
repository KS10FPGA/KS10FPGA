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
// Copyright (C) 2012-2021 Rob Doyle
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

module DEBUG (
      input  wire         rst,          // Reset
      input  wire         clk,          // Clock
      input  wire [ 0:35] cpuADDR,      // Backplane address from CPU
      input  wire [18:35] cpuPC,        // Program counter
      input  wire [ 0:35] cpuHR,        // Instruction register
      input  wire         regsLOAD,     // Load registers
      input  wire         vmaLOAD,      // Load VMA
      input  wire [ 0: 2] debBRCMD,     // Breakpoint command
      output reg  [13:15] debBRSTATE,   // Breakpoint state
      input  wire [24:26] debTRCMD,     // Trace command
      output reg  [27:29] debTRSTATE,   // Trace state
      output wire         debTRFULL,    // Trace full
      output wire         debTREMPTY,   // Trace empty
      input  wire [ 0:35] debBAR,       // Breakpoint address register
      input  wire [ 0:35] debBMR,       // Breakpoint mask register
      output wire [ 0:63] debITR,       // ITR register
      output reg  [ 0:63] debPCIR,      // PCIR register
      input  wire         debBRCMD_WR,  // DCSR breakpoint command write
      input  wire         debTRCMD_WR,  // DCSR trace command write
      input  wire         debITR_RD,    // ITR read
      output wire         debugHALT     // Halt signal to CPU
   );

   //
   // Match and mask
   //

   wire match = (cpuADDR & debBMR) == (debBAR & debBMR);

   //
   // Trace Trigger State Machine
   //

   localparam [2:0] trcmdRESET   = 0,
                    trcmdTRIGGER = 1,
                    trcmdADDRMAT = 2,
                    trcmdSTOP    = 3;

   localparam [2:0] trstateIDLE   = 0,
                    trstateARMED  = 1,
                    trstateACTIVE = 2,
                    trstateDONE   = 3;

   always @(posedge clk)
     begin
        if (rst)
          debTRSTATE <= trstateIDLE;
        else
          if ((debTRCMD == trcmdRESET) & debTRCMD_WR)
            debTRSTATE <= trstateIDLE;
          else
            case (debTRSTATE)
              trstateIDLE:
                if (debTRCMD_WR)
                  case (debTRCMD)
                    trcmdTRIGGER:
                      debTRSTATE <= trstateACTIVE;
                    trcmdADDRMAT:
                      debTRSTATE <= trstateARMED;
                  endcase
              trstateARMED:
                if (match)
                  debTRSTATE <= trstateACTIVE;
                else if ((debTRCMD == trcmdSTOP) & debTRCMD_WR)
                  debTRSTATE <= trstateDONE;
              trstateACTIVE:
                if (debTRFULL | ((debTRCMD == trcmdSTOP) & debTRCMD_WR))
                  debTRSTATE <= trstateDONE;
              trstateDONE:
                debTRSTATE <= trstateDONE;
            endcase
     end

   //
   // Breakpoint Trigger State Machine
   //

   localparam [2:0] brcmdDISABLE = 0,
                    brcmdTRIG    = 1,
                    brcmdFULL    = 2,
                    brcmdEITHER  = 3;

   localparam [2:0] brstateIDLE  = 0,
                    brstateARMED = 1,
                    brstateBREAK = 2;

   always @(posedge clk)
     begin
        if (rst)
          debBRSTATE <= trstateIDLE;
        else
          if ((debBRCMD == brcmdDISABLE) & debBRCMD_WR)
            debBRSTATE <= brstateIDLE;
          else
            case (debBRSTATE)
              brstateIDLE:
                if (debBRCMD_WR)
                  case (debBRCMD)
                    brcmdTRIG,
                    brcmdFULL,
                    brcmdEITHER:
                      debBRSTATE <= brstateARMED;
                  endcase
              brstateARMED:
                if (((debBRCMD == brcmdTRIG)   & match ) |
                    ((debBRCMD == brcmdFULL)   & debTRFULL) |
                    ((debBRCMD == brcmdEITHER) & match ) |
                    ((debBRCMD == brcmdEITHER) & debTRFULL))
                  debBRSTATE <= brstateBREAK;
              brstateBREAK:
                debBRSTATE <= brstateIDLE;
            endcase
     end

   //
   // Instruction Trace Buffer (FIFO)
   //

   wire fifo_rd;
   wire fifo_wr;
   wire [ 0:35] fifoHR;
   wire [18:35] fifoPC;

   EDGETRIG #(
      .POSEDGE    (0)
   ) traceRD (
      .clk        (clk),
      .rst        (rst),
      .clken      (1'b1),
      .i          (debITR_RD),
      .o          (fifo_rd)
   );

   EDGETRIG #(
      .POSEDGE    (1)
   ) traceWR (
      .clk        (clk),
      .rst        (rst),
      .clken      (1'b1),
      .i          (regsLOAD & (debTRSTATE == trstateACTIVE)),
      .o          (fifo_wr)
   );

   FIFO #(
      .SIZE       (1*1024),
      .WIDTH      (54)
   ) TRACE_BUFFER (
      .clk        (clk),
      .rst        (rst),
      .clr        (debTRSTATE == trstateIDLE),
      .clken      (1'b1),
      .rd         (fifo_rd),
      .wr         (fifo_wr),
      .in         ({cpuPC, cpuHR}),
      .out        ({fifoPC, fifoHR}),
      .full       (debTRFULL),
      .empty      (debTREMPTY)
   );

   //
   // Instruction Trace Register
   //

   assign debITR = {10'b0, fifoPC, fifoHR};

   //
   // Program Counter and Instruction Register
   //

   always @(posedge clk)
     begin
        if (rst)
          debPCIR <= 0;
        else if (regsLOAD)
          debPCIR <= {cpuPC, cpuHR};
     end

   //
   // Breakpoint Halt
   //

   assign debugHALT = debBRSTATE == brstateBREAK;

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
   // Registers
   //

   reg [18:35] PC;
   reg [ 0:35] IR;
   reg [14*8:1] test;

   //
   // Remember last time VMA was updated
   //

   time lastVMA;
   always @(posedge clk)
     begin
        if (rst)
          lastVMA = 0;
        else if (vmaLOAD)
          lastVMA = $time;
     end

   //
   // Remember last time IR was updated
   //

   time lastIR;
   always @(posedge clk)
     begin
        if (rst)
          lastIR = 0;
        else if (regsLOAD)
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

   always @(posedge clk)
     begin
        if (rst)
          begin
             IR   = 0;
             PC   = 0;
             test = "";
          end
        else if (regsLOAD)
          begin
             IR     = cpuHR;
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
//             `include "debug_smmon.vh"

               $display("[%11.3f] %15s: PC is %06o", $time/1.0e3, test, PC);
          end
     end

`endif

endmodule
