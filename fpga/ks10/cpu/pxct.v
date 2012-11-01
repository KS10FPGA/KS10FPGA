////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      PXCT
//!
//! \details
//!      
//! \note
//!      
//! \todo
//!
//! \file
//!      pxct.v
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

`include "useq/crom.vh"

module PXCT(clk, rst, clken, crom, dp, pxct, pxctON, prevEN);
            
   parameter cromWidth = `CROM_WIDTH;

   input                      clk;              // clock
   input                      rst;              // reset
   input                      clken;            // clock enable
   input      [0:cromWidth-1] crom;             // Control ROM Data
   input      [0:35]          dp;               // Data path
   output reg                 pxctON;          	// PXCT on
   output reg [9:12]          pxct;             // PXCT
   output reg                 prevEN;           // 

   //
   // PCXT Register
   //  DPMA/E71
   //  DPMA/E78
   //  DPMA/E2
   //

   wire pxct_en  = `cromSPEC_EN_10 & (`cromSPEC_SEL == `cromSPEC_SEL_PXCTEN );
   wire pxct_off = `cromSPEC_EN_20 & (`cromSPEC_SEL == `cromSPEC_SEL_PXCTOFF);
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             pxctON <= 1'b0;
             pxct    <= 4'b0;
          end
        else if (clken & pxct_en)
          begin
             pxctON <= ~pxct_off;
             pxct    <= dp[9:12];
          end
     end

   //
   //
   //
   
   wire [0:2] pxct_sel  = `cromMEM_PXCTSEL;
   wire       wru_cycle = `cromMEM_WRUCYCLE;
   
   always @(pxct or pxctON or pxct_sel or wru_cycle)
     begin
        if ((pxctON & pxct[9]) |
            (pxctON & wru_cycle))
          case (pxct_sel)
            0: prevEN <= 1'b0;			// Current
            1: prevEN <= pxct[ 9];		// E1
            2: prevEN <= pxct[10];		// Not used
            3: prevEN <= pxct[10];		// D1
            4: prevEN <= pxct[11];		// BIS-SRC-EA
            5: prevEN <= pxct[11];		// E2
            6: prevEN <= pxct[12];		// BIS-DST-EA
            7: prevEN <= pxct[12];		// D2
          endcase
        else
          prevEN <= 1'b0;			// Current
     end
   
endmodule
