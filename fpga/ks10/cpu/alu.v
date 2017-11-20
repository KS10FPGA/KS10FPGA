////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Arithmetic Logic Unit (ALU)
//
// Details
//   The KS10 ALU implementation uses ten cascaded am2901 4-bit slices.  Some
//   quick study showed that this did not work well with an FPGA implemenation.
//   Most FPGAs have optimized (very fast) carry logic to support counters and
//   adders.  It turns out that the synthesis tools can't infer from the
//   description of the 4-bit slices that a single 40-bit carry chain exists
//   from the LSB to the MSB.  Therefore this ALU is implemented as two 20-bit
//   ALUs.  The two 20-bit ALUs are required because the two ALU halves must
//   operate together forming a single 40-bit ALU and must operate separately
//   to form two independant registers.
//
// Note
//   The ALU bit numbering on the schematic is [-2,-1,0:37].  This doesn't work
//   at all for verilog.   Therefore the bit numbering is [0:39].
//
// File
//   alu.v
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

`include "alu.vh"
`include "useq/crom.vh"

module ALU (
      input  wire          clk,         // Clock
      input  wire          rst,         // Reset
      input  wire          clken,       // Clock enable
      input  wire [ 0:107] crom,        // Control ROM Data
      input  wire [ 0: 35] aluIN,       // Bus input
      output wire [ 0:  8] aluFLAGS,    // ALU Flags
      output wire [ 0: 35] aluOUT,      // ALU Output
      output wire [18: 35] aluPC,       // Program Counter
      output wire [ 0: 35] aluHR        // Instruction Register
   );

   //
   // Microcode fields
   //
   // Note
   //  These temporaries are created so I can see the microcode fields in the
   //  simulator.  The synthesis optimizer deletes them.
   //

   reg  [0:39] f;                               // ALU Output
   reg  [0:39] q;                               // Q Register Output
   wire [0: 2] fun     = `cromFUN;              // ALU Function
   wire [0: 2] lsrc    = `cromLSRC;             // ALU Source (Left Side)
   wire [0: 2] rsrc    = `cromRSRC;             // ALU Source (Right Size)
   wire [0: 2] dst     = `cromDST;              // ALU Destination
   wire        lclken  = `cromLCLKEN;           // ALU CLock (Left Side)
   wire        rclken  = `cromRCLKEN;           // ALU Clock (Right Side)
   wire [0: 3] aa      = `cromALU_A;            // ALU DPRAM A Address
   wire [0: 3] ba      = `cromALU_B;            // ALU DPRAM B Address
   wire [0: 2] shstyle = `cromSPEC_SHSTYLE;     // ALU Shift Mode

   //
   // Registers
   //

   reg multi_shift;
   reg divide_shift;
   reg carry_in;
   reg funct_02;

   //
   // Carry Inhibit
   //
   // Details
   //  Inhibit the carry from right half of the ALU to left half of the ALU
   //

   wire specCRY18INH = `cromSPEC_EN_40 & (`cromSPEC_SEL == `cromSPEC_SEL_CRY18INH);

   //
   // Destination Address Munging
   //
   // Note
   //  DST[1] is inverted.
   //
   //  When the ALU is configured for shift operations, the dst[1] signal
   //  selects between right shifts and left shifts.
   //
   //  In the KS10, the dst[1] selects tri-state muxes that implement the
   //  right-shift and left-shift operations.   This isn't necessary on the
   //  FPGA implementation because there aren't any tristate pins on the ALU.
   //  I just don't want to change the microcode.   So it stays.
   //
   // Trace
   //  DPE5/E62
   //

   wire [0:2] dest = {dst[0], ~dst[1], dst[2]};

   //
   // Function Munging
   //
   // Note
   //  FUN[2] is munged on DPE5
   //
   //  When fun[0] and fun[1] are both zero, fun[2] selects between add and
   //  subtract operations. This is used in the divide implementation and the
   //  other multiprecision operations.
   //
   // Trace
   //  DPE5/E62
   //  DPE5/E5
   //

   wire [0:2] func = {fun[0], fun[1], funct_02};

   //
   // ALU Register Write
   //
   // Note
   //  The following ALU destinations write data into the ALU registers.
   //

   wire write = ((dest ==`cromDST_RAMA)  ||
                 (dest ==`cromDST_RAMF)  ||
                 (dest ==`cromDST_RAMQD) ||
                 (dest ==`cromDST_RAMQU) ||
                 (dest ==`cromDST_RAMD)  ||
                 (dest ==`cromDST_RAMU));

   //
   // Input Sign Extension
   //
   // Details
   //  The ALU is 40-bits wide.  The input is sign extended from 36 bits to 38
   //  bits on the left and two bits of zero padding are added to the right.
   //
   // Trace
   //  DPE1/E29  (MSB/Sign Extension)
   //  DPE2/E157 (LSB/Zero pad)
   //

   wire [0:39] dd = {aluIN[0], aluIN[0], aluIN[0:35], 2'b00};

   //
   // Shifter Operations:
   //
   // Details
   //  The am2901s are wired together to perform specific shift operation
   //  controlled by the cromSPEC_SHSTYLE microcode field.  The ASCII art
   //  pictures below detail the various shifter modes.
   //
   // Note
   //  All of the F shifter logic is external to the am2901s.
   //
   //  Shift Left Operations
   //
   //            +--------- F shifter --------+      +--------- Q shifter --------+
   //            |                            |      |                            |
   //
   //                                   multi_shift
   //                                        |
   //             +----+       +----------+  |         +----+       +----------+
   //  NORM       |0123|<------|4       39|<-+         |0123|<------|4       39|<---- 0
   //             +----+       +----------+            +----+       +----------+
   //
   //              +------+
   //              |      |
   //             +----+  |    +----------+            +----+       +----------+
   //  ZER0       |0123|<-+    |4       39|<---- 0     |0123|<------|4       39|<---- 0
   //             +----+       +----------+            +----+       +----------+
   //
   //              +------+
   //              |      |
   //             +----+  |    +----------+            +----+       +----------+
   //  ONES       |0123|<-+    |4       39|<---- 1     |0123|<------|4       39|<---- 1
   //             +----+       +----------+            +----+       +----------+
   //
   //              +------+  +---------------+                    +---------------+
   //              |      |  |               |                    |               |
   //             +----+  |  | +----------+  |         +----+     | +----------+  |
   //  ROT        |0123|<-+  +-|4       39|<-+         |0123|<----+-|4       39|<-+
   //             +----+       +----------+            +----+       +----------+
   //
   //              +------+
   //              |      |
   //             +----+  |    +----------+            +----+       +----------+
   //  ASHC       |0123|<-+    |4       39|<----+      |0123|<----+-|4       39|<---- 0
   //             +----+       +----------+     |      +----+     | +----------+
   //                                           |                 |
   //                                           +-----------------+
   //
   //             +----+       +----------+            +----+       +----------+
   //  LSHC       |0123|<------|4       39|<----+      |0123|<----+-|4       39|<---- 0
   //             +----+       +----------+     |      +----+     | +----------+
   //                                           |                 |
   //                                           +-----------------+
   //
   //             +----+       +----------+            +----+       +----------+
   //  DIV        |0123|<------|4       39|<----+      |0123|<----+-|4       39|<---- divide_shift
   //             +----+       +----------+     |      +----+     | +----------+
   //                                           |                 |
   //                                           +-----------------+
   //
   //              +------+  +----------------------------------------------------+
   //              |      |  |                                                    |
   //             +----+  |  | +----------+            +----+       +----------+  |
   //  ROTC       |0123|<-+  +-|4       39|<----+      |0123|<----+-|4       39|<-+
   //             +----+       +----------+     |      +----+     | +----------+
   //                                           |                 |
   //                                           +-----------------+
   //
   //  Shift Right Operations
   //
   //            +--------- F shifter --------+      +--------- Q shifter --------+
   //            |                            |      |                            |
   //
   //          +---+                                0
   //          |   |                                |
   //          |  +----+       +----------+         |  +----+       +----------+
   //  NORM    +->|0123|------>|4       39|         +->|0123|------>|4       39|
   //             +----+       +----------+            +----+       +----------+
   //
   //          +---+        0                       0            0
   //          |   |        |                       |            |
   //          |  +----+    |  +----------+         |  +----+    |  +----------+
   //  ZEROS   +->|0123|    +->|4       39|         +->|0123|    +->|4       39|
   //             +----+       +----------+            +----+       +----------+
   //
   //          +---+        1                       0            1
   //          |   |        |                       |            |
   //          |  +----+    |  +----------+         |  +----+    |  +----------+
   //  ONES    +->|0123|    +->|4       39|         +->|0123|    +->|4       39|
   //             +----+       +----------+            +----+       +----------+
   //
   //          +---+        +---------------+       0            +---------------+
   //          |   |        |               |       |            |               |
   //          |  +----+    |  +----------+ |       |  +----+    |  +----------+ |
   //  ROT     +->|0123|    +->|4       39|-+       +->|0123|    +->|4       39|-+
   //             +----+       +----------+            +----+       +----------+
   //
   //          +---+                                0
   //          |   |                                |
   //          |  +----+       +----------+         |  +----+       +----------+
   //  ASHC    +->|0123|------>|4       39|-----+   +->|0123|    +->|4       39|
   //             +----+       +----------+     |      +----+    |  +----------+
   //                                           |                |
   //                                           +----------------+
   //
   //          +---+        0                       0
   //          |   |        |                       |
   //          |  +----+    |  +----------+         |  +----+       +----------+
   //  LSHC    +->|0123|    +->|4       39|-----+   +->|0123|    +->|4       39|
   //             +----+       +----------+     |      +----+    |  +----------+
   //                                           |                |
   //                                           +----------------+
   //
   //          +---+        1                       0
   //          |   |        |                       |
   //          |  +----+    |  +----------+         |  +----+       +----------+
   //  DIV     +->|0123|    +->|4       39|-----+   +->|0123|    +->|4       39|
   //             +----+       +----------+     |      +----+    |  +----------+
   //                                           |                |
   //                                           +----------------+
   //
   //          +---+        +----------------------------------------------------+
   //          |   |        |                       0                            |
   //          |  +----+    |  +----------+         |  +----+       +----------+ |
   //  ROTC    +->|0123|    +->|4       39|-----+   +->|0123|    +->|4       39|-+
   //             +----+       +----------+     |      +----+    |  +----------+
   //                                           |                |
   //                                           +----------------+
   // Trace:
   //  DPE1/E12
   //  DPE1/E20
   //  DPE1/E41
   //  DPE1/E48
   //  DPE1/E71
   //

   reg [0:39] bdi;
   always @*
     begin
        if (dest == `cromDST_RAMQU || dest == `cromDST_RAMU)
          case (shstyle)
            `cromSPEC_SHSTYLE_NORM:
              bdi = {f[1:3], f[4], f[5:39], multi_shift};
            `cromSPEC_SHSTYLE_ZERO:
              bdi = {f[1:3], f[0], f[5:39], 1'b0};
            `cromSPEC_SHSTYLE_ONES:
              bdi = {f[1:3], f[0], f[5:39], 1'b1};
            `cromSPEC_SHSTYLE_ROT:
              bdi = {f[1:3], f[0], f[5:39], f[4]};
            `cromSPEC_SHSTYLE_ASHC:
              bdi = {f[1:3], f[0], f[5:39], q[4]};
            `cromSPEC_SHSTYLE_LSHC:
              bdi = {f[1:3], f[4], f[5:39], q[4]};
            `cromSPEC_SHSTYLE_DIV:
              bdi = {f[1:3], f[4], f[5:39], q[4]};
            `cromSPEC_SHSTYLE_ROTC:
              bdi = {f[1:3], f[0], f[5:39], q[4]};
          endcase
        else if (dest == `cromDST_RAMQD ||  dest == `cromDST_RAMD)
          case (shstyle)
            `cromSPEC_SHSTYLE_NORM:
              bdi = {f[0], f[0:2], f[3],  f[4:38]};
            `cromSPEC_SHSTYLE_ZERO:
              bdi = {f[0], f[0:2], 1'b0,  f[4:38]};
            `cromSPEC_SHSTYLE_ONES:
              bdi = {f[0], f[0:2], 1'b1,  f[4:38]};
            `cromSPEC_SHSTYLE_ROT:
              bdi = {f[0], f[0:2], f[39], f[4:38]};
            `cromSPEC_SHSTYLE_ASHC:
              bdi = {f[0], f[0:2], f[3],  f[4:38]};
            `cromSPEC_SHSTYLE_LSHC:
              bdi = {f[0], f[0:2], 1'b0,  f[4:38]};
            `cromSPEC_SHSTYLE_DIV:
              bdi = {f[0], f[0:2], 1'b1,  f[4:38]};
            `cromSPEC_SHSTYLE_ROTC:
              bdi = {f[0], f[0:2], q[39], f[4:38]};
          endcase
        else
          bdi = f;
     end

   //
   // ALU RAM Write Port
   //
   // Note
   //  The left side and right side of the ALU can be independantly clocked and
   //  updated.
   //

   reg [0:39] aluRAM [0:15];

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             aluRAM[ 0] <= 40'b0;
             aluRAM[ 1] <= 40'b0;
             aluRAM[ 2] <= 40'b0;
             aluRAM[ 3] <= 40'b0;
             aluRAM[ 4] <= 40'b0;
             aluRAM[ 5] <= 40'b0;
             aluRAM[ 6] <= 40'b0;
             aluRAM[ 7] <= 40'b0;
             aluRAM[ 8] <= 40'b0;
             aluRAM[ 9] <= 40'b0;
             aluRAM[10] <= 40'b0;
             aluRAM[11] <= 40'b0;
             aluRAM[12] <= 40'b0;
             aluRAM[13] <= 40'b0;
             aluRAM[14] <= 40'b0;
             aluRAM[15] <= 40'b0;
          end
        else
          if (clken)
            begin
               if (lclken & write)
                 aluRAM[ba][ 0:19] <= bdi[ 0:19];
               if (rclken & write)
                 aluRAM[ba][20:39] <= bdi[20:39];
            end
     end

   //
   // ALU RAM Read Port(s)
   //
   // Details
   //  The am2901 latches the addresses when the clock is low. These latches
   //  would be a problem for an FPGA design.  Latching the address lines is
   //  not necessary anyway because the RAM address lines come directly from
   //  the CROM which is already registered.   We'll absorb the address latch
   //  into the CROM register.
   //
   // Note:
   //  This asynchronous read (and asynchronous reset) causes the RAM to be
   //  built out of distributed RAM or flip-flops.   If this turns into a too
   //  wasteful (576 flip-flops), we can pipeline the CROM register: use the
   //  early CROM to set the read address the synchronous RAM and use the
   //  pipelined delayed CROM for everything else.   When combined, the clock
   //  delayed output of the synchronous RAM would be pipelined correctly
   //  with the rest of the CROM.
   //
   //  Since the registers are implemented in flip-flops, it is no problem
   //  to add a third port to the ALU RAM for debugging or a front panel
   //  interface.
   //

   wire [0:39] ad = aluRAM[aa];
   wire [0:39] bd = aluRAM[ba];

   //
   // Q Register Shifter
   //
   // Note:
   //  All of the Q shifer logic is external to the am2901s.
   //

   reg [0:39] qi;
   always @*
     begin
        case (dest)
          `cromDST_RAMQU:
            case (shstyle)
              `cromSPEC_SHSTYLE_NORM:
                qi <= {q[1:39], 1'b0};
              `cromSPEC_SHSTYLE_ZERO:
                qi <= {q[1:39], 1'b0};
              `cromSPEC_SHSTYLE_ONES:
                qi <= {q[1:39], 1'b1};
              `cromSPEC_SHSTYLE_ROT:
                qi <= {q[1:39], q[4]};
              `cromSPEC_SHSTYLE_ASHC:
                qi <= {q[1:39], 1'b0};
              `cromSPEC_SHSTYLE_LSHC:
                qi <= {q[1:39], 1'b0};
              `cromSPEC_SHSTYLE_DIV:
                qi <= {q[1:39], divide_shift};
              `cromSPEC_SHSTYLE_ROTC:
                qi <= {q[1:39], f[4]};
            endcase
          `cromDST_RAMQD:
            case (shstyle)
              `cromSPEC_SHSTYLE_NORM:
                qi <= {1'b0, q[0:2], q[3],  q[4:38]};
              `cromSPEC_SHSTYLE_ZERO:
                qi <= {1'b0, q[0:2], 1'b0,  q[4:38]};
              `cromSPEC_SHSTYLE_ONES:
                qi <= {1'b0, q[0:2], 1'b1,  q[4:38]};
              `cromSPEC_SHSTYLE_ROT:
                qi <= {1'b0, q[0:2], q[39], q[4:38]};
              `cromSPEC_SHSTYLE_ASHC:
                qi <= {1'b0, q[0:2], f[39], q[4:38]};
              `cromSPEC_SHSTYLE_LSHC:
                qi <= {1'b0, q[0:2], f[39], q[4:38]};
              `cromSPEC_SHSTYLE_DIV:
                qi <= {1'b0, q[0:2], f[39], q[4:38]};
              `cromSPEC_SHSTYLE_ROTC:
                qi <= {1'b0, q[0:2], f[39], q[4:38]};
            endcase
          `cromDST_QREG:
            qi <= f;
          `cromDST_NOP,
          `cromDST_RAMA,
          `cromDST_RAMF,
          `cromDST_RAMD,
          `cromDST_RAMU:
            qi <= q;
        endcase
     end

   //
   // Q Register
   //
   // Details
   //  The left side and right side of the Q Register can be independantly
   //  clocked and updated.  I'm not sure if the microcode does that, or not.
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          q[ 0:39] <= 40'b0;
        else
          if (clken)
            begin
               if (lclken)
                 q[ 0:19] <= qi[ 0:19];
               if (rclken)
                 q[20:39] <= qi[20:39];
            end
     end

   //
   // ALU Left R Source Selector
   //
   // Details
   //  This selects source for the "R" input to the left-half of the ALU.
   //

   reg [0:39] r;

   always @*
     begin
        case (lsrc)
          `cromSRC_AQ,
          `cromSRC_AB:
            r[0:19] = ad[0:19];
          `cromSRC_ZQ,
          `cromSRC_ZB,
          `cromSRC_ZA:
            r[0:19] = 20'b0;
          `cromSRC_DA,
          `cromSRC_DQ,
          `cromSRC_DZ:
            r[0:19] = dd[0:19];
        endcase
     end

   //
   // ALU Right R Source Selector
   //
   // Details
   //  This selects source for the "R" input to the right-half of the ALU.
   //

   always @*
     begin
        case (rsrc)
          `cromSRC_AQ,
          `cromSRC_AB:
            r[20:39] = ad[20:39];
          `cromSRC_ZQ,
          `cromSRC_ZB,
          `cromSRC_ZA:
            r[20:39] = 20'b0;
          `cromSRC_DA,
          `cromSRC_DQ,
          `cromSRC_DZ:
            r[20:39] = dd[20:39];
        endcase
     end

   //
   // ALU Left S Source Selector
   //
   // Details
   //  This selects source for the "S" input to the left-half of the ALU.
   //

   reg [0:39] s;

   always @*
     begin
        case (lsrc)
          `cromSRC_AQ,
          `cromSRC_ZQ,
          `cromSRC_DQ:
            s[0:19] = q[0:19];
          `cromSRC_AB,
          `cromSRC_ZB:
            s[0:19] = bd[0:19];
          `cromSRC_ZA,
          `cromSRC_DA:
            s[0:19] = ad[0:19];
          `cromSRC_DZ:
            s[0:19] = 20'b0;
        endcase
     end

   //
   // ALU Right S Source Selector
   //
   // Details
   //  This selects source for the "S" input to the right-half of the ALU.
   //

   always @*
     begin
        case (rsrc)
          `cromSRC_AQ,
          `cromSRC_ZQ,
          `cromSRC_DQ:
            s[20:39] = q[20:39];
          `cromSRC_AB,
          `cromSRC_ZB:
            s[20:39] = bd[20:39];
          `cromSRC_ZA,
          `cromSRC_DA:
            s[20:39] = ad[20:39];
          `cromSRC_DZ:
            s[20:39] = 20'b0;
        endcase
     end

   //
   // ALU Proper
   //
   // Details
   //  The ALU is somewhat optimized so that the carry chain can be optimized.
   //  Instead of adding logic into the middle of the carry to separate the
   //  left half and the right half of the ALU, the left half, the right half,
   //  and the whole ALU are calculated in parallel.
   //

   reg [0:3] g;                         // ALU Partial Sum
   reg       co;                        // Carry out of left half
   reg       go;                        // Partial sum for calculating CRY2
   wire      ci = carry_in;             // Carry into right half
   reg       bb;                        // Bit Bucket

   always @*
     begin
        co  = 1'b0;
        go  = 1'b0;
        g   = 4'b0;
        case (func)
          `cromFUN_ADD:
            begin
               {go, g[ 0: 3]} = {1'b0, r[ 0: 3]} + {1'b0, s[ 0: 3]};
               if (specCRY18INH)
                 begin
                    {bb, f[20:39]} = {1'b0, r[20:39]} + {1'b0, s[20:39]} + ci;          // Right Half
                    {co, f[ 0:19]} = {1'b0, r[ 0:19]} + {1'b0, s[ 0:19]};               // Left Half (assumes no carry)
                 end
               else
                 begin
                    {co, f[ 0:39]} = {1'b0, r[ 0:39]} + {1'b0, s[ 0:39]} + ci;          // Whole ACC
                 end
            end
          `cromFUN_SUBR:
            begin
               {go, g[ 0: 3]} = {1'b0, ~r[ 0: 3]} + {1'b0, s[ 0: 3]};
               if (specCRY18INH)
                 begin
                    {bb, f[20:39]} = {1'b0, ~r[20:39]} + {1'b0, s[20:39]} + ci;         // Right Half
                    {co, f[ 0:19]} = {1'b0, ~r[ 0:19]} + {1'b0, s[ 0:19]};              // Left Half (assumes no carry)
                 end
               else
                 begin
                    {co, f[ 0:39]} = {1'b0, ~r[ 0:39]} + {1'b0, s[ 0:39]} + ci;         // Whole ACC
                 end
            end
          `cromFUN_SUBS:
            begin
               {go, g[ 0: 3]} = {1'b0, r[ 0: 3]} + {1'b0, ~s[ 0: 3]};
               if (specCRY18INH)
                 begin
                    {bb, f[20:39]} = {1'b0, r[20:39]} + {1'b0, ~s[20:39]} + ci;         // Right Half
                    {co, f[ 0:19]} = {1'b0, r[ 0:19]} + {1'b0, ~s[ 0:19]};              // Left Half (assumes no carry)
                 end
               else
                 begin
                    {co, f[ 0:39]} = {1'b0, r[ 0:39]} + {1'b0, ~s[ 0:39]} + ci;         // Whole ACC
                 end
            end
          `cromFUN_ORRS:
            f = r | s;
          `cromFUN_ANDRS:
            f = r & s;
          `cromFUN_NOTRS:
            f = ~r & s;
          `cromFUN_EXOR:
            f = r ^ s;
          `cromFUN_EXNOR:
            f = ~(r ^ s);
        endcase
     end

   //
   // ALU Sign outputs
   //

   wire aluLSIGN = f[ 0];
   wire aluRSIGN = f[20];

   //
   // ALU Zero outputs
   //

   wire aluLZERO = f[ 0:19] == 20'b0;
   wire aluRZERO = f[20:39] == 20'b0;

   //
   // Arithmetic Overflow (aluAOV)
   //
   // Details
   //  Arithmetic overflow occurs when the sign is different than the MSB
   //
   // Trace
   //  DPE9/E26
   //

   wire aluAOV = aluLSIGN != f[2];

   //
   // aluCRY0
   //
   // Details
   //  This is the carry form ALU bit -2 (Verilog bit 0).  In the KS10, this
   //  signal comes from the carry skippers. In the FPGA implementation, the
   //  'co' signal comes directly from the ALU serial carry from the MSB.
   //
   //  Note that the CRY0 doesn't actually come from bit 0: it comes from bit
   //  (-2) using KS10 numbering.  Because the top two bits are sign extensions,
   //  they are equivalent.  A carry from bit 0 will cause a carry into bit (-1)
   //  and a carry from bit (-1) will cause a carry into bit (-2).
   //

   wire aluCRY0 = co;

   //
   // aluCRY1
   //
   // Details
   //  A carry from bit 1 must have occured if the Arithmetic Overflow bit is
   //  different than the carry from bit 0.
   //
   // Trace:
   //  DPE9/E26
   //

   wire aluCRY1 = aluAOV != aluCRY0;

   // aluCRY2:
   //
   // Details
   //  This is the carry from ALU bit 2 into ALU bit 1.  In Verilog numbering
   //  (see notes at top of file), this is a carry from ALU bit 4 into ALU bit
   //  3.  We don't really have access to the carry from ALU bit 4, but we
   //  infer it by recalculating the 4 MSBs with the carry cleared, and
   //  checking to see if it yields the same results as the full calculation.
   //  If either the carry or the top four bits are different, there must have
   //  been a carry from ALU bit 2.
   //

   wire aluCRY2 = ((go != co) | (f[0:3] != g[0:3]));

   //
   // QR37
   //
   // Details
   //  This is what is shifted out of the LSB of the Q Register and is used by
   //  the multiplication implementation.  I.e., it goes to the multiplication
   //  dispatch logic to control whether to add (or not) the partial product.
   //
   // Note
   //  This is actually QR39 using Verilog numbering.
   //

   reg flagQR37;

   //
   // ALU Flag State Register
   //
   // Details
   //  These registers store ALU state from one microinstruction to the next.
   //  This state facilates the implementation of multi-word shifts as well as
   //  mutiplication and divide operations.
   //
   // Trace
   //  DPE5/E28
   //

   reg flagFL02;
   reg flagCARRY02;
   reg flagFUNCT02;
   reg flagCARRYOUT;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             flagFL02     <= 1'b0;
             flagQR37     <= 1'b0;
             flagCARRY02  <= 1'b0;
             flagFUNCT02  <= 1'b0;
             flagCARRYOUT <= 1'b0;
          end
        else
          if (clken)
            begin
               flagFL02     <= bdi[3];
               flagQR37     <= q[39];
               flagCARRY02  <= aluCRY2;
               flagFUNCT02  <= funct_02;
               flagCARRYOUT <= aluCRY0;
            end
     end

   //
   // Shifter Configuration
   //
   // Details
   //  This logic contains special connections to the shifter that support
   //  multishift and divide operations.
   //
   //  The special operations are controlled by the `cromMULTIPREC and
   //  `cromDIVIDE microcode fields.
   //
   // Trace
   //  DPE5/E4
   //  DPE5/E5
   //  DPE5/E6
   //  DPE5/E62
   //  DPE5/E70
   //

   always @*
     begin

        //
        // Multiprecision operations
        //

        if (`cromMULTIPREC)
          begin
             multi_shift  <= flagFL02;
             divide_shift <= 1'b0;
             carry_in     <= flagCARRY02 | `cromCRY38;
             funct_02     <= flagFUNCT02 | fun[2];
          end

        //
        // Divide operations
        //

        else if (`cromDIVIDE)
          begin
             multi_shift  <= 1'b0;
             divide_shift <= flagCARRYOUT;
             carry_in     <= flagCARRYOUT | `cromCRY38;
             funct_02     <= flagCARRYOUT | fun[2];
          end

        //
        // Nothing special.  Carry in is controlled by microcode.  Everything
        // else special is disabled.
        //

        else
          begin
             multi_shift  <= 1'b0;
             divide_shift <= 1'b0;
             carry_in     <= `cromCRY38;
             funct_02     <= fun[2];
          end
     end

   //
   // ALU Destination Selector
   //
   // Details
   //  Select ALU output and truncate output bus from 40 bits to 36 bits.
   //

   assign aluOUT = (dest ==`cromDST_RAMA) ? ad[2:37] : f[2:37];

   //
   // Make Program Counter and Instruction Register available
   //

   assign aluPC = aluRAM[`aluPC][20:37];
   assign aluHR = aluRAM[`aluHR][ 2:37];

   //
   // ALU Flags
   //

   assign aluFLAGS[0] = flagQR37;
   assign aluFLAGS[1] = aluLZERO;
   assign aluFLAGS[2] = aluRZERO;
   assign aluFLAGS[3] = aluLSIGN;
   assign aluFLAGS[4] = aluRSIGN;
   assign aluFLAGS[5] = aluAOV;
   assign aluFLAGS[6] = aluCRY0;
   assign aluFLAGS[7] = aluCRY1;
   assign aluFLAGS[8] = aluCRY2;

endmodule
