////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Unibus Exerciser Control/Status Register #2 (UBECSR2)
//
// Details
//   The information used to design the UBE was mostly obtained be reverse
//   engineering the UBE from DSDUA source code and CXBEAB0 diagnostic source
//   code.
//
// File
//   ubecsr2.sv
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2021 Rob Doyle
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

`include "ubecsr2.vh"

module UBECSR2 (
      input  wire          clk,                         // Clock
      input  wire          rst,                         // Reset
      input  wire          devRESET,                    // Device Reset
      input  wire          devHIBYTE,                   // Device Hi Byte
      input  wire          devLOBYTE,                   // Device Lo Byte
      input  wire  [35: 0] devDATAI,                    // Device Data In
      input  wire          csr2WRITE,                   // CSR2 write
      output logic [15: 0] regCSR2                      // CSR2 register
   );

   //
   //  Bit 4: UBE Control/Status Register #2 - ACLO
   //

   logic ubeACLO;

   always_ff @(posedge clk)
     begin
        if (rst | devRESET)
          ubeACLO <= 0;
        else if (csr2WRITE & devLOBYTE)
          ubeACLO <= `ubeCSR2_ACLO(devDATAI);
     end

   //
   // Bit 3: UBE Control/Status Register #2 - USED3
   //

   logic ubeUSED3;

   always_ff @(posedge clk)
     begin
        if (rst | devRESET)
          ubeUSED3 <= 0;
        else if (csr2WRITE & devLOBYTE)
          ubeUSED3 <= `ubeCSR2_USED3(devDATAI);
     end

   //
   // Bit 2: UBE Control/Status Register #2 - USED2
   //

   logic ubeUSED2;

   always_ff @(posedge clk)
     begin
        if (rst | devRESET)
          ubeUSED2 <= 0;
        else if (csr2WRITE & devLOBYTE)
          ubeUSED2 <= `ubeCSR2_USED2(devDATAI);
     end

   //
   // Bit 1: UBE Control/Status Register #2 - USED1
   //

   logic ubeUSED1;

   always_ff @(posedge clk)
     begin
        if (rst | devRESET)
          ubeUSED1 <= 0;
        else if (csr2WRITE & devLOBYTE)
          ubeUSED1 <= `ubeCSR2_USED1(devDATAI);
     end

   //
   // Bit 0: UBE Control/Status Register #2 - USED0
   //

   logic ubeUSED0;

   always_ff @(posedge clk)
     begin
        if (rst | devRESET)
          ubeUSED0 <= 0;
        else if (csr2WRITE & devLOBYTE)
          ubeUSED0 <= `ubeCSR2_USED0(devDATAI);
     end

   //
   // Build UBECSR2
   //

   assign regCSR2 = {11'b0, ubeACLO, ubeUSED3, ubeUSED2, ubeUSED1,  ubeUSED0};

endmodule
