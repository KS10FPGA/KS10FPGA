////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DZ11 Interrupt
//
// Details
//   The module implements the DZ11 interrupt controller.
//
// File
//   dzintr.v
//
// Notes
//   DZ11 interrupts are a little strange.
//
//   Please read the white pager entited "PDP-11 Interrupts: Variations On A
//   Theme", Bob Supnik, 03-Feb-2002 [revised 20-Feb-2004]
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

module DZINTR (
      input  wire clk,                  // Clock
      input  wire rst,                  // Reset
      input  wire clr,                  // Clear
      input  wire iack,                 // Interrupt acknowledge
      input  wire vectREAD,             // Interrupt vector cycle
      output reg  rxVECTOR,             // RX Vector
      input  wire csrRIE,               // RX Interrupt enable
      input  wire csrRRDY,              // RX Interrupt set
      input  wire rbufREAD,             // RX Interrupt done
      output wire rxINTR,               // RX Interrupt out
      input  wire csrTIE,               // TX Interrupt enable
      input  wire csrTRDY,              // TX Interrupt set
      input  wire tdrWRITE,             // TX Interrupt done
      output wire txINTR                // TX Interrupt out
   );

   localparam [3:0] stateIDLE     = 0,
                    stateACT      = 1,
                    stateWAIT     = 2,
                    stateIACK     = 3,
                    stateVECTREAD = 4,
                    stateVECTCLR  = 5,
                    stateRXDONE   = 6,
                    stateTXDONE   = 7,
                    stateDONE     = 8;

   //
   // RX Interrupt State Machine
   //
   // Notes:
   //  - The receiver interrupt clears when the interrupt is acknowledged.
   //  - The receiver interrupt is complete and can be retriggered when
   //    the RBUF has been read.
   //  - Once the interrupt is set, the only way to clear the interrupt is
   //    to initialize the DZ11 with a CSR[CLR] command or issue an IO Bus
   //    initialization command UBASR[INI].  Clearing the interrupt enable
   //    (csrRIE) will block the interrupt but not clear the flip-flop.
   //

   reg [3:0] rxstate;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rxstate <= stateIDLE;
        else
          begin
             if (clr)
               rxstate <= stateIDLE;
             else
               case (rxstate)
                 stateIDLE:
                   if (csrRRDY & csrRIE)
                     rxstate <= stateACT;
                 stateACT:
                   if (rxclr)
                     rxstate <= stateWAIT;
                 stateWAIT:
                   if (rbufREAD)
                     rxstate <= stateDONE;
                 stateDONE:
                   if (!rbufREAD)
                     rxstate <= stateIDLE;
               endcase
          end
     end

   assign rxINTR = (rxstate == stateACT) & csrRIE;

   //
   // TX Interrupt State Machine
   //
   // Notes:
   //  - The transmitter interrupt clears when the interrupt is acknowledged.
   //  - The transmitter interrupt is complete and can be retriggered when
   //    the TDR has been written.
   //  - Once the interrupt is set, the only way to clear the interrupt is
   //    to initialize the DZ11 with a CSR[CLR] command or issue an IO Bus
   //    initialization command UBASR[INI].  Clearing the interrupt enable
   //    (csrTIE) will block the interrupt but not clear the flip-flop.
   //

   reg [3:0] txstate;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          txstate <= stateIDLE;
        else
          begin
             if (clr)
               txstate <= stateIDLE;
             else
               case (txstate)
                 stateIDLE:
                   if (csrTRDY & csrTIE)
                     txstate <= stateACT;
                 stateACT:
                   if (txclr)
                     txstate <= stateWAIT;
                 stateWAIT:
                   if (tdrWRITE)
                     txstate <= stateDONE;
                 stateDONE:
                   if (!tdrWRITE)
                     txstate <= stateIDLE;
               endcase
          end
     end

   assign txINTR = (txstate == stateACT) & csrTIE;

   //
   // Arbiter
   //
   // Details:
   //   The receiver interrupt has priority over the transmitter interrupt.
   //   When the interrupt is acknowledged the receiver interrupt output is
   //   sampled and the interrupt controller commits to either a transmitter
   //   interrupt or a receiver interrupt.
   //
   //   If the receiver interrupt is asserted, the interrupt controller will
   //   assert the rxVECTOR signal to indicate that a receiver interrupt vector
   //   should be generated during the interrupt vector request bus cycle and
   //   the state machine will resample the receiver interrupt input after a
   //   read from the RBUF has been performed.
   //
   //   If the receiver interrupt output is not asserted, the interrupt
   //   controller will negate the the rxVECTOR signal to indicate that a
   //   transmitter interrupt vector should be generated during the interrupt
   //   vector request bus cycle and the state machine will resample the
   //   transmitter interrupt input after a write to the TDR has been performed.
   //
   //   In other words, the a transmitter interrupt can start the interrupt but
   //   if a receiver interrupt comes before the interrupt is acknowledged, the
   //   receiver interrupt take priority.  If the receiver interrupt comes
   //   along after the interrupt is acknowledged, the transmitter interrupt
   //   will be processed first.
   //

   reg [3:0] arbstate;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             rxVECTOR <= 0;
             arbstate <= stateIDLE;
          end
        else
          begin
             if (clr)
               begin
                  rxVECTOR <= 0;
                  arbstate <= stateIDLE;
               end
             else
               case (arbstate)
                 stateIDLE:
                   if ((rxstate == stateACT) | (txstate == stateACT))
                     arbstate <= stateIACK;
                 stateIACK:
                   if (iack)
                     begin
                        rxVECTOR <= rxINTR;
                        arbstate <= stateVECTREAD;
                     end
                 stateVECTREAD:
                   if (vectREAD)
                     arbstate <= stateVECTCLR;
                 stateVECTCLR:
                   if (!vectREAD)
                     arbstate <= rxVECTOR ? stateRXDONE : stateTXDONE;
                 stateRXDONE:
                   arbstate <= stateIDLE;
                 stateTXDONE:
                   arbstate <= stateIDLE;
               endcase
          end
     end

   wire rxclr = (arbstate == stateRXDONE);
   wire txclr = (arbstate == stateTXDONE);

endmodule
