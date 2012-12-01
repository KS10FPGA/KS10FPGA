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

`default_nettype none
`include "crom.vh"

module CROM(clk, rst, clken, addr, crom);

   parameter  cromWidth = `CROM_WIDTH;

   input                      clk;      // Clock
   input                      rst;      // Reset
   input                      clken;    // Clock Enable
   input      [0:11]          addr;     // Address
   output reg [0:cromWidth-1] crom;     // Output Data

   //
   // Control ROM initialization
   //
   // Note:
   //  The KS10 microcode is extracted from the listing file by
   //  a 'simple' AWK script and is included below.
   //

   reg [0:cromWidth-1] CROM[0:2047];

   initial
     begin
        `include "crom.dat"
     end

   //
   // Control ROM
   //
   // Details:
   //  The Control ROM stores the microcode.
   //
   // Note:
   //  The KS10 only implemented half of the microcode.  Therefore
   //  the MSB of the address is ignored.  If you need more than
   //  2048 words of microcode, you can simply add more ROM.  See
   //  notes at top-of-file.
   //
   //  The KS10 used asynchronous ROM followed by a 108-bit wide
   //  register.   This register has been absorbed into this
   //  synchronous ROM implementation.
   //
   // Trace:
   //  Registers
   //   CRA6/E2,   CRA6/E46,  CRA6/E67,  CRA6/E86,  CRA6/E87,  CRA6/E104
   //  Address buffers:
   //   CRA7/E5,   CRA7/E6,   CRA7/E10,  CRA7/E11,  CRA7/E19,  CRA7/E20
   //   CRA7/E68,  CRA7/E80,  CRA7/E93,  CRA7/E94,  CRA7/E100, CRA7/E106
   //  ROMS:
   //   CRA8/E8,   CRA8/E13,  CRA8/E14,  CRA8/E22,  CRA8/E23,  CRA8/E28,
   //   CRA8/E29,  CRA8/E37,  CRA8/E38,  CRA8/E40,  CRA8/E41,  CRA8/E49,
   //   CRA8/E50,  CRA8/E52,  CRA8/E53,  CRA8/E60,  CRA8/E61,  CRA8/E63,
   //   CRA8/E64,  CRA8/E71,  CRA8/E72,  CRA8/E74,  CRA8/E75,  CRA8/E83,
   //   CRA8/E109, CRA8/E117, CRA8/E120, CRA8/E126, CRA8/E134, CRA8/E142,
   //   CRA8/E146, CRA8/E154, CRA8/E157, CRA8/E166, CRA8/E169, CRA8/E178,
   //
   //   CRA9/E7,   CRA9/E12,  CRA9/E21,  CRA9/E27,  CRA9/E36,  CRA9/E39,
   //   CRA9/E48,  CRA9/E51,  CRA9/E59,  CRA9/E62,  CRA9/E70,  CRA9/E73,
   //   CRA9/E102, CRA9/E108, CRA9/E116, CRA9/E119, CRA9/E125, CRA9/E133,
   //   CRA9/E141, CRA9/E145, CRA9/E153, CRA9/E156, CRA9/E165, CRA9/E168,
   //   CRA9/E101, CRA9/E107, CRA9/E115, CRA9/E118, CRA9/E124, CRA9/E132,
   //   CRA9/E140, CRA9/E144, CRA9/E152, CRA9/E155, CRA9/E164, CRA9/E167,
   //
   //   CRM4/E7,   CRM4/E14,  CRM4/E19,  CRM4/E33,  CRM4/E40,  CRM4/E45,
   //   CRM4/E52,  CRM4/E56,  CRM4/E82,  CRM4/E89,  CRM4/E94,  CRM4/E101,
   //   CRM4/E105, CRM4/E117, CRM4/E127, CRM4/E132, CRM4/E133, CRM4/E140,
   //   CRM4/E147, CRM4/E152, CRM4/E159, CRM4/E184, CRM4/E191, CRM4/E198,
   //
   //   CRM5/E6,   CRM5/E13,  CRM5/E18,  CRM5/E39,  CRM5/E44,  CRM5/E51,
   //   CRM5/E70,  CRM5/E74,  CRM5/E81,  CRM5/E88,  CRM5/E100, CRM5/E104,
   //   CRM5/E112, CRM5/E116, CRM5/E126, CRM5/E139, CRM5/E146, CRM5/E151,
   //   CRM5/E158, CRM5/E165, CRM5/E178, CRM5/E183, CRM5/E190, CRM5/E197,
   //
   //   CRM6/E5,   CRM6/E12,  CRM6/E17,  CRM6/E31,  CRM6/E38,  CRM6/E43,
   //   CRM6/E50,  CRM6/E54,  CRM6/E60,  CRM6/E73,  CRM6/E80,  CRM6/E87,
   //   CRM6/E103, CRM6/E107, CRM6/E125, CRM6/E138, CRM6/E145, CRM6/E150,
   //   CRM6/E157, CRM6/E164, CRM6/E170, CRM6/E182, CRM6/E189, CRM6/E196,
   //
   //   CRM7/E4,   CRM7/E11,  CRM7/E16,  CRM7/E23,  CRM7/E42,  CRM7/E49,
   //   CRM7/E59,  CRM7/E62,  CRM7/E68,  CRM7/E72,  CRM7/E79,  CRM7/E93,
   //   CRM7/E98,  CRM7/E102, CRM7/E110, CRM7/E114, CRM7/E137, CRM7/E144,
   //   CRM7/E156, CRM7/E163, CRM7/E176, CRM7/E181, CRM7/E188, CRM7/E195,
   //
   
   always @(posedge clk)
     begin
        if (clken)
          crom <= CROM[addr[1:11]];
     end

endmodule
