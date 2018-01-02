////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DUP11 Interrupt Controller
//
// Details
//   This file provides the implementation of the Interrupt Controller
//
// File
//   dupintr.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2018 Rob Doyle
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

module DUPINTR (
      input  wire         clk,          // Clock
      input  wire         rst,          // Reset
      input  wire         init,         // Initialize
      input  wire         vect,         // Read interrupt vector
      input  wire         statrw,       // Read/Write status register
      input  wire         trig,         // Trigger interrupt
      input  wire         secinh,       // Secondary Inhibit
      output wire         priact,       // Primary Active
      output wire         intr          // Interrupt request out
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
   //  - The interrupt request clears when the interrupt is acknowledged.
   //  - The interrupt is complete and can be retriggered only after
   //    the TXCSR has been written.
   //

   reg [2:0] state;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          state <= stateIDLE;
        else
          begin
             if (init)
               state <= stateIDLE;
             else
               case (state)

                 //
                 // stateIDLE
                 //  Wait for a interrupt
                 //

                 stateIDLE:
                   if (trig)
                     state <= stateACTIVE;

                 //
                 // stateACTIVE
                 //  Interrupt request is active.
                 //  Waiting for an interrupt vector read
                 //

                 stateACTIVE:
                   if (vect & !secinh)
                     state <= stateVECTREAD;

                 //
                 // stateVECTREAD
                 //  Interrupt vector read.  Waiting for it to clear.
                 //

                 stateVECTREAD:
                   if (!vect)
                     state <= stateWAIT;

                 //
                 // stateWAIT
                 //  Wait for status to be read.
                 //

                 stateWAIT:
                   if (statrw)
                     state <= stateDONE;

                 //
                 // stateDONE
                 //  Status read. Wait for read to complete.
                 //

                 stateDONE:
                   if (!statrw)
                     state <= stateIDLE;

               endcase
          end
     end

   //
   // Interrupt request
   //

   assign intr = ((state == stateACTIVE) || (state == stateVECTREAD));

   //
   // Primary active
   //

   assign priact = (state != stateIDLE);

endmodule
