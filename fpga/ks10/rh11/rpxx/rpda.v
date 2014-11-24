////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RPxx Disk Address Register (RPDA)
//
// File
//   rpda.v
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
`include "rpda.vh"

  module RPDA(clk, rst, clr,
              rpDATAI, lastSECTOR, lastTRACK, rpdaWRITE, incSECTOR, rpDA);

   input          clk;                          // Clock
   input          rst;                          // Reset
   input          clr;                          // Clear
   input  [35: 0] rpDATAI;                      // RP Data In
   input  [ 5: 0] lastSECTOR;			// Last sector number
   input  [ 5: 0] lastTRACK;			// Last track number
   input          rpdaWRITE;                    // DA Write
   input          incSECTOR;			// Increment sector/track/cylinder
   output [15: 0] rpDA;                         // rpDA Output

   //
   // RPDA Sector Address (RPSA)
   //
   // Trace
   //  M7766/SS3/E13
   //  M7766/SS3/E18
   //

   reg [5:0] rpSA;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpSA <= 0;
	else
	  if (clr)
            rpSA <= 0;
	  else if (rpdaWRITE)
	    rpSA <= `rpDA_SA(rpDATAI);
	  else if (incSECTOR)
	    begin
               if (rpSA == lastSECTOR)
		 rpSA <= 0;
	       else
		 rpSA <= rpSA + 1'b1;
	    end
     end     
   
   //
   // RPDA Track Address (RPTA)
   //
   // Trace
   //  M7766/SS3/E16
   //  M7766/SS3/E17
   //

   reg [5:0] rpTA;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpTA <= 0;
	else
	  if (clr)
            rpTA <= 0;
	  else if (rpdaWRITE)
	    rpTA <= `rpDA_TA(rpDATAI);
	  else if (incSECTOR & (rpSA == lastSECTOR))
	    begin
	       if (rpTA == lastTRACK) 
		 rpTA <= 0;
	       else
		 rpTA <= rpTA + 1'b1;
	    end
     end     

   //
   // Build the RPDA Register
   //
   
   assign rpDA = {2'b0, rpTA, 2'b0, rpSA};

endmodule
