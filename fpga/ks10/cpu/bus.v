////////////////////////////////////////////////////////////////////////////////
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
//      Memory R/W |                 VMA Flags               |                      Memory Address                             |
//                 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//
//                   0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
//                 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//          IO R/W |                 VMA Flags               |  DEV NO   |             Register Address                        |
//                 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//
//                   0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
//                 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//     Byte IO R/W |                 VMA Flags               |  DEV NO   |             Register Address                        |
//                 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//
//                   0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
//                 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//       WRU Cycle |                 VMA Flags               | 0|  PI NO |                 Unused                              |
//                 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//
//                   0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
//                 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//    Vector Cycle |                 VMA Flags               |  DEV NO   |                 Unused                              |
//                 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//
//
// File
//   bus.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2014 Rob Doyle
//
// This source file may be used and distributed without restriction provided
// that this copyright statement is not removed from the file and that any
// derivative work contains the original copyright notice and the associated
// disclaimer.
//
// This source file is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as published by the
// Free Software Foundation; version 2.1 of the License.
//
// This source is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License
// for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this source; if not, download it from
// http://www.gnu.org/licenses/lgpl.txt
//
////////////////////////////////////////////////////////////////////////////////

`default_nettype none
`include "apr.vh"
`include "vma.vh"
`include "useq/crom.vh"

module BUS(clk, rst, dp, crom, vmaEXTENDED, vmaREG, pageADDR, aprFLAGS, piCURPRI,
           cpuDATAO, cpuADDRO, cpuREQO);

   parameter  cromWidth = `CROM_WIDTH;

   input          clk;                  // Clock
   input          rst;                  // Reset
   input  [ 0:35]          dp;          // Data path
   input  [ 0:cromWidth-1] crom;        // Control ROM Data
   input                   vmaEXTENDED; // Extended VMA
   input  [ 0:35]          vmaREG;      // VMA Register
   input  [16:26]          pageADDR;    // Page Address
   input  [22:35]          aprFLAGS;    // APR Flags
   input  [ 0: 2]          piCURPRI;    // Current Interrupt Priority
   output [ 0:35]          cpuDATAO;    // CPU Data Out
   output [ 0:35]          cpuADDRO;    // CPU Address Out
   output                  cpuREQO;     // CPU Request

   //
   // APR Flags
   //

   wire flagPAGEEN = `flagPAGEEN(aprFLAGS);

   //
   // VMA Flags
   //

   wire vmaREAD    = `vmaREAD(vmaREG);
   wire vmaWRTEST  = `vmaWRTEST(vmaREG);
   wire vmaWRITE   = `vmaWRITE(vmaREG);
   wire vmaPHYS    = `vmaPHYS(vmaREG);
   wire vmaIO      = `vmaIO(vmaREG);
   wire vmaWRU     = `vmaWRU(vmaREG);
   wire vmaVECT    = `vmaVECT(vmaREG);

   //
   // Paged Reference
   //

   wire pagedREF = !vmaPHYS & flagPAGEEN;

   //
   // The WRU cycle and VECTOR cycle are merged into a single long bus
   // transaction.  This splits the transaction in half so that the WRU and
   // VECTOR cycle and be arbitrated independantly.  This takes a clock cycle
   // off of the end of the WRU cycle.
   //

   reg addr3666;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          addr3666  <= 0;
        else
          addr3666 <= (crom[0:11] == 12'o3666);
     end

   //
   // Bus Request Output
   //

   assign cpuREQO = vmaREAD | vmaWRITE  | vmaWRTEST | vmaVECT |
                    (vmaWRU & !addr3666);

   //
   // Data Output
   //

   assign cpuDATAO = dp;

   //
   // Address Output
   //

   reg [0:35] cpuADDRO;

   always @*
     begin
        if (pagedREF)
          cpuADDRO <= {vmaREG[0:13], vmaREG[14:15], pageADDR[16:26], vmaREG[27:35]};
        else
          begin
             if (vmaWRU)
               cpuADDRO[0:35] <= {vmaREG[0:13], 1'b0, piCURPRI[0:2], vmaREG[18:35]};
             else
               begin
                  if (vmaEXTENDED)
                    cpuADDRO <= vmaREG;
                  else
                    cpuADDRO <= {vmaREG[0:13], 4'b0000, vmaREG[18:35]};
               end
          end
     end

endmodule
