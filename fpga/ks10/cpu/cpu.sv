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
//   cpu.sv
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2021 Rob Doyle
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
      input  wire          rst,         // Reset
      input  wire          clk,         // Clock
      input  wire  [ 1: 4] clkT,        // Clock
      ks10bus.device       cpuBUS,      // KS10 backplane bus
      // Breakpoint
      input  wire          brHALT,      // Breakpoint
      // Console
      input  wire          cslRUN,      // Run
      input  wire          cslHALT,     // Halt
      input  wire          cslCONT,     // Continue
      input  wire          cslEXEC,     // Execute
      input  wire          cslTIMEREN,  // Timer Enable
      input  wire          cslTRAPEN,   // Enable Traps
      input  wire          cslCACHEEN,  // Enable Cache
      input  wire          cslINTRI,    // Console Interrupt to CPU
      output logic         cslINTRO,    // CPU Interrupt to Console
      output logic [ 0:35] cpuADDRO,    // CPU Addr and Flags
      output logic         cpuHALT,     // CPU Halt Status
      output logic         cpuRUN,      // CPU Run Status
      output logic         cpuEXEC,     // CPU Exec Status
      output logic         cpuCONT,     // CPU Cont Status
      // Trace
      output logic [18:35] cpuPC,       // Program Counter Register
      output logic [ 0:35] cpuHR,       // Instruction Register
      output logic         regsLOAD,    // Register update
      output logic         vmaLOAD      // VMA update
   );

   //
   // ROMS
   //

   logic [0:107] crom;          // Control ROM
   logic [0: 35] drom;          // Dispatch ROM

   //
   // Flags
   //

   wire  memory_cycle = 0;      // FIXME
   logic nxmINTR;               // Non-existent memory interrupt
   logic memWAIT;               // Wait for memory
   logic ioWAIT;                // Wait for memory
   logic ioBUSY;                // IO is busy
   logic opJRST0;               // JRST 0 Instruction
   logic skipJFCL;              // JFCL Instruction
   logic trapCYCLE;             // Trap Cycle

   //
   // Prioity Interrupts
   //

   logic piINTR;                // Priority Interrupt
   logic [ 0: 2] piCURPRI;      // Current Interrupt Priority
   logic [ 0: 2] piREQPRI;      // Requested Interrupt Priority

   //
   // PXCT
   //

   logic         prevEN;        // Conditionally use Previous Context
   logic [ 0: 5] acBLOCK;       // AC Block

   //
   // ALU Flags
   //

   logic [ 0: 8] aluFLAGS;      // ALU Flags

   //
   // PC Flags
   //

   logic [ 0:17] pcFLAGS;       // PC Flags

   //
   // APR Flags
   //

   logic [22:35] aprFLAGS;      // APR Flags
   logic [ 1: 7] aprINTR;       // APR Interrupt Request

   //
   // VMA Register
   //

   logic [ 0:35] vmaREG;        // VMA Register

   //
   // Paging
   //

   logic         pageFAIL;      // Page Fail
   logic [16:26] pageADDR;      // Page Address
   logic [ 0: 3] pageFLAGS;     // Page Flags

   //
   // Timer
   //

   logic         timerINTR;     // Timer Interrupt
   logic [18:35] timerCOUNT;    // Millisecond timer

   //
   // Instruction Register IR
   //

   logic [ 0:17] regIR;         // Instruction Register (IR)
   logic         xrPREV;        // XR is previous

   //
   // Internal Buses
   //

   logic [ 0:35] dp;            // ALU output bus
   logic [ 0:35] dbus;          // DBUS Mux output
   logic [ 0:35] dbm;           // DBM Mux output
   logic [ 0:35] ramfile;       // RAMFILE output

   //
   // SCAD, SC, and FE
   //

   logic [ 0: 9] scad;          // Step count adder
   logic         scSIGN;        // Step Count Sign
   logic         feSIGN;        // Floating-point exponent Sign

   //
   // Dispatches
   //

   logic [ 8:11] dispNI;        // Next Instruction Dispatch
   logic [ 8:11] dispPF;        // Page Fail Dispatch
   logic [ 8:11] dispBYTE;      // Byte Dispatch
   logic [ 8:11] dispSCAD;      // SCAD Dispatch
   wire  [ 0:11] dispDIAG = 0;  // Diagnostic Dispatch

   //
   // Timing
   //

   logic         clkenDP;       // Clock Enable for Datapaths
   logic         clkenCR;       // Clock Enable for Control ROM

   //
   // Optional DPBUS Latch
   //

   reg [0:35] dpreg;

`define LATCH_DPBUS
`ifdef LATCH_DPBUS

   always_latch
     if (clkT[1])
       begin
          dpreg <= dp;
       end

`else

   always_comb
     begin
        dpreg <= dp;
     end

`endif

   //
   // Timing and Wait States
   //

   TIMING uTIMING (
      .clk              (clkT[1]),
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
      .clk              (clkT[1]),
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
      .clk              (clkT[1]),
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
      .clk              (clkT[1]),
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
      .clk              (clkT[1]),
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
      .clk              (clkT[1]),
      .rst              (rst),
      .dp               (dp),
      .crom             (crom),
      .vmaREG           (vmaREG),
      .pageADDR         (pageADDR),
      .aprFLAGS         (aprFLAGS),
      .piCURPRI         (piCURPRI),
      .cpuDATAO         (cpuBUS.busDATAO),
      .cpuADDRO         (cpuBUS.busADDRO),
      .cpuREQO          (cpuBUS.busREQO)
   );

   //
   // Data Bus
   //

   DBM uDBM (
      .rst              (rst),
      .clk              (clkT[4]),
      .crom             (crom),
      .dp               (dp),
      .scad             (scad),
      .dispPF           (dispPF),
      .aprFLAGS         (aprFLAGS),
      .timerCOUNT       (timerCOUNT),
      .vmaREG           (vmaREG),
      .cpuDATAI         (cpuBUS.busDATAI),
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
      .dp               (dpreg),
      .ramfile          (ramfile),
      .dbm              (dbm),
      .dbus             (dbus)
   );

   //
   // Dispatch ROM
   //

   DROM uDROM (
      .clk              (clkT[1]),
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
      .clk              (clkT[1]),
      .rst              (rst),
      .clken            (clkenDP),
      .crom             (crom),
      .brHALT           (brHALT),
      .cslRUN           (cslRUN),
      .cslHALT          (cslHALT),
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
      .clk              (clkT[1]),
      .rst              (rst),
      .clken            (clkenDP),
      .crom             (crom),
      .dp               (dp),
      .aprINTR          (aprINTR),
      .ubaINTR          (cpuBUS.busINTRI),
      .piREQPRI         (piREQPRI),
      .piCURPRI         (piCURPRI),
      .piINTR           (piINTR)
   );

   //
   // Instruction Register
   //

   REGIR uIR (
      .clk              (clkT[1]),
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
      .clk              (clkT[1]),
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
      .clk              (clkT[1]),
      .rst              (rst),
      .crom             (crom),
      .cpuADDRO         (cpuBUS.busADDRO),
      .cpuREQO          (cpuBUS.busREQO),
      .cpuACKI          (cpuBUS.busACKI),
      .ioWAIT           (ioWAIT),
      .ioBUSY           (ioBUSY)
   );

   //
   // Non-existant Memory
   //

   NXM uNXM (
      .clk              (clkT[1]),
      .rst              (rst),
      .cpuADDRO         (cpuBUS.busADDRO),
      .cpuREQO          (cpuBUS.busREQO),
      .cpuACKI          (cpuBUS.busACKI),
      .memWAIT          (memWAIT),
      .nxmINTR          (nxmINTR)
   );

   //
   // Pager
   //

   PAGER uPAGER (
      .clk              (clkT[1]),
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
      .clk              (clkT[1]),
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
      .clk              (clkT[1]),
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
      .clk              (clkT[2]),
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
      .clk              (clkT[1]),
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
      .clk              (clkT[1]),
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
      .clk              (clkT[1]),
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

   //
   // KS10 backplane bus connections
   //

   assign cpuBUS.busACKO  = 0;
   assign cpuBUS.busINTRO = 0;
   assign cpuADDRO = cpuBUS.busADDRO;   // For breakpoints

endmodule
