////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      Page Fail Dispatch
//!
//! \details
//!      See comments in microcode at PAGE-FAIL entry point.
//!
//!      The dispatch is via "DP LEFT".  The dispatch into the CROM
//!      Address (see DISP/PAGE FAIL=63) is never used.  It looks
//!      like the traces are delete from the board.
//!
//!      The microcode has the following dispatches defined:
//!
//!        0001: Interrupt
//!        0011: Bad Data (Not implemented)
//!        0101: NXM (Non-existant Memory)
//!        0111: NXM and Bad Data (Not implemented)
//!        1000: Write Violation
//!        1010: Page not valid
//!        1011: Exec/User Mismatch
//!
//!     The description in the Technical Manual is incorrect wrt
//!     the LSB.
//!
//! \note
//!
//! \file
//!      pf_disp.v
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
// details.S
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

module PF_DISP(clk, rst, clken, crom, drom, vmaFLAGS, vmaADDR,
               aprFLAGS, pageFLAGS, cpuINTR, nxmINTR, timerINTR,
               dispPF);

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

   wire flagPAGEEN     = aprFLAGS[23];	// Paging is enabled

   //
   // vmaFLAGS
   //

   wire vmaUSER        = vmaFLAGS[0];   // VMA User
   wire vmaWRTESTCYCLE = vmaFLAGS[4];   // Write Test Cycle
   wire vmaWRITECYCLE  = vmaFLAGS[5];   // Write Cycle
   wire vmaPHYSICAL    = vmaFLAGS[8];   // VMA Physical

   //
   // Page Flags
   //

   wire pageVALID      = pageFLAGS[0];  // Page is valid
   wire pageWRITEABLE  = pageFLAGS[1];  // Page is writeable
   wire pageUSER       = pageFLAGS[3];  // Page is user mode

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

   //
   // Memory Cycles
   //
   // Trace
   //  DPM5/E110
   //

   wire memEN          = ((`cromMEM_CYCLE & `cromMEM_LOADVMA           ) |
                          (`cromMEM_CYCLE & `cromMEM_AREAD   & `dromVMA));

   wire memWAIT        = specMEMCLR | specMEMWAIT | memEN;

   //
   // Latch Interrupt Sources during memory cycle
   //
   // Details:
   //
   // Trace:
   //  DPM6/E16
   //

   reg intTIM;
   reg intCPU;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
            `ifdef INITREGS
               intCPU <= 1'b0;
               intTIM <= 1'b0;
            `else
               intCPU <= 1'bx;
               intTIM <= 1'bx;
            `endif
          end
        else if (clken & memWAIT)
          begin
             intCPU <= cpuINTR;
             intTIM <= timerINTR;
          end
     end

   //
   // FIXME

   wire startCYCLE  = 1'b0;

   //
   // Memory Cycle
   //

   reg memCYCLE;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          memCYCLE <= 1'b0;
        else if (clken & memWAIT)
          memCYCLE <= startCYCLE;
     end

   //
   // Page Logic
   //
   // Trace:
   //  DPM6/E9
   //  DPM6/E15
   //  DPM6/E17
   //

   wire INT_OR_ERR = ((intCPU & memCYCLE & ~(vmaPHYSICAL | vmaWRITECYCLE))  |
                      (intTIM & memCYCLE & ~(vmaPHYSICAL | vmaWRITECYCLE)));

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

   wire pagingOK = flagPAGEEN & ~vmaACREF & ~vmaPHYSICAL & ~INT_OR_ERR;

   //
   // Page Fail Dispatch
   //
   // Details:
   //  This logic generates
   //
   // Note:
   //  The two msbs of the priority encoder are inverted.
   //  The lsb is not.  The output of the priority encoder is "111"
   //  when not enabled.  This translates to "001" when the inverters
   //  are added.
   //
   //  Notice also the nxmINTR generates a dispatch but disables the
   //  priority encoder - so the two kinds of dispatches (interrupts
   //  and paging errors) are independant.
   //
   // Trace:
   //  DPM6/E41
   //  DPM6/E47
   //  DPM6/E115
   //  DPM6/E124
   //
   
   reg [ 0: 3] dispPF;
   always @(nxmINTR or pagingOK or pageVALID or pageUSER or
            vmaWRTESTCYCLE or vmaUSER or pageWRITEABLE)
     begin
        if (nxmINTR)
          dispPF = 4'b0101;
        else if (pagingOK)
          begin
             if (~pageVALID)
               dispPF = 4'b1010;
             else if (pageUSER != vmaUSER)
               dispPF = 4'b1011;
             else if (vmaWRTESTCYCLE & ~pageWRITEABLE)
               dispPF = 4'b1000;
             else
               dispPF = 4'b0001;
          end
        else
          dispPF = 3'b0001;
     end

endmodule
