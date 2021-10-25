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

`include "rhcs1.vh"

module RHCS1 (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire         devRESET,             // Device reset from UBA
      input  wire         devLOBYTE,            // Device low byte
      input  wire         devHIBYTE,            // Device high byte
      input  wire [35: 0] rhDATAI,              // Data in
      input  wire         rhcs1WRITE,           // CS1 write
      input  wire         rhCLRGO,              // Go clear
      input  wire         rhCLRTRE,             // Transfer error clear
      input  wire         rhSETCPE,             // Massbus parity error  (RHCS1[CPE])
      input  wire         rhDLT,                // Data late error       (RHCS2[DLT])
      input  wire         rhWCE,                // Write check error     (RHCS2[WCE])
      input  wire         rhUPE,                // Unibus parity error   (RHCS2[UPE])
      input  wire         rhNED,                // Non-existent drive    (RHCS2[NED])
      input  wire         rhNEM,                // Non-existent memory   (RHCS2[NEM])
      input  wire         rhPGE,                // Program Error         (RHCS2[PGE])
      input  wire         rhMXF,                // Missed Transfer Error (RHCS2[MXF])
      input  wire         rhDPE,                // Data Parity Error     (RHCS2[DPE])
      input  wire         rhCLR,                // Controller Clear      (RHCS2[CLR])
      input  wire         rhIACK,               // Interrupt acknowledge
      input  wire         rhATA,                // RPxx Attention
      input  wire         rhDVA,                // RPxx Drive available  (RHCS1[DVA])
      input  wire         rhDRY,                // RPxx Drive Ready      (RHDS [DRY ])
      input  wire [17:16] rhBA,                 // rhBA address extension
      output reg          rhGO,                 // RHCS1[GO]
      output wire [15: 0] rhCS1                 // rhCS1 output
   );

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

   wire statTRE = rhDLT | rhWCE | rhUPE | rhNED | rhNEM | rhPGE | rhMXF | rhDPE;

   reg lastTRE;

   always @(posedge clk)
     begin
        if (rst)
          lastTRE <= 0;
        else
          lastTRE <= statTRE;
     end

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

   always @(posedge clk)
     begin
        if (rst | devRESET | rhCLR | rhCLRTRE | rhCLRGO)
          cs1TRE <= 0;
        else if (statTRE & !lastTRE)
          cs1TRE <= 1;
     end

   //
   // CS1 Massbus Control Parity Error (CPE)
   //
   // Trace
   //  M7297/PACA/E5
   //  M7297/PACA/E7
   //  M7297/PACA/E10
   //

   reg cs1CPE;

   always @(posedge clk)
     begin
        if (rst | devRESET | rhCLR)
          cs1CPE <= 0;
        else if (rhSETCPE)
          cs1CPE <= 1;
     end

   //
   // CS1 Ready (RDY)
   //
   // Trace
   //  M7296/CSRA/E3
   //

   wire cs1DRY = rhDRY;

   //
   // CS1 Port Select (PSEL)
   //
   // Trace
   //  M7296/CSRA/E11
   //  M7296/CSRA/E12
   //

   reg cs1PSEL;
   always @(posedge clk)
     begin
        if (rst | devRESET | rhCLR)
          cs1PSEL <= 0;
        else if (rhcs1WRITE & devHIBYTE & rhDRY)
          cs1PSEL <= `rhCS1_PSEL(rhDATAI);
     end

   //
   // CS1 Interrupt Enable (IE)
   //
   // Trace
   //  M7296/CSRA/E10
   //  M7296/CSRA/E18
   //  M7296/CSRA/E20
   //

   reg cs1IE;
   always @(posedge clk)
     begin
        if (rst | devRESET | rhCLR | rhIACK)
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

   reg [5:1] cs1FUN;
   always @(posedge clk)
     begin
        if (rst)
          cs1FUN <= 0;
        else if (rhcs1WRITE & devLOBYTE & rhDRY)
          cs1FUN <= `rhCS1_FUN(rhDATAI);
     end

   //
   // CS1 GO
   //

   always @(posedge clk)
     begin
        if (rst)
          rhGO <= 0;
        else
          rhGO <= rhcs1WRITE & devLOBYTE & `rhCS1_GO(rhDATAI);
     end

   // From Massbus
   //
   // Trace
   //  R11-0-01/MBSA/
   //

   wire cs1GO = !rhDRY;

   //
   // CS1 Special Conditions (SC)
   //
   // Trace
   //  M7296/CSRB/E2
   //  M7296/CSRB/E20
   //

   wire cs1SC = cs1TRE | cs1CPE | rhATA;

   //
   // Build CS1 Register
   //
   // Trace
   //  M7294/DBCJ/E30 (00:03)
   //  M7294/DBCJ/E32 (04:07)
   //  M7295/BCTJ/E60 (08:11)
   //  M7295/BCTJ/E59 (12:15)
   //

   assign rhCS1 = {cs1SC, cs1TRE, cs1CPE, 1'b0, rhDVA, cs1PSEL,
                   rhBA[17:16], cs1DRY, cs1IE, cs1FUN, cs1GO};

endmodule
