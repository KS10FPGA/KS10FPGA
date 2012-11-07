////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      APR Device
//!
//! \details
//!
//! \todo
//!
//! \file
//!      apr.v
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

`include "config.vh"
`include "useq/crom.vh"

module APR(clk, rst, clken, crom, dp,
           pwrIRQ, nxmIRQ, consIRQ,
           aprFLAGS, bus_pi_req_out);

   parameter cromWidth = `CROM_WIDTH;

   input                       clk;             // Clock
   input                       rst;             // Reset
   input                       clken;           // Clock Enable
   input      [ 0:cromWidth-1] crom;            // Control ROM Data
   input      [ 0:35]          dp;              // Data path
   input                       pwrIRQ;         // Power Failure interrupt
   input                       nxmIRQ;         // Non existant memory interrupt
   input                       consIRQ;        // Interrupt 10
   output     [22:35]          aprFLAGS;        // APR Flags
   output reg [ 1: 7]          bus_pi_req_out;  // Bus PI Request Out

   //
   // Decode APR Flags Enable microcode
   //

   wire specAPRFLAGS = `cromSPEC_EN_20 & (`cromSPEC_SEL == `cromSPEC_SEL_APRFLAGS);
   wire specAPREN    = `cromSPEC_EN_20 & (`cromSPEC_SEL == `cromSPEC_SEL_LOADAPR);

   //
   // APR Flag Register 24
   //  DPMB/E814
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
   //  DPMB/E814
   //

   reg flag25;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          `ifdef INITRAM
          flag25 <= 1'b0;
          `else
          flag25 <= 1'bx;
          `endif
        else if (clken & specAPRFLAGS)
          flag25 <= dp[25];
     end

   //
   // APR Flag Register 26
   //  DPMB/E815
   //

   reg flagPWR;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          `ifdef INITRAM
            flagPWR <= 1'b0;
          `else
            flagPWR <= 1'bx;
          `endif
        else if (clken & specAPRFLAGS)
          if (pwrIRQ)
            flagPWR <= 1'b1;
          else
            flagPWR <= dp[26];
     end

   //
   // APR Flag Register 27
   //  DPMB/E815
   //

   reg flagNXM;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          `ifdef INITRAM
            flagNXM <= 1'b0;
          `else
            flagNXM <= 1'bx;
          `endif
        else if (clken & specAPRFLAGS)
          if (nxmIRQ)
            flagNXM <= 1'b1;
          else
            flagNXM <= dp[27];
     end

   //
   // APR Flag Register 28
   //  DPMB/E914
   //  DPMB/E915
   //

   reg flagBADDATA;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          `ifdef INITRAM
            flagBADDATA <= 1'b0;
          `else
            flagBADDATA <= 1'bx;
          `endif
        else if (clken & specAPRFLAGS)
          flagBADDATA <= dp[28];
     end

   //
   // APR Flag Register 29
   //  DPMB/E914
   //

   reg flagCORDATA;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          `ifdef INITRAM
            flagCORDATA <= 1'b0;
          `else
            flagCORDATA <= 1'bx;
         `endif
        else if (clken & specAPRFLAGS)
          flagCORDATA <= dp[29];
     end

   //
   // APR Flag Register 30
   //  DPMB/E915
   //

   reg flag30;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          `ifdef INITRAM
            flag30 <= 1'b0;
          `else
            flag30 <= 1'bx;
          `endif
        else if (clken & specAPRFLAGS)
          flag30 <= dp[30];
     end

   //
   // APR Flag Register 31
   //  DPMB/E915
   //

   reg flagCONS;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          `ifdef INITRAM
            flagCONS <= 1'b0;
          `else
            flagCONS <= 1'bx;
          `endif
        else if (clken & specAPRFLAGS)
          if (consIRQ)
            flagCONS <= 1'b1;
          else
            flagCONS <= dp[31];
     end

   //
   // APR Enable Register
   //  DPMB/E816
   //  DPMB/E916
   //  DPEB/E173
   //


   reg         flagTRAPEN;
   reg         flagPAGEEN;
   reg [24:31] flagAPREN;
   reg         flagSWINT;
   reg [ 0: 2] reqOUT;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
            `ifdef INITRAM
               flagTRAPEN <= 1'b0;
               flagPAGEEN <= 1'b0;
               flagAPREN  <= 8'b0;
               flagSWINT  <= 1'b0;
               reqOUT     <= 3'b0;
            `else
               flagTRAPEN <= 1'bx;
               flagPAGEEN <= 1'bx;
               flagAPREN  <= 8'bx;
               flagSWINT  <= 1'bx;
               reqOUT     <= 3'bx;
            `endif
          end
        else if (clken & specAPREN)
          begin
             flagTRAPEN <= dp[22];
             flagPAGEEN <= dp[23];
             flagAPREN  <= dp[24:31];
             flagSWINT  <= dp[32];
             reqOUT     <= dp[33:35];
          end
    end

   //
   // APR Interrupt Mask
   //  DPMB/E817
   //  DPMB/E917
   //  DPMB/E121
   //  DPMB/E309
   //

   wire flagINTREQ = ((flag24      & flagAPREN[24]) ||
                      (flag25      & flagAPREN[25]) ||
                      (flagPWR     & flagAPREN[26]) ||
                      (flagNXM     & flagAPREN[27]) ||
                      (flagBADDATA & flagAPREN[28]) ||
                      (flagCORDATA & flagAPREN[29]) ||
                      (flag30      & flagAPREN[30]) ||
                      (flagCONS    & flagAPREN[31]) ||
                      (flagSWINT));

   //
   // PI Request Output Decoder
   //  DPEB/E166
   //

   always @(reqOUT or flagINTREQ)
     begin
        if (flagINTREQ)
          case (reqOUT)
            3'b000 : bus_pi_req_out <= 7'b0000000;
            3'b001 : bus_pi_req_out <= 7'b1000000;
            3'b010 : bus_pi_req_out <= 7'b0100000;
            3'b011 : bus_pi_req_out <= 7'b0010000;
            3'b100 : bus_pi_req_out <= 7'b0001000;
            3'b101 : bus_pi_req_out <= 7'b0000100;
            3'b110 : bus_pi_req_out <= 7'b0000010;
            3'b111 : bus_pi_req_out <= 7'b0000001;
          endcase
        else
          bus_pi_req_out <= 7'b0000000;
     end

   //
   // FIXUPS
   //

   assign aprFLAGS[22] = flagTRAPEN;
   assign aprFLAGS[23] = flagPAGEEN;
   assign aprFLAGS[24] = flag24;
   assign aprFLAGS[25] = flag25;
   assign aprFLAGS[26] = flagPWR;
   assign aprFLAGS[27] = flagNXM;
   assign aprFLAGS[28] = flagBADDATA;
   assign aprFLAGS[29] = flagCORDATA;
   assign aprFLAGS[30] = flag30;
   assign aprFLAGS[31] = flagCONS;
   assign aprFLAGS[32] = flagINTREQ;
   assign aprFLAGS[33] = 1'b1;
   assign aprFLAGS[34] = 1'b1;
   assign aprFLAGS[35] = 1'b1;

endmodule
