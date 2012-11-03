////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      Microcontroller
//!
//! \details
//!      This file implements the KS10 microsequencer.
//!
//! \file
//!      useq.v
//!
//! \author
//!      Rob Doyle - doyle (at) cox (dot) net
//!
////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2012 Rob Doyle
//
// This source file may be used and distributed without
// restriction provided that this copyright statement is not
// removed from the file and that any derivative work contains
// the original copyright notice and the associated disclaimer.
//
// This source file is free software; you can redistribute it
// and/or modify it under the terms of the GNU Lesser General
// Public License as published by the Free Software Foundation;
// version 2.1 of the License.
//
// This source is distributed in the hope that it will be
// useful, but WITHOUT ANY WARRANTY; without even the implied
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
// PURPOSE. See the GNU Lesser General Public License for more
// details.
//
// You should have received a copy of the GNU Lesser General
// Public License along with this source; if not, download it
// from http://www.gnu.org/licenses/lgpl.txt
//
////////////////////////////////////////////////////////////////////
//
// Comments are formatted for doxygen
//

`include "crom.vh"
`include "drom.vh"

module USEQ(clk, rst, clken, pageFAIL, dp, dispDIAG,
            dispMUL, dispPF, dispNI, dispBYTE,
            dispEA, dispSCAD, dispNORM, skip40,
            skip20, skip10, regIR, drom, crom);

   parameter cromWidth = `CROM_WIDTH;
   parameter dromWidth = `DROM_WIDTH;

   input                  clk;          // Clock
   input                  rst;          // Reset
   input                  clken;        // Clock Enable
   input                  pageFAIL;     // Page Fail
   input  [0:35]          dp;           // Datapath
   input  [0:11]          dispDIAG;     // Diagnostic Addr
   input  [0: 3]          dispMUL;      // Multiply Dispatch
   input  [0: 3]          dispPF;       // Page Fail Dispatch
   input  [0: 3]          dispNI;       // Next Instruction Dispatch
   input  [0: 3]          dispBYTE;     // Byte Size/Position Dispatch
   input  [0: 3]          dispEA;       // Effective Address Mode Dispatch
   input  [0: 3]          dispSCAD;     // SCAD Dispatch
   input  [0: 3]          dispNORM;     // Normalize Dispatch
   input  [1: 7]          skip40;       // Skip 40
   input  [1: 7]          skip20;       // Skip 20
   input  [1: 7]          skip10;       // Skip 10
   input  [0:17]          regIR;        // Instruction Register
   input  [0:dromWidth-1] drom;         // Dispatch ROM Data
   output [0:cromWidth-1] crom;         // Control ROM Data

   //
   // Instruction Register AC field
   //

   wire [ 9:12] regIR_AC = regIR[ 9:12];
   
   //
   // Control ROM Address
   //

   wire [0:11] addr;
   wire [0:11] dispRET;

   //
   // Skip Logic
   //

   wire [0:11] skipADDR;
   
   SKIP uSKIP(.crom(crom),
              .skip40(skip40),
              .skip20(skip20),
              .skip10(skip10),
              .skipADDR(skipADDR));

   //
   // Dispatch Logic
   //  The dromJ is implemented slightly different than the KS-10.
   //  In the KS10, the DROM J value is constained to be between 1400
   //  and 1777.  This allows the dispatch function to hardwire
   //  the upper 4 data bits instead of storing them in the DROM.
   //  I've hooked all data lines up and will let the optimizer do
   //  it's thing.  The optimizer will determine that these lines
   //  never change and replace the DROM columns with hardwired
   //  constants.  Done this way, the address constants are obvious
   //  and not embedded in the logic: therefore the intent is more
   //  evident.  Watch the index numbering on DROM_J!
   //
   //  AREAD does dispatch to address 40-57 or address 1400-1777
   //
   //  Quoting the KS10 Technical Manual:
   //
   //   dromAEQJ -  "This bit causes an immediate dispatch on the J
   //               field when the microword calls for the standard
   //               AREAD dispatch on the A field. This is used for
   //               instructions that require no memory access or
   //               special setup (for example, MOVEI, JFCL)".
   //
   //  dromACDISP - "This bit causes the AC field of the instruction
   //               word to replace the right four bits of the J
   //               field so that a jump to begin instruction
   //               execution will actually dispatch to one of 16
   //               locations where the instruction code is expanded
   //               to 13 bits."
   //
   //  DPEA/E111
   //  DPEA/E153
   //  CRA2/E158
   //

   wire        dromAEQJ     = `dromAEQJ;
   wire        dromACDISP   = `dromACDISP;
   wire [0:11] dromJ        = `dromJ;
   wire [0: 3] dromA        = `dromA;
   wire [0: 3] dromB        = `dromB;

   reg [0:11] dispAREAD;

   always @(dromAEQJ, dromACDISP, dromJ, dromA, regIR_AC)
     begin
        if (dromAEQJ)                                   // Dispatch Address Range:
          if (dromACDISP)
            dispAREAD = {dromJ[0:7], regIR_AC};         // 1400 to 1777  (4 upper address were hardwired)
          else
            dispAREAD = dromJ;                          // 1400 to 1777  (4 upper address were hardwired)
        else
          dispAREAD = {8'b00000010, dromA};             // 0040 to 0057
     end

   //
   // Dispatch MUX
   //

   wire [0:11] dispADDR;
   
   DISPATCH uDISPATCH(.crom(crom),
                      .dp(dp),
                      .dispDIAG(dispDIAG),
                      .dispRET(dispRET),
                      .dispJ(dromJ),
                      .dispAREAD(dispAREAD),
                      .dispMUL(dispMUL),
                      .dispPF(dispPF),
                      .dispNI(dispNI),
                      .dispBYTE(dispBYTE),
                      .dispEA(dispEA),
                      .dispSCAD(dispSCAD),
                      .dispNORM(dispNORM),
                      .dispDROM_A(dromA),
                      .dispDROM_B(dromB),
                      .dispADDR(dispADDR));

   //
   // The CROM registers have been absorbed by the synchronous FPGA ROM.
   //  Therefore the initial state of the microcode (address zero) must
   //  be handled exlicitly.   This synchronizes the reset negation.
   //

   reg reset;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          reset <= 1'b1;
        else if (clken)
          reset <= 1'b0;
     end;
   
   //
   // Address 'MUX'
   //  Per comments above, this mux is modified to force the
   //  CROM address to zero at reset.
   //
   //  The Page Fail address is hard coded to o1777 in the
   //  microcode.  Note that the microcode address space is
   //  12-bits but only 11-bits (2048 microcode words) are
   //  actually implemented.   That will allow us to double
   //  the amount of microcode without changing the micro-
   //  architecture.
   //
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

   assign addr = (reset)    ? 12'b000_000_000_000 : 
                 (pageFAIL) ? 12'b111_111_111_111 : 
                 (dispADDR | skipADDR | `cromJ);

   //
   // Control ROM
   //

   CROM uCROM(.clk(clk),
              .clken(clken),
              .rst(rst),
              .addr(addr),
              .crom(crom));

   //
   // Call/Return Stack
   //

   STACK uSTACK(.clk(clk),
                .rst(rst),
                .clken(clken),
                .crom(crom),
                .addrIN(addr),
                .addrOUT(dispRET));

endmodule
