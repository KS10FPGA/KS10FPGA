////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Ramfile
//
// Details
//
// Note
//   The ramfile is addressed as follows:
//
//     +------+----------------+
//     | 1777 |                |
//     |      |     Cache      |
//     | 1000 |                |
//     +------+----------------+
//     | 0777 |                |
//     |      |   Workspace    |
//     | 0200 |                |
//     +------+----------------+
//     | 0177 |                |
//     |      |   AC Block 7   |
//     | 0160 |                |
//     +------+----------------+
//     | 0067 |                |
//     |      |   AC Block 6   |
//     | 0140 |                |
//     +------+----------------+
//     | 0037 |                |
//     |      |   AC Block 5   |
//     | 0120 |                |
//     +------+----------------+
//     | 0117 |                |
//     |      |   AC Block 4   |
//     | 0100 |                |
//     +------+----------------+
//     | 0077 |                |
//     |      |   AC Block 3   |
//     | 0060 |                |
//     +------+----------------+
//     | 0057 |                |
//     |      |   AC Block 2   |
//     | 0040 |                |
//     +------+----------------+
//     | 0037 |                |
//     |      |   AC Block 1   |
//     | 0020 |                |
//     +------+----------------+
//     | 0017 |                |
//     |      |   AC Block 0   |
//     | 0000 |                |
//     +------+----------------+
//
// Note
//   In the original circuitry the Control ROM (microcode) was supplied to this
//   module via the dbm input.  This has been replaced by a direct connection
//   to the Control ROM. Presumably this was done because of circuit board
//   interconnection limitations.
//
// File
//   ramfile.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2016 Rob Doyle
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

`include "vma.vh"
`include "pxct.vh"
`include "regir.vh"
`include "useq/crom.vh"

module RAMFILE (
      input  wire          clk,                 // Clock
      input  wire          rst,                 // Reset
      input  wire          clken,               // Clock enable
      input  wire [ 0:107] crom,                // Control ROM Data
      input  wire [ 0: 35] dbus,                // DBUS Input
      input  wire [ 0: 17] regIR,               // Instruction Register
      input  wire          xrPREV,              // XR Previous
      input  wire [ 0: 35] vmaREG,              // VMA Register
      input  wire [ 0:  5] acBLOCK,             // AC Blocks
      output wire [ 0: 35] ramfile              // RAMFILE output
   );

   //
   // IR Fields
   //

   wire [ 9:12] regIR_AC = `IR_AC(regIR);       // Instruction Register AC Field
   wire [14:17] regIR_XR = `IR_XR(regIR);       // Instruction Register XR Field

   //
   // VMA Flags
   //

   wire vmaWRITE = `vmaWRITE(vmaREG);
   wire vmaPHYS  = `vmaPHYS(vmaREG);
   wire vmaPREV  = `vmaPREV(vmaREG);

   //
   // AC Reference
   //
   // Details:
   //  True when addressing lowest 16 addresses using and not
   //  physical addressing.  References to the ACs are never
   //  physical.
   //
   // Trace
   //  DPM4/E160
   //  DPM4/E168
   //  DPM4/E191
   //

   wire vmaACREF = `vmaACREF(vmaREG);

   //
   // AC Blocks
   //

   wire [0:2] currBLOCK = `currBLOCK(acBLOCK);  // Current AC Block
   wire [0:2] prevBLOCK = `prevBLOCK(acBLOCK);  // Previous AC Block

   //
   // Address Mux
   //
   // Details
   //  This mux provide the address for various RAMFILE operations.  The
   //  operations can be:
   //
   //  Access to the RAMFILE ACs are selected using the AC field of the
   //  instruction.
   //
   //  1.  Access to an AC in the current context using the AC field of the
   //      instruction.
   //  2.  Access to an AC in the current context using the XR field of the
   //      instruction.
   //  3.  Access to an AC in the previous context using the XR field of the
   //      instruction.
   //  4.  Access to an AC in the current context using a plain address.
   //  5.  Access to an AC in the previous context using a plain address.
   //  6.  Access to RAMFILE storage.
   //  7.  Access to the cache
   //
   // Note:
   //  The KS10 used {dbm[26:28], dbm[11:17]} for the cromRAMADDR_SEL_NUM case
   //  below.  Since the number field in on both halves of the dbm, this is
   //  equivalent to dbm[8:17].  This has been replaced by a direct connection
   //  to the CROM.
   //
   //  This was a 74LS181 ALU in the KS10.  Only the part of that device that
   //  is used is implemented.  This adder is controlled by one of the
   //  overloaded usages of the CROM number field.
   //
   // Trace
   //  DPE6/E3
   //  DPE6/E6
   //  DPE6/E7
   //  DPE6/E8
   //  DPE6/E13
   //  DPE6/E14
   //  DPE6/E15
   //  DPE6/E16
   //  DPE6/E21
   //  DPE6/E22
   //  DPE6/E23
   //  DPE6/E24
   //  DPE6/E79
   //

   reg [0:9] addr;

   always @*
     begin
        case(`cromRAMADDR_SEL)
          `cromRAMADDR_SEL_AC:
            addr = {3'b0, currBLOCK, regIR_AC };
          `cromRAMADDR_SEL_ACOPNUM:
            case (`cromACALU_FUN)
              6'o25  :
                addr = {3'b0, currBLOCK, `cromACALU_NUM};
              6'o62  :
                addr = {3'b0, currBLOCK, `cromACALU_NUM + regIR_AC};
              default:
                addr = {3'b0, currBLOCK, `cromACALU_NUM};
            endcase
          `cromRAMADDR_SEL_XR:
            begin
               if (xrPREV)
                 addr = {3'b0, prevBLOCK, regIR_XR};
               else
                 addr = {3'b0, currBLOCK, regIR_XR};
            end
          `cromRAMADDR_SEL_VMA:
            begin
               if (vmaACREF)
                 begin
                    if (vmaPREV)
                      addr = {3'b0, prevBLOCK, vmaREG[32:35]};
                    else
                      addr = {3'b0, currBLOCK, vmaREG[32:35]};
                 end
               else
                 addr = {1'b1, vmaREG[27:35]};
            end
          `cromRAMADDR_SEL_RAM:
            addr = vmaREG[26:35];
          `cromRAMADDR_SEL_NUM:
            addr = `cromSNUM;
          default:
            addr = 9'b0;
        endcase
     end

   //
   // RAMFILE Write
   //
   // Trace
   //  DPE5/E119
   //  DPMA/E22
   //  DPMA/E54
   //

   wire ramfileWRITE = ((vmaACREF & vmaWRITE) | (`cromFMWRITE));

   //
   // RAMFILE Memory
   //
   // Note:
   //  There are places when the KS10 microcode reads uninitialized RAMFILE
   //  contents (TTG, for one).  Therefore this includes code to initialize
   //  the RAMFILE contents.
   //
   // Trace
   //  DPE7/E906, DPE7/E907, DPE7/E908, DPE7/E909, DPE7/E910, DPE7/E911
   //  DPE7/E912, DPE7/E913, DPE7/E914, DPE7/E915, DPE7/E916, DPE7/E917
   //  DPE7/E918, DPE7/E919, DPE7/E920, DPE7/E921, DPE7/E922, DPE7/E923
   //  DPE7/E806, DPE7/E807, DPE7/E808, DPE7/E809, DPE7/E810, DPE7/E811
   //  DPE7/E812, DPE7/E813, DPE7/E814, DPE7/E815, DPE7/E816, DPE7/E817
   //  DPE7/E818, DPE7/E819, DPE7/E820, DPE7/E821, DPE7/E822, DPE7/E823
   //

   reg [0:35] ram [0:1023];
   reg [0: 9] rd_addr;

`ifndef SYNTHESIS
   integer i;

   initial
     begin
        for (i = 0; i < 1024; i = i + 1)
          begin
             if (i == 15)
               ram[i] = 36'o777577_030303;      // (Initialize stack pointer)
             else
               ram[i] = 0;
          end
     end
`endif

   always @(negedge clk)
     begin
        if (clken)
          begin
             if (ramfileWRITE)
               ram[addr] <= dbus;
             rd_addr <= addr;
          end
     end

   assign ramfile = ram[rd_addr];

endmodule
