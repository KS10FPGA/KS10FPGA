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
//!       The logic can be simplified by recognizing that selPCFLAGS, selEXPTEST,
//!       and selASHTEST are mutually exclusive.
//!
//! \file
//!      flags.v
//!
//! \author
//!      Rob Doyle - doyle (at) cox (dot) net
//!
 ////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2009, 2012 Rob Doyle
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

module PCFLAGS(clk, rst, clken, crom, dp, dbm, scad, regIR,
               aluAOV, aluCRY0, aluCRY1, pcFLAGS, skipJFCL);
             
   parameter cromWidth = `CROM_WIDTH;
             
   input                  clk;                  // Clock
   input                  rst;                  // Reset
   input                  clken;                // Clock Enable
   input  [0:cromWidth-1] crom;                 // Control ROM Data
   input  [0:35]          dp;                   // Data path
   input  [0:35]          dbm;                  // DBM
   input  [0: 9]          scad;                 // SCAD
   input  [0:17]          regIR;             	// Instruction Register
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
   //  In this mode, the Control ROM NUMBER field is multiplexed
   //  onto the dbm bus.  The definiton of these bits are as
   //  follows:
   //

   wire dbmSETOV     = dbm[ 0];                 // Set flagAOV          [see cromSETOV]
   wire dbmSETFOV    = dbm[ 1];                 // Set flagFOV          [see cromSETFOV]
   wire dbmSETNODIV  = dbm[ 2];                 // Set flagNODIV        [see cromSETNDV]
   wire dbmCLRFPD    = dbm[ 3];                 // Clr flagFPD          [see cromCLRFPD]
   wire dbmSETFPD    = dbm[ 4];                 // Set flagFPD          [see cromSETFPD]
   wire dbmHOLDUSER  = dbm[ 5];                 // Hold flagUSER        [see cromHOLDUSER]
   wire dbmSETTRAP2  = dbm[ 7];                 // Set flagTRAP2        [see cromSETTRAP2]
   wire dbmSETTRAP1  = dbm[ 8];                 // Set flagTRAP1        [see cromSETTRAP1]
   wire dbmSETPCU    = dbm[ 9];                 // Set flagPCU          [see cromSETPCU]
   wire dbmJFCLFLAGS = dbm[14];                 // Load Flags from JFCL [see cromJFCLFLAG]
   wire dbmLDFLAGS   = dbm[15];                 // Load Flags from DP   [see cromLDFLAGS]
   wire dbmADFLAGS   = dbm[17];                 // Update Flags from ALU[see cromADFLAGS
   
   //
   // dp bus:
   //    When dbmADFLAGS is asserted, the dp bus has the contents
   //    of the last ALU operation.  In this mode dpOV, dpCRY0,
   //    dpCRY1, are use to update the flags.
   //
   //    When dbmLDFLAGS is asserted, the dp bus is used to
   //    modify the flags.
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
   
   assign JFCL[ 9]  = selPCFLAGS & dbmJFCLFLAGS & flagAOV  & regIR_AC[ 9];
   assign JFCL[10]  = selPCFLAGS & dbmJFCLFLAGS & flagCRY0 & regIR_AC[10];
   assign JFCL[11]  = selPCFLAGS & dbmJFCLFLAGS & flagCRY1 & regIR_AC[11];
   assign JFCL[12]  = selPCFLAGS & dbmJFCLFLAGS & flagFOV  & regIR_AC[12];

   //
   // JFCL Skip
   //  DPE9/E77
   //
   
   assign skipJFCL = JFCL[9] | JFCL[10] | JFCL[11] | JFCL[12];

   //
   // Overflow Flag (OV)
   //  Arithmetic Overflow occurs if CRY0 and CRY1 differ.
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
                  if (dbmSETOV)
                    flagAOV <= 1'b1;
                  else if (dbmADFLAGS)
                    flagAOV <= aluAOV;
                  else if (JFCL[9])
                    begin
                       if (dbmLDFLAGS)
                         flagAOV <= dpOV;
                       else
                         flagAOV <= flagAOV;
                    end
                  else
                    flagAOV <= 1'b0;
               end
          end
     end
   
   //
   // Carry 0 Flag (CRY0)
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          flagCRY0 <= 1'b0;
        else if (clken & selPCFLAGS)
          begin
             if (dbmADFLAGS)
               flagCRY0 <= aluCRY0;
             else if (JFCL[10])
               begin
                  if (dbmLDFLAGS)
                    flagCRY0 <= dpCRY0;
                  else
                    flagCRY0 <= flagCRY0;
               end
             else
               flagCRY0 <= 1'b0;
          end
     end

   //
   // Carry 1 Flag (CRY1)
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          flagCRY1 <= 1'b0;
        else if (clken & selPCFLAGS)
          begin
             if (dbmADFLAGS)
               flagCRY1 <= aluCRY1;
             else if (JFCL[11])
               begin
                  if (dbmLDFLAGS)
                    flagCRY1 <= dpCRY1;
                  else
                    flagCRY1 <= flagCRY1;
               end
             else
               flagCRY1 <= 1'b0;
          end
     end
   
   //
   // Floating-point Overflow Flag (FOV)
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
                    begin
                       if (dbmLDFLAGS)
                         flagFOV <= dpFOV;
                       else
                         flagFOV <= flagFOV;
                    end
                  else
                    flagFOV <= 1'b0;
               end
          end
     end
   
   //
   // First Part Done Flag (FPD)
   //  The Clear operation has priority over the Set operation.
   //  The Set operation has priority over the Load operation.
   //
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
           flagFPD <= 1'b0;
        else if (clken & selPCFLAGS)
          begin
             if (dbmCLRFPD)
               flagFPD <= 1'b0;
             else if (dbmSETFPD)
               flagFPD <= 1'b1;
             else if (dbmLDFLAGS)
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
             if (dbmLDFLAGS)
               flagUSER <= dpUSER;
             else if (dbmHOLDUSER)
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
          flagUSERIO <= ((flagUSER   & dpUSERIO               & dbmLDFLAGS ) |
                         (flagUSERIO                          & dbmLDFLAGS ) |
                         (flagUSER   & dbmSETPCU                           ) |
                         (flagUSERIO & dpUSERIO & dbmHOLDUSER & dbmLDFLAGS ));
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
             if (dbmSETTRAP2)
               flagTRAP2 <= 1'b1;
             else if (dbmLDFLAGS)
               flagTRAP2 <= dpTRAP2;
             else
               flagTRAP2 <= 1'b0;
          end
     end
 
   //
   // TRAP1 Flag
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
                  if (dbmSETTRAP1)
                    flagTRAP1 <= 1'b1;
                  else if (aluAOV & dbmADFLAGS)
                    flagTRAP1 <= 1'b1;
                  else if (dpTRAP1 & dbmLDFLAGS)
                    flagTRAP1 <= 1'b1;
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
                  if (dbmLDFLAGS)
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
             if (dbmSETNODIV)
               flagNODIV <= 1'b1;
             else if (dbmLDFLAGS)
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
