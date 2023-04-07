////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DZ-11 Programmable baudrate generator, UART transmitter, and UART
//   receiver.
//
// Details
//   This is an implements the DZ11 UART Transceiver.  In this implementation,
//   the LPR register is part of the DZUART module.  It was just easier that
//   way...
//
// File
//   dzuart.sv
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2023 Rob Doyle
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

`include "dzlpr.vh"

module DZUART (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire         clr,                  // Clear
      input  wire [ 2: 0] num,                  // UART Number
      input  wire         lprWRITE,             // Write to LPR
      input  wire [35: 0] dzDATAI,              // Device Data In
      input  wire         rxd,                  // Receiver serial data
      input  wire         rxclr,                // Receiver flag clear
      output wire         rxfull,               // Receiver full flag
      output wire [ 7: 0] rxdata,               // Received data
      output wire         rxpare,               // Receiver parity error
      output wire         rxfrme,               // Receiver framing error
      output wire         txd,                  // Transmitter serial data
      output wire         txempty,              // Transmitter empty
      input  wire         txload,               // Transmitter load
      input  wire [ 7: 0] txdata                // Transmitter data
   );

   //
   // LPR Register
   //
   // Note:
   //  There is a LPR register for every UART.
   //

   logic [12:3] lprREG;

   always_ff @(posedge clk)
     begin
        if (rst | clr)
          lprREG <= 0;
        else if (lprWRITE & (`dzLPR_LINE(dzDATAI) == num))
          lprREG <= `dzLPR_DATA(dzDATAI);
     end

   //
   // UART Baud Rate Generator
   //

   logic clken;

   UART_BRG ttyBRG (
      .clk     (clk),
      .rst     (rst),
      .speed   ({1'b0, `dzLPR_SPEED(lprREG)}),
      .clken   (clken)
   );

   //
   // UART Transmitter
   //

   UART_TX ttyTX (
       .clk    (clk),
       .rst    (rst),
       .clr    (clr),
       .clken  (clken),
       .length (`dzLPR_LEN(lprREG)),
       .parity (`dzLPR_PAR(lprREG)),
       .stop   (`dzLPR_STOP(lprREG)),
       .load   (txload),
       .data   (txdata),
       .empty  (txempty),
       .intr   (),
       .txd    (txd)
   );

   //
   // UART Receiver
   //

   wire intr;

   UART_RX ttyRX (
       .clk    (clk),
       .rst    (rst),
       .clr    (clr),
       .clken  (`dzLPR_RXEN(lprREG) & clken),
       .length (`dzLPR_LEN(lprREG)),
       .parity (`dzLPR_PAR(lprREG)),
       .stop   (`dzLPR_STOP(lprREG)),
       .rxd    (rxd),
       .rfull  (rxclr),
       .full   (rxfull),
       .intr   (intr),
       .data   (rxdata),
       .pare   (rxpare),
       .frme   (rxfrme),
       .ovre   ()
   );

`ifndef SYNTHESIS

   //
   // Debugging crutches
   //

   logic [0:7] txDATA;
   logic [0:7] rxDATA;

   always_ff @(posedge clk)
     begin
        if (rst | clr)
          begin
             rxDATA <= 0;
             txDATA <= 0;
          end
        else
          begin
             if (intr)
               rxDATA <= rxdata;
             if (txload)
               txDATA <= txdata;
          end
     end

`endif

endmodule
