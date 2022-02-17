////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   UBA Interrupt Request Logic
//
// File
//   ubaintr.sv
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

`include "uba.vh"
`include "ubasr.vh"

module UBAINTR (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      output wire [ 1: 7] busINTR,              // Interrupt to CPU
      input  wire         wruREAD,              // Who are you?
      input  wire [ 0:35] regUBASR,             // Status Register
      input  wire [ 7: 4] devINTR[1:5]          // Interrupt request
   );

   //
   // High and Low Interrupt Request
   //

   wire [ 0: 2] statPIH   = `statPIH(regUBASR);
   wire [ 0: 2] statPIL   = `statPIL(regUBASR);
   wire         statINTHI = (devINTR[1][7] | devINTR[2][7] | devINTR[3][7] | devINTR[4][7] | devINTR[5][7] |
                             devINTR[1][6] | devINTR[2][6] | devINTR[3][6] | devINTR[4][6] | devINTR[5][6]);
   wire         statINTLO = (devINTR[1][5] | devINTR[2][5] | devINTR[3][5] | devINTR[4][5] | devINTR[5][5]|
                             devINTR[1][4] | devINTR[2][4] | devINTR[3][4] | devINTR[4][4] | devINTR[5][4]);

   //
   // High Priority Interrupt
   //
   // Trace
   //  UBA3/E180
   //

   logic [1:7] devINTRH;

    always_comb
     begin
        if (statINTHI)
          case (statPIH)
            0: devINTRH <= 7'b0000000;
            1: devINTRH <= 7'b1000000;
            2: devINTRH <= 7'b0100000;
            3: devINTRH <= 7'b0010000;
            4: devINTRH <= 7'b0001000;
            5: devINTRH <= 7'b0000100;
            6: devINTRH <= 7'b0000010;
            7: devINTRH <= 7'b0000001;
          endcase
        else
          devINTRH <= 7'b0000000;
     end

   //
   // Low Priority Interrupt
   //
   // Trace
   //  UBA3/E182
   //

   logic [1:7] devINTRL;

   always_comb
     begin
        if (statINTLO)
          case (statPIL)
            0: devINTRL <= 7'b0000000;
            1: devINTRL <= 7'b1000000;
            2: devINTRL <= 7'b0100000;
            3: devINTRL <= 7'b0010000;
            4: devINTRL <= 7'b0001000;
            5: devINTRL <= 7'b0000100;
            6: devINTRL <= 7'b0000010;
            7: devINTRL <= 7'b0000001;
          endcase
        else
          devINTRL <= 7'b0000000;
     end

   //
   // IO Bridge Interrupt Request
   //
   // Trace
   //  UBA3/E179
   //  UBA3/E181
   //

   assign busINTR = devINTRL | devINTRH;

endmodule
