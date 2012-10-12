////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      Next Instruction Dispatch
//!
//! \details
//!      This is a 16-way dispatch base on the next instruction.
//!
//! \todo
//!
//! \file
//!      ni_disp.v
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

module NI_DISP(run, memory_cycle, trap3, trap2, trap1, dispNI);

   input         run;          	// Run
   input         memory_cycle;  // Memory Cycle
   input         trap3;        	// Trap 3
   input         trap2;        	// Trap 2
   input         trap1;        	// Trap 1
   output [8:11] dispNI;    	// Next Instruction dispatch

   //
   // NICOND
   //  CRA2/E147
   //

   wire halt = ~run;

   assign dispNI[8]    = memory_cycle;		// Fetch in progress
   assign dispNI[9:11] = ((trap3) ? 3'd1 :
                          (trap2) ? 3'd2 :
                          (trap1) ? 3'd3 :
                          (halt ) ? 3'd5 : 3'd7);
   
endmodule
