////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      PC Flags
//!
//! \details
//!      The KS10 flags are defined as:
//!
//!         00   01   02   03   04   05   06   07   08   09   10   11   12   13   14   15   16   17
//!       +----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
//!  USER |AOV |CRY0|CRY1| FOV| FPD|USER|USER| PUB|    |TRAP|TRAP| FXU| NO |    |    |    |    |    |
//!       |    |    |    |    |    |    | IO |    |    |  2 |  1 |    | DIV|    |    |    |    |    |
//!       +----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
//!  EXEC | PCP|CRY0|CRY1| FOV| FPD|USER| PCU| PUB|    |TRAP|TRAP| FXU| NO |    |    |    |    |    |
//!       |  * |    |    |    |    |    |    |    |    |  2 |  1 |    | DIV|    |    |    |    |    |
//!       +----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
//!
//!       AOV    - Overflow
//!       CRY0   - Carry out of bit 0.
//!       CRY1   - Carry out of bit 1.
//!       FOV    - Floating-point overflow.
//!       FPD    - First part done.
//!       USER   -
//!       USERIO -
//!       PUB    - Public.
//!                Not implemented on the KS10.  Bit seven always
//!                indicates 0.
//!       TRAP2  - Trap 2.
//!       TRAP1  - Trap 1.
//!       FXU    - Floating-point underflow.
//!       NODIV  - No Divide.
//!      *PCP    - Previous Context Public
//!                Not implemented on the KS10.  Bit zero always
//!                indicates AOV.
//!       PCU    - Previous Context User
//!
//!       Overflow occurs if CRY0 and CRY1 differ.
//!
//! \note
//!       The logic has been simplified by recognizing that
//!       selPCFLAGS, selEXPTEST, and selASHTEST are mutually
//!       exclusive.
//!
//! \note
//!       In the original circuitry the Control ROM (microcode)
//!       was supplied to this module via the dbm input.  This
//!       has been replaced by a direct connection to the Control
//!       ROM. Presumably this was done because of circuit board
//!       interconnection limitations.
//!
//! \file
//!      flags.v
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
// This source fiit under the terms of the GNU Lesser General
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

`include "useq/crom.vh"

module PCFLAGS(clk, rst, clken, crom, dp, scad, regIR,
               aluAOV, aluCRY0, aluCRY1, pcFLAGS, skipJFCL);

   parameter cromWidth = `CROM_WIDTH;

   input                  clk;                  // Clock
   input                  rst;                  // Reset
   input                  clken;                // Clock Enable
   input  [0:cromWidth-1] crom;                 // Control ROM Data
   input  [0:35]          dp;                   // Data path
   input  [0: 9]          scad;                 // SCAD
   input  [0:17]          regIR;                // Instruction Register
   input                  aluAOV;               // ALU Arithmetic Overflow
   input                  aluCRY0;              // ALU Carry 0
   input                  aluCRY1;              // ALU Carry 1
   output [0:17]          pcFLAGS;              // Flags
   output                 skipJFCL;             // JFCL Skip

   //
   // Flags Registers
   //

   reg flagAOV;                                 // Overflow
   reg flagCRY0;                                // Carry 0
   reg flagCRY1;                                // Carry 1
   reg flagFOV;                                 // Floating-point overflow
   reg flagFPD;                                 // First part done
   reg flagUSER;                                // User mode
   reg flagUSERIO;                              // User IO or User IOT
   reg flagTRAP2;                               // Trap 2
   reg flagTRAP1;                               // Trap 1
   reg flagFXU;                                 // Floating-point underflow
   reg flagNODIV;                               // Divide failure

   //
   // DP Inputs
   //
   // Details
   //  When `cromADFLAGS is asserted, the dp bus has the contents of
   //  the last ALU operation.  In this mode dpOV, dpCRY0, dpCRY1,
   //  are use to update the flags.
   //
   //  When `cromLDFLAGS is asserted, the dp bus is used by the
   //  microcode to directly modify the flags.
   //

   wire dpOV         = dp[ 0];                  // Overflow flag
   wire dpCRY0       = dp[ 1];                  // Carry 0
   wire dpCRY1       = dp[ 2];                  // Carry 1
   wire dpFOV        = dp[ 3];                  // Floating-point overflow
   wire dpFPD        = dp[ 4];                  // First Part Done
   wire dpUSER       = dp[ 5];                  // USER
   wire dpUSERIO     = dp[ 6];                  // USER IO
   wire dpTRAP2      = dp[ 9];                  // Trap 2
   wire dpTRAP1      = dp[10];                  // Trap 1
   wire dpFXU        = dp[11];                  // Floating-point underflow
   wire dpNODIV      = dp[12];                  // No divide

   //
   // DPE9/E27
   // DPE9/E83
   //

   wire selPCFLAGS  = `cromSPEC_EN_40 & (`cromSPEC_SEL == `cromSPEC_SEL_PCFLAGS);
   wire selEXPTEST  = `cromSPEC_EN_40 & (`cromSPEC_SEL == `cromSPEC_SEL_EXPTEST);
   wire selASHTEST  = `cromSPEC_EN_40 & (`cromSPEC_SEL == `cromSPEC_SEL_ASHTEST);

   //
   // JFCL
   //  See JFCL Instruction Format.
   //  DPE9/E85
   //  DPE9/E92
   //

   wire [9:12] JFCL;
   wire [9:12] regIR_AC = regIR[9:12];

   assign JFCL[ 9]  = selPCFLAGS & `cromJFCLFLAGS & flagAOV  & regIR_AC[ 9];
   assign JFCL[10]  = selPCFLAGS & `cromJFCLFLAGS & flagCRY0 & regIR_AC[10];
   assign JFCL[11]  = selPCFLAGS & `cromJFCLFLAGS & flagCRY1 & regIR_AC[11];
   assign JFCL[12]  = selPCFLAGS & `cromJFCLFLAGS & flagFOV  & regIR_AC[12];

   //
   // JFCL Skip
   //
   // Trace
   //  DPE9/E77
   //

   assign skipJFCL = JFCL[9] | JFCL[10] | JFCL[11] | JFCL[12];

   //
   // Arithmetic Overflow Flag (AOV)
   //
   // Details:
   //  AOV is set on an ALU overflow. Arithmetic Overflow occurs
   //   if CRY0 and CRY1 differ
   //  AOV is set by SETAOV in microcode.
   //  AOV is cleared by JFCL 9.
   //  AOV is modified by dp.
   //
   // Trace
   //  DPE9/E17
   //  DPE9/E26
   //  DPE9/E33
   //  DPE9/E78
   //  DPE9/E92
   //  DPE8/E98
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          flagAOV <= 1'b0;
        else if (clken)
          begin
             if (selASHTEST)
               flagAOV <= (dpCRY0 != dpCRY1);
             else if (selEXPTEST)
               flagAOV <= scad[1];
             else if (selPCFLAGS)
               begin
                  if (`cromSETOV)
                    flagAOV <= 1'b1;
                  else if (`cromADFLAGS)
                    flagAOV <= aluAOV;
                  else if (JFCL[9])
                    flagAOV <= 1'b0;
                  else if (`cromLDFLAGS)
                    flagAOV <= dpOV;
               end
          end
     end

   //
   // Carry 0 Flag (CRY0)
   //
   // Details:
   //  CRY 0 is set on an ALU carry 0.
   //  CRY 0 is cleared by JFCL 10
   //  CRY 0 is modified by dp.
   //
   // Trace
   //  DPE9/E17
   //  DPE9/E25
   //  DPE9/E32
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          flagCRY0 <= 1'b0;
        else if (clken & selPCFLAGS)
          begin
             if (`cromADFLAGS)
               flagCRY0 <= aluCRY0;
             else if (JFCL[10])
               flagCRY0 <= 1'b0;
             else if (`cromLDFLAGS)
               flagCRY0 <= dpCRY0;
          end
     end

   //
   // Carry 1 Flag (CRY1)
   //
   // Details:
   //  CRY 1 is set on an ALU carry 1.
   //  CRY 1 is cleared by JFCL 11
   //  CRY 1 is modified by dp.
   //
   // Trace
   //  DPE9/E17
   //  DPE9/E25
   //  DPE9/E32
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          flagCRY1 <= 1'b0;
        else if (clken & selPCFLAGS)
          begin
             if (`cromADFLAGS)
               flagCRY1 <= aluCRY1;
             else if (JFCL[11])
               flagCRY1 <= 1'b0;
             else if (`cromLDFLAGS)
               flagCRY1 <= dpCRY1;
          end
     end

   //
   // Floating-point Overflow Flag (FOV)
   //
   // Details:
   //  FOV is set on an Floating-point overflow
   //  FOV is cleared by JFCL 12
   //  FOV is modified by dp.
   //
   // Trace
   //  DPE9/E26
   //  DPE9/E33
   //  DPE9/E32
   //  DPE9/E78
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          flagFOV <= 1'b0;
        else if (clken)
          begin
             if (selEXPTEST)
               flagFOV <= scad[1];
             else if (selPCFLAGS)
               begin
                  if (JFCL[12])
                    flagFOV <= 1'b0;
                  else if (`cromSETFOV)
                    flagFOV <= 1'b1;
                  else if (`cromLDFLAGS)
                    flagFOV <= dpFOV;
               end
          end
     end

   //
   // First Part Done Flag (FPD)
   //
   // Note
   //  The Clear operation has priority over the Set operation.
   //  The Set operation has priority over the Load operation.
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
           flagFPD <= 1'b0;
        else if (clken & selPCFLAGS)
          begin
             if (`cromCLRFPD)
               flagFPD <= 1'b0;
             else if (`cromSETFPD)
               flagFPD <= 1'b1;
             else if (`cromLDFLAGS)
               flagFPD <= dpFPD;
             else
               flagFPD <= flagFPD;
          end
     end

   //
   // USER Flag
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          flagUSER <= 1'b0;
        else if (clken & selPCFLAGS)
          begin
             if (`cromLDFLAGS)
               flagUSER <= dpUSER;
             else if (`cromHOLDUSER)
               flagUSER <= flagUSER;
             else
               flagUSER <= 1'b0;
          end
     end

   //
   // USERIO Flag
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          flagUSERIO <= 1'b0;
        else if (clken & selPCFLAGS)
          flagUSERIO <= ((flagUSER   & dpUSERIO                 & `cromLDFLAGS ) |
                         (flagUSERIO                            & `cromLDFLAGS ) |
                         (flagUSER              & `cromSETPCU                  ) |
                         (flagUSERIO & dpUSERIO & `cromHOLDUSER & `cromLDFLAGS ));
     end

   //
   // TRAP2 Flag
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          flagTRAP2 <= 1'b0;
        else if (clken & selPCFLAGS)
          begin
             if (`cromSETTRAP2)
               flagTRAP2 <= 1'b1;
             else if (`cromLDFLAGS)
               flagTRAP2 <= dpTRAP2;
             else
               flagTRAP2 <= 1'b0;
          end
     end

   //
   // TRAP1 Flag
   //
   // Notes
   //  An arithmetic overflow occurs if CRY0 and CRY1 differ which
   //  also sets the TRAP1 flag.
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          flagTRAP1 <= 1'b0;
        else if (clken)
          begin
             if (selASHTEST)
               flagTRAP1 <= (dpCRY0 != dpCRY1);
             else if (selEXPTEST)
               flagTRAP1 <= scad[1];
             else if (selPCFLAGS)
               begin
                  if (`cromSETTRAP1)
                    flagTRAP1 <= 1'b1;
                  else if (`cromADFLAGS)
                    flagTRAP1 <= aluAOV;
                  else if (`cromLDFLAGS)
                    flagTRAP1 <= dpTRAP1;
                  else
                    flagTRAP1 <= 1'b0;
               end
          end
     end

   //
   // Floating-point Underflow Flag (FXU)
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          flagFXU <= 1'b0;
        else if (clken)
          begin
             if (selEXPTEST)
               flagFXU <= scad[0];
             else if (selPCFLAGS)
               begin
                  if (`cromLDFLAGS)
                    flagFXU <= dpFXU;
                  else
                    flagFXU <= flagFXU;
               end
          end
     end

   //
   // NODIV Flag
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          flagNODIV <= 1'b0;
        else if (clken & selPCFLAGS)
          begin
             if (`cromSETNODIV)
               flagNODIV <= 1'b1;
             else if (`cromLDFLAGS)
               flagNODIV <= dpNODIV;
             else
               flagNODIV <= flagNODIV;
          end
     end

   //
   // Output fixups
   //

   assign pcFLAGS[ 0] = flagAOV;
   assign pcFLAGS[ 1] = flagCRY0;
   assign pcFLAGS[ 2] = flagCRY1;
   assign pcFLAGS[ 3] = flagFOV;
   assign pcFLAGS[ 4] = flagFPD;
   assign pcFLAGS[ 5] = flagUSER;
   assign pcFLAGS[ 6] = flagUSERIO;
   assign pcFLAGS[ 7] = 1'b0;
   assign pcFLAGS[ 8] = 1'b0;
   assign pcFLAGS[ 9] = flagTRAP2;
   assign pcFLAGS[10] = flagTRAP1;
   assign pcFLAGS[11] = flagFXU;
   assign pcFLAGS[12] = flagNODIV;
   assign pcFLAGS[13] = 1'b0;
   assign pcFLAGS[14] = 1'b0;
   assign pcFLAGS[15] = 1'b0;
   assign pcFLAGS[16] = 1'b0;
   assign pcFLAGS[17] = 1'b0;

endmodule
