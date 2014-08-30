////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Double Buffered UART Transmitter
//
// Details
//   The UART Receiver is hard configured for:
//   - 8 data bits
//   - no parity
//   - 1 stop bit
//
// Note
//   This UART primitive receiver is kept simple intentionally and is
//   therefore unbuffered.  If you require a double buffered UART, then you
//   will need to layer a set of buffers on top of this device.
//
// File
//   uart_rx.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2009-2014 Rob Doyle
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

module UART_RX(clk, rst, clkBR, rxd, intr, data);

   input        clk;                    // Clock
   input        rst;                    // Reset
   input        clkBR;                  // Clock Enable from BRG
   input        rxd;                    // Receiver Serial Data
   output       intr;                   // Data ready
   output [7:0] data;                   // Received Data

   //
   // State machine states
   //

   parameter [3:0] stateIDLE  =  0,     // Idle
                   stateSYNC  =  1,     // Wait for Start Bit
                   stateSTART =  2,     // Working on Start Bit
                   stateBIT0  =  3,     // Working on Bit 7
                   stateBIT1  =  4,     // Working on Bit 6
                   stateBIT2  =  5,     // Working on Bit 5
                   stateBIT3  =  6,     // Working on Bit 4
                   stateBIT4  =  7,     // Working on Bit 3
                   stateBIT5  =  8,     // Working on Bit 2
                   stateBIT6  =  9,     // Working on Bit 1
                   stateBIT7  = 10,     // Working on Bit 0
                   stateSTOP  = 11,     // Working on Stop Bit
                   stateDONE  = 12;     // Generate Interrupt

   //
   // Synchronize the Received Data to this clock domain.
   //

   reg temp;
   reg rxdd;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             temp <= 1;
             rxdd <= 1;
          end
        else
          begin
             temp <= rxd;
             rxdd <= temp;
          end
     end

   //
   // UART Receiver
   //
   // Details
   //   The clkBR is 16 clocks per bit.  The UART receives LSB first.
   //
   //   The state machine is initialized to the idle state where it
   //   looks for a start bit.  When it find the 'edge' of the start
   //   bit starts the state machine which does the following:
   //
   //    - Continuously sample the start bit for half a bit period.
   //      If the start bit is narrower than half a bit then, go back
   //      to the idle state and look for a real start bit.   Othewise,
   //    - Delay one bit time from the middle of the Start bit and
   //      sample bit D7 (LSB), then
   //    - Delay one bit time from the middle of D7 and sample bit D6, then
   //    - Delay one bit time from the middle of D6 and sample bit D5, then
   //    - Delay one bit time from the middle of D5 and sample bit D4, then
   //    - Delay one bit time from the middle of D4 and sample bit D3, then
   //    - Delay one bit time from the middle of D3 and sample bit D2, then
   //    - Delay one bit time from the middle of D2 and sample bit D1, then
   //    - Delay one bit time from the middle of D1 and sample bit D0, then
   //    - Delay one bit time from the middle of D0 and sample Stop
   //       Bit, then
   //    - Generate INTR pulse for one clock cycle, then
   //    - Go back to idle state and wait for a start bit.
   //

   reg [3:0] state;
   reg [7:0] rxREG;
   reg [3:0] brdiv;

   always @(posedge clk or posedge rst)
     begin

        if (rst)

          begin
             state <= stateIDLE;
             rxREG <= 0;
             brdiv <= 0;
          end

        else

          case (state)

            //
            // Receiver is waiting for IDLE condition
            //

            stateIDLE:
              begin
                 if (rxdd)
                   begin
                      state <= stateSYNC;
                   end
              end

            //
            // Wait for edge of Start bit
            //

            stateSYNC:
              begin
                 if (clkBR)
                   begin
                      if (~rxdd)
                        begin
                           state <= stateSTART;
                           brdiv <= 8;
                        end
                   end
              end

            //
            // Receive Start Bit
            //

            stateSTART:
              begin
                 if (clkBR)
                   begin
                      if (~rxdd)
                        begin
                           if (brdiv == 0)
                             begin
                                brdiv <= 15;
                                state <= stateBIT0;
                             end
                           else
                             begin
                                brdiv <= brdiv - 1'b1;
                             end
                        end
                      else
                        begin
                           state <= stateIDLE;
                        end
                   end
              end

            //
            // Receive Bit 0 (LSB)
            //

            stateBIT0:
              begin
                 if (clkBR)
                   begin
                      if (brdiv == 0)
                        begin
                           brdiv <= 15;
                           rxREG <= {rxdd, rxREG[7:1]};
                           state <= stateBIT1;
                        end
                      else
                        begin
                           brdiv <= brdiv - 1'b1;
                        end
                   end
              end

            //
            // Receive Bit 1
            //

            stateBIT1:
              begin
                 if (clkBR)
                   begin
                      if (brdiv == 0)
                        begin
                           brdiv <= 15;
                           rxREG <= {rxdd, rxREG[7:1]};
                           state <= stateBIT2;
                        end
                      else
                        begin
                           brdiv <= brdiv - 1'b1;
                        end
                   end
              end

            //
            // Receive Bit 2
            //

            stateBIT2:
              begin
                 if (clkBR)
                   begin
                      if (brdiv == 0)
                        begin
                           brdiv <= 15;
                           rxREG <= {rxdd, rxREG[7:1]};
                           state <= stateBIT3;
                        end
                      else
                        begin
                           brdiv <= brdiv - 1'b1;
                        end
                   end
              end

            //
            // Receive Bit 3
            //

            stateBIT3:
              begin
                 if (clkBR)
                   begin
                      if (brdiv == 0)
                        begin
                           brdiv <= 15;
                           rxREG <= {rxdd, rxREG[7:1]};
                           state <= stateBIT4;
                        end
                      else
                        begin
                           brdiv <= brdiv - 1'b1;
                        end
                   end
              end

            //
            // Receive Bit 4
            //

            stateBIT4:
              begin
                 if (clkBR)
                   begin
                      if (brdiv == 0)
                        begin
                           brdiv <= 15;
                           rxREG <= {rxdd, rxREG[7:1]};
                           state <= stateBIT5;
                        end
                      else
                        begin
                           brdiv <= brdiv - 1'b1;
                        end
                   end
              end

            //
            // Receive Bit 5
            //

            stateBIT5:
              begin
                 if (clkBR)
                   begin
                      if (brdiv == 0)
                        begin
                           brdiv <= 15;
                           rxREG <= {rxdd, rxREG[7:1]};
                           state <= stateBIT6;
                        end
                      else
                        begin
                           brdiv <= brdiv - 1'b1;
                        end
                   end
              end

            //
            // Receive Bit 6
            //

            stateBIT6:
              begin
                 if (clkBR)
                   begin
                      if (brdiv == 0)
                        begin
                           brdiv <= 15;
                           rxREG <= {rxdd, rxREG[7:1]};
                           state <= stateBIT7;
                        end
                      else
                        begin
                           brdiv <= brdiv - 1'b1;
                        end
                   end
              end

            //
            // Receive Bit 7 (MSB)
            //

            stateBIT7:
              begin
                 if (clkBR)
                   begin
                      if (brdiv == 0)
                        begin
                           brdiv <= 15;
                           rxREG <= {rxdd, rxREG[7:1]};
                           state <= stateSTOP;
                        end
                      else
                        begin
                           brdiv <= brdiv - 1'b1;
                        end
                   end
              end

            //
            // Receive Stop Bit
            //

            stateSTOP:
              begin
                 if (clkBR)
                   begin
                      if (brdiv == 0)
                        begin
                           if (rxdd)
                             state <= stateDONE;
                           else
                             state <= stateIDLE;
                        end
                      else
                        begin
                           brdiv <= brdiv - 1'b1;
                        end
                   end
              end

            //
            // Generate Interrupt
            //

            stateDONE:
              begin
                 state <= stateIDLE;
              end

            //
            // Everything else
            //

            default:
              begin
                 state <= stateIDLE;
              end

          endcase
     end

   assign intr = (state == stateDONE);
   assign data = rxREG;

endmodule
