////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      Cache Directory
//!
//! \details
//!
//! \note   
//!   
//! \file
//!      cache.v
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

`include "microcontroller/crom.vh"
`include "microcontroller/drom.vh"

module CACHE(clk, rst, clken, crom, dp,
             vma, vma_physical, vma_user,
             cache_valid,
             cache_user,
             cache_hit,
             cache_hit_en,
             cache_addr[18:26]);

   parameter cromWidth = `CROM_WIDTH;
   
   input 		   clk;        		// Clock
   input 		   rst;         	// Reset
   input 	 	   clken;       	// Clock Enable
   input  [ 0:cromWidth-1] crom;		// Control ROM Data
   input  [ 0:35]          dp;          	// Data path
   input  [14:35]          vma;			// Virtural address
   input                   vma_user;		//
   output                  page_valid;		//
   output                  page_writeable;	//
   output                  page_cacheable;	//
   output                  cache_hit;		//
   output [16:26]          page_number;		//
   
   //
   // VMA Logic
   //  DPE5/E76
   //  DPE6/E53
   //
   
// wire sweep      = `cromSPEC_EN_20 & (`cromSPEC_SEL == `cromSPEC_SEL_CLRCACHE);

   reg  [0:11] cache_dir[0:511];
   reg  [0: 8] read_addr;
   wire [0: 8] virt_page = vma[18:26];
   wire [0:11] din = {vma_phyical, 1'b0, vma_user, vma[18:35]};
   
   //
   // Page memory
   //
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          read_addr <= 9'b0;
        else if (clken & vma_en)
          begin
             if (page_write)
               cache_dir[virt_page] <= din;
             read_addr <= virt_page;
          end
     end

   //
   // Fixup Page RAM data
   //
   
   wire [0:15] dout      = cache_dir[read_addr];
   
endmodule
