////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KMC11 Branch Register (BRG)
//
// Details
//   This file contains the implementation of the microprocessor Branch
//   Register (BRG).
//
// File
//   kmcbrg.sv
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

module KMCBRG (
      input  wire         clk,          // Clock
      input  wire         rst,          // Reset
      input  wire         kmcINIT,      // Initialize
      input  wire  [15:0] kmcCRAM,      // Control ROM
      input  wire         kmcBRGCLKEN,  // NPR clock enable
      input  wire  [ 7:0] kmcALU,       // ALU register
      output logic [ 7:0] kmcBRG        // BRG register
   );

   //
   // Microcode Decode
   //

   wire kmcMOVINST = ((`kmcCRAM_SRC(kmcCRAM) == `kmcCRAM_SRC_MOV_IMMED) |
                      (`kmcCRAM_SRC(kmcCRAM) == `kmcCRAM_SRC_MOV_IBUS ) |
                      (`kmcCRAM_SRC(kmcCRAM) == `kmcCRAM_SRC_MOV_MEM  ) |
                      (`kmcCRAM_SRC(kmcCRAM) == `kmcCRAM_SRC_MOV_BRG  ) |
                      (`kmcCRAM_SRC(kmcCRAM) == `kmcCRAM_SRC_MOV_IBUSS));

   wire kmcLDBRG = ((kmcBRGCLKEN & kmcMOVINST & `kmcCRAM_DST(kmcCRAM) == `kmcCRAM_DST_BRG  ) |
                    (kmcBRGCLKEN & kmcMOVINST & `kmcCRAM_DST(kmcCRAM) == `kmcCRAM_DST_SPBRG));

   wire kmcSHBRG =   kmcBRGCLKEN & kmcMOVINST & `kmcCRAM_DST(kmcCRAM) == `kmcCRAM_DST_BRGSHR;

   //
   // BRG Register
   //

   always_ff @(posedge clk)
     begin
        if (rst | kmcINIT)
          kmcBRG <= 0;
        else if (kmcLDBRG)
          kmcBRG <= kmcALU;
        else if (kmcSHBRG)
          kmcBRG <= {kmcALU[0], kmcALU[7:1]};
     end

endmodule
