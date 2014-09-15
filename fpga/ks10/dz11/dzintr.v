////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DZ11 Interrupt
//
// Details
//   The module implements a DZ11 interrupt.
//
// File
//   dzintr.v
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

  module DZINTR(clk, rst, clr, rxen, txen, rxin, txin, ack, vect, rxout, txout);

   input  clk;                          // Clock
   input  rst;                          // Reset
   input  clr;                          // Clear
   input  rxen;                         // RX Interrupt enable
   input  txen;                         // TX Interrupt enable
   input  rxin;                         // RX Interrupt input
   input  txin;                         // TX Interrupt input
   input  ack;                          // Interrupt ACK
   input  vect;                         // Interrupt vector cycle
   output rxout;                        // RX Interrupt out
   output txout;                        // TX Interrupt out

   localparam [2:0] stateIDLE    = 0,
                    stateACT     = 1,
                    stateWAIT    = 2,
                    stateACK     = 3,
                    stateVECT    = 4,
                    stateVECTCLR = 5,
                    stateRXDONE  = 6,
                    stateTXDONE  = 7;

   //
   // RX Interrupt State Machine
   //

   reg [2:0] rxstate;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rxstate <= stateIDLE;
        else
          begin
             if (!rxen)
               rxstate <= stateIDLE;
             else
               case (rxstate)
                 stateIDLE:
                   if (rxin)
                     rxstate <= stateACT;
                 stateACT:
                   if (rxclr)
                     rxstate <= stateWAIT;
                 stateWAIT:
                   if (!rxin)
                     rxstate <= stateIDLE;
               endcase
          end
     end

   wire rxout = (rxstate == stateACT);

   //
   // TX Interrupt State Machine
   //

   reg [2:0] txstate;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          txstate <= stateIDLE;
        else
          begin
             if (!txen)
               txstate <= stateIDLE;
             else
               case (txstate)
                 stateIDLE:
                   if (txin)
                     txstate <= stateACT;
                 stateACT:
                   if (txclr)
                     txstate <= stateWAIT;
                 stateWAIT:
                   if (!txin)
                     txstate <= stateIDLE;
               endcase
          end
     end

   wire txout = (txstate == stateACT);

   //
   // Arbiter
   //

   reg [2:0] arbstate;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          arbstate <= stateIDLE;
        else
          begin
             case (arbstate)
               stateIDLE:
                 if ((rxstate == stateACT) | (txstate == stateACT))
                   arbstate <= stateACK;
               stateACK:
                 if (ack)
                   arbstate <= stateVECT;
               stateVECT:
                 if (vect)
                   arbstate <= stateVECTCLR;
               stateVECTCLR:
                 if (!vect)
                   begin
                      if (rxstate == stateACT)
                        arbstate <= stateRXDONE;
                      else if (txstate == stateACT)
                        arbstate <= stateTXDONE;
                   end
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
