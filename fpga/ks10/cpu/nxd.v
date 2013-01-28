////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   IO Latch
//
// Details
//
// File
//   iolatch.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
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

`default_nettype none
`include "useq/crom.vh"
`include "vma.vh"

module IOLATCH(clk, rst, clken, crom, vmaFLAGS, iolatch);
   
   parameter cromWidth = `CROM_WIDTH;

   input                  clk;  	// Clock
   input                  rst;      	// Reset
   input                  clken;    	// Clock Enable
   input  [0:cromWidth-1] crom;  	// Control ROM Data
   input  [0:13]          vmaFLAGS;     // VMA Flags
   output                 iolatch;	// IO Latch
   
   //
   // Microcode Decode
   //
   
   wire selCLRIOLAT = `cromSPEC_EN_10 & (`cromSPEC_SEL == `cromSPEC_SEL_CLRIOLAT);
   
   //
   // VMA Flags
   //
   
   wire vmaIOCYCLE  = `vmaIOCYCLE(vmaFLAGS);
   
   //
   // IO Latch
   //
   // Trace
   //  DPEA/E99
   //  DPEA/E93
   //

   reg iolatch;
   reg lastVMAIO;
   reg [0:1] count;
   
   always @(posedge clk or posedge rst)
    begin
        if (rst)
          begin
             iolatch   <= 0;
             lastVMAIO <= 0;
             count     <= 3;
          end
        else if (clken)
          begin
             if (vmaIOCYCLE & ~lastVMAIO)
               begin
                  iolatch <= 1;
                  count   <= 3;
               end
             else if (count == 0)
               begin
                  iolatch <= 0;
               end
             else
               begin
                  count <= count - 1'b1;
               end
             lastVMAIO <= vmaIOCYCLE;
          end
    end

 endmodule
