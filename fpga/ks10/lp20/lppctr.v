////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   LP20 Page Count Register (PCTR)
//
// Details
//   This file provides the implementation of the LP20 PCTR Register.
//
// File
//   lppctr.v
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

`include "lppctr.vh"

module LPPCTR (
      input  wire        clk,           // Clock
      input  wire        rst,           // Reset
      input  wire [35:0] lpDATAI,       // Bus data in
      input  wire        csrbWRITE,     // Write to CSRB
      input  wire        pctrWRITE,     // Write to PCTR
      input  wire        lpINIT,        // Initialize
      input  wire        lpTESTPCTR,    // Test PCTR
      input  wire        lpTOF,         // Top of form (Decrement PCTR)
      output wire        lpSETPCZ,      // Page counter is zero
      output wire [15:0] regPCTR        // PCTR output
   );

   //
   // Decrement page counter
   //
   // Trace
   //  M8587/LPD4/E35
   //  M8587/LPD4/E41
   //  M8587/LPD4/E52
   //

   reg lpDECPCTR;
   always @*
     begin
        if (lpTESTPCTR)
          lpDECPCTR <= csrbWRITE & lpDATAI[0];
        else
          lpDECPCTR <= lpTOF;
     end

   //
   // Edge detect decrements
   //
   //   The magic page decrement test above may decrement multiple times depending
   //   on the REQ/ACK timing of the csrbWRITE.

   reg lastDECR;
   always @(posedge clk)
     begin
        if (rst)
          lastDECR <= 0;
        else
          lastDECR <= lpDECPCTR;
     end

   //
   // Page Count Register
   //
   // In Page Counter Test Mode, writing to the LSB of the CSRB will increment
   // the Page Counter.
   //
   // Trace
   //  M8597/LPD4/E22
   //  M8597/LPD4/E30
   //  M8597/LPD4/E35
   //  M8597/LPD4/E38
   //  M8597/LPD4/E41
   //

   reg [11:0] lpPGCNT;
   always @(posedge clk)
     begin
        if (rst | lpINIT)
          lpPGCNT <= 0;
        else if (pctrWRITE)
          lpPGCNT <= `lpPCTR_DAT(lpDATAI);
        else if (lpDECPCTR & !lastDECR)
          lpPGCNT <= lpPGCNT - 1'b1;
     end

   //
   // Page counter is zero
   //
   // Trace
   //  M8597/LPD4/E38
   //  M8586/LPC9/E58
   //  M8586/LPC9/E33
   //

   assign lpSETPCZ = (lpPGCNT == 1) & lpDECPCTR;

   //
   // Build PCTR Register
   //

   assign regPCTR = {4'b0, lpPGCNT};

endmodule
