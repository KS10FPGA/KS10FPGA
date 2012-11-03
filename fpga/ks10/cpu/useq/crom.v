////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      Microcontroller Control ROM (CROM)
//!
//! \details
//!      The Control ROM contains the executable microcode of the
//!      the microcontroller.
//!
//! \note
//!      Although all of the microcontroller addressing supports
//!      12-bit addresses (4096 words of ROM) the Control ROM only
//!      implements 2048 words of ROM.
//!
//!      The current microcode uses all of the ROM except for
//!      about 25 words.
//!
//!      Implementing 4096 words of ROM would all double the amount
//!      of microcode and allow for feature growth.
//!
//! \note
//!      The contents of this file was extracted from the microcode
//!      listing file by a simple AWK script.  Go see the makefile.
//!
//! \file
//!      crom.v
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

`include "crom.vh"

module CROM(clk, rst, clken, addr, crom);

   parameter  cromWidth = `CROM_WIDTH;

   input                      clk;      // Clock
   input                      rst;      // Reset
   input                      clken;    // Clock Enable
   input      [0:11]          addr;     // Address
   output reg [0:cromWidth-1] crom;     // Output Data

   //
   // CROM
   //  Note ROM MSB is ignored.
   //   Address buffers:
   //    CRA7/E11,  CRA7/E19, CRA7/E106, CRA7/E100, CRA7/E10, CRA7/E6,
   //    CRA7/E93,  CRA7/E68, CRA7/E80,  CRA7/E94,  CRA7/E20, CRA7/E5,
   //   ROM:
   //    CRA8/E14,  CRA8/E23, CRA8/E28,  CRA8/E38,  CRA8/E41, CRA8/E50,
   //
   //   Registers:
   //    CRA6/E104, CRA6/E87, CRA6/E2,   CRA6/E46,  CRA6/E67, CRA6/E86,
   //
   //

   reg [0:cromWidth-1] CROM[0:2047];
   
   initial
     begin
	
        //
        // The KS10 microcode is extracted from the listing file by
        // a simple AWK script and inserted below.
        //
	
        `include "crom.dat"
	
     end

   //
   // Registered ROM
   //  Note MSB of the address is ignored.  If you need more than
   //  2048 words of microcode, you can simply add more ROM.  See
   //  notes at top-of-file.
   //

   always @(posedge clk)
     begin
        if (clken)
          crom <= CROM[addr[1:11]];
     end

endmodule
