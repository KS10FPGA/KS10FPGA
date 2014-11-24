////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RPxx Disk Cylinder Address Register (RPDC)
//
// File
//   rpdc.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2014 Rob Doyle
//
// This source file may be used and distributed without restriction provided
// that this copyright statement is not removed from the file and that any
// derivative work contains the original copyright notice and the associated
// disclaimer.
//
// This source file is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as published by the
// Free Software Foundation; version 2.1 of the License.
//
// This source is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License
// for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this source; if not, download it from
// http://www.gnu.org/licenses/lgpl.txt
//
////////////////////////////////////////////////////////////////////////////////

`default_nettype none
`include "rpdc.vh"

  module RPDC(clk, rst, clr, lastSECTOR, lastTRACK, rpSA, rpTA, rpDATAI,
	      rpdcWRITE, incSECTOR, rpDC);
   
   input          clk;                          // Clock
   input          rst;                          // Reset
   input          clr;                          // Clear
   input  [ 5: 0] lastSECTOR;			// Last sector number
   input  [ 5: 0] lastTRACK;			// Last track number
   input  [ 5: 0] rpSA;				// Sector address
   input  [ 5: 0] rpTA;				// Track address
   input  [35: 0] rpDATAI;                      // RP Data In
   input          rpdcWRITE;                    // DC Write
   input          incSECTOR;			// Increment sector
   output [15: 0] rpDC;                         // rpDC Output

   //
   // RPDC Desired Cylinder Address (DCA)
   //
   // Trace
   //

   reg [9:0] rpDCA;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpDCA <= 0;
	else
	  if (clr)
            rpDCA <= 0;
	  else if (rpdcWRITE)
	    rpDCA <= `rpDC_DCA(rpDATAI);
	  else if (incSECTOR & (rpTA == lastTRACK) & (rpSA == lastSECTOR))
	    rpDCA <= rpDCA + 1'b1;
     end     

   //
   // Build the RPDC Register
   //
   
   assign rpDC = {6'b0, rpDCA};

endmodule
