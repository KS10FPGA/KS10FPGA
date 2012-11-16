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

`include "useq/crom.vh"

module INTR(clk, rst, clken, crom, dp, flagINTREQ, ubaINTR, ubaINTA,
            pi_new, pi_current, cpuINTR, pi_on);

   parameter cromWidth = `CROM_WIDTH;

   input                  clk;        	// Clock
   input                  rst;          // Reset
   input                  clken;        // Clock enable
   input  [0:cromWidth-1] crom;         // Control ROM Data
   input  [0:35]          dp;           // Data path
   input                  flagINTREQ;	// Interrupt Request
   input  [1: 7]          ubaINTR;      // Unibus request
   output [1: 7]          ubaINTA;  	// Interrupt Acknowledge
   output [0: 2]          pi_new;       // New Prioity Interrupt number
   output [0: 2]          pi_current;   // Current Prioity Interrupt number
   output                 cpuINTR;      // Interrupt Request
   output                 pi_on;        // PI is on

   //
   // Microcode Decode
   //
   
   wire specLOADPI  = `cromSPEC_EN_40 & (`cromSPEC_SEL == `cromSPEC_SEL_LOADPI);
   wire specLOADAPR = `cromSPEC_EN_20 & (`cromSPEC_SEL == `cromSPEC_SEL_LOADAPR);
   
   //
   // Bus Request In
   //
   // Details
   //  This synchronizes bus-based interrupt requests
   //
   // Trace
   //  DPEB/E167
   //

   reg [1:7] pi_bus;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          pi_bus <= 7'b0;
        else if (clken)
          pi_bus <= ubaINTR;
     end

   //
   // Datapath Interface
   //
   // Trace
   //  DPEB/E175
   //  DPEB/E126
   //  DPEB/E140
   //

   reg pi_on;		// PI is active
   reg [1:7] pi_act;    // active pi level
   reg [1:7] pi_cur;    // current pi level
   reg [1:7] pi_sw;     // software pi level

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             pi_act <= 7'b0;
             pi_on  <= 1'b0;
             pi_cur <= 7'b0;
             pi_sw  <= 7'b0;
          end
        else if (clken & specLOADPI)
          begin
             pi_act <= ~dp[29:35];
             pi_on  <= ~dp[28];
             pi_cur <= ~dp[21:27];
             pi_sw  <= ~dp[11:17];
          end
     end

   //
   // Interrupt enable logic
   //
   // Trace
   //  DPEB/E174
   //  DPEB/E168
   //  DPEB/E154
   //  DPEB/E161
   //

   wire [1:7] pi_req = (pi_bus & pi_act) | pi_sw;

   //
   // Interrupt Request Priority Encoder
   //
   // Trace
   //  DPEB/E147
   //

   wire [0:3] pi_req_num = (pi_req[1] ? 4'b0001 :       // Highest priority
                            pi_req[2] ? 4'b0010 :
                            pi_req[3] ? 4'b0011 :
                            pi_req[4] ? 4'b0100 :
                            pi_req[5] ? 4'b0101 :
                            pi_req[6] ? 4'b0110 :
                            pi_req[7] ? 4'b0111 :
                            4'b1000);                   // Lowest priority

   //
   // Current Interrupt Priority Encoder
   //
   // Trace
   //  DPEB/E134
   //

   wire [0:3] pi_cur_num = (pi_cur[1] ? 4'b0001 :       // Highest priority
                            pi_cur[2] ? 4'b0010 :
                            pi_cur[3] ? 4'b0011 :
                            pi_cur[4] ? 4'b0100 :
                            pi_cur[5] ? 4'b0101 :
                            pi_cur[6] ? 4'b0110 :
                            pi_cur[7] ? 4'b0111 :
                            4'b1000);                   // Lowest priority

   //
   // Interrupt Request
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
          begin
             cpuINTR <= (pi_req_num < pi_cur_num);
          end
     end

   //
   // Interrupt Acknowledge
   
   reg [0: 2] intrACK;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          `ifdef INITRAM
             intrACK <= 3'b0;
          `else
             intrACK <= 3'bx;
          `endif
          else if (clken & specLOADAPR)
            intrACK <= dp[33:35];
     end
          
   //
   // PI Request Output Decoder
   //
   // Trace
   //  DPEB/E166
   //

   reg [1:7] ubaINTA;
   always @(intrACK or flagINTREQ)
     begin
        if (flagINTREQ)
          case (intrACK)
            3'b000 : ubaINTA <= 7'b0000000;
            3'b001 : ubaINTA <= 7'b1000000;
            3'b010 : ubaINTA <= 7'b0100000;
            3'b011 : ubaINTA <= 7'b0010000;
            3'b100 : ubaINTA <= 7'b0001000;
            3'b101 : ubaINTA <= 7'b0000100;
            3'b110 : ubaINTA <= 7'b0000010;
            3'b111 : ubaINTA <= 7'b0000001;
          endcase
        else
          ubaINTA <= 7'b0000000;
     end

   assign pi_new     = pi_req_num[1:3];
   assign pi_current = pi_cur_num[1:3];

endmodule
