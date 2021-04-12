////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KMC11 Multiport RAM
//
// Details
//
//        ADDR   HI (ODD) BYTE    LO (EVEN) BYTE
//             +----------------+----------------+
//          0  |        1       |        0       |     DMA IN  DATA
//  IBUS    1  |        3       |        2       |     DMA OUT DATA
//  OBUS    2  |        5       |        4       |     DMA IN  ADDRESS
//          3  |        7       |        6       |     DMS OUT ADDRESS
//             +----------------+----------------+
//          4  |        1       |        0       |     CSR0
//  IBUS*   5  |        3       |        2       |     CSR2
//  OBUS*   6  |        5       |        4       |     CSR4
//          7  |        7       |        6       |     CSR6
//             +----------------+----------------+
//
// File
//   kmcmpram.v
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
      input  wire        clk,           // Clock
      input  wire        rst,           // Reset
      input  wire        devREQO,       // DMA request out
      input  wire        devACKI,       // DMA acknowleget in
      input  wire        devLOBYTE,     // Write low byte
      input  wire        devHIBYTE,     // Write high byte
      input  wire        csrWRITE,      // Write to CSR
      input  wire [35:0] kmcADDRI,      // Addr in
      input  wire [35:0] kmcDATAI,      // Data in
      input  wire [15:0] kmcCRAM,       // Control RAM
      input  wire [ 7:0] kmcALU,        // ALU data
      input  wire        kmcRAMCLKEN,   // MPRAM clock enable
      input  wire        kmcNPRO,       // NPR out transaction
      output wire        kmcMPBUSY,     // MPRAM busy
      output wire [15:0] kmcNPRID,      // NPR in data
      output wire [15:0] kmcNPROD,      // NPR out data
      output wire [15:0] kmcNPRIA,      // NPR in address
      output wire [15:0] kmcNPROA,      // NPR out address
      output wire [15:0] kmcCSR0,       // CSR0 output
      output wire [15:0] kmcCSR2,       // CSR2 output
      output wire [15:0] kmcCSR4,       // CSR4 output
      output wire [15:0] kmcCSR6        // CSR5 output
   );

   //
   // Register Addresses
   //

   localparam [2:0] NPRID_ADDR = 0,
                    NPROD_ADDR = 1,
                    NPRIA_ADDR = 2,
                    NPROA_ADDR = 3,
                    CSR0_ADDR  = 4,
                    CSR2_ADDR  = 5,
                    CSR4_ADDR  = 6,
                    CSR6_ADDR  = 7;

   //
   // Decode writes to MPRAM
   //

   wire kmcDSTOBUS  = `kmcCRAM_DST(kmcCRAM) == `kmcCRAM_DST_OBUS;
   wire kmcDSTOBUSS = `kmcCRAM_DST(kmcCRAM) == `kmcCRAM_DST_OBUSS;

   //
   //  Port A Data Mux
   //
   //  This routes the device data into to the MPRAM write port.
   //
   // Trace:
   //   M8206/D9/E69
   //   M8206/D9/E77
   //   M8206/D9/E78
   //   M8206/D9/E86
   //

   reg [15:0] kmcDATA;
   reg [ 2:0] kmcADDR;
   reg        kmcWRH;
   reg        kmcWRL;
   reg        kmcMPWR;

   always @*
     begin

        kmcDATA <= 0;
        kmcADDR <= 0;
        kmcWRL  <= 0;
        kmcWRH  <= 0;
        kmcMPWR <= 0;

        //
        // Microprocessor Writes
        //

        if ((kmcDSTOBUS  & !kmcCRAM[3]) |
            (kmcDSTOBUSS & !kmcCRAM[3]))
          begin
             kmcDATA <= {kmcALU, kmcALU};
             kmcWRL  <= !kmcCRAM[0];
             kmcWRH  <=  kmcCRAM[0];
             kmcMPWR <=  kmcRAMCLKEN;
             if (kmcDSTOBUS)
               kmcADDR <= {1'b0, kmcCRAM[2:1]};
             else
               kmcADDR <= {1'b1, kmcCRAM[2:1]};
          end

        //
        // IO Bus DMA input goes to NPRIDL
        //

        else if (devREQO & devACKI & !kmcNPRO)
          begin
             kmcDATA <= kmcDATAI[15:0];
             kmcADDR <= NPRID_ADDR;
             kmcWRL  <= devLOBYTE;
             kmcWRH  <= devHIBYTE;
             kmcMPWR <= 1;
          end

        //
        // IO Bus writes to CSRs
        //

        else if (csrWRITE)
          begin
             kmcDATA <= kmcDATAI[15:0];
             kmcADDR <= {1'b1, kmcADDRI[2:1]};
             kmcWRL  <= devLOBYTE;
             kmcWRH  <= devHIBYTE;
             kmcMPWR <= 1;
         end

     end

   assign kmcMPBUSY = ((kmcDSTOBUS  & kmcRAMCLKEN) |
                       (kmcDSTOBUSS & kmcRAMCLKEN));

   //
   // Multi-port RAM
   //

   reg [15:0] mpram[0:7];

`ifndef SYNTHESIS

   initial
     begin
        mpram[0] = 0;
        mpram[1] = 0;
        mpram[2] = 0;
        mpram[3] = 0;
        mpram[4] = 0;
        mpram[5] = 0;
        mpram[6] = 0;
        mpram[7] = 0;
     end

`endif

   //
   // MPRAM High Byte
   //

   always @(posedge clk)
     begin
        if (kmcMPWR & kmcWRH)
          mpram[kmcADDR][15:8] <= kmcDATA[15:8];
     end

   //
   // MPRAM Low Byte
   //

   always @(posedge clk)
     begin
        if (kmcMPWR & kmcWRL)
          mpram[kmcADDR][ 7:0] <= kmcDATA[ 7:0];
     end

   //
   // Register outputs
   //

   assign kmcNPRID = mpram[NPRID_ADDR];
   assign kmcNPROD = mpram[NPROD_ADDR];
   assign kmcNPRIA = mpram[NPRIA_ADDR];
   assign kmcNPROA = mpram[NPROA_ADDR];
   assign kmcCSR0  = mpram[CSR0_ADDR];
   assign kmcCSR2  = mpram[CSR2_ADDR];
   assign kmcCSR4  = mpram[CSR4_ADDR];
   assign kmcCSR6  = mpram[CSR6_ADDR];

endmodule
