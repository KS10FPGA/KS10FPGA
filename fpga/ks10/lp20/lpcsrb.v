////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   LP20 Control and Status Register B (CSRB)
//
// Details
//   The module implements the LP20 CSRB Register.
//
// File
//   lpcsrb.v
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

`include "lpcsrb.vh"

module LPCSRB (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire         devRESET,             // Device Reset from UBA
      input  wire         devLOBYTE,            // Device Low Byte
      input  wire         devHIBYTE,            // Device High Byte
      input  wire [35: 0] lpDATAI,              // Bus Data In
      input  wire         csrbWRITE,            // Write to CSRA
      input  wire         lpINIT,               // Initialize
      input  wire         lpVAL,                // Valid
      input  wire         lpLA180,              // LP180
      input  wire         lpNRDY,               // Not ready
      input  wire         lpDPAR,               // Data Parity
      input  wire         lpOVFU,               // Optical vertical format unit
      input  wire         lpOFFL,               // Offline
      input  wire         lpDVOF,               // DAVFU not ready
      input  wire         lpLPE,                // LPT parity error
      input  wire         lpSETMPE,             // MEM parity error
      input  wire         lpSETRPE,             // RAM parity error
      input  wire         lpMTE,                // Unibus time-out error
      input  wire         lpDTE,                // Demand time-out error
      input  wire         lpSETGOE,             // Go error
      output wire [15: 0] regCSRB               // CSRA Output
   );

   //
   // CSRB TEST (TEST)
   //
   // Trace
   //  M8586/LPC6/E32
   //  M8586/LPC6/E34
   //  M8586/LPC6/E38
   //

   reg [2:0] lpTEST;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          lpTEST <= 0;
        else
          begin
             if (lpINIT)
               lpTEST <= 0;
             else if (csrbWRITE & devHIBYTE)
               lpTEST <= `lpCSRB_TEST(lpDATAI);
          end
     end

   //
   // Memory Parity Error
   //
   // Trace
   //  M8586/LPC7/E64
   //

   reg lpMPE;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          lpMPE <= 0;
        else
          begin
             if (lpSETMPE)
               lpMPE <= 1;
             else if (lpINIT)
               lpMPE <= 0;
          end
     end

   //
   // RAM Parity Error
   //
   // Trace
   //  M8586/LPC7/E59
   //

   reg lpRPE;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          lpRPE <= 0;
        else
          begin
             if (lpSETRPE)
               lpRPE <= 1;
             else if (lpINIT)
               lpRPE <= 0;
          end
     end

   //
   // GO Error
   //
   // Trace
   //  M8586/LPC7/E64
   //

   reg lpGOE;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          lpGOE <= 0;
        else
          begin
             if (lpSETGOE)
               lpGOE <= 1;
             else if (lpINIT)
               lpGOE <= 0;
          end
     end

   //
   // Build CSRB
   //

   assign regCSRB = {lpVAL, 1'b0, lpNRDY, lpDPAR, lpOVFU, lpTEST,
                     lpOFFL, lpDVOF, lpLPE, lpMPE, lpRPE, lpMTE, lpDTE, lpGOE};

endmodule
