////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Dispatch ROM (DROM)
//
// Details
//   The Dispatch ROM maps the instruction (from the Instruction Register) to
//   the address of code that executes that instruction in the Control ROM.
//
//   The Dispatch ROM has 512 entries.  One for each of the opcodes.
//
// Note
//   The contents of this file was extracted from the microcode listing file by
//   a simple AWK script.  Go see the makefile.
//
// File
//   drom.v
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

`include "crom.vh"

`ifndef DROM_DAT
`define DROM_DAT "drom.dat"
`endif

module DROM (
      input  wire         clk,          // Clock
      input  wire         clken,        // Clock Enable
      input  wire [0: 35] dbus,         // DBUS
      input  wire [0:107] crom,         // Control ROM
      output reg  [0: 35] drom          // Dispatch ROM Output
   );

   //
   // Microcode decode
   //

   wire loadIR = `cromSPEC_EN_40 & (`cromSPEC_SEL == `cromSPEC_SEL_LOADIR);

   //
   // Dispatch ROM
   //
   // Details:
   //  The DROM in the KS10 is asynchronous.  That won't work in an FPGA
   //  implementation.  Fortunately the DROM is addressed by the Instruction
   //  Register (IR) which is loaded synchronously.  Therefore we can
   //  absorb a copy of the OPCODE portion of IR directly into Dispatch ROM
   //  addressing.
   //
   //  Simply put: when we load the IR, we also synchronously lookup the
   //  contents of the Dispatch ROM.
   //
   // Trace:
   //  DPEA/E98
   //  DPEA/E117
   //  DPEA/E110
   //

   reg [0:35] DROM[0:511];

   initial
     begin
        $readmemh(`DROM_DAT, DROM);
     end

   always @(posedge clk)
     begin
        if (clken & loadIR)
          drom <= DROM[dbus[0:8]];
     end

endmodule
