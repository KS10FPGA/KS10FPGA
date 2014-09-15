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

module BUS(dp, vmaEXTENDED, vmaFLAGS, vmaADDR, pageADDR,
	   aprFLAGS, curINTP, cpuDATAO, cpuADDRO, cpuREQO);

   input  [ 0:35]          dp;          // Data path
   input                   vmaEXTENDED; // Extended VMA
   input  [ 0:13]          vmaFLAGS;    // VMA Flags
   input  [14:35]          vmaADDR;     // Virtual Memory Address
   input  [16:26]          pageADDR;    // Page Address
   input  [22:35]          aprFLAGS;    // APR Flags
   input  [ 0: 2]          curINTP;     // Current Interrupt Priority
   output [ 0:35]          cpuDATAO;    // CPU Data Out
   output [ 0:35]          cpuADDRO;    // CPU Address Out
   output                  cpuREQO;     // CPU Request

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
   wire vmaIOCYCLE     = `vmaIOCYCLE(vmaFLAGS);
   wire vmaWRUCYCLE    = `vmaWRUCYCLE(vmaFLAGS);
   wire vmaVECTORCYCLE = `vmaVECTORCYCLE(vmaFLAGS);

   //
   // Paged Reference
   //

   wire pagedREF = !vmaPHYSICAL & flagPAGEEN;

   //
   // Bus Request Output
   //  vmaIOCYCLE is asserted during WRU and VECT cycles
   //

   assign cpuREQO = vmaREADCYCLE | vmaWRITECYCLE  | vmaWRTESTCYCLE | vmaIOCYCLE;

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
          cpuADDRO <= {vmaFLAGS, vmaADDR[14:15], pageADDR[16:26], vmaADDR[27:35]};
        else
          begin
             if (vmaWRUCYCLE)
               cpuADDRO[0:35] <= {vmaFLAGS, 1'b0, curINTP, vmaADDR[18:35]};
             else
               begin
                  if (vmaEXTENDED)
                    cpuADDRO <= {vmaFLAGS, vmaADDR};
                  else
                    cpuADDRO <= {vmaFLAGS, 4'b0000, vmaADDR[18:35]};
               end
          end
     end

endmodule
