////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      KS-10 Console
//!
//! \details
//!
//! \todo
//!
//! \file
//!      cons.v
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

module CONS(clk, clken, cpuREAD, cpuWRITE, cpuIO, cpuADDR, cpuDATA, consDATA, consACK);

   input          clk;      	// Clock
   input          clken;        // Clock enable
   input          cpuREAD;	// Memory/IO Read
   input          cpuWRITE;     // Memory/IO Write
   input          cpuIO;	// Memory/IO Select
   input  [14:35] cpuADDR;      // CPU Address
   input  [ 0:35] cpuDATA;      // CONS data in
   output [ 0:35] consDATA;     // CONS data out
   output         consACK;      // CONS ACK

   //
   // Execute/Start 'Vector'
   //
   // Details:
   //  When the 'execute switch' is asserted at power-up the
   //  microcode will perform a read at IO address o200000
   //  and then execute that instruction.  In the KS10, this
   //  IO address was handled by the Console.  Therefore the
   /// Console could set the start address.
   //
   //  This is normally a JRST instruction which causes the
   //  code to jump to the entry point of the code/bootloader.
   //
   
   assign consACK  = cpuIO & cpuREAD & (cpuADDR == 18'o200000);
   assign consDATA = consACK ? 36'o254000030600 : 36'bx;

endmodule
