////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   LP20 Control and Status Register A (CSRA)
//
// Details
//   The module implements the LP20 CSRA Register.
//
// File
//   lpcsra.v
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

`include "lpcsra.vh"

module LPCSRA (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire         devRESET,             // Device Reset from UBA
      input  wire         devLOBYTE,            // Device Low Byte
      input  wire         devHIBYTE,            // Device High Byte
      input  wire [35: 0] lpDATAI,              // Device Data In
      input  wire         csraWRITE,            // Write to CSRA
      input  wire         lpPCZ,                // Page count zero
      input  wire         lpUNDC,               // Undefined character
      input  wire         lpDVON,               // DAVFU ready
      input  wire         lpONLINE,             // On line
      input  wire         lpDONE,               // Done
      input  wire         lpGO,                 // Go
      input  wire         lpLPE,                // Line printer parity error
      input  wire         lpMPE,                // Memory parity error
      input  wire         lpRPE,                // RAM parity error
      input  wire         lpMTE,                // Unibus timeout error
      input  wire         lpDTE,                // Demand timeout error
      input  wire         lpGOE,                // Go Error
      input  wire         lpSETDHLD,            // Set delimiter hold
      output wire         lpCMDGO,              // Go command
      input  wire [17: 0] regBAR,               // Bus address register
      output wire [15: 0] regCSRA               // CSRA Output
   );

   //
   // CSRA Initialize (INIT)
   //
   // This is a little different than the LP20.  The lpINIT is output from this
   // register but it cannot be read by the KS10 because it is only asserted
   // during the write operation
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
   // This is a little different than the LP20.  The lpECLR is output from this
   // register but it cannot be read by the KS10 because it is only asserted
   // during the write operation
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
   // This is asserted when the printer transtions of off-line
   //
   // Trace
   //  M8586/LPC7/E71
   //

   reg lastONLINE;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          lastONLINE <= 0;
        else
          lastONLINE <= lpONLINE;
     end

   wire errONLINE = !lpONLINE & lastONLINE;

   //
   // DAVFU Error
   //
   // This is asserted when the DAVFU transitions to not ready
   //
   // Trace
   //  M8586/LPC7/E70
   //

   reg lastDAVFU;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          lastDAVFU <= 0;
        else
          lastDAVFU <= lpDVON;
     end

   wire errDAVFU = !lpDVON & lastDAVFU;

   //
   // CSRA Error (ERR)
   //
   // Trace
   //  M8586/LPC7/E42
   //  M8586/LPC7/E59
   //  M8586/LPC7/E61
   //
   //

   reg lpERR;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          lpERR <= 0;
        else
          begin
             if (lpMPE | lpRPE | lpMTE | lpDTE | errONLINE | errDAVFU | lpLPE | lpGOE)
               lpERR <= 1;
             else if (lpECLR)
               lpERR <= 0;
          end
     end

   //
   // CSRA Delimiter Hold (DHLD)
   //

   reg lpDHLD;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          lpDHLD <= 0;
        else
          begin
             if (lpINIT)
               lpDHLD <= 0;
             else if (lpSETDHLD)
               lpDHLD <= 1;
             else if (csraWRITE & devHIBYTE)
               lpDHLD <= `lpCSRA_DHLD(lpDATAI);
          end
     end

   //
   // CSRA Interrupt Enable (IE)
   //
   // Trace
   //  M8586/LPC6/E40
   //

   reg lpIE;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          lpIE <= 0;
        else
          begin
             if (lpINIT)
               lpIE <= 0;
             else if (csraWRITE & devLOBYTE)
               lpIE <= `lpCSRA_IE(lpDATAI);
          end
     end

   //
   // CSRA Mode (MODE)
   //
   // Trace
   //  M8586/LPC6/E43
   //  M8586/LPC6/E50
   //

   reg [1:0] lpMODE;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          lpMODE <= 0;
        else
          begin
             if (lpINIT)
               lpMODE <= 0;
             else if (csraWRITE & devLOBYTE)
               lpMODE <= `lpCSRA_MODE(lpDATAI);
          end
     end

   //
   // CSRA Parity Enable (PAR)
   //
   // Trace
   //  M8586/LPC6/E50
   //

   reg lpPAR;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          lpPAR <= 0;
        else
          begin
             if (lpINIT)
               lpPAR <= 0;
             else if (csraWRITE & devLOBYTE)
               lpPAR <= `lpCSRA_PAR(lpDATAI);
          end
     end

   //
   // Build CSRA
   //

   assign regCSRA = {lpERR, lpPCZ, lpUNDC, lpDVON, lpONLINE, lpDHLD, lpECLR, lpINIT,
                     lpDONE, lpIE, regBAR[17:16], lpMODE, lpPAR, lpGO};

   //
   // CSRA Command GO
   //

   assign lpCMDGO = csraWRITE & devLOBYTE & `lpCSRA_GO(lpDATAI);

endmodule
