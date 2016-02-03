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
// Copyright (C) 2012-2016 Rob Doyle
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
`timescale 1ns/1ps

`include "useq/crom.vh"
`include "useq/drom.vh"
`include "apr.vh"

module CPU (
      input  wire         rst,          // Reset
      input  wire         clk,          // Clock
      input  wire         memCLK,       // Memory Clock
      input  wire [ 1: 4] clkPHS,       // Clock Phase
      // Breakpoint
      input  wire         debugHALT,    // Breakpoint
      // Console
      input  wire         cslSET,       // Set Console RUN, EXEC, CONT
      input  wire         cslRUN,       // Run
      input  wire         cslCONT,      // Continue
      input  wire         cslEXEC,      // Execute
      input  wire         cslTIMEREN,   // Timer Enable
      input  wire         cslTRAPEN,    // Enable Traps
      input  wire         cslCACHEEN,   // Enable Cache
      input  wire         cslINTRI,     // Console Interrupt to CPU
      output wire         cslINTRO,     // CPU Interrupt to Console
      // UBA
      input  wire [ 1: 7] ubaINTR,      // Unibus Interrupt Request
      // CPU
      output wire         cpuREQO,      // CPU Bus Request
      input  wire         cpuACKI,      // Bus Acknowledge
      output wire [ 0:35] cpuADDRO,     // CPU Addr and Flags
      input  wire [ 0:35] cpuDATAI,     // Bus Data Input
      output wire [ 0:35] cpuDATAO,     // CPU Data Output
      output wire         cpuHALT,      // CPU Halt Status
      output wire         cpuRUN,       // CPU Run Status
      output wire         cpuEXEC,      // CPU Exec Status
      output wire         cpuCONT,      // CPU Cont Status
      // Trace
      output wire [18:35] cpuPC,        // Program Counter Register
      output wire [ 0:35] cpuHR,        // Instruction Register
      output wire         regsLOAD,     // Register update
      output wire         vmaLOAD       // VMA update
   );

   //
   // ROMS
   //

   wire [0:107] crom;           // Control ROM
   wire [0: 35] drom;           // Dispatch ROM

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
   // Timing
   //

   wire         clkenDP;        // Clock Enable for Datapaths
   wire         clkenCR;        // Clock Enable for Control ROM

   //
   // Timing and Wait States
   //

   TIMING uTIMING (
      .clk              (clk),
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
      .clk              (clk),
      .rst              (rst),
      .clken            (clkenDP),
      .crom             (crom),
      .aluIN            (dbus),
      .aluFLAGS         (aluFLAGS),
      .aluOUT           (dp),
      .aluPC            (cpuPC),
      .aluHR            (cpuHR)
   );

   //
   // APR
   //

   APR uAPR (
      .clk              (clk),
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
      .clk              (clk),
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
      .clk              (clk),
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
      .clk              (clk),
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
      .rst              (rst),
      .memCLK           (memCLK),
      .clkPHS           (clkPHS),
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
   // DBUS MUX
   //

   DBUS uDBUS (
      .crom             (crom),
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
      .clk              (clk),
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
      .clk              (clk),
      .rst              (rst),
      .clken            (clkenDP),
      .crom             (crom),
      .debugHALT        (debugHALT),
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
      .clk              (clk),
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
      .clk              (clk),
      .rst              (rst),
      .clken            (clkenDP),
      .crom             (crom),
      .dbus             (dbus),
      .prevEN           (prevEN),
      .regIR            (regIR),
      .xrPREV           (xrPREV),
      .opJRST0          (opJRST0),
      .regsLOAD         (regsLOAD)
   );

   //
   // Microsequencer
   //

   USEQ uUSEQ (
      .clk              (clk),
      .rst              (rst),
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
      .clk              (clk),
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
      .clk              (clk),
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
      .clk              (clk),
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
      .clk              (clk),
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
      .clk              (clk),
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
      .clk              (clk),
      .rst              (rst),
      .clken            (1'b1),
      .crom             (crom),
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
      .clk              (clk),
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
      .clk              (clk),
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
      .clk              (clk),
      .rst              (rst),
      .clken            (clkenDP),
      .crom             (crom),
      .drom             (drom),
      .dp               (dp),
      .cpuEXEC          (cpuEXEC),
      .prevEN           (prevEN),
      .pcFLAGS          (pcFLAGS),
      .pageFAIL         (pageFAIL),
      .vmaREG           (vmaREG),
      .vmaLOAD          (vmaLOAD)
   );

   //
   //  KS10 Interrupt to Console
   //

   assign cslINTRO = `flagCSL(aprFLAGS);

endmodule
