////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      Microcontroller Call Stack
//!
//! \details
//!
//! \todo
//!
//! \file
//!      stack.v
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

module STACK(clk, rst, clken, call, ret, addr_in, addr_out);

   input  clk;                  // Clock
   input  rst;                  // Reset
   input  clken;                // Clock Enable
   input  call;                 // Call (push addr on stack)
   input  ret;                  // Return (pop addr from stack)
   input  [0:11] addr_in;       // Calling address for stack
   output [0:11] addr_out;      // Return address from stack

   reg    [0:11] stack[0:15];   // Dual Ported Stack Memory
   reg    [0:3] sp;           // Stack pointer
   wire   [0:3] wp;           // Write pointer
   reg    [0:3] rp;           // Read pointer;

   //
   // Stack Pointer
   //
                 
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          sp <= 4'b0000;
        else
          begin
             if (call)
               sp <= sp + 1;
             else if (ret)
               sp <= sp - 1;
          end
     end

   assign wp = sp + 1;

   //
   // Dual Port RAM
   //
   
   always @(posedge clk)
     begin
        if (call)
          begin
             stack[wp] <= addr_in;
          end
        rp <= sp;
     end

   assign addr_out = stack[rp];

endmodule   