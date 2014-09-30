////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Debug Interface
//
// Details
//   This file is used by the simulator to print the program counter on the
//   console display as the code executes
//
// File
//   debug.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2012-2014 Rob Doyle
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

   wire loadIR = `cromSPEC_EN_40 & (`cromSPEC_SEL == `cromSPEC_SEL_LOADIR);

   //
   // Print the Program Counter
   //
   // Details:
   //  The program counter is modified by instructions in various stages of the
   //  microcode.  A modified PC does not mean that the instruction was
   //  actually executed.  For example, the PC is always incremented after the
   //  instruction is fetched but the PC may be modified (again) later by a
   //  branch instruction.
   //
   //  This code prints the program counter when the instruction register is
   //  loaded.  This occurs once during the instruction execution.
   //

   reg [18:35] PC;
   reg [14*8:1] test;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             PC   <= 0;
             test <= "";
          end
        else if (loadIR)
          begin
             PC <= debugDATA[18:35];

             if (PC ==  18'o030057)
               begin
                  $display("Test Completed\n");
                  $stop;
               end

             `ifdef DEBUG_DSKBA
                 `include "debug_dskba.vh"

             `elsif DEBUG_DSKCG
                 `include "debug_dskcg.vh"

             `elsif DEBUG_DSDZA
                 `include "debug_dsdza.vh"

             `elsif DEBUG_DSUBA
                 `include "debug_dsuba.vh"

             `endif

             $display("[%10.3f] %-15s: PC is %06o", $time/1.0e3, test, PC);
          end
     end

`endif

   //
   // PC is Register #1 in the ALU
   //

   assign debugADDR = 4'b0001;

 endmodule
