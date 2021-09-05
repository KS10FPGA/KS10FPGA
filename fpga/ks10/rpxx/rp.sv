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
   // SD Signals
   //

   logic [ 2: 0] rpSDOP [7:0];                          // SD operation
   logic [20: 0] rpSDLSA[7:0];                          // SD Linear sector address
   logic [ 7: 0] rpSDREQ;                               // RP requests the SD
   logic [ 7: 0] rpSDACK;                               // SD acknowledges the RP
   logic [ 2: 0] sdSCAN;                                // Current RP accessing SD
   logic         sdREADOP;                              // Read operation
   logic         sdINCSECT;                             // Increment Sector

   wire  [ 2: 0] rpUNIT = `rhCS2_UNIT(massbus.rhCS2);   // Unit
   wire          rpPAT  = `rhCS2_PAT(massbus.rhCS2);    // Parity Test

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
              .clk       (massbus.clk),
              .rst       (massbus.rst),
              .devRESET  (massbus.devRESET),
              .devDATAI  (massbus.devDATAI),
              .rhUNIT    (rpUNIT),
              .rpNUM     (i[2:0]),
              .rpPAT     (rpPAT),
              .rpINCRSECT(sdINCSECT),
              .rpMOL     (rpMOL[i]),
              .rpWRL     (rpWRL[i]),
              .rpDPR     (rpDPR[i]),
              .rpADDR    (massbus.mbADDR),
              .rpREAD    (massbus.mbREAD),
              .rpWRITE   (massbus.mbWRITE),
              .rpCS1     (massbus.mbREG00[i]),
              .rpDA      (massbus.mbREG06[i]),
              .rpDS      (massbus.mbREG12[i]),
              .rpER1     (massbus.mbREG14[i]),
              .rpLA      (massbus.mbREG20[i]),
              .rpMR      (massbus.mbREG24[i]),
              .rpDT      (massbus.mbREG26[i]),
              .rpSN      (massbus.mbREG30[i]),
              .rpOF      (massbus.mbREG32[i]),
              .rpDC      (massbus.mbREG34[i]),
              .rpCC      (massbus.mbREG36[i]),
              .rpER2     (massbus.mbREG40[i]),
              .rpER3     (massbus.mbREG42[i]),
              .rpEC1     (massbus.mbREG44[i]),
              .rpEC2     (massbus.mbREG46[i]),
              .rpSDOP    (rpSDOP[i]),
              .rpSDREQ   (rpSDREQ[i]),
              .rpSDACK   (rpSDACK[i]),
              .rpSDLSA   (rpSDLSA[i]),
              .rpACTIVE  (rpLEDS[i])
           );

        end

   endgenerate

   //
   // SD Controller
   //

   SD uSD (
      .clk        (massbus.clk),
      .rst        (massbus.rst),
      .clr        (massbus.devRESET),
`ifndef SYNTHESIS
      .file       (massbus.file),
`endif
      .SD_MISO    (SD_MISO),
      .SD_MOSI    (SD_MOSI),
      .SD_SCLK    (SD_SCLK),
      .SD_SS_N    (SD_SS_N),
      // Device interface
      .devDATAI   (massbus.devDATAI),
      .devDATAO   (massbus.devDATAO),
      .devREQO    (massbus.devREQO),
      .devACKI    (massbus.devACKI),
      // RH11 interfaces
      .rhWC       (massbus.rhWC),
      // RPXX interface
      .rpSDOP     (rpSDOP[sdSCAN]),
      .rpSDLSA    (rpSDLSA[sdSCAN]),
      .rpSDREQ    (rpSDREQ),
      .rpSDACK    (rpSDACK),
      // SD Output
      .sdINCWC    (massbus.incWC2),
      .sdINCBA    (massbus.incBA4),
      .sdSETWCE   (massbus.setWCE),
      .sdINCSECT  (sdINCSECT),
      .sdREADOP   (sdREADOP),
      .sdSCAN     (sdSCAN),
      .sdDEBUG    (rpDEBUG)
   );

   //
   // FIXME:
   //  Something is wrong here with sdREADOP
   //

   assign massbus.setNPRO = sdREADOP;

   //
   // ACLO
   //

   assign massbus.devACLO = 0;

   //
   // Parity Test from RP
   //

   assign massbus.mbINVPAR = 0;


endmodule
