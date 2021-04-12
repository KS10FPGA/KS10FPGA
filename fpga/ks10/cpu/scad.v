////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Step Count Adder
//
// Details
//   This module implements the SCAD.  The SCAD is used by the microcode as a
//   counter, by multiply and divide instructions, and by the floating-point
//   exponentiator.
//
// File
//   scad.v
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

`include "useq/crom.vh"

module SCAD (
      input  wire         clk,          // Clock
      input  wire         rst,          // Reset
      input  wire         clken,        // Clock Enable
      input  wire [0:107] crom,         // Control ROM Data
      input  wire [0: 35] dp,           // Data path
      output wire         feSIGN,       // FE Sign
      output wire         scSIGN,       // SC Sign
      output reg  [0:  9] scad,         // SCAD
      output wire [8: 11] dispSCAD      // SCAD Dispatch
   );

   //
   // CROM interface
   //

   wire [0:2] fun    = `cromSCAD_FUN;   // SCAN Function
   wire [0:2] asel   = `cromSCAD_ASEL;  // SCAD B Input
   wire [0:1] bsel   = `cromSCAD_BSEL;  // SCAD A Input
   wire [0:9] snum   = `cromSNUM;       // Small number field
   wire       loadSC = `cromLOADSC;     // Load SC
   wire       loadFE = `cromLOADFE;     // Load FE

   //
   // Registers
   //

   reg [0:9] fe;                        // Floating-point exponent
   reg [0:9] sc;                        // Step counter

   //
   // SCADA MUX
   //
   // Details:
   //  This mux provides one input to the SCAD ALU.
   //
   // Trace:
   //  DPM3/E28
   //  DPM3/E51
   //  DPM3/E67
   //  DPM3/E68
   //  DPM3/E75
   //  DPM3/E83
   //  DPM3/E91
   //  DPM3/E99
   //  DPM3/E100
   //  DPM3/E107
   //

   reg [0: 9] scadA;

   always @*
     begin
        case (asel)
          `cromSCAD_ASEL_SC:
            scadA <= sc[0:9];
          `cromSCAD_ASEL_SNUM:
            scadA <= snum[0:9];
          `cromSCAD_ASEL_PTR44:
            scadA <= {sc[0], 6'o44, dp[6], sc[8:9]};
          `cromSCAD_ASEL_BYTE1:
            scadA <= {snum[0], dp[ 0: 6], snum[8:9]};
          `cromSCAD_ASEL_BYTE2:
            scadA <= {sc[0],   dp[ 7:13], sc[8:9]};
          `cromSCAD_ASEL_BYTE3:
            scadA <= {snum[0], dp[14:20], snum[8:9]};
          `cromSCAD_ASEL_BYTE4:
            scadA <= {sc[0],   dp[21:27], sc[8:9]};
          `cromSCAD_ASEL_BYTE5:
            scadA <= {snum[0], dp[28:34], snum[8:9]};
        endcase
     end

   //
   // SCADB Mux
   //
   // Details:
   //  This mux provides the other input to the SCAD ALU.
   //
   // Trace:
   //  DPM3/E36
   //  DPM3/E60
   //  DPM3/E75
   //  DPM3/E84
   //

   reg [0:9] scadB;

   always @*
     begin
        case (bsel)
          `cromSCAD_BSEL_FE:
            scadB <= fe[0:9];
          `cromSCAD_BSEL_EXP:
            if (dp[0])
              scadB <= {2'b00, ~dp[1:8]};
            else
              scadB <= {2'b00,  dp[1:8]};
          `cromSCAD_BSEL_SHIFT:
            scadB <= {dp[18], dp[18], dp[28:35]};
          `cromSCAD_BSEL_SIZE:
            scadB <= {1'b0, dp[6:11], 3'b0};
        endcase
     end

   //
   // SCAD ALU:
   //
   // Details:
   //  The 74LS181 ALUs implment 16 functions.  Only 8 functions are used.
   //  Therefore this is a bunch of logic to map the microcode into the ALU
   //  function.
   //
   // Notes:
   //  This is positive logic.  Be sure to use the right table in the 74ls181
   //  data sheet.
   //
   //  Be sure to notice that the CY# input to the ALU is tied to FUN2.
   //
   //  The SCAD Carry Skipper DPM4/E704 does not need to be implemented.  The
   //  FPGA carry logic does not require parallel carries for this level of
   //  performance.
   //
   //  The following truth table is derived from the circuit diagram.
   //
   //   +-------------+-+-------------------------+---------------+
   //   | FUN FUN FUN | | ALU ALU ALU ALU ALU ALU |               |
   //   |  0   1   2  | |  8   4   2   1   CY  M  |  Descripton   |
   //   +-------------+-+-------------------------+---------------+
   //   |  0   0   0  | |  1   1   0   0   1   0  | F = A + A     |
   //   |  0   0   1  | |  1   1   1   0   0   1  | F = A | B     |
   //   |  0   1   0  | |  0   1   1   0   1   0  | F = A - B - 1 |
   //   |  0   1   1  | |  0   1   1   0   0   0  | F = A - B     |
   //   |  1   0   0  | |  1   0   0   1   1   0  | F = A + B     |
   //   |  1   0   1  | |  1   0   1   1   0   1  | F = A & B     |
   //   |  1   1   0  | |  1   1   1   1   1   0  | F = A - 1     |
   //   |  1   1   1  | |  1   1   1   1   0   0  | F = A         |
   //   +-------------+-+-------------------------+---------------+
   //
   // Funny enough, this matches the microcode.
   //
   // Trace:
   //  DPM3/E5
   //  DPM3/E19
   //  DPM3/E22
   //  DPM3/E20
   //  DPM3/E24
   //

   always @*
     begin
        case (fun)
          `cromSCAD_A_PLUS_A:
            scad <= scadA + scadA;
          `cromSCAD_A_OR_B:
            scad <= scadA | scadB;
          `cromSCAD_A_MINUS_B_1:
            scad <= scadA - scadB - 1'b1;
          `cromSCAD_A_MINUS_B:
            scad <= scadA - scadB;
          `cromSCAD_A_PLUS_B:
            scad <= scadA + scadB;
          `cromSCAD_A_AND_B:
            scad <= scadA & scadB;
          `cromSCAD_A_MINUS_1:
            scad <= scadA - 1'b1;
          `cromSCAD_A:
            scad <= scadA;
        endcase
     end

   //
   // FE Register
   //
   // Details:
   //  Floating-point exponent
   //
   // Trace
   //  DPM4/E44
   //  DPM4/E52
   //

   always @(posedge clk)
    begin
        if (rst)
          fe <= 9'b0;
        else if (clken & loadFE)
          fe <= scad;
    end

   //
   // SC Register
   //
   // Details:
   //  Step Counter
   //
   // Trace
   //  DPM4/E35
   //  DPM4/E43
   //

   always @(posedge clk)
    begin
        if (rst)
          sc <= 9'b0;
        else if (clken & loadSC)
          sc <= scad;
    end

   //
   // FE Sign and SC Sign
   //

   assign feSIGN = fe[0];
   assign scSIGN = sc[0];

   //
   // SCAD Dispatch
   //

   assign dispSCAD = (scad[0]) ? 4'b0010 : 4'b0000;

endmodule
