////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DZ-11 Receiver Buffer (RBUF)
//
// Details
//   This is an implements the DZ11 RBUF Register
//
// File
//   dzrbuf.v
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
`define SIZE 64

module DZRBUF(clk, rst, clr, csrMSE, csrSAE, scan, uartRXOVRE, uartRXFRME,
              uartRXPARE, uartRXDATA, uartRXFULL, uartRXCLR, rbufREAD, rbufRDONE,
              rbufSA, regRBUF);

   input         clk;                           // Clock
   input         rst;                           // Reset
   input         clr;                           // Clear
   input         csrMSE;                        // CSR[MSE]
   input         csrSAE;                        // CSR[SAE]
   input  [ 2:0] scan;                          // Scan
   input         uartRXOVRE;                    // UART overrun error
   input         uartRXFRME;                    // UART framing error
   input         uartRXPARE;                    // UART parity error
   input  [ 7:0] uartRXDATA;                    // UART data
   input         uartRXFULL;                    // UART full
   output [ 7:0] uartRXCLR;                     // UART clear
   input         rbufREAD;                      // RBUF read
   output        rbufRDONE;                     // RBUF is empty
   output        rbufSA;                        // RBUF Silo Alarm
   output [15:0] regRBUF;                       // RBUF output

   //
   // UART Receiver Interface
   //
   // Details:
   //  If the UART receiver is full, empty the UART receiver data into the FIFO
   //  and clear the UART full flag of the correct UART.
   //

   reg [7:0] uartRXCLR;
   
   always @*
     begin
        if (uartRXFULL & csrMSE)
          case (scan)
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
   // FIFO write
   //

   wire wr = uartRXFULL & csrMSE;

   //
   // FIFO read
   //
   // Details:
   //  The FIFO state is updated on the trailing edge of the read pulse; i.e.,
   //  after the read is completed.
   //

   wire rd;
   EDGETRIG uFIFOREAD(clk, rst, 1'b1, 1'b0, rbufREAD, rd);

   //
   // Delayed read and write
   //
   // Details:
   //  Some status bits need to be updated after the FIFO read and the FIFO
   //  write have completed and the FIFO depth has been updated.  See RBUF[OVRE]
   //  and RBUF[DVAL].
   //

   reg rd_dly;
   reg wr_dly;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             rd_dly <= 0;
             wr_dly <= 0;
          end
        else
          begin
             rd_dly <= rd;
             wr_dly <= wr;
          end
     end

   //
   // FIFO State
   //
   //  Note: FIFOs have a depth of 64 not 63.  Watch the counter sizes.
   //

   reg [0:6] depth;
   reg [0:6] rd_ptr;
   reg [0:6] wr_ptr;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             depth  <= 0;
             rd_ptr <= 0;
             wr_ptr <= 0;
          end
        else if (rd & ~wr & !empty)
          begin
             depth <= depth - 1'b1;
             if (rd_ptr == `SIZE)
               rd_ptr <= 0;
             else
               rd_ptr <= rd_ptr + 1'b1;
          end
        else if (wr & !rd & !full)
          begin
             depth <= depth + 1'b1;
             if (wr_ptr == `SIZE)
               wr_ptr <= 0;
             else
               wr_ptr <= wr_ptr + 1'b1;
          end
     end

   wire empty = (depth == 0);
   wire full  = (depth == `SIZE);

   //
   // RBUF[RDONE]
   //
   // Details
   //  RDONE is asserted when the FIFO is not empty.
   //

   wire rbufRDONE = !empty;

   //
   // RBUF[OVRE]
   //
   //  An overrun error occurs when you write to a full FIFO.
   //

   reg rbufOVRE;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rbufOVRE <= 0;
        else
          begin
             if (clr)
               rbufOVRE <= 0;
             else if (wr | rd_dly)
               rbufOVRE <= full;
          end
     end

   //
   // RBUF[DVAL]
   //

   reg rbufDVAL;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rbufDVAL  <= 0;
        else
          begin
             if (clr)
               rbufDVAL <= 0;
             else if (rd | wr_dly)
               rbufDVAL <= !empty;
          end
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

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          countSA <= 0;
        else
          begin
             if (clr | rd | !csrSAE)
               countSA <= 0;
             else if (wr)
               countSA <= countSA + 1'b1;
          end
     end

   //
   // SILO Alarm (SA)
   //
   // The Silo Alarm is a asserted when the 16th word is written to the FIFO.
   // The Silo Alarm is cleared after reading the RBUF or clearing SAE.
   //

   reg rbufSA;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rbufSA <= 0;
        else
          begin
             if (clr | rd | !csrSAE)
               rbufSA <= 0;
             else if (countSA == 16)
               rbufSA <= 1;
          end
     end

   //
   // Dual Port RAM
   //
   // Details
   //  When the FIFO is full, the last character in the FIFO is replaced with
   //  the current character and the Overrun Error bit (RBUF[OVRE]) is asserted.
   //

`ifndef SYNTHESIS
   integer i;
`endif

   reg [14:0] fifoDATA;
   reg [14:0] DPRAM[0:`SIZE];

   always @(posedge clk or posedge rst)
     begin
        if (rst)
`ifdef SYNTHESIS
          ;
`else
          for (i = 0; i <= `SIZE; i = i + 1)
            DPRAM[i] <= 0;
`endif
        else
          begin
             if (wr)
               DPRAM[wr_ptr] <= {rbufOVRE, uartRXFRME, uartRXPARE, 1'b0, scan, uartRXDATA[7:0]};
             fifoDATA <= DPRAM[rd_ptr];
          end
     end

   //
   // RBUF Register
   //
   // Details
   //  RBUF is read only and can only be read as words.
   //
   //  RBUF[DVAL] is the FIFO Status.  Everything else is read from the FIFO.
   //

   wire [15:0] regRBUF = {rbufDVAL, fifoDATA};

   //
   // Status
   //
   // Some of the simulations take forever.  Print some status messages.
   //
   // Use "tail -f dzstatus.txt" to view the output log
   //

`ifndef SYNTHESIS
 `ifdef DEBUG_DSDZA

   integer file;

   initial
     begin
        file = $fopen("dzstatus.txt",  "w");
     end

   always @(posedge clk)
     begin
        if (wr)
          begin
             $fwrite(file, "Received character 0x%02x on channel %d\n",
                      uartRXDATA[7:0], scan[2:0]);
             $fflush(file);
          end
     end

 `endif
`endif

endmodule
