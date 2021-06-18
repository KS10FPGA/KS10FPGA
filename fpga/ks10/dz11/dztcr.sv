////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DZ11 Transmit Control Register (TCR)
//
// Details
//   The module implements the DZ11 TCR Register.
//
// File
//   dztcr.sv
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

`include "dztcr.vh"

module DZTCR (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire         devRESET,             // Device Reset from UBA
      input  wire         devLOBYTE,            // Device Low Byte
      input  wire         devHIBYTE,            // Device High Byte
      input  wire [35: 0] dzDATAI,              // DZ Data In
      input  wire         csrCLR,               // CSR clear bit
      input  wire         tcrWRITE,             // Write to TCR
      output wire [15: 0] regTCR                // TCR Output
   );

   //
   // Data Terminal Ready Register (DTR)
   //
   // Details
   //   The DTR register is not reset by CSR[CLR].
   //

   logic [7:0] tcrDTR;

   always_ff @(posedge clk)
     begin
        if (rst | devRESET)
          tcrDTR <= 0;
        else if (tcrWRITE & devHIBYTE)
          tcrDTR <= `dzTCR_DTR(dzDATAI);
     end

   //
   // Line Enable Register (LIN)
   //
   // Details
   //   The DTR register is reset by CSR[CLR].
   //

   logic [7:0] tcrLIN;

   always_ff @(posedge clk)
     begin
        if (rst | devRESET | csrCLR)
          tcrLIN <= 0;
        else if (tcrWRITE & devLOBYTE)
          tcrLIN <= `dzTCR_LIN(dzDATAI);
     end

   assign regTCR = {tcrDTR, tcrLIN};

endmodule
