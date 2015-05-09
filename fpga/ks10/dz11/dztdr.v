////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DZ11 Transmit Data Register (TDR)
//
// Details
//   The module implements the DZ11 TDR Register.
//
// File
//   dztdr.v
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

`include "dztdr.vh"

module DZTDR (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire         devLOBYTE,            // Device Low Byte
      input  wire         devHIBYTE,            // Device High Byte
      input  wire [ 0:35] devDATAI,             // Device Data In
      input  wire [ 2: 0] csrTLINE,             // CSR[TLINE] bits
      input  wire         tdrWRITE,             // Write to TDR
      output reg  [ 7: 0] uartTXLOAD,           // Load UART
      output wire [15: 0] regTDR                // TDR Output
   );

   //
   // Big-endian to little-endian data bus swap
   //

   wire [35:0] dzDATAI = devDATAI[0:35];

   //
   // TDR Register
   //
   // Details
   //  TDR is write-only and can be accessed as bytes or words
   //

   always @(csrTLINE or tdrWRITE or devLOBYTE)
     begin
        if (tdrWRITE & devLOBYTE)
          case (csrTLINE)
            0: uartTXLOAD <= 8'b0000_0001;
            1: uartTXLOAD <= 8'b0000_0010;
            2: uartTXLOAD <= 8'b0000_0100;
            3: uartTXLOAD <= 8'b0000_1000;
            4: uartTXLOAD <= 8'b0001_0000;
            5: uartTXLOAD <= 8'b0010_0000;
            6: uartTXLOAD <= 8'b0100_0000;
            7: uartTXLOAD <= 8'b1000_0000;
          endcase
        else
          uartTXLOAD <= 8'b0000_0000;
     end

   //
   // Build TDR.  Break is not implemented.
   //

   assign regTDR = {8'b0, `dzTDR_TBUF(dzDATAI)};

endmodule
