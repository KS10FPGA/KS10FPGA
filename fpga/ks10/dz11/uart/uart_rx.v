////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Generic unbuffered UART Receiver
//
// Details
//   This module implements a genereric unbuffered UART receiver.  Ports
//   control the character length (5 to 8 bits), parity (even/odd/none), and
//   number of stop bits (1 or 2).
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
// Copyright (C) 2009-2014 Rob Doyle
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
`include "../dzuart.vh"

module UART_RX(clk, rst, clr, length, stop, parity, rxd,  brgCLKEN, rfull,
               full, intr, data, pare, frme, ovre);

   input        clk;                    // Clock
   input        rst;                    // Reset
   input        clr;                    // Clear
   input        brgCLKEN;               // Clock enable from BRG
   input  [1:0] length;                 // Character length
   input        stop;                   // Number of stop bits
   input  [1:0] parity;                 // Receiver parity
   input        rxd;                    // Receiver serial data
   input        rfull;                  // Receiver reset full flag
   output       full;                   // Receiver full flag
   output       intr;                   // Receiver interrupt
   output [7:0] data;                   // Received data
   output       pare;                   // Receiver parity error
   output       frme;                   // Receiver framing error
   output       ovre;                   // Receiver overrun error

   //
   // State machine states
   //

   parameter [3:0] stateIDLE   =  0,    // Idle
                   stateSTART  =  1,    // Start Bit
                   stateBIT0   =  2,    // Data bit 0 (LSB)
                   stateBIT1   =  3,    // Data bit 1
                   stateBIT2   =  4,    // Data bit 2
                   stateBIT3   =  5,    // Data bit 3
                   stateBIT4   =  6,    // Data bit 4
                   stateBIT5   =  7,    // Data bit 5
                   stateBIT6   =  8,    // Data bit 6
                   stateBIT7   =  9,    // Data bit 7 (MSB)
                   statePARITY = 10,    // Parity bit
                   stateSTOP1  = 11,    // Stop bit 1
                   stateSTOP2  = 12,    // Stop bit 2
                   stateWAIT   = 13,    // Finish stop bit
                   stateDONE   = 14;    // Generate interrupt

   //
   // Synchronize the Received Data to this clock domain.
   //

   reg temp;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          temp <= 1;
        else
          temp <= rxd;
     end

   reg din;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          din <= 1;
        else
          din <= temp;
     end

   //
   // UART Receiver
   //
   // Details
   //   The brgCLKEN is 16 clocks per bit.  The UART receives LSB first.
   //
   //   The state machine is initialized to the idle state where it
   //   looks for a start bit.  When it find the 'edge' of the start
   //   bit starts the state machine which does the following:
   //
   //    - Continuously sample the start bit for half a bit period.
   //      If the start bit is narrower than half a bit then, go back
   //      to the idle state and look for a real start bit.   Otherwise,
   //    - Delay one bit time from the middle of the Start bit and
   //      sample bit D0 (LSB), then
   //    - Delay one bit time from the middle of D0 and sample bit D1 then
   //    - Delay one bit time from the middle of D1 and sample bit D2, then
   //    - Delay one bit time from the middle of D2 and sample bit D3, then
   //    - Delay one bit time from the middle of D3 and sample bit D4, then
   //    - Delay one bit time from the middle of D4 and sample bit D5, then
   //    - Delay one bit time from the middle of D5 and sample bit D6, then
   //    - Delay one bit time from the middle of D6 and sample bit D7, then
   //    - Delay one bit time from the middle of D7 and sample Stop
   //       Bit, then
   //    - Generate INTR pulse for one clock cycle, then
   //    - Go back to idle state and wait for a start bit.
   //

   reg [3:0] brdiv;
   reg [7:0] rxREG;
   reg       pare;
   reg       frme;
   reg       ovre;
   reg [3:0] state;

   always @(posedge clk or posedge rst)
     begin

        if (rst)
          begin
             brdiv <= 0;
             rxREG <= 0;
             pare  <= 0;
             frme  <= 0;
             ovre  <= 0;
             state <= stateIDLE;
          end

        else

          if (clr)
            begin
               brdiv <= 0;
               rxREG <= 0;
               pare  <= 0;
               frme  <= 0;
               ovre  <= 0;
               state <= stateIDLE;
            end

          else

            case (state)

              //
              // Wait for edge of Start bit
              //

              stateIDLE:
                if (brgCLKEN & !din)
                  begin
                     state <= stateSTART;
                     brdiv <= 7;
                  end

              //
              // Receive start bit
              //

              stateSTART:
                if (brgCLKEN)
                  if (!din)
                    if (brdiv == 0)
                      begin
                         brdiv <= 15;
                         rxREG <= 0;
                         pare  <= 0;
                         frme  <= 0;
                         ovre  <= 0;
                         state <= stateBIT0;
                      end
                    else
                      brdiv <= brdiv - 1'b1;
                  else
                    state <= stateIDLE;

              //
              // Receive data bit 0 (LSB)
              //

              stateBIT0:
                if (brgCLKEN)
                  if (brdiv == 0)
                    begin
                       brdiv <= 15;
                       rxREG <= {din, rxREG[7:1]};
                       state <= stateBIT1;
                    end
                  else
                    brdiv <= brdiv - 1'b1;

              //
              // Receive data bit 1
              //

              stateBIT1:
                if (brgCLKEN)
                  if (brdiv == 0)
                    begin
                       brdiv <= 15;
                       rxREG <= {din, rxREG[7:1]};
                       state <= stateBIT2;
                    end
                  else
                    brdiv <= brdiv - 1'b1;

              //
              // Receive data bit 2
              //

              stateBIT2:
                if (brgCLKEN)
                  if (brdiv == 0)
                    begin
                       brdiv <= 15;
                       rxREG <= {din, rxREG[7:1]};
                       state <= stateBIT3;
                    end
                  else
                    brdiv <= brdiv - 1'b1;

              //
              // Receive data bit 3
              //

              stateBIT3:
                if (brgCLKEN)
                  if (brdiv == 0)
                    begin
                       brdiv <= 15;
                       rxREG <= {din, rxREG[7:1]};
                       state <= stateBIT4;
                    end
                  else
                    brdiv <= brdiv - 1'b1;

              //
              // Receive Bit 4
              //

              stateBIT4:
                if (brgCLKEN)
                  if (brdiv == 0)
                    begin
                       brdiv <= 15;
                       if (length == `UARTLEN_5)
                         begin
                            rxREG <= {3'b000, din, rxREG[7:4]};
                            if ((parity == `UARTPAR_EVEN) ||
                                (parity == `UARTPAR_ODD ))
                              state <= statePARITY;
                            else
                              state <= stateSTOP1;
                         end
                       else
                         begin
                            rxREG <= {din, rxREG[7:1]};
                            state <= stateBIT5;
                         end
                    end
                  else
                    brdiv <= brdiv - 1'b1;

              //
              // Receive data bit 5
              //

              stateBIT5:
                if (brgCLKEN)
                  if (brdiv == 0)
                    begin
                       brdiv <= 15;
                       if (length == `UARTLEN_6)
                         begin
                            rxREG <= {2'b00, din, rxREG[7:3]};
                            if ((parity == `UARTPAR_EVEN) ||
                                (parity == `UARTPAR_ODD ))
                              state <= statePARITY;
                            else
                              state <= stateSTOP1;
                         end
                       else
                         begin
                            rxREG <= {din, rxREG[7:1]};
                            state <= stateBIT6;
                         end
                    end
                  else
                    brdiv <= brdiv - 1'b1;

              //
              // Receive data bit 6
              //

              stateBIT6:
                if (brgCLKEN)
                  if (brdiv == 0)
                    begin
                       brdiv <= 15;
                       if (length == `UARTLEN_7)
                         begin
                            rxREG <= {1'b0, din, rxREG[7:2]};
                            if ((parity == `UARTPAR_EVEN) ||
                                (parity == `UARTPAR_ODD ))
                              state <= statePARITY;
                            else
                              state <= stateSTOP1;
                         end
                       else
                         begin
                            rxREG <= {din, rxREG[7:1]};
                            state <= stateBIT7;
                         end
                    end
                  else
                    brdiv <= brdiv - 1'b1;

              //
              // Receive data bit 7 (MSB)
              //

              stateBIT7:
                if (brgCLKEN)
                  if (brdiv == 0)
                    begin
                       brdiv <= 15;
                       rxREG <= {din, rxREG[7:1]};
                       if ((parity == `UARTPAR_EVEN) ||
                           (parity == `UARTPAR_ODD ))
                         state <= statePARITY;
                       else
                         state <= stateSTOP1;
                    end
                  else
                    brdiv <= brdiv - 1'b1;

              //
              // Receive parity bit
              //  Check parity
              //

              statePARITY:
                if (brgCLKEN)
                  if (brdiv == 0)
                    begin
                       if (parity == `UARTPAR_EVEN)
                         pare <= (din == (rxREG[0] ^ rxREG[1] ^ rxREG[2] ^
                                          rxREG[3] ^ rxREG[4] ^ rxREG[5] ^
                                          rxREG[6] ^ rxREG[7]));
                       else
                         pare <= (din != (rxREG[0] ^ rxREG[1] ^ rxREG[2] ^
                                          rxREG[3] ^ rxREG[4] ^ rxREG[5] ^
                                          rxREG[6] ^ rxREG[7]));
                       brdiv <= 15;
                       state <= stateSTOP1;
                    end
                  else
                    brdiv <= brdiv - 1'b1;

              //
              // Receive Stop Bit 1
              //  Check framing error
              //

              stateSTOP1:
                if (brgCLKEN)
                  if (brdiv == 0)
                    begin
                       if (!din)
                         frme <= 1;
                       if (stop == `UARTSTOP_2)
                         begin
                            brdiv <= 15;
                            state <= stateSTOP2;
                         end
                       else
                         begin
                            brdiv <= 7;
                            state <= stateWAIT;
                         end
                    end
                  else
                    brdiv <= brdiv - 1'b1;

              //
              // Receive Stop Bit 2
              //  Check framing error
              //

              stateSTOP2:
                if (brgCLKEN)
                  if (brdiv == 0)
                    begin
                       if (!din)
                         frme <= 1;
                       brdiv <= 7;
                       state <= stateWAIT;
                    end
                  else
                    brdiv <= brdiv - 1'b1;

              //
              // Delay to end of last stop bit
              //  This is half of a bit period
              //

              stateWAIT:
                if (brgCLKEN)
                  if (brdiv == 0)
                    state <= stateDONE;
                  else
                    brdiv <= brdiv - 1'b1;

              //
              // Generate Interrupt
              //

              stateDONE:
                state <= stateIDLE;

              //
              // Everything else
              //

              default:
                state <= stateIDLE;

            endcase
     end

   //
   // Full flag
   //

   reg full;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          full <= 0;
        else
          begin
             if (rfull | clr)
               full <= 0;
             else if (state == stateDONE)
               full <= 1;
          end
     end

   //
   // Create outputs
   //

   assign intr = (state == stateDONE);
   assign data = rxREG;

endmodule
