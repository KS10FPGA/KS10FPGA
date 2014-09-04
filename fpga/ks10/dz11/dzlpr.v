////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DZ11 Line Parameter Register (LPR)
//
// Details
//   The module implements the DZ11 LPR Register.
//
// File
//   dzlpr.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2014 Rob Doyle
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
`include "dzlpr.vh"

  module DZLPR(clk, rst, clr, devDATAI, lprWRITE, lprRXEN);

   input          clk;                          // Clock
   input          rst;                          // Reset
   input          clr;                          // Clear
   input  [ 0:35] devDATAI;                     // Device Data In
   input          lprWRITE;                     // Write to LPR
   output [ 0: 7] lprRXEN;                      // LPR Output

   //
   // Big-endian to little-endian data bus swap
   //

   wire [35:0] dzDATAI = devDATAI[0:35];

   //
   // LPR Register
   //
   // Details
   //  LPR is write-only and can only be written as words.  The LINE field
   //  selects the receiver that is being updated.
   //
   //  Many of the LPR bits are not implemented.
   //

   reg [0:7] lprRXEN;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          lprRXEN <= 0;
        else
          begin
             if (clr)
               lprRXEN <= 0;
             else if (lprWRITE)
               case (`dzLPR_LINE(dzDATAI))
                 0: lprRXEN[0] <= `dzLPR_RXEN(dzDATAI);
                 1: lprRXEN[1] <= `dzLPR_RXEN(dzDATAI);
                 2: lprRXEN[2] <= `dzLPR_RXEN(dzDATAI);
                 3: lprRXEN[3] <= `dzLPR_RXEN(dzDATAI);
                 4: lprRXEN[4] <= `dzLPR_RXEN(dzDATAI);
                 5: lprRXEN[5] <= `dzLPR_RXEN(dzDATAI);
                 6: lprRXEN[6] <= `dzLPR_RXEN(dzDATAI);
                 7: lprRXEN[7] <= `dzLPR_RXEN(dzDATAI);
               endcase
          end
     end

endmodule
