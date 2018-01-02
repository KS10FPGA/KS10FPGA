////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DUP Parameter Control/Status Register (PARCSR)
//
// Details
//   This file provides the implementation of the DUP11 PARCSR register.
//
// File
//   dupparcsr.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2018 Rob Doyle
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

`include "dupparcsr.vh"

module DUPPARCSR (
      input  wire        clk,           // Clock
      input  wire        rst,           // Reset
      input  wire        devLOBYTE,     // Device Low Byte
      input  wire        devHIBYTE,     // Device High Byte
      input  wire        parcsrWRITE,   // Transmitter Data Buffer Write
      input  wire        dupINIT,       // Initialize
      input  wire [35:0] dupDATAI,      // Device Data In
      output wire [15:0] regPARCSR      // PARCSR Output
   );

   //
   // Bit 15: DEC Mode (DEC)
   //

   reg dupDECMD;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          dupDECMD <= 0;
        else
          if (dupINIT)
            dupDECMD <= 0;
          else if (parcsrWRITE & devHIBYTE)
            dupDECMD <= `dupPARCSR_DECMD(dupDATAI);
     end

   //
   // Bit 14-13: Reserved
   //

   //
   // Bit 12: Secondary Station Mode (SSM)
   //

   reg dupSSM;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          dupSSM <= 0;
        else
          if (dupINIT)
            dupSSM <= 0;
          else if (parcsrWRITE & devHIBYTE)
            dupSSM <= `dupPARCSR_SSM(dupDATAI);
     end

   //
   // Bit 11-10 Reserved
   //

   //
   // Bit 9: CRC Inhibit (CRCI)
   //

   reg dupCRCI;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          dupCRCI <= 0;
        else
          if (dupINIT)
            dupCRCI <= 0;
          else if (parcsrWRITE & devHIBYTE)
            dupCRCI <= `dupPARCSR_CRCI(dupDATAI);
     end

   //
   // Bit 8: Reserved
   //

   //
   // Bit 7-0: Sync Character/Secondary Address
   //

   reg [7:0] dupSYNADR;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          dupSYNADR <= 0;
        else
          if (dupINIT)
            dupSYNADR <= 0;
          else if (parcsrWRITE & devLOBYTE)
            dupSYNADR <= `dupPARCSR_SYNADR(dupDATAI);
     end

   //
   // Build PARCSR
   //

   assign regPARCSR = {dupDECMD, 2'b0, dupSSM, 2'b0, dupCRCI, 1'b0, dupSYNADR[7:0]};

endmodule
