////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   LP20 Control and Status Register A (CSRA)
//
// Details
//   This file provides the implementation of the LP20 CSRA Register.
//
// File
//   lpcsra.v
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

module LPCSRA (
      input  wire        clk,           // Clock
      input  wire        rst,           // Reset
      input  wire        devRESET,      // Device Reset from UBA
      input  wire        devLOBYTE,     // Device Low Byte
      input  wire        devHIBYTE,     // Device High Byte
      input  wire        bctrWRITE,     // Byte counter write
      input  wire        pctrWRITE,     // Page counter write
      input  wire        csraWRITE,     // Write to CSRA
      input  wire [35:0] lpDATAI,       // Device Data In
      input  wire        lpONLINE,      // On line
      input  wire        lpGO,          // Go
      input  wire        lpLPE,         // Line printer parity error
      input  wire        lpVFURDY,      // Vertical format unit ready
      input  wire        lpCMDGO,       // Go command
      input  wire        lpSETUNDC,     // Set undefined character
      input  wire        lpSETMPE,      // Memory parity error
      input  wire        lpSETRPE,      // RAM parity error
      input  wire        lpSETMSYN,     // IO bus timeout error
      input  wire        lpSETDHLD,     // Set delimiter hold
      input  wire        lpCLRDHLD,     // Clear delimiter hold
      input  wire        lpSETDTE,      // Set demand timeout error
      input  wire        lpSETGOE,      // Set go Error
      input  wire        lpSETPCZ,      // Set page counter is zero
      input  wire        lpSETDONE,     // Set DMA done
      output wire        lpSETIRQ,      // Interrupt request
      input  wire [17:0] regBAR,        // Bus address register
      output wire [15:0] regCSRA        // CSRA Output
   );

   //
   // CSRA Initialize (INIT)
   //
   // This is a little different than the LP20.  The lpINIT is output from this
   // register but it cannot be read by the KS10 because it is only asserted
   // during the write operation. It looks like it is write only.
   //
   // Trace
   //  M8586/LPC8/E7
   //  M8586/LPC8/E8
   //  M8586/LPC8/E24
   //  M8586/LPC8/E36
   //

   wire lpINIT = devRESET | (csraWRITE & devHIBYTE & `lpCSRA_INIT(lpDATAI));

   //
   // CSRA Error Clear (ECLR)
   //
   // This is a little different than the LP20.  The lpECLR is an output from
   // this register but it cannot be read by the KS10 because it is only
   // asserted during the write operation.
   //
   // Trace
   //  M8586/LPC7/E36
   //  M8586/LPC7/E37
   //  M8586/LPC7/E42
   //

   wire lpECLR = lpINIT | (csraWRITE & devHIBYTE & `lpCSRA_ECLR(lpDATAI));

   //
   // On-line Error
   //
   // Watch for transitions of printer status
   //
   // Trace
   //  M8586/LPC7/E71
   //

   reg lastONLINE;
   always @(posedge clk)
     begin
        if (rst)
          lastONLINE <= 0;
        else
          lastONLINE <= lpONLINE;
     end

   //
   // DAVFU Error
   //
   // Watch for transitions of the DAVFU
   //
   // Trace
   //  M8586/LPC7/E70
   //

   reg lastVFURDY;
   always @(posedge clk)
     begin
        if (rst)
          lastVFURDY <= 0;
        else
          lastVFURDY <= lpVFURDY;
     end

   //
   // Line printer parity error
   //
   // Watch for transitions of the LPE
   //
   // Trace
   //  M8586/LPC7/E66
   //

   reg lastLPE;
   always @(posedge clk)
     begin
        if (rst)
          lastLPE <= 0;
        else
          lastLPE <= lpLPE;
     end

   //
   // lpSETERR
   //
   // Trace
   //  M8587/LPC7/E31
   //  M8587/LPCS/E42
   //

   wire lpSETERR = lpSETMPE | lpSETRPE | lpSETMSYN | lpSETDTE | (!lpONLINE & lastONLINE) | (!lpVFURDY & lastVFURDY) | (lpLPE & !lastLPE) | lpSETGOE;

   //
   // CSRA Composite Error (ERR)
   //
   // Trace
   //  M8586/LPC7/E42
   //  M8586/LPC7/E59
   //  M8586/LPC7/E61
   //
   //

   reg lpERR;
   always @(posedge clk)
     begin
        if (rst | lpECLR)
          lpERR <= 0;
        else if (lpSETERR)
          lpERR <= 1;
     end

   //
   // CSRA Page Count Zero (PCZ)
   //
   // Trace
   //  M8586/LPC9/E58
   //  M8586/LPC9/E33
   //  M8586/LPC9/E58
   //  M8597/LPD4/E38
   //

   reg lpPCZ;
   always @(posedge clk)
     begin
        if (rst | lpINIT | pctrWRITE)
          lpPCZ <= 0;
        else if (lpSETPCZ)
          lpPCZ <= 1;
     end

   //
   // CSRA Undefined Characters (UNDC)
   //
   // Trace
   //  M8587/LPD6/E63
   //

   reg lpUNDC;
   always @(posedge clk)
     begin
        if (rst | lpCMDGO)
          lpUNDC <= 0;
        else if (lpSETUNDC)
          lpUNDC <= 1;
     end

   //
   // CSRA Delimiter Hold (DHLD)
   //
   // Trace
   //  M8587/LPD5/E52
   //  M8587/LPD5/E53
   //  M8587/LPD5/E56
   //  M8587/LPD5/E57
   //

   reg lpDHLD;
   always @(posedge clk)
     begin
        if (rst | lpINIT | lpCLRDHLD)
          lpDHLD <= 0;
        else if (lpSETDHLD)
          lpDHLD <= 1;
        else if (csraWRITE & devHIBYTE)
          lpDHLD <= `lpCSRA_DHLD(lpDATAI);
     end

   //
   // CSRA Done (DONE)
   //
   // Trace
   //  M8585/LPC9/E35
   //  M8585/LPC9/E40
   //  M8585/LPC9/E65
   //

   reg lpDONE;
   always @(posedge clk)
     begin
        if (rst | bctrWRITE)
          lpDONE <= 0;
        else if (lpINIT | lpSETDONE)
          lpDONE <= 1;
     end

   //
   // CSRA Interrupt Enable (IE)
   //
   // Trace
   //  M8586/LPC6/E40
   //

   reg lpIE;
   always @(posedge clk)
     begin
        if (rst | lpINIT)
          lpIE <= 0;
        else if (csraWRITE & devLOBYTE)
          lpIE <= `lpCSRA_IE(lpDATAI);
     end

   //
   // CSRA Mode (MODE)
   //
   // Trace
   //  M8586/LPC6/E43
   //  M8586/LPC6/E50
   //

   reg [1:0] lpMODE;
   always @(posedge clk)
     begin
        if (rst | lpINIT)
          lpMODE <= 0;
        else if (csraWRITE & devLOBYTE)
          lpMODE <= `lpCSRA_MODE(lpDATAI);
     end

   //
   // CSRA Parity Enable (PAR)
   //
   // Trace
   //  M8586/LPC6/E50
   //

   reg lpPAR;
   always @(posedge clk)
     begin
        if (rst | lpINIT)
          lpPAR <= 0;
        else if (csraWRITE & devLOBYTE)
          lpPAR <= `lpCSRA_PAR(lpDATAI);
     end

   //
   // Build CSRA
   //

   assign regCSRA = {lpERR, lpPCZ, lpUNDC, lpVFURDY, lpONLINE, lpDHLD, lpECLR, lpINIT,
                     lpDONE, lpIE, regBAR[17:16], lpMODE[1:0], lpPAR, lpGO};

   //
   // Interrupt Request
   //
   // Trace
   //  M8586/LPC4/E65
   //  M8586/LPC4/E74
   //  M8586/LPC4/E75
   //

   assign lpSETIRQ = lpSETERR | lpSETPCZ | lpSETUNDC | lpSETDONE | (lpVFURDY != lastVFURDY) | (lpONLINE != lastONLINE);

endmodule
