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
//!      cpu.v
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

`include "useq/crom.vh"
`include "useq/drom.vh"

module CPU(clk, rst, clken, consTIMEREN, 
            consSTEP, consRUN, consEXEC, consCONT, consTRAPEN, consCACHEEN, 
            intPWR, intCONS,
            bus_data_in, bus_data_out,
            bus_pi_req_in,  bus_pi_req_out, bus_pi_current,
           
            crom, dp, pageNUMBER);

   parameter cromWidth = `CROM_WIDTH;
   parameter dromWidth = `DROM_WIDTH;

   input                  clk;          // Clock
   input                  rst;          // Reset
   input                  clken;        // Clock enable
   input                  consTIMEREN; 	// Timer Enable
   input                  consSTEP;	// Single Step
   input                  consRUN;      // Run
   input                  consEXEC;     // Execute
   input                  consCONT;     // Continue
   input                  consTRAPEN;   // Enable Traps
   input                  consCACHEEN;  // Enable Cache
   input                  intPWR;    	// Power Fail Interrupt
   input                  intCONS;    	// Console Interrupt

   input  [1: 7]          bus_pi_req_in;
   output [1: 7]          bus_pi_req_out;
   output [0: 2]          bus_pi_current;
   input  [0:35]          bus_data_in;
   output [0:35]          bus_data_out;
   
   output [0:cromWidth-1] crom;         // Control ROM
   output [0:35]          dp;           // ALU Output Bus
   output [16:26] 	  pageNUMBER;

   //
   // ROMS
   //
   
   wire [0:dromWidth-1] drom;           // Dispatch ROM
   
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
   

   wire apr_int_req;
   wire mem_wait;
   wire stop_main_memory;
   wire memory_cycle            = 1'b0;         // FIXME
   wire interrupt_req;
   wire iolatch;
   wire intNXM                  = 1'b0;         // FIXME
   wire intBADDATA              = 1'b0;         // FIXME
   wire forceRAMFILE            = 1'b0;         // FIXME
   wire JRST0;
   wire indirect;
   
   //
   // Registers
   //

   wire [ 0: 2] pi_new;
   wire [ 0: 2] curr_block;             //
   wire [ 0: 2] prev_block;             //
   
   //
   // PC Flags
   //

   wire [ 0:17] pcFLAGS;
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
   // APR Flags
   //
   
   wire [22:35] aprFLAGS;
   wire         trapEN         = aprFLAGS[22];
   wire         pageEN         = aprFLAGS[23];
   wire         flagPWR        = aprFLAGS[26];
   wire         flagNXM        = aprFLAGS[27];
   wire         flagBADDATA    = aprFLAGS[28];
   wire         flagCORDATA    = aprFLAGS[29];
   wire         flagCONS       = aprFLAGS[31];
   wire         flagINTREG     = aprFLAGS[32];

   //
   // A Registers
   //
   
   wire [ 0:13] vmaFLAGS;
   wire [14:35] vmaADDR;
   wire         vmaUSER        = vmaFLAGS[ 0];
   wire         vmaEXEC        = vmaFLAGS[ 1];
   wire         vmaFETCH       = vmaFLAGS[ 2];
   wire         vmaREADCYCLE   = vmaFLAGS[ 3];		// 1 = Read Cycle (IO or Memory)
   wire         vmaWRTESTCYCLE = vmaFLAGS[ 4];
   wire         vmaWRITECYCLE  = vmaFLAGS[ 5];		// 1 = Write Cycle (IO or Memory)
   wire         vmaIORDWR      = vmaFLAGS[ 6];
   wire         vmaCACHEIHN    = vmaFLAGS[ 7];
   wire         vmaPHYSICAL    = vmaFLAGS[ 8];   
   wire         vmaPREVIOUS    = vmaFLAGS[ 9];
   wire         vmaIOCYCLE     = vmaFLAGS[10];		// 0 = Memory Cycle, 1 = IO Cycle
   wire         vmaWRUCYCLE    = vmaFLAGS[11];		// 1 = Read interrupt controller number
   wire         vmaVECTORCYCLE = vmaFLAGS[12];		// 1 = Read interrupt vector 
   wire         vmaIOBYTECYCLE = vmaFLAGS[13];		// 1 = Unibus Byte IO Operation
   wire         vmaACREF;

   //
   // Paging
   //
   
   wire         pageFAIL       = 1'b0;         // FIXME
   wire         pageVALID;
   wire         pageWRITEABLE;
   wire         pageCACHEABLE;
   wire         pageUSER;
// wire [16:26] pageNUMBER;

   //
   // Timer
   //

   wire         timerINTR;
   wire [24:35] timerCOUNT;             // Millisecond timer
   
   
   //
   // Instruction Register IR
   //

   wire [ 0:17] regIR;
   wire [ 0: 8] regIR_OPCODE = regIR[ 0: 8];
   wire [ 9:12] regIR_AC     = regIR[ 9:12];
   wire         regIR_I      = regIR[13];
   wire [14:17] regIR_XR     = regIR[14:17];
   wire         regACZERO    = (regIR_AC == 4'b0000);
   wire         regXRZERO    = (regIR_XR == 4'b0000);
   wire         xrPREV;

   //
   // PXCT
   //

   wire [ 9:12] pxct;
   wire         pxctON;
   wire         prevEN;
   
   //
   // Busses
   //

   wire [ 0:35] dp;                     // ALU output bus
   wire [ 0:35] dbus;                   //
   wire [ 0:35] dbm;                    //
   wire [ 0:35] mb = 36'b0;             // FIXME Memory Buffer
   wire [ 0:35] ramfile;                // RAMFILE output
   
   //
   // SCAD, SC, and FE
   //
   
   wire [ 0: 9] scad;
   wire [ 0: 9] sc;
   wire         scSIGN = sc[0];
   wire [ 0: 9] fe;
   wire         feSIGN = fe[0];

   //
   // Traps
   //

   wire [3:1]   traps;
   wire         trapCYCLE;
   
   //
   // Dispatches
   //
   
   wire [ 8:11] dispSCAD;                                       // SCAD dispatch
   wire [ 8:11] dispNI;                                         // Next Instruction dispatch
   wire [ 8:11] dispBYTE;                                       // Byte dispatch
   wire [ 8:11] dispMUL  = {1'b0, aluQR37, 1'b0, 1'b0};         // Multiply dispatch
   wire [ 8:11] dispPF   = 4'b0000;                             // Page Fail dispatch (depricated)
   wire [ 8:11] dispNORM = {aluZERO, dp[8:9], aluLSign};        // Normalize dispatch
   wire [ 8:11] dispEA   = {~JRST0, regIR_I, regXRZERO, 1'b0}; 	// EA Dispatch
   wire [ 0:11] dispDIAG = 12'b0000_0000_0000;                  // Diagnostic Dispatch

   //
   // Skips
   //

   wire skipJFCL;
   wire [1:7] skip40 = {aluCRY0,   aluLZero,  aluRZero, flagUSER,
                        flagFPD,   regACZERO, interrupt_req};
   wire [1:7] skip20 = {aluCRY2,   aluLSign,  aluRSign, flagUSERIO,
                        skipJFCL,  aluCRY1,   txxx};
   wire [1:7] skip10 = {trapCYCLE, aluZERO,   scSIGN,   consEXEC,
                        iolatch,   consCONT,  timerINTR};

   //
   // DBM inputs
   //
   
   wire [0:35] dbm0 = {scad[1:9], 8'b11111111, scad[0], aprFLAGS};
   wire [0:35] dbm1 = {scad[1:7], scad[1:7], scad[1:7], scad[1:7], scad[1:7], dp[35]};
   wire [0:35] dbm2 = {1'b0, scad[2:9], dp[9:17], 6'b111111, timerCOUNT};
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
            .t(dp));

   //
   // APR
   //

   APR uAPR(.clk(clk),
            .rst(rst),
            .clken(clken),
            .crom(crom),
            .dp(dp),
            .intPWR(intPWR),
            .intNXM(intNXM),
            .intBADDATA(intBADDATA),
            .intCONS(intCONS),
            .aprFLAGS(aprFLAGS),
            .bus_pi_req_out(bus_pi_req_out));

   //
   // Byte Dispatch
   //

   BYTE_DISP uBYTE_DISP(.dp(dp),
                        .dispBYTE(dispBYTE));

/*
   BUS uBUS(.clk(clk),
            .rst(rst),
            .clken(clken),
            .dp(dp),
            .vmaFLAGS(vmaFLAGS),
            .busDATA(busDATA));
 */  
      

   //
   // Data Bus
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
              .forceRAMFILE(forceRAMFILE),
              .pcFLAGS({pcFLAGS, 1'b0, pi_new, 4'b1111, vmaADDR[26:35]}),
              .dp(dp),
              .ramfile(ramfile),
              .dbm(dbm),
              .dbus(dbus));

   //
   // Dispatch ROM
   //

   DROM uDROM(.clk(clk),
              .rst(rst),
              .clken(clken),
              .dbus(dbus),
              .crom(crom),
              .drom(drom));

   //
   // Interrupt Controller
   //
   
   INTR uINTR(.clk(clk),
              .rst(rst),
              .clken(clken),
              .crom(crom),
              .dp(dp),
              .bus_pi_req_in(bus_pi_req_in),
              .interrupt_req(interrupt_req),
              .pi_new(pi_new),
              .pi_current(bus_pi_current),
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
             .prevEN(prevEN),
             .regIR(regIR),
             .xrPREV(xrPREV),
             .JRST0(JRST0));
   
   //
   // Microsequencer
   //

   USEQ uUSEQ(.clk(clk),
          .rst(rst),
          .clken(clken),
          .pageFAIL(pageFAIL),
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
          .regIR(regIR),
          .drom(drom),
          .crom(crom));
   
   //
   // Next Instruction Dispatch
   //
   
   NI_DISP uNI_DISP(.run(consRUN),
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
                            .vmaADDR(vmaADDR),
                            .vmaFLAGS(vmaFLAGS),
                            .pageVALID(pageVALID),
                            .pageWRITEABLE(pageWRITEABLE),
                            .pageCACHEABLE(pageCACHEABLE),
                            .pageUSER(pageUSER),
                            .pageNUMBER(pageNUMBER));
   
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
                    .regIR(regIR),
                    .aluAOV(aluAOV),
                    .aluCRY0(aluCRY0),
                    .aluCRY1(aluCRY1),
                    .pcFLAGS(pcFLAGS),
                    .skipJFCL(skipJFCL));

   //
   // Pxct
   //

   PXCT uPXCT(.clk(clk),
              .rst(rst),
              .clken(clken),
              .crom(crom),
              .dp(dp),
              .pxctON(pxctON),
              .prevEN(prevEN),
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
                    .regIR(regIR),
                    .xrPREV(xrPREV),
                    .vmaADDR(vmaADDR),
                    .vmaPHYSICAL(vmaPHYSICAL),
                    .vmaPREVIOUS(vmaPREVIOUS),
                    .previous_block(prev_block),
                    .current_block(curr_block),
                    .ramfile(ramfile));    
              
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
                .timerEN(consTIMEREN),
                .timerINTR(timerINTR),
                .timerCOUNT(timerCOUNT));

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
            .consEXEC(consEXEC),
            .prevEN(prevEN),
            .flagPCU(flagPCU),
            .flagUSER(flagUSER),
            .vmaSWEEP(vmaSWEEP),
            .vmaEXTENDED(vmaEXTENDED),
            .vmaACREF(vmaACREF),
            .vmaFLAGS(vmaFLAGS),
            .vmaADDR(vmaADDR));
   
endmodule


