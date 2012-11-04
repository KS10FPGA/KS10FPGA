////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      Next Instruction Dispatch
//!
//! \details
//!      This is a 16-way dispatch base on the next instruction.
//!
//! \todo
//!
//! \file
//!      ni_disp.v
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

module NI_DISP (aprFLAGS, pcFLAGS, consTRAPEN, cpuRUN, memory_cycle, dispNI);

   input  [ 0:17] pcFLAGS;              // PC Flags
   input  [22:35] aprFLAGS;             // APR Flags
   input          consTRAPEN;           // Console Trap Enable
   input          cpuRUN;               // Run
   input          memory_cycle;         // Memory Cycle
   output [ 8:11] dispNI;               // Next Instruction dispatch

   //
   // Trap Enable Flag
   //

   wire flagTRAPEN = aprFLAGS[22];

   //
   // Trap Flags
   //

   wire flagTRAP2 = pcFLAGS[ 9];
   wire flagTRAP1 = pcFLAGS[10];
   wire [0:1] trapSEL = {flagTRAP2, flagTRAP1};
   reg  [1:3] traps;

   always @(consTRAPEN or flagTRAPEN or trapSEL)
     begin
        if (consTRAPEN & flagTRAPEN)
          case (trapSEL)
            0: traps = 3'b000;
            1: traps = 3'b001;
            2: traps = 3'b010;
            3: traps = 3'b100;
          endcase
        else
          traps = 3'b000;
     end

   //
   // NICOND
   //  CRA2/E147
   //

   assign dispNI[8] = memory_cycle;     // Fetch in progress
   assign dispNI[9:11] = ((traps[3]) ? 3'o1 :
                          (traps[2]) ? 3'o2 :
                          (traps[1]) ? 3'o3 :
                          (~cpuRUN ) ? 3'o5 : 3'o7);

endmodule
