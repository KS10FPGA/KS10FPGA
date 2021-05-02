///////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KMC11 Sequencer
//
// File
//   kmcseq.v
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

module KMCSEQ (
      // Reset
      input  wire        clk,           // Clock
      input  wire        rst,           // Reset
      input  wire        devLOBYTE,     // LO Byte
      input  wire        devHIBYTE,     // HI Byte
      input  wire        sel4WRITE,     // Write to CSR4
      input  wire        sel6WRITE,     // Write to CSR6
      input  wire        kmcINIT,       // Initialize
      input  wire [35:0] kmcDATAI,      // Input data
      input  wire        kmcCRAMIN,     // Control RAM in
      input  wire        kmcCRAMOUT,    // Control RAM out
      input  wire        kmcCRAMWR,     // Control RAM write
      input  wire        kmcPCCLKEN,    // PC clock enable
      input  wire        kmcCRAMCLKEN,  // CRAM clock enable
      input  wire        kmcALUZ,       // ALU Zero
      input  wire        kmcALUC,       // ALU Carry
      input  wire [ 7:0] kmcALU,        // ALU Output
      input  wire [ 7:0] kmcBRG,        // Branch Register
      output reg  [ 9:0] kmcPC,         // Program Counter
      output reg  [ 9:0] kmcMNTADDR,    // Maintenance Address Register
      output reg  [15:0] kmcMNTINST,    // Maintenance Instruction Register
      output reg  [15:0] kmcCRAM        // Control ROM
   );

   //
   // Microcode Decode
   //

   wire [10: 8] kmcCOND = `kmcCRAM_COND(kmcCRAM);

   //
   // Decode branch instructions
   //

   wire kmcBRINST = ((`kmcCRAM_SRC(kmcCRAM) == `kmcCRAM_SRC_JMP_IMMED) |
                     (`kmcCRAM_SRC(kmcCRAM) == `kmcCRAM_SRC_JMP_MEM  ) |
                     (`kmcCRAM_SRC(kmcCRAM) == `kmcCRAM_SRC_JMP_BRG  ));

   //
   // Maintenance Address Register
   //

   always @(posedge clk)
     begin
        if (rst | kmcINIT)
          kmcMNTADDR <= 0;
        else if (sel4WRITE)
          kmcMNTADDR <= kmcDATAI[9:0];
     end

   //
   // Maintenance Instruction Register
   //

   always @(posedge clk)
     begin
        if (rst | kmcINIT)
          kmcMNTINST <= 0;
        else if (sel6WRITE)
          kmcMNTINST <= kmcDATAI[15:0];
     end

   //
   // Branch Decoder
   //
   // Trace
   //  M8206/D2/E37
   //

   reg kmcBRANCH;

   always @*
     begin
        case (kmcCOND)
          `kmcCRAM_COND_RESVD  : kmcBRANCH <= 1;
          `kmcCRAM_COND_ALWAYS : kmcBRANCH <= 1;
          `kmcCRAM_COND_ALUC   : kmcBRANCH <= kmcALUC;
          `kmcCRAM_COND_ALUZ   : kmcBRANCH <= kmcALUZ;
          `kmcCRAM_COND_BRG0   : kmcBRANCH <= kmcBRG[0];
          `kmcCRAM_COND_BRG1   : kmcBRANCH <= kmcBRG[1];
          `kmcCRAM_COND_BRG4   : kmcBRANCH <= kmcBRG[4];
          `kmcCRAM_COND_BRG7   : kmcBRANCH <= kmcBRG[7];
        endcase
     end

   //
   // Program Counter
   //
   // Trace
   //   M8206/D1/E32
   //   M8206/D1/E59
   //   M8206/D2/E33
   //   M8206/D2/E34
   //   M8206/D2/E46
   //   M8206/D2/E47
   //   M8206/D2/E48
   //   M8206/D2/E49
   //

   always @(posedge clk)
     begin
        if (rst | kmcINIT)
          kmcPC <= 0;
        else if (kmcPCCLKEN)
          begin
             if (kmcBRANCH & kmcBRINST)
               kmcPC <= {`kmcCRAM_MAR(kmcCRAM), kmcALU};
             else
               kmcPC <= kmcPC + 1'b1;
          end
     end

   //
   // Control ROM
   //
   // Trace
   //   M8206/D5/E1
   //   M8206/D5/E2
   //   M8206/D5/E3
   //   M8206/D5/E4
   //   M8206/D5/E5
   //   M8206/D5/E6
   //   M8206/D5/E7
   //   M8206/D5/E8
   //   M8206/D6/E16
   //   M8206/D6/E17
   //   M8206/D6/E18
   //   M8206/D6/E19
   //   M8206/D6/E20
   //   M8206/D6/E21
   //   M8206/D6/E22
   //   M8206/D6/E23
   //

   reg [15:0] kmcCRAMR;
   reg [15:0] kmcCRAM_MEM[0:1023];

   always @(posedge clk)
     begin
        if (kmcCRAMOUT & kmcCRAMWR)
          kmcCRAM_MEM[kmcMNTADDR] <= kmcMNTINST;
        else if (kmcCRAMCLKEN)
          kmcCRAMR <= kmcCRAM_MEM[kmcPC];
     end

   //
   // Maintenance Instruction and Instruction Register Mux
   //

   always @*
     begin
        if (kmcCRAMIN)
          kmcCRAM <= kmcMNTINST;
        else
          kmcCRAM <= kmcCRAMR;
     end

endmodule
