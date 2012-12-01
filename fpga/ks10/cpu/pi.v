////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      Priority Interrupt
//!
//! \details
//!
//! \note
//!      The highest priority is interrupt 1, the lower priority is
//!      interrupt 7.
//!
//! \todo
//!
//! \file
//!      intr.v
//!
//! \author
//!      Rob Doyle - doyle (at) cox (dot) net
//!
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

module INTR(clk, rst, clken, crom, dp, flagINTREQ,
            busINTR, aprINTR, newINTR_NUM, curINTR_NUM, cpuINTR);

   parameter cromWidth = `CROM_WIDTH;

   input                  clk;          // Clock
   input                  rst;          // Reset
   input                  clken;        // Clock enable
   input  [0:cromWidth-1] crom;         // Control ROM Data
   input  [0:35]          dp;           // Data path
   input                  flagINTREQ;   // Interrupt Request
   input  [1: 7]          aprINTR;      // Arithmetic Processor request
   input  [1: 7]          busINTR;      // Unibus request
   output [0: 2]          newINTR_NUM;  // New Prioity Interrupt number
   output [0: 2]          curINTR_NUM;  // Current Prioity Interrupt number
   output                 cpuINTR;      // Interrupt Request

   //
   // Microcode Decode
   //

   wire specLOADPI  = `cromSPEC_EN_40 & (`cromSPEC_SEL == `cromSPEC_SEL_LOADPI);
   wire specLOADAPR = `cromSPEC_EN_20 & (`cromSPEC_SEL == `cromSPEC_SEL_LOADAPR);

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
             actINTR <= 7'b0;
             intrEN  <= 1'b0;
             curINTR <= 7'b0;
             swINTR  <= 7'b0;
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

   wire [1:7] newINTR = ((busINTR[1:7] | aprINTR[1:7]) & actINTR[1:7]) | swINTR[1:7];

   //
   // New Interrupt Priority
   //
   // Details
   //  The MSB is present to represent that no interrupt is active.
   //
   // Trace
   //  DPEB/E147
   //

   wire [0:3] newINTRNUM = (~intrEN    ? 4'b1000 :      // Disabled
                            newINTR[1] ? 4'b0001 :      // Highest priority
                            newINTR[2] ? 4'b0010 :
                            newINTR[3] ? 4'b0011 :
                            newINTR[4] ? 4'b0100 :
                            newINTR[5] ? 4'b0101 :
                            newINTR[6] ? 4'b0110 :
                            newINTR[7] ? 4'b0111 :
                            4'b1000);                   // Lowest priority

   assign newINTR_NUM = newINTRNUM[1:3];

   //
   // Current Interrupt Priority
   //
   // Details
   //  The MSB is present to represent that no interrupt is active.
   //
   // Trace
   //  DPEB/E134
   //

   wire [0:3] curINTRNUM = (curINTR[1] ? 4'b0001 :      // Highest priority
                            curINTR[2] ? 4'b0010 :
                            curINTR[3] ? 4'b0011 :
                            curINTR[4] ? 4'b0100 :
                            curINTR[5] ? 4'b0101 :
                            curINTR[6] ? 4'b0110 :
                            curINTR[7] ? 4'b0111 :
                            4'b1000);                   // Lowest priority

   assign curINTR_NUM = curINTRNUM[1:3];

   //
   // Interrupt Request
   //
   // Details
   //  The priority of the new interrupt level is compared to the
   //  priority of the current interrupt level.  If the current input
   //  is a higher priority, an interrupt to the CPU is generated.
   //
   // Trace
   //  DPEB/E148
   //  DPEB/E167
   //

   reg cpuINTR;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          cpuINTR <= 1'b0;
        else if (clken)
          cpuINTR <= (newINTR_NUM < curINTR_NUM);
     end

endmodule
