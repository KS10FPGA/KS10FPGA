////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KMC11 Multiport RAM
//
// Details
//
//   IBUS[0]  : CSR0
//   IBUS[1]  : CSR1
//   IBUS[2]  : CSR2
//   IBUS[3]  : CSR3
//   IBUS[4]  : CSR4
//   IBUS[5]  : CSR5
//   IBUS[6]  : CSR6
//   IBUS[7]  : CSR7
//
//   IBUSS[0] : NPRIDL       DMA DATA IN  (LO)
//   IBUSS[1] : NPRIDH       DMA DATA IN  (HI)
//   IBUSS[2] : NPRODL       DMA DATA OUT (LO)
//   IBUSS[3] : NPRODH       DMA DATA OUT (HI)
//   IBUSS[4] : NPRIAL       DMA ADDR IN  (LO)
//   IBUSS[5] : NPRIAH       DMA ADDR IN  (HI)
//   IBUSS[6] : NPROAL       DMA ADDR OUT (LO)
//   IBUSS[7] : NPROAH       DMA ADDR OUT (HI)
//
// File
//   kmcmpram.sv
//
// Note:
//   I didn't bother trying to use RAM for this.  It's just simpler to use some
//   some registers.
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

`include "kmccram.vh"

module KMCMPRAM (
      input  wire         clk,          // Clock
      input  wire         rst,          // Reset
      input  wire         devREQO,      // DMA request out
      input  wire         devACKI,      // DMA acknowleget in
      input  wire         devLOBYTE,    // Write low byte
      input  wire         devHIBYTE,    // Write high byte
      input  wire         sel0WRITE,    // SEL0 write
      input  wire         sel2WRITE,    // SEL2 write
      input  wire         sel4WRITE,    // SEL4 write
      input  wire         sel6WRITE,    // SEL6 write
      input  wire  [35:0] kmcDATAI,     // Data in
      input  wire  [15:0] kmcCRAM,      // Control RAM
      input  wire         kmcCRAMIN,    // CRAM IN
      input  wire         kmcCRAMOUT,   // CRAM OUT
      input  wire  [ 7:0] kmcALU,       // ALU data
      input  wire         kmcRAMCLKEN,  // MPRAM clock enable
      input  wire         kmcNPRO,      // NPR Out transaction
      input  wire         kmcBYTE,      // NPR Byte transaction
      output wire         kmcMPBUSY,    // MPRAM busy
      output logic [15:0] kmcNPRID,     // NPR in data
      output logic [15:0] kmcNPROD,     // NPR out data
      output logic [15:0] kmcNPRIA,     // NPR in address
      output logic [15:0] kmcNPROA,     // NPR out address
      output logic [15:0] kmcCSR0,      // CSR0 output
      output logic [15:0] kmcCSR2,      // CSR2 output
      output logic [15:0] kmcCSR4,      // CSR4 output
      output logic [15:0] kmcCSR6       // CSR5 output
   );

   //
   // Decode writes to MPRAM
   //

   wire kmcDSTOBUS  = `kmcCRAM_DST(kmcCRAM) == `kmcCRAM_DST_OBUS;
   wire kmcDSTOBUSS = `kmcCRAM_DST(kmcCRAM) == `kmcCRAM_DST_OBUSS;

   assign kmcMPBUSY = ((kmcDSTOBUS  & kmcRAMCLKEN) |
                       (kmcDSTOBUSS & kmcRAMCLKEN));

   //
   // NPRIDL
   //  This data from an NPR read is written to NPRID.
   //

   always_ff @(posedge clk)
     begin
        if (rst)
          kmcNPRID[7:0] <= 0;
`ifdef KMC_BROKE_RPW
        else if (devREQO & devACKI & !kmcNPRO)
          case ({kmcBYTE, kmcNPRIA[1:0]})
            3'b000: kmcNPRID[ 7: 0] <= kmcDATAI[25:18]; // Even word
            3'b001: kmcNPRID[ 7: 0] <= kmcDATAI[25:18]; // Even word
            3'b010: kmcNPRID[ 7: 0] <= kmcDATAI[ 7: 0]; // Odd  word
            3'b011: kmcNPRID[ 7: 0] <= kmcDATAI[ 7: 0]; // Odd  word
            3'b100: kmcNPRID[ 7: 0] <= kmcDATAI[25:18]; // Even word, low  byte
            3'b101: ;                                   // Even word, high byte
            3'b110: kmcNPRID[ 7: 0] <= kmcDATAI[ 7: 0]; // Odd  word, low  byte
            3'b111: ;                                   // Odd  word, high byte
          endcase
`else
        else if (devLOBYTE & devREQO & devACKI & !kmcNPRO)
          kmcNPRID[7:0] <= kmcDATAI[7:0];
`endif
        else if (kmcRAMCLKEN & kmcDSTOBUS & (`kmcCRAM_OBUS(kmcCRAM) == `kmcCRAM_OBUS_NPRIDL))
          kmcNPRID[7:0] <= kmcALU;
     end

   //
   // NPRIDH
   //  This data from an NPR read is written to NPRID.
   //

   always_ff @(posedge clk)
     begin
        if (rst)
          kmcNPRID[15:8] <= 0;
`ifdef KMC_BROKE_RPW
        else if (devREQO & devACKI & !kmcNPRO)
          case ({kmcBYTE, kmcNPRIA[1:0]})
            3'b000: kmcNPRID[15: 8] <= kmcDATAI[33:26]; // Even word
            3'b001: kmcNPRID[15: 8] <= kmcDATAI[33:26]; // Even word
            3'b010: kmcNPRID[15: 8] <= kmcDATAI[15: 8]; // Odd  word
            3'b011: kmcNPRID[15: 8] <= kmcDATAI[15: 8]; // Odd  word
            3'b100: ;                                   // Even word, low  byte
            3'b101: kmcNPRID[15: 8] <= kmcDATAI[33:26]; // Even word, high byte
            3'b110: ;                                   // Odd  word, low  byte
            3'b111: kmcNPRID[15: 8] <= kmcDATAI[15: 8]; // Odd  word, high byte
          endcase
`else
        else if (devHIBYTE & devREQO & devACKI & !kmcNPRO)
          kmcNPRID[15:8] <= kmcDATAI[15:8];
`endif
        else if (kmcRAMCLKEN & kmcDSTOBUS & (`kmcCRAM_OBUS(kmcCRAM) == `kmcCRAM_OBUS_NPRIDH))
          kmcNPRID[15:8] <= kmcALU;
     end

   //
   // NPRODL
   //  The contents of NPROD is written on an NPR write.
   //

   always_ff @(posedge clk)
     begin
        if (rst)
          kmcNPROD[7:0] <= 0;
        else if (devLOBYTE & devREQO & devACKI & kmcNPRO & kmcCRAMIN & kmcCRAMOUT)
          kmcNPROD[7:0] <= kmcDATAI[7:0];
        else if (kmcRAMCLKEN & kmcDSTOBUS & (`kmcCRAM_OBUS(kmcCRAM) == `kmcCRAM_OBUS_NPRODL))
          kmcNPROD[7:0] <= kmcALU;
     end

   //
   // NPRODH
   //  The contents of NPROD is written on an NPR write.
   //

   always_ff @(posedge clk)
     begin
        if (rst)
          kmcNPROD[15:8] <= 0;
        else if (devHIBYTE & devREQO & devACKI & kmcNPRO & kmcCRAMIN & kmcCRAMOUT)
          kmcNPROD[15:8] <= kmcDATAI[15:8];
        else if (kmcRAMCLKEN & kmcDSTOBUS & (`kmcCRAM_OBUS(kmcCRAM) == `kmcCRAM_OBUS_NPRODH))
          kmcNPROD[15:8] <= kmcALU;
     end

   //
   // NPRIAL
   //  The contents of NPRIA provides the address for an NPR read.
   //

   always_ff @(posedge clk)
     begin
        if (rst)
          kmcNPRIA[7:0] <= 0;
        else if (kmcRAMCLKEN & kmcDSTOBUS & (`kmcCRAM_OBUS(kmcCRAM) == `kmcCRAM_OBUS_NPRIAL))
          kmcNPRIA[7:0] <= kmcALU;
     end

   //
   // NPRIAH
   //  The contents of NPRIA provides the address for an NPR read.
   //

   always_ff @(posedge clk)
     begin
        if (rst)
          kmcNPRIA[15:8] <= 0;
        else if (kmcRAMCLKEN & kmcDSTOBUS & (`kmcCRAM_OBUS(kmcCRAM) == `kmcCRAM_OBUS_NPRIAH))
          kmcNPRIA[15:8] <= kmcALU;
     end

   //
   // NPROAL
   //  The contents of NPROA provides the address for an NPR write.
   //

   always_ff @(posedge clk)
     begin
        if (rst)
          kmcNPROA[7:0] <= 0;
        else if (kmcRAMCLKEN & kmcDSTOBUS & `kmcCRAM_OBUS(kmcCRAM) == `kmcCRAM_OBUS_NPROAL)
          kmcNPROA[7:0] <= kmcALU;
     end

   //
   // NPROAH
   //  The contents of NPROA provides the address for an NPR write.
   //

   always_ff @(posedge clk)
     begin
        if (rst)
          kmcNPROA[15:8] <= 0;
        else if (kmcRAMCLKEN & kmcDSTOBUS & (`kmcCRAM_OBUS(kmcCRAM) == `kmcCRAM_OBUS_NPROAH))
          kmcNPROA[15:8] <= kmcALU;
     end

   //
   // CSR0
   //

   always_ff @(posedge clk)
     begin
        if (rst)
          kmcCSR0[7:0] <= 0;
        else if (devLOBYTE & sel0WRITE)
          kmcCSR0[7:0] <= kmcDATAI[7:0];
        else if (kmcRAMCLKEN & kmcDSTOBUSS & (`kmcCRAM_OBUSS(kmcCRAM) == `kmcCRAM_OBUSS_CSR0))
          kmcCSR0[7:0] <= kmcALU;
     end

   //
   // CSR1
   //

   always_ff @(posedge clk)
     begin
        if (rst)
          kmcCSR0[15:8] <= 0;
        else if (devHIBYTE & sel0WRITE)
          kmcCSR0[15:8] <= kmcDATAI[15:8];
        else if (kmcRAMCLKEN & kmcDSTOBUSS & (`kmcCRAM_OBUSS(kmcCRAM) == `kmcCRAM_OBUSS_CSR1))
          kmcCSR0[15:8] <= kmcALU;
     end

   //
   // CSR2
   //

   always_ff @(posedge clk)
     begin
        if (rst)
          kmcCSR2[7:0] <= 0;
        else if (devLOBYTE & sel2WRITE)
          kmcCSR2[7:0] <= kmcDATAI[7:0];
        else if (kmcRAMCLKEN & kmcDSTOBUSS & `kmcCRAM_OBUSS(kmcCRAM) == `kmcCRAM_OBUSS_CSR2)
          kmcCSR2[7:0] <= kmcALU;
     end

   //
   // CSR3
   //

   always_ff @(posedge clk)
     begin
        if (rst)
          kmcCSR2[15:8] <= 0;
        else if (devHIBYTE & sel2WRITE)
          kmcCSR2[15:8] <= kmcDATAI[15:8];
        else if (kmcRAMCLKEN & kmcDSTOBUSS & (`kmcCRAM_OBUSS(kmcCRAM) == `kmcCRAM_OBUSS_CSR3))
          kmcCSR2[15:8] <= kmcALU;
     end

   //
   // CSR4
   //

   always_ff @(posedge clk)
     begin
        if (rst)
          kmcCSR4[7:0] <= 0;
        else if (devLOBYTE & sel4WRITE)
          kmcCSR4[7:0] <= kmcDATAI[7:0];
        else if (kmcRAMCLKEN & kmcDSTOBUSS & (`kmcCRAM_OBUSS(kmcCRAM) == `kmcCRAM_OBUSS_CSR4))
          kmcCSR4[7:0] <= kmcALU;
     end

   //
   // CSR5
   //

   always_ff @(posedge clk)
     begin
        if (rst)
          kmcCSR4[15:8] <= 0;
        else if (devHIBYTE & sel4WRITE)
          kmcCSR4[15:8] <= kmcDATAI[15:8];
        else if (kmcRAMCLKEN & kmcDSTOBUSS & (`kmcCRAM_OBUSS(kmcCRAM) == `kmcCRAM_OBUSS_CSR5))
          kmcCSR4[15:8] <= kmcALU;
     end

   //
   // CSR6
   //

   always_ff @(posedge clk)
     begin
        if (rst)
          kmcCSR6[7:0] <= 0;
        else if (devLOBYTE & sel6WRITE)
          kmcCSR6[7:0] <= kmcDATAI[7:0];
        else if (kmcRAMCLKEN & kmcDSTOBUSS & (`kmcCRAM_OBUSS(kmcCRAM) == `kmcCRAM_OBUSS_CSR6))
          kmcCSR6[7:0] <= kmcALU;
     end

   //
   // CSR7
   //

   always_ff @(posedge clk)
     begin
        if (rst)
          kmcCSR6[15:8] <= 0;
        else if (devHIBYTE & sel6WRITE)
          kmcCSR6[15:8] <= kmcDATAI[15:8];
        else if (kmcRAMCLKEN & kmcDSTOBUSS & (`kmcCRAM_OBUSS(kmcCRAM) == `kmcCRAM_OBUSS_CSR7))
          kmcCSR6[15:8] <= kmcALU;
     end

endmodule
