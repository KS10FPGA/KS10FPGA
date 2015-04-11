////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Priority Interrupt
//
// Details
//
//   The PI Register internal format is:
//
//        0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
//      +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//   PI |              MBZ               |   Program Request  |   MBZ  |   PI In progress   |EN|    PI Enabled      |
//      |                                | 1  2  3  4  5  6  7|        | 1  2  3  4  5  6  7|  | 1  2  3  4  5  6  7|
//      +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//
//   This matches the format of the CONI PI (RDPI) instruction.
//
// Note
//   The highest priority is interrupt 1, the lower priority is interrupt 7.
//
// File
//   pi.v
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

module PI(clk, rst, clken, crom, dp, ubaINTR, aprINTR, piREQPRI, piCURPRI, piINTR);

   parameter cromWidth = `CROM_WIDTH;

   input                  clk;          // Clock
   input                  rst;          // Reset
   input                  clken;        // Clock enable
   input  [0:cromWidth-1] crom;         // Control ROM Data
   input  [0:35]          dp;           // Data path
   input  [1: 7]          aprINTR;      // Arithmetic Processor request
   input  [1: 7]          ubaINTR;      // Unibus request
   output [0: 2]          piREQPRI;     // Requested Interrupt Priority
   output [0: 2]          piCURPRI;     // Current Prioity Interrupt number
   output                 piINTR;       // Interrupt Request

   //
   // Microcode Decode
   //

   wire specLOADPI = `cromSPEC_EN_40 & (`cromSPEC_SEL == `cromSPEC_SEL_LOADPI);

   //
   // PI Register
   //
   // Details
   //  The microcode keeps track of the current interrupt priority and the
   //  interrupt mask in the PI register of the ALU.
   //
   // Trace
   //  DPEB/E175
   //  DPEB/E126
   //  DPEB/E140
   //

   reg [1:7] piPROGREQ;                 // PI Program request
   reg [1:7] piINPROG;                  // PI In progress
   reg       piSYSEN;                   // PI System is enabled
   reg [1:7] piENABLED;                 // PI Enabled (Interrupt Mask)

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             piPROGREQ <= 0;
             piINPROG  <= 0;
             piSYSEN   <= 0;
             piENABLED <= 0;
          end
        else if (clken & specLOADPI)
          begin
             piPROGREQ <= ~dp[11:17];
             piINPROG  <= ~dp[21:27];
             piSYSEN   <= ~dp[28];
             piENABLED <= ~dp[29:35];
          end
     end

   //
   // Interrupt Enable / Masking
   //
   // Details
   //  Interrupts come from Unibus (UBA) or the Arithmetic Processor (APR), or
   //  the software (PROG REQ).
   //
   //  The software interrupts are not masked.
   //
   // Trace
   //  DPEB/E174
   //  DPEB/E168
   //  DPEB/E154
   //  DPEB/E161
   //

   wire [1:7] piREQEST = ((ubaINTR[1:7] | aprINTR[1:7]) & piENABLED[1:7]) | piPROGREQ[1:7];

   //
   // Requested Interrupt Priority
   //
   // Details
   //  The MSB is present to represent that no interrupt is active.
   //
   // Trace
   //  DPEB/E147
   //

   wire [0:3] reqPRI = (!piSYSEN    ? 4'b1000 : // Disabled
                        piREQEST[1] ? 4'b0001 : // Chan 1 - Highest priority
                        piREQEST[2] ? 4'b0010 : // Chan 2
                        piREQEST[3] ? 4'b0011 : // Chan 3
                        piREQEST[4] ? 4'b0100 : // Chan 4
                        piREQEST[5] ? 4'b0101 : // Chan 5
                        piREQEST[6] ? 4'b0110 : // Chan 6
                        piREQEST[7] ? 4'b0111 : // Chan 7 - Lowest priority
                        4'b1000);               // Nothing active

   assign piREQPRI = reqPRI[1:3];

   //
   // Current Interrupt Priority
   //
   // Details
   //  The MSB is present to represent that no interrupt is active.
   //
   // Trace
   //  DPEB/E134
   //

   wire [0:3] curPRI = (piINPROG[1] ? 4'b0001 : // Chan 1 - Highest priority
                        piINPROG[2] ? 4'b0010 : // Chan 2
                        piINPROG[3] ? 4'b0011 : // Chan 3
                        piINPROG[4] ? 4'b0100 : // Chan 4
                        piINPROG[5] ? 4'b0101 : // Chan 5
                        piINPROG[6] ? 4'b0110 : // Chan 6
                        piINPROG[7] ? 4'b0111 : // Chan 7 - Lowest priority
                        4'b1000);               // Nothing active

   assign piCURPRI = curPRI[1:3];

   //
   // Interrupt Request
   //
   // Details
   //  If the requested interrupt priority is higher than the current interrupt
   //  priority, an interrupt to the CPU is generated.
   //
   // Trace
   //  DPEB/E148
   //  DPEB/E167
   //

   reg piINTR;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          piINTR <= 0;
        else if (clken)
          piINTR <= (reqPRI < curPRI);
     end

endmodule
