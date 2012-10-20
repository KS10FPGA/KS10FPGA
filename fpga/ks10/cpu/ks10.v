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

module KS10(clk, rst, clken,
            cons_run, cons_msec_en, cons_exec, cons_cont, consTRAPEN,
            bus_ac_lo,
            crom, t);

   parameter cromWidth = `CROM_WIDTH;
   parameter dromWidth = `DROM_WIDTH;

   input                  clk;          // Clock
   input                  rst;          // Reset
   input                  clken;        // Clock enable
   input                  cons_run;     // Run
   input                  cons_msec_en; // Timer Enable
   input                  cons_exec;    // Execute
   input                  cons_cont;    // Continue
   input                  consTRAPEN;	// Enable Traps
   input                  bus_ac_lo;	// Power Fail
   output [0:cromWidth-1] crom;       	// Control ROM
   output [0:35]          t;            // ALU Output Bus

   //
   // ROMS
   //
   
   wire [0:dromWidth-1] drom;		// Dispatch ROM
   
   //
   // ALU
   //

   wire aluLZero;
   wire aluRZero;
   wire aluLSign;
   wire aluRSign;
   wire aluCRY0;
   wire aluCRY1;
   wire aluCRY2;
   wire aluQR37;
   wire aluZERO = aluLZero & aluRZero;
   wire txxx = (aluZERO != `dromTXXXEN);

   //
   // flags
   //
   
   wire trapEN;
   wire pageEN;
   wire page_fail 		= 1'b0;		// FIXME
   wire apr_int_req;
   wire mem_wait;
   wire stop_main_memory;
   wire memory_cycle 		= 1'b0;		// FIXME
   wire interrupt_req;
   wire iolatch;
   wire xr_previous;
   wire nxm_err                 = 1'b0;		// FIXME
   wire bad_data_err 		= 1'b0;		// FIXME
   wire int_10 			= 1'b0;		// FIXME
   wire force_ramfile           = 1'b0;		// FIXME
   wire previousEN;

   //
   // Registers
   //

   wire [ 0: 2] pi_new;
   wire [ 0: 3] xr;
   wire [ 0: 8] ir;
   wire [ 0: 3] ac;
   wire [ 9:12] pxct;
   wire [24:35] msec_count;             // Millisecond timer
   wire [ 0:17] pcFLAGS;                // PC flags
   wire [24:31] aprFLAGS;               //
   wire [ 0: 2] curr_block;             //
   wire [ 0: 2] prev_block;             //
   wire [16:26] page_number;            //
   
   wire         ac_eq_zero;             // AC selection is zero
   wire         xr_eq_zero;             // XR selection is zero

   //
   // PC Flags
   //

   wire         flagAOV        = pcFLAGS[ 0];
   wire         flagCRY0       = pcFLAGS[ 1];
   wire         flagCRY1       = pcFLAGS[ 2];
   wire         flagFOV        = pcFLAGS[ 3];
   wire         flagFPD        = pcFLAGS[ 4];
   wire         flagUSER       = pcFLAGS[ 5];
   wire         flagUSERIO     = pcFLAGS[ 6];
   wire         flagPCU        = pcFLAGS[ 6];
   wire         flagTRAP2      = pcFLAGS[ 9];
   wire         flagTRAP1      = pcFLAGS[10];
   wire         flagFXU        = pcFLAGS[11];
   wire         flagNODIV      = pcFLAGS[12];

   //
   // VMA Registers
   //
   
   wire [ 0:13] vmaFLAGS;
   wire [14:35] vmaADDR;
   wire         vmaUSER        = vmaFLAGS[ 0];
   wire         vmaEXEC        = vmaFLAGS[ 1];
   wire         vmaFETCH       = vmaFLAGS[ 2];
   wire         vmaREADCYCLE   = vmaFLAGS[ 3];
   wire         vmaWRTESTCYCLE = vmaFLAGS[ 4];
   wire         vmaWRITECYCLE  = vmaFLAGS[ 5];
   wire         vmaIORDWR      = vmaFLAGS[ 6];
   wire         vmaCACHEIHN    = vmaFLAGS[ 7];
   wire         vmaPHYSICAL    = vmaFLAGS[ 8];   
   wire         vmaPREVIOUS    = vmaFLAGS[ 9];
   wire         vmaIO          = vmaFLAGS[10];
   wire         vmaWRUCYCLE    = vmaFLAGS[11];
   wire         vmaVECTORCYCLE = vmaFLAGS[12];
   wire         vmaIOBYTECYCLE = vmaFLAGS[13];   
   
   //
   // Busses
   //

   wire [ 0:35] dp;                     // ALU output bus
   wire [ 0:35] dbus;                   //
   wire [ 0:35] dbm;                    //
   wire [ 0:35] mb = 36'b0;             // FIXME Memory Buffer
   wire [ 0:35] ram;                    // RAMFILE output
   wire [ 1: 7] bus_pi_req_out;         // 
   wire [ 1: 7] bus_pi_req_in = 7'b0;   // 
   
   
   //
   // SCAD, SC, and FE
   //
   
   wire [ 0: 9] scad;
   wire [ 0: 9] sc;
   wire         sc_sign = sc[0];
   wire [ 0: 9] fe;
   wire         fe_sign = fe[0];

   //
   // Traps
   //

   wire [3:1]   traps;
   
   //
   // Dispatches
   //
   
   wire [ 8:11] dispSCAD;                       		// SCAD dispatch
   wire [ 8:11] dispNI;             				// Next Instruction dispatch
   wire [ 8:11] dispBYTE;                       		// Byte dispatch
   wire [ 8:11] dispMUL  = {1'b0, aluQR37, 1'b0, 1'b0};		// Multiply dispatch
   wire [ 8:11] dispPF   = 4'b0000;             		// Page Fail dispatch (depricated)
   wire [ 8:11] dispNORM = {aluZERO, dp[8:9], aluLSign};     	// Normalize dispatch
   wire [ 8:11] dispEA   = {~jrst0, indirect, xr_eq_zero, 1'b0};// EA Dispatch
   wire [ 0:11] dispDIAG = 12'b0000_0000_0000;  		// Diagnostic Dispatch

   //
   // Skips
   //

   wire jfcl_skip;
   wire [1:7] skip40 = {aluCRY0,    aluLZero,   aluRZero, flagUSER,
                        flagFPD,    ac_eq_zero, interrupt_req};
   wire [1:7] skip20 = {aluCRY2,    aluLSign,   aluRSign, flagUSERIO,
                        jfcl_skip,  aluCRY1,    txxx};
   wire [1:7] skip10 = {trapCYCLE, aluZERO,    sc_sign,  cons_exec,
                        iolatch,    cons_cont,  msec_intr};

   //
   // DBM inputs
   //
   
   wire [0:35] dbm0 = {scad[1:9], 8'b1111_1111, scad[0], dispPF, trapEN,
                       pageEN, aprFLAGS, apr_int_req, 3'b111};
   wire [0:35] dbm1 = {scad[1:7], scad[1:7], scad[1:7], scad[1:7],
                       scad[1:7], dp[35]};
   wire [0:35] dbm2 = {1'b0, scad[2:9], dp[9:17], 6'b111_111,
                       msec_count[24:33], 2'b00};
   wire [0:35] dbm3 = dp[0:35];
   wire [0:35] dbm4 = {dp[18:35], dp[0:17]};
   wire [0:35] dbm5 = {vmaFLAGS[0:13], vmaADDR[14:35]};
   wire [0:35] dbm6 = mb[0:35];
   wire [0:35] dbm7 = {`cromNUM, `cromNUM};

   //
   //
   //
   
   AC_BLOCK uAC_BLOCK(.clk(clk),
                      .rst(rst),
                      .clken(clken),
                      .crom(crom),
                      .dp(dp),
                      .curr_block(curr_block),
                      .prev_block(prev_block));
 
   //
   // Arithmetic Logic Unit
   //

   ALU uALU(.clk(clk),
            .rst(rst),
            .clken(clken),
            .dbus(dbus),
            .crom(crom),
            .aluLZero(aluLZero),
            .aluRZero(aluRZero),
            .aluLSign(aluLSign),
            .aluRSign(aluRSign),
            .aluAOV(aluAOV),
            .aluCRY0(aluCRY0),
            .aluCRY1(aluCRY1),
            .aluCRY2(aluCRY2),
            .aluQR37(aluQR37),
            .t(t));

   //
   // APR
   //

   APR uAPR(.clk(clk),
            .rst(rst),
            .clken(clken),
            .crom(crom),
            .dp(dp),
            .bus_ac_lo(bus_ac_lo),
            .nxm_err(nxm_err),
            .bad_data_err(bad_data_err),
            .int_10(int_10),
            .trapEN(trapEN),
            .pageEN(pageEN),
            .aprFLAGS(aprFLAGS),
            .apr_int_req(apr_int_req),
            .bus_pi_req_out(bus_pi_req_out));

   //
   // Byte Dispatch
   //

   BYTE_DISP uBYTE_DISP(.dp(dp),
                        .dispBYTE(dispBYTE));

   //
   //
   //


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
   // DBUS MUX
   //

   DBUS uDBUS(.crom(crom),
              .force_ramfile(force_ramfile),
              .pcFLAGS({pcFLAGS, 1'b0, pi_new, 4'b1111, vmaADDR[26:35]}),
              .dp(dp),
              .ram(ram),
              .dbm(dbm),
              .dbus(dbus));


   //
   // Dispatch ROM
   //

   DROM uDROM(.clk(clk),
              .rst(rst),
              .clken(clken),
              .addr(dbus[0:8]),
              .drom(drom));

   //
   //
   //
   
   INTR uINTR(.clk(clk),
              .rst(rst),
              .clken(clken),
              .crom(crom),
              .dp(dp),
              .bus_pi_req_in(bus_pi_req_in),
              .interrupt_req(interrupt_req),
              .pi_new(pi_new),
              .pi_on(pi_on));
                
   //
   //
   //
   
   IOLATCH uIOLATCH(.clk(clk),
                    .rst(rst),
                    .clken(clken),
                    .crom(crom),
                    .iolatch(iolatch));
   
  
   //
   // Instruction Register
   //

   regIR uIR(.clk(clk),
             .rst(rst),
             .clken(clken),
             .crom(crom),
             .dbus(dbus),
             .ir(ir),
             .ac(ac),
             .jrst0(jrst0));

   assign ac_eq_zero = (ac == 4'b0000);
   
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
                      .ac(ac),
                      .drom(drom),
                      .crom(crom));
   
   //
   // Next Instruction Dispatch
   //
   
   NI_DISP uNI_DISP(.run(cons_run),
                    .memory_cycle(memory_cycle),
                    .traps(traps),
                    .dispNI(dispNI));

   //
   // Page Tables
   //
   
   PAGE_TABLES uPAGE_TABLES(.clk(clk),
                            .rst(rst),
                            .clken(clken),
                            .crom(crom),
                            .drom(drom),
                            .dp(dp),
                            .vma(vmaADDR),
                            .vmaUSER(vmaUSER),
                            .page_valid(page_valid),
                            .page_writeable(page_writeable),
                            .page_cacheable(page_cacheable),
                            .page_user(page_user),
                            .page_number(page_number));
   
   
   //
   // PC Flags
   //

   PCFLAGS uPCFLAGS(.clk(clk),
                    .rst(rst),
                    .clken(clken),
                    .crom(crom),
                    .dp(dp),
                    .dbm(dbm),
                    .scad(scad),
                    .ac(ac),
                    .aluAOV(aluAOV),
                    .aluCRY0(aluCRY0),
                    .aluCRY1(aluCRY1),
                    .pcFLAGS(pcFLAGS),
                    .jfcl_skip(jfcl_skip));

   //
   // Pxct
   //

   PXCT uPXCT(.clk(clk),
              .rst(rst),
              .clken(clken),
              .crom(crom),
              .dp(dp),
              .pxct_on(pxct_on),
              .previous_en(previousEN),
              .pxct(pxct));

   //
   // RAMFILE
   //

   RAMFILE uRAMFILE(.clk(clk),
                    .rst(rst),
                    .clken(1'b1),
                    .crom(crom),
                    .dbus(dbus),
                    .dbm(dbm),
                    .ac(ac),
                    .xr(xr),
                    .xr_previous(xr_previous),
                    .vmaADDR(vmaADDR),
                    .vmaPHYSICAL(vmaPHYSICAL),
                    .vmaPREVIOUS(vmaPREVIOUS),
                    .previous_block(prev_block),
                    .current_block(curr_block),
                    .ram(ram));    
              
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
   //
   
   TIMER uTIMER(.clk(clk),
                .rst(rst),
                .clken(clken),
                .crom(crom),
                .msec_en(cons_msec_en),
                .msec_intr(msec_intr),
                .msec_count(msec_count));

   //
   // Traps
   //
   
   TRAPS uTRAPS(.clk(clk),
                .rst(rst),
                .clken(clken),
                .crom(crom),
                .dp(dp),
                .pcFLAGS(pcFLAGS),
                .consTRAPEN(consTRAPEN),
                .trapEN(trapEN),
                .traps(traps),
                .trapCYCLE(trapCYCLE));
              
   //
   // VMA
   //
   
   VMA uVMA(.clk(clk),
            .rst(rst),
            .clken(clken),
            .crom(crom),
            .drom(drom),
            .dp(dp),
            .execute(cons_exec),
            .previousEN(previousEN),
            .flagPCU(flagPCU),
            .flagUSER(flagUSER),
            .vmaSWEEP(vmaSWEEP),
            .vmaEXTENDED(vmaEXTENDED),
            .vmaACREF(vmaACREF),
            .vmaFLAGS(vmaFLAGS),
            .vmaADDR(vmaADDR));

   //
   // Index Register
   //

   regXR uXR(.clk(clk),
             .rst(rst),
             .clken(clken),
             .dbus(dbus),
             .crom(crom),
             .prev_en(previousEN),
             .xr(xr),
             .indirect(indirect),
             .xr_previous(xr_previous));

   assign xr_eq_zero = (xr == 4'b0000);
   
endmodule


