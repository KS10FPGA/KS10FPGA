////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Page Fail Dispatch
//
// Details
//   See comments in microcode at PAGE-FAIL entry point.
//
//   The dispatch is via "DP LEFT".  The dispatch into the CROM
//   Address (see DISP/PAGE FAIL=63) is never used.  It looks
//   like the traces are delete from the board.
//
//   The microcode has the following dispatches defined:
//
//        0001: Timer or External Interrupt
//        0011: Bad Data (Not implemented)
//        0101: NXM (Non-existant Memory)
//        0111: NXM and Bad Data (Not implemented)
//        1000: Write Violation
//        1010: Page not valid
//        1011: Exec/User Mismatch
//
//   The the Page Fail dispatch is actually a combination of a
//   Dispatch and a Skip operating simulataneously.
//
//
// Note
//
// File
//   pf_disp.v
//
// Author
//      Rob Doyle - doyle (at) cox (dot) net
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
// details.S
//
// You should have received a copy of the GNU Lesser General
// Public License along with this source; if not, download it
// from http://www.gnu.org/licenses/lgpl.txt
//
////////////////////////////////////////////////////////////////////

`default_nettype none
`include "apr.vh"
`include "vma.vh"
`include "pager.vh"
`include "useq/crom.vh"
`include "useq/drom.vh"

module PF_DISP(clk, rst, clken, crom, drom, vmaFLAGS, vmaADDR,
               aprFLAGS, pageFLAGS, cpuINTR, nxmINTR, timerINTR,
               pageFAIL, dispPF);

   parameter cromWidth = `CROM_WIDTH;
   parameter dromWidth = `DROM_WIDTH;

   input                   clk;         // Clock
   input                   rst;         // Reset
   input                   clken;       // Clock Enable
   input  [ 0:cromWidth-1] crom;        // Control ROM Data
   input  [ 0:dromWidth-1] drom;        // Dispatch ROM Data
   input  [ 0:13]          vmaFLAGS;    // Virtual Memory Flags
   input  [14:35]          vmaADDR;     // Virtual Memory Address
   input  [22:35]          aprFLAGS;    // APR Flags
   input  [ 0: 4]          pageFLAGS;   // Page Flags
   input                   timerINTR;   // Timer Interrupt
   input                   cpuINTR;     // CPU Interrupt
   input                   nxmINTR;     // NXM Interrupt
   output                  pageFAIL;	// Page Fail                  
   output [ 0: 3]     	   dispPF;   	// Page Fail Dispatch

   //
   // Microcode decode
   //
   // Note
   //  specMEMCLR and specMEMWAIT can be asserted simultaneously.
   //
   // Trace
   //  DPMA/E2
   //  DPMA/E8
   //

   wire specMEMCLR     = `cromSPEC_EN_20 & (`cromSPEC_SEL == `cromSPEC_SEL_MEMCLR );
   wire specMEMWAIT    = `cromSPEC_EN_10 & (`cromSPEC_SEL == `cromSPEC_SEL_MEMWAIT);

   //
   // aprFLAGS
   //

   wire flagPAGEEN     = `flagPAGEEN(aprFLAGS);		// Paging is enabled

   //
   // vmaFLAGS
   //

   wire vmaUSER        = `vmaUSER(vmaFLAGS);   		// VMA User
   wire vmaREADCYCLE   = `vmaREADCYCLE(vmaFLAGS);   	// Read Cycle (IO or Memory)
   wire vmaWRTESTCYCLE = `vmaWRTESTCYCLE(vmaFLAGS);   	// Write Test Cycle
   wire vmaWRITECYCLE  = `vmaWRITECYCLE(vmaFLAGS);   	// Write Cycle (IO or Memory)
   wire vmaPHYSICAL    = `vmaPHYSICAL(vmaFLAGS);   	// VMA Physical

   //
   // Page Flags
   //

   wire pageVALID      = `pageVALID(pageFLAGS);  	// Page is valid
   wire pageWRITEABLE  = `pageWRITEABLE(pageFLAGS);  	// Page is writeable
   wire pageUSER       = `pageUSER(pageFLAGS);  	// Page is user mode

   //
   // AC Reference
   //
   // Details
   //  True when addressing lowest 16 addresses using and not
   //  physical addressing.  References to the ACs are never
   //  physical.
   //
   // Trace
   //  DPM4/E160
   //  DPM4/E168
   //  DPM4/E191
   //

   wire vmaACREF       = ~vmaPHYSICAL & (vmaADDR[18:31] == 14'b0);
   
   wire memCYCLE       = 1;//vmaREADCYCLE | vmaWRTESTCYCLE;
   
   //
   // pagingOK
   //
   // Details:
   //  This logic enables Page Fail dispatch.  Paging is enabled when:
   //  1.  Paging is enabled
   //  2.  The reference is not to an AC.  ACs are always physical.
   //  3.  The reference it not a physical address.
   //  4.  An interrupt or error is not being handled.
   //
   // Trace:
   //  DPM6/E47
   //

   wire pagingOK = flagPAGEEN & ~vmaACREF & ~vmaPHYSICAL;

   //
   // Page Fail Dispatch
   //
   // Details:
   //  This logic generates a PAGE FAIL dispatch into the microcode.
   //  Actually PAGE FAIL is a misnomer because the PAGE FAIL
   //  dispatch also handles External Interrupts, Timer Interrupts,
   //  and NXM Interrupts, Uncorrectable Memory Interrupts, (not
   //  implemented) and Page Failures.
   //
   //  The PAGE-FAIL dispatch operates as follows:
   //  1.  This module creates the pageFAIL signal coincident with
   //      Memory Reads and Memory Write Test bus cycles.  This will
   //      be explained below.
   //  2.  The Microsequencer dispatches to address 3777 which is
   //      hard coded into the microsequencer address logic.
   //  3.  The Microsequencer also stores the address of the Read
   //      or Write Test microcode operations.
   //  4.  The PAGE-FAIL code runs.  The microcode will handle the
   //      various causes of the dispatch.
   //  5.  Eventually the microcode returns and re-executes the
   //      instruction that caused the page fail dispatch.
   //
   //  As explained above, when a operation causes a page failure,
   //  the KS10 CPU executes the Page Fill microcode and then
   //  re-executes the instruction that caused the Page Failure.
   //
   // Note:
   //  The two msbs of the priority encoder are inverted.
   //  The lsb is not.  The output of the priority encoder is "111"
   //  when not enabled.  This translates to "001" when the inverters
   //  are added.
   //
   //  Notice also the interrupts generate a dispatch but disables the
   //  priority encoder - so the two kinds of dispatches (interrupts
   //  and paging errors) are independant.
   //
   // Trace:
   //  DPM6/E41
   //  DPM6/E47
   //  DPM6/E115
   //  DPM6/E124
   //
   
   reg actPF;
   reg [0:3] dispPF;
   
   always @(memCYCLE or nxmINTR or cpuINTR or timerINTR or pagingOK or
            pageVALID or pageUSER or vmaWRTESTCYCLE or vmaUSER or
            pageWRITEABLE)
     begin
        if (memCYCLE)
          begin
             if (nxmINTR)
               begin
                  actPF  = 1;
                  dispPF = 4'b0101;
               end
             else if (cpuINTR | timerINTR)
               begin
                  actPF  = 1;
                  dispPF = 4'b0001;
               end
             else if (pagingOK)
               begin
                  if (~pageVALID)
                    begin
                       actPF  = 1;
                       dispPF = 4'b1010;
                    end
                  else if (pageUSER != vmaUSER)
                    begin
                       actPF  = 1;
                       dispPF = 4'b1011;
                    end
                  else if (vmaWRTESTCYCLE & ~pageWRITEABLE)
                    begin
                       actPF  = 1;
                       dispPF = 4'b1000;
                    end
                  else
                    begin
                       actPF  = 0;
                       dispPF = 4'b0001;
                    end
               end
             else
               begin
                  actPF  = 0;
                  dispPF = 4'b0001;
               end
          end
        else
          begin
             actPF  = 0;
             dispPF = 4'b0001;
          end
     end
        
   //
   // pageFAIL should only be asserted for a clock cycle.
   //
   
   reg lastACT;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          lastACT <= 0;
        else if (clken)
          lastACT <= actPF;
     end

   assign pageFAIL = 0;//~lastACT & actPF;
   
endmodule
