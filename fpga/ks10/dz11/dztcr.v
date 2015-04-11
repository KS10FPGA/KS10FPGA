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
//   dztcr.v
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

`include "dztcr.vh"

module DZTCR(clk, rst,
             devRESET, devLOBYTE, devHIBYTE, devDATAI,
             csrCLR, tcrWRITE, regTCR);

   input          clk;                          // Clock
   input          rst;                          // Reset
   input          devRESET;                     // Device Reset from UBA
   input          devLOBYTE;                    // Device Low Byte
   input          devHIBYTE;                    // Device High Byte
   input  [ 0:35] devDATAI;                     // Device Data In
   input          csrCLR;                       // CSR clear bit
   input          tcrWRITE;                     // Write to TCR
   output [15: 0] regTCR;                       // TCR Output

   //
   // Big-endian to little-endian data bus swap
   //

   wire [35:0] dzDATAI = devDATAI[0:35];

   //
   // TCR Register
   //
   // Details
   //  TCR is read/write and can be accessed as bytes or words
   //
   //  The DTR registers are not reset by CSR[CLR].
   //

   reg [7:0] tcrDTR;
   reg [7:0] tcrLIN;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             tcrDTR <= 0;
             tcrLIN <= 0;
          end
        else
          begin
             if (devRESET)
               begin
                  tcrDTR <= 0;
                  tcrLIN <= 0;
               end
             else if (csrCLR)
               tcrLIN <= 0;
             else
               begin
                  if (tcrWRITE)
                    begin
                       if (devHIBYTE)
                         tcrDTR <= `dzTCR_DTR(dzDATAI);
                       if (devLOBYTE)
                         tcrLIN <= `dzTCR_LIN(dzDATAI);
                    end
               end
          end
     end

   wire [15:0] regTCR = {tcrDTR, tcrLIN};

endmodule
