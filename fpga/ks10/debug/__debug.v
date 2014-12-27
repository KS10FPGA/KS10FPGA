////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Debug Interface
//
// Details
//   This file is used by the simulator to print the program counter on the
//   console display as the code executes.   A modified PC does not mean that
//   the instruction was actually executed.  For example, the PC is always
//   incremented after the instruction is fetched but the PC may be modified
//   (again) later by a branch instruction.   This code prints the program
//   counter when the instruction register is loaded.  This occurs once during
//   the instruction execution.
//
//   This module also has some code that attempts to halt the simulation if
//   the CPU gets stuck.  It does this by watching for VMA changes and PC
//   changes.
//
//   The PC will appear to be stuck for long period of time when doing BLT
//   operations therefore watching for just PC changes is not sufficient.
//
// File
//   debug.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2014 Rob Doyle
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
`include "useq/crom.vh"

  module DEBUG(clk, rst, clken, crom, debugDATA, debugADDR);

   parameter cromWidth = `CROM_WIDTH;

   input                  clk;          // Clock
   input                  rst;          // Reset
   input                  clken;        // Clock Enable
   input  [0:cromWidth-1] crom;         // Control ROM Data
   input  [0:35]          debugDATA;    // DEBUG Data
   output [0: 3]          debugADDR;    // DEBUG Address

   //
   // Microcode Decode
   //

`ifndef SYNTHESIS

   wire loadIR  = `cromSPEC_EN_40 & (`cromSPEC_SEL == `cromSPEC_SEL_LOADIR);

   wire loadVMA = (`cromMEM_CYCLE & `cromMEM_LOADVMA);

   //
   // Print the Program Counter
   //

   reg [18:35] PC;
   reg [14*8:1] test;
   integer lastIR;
   integer lastVMA;

   always @(posedge clk or posedge rst)
     begin

        if (rst)
          begin
             PC      = 0;
             test    = "";
             lastIR  = 0;
             lastVMA = 0;
          end

        //
        // Capture time when VMA last changed.
        //

        else if (loadVMA)
          begin
             lastVMA = $time;
          end

        //
        // Capture time when IR last changed
        //

        else if (loadIR)
          begin

             PC     = debugDATA[18:35];
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

`endif

   //
   // PC is Register #1 in the ALU
   //

   assign debugADDR = 4'b0001;

endmodule
