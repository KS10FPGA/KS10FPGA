////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   APR Device
//
// Details
//
// File
//   apr.v
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

`default_nettype none
`include "useq/crom.vh"

module APR(clk, rst, clken, crom, dp, nxmINTR, cslINTR, aprFLAGS, aprINTR);

   parameter cromWidth = `CROM_WIDTH;

   input                   clk;         // Clock
   input                   rst;         // Reset
   input                   clken;       // Clock Enable
   input  [ 0:cromWidth-1] crom;        // Control ROM Data
   input  [ 0:35]          dp;          // Data path
   input                   nxmINTR;     // Non existant memory interrupt
   input                   cslINTR;     // Interrupt from Console
   output [22:35]          aprFLAGS;    // APR Flags
   output [ 1: 7]          aprINTR;     // APR Interrupt Request

   //
   // Microcode Decode
   //

   wire specLOADAPR  = `cromSPEC_EN_20 & (`cromSPEC_SEL == `cromSPEC_SEL_LOADAPR);
   wire specAPRFLAGS = `cromSPEC_EN_20 & (`cromSPEC_SEL == `cromSPEC_SEL_APRFLAGS);

   //
   // APR Flag Register 24
   //
   // Note
   //  This is strictly a software interrupt.
   //
   // Trace
   //  DPMB/E159
   //

   reg flag24;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          flag24 <= 1'b0;
        else if (clken & specAPRFLAGS)
          flag24 <= dp[24];
     end

   //
   // APR Flag Register 25
   //
   // Note
   //  This KS10 can set this bit to generate an interrupt to the
   //  KS10 console.
   //
   // Trace
   //  DPMB/E159
   //

   reg flag25;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          flag25 <= 1'b0;
        else if (clken & specAPRFLAGS)
          flag25 <= dp[25];
     end

   //
   // APR Flag Register 26
   //
   // Note
   //  This interrupt indicates that an power fail condition
   //  exists.  This interrupt is not implemented.
   //
   // Trace
   //  DPMB/E158
   //

   reg flag26;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          flag26 <= 1'b0;
        else if (clken & specAPRFLAGS)
          flag26 <= dp[26];
     end

   //
   // APR Flag Register 27
   //
   // Note
   //  This interrupt indicates that non-existant memory has been
   //  accessed.
   //
   // Trace
   //  DPMB/E139
   //

   reg flag27;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          flag27 <= 1'b0;
        else if (nxmINTR)
          flag27 <= 1'b1;
        else if (clken & specAPRFLAGS)
          flag27 <= dp[27];
     end

   //
   // APR Flag Register 28
   //
   // Note
   //  This interrupt indicates that an uncorrectable memory error
   //  has occurred.  This is not implemented in the FPGA.
   //
   // Trace
   //  DPMB/E139
   //

   reg flag28;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          flag28 <= 1'b0;
        else if (clken & specAPRFLAGS)
          flag28 <= dp[28];
     end

   //
   // APR Flag Register 29
   //
   // Note
   //  This interrupt indicates that an correctable memory error
   //  has occurred.   This is not implemented in the FPGA.
   //
   // Trace
   //  DPMB/E147
   //

   reg flag29;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          flag29 <= 1'b0;
        else if (clken & specAPRFLAGS)
          flag29 <= dp[29];
     end

   //
   // APR Flag Register 30
   //
   // Note
   //  This interrupt indicates that an interval timer interrup
   //  has occurred.   This microcode manages this bit.
   //
   // Trace
   //  DPMB/E147
   //

   reg flag30;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          flag30 <= 1'b0;
        else if (clken & specAPRFLAGS)
          flag30 <= dp[30];
     end

   //
   // APR Flag Register 31
   //
   // Note
   //  This interrupt indicates that the Console has requested
   //  a KS10 Interrupt.
   //
   // Trace
   //  DPMB/E158
   //

   reg flag31;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          flag31 <= 1'b0;
        else if (cslINTR)
          flag31 <= 1'b1;
        else if (clken & specAPRFLAGS)
          flag31 <= dp[31];
     end

   //
   // APR Enable Register
   //
   // Trace
   //  DPMB/E123
   //  DPMB/E132
   //  DPEB/E173
   //

   reg         flagTRAPEN;      // Trap Enable
   reg         flagPAGEEN;      // Paging Enable
   reg [24:31] flagAPREN;       // APR Enable
   reg         flagSWINT;       // Software Interrupt
   reg [ 0: 2] flagINTR;        // APR Interrupt Request

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             flagTRAPEN <= 1'b0;
             flagPAGEEN <= 1'b0;
             flagAPREN  <= 8'b0;
             flagSWINT  <= 1'b0;
             flagINTR   <= 3'b0;
          end
        else if (clken & specLOADAPR)
          begin
             flagTRAPEN <= dp[22];
             flagPAGEEN <= dp[23];
             flagAPREN  <= dp[24:31];
             flagSWINT  <= dp[32];
             flagINTR   <= dp[33:35];
          end
    end

   //
   // APR Interrupt Mask
   //
   // Details
   //  This masks the disabled interrupts.
   //
   // Trace
   //  DPMB/E154
   //  DPMB/E161
   //  DPMB/E168
   //  DPMB/E174
   //

   wire flagINTREQ = ((flag24 & flagAPREN[24]) ||
                      (flag25 & flagAPREN[25]) ||
                      (flag26 & flagAPREN[26]) ||
                      (flag27 & flagAPREN[27]) ||
                      (flag28 & flagAPREN[28]) ||
                      (flag29 & flagAPREN[29]) ||
                      (flag30 & flagAPREN[30]) ||
                      (flag31 & flagAPREN[31]) ||
                      (flagSWINT));

   //
   // APR Interrupt Request
   //
   // Details
   //  The APR can request interrupts.
   //
   // Trace
   //  DPEB/E166
   //

   reg [1:7] aprINTR;
   always @(flagINTREQ or flagINTR)
     begin
        aprINTR <= 7'b0000000;
        if (flagINTREQ)
          case (flagINTR)
            3'b000 : aprINTR <= 7'b0000000;
            3'b001 : aprINTR <= 7'b1000000;
            3'b010 : aprINTR <= 7'b0100000;
            3'b011 : aprINTR <= 7'b0010000;
            3'b100 : aprINTR <= 7'b0001000;
            3'b101 : aprINTR <= 7'b0000100;
            3'b110 : aprINTR <= 7'b0000010;
            3'b111 : aprINTR <= 7'b0000001;
            default: aprINTR <= 7'b0000000;
          endcase
     end

   //
   // FIXUPS
   //

   assign aprFLAGS[22] = flagTRAPEN;
   assign aprFLAGS[23] = flagPAGEEN;
   assign aprFLAGS[24] = flag24;
   assign aprFLAGS[25] = flag25;
   assign aprFLAGS[26] = flag26;
   assign aprFLAGS[27] = flag27;
   assign aprFLAGS[28] = flag28;
   assign aprFLAGS[29] = flag29;
   assign aprFLAGS[30] = flag30;
   assign aprFLAGS[31] = flag31;
   assign aprFLAGS[32] = flagINTREQ;
   assign aprFLAGS[33] = 1'b1;
   assign aprFLAGS[34] = 1'b1;
   assign aprFLAGS[35] = 1'b1;

endmodule
