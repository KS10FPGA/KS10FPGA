////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RH11 Completion Monitor
//
// Details
//   The module implements the RH11 completion monitor.  The Completion Monitor
//   scans the disk drives (round robbin) and checks for drives that are
//   requesting access to the SD Controller.
//
// File
//   rhscan.v
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

module RHSCAN (
      input  wire       clk,                    // Clock
      input  wire       rst,                    // Reset
      input  wire [7:0] sdREQ,                  // SD Request
      output reg  [7:0] sdACK,                  // SD Acknowledge
      output reg  [2:0] scan                    // Scan
   );

   //
   // States
   //

   localparam [2:0] stateIDLE = 0,
                    stateBUSY = 1,
                    stateDONE = 2;

   //
   // Scanner
   //

   reg [2:0] state;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             scan  <= 0;
             sdACK <= 0;
             state <= stateIDLE;
          end
        else
          case (state)

            //
            // IDLE
            //  Scan for an SD Reqest from the RPxx.  Acknowledge it if one is found.
            //

            stateIDLE:
              begin
                 if (sdREQ[scan])
                   begin
                      case (scan)
                        0: sdACK <= 8'b0000_0001;
                        1: sdACK <= 8'b0000_0010;
                        2: sdACK <= 8'b0000_0100;
                        3: sdACK <= 8'b0000_1000;
                        4: sdACK <= 8'b0001_0000;
                        5: sdACK <= 8'b0010_0000;
                        6: sdACK <= 8'b0100_0000;
                        7: sdACK <= 8'b1000_0000;
                      endcase
                      state <= stateBUSY;
                   end
                 else
                   scan <= scan + 1'b1;
              end

            //
            // BUSY
            //  Wait while the RPxx is busy.
            //

            stateBUSY:
              begin
                 if (!sdREQ[scan])
                   begin
                      sdACK <= 0;
                      state <= stateDONE;
                   end
              end

            //
            // Cycle back to IDLE.
            //

            stateDONE:
              begin
                 state <= stateIDLE;
              end
          endcase
     end

endmodule
