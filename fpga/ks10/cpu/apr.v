////////////////////////////////////////////////////////////////////////////////
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

module APR (
      input  wire          clk,         // Clock
      input  wire          rst,         // Reset
      input  wire          clken,       // Clock Enable
      input  wire [ 0:107] crom,        // Control ROM Data
      input  wire [ 0: 35] dp,          // Data path
      input  wire          nxmINTR,     // Non existant memory interrupt
      input  wire          cslINTR,     // Interrupt from Console
      output wire [22: 35] aprFLAGS,    // APR Flags
      output reg  [ 1:  7] aprINTR      // APR Interrupt Request
   );

   //
   // Microcode Decode
   //

   wire specAPRENABLE = `cromSPEC_EN_20 & (`cromSPEC_SEL == `cromSPEC_SEL_APRENABLE);
   wire specAPRFLAGS  = `cromSPEC_EN_20 & (`cromSPEC_SEL == `cromSPEC_SEL_APRFLAGS);

   //
   // APR Flag Register 24
   //
   // Note
   //  This is strictly a software interrupt.
   //
   // Trace
   //  DPMB/E159
   //

   reg aprFLAG24;
   always @(posedge clk)
     begin
        if (rst)
          aprFLAG24 <= 1'b0;
        else if (clken & specAPRFLAGS)
          aprFLAG24 <= dp[24];
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

   reg aprFLAG25;
   always @(posedge clk)
     begin
        if (rst)
          aprFLAG25 <= 1'b0;
        else if (clken & specAPRFLAGS)
          aprFLAG25 <= dp[25];
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

   reg aprFLAG26;
   always @(posedge clk)
     begin
        if (rst)
          aprFLAG26 <= 1'b0;
        else if (clken & specAPRFLAGS)
          aprFLAG26 <= dp[26];
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

   reg aprFLAG27;
   always @(posedge clk)
     begin
        if (rst)
          aprFLAG27 <= 1'b0;
        else if (nxmINTR)
          aprFLAG27 <= 1'b1;
        else if (clken & specAPRFLAGS)
          aprFLAG27 <= dp[27];
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

   reg aprFLAG28;
   always @(posedge clk)
     begin
        if (rst)
          aprFLAG28 <= 1'b0;
        else if (clken & specAPRFLAGS)
          aprFLAG28 <= dp[28];
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

   reg aprFLAG29;
   always @(posedge clk)
     begin
        if (rst)
          aprFLAG29 <= 1'b0;
        else if (clken & specAPRFLAGS)
          aprFLAG29 <= dp[29];
     end

   //
   // APR Flag Register 30
   //
   // Note
   //  This interrupt indicates that an interval timer interrupt
   //  has occurred.   This microcode manages this bit.
   //
   // Trace
   //  DPMB/E147
   //

   reg aprFLAG30;
   always @(posedge clk)
     begin
        if (rst)
          aprFLAG30 <= 1'b0;
        else if (clken & specAPRFLAGS)
          aprFLAG30 <= dp[30];
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

   reg aprFLAG31;
   always @(posedge clk)
     begin
        if (rst)
          aprFLAG31 <= 1'b0;
        else if (cslINTR)
          aprFLAG31 <= 1'b1;
        else if (clken & specAPRFLAGS)
          aprFLAG31 <= dp[31];
     end

   //
   // APR Enable Register
   //
   // Trace
   //  DPMB/E123
   //  DPMB/E132
   //  DPEB/E173
   //

   reg         aprTRAPEN;       // Trap Enable
   reg         aprPAGEEN;       // Paging Enable
   reg [24:31] aprENABLE;       // APR Enable
   reg         aprSWINT;        // Software Interrupt
   reg [ 0: 2] aprPRI;          // APR Interrupt Request

   always @(posedge clk)
     begin
        if (rst)
          begin
             aprTRAPEN <= 1'b0;
             aprPAGEEN <= 1'b0;
             aprENABLE <= 8'b0;
             aprSWINT  <= 1'b0;
             aprPRI    <= 3'b0;
          end
        else if (clken & specAPRENABLE)
          begin
             aprTRAPEN <= dp[22];
             aprPAGEEN <= dp[23];
             aprENABLE <= dp[24:31];
             aprSWINT  <= dp[32];
             aprPRI    <= dp[33:35];
          end
    end

   //
   // APR Interrupt Mask
   //
   // Details
   //  Apr Interrupt Enables
   //
   // Trace
   //  DPMB/E154
   //  DPMB/E161
   //  DPMB/E168
   //  DPMB/E174
   //

   wire aprINTREQ = ((aprFLAG24 & aprENABLE[24]) ||
                     (aprFLAG25 & aprENABLE[25]) ||
                     (aprFLAG26 & aprENABLE[26]) ||
                     (aprFLAG27 & aprENABLE[27]) ||
                     (aprFLAG28 & aprENABLE[28]) ||
                     (aprFLAG29 & aprENABLE[29]) ||
                     (aprFLAG30 & aprENABLE[30]) ||
                     (aprFLAG31 & aprENABLE[31]) ||
                     (aprSWINT));

   //
   // APR Interrupt Request
   //
   // Details
   //  The APR can request interrupts.
   //
   // Trace
   //  DPEB/E166
   //

   always @*
     begin
        if (aprINTREQ)
          case (aprPRI)
            3'b000 : aprINTR <= 7'b0000000;
            3'b001 : aprINTR <= 7'b1000000;
            3'b010 : aprINTR <= 7'b0100000;
            3'b011 : aprINTR <= 7'b0010000;
            3'b100 : aprINTR <= 7'b0001000;
            3'b101 : aprINTR <= 7'b0000100;
            3'b110 : aprINTR <= 7'b0000010;
            3'b111 : aprINTR <= 7'b0000001;
          endcase
        else
          aprINTR <= 7'b0000000;
     end

   //
   // FIXUPS
   //

   assign aprFLAGS[22] = aprTRAPEN;
   assign aprFLAGS[23] = aprPAGEEN;
   assign aprFLAGS[24] = aprFLAG24;
   assign aprFLAGS[25] = aprFLAG25;
   assign aprFLAGS[26] = aprFLAG26;
   assign aprFLAGS[27] = aprFLAG27;
   assign aprFLAGS[28] = aprFLAG28;
   assign aprFLAGS[29] = aprFLAG29;
   assign aprFLAGS[30] = aprFLAG30;
   assign aprFLAGS[31] = aprFLAG31;
   assign aprFLAGS[32] = aprINTREQ;
   assign aprFLAGS[33] = 1'b1;
   assign aprFLAGS[34] = 1'b1;
   assign aprFLAGS[35] = 1'b1;

endmodule
