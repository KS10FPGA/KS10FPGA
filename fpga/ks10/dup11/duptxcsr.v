////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DUP11 Transmitter Control and Status Register
//
// Details
//   This file provides the implementation of the DUP11 TXCSR Register.
//
// File
//   duptxcsr.v
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

`include "duptxcsr.vh"

module DUPTXCSR (
      input  wire        clk,           // Clock
      input  wire        rst,           // Reset
      input  wire        devRESET,      // Device Reset from UBA
      input  wire        devLOBYTE,     // Device Low Byte
      input  wire        devHIBYTE,     // Device High Byte
      input wire         txdbufWRITE,   // Transmitter data buffer write
      input  wire        txcsrWRITE,    // Transmitter Control/Status write
      input  wire [35:0] dupDATAI,      // Device Data In
      input  wire        dupMDO,        // Maintenance Data Out
      input  wire        dupTXDLE,      // Data late error
      input  wire        dupTXACT,      // Transmitter active
      input  wire        dupTXDONE,     // Transmitter done
      output wire [15:0] regTXCSR       // TXCSR Output
   );

   wire dupINIT;

   //
   // Bit 15: Transmitter Data Late Error (TXDLE)
   //


   //
   // Bit 14: Maintenance Data Out (MDO)
   //

   //
   // Bit 13: Maintenance Clock Out (MCO)
   //

   reg dupMCO;
   always @(posedge clk)
     begin
        if (rst | dupINIT)
          dupMCO <= 0;
        else if (txcsrWRITE & devHIBYTE)
          dupMCO <= `dupTXCSR_MCO(dupDATAI);
     end

   //
   // Bit 12:11 Maintenance Select (MSEL)
   //

   reg [12:11] dupMSEL;
   always @(posedge clk)
     begin
        if (rst | dupINIT)
          dupMSEL <= 0;
        else if (txcsrWRITE & devHIBYTE)
          dupMSEL <= `dupTXCSR_MSEL(dupDATAI);
     end

   //
   // Bit 10: Maintenance Data In
   //

   reg dupMDI;
   always @(posedge clk)
     begin
        if (rst | dupINIT)
          dupMDI <= 0;
        else if (txcsrWRITE & devHIBYTE)
          dupMDI <= `dupTXCSR_MDI(dupDATAI);
     end

   //
   // Bit 9: Transmitter Active
   //

   //
   // Bit 8: Initialize (INIT)
   //

   assign dupINIT = devRESET | (txcsrWRITE & devHIBYTE & `dupTXCSR_INIT(dupDATAI));

   //
   // Bit 7: Transmitter Done (TXDONE)
   //


   //
   // Bit 6: Transmitter Interrupt Enable (TXIE)
   //

   reg dupTXIE;
   always @(posedge clk)
     begin
        if (rst | dupINIT)
          dupTXIE <= 0;
        else if (txcsrWRITE & devLOBYTE)
          dupTXIE <= `dupTXCSR_TXIE(dupDATAI);
     end

   //
   // Bit 5: Reserved
   //

   //
   // Bit 4: Send (SEND)
   //

   reg dupSEND;
   always @(posedge clk)
     begin
        if (rst | dupINIT)
          dupSEND <= 0;
        else if (txcsrWRITE & devLOBYTE)
          dupSEND <= `dupTXCSR_SEND(dupDATAI);
     end

   //
   // Bit 3: Half-duplex (HDX)
   //

   reg dupHDX;
   always @(posedge clk)
     begin
        if (rst | dupINIT)
          dupHDX <= 0;
        else if (txcsrWRITE & devLOBYTE)
          dupHDX <= `dupTXCSR_HDX(dupDATAI);
     end

   //
   // Bit 2-0: Reserved
   //


   //
   // Build TXCSR
   //

   assign regTXCSR = {dupTXDLE, dupMDO, dupMCO, dupMSEL[12:11], dupMDI, dupTXACT, dupINIT,
                      dupTXDONE, dupTXIE, 1'b0, dupSEND, dupHDX, 3'b0};

endmodule
