////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KMC11 Maintenance Register #1 (MAINT)
//
// Details
//   This file contains the bit implementation of the Maintenance Register.
//   This register is write-only but shadows a register in the multiport RAM.
//
// File
//   kmcmaint.sv
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

`include "kmcmaint.vh"

module KMCMAINT (
      input  wire         clk,          // Clock
      input  wire         rst,          // Reset
      input  wire         devHIBYTE,    // High Byte
      input  wire         devRESET,     // Controller Clear
      input  wire         sel0WRITE,    // MAINT Write
      input  wire  [35:0] kmcDATAI,     // KMC data
      input  wire         kmcINIT,      // Initialize
      output logic [ 7:0] kmcMAINT      // MAINT register
   );

   //
   // Bit 15: RUN
   //

   logic kmcRUN;
   always_ff @(posedge clk)
     begin
        if (rst | kmcINIT)
          kmcRUN <= 0;
        else if (sel0WRITE & devHIBYTE)
          kmcRUN <= `kmcMAINT_RUN(kmcDATAI);
     end

   //
   // Bit 14: MCLR
   //

   logic [2:0] count;
   always_ff @(posedge clk)
     begin
        if (rst | devRESET)
          count <= 0;
        else if (sel0WRITE & devHIBYTE & `kmcMAINT_MCLR(kmcDATAI))
          count <= 3'd7;
        else if (count != 0)
          count <= count - 1'b1;
     end

   wire kmcMCLR = (count != 0);

   //
   // Bit 13: CRAMWR
   //

   wire kmcCRAMWR  = sel0WRITE & devHIBYTE & `kmcMAINT_CRAMWR(kmcDATAI);

   //
   // Bit 12: LU STEP
   //

   logic kmcLUSTEP;
   always_ff @(posedge clk)
     begin
        if (rst | kmcINIT)
          kmcLUSTEP <= 0;
        else if (sel0WRITE & devHIBYTE)
          kmcLUSTEP <= `kmcMAINT_LUSTEP(kmcDATAI);
     end

   //
   // Bit 11: LU LOOP
   //

   logic kmcLULOOP;
   always_ff @(posedge clk)
     begin
        if (rst | kmcINIT)
          kmcLULOOP <= 0;
        else if (sel0WRITE & devHIBYTE)
          kmcLULOOP <= `kmcMAINT_LULOOP(kmcDATAI);
     end

   //
   // Bit 10: CRAMOUT
   //

   logic kmcCRAMOUT;
   always_ff @(posedge clk)
     begin
        if (rst | kmcINIT)
          kmcCRAMOUT <= 0;
        else if (sel0WRITE & devHIBYTE)
          kmcCRAMOUT <= `kmcMAINT_CRAMOUT(kmcDATAI);
     end

   //
   // Bit 9: CRAMIN
   //

   logic kmcCRAMIN;
   always_ff @(posedge clk)
     begin
        if (rst | kmcINIT)
          kmcCRAMIN <= 0;
        else if (sel0WRITE & devHIBYTE)
          kmcCRAMIN <= `kmcMAINT_CRAMIN(kmcDATAI);
     end

   //
   // Bit 8: STEP
   //

   wire kmcSTEP = sel0WRITE & devHIBYTE & `kmcMAINT_STEP(kmcDATAI);

   //
   // Build Maintenance Register
   //

   assign kmcMAINT = {kmcRUN, kmcMCLR, kmcCRAMWR, kmcLUSTEP, kmcLULOOP, kmcCRAMOUT, kmcCRAMIN, kmcSTEP};

endmodule
