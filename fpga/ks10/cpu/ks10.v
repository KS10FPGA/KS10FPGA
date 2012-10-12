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

`include "microcontroller/crom.vh"
`include "microcontroller/drom.vh"

module KS10(clk, rst, clken, run, msec_en, execute, d, t, crom);

   parameter cromWidth = `CROM_WIDTH;
   parameter dromWidth = `DROM_WIDTH;

   output [0:cromWidth-1] crom; 	// Control ROM
   input 		  clk;          // Clock
   input 		  rst;          // Reset
   input 		  clken;	// Clock enable
   input                  run;		// Run (From Console)
   input                  msec_en;	// Timer Enable (From Console)
   input                  execute; 	// Execute (From Console)
   input  [0:35] 	  d;
   output [0:35] 	  t;


   
   wire 		  ac_eq_zero;  	// AC selection is zero

   //
   // ROMS
   //
   
   wire   [0:dromWidth-1] drom;

   //
   // flags
   //
   
   wire                   ov_flag;
   wire                   cry0_flag;
   wire                   cry1_flag;
   wire                   fov_flag;
   wire                   fpd_flag;
   wire                   pcu_flag;	// Previous context user bit
   wire                   user_flag;
   wire                   userio_flag;
   wire                   trap2_flag;
   wire                   trap1_flag;
   wire                   fxu_flag;
   wire                   nodiv_flag;
   wire                   trap_en;
   wire                   page_en;
   wire                   page_fail = 1'b0;
   wire [ 0: 7]           apr_flags;
   wire                   apr_int_req;
   wire                   vma_user;
   wire                   vma_fetch;
   wire                   vma_phys;
   wire                   vma_prev;
   wire                   mem_read;
   wire                   mem_write;
   wire                   mem_wr_test;
   wire                   cache_inh;
   wire                   vma_io;
   wire                   wru_cycle;
   wire                   vector_cycle;
   wire                   io_byte_cycle;
   wire                   force_ramfile = 1'b0;
   wire                   memory_cycle = 1'b1;


   //
   // Registers
   //

   wire [14:35]           vma;
   wire [ 0: 2]           pi_new;
   wire [ 0: 3]           xr;
   wire [ 0: 8]           ir;
   wire [ 0: 3]           ac;
   wire [24:35]           msec_count;		// Millisecond timer
   
   //
   // Busses
   //

   wire [ 0:35]           dp;		// ALU output bus
   wire [ 0:35]           dbus;		//
   wire [ 0:35]           dbm;		//
   wire [ 0:35]           mb;		//
   wire [ 0: 9]           ramfile_addr;
   
   //
   // Dispatches
   //
   
   wire [ 8:11]           dispBYTE;	// Byte dispatch
   wire [ 8:11] 	  dispSCAD;	// SCAD dispatch
   wire [ 8:11]           dispNORM;	// NORM dispatch
   wire [ 8:11] 	  dispNI;	// Next Instruction dispatch
   wire [ 8:11]           dispPF   = 4'b0000;
   wire [ 8:11]           dispMUL  = 4'b0000;
   wire [ 8:11] 	  dispEA   = 4'b0000;
   wire [ 0:11]           dispDIAG = 12'b0000_0000_0000;

   //
   // Skips
   //

   wire [ 0: 7]	  	  skip40   = 8'b0000_0000;
   wire [ 0: 7]           skip20   = 8'b0000_0000;
   wire [ 0: 7]           skip10   = 8'b0000_0000;
   
   //
   // SCAD, SC, and FE
   //
   
   wire [ 0: 9]           scad;
   wire [ 0: 9]           sc;
   wire                   sc_sign = sc[0];
   wire [ 0: 9]           fe;
   wire                   fe_sign = fe[0];

   //
   // Traps
   //

   wire                   trap3 = 1'b0;
   wire                   trap2 = 1'b0;
   wire                   trap1 = 1'b0;
   

   wire [ 9:12]           pxct;
   

   
   //
   // Next Instruction Dispatch
   //

   
   NI_DISP uNI_DISP(.run(run),
            .memory_cycle(memory_cycle),
            .trap3(trap3),
            .trap2(trap2),
            .trap1(trap1),
            .dispNI(dispNI));
   
   //
   // Microcontroller
   //


   microcontroller u1(.clk(clk),
                      .rst(rst),
                      .clken(clken),
                      .page_fail(page_fail),
                      .dp(dp),
                      .dispDIAG(dispDIAG),
                      .dispMUL(dispMUL),
                      .dispPF(dispPF),
                      .dispNI(dispNI),
                      .dispBYTE(dispBYTE),
                      .dispEA(dispEA),
                      .dispSCAD(dispSCAD),
                      .dispNORM(dispNORM),
                      .skip40(skip40),
                      .skip20(skip20),
                      .skip10(skip10),
                      .drom(drom),
                      .crom(crom));

   //
   // RAMFILE
   //

   wire [0:35] ram;
   RAMFILE uRAMFILE(.clk(clk),
                    .clken(1'b1),
                    .wr(ramfile_wr),
                    .addr(ramfile_addr),
                    .din(dbus),
                    .dout(ram));

   //
   // DBUS MUX
   //

   wire [0:35] pc_flags = {ov_flag, cry0_flag, cry1_flag, fov_flag, fpd_flag, user_flag,//  0: 5
                           userio_flag, 2'b00, trap2_flag, trap1_flag, fxu_flag,	//  6:11
                           nodiv_flag, 5'b00000,					// 12:17
                           1'b0, pi_new, 2'b11,					// 18:23
                           2'b11, vma[26:29], 						// 24:29
                           vma[30:35]};							// 30:36

   DBUS uDBUS(.crom(crom),
              .force_ramfile(force_ramfile),
              .flags(pc_flags),
              .dp(dp),
              .ram(ram),
              .dbm(dbm),
              .dbus(dbus));

   //
   // Arithmetic Logic Unit
   //

   ALU uALU(.clk(clk),
            .rst(rst),
            .dbus(dbus),
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
            .t(dp));

   //
   // Instruction Register
   //

   IR uIR(.clk(clk),
          .rst(rst),
          .clken(clken),
          .crom(crom),
          .dbus(dbus),
          .ir(ir),
          .ac(ac));

   assign ac_eq_zero = (ac == 4'b0000);

   //
   // Index Register
   //

   XR uXR(.clk(clk),
          .rst(rst),
          .clken(clken),
          .dbus(dbus),
          .crom(crom),
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
   //

   DROM uDROM(.clk(clk),
              .clken(ir_load),
              .dbus(dbus),
              .drom(drom));


   //
   // Byte Dispatch
   //

   BYTE_DISP uBYTE_DISP(.dp(dp),
                        .dispBYTE(dispBYTE));

   //
   //
   //

   wire [0:35] dbm0 = {scad[1:9], 8'b1111_1111, scad[0], dispPF, trap_en, page_en, apr_flags, apr_int_req, 3'b111};
   wire [0:35] dbm1 = {scad[1:7], scad[1:7], scad[1:7], scad[1:7], scad[1:7], dp[35]};
   wire [0:35] dbm2 = {1'b0, scad[2:9], dp[9:17], 6'b111_111, msec_count[24:33], 2'b00};
   wire [0:35] dbm3 = dp[0:35];
   wire [0:35] dbm4 = {dp[18:35], dp[0:17]};
   wire [0:35] dbm5 = {vma_user, 1'b0, vma_fetch, mem_read, mem_wr_test, mem_write, 1'b0, cache_inh, vma_phys, vma_prev, vma_io, wru_cycle, vector_cycle, io_byte_cycle, vma[14:35]};
   wire [0:35] dbm6 = mb[0:35];
   wire [0:35] dbm7 = {`cromNUM, `cromNUM};

   DBM uDBM(.crom(crom),
            .dbm0(dbm0),
            .dbm1(dbm1),
            .dbm2(dbm2),
            .dbm3(dbm3),
            .dbm4(dbm4),
            .dbm5(dbm5),
            .dbm6(dbm6),
            .dbm7(dbm7),
            .dbm(dbm));

   //
   //
   //

   SCAD uSCAD(.clk(clk),
	      .rst(rst),
	      .clken(clken),
              .crom(crom),
              .scad(scad),
              .dp(dp),
              .sc(sc),
              .fe(fe),
              .dispSCAD(dispSCAD));

   //
   // One millisecond (more or less) interval timer.
   
   TIMER uTIMER(.clk(clk),
		.rst(rst),
		.clken(clken),
		.crom(crom),
		.msec_en(msec_en),
		.msec_intr(msec_intr),
		.msec_count(msec_count));

   //
   //
   //
   
   VMA uVMA(.clk(clk),
	    .rst(rst),
	    .clken(clken),
	    .crom(crom),
	    .drom(drom),
	    .dp(dp),
            .execute(execute),
            .user_flag(user_flag),
            .pcu_flag(pcu_flag),
            .previous_en(previous_en),
            .wru_cycle(wru_cycle),
            .vector_cycle(vector_cycle),
            .iobyte_cycle(iobyte_cycle),
            .vma_sweep(vma_sweep),
            .vma_extended(vma_extended),
            .vma_user(vma_user),
            .vma_previous(vma_previous),
            .vma_physical(vma_physical),
            .vma_fetch(vma_fetch),
            .vma_io(vma_io),
            .vma_ac_ref(vma_ac_ref),
	    .vma(vma));

   //
   //
   //

   PXCT uPXCT(.clk(clk),
	      .rst(rst),
	      .clken(clken),
	      .crom(crom),
	      .dp(dp),
              .pxct_on(pxct_on),
              .previous_en(previous_en),
              .pxct(pxct));
              

   //
   //
   //
   
   TRAP_CYCLE uTRAP_CYCLE(.clk(clk),
			  .rst(rst),
			  .clken(clken),
			  .crom(crom),
			  .trap3(trap3),
			  .trap2(trap2),
			  .trap1(trap1),
			  .trap_cycle(trap_cycle));

   //
   //
   //
   
   PAGE_TABLES uPAGE_TABLES(.clk(clk),
			    .rst(rst),
			    .clken(clken),
			    .crom(crom),
			    .drom(drom),
 	                    .dp(dp));

   //
   //
   //
   
   FLAGS uFLAGS(.clk(clk),
		.rst(rst),
		.clken(clken),
		.crom(crom),
                .drom(drom),
                .dp(dp),
                .cry0_flag(cry0_flag),
                .cry1_flag(cry1_flag),
                .fov_flag(fov_flag),
                .ov_flag(ov_flag),
                .fxu_flag(fxu_flag),
                .user_flag(user_flag),
                .trap1_flag(trap1_flag),
                .trap2_flag(trap2_flag),
                .nodiv_flag(nodiv_flag),
                .pcu_flag(pcu_flag),
                .userio_flag(userio_flag));
   
endmodule


