////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   UBA Non-existent Device State Machine
//
// Details
//   This module implements the NXD detection timeout timer state machine.
//
// File
//   ubanxd.v
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

module UBANXD (
      input  wire clk,                          // Clock
      input  wire rst,                          // Reset
      input  wire busREQI,                      // Bus Request
      output wire busACKO,                      // Bus Acknowledge
      input  wire devREQ,                       // DEV Request
      input  wire devACK,                       // DEV Ack
      input  wire ubaACK,                       // UBA Ack
      input  wire wruACK,                       // WRU Ack
      output wire setNXD                        // Set NXD
   );

   localparam [0:3] timeout = 4'd15;

   localparam [0:1] stateIDLE = 0,
                    stateDLY  = 1,
                    stateNXD  = 2,
                    stateACK  = 3;

   reg [0:3] counter;
   reg [0:1] state;

   always @(posedge clk)
     begin
        if (rst)
          begin
             counter <= 0;
             state   <= stateIDLE;
          end
        else
          case (state)
            stateIDLE:
              begin
                 if ((busREQI & ubaACK) | (busREQI & wruACK))
                   state <= stateACK;
                 else if (busREQI & devREQ)
                   if (devACK)
                     state <= stateACK;
                   else
                     begin
                        counter <= timeout;
                        state   <= stateDLY;
                     end
              end
            stateDLY:
              if (devACK)
                state <= stateACK;
              else if (counter != 0)
                counter <= counter - 1'b1;
              else
                state <= stateNXD;
            stateACK:
              if (!busREQI)
                state <= stateIDLE;
            stateNXD:
              state <= stateIDLE;
          endcase
     end

   assign setNXD  = (state == stateNXD);
   assign busACKO = (state == stateACK);

endmodule
