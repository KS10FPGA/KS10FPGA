////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      KS10 CPU
//!
//! \details
//!
//! \todo
//!
//! \file
//!      ks10.v
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

`include "microcontroller/microcontroller.vh"

module KS10(clk, rst, clken, d, t, crom);

   parameter cromWidth = `CROM_WIDTH;
   parameter dromWidth = `DROM_WIDTH;

   output [0:cromWidth-1] crom; 	// Control ROM
   input 		  clk;          // Clock
   input 		  rst;          // Reset
   input 		  clken;	// Clock enable
   input  [0:35] 	  d;
   output [0:35] 	  t;
   
   wire 		  ac_eq_zero;  	// AC selection is zero
   wire   [0:35] 	  dbus;
   wire   [0:dromWidth-1] drom;

   wire   [0:11]          disp_diag  = 12'b0000_0000_0000;
   wire   [0: 3]          disp_mul  = 4'b0000;
   wire   [0: 3] 	  disp_pf   = 4'b0000;
   wire   [0: 3] 	  disp_ni   = 4'b0000;
   wire   [0: 3] 	  disp_byte = 4'b0000;
   wire   [0: 3] 	  disp_ea   = 4'b0000;
   wire   [0: 3] 	  disp_scad = 4'b0000;

   wire   [0: 7]	  skip_40   = 8'b0000_0000;
   wire   [0: 7] 	  skip_20   = 8'b0000_0000;
   wire   [0: 7] 	  skip_10   = 8'b0000_0000;
   
   microcontroller u1(.clk(clk),
                     .rst(rst),
                     .clken(clken),
                     .disp_diag(disp_diag),
                     .disp_mul(disp_mul),
                     .disp_pf(disp_pf),
                     .disp_ni(disp_ni),
                     .disp_byte(disp_byte),
                     .disp_ea(disp_ea),
                     .disp_scad(disp_scad),
                     .skip_40(skip_40),
                     .skip_20(skip_20),
                     .skip_10(skip_10),
                     .drom(drom),
                     .crom(crom));
	
   //
   // Arithmetic Logic Unit
   //
						
   alu u2(.clk(clk),
          .rst(rst),
          .crom(crom),
          .multi_shift(1'b0),
          .divide_shift(1'b0),
          .ci(1'b0),
          .co(),
          .lZ(),
          .hZ(),
          .ovfl(),
          .sign(),
          .smear(),
          .t(t));  

   //
   // Instruction Register
   //  DPEA/E55
   //  DPEA/E64
   //  DPEA/E93
   //
   
   wire [0:8] ir;
   wire [0:3] ac;
   wire ir_load = `cromSPEC_EN_40 && (`cromSPEC_SEL == `cromSPEC_SEL_LOADIR);
   
   IR uIR(.clk(clk),
          .rst(rst),
          .clken(ir_load),
          .dbus(dbus),
          .ir(ir),
          .ac(ac));

   assign ac_eq_zero = (ac == 4'b0000);

   //
   // Index Register
   //  DPEA/E99
   //  DPEA/E93
   //

   wire [0:3] xr;
   wire xr_load = `cromSPEC_EN_20 && (`cromSPEC_SEL == `cromSPEC_SEL_LOADXR);
   
   XR u4(.clk(clk),
         .rst(rst),
         .clken(xr_load),
         .dbus(dbus),
         .prev_en(prev_en),
         .xr(xr),
         .indirect(indirect),
         .xr_prev(xr_prev));
   
   assign xr_eq_zero = (xr == 4'b0000);

   //
   // Dispatch ROM
   //  Because the Dispatch ROM is registered instead of
   //  combinational, the address is loaded when the Instruction
   //  Register is loaded.
   //  DPEA/E98
   //  DPEA/E117
   //  DPEA/E110
   //
   
   DROM u5(.clk(clk),
           .clken(ir_load),
           .dbus(dbus),
           .drom(drom));
   
	

	  
endmodule
							