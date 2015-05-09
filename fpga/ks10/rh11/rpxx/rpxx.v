////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RPxx Style Massbus Disk Drive
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
//   rpxx.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2015 Rob Doyle
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

`include "rpxx.vh"
`include "rpda.vh"
`include "rpcc.vh"
`include "rpdc.vh"
`include "rpds.vh"
`include "rpof.vh"
`include "rpcs1.vh"
`include "rper1.vh"
`include "../rh11.vh"
`include "../sd/sd.vh"
`include "../../ubabus.vh"

module RPXX (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire         clr,                  // Clear
      input  wire         rhINCSECT,            // Increment Sector
      input  wire         rhATACLR,             // Clear RPDS[ATA]
      input  wire [ 0:35] devADDRI,             // Device Address In
      input  wire [ 0:35] devDATAI,             // Device Data In
      input  wire         rpSELECT,             // Unit Select
      input  wire         rpCD,                 // Card Detect from SD Card
      input  wire         rpPAT,                // Parity Test
      input  wire         rpWP,                 // Write Protect from SD Card
      output wire [15: 0] rpCS1,                // CS1 Register
      output wire [15: 0] rpDA,                 // DA  Register
      output wire [15: 0] rpDS,                 // DS  Register
      output wire [15: 0] rpER1,                // ER1 Register
      output wire [15: 0] rpLA,                 // LA  Register
      output wire [15: 0] rpMR,                 // MR  Register
      output wire [15: 0] rpDT,                 // DT  Register
      output wire [15: 0] rpOF,                 // OF  Register
      output wire [15: 0] rpDC,                 // DC  Register
      output wire [15: 0] rpCC,                 // CC  Register
      output wire [15: 0] rpER2,                // ER2 Register
      output wire [15: 0] rpER3,                // ER3 Register
      output wire [ 1: 0] rpSDOP,               // SD Operation
      output wire         rpSDREQ,              // SD Request
      input  wire         rpSDACK,              // SD Complete Acknowledge
      output wire [31: 0] rpSDLSA               // SD Linear Sector Address
   );

   //
   // RH Parameters
   //

   parameter [14:17] rhDEV    = `rh1DEV;        // Device 3
   parameter [18:35] rhADDR   = `rh1ADDR;       // RH11 #1 Base Address
   parameter [15: 0] drvTYPE  = `rpRP06;        // Drive type
   parameter         simTIME  = 1'b0;           // Simulate timing

   //
   // RH Register Addresses
   //

   localparam [18:35] cs1ADDR = rhADDR + `cs1OFFSET;
   localparam [18:35] wcADDR  = rhADDR + `wcOFFSET;
   localparam [18:35] baADDR  = rhADDR + `baOFFSET;
   localparam [18:35] daADDR  = rhADDR + `daOFFSET;

   localparam [18:35] cs2ADDR = rhADDR + `cs2OFFSET;
   localparam [18:35] dsADDR  = rhADDR + `dsOFFSET;
   localparam [18:35] er1ADDR = rhADDR + `er1OFFSET;
   localparam [18:35] asADDR  = rhADDR + `asOFFSET;

   localparam [18:35] laADDR  = rhADDR + `laOFFSET;
   localparam [18:35] dbADDR  = rhADDR + `dbOFFSET;
   localparam [18:35] mrADDR  = rhADDR + `mrOFFSET;
   localparam [18:35] dtADDR  = rhADDR + `dtOFFSET;

   localparam [18:35] snADDR  = rhADDR + `snOFFSET;
   localparam [18:35] ofADDR  = rhADDR + `ofOFFSET;
   localparam [18:35] dcADDR  = rhADDR + `dcOFFSET;
   localparam [18:35] ccADDR  = rhADDR + `ccOFFSET;

   localparam [18:35] er2ADDR = rhADDR + `er2OFFSET;
   localparam [18:35] er3ADDR = rhADDR + `er3OFFSET;
   localparam [18:35] ec1ADDR = rhADDR + `ec1OFFSET;
   localparam [18:35] ec2ADDR = rhADDR + `ec2OFFSET;

   localparam [18:35] undADDR = rhADDR + `undOFFSET;

   //
   // Lookup Drive Geometries
   //

   localparam [5:0] rpSECNUM = `getLAST_SECTOR(drvTYPE);        // Sectors
   localparam [5:0] rpTRKNUM = `getLAST_TRACK(drvTYPE);         // Tracks (or surfaces or heads)
   localparam [9:0] rpCYLNUM = `getLAST_CYL (drvTYPE);          // Cylinder

   //
   // Device Address and Flags
   //

   wire         devREAD  = `devREAD(devADDRI);                  // Read Cycle
   wire         devWRITE = `devWRITE(devADDRI);                 // Write Cycle
   wire         devIO    = `devIO(devADDRI);                    // IO Cycle
   wire         devPHYS  = `devPHYS(devADDRI);                  // Physical reference
   wire [14:17] devDEV   = `devDEV(devADDRI);                   // Device Number
   wire [18:34] devADDR  = `devADDR(devADDRI);                  // Device Address

   //
   // Register Decode
   //
   // Trace
   //   M7774/RG5/E75
   //

   wire rpcs1WRITE = devWRITE & devIO & devPHYS & (devDEV == rhDEV) & (devADDR == cs1ADDR[18:34]) & rpSELECT;
   wire rper1WRITE = devWRITE & devIO & devPHYS & (devDEV == rhDEV) & (devADDR == er1ADDR[18:34]) & rpSELECT;
   wire rpmrWRITE  = devWRITE & devIO & devPHYS & (devDEV == rhDEV) & (devADDR ==  mrADDR[18:34]) & rpSELECT;
   wire rpofWRITE  = devWRITE & devIO & devPHYS & (devDEV == rhDEV) & (devADDR ==  ofADDR[18:34]) & rpSELECT;
   wire rpdaWRITE  = devWRITE & devIO & devPHYS & (devDEV == rhDEV) & (devADDR ==  daADDR[18:34]) & rpSELECT;
   wire rpdcWRITE  = devWRITE & devIO & devPHYS & (devDEV == rhDEV) & (devADDR ==  dcADDR[18:34]) & rpSELECT;
   wire rper2WRITE = devWRITE & devIO & devPHYS & (devDEV == rhDEV) & (devADDR == er2ADDR[18:34]) & rpSELECT;
   wire rper3WRITE = devWRITE & devIO & devPHYS & (devDEV == rhDEV) & (devADDR == er3ADDR[18:34]) & rpSELECT;

   //
   // Big-endian to little-endian data bus swap
   //

   wire [35:0] rpDATAI = devDATAI[0:35];

   //
   // RPxx Control/Status Register (RPCS1)
   //

   wire rpGO = `rpCS1_GO(rpCS1);

   //
   // RPxx Disk Status Register (RPDS)
   //

   wire rpERR = `rpDS_ERR(rpDS);

   //
   // RPxx Disk Address Register (RPDA)
   //

   wire [5:0] rpSA = `rpDA_SA(rpDA);
   wire [5:0] rpTA = `rpDA_TA(rpDA);

   //
   // RPxx Offset (RPOF) Register
   //

   wire rpFMT22 = `rpOF_FMT22(rpOF);

   //
   // RPxx Desired Cylinder (RPDC) Register
   //

   wire [9:0] rpDCA = `rpDC_DCA(rpDC);

   //
   // RPxx Current Cylinder (RPCC) Register
   //

   wire [9:0] rpCCA = `rpCC_CCA(rpCC);

   //
   // Commands
   //
   // Trace
   //  M7774/RG4/E60
   //

   wire rpCMDGO  = rpcs1WRITE & `rpCS1_GO(rpDATAI) & !rpPAT;            // Go command
   wire rpDRVCLR = rpCMDGO & (`rpCS1_FUN(rpDATAI) == `funCLEAR);        // Drive clear
   wire rpPRESET = rpCMDGO & (`rpCS1_FUN(rpDATAI) == `funPRESET);       // Read-in preset
   wire rpCENTER = rpCMDGO & (`rpCS1_FUN(rpDATAI) == `funCENTER);       // Return to center
   wire rpPAKACK = rpCMDGO & (`rpCS1_FUN(rpDATAI) == `funPAKACK);       // Pack acknowledge

   //
   //
   //

   wire rpDRY;                                                          // Drive ready
   wire rpPIP;                                                          // Positioning in progress
   wire rpSETATA;                                                       // Set ATA
   wire rpADRSTRT;                                                      // Start sector address calculation
   wire rpADRBUSY;                                                      // Busy calculation sector address
   wire rpccWRITE;
   wire rpSETWLE = rpCMDGO & rpWP;                                      // Write lock error
   wire rpSETIAE = ((rpCMDGO & (rpSA  > rpSECNUM)) |                    // Invalid address error
                    (rpCMDGO & (rpTA  > rpTRKNUM)) |
                    (rpCMDGO & (rpDCA > rpCYLNUM)));
   wire rpSETAOE = (rpINCSECT & (rpSA == rpSECNUM) &                    // Address overflow error
                    (rpTA == rpTRKNUM) & (rpDCA == rpCYLNUM));



   wire rpINCCYL = rpINCSECT & ((rpSA == rpSECNUM) & (rpTA == rpTRKNUM));                               // Increment cylinder
   wire rpSETLST = /*FIXME*/   ((rpSA == rpSECNUM) & (rpTA == rpTRKNUM) & (rpDCA == rpCYLNUM));         // Last sector transferred
   wire rpSETRMR = !rpDRY & (rpcs1WRITE | rper1WRITE | rpofWRITE  |     // Register modification refused
                             rpdaWRITE  | rpdcWRITE  | rper2WRITE |
                             rper3WRITE);

   wire rpSETPAR =  rpPAT & (rpcs1WRITE | rper1WRITE | rpmrWRITE |      // Parity error
                             rpofWRITE  | rpdaWRITE  | rpdcWRITE |
                             rper2WRITE | rper3WRITE);



   wire rpINCSECT = rhINCSECT & rpSELECT;                               // Increment RPxx sector
   wire rpSETILF  = ((rpCMDGO & (`rpCS1_FUN(rpDATAI) == 5'o12)) |       // Illegal functions
                     (rpCMDGO & (`rpCS1_FUN(rpDATAI) == 5'o13)) |
                     (rpCMDGO & (`rpCS1_FUN(rpDATAI) == 5'o15)) |
                     (rpCMDGO & (`rpCS1_FUN(rpDATAI) == 5'o16)) |
                     (rpCMDGO & (`rpCS1_FUN(rpDATAI) == 5'o17)) |
                     (rpCMDGO & (`rpCS1_FUN(rpDATAI) == 5'o20)) |
                     (rpCMDGO & (`rpCS1_FUN(rpDATAI) == 5'o21)) |
                     (rpCMDGO & (`rpCS1_FUN(rpDATAI) == 5'o22)) |
                     (rpCMDGO & (`rpCS1_FUN(rpDATAI) == 5'o23)) |
                     (rpCMDGO & (`rpCS1_FUN(rpDATAI) == 5'o26)) |
                     (rpCMDGO & (`rpCS1_FUN(rpDATAI) == 5'o27)) |
                     (rpCMDGO & (`rpCS1_FUN(rpDATAI) == 5'o32)) |
                     (rpCMDGO & (`rpCS1_FUN(rpDATAI) == 5'o33)) |
                     (rpCMDGO & (`rpCS1_FUN(rpDATAI) == 5'o36)) |
                     (rpCMDGO & (`rpCS1_FUN(rpDATAI) == 5'o37)));

   wire [31:0] rpSDADDR;

   //
   // RPxx Control/Status Register (RPCS1)
   //

   RPCS1 CS1 (
      .clk         (clk),
      .rst         (rst),
      .clr         (clr),
      .rpDATAI     (rpDATAI),
      .rpcs1WRITE  (rpcs1WRITE),
      .rpDRY       (rpDRY),
      .rpCS1       (rpCS1)
   );

   //
   // RPxx Disk Address Register (RPDA)
   //

   RPDA DA (
      .clk         (clk),
      .rst         (rst),
      .clr         (clr),
      .rpDATAI     (rpDATAI),
      .rpdaWRITE   (rpdaWRITE),
      .rpPRESET    (rpPRESET),
      .rpSECNUM    (rpSECNUM),
      .rpTRKNUM    (rpTRKNUM),
      .rpINCSECT   (rpINCSECT),
      .rpDRY       (rpDRY),
      .rpDA        (rpDA)
   );

   //
   // RPxx Disk Status Register (RPDS)
   //

   RPDS DS (
      .clk         (clk),
      .rst         (rst),
      .clr         (clr),
      .rhATACLR    (rhATACLR),
      .rpSETLST    (rpSETLST),
      .rpSETATA    (rpSETATA),
      .rpCD        (rpCD),
      .rpWP        (rpWP),
      .rpPIP       (rpPIP),
      .rpDRY       (rpDRY),
      .rpDRVCLR    (rpDRVCLR),
      .rpPRESET    (rpPRESET),
      .rpPAKACK    (rpPAKACK),
      .rpdaWRITE   (rpdaWRITE),
      .rpER1       (rpER1),
      .rpER2       (rpER2),
      .rpER3       (rpER3),
      .rpDS        (rpDS)
   );

   //
   // RPxx Error #1 (RPER1) Register
   //

   RPER1 ER1 (
      .clk         (clk),
      .rst         (rst),
      .clr         (clr),
      .rpDRVCLR    (rpDRVCLR),
      .rpSETWLE    (rpSETWLE),
      .rpSETIAE    (rpSETIAE),
      .rpSETAOE    (rpSETAOE),
      .rpSETPAR    (rpSETPAR),
      .rpSETRMR    (rpSETRMR),
      .rpSETILF    (rpSETILF),
      .rpDATAI     (rpDATAI),
      .rper1WRITE  (rper1WRITE),
      .rpDRY       (rpDRY),
      .rpER1       (rpER1)
   );

   //
   // RPxx Look Ahead (RPLA) Register
   //

   RPLA LA (
      .clk         (clk),
      .rst         (rst),
      .clr         (clr),
      .rpFMT22     (rpFMT22),
      .rpMR        (rpMR),
      .rpSA        (rpSA),
      .rpLA        (rpLA)
   );

   //
   // RPxx Offset (RPOF) Register
   //

   RPOF OF (
      .clk         (clk),
      .rst         (rst),
      .clr         (clr),
      .rpCENTER    (rpCENTER),
      .rpPRESET    (rpPRESET),
      .rpDATAI     (rpDATAI),
      .rpofWRITE   (rpofWRITE),
      .rpDRY       (rpDRY),
      .rpOF        (rpOF)
   );

   //
   // RPxx Desired Cylinder (RPDC) Register
   //

   RPDC DC (
      .clk         (clk),
      .rst         (rst),
      .clr         (rpPRESET),
      .rpDATAI     (rpDATAI),
      .rpdcWRITE   (rpdcWRITE),
      .rpINCCYL    (rpINCCYL),
      .rpDRY       (rpDRY),
      .rpDC        (rpDC)
   );

   //
   // RPxx Current Cylinder (RPCC) Register
   //

   RPCC CC (
      .clk         (clk),
      .rst         (rst),
      .clr         (rpPRESET),
      .rpDC        (rpDC),
      .rpccWRITE   (rpccWRITE),
      .rpCC        (rpCC)
   );

   //
   // RPxx Maintenaince (RPMR) Register
   //

   RPMR MR (
      .clk         (clk),
      .rst         (rst),
      .clr         (clr),
      .rpDRVCLR    (rpDRVCLR),
      .rpDATAI     (rpDATAI),
      .rpmrWRITE   (rpmrWRITE),
      .rpGO        (rpGO),
      .rpMR        (rpMR)
   );

   //
   // RPxx Error Status #2 (RPER2) Register
   //

   RPER2 ER2 (
      .clk         (clk),
      .rst         (rst),
      .clr         (clr),
      .rpDRVCLR    (rpDRVCLR),
      .rpDATAI     (rpDATAI),
      .rper2WRITE  (rper2WRITE),
      .rpDRY       (rpDRY),
      .rpER2       (rpER2)
   );

   //
   // RPxx Error Status #3 (RPER3) Register
   //

   RPER3 ER3 (
      .clk         (clk),
      .rst         (rst),
      .clr         (clr),
      .rpDRVCLR    (rpDRVCLR),
      .rpDATAI     (rpDATAI),
      .rper3WRITE  (rper3WRITE),
      .rpDRY       (rpDRY),
      .rpER3       (rpER3)
   );

   //
   // Linear sector address calculation
   //

   RPADDR ADDR (
      .clk         (clk),
      .rst         (rst),
      .rpTRKNUM    (rpTRKNUM),
      .rpSECNUM    (rpSECNUM),
      .rpDCA       (rpDCA),
      .rpTA        (rpTA),
      .rpSA        (rpSA),
      .rpSDLSA     (rpSDLSA),
      .rpADRSTRT   (rpADRSTRT),
      .rpADRBUSY   (rpADRBUSY)
   );

   //
   // Controller state machine
   //

   RPCTRL #(
      .simTIME     (simTIME)
   )
   CTRL (
      .clk         (clk),
      .rst         (rst),
      .clr         (clr),
      .rpCMDGO     (rpCMDGO),
      .rpCMDFUN    (`rpCS1_FUN(rpDATAI)),
      .rpADRSTRT   (rpADRSTRT),
      .rpADRBUSY   (rpADRBUSY),
      .rpPIP       (rpPIP),
      .rpDRY       (rpDRY),
      .rpSETWLE    (rpSETWLE),
      .rpSETATA    (rpSETATA),
      .rpSETIAE    (rpSETIAE),
      .rpccWRITE   (rpccWRITE),
      .rpSDOP      (rpSDOP),
      .rpSDREQ     (rpSDREQ),
      .rpSDACK     (rpSDACK),
      .rpDCA       (rpDCA),
      .rpCCA       (rpCCA)
   );

   //
   // Fixups
   //

   assign rpDT = drvTYPE;

endmodule
