////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      IO Latch
//!
//! \details
//!
//! \todo
//!
//! \file
//!      iolatch.v
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

module IOLATCH(clk, rst, clken, crom, iolatch);
   
   parameter cromWidth = `CROM_WIDTH;

   input                      clk;      // Clock
   input                      rst;      // Reset
   input                      clken;    // Clock Enable
   input      [0:cromWidth-1] crom;  	// Control ROM Data
   output reg                 iolatch;

   //
   // IO Latch
   //  DPEA/E99
   //  DPEA/E93
   //

   wire latch = 1'b0;	// FIXME
   
   always @(posedge clk or posedge rst)
    begin
        if (rst)
          iolatch <= 1'b0;
        else if (clken)
          iolatch <= latch;
    end

 endmodule
