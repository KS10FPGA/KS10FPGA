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
`include "useq/crom.vh"
`include "useq/drom.vh"

module CPU(clk, rst,
           consTIMEREN, consSTEP, consRUN, consEXEC, consCONT, consHALT, consTRAPEN, consCACHEEN,
           pwrINTR, consINTR, busINTR, curINTR_NUM,
           busREQ, busACK, busDATAI, busDATAO, busADDRO,
           cpuEXEC, cpuHALT, cpuRUN);

   parameter cromWidth = `CROM_WIDTH;
   parameter dromWidth = `DROM_WIDTH;

   input          clk;          // Clock
   input          rst;          // Reset
   input          consTIMEREN;  // Timer Enable
   input          consSTEP;     // Single Step
   input          consRUN;      // Run
   input          consEXEC;     // Execute
   input          consHALT;     // HALT
   input          consCONT;     // Continue
   input          consTRAPEN;   // Enable Traps
   input          consCACHEEN;  // Enable Cache
   input          pwrINTR;      // Power Fail Interrupt Request
   input          consINTR;     // Console Interrupt Request
   input  [ 1: 7] busINTR;      // Unibus Interrupt Request
   output [ 0: 2] curINTR_NUM;  // Current Interrupt Priority
   output         busREQ;       // Bus Request
   input          busACK;       // Bus Acknowledge
   input  [ 0:35] busDATAI;     // Bus Data Input
   output [ 0:35] busDATAO;     // Bus Data Output
   output [ 0:35] busADDRO;     // Bus Addr and Flags
   output         cpuEXEC;      // 
   output         cpuHALT;      //
   output         cpuRUN;       //

   //
   // ROMS
   //

   wire [0:cromWidth-1] crom;                           // Control ROM
   wire [0:dromWidth-1] drom;                           // Dispatch ROM

   //
   // ALU
   //

   wire aluLZERO;                                       // ALU left-half is zero
   wire aluRZERO;                                       // ALU right-half is zero
   wire aluLSIGN;                                       // ALU left-half sign
   wire aluRSIGN;                                       // ALU right-half sign
   wire aluAOV;                                         // ALU arithmetic overflow
   wire aluCRY0;                                        // ALU carry into bit 0
   wire aluCRY1;                                        // ALU carry into bit 1
   wire aluCRY2;                                        // ALU carry into bit 2
   wire aluQR37;                                        // Q Register LSB
   wire aluZERO = aluLZERO & aluRZERO;                  // ALU (both halves) is zero
   wire txxx    = aluZERO != `dromTXXXEN;               // Test Instruction Results

   //
   // flags
   //

   wire mem_wait;
   wire stop_main_memory;
   wire memory_cycle = 1'b0;                            // FIXME
   wire iolatch;                                        // FIXME
   wire cpuCONT;                                        //
   wire JRST0;
   wire trapCYCLE;

   //
   // Interrupts
   //

   wire cpuINTR;                                        // Extenal Interrupt
   wire nxmINTR = 1'b0;                                 // FIXME
   wire [ 0: 2] newINTR_NUM;                            // New Interrupt Number
   wire [ 1: 7] aprINTR;                                // APR Interrupt Request

   //
   // AC Blocks
   //

   wire [ 0: 5] acBLOCK;                                // AC Block
   wire [ 0: 2] currBLOCK = acBLOCK[0:2];               //  Current AC Block
   wire [ 0: 2] prevBLOCK = acBLOCK[3:5];               //  Previous AC Block

   //
   // PC Flags
   //

   wire [ 0:17] pcFLAGS;                                // PC Flags
   wire         flagAOV        = pcFLAGS[ 0];           //  Arithmetic overflow
   wire         flagCRY0       = pcFLAGS[ 1];           //  Carry into bit 0
   wire         flagCRY1       = pcFLAGS[ 2];           //  Carry into bit 1
   wire         flagFOV        = pcFLAGS[ 3];           //  Floating-poing overflow
   wire         flagFPD        = pcFLAGS[ 4];           //  First Part Done
   wire         flagUSER       = pcFLAGS[ 5];           //  User Mode
   wire         flagUSERIO     = pcFLAGS[ 6];           //  User mode IO instructions
   wire         flagPCU        = pcFLAGS[ 6];           //  Previous Context User
   wire         flagTRAP2      = pcFLAGS[ 9];           //  Trap2
   wire         flagTRAP1      = pcFLAGS[10];           //  Trap1
   wire         flagFXU        = pcFLAGS[11];           //  Floating-point underflow
   wire         flagNODIV      = pcFLAGS[12];           //  Divide failure

   //
   // APR Flags
   //

   wire [22:35] aprFLAGS;                               // Arithmetic Processor Flags
   wire         flagTRAPEN     = aprFLAGS[22];          //  Traps are enabled
   wire         flagPAGEEN     = aprFLAGS[23];          //  Paging is enabled
   wire         flagPWR        = aprFLAGS[26];          //  Power fail
   wire         flagNXM        = aprFLAGS[27];          //  Non existent memory
   wire         flagBADDATA    = aprFLAGS[28];          //  Bad memory data (not implemented)
   wire         flagCORDATA    = aprFLAGS[29];          //  Corrected memory data (not implemented)
   wire         flagCONS       = aprFLAGS[31];          //  Console interrupt
   wire         flagINTREQ     = aprFLAGS[32];          //  Interrupt Request

   //
   // A Registers
   //

   wire [14:35] vmaADDR;                                // VMA Address
   wire [ 0:13] vmaFLAGS;                               // VMA Flags
   wire         vmaUSER        = vmaFLAGS[ 0];          //  1 = User Mode
   wire         vmaEXEC        = vmaFLAGS[ 1];          //  1 = Exec Mode
   wire         vmaFETCH       = vmaFLAGS[ 2];          //  1 = Instruction fetch
   wire         vmaREADCYCLE   = vmaFLAGS[ 3];          //  1 = Read Cycle (IO or Memory)
   wire         vmaWRTESTCYCLE = vmaFLAGS[ 4];          //  1 = Perform write test for page fail
   wire         vmaWRITECYCLE  = vmaFLAGS[ 5];          //  1 = Write Cycle (IO or Memory)
   wire         vmaIORDWR      = vmaFLAGS[ 6];          //
   wire         vmaCACHEIHN    = vmaFLAGS[ 7];          //  1 = Cache is inhibited
   wire         vmaPHYSICAL    = vmaFLAGS[ 8];          //  1 = Physical reference
   wire         vmaPREVIOUS    = vmaFLAGS[ 9];          //  1 = VMA Previous Context
   wire         vmaIOCYCLE     = vmaFLAGS[10];          //  1 = IO Cycle, 0 = Memory Cycle
   wire         vmaWRUCYCLE    = vmaFLAGS[11];          //  1 = Read interrupt controller number
   wire         vmaVECTORCYCLE = vmaFLAGS[12];          //  1 = Read interrupt vector
   wire         vmaIOBYTECYCLE = vmaFLAGS[13];          //  1 = Unibus Byte IO Operation
   wire         vmaEXTENDED;                            //  Extended VMA
   
   //
   // Paging
   //

   wire         pageFAIL       = 1'b0;                  // Page Fail FIXME
   wire [16:26] pageADDR;                               // Page Address
   wire [ 0: 4] pageFLAGS;                              // Page Flags
   wire         pageVALID      = pageFLAGS[0];          //  Page is valid
   wire         pageWRITEABLE  = pageFLAGS[1];          //  Page is writeable
   wire         pageCACHEABLE  = pageFLAGS[2];          //  Page is cacheable
   wire         pageUSER       = pageFLAGS[3];          //  Page is user mode
   wire         pagePARITY     = pageFLAGS[4];          //  Not implemented

   //
   // Timer
   //

   wire         timerINTR;                               // Timer Interrupt
   wire [18:35] timerCOUNT;                             // Millisecond timer

   //
   // Instruction Register IR
   //

   wire [ 0:17] regIR;                                  // Instruction Register (IR)
   wire [ 0: 8] regIR_OPCODE = regIR[ 0: 8];            //  IR opcode Field
   wire [ 9:12] regIR_AC     = regIR[ 9:12];            //  IR AC field
   wire         regIR_I      = regIR[13];               //  IR I field
   wire [14:17] regIR_XR     = regIR[14:17];            //  IR XR field
   wire         regACZERO    = (regIR_AC == 4'b0000);   //  AC is zero
   wire         regXRZERO    = (regIR_XR == 4'b0000);   //  XR is zero
   wire         xrPREV;                                 //  XR is previous

   //
   // PXCT
   //

   wire         prevEN;                                 // Conditionally use previous context

   //
   // Cache
   //

   wire         cacheHIT = 1'b0;                        // FIXME: Cache not implemented.

   //
   // Busses
   //

   wire [ 0:35] dp;                                     // ALU output bus
   wire [ 0:35] dbus;                                   // DBUS Mux output
   wire [ 0:35] dbm;                                    // DBM Mux output
   wire [ 0:35] ramfile;                                // RAMFILE output

   //
   // SCAD, SC, and FE
   //

   wire [ 0: 9] scad;
   wire         scadSIGN = scad[0];                     // SCAD Sign
   wire         scSIGN;                                 // Step Count Sign
   wire         feSIGN;                                 // Floating-point exponent Sign

   //
   // Dispatches
   //

   wire [ 8:11] dispNI;                                 // Next Instruction dispatch
   wire [ 8:11] dispPF;                                 // Page Fail dispatch
   wire [ 8:11] dispBYTE;                               // Byte dispatch
   wire [ 8:11] dispSCAD;                               // SCAD dispatch
   wire [ 8:11] dispMUL  = {1'b0, aluQR37,              // Multiply dispatch
                            1'b0, 1'b0};
   wire [ 8:11] dispNORM = {aluZERO, dp[8:9],           // Normalize dispatch
                            aluLSIGN};
   wire [ 8:11] dispEA   = {~JRST0, regIR_I,            // EA Dispatch
                            regXRZERO, 1'b0};
   wire [ 0:11] dispDIAG = 12'b0;                       // Diagnostic Dispatch

   //
   // DEBUG
   //

   wire [0: 3]  debugADDR;                              // DEBUG Address
   wire [0:35]  debugDATA;                              // DEBUG Data

   //
   // Skips
   //

   wire skipJFCL;
   wire [1:7] skip40 = {aluCRY0,   aluLZERO, aluRZERO, ~flagUSER,  flagFPD,  regACZERO, cpuINTR   };
   wire [1:7] skip20 = {aluCRY2,   aluLSIGN, aluRSIGN, flagUSERIO, skipJFCL, aluCRY1,   txxx      };
   wire [1:7] skip10 = {trapCYCLE, aluZERO,  scSIGN,   cpuEXEC,    iolatch,  ~cpuCONT,  ~timerINTR};

   //
   // Timing
   //

   wire clkenDP;                                        // Clock Enable for Datapaths
   wire clkenCR;                                        // Clock Enable for Control ROM

   TIMING uTIMING
     (.clk(clk),
      .rst(rst),
      .crom(crom),
      .drom(drom),
      .dp(dp),
      .feSIGN(feSIGN),
      .clkenDP(clkenDP),
      .clkenCR(clkenCR)
      );

   //
   // AC Block
   //

   AC_BLOCK uAC_BLOCK
     (.clk(clk),
      .rst(rst),
      .clken(clkenDP),
      .crom(crom),
      .dp(dp),
      .acBLOCK(acBLOCK)
      );

   //
   // Arithmetic Logic Unit
   //

   ALU uALU
     (.clk(clk),
      .rst(rst),
      .clken(clkenDP),
      .crom(crom),
      .aluIN(dbus),
      .aluLZERO(aluLZERO),
      .aluRZERO(aluRZERO),
      .aluLSIGN(aluLSIGN),
      .aluRSIGN(aluRSIGN),
      .aluAOV(aluAOV),
      .aluCRY0(aluCRY0),
      .aluCRY1(aluCRY1),
      .aluCRY2(aluCRY2),
      .aluQR37(aluQR37),
      .aluOUT(dp),
      .debugADDR(debugADDR),
      .debugDATA(debugDATA)
      );

   //
   // APR
   //

   APR uAPR
     (.clk(clk),
      .rst(rst),
      .clken(clkenDP),
      .crom(crom),
      .dp(dp),
      .pwrINTR(pwrINTR),
      .nxmINTR(nxmINTR),
      .consINTR(consINTR),
      .aprFLAGS(aprFLAGS),
      .aprINTR(aprINTR)
      );

   //
   // Byte Dispatch
   //

   BYTE_DISP uBYTE_DISP
     (.dp(dp),
      .dispBYTE(dispBYTE)
      );

   //
   // Memory/IO Bus
   //

   BUS uBUS
     (.clk(clk),
      .rst(rst),
      .clken(clkenDP),
      .crom(crom),
      .dp(dp),
      .vmaEXTENDED(vmaEXTENDED),
      .vmaFLAGS(vmaFLAGS),
      .vmaADDR(vmaADDR),
      .pageADDR(pageADDR),
      .aprFLAGS(aprFLAGS),
      .busREQ(busREQ),
      .busACK(busACK),
      .busDATAO(busDATAO),
      .busADDRO(busADDRO)
      );

   //
   // Data Bus
   //

   DBM uDBM
     (.crom(crom),
      .dp(dp),
      .scad(scad),
      .dispPF(dispPF),
      .aprFLAGS(aprFLAGS),
      .timerCOUNT(timerCOUNT),
      .vmaFLAGS(vmaFLAGS),
      .vmaADDR(vmaADDR),
      .busDATAI(busDATAI),
      .dbm(dbm)
      );

   //
   // DEBUG
   //

   DEBUG uDEBUG
      (.clk(clk),
       .rst(rst),
       .clken(clkenDP),
       .debugDATA(debugDATA),
       .debugADDR(debugADDR)
       );

   //
   // DBUS MUX
   //

   DBUS uDBUS
     (.crom(crom),
      .cacheHIT(cacheHIT),
      .vmaFLAGS(vmaFLAGS),
      .vmaADDR(vmaADDR),
      .pcFLAGS({pcFLAGS, 1'b0, newINTR_NUM, 4'b1111, vmaADDR[26:35]}),
      .dp(dp),
      .ramfile(ramfile),
      .dbm(dbm),
      .dbus(dbus)
      );

   //
   // Dispatch ROM
   //

   DROM uDROM
     (.clk(clk),
      .rst(rst),
      .clken(clkenDP),
      .dbus(dbus),
      .crom(crom),
      .drom(drom)
      );

   //
   // Interrupt Controller
   //

   INTR uINTR
     (.clk(clk),
      .rst(rst),
      .clken(clkenDP),
      .crom(crom),
      .dp(dp),
      .flagINTREQ(flagINTREQ),
      .aprINTR(aprINTR),
      .busINTR(busINTR),
      .newINTR_NUM(newINTR_NUM),
      .curINTR_NUM(curINTR_NUM),
      .cpuINTR(cpuINTR)
      );

   //
   // INTF
   //  Console Interface
   //

   INTF uINTF
     (.clk(clk),
      .rst(rst),
      .clken(clkenDP),
      .crom(crom),
      .consRUN(consRUN),
      .consCONT(consCONT),
      .consEXEC(consEXEC),
      .consHALT(consHALT),
      .cpuRUN(cpuRUN),
      .cpuCONT(cpuCONT),
      .cpuEXEC(cpuEXEC),
      .cpuHALT(cpuHALT)
      );

   //
   // IO Latch
   //

   IOLATCH uIOLATCH
     (.clk(clk),
      .rst(rst),
      .clken(clkenDP),
      .crom(crom),
      .iolatch(iolatch)
      );

   //
   // Instruction Register
   //

   regIR uIR
     (.clk(clk),
      .rst(rst),
      .clken(clkenDP),
      .crom(crom),
      .dbus(dbus),
      .prevEN(prevEN),
      .regIR(regIR),
      .xrPREV(xrPREV),
      .JRST0(JRST0)
      );

   //
   // Microsequencer
   //

   USEQ uUSEQ
     (.clk(clk),
      .rst(rst),
      .clken(clkenCR),
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
      .crom(crom)
      );

   //
   // Next Instruction Dispatch
   //

   NI_DISP uNI_DISP
     (.aprFLAGS(aprFLAGS),
      .pcFLAGS(pcFLAGS),
      .consTRAPEN(consTRAPEN),
      .cpuRUN(cpuRUN),
      .memory_cycle(memory_cycle),
      .dispNI(dispNI)
      );

   //
   // Page Tables
   //

   PAGE_TABLES uPAGE_TABLES
     (.clk(clk),
      .rst(rst),
      .clken(clkenDP),
      .crom(crom),
      .drom(drom),
      .dp(dp),
      .vmaADDR(vmaADDR),
      .vmaFLAGS(vmaFLAGS),
      .pageFLAGS(pageFLAGS),
      .pageADDR(pageADDR)
      );

   //
   // PC Flags
   //

   PCFLAGS uPCFLAGS
     (.clk(clk),
      .rst(rst),
      .clken(clkenDP),
      .crom(crom),
      .dp(dp),
      .scad(scad),
      .regIR(regIR),
      .aluAOV(aluAOV),
      .aluCRY0(aluCRY0),
      .aluCRY1(aluCRY1),
      .pcFLAGS(pcFLAGS),
      .skipJFCL(skipJFCL)
      );

   //
   // Page Fail Dispatch
   //

   PF_DISP uPF_DISP
     (.clk(clk),
      .rst(rst),
      .clken(clkenDP),
      .crom(crom),
      .drom(drom),
      .vmaFLAGS(vmaFLAGS),
      .vmaADDR(vmaADDR),
      .aprFLAGS(aprFLAGS),
      .pageFLAGS(pageFLAGS),
      .cpuINTR(cpuINTR),
      .nxmINTR(nxmINTR),
      .timerINTR(timerINTR),
      .dispPF(dispPF)
      );

   //
   // PXCT
   //  Previous context

   PXCT uPXCT
     (.clk(clk),
      .rst(rst),
      .clken(clkenDP),
      .crom(crom),
      .dp(dp),
      .prevEN(prevEN)
      );

   //
   // RAMFILE
   //

   RAMFILE uRAMFILE
     (.clk(clk),
      .rst(rst),
      .clken(1'b1),
      .crom(crom),
      .drom(drom),
      .dp(dp),
      .dbus(dbus),
      .regIR(regIR),
      .xrPREV(xrPREV),
      .vmaFLAGS(vmaFLAGS),
      .vmaADDR(vmaADDR),
      .acBLOCK(acBLOCK),
      .ramfile(ramfile)
      );

   //
   // SCAD
   //

   SCAD uSCAD
     (.clk(clk),
      .rst(rst),
      .clken(clkenDP),
      .crom(crom),
      .dp(dp),
      .scSIGN(scSIGN),
      .feSIGN(feSIGN),
      .scad(scad),
      .dispSCAD(dispSCAD)
      );

   //
   // One millisecond (more or less) interval timer.
   //

   TIMER uTIMER
     (.clk(clk),
      .rst(rst),
      .clken(clkenDP),
      .crom(crom),
      .timerEN(consTIMEREN),
      .timerINTR(timerINTR),
      .timerCOUNT(timerCOUNT)
      );

   //
   // Traps
   //

   TRAPS uTRAPS
     (.clk(clk),
      .rst(rst),
      .clken(clkenDP),
      .crom(crom),
      .pcFLAGS(pcFLAGS),
      .aprFLAGS(aprFLAGS),
      .consTRAPEN(consTRAPEN),
      .trapCYCLE(trapCYCLE)
      );

   //
   // VMA
   //

   VMA uVMA
     (.clk(clk),
      .rst(rst),
      .clken(clkenDP),
      .crom(crom),
      .drom(drom),
      .dp(dp),
      .cpuEXEC(cpuEXEC),
      .prevEN(prevEN),
      .pcFLAGS(pcFLAGS),
      .vmaEXTENDED(vmaEXTENDED),
      .vmaFLAGS(vmaFLAGS),
      .vmaADDR(vmaADDR)
      );

endmodule
