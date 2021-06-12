////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KMC11 Interrupt Controller
//
// Details
//   This module implements the KMC11 Interrupt Controller.
//
// File
//   kmcintr.v
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

module KMCINTR (
      input  wire clk,          // Clock
      input  wire rst,          // Reset
      input  wire kmcINIT,      // Initialize
      input  wire kmcSETIRQ,    // Edge trigger interrupt
      input  wire kmcIACK,      // Interrupt acknowledge
      output wire kmcIRQO       // Interrupt request out
   );

   localparam [1:0] stateIDLE    = 0,
                    stateACT     = 1,
                    stateVECTCLR = 2;

   //
   // The interrupt request MUST clear AFTER the vector cycle is complete.
   //

   reg [1:0] state;

   always @(posedge clk)
     begin
        if (rst | kmcINIT)
          state <= stateIDLE;
        else
          case (state)
            stateIDLE:
              if (kmcSETIRQ)
                state <= stateACT;
            stateACT:
              if (kmcIACK)
                state <= stateVECTCLR;
            stateVECTCLR:
              if (!kmcIACK)
                state <= stateIDLE;
          endcase
     end

   assign kmcIRQO = state != stateIDLE;

endmodule
