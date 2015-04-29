///////////////////////////////////////////////////////////////////////////////
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
//   Regarding interrupts:
//     Please read the white pager entited "PDP-11 Interrupts: Variations On A
//     Theme", Bob Supnik, 03-Feb-2002 [revised 20-Feb-2004]
//
// File
//   rh11.v
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

`include "rh11.vh"
`include "rhcs1.vh"
`include "rhcs2.vh"
`include "rpxx/rpcs1.vh"
`include "rpxx/rpxx.vh"
`include "sd/sd.vh"
`include "../ubabus.vh"

module RH11(clk,      rst,
            rh11CD,   rh11WP,   rh11MISO, rh11MOSI, rh11SCLK, rh11CS, rh11DEBUG,
            devRESET, devINTR,  devINTA,
            devREQI,  devACKO,  devADDRI,
            devREQO,  devACKI,  devADDRO,
            devDATAI, devDATAO);

   input          clk;                          // Clock
   input          rst;                          // Reset
   // RH11 Interfaces
   input          rh11CD;                       // RH11 Card Detect
   input          rh11WP;                       // RH11 Write Protect
   input          rh11MISO;                     // RH11 Data In
   output         rh11MOSI;                     // RH11 Data Out
   output         rh11SCLK;                     // RH11 Clock
   output         rh11CS;                       // RH11 Chip Select
   output [ 0:63] rh11DEBUG;                    // RH11 Debug Output
   // Reset
   input          devRESET;                     // IO Bus Bridge Reset
   // Interrupt
   output [ 7: 4] devINTR;                      // Interrupt Request
   input  [ 7: 4] devINTA;                      // Interrupt Acknowledge
   // Target
   input          devREQI;                      // Device Request In
   output         devACKO;                      // Device Acknowledge Out
   input  [ 0:35] devADDRI;                     // Device Address In
   // Initiator
   output         devREQO;                      // Device Request Out
   input          devACKI;                      // Device Acknowledge In
   output [ 0:35] devADDRO;                     // Device Address Out
   // Data
   input  [ 0:35] devDATAI;                     // Data In
   output [ 0:35] devDATAO;                     // Data Out

   //
   // RH Parameters
   //

   parameter [14:17] rhDEV   = `devUBA1;        // RH11 Device Number
   parameter [18:35] rhADDR  = `rh1ADDR;        // RH11 Base Address
   parameter [18:35] rhVECT  = `rh1VECT;        // RH11 Interrupt Vector
   parameter [ 7: 4] rhINTR  = `rh1INTR;        // RH11 Interrupt
   parameter [15: 0] drvTYPE = `rpRP06;         // Drive type
   parameter         simTIME = 1'b0;            // Simulate timing

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

   localparam [0:19] rdFLAGS = 20'b0001_0000_0000_0000_0000;
   localparam [0:19] wrFLAGS = 20'b0000_0100_0000_0000_0000;

   //
   // Selector function
   //

   function [7:0] select;
      input [0:2] sel;
      begin
         select = 1'b1 << sel;
      end
   endfunction

   //
   // Device Address and Flags
   //

   wire         devREAD   = `devREAD(devADDRI);         // Read Cycle
   wire         devWRITE  = `devWRITE(devADDRI);        // Write Cycle
   wire         devPHYS   = `devPHYS(devADDRI);         // Physical reference
   wire         devIO     = `devIO(devADDRI);           // IO Cycle
   wire         devWRU    = `devWRU(devADDRI);          // WRU Cycle
   wire         devVECT   = `devVECT(devADDRI);         // Read interrupt vector
   wire         devIOBYTE = `devIOBYTE(devADDRI);       // Byte IO Operation
   wire [14:17] devDEV    = `devDEV(devADDRI);          // Device Number
   wire [18:34] devADDR   = `devADDR(devADDRI);         // Device Address
   wire         devHIBYTE = `devHIBYTE(devADDRI);       // Device High Byte
   wire         devLOBYTE = `devLOBYTE(devADDRI);       // Device Low Byte

   //
   // Address Decoding
   //

   wire vectREAD   = devREAD  & devIO & devPHYS & !devWRU &  devVECT & (devDEV == rhDEV);

   wire rhcs1READ  = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR == cs1ADDR[18:34]);
   wire rhcs1WRITE = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR == cs1ADDR[18:34]);
   wire rhwcREAD   = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR ==  wcADDR[18:34]);
   wire rhwcWRITE  = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR ==  wcADDR[18:34]);
   wire rhbaREAD   = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR ==  baADDR[18:34]);
   wire rhbaWRITE  = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR ==  baADDR[18:34]);
   wire rpdaREAD   = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR ==  daADDR[18:34]);
   wire rpdaWRITE  = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR ==  daADDR[18:34]);

   wire rhcs2READ  = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR == cs2ADDR[18:34]);
   wire rhcs2WRITE = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR == cs2ADDR[18:34]);
   wire rpdsREAD   = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR ==  dsADDR[18:34]);
   wire rpdsWRITE  = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR ==  dsADDR[18:34]);
   wire rper1READ  = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR == er1ADDR[18:34]);
   wire rper1WRITE = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR == er1ADDR[18:34]);
   wire rpasREAD   = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR ==  asADDR[18:34]);
   wire rpasWRITE  = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR ==  asADDR[18:34]);

   wire rplaREAD   = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR ==  laADDR[18:34]);
   wire rplaWRITE  = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR ==  laADDR[18:34]);
   wire rhdbREAD   = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR ==  dbADDR[18:34]);
   wire rhdbWRITE  = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR ==  dbADDR[18:34]);
   wire rpmrREAD   = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR ==  mrADDR[18:34]);
   wire rpmrWRITE  = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR ==  mrADDR[18:34]);
   wire rpdtREAD   = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR ==  dtADDR[18:34]);
   wire rpdtWRITE  = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR ==  dtADDR[18:34]);

   wire rpsnREAD   = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR ==  snADDR[18:34]);
   wire rpsnWRITE  = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR ==  snADDR[18:34]);
   wire rpofREAD   = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR ==  ofADDR[18:34]);
   wire rpofWRITE  = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR ==  ofADDR[18:34]);
   wire rpdcREAD   = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR ==  dcADDR[18:34]);
   wire rpdcWRITE  = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR ==  dcADDR[18:34]);
   wire rpccREAD   = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR ==  ccADDR[18:34]);
   wire rpccWRITE  = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR ==  ccADDR[18:34]);

   wire rper2READ  = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR == er2ADDR[18:34]);
   wire rper2WRITE = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR == er2ADDR[18:34]);
   wire rper3READ  = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR == er3ADDR[18:34]);
   wire rper3WRITE = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR == er3ADDR[18:34]);
   wire rpec1READ  = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR == ec1ADDR[18:34]);
   wire rpec1WRITE = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR == ec1ADDR[18:34]);
   wire rpec2READ  = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR == ec2ADDR[18:34]);
   wire rpec2WRITE = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV) & (devADDR == ec2ADDR[18:34]);

   //
   // Big-endian to little-endian data bus swap
   //

   wire [35:0] rhDATAI = devDATAI[0:35];

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
   wire [15:0] rpAS;                    // AS  Register (Pseudo register)
   wire [15:0] rpLA [7:0];              // LA  Register
   wire [15:0] rpMR [7:0];              // MR  Register
   wire [15:0] rpDT [7:0];              // DT  Register
   wire [15:0] rpSN [7:0];              // SN  Register
   wire [15:0] rpOF [7:0];              // OF  Register
   wire [15:0] rpDC [7:0];              // DC  Register
   wire [15:0] rpCC [7:0];              // CC  Register
   wire [15:0] rpER2[7:0];              // ER2 Register
   wire [15:0] rpER3[7:0];              // ER3 Register
   wire [15:0] rpEC1 = {15'b0};         // EC1 Register (always 0)
   wire [15:0] rpEC2 = {15'b0};         // EC2 Register (always 0)

   //
   // RH11 Control/Status #1 (CS1) Register
   //

   wire rhSC  = `rhCS1_SC(rhCS1);
   wire rhRDY = `rhCS1_RDY(rhCS1);
   wire rhIE  = `rhCS1_IE(rhCS1);

   //
   // RH11 Control/Status #2 (CS2) Register
   //

   wire rhCLR  = `rhCS2_CLR(rhCS2);
   wire rhBAI  = `rhCS2_BAI(rhCS2);
   wire [ 2:0] rhUNIT = `rhCS2_UNIT(rhCS2);

   //
   // RH11 Attention Summary (AS) Register
   //

   assign rpAS = {8'b0,
                  rpDS[7][15], rpDS[6][15], rpDS[5][15], rpDS[4][15],
                  rpDS[3][15], rpDS[2][15], rpDS[1][15], rpDS[0][15]};

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
   //
   //

   wire rpATA = (rpDS[0][15] | rpDS[1][15] | rpDS[2][15] | rpDS[3][15] |
                 rpDS[4][15] | rpDS[5][15] | rpDS[6][15] | rpDS[7][15]);


   wire [ 1:0] rpSDOP  [7:0];           // SD Operation
   wire [31:0] rpSDADDR[7:0];           // SD Sector Address
   wire [ 7:0] rpSDREQ;                 // RP is ready for SD

   //
   // Signals
   //

   wire sdINCWORD;                      // Increment word
   wire sdINCSECT;                      // Increment Sector

   //
   // FIXME
   //

   wire setWCE = 0;     // FIXME
   wire setNEM = 0;     // FIXME
   wire setPGE = 0;     // FIXME

   //
   // Transfer Error Clear
   //

   wire treCLR = rhcs1WRITE & devHIBYTE & `rhCS1_TRE(rhDATAI);

   //
   // Go Clear Command
   //

   wire goCLR = rhcs1WRITE & (rhDATAI[5:1] == `funCLEAR) & `rpCS1_GO(rhDATAI) & rhRDY;

   //
   // RH11 Control/Status #1 (RHCS1) Register
   //

   RHCS1 CS1 (
      .clk        (clk),
      .rst        (rst),
      .devRESET   (devRESET),
      .devLOBYTE  (devLOBYTE),
      .devHIBYTE  (devHIBYTE),
      .devDATAI   (devDATAI),
      .rhcs1WRITE (rhcs1WRITE),
      .rpATA      (rpATA),
      .goCLR      (goCLR),
      .intrDONE   (1'b0),       // FIXME
      .rhBA       (rhBA),
      .rhCS2      (rhCS2),
      .rpCS1      (rpCS1[rhUNIT]),
      .rhCS1      (rhCS1)
   );

   //
   // RH11 Word Count (RHWC) Register
   //

   RHWC WC (
      .clk        (clk),
      .rst        (rst),
      .clr        (devRESET | rhCLR),
      .devLOBYTE  (devLOBYTE),
      .devHIBYTE  (devHIBYTE),
      .devDATAI   (devDATAI),
      .rhwcWRITE  (rhwcWRITE),
      .rhINCWC    (sdINCWORD),
      .rhWC       (rhWC)
   );

   //
   // RH11 Bus Address (RHBA) Register
   //

   RHBA BA (
      .clk        (clk),
      .rst        (rst),
      .clr        (devRESET | rhCLR),
      .devLOBYTE  (devLOBYTE),
      .devHIBYTE  (devHIBYTE),
      .devDATAI   (devDATAI),
      .rhcs1WRITE (rhcs1WRITE),
      .rhbaWRITE  (rhbaWRITE),
      .rhRDY      (rhRDY),
      .rhINCBA    (sdINCWORD & !rhBAI),
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
      .devDATAI   (devDATAI),
      .rhcs2WRITE (rhcs2WRITE),
      .setWCE     (setWCE),
      .setNEM     (setNEM),
      .setPGE     (setPGE),
      .goCLR      (goCLR),
      .treCLR     (treCLR),         // FIXME
      .rhCS1      (rhCS1),
      .rhCS2      (rhCS2)
   );

   //
   // RH11 Data Buffer (RHDB) Register
   //

   RHDB DB (
      .clk        (clk),
      .rst        (rst),
      .clr        (rhCLR | devRESET),
      .devLOBYTE  (devLOBYTE),
      .devHIBYTE  (devHIBYTE),
      .devDATAI   (devDATAI),
      .rhdbWRITE  (rhdbWRITE),
      .rhDB       (rhDB)
   );

   //
   // Attention Summary Pseudo Register
   //

   wire [ 7:0] ataCLR = (rpasWRITE) ? rhDATAI[7:0] : 8'b0;

   //
   // Completion Monitor
   //
   // Details:
   //  The Completion Monitor scans the disk drives (round robbin) and
   //  checks for drives that are requesting access to the SD Controller.
   //

   localparam [2:0] stateSCAN = 0,
                    stateBUSY = 1,
                    stateACK  = 2;

   reg [2:0] state;
   reg [2:0] scan;
   always @(posedge clk)
     begin
        if (rst)
          begin
             scan <= 0;
             state <= stateSCAN;
          end
        else
          begin
             case (state)
               stateSCAN:
                 begin
                    if (rpSDREQ[scan])
                      begin
                         if (rpSDOP[scan] == `sdopNOP)
                           state <= stateACK;
                         else
                           state <= stateBUSY;
                      end
                    else
                      begin
                         scan <= scan + 1'b1;
                      end
                 end

               //
               //
               //

               stateBUSY:
                 begin
                 end

               //
               // ACK the RP so that it will complete it's operation and
               // become ready for the next operation.
               //

               stateACK:
                 begin
                    state <= stateSCAN;
                 end
             endcase
          end
     end

   //
   // RH11 Interrupts
   //

   wire rhIFF;

   RHINTR INTR (
      .clk        (clk),
      .rst        (rst),
      .clr        (rhCLR | devRESET),
      .rhIFF      (rhIFF)
   );

   //
   // Build an array 8 RPxx disk drives
   //

   genvar i;
   generate
      for (i = 0; i < 8; i = i + 1)
        begin : disk_loop
           RPXX #(
              .drvTYPE  (`rpRP06),
              .simTIME  (simTIME)
           )
           uRPXX (
              .clk      (clk),
              .rst      (rst),
              .clr      (rhCLR | devRESET),
              .unitSEL  (rhUNIT == i[2:0]),
              .incSECTOR(sdINCSECT),
              .ataCLR   (ataCLR[i]),
              .devADDRI (devADDRI),
              .devDATAI (devDATAI),
              .rpCD     (rh11CD),
              .rpWP     (rh11WP),
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
              .rpSDACK  ((scan == i[2:0]) && (state == stateACK)),
              .rpSDADDR (rpSDADDR[i])
           );
        end
   endgenerate

   //
   // SD Controller
   //

   wire sdSTAT;

   SD uSD (
      .clk       (clk),
      .rst       (rst),
      .sdMISO    (rh11MISO),
      .sdMOSI    (rh11MOSI),
      .sdSCLK    (rh11SCLK),
      .sdCS      (rh11CS),
      .sdOP      (rpSDOP[scan]),
      .sdSECTADDR(rpSDADDR[scan]),
      .sdWDCNT   (rhWC),

      //here
      //.sdBUSADDR (sdBUSADDR),

//      .sdDATAI   (sdDATAI),
//      .sdDATAO   (sdDATAO),
//      .dmaREQ    (devREQO),  // fixme
//      .dmaACK    (devACKI),

      .sdINCWORD (sdINCWORD),
      .sdINCSECT (sdINCSECT),
      .sdSTAT    (sdSTAT),
      .sdDEBUG   (rh11DEBUG)
   );

   //
   // Generate Bus ACK
   //

   assign devACKO = (rhcs1WRITE | rhcs1READ |
                     rhwcWRITE  | rhwcREAD  |
                     rhbaWRITE  | rhbaREAD  |
                     rpdaWRITE  | rpdaREAD  |
                     //
                     rhcs2WRITE | rhcs2READ |
                     rpdsWRITE  | rpdsREAD  |
                     rper1WRITE | rper1READ |
                     rpasWRITE  | rpasREAD  |
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
                     rpec2WRITE | rpec2READ);

   //
   // Bus Mux and little-endian to big-endian bus swap.
   //

   reg [0:35] devDATAO;

   always @*
     begin
        devDATAO = 36'b0;
        if (rhcs1WRITE | rhcs1READ)
          devDATAO = {20'b0, rhCS1};
        if (rhwcWRITE | rhwcREAD)
          devDATAO = {20'b0, rhWC};
        if (rhbaWRITE | rhbaREAD)
          devDATAO = {20'b0, rhBA[15:0]};
        if (rpdaWRITE | rpdaREAD)
          devDATAO = {20'b0, rpDA[rhUNIT]};
        if (rhcs2WRITE | rhcs2READ)
          devDATAO = {20'b0, rhCS2};
        if (rpdsWRITE | rpdsREAD)
          devDATAO = {20'b0, rpDS[rhUNIT]};
        if (rper1WRITE | rper1READ)
          devDATAO = {20'b0, rpER1[rhUNIT]};
        if (rpasWRITE | rpasREAD)
          devDATAO = {20'b0, rpAS};
        if (rplaWRITE | rplaREAD)
          devDATAO = {20'b0, rpLA[rhUNIT]};
        if (rhdbWRITE | rhdbREAD)
          devDATAO = {20'b0, rhDB};
        if (rpmrWRITE | rpmrREAD)
          devDATAO = {20'b0, rpMR[rhUNIT]};
        if (rpdtWRITE | rpdtREAD)
          devDATAO = {20'b0, rpDT[rhUNIT]};
        if (rpsnWRITE | rpsnREAD)
          devDATAO = {20'b0, rpSN[rhUNIT]};
        if (rpofWRITE | rpofREAD)
          devDATAO = {20'b0, rpOF[rhUNIT]};
        if (rpdcWRITE | rpdcREAD)
          devDATAO = {20'b0, rpDC[rhUNIT]};
        if (rpccWRITE | rpccREAD)
          devDATAO = {20'b0, rpCC[rhUNIT]};
        if (rper2WRITE | rper2READ)
          devDATAO = {20'b0, rpER2[rhUNIT]};
        if (rper3WRITE | rper3READ)
          devDATAO = {20'b0, rpER3[rhUNIT]};
        if (rpec1WRITE | rpec1READ)
          devDATAO = {20'b0, rpEC1};
        if (rpec2WRITE | rpec2READ)
          devDATAO = {20'b0, rpEC2};
     end

   //
   // Interrupt Request
   //

   assign devINTR = (rhIFF | (rhSC & rhRDY & rhIE)) ? rhINTR : 4'b0;

   //
   // Create address
   // FIXME:

   //wire devADDRO = (readOP) ? {rdFLAGS, sdBUSADDR} : {wrFLAGS, sdBUSADDR};

`ifndef SYNTHESIS

   //
   // Bus Monitor
   //
   // Details
   //  Wait for Bus ACK on bus accesses.  Generate message on a timeout.
   //

   localparam [0:3] nxmTimeout = 15;
   reg        [0:3] nxmCount;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          nxmCount <= nxmTimeout;
        else
          begin
             if (devREQO & !devACKI)
               begin
                  if (nxmCount != 0)
                    nxmCount <= nxmCount - 1'b1;
               end
             else
               nxmCount <= nxmTimeout;
          end
     end

   //
   // Whine about unacked bus cycles
   //

   always @(posedge clk)
     begin
        if (nxmCount == 1)
          begin
             $display("[%11.3f] RH11: Unacknowledged bus cycle.  Addr Bus = %012o",
                      $time/1.0e3, devADDRO);
             $stop;
          end
     end

`endif

endmodule
