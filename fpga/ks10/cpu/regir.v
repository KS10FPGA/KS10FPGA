////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      Instruction Register (IR)
//!
//! \details
//!
//! \todo
//!
//! \file
//!      ir.v
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

module IR(clk, rst, clken, dbus, ir, ac);

   input 	 clk;           // Clock
   input 	 rst;           // Reset
   input 	 clken          // Clock Enable
   input  [0:35] dbus;          // Input Bus
   output [0: 8] ir;            // Instruction register
   output [0: 3] ac;            // Accumulator selection

   //
   // Instruction Register and AC Selection
   //  DPEA/E55
   //  DPEA/E64
   //  DPEA/E93
   //

   reg [0: 8] ir;               // Instruction register
   reg [0: 3] ac;               // Accumulator selection

   always @(posedge clk or posedge rst)
    begin
        if (rst)
          begin
             ir <= 9'b000_000_000;
             ac <= 4'b0000;
          end
        else if (clken)
          begin
             ir <= dbus[0:8];
             ac <= dbus[9:12];
          end
    end

 endmodule
