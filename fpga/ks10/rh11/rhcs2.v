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
// Copyright (C) 2014 Rob Doyle
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

`include "rhcs1.vh"  
`include "rhcs2.vh"

  module RHCS2(clk, rst,
               devRESET, devLOBYTE, devHIBYTE, devDATAI, rhcs2WRITE,
               setWCE, setNEM, setPGE, goCLR, treCLR, rhCS1, rhCS2);

   input          clk;                          // Clock
   input          rst;                          // Reset
   input          devRESET;                     // Device Reset from UBA
   input          devLOBYTE;                    // Device Low Byte
   input          devHIBYTE;                    // Device High Byte
   input  [ 0:35] devDATAI;                     // Device Data In
   input          rhcs2WRITE;                   // Write to CS2
   input          setWCE;                       // Set WCE
   input          setNEM;                       // Set NEM
   input          setPGE;                       // Set PGE
   input          goCLR;                        // GO CLR
   input          treCLR;                       // TRE CLR
   input  [15: 0] rhCS1;                        // CS1 Input
   output [15: 0] rhCS2;                        // CS2 Output

   //
   // Big-endian to little-endian data bus swap
   //

   wire [35:0] rhDATAI = devDATAI[0:35];

   //
   // CS2 Device Late
   //  Not implemented.  The SD Card is never late.
   //
   // Trace
   //  M7294/DBCB/E61
   //  M7294/DBCB/E71
   //  M7294/DBCB/E72
   //  M7294/DBCB/E73
   //  M7294/DBCB/E79
   //  M7294/DBCB/E97
   //

   wire rhcs2DLT = 0;

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
   always @(posedge clk)
     begin
        if (rst)
          rhcs2WCE <= 0;
        else
          if (devRESET | rhcs2CLR | treCLR | goCLR)
            rhcs2WCE <= 0;
          else if (setWCE)
            rhcs2WCE <= 1;
     end

   //
   // RHCS2 Unibus Parity Error
   //
   // Trace
   //  M7296/CSRB/E25
   //

   reg rhcs2UPE;
   always @(posedge clk)
     begin
        if (rst)
          rhcs2UPE <= 0;
        else
          if (devRESET | rhcs2CLR | treCLR | goCLR)
            rhcs2UPE <= 0;
          else if (rhcs2WRITE & devHIBYTE)
            rhcs2UPE <= `rhCS2_UPE(rhDATAI);
     end

   //
   // RHCS2 Non-existent Drive
   //  Not implemented.  All drives are valid.
   //
   // Trace
   //  M7296/CSRB/E9
   //

   wire rhcs2NED = 0;

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
   always @(posedge clk)
     begin
        if (rst)
          rhcs2NEM <= 0;
        else
          if (devRESET | rhcs2CLR | treCLR | goCLR)
            rhcs2NEM <= 0;
          else if (setNEM)
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
   always @(posedge clk)
     begin
        if (rst)
          rhcs2PGE <= 0;
        else
          if (devRESET | rhcs2CLR | treCLR)
            rhcs2PGE <= 0;
          else if (setPGE)
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
   always @(posedge clk)
     begin
        if (rst)
          rhcs2MXF <= 0;
        else
          if (devRESET | rhcs2CLR | treCLR | goCLR)
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
   //  Not implemented.
   //
   // Trace
   //  M7294/DBCB/E87 (OBUF FULL)
   //

   wire rhcs2OR = 0;

   //
   // RHCS2 Input Ready
   //  Not implemented.
   //
   // Trace
   //  M7294/DBCB/E81 (IBUF FULL)
   //

   wire rhcs2IR = 0;

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
   always @(posedge clk)
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
   //  M7296/CSRB/E12
   //  M7296/CSRB/E8
   //  M7296/CSRB/E27
   //

   reg rhcs2BAI;
   always @(posedge clk)
     begin
        if (rst)
          rhcs2BAI <= 0;
        else
          if (devRESET | rhcs2CLR)
            rhcs2BAI <= 0;
          else if (rhcs2WRITE & devLOBYTE & `rhCS1_RDY(rhCS1))
            rhcs2BAI <= `rhCS2_BAI(rhDATAI);
     end

   //
   // RHCS2 Unit Select
   //
   // Trace
   //  M7296/CSRB/E21
   //

   reg [2:0] rhcs2UNIT;
   always @(posedge clk)
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

   wire [15:0] rhCS2 = {rhcs2DLT, rhcs2WCE, rhcs2UPE, rhcs2NED, rhcs2NEM,
                        rhcs2PGE, rhcs2MXF, rhcs2DPE, rhcs2OR,  rhcs2IR,
                        rhcs2CLR, rhcs2PAT, rhcs2BAI, rhcs2UNIT};

endmodule
