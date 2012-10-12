////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      Microcontroller Dispatch Logic
//!
//! \details
//!
//! \todo
//!
//! \file
//!      disp.v
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

module DISPATCH(crom, dp, dispDIAG, dispRET, dispJ, dispAREAD,
                dispMUL, dispPF, dispNI, dispBYTE, dispEA,
                dispSCAD, dispNORM, dispDROM_A, dispDROM_B,
                dispADDR);

   parameter  cromWidth = `CROM_WIDTH;

   input      [0:cromWidth-1] crom;             // Control ROM Data
   input      [0:35]          dp; 		// Datapath Dispatch
   input      [0:11]          dispDIAG;         // Diagnostic dispatch
   input      [0:11]          dispRET;          // Microcode return dispatch
   input      [0:11]          dispJ;            // Jump dispatch
   input      [0:11]          dispAREAD;        // Address Read dispatch
   input      [8:11]          dispMUL;          // Multiply Dispatch
   input      [8:11]          dispPF;           // Page Fail Dispatch
   input      [8:11]          dispNI;           // Next Instruction Dispatch
   input      [8:11]          dispBYTE;         // Byte Size/Position Dispatch
   input      [8:11]          dispEA;           // Effective Address Mode Dispatch
   input      [8:11]          dispSCAD;         // SCAD Dispatch
   input      [8:11]          dispNORM;         // Normalize Dispatch
   input      [8:11]          dispDROM_A;       // DROM A Dispatch
   input      [8:11]          dispDROM_B;       // DROM B Dispatch
   output reg [0:11]          dispADDR;         // Dispatch Addr

   //
   // Control ROM Dispatch Address
   //

   wire       dispEN10 = `cromDISP_EN_10;
   wire       dispEN20 = `cromDISP_EN_20;
   wire       dispEN40 = `cromDISP_EN_40;
   wire [0:1] dispSELH = `cromDISP_SELH;
   wire [0:2] dispSEL  = `cromDISP_SEL;

   always @(dispDIAG or dispRET or dispJ or dispAREAD or
            dispMUL  or dispPF or dispNI or dispBYTE or dispEA or
            dispSCAD or dispEN20 or dispEN10 or dispSEL or
            dispSELH)
     begin

        //
        // Default dispatch if none of the data selectors
        // are activated.
        //
        
        dispADDR[0:11] = 12'b000_000_000_000;

        //
        // Dispatch Address Select MSBs
        //  CRA1/E69
        //  CRA1/E68
        //  CRA1/E151 
        //  CRA1/E138
        //

        if (dispEN20)
          begin
             case (dispSELH)
               `cromDISP_SELH_DIAG:
                 dispADDR[0:7] = dispDIAG[0:7];
               `cromDISP_SELH_RET:
                 dispADDR[0:7] = dispRET[0:7];
               `cromDISP_SELH_J:
                 dispADDR[0:7] = dispJ[0:7];
               `cromDISP_SELH_AREAD:
                 dispADDR[0:7] = dispAREAD[0:7];
             endcase
          end

        //
        // Dispatch Address Select LSBs
        //  CRA1/E158
        //  CRA1/E170
        //  CRA1/E171
        //  CRA1/E182
        //

        if (dispEN10)
          case (dispSEL)
            `cromDISP_SEL_DIAG:
              dispADDR[8:11] = dispDIAG[8:11];
            `cromDISP_SEL_RET:
              dispADDR[8:11] = dispRET[8:11];
            `cromDISP_SEL_MULTIPLY:
              dispADDR[8:11] = dispMUL[8:11];
            `cromDISP_SEL_PAGEFAIL:
              dispADDR[8:11] = dispPF[8:11];
            `cromDISP_SEL_NICOND:
              dispADDR[8:11] = dispNI[8:11];
            `cromDISP_SEL_BYTE:
              dispADDR[8:11] = dispBYTE[8:11];
            `cromDISP_SEL_EAMODE:
              dispADDR[8:11] = dispEA[8:11];
            `cromDISP_SEL_SCAD:
              dispADDR[8:11] = dispSCAD[8:11];
          endcase

        //
        // Dispatch Address Select LSBs
        //
        
        if (dispEN40)
          case (dispSEL)
            `cromDISP_SEL_ZERO:
              dispADDR[8:11] = 4'b0;
            `cromDISP_SEL_DP18TO21:
              dispADDR[8:11] = dp[18:21];
            `cromDISP_SEL_J:
              dispADDR[8:11] = dispJ[8:11];
            `cromDISP_SEL_AREAD:
              dispADDR[8:11] = dispAREAD[8:11];
            `cromDISP_SEL_NORM:
              dispADDR[8:11] = dispNORM[8:11];
            `cromDISP_SEL_DP32TO35:
              dispADDR[8:11] = dp[32:35];
            `cromDISP_SEL_DROMA:
              dispADDR[8:11] = dispDROM_A;
            `cromDISP_SEL_DROMB:
              dispADDR[8:11] = dispDROM_B;
          endcase
     end

endmodule
