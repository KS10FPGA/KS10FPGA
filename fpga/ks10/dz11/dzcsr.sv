////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DZ11 Control and Status Register (CSR)
//
// Details
//   The module implements the DZ11 CSR Register.
//
// File
//   dzcsr.sv
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

`include "dzcsr.vh"
`include "dztcr.vh"

module DZCSR (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire         devRESET,             // Device Reset from UBA
      input  wire         devLOBYTE,            // Device Low Byte
      input  wire         devHIBYTE,            // Device High Byte
      input  wire [35: 0] dzDATAI,              // DZ Data In
      input  wire         csrWRITE,             // Write to CSR
      input  wire         rbufRDONE,            // RBUF Receiver Done
      input  wire         rbufSA,               // RBUF Silo Alarm
      input  wire         tdrTRDY,              // TDR Transmitter ready
      input  wire [ 2: 0] tdrTLINE,             // TDR Transmitter line number
      output wire [15: 0] regCSR                // CSR Output
   );

   logic csrCLR;

   //
   // CSRPER parameter
   //
   // Details
   //  The CSR[CLR] is a 15us one-shot in the KS10.  Because the KS10 FPGA runs
   //  faster than DEC KS10, the CLR timing needs to be adjusted or the DSDZA
   //  diagnostic will fail when it measures this period.  The DZ11 doesn't
   //  care.  The clear only takes a single clock cycle.
   //
   //  Set the one-shot for 3 microseconds.
   //

   localparam [63:0] CSRCNT = (0.000003 * `CLKFRQ);

   //
   // CSR Transmitter Interrupt Enable (TIE)
   //
   // Trace
   //  M7819/S6/E26
   //

   logic csrTIE;

   always_ff @(posedge clk)
     begin
        if (rst | csrCLR | devRESET)
          csrTIE <= 0;
        else if (csrWRITE & devHIBYTE)
          csrTIE <= `dzCSR_TIE(dzDATAI);
     end

   //
   // CSR SILO Alarm Enable(SAE)
   //
   // Trace
   //  M7819/S6/E26
   //

   logic csrSAE;

   always_ff @(posedge clk)
     begin
        if (rst | csrCLR | devRESET)
          csrSAE <= 0;
        else if (csrWRITE & devHIBYTE)
          csrSAE <= `dzCSR_SAE(dzDATAI);
     end

   //
   // CSR Receiver Interrupt Enable (RIE)
   //
   // Trace
   //  M7819/S6/E27
   //

   logic csrRIE;

   always_ff @(posedge clk)
     begin
        if (rst | csrCLR | devRESET)
          csrRIE <= 0;
        else if (csrWRITE & devLOBYTE)
          csrRIE <= `dzCSR_RIE(dzDATAI);
     end

   //
   // CSR Master Scan Enable (MSE)
   //
   // Trace
   //  M7819/S6/E27
   //

   logic csrMSE;

   always_ff @(posedge clk)
     begin
        if (rst | csrCLR | devRESET)
          csrMSE <= 0;
        else if (csrWRITE  & devLOBYTE)
          csrMSE <= `dzCSR_MSE(dzDATAI);
     end

   //
   // CSR Clear (CLR)
   //
   // Details
   //  See note associated with CSRPER parameter
   //
   // Trace
   //  M7819/S6/E27
   //

   logic [9:0] clrCOUNT;
   always_ff @(posedge clk)
     begin
        if (rst | devRESET)
          clrCOUNT <= 0;
        if (csrWRITE & devLOBYTE & `dzCSR_CLR(dzDATAI))
          clrCOUNT <= CSRCNT[9:0];
        else if (clrCOUNT != 0)
          clrCOUNT <= clrCOUNT - 1'b1;
     end

   assign csrCLR = (clrCOUNT != 0);

   //
   // CSR Maintenance Mode (MAINT)
   //
   // Trace
   //  M7819/S6/E27
   //

   logic csrMAINT;

   always_ff @(posedge clk)
     begin
        if (rst | csrCLR | devRESET)
          csrMAINT <= 0;
        else if (csrWRITE & devLOBYTE)
          csrMAINT <= `dzCSR_MAINT(dzDATAI);
     end

   //
   // Build CSR
   //

   assign regCSR = {tdrTRDY,  csrTIE, rbufSA, csrSAE,  1'b0, tdrTLINE[2:0],
                    rbufRDONE, csrRIE, csrMSE, csrCLR, csrMAINT, 3'b0};

endmodule
