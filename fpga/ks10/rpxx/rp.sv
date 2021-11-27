////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RP Disk
//
// Details
//
// Notes
//   Regarding endian-ness:
//     The KS10 backplane bus is 36-bit big-endian and uses [0:35] notation.
//     The IO Device are 36-bit little-endian (after Unibus) and uses [35:0]
//     notation.
//
//     Whereas the 'Unibus' is 18-bit data and 16-bit address, I've implemented
//     the IO bus as 36-bit address and 36-bit data just to keep things simple.
//
// File
//   rp.sv
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2021 Rob Doyle
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
`timescale 1ns/1ps

`include "rpds.vh"

module RP (
      massbus.slave        massbus,                     // Massbus interface
      input  wire          SD_MISO,                     // SD Data In
      output logic         SD_MOSI,                     // SD Data Out
      output logic         SD_SCLK,                     // SD Clock
      output logic         SD_SS_N,                     // SD Slave Select
      input  wire  [ 7: 0] rpMOL,                       // RPxx Media On-line
      input  wire  [ 7: 0] rpWRL,                       // RPxx Write Lock
      input  wire  [ 7: 0] rpDPR,                       // RPxx Drive Present
      output logic [ 0: 7] rpLEDS,                      // Status LEDS
      output logic [ 0:63] rpDEBUG                      // Debug Output
   );

   //
   // Bus interface
   //

   logic clk;
   logic rst;
   assign clk = massbus.clk;
   assign rst = massbus.rst;

   //
   // SD Signals
   //

   logic [ 2: 0] rpSDOP [7:0];                          // SD operation
   logic [20: 0] rpSDLSA[7:0];                          // SD Linear sector address
   logic [ 7: 0] rpSDREQ;                               // RP requests the SD
   logic [ 7: 0] rpSDACK;                               // SD acknowledges the RP
   logic [ 2: 0] rpSCAN;                                // Current RP accessing SD
   logic         rpREADOP;                              // Read operation
   logic         rpINCSECT;                             // Increment Sector

   //
   // Registers
   //

   logic [15: 0] rpDS[0:7];
   logic [15: 0] rpER1[0:7];
   logic [15: 0] rpMR[0:7];
   logic [15: 0] rpDA[0:7];
   logic [15: 0] rpDT[0:7];
   logic [15: 0] rpLA[0:7];
   logic [15: 0] rpSN[0:7];
   logic [15: 0] rpOF[0:7];
   logic [15: 0] rpDC[0:7];
   logic [15: 0] rpCC[0:7];
   logic [15: 0] rpER2[0:7];
   logic [15: 0] rpER3[0:7];
   logic [15: 0] rpEC1[0:7];
   logic [15: 0] rpEC2[0:7];

   //
   // Generate an array of disk drives
   //

   generate

      genvar i;

      for (i = 0; i < 8; i = i + 1)

        begin : uRPXX

           RPXX #(
              .rpDRVTYP  (`getTYPE(i)),
              .rpDRVSN   (`getSN(i))
           )
           uRPXX (
              .clk       (clk),
              .rst       (rst),
              .rpNUM     (i[2:0]),
              .rpMOL     (rpMOL[i]),
              .rpWRL     (rpWRL[i]),
              .rpDPR     (rpDPR[i]),
              .devDATAI  (massbus.mbDATAI),
              .rpINIT    (massbus.mbINIT),
              .rpPAT     (massbus.mbPAT),
              .rpUNIT    (massbus.mbUNIT),
              .rpREAD    (massbus.mbREAD),
              .rpWRITE   (massbus.mbWRITE),
              .rpREGSEL  (massbus.mbREGSEL),
              .rpFUN     (massbus.mbFUN),
              .rpFUNGO   (massbus.mbGO),
              .rpDS      (rpDS[i]),
              .rpER1     (rpER1[i]),
              .rpMR      (rpMR[i]),
              .rpDA      (rpDA[i]),
              .rpDT      (rpDT[i]),
              .rpLA      (rpLA[i]),
              .rpSN      (rpSN[i]),
              .rpOF      (rpOF[i]),
              .rpDC      (rpDC[i]),
              .rpCC      (rpCC[i]),
              .rpER2     (rpER2[i]),
              .rpER3     (rpER3[i]),
              .rpEC1     (rpEC1[i]),
              .rpEC2     (rpEC2[i]),
              .rpSDOP    (rpSDOP[i]),
              .rpSDREQ   (rpSDREQ[i]),
              .rpSDACK   (rpSDACK[i]),
              .rpSDLSA   (rpSDLSA[i]),
              .rpACTIVE  (rpLEDS[i]),
              .rpINCRSECT(rpINCSECT)
           );

        end

   endgenerate

   //
   // Multiplex registers back to RH11
   //

   always_comb
     begin
        case (massbus.mbREGSEL)
          5'o01: massbus.mbREGDAT = rpDS[massbus.mbUNIT];
          5'o02: massbus.mbREGDAT = rpER1[massbus.mbUNIT];
          5'o03: massbus.mbREGDAT = rpMR[massbus.mbUNIT];
          5'o05: massbus.mbREGDAT = rpDA[massbus.mbUNIT];
          5'o06: massbus.mbREGDAT = rpDT[massbus.mbUNIT];
          5'o07: massbus.mbREGDAT = rpLA[massbus.mbUNIT];
          5'o10: massbus.mbREGDAT = rpSN[massbus.mbUNIT];
          5'o11: massbus.mbREGDAT = rpOF[massbus.mbUNIT];
          5'o12: massbus.mbREGDAT = rpDC[massbus.mbUNIT];
          5'o13: massbus.mbREGDAT = rpCC[massbus.mbUNIT];
          5'o14: massbus.mbREGDAT = rpER2[massbus.mbUNIT];
          5'o15: massbus.mbREGDAT = rpER3[massbus.mbUNIT];
          5'o16: massbus.mbREGDAT = rpEC1[massbus.mbUNIT];
          5'o17: massbus.mbREGDAT = rpEC2[massbus.mbUNIT];
          default: massbus.mbREGDAT = 16'b0;
        endcase
     end

   assign massbus.mbREGACK = (massbus.mbREGSEL <= 5'o17);

   //
   // SD Controller
   //

   SD uSD (
      .clk        (clk),
      .rst        (rst),
      .clr        (massbus.mbINIT),
`ifndef SYNTHESIS
      .file       (massbus.file),
`endif
      .SD_MISO    (SD_MISO),
      .SD_MOSI    (SD_MOSI),
      .SD_SCLK    (SD_SCLK),
      .SD_SS_N    (SD_SS_N),
      // Device interface
      .devDATAI   (massbus.mbDATAI),
      .devDATAO   (massbus.mbDATAO),
      .devREQO    (massbus.mbREQO),
      .devACKI    (massbus.mbACKI),
      // RH11 interfaces
      .rhWCZ      (massbus.mbWCZ),
      // RPXX interface
      .rpSDOP     (rpSDOP[rpSCAN]),
      .rpSDLSA    (rpSDLSA[rpSCAN]),
      .rpSDREQ    (rpSDREQ),
      .rpSDACK    (rpSDACK),
      // SD Output
      .sdINCWC    (massbus.mbINCWC),
      .sdINCBA    (massbus.mbINCBA),
      .sdSETWCE   (massbus.mbWCE),
      .sdINCSECT  (rpINCSECT),
      .sdREADOP   (rpREADOP),
      .sdSCAN     (rpSCAN),
      .sdDEBUG    (rpDEBUG)
   );

   //
   // FIXME:
   //  Something is wrong here with rpREADOP
   //

   assign massbus.mbNPRO = rpREADOP;

   //
   // Attention
   //

   assign massbus.mbATA[0] = `rpDS_ATA(rpDS[0]);
   assign massbus.mbATA[1] = `rpDS_ATA(rpDS[1]);
   assign massbus.mbATA[2] = `rpDS_ATA(rpDS[2]);
   assign massbus.mbATA[3] = `rpDS_ATA(rpDS[3]);
   assign massbus.mbATA[4] = `rpDS_ATA(rpDS[4]);
   assign massbus.mbATA[5] = `rpDS_ATA(rpDS[5]);
   assign massbus.mbATA[6] = `rpDS_ATA(rpDS[6]);
   assign massbus.mbATA[7] = `rpDS_ATA(rpDS[7]);

   //
   // Drive Present (RPDS[DPR])
   //

   assign massbus.mbDPR    = `rpDS_DPR(rpDS[massbus.mbUNIT]);

   //
   // Drive Ready (RPDS[DRY])
   //

   assign massbus.mbDRY    = `rpDS_DRY(rpDS[massbus.mbUNIT]);

   //
   // Drive Available (MTCS1[DVA])
   //

   assign massbus.mbDVA    = 1;

   //
   // Parity Test from RP
   //

   assign massbus.mbINVPAR = 0;

   //
   // ACLO
   //

   assign massbus.mbACLO = 0;

   //
   // mtDECBA
   //
   // No reverse operations on a disk drive
   //

   assign massbus.mbDECBA = 0;

endmodule
