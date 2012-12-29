////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KS10 CPU
//
// Details
//
// Todo
//
// File
//   cpu.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
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

`default_nettype none
`include "useq/crom.vh"
`include "useq/drom.vh"

module CPU(clk, rst,
           cslSTEP, cslRUN, cslEXEC, cslCONT, cslHALT, cslTIMEREN, cslTRAPEN, cslCACHEEN,
           ks10INTR, cslINTR, busINTR,
           busREQ, busACK, busDATAI, busDATAO, busADDRO,
           cpuHALT);

   parameter cromWidth = `CROM_WIDTH;
   parameter dromWidth = `DROM_WIDTH;

   input          clk;          // Clock
   input          rst;          // Reset
   input          cslSTEP;      // Single Step
   input          cslRUN;       // Run
   input          cslEXEC;      // Execute
   input          cslCONT;      // Continue
   input          cslHALT;      // HALT
   input          cslTIMEREN;   // Timer Enable
   input          cslTRAPEN;    // Enable Traps
   input          cslCACHEEN;   // Enable Cache
   input          ks10INTR;     // Console Interrupt to KS10
   output         cslINTR;      // KS10 Interrupt to Console
   input  [ 1: 7] busINTR;      // Unibus Interrupt Request
   output         busREQ;       // Bus Request
   input          busACK;       // Bus Acknowledge
   input  [ 0:35] busDATAI;     // Bus Data Input
   output [ 0:35] busDATAO;     // Bus Data Output
   output [ 0:35] busADDRO;     // Bus Addr and Flags
   output         cpuHALT;      // Run/Halt Status

   //
   // ROMS
   //

   wire [0:cromWidth-1] crom;                           // Control ROM
   wire [0:dromWidth-1] drom;                           // Dispatch ROM

   //
   // Processor State
   //

   wire cpuRUN;                                         // Run Switch Active
   wire cpuCONT;                                        // Continue Switch Active
   wire cpuEXEC;                                        // Execute Switch Active

   //
   // Flags
   //

   wire memory_cycle = 1'b0;                            // FIXME
   wire iolatch;                                        // FIXME
   wire opJRST0;                                        // JRST 0 Instruction
   wire skipJFCL;                                       // JFCL Instruction
   wire trapCYCLE;                                      // Trap Cycle

   //
   // Interrupts
   //

   wire cpuINTR;                                        // Extenal Interrupt
   wire nxmINTR;                                        // Non-existent memory interrupt
   wire [ 0: 2] reqINTP;                                // Requested Interrupt Priority
   wire [ 0: 2] curINTP;                                // Current Interrupt Priority
   wire [ 1: 7] aprINTR;                                // APR Interrupt Request

   //
   // PXCT
   //

   wire         prevEN;                                 // Conditionally use Previous Context
   wire [ 0: 5] acBLOCK;                                // AC Block
   wire [ 0: 2] currBLOCK = acBLOCK[0:2];               //  Current AC Block
   wire [ 0: 2] prevBLOCK = acBLOCK[3:5];               //  Previous AC Block

   //
   // ALU
   //

   wire [ 0: 8] aluFLAGS;                               // ALU Flags
   wire         aluQR37        = aluFLAGS[0];           //  ALU Q Register LSB
   wire         aluLZERO       = aluFLAGS[1];           //  ALU left-half is zero
   wire         aluRZERO       = aluFLAGS[2];           //  ALU right-half is zero
   wire         aluLSIGN       = aluFLAGS[3];           //  ALU left-half sign
   wire         aluRSIGN       = aluFLAGS[4];           //  ALU right-half sign
   wire         aluAOV         = aluFLAGS[5];           //  ALU arithmetic overflow
   wire         aluCRY0        = aluFLAGS[6];           //  ALU carry into bit 0
   wire         aluCRY1        = aluFLAGS[7];           //  ALU carry into bit 1
   wire         aluCRY2        = aluFLAGS[8];           //  ALU carry into bit 2

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
   wire         flag24         = aprFLAGS[24];          //  Flag 24
   wire         flagCSL        = aprFLAGS[25];          //  KS10 Interrupt to Console
   wire         flagPWR        = aprFLAGS[26];          //  Power fail
   wire         flagNXM        = aprFLAGS[27];          //  Non existent memory
   wire         flagBADDATA    = aprFLAGS[28];          //  Bad memory data (not implemented)
   wire         flagCORDATA    = aprFLAGS[29];          //  Corrected memory data (not implemented)
   wire         flag30         = aprFLAGS[30];          //  Flag 30
   wire         flag31         = aprFLAGS[31];          //  Console Interrupt to KS10
   wire         flagINTREQ     = aprFLAGS[32];          //  Interrupt Request
   assign       cslINTR        = flagCSL;               //  KS10 Interrupt to Console

   //
   // VMA Registers
   //

   wire [14:35] vmaADDR;                                // VMA Address
   wire [ 0:13] vmaFLAGS;                               // VMA Flags
   wire         vmaUSER        = vmaFLAGS[ 0];          //  1 = User Mode
   wire         vmaEXEC        = vmaFLAGS[ 1];          //  1 = Exec Mode
   wire         vmaFETCH       = vmaFLAGS[ 2];          //  1 = Instruction fetch
   wire         vmaREADCYCLE   = vmaFLAGS[ 3];          //  1 = Read Cycle (IO or Memory)
   wire         vmaWRTESTCYCLE = vmaFLAGS[ 4];          //  1 = Perform write test for page fail
   wire         vmaWRITECYCLE  = vmaFLAGS[ 5];          //  1 = Write Cycle (IO or Memory)
   wire         vmaUNUSED      = vmaFLAGS[ 6];          //  Spare/Unused bit
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

   wire         timerINTR;                              // Timer Interrupt
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

   wire [ 8:11] dispNI;                                 // Next Instruction Dispatch
   wire [ 8:11] dispPF;                                 // Page Fail Dispatch
   wire [ 8:11] dispBYTE;                               // Byte Dispatch
   wire [ 8:11] dispSCAD;                               // SCAD Dispatch
   wire [ 0:11] dispDIAG = 12'b0;                       // Diagnostic Dispatch

   //
   // DEBUG
   //

   wire [0: 3]  debugADDR;                              // DEBUG Address
   wire [0:35]  debugDATA;                              // DEBUG Data

   //
   // Timing
   //

   wire clkenDP;                                        // Clock Enable for Datapaths
   wire clkenCR;                                        // Clock Enable for Control ROM
   wire memWAIT;                                        // Wait for memory

   //
   // Timing and Wait States
   //

   TIMING uTIMING
     (.clk              (clk),
      .rst              (rst),
      .crom             (crom),
      .feSIGN           (feSIGN),
      .clkenDP          (clkenDP),
      .clkenCR          (clkenCR),
      .memWAIT          (memWAIT)
      );

   //
   // Arithmetic Logic Unit
   //

   ALU uALU
     (.clk              (clk),
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

   APR uAPR
     (.clk              (clk),
      .rst              (rst),
      .clken            (clkenDP),
      .crom             (crom),
      .dp               (dp),
      .nxmINTR          (nxmINTR),
      .ks10INTR         (ks10INTR),
      .aprFLAGS         (aprFLAGS),
      .aprINTR          (aprINTR)
      );

   //
   // Byte Dispatch
   //

   BYTE_DISP uBYTE_DISP
     (.dp               (dp),
      .dispBYTE         (dispBYTE)
      );

   //
   // Memory/IO Bus
   //

   BUS uBUS
     (.clk              (clk),
      .rst              (rst),
      .clken            (clkenDP),
      .crom             (crom),
      .dp               (dp),
      .vmaEXTENDED      (vmaEXTENDED),
      .vmaFLAGS         (vmaFLAGS),
      .vmaADDR          (vmaADDR),
      .pageADDR         (pageADDR),
      .aprFLAGS         (aprFLAGS),
      .busDATAO         (busDATAO),
      .busADDRO         (busADDRO),
      .busREQ           (busREQ),
      .busACK           (busACK),
      .curINTP          (curINTP),
      .memWAIT          (memWAIT),
      .nxmINTR          (nxmINTR)
      );

   //
   // Data Bus
   //

   DBM uDBM
     (.crom             (crom),
      .dp               (dp),
      .scad             (scad),
      .dispPF           (dispPF),
      .aprFLAGS         (aprFLAGS),
      .timerCOUNT       (timerCOUNT),
      .vmaFLAGS         (vmaFLAGS),
      .vmaADDR          (vmaADDR),
      .busDATAI         (busDATAI),
      .dbm              (dbm)
      );

   //
   // DEBUG
   //

   DEBUG uDEBUG
      (.clk             (clk),
       .rst             (rst),
       .clken           (clkenDP),
       .crom            (crom),
       .debugDATA       (debugDATA),
       .debugADDR       (debugADDR)
       );

   //
   // DBUS MUX
   //

   DBUS uDBUS
     (.crom             (crom),
      .cacheHIT         (cacheHIT),
      .reqINTP          (reqINTP),
      .vmaFLAGS         (vmaFLAGS),
      .vmaADDR          (vmaADDR),
      .pcFLAGS          (pcFLAGS),
      .dp               (dp),
      .ramfile          (ramfile),
      .dbm              (dbm),
      .dbus             (dbus)
      );

   //
   // Dispatch ROM
   //

   DROM uDROM
     (.clk              (clk),
      .rst              (rst),
      .clken            (clkenDP),
      .dbus             (dbus),
      .crom             (crom),
      .drom             (drom)
      );

   //
   // Interrupt Controller
   //

   INTR uINTR
     (.clk              (clk),
      .rst              (rst),
      .clken            (clkenDP),
      .crom             (crom),
      .dp               (dp),
      .flagINTREQ       (flagINTREQ),
      .aprINTR          (aprINTR),
      .busINTR          (busINTR),
      .reqINTP          (reqINTP),
      .curINTP          (curINTP),
      .cpuINTR          (cpuINTR)
      );

   //
   // INTF
   //  Console Interface
   //

   INTF uINTF
     (.clk              (clk),
      .rst              (rst),
      .clken            (clkenDP),
      .crom             (crom),
      .cslRUN           (cslRUN),
      .cslCONT          (cslCONT),
      .cslEXEC          (cslEXEC),
      .cslHALT          (cslHALT),
      .cpuRUN           (cpuRUN),
      .cpuCONT          (cpuCONT),
      .cpuEXEC          (cpuEXEC),
      .cpuHALT          (cpuHALT)
      );

   //
   // IO Latch
   //

   IOLATCH uIOLATCH
     (.clk              (clk),
      .rst              (rst),
      .clken            (clkenDP),
      .crom             (crom),
      .iolatch          (iolatch)
      );

   //
   // Instruction Register
   //

   regIR uIR
     (.clk              (clk),
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

   USEQ uUSEQ
     (.clk              (clk),
      .rst              (rst),
      .clken            (clkenCR),
      .dp               (dp),
      .pageFAIL         (pageFAIL),
      .cpuINTR          (cpuINTR),
      .cpuEXEC          (cpuEXEC),
      .cpuCONT          (cpuCONT),
      .iolatch          (iolatch),
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
   // Next Instruction Dispatch
   //

   NI_DISP uNI_DISP
     (.aprFLAGS         (aprFLAGS),
      .pcFLAGS          (pcFLAGS),
      .cslTRAPEN        (cslTRAPEN),
      .cpuRUN           (cpuRUN),
      .memory_cycle     (memory_cycle),
      .dispNI           (dispNI)
      );

   //
   // Page Tables
   //

   PAGER uPAGER
     (.clk              (clk),
      .rst              (rst),
      .clken            (clkenDP),
      .crom             (crom),
      .drom             (drom),
      .dp               (dp),
      .vmaADDR          (vmaADDR),
      .vmaFLAGS         (vmaFLAGS),
      .pageFLAGS        (pageFLAGS),
      .pageADDR         (pageADDR)
      );

   //
   // PC Flags
   //

   PCFLAGS uPCFLAGS
     (.clk              (clk),
      .rst              (rst),
      .clken            (clkenDP),
      .crom             (crom),
      .dp               (dp),
      .scad             (scad),
      .regIR            (regIR),
      .aluAOV           (aluAOV),
      .aluCRY0          (aluCRY0),
      .aluCRY1          (aluCRY1),
      .pcFLAGS          (pcFLAGS),
      .skipJFCL         (skipJFCL)
      );

   //
   // Page Fail Dispatch
   //

   PF_DISP uPF_DISP
     (.clk              (clk),
      .rst              (rst),
      .clken            (clkenDP),
      .crom             (crom),
      .drom             (drom),
      .vmaFLAGS         (vmaFLAGS),
      .vmaADDR          (vmaADDR),
      .aprFLAGS         (aprFLAGS),
      .pageFLAGS        (pageFLAGS),
      .cpuINTR          (cpuINTR),
      .nxmINTR          (nxmINTR),
      .timerINTR        (timerINTR),
      .dispPF           (dispPF)
      );

   //
   // PXCT
   //  Previous context

   PXCT uPXCT
     (.clk              (clk),
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

   RAMFILE uRAMFILE
     (.clk              (clk),
      .rst              (rst),
      .clken            (1'b1),
      .crom             (crom),
      .drom             (drom),
      .dbus             (dbus),
      .regIR            (regIR),
      .xrPREV           (xrPREV),
      .vmaFLAGS         (vmaFLAGS),
      .vmaADDR          (vmaADDR),
      .acBLOCK          (acBLOCK),
      .ramfile          (ramfile)
      );

   //
   // SCAD
   //

   SCAD uSCAD
     (.clk              (clk),
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

   TIMER uTIMER
     (.clk              (clk),
      .rst              (rst),
      .clken            (clkenDP),
      .crom             (crom),
      .timerEN          (cslTIMEREN),
      .timerINTR        (timerINTR),
      .timerCOUNT       (timerCOUNT)
      );

   //
   // Traps
   //

   TRAPS uTRAPS
     (.clk              (clk),
      .rst              (rst),
      .clken            (clkenDP),
      .crom             (crom),
      .pcFLAGS          (pcFLAGS),
      .aprFLAGS         (aprFLAGS),
      .cslTRAPEN        (cslTRAPEN),
      .trapCYCLE        (trapCYCLE)
      );

   //
   // VMA
   //

   VMA uVMA
     (.clk              (clk),
      .rst              (rst),
      .clken            (clkenDP),
      .crom             (crom),
      .drom             (drom),
      .dp               (dp),
      .cpuEXEC          (cpuEXEC),
      .prevEN           (prevEN),
      .pcFLAGS          (pcFLAGS),
      .vmaEXTENDED      (vmaEXTENDED),
      .vmaFLAGS         (vmaFLAGS),
      .vmaADDR          (vmaADDR)
      );

endmodule
