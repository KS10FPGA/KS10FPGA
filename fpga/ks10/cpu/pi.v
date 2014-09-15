////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Priority Interrupt
//
// Details
//
// Note
//   The highest priority is interrupt 1, the lower priority is
//   interrupt 7.
//
// File
//   intr.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2012 Rob Doyle
//
// This source file may be used and distributed without
// restriction provided that this copyright statement is not
// removed from the file and that any derivative work contains
// the original copyright notice and the associated disclaimer.
//
// This source file is free software; you can redistribute it
// and/or modify it under the terms of the GNU Lesser General
// Public License as published by the Free Software Foundation;
// version 2.1 of the License.
//
// This source is distributed in the hope that it will be
// useful, but WITHOUT ANY WARRANTY; without even the implied
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
// PURPOSE. See the GNU Lesser General Public License for more
// details.
//
// You should have received a copy of the GNU Lesser General
// Public License along with this source; if not, download it
// from http://www.gnu.org/licenses/lgpl.txt
//
////////////////////////////////////////////////////////////////////
//
// Comments are formatted for doxygen
//

`default_nettype none
`include "useq/crom.vh"

module INTR(clk, rst, clken, crom, dp, ubaINTR, aprINTR, reqINTP,
            curINTP, cpuINTR);

   parameter cromWidth = `CROM_WIDTH;

   input                  clk;          // Clock
   input                  rst;          // Reset
   input                  clken;        // Clock enable
   input  [0:cromWidth-1] crom;         // Control ROM Data
   input  [0:35]          dp;           // Data path
   input  [1: 7]          aprINTR;      // Arithmetic Processor request
   input  [1: 7]          ubaINTR;      // Unibus request
   output [0: 2]          reqINTP;      // Requested Interrupt Priority
   output [0: 2]          curINTP;      // Current Prioity Interrupt number
   output                 cpuINTR;      // Interrupt Request

   //
   // Microcode Decode
   //

   wire specLOADPI = `cromSPEC_EN_40 & (`cromSPEC_SEL == `cromSPEC_SEL_LOADPI);

   //
   // Datapath Interface
   //
   // Details
   //  The microcode keeps track of the current interrupt priority
   //  and the interrupt mask.
   //
   // Trace
   //  DPEB/E175
   //  DPEB/E126
   //  DPEB/E140
   //

   reg intrEN;                          // Interrupts are enabled
   reg [1:7] actINTR;                   // Interrupt mask
   reg [1:7] curINTR;                   // Current interrupt level
   reg [1:7] swINTR;                    // Software interrupt

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             actINTR <= 0;
             intrEN  <= 0;
             curINTR <= 0;
             swINTR  <= 0;
          end
        else if (clken & specLOADPI)
          begin
             actINTR <= ~dp[29:35];
             intrEN  <= ~dp[28];
             curINTR <= ~dp[21:27];
             swINTR  <= ~dp[11:17];
          end
     end

   //
   // Interrupt Enable / Masking
   //
   // Details
   //  Interrupts come from Unibus (UBA) or the Arithmetic
   //  Processor (APR), or the microcode software (SW).
   //
   //  The software interrupts are not masked.
   //
   // Trace
   //  DPEB/E174
   //  DPEB/E168
   //  DPEB/E154
   //  DPEB/E161
   //

   wire [1:7] reqINTR = ((ubaINTR[1:7] | aprINTR[1:7]) & actINTR[1:7]) | swINTR[1:7];

   //
   // Requested Interrupt Priority
   //
   // Details
   //  The MSB is present to represent that no interrupt is active.
   //
   // Trace
   //  DPEB/E147
   //

   wire [0:3] reqPRIORITY = (~intrEN    ? 4'b1000 :     // Disabled
                             reqINTR[1] ? 4'b0001 :     // Highest priority
                             reqINTR[2] ? 4'b0010 :
                             reqINTR[3] ? 4'b0011 :
                             reqINTR[4] ? 4'b0100 :
                             reqINTR[5] ? 4'b0101 :
                             reqINTR[6] ? 4'b0110 :
                             reqINTR[7] ? 4'b0111 :     // Lowest priority
                             4'b1000);                  // Nothing active

   assign reqINTP = reqPRIORITY[1:3];

   //
   // Current Interrupt Priority
   //
   // Details
   //  The MSB is present to represent that no interrupt is active.
   //
   // Trace
   //  DPEB/E134
   //

   wire [0:3] curPRIORITY = (curINTR[1] ? 4'b0001 :     // Highest priority
                             curINTR[2] ? 4'b0010 :
                             curINTR[3] ? 4'b0011 :
                             curINTR[4] ? 4'b0100 :
                             curINTR[5] ? 4'b0101 :
                             curINTR[6] ? 4'b0110 :
                             curINTR[7] ? 4'b0111 :     // Lowest priority
                             4'b1000);                  // Nothing active

   assign curINTP = curPRIORITY[1:3];

   //
   // Interrupt Request
   //
   // Details
   //  If the requested interrupt priority is higher than the
   //  current interrupt priority, an interrupt to the CPU is
   //  generated.
   //
   // Trace
   //  DPEB/E148
   //  DPEB/E167
   //

   reg cpuINTR;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          cpuINTR <= 0;
        else if (clken)
          cpuINTR <= (reqPRIORITY < curPRIORITY);
     end

endmodule
