////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DZ-11 Receiver Buffer (RBUF)
//
// Details
//   This is an implements the DZ11 RBUF Register.
//
// File
//   dzrbuf.sv
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

module DZRBUF (
      input  wire        clk,                   // Clock
      input  wire        rst,                   // Reset
      input  wire        clr,                   // Clear
      input  wire        csrMSE,                // CSR[MSE]
      input  wire        csrSAE,                // CSR[SAE]
      input  wire [ 7:0] uartRXFRME,            // UART framing error
      input  wire [ 7:0] uartRXPARE,            // UART parity error
      input  wire [ 7:0] uartRXDATA[7:0],       // UART data
      input  wire [ 7:0] uartRXFULL,            // UART full
      output reg  [ 7:0] uartRXCLR,             // UART clear
      input  wire        rbufREAD,              // RBUF read
      output wire        rbufRDONE,             // RBUF is empty
      output reg         rbufSA,                // RBUF Silo Alarm
      output wire [15:0] regRBUF                // RBUF output
   );

   //
   // UART receiver scanner
   //
   // Details
   //  This just increments the RX scan signal when Master Scan Enable is asserted.
   //

   reg [2:0] rxSCAN;

   always_ff @(posedge clk)
     begin
        if (rst)
          rxSCAN <= 0;
        else if (csrMSE)
          rxSCAN <= rxSCAN + 1'b1;
     end

   //
   // FIFO read
   //
   // Details
   //  The FIFO state is updated after the read to RBUF.
   //

   wire rd;
   EDGETRIG #(
      .POSEDGE  (0)
   ) uFIFOREAD (
       .clk     (clk),
       .rst     (rst),
       .clken   (1'b1),
       .i       (rbufREAD),
       .o       (rd)
   );

   //
   // FIFO write
   //
   // Details
   //  The FIFO written when the scanner detects a receiver full
   //

   wire wr = uartRXFULL[rxSCAN] & csrMSE;

   //
   // Delayed read
   //
   // Details:
   //  RBUF[DVAL] is updated after the FIFO read so that the FIFO status
   //  has been updated.
   //

   reg rd_dly;

   always_ff @(posedge clk)
     begin
        if (rst)
          rd_dly <= 0;
        else
          rd_dly <= rd;
     end

   //
   // Delayed write
   //
   // Details:
   //  RBUF[OVRE] is updated after the FIFO write so that the FIFO status
   //  has been updated.
   //

   reg wr_dly;

   always_ff @(posedge clk)
     begin
        if (rst)
          wr_dly <= 0;
        else
          wr_dly <= wr;
     end

   //
   // UART Receiver Interface
   //
   // Details:
   //  If the currently scannned UART receiver is full, write the UART receiver
   //  data into the FIFO, and clear the UART full flag for that UART.
   //

   always_comb
     begin
        if (uartRXFULL[rxSCAN] & csrMSE)
          case (rxSCAN)
            0: uartRXCLR <= 8'b0000_0001;
            1: uartRXCLR <= 8'b0000_0010;
            2: uartRXCLR <= 8'b0000_0100;
            3: uartRXCLR <= 8'b0000_1000;
            4: uartRXCLR <= 8'b0001_0000;
            5: uartRXCLR <= 8'b0010_0000;
            6: uartRXCLR <= 8'b0100_0000;
            7: uartRXCLR <= 8'b1000_0000;
          endcase
        else
          uartRXCLR <= 8'b0000_0000;
     end

   //
   // Receive data SILO
   //

   wire        full;
   wire        empty;
   reg         rbufOVRE;
   wire [14:0] readDATA;
   wire [14:0] writeDATA = {rbufOVRE, uartRXFRME[rxSCAN], uartRXPARE[rxSCAN], 1'b0, rxSCAN, uartRXDATA[rxSCAN]};

   FIFO #(
      .SIZE     (65),
      .WIDTH    (15)
   ) RBUF (
      .clk      (clk),
      .rst      (rst),
      .clr      (clr),
      .clken    (1'b1),
      .rd       (rd),
      .wr       (wr),
      .in       (writeDATA),
      .out      (readDATA),
      .full     (full),
      .empty    (empty)
   );

   //
   // RBUF[RDONE]
   //
   // Details
   //  RDONE is asserted when the FIFO is not empty.
   //

   assign rbufRDONE = !empty;

   //
   // RBUF[OVRE]
   //
   // Details
   //  An overrun error occurs when you write to a full FIFO.
   //

   always_ff @(posedge clk)
     begin
        if (rst | clr)
          rbufOVRE <= 0;
        else if (wr | rd_dly)
          rbufOVRE <= full;
     end

   //
   // RBUF[DVAL]
   //

   reg rbufDVAL;

   always_ff @(posedge clk)
     begin
        if (rst | clr)
          rbufDVAL <= 0;
        else if (rd | wr_dly)
          rbufDVAL <= !empty;
     end

   //
   // SILO Alarm Counter
   //
   // Details
   //  This increments every time a character is stored in the FIFO. The
   //  counter is reset by a rbufREAD.  This is not the FIFO depth.
   //
   //  When the SA flag is asserted, the FIFO must be emptied because the SA
   //  flag will only asserted again when another 16 characters are written
   //  to the FIFO. If the software doesn't empty the FIFO, the SA will be
   //  incorrect.
   //

   reg [0:4] countSA;

   always_ff @(posedge clk)
     begin
        if (rst | clr | rd | !csrSAE)
          countSA <= 0;
        else if (wr)
          countSA <= countSA + 1'b1;
     end

   //
   // SILO Alarm (SA)
   //
   // The Silo Alarm is a asserted when the 16th word is written to the FIFO.
   // The Silo Alarm is negated after reading the RBUF or clearing SAE.
   //

   always_ff @(posedge clk)
     begin
        if (rst | clr | rd | !csrSAE)
          rbufSA <= 0;
        else if (countSA == 16)
          rbufSA <= 1;
     end

   //
   // RBUF Register
   //
   // Details
   //  RBUF is read only and can only be read as a word.
   //
   //  RBUF[DVAL] is the FIFO Status.  Everything else is read from the FIFO.
   //

   assign regRBUF = {rbufDVAL, readDATA};

endmodule
