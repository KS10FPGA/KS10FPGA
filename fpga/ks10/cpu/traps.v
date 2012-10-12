////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      Trap Cycle
//!
//! \details
//!
//! \todo
//!
//! \file
//!      trap_cycle.v
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

module TRAP_CYCLE(clk, rst, clken, crom, trap3, trap2, trap1, trap_cycle);

   parameter cromWidth = `CROM_WIDTH;
   
   input                  clk;          // Clock
   input                  rst;          // Reset
   input                  clken;        // Clock Enable
   input  [0:cromWidth-1] crom;         // Control ROM Data
   input                  trap3;        // Trap 3
   input                  trap2;        // Trap 2
   input                  trap1;        // Trap 1
   output reg             trap_cycle;   // Trap Cycle

   //
   // TRAP CYCLE
   //  CRA2/E100
   //  CRA2/E113
   //
   //  The schematic uses NICOND_09.  This is the same logic but
   //  a little more straight forward.
   //

   wire trap_en = `cromSPEC_EN_10 & (`cromSPEC_SEL == `cromSPEC_SEL_LOADNICOND);
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          trap_cycle <= 1'b0;
        else if (clken & trap_en)
          trap_cycle <= trap3 | trap2 | trap1;
    end
   
endmodule
