////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      KS10 Bus Interface
//!
//! \details
//!      The protocol is not the same as the KS10
//!
//!        The first 7 bis are the Bus Command Bits
//!
//!                      0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
//!                    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!       Memory Write |                 VMA Flags               |                      Memory Address                             |
//!                    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!
//!                      0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
//!                    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!        Memory Read |                 VMA Flags               |                      Memory Address                             |
//!                    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!
//!                      0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
//!                    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!         RMW Memory |                 VMA Flags               |                      Memory Address                             |
//!                    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!
//!                      0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
//!                    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!           IO Write |                 VMA Flags               |  DEV NO   |             Register Address                        |
//!                    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!
//!                      0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
//!                    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!      IO Write Byte |                 VMA Flags               |  DEV NO   |             Register Address                        |
//!                    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!
//!                      0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
//!                    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!            IO Read |                 VMA Flags               |  DEV NO   |             Register Address                        |
//!                    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!
//!                      0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
//!                    +-+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!     Read Controller|                 VMA Flags               |  |  PI NO |                 Unused                              |
//!         Number     +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!
//!                      0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
//!                    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!     Read Intr Vect |                 VMA Flags               |  DEV NO   |                 Unused                              |
//!                    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!
//!
//! \todo
//!
//! \note
//!
//! \file
//!      bus.v
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
`include "useq/crom.vh"

module BUS(clk, rst, clken, crom, dp,
           vmaEXTENDED, vmaFLAGS, vmaADDR, pageADDR, aprFLAGS,
           busDATAO, busADDRO, busREQ, busACK, memWAIT);

   parameter  cromWidth = `CROM_WIDTH;
   input                   clk;         // Clock
   input                   rst;         // Reset
   input                   clken;       // Clock enable
   input  [ 0:cromWidth-1] crom;        // Control ROM Data
   input  [ 0:35]          dp;          // Data path
   input                   vmaEXTENDED; // Extended VMA
   input  [ 0:13]          vmaFLAGS;    // VMA Flags
   input  [14:35]          vmaADDR;     // Virtual Memory Address
   input  [16:26]          pageADDR;    // Page Address
   input  [22:35]          aprFLAGS;    // APR Flags
   output [ 0:35]          busDATAO;    // Bus Out
   output [ 0:35]          busADDRO;    // Bus Address
   output                  busREQ;      // Bus Request
   input                   busACK;      // Bus Acknowledge
   output                  memWAIT;     // Wait for Memory

   //
   // Control ROM Decode
   //

   wire pageWRITE = `cromSPEC_EN_10 & (`cromSPEC_SEL == `cromSPEC_SEL_PAGEWRITE);

   //
   // APR Flags
   //

   wire flagPAGEEN = aprFLAGS[23];

   //
   // VMA Flags
   //

   wire vmaREADCYCLE   = vmaFLAGS[3];
   wire vmaWRTESTCYCLE = vmaFLAGS[4];
   wire vmaWRITECYCLE  = vmaFLAGS[5];
   wire vmaPHYSICAL    = vmaFLAGS[8];

   //
   // Paged Reference
   //

   wire pagedREF = ~vmaPHYSICAL & flagPAGEEN;

   //
   // Data Output
   //
   // FIXME:
   //  Is the mux necessary?  It just zeros out dp[19:20] and dp[23:24].
   //

   reg [0:35] busDATAO;

   always @(dp or pageWRITE)
     begin
        if (pageWRITE)
          busDATAO[0:35] <= {dp[0:18], 2'b0, dp[21:22], 2'b0, dp[25:35]};
        else
          busDATAO[0:35] <= dp[0:35];
     end

   //
   // Address Output
   //

   reg [0:35] busADDRO;

   always @(pagedREF or vmaEXTENDED or vmaFLAGS or vmaADDR or pageADDR)
     begin
        if (pagedREF)
          busADDRO <= {vmaFLAGS, vmaADDR[14:15], pageADDR[16:26], vmaADDR[27:35]};
        else
          if (vmaEXTENDED)
            busADDRO <= {vmaFLAGS, vmaADDR};
          else
            busADDRO <= {vmaFLAGS, vmaADDR} & 36'o777760_777777;
     end

   //
   // Bus Request on the various cycles
   //

   assign busREQ = vmaREADCYCLE | vmaWRITECYCLE | vmaWRTESTCYCLE;

   //
   // Wait for memory (REQ with no ACK)
   //

   assign memWAIT = busREQ & ~busACK;

endmodule
