///////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   LP20 Control and Status Register B (CSRB) implementation.
//
// Details
//   This file provides the implementation of the LP20 CSRB Register.
//
// File
//   lpcsrb.v
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

`include "lpcsra.vh"
`include "lpcsrb.vh"

module LPCSRB (
      input  wire         clk,          // Clock
      input  wire         rst,          // Reset
      input  wire         devRESET,     // Device Reset from UBA
      input  wire         devLOBYTE,    // Device Low Byte
      input  wire         devHIBYTE,    // Device High Byte
      input  wire         csrbWRITE,    // Write to CSRA
      input  wire [35: 0] lpDATAI,      // Bus Data In
      input  wire         lpINIT,       // Initialize
      input  wire         lpECLR,       // Error clear
      input  wire         lpOVFU,       // Optical vertical format unit
      input  wire         lpVFURDY,     // DAVFU ready
      input  wire         lpVAL,        // Printer valid data
      input  wire         lpLPE,        // Line printer parity error
      input  wire         lpDPAR,       // Line printer data parity
      input  wire         lpONLINE,     // Online
      input  wire         lpSETMPE,     // Memory parity error
      input  wire         lpSETRPE,     // RAM parity error
      input  wire         lpSETMSYN,    // IO bus time-out error
      input  wire         lpSETGOE,     // Go error
      input  wire         lpSETDTE,     // Set demand timeout error
      output wire [15: 0] regCSRB       // CSRA Output
   );

   //
   // Printer not ready (NRDY)
   //  Not implemented
   //

   wire lpNRDY = 0;

   //
   // Printer Data Parity (DPAR)
   //

   //
   // Optical Vertical Format Unit (OVFU)
   //  This is a configuration option governed by the LPCCR
   //

   //
   // CSRB TEST (TEST)
   //
   // Trace
   //  M8586/LPC6/E32
   //  M8586/LPC6/E34
   //  M8586/LPC6/E38
   //

   reg [2:0] lpTEST;
   always @(posedge clk)
     begin
        if (rst | lpINIT)
          lpTEST <= 0;
        else if (csrbWRITE & devHIBYTE)
          lpTEST <= `lpCSRB_TEST(lpDATAI);
     end

   //
   // DAVFU Error (VFUE)
   //
   // Trace
   //  M8587/LPD6/E11
   //  M8587/LPD6/E50
   //  M8587/LPD6/E66
   //  M8587/LPD6/E74
   //

   wire lpVFUE = !lpVFURDY;

   //
   // Memory Parity Error
   //
   // Trace
   //  M8586/LPC7/E64
   //

   reg lpMPE;
   always @(posedge clk)
     begin
        if (rst | lpINIT)
          lpMPE <= 0;
        else if (lpSETMPE)
          lpMPE <= 1;
     end

   //
   // RAM Parity Error
   //
   // Trace
   //  M8586/LPC7/E59
   //

   reg lpRPE;
   always @(posedge clk)
     begin
        if (rst | lpINIT)
          lpRPE <= 0;
        else if (lpSETRPE)
          lpRPE <= 1;
     end

   //
   // IO Bus Timeout Error
   //
   // Trace
   //  M8586/LPC3/E55
   //  M8586/LPC3/E56
   //

   reg lpMSYN;
   always @(posedge clk)
     begin
        if (rst | lpECLR)
          lpMSYN <= 0;
        else if (lpSETMSYN)
          lpMSYN <= 1;
     end

   //
   // Demand Timeout Error
   //
   // Trace
   //  M8586/LPC3/E55
   //  M8586/LPC3/E55
   //

   reg lpDTE;
   always @(posedge clk)
     begin
        if (rst | lpECLR)
          lpDTE <= 0;
        else if (lpSETDTE)
          lpDTE <= 1;
     end

   //
   // GO Error
   //
   // Trace
   //  M8586/LPC7/E64
   //

   reg lpGOE;
   always @(posedge clk)
     begin
        if (rst | lpINIT)
          lpGOE <= 0;
        else if (lpSETGOE)
          lpGOE <= 1;
     end

   //
   // Build CSRB
   //

   assign regCSRB = {lpVAL, 1'b0, lpNRDY, lpDPAR, lpOVFU, lpTEST,
                     !lpONLINE, lpVFUE, lpLPE, lpMPE, lpRPE, lpMSYN, lpDTE, lpGOE};

endmodule
