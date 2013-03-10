////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KS10 Bus Interface
//
// Details
//   The protocol is not the same as the KS10
//
//     The first 7 bis are the Bus Command Bits
//
//                   0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
//                 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//    Memory Write |                 VMA Flags               |                      Memory Address                             |
//                 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//
//                   0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
//                 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//     Memory Read |                 VMA Flags               |                      Memory Address                             |
//                 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//
//                   0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
//                 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//      RMW Memory |                 VMA Flags               |                      Memory Address                             |
//                 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//
//                   0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
//                 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//        IO Write |                 VMA Flags               |  DEV NO   |             Register Address                        |
//                 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//
//                   0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
//                 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//   IO Write Byte |                 VMA Flags               |  DEV NO   |             Register Address                        |
//                 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//
//                   0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
//                 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//         IO Read |                 VMA Flags               |  DEV NO   |             Register Address                        |
//                 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//
//                   0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
//                 +-+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//  Read Controller|                 VMA Flags               |  |  PI NO |                 Unused                              |
//      Number     +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//
//                   0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
//                 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//  Read Intr Vect |                 VMA Flags               |  DEV NO   |                 Unused                              |
//                 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//
//
// File
//   bus.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
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
`include "apr.vh"
`include "vma.vh"
`include "useq/crom.vh"

module BUS(clk, rst, clken, crom, dp,
           vmaEXTENDED, vmaFLAGS, vmaADDR, pageADDR, aprFLAGS,
           busDATAO, busADDRO, busREQ, busACK, curINTP, memWAIT, nxmINTR);

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
   input  [ 0: 2]          curINTP;     // Current Interrupt Priority
   output                  memWAIT;     // Wait for Memory
   output                  nxmINTR;     // Non-existant Memory Interrupt

   //
   // APR Flags
   //

   wire flagPAGEEN     = `flagPAGEEN(aprFLAGS);

   //
   // VMA Flags
   //

   wire vmaREADCYCLE   = `vmaREADCYCLE(vmaFLAGS);
   wire vmaWRTESTCYCLE = `vmaWRTESTCYCLE(vmaFLAGS);
   wire vmaWRITECYCLE  = `vmaWRITECYCLE(vmaFLAGS);
   wire vmaPHYSICAL    = `vmaPHYSICAL(vmaFLAGS);
   wire vmaWRUCYCLE    = `vmaWRUCYCLE(vmaFLAGS);
   wire vmaVECTORCYCLE = `vmaVECTORCYCLE(vmaFLAGS);

   //
   // Paged Reference
   //

   wire pagedREF = ~vmaPHYSICAL & flagPAGEEN;

   //
   // Data Output
   //

   assign busDATAO[0:35] = dp[0:35];

   //
   // Address Output
   //

   reg [0:35] busADDRO;

   always @(pagedREF or vmaEXTENDED or vmaFLAGS or vmaADDR or pageADDR or vmaWRUCYCLE or curINTP)
     begin
        if (pagedREF)
          busADDRO <= {vmaFLAGS, vmaADDR[14:15], pageADDR[16:26], vmaADDR[27:35]};
        else
          begin
             if (vmaWRUCYCLE)
               busADDRO[0:35] <= {vmaFLAGS, 1'b0, curINTP, vmaADDR[18:35]};
             else
               begin
                  if (vmaEXTENDED)
                    busADDRO <= {vmaFLAGS, vmaADDR};
                  else
                    busADDRO <= {vmaFLAGS, 4'b0000, vmaADDR[18:35]};
               end
          end
     end

   //
   // Bus Request on the various cycles
   //

   assign busREQ = vmaREADCYCLE | vmaWRITECYCLE | vmaWRTESTCYCLE | vmaWRUCYCLE | vmaVECTORCYCLE;

   //
   // Wait for memory (REQ with no ACK)
   //

   assign memWAIT = busREQ & ~busACK;

   //
   // Bus Monitor
   //
   // Details
   //  Generate a NXM Interrupt on a bus timeout
   //

   reg [0:3] timeout;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          timeout <= 0;
        else
          begin
             if (memWAIT)
               begin
                  if (timeout != 15)
                    timeout <= timeout + 1'b1;
               end
             else
               timeout <= 0;
          end
     end

   assign nxmINTR = (timeout == 14);

endmodule
