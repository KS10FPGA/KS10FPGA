////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DZ-11 Receiver Buffer (RBUF)
//
// Details
//   This is an implements the DZ11 RBUF Register.  The RBUF contains the
//   receiver FIFO (aka SILO).
//
// File
//   dzrbuf.v
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
      input  wire [ 2:0] scan,                  // Scan
      input  wire        uartRXOVRE,            // UART overrun error
      input  wire        uartRXFRME,            // UART framing error
      input  wire        uartRXPARE,            // UART parity error
      input  wire [ 7:0] uartRXDATA,            // UART data
      input  wire        uartRXFULL,            // UART full
      output reg  [ 7:0] uartRXCLR,             // UART clear
      input  wire        rbufREAD,              // RBUF read
      output wire        rbufRDONE,             // RBUF is empty
      output reg         rbufSA,                // RBUF Silo Alarm
      output wire [15:0] regRBUF                // RBUF output
   );

   //
   // log2() function
   //

   function integer log2;
       input [31:0] val;
       begin
          val = val - 1;
          for(log2 = 0; val > 0; log2 = log2 + 1)
            val = val >> 1;
       end
   endfunction

   //
   // FIFO Parameters
   //

   localparam FIFO_SIZE      = 65;
   localparam BUF_ADDR_WIDTH = log2(FIFO_SIZE);
   localparam BUF_SIZE       = 2**BUF_ADDR_WIDTH;

   //
   // UART Receiver Interface
   //
   // Details:
   //  If the UART receiver is full, empty the UART receiver data into the FIFO
   //  and clear the UART full flag of the correct UART.
   //

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
   EDGETRIG #(.POSEDGE(0)) uFIFOREAD(clk, rst, 1'b1, rbufREAD, rd);

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

   always @(posedge clk)
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
   //  Note: FIFOs have a depth of 65 not 64.  Watch the counter sizes.
   //

   reg [BUF_ADDR_WIDTH-1:0] depth;
   reg [BUF_ADDR_WIDTH-1:0] rd_ptr;
   reg [BUF_ADDR_WIDTH-1:0] wr_ptr;

   wire empty = (depth == 0);
   wire full  = (depth == FIFO_SIZE - 1);

   always @(posedge clk)
     begin
        if (rst | clr)
          begin
             depth  <= 0;
             rd_ptr <= 0;
             wr_ptr <= 0;
          end
        else if (rd & !wr & !empty)
          begin
             depth <= depth - 1'b1;
             if (rd_ptr == FIFO_SIZE - 1)
               rd_ptr <= 0;
             else
               rd_ptr <= rd_ptr + 1'b1;
          end
        else if (wr & !rd & !full)
          begin
             depth <= depth + 1'b1;
             if (wr_ptr == FIFO_SIZE - 1)
               wr_ptr <= 0;
             else
               wr_ptr <= wr_ptr + 1'b1;
          end
     end

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
   //  An overrun error occurs when you write to a full FIFO.
   //

   reg rbufOVRE;

   always @(posedge clk)
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

   always @(posedge clk)
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

   always @(posedge clk)
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

   always @(posedge clk)
     begin
        if (rst | clr | rd | !csrSAE)
          rbufSA <= 0;
        else if (countSA == 16)
          rbufSA <= 1;
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
   reg [14:0] DPRAM[BUF_SIZE-1:0];

   always @(posedge clk)
     begin
        if (rst)
`ifdef SYNTHESIS
          ;
`else
          for (i = 0; i < BUF_SIZE; i = i + 1)
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

   assign regRBUF = {rbufDVAL, fifoDATA};

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
