////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      KS-10 Memory Interface
//!
//! \details
//!      This module is simply a wrapper for the external memory.
//!
//! \todo
//!
//! \file
//!      mem.v
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

module MEM(clk, clken,
           busREQI, busACKO, busADDRI, busDATAI, busDATAO,
           ssramCLK, ssramADDR, ssramDATA, ssramADV, ssramWR);

   input         clk;           // Clock
   input         clken;         // Clock enable
   input         busREQI;       // Memory Request In
   output        busACKO;       // Memory Acknowledge Out
   input  [0:35] busADDRI;      // Address Address In
   input  [0:35] busDATAI;      // Data in
   output [0:35] busDATAO;      // Data out
   output        ssramCLK;      // SSRAM Clock
   output [0:22] ssramADDR;     // SSRAM Address Bus
   inout  [0:35] ssramDATA;     // SSRAM Data Bus
   output        ssramADV;      // SSRAM Advance (burst)
   output        ssramWR;       // SSRAM Write
   
   //
   // Memory flags
   //
   // Details:
   //  busADDRI[ 0:13] is flags
   //  busADDRI[14:35] is address
   //

   wire         busREAD  = busADDRI[ 3];
   wire         busWRITE = busADDRI[ 5];
   wire         busIO    = busADDRI[10];
   wire [16:35] busADDR  = busADDRI[16:35];

   //
   // SSRAM Interface
   //
   // FIXME:
   //  Right now this is not setup for SSRAM.
   //

   assign ssramCLK  = clk;
   assign ssramADV  = 1'b0;
   assign ssramWR   = busWRITE & ~busIO;
   assign ssramADDR = {3'b0, busADDR[16:35]};
   assign ssramDATA = (ssramWR) ? busDATAI : 36'bz;
   assign busDATAO  = ssramDATA;

   //
   // ACK the memory if implemented.
   //
   // FIXME:
   //  Right now, only 32K of memory is implemented.
   //

   assign busACKO = ~busIO & (busADDR < 32768);

endmodule
