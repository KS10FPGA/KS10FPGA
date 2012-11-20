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

module TIMING(clk, rst, crom, drom, dp, fe, clken, clkenUSEQ);

   parameter cromWidth = `CROM_WIDTH;
   parameter dromWidth = `DROM_WIDTH;

   input                  clk;          // Clock
   input                  rst;          // Reset
   input  [0:cromWidth-1] crom;         // Control ROM Data
   input  [0:dromWidth-1] drom;         // Control ROM Data
   input  [0:35]          dp;           // Data path
   input  [0: 9]          fe;		// FE
   output                 clken;        // Clock Enable
   output                 clkenUSEQ;    // Clock Enable Microsequencer
  
   //
   // Fast Shift
   //
   // Details:
   //  The KS10 fast shifts while the FE is negative.  Be careful:
   //  when the shift count is zero (FE = -1 or 1777) no shifts
   //  should be peformed.
   //
   // FIXME:
   //  This crazy fast shift stuff should be replaced by a microcode hack.
   //  The FPGA doesn't really require this fast shift implementation.
   //
   // 
   
   reg done;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          done = 1'b0;
        else
          done = fe[0] & `cromMULTISHIFT;
     end

   assign clkenUSEQ = ~(`cromMULTISHIFT & fe[0]);
   assign clken = ~((done & clkenUSEQ) | (~fe[0] & `cromMULTISHIFT));
  
endmodule
