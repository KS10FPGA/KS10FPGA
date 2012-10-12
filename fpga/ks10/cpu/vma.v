////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      Virtual Memory Address
//!
//! \details
//!
//! \todo
//!
//! \file
//!      vma.v
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
`include "microcontroller/drom.vh"

module VMA(clk, rst, clken, crom, drom, dp, execute, user_flag,
           pcu_flag, previous_en, wru_cycle, vector_cycle,
           iobyte_cycle, vma_sweep, vma_extended, vma_user,
           vma_previous, vma_physical, vma_fetch, vma_io,
           vma_ac_ref, vma);

   parameter cromWidth = `CROM_WIDTH;
   parameter dromWidth = `DROM_WIDTH;
   
   input 		  clk;        	// Clock
   input 		  rst;          // Reset
   input 		  clken;        // Clock Enable
   input  [0:cromWidth-1] crom;		// Control ROM Data
   input  [0:dromWidth-1] drom;		// Dispatch ROM Data
   input  [0:35]          dp;           // Data path
   input                  execute;  	//
   input                  user_flag;    // User Flag
   input                  pcu_flag;  	// Previous Context User (PCU) Flag
   input                  previous_en;  //
   output reg             wru_cycle;    // WRU Cycle
   output reg             vector_cycle; // Vector Cycle
   output reg             iobyte_cycle; // IO Byte Cycle
   output reg             vma_sweep;    // VMA Sweep
   output reg             vma_extended; // VMA Extended
   output reg             vma_user;	// VMA User
   output reg             vma_previous; // VMA Previous
   output reg             vma_physical; // VMA Physical
   output reg             vma_fetch;    // VMA Fetch
   output reg             vma_io; 	// VMA IO
   output                 vma_ac_ref;   // VMA references an AC
   output reg [14:35]     vma;  	// Virtual Memory Address

   //
   // VMA Logic
   //  DPE5/E76
   //  DPE6/E53
   //
   
   wire cache_sweep      = `cromSPEC_EN_20 & (`cromSPEC_SEL == `cromSPEC_SEL_CLRCACHE);
   wire previous         = `cromSPEC_EN_20 & (`cromSPEC_SEL == `cromSPEC_SEL_PREVIOUS);
   wire dromVMA          = `dromVMA;		// 
   wire mem_load_vma     = `cromMEM_LOADVMA;	// Load the VMA
   wire mem_extaddr      = `cromMEM_EXTADDR;	// Put VMA[14:17] Bits onto Bus
   wire mem_aread        = `cromMEM_AREAD;	// Let DROM select type and load VMA (see dromVMA)
   wire mem_dp_funct     = `cromMEM_DPFUNC;	// This is a DP function.  Use dp[0:13] instead of cromNUM[0:13]
   wire mem_cycle        = `cromMEM_CYCLE;	// Start/complete MEM or IO Cycle
   wire mem_force_exec   = `cromMEM_FORCEEXEC;	// Force exec mode reference
   wire mem_force_user   = `cromMEM_FORCEUSER;	// Force user mode reference
   wire mem_fetch_cycle  = `cromMEM_FETCHCYCLE;	// This is an instruction fetch cycle
   wire mem_wru_cycle    = `cromMEM_WRUCYCLE;	// This is a WRU cycle
   wire mem_iobyte_cycle = `cromMEM_IOBYTECYCLE;// This is a byte cycle
   wire mem_physical     = `cromMEM_PHYSICAL;	// No paging on this cycle
     
   //
   // VMA EN
   //  DPE3/E76
   //  DPE3/E53
   //
        
   wire vma_en = ((mem_cycle & mem_load_vma) | 
                  (mem_cycle & mem_aread & dromVMA) |
                  (cache_sweep));

   //
   // VMA USER, VMA PREV
   //  DPM4/E55
   //  DPM4/E56
   //  DPM4/E74
   //  DPM4/E82
   //
   
   wire prev = previous_en | previous;
   
   wire user = ((~mem_force_exec & ~execute & user_flag) |
                (mem_fetch_cycle & user_flag) |
                (mem_force_user) |
                (pcu_flag & previous));
   
   //
   // VMA Register
   //  DPM4/E103
   //  DPM4/E152
   //  DPM4/E137
   //  DPM4/E175
   //  DPM4/E182
   //  DPM4/E183
   //  DPM4/E97
   //  DPM4/E90
   //  DPM4/E168
   //  DPM4/E115
   //
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             vma_sweep     <=  1'b0;
             vma_extended  <=  1'b0;
             vma           <= 22'b0;
             vma_user      <=  1'b0;
             vma_previous  <=  1'b0;
             wru_cycle     <=  1'b0;
             vma_fetch     <=  1'b0;
             vector_cycle  <=  1'b0;
             iobyte_cycle  <=  1'b0;
             vma_io        <=  1'b0;
             vma_physical  <=  1'b0;
          end
        else if (clken & vma_en)
          begin
             vma_sweep     <= cache_sweep;
             vma_extended  <= mem_extaddr;
             vma           <= dp[14:35];
             if (mem_dp_funct)
               begin
                  vma_user     <= dp[0];
                  vma_fetch    <= dp[2];
                  vma_physical <= dp[8];
                  vma_previous <= dp[9];
                  vma_io       <= dp[10];
                  wru_cycle    <= dp[11];
                  vector_cycle <= dp[12];
                  iobyte_cycle <= dp[13];
               end
             else
               begin
                  vma_user     <= user;
                  vma_fetch    <= mem_fetch_cycle;
                  vma_physical <= mem_physical;
                  vma_previous <= prev;
                  vma_io       <= 1'b0;
                  wru_cycle    <= 1'b0;
                  vector_cycle <= 1'b0;
                  iobyte_cycle <= 1'b0;
               end
          end
    end

   //
   // The ACs are always physically addressed and are located
   // at address 0 to 15.  Note that the comparison igores
   // the 4 lowest address lines (vma[32:35]) and checks that
   // the upper address lines (vma[18:31]) are all zero.
   //
   
   assign vma_ac_ref = vma_physical && (vma[18:31] == 14'b0);
   
endmodule
