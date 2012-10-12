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
//!      apr_device.v
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

module APR_DEVICE(clk, rst, clken, crom, dp, trap_en, page_en, apr_flags, apr_int_req);

   parameter cromWidth = `CROM_WIDTH;
   
   input 		  clk;        	// Clock
   input 		  rst;          // Reset
   input 		  clken;        // Clock Enable
   input  [0:cromWidth-1] crom;		// Control ROM Data
   input  [0:35]          dp;           // Data path
   input                  bus_ac_lo;    // Power Failure
   input                  nxm_err;    	//
   input                  bad_data_err; //
   input		  int_10;    	//
   output reg             trap_en; 	// Trap Enable
   output reg             page_en;      // Page Enable
   output reg [0:7]       apr_flags;    // APR Flags
   output reg             apr_int_req;  // Interrupt Request

   //
   // APR Enable Register
   //  DPMB/E816
   //  DPMB/E916
   //

   wire apren = 1'b0;   // FIXME
   reg [0:7] apr_en;
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             trap_en <= 1'b0;
             page_en <= 1'b0;
             apr_en  <= 9'b000_000_000;
             intr    <= 1'b0;
          end
        else if (clken & apren)
          begin
             trap_en <= dp[22];
             page_en <= dp[23];
             apr_en  <= dp[24:31];
             intr    <= dp[32];
          end
    end

   //
   // APR Flag Register 24
   //  DPMB/E814
   //
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          apr_flag[24] <= 1'b0;
        else if (clken & apren)
          apr_flag[24] <= dp[24];
     end
   
   //
   // APR Flag Register 25
   //  DPMB/E814
   //
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          apr_flag[25] <= 1'b0;
        else if (clken & apren)
          apr_flag[25] <= dp[25];
     end
   
   //
   // APR Flag Register 26
   //  DPMB/E815
   //
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          apr_flag[26] <= 1'b0;
        else if (clken & apren)
          if (bus_ac_lo)
            apr_flag[26] <= 1'b1;
          else
            apr_flag[26] <= dp[26];
     end
   
   //
   // APR Flag Register 27
   //  DPMB/E815
   //
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          apr_flag[27] <= 1'b0;
        else if (clken & apren)
          if (nxm_err)
            apr_flag[27] <= 1'b1;
          else
            apr_flag[27] <= dp[27];
     end

   //
   // APR Flag Register 28
   //  DPMB/E914
   //  DPMB/E915
   //
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          apr_flag[28] <= 1'b0;
        else if (clken & apren)
          if (bad_data_err)
            apr_flag[28] <= 1'b1;
          else
            apr_flag[28] <= dp[28];
     end

   //
   // APR Flag Register 29
   //  DPMB/E914
   //
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          apr_flag[29] <= 1'b0;
        else if (clken & apren)
          apr_flag[29] <= dp[29];
     end
   
   //
   // APR Flag Register 30
   //  DPMB/E915
   //
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          apr_flag[30] <= 1'b0;
        else if (clken & apren)
          apr_flag[30] <= dp[30];
     end

   //
   // APR Flag Register 31
   //  DPMB/E915
   //
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          apr_flag[31] <= 1'b0;
        else if (clken & apren)
          if (int_10)
            apr_flag[31] <= 1'b1;
          else
            apr_flag[31] <= dp[31];
     end
   
   //
   // APR Interrupt Mask
   //  DPMB/E817
   //  DPMB/E917
   //  DPMB/E121
   //  DPMB/E309
   //
   
   assign apr_int_req = ((apr_flag[24] & apr_en[24]) ||
                         (apr_flag[25] & apr_en[25]) ||
                         (apr_flag[26] & apr_en[26]) ||
                         (apr_flag[27] & apr_en[27]) ||
                         (apr_flag[28] & apr_en[28]) ||
                         (apr_flag[29] & apr_en[29]) ||
                         (apr_flag[30] & apr_en[30]) ||
                         (apr_flag[31] & apr_en[31]) ||
                         (intr));
   
endmodule
