////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      Debug Hack
//!
//! \details
//!
//! \todo
//!
//! \file
//!      debug.v
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


module DEBUG(clk, rst, clken, debugDATA, debugADDR);

   // synthesis translate_off
   
   input         clk;      	// Clock
   input         rst;      	// Reset
   input         clken;    	// Clock Enable
   input  [0:35] debugDATA;	// DEBUG Data
   output [0: 3] debugADDR;	// DEBUG Address

   //
   // PC is at Address 1 in the ALU
   //
   
   assign debugADDR = "0001";

   //
   // Print the PC
   //
   
   reg [0:35] last;
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          last = 36'bx;
        else if (clken)
          begin
             if (debugDATA != last)
              $display("debug: PC is %06o", debugDATA);
             last = debugDATA;
          end
     end
   
   // synthesis translate_on
   
 endmodule
