////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      Byte Dispatch
//!
//! \details
//!      When the Datapath has a byte pointer and the byte size
//!      indication is 7 (most common byte size) and the bytes
//!      are zero aligned, then this hardware is enabled to speed
//!      byte manipulation.
//!
//! \todo
//!
//! \file
//!      byte_disp.v
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

`default_nettype none

module BYTE_DISP(dp, dispBYTE);

   input      [0:35] dp;                // Data path
   output reg [8:11] dispBYTE;          // Byte dispatch

   //
   // BYTE DISP
   //
   // Details
   //  The first 6 bits in DP are the position, the second 6 bits
   //  in DP are the size.  This is derived from the byte pointer
   //  format of the PDP10.
   //
   // Trace
   //  DPE3/E77
   //  DPE3/E16
   //  DPE3/E10
   //  DPE3/E9
   //

   wire pos  = dp[0: 5];
   wire size = dp[6:11];

   always @(pos, size)
     begin
        if (size == 7)
          case (pos)
            1      : dispBYTE = 7;
            8      : dispBYTE = 5;
            15     : dispBYTE = 4;
            22     : dispBYTE = 2;
            29     : dispBYTE = 1;
            default: dispBYTE = 0;
          endcase
        else
          dispBYTE = 0;
     end

endmodule
