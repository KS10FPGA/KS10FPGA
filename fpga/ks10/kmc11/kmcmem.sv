////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KMC11 Memory
//
// File
//   kmcmem.sv
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

module KMCMEM (
      input  wire         clk,          // Clock
      input  wire         rst,          // Reset
      input  wire         kmcINIT,      // Initialize
      input  wire  [15:0] kmcCRAM,      // Control ROM
      input  wire         kmcMARCLKEN,  // MAR clock enable
      input  wire         kmcMEMCLKEN,  // RAM clock enable
      input  wire  [ 7:0] kmcALU,       // ALU output
      output logic [10:0] kmcMAR,       // Memory address register
      output logic [ 7:0] kmcMEM        // Memory bus output
   );

   //
   // Move Instruction Decoder
   //
   // The MOV instruction decode is Bit 5 of the "S ROM".
   //
   // MAR loads only occur on MOV instructions.  Not on branch instructions.
   // Branch instructions use this field for CRAM paging.
   //
   // Trace
   //   M8206/D7/E40
   //

   wire kmcMOVINST = ((`kmcCRAM_SRC(kmcCRAM) == `kmcCRAM_SRC_MOV_IMMED) |
                      (`kmcCRAM_SRC(kmcCRAM) == `kmcCRAM_SRC_MOV_IBUS ) |
                      (`kmcCRAM_SRC(kmcCRAM) == `kmcCRAM_SRC_MOV_MEM  ) |
                      (`kmcCRAM_SRC(kmcCRAM) == `kmcCRAM_SRC_MOV_BRG  ) |
                      (`kmcCRAM_SRC(kmcCRAM) == `kmcCRAM_SRC_MOV_IBUSS));

   //
   // Memory Write Decoder
   //
   // The write decode is Bit 6 of "D ROM" which is a trival decoded.
   //
   // Trace
   //   M8206/D1/E65
   //

   wire kmcWRMEM = `kmcCRAM_DST(kmcCRAM) == `kmcCRAM_DST_MEM;

   //
   // Memory Address Register (MAR)
   //
   // The memory is only 1K bytes.  The 10th bit allows for MAR overflow
   // detection on a MAR increment.  If the MAR address wraps to zero, you'll
   // get an indication - if you bother to check.
   //
   // The MAR load and increment microcode decode was trivially implemented in
   // the "D ROM".  I've just open coded the decoder.  It's more obvious how
   // things work.
   //
   // Trace
   //   M8206/D1/E15
   //   M8206/D1/E65
   //   M8206/D2/E32
   //   M8206/D2/E42
   //

   always_ff @(posedge clk)
     begin
        if (rst | kmcINIT)
          kmcMAR <= 0;
        else if (kmcMARCLKEN & kmcMOVINST)
          begin
             if (`kmcCRAM_MAR(kmcCRAM) == `kmcCRAM_MAR_LDLO)
               kmcMAR[7:0] <= kmcALU;
             else if (`kmcCRAM_MAR(kmcCRAM) == `kmcCRAM_MAR_LDHI)
               kmcMAR[10:8] <= {1'b0, kmcALU[1:0]};
             else if (`kmcCRAM_MAR(kmcCRAM) == `kmcCRAM_MAR_INC)
               kmcMAR <= kmcMAR + 1'b1;
          end
     end

   //
   // RAM
   //
   // Trace
   //   M8206/D3/E11
   //   M8206/D3/E12
   //   M8206/D3/E13
   //   M8206/D3/E14
   //   M8206/D3/E26
   //   M8206/D3/E27
   //   M8206/D3/E28
   //   M8206/D3/E29
   //

   logic [9:0] rd_addr;
   logic [7:0] ram[0:1023];

`ifndef SYNTHESIS
   integer i;
`endif

   always_ff @(posedge clk)
     begin
        if (rst)
`ifdef SYNTHESIS
          ;
`else
        for (i = 0; i < 1024; i = i + 1)
          ram[i] = 0;
`endif
        else if (kmcWRMEM & kmcMOVINST & kmcMEMCLKEN)
          ram[kmcMAR[9:0]] <= kmcALU;
        kmcMEM <= ram[kmcMAR[9:0]];
     end

endmodule
