////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      Microcontroller
//!
//! \details
//!
//! \todo
//!
//! \file
//!      microcontroller.v
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

`include "microcontroller.vh"

module microcontroller(clk, rst, clken, disp_diag, 
                       disp_mul, disp_pf, disp_ni, disp_byte, disp_ea, disp_scad,
                       skip_40, skip_20, skip_10, drom, crom);
   
   parameter cromWidth = `CROM_WIDTH;
   parameter dromWidth = `DROM_WIDTH;

   input         clk;           // Clock
   input         rst;           // Reset
   input         clken;         // Clock Enable
   input  [0:11] disp_diag;     // Diagnostic Addr
   input  [0: 3] disp_mul;      // Multiply Dispatch
   input  [0: 3] disp_pf;       // Page Fail Dispatch
   input  [0: 3] disp_ni;       // Next Instruction Dispatch
   input  [0: 3] disp_byte;     // Byte Size/Position Dispatch
   input  [0: 3] disp_ea;       // Effective Address Mode Dispatch
   input  [0: 3] disp_scad;     // SCAD Dispatch
   input  [0: 8] skip_40;       // Skip 40
   input  [0: 8] skip_20;       // Skip 20
   input  [0: 8] skip_10;       // Skip 10
   input  [0:dromWidth-1] drom; // Dispatch ROM Data
   output [0:cromWidth-1] crom; // Control ROM Data

   //
   // Control ROM Address
   //

   wire [0:11] addr;
   wire [0:11] ret_addr;
   
   // Note:
   // The KS10 logic decodes "x0xx01" (CRA2/E34) but only
   //  001 and 041 are used by the microcode.
   //
   
   wire        ret = ((`cromDISP == 6'o01) ||   // used
                      (`cromDISP == 6'o05) ||   // not used
                      (`cromDISP == 6'o11) ||   // not used
                      (`cromDISP == 6'o15) ||   // not used
                      (`cromDISP == 6'o41) ||   // used
                      (`cromDISP == 6'o45) ||   // not used
                      (`cromDISP == 6'o51) ||   // not used
                      (`cromDISP == 6'o55));    // not used

   //
   // Page Fail
   //

   wire        page_fail = 1'b0;

   //
   // Skip Logic
   //
   
   wire [0:11] skip_addr;
   SKIP uSKIP(.crom(crom),
              .skip_40(skip_40),
              .skip_20(skip_20),
              .skip_10(skip_10),
              .skip_addr(skip_addr));

   //
   // Dispatch Logic
   //

   wire        dromAEQJ   = 1'b0;
	wire [0:11] dromJ      = `dromJ;
   wire [0: 7] disp_aread = (dromAEQJ) ? 
               {2'b00, dromAEQJ, dromAEQJ, dromJ} : 
               {2'b00, dromAEQJ, dromAEQJ, 4'b0000};
   
   DISPATCH uDISPATCH(.crom(crom),
                      .disp_diag(disp_diag),
                      .disp_ret(disp_ret),
                      .disp_j(disp_j),
                      .disp_aread(disp_aread),
                      .disp_mul(disp_mul),
                      .disp_pf(disp_pf),
                      .disp_ni(disp_ni),
                      .disp_byte(disp_byte),
                      .disp_ea(disp_ea),
                      .disp_scad(disp_scad),
                      .disp_addr(disp_addr));

   //
   // Address MUX
   //

 
   
   assign addr = (rst)       ? 12'b000_000_000_000 :
                 (page_fail) ? 12'b111_111_111_111 :
                 disp_addr | skip_addr | crom[`cromJ];

   
   //
   // Control ROM
   //
   
   CROM uCROM(.clk(clk),
              .clken(clken),
              .addr(addr),
              .crom(crom));

   //
   // Call/Return Stack
   //
   
   STACK uSTACK(.clk(clk),
                .rst(rst),
                .clken(clken),
                .call(`cromCALL),
                .ret(ret),
                .addr_in(addr),
                .addr_out(ret_addr));
   
endmodule
