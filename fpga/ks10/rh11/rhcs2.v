////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RH11 Control and Status Register 2 (RHCS2)
//
// File
//   rhcs2.v
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

`include "rhcs1.vh"
`include "rhcs2.vh"

module RHCS2 (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire         devRESET,             // Device Reset from UBA
      input  wire         devLOBYTE,            // Device Low Byte
      input  wire         devHIBYTE,            // Device High Byte
      input  wire [ 0:35] devDATAI,             // Device Data In
      input  wire         rhcs2WRITE,           // Write to CS2
      input  wire         rhCMDGO,              // Go command
      input  wire         rhCLRGO,              // Command clear
      input  wire         rhCLRTRE,             // Transfer error clear
      input  wire         rhCLR,                // Controller clear
      input  wire         rhRDY,                // Controller ready
      input  wire         rhSETDLT,             // Set DLT
      input  wire         rhSETWCE,             // Set WCE
      input  wire         rhSETNED,             // Set NED
      input  wire         rhSETNEM,             // Set NEM
      input  wire         rhBUFIR,              // Status IR
      input  wire         rhBUFOR,              // Status OR
      output wire [15: 0] rhCS2                 // CS2 Output
   );

   //
   // Big-endian to little-endian data bus swap
   //

   wire [35:0] rhDATAI = devDATAI[0:35];

   //
   // Error Clear
   //
   // Trace
   //  M7296/CSRB/E2
   //  M7296/CSRB/E5
   //  M7296/CSRB/E11
   //

   wire errCLR = devRESET | rhCLR | rhCLRTRE | rhCLRGO;

   //
   // CS2 Device Late
   //  Not implemented.
   //
   // Trace
   //  M7294/DBCB/E61
   //  M7294/DBCB/E71
   //  M7294/DBCB/E72
   //  M7294/DBCB/E73
   //  M7294/DBCB/E79
   //  M7294/DBCB/E97
   //

   reg rhcs2DLT;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rhcs2DLT <= 0;
        else
          if (errCLR)
            rhcs2DLT <= 0;
          else if (rhSETDLT)
            rhcs2DLT <= 1;
     end

   //
   // RHCS2 Write Check Error
   //
   // Trace
   //  M7296/CSRA/E1
   //  M7296/CSRA/E8
   //  M7296/CSRA/E14
   //  M7296/CSRA/E15
   //  M7294/DBCD/E28
   //  M7294/DBCD/E37
   //

   reg rhcs2WCE;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rhcs2WCE <= 0;
        else
          if (errCLR)
            rhcs2WCE <= 0;
          else if (rhSETWCE)
            rhcs2WCE <= 1;
     end

   //
   // RHCS2 Unibus Parity Error
   //  Not implemented.
   //
   // Trace
   //  M7296/CSRB/E25
   //

   reg rhcs2UPE;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rhcs2UPE <= 0;
        else
          if (errCLR)
            rhcs2UPE <= 0;
          else if (rhcs2WRITE & devHIBYTE)
            rhcs2UPE <= `rhCS2_UPE(rhDATAI);
     end

   //
   // RHCS2 Non-existent Drive
   //  NED is asserted when a read or write is performed to a disk that is not
   //  present.
   //
   // Trace
   //  M7296/CSRB/E9
   //  M7295/BCTB/E72
   //  M7295/BCTB/E91
   //  M7295/BCTB/E92
   //  M7295/BCTB/E93
   //

   reg rhcs2NED;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rhcs2NED <= 0;
        else
          if (errCLR)
            rhcs2NED <= 0;
          else if (rhSETNED)
            rhcs2NED <= 1;
     end

   //
   // RHCS2 Non-existent Memory
   //
   // Trace
   //  M7294/DBCA/E32
   //  M7294/DBCA/E80
   //  M7294/DBCA/E83
   //  M7294/DBCA/E85
   //

   reg rhcs2NEM;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rhcs2NEM <= 0;
        else
          if (errCLR)
            rhcs2NEM <= 0;
          else if (rhSETNEM)
            rhcs2NEM <= 1;
     end

   //
   // RHCS2 Program Error
   //
   // Trace
   //  M7296/CSRB/E11
   //  M7296/CSRB/E25
   //

   reg rhcs2PGE;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rhcs2PGE <= 0;
        else
          if (devRESET | rhCLR | rhCLRTRE)
            rhcs2PGE <= 0;
          else if (rhCMDGO & !rhRDY)
            rhcs2PGE <= 1;
     end

   //
   // RHCS2 Missed Transfer
   //
   // Trace
   //  M7295/BCTJ/E64
   //  M7295/BCTJ/E80
   //  M7295/BCTJ/E85
   //  M7295/BCTJ/E86
   //  M7295/BCTJ/E87
   //

   reg rhcs2MXF;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rhcs2MXF <= 0;
        else
          if (errCLR)
            rhcs2MXF <= 0;
          else if (rhcs2WRITE & devHIBYTE)
            rhcs2MXF <= `rhCS2_MXF(rhDATAI);
     end

   //
   // RHCS2 Massbus Data Parity Error
   //  Not implemented.
   //
   // Trace
   //  M7297/PACA/E1
   //  M7297/PACA/E2
   //  M7297/PACA/E4
   //  M7297/PACA/E10 (SYNC PE)
   //

   wire rhcs2DPE = 0;

   //
   // RHCS2 Output Ready
   //
   // Trace
   //  M7294/DBCB/E87 (OBUF FULL)
   //

   wire rhcs2OR = rhBUFOR;

   //
   // RHCS2 Input Ready
   //
   // Trace
   //  M7294/DBCB/E81 (IBUF FULL)
   //

   wire rhcs2IR = rhBUFIR;

   //
   // RHCS2 Clear
   //
   // Trace
   //  M7296/CSRB/E17
   //  M7296/CSRB/E26
   //  M7296/CSRB/E27
   //

   wire rhcs2CLR = rhcs2WRITE & devLOBYTE & `rhCS2_CLR(rhDATAI);

   //
   // RHCS2 Parity Test
   //
   // Trace
   //  M7296/CSRB/E21
   //

   reg rhcs2PAT;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rhcs2PAT <= 0;
        else
          if (devRESET | rhcs2CLR)
            rhcs2PAT <= 0;
          else if (rhcs2WRITE & devLOBYTE)
            rhcs2PAT <= `rhCS2_PAT(rhDATAI);
     end

   //
   // RHCS2 Bus Address Increment Inhibit
   //
   // Trace
   //  M7296/CSRB/E8
   //  M7296/CSRB/E12
   //  M7296/CSRB/E27
   //

   reg rhcs2BAI;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rhcs2BAI <= 0;
        else
          if (devRESET | rhcs2CLR)
            rhcs2BAI <= 0;
          else if (rhcs2WRITE & devLOBYTE & rhRDY)
            rhcs2BAI <= `rhCS2_BAI(rhDATAI);
     end

   //
   // RHCS2 Unit Select
   //
   // Trace
   //  M7296/CSRB/E21
   //

   reg [2:0] rhcs2UNIT;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rhcs2UNIT <= 0;
        else
          if (devRESET | rhcs2CLR)
            rhcs2UNIT <= 0;
          else if (rhcs2WRITE & devLOBYTE)
            rhcs2UNIT <= `rhCS2_UNIT(rhDATAI);
     end

   //
   // Build RHCS2 Register
   //
   // Trace
   //  M7294/DBCJ/E30 (00:03)
   //  M7294/DBCJ/E32 (04:07)
   //  M7295/BCTJ/E60 (08:11)
   //  M7295/BCTJ/E59 (12:15)
   //

   assign rhCS2 = {rhcs2DLT, rhcs2WCE, rhcs2UPE, rhcs2NED, rhcs2NEM,
                   rhcs2PGE, rhcs2MXF, rhcs2DPE, rhcs2OR,  rhcs2IR,
                   rhcs2CLR, rhcs2PAT, rhcs2BAI, rhcs2UNIT};

endmodule
