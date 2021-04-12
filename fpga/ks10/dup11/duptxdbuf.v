////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DUP Transmitter Data Buffer (TXDBUF)
//
// Details
//   This file provides the implementation of the DUP11 TXDBUF register.
//
// File
//   duptxdbuf.v
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

`include "duptxdbuf.vh"

module DUPTXDBUF (
      input  wire        clk,           // Clock
      input  wire        rst,           // Reset
      input  wire        devLOBYTE,     // Device Low Byte
      input  wire        devHIBYTE,     // Device High Byte
      input  wire        txdbufWRITE,   // Transmitter Data Buffer Write
      input  wire        dupINIT,       // Initialize
      input  wire [35:0] dupDATAI,      // Device Data In
      input  wire        dupRXCRC,      // Receiver CRC LSB
      input  wire        dupTXCRC,      // Transmitter CRC LSB
      input  wire        dupMNTT,       // Maintenance Timer
      output wire [15:0] regTXDBUF      // TXDBUF Output
   );

   //
   // Bit 15: Reserved
   //

   //
   // Bit 14: Receiver CRC Register LSB (RXCRC)
   //

   //
   // Bit 13: Reserved
   //

   //
   // Bit 12: Transmitter CRC Register LSB (RXCRC)
   //

   //
   // Bit 11 Maintenance Timer (MNTT)
   //

   //
   // Bit 10: Transmit Abord (TXABRT)
   //

   reg dupTXABRT;
   always @(posedge clk)
     begin
        if (rst | dupINIT)
          dupTXABRT <= 0;
        else if (txdbufWRITE & devHIBYTE)
          dupTXABRT <= `dupTXDBUF_TXABRT(dupDATAI);
     end

   //
   // Bit 9: Transmit End of Message (TXEOM)
   //

   reg dupTXEOM;
   always @(posedge clk)
     begin
        if (rst | dupINIT)
          dupTXEOM <= 0;
        else if (txdbufWRITE & devHIBYTE)
          dupTXEOM <= `dupTXDBUF_TXEOM(dupDATAI);
     end

   //
   // Bit 8: Transmit Start of Message (TXEOM)
   //

   reg dupTXSOM;
   always @(posedge clk)
     begin
        if (rst | dupINIT)
          dupTXSOM <= 0;
        else if (txdbufWRITE & devHIBYTE)
          dupTXSOM <= `dupTXDBUF_TXSOM(dupDATAI);
     end

   //
   // Bit 7-0: Transmitter Data
   //

   reg [7:0] dupTXDAT;
   always @(posedge clk)
     begin
        if (rst | dupINIT)
          dupTXDAT <= 0;
        else if (txdbufWRITE & devLOBYTE)
          dupTXDAT <= `dupTXDBUF_TXDAT(dupDATAI);
     end

   //
   // Build TXDBUF
   //

   assign regTXDBUF = {1'b0, dupRXCRC, 1'b0, dupTXCRC, dupMNTT, dupTXABRT, dupTXEOM, dupTXSOM,
                       dupTXDAT[7:0]};

endmodule
