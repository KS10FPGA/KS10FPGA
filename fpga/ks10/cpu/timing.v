////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      Read/Write Timing
//!
//! \details
//!
//! \note
//!
//! \todo
//!
//! \file
//!      timing.v
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
`include "useq/drom.vh"

module TIMING(clk, rst, crom, vmaFLAGS, clken);

   parameter cromWidth = `CROM_WIDTH;

   input                  clk;                 	// Clock
   input                  rst;                 	// Reset
   input  [0:cromWidth-1] crom;                	// Control ROM Data
   input  [0:13]          vmaFLAGS;     	// VMA Flags
   output 		  clken;		// Clock Enable

   //
   // VMA Flags
   //
   
   wire vmaREADCYCLE  = vmaFLAGS[3];
   wire vmaWRITECYCLE = vmaFLAGS[5];

   //
   //
   //
   
   wire memWAIT = vmaREADCYCLE | vmaWRITECYCLE | `cromFMWRITE;

   //
   //
   //

   reg 	asdf;
   always @(posedge rst or posedge clk)
     begin
       if (rst)
	 asdf <= 1'b0;
       else
	 asdf <= memWAIT;
     end

   assign clken = 1'b1;//~memWAIT | asdf;
   
endmodule
