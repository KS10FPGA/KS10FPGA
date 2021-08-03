////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Unibus Exerciser Control/Status Register #1 (UBECSR1)
//
// Details
//   The information used to design the UBE was mostly obtained be reverse
//   engineering the UBE from DSDUA source code and CXBEAB0 diagnostic source
//   code.
//
// File
//   ubecsr1.sv
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2021 Rob Doyle
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

`include "ubecsr1.vh"

module UBECSR1 (
      input  wire          clk,                         // Clock
      input  wire          rst,                         // Reset
      input  wire          clr,                         // Clear
      input  wire          devHIBYTE,                   // Device Hi Byte
      input  wire          devLOBYTE,                   // Device Lo Byte
      input  wire  [35: 0] devDATAI,                    // Device Data In
      input  wire          csr1WRITE,                   // CSR1 write
      output logic [15: 0] regCSR1                      // CSR1 register
   );

   //
   // Bit 15: UBE Control/Status Register #1 Error - UBECSR1[ERR]
   //

   wire ubeERR = 0;

   //
   // Bit 14: UBE Control/Status Register #1 UNK5 - UBECSR1[UNK5]
   //

   logic ubeUNK5;

   always @(posedge clk)
     begin
        if (rst | clr)
          ubeUNK5 <= 0;
        else if (csr1WRITE & devHIBYTE)
          ubeUNK5 <= `ubeCSR1_UNK5(devDATAI);
     end

   //
   // Bit 13: UBE Control/Status Register #1 UNK4 - UBECSR1[UNK4]
   //

   logic ubeUNK4;

   always @(posedge clk)
     begin
        if (rst | clr)
          ubeUNK4 <= 0;
        else if (csr1WRITE & devHIBYTE)
          ubeUNK4 <= `ubeCSR1_UNK4(devDATAI);
     end

   //
   // Bit 12: UBE Control/Status Register #1 UNK3 - UBECSR1[UNK3]
   //

   logic ubeUNK3;

   always @(posedge clk)
     begin
        if (rst | clr)
          ubeUNK3 <= 0;
        else if (csr1WRITE & devHIBYTE)
          ubeUNK3 <= `ubeCSR1_UNK3(devDATAI);
     end

   //
   // Bit 11: UBE Control/Status Register #1 FTM - UBECSR1[FTM]
   //

   logic ubeFTM;

   always @(posedge clk)
     begin
        if (rst | clr)
          ubeFTM <= 0;
        else if (csr1WRITE & devHIBYTE)
          ubeFTM <= `ubeCSR1_FTM(devDATAI);
     end

   //
   // Bit 10: UBE Control/Status Register #1 USED2 - UBECSR1[XTCCO]
   //

   logic ubeXTCCO;

   always @(posedge clk)
     begin
        if (rst | clr)
          ubeXTCCO <= 0;
        else if (csr1WRITE & devHIBYTE)
          ubeXTCCO <= `ubeCSR1_XTCCO(devDATAI);
     end

   //
   // Bit 9: UBE Control/Status Register #1 NPRO - UBECSR1[NPRO]
   //

   logic ubeNPRO;

   always @(posedge clk)
     begin
        if (rst | clr)
          ubeNPRO <= 0;
        else if (csr1WRITE & devHIBYTE)
          ubeNPRO <= `ubeCSR1_NPRO(devDATAI);
     end

   //
   // Bit 8: UBE Control/Status Register #1 BYTE - UBECSR1[BYTE]
   //

   logic ubeBYTE;

   always @(posedge clk)
     begin
        if (rst | clr)
          ubeBYTE <= 0;
        else if (csr1WRITE & devHIBYTE)
          ubeBYTE <= `ubeCSR1_BYTE(devDATAI);
     end

   //
   // Bit 7: UBE Control/Status Register #1 UNK2 - UBECSR1[UNK2]
   //

   wire ubeUNK2 = 0;

   //
   // Bit 6: UBE Control/Status Register #1 UNK1 - UBECSR1[UNK1]
   //

   logic ubeUNK1;

   always @(posedge clk)
     begin
        if (rst | clr)
          ubeUNK1 <= 0;
        else if (csr1WRITE & devLOBYTE)
          ubeUNK1 <= `ubeCSR1_UNK1(devDATAI);
     end

   //
   // Bit 5: UBE Control/Status Register #1 NPRS - UBECSR1[NPRS]
   //

   logic ubeNPRS;

   always @(posedge clk)
     begin
        if (rst | clr)
          ubeNPRS <= 0;
        else if (csr1WRITE & devLOBYTE)
          ubeNPRS <= `ubeCSR1_NPRS(devDATAI);
     end

   //
   // Bit 4: UBE Control/Status Register #1 Interrupt Request 7 - UBECSR1[BR7]
   //

   logic ubeBR7;

   always @(posedge clk)
     begin
        if (rst | clr)
          ubeBR7 <= 0;
        else if (csr1WRITE & devLOBYTE)
          ubeBR7 <= `ubeCSR1_BR7(devDATAI);
     end

   //
   // Bit 3: UBE Control/Status Register #1 Interrupt Request 6 - UBECSR1[BR6]
   //

   logic ubeBR6;

   always @(posedge clk)
     begin
        if (rst | clr)
          ubeBR6 <= 0;
        else if (csr1WRITE & devLOBYTE)
          ubeBR6 <= `ubeCSR1_BR6(devDATAI);
     end

   //
   // Bit 2: UBE Control/Status Register #1 Interrupt Request 5 - UBECSR1[BR5]
   //

   logic ubeBR5;

   always @(posedge clk)
     begin
        if (rst | clr)
          ubeBR5 <= 0;
        else if (csr1WRITE & devLOBYTE)
          ubeBR5 <= `ubeCSR1_BR5(devDATAI);
     end

   //
   // Bit 1: UBE Control/Status Register #1 Interrupt Request 4 - UBECSR1[BR4]
   //

   logic ubeBR4;

   always @(posedge clk)
     begin
        if (rst | clr)
          ubeBR4 <= 0;
        else if (csr1WRITE & devLOBYTE)
          ubeBR4 <= `ubeCSR1_BR4(devDATAI);
     end

   //
   // Bit 0: UBE Control/Status Register #1 GO - UBECSR1[GO]
   //

   wire ubeGO = csr1WRITE & devLOBYTE & `ubeCSR1_GO(devDATAI);

   //
   // Form UBECSR1
   //

   assign regCSR1 = {ubeERR,  ubeUNK5, ubeUNK4,  ubeUNK3, ubeFTM, ubeXTCCO, ubeNPRO, ubeBYTE,
                     ubeUNK2, ubeUNK1, ubeNPRS, ubeBR7,  ubeBR6, ubeBR5,   ubeBR4,  ubeGO};

endmodule
