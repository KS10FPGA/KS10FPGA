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
// File
//   disp_pf.v
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

`include "apr.vh"
`include "vma.vh"
`include "pager.vh"
`include "useq/crom.vh"
`include "useq/drom.vh"

module DISP_PF (
      input  wire          clk,         // Clock
      input  wire          rst,         // Reset
      input  wire          clken,       // Clock Enable
      input  wire [ 0:107] crom,        // Control ROM Data
      input  wire [ 0: 35] drom,        // Dispatch ROM Data
      input  wire [ 0: 35] dp,          // Datapath
      input  wire [ 0: 35] vmaREG,      // Virtual Memory Register
      input  wire [22: 35] aprFLAGS,    // APR Flags
      input  wire [ 0:  3] pageFLAGS,   // Page Flags
      input  wire          timerINTR,   // Timer Interrupt
      input  wire          piINTR,      // CPU Interrupt
      input  wire          nxmINTR,     // NXM Interrupt
      output reg           pageFAIL,    // Page Fail
      output reg  [ 0:  3] dispPF       // Page Fail Dispatch
   );

   //
   // Dispatch values
   //

   localparam [0:3] dispNONE       = 4'o00,     // Nothing active
                    dispINTR       = 4'o01,     // PI/Timer interrupt
                    dispBADDATA    = 4'o03,     // Bad data (not implemented)
                    dispNXM        = 4'o05,     // NXM
                    dispNXMBADDATA = 4'o07,     // NXM and bad data (not implemented)
                    dispWRITEFAIL  = 4'o10,     // Page not writeable
                    dispTIMPAGFAIL = 4'o11,     // Timer and movsrj
                    dispINVALID    = 4'o12,     // Page not present
                    dispMISMATCH   = 4'o13;     // EXEC/USER Mismatch

   //
   // specMEMCLR microcode decode
   //   This clears the PAGE-FAIL dispatch.
   //
   // Trace
   //  DPMA/E2
   //  DPMA/E8
   //  DPE5/E1
   //

   wire specMEMCLR = `cromSPEC_EN_20 & (`cromSPEC_SEL == `cromSPEC_SEL_MEMCLR );

   //
   // pfCYCLE
   //  This is adapted from the code in vma.v except we really don't care what kind
   //  of bus cycle is being created.   pfCYCLE is asserted on the micro-instruction
   //  before the bus cycle.
   //
   // Trace
   //  DPM5/E48
   //  DPM5/E66
   //  DPM5/E33
   //  DPM5/E110
   //

   reg  pfCYCLE;
   wire memEN = ((`cromMEM_CYCLE  & `cromMEM_WAIT                   ) |
                 (`cromMEM_CYCLE  & `cromMEM_BWRITE & `dromCOND_FUNC));

   always @*
     begin
        if (memEN)
          begin
             if (`cromMEM_AREAD)
               pfCYCLE = `dromREADCYCLE | `dromWRTESTCYCLE | `dromWRITECYCLE;
             else
               begin
                  if (`cromMEM_DPFUNC)
                    pfCYCLE = `vmaREAD(dp) | `vmaWRTEST(dp) | `vmaWRITE(dp);
                  else
                    pfCYCLE = `cromMEM_READCYCLE | `cromMEM_WRTESTCYCLE | `cromMEM_WRITECYCLE;
               end
          end
        else
          pfCYCLE = 0;
     end

   //
   // Micro-instruction 0110 is the instruction fetch.
   //

   wire fetchCYCLE    = (crom[0:11] == 12'o0110);

   //
   // APR flags interface
   //

   wire pageENABLE    = `flagPAGEEN(aprFLAGS);

   //
   // VMA Interface
   //

   wire vmaACREF      = `vmaACREF(vmaREG);
   wire vmaPHYS       = `vmaPHYS(vmaREG);
   wire vmaUSER       = `vmaUSER(vmaREG);
   wire vmaWRTEST     = `vmaWRTEST(vmaREG);

   //
   // Pager Interface
   //

   wire pageUSER      = `pageUSER(pageFLAGS);
   wire pageVALID     = `pageVALID(pageFLAGS);
   wire pageWRITEABLE = `pageWRITEABLE(pageFLAGS);

   //
   // Page fail enable
   //

   reg pfEN;

   always @(posedge clk)
     begin
        if (rst)
          pfEN <= 0;
        else if (clken)
          if (!pfEN)
            pfEN <= pfCYCLE;
          else
            pfEN <= 0;
     end

   //
   // Interrupt enable
   //

   reg intrEN;

   always @(posedge clk)
     begin
        if (rst)
          intrEN <= 0;
        else if (clken)
          intrEN <= fetchCYCLE;
     end

   //
   // Page failure types
   //

   wire pageINVALID   = pageENABLE & !vmaPHYS & !vmaACREF & !pageVALID;
   wire pageMISMATCH  = pageENABLE & !vmaPHYS & !vmaACREF & (vmaUSER != pageUSER);
   wire pageWRITEFAIL = pageENABLE & !vmaPHYS & !vmaACREF & vmaWRTEST & !pageWRITEABLE;

   //
   // Page Fail Dispatch
   //

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
        else if (intrEN & piINTR)
          begin
             pageFAIL <= 1;
             dispatch <= dispINTR;
          end
        else if (intrEN & timerINTR & pageINVALID)
          begin
             pageFAIL <= 1;
             dispatch <= dispTIMPAGFAIL;
          end
        else if (intrEN & timerINTR)
          begin
             pageFAIL <= 1;
             dispatch <= dispINTR;
          end
        else if (pfEN & pageINVALID)
          begin
             pageFAIL <= 1;
             dispatch <= dispINVALID;
          end
        else if (pfEN & pageMISMATCH)
          begin
             pageFAIL <= 1;
             dispatch <= dispMISMATCH;
          end
        else if (pfEN & pageWRITEFAIL)
          begin
             pageFAIL <= 1;
             dispatch <= dispWRITEFAIL;
          end
     end

   //
   // Page fail dispatch register
   //

   always @(posedge clk)
     begin
        if (rst)
          dispPF <= 0;
        else if (clken)
          if (pageFAIL)
            dispPF <= dispatch;
          else if (specMEMCLR)
            dispPF <= 0;
     end

endmodule
