////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DUP11 Receiver Control and Status Register
//
// Details
//   This file provides the implementation of the DUP11 RXCSR Register.
//
// File
//   duprxcsr.v
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

`include "duprxcsr.vh"

module DUPRXCSR (
      input  wire        clk,           // Clock
      input  wire        rst,           // Reset
      input  wire        devLOBYTE,     // Device Low Byte
      input  wire        devHIBYTE,     // Device High Byte
      input  wire        rxdbufREAD,    // Receiver Buffer Register read
      input  wire        rxcsrREAD,     // Receiver Control/Status read
      input  wire        rxcsrWRITE,    // Receiver Control/Status write
      input  wire        dupW3,         // Configuration Wire #3
      input  wire        dupW5,         // Configuration Wire #5
      input  wire        dupW6,         // Configuration Wire #6
      input  wire        dupRI,         // Ring Indication
      input  wire        dupCTS,        // Clear to Send
      input  wire        dupDCD,        // Data Carrier Detect
      input  wire        dupDSR,        // Data Set Ready
      output reg         dupRTS,        // Request to Send
      output reg         dupDTR,        // Data Terminal Ready
      input  wire [35:0] dupDATAI,      // Device Data In
      input  wire        dupINIT,       // Initialize
      input  wire        dupRXACT,      // Receiver Active
      input  wire        dupRXDONE,     // Receiver Done
      output wire [15:0] regRXCSR       // RXCSR Output
   );

   wire dupSECRX;

   //
   // Watch for transitions of RI
   //

   reg lastRI;
   always @(posedge clk)
     begin
        if (rst)
          lastRI <= 0;
        else
          lastRI <= dupRI;
     end

   //
   // Watch for transitions of CTS
   //

   reg lastCTS;
   always @(posedge clk)
     begin
        if (rst)
          lastCTS <= 0;
        else
          lastCTS <= dupCTS;
     end

   //
   // Watch for transitions of DCD
   //

   reg lastDCD;
   always @(posedge clk)
     begin
        if (rst)
          lastDCD <= 0;
        else
          lastDCD <= dupDCD;
     end

   //
   // Watch for transition on SECRX
   //

   reg lastSECRX;
   always @(posedge clk)
     begin
        if (rst)
          lastSECRX <= 0;
        else
          lastSECRX <= dupSECRX;
     end

   //
   // Watch for transitions of DSR
   //

   reg lastDSR;
   always @(posedge clk)
     begin
        if (rst)
          lastDSR <= 0;
        else
          lastDSR <= dupDSR;
     end

   //
   // Some register bits clear AFTER they are read. Keep some history of the
   // rxcsrREAD signal.
   //

   reg [2:0] lastCSRRD;
   always @(posedge clk)
     begin
        if (rst)
          lastCSRRD <= 0;
        else
          lastCSRRD <= {lastCSRRD[1:0], rxcsrREAD};
     end

   wire dupCSRCLR = lastCSRRD[2] & !lastCSRRD[1];

   //
   // Bit 15: Data Set Change A (DSCA)
   //

   reg dupDSCA;
   always @(posedge clk)
     begin
        if (rst | dupINIT | dupCSRCLR)
          dupDSCA <= 0;
        else if ((         (dupRI    != lastRI   )) |
                 (         (dupCTS   != lastCTS  )) |
                 ( dupW5 & (dupDCD   != lastDCD  )) |
                 ( dupW5 & (dupDSR   != lastDSR  )) |
                 ( dupW5 & (dupSECRX != lastSECRX)))
          dupDSCA <= 1;
     end

   //
   // Bit 14: Ring Indication (RI)
   //

   //
   // Bit 13: Clear To Send (CTS)
   //

   //
   // Bit 12: Data Carrier Detect (DCD)
   //

   //
   // Bit 11: Receiver Active (RXACT)
   //

   //
   // Bit 10: Secondary Received Data (SECRX)
   //

   //
   // Bit 9: Data Set Ready (DSR)
   //

   //
   // Bit 8: Strip Sync (STRSYN)
   //

   reg dupSTRSYN;
   always @(posedge clk)
     begin
        if (rst | dupINIT)
          dupSTRSYN <= 0;
        else if (rxcsrWRITE & devHIBYTE)
          dupSTRSYN <= `dupRXCSR_STRSYN(dupDATAI);
     end

   //
   // Bit 7: Receive Done (RXDONE)
   //

   //
   // Bit 6: Receiver Interrupt Enable (RXIE)
   //

   reg dupRXIE;
   always @(posedge clk)
     begin
        if (rst | dupINIT)
          dupRXIE <= 0;
        else if (rxcsrWRITE & devLOBYTE)
          dupRXIE <= `dupRXCSR_RXIE(dupDATAI);
     end

   //
   // Bit 5: Data Set Change Interrupt Enable (DSCIE)
   //

   reg dupDSCIE;
   always @(posedge clk)
     begin
        if (rst | dupINIT)
          dupDSCIE <= 0;
        else if (rxcsrWRITE & devLOBYTE)
          dupDSCIE <= `dupRXCSR_DSCIE(dupDATAI);
     end

   //
   // Bit 4: Receiver Enable (RXEN)
   //

   reg dupRXEN;
   always @(posedge clk)
     begin
        if (rst | dupINIT)
          dupRXEN <= 0;
        else if (rxcsrWRITE & devLOBYTE)
          dupRXEN <= `dupRXCSR_RXEN(dupDATAI);
     end

   //
   // Bit 3: Secondary Transmitted Data (SECTX)
   //

   reg dupSECTX;
   always @(posedge clk)
     begin
        if (rst | (dupW3 & dupINIT))
          dupSECTX <= 0;
        else if (rxcsrWRITE & devLOBYTE)
          dupSECTX <= `dupRXCSR_SECTX(dupDATAI);
     end

   assign dupSECRX = dupSECTX;

   //
   // Bit 2:  Request To Send (RTS)
   //

   always @(posedge clk)
     begin
        if (rst | (dupW3 & dupINIT))
          dupRTS <= 0;
        else if (rxcsrWRITE & devLOBYTE)
          dupRTS <= `dupRXCSR_RTS(dupDATAI);
     end

   //
   // Bit 1: Data Terminal Ready (DTR)
   //

   always @(posedge clk)
     begin
        if (rst | (dupW3 & dupINIT))
          dupDTR <= 0;
        else if (rxcsrWRITE & devLOBYTE)
          dupDTR <= `dupRXCSR_DTR(dupDATAI);
     end

   //
   // Bit 0: Data Set Change B (DSCB)
   //

   reg dupDSCB;
   always @(posedge clk)
     begin
        if (rst | dupINIT | dupCSRCLR)
          dupDSCB <= 0;
        else if ((dupW6 & (dupDCD   != lastDCD   )) |
                 (dupW6 & (dupDSR   != lastDSR   )) |
                 (dupW6 & (dupSECRX != lastSECRX)))
          dupDSCB <= 1;
     end

   //
   // Build RXCSR
   //

   assign regRXCSR = {dupDSCA, dupRI, dupCTS, dupDCD, dupRXACT, dupSECRX, dupDSR, dupSTRSYN,
                      dupRXDONE, dupRXIE, dupDSCIE, dupRXEN, dupSECTX, dupRTS, dupDTR, dupDSCB};

endmodule
