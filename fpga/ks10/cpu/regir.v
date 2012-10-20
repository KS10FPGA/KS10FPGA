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

`include "microcontroller/crom.vh"

module regIR(clk, rst, clken, crom, dbus, ir, ac, jrst0);
   
   parameter cromWidth = `CROM_WIDTH;

   input                      clk;      // Clock
   input                      rst;      // Reset
   input                      clken;    // Clock Enable
   input      [0:cromWidth-1] crom;   	// Control ROM Data
   input      [0:35]          dbus;     // Input Bus
   output reg [0: 8]          ir;       // Instruction register
   output reg [0: 3]          ac;   	// Accumulator selection
   output                     jrst0;	// JRST Instruction

   //
   // Instruction Register and AC Selection
   //  DPEA/E55
   //  DPEA/E64
   //  DPEA/E93
   //

   wire load_ir = `cromSPEC_EN_40 & (`cromSPEC_SEL == `cromSPEC_SEL_LOADIR);
   
   always @(posedge clk or posedge rst)
    begin
        if (rst)
          begin
             ir <= 9'b0;
             ac <= 4'b0;
          end
        else if (clken & load_ir)
          begin
             ir <= dbus[0:8];
             ac <= dbus[9:12];
          end
    end

   //
   // JRST 0 decode
   //  DPEA/E54
   //  DPEA/E61
   //  DPE1/E62
   //
   
   assign jrst0 = ((ir == 9'o254) & (ac == 4'b0));
   
 endmodule
