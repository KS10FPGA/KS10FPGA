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
//!      Important IO addresses:
//!          100000: Memory Status Register
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

   //
   // Memory Status Register (IO Address 100000)
   //  See Page 5-69
   //
   //
   //           0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17
   //         +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //   Write |EH|  |RE|PE|EE|                    |PF|              |                                                     |
   //   (LH)  +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //
   //          18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
   //         +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //   Write |                             |       FCB          |ED|
   //   (RH)  +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //
   //
   //  EH  : Error Hold          - Writes ignored (not implemented).
   //  RE  : Refresh Error       - Writes ignored (not implemented).
   //  PE  : Parity Error        - Writes sets/clears bit 3,
   //                              otherwise not implemented.
   //  PF  : Power Failure       - Writing zero clears bit 12,
   //                              otherwise not implemented.
   //  FCB : Force Check Bits    - Write ignored (not implemented).
   //  ED  : ECC Disable         - Writing zero sets bit 4,
   //                              Writing one clears bit 4,
   //                              otherwise not implemented.
   //
   //
   //           0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17
   //         +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //    Read |EH|UE|RE|PE|EE|         ECP        |PF| 0|   ERA     |
   //    (LH) +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //
   //          18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
   //         +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //   Write |                     ERA                             |
   //   (RH)  +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //
   //  EH  : Error Hold          - Always read as 0 (not implemented).
   //  UE  : Uncorrectable Error - Always read as 0 (not implemented).
   //  RE  : Refresh Error       - Always read as 0 (not implemented).
   //  PE  : Parity Error        - Reads back value set by write to bit 3.
   //  EE  : ECC Enable          - Reads back inverse value set by
   //                              write to bit 35.
   //  ECP : Error Cor  Parity   - Always read as zero. (not implemented).
   //  PF  : Power Failure       - Initialized to 1 at power-up
   //                            - Cleared by writing 0 to bit 12
   //  ERA : Error Read Address  - Always read as 0 (not implemented).
   //


   //
   // ACK the memory if implemented.
   //
   // FIXME:
   //  Right now, only 32K of memory is implemented.
   //  Memory Status Register is not implemented.
   //

   assign busACKO  = ~busIO & (busADDR < 32768);
   assign busDATAO = ssramDATA;

endmodule
