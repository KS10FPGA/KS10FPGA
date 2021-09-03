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
`include "rhcs1.vh"
`include "rhcs2.vh"
`include "rpxx/rpcs1.vh"
`include "rpxx/rpof.vh"
`include "rpxx/rpds.vh"
`include "rpxx/rpxx.vh"
`include "sd/sd.vh"
`include "../uba/ubabus.vh"

module RH11 (
      unibus.device       unibus,                       // Unibus connection
      // SD Interfaces
      input  wire         SD_MISO,                      // SD Data In
      output wire         SD_MOSI,                      // SD Data Out
      output wire         SD_SCLK,                      // SD Clock
      output wire         SD_SS_N,                      // SD Slave Select
      // RPXX Interfaces
      input  wire [ 7: 0] rpMOL,                        // RPxx Media On-line
      input  wire [ 7: 0] rpWRL,                        // RPxx Write Lock
      input  wire [ 7: 0] rpDPR,                        // RPxx Drive Present
      output wire [ 7: 0] rpLEDS,                       // RPxx Status LEDs
      output wire [ 0:63] rhDEBUG                       // RH11 Debug Output
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

   localparam [18:35] cs1ADDR = rhADDR + `cs1OFFSET;     // RH/Massbus Addr 00
   localparam [18:35] wcADDR  = rhADDR + `wcOFFSET;      // RH Register
   localparam [18:35] baADDR  = rhADDR + `baOFFSET;      // RH Register
   localparam [18:35] daADDR  = rhADDR + `daOFFSET;      // Massbus Addr 05

   localparam [18:35] cs2ADDR = rhADDR + `cs2OFFSET;     // RH Register
   localparam [18:35] dsADDR  = rhADDR + `dsOFFSET;      // Massbus Addr 01
   localparam [18:35] er1ADDR = rhADDR + `er1OFFSET;     // Massbus Addr 02
   localparam [18:35] asADDR  = rhADDR + `asOFFSET;      // Massbus Addr 04 (Pseudo Reg)

   localparam [18:35] laADDR  = rhADDR + `laOFFSET;      // Massbus Addr 07
   localparam [18:35] dbADDR  = rhADDR + `dbOFFSET;      // RH Register
   localparam [18:35] mrADDR  = rhADDR + `mrOFFSET;      // Massbus Addr 03
   localparam [18:35] dtADDR  = rhADDR + `dtOFFSET;      // Massbus Addr 06

   localparam [18:35] snADDR  = rhADDR + `snOFFSET;      // Massbus Addr 10
   localparam [18:35] ofADDR  = rhADDR + `ofOFFSET;      // Massbus Addr 11
   localparam [18:35] dcADDR  = rhADDR + `dcOFFSET;      // Massbus Addr 12
   localparam [18:35] ccADDR  = rhADDR + `ccOFFSET;      // Massbus Addr 13

   localparam [18:35] er2ADDR = rhADDR + `er2OFFSET;     // Massbus Addr 14
   localparam [18:35] er3ADDR = rhADDR + `er3OFFSET;     // Massbus Addr 15
   localparam [18:35] ec1ADDR = rhADDR + `ec1OFFSET;     // Massbus Addr 16
   localparam [18:35] ec2ADDR = rhADDR + `ec2OFFSET;     // Massbus Addr 17

   //
   // Address Flags
   //

   localparam [0:17] rdFLAGS = 18'b000_100_000_000_000_000;
   localparam [0:17] wrFLAGS = 18'b000_001_000_000_000_000;

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

   wire rhcs1READ  = rhREAD  & (devADDR == cs1ADDR);
   wire rhcs1WRITE = rhWRITE & (devADDR == cs1ADDR);
   wire rhwcREAD   = rhREAD  & (devADDR ==  wcADDR);
   wire rhwcWRITE  = rhWRITE & (devADDR ==  wcADDR);
   wire rhbaREAD   = rhREAD  & (devADDR ==  baADDR);
   wire rhbaWRITE  = rhWRITE & (devADDR ==  baADDR);
   wire rpdaREAD   = rhREAD  & (devADDR ==  daADDR);
   wire rpdaWRITE  = rhWRITE & (devADDR ==  daADDR);

   wire rhcs2READ  = rhREAD  & (devADDR == cs2ADDR);
   wire rhcs2WRITE = rhWRITE & (devADDR == cs2ADDR);
   wire rpdsREAD   = rhREAD  & (devADDR ==  dsADDR);
   wire rpdsWRITE  = rhWRITE & (devADDR ==  dsADDR);
   wire rper1READ  = rhREAD  & (devADDR == er1ADDR);
   wire rper1WRITE = rhWRITE & (devADDR == er1ADDR);
   wire rhasREAD   = rhREAD  & (devADDR ==  asADDR);
   wire rhasWRITE  = rhWRITE & (devADDR ==  asADDR);

   wire rplaREAD   = rhREAD  & (devADDR ==  laADDR);
   wire rplaWRITE  = rhWRITE & (devADDR ==  laADDR);
   wire rhdbREAD   = rhREAD  & (devADDR ==  dbADDR);
   wire rhdbWRITE  = rhWRITE & (devADDR ==  dbADDR);
   wire rpmrREAD   = rhREAD  & (devADDR ==  mrADDR);
   wire rpmrWRITE  = rhWRITE & (devADDR ==  mrADDR);
   wire rpdtREAD   = rhREAD  & (devADDR ==  dtADDR);
   wire rpdtWRITE  = rhWRITE & (devADDR ==  dtADDR);

   wire rpsnREAD   = rhREAD  & (devADDR ==  snADDR);
   wire rpsnWRITE  = rhWRITE & (devADDR ==  snADDR);
   wire rpofREAD   = rhREAD  & (devADDR ==  ofADDR);
   wire rpofWRITE  = rhWRITE & (devADDR ==  ofADDR);
   wire rpdcREAD   = rhREAD  & (devADDR ==  dcADDR);
   wire rpdcWRITE  = rhWRITE & (devADDR ==  dcADDR);
   wire rpccREAD   = rhREAD  & (devADDR ==  ccADDR);
   wire rpccWRITE  = rhWRITE & (devADDR ==  ccADDR);

   wire rper2READ  = rhREAD  & (devADDR == er2ADDR);
   wire rper2WRITE = rhWRITE & (devADDR == er2ADDR);
   wire rper3READ  = rhREAD  & (devADDR == er3ADDR);
   wire rper3WRITE = rhWRITE & (devADDR == er3ADDR);
   wire rpec1READ  = rhREAD  & (devADDR == ec1ADDR);
   wire rpec1WRITE = rhWRITE & (devADDR == ec1ADDR);
   wire rpec2READ  = rhREAD  & (devADDR == ec2ADDR);
   wire rpec2WRITE = rhWRITE & (devADDR == ec2ADDR);

   //
   // Big-endian to little-endian data bus swap
   //

   wire [35:0] rhDATAI = unibus.devDATAI[0:35];

   //
   // Interrupt Acknowledge
   //

   wire rhIACK = vectREAD;

   //
   // RH11 Registers
   //

   wire [15:0] rhCS1;                   // CS1 Reguster
   wire [15:0] rhWC;                    // WC  Register
   wire [17:0] rhBA;                    // BA  Register
   wire [15:0] rhCS2;                   // CS2 Register
   wire [15:0] rhDB;                    // DB  Register

   //
   // RPXX Registers
   //

   wire [15:0] rpCS1[7:0];              // CS1 Register
   wire [15:0] rpDA [7:0];              // DA  Reguster
   wire [15:0] rpDS [7:0];              // DS  Register
   wire [15:0] rpER1[7:0];              // ER1 Register
   wire [15:0] rpLA [7:0];              // LA  Register
   wire [15:0] rpMR [7:0];              // MR  Register
   wire [15:0] rpDT [7:0];              // DT  Register
   wire [15:0] rpSN [7:0];              // SN  Register
   wire [15:0] rpOF [7:0];              // OF  Register
   wire [15:0] rpDC [7:0];              // DC  Register
   wire [15:0] rpCC [7:0];              // CC  Register
   wire [15:0] rpER2[7:0];              // ER2 Register
   wire [15:0] rpER3[7:0];              // ER3 Register
   wire [15:0] rpEC1 = 16'b0;           // EC1 Register (always 0)
   wire [15:0] rpEC2 = 16'b0;           // EC2 Register (always 0)

   //
   // RH11 Control/Status #1 (CS1) Register
   //

   wire rhSC  = `rhCS1_SC (rhCS1);
   wire rhRDY = `rhCS1_RDY(rhCS1);
   wire rhIE  = `rhCS1_IE (rhCS1);

   //
   // RH11 Control/Status #2 (CS2) Register
   //

   wire rhDLT = `rhCS2_DLT(rhCS2);
   wire rhWCE = `rhCS2_WCE(rhCS2);
   wire rhUPE = `rhCS2_UPE(rhCS2);
   wire rhNED = `rhCS2_NED(rhCS2);
   wire rhNEM = `rhCS2_NEM(rhCS2);
   wire rhPGE = `rhCS2_PGE(rhCS2);
   wire rhMXF = `rhCS2_MXF(rhCS2);
   wire rhDPE = `rhCS2_DPE(rhCS2);
   wire rhCLR = `rhCS2_CLR(rhCS2);
   wire rhPAT = `rhCS2_PAT(rhCS2);
   wire rhBAI = `rhCS2_BAI(rhCS2);
   wire [2:0] rhUNIT = `rhCS2_UNIT(rhCS2);

   //
   // RH11 Attention Summary (RHAS) Pseudo Register
   //

   wire [15:0] rhAS = {8'b0,
                       `rpDS_ATA(rpDS[7]), `rpDS_ATA(rpDS[6]),
                       `rpDS_ATA(rpDS[5]), `rpDS_ATA(rpDS[4]),
                       `rpDS_ATA(rpDS[3]), `rpDS_ATA(rpDS[2]),
                       `rpDS_ATA(rpDS[1]), `rpDS_ATA(rpDS[0])};

   //
   // ATA (from all disks)
   //

   wire rpATA = (`rpDS_ATA(rpDS[7]) | `rpDS_ATA(rpDS[6]) |
                 `rpDS_ATA(rpDS[5]) | `rpDS_ATA(rpDS[4]) |
                 `rpDS_ATA(rpDS[3]) | `rpDS_ATA(rpDS[2]) |
                 `rpDS_ATA(rpDS[1]) | `rpDS_ATA(rpDS[0]));

   //
   // RPXX Status
   //

   wire       rpERR = `rpDS_ERR(rpDS[rhUNIT]);
   wire       rpDVA = `rpCS1_DVA(rpCS1[rhUNIT]);
   wire [5:1] rpFUN = `rpCS1_FUN(rpCS1[rhUNIT]);
   wire       rpGO  = `rpCS1_GO(rpCS1[rhUNIT]);

   //
   // RPXX Serial Number Registes
   //

   assign rpSN[0] = `rpSN0;
   assign rpSN[1] = `rpSN1;
   assign rpSN[2] = `rpSN2;
   assign rpSN[3] = `rpSN3;
   assign rpSN[4] = `rpSN4;
   assign rpSN[5] = `rpSN5;
   assign rpSN[6] = `rpSN6;
   assign rpSN[7] = `rpSN7;

   //
   // RH Signals
   //

   wire rhSETNEM;                       // Set non-existent memory
   wire rhSETDLT;                       // Set device late
   wire rhBUFIR;                        // Buffer input ready
   wire rhBUFOR;                        // Buffer output ready
   wire rhIRQ;                          // Interrupt request

   //
   // SD Signals
   //

   wire [ 2: 0] sdSCAN;                 // Current RP accessing SD
   wire         sdINCWC;                // Increment word count
   wire         sdINCBA;                // Increment bus address
   wire         sdINCSECT;              // Increment Sector
   wire         sdSETWCE;               // Set write check error
   wire         sdREADOP;               // Read or write check operation
   wire [ 0:35] sdDATAO;                // SD DMA data out

   //
   // RP Signals
   //

   wire [ 2:0] rpSDOP [7:0];            // SD operation
   wire [20:0] rpSDLSA[7:0];            // SD Linear sector address
   wire [ 7:0] rpSDREQ;                 // RP requests the SD
   wire [ 7:0] rpSDACK;                 // SD acknowledges the RP

   //
   // Transfer Error Clear
   //

   wire rhCLRTRE = rhcs1WRITE & devHIBYTE & `rhCS1_TRE(rhDATAI);

   //
   // Go Command
   //

   wire rhCMDGO = rhcs1WRITE & `rpCS1_GO(rhDATAI);

   //
   // Drive is present
   //

   wire rpPRES = rpDPR[rhUNIT];

   //
   // Set Non-existant Device (NED)
   //

   wire rhSETNED = (rpdaWRITE  & !rpPRES |
                    rpdaREAD   & !rpPRES |
                    rpdsWRITE  & !rpPRES |
                    rpdsREAD   & !rpPRES |
                    rper1WRITE & !rpPRES |
                    rper1READ  & !rpPRES |
                    rhasWRITE  & !rpPRES |
                    rhasREAD   & !rpPRES |
                    rplaWRITE  & !rpPRES |
                    rplaREAD   & !rpPRES |
                    rpmrWRITE  & !rpPRES |
                    rpmrREAD   & !rpPRES |
                    rpdtWRITE  & !rpPRES |
                    rpdtREAD   & !rpPRES |
                    rpsnWRITE  & !rpPRES |
                    rpsnREAD   & !rpPRES |
                    rpofWRITE  & !rpPRES |
                    rpofREAD   & !rpPRES |
                    rpdcWRITE  & !rpPRES |
                    rpdcREAD   & !rpPRES |
                    rpccWRITE  & !rpPRES |
                    rpccREAD   & !rpPRES |
                    rper2WRITE & !rpPRES |
                    rper2READ  & !rpPRES |
                    rper3WRITE & !rpPRES |
                    rper3READ  & !rpPRES |
                    rpec1WRITE & !rpPRES |
                    rpec1READ  & !rpPRES |
                    rpec2WRITE & !rpPRES |
                    rpec2READ  & !rpPRES);

   //
   // Command Clear
   //
   // The DEC KS10 logic doesn't fully decode the Read, Write, and Wrchk
   // commands and therefore includes some illegal commands.  This 'feature' is
   // replicated here.
   //
   // Trace
   //  M7296/CSRA/E6
   //  M7296/CSRA/E14
   //  M7296/CSRA/E16
   //  M7296/CSRA/E17
   //

   wire rhCLRGO = ((rhRDY & rhcs1WRITE & (`rhCS1_FUN(rhDATAI) == `funWRCHK ) & `rpCS1_GO(rhDATAI)) |
                   (rhRDY & rhcs1WRITE & (`rhCS1_FUN(rhDATAI) == `funWRCHKH) & `rpCS1_GO(rhDATAI)) |
                   (rhRDY & rhcs1WRITE & (`rhCS1_FUN(rhDATAI) == 5'o26     ) & `rpCS1_GO(rhDATAI)) |  // Illegal command
                   (rhRDY & rhcs1WRITE & (`rhCS1_FUN(rhDATAI) == 5'o27     ) & `rpCS1_GO(rhDATAI)) |  // Illegal command
                   (rhRDY & rhcs1WRITE & (`rhCS1_FUN(rhDATAI) == `funWRITE ) & `rpCS1_GO(rhDATAI)) |
                   (rhRDY & rhcs1WRITE & (`rhCS1_FUN(rhDATAI) == `funWRITEH) & `rpCS1_GO(rhDATAI)) |
                   (rhRDY & rhcs1WRITE & (`rhCS1_FUN(rhDATAI) == 5'o32     ) & `rpCS1_GO(rhDATAI)) |  // Illegal command
                   (rhRDY & rhcs1WRITE & (`rhCS1_FUN(rhDATAI) == 5'o33     ) & `rpCS1_GO(rhDATAI)) |  // Illegal command
                   (rhRDY & rhcs1WRITE & (`rhCS1_FUN(rhDATAI) == `funREAD  ) & `rpCS1_GO(rhDATAI)) |
                   (rhRDY & rhcs1WRITE & (`rhCS1_FUN(rhDATAI) == `funREADH ) & `rpCS1_GO(rhDATAI)) |
                   (rhRDY & rhcs1WRITE & (`rhCS1_FUN(rhDATAI) == 5'o36     ) & `rpCS1_GO(rhDATAI)) |  // Illegal command
                   (rhRDY & rhcs1WRITE & (`rhCS1_FUN(rhDATAI) == 5'o37     ) & `rpCS1_GO(rhDATAI)));  // Illegal command

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
      .rhcs1WRITE (rhcs1WRITE),
      .rhCLRGO    (rhCLRGO),
      .rhCLRTRE   (rhCLRTRE),
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
      .rpATA      (rpATA),
      .rpERR      (rpERR),
      .rpDVA      (rpDVA),
      .rpFUN      (rpFUN),
      .rpGO       (rpGO),
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
      .rhwcWRITE  (rhwcWRITE),
      .rhCLR      (rhCLR),
      .rhINCWC    (sdINCWC),
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
      .rhcs1WRITE (rhcs1WRITE),
      .rhbaWRITE  (rhbaWRITE),
      .rhCLR      (rhCLR),
      .rhRDY      (rhRDY),
      .rhBAI      (rhBAI),
      .rhINCBA    (sdINCBA),
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
      .rhcs2WRITE (rhcs2WRITE),
      .rhCMDGO    (rhCMDGO),
      .rhCLRGO    (rhCLRGO),
      .rhCLRTRE   (rhCLRTRE),
      .rhCLR      (rhCLR),
      .rhRDY      (rhRDY),
      .rhSETDLT   (rhSETDLT),
      .rhSETNED   (rhSETNED),
      .rhSETNEM   (rhSETNEM),
      .rhSETWCE   (sdSETWCE),
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
      .rhdbREAD   (rhdbREAD),
      .rhdbWRITE  (rhdbWRITE),
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
      .rhcs1WRITE (rhcs1WRITE),
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
   // An array 8 RPxx disk drives
   //

   genvar i;
   generate
      for (i = 0; i < 8; i = i + 1)
        begin : disk_loop
           RPXX #(
              .drvTYPE  (`getTYPE(i))
           )
           uRPXX (
              .clk      (clk),
              .rst      (rst),
              .clr      (rhCLR | devRESET),
              .rhINCSECT(sdINCSECT),
              .devADDRI (unibus.devADDRI),
              .devDATAI (unibus.devDATAI),
              .rhUNIT   (rhUNIT),
              .rpNUM    (i[2:0]),
              .rpPAT    (rhPAT),
              .rpMOL    (rpMOL[i]),
              .rpWRL    (rpWRL[i]),
              .rpDPR    (rpDPR[i]),
              .rpCS1    (rpCS1[i]),
              .rpDA     (rpDA[i]),
              .rpDS     (rpDS[i]),
              .rpER1    (rpER1[i]),
              .rpLA     (rpLA[i]),
              .rpMR     (rpMR[i]),
              .rpDT     (rpDT[i]),
              .rpOF     (rpOF[i]),
              .rpDC     (rpDC[i]),
              .rpCC     (rpCC[i]),
              .rpER2    (rpER2[i]),
              .rpER3    (rpER3[i]),
              .rpSDOP   (rpSDOP[i]),
              .rpSDREQ  (rpSDREQ[i]),
              .rpSDACK  (rpSDACK[i]),
              .rpSDLSA  (rpSDLSA[i]),
              .rpACTIVE (rpLEDS[i])
           );
        end
   endgenerate

   //
   // SD Controller
   //

   SD uSD (
      .clk        (clk),
      .rst        (rst),
      .clr        (rhCLR | devRESET),
`ifndef SYNTHESIS
      .file       (file),
`endif
      .SD_MISO    (SD_MISO),
      .SD_MOSI    (SD_MOSI),
      .SD_SCLK    (SD_SCLK),
      .SD_SS_N    (SD_SS_N),
      // Device interface
      .devDATAI   (unibus.devDATAI),
      .devDATAO   (sdDATAO),
      .devREQO    (unibus.devREQO),
      .devACKI    (unibus.devACKI),
      // RH11 interfaces
      .rhWC       (rhWC),
      // RPXX interface
      .rpSDOP     (rpSDOP[sdSCAN]),
      .rpSDLSA    (rpSDLSA[sdSCAN]),
      .rpSDREQ    (rpSDREQ),
      .rpSDACK    (rpSDACK),
      // SD Output
      .sdINCWC    (sdINCWC),
      .sdINCBA    (sdINCBA),
      .sdINCSECT  (sdINCSECT),
      .sdSETWCE   (sdSETWCE),
      .sdREADOP   (sdREADOP),
      .sdSCAN     (sdSCAN),
      .sdDEBUG    (rhDEBUG)
   );

   //
   // Generate Bus ACK
   //

   assign unibus.devACKO = (rhcs1WRITE | rhcs1READ |
                            rhwcWRITE  | rhwcREAD  |
                            rhbaWRITE  | rhbaREAD  |
                            rpdaWRITE  | rpdaREAD  |
                            //
                            rhcs2WRITE | rhcs2READ |
                            rpdsWRITE  | rpdsREAD  |
                            rper1WRITE | rper1READ |
                            rhasWRITE  | rhasREAD  |
                            //
                            rplaWRITE  | rplaREAD  |
                            rhdbWRITE  | rhdbREAD  |
                            rpmrWRITE  | rpmrREAD  |
                            rpdtWRITE  | rpdtREAD  |
                            //
                            rpsnWRITE  | rpsnREAD  |
                            rpofWRITE  | rpofREAD  |
                            rpdcWRITE  | rpdcREAD  |
                            rpccWRITE  | rpccREAD  |
                            //
                            rper2WRITE | rper2READ |
                            rper3WRITE | rper3READ |
                            rpec1WRITE | rpec1READ |
                            rpec2WRITE | rpec2READ |
                            //
                            vectREAD);

   //
   // Bus Mux and little-endian to big-endian bus swap.
   //  Only output the RP register if the disk is present.
   //

   always @*
     begin
        unibus.devDATAO = 0;
        if (unibus.devREQO)
          unibus.devDATAO = sdDATAO;
        if (rhcs1READ)
          unibus.devDATAO = {20'b0, rhCS1};
        if (rhwcREAD)
          unibus.devDATAO = {20'b0, rhWC};
        if (rhbaREAD)
          unibus.devDATAO = {20'b0, rhBA[15:0]};
        if (rpdaREAD & rpPRES)
          unibus.devDATAO = {20'b0, rpDA[rhUNIT]};
        if (rhcs2READ)
          unibus.devDATAO = {20'b0, rhCS2};
        if (rpdsREAD & rpPRES)
          unibus.devDATAO = {20'b0, rpDS[rhUNIT]};
        if (rper1READ & rpPRES)
          unibus.devDATAO = {20'b0, rpER1[rhUNIT]};
        if (rhasREAD)
          unibus.devDATAO = {20'b0, rhAS};
        if (rplaREAD & rpPRES)
          unibus.devDATAO = {20'b0, rpLA[rhUNIT]};
        if (rhdbREAD)
          unibus.devDATAO = {20'b0, rhDB};
        if (rpmrREAD & rpPRES)
          unibus.devDATAO = {20'b0, rpMR[rhUNIT]};
        if (rpdtREAD & rpPRES)
          unibus.devDATAO = {20'b0, rpDT[rhUNIT]};
        if (rpsnREAD & rpPRES)
          unibus.devDATAO = {20'b0, rpSN[rhUNIT]};
        if (rpofREAD & rpPRES)
          unibus.devDATAO = {20'b0, rpOF[rhUNIT]};
        if (rpdcREAD & rpPRES)
          unibus.devDATAO = {20'b0, rpDC[rhUNIT]};
        if (rpccREAD & rpPRES)
          unibus.devDATAO = {20'b0, rpCC[rhUNIT]};
        if (rper2READ & rpPRES)
          unibus.devDATAO = {20'b0, rpER2[rhUNIT]};
        if (rper3READ & rpPRES)
          unibus.devDATAO = {20'b0, rpER3[rhUNIT]};
        if (rpec1READ & rpPRES)
          unibus.devDATAO = {20'b0, rpEC1};
        if (rpec2READ & rpPRES)
          unibus.devDATAO = {20'b0, rpEC2};
        if (vectREAD)
          unibus.devDATAO = {20'b0, rhVECT[20:35]};
     end

   //
   // Interrupt Request
   //

   assign unibus.devINTRO = rhIRQ ? rhINTR : 4'b0;

   //
   // Create DMA address
   //

   assign unibus.devADDRO = sdREADOP ? {wrFLAGS, rhBA} : {rdFLAGS, rhBA};

   //
   // Bus Interface
   //

   assign unibus.devACLO  = 0;                          // Power fail (not implemented)

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
             if (sdREADOP)
               $fwrite(file, "[%11.3f] RH11: Wrote %012o to address %012o.  rhWC = 0x%04x\n", $time/1.0e3, sdDATAO, unibus.devADDRO, rhWC);
             else
               $fwrite(file, "[%11.3f] RH11: Read %012o from address %012o.  rhWC = 0x%04x\n", $time/1.0e3, unibus.devDATAI, unibus.devADDRO, rhWC);
             $fflush(file);
          end
     end

`endif

endmodule
