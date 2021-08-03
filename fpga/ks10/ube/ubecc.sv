////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Unibus Exerciser Cycle Count Register (UBECC)
//
// Details
//   The information used to design the UBE was mostly obtained be reverse
//   engineering the UBE from DSDUA source code and CXBEAB0 diagnostic source
//   code.
//
// File
//   ubecc.sv
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

`include "ubecc.vh"

module UBECC (
      input  wire          clk,                         // Clock
      input  wire          rst,                         // Reset
      input  wire          devRESET,                    // Device Reset
      input  wire          devHIBYTE,                   // Device Hi Byte
      input  wire          devLOBYTE,                   // Device Lo Byte
      input  wire  [35: 0] devDATAI,                    // Device Data In
      input  wire          ccWRITE,                     // CC write
      input  wire          ubeINC,                      // CC inc by two
      output logic [15: 0] regCC                        // CC register
   );

   //
   // UBE Cycle Count Register
   //

   always @(posedge clk)
     begin
        if (rst | devRESET)
          regCC <= 0;
        else if (ccWRITE)
          begin
             if (devHIBYTE)
               regCC[15: 8] <= `ubeCC_HI(devDATAI);
             if (devLOBYTE)
               regCC[ 7: 0] <= `ubeCC_LO(devDATAI);
          end
        else if (ubeINC)
          regCC <= regCC + 16'd2;
     end

endmodule
