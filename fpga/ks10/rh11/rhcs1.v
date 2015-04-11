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
`include "rhcs2.vh"
`include "rpxx/rpcs1.vh"

module RHCS1(clk, rst,
             devRESET, devLOBYTE, devHIBYTE, devDATAI, rhcs1WRITE, rpATA,
             goCLR, intrDONE, rhBA, rhCS2, rpCS1, rhCS1);

   input          clk;                          // Clock
   input          rst;                          // Reset
   input          devRESET;                     // Device Reset from UBA
   input          devLOBYTE;                    // Device Low Byte
   input          devHIBYTE;                    // Device High Byte
   input  [ 0:35] devDATAI;                     // Device Data In
   input          rhcs1WRITE;                   // CS1 Write
   input          rpATA;                        // Attention
   input          goCLR;                        // Go clear
   input          intrDONE;                     // Interrupt done
   input  [17: 0] rhBA;                         // rhBA Input
   input  [15: 0] rhCS2;                        // rhCS2 Input
   input  [15: 0] rpCS1;                        // rpCS1 Input
   output [15: 0] rhCS1;                        // rhCS1 Output

   //
   // Big-endian to little-endian data bus swap
   //

   wire [35:0] rhDATAI = devDATAI[0:35];

   //
   // Clear Transfer Error
   //

   wire treCLR = rhcs1WRITE & devHIBYTE & `rhCS1_TRE(rhDATAI);

   //
   // Status history.  See Transfer Error (TRE).
   //

   reg lastDLT;
   reg lastWCE;
   reg lastUPE;
   reg lastNED;
   reg lastNEM;
   reg lastPGE;
   reg lastMXF;
   reg lastDPE;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             lastDLT <= 0;
             lastWCE <= 0;
             lastUPE <= 0;
             lastNED <= 0;
             lastNEM <= 0;
             lastPGE <= 0;
             lastMXF <= 0;
             lastDPE <= 0;
          end
        else
          begin
             lastDLT <= `rhCS2_DLT(rhCS2);
             lastWCE <= `rhCS2_WCE(rhCS2);
             lastUPE <= `rhCS2_UPE(rhCS2);
             lastNED <= `rhCS2_NED(rhCS2);
             lastNEM <= `rhCS2_NEM(rhCS2);
             lastPGE <= `rhCS2_PGE(rhCS2);
             lastMXF <= `rhCS2_MXF(rhCS2);
             lastDPE <= `rhCS2_DPE(rhCS2);
          end
     end

   //
   // CS1 Special Conditions (SC)
   //
   // Trace
   //  M7296/CSRB/E2
   //  M7296/CSRB/E20
   //

   wire cs1SC = cs1TRE | rpATA;

   //
   // CS1 Transfer Error (TRE)
   //
   // Note:
   //  Transfer error is asserted on the *transition* of the status signals.
   //
   // Trace
   //  M7296/CSRB/E2
   //  M7296/CSRB/E3
   //  M7296/CSRB/E5
   //  M7296/CSRB/E20
   //  M7296/CSRB/E22
   //

   reg cs1TRE;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          cs1TRE  <= 0;
        else
          begin
             if (devRESET | `rhCS2_CLR(rhCS2) | goCLR | treCLR)
               cs1TRE <= 0;
             else if ((`rhCS2_DLT(rhCS2) & !lastDLT) |
                      (`rhCS2_WCE(rhCS2) & !lastWCE) |
                      (`rhCS2_UPE(rhCS2) & !lastUPE) |
                      (`rhCS2_NED(rhCS2) & !lastNED) |
                      (`rhCS2_NEM(rhCS2) & !lastNEM) |
                      (`rhCS2_PGE(rhCS2) & !lastPGE) |
                      (`rhCS2_MXF(rhCS2) & !lastMXF) |
                      (`rhCS2_DPE(rhCS2) & !lastDPE))
               cs1TRE <= 1;
          end
     end

   //
   // CS1 Massbus Control Parity Error (CPE aka CNTL PE)
   //
   // Trace
   //  M7296/PACA/E5
   //  M7296/PACA/E7
   //  M7296/PACA/E10
   //

   wire cs1CPE = 0;

   //
   // CS1 Drive Available (DVA)
   //
   // Trace
   //  Supplied via massbus
   //

   wire cs1DVA = `rpCS1_DVA(rpCS1);

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
        if (rst)
          cs1PSEL <= 0;
        else
          if (devRESET | `rhCS2_CLR(rhCS2))
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

   wire cs1RDY = 0;
   //FIXME:

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
        if (rst)
          cs1IE <= 0;
        else
          if (devRESET | `rhCS2_CLR(rhCS2) | intrDONE)
            cs1IE <= 0;
          else if (rhcs1WRITE & devLOBYTE)
            cs1IE <= `rhCS1_IE(rhDATAI);
     end

   //
   // CS1 Function (from RPxx)
   //
   // Trace
   //  Supplied via massbus
   //

   wire [5:1] cs1FUN = `rpCS1_GO(rpCS1);

   //
   // CS1 GO (from RPxx)
   //
   // Trace
   //  Supplied via massbus
   //

   wire cs1GO = `rpCS1_GO(rpCS1);

   //
   // Build CS1 Register
   //
   // Trace
   //  M7294/DBCJ/E30 (00:03)
   //  M7294/DBCJ/E32 (04:07)
   //  M7295/BCTJ/E60 (08:11)
   //  M7295/BCTJ/E59 (12:15)
   //

   wire [15:0] rhCS1 = {cs1SC, cs1TRE, cs1CPE, 1'b1, cs1DVA, cs1PSEL,
                        rhBA[17:16], cs1RDY, cs1IE, cs1FUN, cs1GO};

endmodule

