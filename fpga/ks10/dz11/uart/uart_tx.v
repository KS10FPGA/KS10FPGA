////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Generic unbufffered UART transmitter
//
// Details
//   This module implements a genereric unbuffered UART transmitter.  Ports
//   control the character length (5 to 8 bits), parity (even/odd/none), and
//   number of stop bits (1 or 2).
//
// Note
//   This UART primitive transmitter is kept simple intentionally and is
//   therefore unbuffered.  If you require a double buffered UART, then you
//   will need to layer a set of buffers on top of this device.
//
// File
//   uart_tx.vhd
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2009-2016 Rob Doyle
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

`include "../dzuart.vh"

module UART_TX (
      input  wire       clk,            // Clock
      input  wire       rst,            // Reset
      input  wire       clr,            // Clear
      input  wire [1:0] length,         // Character length
      input  wire [1:0] parity,         // Parity
      input  wire       stop,           // Number of stop bits
      input  wire       brgCLKEN,       // Clock enable from BRG
      input  wire [7:0] data,           // Transmitter data
      input  wire       load,           // Load transmitter
      output wire       empty,          // Transmitter buffer empty
      output wire       intr,           // Transmitter interrupt
      output wire       txd             // Transmitter serial data
   );

   //
   // State machine states
   //

   parameter [3:0] stateIDLE    =  0,   // Idle
                   stateSYNC    =  1,   // Sync
                   stateSTART   =  2,   // Start bit
                   stateBIT0    =  3,   // Data bit 0 (LSB)
                   stateBIT1    =  4,   // Data bit 1
                   stateBIT2    =  5,   // Data bit 2
                   stateBIT3    =  6,   // Data bit 3
                   stateBIT4    =  7,   // Data bit 4
                   stateBIT5    =  8,   // Data bit 5
                   stateBIT6    =  9,   // Data bit 6
                   stateBIT7    = 10,   // Data bit 7 (MSB)
                   statePARITY  = 11,   // Parity bit
                   stateSTOP1   = 12,   // Stop bit 1
                   stateSTOP2   = 13,   // Stop bit 2
                   stateDONE    = 14;   // Generate Interrupt

   //
   // UART Transmitter:
   //
   // Details
   //   The brgCLKEN is 16 clocks per bit.  The UART transmits LSB first.
   //
   //   When the load input is asserted, the data is loaded into the
   //   Transmit Register and the state machine is started.
   //
   //   Once the state machine is started, it proceeds as follows:
   //
   //    - Send Start Bit, then
   //    - Send data bit 0 (LSB)
   //    - Send data bit 1
   //    - Send data bit 2
   //    - Send data bit 3
   //    - Send data bit 4
   //    - Send data bit 5
   //    - Send data bit 6
   //    - Send data bit 7 (MSB)
   //    - Send parity bit
   //    - Send stop bit 1
   //    - Send stop bit 2
   //    - Trigger Interrupt output
   //
   // Note
   //   Some states will be skipped depending on the configuration.
   //

   reg [3:0] state;
   reg [7:0] txREG;
   reg [3:0] brdiv;

   always @(posedge clk or posedge rst)
     begin

        if (rst)
          begin
             txREG <= 0;
             brdiv <= 0;
             state <= stateIDLE;
          end

        else

          if (clr)
            begin
               txREG <= 0;
               brdiv <= 0;
               state <= stateIDLE;
            end

          else

            case (state)

              //
              // Transmitter is idle
              //

              stateIDLE:
                if (load)
                  begin
                     txREG <= data;
                     state <= stateSYNC;
                  end

              //
              // Wait for clock
              //

              stateSYNC:
               if (brgCLKEN)
                 begin
                    brdiv <= 15;
                    state <= stateSTART;
                 end

              //
              // Transmit Start Bit
              //

              stateSTART:
                if (brgCLKEN)
                  if (brdiv == 0)
                    begin
                       brdiv <= 15;
                       state <= stateBIT0;
                    end
                  else
                    brdiv <= brdiv - 1'b1;

              //
              // Transmit Bit 0 (LSB)
              //

              stateBIT0:
                if (brgCLKEN)
                  if (brdiv == 0)
                    begin
                       brdiv <= 15;
                       state <= stateBIT1;
                    end
                  else
                    brdiv <= brdiv - 1'b1;

              //
              // Transmit Bit 1
              //

              stateBIT1:
                if (brgCLKEN)
                  if (brdiv == 0)
                    begin
                       brdiv <= 15;
                       state <= stateBIT2;
                    end
                  else
                    brdiv <= brdiv - 1'b1;

              //
              // Transmit Bit 2
              //

              stateBIT2:
                if (brgCLKEN)
                  if (brdiv == 0)
                    begin
                       brdiv <= 15;
                       state <= stateBIT3;
                    end
                  else
                    brdiv <= brdiv - 1'b1;

              //
              // Transmit Bit 3
              //

              stateBIT3:
                if (brgCLKEN)
                  if (brdiv == 0)
                    begin
                       brdiv <= 15;
                       state <= stateBIT4;
                    end
                  else
                    brdiv <= brdiv - 1'b1;

              //
              // Transmit Bit 4
              //

              stateBIT4:
                if (brgCLKEN)
                  if (brdiv == 0)
                    begin
                       brdiv <= 15;
                       if (length == `UARTLEN_5)
                         begin
                            if ((parity == `UARTPAR_EVEN) ||
                                (parity == `UARTPAR_ODD ))
                              state <= statePARITY;
                            else
                              state <= stateSTOP1;
                         end
                       else
                         state <= stateBIT5;
                    end
                  else
                    brdiv <= brdiv - 1'b1;

              //
              // Transmit Bit 5
              //

              stateBIT5:
                if (brgCLKEN)
                  if (brdiv == 0)
                    begin
                       brdiv <= 15;
                       if (length == `UARTLEN_6)
                         begin
                            if ((parity == `UARTPAR_EVEN) ||
                                (parity == `UARTPAR_ODD ))
                              state <= statePARITY;
                            else
                              state <= stateSTOP1;
                         end
                       else
                         state <= stateBIT6;
                    end
                  else
                    brdiv <= brdiv - 1'b1;

              //
              // Transmit Bit 6
              //

              stateBIT6:
                if (brgCLKEN)
                  if (brdiv == 0)
                    begin
                       brdiv <= 15;
                       if (length == `UARTLEN_7)
                         begin
                            if ((parity == `UARTPAR_EVEN) ||
                                (parity == `UARTPAR_ODD ))
                              state <= statePARITY;
                            else
                              state <= stateSTOP1;
                         end
                       else
                         state <= stateBIT7;
                    end
                  else
                    brdiv <= brdiv - 1'b1;

              //
              // Transmit Bit 7 (MSB)
              //

              stateBIT7:
                if (brgCLKEN)
                  if (brdiv == 0)
                    begin
                       brdiv <= 15;
                       if ((parity == `UARTPAR_EVEN) ||
                           (parity == `UARTPAR_ODD ))
                         state <= statePARITY;
                       else
                         state <= stateSTOP1;
                    end
                  else
                    brdiv <= brdiv - 1'b1;

              //
              // Parity
              //

              statePARITY:
                if (brgCLKEN)
                  if (brdiv == 0)
                    begin
                       brdiv <= 15;
                       state <= stateSTOP1;
                    end
                  else
                    brdiv <= brdiv - 1'b1;

              //
              // Transmit Stop Bit 1
              //

              stateSTOP1:
                if (brgCLKEN)
                  if (brdiv == 0)
                    begin
                       brdiv <= 15;
                       if (stop == `UARTSTOP_2)
                         state <= stateSTOP2;
                       else
                         state <= stateDONE;
                    end
                  else
                    brdiv <= brdiv - 1'b1;

              //
              // Transmit Stop Bit 2
              //

              stateSTOP2:
                if (brgCLKEN)
                  if (brdiv == 0)
                    begin
                       brdiv <= 15;
                       state <= stateDONE;
                    end
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
   // Parity
   //

   wire evenpar = (txREG[0] ^ txREG[1] ^ txREG[2] ^ txREG[3] ^
                   txREG[4] ^ txREG[5] ^ txREG[6] ^ txREG[7]);

   //
   // Data selector for TXD
   //

   reg txdata;
   always @*
     begin
        case (state)
          stateSTART  : txdata = 0;
          stateBIT0   : txdata = txREG[0];
          stateBIT1   : txdata = txREG[1];
          stateBIT2   : txdata = txREG[2];
          stateBIT3   : txdata = txREG[3];
          stateBIT4   : txdata = txREG[4];
          stateBIT5   : txdata = txREG[5];
          stateBIT6   : txdata = txREG[6];
          stateBIT7   : txdata = txREG[7];
          statePARITY : txdata = (parity == `UARTPAR_EVEN) ? evenpar : !evenpar;
          default     : txdata = 1;
        endcase
     end

   //
   // Outputs
   //

   assign empty = (state == stateIDLE);
   assign intr  = (state == stateDONE);
   assign txd   = txdata;

endmodule
