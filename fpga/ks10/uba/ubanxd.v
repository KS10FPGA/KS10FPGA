////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   UBA Non-existent Device State Machine
//
// Details
//   This module implements the
//
// File
//   ubanxd.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2014 Rob Doyle
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

  module UBANXD(clk, rst, devINT, devEXT, devACKI, busREQI, busACKO, setNXD);

   input  clk;                                  // Clock
   input  rst;                                  // Reset
   input  devINT;                               // Device in on UBA Card
   input  devEXT;                               // Device is on IO Bus
   input  devACKI;                              // Device ACK
   input  busREQI;                              // Bus Request
   output busACKO;                              // Bus Acknowledge
   output setNXD;                               // Set NXD

   localparam [0:3] stateNULL =  0,
                    stateCNT0 =  1,
                    stateCNT1 =  2,
                    stateCNT2 =  3,
                    stateCNT3 =  4,
                    stateCNT4 =  5,
                    stateCNT5 =  6,
                    stateCNT6 =  7,
                    stateCNT7 =  8,
                    stateCNT8 =  9,
                    stateCNT9 = 10,
                    stateNXD  = 11,
                    stateACK  = 12;

   reg [0:3] state;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          state <= stateNULL;
        else
          case (state)

            stateNULL:
              if (busREQI & devINT)
                state <= stateACK;
              else if (busREQI & devEXT)
                state <= stateCNT0;

            stateCNT0:
              if (devACKI)
                state <= stateACK;
              else
                state <= stateCNT1;

            stateCNT1:
              if (devACKI)
                state <= stateACK;
              else
                state <= stateCNT2;

            stateCNT2:
              if (devACKI)
                state <= stateACK;
              else
                state <= stateCNT3;

            stateCNT3:
              if (devACKI)
                state <= stateACK;
              else
                state <= stateCNT4;

            stateCNT4:
              if (devACKI)
                state <= stateACK;
              else
                state <= stateCNT5;

            stateCNT5:
              if (devACKI)
                state <= stateACK;
              else
                state <= stateCNT6;

            stateCNT6:
              if (devACKI)
                state <= stateACK;
              else
                state <= stateCNT7;

            stateCNT7:
              if (devACKI)
                state <= stateACK;
              else
                state <= stateCNT8;

            stateCNT8:
              if (devACKI)
                state <= stateACK;
              else
                state <= stateCNT9;

            stateCNT9:
              if (devACKI)
                state <= stateACK;
              else
                state <= stateNXD;

            stateACK:
              if (!busREQI)
                state <= stateNULL;

            stateNXD:
              state <= stateNULL;

          endcase
     end

   assign setNXD  = (state == stateNXD);
   assign busACKO = (state == stateACK);

endmodule
