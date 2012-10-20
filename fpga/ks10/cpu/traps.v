////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      Traps
//!
//! \details
//!
//! \note
//!
//! \file
//!      traps.v
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

`include "microcontroller/crom.vh"

module TRAPS(clk, rst, clken, crom, dp, pcFLAGS, consTRAPEN, trapEN, traps, trapCYCLE);
             
   parameter cromWidth = `CROM_WIDTH;
             
   input                      clk;              // Clock
   input                      rst;              // Reset
   input                      clken;            // Clock Enable
   input      [0:cromWidth-1] crom;             // Control ROM Data
   input      [0:35]          dp;               // Data path
   input      [0:17]          pcFLAGS;          // PC Flags
   input                      consTRAPEN;       // Console Trap Enable
   input                      trapEN;           // Trap Enable
   output reg [3: 1]          traps;            // Traps
   output reg                 trapCYCLE;        // Trap Cycle
   
   //
   // Trap Selection
   // CRA2/E147
   //
   
   wire [0:1] trapSEL = pcFLAGS[9:10];
   
   always @(consTRAPEN or trapEN or trapSEL)
     begin
        if (consTRAPEN & trapEN)
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
   // Trap Cycle
   //  The schematic uses NICOND_09.  This is the same logic but
   //  a little more straight forward.
   //
   //  CRA2/E159
   //

   wire niEN = `cromSPEC_EN_10 & (`cromSPEC_SEL == `cromSPEC_SEL_LOADNICOND);
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          trapCYCLE <= 1'b0;
        else if (clken & niEN)
          trapCYCLE <= (traps != 3'b000);
    end
   
endmodule
