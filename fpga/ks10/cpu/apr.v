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
//  Copyright (C) 2009, 2012 Rob Doyle
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

`include "microcontroller/crom.vh"

module APR(clk, rst, clken, crom, dp,
           bus_ac_lo, nxm_err, bad_data_err, int_10,
           trapEN, pageEN,
           aprFLAGS, apr_int_req, bus_pi_req_out);

   parameter cromWidth = `CROM_WIDTH;

   input                       clk;      	// Clock
   input                       rst;          	// Reset
   input                       clken;        	// Clock Enable
   input      [ 0:cromWidth-1] crom;		// Control ROM Data
   input      [ 0:35]          dp;           	// Data path
   input                       bus_ac_lo;    	// Power Failure
   input                       nxm_err;    	//
   input                       bad_data_err; 	//
   input                       int_10;    	// 
   output reg                  trapEN; 		// Trap Enable
   output reg                  pageEN;      	// Page Enable
   output reg [24:31]          aprFLAGS;    	// APR Flags
   output                      apr_int_req;  	// Interrupt Request
   output reg [ 1: 7]          bus_pi_req_out;	// Bus PI Request Out
  
   //
   // Decode APR Flags Enable microcode
   //
   
   wire aprENFLAGS = `cromSPEC_EN_20 && (`cromSPEC_SEL == `cromSPEC_SEL_APRFLAGS);
   
   //
   // APR Flag Register 24
   //  DPMB/E814
   //
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          aprFLAGS[24] <= 1'b0;
        else if (clken & aprENFLAGS)
          aprFLAGS[24] <= dp[24];
     end
   
   //
   // APR Flag Register 25
   //  DPMB/E814
   //
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          aprFLAGS[25] <= 1'b0;
        else if (clken & aprENFLAGS)
          aprFLAGS[25] <= dp[25];
     end
   
   //
   // APR Flag Register 26
   //  DPMB/E815
   //
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          aprFLAGS[26] <= 1'b0;
        else if (clken & aprENFLAGS)
          if (bus_ac_lo)
            aprFLAGS[26] <= 1'b1;
          else
            aprFLAGS[26] <= dp[26];
     end
   
   //
   // APR Flag Register 27
   //  DPMB/E815
   //
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          aprFLAGS[27] <= 1'b0;
        else if (clken & aprENFLAGS)
          if (nxm_err)
            aprFLAGS[27] <= 1'b1;
          else
            aprFLAGS[27] <= dp[27];
     end

   //
   // APR Flag Register 28
   //  DPMB/E914
   //  DPMB/E915
   //
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          aprFLAGS[28] <= 1'b0;
        else if (clken & aprENFLAGS)
          if (bad_data_err)
            aprFLAGS[28] <= 1'b1;
          else
            aprFLAGS[28] <= dp[28];
     end

   //
   // APR Flag Register 29
   //  DPMB/E914
   //
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          aprFLAGS[29] <= 1'b0;
        else if (clken & aprENFLAGS)
          aprFLAGS[29] <= dp[29];
     end
   
   //
   // APR Flag Register 30
   //  DPMB/E915
   //
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          aprFLAGS[30] <= 1'b0;
        else if (clken & aprENFLAGS)
          aprFLAGS[30] <= dp[30];
     end

   //
   // APR Flag Register 31
   //  DPMB/E915
   //
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          aprFLAGS[31] <= 1'b0;
        else if (clken & aprENFLAGS)
          if (int_10)
            aprFLAGS[31] <= 1'b1;
          else
            aprFLAGS[31] <= dp[31];
     end

   //
   // APR Enable Register
   //  DPMB/E816
   //  DPMB/E916
   //  DPEB/E173
   //
   
   wire aprEN = `cromSPEC_EN_20 & (`cromSPEC_SEL == `cromSPEC_SEL_LOADAPR);
   reg  intr;
   reg [ 0: 2] req_out;
   reg [24:31] apr_en;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             trapEN  <= 1'b0;
             pageEN  <= 1'b0;
             apr_en  <= 9'b000_000_000;
             intr    <= 1'b0;
             req_out <= 3'b0;
          end
        else if (clken & aprEN)
          begin
             trapEN  <= dp[22];
             pageEN  <= dp[23];
             apr_en  <= dp[24:31];
             intr    <= dp[32];
             req_out <= dp[33:35];
          end
    end
   
   //
   // APR Interrupt Mask
   //  DPMB/E817
   //  DPMB/E917
   //  DPMB/E121
   //  DPMB/E309
   //
   
   wire apr_int_req = ((aprFLAGS[24] & apr_en[24]) ||
                       (aprFLAGS[25] & apr_en[25]) ||
                       (aprFLAGS[26] & apr_en[26]) ||
                       (aprFLAGS[27] & apr_en[27]) ||
                       (aprFLAGS[28] & apr_en[28]) ||
                       (aprFLAGS[29] & apr_en[29]) ||
                       (aprFLAGS[30] & apr_en[30]) ||
                       (aprFLAGS[31] & apr_en[31]) ||
                       (intr));
   
   //
   // 
   //  DPEB/E166
   //
   
   always @(req_out or apr_int_req)
     begin
        if (apr_int_req)
          case (req_out)
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
   
endmodule
