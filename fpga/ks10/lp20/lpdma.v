////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   LP20 Controller State Machine
//
// Details
//   The module implements the LP20 Controller
//
// File
//   lpctrl.v
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

`include "lpcsra.vh"

module LPDMA (
      input  wire         clk,          // Clock
      input  wire         rst,          // Reset
      output reg          devREQO,      // Device request
      input  wire         devACKI,      // Device acknowledge
      input  wire [35: 0] lpDATAI,      // Device data
      input  wire         lpDONE,       // BCTR is zero
      input  wire         lpTESTMSYN,   // DMA Acknowledge Timeout Test
      input  wire         lpTESTMPE,    // Memory Parity Error Test
      input  wire         lpERR,        // Composite error
      input  wire         lpCMDGO,      // Go command
      input  wire         lpCMDSTOP,    // Stop command
      input  wire         lpREADY,      // Printer is ready for more
      output reg          lpGO,         // DMA is running
      output wire         lpSETMPE,     // Memory parity error
      output wire         lpSETMSYN,    // IO Bus Timeout
      output reg          lpINCR        // Increment BAR, BCTR, and ADDR
   );

   //
   // State Definition
   //

   localparam [3:0] stateIDLE    = 0,   // Idle
                    stateWAIT    = 1,   // Wait to start
                    stateREADY   = 2,   // Wait for lpREADY
                    stateREAD    = 3,   // Read data
                    stateNEXT    = 4,   // Update counters
                    stateCHECK   = 5,   // Check for done
                    stateACKFAIL = 6,   // Ack timeout
                    stateDONE    = 7;   // Done

   //
   // State Machine
   //

   reg [ 8:0] timer;
   reg [ 3:0] state;

   always @(posedge clk)
     begin
        if (rst)
          begin
             lpGO    <= 0;
             timer   <= 255;
             devREQO <= 0;
             lpINCR  <= 0;
             state   <= stateIDLE;
          end
        else
          begin

             lpINCR  <= 0;
             devREQO <= 0;

             //
             // Stop command
             //  Unconditionally go to IDLE state
             //

             if (lpCMDSTOP)
               begin
                  lpGO  <= 0;
                  state <= stateIDLE;
               end

             else
               begin
                  case (state)

                    //
                    // stateIDLE
                    //  Wait for a command
                    //

                    stateIDLE:

                      //
                      // GO command received.  Process it.
                      //

                      if (lpCMDGO & !lpERR)
                        begin
                           lpGO  <= 1;
                           state <= stateWAIT;
                        end

                    //
                    // stateWAIT
                    //  Wait for GO to negate
                    //

                    stateWAIT:
                      if (!lpCMDGO)
                        state <= stateREADY;

                    //
                    // stateREADY
                    //  Wait for READY to assert
                    //

                    stateREADY:
                      if (lpREADY)
                        begin
                           devREQO <= 1;
                           timer   <= 255;
                           state   <= stateREAD;
                        end

                    //
                    // stateREAD
                    //  Wait for bus acknowledge
                    //  Capture data
                    //  Timeout if no ACK
                    //
                    //  Ignore the ACK when testing MSYN
                    //

                    stateREAD:
                      begin
                         if (devACKI & !lpTESTMSYN)
                           begin
                              devREQO <= 0;
                              lpINCR  <= 1;
                              state   <= stateNEXT;
                           end
                         else if (timer == 0)
                           begin
                              devREQO <= 0;
                              state   <= stateACKFAIL;
                           end
                         else
                           begin
                              devREQO <= 1;
                              timer   <= timer - 1'b1;
                           end
                      end

                    //
                    // stateNEXT
                    //  Update BAR
                    //  Update CCTR
                    //

                    stateNEXT:
                      begin
                         state <= stateCHECK;
                      end

                    //
                    // stateCHECK
                    //  See if we're done.
                    //

                    stateCHECK:
                      if (lpDONE)
                        state <= stateDONE;
                      else
                        state <= stateREADY;

                    //
                    // stateACKFAIL
                    //  Timed out wait for a bus acknowledge
                    //

                    stateACKFAIL:
                      state <= stateDONE;

                    //
                    // stateDONE
                    //  All done
                    //

                    stateDONE:
                      begin
                         lpGO  <= 0;
                         state <= stateIDLE;
                      end

                  endcase
               end
          end
     end

   //
   // IO Bus Timeout
   //
   // Trace
   //  M8586/LPC3/E55
   //  M8586/LPC3/E56
   //

   assign lpSETMSYN = (state == stateACKFAIL);

   //
   // Memory Parity Error Test
   //
   // Trace
   //  M8586/LPC7/E64
   //

   assign lpSETMPE = (state == stateREAD) & lpTESTMPE;

endmodule
