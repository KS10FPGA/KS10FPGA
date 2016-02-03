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

module DEBUG (
      input  wire         clk,          // Clock
      input  wire         rst,          // Reset
      input  wire         clken,        // Clock Enable
      input  wire [0:107] crom,         // Control ROM Data
      input  wire [0: 11] cromADDR,     // Control ROM Address
      input  wire [0: 35] dp,           // dp bus
      input  wire [0: 35] dbm,          // dbm bus
      input  wire [0: 35] dbus,         // dbus bus
      input  wire         cpuRUN,       // CPU Run Status
      input  wire         cpuCONT,      // CPU Continue Status
      input  wire         cpuEXEC,      // CPU Execute Status
      input  wire         cpuHALT,      // CPU Halt Status
      input  wire [0: 35] debugDATA,    // DEBUG Data
      output wire [0:  3] debugADDR     // DEBUG Address
   );

`ifdef SYNTHESIS

`ifdef CHIPSCOPE_CPU

   //
   // Microcode Decode
   //

   wire loadIR  = `cromSPEC_EN_40 & (`cromSPEC_SEL == `cromSPEC_SEL_LOADIR);

   //
   // Capture the PC
   //

   reg [18:35] PC;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          PC <= 0;
        else
          if (loadIR)
            PC <= debugDATA[18:35];
     end

   //
   // ChipScope Pro Integrated Controller (ICON)
   //

   wire [35:0] control0;
   wire [35:0] control1;

   chipscope_cpu_icon uICON (
      .CONTROL0  (control0),
      .CONTROL1  (control1)
   );

   //
   // ChipScope Pro Virtual Input/Output (VIO)
   //
   // ALU Register Mapping
   //
   // ADDR  REG
   // ---- ----
   //   0: MAG
   //   1: PC
   //   2: HR
   //   3: AR
   //   4: ARX
   //   5: BR
   //   6: BRX
   //   7: ONE
   //   8: EBR
   //   9: UBR
   //  10: MASK
   //  11: FLG
   //  12: PI
   //  13: XWD1
   //  14: T0
   //  15: T1
   //

   chipscope_cpu_vio uVIO (
      .CONTROL   (control0),
      .ASYNC_IN  (debugADDR),
      .ASYNC_OUT (debugADDR)
   );

   //
   // ChipScope Pro Integrated Logic Analyzer (ILA)
   //

   wire [127:0] TRIG0 = {
       rst,                     // dataport[    127]
       cromADDR,                // dataport[115:126]
       dp,                      // dataport[ 79:114]
       {18'b0, PC},             // dataport[ 43: 78]
       debugDATA,               // dataport[  7: 42]
       loadIR,                  // dataport[      6]
       1'b0,                    // dataport[      5]
       cpuRUN,                  // dataport[      4]
       cpuCONT,                 // dataport[      3]
       cpuEXEC,                 // dataport[      2]
       cpuHALT,                 // dataport[      1]
       1'b0                     // dataport[      0]
   };

   chipscope_cpu_ila uILA (
      .CLK       (clk),
      .CONTROL   (control1),
      .TRIG0     (TRIG0)
   );

`else

   //
   // PC is Register #1 in the ALU
   //

   assign debugADDR = 4'b0001;

`endif

`else

   //
   // Microcode Decode
   //

   wire loadIR  = `cromSPEC_EN_40 & (`cromSPEC_SEL == `cromSPEC_SEL_LOADIR);
   wire loadVMA = (`cromMEM_CYCLE & `cromMEM_LOADVMA);

   //
   // Print the Program Counter
   //

   reg [18:35] PC;
   reg [14*8:1] test;
   time lastIR;
   time lastVMA;

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
   // PC is Register #1 in the ALU
   //

   assign debugADDR = 4'b0001;

`endif

endmodule
