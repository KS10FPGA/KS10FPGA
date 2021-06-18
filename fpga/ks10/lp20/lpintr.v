////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   LP20 Interrupt Controller
//
// Details
//   The module implements the LP20 Interrupt Controller
//
// File
//   lpintr.v
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

module LPINTR (
      input  wire         clk,          // Clock
      input  wire         rst,          // Reset
      input  wire         csraREAD,     // Read CSRA
      input  wire         lpINIT,       // Initialize
      input  wire         lpSETIRQ,     // Interrupt request
      input  wire         lpIACK,       // Read interrupt vector
      input  wire         lpIE,         // Interrupt enable
      output wire         lpINT         // Interrupt request
   );

   //
   // States
   //

   localparam [2:0] stateIDLE     = 0,
                    stateACTIVE   = 1,
                    stateVECTREAD = 2,
                    stateWAIT     = 3,
                    stateDONE     = 4;

   //
   // Interrupt State Machine
   //
   // Notes:
   //  - The interrupt request clears immediately after the interrupt is
   //    acknowledged.
   //  - The interrupt is complete and can be retriggered only after
   //    the CSRA has been read.
   //

   reg [2:0] state;

   always @(posedge clk)
     begin
        if (rst)
          state <= stateIDLE;
        else
          begin
             if (lpINIT)
               state <= stateIDLE;
             else
               case (state)

                 //
                 // stateIDLE
                 //  Wait for a interrupt
                 //

                 stateIDLE:
                   if (lpSETIRQ & lpIE)
                     state <= stateACTIVE;

                 //
                 // stateACTIVE
                 //  Interrupt request is active.
                 //  Waiting for an interrupt vector read
                 //

                 stateACTIVE:
                   if (lpIACK)
                     state <= stateVECTREAD;

                 //
                 // stateVECTREAD
                 //  Interrupt vector read.  Waiting for it to clear.
                 //

                 stateVECTREAD:
                   if (!lpIACK)
                     state <= stateWAIT;

                 //
                 // stateWAIT
                 //  Wait for status to be read.
                 //

                 stateWAIT:
                   if (csraREAD)
                     state <= stateDONE;

                 //
                 // stateDONE
                 //  Status read. Wait for read to complete.
                 //

                 stateDONE:
                   if (!csraREAD)
                     state <= stateIDLE;

               endcase
          end
     end

   //
   // Interrupt request
   //

   assign lpINT = (state == stateACTIVE || state == stateVECTREAD);

endmodule
