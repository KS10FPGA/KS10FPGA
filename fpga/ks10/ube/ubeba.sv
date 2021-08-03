////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Unibus Exerciser Buffer Address Register (UBEBA)
//
// Details
//   The information used to design the UBE was mostly obtained be reverse
//   engineering the UBE from DSDUA source code and CXBEAB0 diagnostic source
//   code.
//
// File
//   ubeba.sv
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

`include "ubeba.vh"

module UBEBA (
      input  wire          clk,                         // Clock
      input  wire          rst,                         // Reset
      input  wire          devRESET,                    // Device Reset
      input  wire          devHIBYTE,                   // Device Hi Byte
      input  wire          devLOBYTE,                   // Device Lo Byte
      input  wire  [35: 0] devDATAI,                    // Device Data In
      input  wire          baWRITE,                     // BA write
      input  wire          ubeINC,                      // BA inc by four
      output logic [15: 0] regBA                        // BA register
   );

   //
   // UBE Buffer Address Register
   //

   always @(posedge clk)
     begin
        if (rst | devRESET)
          regBA <= 0;
        else if (baWRITE)
          begin
             if (devHIBYTE)
               regBA[15: 8] <= `ubeBA_HI(devDATAI);
             if (devLOBYTE)
               regBA[ 7: 0] <= `ubeBA_LO(devDATAI);
          end
        else if (ubeINC)
          regBA <= regBA + 16'd4;
     end

endmodule
