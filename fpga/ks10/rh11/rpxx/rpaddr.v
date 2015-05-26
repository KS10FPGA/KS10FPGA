////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Linear Sector Address Calculator
//
// Details
//   This module calculates a Linear Sector Address from the Disk CHS address.
//   The linear sector address is used the SD Card.  This calculation follows
//   the SIMH addressing convention.
//
//   This requires 75 clock cycles to perform the address calculation
//   (worst case).
//
// File
//   rpaddr.v
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

module RPADDR (
      input  wire        clk,           // Clock
      input  wire        rst,           // Reset
      input  wire [ 5:0] rpTRKNUM,      // Number of tracks
      input  wire [ 5:0] rpSECNUM,      // Number of sectors
      input  wire [ 9:0] rpDCA,         // Cylinder
      input  wire [ 5:0] rpTA,          // Track
      input  wire [ 5:0] rpSA,          // Sector
      output wire [20:0] rpSDLSA,       // Linear sector address
      input  wire        rpADRSTRT,     // Start calculation
      output wire        rpADRBUSY      // Calculation completed
   );

   //
   // States
   //

   parameter [1:0] stateIDLE  = 0,
                   stateTRACK = 1,
                   stateSECT  = 2,
                   stateWORD  = 3;

   //
   // SD Sector Address Calculator State Machine
   //

   reg [20:0] sum;
   reg [20:0] temp;
   reg [ 1:0] state;
   reg [ 5:0] loop;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             sum   <= 0;
             temp  <= 0;
             loop  <= 0;
             state <= stateIDLE;
          end
        else
          begin
             case (state)
               stateIDLE:
                 begin
                    if (rpADRSTRT)
                      begin
                         sum   <= 0;
                         temp  <= rpDCA;
                         loop  <= rpTRKNUM;
                         state <= stateTRACK;
                      end
                 end
               stateTRACK:
                 begin
                    if (loop == 0)
                      begin
                         sum   <= 0;
                         temp  <= sum + rpTA;
                         loop  <= rpSECNUM;
                         state <= stateSECT;
                      end
                    else
                      begin
                         sum  <= sum + temp;
                         loop <= loop - 1'b1;
                      end
                 end
               stateSECT:
                 begin
                    if (loop == 0)
                      begin
                         sum   <= sum + rpSA;
                         state <= stateWORD;
                      end
                    else
                      begin
                         sum  <= sum + temp;
                         loop <= loop - 1'b1;
                      end
                 end
               stateWORD:
                 begin
                    sum   <= sum + sum;
                    state <= stateIDLE;
                 end
             endcase
          end
     end

   assign rpSDLSA   = sum;
   assign rpADRBUSY = !(state == stateIDLE);

endmodule
