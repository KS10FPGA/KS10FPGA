////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Microsequencer
//
// Details
//   This file implements the KS10 microsequencer.
//
// File
//   useq.v
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
`include "drom.vh"
`include "../alu.vh"
`include "../pcflags.vh"
`include "../regir.vh"

module USEQ (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire         clken,                // Clock Enable
      input  wire         pageFAIL,             // Page Fail
      input  wire [0: 35] dp,                   // Datapath
      input  wire [0: 11] dispDIAG,             // Diagnostic Addr
      input  wire         piINTR,               // External Interrupt
      input  wire         cpuEXEC,              // Execute Switch Active
      input  wire         cpuCONT,              // Continue Switch Active
      input  wire         ioBUSY,               // IO Busy
      input  wire         timerINTR,            // Timer Interrupt
      input  wire         trapCYCLE,            // Trap Cycle
      input  wire         scSIGN,               // SC Sign
      input  wire [0:  8] aluFLAGS,             // ALU Flags
      input  wire         skipJFCL,             // JFCL Instruction
      input  wire         opJRST0,              // JRST 0 Instruction
      input  wire [0:  3] dispPF,               // Page Fail Dispatch
      input  wire [0:  3] dispNI,               // Next Instruction Dispatch
      input  wire [0:  3] dispBYTE,             // Byte Size/Position Dispatch
      input  wire [0:  3] dispSCAD,             // SCAD Dispatch
      input  wire [0: 17] regIR,                // Instruction Register
      input  wire [0: 17] pcFLAGS,              // PC Flags
      input  wire [0: 35] drom,                 // Dispatch ROM Data
      output wire [0:107] crom                  // Control ROM Data
   );

   //
   // ALU Flags
   //

   wire aluQR37    = `aluQR37(aluFLAGS);
   wire aluLZERO   = `aluLZERO(aluFLAGS);
   wire aluRZERO   = `aluRZERO(aluFLAGS);
   wire aluLSIGN   = `aluLSIGN(aluFLAGS);
   wire aluRSIGN   = `aluRSIGN(aluFLAGS);
   wire aluCRY0    = `aluCRY0(aluFLAGS);
   wire aluCRY1    = `aluCRY1(aluFLAGS);
   wire aluCRY2    = `aluCRY2(aluFLAGS);
   wire aluZERO    = `aluZERO(aluFLAGS);

   //
   // PC Flags
   //

   wire flagFPD    = `flagFPD(pcFLAGS);
   wire flagUSER   = `flagUSER(pcFLAGS);
   wire flagUSERIO = `flagUSERIO(pcFLAGS);

   //
   // Instruction Register
   //

   wire [ 9:12] regIR_AC  = `IR_AC(regIR);
   wire         regIR_I   = `IR_I(regIR);
   wire         regACZERO = `acZERO(regIR);
   wire         regXRZERO = `xrZERO(regIR);

   //
   // Control ROM Address
   //

   wire [0:11] dispRET;
   wire [0:11] skipADDR;
   wire [0:11] dispADDR;

   //
   // ALU Zero
   //

   wire txxx    = aluZERO != `dromTXXXEN;       // Test Instruction Results

   //
   // Dispatch Addresses
   //

   wire [8:11] dispMUL  = {1'b0,     aluQR37, 1'b0,      1'b0};
   wire [8:11] dispEA   = {~opJRST0, regIR_I, regXRZERO, 1'b0};
   wire [8:11] dispNORM = {aluZERO,  dp[8:9], aluLSIGN};

   //
   // Skip Logic
   //
   // Details
   //  The skip logic allows the sequencer to conditionally jump forward one
   //  micro-instruction.
   //
   // Note:
   //  Like the dispatch, the skip logic can only set bits.  The skip must take
   //  place on an even address.
   //

   SKIP uSKIP (
      .crom(crom),
      .skip40({aluCRY0,   aluLZERO, aluRZERO, !flagUSER,  flagFPD,  regACZERO, piINTR    }),
      .skip20({aluCRY2,   aluLSIGN, aluRSIGN, flagUSERIO, skipJFCL, aluCRY1,   txxx      }),
      .skip10({trapCYCLE, aluZERO,  scSIGN,   cpuEXEC,    !ioBUSY , !cpuCONT,  !timerINTR}),
      .skipADDR(skipADDR)
   );

   //
   // Dispatch Logic
   //
   // Details
   //  The dromJ is implemented slightly different than the KS-10.  In the
   //  KS10, the DROM J value is constained to be between 1400 and 1777.  This
   //  allows the dispatch function to hardwire the upper 4 data bits instead
   //  of storing them in the DROM.
   //
   //  I've hooked all data lines up and will let the optimizer do it's thing.
   //  The optimizer will determine that these lines never change and replace
   //  the DROM columns with hardwired constants.  This design approach makes
   //  the design intent much more obvious.
   //
   // Notes
   //  Watch the index numbering on DROM_J!
   //
   //  AREAD does dispatch to address 40-57 or address 1400-1777
   //
   //  Quoting the KS10 Technical Manual:
   //
   //   dromAEQJ -  "This bit causes an immediate dispatch on the J field when
   //               the microword calls for the standard AREAD dispatch on the
   //               A field. This is used for instructions that require no
   //               memory access or special setup (for example, MOVEI, JFCL)".
   //
   //  dromACDISP - "This bit causes the AC field of the instruction word to
   //               replace the right four bits of the J field so that a jump
   //               to begin instruction execution will actually dispatch to
   //               one of 16 locations where the instruction code is expanded
   //               to 13 bits."
   //
   // Trace:
   //  DPEA/E111
   //  DPEA/E153
   //  CRA2/E158
   //

   wire        dromAEQJ   = `dromAEQJ;
   wire        dromACDISP = `dromACDISP;
   wire [0:11] dromJ      = `dromJ;
   wire [0: 3] dromA      = `dromA;
   wire [0: 3] dromB      = `dromB;

   //
   // Jump Dispatch
   //
   // Trace
   //  DPEA/E111
   //

   reg [0:11] dispJ;
   always @(dromACDISP, regIR_AC, dromJ)
     begin
        if (dromACDISP)                         // Dispatch Address Range:
          dispJ = {dromJ[0:7], regIR_AC};       // 1400 to 1777
        else
          dispJ = {dromJ[0:7], dromJ[8:11]};    // 1400 to 1777
     end

   //
   // AREAD Dispatch
   //
   // Trace
   //  CRA2/E158
   //  DPEA/E153
   //

   reg [0:11] dispAREAD;
   always @(dromAEQJ, dispJ, dromA)
     begin
        if (dromAEQJ)                           // Dispatch Address Range:
          dispAREAD = dispJ;                    // 1400 to 1777
        else
          dispAREAD = {8'b00000010, dromA};     // 0040 to 0057
     end

   //
   // Dispatch MUX
   //

   DISPATCH uDISPATCH (
      .crom             (crom),
      .dp               (dp),
      .dispDIAG         (dispDIAG),
      .dispRET          (dispRET),
      .dispJ            (dispJ),
      .dispAREAD        (dispAREAD),
      .dispMUL          (dispMUL),
      .dispPF           (dispPF),
      .dispNI           (dispNI),
      .dispBYTE         (dispBYTE),
      .dispEA           (dispEA),
      .dispSCAD         (dispSCAD),
      .dispNORM         (dispNORM),
      .dispDROM_A       (dromA),
      .dispDROM_B       (dromB),
      .dispADDR         (dispADDR)
   );

   //
   // Address 'MUX'
   //
   // Details
   //  The CROM registers have been absorbed by the synchronous FPGA ROM.
   //  Therefore the initial state of the microcode (address zero) must be
   //  handled explicitly.
   //
   //  The Microcode should begin execution at address o0000.
   //
   //  The microsequencer continuously re-executes instruction at address
   //  o0000 while the rst signal is asserted.  It can only execute the second
   //  instruction after the 'rst' signal is negated.
   //
   //  This process assumes that the 'rst' negation is synchronized to the
   //  clock and that the 'rst' signal is asserted for a few clock cycles
   //  minimum to ensure that the instruction at address o0000 is executed at
   //  least once.
   //
   //  The synchronous 'rst' negation is handled earlier in the design
   //  heirarchy.
   //
   //  The Page Fail address is hardwired to address o3777 on machines with 2K
   //  words of microcode and hardwired to address o7777 on machines with 4K
   //  words of microcode.
   //
   // Trace:
   //  CRA1/E9
   //  CRA1/E18
   //  CRA1/E24
   //  CRA1/E25
   //  CRA1/E26
   //  CRA1/E35
   //  CRA1/E111
   //  CRA1/E121
   //  CRA1/E174
   //  CRA1/E183
   //  CRA1/E184
   //  CRA1/E186
   //

   wire [0:11] addr = (rst)      ? 12'o0000 :
                      (pageFAIL) ? 12'o7777 :
                      (dispADDR  | skipADDR | `cromJ);

   //
   // Control ROM
   //

   CROM uCROM (
      .clk      (clk),
      .clken    (clken),
      .addr     (addr),
      .crom     (crom)
   );

   //
   // Call/Return Instruction Decode:
   //
   // Details:
   //  The address is pushed on the stack during a call or when a PAGE FAIL
   //  occurs.
   //
   // Note:
   //  The KS10 logic decodes a 'return dispatch' as "x0xx01" but only o01 and
   //  o41 are used by the microcode.
   //
   // Trace
   //  CRA2/E33
   //  CRA2/E34
   //

   wire call = `cromCALL | pageFAIL;
   wire ret  = ((`cromDISP == 6'o01) ||   // used
                (`cromDISP == 6'o05) ||   // not used
                (`cromDISP == 6'o11) ||   // not used
                (`cromDISP == 6'o15) ||   // not used
                (`cromDISP == 6'o41) ||   // used
                (`cromDISP == 6'o45) ||   // not used
                (`cromDISP == 6'o51) ||   // not used
                (`cromDISP == 6'o55));    // not used

   //
   // Call/Return Stack
   //

   STACK uSTACK (
      .clk      (clk),
      .rst      (rst),
      .clken    (clken),
      .call     (call),
      .ret      (ret),
      .addrIN   (addr),
      .addrOUT  (dispRET)
   );

endmodule
