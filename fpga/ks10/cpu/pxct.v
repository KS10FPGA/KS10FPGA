////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   PXCT
//
// Details
//   This module implements the Previous Context decoding.
//
// Note
//   For a really good explanation of these bits see Mike Eulers Interoffice
//   Memorandum on Extended Addressing.
//
//   It is available from:
//   <http://bitsavers.trailing-edge.com/pdf/dec/pdp10/KC10_Jupiter/
//   ExtendedAddressing_Jul83.pdf>
//
//   The following information is extracted from that document verbatim.
//
//   Bit       References made in previous context if bit is 1
//
//    9  (E1)  Effective address calculation of instruction (index registers,
//             indirect words).
//
//   10  (D1)  Memory operands specified by EA, whether fetch or store (e.g,
//             PUSH source, POP or BLT destination); byte pointer.
//
//   11  (E2)  Effective address calculation of byte pointer; source in EXTEND
//             (e.g., XBLT or MOVSLJ source); effective address calculation of
//             source byte pointer in EXTEND (MOVSLJ).
//
//   12  (D2)  Byte data; source in BLT; destination in EXTEND (e.g., XBLT or
//             MOVSLJ destination); effective address calculation of destination
//             byte pointer in EXTEND (MOVSLJ).
//
// File
//   pxct.v
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

`include "useq/crom.vh"

module PXCT (
      input  wire         clk,                  // clock
      input  wire         rst,                  // reset
      input  wire         clken,                // clock enable
      input  wire [0:107] crom,                 // Control ROM Data
      input  wire [0: 35] dp,                   // Data Path
      output reg          prevEN,               // Previous Enable
      output reg  [0:  5] acBLOCK               // Blocks
   );

   //
   // Microcode fields
   //

   wire       specACBLK   = `cromSPEC_EN_40 & (`cromSPEC_SEL == `cromSPEC_SEL_LOADACBLK);
   wire       specPXCTEN  = `cromSPEC_EN_10 & (`cromSPEC_SEL == `cromSPEC_SEL_PXCTEN   );
   wire       specPXCTOFF = `cromSPEC_EN_20 & (`cromSPEC_SEL == `cromSPEC_SEL_PXCTOFF  );
   wire [0:2] memPXCTSEL  = `cromMEM_PXCTSEL;

   //
   // AC Block Selection
   //
   // Details
   //  This register holds the current AC block and the previous AC block.  The
   //  PXCT selects between the two.
   //
   // Trace
   //  DPE5/E308
   //

   always @(posedge clk)
    begin
        if (rst)
          acBLOCK <= 0;
        else if (clken & specACBLK)
          acBLOCK <= dp[6:11];
    end

   //
   // PCXT Register
   //
   // Details:
   //  The microcode saves the AC field of the XCT instruction into this
   //  register.  The PXCT state is used in the operation that follows.
   //
   // Note:
   //  specPXCTEN and specPXCTOFF can occur simultaneously or independantly.
   //
   // Trace:
   //  DPMA/E71
   //  DPMA/E78
   //  DPMA/E2
   //

   reg        enPXCT;
   reg [9:12] pxct;

   always @(posedge clk)
     begin
        if (rst)
          begin
             enPXCT <= 0;                       // Enable PXCT
             pxct   <= 0;                       // PXCT Bits
          end
        else if (clken & specPXCTEN)
          begin
             enPXCT <= !specPXCTOFF;            // Enable PXCT
             pxct   <= dp[9:12];                // PXCT E1, D1, E2, D2 Bits
          end
     end

   //
   // PXCT AC Field Decode
   //
   // Details:
   //  The use of previous context (prevEN) is a function of AC field of the
   //  XCT opcode and the type of memory operation being performed.
   //
   //  The microcode indexes this device with the type of memory operation
   //  (memPXCTSEL) and this device examines the AC field of the XCT
   //  instruction (pxct[9:12]) to determine if previous context is applicable
   //  to this specific memory operation, or not.
   //
   //  See additional information in file header.
   //
   // Trace:
   //  DPMA/E62
   //  DPMA/E63
   //

   always @*
     begin
        if (enPXCT)
          case (memPXCTSEL)
            0: prevEN <= 0;                     // Current
            1: prevEN <= pxct[ 9];              // E1: PXCT EA
            2: prevEN <= pxct[10] & pxct[9];    // Not used
            3: prevEN <= pxct[10];              // D1: PXCT DATA or
                                                //     PXCT BLT DEST
            4: prevEN <= pxct[11] & pxct[9];    // BIS-SRC-EA
            5: prevEN <= pxct[11];              // E2: PXCT BYTE PTR EA or
                                                //     PXCT EXTEND EA
            6: prevEN <= pxct[12] & pxct[9];    // BIS-DST-EA
            7: prevEN <= pxct[12];              // D2: PXCT BYTE DATA or
                                                //     PXCT STACK WORD or
                                                //     PXCT BLT SRC
          endcase
        else
          prevEN <= 0;                          // Current
     end

endmodule
