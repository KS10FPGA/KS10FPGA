////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Page Fail / Interrupt Dispatch
//
// Details
//   This logic generates a PAGE-FAIL dispatch into the microcode.  Actually
//   PAGE-FAIL is a misnomer because the PAGE-FAIL dispatch also handles
//   External Interrupts, Timer Interrupts, NXM Interrupts, Uncorrectable
//   Memory (BAD DATA) Interrupts (not implemented) and Page Failures.
//
//   The microcode has the following dispatches defined:
//
//     DISP PRI Description
//     0001     Timer or External Interrupt
//     0011     Bad Data (Not implemented)
//     0101     NXM (Non-existant Memory)
//     0111     NXM and Bad Data (Not implemented)
//     1000  2  Write Violation (Not writeable on write test)
//     1001     Timer and Page Fail
//     1010  0  Page not valid
//     1011  1  Exec/User Mismatch
//
//   The pageFAIL signal must be asserted on the cycle before the memory access.
//   This will vector the microcode to Page Fail handler (location 3777
//   PAGE-FAIL:) during the memory cycle.
//
//   The PAGE-FAIL dispatch operates as follows:
//
//   1.  This module creates the pageFAIL signal coincident with Memory Reads
//       and Memory Write, and Memory Write Test bus cycles.  This will be
//       explained below.
//   2.  The Microsequencer dispatches to address 7777 (or 3777) which is hard
//       coded into the microsequencer address logic.
//   3.  The Microsequencer also stores the address of the Read or Write Test
//       microcode operations.
//   4.  The PAGE-FAIL code runs.  The microcode will handle the various causes
//       of the dispatch.
//   5.  Eventually the microcode returns and re-executes the instruction that
//       caused the page fail dispatch.
//
//   As explained above, when a operation causes a page failure, the KS10 CPU
//   executes the Page Fill microcode and then re-executes the instruction
//   that caused the Page Failure.
//
//   The operation servicing an interrupt is similar.   The KS10 saves the
//   state of the processor, services the interrupt, and re-executes the
//   interruptedinstruction
//
//   The dispatch is via "DP LEFT".  The dispatch into the CROM Address is never
//   used.   See microcode DISP/PAGE FAIL=63).  It looks like the traces are
//   deleted from the board.
//
//   The the Page Fail dispatch is actually a combination of a Dispatch and a
//   Skip operating simulataneously.
//
// FIXME
//   This needs a lot of work.
//
// File
//   disp_pf.v
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

`include "apr.vh"
`include "vma.vh"
`include "pager.vh"
`include "useq/crom.vh"
`include "useq/drom.vh"

module DISP_PF(clk, rst, clken, crom, drom, dp, vmaREG, aprFLAGS, pageFLAGS,
               piINTR, nxmINTR, timerINTR, pageFAIL, dispPF);

   parameter cromWidth = `CROM_WIDTH;
   parameter dromWidth = `DROM_WIDTH;

   input                   clk;                 // Clock
   input                   rst;                 // Reset
   input                   clken;               // Clock Enable
   input  [ 0:cromWidth-1] crom;                // Control ROM Data
   input  [ 0:dromWidth-1] drom;                // Dispatch ROM Data
   input  [ 0:35]          dp;                  // Datapath
   input  [ 0:35]          vmaREG;              // Virtual Memory Register
   input  [22:35]          aprFLAGS;            // APR Flags
   input  [ 0: 3]          pageFLAGS;           // Page Flags
   input                   timerINTR;           // Timer Interrupt
   input                   piINTR;              // CPU Interrupt
   input                   nxmINTR;             // NXM Interrupt
   output                  pageFAIL;            // Page Fail
   output [ 0: 3]          dispPF;              // Page Fail Dispatch

   //
   // Microcode decode
   //
   // Trace
   //  DPMA/E2
   //  DPMA/E8
   //  DPE5/E1
   //

   wire specMEMCLR = `cromSPEC_EN_20 & (`cromSPEC_SEL == `cromSPEC_SEL_MEMCLR );

   wire pfEN       = ((`cromMEM_CYCLE & `cromMEM_FETCHCYCLE & `cromMEM_WAIT & `cromMEM_READCYCLE) |
                      (`cromMEM_CYCLE & `cromMEM_FETCHCYCLE & `cromMEM_WAIT & `cromMEM_READCYCLE) |
                      (`cromMEM_CYCLE & `cromMEM_FETCHCYCLE & `cromMEM_WAIT & `cromMEM_READCYCLE));

   wire fetchCYCLE = `cromMEM_CYCLE & `cromMEM_FETCHCYCLE & `cromMEM_WAIT & `cromMEM_READCYCLE;

   //
   // VMA Interface
   //

   wire vmaACREF      = 0;
   wire vmaPHYS       = 0;
   wire vmaUSER       = 0;
   wire vmaWRTEST     = 0;

   //
   // Pager/PC Flags Interface
   //

   wire pageUSER      = 0;
   wire pageENABLE    = 0;
   wire pagePRESENT   = 0;
   wire pageWRITEABLE = 0;

   //
   // Dispatch values
   //

   localparam [0:3] dispNONE       = 4'o00,     // Nothing active
                    dispINTR       = 4'o01,     // PI/Timer interrupt
                    dispBADDATA    = 4'o03,     // Bad data (not implemented)
                    dispNXM        = 4'o05,     // NXM
                    dispNXMBADDATA = 4'o07,     // NXM and bad data (not implemented)
                    dispWRITEFAIL  = 4'o10,     // Page not writeable
                    dispASDF       = 4'o11,     // Timer and movsrj
                    dispNOTPRESENT = 4'o12,     // Page not present
                    dispMISMATCH   = 4'o13;     // EXEC/USER Mismatch

   //
   //
   //

   reg intrEN;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          intrEN <= 0;
        else
          intrEN <= fetchCYCLE;
     end

   //
   //
   //

   reg pageFAIL;
   reg [0:3] dispatch;

   always @*
     begin
        pageFAIL <= 0;
        dispatch <= dispNONE;
        if (intrEN & nxmINTR)
          begin
             pageFAIL <= 1;
             dispatch <= dispNXM;
          end
        else if (intrEN & (piINTR | timerINTR))
          begin
             pageFAIL <= 1;
             dispatch <= dispINTR;
          end
        else if (pfEN & pageENABLE & !vmaPHYS & !vmaACREF & !pagePRESENT)
          begin
             pageFAIL <= 1;
             dispatch <= dispNOTPRESENT;
          end
        else if (pfEN & pageENABLE & !vmaPHYS & !vmaACREF & (vmaUSER != pageUSER))
          begin
             pageFAIL <= 1;
             dispatch <= dispMISMATCH;
          end
        else if (pfEN & pageENABLE & !vmaPHYS & !vmaACREF & vmaWRTEST & !pageWRITEABLE)
          begin
             pageFAIL <= 1;
             dispatch <= dispWRITEFAIL;
          end
     end

   //
   // Page fail dispatch register
   //

   reg [0:3] dispPF;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          dispPF <= 0;
        else if (clken)
          begin
             if (pageFAIL)
               dispPF <= dispatch;
             else if (specMEMCLR)
               dispPF <= 0;
          end
     end

endmodule
