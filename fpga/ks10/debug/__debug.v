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

`default_nettype none
`include "useq/crom.vh"

  module DEBUG(clk, rst, clken, crom, debugDATA, debugADDR);
   
   parameter cromWidth = `CROM_WIDTH;
   
   input                  clk;          // Clock
   input                  rst;          // Reset
   input                  clken;        // Clock Enable
   input  [0:cromWidth-1] crom;         // Control ROM Data
   input  [0:35]          debugDATA;    // DEBUG Data
   output [0: 3]          debugADDR;    // DEBUG Address

   //
   // Print the Program Counter
   //
   // Details:
   //  The program counter is modified by instructions in various
   //  stages of the microcode.  A modified PC does not mean that
   //  the instruction was actually executed.  For example, the
   //  PC is always incremented after the instruction is fetched
   //  but the PC may be modified (again) later by a branch
   //  instruction.
   //
   //  This code prints the program counter when the instruction
   //  register is loaded.  This occurs once during the instruction
   //  execution.
   //
   // synthesis translate_off
   //

   wire loadIR = `cromSPEC_EN_40 & (`cromSPEC_SEL == `cromSPEC_SEL_LOADIR);
   reg [18:35] PC;
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          PC <= 18'b0;
        else if (loadIR)
          begin
             PC <= debugDATA;
             $display("debug: PC is %06o", debugDATA[18:35]);
          end
     end
   
   //
   // PC is Register #1 in the ALU
   // synthesis translate_on
   //
   
   assign debugADDR = 4'b0001;
   
 endmodule
