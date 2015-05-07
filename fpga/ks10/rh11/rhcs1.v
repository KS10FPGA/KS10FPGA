////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RH11 Control and Status Register 1 (RHCS1)
//
// File
//   rhcs1.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2015 Rob Doyle
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

`include "rhcs1.vh"

module RHCS1(clk, rst,
             devRESET, devLOBYTE, devHIBYTE, devDATAI, rhcs1WRITE, rhCLRGO, rhCLRTRE,
             rhDLT, rhWCE, rhUPE, rhNED, rhNEM, rhPGE, rhMXF, rhDPE, rhCLR, rhIACK,
             rpATA, rpERR, rpDVA, rpFUN, rpGO, rhBA, rhCS1);

   input          clk;                          // Clock
   input          rst;                          // Reset
   input          devRESET;                     // Device reset from UBA
   input          devLOBYTE;                    // Device low byte
   input          devHIBYTE;                    // Device high byte
   input  [ 0:35] devDATAI;                     // Device data in
   input          rhcs1WRITE;                   // CS1 write
   input          rhCLRGO;                      // Go clear
   input          rhCLRTRE;                     // Transfer error clear
   input          rhDLT;                        // Data late error       (RHCS2[DLT])
   input          rhWCE;                        // Write check error     (RHCS2[WCE])
   input          rhUPE;                        // Unibus parity error   (RHCS2[UPE])
   input          rhNED;                        // Non-existent drive    (RHCS2[NED])
   input          rhNEM;                        // Non-existent memory   (RHCS2[NEM])
   input          rhPGE;                        // Program Error         (RHCS2[PGE])
   input          rhMXF;                        // Missed Transfer Error (RHCS2[MXF])
   input          rhDPE;                        // Data Parity Error     (RHCS2[DPE])
   input          rhCLR;                        // Controller Clear      (RHCS2[CLR])
   input          rhIACK;                       // Interrupt acknowledge
   input          rpATA;                        // RPxx Attention
   input          rpERR;                        // RPxx Composite error  (RPDS [ERR])
   input          rpDVA;                        // RPxx Drive available  (RPCS1[DVA])
   input  [ 5: 1] rpFUN;                        // RPxx Function         (RPCA1[FUN])
   input          rpGO;                         // RPxx Go               (RPCS1[GO ])
   input  [17:16] rhBA;                         // rhBA address extension
   output [15: 0] rhCS1;                        // rhCS1 output

   //
   // Big-endian to little-endian data bus swap
   //

   wire [35:0] rhDATAI = devDATAI[0:35];

   //
   // Transfer Error (TRE)
   //
   // This is used to detect transitions of the signals that create TRE.
   //
   // Trace
   //  M7296/CSRB/E3
   //  M7296/CSRB/E20
   //  M7296/CSRB/E22
   //

   wire statTRE = rhDLT | rhWCE | rhUPE | rhNED | rhNEM | rhPGE | rhMXF | rhDPE | rpERR;

   reg lastTRE;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          lastTRE <= 0;
        else
          lastTRE <= statTRE;
     end

   //
   // CS1 Special Conditions (SC)
   //
   // Trace
   //  M7296/CSRB/E2
   //  M7296/CSRB/E20
   //

   wire cs1SC = cs1TRE | cs1CPE | rpATA;

   //
   // CS1 Transfer Error (TRE)
   //
   // Note:
   //  Transfer error is asserted on the *transition* of the status signals.
   //  Cleared by Error Clear
   //
   // Trace
   //  M7296/CSRB/E2
   //  M7296/CSRB/E3
   //  M7296/CSRB/E5
   //  M7296/CSRB/E11
   //  M7296/CSRB/E20
   //  M7296/CSRB/E22
   //

   reg cs1TRE;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          cs1TRE <= 0;
        else
          begin
             if (devRESET | rhCLR | rhCLRTRE | rhCLRGO)
               cs1TRE <= 0;
             else if (statTRE & !lastTRE)
               cs1TRE <= 1;
          end
     end

   //
   // CS1 Massbus Control Parity Error (CPE)
   //
   // Trace
   //  M7296/PACA/E5
   //  M7296/PACA/E7
   //  M7296/PACA/E10
   //

   wire cs1CPE = 0;

   //
   // CS1 Port Select (PSEL)
   //
   // Trace
   //  M7296/CSRA/E11
   //  M7296/CSRA/E12
   //

   reg cs1PSEL;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          cs1PSEL <= 0;
        else
          if (devRESET | rhCLR)
            cs1PSEL <= 0;
          else if (rhcs1WRITE & devHIBYTE & cs1RDY)
            cs1PSEL <= `rhCS1_PSEL(rhDATAI);
     end

   //
   // CS1 Ready (RDY)
   //
   // Trace
   //  M7296/CSRA/E3
   //

   wire cs1RDY = !rpGO;

   //
   // CS1 Interrupt Enable (IE)
   //
   // Trace
   //  M7296/CSRA/E10
   //  M7296/CSRA/E18
   //  M7296/CSRA/E20
   //

   reg cs1IE;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          cs1IE <= 0;
        else
          if (devRESET | rhCLR | rhIACK)
            cs1IE <= 0;
          else if (rhcs1WRITE & devLOBYTE)
            cs1IE <= `rhCS1_IE(rhDATAI);
     end

   //
   // CS1 Function (FUN)
   //
   // From Massbus
   //
   // Trace
   //  R11-0-01/MBSA/
   //

   wire [5:1] cs1FUN = rpFUN;

   //
   // CS1 GO
   //
   // From Massbus
   //
   // Trace
   //  R11-0-01/MBSA/
   //

   wire cs1GO = rpGO;

   //
   // Build CS1 Register
   //
   // Trace
   //  M7294/DBCJ/E30 (00:03)
   //  M7294/DBCJ/E32 (04:07)
   //  M7295/BCTJ/E60 (08:11)
   //  M7295/BCTJ/E59 (12:15)
   //

   wire [15:0] rhCS1 = {cs1SC, cs1TRE, cs1CPE, 1'b0, rpDVA, cs1PSEL,
                        rhBA[17:16], cs1RDY, cs1IE, cs1FUN, cs1GO};

endmodule
