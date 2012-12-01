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

`default_nettype none
`include "useq/crom.vh"
`include "useq/drom.vh"

module CACHE(clk, rst, clken, crom, dp, vmaFLAGS, vmaADDR,
             vmaACREF, stop_main_memory, memoryCYCLE, memoryWAIT,
             cacheVALID, cacheUSER, cacheHIT, cacheHITEN, cacheADDR);

   parameter cromWidth = `CROM_WIDTH;
   
   input                   clk;                 // Clock
   input                   rst;                 // Reset
   input                   clken;               // Clock Enable
   input  [ 0:cromWidth-1] crom;                // Control ROM Data
   input  [ 0:35]          dp;                  // Data path
   input  [ 0:13]          vmaFLAGS;            // VMA Flags
   input  [14:35]          vmaADDR;             // VMA Address
   input                   vmaACREG;
   input                   stop_main_memory;
   input                   memoryCYCLE;
   input                   memoryWAIT;
   output                  cacheVALID;          // Cache Valid
   output                  cacheUSER;           // Cache User
   output [18:26]          cacheADDR;           // Cache Addr                  
   
   //
   // VMA Flags
   //

   wire vmaUSER        = vmaFLAGS[ 0];
   wire vmaREADCYCLE   = vmaFLAGS[ 3];
   wire vmaCACHEIHN    = vmaFLAGS[ 7];
   wire vmaPHYSICAL    = vmaFLAGS[ 8];   
   
   //
   // VMA Logic
   //  DPE5/E76
   //  DPE6/E53
   //
   
   wire [0: 8] virtPAGE   = vmaADDR[18:26];
   wire [0:11] din        = {vmaPHYICAL, 1'b0, vmaUSER, vmaADDR[18:35]};
   wire        sweep      = `cromSPEC_EN_20 & (`cromSPEC_SEL == `cromSPEC_SEL_CLRCACHE);
   wire        cacheWRITE = (~vmaACREF & stop_main_memory & memoryCYCLE & memoryWAIT);
   wire        vmaEN      = ((`cromMEM_CYCLE & `cromMEM_LOADVMA           ) | 
                             (`cromMEM_CYCLE & `cromMEM_AREAD   & `dromVMA));
   
   //
   // Cache Directory Memory
   //
   
   reg  [0: 8] readADDR;
   reg  [0:11] cacheDIR1[0:255];
   reg  [0:11] cacheDIR1[0:255];
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          readADDR <= 9'b0;
        else if (clken & vmaEN)
          begin
             readADDR <= virtPAGE;
             if (cacheWRITE)
               begin
                  if (~virtPAGE[0] | sweep) 
                    cacheDIR1[virtPAGE[1:8]] <= din;
                  if ( virtPAGE[0] | sweep)
                    cacheDIR2[virtPAGE[1:8]] <= din;
               end
          end
     end

   //
   // Cache Directory Read
   //
   
   wire [0:15] dout  = (readADDR[0]) ? cacheDIR2[readADDR[1:8]] : cacheDIR1[readADDR[1:8]];
   assign cacheVALID = dout[0];
   assign cacheUSER  = dout[2];
   assign cacheADDR  = dout[3:11];
   
   wire  cacheHITEN  = ((int_or_err                  ) &
                        (pageVALID                   ) &
                        (~pageFAIL[5]                ) &
                        (~pageFAIL[6]                ) & 
                        (pageEN                      ) &
                        (vmaREADCYCLE                ) &
                        (~vmaCACHEINH                ) &
                        (~vmaPHYSICAL                ) &
                        (pageCACHEABLE               ) &
                        (cacheENABLE                 ) & 
                        (cacheVALID                  ) &
                        (cacheUSER     == vmaUSER    ) &
                        (cacheADDR[18] == vmaADDR[18]) & 
                        (cacheADDR[19] == vmaADDR[19]) & 
                        (cacheADDR[20] == vmaADDR[20]) & 
                        (cacheADDR[21] == vmaADDR[21]) & 
                        (cacheADDR[22] == vmaADDR[22]) & 
                        (cacheADDR[23] == vmaADDR[23]) & 
                        (cacheADDR[24] == vmaADDR[24]) & 
                        (cacheADDR[25] == vmaADDR[25]) &
                        (cacheADDR[26] == vmaADDR[26]));

   wire  cacheHIT  = (cacheHITEN & ~vma_just_loaded);
   
endmodule
