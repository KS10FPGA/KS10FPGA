//////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KS-10 RH11 Massbus Disk Controller
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
//   rh11.sv
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

`include "rh11.vh"
`include "rhds.vh"
`include "rhcs1.vh"
`include "rhcs2.vh"
`include "../uba/ubabus.vh"

module RH11 (
      unibus.device  unibus,                            // Unibus connection
      massbus.master massbus                            // Massbus Interface
   );

   //
   // Bus Interface
   //

   logic  clk;                                          // Clock
   logic  rst;                                          // Reset
   logic  devRESET;                                     // Device reset
   assign clk      = unibus.clk;                        // Clock
   assign rst      = unibus.rst;                        // Reset
   assign devRESET = unibus.devRESET;                   // Device reset

   //
   // RH Parameters
   //

   parameter [14:17] rhDEV   = `devUBA1;                // RH11 Device Number
   parameter [18:35] rhADDR  = `rh1ADDR;                // RH11 Base Address
   parameter [18:35] rhVECT  = `rh1VECT;                // RH11 Interrupt Vector
   parameter [ 7: 4] rhINTR  = `rh1INTR;                // RH11 Interrupt

   //
   // RH Register Addresses
   //

   localparam [18:35] rhADDR00 = rhADDR + 6'o00;        // Address 00
   localparam [18:35] rhADDR02 = rhADDR + 5'o02;        // Address 02
   localparam [18:35] rhADDR04 = rhADDR + 6'o04;        // Address 04
   localparam [18:35] rhADDR06 = rhADDR + 6'o06;        // Address 06

   localparam [18:35] rhADDR10 = rhADDR + 6'o10;        // Address 10
   localparam [18:35] rhADDR12 = rhADDR + 6'o12;        // Address 12
   localparam [18:35] rhADDR14 = rhADDR + 6'o14;        // Address 14
   localparam [18:35] rhADDR16 = rhADDR + 6'o16;        // Address 16

   localparam [18:35] rhADDR20 = rhADDR + 6'o20;        // Address 20
   localparam [18:35] rhADDR22 = rhADDR + 6'o22;        // Address 22
   localparam [18:35] rhADDR24 = rhADDR + 6'o24;        // Address 24
   localparam [18:35] rhADDR26 = rhADDR + 6'o26;        // Address 26

   localparam [18:35] rhADDR30 = rhADDR + 6'o30;        // Address 30
   localparam [18:35] rhADDR32 = rhADDR + 6'o32;        // Address 32
   localparam [18:35] rhADDR34 = rhADDR + 6'o34;        // Address 34
   localparam [18:35] rhADDR36 = rhADDR + 6'o36;        // Address 36

   localparam [18:35] rhADDR40 = rhADDR + 6'o40;        // Address 40
   localparam [18:35] rhADDR42 = rhADDR + 6'o42;        // Address 42
   localparam [18:35] rhADDR44 = rhADDR + 6'o44;        // Address 44
   localparam [18:35] rhADDR46 = rhADDR + 6'o46;        // Address 46

   //
   // Address Flags
   //

   localparam [ 0:17] rdFLAGS = 18'b000_100_000_000_000_000;
   localparam [ 0:17] wrFLAGS = 18'b000_001_000_000_000_000;

   //
   // Debug output
   //

`ifndef SYNTHESIS

   integer file;

`endif

   //
   // Device Address and Flags
   //

   wire         devREAD   = `devREAD(unibus.devADDRI);  // Read Cycle
   wire         devWRITE  = `devWRITE(unibus.devADDRI); // Write Cycle
   wire         devPHYS   = `devPHYS(unibus.devADDRI);  // Physical reference
   wire         devIO     = `devIO(unibus.devADDRI);    // IO Cycle
   wire         devWRU    = `devWRU(unibus.devADDRI);   // WRU Cycle
   wire         devVECT   = `devVECT(unibus.devADDRI);  // Read interrupt vector
   wire [14:17] devDEV    = `devDEV(unibus.devADDRI);   // Device Number
   wire [18:35] devADDR   = `devADDR(unibus.devADDRI);  // Device Address
   wire         devHIBYTE = `devHIBYTE(unibus.devADDRI);// Device High Byte
   wire         devLOBYTE = `devLOBYTE(unibus.devADDRI);// Device Low Byte

   //
   // Read/Write Decoding
   //

   wire rhREAD   = unibus.devREQI & devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV);
   wire rhWRITE  = unibus.devREQI & devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV);
   wire vectREAD = unibus.devREQI & devREAD  & devIO & devPHYS & !devWRU &  devVECT & (devDEV == rhDEV);

   //
   // Address Decoding
   //

   wire rhRDREG00 = rhREAD  & (devADDR == rhADDR00);        // RHCS1
   wire rhWRREG00 = rhWRITE & (devADDR == rhADDR00);        // RHCS1
   wire rhRDREG02 = rhREAD  & (devADDR == rhADDR02);        // RHWC
   wire rhWRREG02 = rhWRITE & (devADDR == rhADDR02);        // RHWC
   wire rhRDREG04 = rhREAD  & (devADDR == rhADDR04);        // RHBA
   wire rhWRREG04 = rhWRITE & (devADDR == rhADDR04);        // RHBA
   wire rhRDREG06 = rhREAD  & (devADDR == rhADDR06);        // RPDA/MTFC
   wire rhWRREG06 = rhWRITE & (devADDR == rhADDR06);        // RPDA/MTFC

   wire rhRDREG10 = rhREAD  & (devADDR == rhADDR10);        // RHCS2
   wire rhWRREG10 = rhWRITE & (devADDR == rhADDR10);        // RHCS2
   wire rhRDREG12 = rhREAD  & (devADDR == rhADDR12);        // RPDS/MTDS
   wire rhWRREG12 = rhWRITE & (devADDR == rhADDR12);        // RPDS/MTDS
   wire rhRDREG14 = rhREAD  & (devADDR == rhADDR14);        // RPER1/MTER
   wire rhWRREG14 = rhWRITE & (devADDR == rhADDR14);        // RPER1/MTER
   wire rhRDREG16 = rhREAD  & (devADDR == rhADDR16);        // RHAS
   wire rhWRREG16 = rhWRITE & (devADDR == rhADDR16);        // RHAS

   wire rhRDREG20 = rhREAD  & (devADDR == rhADDR20);        // RPLA/MTCC
   wire rhWRREG20 = rhWRITE & (devADDR == rhADDR20);        // RPLA/MTCC
   wire rhRDREG22 = rhREAD  & (devADDR == rhADDR22);        // RHDB
   wire rhWRREG22 = rhWRITE & (devADDR == rhADDR22);        // RHDB
   wire rhRDREG24 = rhREAD  & (devADDR == rhADDR24);        // RPMR/MTMR
   wire rhWRREG24 = rhWRITE & (devADDR == rhADDR24);        // RPMR/MTMR
   wire rhRDREG26 = rhREAD  & (devADDR == rhADDR26);        // RPDT/MTDT
   wire rhWRREG26 = rhWRITE & (devADDR == rhADDR26);        // RPDT/MTDT

   wire rhRDREG30 = rhREAD  & (devADDR == rhADDR30);        // RPSN/MTSN
   wire rhWRREG30 = rhWRITE & (devADDR == rhADDR30);        // RPSN/MTSN
   wire rhRDREG32 = rhREAD  & (devADDR == rhADDR32);        // RPOF/MTTC
   wire rhWRREG32 = rhWRITE & (devADDR == rhADDR32);        // RPOF/MTTC
   wire rhRDREG34 = rhREAD  & (devADDR == rhADDR34);        // RPDC/zero
   wire rhWRREG34 = rhWRITE & (devADDR == rhADDR34);        // RPDC/zero
   wire rhRDREG36 = rhREAD  & (devADDR == rhADDR36);        // RPCC/zero
   wire rhWRREG36 = rhWRITE & (devADDR == rhADDR36);        // RPCC/zero

   wire rhRDREG40 = rhREAD  & (devADDR == rhADDR40);        // RPER2/zero
   wire rhWRREG40 = rhWRITE & (devADDR == rhADDR40);        // RPER2/zero
   wire rhRDREG42 = rhREAD  & (devADDR == rhADDR42);        // RPER3/zero
   wire rhWRREG42 = rhWRITE & (devADDR == rhADDR42);        // RPER3/zero
   wire rhRDREG44 = rhREAD  & (devADDR == rhADDR44);        // RPEC1/zero
   wire rhWRREG44 = rhWRITE & (devADDR == rhADDR44);        // RPEC1/zero
   wire rhRDREG46 = rhREAD  & (devADDR == rhADDR46);        // RPEC2/zero
   wire rhWRREG46 = rhWRITE & (devADDR == rhADDR46);        // RPEC2/zero

   //
   // Big-endian to little-endian data bus swap
   //

   wire [35: 0] rhDATAI = unibus.devDATAI[0:35];

   //
   // Interrupt Acknowledge
   //

   wire         rhIACK = vectREAD;

   //
   // RH11 Registers
   //

   wire [15: 0] rhCS1;                   // RHCS1
   wire [15: 0] rhWC;                    // RHWC
   wire [17: 0] rhBA;                    // RHBA
   wire [15: 0] rhCS2;                   // RHCS2
   wire [15: 0] rhDB;                    // RHDB

   //
   // RH11 Control/Status #2 (CS2) Register
   //

   wire         rhDLT  = `rhCS2_DLT(rhCS2);
   wire         rhWCE  = `rhCS2_WCE(rhCS2);
   wire         rhUPE  = `rhCS2_UPE(rhCS2);
   wire         rhNED  = `rhCS2_NED(rhCS2);
   wire         rhNEM  = `rhCS2_NEM(rhCS2);
   wire         rhPGE  = `rhCS2_PGE(rhCS2);
   wire         rhMXF  = `rhCS2_MXF(rhCS2);
   wire         rhDPE  = `rhCS2_DPE(rhCS2);
   wire         rhCLR  = `rhCS2_CLR(rhCS2);
   wire         rhBAI  = `rhCS2_BAI(rhCS2);
   wire [ 2: 0] rhUNIT = `rhCS2_UNIT(rhCS2);

   //
   // RH11 Control/Status #1 (CS1) Register
   //

   wire         rhSC   = `rhCS1_SC (rhCS1);
   wire         rhRDY  = `rhCS1_RDY(rhCS1);
   wire         rhIE   = `rhCS1_IE (rhCS1);
   wire         rhDVA  = `rhCS1_DVA(massbus.mbREG00[rhUNIT]);
   wire [ 5: 1] rhFUN  = `rhCS1_FUN(massbus.mbREG00[rhUNIT]);
   wire         rhGO   = `rhCS1_GO(massbus.mbREG00[rhUNIT]);

   //
   // RHDS Status
   //

   wire         rhERR  = `rhDS_ERR(massbus.mbREG12[rhUNIT]);
   wire         rhDPR  = `rhDS_DPR(massbus.mbREG12[rhUNIT]);

   //
   // RH11 Attention Summary (RHAS) Pseudo Register
   //

   wire [15: 0] rhAS = {8'b0,
                        `rhDS_ATA(massbus.mbREG12[7]),
                        `rhDS_ATA(massbus.mbREG12[6]),
                        `rhDS_ATA(massbus.mbREG12[5]),
                        `rhDS_ATA(massbus.mbREG12[4]),
                        `rhDS_ATA(massbus.mbREG12[3]),
                        `rhDS_ATA(massbus.mbREG12[2]),
                        `rhDS_ATA(massbus.mbREG12[1]),
                        `rhDS_ATA(massbus.mbREG12[0])};

   //
   // ATA (from all disks)
   //

   wire         rhATA = (`rhDS_ATA(massbus.mbREG12[7]) |
                         `rhDS_ATA(massbus.mbREG12[6]) |
                         `rhDS_ATA(massbus.mbREG12[5]) |
                         `rhDS_ATA(massbus.mbREG12[4]) |
                         `rhDS_ATA(massbus.mbREG12[3]) |
                         `rhDS_ATA(massbus.mbREG12[2]) |
                         `rhDS_ATA(massbus.mbREG12[1]) |
                         `rhDS_ATA(massbus.mbREG12[0]));

   //
   // RH Signals
   //

   wire         rhSETNEM;               // Set non-existent memory
   wire         rhSETDLT;               // Set device late
   wire         rhBUFIR;                // Buffer input ready
   wire         rhBUFOR;                // Buffer output ready
   wire         rhIRQ;                  // Interrupt request

   //
   // Transfer Error Clear
   //

   wire rhCLRTRE = rhWRREG00 & devHIBYTE & `rhCS1_TRE(rhDATAI);

   //
   // Go Command
   //

   wire rhCMDGO = rhWRREG00 & `rhCS1_GO(rhDATAI);

   //
   // Set Non-existant Device (NED)
   //

   wire rhSETNED = (rhWRREG06 & !rhDPR |
                    rhRDREG06 & !rhDPR |
                    rhWRREG12 & !rhDPR |
                    rhRDREG12 & !rhDPR |
                    rhWRREG14 & !rhDPR |
                    rhRDREG14 & !rhDPR |
                    rhWRREG16 & !rhDPR |
                    rhRDREG16 & !rhDPR |
                    rhWRREG20 & !rhDPR |
                    rhRDREG20 & !rhDPR |
                    rhWRREG24 & !rhDPR |
                    rhRDREG24 & !rhDPR |
                    rhWRREG26 & !rhDPR |
                    rhRDREG26 & !rhDPR |
                    rhWRREG30 & !rhDPR |
                    rhRDREG30 & !rhDPR |
                    rhWRREG32 & !rhDPR |
                    rhRDREG32 & !rhDPR |
                    rhWRREG34 & !rhDPR |
                    rhRDREG34 & !rhDPR |
                    rhWRREG36 & !rhDPR |
                    rhRDREG36 & !rhDPR |
                    rhWRREG40 & !rhDPR |
                    rhRDREG40 & !rhDPR |
                    rhWRREG42 & !rhDPR |
                    rhRDREG42 & !rhDPR |
                    rhWRREG44 & !rhDPR |
                    rhRDREG44 & !rhDPR |
                    rhWRREG46 & !rhDPR |
                    rhRDREG46 & !rhDPR);

   //
   // Command Clear
   //  This decodes functions 24 through 37.  Some of these are used by the Disk
   //  Drives and others are used by the Tape Drives.  See comments.
   //
   // Trace
   //  M7296/CSRA/E6
   //  M7296/CSRA/E14
   //  M7296/CSRA/E16
   //  M7296/CSRA/E17
   //
   //                                                                                           // ------- RP06 -------   ------- TM02 -------
   wire rhCLRGO = ((rhRDY & rhWRREG00 & (`rhCS1_FUN(rhDATAI) == 5'o24) & `rhCS1_GO(rhDATAI)) |  // Write Check            Write Check Forward
                   (rhRDY & rhWRREG00 & (`rhCS1_FUN(rhDATAI) == 5'o25) & `rhCS1_GO(rhDATAI)) |  // Write Check Header
                   (rhRDY & rhWRREG00 & (`rhCS1_FUN(rhDATAI) == 5'o26) & `rhCS1_GO(rhDATAI)) |  //
                   (rhRDY & rhWRREG00 & (`rhCS1_FUN(rhDATAI) == 5'o27) & `rhCS1_GO(rhDATAI)) |  //                        Write Check Reverse
                   (rhRDY & rhWRREG00 & (`rhCS1_FUN(rhDATAI) == 5'o30) & `rhCS1_GO(rhDATAI)) |  // Write                  Write Forward
                   (rhRDY & rhWRREG00 & (`rhCS1_FUN(rhDATAI) == 5'o31) & `rhCS1_GO(rhDATAI)) |  // Write Header
                   (rhRDY & rhWRREG00 & (`rhCS1_FUN(rhDATAI) == 5'o32) & `rhCS1_GO(rhDATAI)) |  //
                   (rhRDY & rhWRREG00 & (`rhCS1_FUN(rhDATAI) == 5'o33) & `rhCS1_GO(rhDATAI)) |  //
                   (rhRDY & rhWRREG00 & (`rhCS1_FUN(rhDATAI) == 5'o34) & `rhCS1_GO(rhDATAI)) |  // Read                   Read Forward
                   (rhRDY & rhWRREG00 & (`rhCS1_FUN(rhDATAI) == 5'o35) & `rhCS1_GO(rhDATAI)) |  // Read Header
                   (rhRDY & rhWRREG00 & (`rhCS1_FUN(rhDATAI) == 5'o36) & `rhCS1_GO(rhDATAI)) |  //
                   (rhRDY & rhWRREG00 & (`rhCS1_FUN(rhDATAI) == 5'o37) & `rhCS1_GO(rhDATAI)));  //                        Read Reverse


   //
   // Controller Parity Error
   //  Massbus device is sending inverted parity to RH11 in maintenance mode.
   //

   wire rhSETCPE = rhREAD & massbus.mbINVPAR;

   //
   // RH11 Control/Status #1 (RHCS1) Register
   //

   RHCS1 CS1 (
      .clk        (clk),
      .rst        (rst),
      .devRESET   (devRESET),
      .devLOBYTE  (devLOBYTE),
      .devHIBYTE  (devHIBYTE),
      .rhDATAI    (rhDATAI),
      .rhcs1WRITE (rhWRREG00),
      .rhCLRGO    (rhCLRGO),
      .rhCLRTRE   (rhCLRTRE),
      .rhSETCPE   (rhSETCPE),
      .rhDLT      (rhDLT),
      .rhWCE      (rhWCE),
      .rhUPE      (rhUPE),
      .rhNED      (rhNED),
      .rhNEM      (rhNEM),
      .rhPGE      (rhPGE),
      .rhMXF      (rhMXF),
      .rhDPE      (rhDPE),
      .rhCLR      (rhCLR),
      .rhIACK     (rhIACK),
      .rhATA      (rhATA),
      .rhERR      (rhERR),
      .rhDVA      (rhDVA),
      .rhFUN      (rhFUN),
      .rhGO       (rhGO),
      .rhBA       (rhBA[17:16]),
      .rhCS1      (rhCS1)
   );

   //
   // RH11 Word Count (RHWC) Register
   //

   RHWC WC (
      .clk        (clk),
      .rst        (rst),
      .devRESET   (devRESET),
      .devLOBYTE  (devLOBYTE),
      .devHIBYTE  (devHIBYTE),
      .rhDATAI    (rhDATAI),
      .rhwcWRITE  (rhWRREG02),
      .rhCLR      (rhCLR),
      .rhINCWC    (massbus.incWC2),
      .rhWC       (rhWC)
   );

   //
   // RH11 Bus Address (RHBA) Register
   //

   RHBA BA (
      .clk        (clk),
      .rst        (rst),
      .devRESET   (devRESET),
      .devLOBYTE  (devLOBYTE),
      .devHIBYTE  (devHIBYTE),
      .rhDATAI    (rhDATAI),
      .rhcs1WRITE (rhWRREG00),
      .rhbaWRITE  (rhWRREG04),
      .rhCLR      (rhCLR),
      .rhRDY      (rhRDY),
      .rhBAI      (rhBAI),
      .rhINCBA    (massbus.incBA4),
      .rhBA       (rhBA)
   );

   //
   // RH11 Control/Status #2 (RHCS2) Register
   //

   RHCS2 CS2 (
      .clk        (clk),
      .rst        (rst),
      .devRESET   (devRESET),
      .devLOBYTE  (devLOBYTE),
      .devHIBYTE  (devHIBYTE),
      .rhDATAI    (rhDATAI),
      .rhcs2WRITE (rhWRREG10),
      .rhCMDGO    (rhCMDGO),
      .rhCLRGO    (rhCLRGO),
      .rhCLRTRE   (rhCLRTRE),
      .rhCLR      (rhCLR),
      .rhRDY      (rhRDY),
      .rhSETDLT   (rhSETDLT),
      .rhSETNED   (rhSETNED),
      .rhSETNEM   (rhSETNEM),
      .rhSETWCE   (massbus.setWCE),
      .rhBUFIR    (rhBUFIR),
      .rhBUFOR    (rhBUFOR),
      .rhCS2      (rhCS2)
   );

   //
   // RH11 Data Buffer (RHDB) Register
   //

   RHDB DB (
      .clk        (clk),
      .rst        (rst),
      .devRESET   (devRESET),
      .devLOBYTE  (devLOBYTE),
      .devHIBYTE  (devHIBYTE),
      .rhDATAI    (rhDATAI),
      .rhCLRGO    (rhCLRGO),
      .rhCLRTRE   (rhCLRTRE),
      .rhCLR      (rhCLR),
      .rhdbREAD   (rhRDREG22),
      .rhdbWRITE  (rhWRREG22),
      .rhSETDLT   (rhSETDLT),
      .rhBUFIR    (rhBUFIR),
      .rhBUFOR    (rhBUFOR),
      .rhDB       (rhDB)
   );

   //
   // RH11 Interrupt Controller
   //

   RHINTR INTR (
      .clk        (clk),
      .rst        (rst),
      .devRESET   (devRESET),
      .devLOBYTE  (devLOBYTE),
      .rhDATAI    (rhDATAI),
      .rhcs1WRITE (rhWRREG00),
      .rhSC       (rhSC),
      .rhRDY      (rhRDY),
      .rhIE       (rhIE),
      .rhCLR      (rhCLR),
      .rhIACK     (rhIACK),
      .rhIRQ      (rhIRQ)
   );

   //
   // Non-existent Memory
   //

   RHNEM NEM (
      .clk        (clk),
      .rst        (rst),
      .devREQO    (unibus.devREQO),
      .devACKI    (unibus.devACKI),
      .setNEM     (rhSETNEM)
   );

   //
   // Generate Bus ACK
   //

   assign unibus.devACKO = (rhWRREG00 | rhRDREG00 |
                            rhWRREG02 | rhRDREG02 |
                            rhWRREG04 | rhRDREG04 |
                            rhWRREG06 | rhRDREG06 |
                            //
                            rhWRREG10 | rhRDREG10 |
                            rhWRREG12 | rhRDREG12 |
                            rhWRREG14 | rhRDREG14 |
                            rhWRREG16 | rhRDREG16 |
                            //
                            rhWRREG20 | rhRDREG20 |
                            rhWRREG22 | rhRDREG22 |
                            rhWRREG24 | rhRDREG24 |
                            rhWRREG26 | rhRDREG26 |
                            //
                            rhWRREG30 | rhRDREG30 |
                            rhWRREG32 | rhRDREG32 |
                            rhWRREG34 | rhRDREG34 |
                            rhWRREG36 | rhRDREG36 |
                            //
                            rhWRREG40 | rhRDREG40 |
                            rhWRREG42 | rhRDREG42 |
                            rhWRREG44 | rhRDREG44 |
                            rhWRREG46 | rhRDREG46 |
                            //
                            vectREAD);

   //
   // Bus Mux and little-endian to big-endian bus swap.
   //  Only output the RP register if the disk is present.
   //

   always @*
     begin
        unibus.devDATAO = 0;
        if (massbus.devREQO)
          unibus.devDATAO = massbus.devDATAO;
        if (rhRDREG00)
          unibus.devDATAO = {20'b0, rhCS1};                    // RHCS1
        if (rhRDREG02)
          unibus.devDATAO = {20'b0, rhWC};                     // RHWC
        if (rhRDREG04)
          unibus.devDATAO = {20'b0, rhBA[15:0]};               // RHBA
        if (rhRDREG06 & rhDPR)
          unibus.devDATAO = {20'b0, massbus.mbREG06[rhUNIT]};  // RPDA,  MTFC
        if (rhRDREG10)
          unibus.devDATAO = {20'b0, rhCS2};                    // RHCS2
        if (rhRDREG12 & rhDPR)
          unibus.devDATAO = {20'b0, massbus.mbREG12[rhUNIT]};  // RPDS,  MTDS
        if (rhRDREG14 & rhDPR)
          unibus.devDATAO = {20'b0, massbus.mbREG14[rhUNIT]};  // RPER1, MTER
        if (rhRDREG16)
          unibus.devDATAO = {20'b0, rhAS};                     // RHAS
        if (rhRDREG20 & rhDPR)
          unibus.devDATAO = {20'b0, massbus.mbREG20[rhUNIT]};  // RPLA,  MTCC
        if (rhRDREG22)
          unibus.devDATAO = {20'b0, rhDB};                     // RHDB
        if (rhRDREG24 & rhDPR)
          unibus.devDATAO = {20'b0, massbus.mbREG24[rhUNIT]};  // RPMR,  MTMR
        if (rhRDREG26 & rhDPR)
          unibus.devDATAO = {20'b0, massbus.mbREG26[rhUNIT]};  // RPDT,  MTDT
        if (rhRDREG30 & rhDPR)
          unibus.devDATAO = {20'b0, massbus.mbREG30[rhUNIT]};  // RPSN,  MTSN
        if (rhRDREG32 & rhDPR)
          unibus.devDATAO = {20'b0, massbus.mbREG32[rhUNIT]};  // RPOF,  MTTC
        if (rhRDREG34 & rhDPR)
          unibus.devDATAO = {20'b0, massbus.mbREG34[rhUNIT]};  // RPDC,  Zero
        if (rhRDREG36 & rhDPR)
          unibus.devDATAO = {20'b0, massbus.mbREG36[rhUNIT]};  // RPCC,  Zero
        if (rhRDREG40 & rhDPR)
          unibus.devDATAO = {20'b0, massbus.mbREG40[rhUNIT]};  // RPER2, Zero
        if (rhRDREG42 & rhDPR)
          unibus.devDATAO = {20'b0, massbus.mbREG42[rhUNIT]};  // RPER3, Zero
        if (rhRDREG44 & rhDPR)
          unibus.devDATAO = {20'b0, massbus.mbREG44[rhUNIT]};  // RPEC1, Zero
        if (rhRDREG46 & rhDPR)
          unibus.devDATAO = {20'b0, massbus.mbREG46[rhUNIT]};  // RPEC2, Zero
        if (vectREAD)
          unibus.devDATAO = {20'b0, rhVECT[20:35]};
     end

   //
   // Interrupt Request
   //

   assign unibus.devINTRO = rhIRQ ? rhINTR : 4'b0;

   //
   // Unibus Interface
   //

   assign unibus.devREQO  = massbus.devREQO;
   assign unibus.devACLO  = massbus.devACLO;
   assign unibus.devADDRO = massbus.setNPRO ? {wrFLAGS, rhBA} : {rdFLAGS, rhBA};

   //
   // Hookup Massbus Outputs
   //

   assign massbus.clk       = clk;
   assign massbus.rst       = rst;
   assign massbus.devRESET  = devRESET;
   assign massbus.devACKI   = unibus.devACKI;
   assign massbus.devDATAI  = unibus.devDATAI;
   assign massbus.mbADDR    = devADDR;
   assign massbus.mbREAD    = rhREAD;
   assign massbus.mbWRITE   = rhWRITE;
   assign massbus.rhCS1     = rhCS1;
   assign massbus.rhCS2     = rhCS2;
   assign massbus.rhWC      = rhWC;
   assign massbus.mbWRREG00 = rhWRREG00;
// assign massbus.mbWRREG02 = rhWRREG02;
// assign massbus.mbWRREG04 = rhWRREG04;
   assign massbus.mbWRREG06 = rhWRREG06;
// assign massbus.mbWRREG10 = rhWRREG10;
// assign massbus.mbWRREG12 = rhWRREG12;
   assign massbus.mbWRREG14 = rhWRREG14;
   assign massbus.mbWRREG16 = rhWRREG16;
   assign massbus.mbWRREG20 = rhWRREG20;
// assign massbus.mbWRREG20 = rhWRREG22;
   assign massbus.mbWRREG24 = rhWRREG24;
// assign massbus.mbWRREG26 = rhWRREG26;
// assign massbus.mbWRREG30 = rhWRREG30;
   assign massbus.mbWRREG32 = rhWRREG32;
   assign massbus.mbWRREG34 = rhWRREG34;
   assign massbus.mbWRREG36 = rhWRREG36;
   assign massbus.mbWRREG40 = rhWRREG40;
   assign massbus.mbWRREG42 = rhWRREG42;
   assign massbus.mbWRREG44 = rhWRREG44;
   assign massbus.mbWRREG46 = rhWRREG46;

   //
   // Debug output
   //

`ifndef SYNTHESIS

   initial
     begin
        file = $fopen("rhstatus.txt", "w");
        $fwrite(file, "[%11.3f] RH11: Debug Mode.\n", $time/1.0e3);
        $fflush(file);
     end

   always @(posedge clk)
     begin
        if (rhSETNEM)
          begin
             $display("[%11.3f] RH11: Unacknowledged bus cycle.  Addr Bus = %012o", $time/1.0e3, unibus.devADDRO);
             $stop;
          end
        if (unibus.devACKI)
          begin
             if (massbus.setNPRO)
               $fwrite(file, "[%11.3f] RH11: Wrote %012o to address %012o.  rhWC = 0x%04x\n", $time/1.0e3, unibus.devDATAO, unibus.devADDRO, rhWC);
             else
               $fwrite(file, "[%11.3f] RH11: Read %012o from address %012o.  rhWC = 0x%04x\n", $time/1.0e3, unibus.devDATAI, unibus.devADDRO, rhWC);
             $fflush(file);
          end
     end

`endif

endmodule
