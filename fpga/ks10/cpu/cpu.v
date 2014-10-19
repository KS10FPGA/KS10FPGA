////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KS10 CPU
//
// Details
//
// File
//   cpu.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2014 Rob Doyle
//
// This source file may be used and distributed without restriction provided
// that this copyright statement is not removed from the file and that any
// derivative work contains the original copyright notice and the associated
// disclaimer.
//
// This source file is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as published by the
// Free Software Foundation; version 2.1 of the License.
//
// This source is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License
// for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this source; if not, download it from
// http://www.gnu.org/licenses/lgpl.txt
//
////////////////////////////////////////////////////////////////////////////////

`default_nettype none
`include "useq/crom.vh"
`include "useq/drom.vh"
`include "apr.vh"

module CPU(rst, clkT, clkR, cslRESET, cslSET, cslRUN, cslCONT, cslEXEC,
           cslTIMEREN, cslTRAPEN, cslCACHEEN, cslINTRI, cslINTRO, ubaINTR,
           cpuREQO, cpuACKI, cpuADDRO, cpuDATAI, cpuDATAO, cpuHALT, cpuRUN,
           cpuEXEC, cpuCONT);

   parameter cromWidth = `CROM_WIDTH;
   parameter dromWidth = `DROM_WIDTH;

   input          rst;          // Reset
   input          clkT;         // Clock
   input          clkR;         // Clock
   // Console
   input          cslRESET;     // CPU Reset
   input          cslSET;       // Set Console RUN, EXEC, CONT
   input          cslRUN;       // Run
   input          cslCONT;      // Continue
   input          cslEXEC;      // Execute
   input          cslTIMEREN;   // Timer Enable
   input          cslTRAPEN;    // Enable Traps
   input          cslCACHEEN;   // Enable Cache
   input          cslINTRI;     // Console Interrupt to CPU
   output         cslINTRO;     // CPU Interrupt to Console
   // UBA
   input  [ 1: 7] ubaINTR;      // Unibus Interrupt Request
   // CPU
   output         cpuREQO;      // CPU Bus Request
   input          cpuACKI;      // Bus Acknowledge
   output [ 0:35] cpuADDRO;     // CPU Addr and Flags
   input  [ 0:35] cpuDATAI;     // Bus Data Input
   output [ 0:35] cpuDATAO;     // CPU Data Output
   output         cpuHALT;      // CPU Halt Status
   output         cpuRUN;       // CPU Run Status
   output         cpuEXEC;      // CPU Exec Status
   output         cpuCONT;      // CPU Cont Status

   //
   // ROMS
   //

   wire [0:cromWidth-1] crom;   // Control ROM
   wire [0:dromWidth-1] drom;   // Dispatch ROM

   //
   // Flags
   //

   wire memory_cycle = 0;       // FIXME
   wire nxmINTR;                // Non-existent memory interrupt
   wire memWAIT;                // Wait for memory
   wire ioWAIT;                 // Wait for memory
   wire ioBUSY;                 // IO is busy
   wire opJRST0;                // JRST 0 Instruction
   wire skipJFCL;               // JFCL Instruction
   wire trapCYCLE;              // Trap Cycle

   //
   // Prioity Interrupts
   //

   wire piINTR;                 // Priority Interrupt
   wire [ 0: 2] piCURPRI;       // Current Interrupt Priority
   wire [ 0: 2] piREQPRI;       // Requested Interrupt Priority

   //
   // PXCT
   //

   wire         prevEN;         // Conditionally use Previous Context
   wire [ 0: 5] acBLOCK;        // AC Block

   //
   // ALU Flags
   //

   wire [ 0: 8] aluFLAGS;       // ALU Flags

   //
   // PC Flags
   //

   wire [ 0:17] pcFLAGS;        // PC Flags

   //
   // APR Flags
   //

   wire [22:35] aprFLAGS;       // APR Flags
   wire [ 1: 7] aprINTR;        // APR Interrupt Request

   //
   // VMA Register
   //

   wire [ 0:35] vmaREG;         // VMA Register

   //
   // Paging
   //

   wire         pageFAIL;       // Page Fail
   wire [16:26] pageADDR;       // Page Address
   wire [ 0: 3] pageFLAGS;      // Page Flags

   //
   // Timer
   //

   wire         timerINTR;      // Timer Interrupt
   wire [18:35] timerCOUNT;     // Millisecond timer

   //
   // Instruction Register IR
   //

   wire [ 0:17] regIR;          // Instruction Register (IR)
   wire         xrPREV;         // XR is previous

   //
   // Cache
   //

   wire         cacheHIT = 0;   // FIXME: Cache not implemented.

   //
   // Busses
   //

   wire [ 0:35] dp;             // ALU output bus
   wire [ 0:35] dbus;           // DBUS Mux output
   wire [ 0:35] dbm;            // DBM Mux output
   wire [ 0:35] ramfile;        // RAMFILE output

   //
   // SCAD, SC, and FE
   //

   wire [ 0: 9] scad;
   wire         scSIGN;         // Step Count Sign
   wire         feSIGN;         // Floating-point exponent Sign

   //
   // Dispatches
   //

   wire [ 8:11] dispNI;         // Next Instruction Dispatch
   wire [ 8:11] dispPF;         // Page Fail Dispatch
   wire [ 8:11] dispBYTE;       // Byte Dispatch
   wire [ 8:11] dispSCAD;       // SCAD Dispatch
   wire [ 0:11] dispDIAG = 0;   // Diagnostic Dispatch

   //
   // DEBUG
   //

   wire [ 0: 3] debugADDR;      // DEBUG Address
   wire [ 0:35] debugDATA;      // DEBUG Data

   //
   // Timing
   //

   wire         clkenDP;        // Clock Enable for Datapaths
   wire         clkenCR;        // Clock Enable for Control ROM

   //
   // Timing and Wait States
   //

   TIMING uTIMING (
      .clk              (clkT),
      .rst              (rst),
      .crom             (crom),
      .feSIGN           (feSIGN),
      .busWAIT          (memWAIT | ioWAIT),
      .clkenDP          (clkenDP),
      .clkenCR          (clkenCR)
   );

   //
   // Arithmetic Logic Unit
   //

   ALU uALU (
      .clk              (clkT),
      .rst              (rst),
      .clken            (clkenDP),
      .crom             (crom),
      .aluIN            (dbus),
      .aluFLAGS         (aluFLAGS),
      .aluOUT           (dp),
      .debugADDR        (debugADDR),
      .debugDATA        (debugDATA)
   );

   //
   // APR
   //

   APR uAPR (
      .clk              (clkT),
      .rst              (rst),
      .clken            (clkenDP),
      .crom             (crom),
      .dp               (dp),
      .nxmINTR          (nxmINTR),
      .cslINTR          (cslINTRI),
      .aprFLAGS         (aprFLAGS),
      .aprINTR          (aprINTR)
   );

   //
   // Byte Dispatch
   //

   DISP_BYTE uDISP_BYTE (
      .dp               (dp),
      .dispBYTE         (dispBYTE)
   );

   //
   // Next Instruction Dispatch
   //

   DISP_NI uDISP_NI (
      .clk              (clkT),
      .rst              (rst),
      .clken            (clkenDP),
      .crom             (crom),
      .aprFLAGS         (aprFLAGS),
      .pcFLAGS          (pcFLAGS),
      .cslTRAPEN        (cslTRAPEN),
      .cpuRUN           (cpuRUN),
      .memory_cycle     (memory_cycle),
      .dispNI           (dispNI),
      .trapCYCLE        (trapCYCLE)
   );

   //
   // Page Fail Dispatch
   //

   DISP_PF uDISP_PF (
      .clk              (clkT),
      .rst              (rst),
      .clken            (clkenDP),
      .crom             (crom),
      .drom             (drom),
      .dp               (dp),
      .vmaREG           (vmaREG),
      .aprFLAGS         (aprFLAGS),
      .pageFLAGS        (pageFLAGS),
      .piINTR           (piINTR),
      .nxmINTR          (nxmINTR),
      .timerINTR        (timerINTR),
      .pageFAIL         (pageFAIL),
      .dispPF           (dispPF)
   );

   //
   // Memory/IO Bus
   //

   BUS uBUS (
      .clk              (clkT),
      .rst              (rst),
      .dp               (dp),
      .crom             (crom),
      .vmaREG           (vmaREG),
      .pageADDR         (pageADDR),
      .aprFLAGS         (aprFLAGS),
      .piCURPRI         (piCURPRI),
      .cpuDATAO         (cpuDATAO),
      .cpuADDRO         (cpuADDRO),
      .cpuREQO          (cpuREQO)
   );

   //
   // Data Bus
   //

   DBM uDBM (
      .crom             (crom),
      .dp               (dp),
      .scad             (scad),
      .dispPF           (dispPF),
      .aprFLAGS         (aprFLAGS),
      .timerCOUNT       (timerCOUNT),
      .vmaREG           (vmaREG),
      .cpuDATAI         (cpuDATAI),
      .dbm              (dbm)
   );

   //
   // DEBUG
   //

   DEBUG uDEBUG (
      .clk              (clkT),
      .rst              (rst),
      .clken            (clkenDP),
      .crom             (crom),
      .debugDATA        (debugDATA),
      .debugADDR        (debugADDR)
   );

   //
   // DBUS MUX
   //

   DBUS uDBUS (
      .crom             (crom),
      .cacheHIT         (cacheHIT),
      .piREQPRI         (piREQPRI),
      .vmaREG           (vmaREG),
      .pcFLAGS          (pcFLAGS),
      .dp               (dp),
      .ramfile          (ramfile),
      .dbm              (dbm),
      .dbus             (dbus)
   );

   //
   // Dispatch ROM
   //

   DROM uDROM (
      .clk              (clkT),
      .rst              (rst),
      .clken            (clkenDP),
      .dbus             (dbus),
      .crom             (crom),
      .drom             (drom)
   );

   //
   // INTF
   //  Console Interface
   //

   INTF uINTF (
      .clk              (clkT),
      .rst              (rst),
      .clken            (clkenDP),
      .crom             (crom),
      .cslSET           (cslSET),
      .cslRUN           (cslRUN),
      .cslCONT          (cslCONT),
      .cslEXEC          (cslEXEC),
      .cpuRUN           (cpuRUN),
      .cpuCONT          (cpuCONT),
      .cpuEXEC          (cpuEXEC),
      .cpuHALT          (cpuHALT)
   );

   //
   // Priority Interrupt Controller
   //

   PI uPI (
      .clk              (clkT),
      .rst              (rst),
      .clken            (clkenDP),
      .crom             (crom),
      .dp               (dp),
      .aprINTR          (aprINTR),
      .ubaINTR          (ubaINTR),
      .piREQPRI         (piREQPRI),
      .piCURPRI         (piCURPRI),
      .piINTR           (piINTR)
   );

   //
   // Instruction Register
   //

   REGIR uIR (
      .clk              (clkT),
      .rst              (rst),
      .clken            (clkenDP),
      .crom             (crom),
      .dbus             (dbus),
      .prevEN           (prevEN),
      .regIR            (regIR),
      .xrPREV           (xrPREV),
      .opJRST0          (opJRST0)
   );

   //
   // Microsequencer
   //

   USEQ uUSEQ (
      .clk              (clkT),
      .rst              (cslRESET),
      .clken            (clkenCR),
      .dp               (dp),
      .pageFAIL         (pageFAIL),
      .piINTR           (piINTR),
      .cpuEXEC          (cpuEXEC),
      .cpuCONT          (cpuCONT),
      .ioBUSY           (ioBUSY),
      .timerINTR        (timerINTR),
      .trapCYCLE        (trapCYCLE),
      .scSIGN           (scSIGN),
      .aluFLAGS         (aluFLAGS),
      .opJRST0          (opJRST0),
      .skipJFCL         (skipJFCL),
      .dispDIAG         (dispDIAG),
      .dispPF           (dispPF),
      .dispNI           (dispNI),
      .dispBYTE         (dispBYTE),
      .dispSCAD         (dispSCAD),
      .regIR            (regIR),
      .pcFLAGS          (pcFLAGS),
      .drom             (drom),
      .crom             (crom)
   );

   //
   // Non-existant Device
   //

   NXD uNXD (
      .clk              (clkT),
      .rst              (rst),
      .crom             (crom),
      .cpuADDRO         (cpuADDRO),
      .cpuREQO          (cpuREQO),
      .cpuACKI          (cpuACKI),
      .ioWAIT           (ioWAIT),
      .ioBUSY           (ioBUSY)
   );

   //
   // Non-existant Memory
   //

   NXM uNXM (
      .clk              (clkT),
      .rst              (rst),
      .cpuADDRO         (cpuADDRO),
      .cpuREQO          (cpuREQO),
      .cpuACKI          (cpuACKI),
      .memWAIT          (memWAIT),
      .nxmINTR          (nxmINTR)
   );

   //
   // Pager
   //

   PAGER uPAGER (
      .clk              (clkT),
      .rst              (rst),
      .clken            (clkenDP),
      .crom             (crom),
      .drom             (drom),
      .dp               (dp),
      .vmaREG           (vmaREG),
      .pageFLAGS        (pageFLAGS),
      .pageADDR         (pageADDR)
   );

   //
   // PC Flags
   //

   PCFLAGS uPCFLAGS (
      .clk              (clkT),
      .rst              (rst),
      .clken            (clkenDP),
      .crom             (crom),
      .dp               (dp),
      .scad             (scad),
      .regIR            (regIR),
      .aluFLAGS         (aluFLAGS),
      .pcFLAGS          (pcFLAGS),
      .skipJFCL         (skipJFCL)
   );

   //
   // PXCT
   //  Previous context

   PXCT uPXCT (
      .clk              (clkT),
      .rst              (rst),
      .clken            (clkenDP),
      .crom             (crom),
      .dp               (dp),
      .prevEN           (prevEN),
      .acBLOCK          (acBLOCK)
   );

   //
   // RAMFILE
   //

   RAMFILE uRAMFILE (
      .clk              (clkR),
      .rst              (rst),
      .clken            (1'b1),
      .crom             (crom),
      .drom             (drom),
      .dbus             (dbus),
      .regIR            (regIR),
      .xrPREV           (xrPREV),
      .vmaREG           (vmaREG),
      .acBLOCK          (acBLOCK),
      .ramfile          (ramfile)
   );

   //
   // SCAD
   //

   SCAD uSCAD (
      .clk              (clkT),
      .rst              (rst),
      .clken            (clkenDP),
      .crom             (crom),
      .dp               (dp),
      .scSIGN           (scSIGN),
      .feSIGN           (feSIGN),
      .scad             (scad),
      .dispSCAD         (dispSCAD)
   );

   //
   // One millisecond (more or less) interval timer.
   //

   TIMER uTIMER (
      .clk              (clkT),
      .rst              (rst),
      .clken            (clkenDP),
      .crom             (crom),
      .timerEN          (cslTIMEREN),
      .timerINTR        (timerINTR),
      .timerCOUNT       (timerCOUNT)
   );

   //
   // VMA
   //

   VMA uVMA (
      .clk              (clkT),
      .rst              (rst),
      .clken            (clkenDP),
      .crom             (crom),
      .drom             (drom),
      .dp               (dp),
      .cpuEXEC          (cpuEXEC),
      .prevEN           (prevEN),
      .pcFLAGS          (pcFLAGS),
      .pageFAIL         (pageFAIL),
      .vmaREG           (vmaREG)
   );

   //
   //  KS10 Interrupt to Console
   //

   assign cslINTRO = `flagCSL(aprFLAGS);

endmodule
