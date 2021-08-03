////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Unibus Exerciser Data Buffer Register (UBEDB)
//
// Details
//   The information used to design the UBE was mostly obtained be reverse
//   engineering the UBE from DSDUA source code and CXBEAB0 diagnostic source
//   code.
//
// File
//   ubedb.sv
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

`include "ubedb.vh"

module UBEDB (
      input  wire          clk,                         // Clock
      input  wire          rst,                         // Reset
      input  wire          devRESET,                    // Device Reset
      input  wire          devHIBYTE,                   // Device Hi Byte
      input  wire          devLOBYTE,                   // Device Lo Byte
      input  wire  [35: 0] devADDRO,                    // Device Addr Out
      input  wire  [35: 0] devDATAI,                    // Device Data In
      input  wire          devREQO,                     // Device Request Out
      input  wire          devACKI,                     // Device Acknowledge In
      input  wire          dbWRITE,                     // DB write
      input  wire          ubeBYTE,                     // BYTE mode
      input  wire          ubeNPRO,                     // NPR output
      output logic [15: 0] regDB                        // DB register
   );

   //
   // UBE Data Buffer Register
   //

   always @(posedge clk)
     begin
        if (rst | devRESET)
          regDB <= 0;
        else if (devREQO & devACKI & !ubeNPRO)
            case ({ubeBYTE, devADDRO[1:0]})
              3'b000: regDB[15: 0] <= devDATAI[33:18];  // Even word
              3'b001: regDB[15: 0] <= devDATAI[33:18];  // Even word
              3'b010: regDB[15: 0] <= devDATAI[15: 0];  // Odd  word
              3'b011: regDB[15: 0] <= devDATAI[15: 0];  // Odd  word
              3'b100: regDB[ 7: 0] <= devDATAI[25:18];  // Even word, low  byte
              3'b101: regDB[15: 8] <= devDATAI[33:26];  // Even word, high byte
              3'b110: regDB[ 7: 0] <= devDATAI[ 7: 0];  // Odd  word, low  byte
              3'b111: regDB[15: 0] <= devDATAI[15: 8];  // Odd  word, high byte
            endcase
        else if (dbWRITE)
          begin
             if (devHIBYTE)
               regDB[15: 8] <= `ubeDB_HI(devDATAI);
             if (devLOBYTE)
               regDB[ 7: 0] <= `ubeDB_LO(devDATAI);
          end
     end

endmodule
