////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      Page Tables
//!
//! \details
//!     The page table translates virtual addresses/page numbers to
//!     phyical addresses/page numbers.  There are 512 virtual pages
//!     which map to 2048 pages.
//!   
//!          18                26 27                    35
//!         +--------------------+------------------------+
//!         |Virtual Page Number |        Word Number     |
//!         +--------------------+------------------------+
//!                  |                       |
//!                  |                       |
//!                 \ /                      |
//!          +-------+-------+               |
//!          |      Page     |               |
//!          |  Translation  |               |
//!          +-------+-------+               |
//!                  |                       |
//!                  |                       |
//!                 \ /                     \ /
//!     +------------------------+------------------------+
//!     |  Physical Page Number  |        Word Number     |
//!     +------------------------+------------------------+
//!      16                    26 27                    35
//!
//!
//! \note   
//!     The Page Tables use asynchronous memory which won't work
//!     in an FPGA.  Since the Page Table is addressed by the VMA
//!     register and the VMA register is loaded synchronously, we
//!     can absorb the VMA register into the Page Table Memory
//!     addressing.
//!   
//! \file
//!      page_table.v
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
// details.S
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
`include "useq/drom.vh"

module PAGE_TABLES(clk, rst, clken, crom, drom, dp, vmaFLAGS, vmaADDR,
		   pageFLAGS, pageADDR);

   parameter cromWidth = `CROM_WIDTH;
   parameter dromWidth = `DROM_WIDTH;
   
   input 		   clk;        		// Clock
   input 		   rst;         	// Reset
   input 	 	   clken;       	// Clock Enable
   input  [ 0:cromWidth-1] crom;		// Control ROM Data
   input  [ 0:dromWidth-1] drom;		// Dispatch ROM Data
   input  [ 0:35]          dp;          	// Data path
   input  [0 :13]          vmaFLAGS;		//
   input  [14:35]          vmaADDR;		// Virtural address
   output [ 0: 4]          pageFLAGS;		// Page Flags
   output [16:26]          pageADDR;		// Page Address

   //
   // vmaFLAGS
   // 

   wire vmaUSER = vmaFLAGS[0];
   
   //
   // VMA Logic
   //  DPE5/E76
   //  DPE6/E53
   //
   
   wire sweep     = `cromSPEC_EN_20 & (`cromSPEC_SEL == `cromSPEC_SEL_CLRCACHE );
   wire pageWRITE = `cromSPEC_EN_10 & (`cromSPEC_SEL == `cromSPEC_SEL_PAGEWRITE);
   wire vmaEN     = ((`cromMEM_CYCLE & `cromMEM_LOADVMA           ) | 
                     (`cromMEM_CYCLE & `cromMEM_AREAD   & `dromVMA));
   
   wire [0: 8] virtPAGE = vmaADDR[18:26];
   wire [0:15] din = {dp[18], dp[21:22], vmaUSER, 1'b0, dp[25:35]};
 
   //
   // Page memory
   //  This has been converted to synchronous memory.  
   //  The page table address is set when the vma address is set
   //
   //  The page table is interleaved with add and even memories
   //  so that the memory can be swept two entries at a time.
   //
   //  Page parity is not implemented.
   //

   //
   // Even Memory
   //  DPM6/E130
   //  DPM6/E154
   //  DPM6/E162
   //  DPM6/E184
   //
   // Odd Memory
   //  DPM6/E138
   //  DPM6/E146
   //  DPM6/E176
   //  DPM6/E192
   //
   
   reg  [0: 8] readADDR;
   reg  [0:15] pageTABLE1[0:255];
   reg  [0:15] pageTABLE2[0:255];
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          readADDR <= 9'b0;
        else if (clken & vmaEN)
          begin
             readADDR <= virtPAGE;
             if (pageWRITE)
               begin
                  if (~virtPAGE[0] | sweep) 
                    pageTABLE1[virtPAGE[1:8]] <= din;
                  if ( virtPAGE[0] | sweep)
                    pageTABLE2[virtPAGE[1:8]] <= din;
               end
          end
     end
   
   //
   // Page Table Read
   //
   
   wire [0:15] dout = (readADDR[0]) ? pageTABLE2[readADDR[1:8]] : pageTABLE1[readADDR[1:8]];

   //
   // Fixup Page RAM data
   //
               
   assign pageFLAGS = dout[0: 4];
   assign pageADDR  = dout[5:15];
   
endmodule
