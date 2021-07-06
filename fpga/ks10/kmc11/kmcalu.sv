////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KMC11 Arithmetic Logic Unit
//
// Details
//   This module implements the Arithmetic Logic Unit.  The ALU is 8-bits wide
//   and implements a subset of the 74181 logic functions.  In the KMC11
//   implementation, a Function ROM (FROM) sits between the microcode and the
//   74181 to remap the functions.
//
// File
//   kmcalu.sv
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

module KMCALU (
      input  wire         clk,          // Clock
      input  wire         rst,          // Reset
      input  wire         kmcINIT,      // Initialize
      input  wire  [15:0] kmcCRAM,      // Control ROM Data
      input  wire  [ 7:0] kmcDMUX,      // Data mux
      input  wire  [ 7:0] kmcSP,        // Scratch pad
      input  wire         kmcALUCLKEN,  // ALU clock enable
      output logic        kmcALUC,      // ALU carry
      output logic        kmcALUZ,      // ALU zero
      output logic [ 7:0] kmcALU        // Unegistered ALU
   );

   //
   // Microcode Decode
   //  ALU Function
   //

   wire [7:4] kmcFUN = `kmcCRAM_FUN(kmcCRAM);

   //
   // Microcode Decode
   //  This decodes MOV instructions
   //
   // Trace
   //   M8206/D7/E40
   //

   wire kmcSRCMOV = ((`kmcCRAM_SRC(kmcCRAM) == `kmcCRAM_SRC_MOV_IMMED) |
                     (`kmcCRAM_SRC(kmcCRAM) == `kmcCRAM_SRC_MOV_IBUS ) |
                     (`kmcCRAM_SRC(kmcCRAM) == `kmcCRAM_SRC_MOV_MEM  ) |
                     (`kmcCRAM_SRC(kmcCRAM) == `kmcCRAM_SRC_MOV_BRG  ) |
                     (`kmcCRAM_SRC(kmcCRAM) == `kmcCRAM_SRC_MOV_IBUSS));

   //
   // Microcode Decode
   //  This decodes instructions that modify the carry
   //
   //  This is part of the Function ROM.
   //
   // Trace
   //   M8206/D8/E95
   //

   wire kmcSRCCY = ((`kmcCRAM_SRC(kmcCRAM) == `kmcCRAM_SRC_MOV_MEM) |
                    (`kmcCRAM_SRC(kmcCRAM) == `kmcCRAM_SRC_MOV_BRG));

   //
   // Microcode Decode
   //  This decodes ALU operations that modify the carry bit.
   //
   //  This is part of the Function ROM.
   //
   // Trace
   //   M8206/D8/E95
   //

   wire kmcOPCY = ((`kmcCRAM_FUN(kmcCRAM) == `kmcCRAM_FUN_ADD   ) |
                   (`kmcCRAM_FUN(kmcCRAM) == `kmcCRAM_FUN_ADDC  ) |
                   (`kmcCRAM_FUN(kmcCRAM) == `kmcCRAM_FUN_SUBC  ) |
                   (`kmcCRAM_FUN(kmcCRAM) == `kmcCRAM_FUN_INCA  ) |
                   (`kmcCRAM_FUN(kmcCRAM) == `kmcCRAM_FUN_APLUSC) |
                   (`kmcCRAM_FUN(kmcCRAM) == `kmcCRAM_FUN_TWOA  ) |
                   (`kmcCRAM_FUN(kmcCRAM) == `kmcCRAM_FUN_TWOAC ) |
                   (`kmcCRAM_FUN(kmcCRAM) == `kmcCRAM_FUN_DECA  ) |
                   (`kmcCRAM_FUN(kmcCRAM) == `kmcCRAM_FUN_SUB   ) |
                   (`kmcCRAM_FUN(kmcCRAM) == `kmcCRAM_FUN_SUBOC ));

   wire [7:0] kmcALUA = kmcSP;
   wire [7:0] kmcALUB = kmcDMUX;

   //
   // ALU
   //
   // Details:
   //  The 74LS181 ALUs implements 32 functions.  Only 16 functions are used.
   //  There the Function ROM that maps the microcode FUN field into the ALU
   //  function.  I've deleted the Function ROM and just re-arranged the ALU
   //  to do the right thing.
   //
   // Notes:
   //  This is positive logic.  Be sure to use the right table in the 74ls181
   //  data sheet.
   //
   //  The following truth table is derived from the Function ROM description.
   //
   //   +---------------------+-+-------------------------+----------------+
   //   | CRM CRM CRM CRM CRM | |                         |                |
   //   |  14  7   6   5   4  | |  CY  S3  S2  S1  S0  M  |  Descripton    |
   //   +---------------------+-+-------------------------+----------------+
   //   |  0   0   0   0   0  | |  0   1   0   1   0   0  | F = B          |
   //   |  0   0   0   0   1  | |  0   1   0   1   0   0  | F = B          |
   //   |  0   0   0   1   0  | |  0   1   0   1   0   0  | F = B          |
   //   |  0   0   0   1   1  | |  0   1   0   1   0   0  | F = B          |
   //   |  0   0   1   0   0  | |  0   1   0   1   0   0  | F = B          |
   //   |  0   0   1   0   1  | |  0   1   0   1   0   0  | F = B          |
   //   |  0   0   1   1   0  | |  0   1   0   1   0   0  | F = B          |
   //   |  0   0   1   1   1  | |  0   1   0   1   0   0  | F = B          |
   //   |  0   1   0   0   0  | |  0   1   0   1   0   0  | F = B          |
   //   |  0   1   0   0   1  | |  0   1   0   1   0   0  | F = B          |
   //   |  0   1   0   1   0  | |  0   1   0   1   0   0  | F = B          |
   //   |  0   1   0   1   1  | |  0   1   0   1   0   0  | F = B          |
   //   |  0   1   1   0   0  | |  0   1   0   1   0   0  | F = B          |
   //   |  0   1   1   0   1  | |  0   1   0   1   0   0  | F = B          |
   //   |  0   1   1   1   0  | |  0   1   0   1   0   0  | F = B          |
   //   |  0   1   1   1   1  | |  0   1   0   1   0   0  | F = B          |
   //   |  1   0   0   0   0  | |  0   1   0   0   1   0  | F = A + B      |
   //   |  1   0   0   0   1  | |  C   1   0   0   1   0  | F = A + B + C  |
   //   |  1   0   0   1   0  | |  C   0   1   1   0   0  | F = A - B - C  |
   //   |  1   0   0   1   1  | |  1   0   0   0   0   0  | F = A + 1      |
   //   |  1   0   1   0   0  | |  C   0   0   0   0   0  | F = A + C      |
   //   |  1   0   1   0   1  | |  0   1   1   0   0   0  | F = A + A      |
   //   |  1   0   1   1   0  | |  C   1   1   0   0   0  | F = A + A + C  |
   //   |  1   0   1   1   1  | |  0   1   1   1   1   0  | F = A - 1      |
   //   |  1   1   0   0   0  | |  0   1   1   1   1   1  | F = A          |
   //   |  1   1   0   0   1  | |  0   1   0   1   0   1  | F = B          |
   //   |  1   1   0   1   0  | |  0   1   1   0   1   1  | F = A | ~B     |
   //   |  1   1   0   1   1  | |  0   1   0   1   1   1  | F = A & B      |
   //   |  1   1   1   0   0  | |  0   0   1   1   0   1  | F = A ^ B      |
   //   |  1   1   1   0   1  | |  0   0   1   1   0   1  | F = A ^ B      |
   //   |  1   1   1   1   0  | |  1   0   1   1   0   0  | F = A - B      |
   //   |  1   1   1   1   1  | |  0   0   1   1   0   0  | F = A - B - 1  |
   //   +---------------------+-+-------------------------+----------------+
   //
   // Carry operation (see Table)
   //   CY = 0: Carry is zero
   //   CY = 1: Carry is one
   //   CY = C: Carry is from last operation
   //
   // Funny enough, this matches the microcode.
   //
   // Trace:
   //  M8206/D8/E62
   //  M8206/D8/E71
   //  M8206/D8/E95
   //  M8206/D8/E114
   //

   logic kmcCY;

   always_comb
     begin
        kmcCY <= 0;
        if (`kmcCRAM_SRC(kmcCRAM) == `kmcCRAM_SRC_MOV_IMMED |
            `kmcCRAM_SRC(kmcCRAM) == `kmcCRAM_SRC_JMP_IMMED |
            `kmcCRAM_SRC(kmcCRAM) == `kmcCRAM_SRC_MOV_IBUS  |
            `kmcCRAM_SRC(kmcCRAM) == `kmcCRAM_SRC_MOV_IBUSS)
          kmcALU <= kmcDMUX;
        else
          case (kmcFUN)
            `kmcCRAM_FUN_ADD:    {kmcCY, kmcALU} <= {1'b0, kmcALUA} +  {1'b0, kmcALUB};            // A+B
            `kmcCRAM_FUN_ADDC:   {kmcCY, kmcALU} <= {1'b0, kmcALUA} +  {1'b0, kmcALUB} +  kmcALUC; // A+B+C
            `kmcCRAM_FUN_SUBC:   {kmcCY, kmcALU} <= {1'b0, kmcALUA} -  {1'b1, kmcALUB} - !kmcALUC; // A-B-C
            `kmcCRAM_FUN_INCA:   {kmcCY, kmcALU} <= {1'b0, kmcALUA}                    +  1'b1;    // A+1
            `kmcCRAM_FUN_APLUSC: {kmcCY, kmcALU} <= {1'b0, kmcALUA}                    +  kmcALUC; // A+C
            `kmcCRAM_FUN_TWOA:   {kmcCY, kmcALU} <= {1'b0, kmcALUA} +  {1'b0, kmcALUA};            // A+A
            `kmcCRAM_FUN_TWOAC:  {kmcCY, kmcALU} <= {1'b0, kmcALUA} +  {1'b0, kmcALUA} +  kmcALUC; // A+A+C
            `kmcCRAM_FUN_DECA:   {kmcCY, kmcALU} <= {1'b0, kmcALUA}                    -  1'b1;    // A-1
            `kmcCRAM_FUN_SELA:   {kmcCY, kmcALU} <= {1'b0, kmcALUA};                               // A
            `kmcCRAM_FUN_SELB:   {kmcCY, kmcALU} <= {1'b0, kmcALUB};                               // B
            `kmcCRAM_FUN_AORNB:  {kmcCY, kmcALU} <= {1'b0, kmcALUA  | ~kmcALUB};                   // A|~B
            `kmcCRAM_FUN_AANDB:  {kmcCY, kmcALU} <= {1'b0, kmcALUA  &  kmcALUB};                   // A&B
            `kmcCRAM_FUN_AORB:   {kmcCY, kmcALU} <= {1'b0, kmcALUA  |  kmcALUB};                   // A|B
            `kmcCRAM_FUN_AXORB:  {kmcCY, kmcALU} <= {1'b0, kmcALUA  ^  kmcALUB};                   // A^B
            `kmcCRAM_FUN_SUB:    {kmcCY, kmcALU} <= {1'b0, kmcALUA} - {1'b0, kmcALUB};            // A-B
            `kmcCRAM_FUN_SUBOC:  {kmcCY, kmcALU} <= {1'b0, kmcALUA} - {1'b0, kmcALUB}  - 1'b1;    // A-B-1
          endcase
     end

   //
   // Registered Carry
   //
   // Trace
   //   M8206/D1/E116
   //   M8206/D7/E40
   //   M8206/D8/E90
   //

   always_ff @(posedge clk)
     begin
        if (rst | kmcINIT)
          kmcALUC <= 0;
        else if (kmcSRCCY & kmcOPCY & kmcALUCLKEN)
          kmcALUC <= kmcCY;
     end

   //
   // Registered Zero
   //
   // Trace
   //   M8206/D8/E90
   //

   always_ff @(posedge clk)
     begin
        if (rst | kmcINIT)
          kmcALUZ <= 0;
        else if (kmcSRCMOV)
          kmcALUZ <= (kmcALU == 8'o377);
     end

endmodule
