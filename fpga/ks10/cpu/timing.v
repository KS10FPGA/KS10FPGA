////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      Read/Write Timing
//!
//! \details
//!
//! \note
//!
//! \todo
//!
//! \file
//!      timing.v
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

`include "useq/crom.vh"
`include "useq/drom.vh"

module TIMING(clk, rst, crom, drom, dp, fe, clken, clkenUSEQ);

   parameter cromWidth = `CROM_WIDTH;
   parameter dromWidth = `DROM_WIDTH;

   input                  clk;          // Clock
   input                  rst;          // Reset
   input  [0:cromWidth-1] crom;         // Control ROM Data
   input  [0:dromWidth-1] drom;         // Control ROM Data
   input  [0:35]          dp;           // Data path
   input  [0: 9]          fe;		// FE
   output                 clken;        // Clock Enable
   output                 clkenUSEQ;    // Clock Enable Microsequencer

   //
   //
   //


   
/*   
   wire memEN     = (( `cromMEM_CYCLE &  `cromMEM_WAIT                       ) |
                     ( `cromMEM_CYCLE &  `cromMEM_BWRITE & `dromCOND_FUNC    ));

   wire readCYCLE = (( `cromMEM_AREAD &  `dromREADCYCLE                      ) |
                     (~`cromMEM_AREAD &  `cromMEM_DPFUNC & dp[3]             ) |
                     (~`cromMEM_AREAD & ~`cromMEM_DPFUNC & `cromMEM_READCYCLE));
   //
   // Wait State Machine
   //

   reg [0:1] state;
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          state <= 0;
        else
          case (state)
            0: if (memEN & readCYCLE)
              state <= 1;
            1: state <= 2;
            2: state <= 0;
            3: state <= 0;
          endcase
     end
   
   assign clken = ((state == 0) |

   reg clken;
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          clken <= 1'b1;
        else
          clken <= ~clken;
     end
                   (state == 2));
*/


   reg ready;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          ready = 1'b0;
        else
          ready = 1'b1;
     end
   
   //
   // Fast Shift
   //
   // Note
   //  The KS10 fast shifts while the FE is negative.  For some reason
   //  the FPGA shifts one too many times.
   //
   // FIXME:
   //  I don't really understand why this needs to be different than the
   //  KS10.
   //
   
   assign clkenUSEQ = ~(`cromMULTISHIFT & (fe != 10'b1_111_111_111) & ready);
   assign clken = 1'b1;
   
endmodule
