////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KMC11 Miscellaneous Register (MISC)
//
// Details
//   This file contains the implementation of the microprocessor MISC Register
//   (MISC).
//
// File
//   kmcmisc.v
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

`include "kmcmisc.vh"
`include "kmccram.vh"

module KMCMISC (
      input  wire        clk,           // Clock
      input  wire        rst,           // Reset
      input  wire        kmcINIT,       // Initialize
      input  wire [15:0] kmcCRAM,       // Control ROM
      input  wire        kmcMISCCLKEN,  // MISC clock enable
      input  wire [ 7:0] kmcALU,        // ALU register
      input  wire        kmcIRQO,       // Interrupt out
      input  wire        kmcSETNXM,     // Non-existent memory
      output wire        kmcSETIRQ,     // Edge trigger interrupt
      output wire [ 7:0] kmcMISC        // MISC register
   );

   //
   // Timer (aka PGM CLK)
   //  50.0 microseconds
   //

   localparam [11:0] kmcTIMERVAL = (0.000050 * `CLKFRQ);

   //
   // Microcode Decode
   //

   wire kmcLDMISC = `kmcCRAM_OBUSS(kmcCRAM) == `kmcCRAM_OBUSS_UMISC;

   //
   // Bit 7: Interrupt Request Trigger (OUT)
   //
   //

   assign kmcSETIRQ = kmcMISCCLKEN & kmcLDMISC & `kmcMISC_IRQO(kmcALU);

   //
   // Bit 6: Interrupt Vector Select (VECTXXX4)
   //

   reg kmcVECTXXX4;
   always @(posedge clk)
     begin
        if (rst | kmcINIT)
          kmcVECTXXX4 <= 0;
        else if (kmcMISCCLKEN & kmcLDMISC)
          kmcVECTXXX4 <= `kmcMISC_VECTXXX4(kmcALU);
     end

   //
   // Bit 5: Latch (LAT)
   //

   reg kmcLAT;
   always @(posedge clk)
     begin
        if (rst | kmcINIT)
          kmcLAT <= 0;
        else if (kmcMISCCLKEN & kmcLDMISC)
          kmcLAT <= `kmcMISC_LAT(kmcALU);
     end

   //
   // Bit 4: Timer (aka PGM CLK)
   //  50 microsecond retriggerable one-shot.
   //

   reg [11:0] kmcTIMERCNT;
   always @(posedge clk)
     begin
        if (rst | kmcINIT)
          kmcTIMERCNT <= 0;
        else if (kmcMISCCLKEN & kmcLDMISC & `kmcMISC_PGMCLK(kmcALU))
          kmcTIMERCNT <= kmcTIMERVAL;
        else if (kmcTIMERCNT != 0)
          kmcTIMERCNT <= kmcTIMERCNT - 1'b1;
     end

   wire kmcTIMER = (kmcTIMERCNT == 0);

   //
   // Bit 3:2 Bus Address Extension Out (BAEO)
   //

   reg [3:2] kmcBAEO;
   always @(posedge clk)
     begin
        if (rst | kmcINIT)
          kmcBAEO <= 0;
        else if (kmcMISCCLKEN & kmcLDMISC)
          kmcBAEO <= `kmcMISC_BAEO(kmcALU);
     end

   //
   // Bit 1: AC LO
   // This will Reset the KS10, if we hook it up...)
   //

   reg kmcACLO;
   always @(posedge clk)
     begin
        if (rst | kmcINIT)
          kmcACLO <= 0;
        else if (kmcMISCCLKEN & kmcLDMISC)
          kmcACLO <= `kmcMISC_ACLO(kmcALU);
     end

   //
   // Bit 0: Non-existent Memory
   //

   reg kmcNXM;
   always @(posedge clk)
     begin
        if (rst | kmcINIT)
          kmcNXM <= 0;
        else if (kmcSETNXM)
          kmcNXM <= 1;
        else if (kmcMISCCLKEN & kmcLDMISC)
          kmcNXM <= `kmcMISC_NXM(kmcALU);
     end

   //
   // Build MISC Register
   //

   assign kmcMISC = {kmcIRQO, kmcVECTXXX4, kmcLAT, kmcTIMER, kmcBAEO, kmcACLO, kmcNXM};

endmodule
