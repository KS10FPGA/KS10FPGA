////////////////////////////////////////////////////////////////////////////////
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
`include "rpxx.vh"
`include "rh11.vh"
`include "rhcs1.vh"
`include "rhcs2.vh"
`include "rpcs1.vh"
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

   localparam [18:35] cs1ADDR = rhADDR + `cs1OFFSET;     // Massbus Addr 00
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
   // Device Address and Flags
   //

   wire         devREAD   = `devREAD(devADDRI);         // Read Cycle (IO or Memory)
   wire         devWRITE  = `devWRITE(devADDRI);        // Write Cycle (IO or Memory)
   wire         devIO     = `devIO(devADDRI);           // IO Cycle, 0 = Memory Cycle
   wire         devIOBYTE = `devIOBYTE(devADDRI);       // Byte IO Operation
   wire [14:17] devDEV    = `devDEV(devADDRI);          // Device Number
   wire [18:34] devADDR   = `devADDR(devADDRI);         // Device Address
   wire         devHIBYTE = `devHIBYTE(devADDRI);       // Device Hi byte select
   wire         devLOBYTE = `devLOBYTE(devADDRI);       // Device Lo byte select

   //
   // Big-endian to little-endian data bus swap
   //

   wire [35:0] rhDATAI = devDATAI[0:35];

   //
   // Write Decoder
   //

   wire rhcs1WRITE = devWRITE & devIO & (devDEV == rhDEV) & (devADDR == cs1ADDR[18:34]);
   wire rhcs2WRITE = devWRITE & devIO & (devDEV == rhDEV) & (devADDR == cs2ADDR[18:34]);
   wire rhwcWRITE  = devWRITE & devIO & (devDEV == rhDEV) & (devADDR ==  wcADDR[18:34]);
   wire rhbaWRITE  = devWRITE & devIO & (devDEV == rhDEV) & (devADDR ==  baADDR[18:34]);
   wire rhdbWRITE  = devWRITE & devIO & (devDEV == rhDEV) & (devADDR ==  dbADDR[18:34]);
   wire rhasWRITE  = devWRITE & devIO & (devDEV == rhDEV) & (devADDR ==  asADDR[18:34]);

   //
   // Transfer Error Clear
   //

   wire treCLR = rhcs1WRITE & devHIBYTE & `rhCS1_TRE(rhDATAI);

   //
   // Controller Clear
   //

   wire rhCLR = rhcs2WRITE & devLOBYTE & `rhCS2_CLR(rhDATAI);

   //
   // Go Clear Command
   //

   wire goCLR = rhcs1WRITE & (rhDATAI[5:1] == `funCLEAR) & `rpCS1_GO(rhDATAI) & rhRDY;

   //
   // RH11 Control/Status #1 (RHCS1) Register
   //

   reg rhTRE;           // [14] Transfer Error
   reg rhPSEL;          // [11] Port Select
   reg rhRDY;           // [ 7] Ready
   reg rhIE;            // [ 6] Interrupt Enable
   reg rhIFF;           // Interrupt Flip-flop
   reg lastWCE;
   reg lastPE;
   reg lastNEM;
   reg lastMXF;
   reg lastRDY;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             rhTRE   <= 0;
             rhPSEL  <= 0;
             rhRDY   <= 1;
             rhIE    <= 0;
             rhIFF   <= 0;
             lastWCE <= 0;
             lastPE  <= 0;
             lastNEM <= 0;
             lastMXF <= 0;
             lastRDY <= 0;
          end
        else
          begin
             if (rhCLR | devRESET)
               begin
                  rhTRE   <= 0;
                  rhPSEL  <= 0;
                  rhRDY   <= 1;
                  rhIE    <= 0;
                  rhIFF   <= 0;
                  lastWCE <= 0;
                  lastPE  <= 0;
                  lastNEM <= 0;
                  lastMXF <= 0;
                  lastRDY <= 0;
               end
             else if (rhcs1WRITE)
               begin
                  if (devHIBYTE)
                    begin
                       rhPSEL <= rhDATAI[10];
                       if (rhDATAI[14])
                         begin
                            rhTRE <= 0;
                         end
                    end
                  if (devLOBYTE)
                    begin
                       rhIE <= rhDATAI[6];
                    end
               end

             if (goCLR)
               begin
                  rhTRE <= 0;
               end
             else if ((rhWCE & ~lastWCE) | (rhPE & ~lastPE) | (rhNEM & ~lastNEM) | (rhPGE & ~lastNEM) | (rhMXF & ~lastMXF))
               begin
                  rhTRE <= 1;
               end

             //
             // Done Interrupt Flip-flop
             //  Set on transition or RDY from 0 -> 1
             //  Cleared by interrupt acknowledge
             //

             if (devINTA == rhINTR)
               rhIFF <= 0;
             else if (rhRDY & ~lastRDY)
               rhIFF <= rhIE;

             lastWCE <= rhWCE;
             lastPE  <= rhPE;
             lastNEM <= rhNEM;
             lastMXF <= rhMXF;
             lastRDY <= rhRDY;
          end
     end

   wire        rhSC   = (rhTRE |
                         rpDS[0][15] | rpDS[1][15] | rpDS[2][15] | rpDS[3][15] |
                         rpDS[4][15] | rpDS[5][15] | rpDS[6][15] | rpDS[7][15]);
   wire        rhMCPE = 0;
   wire        rhDVA  = 1;
   wire [ 5:1] rhFUN  = rpFUN[rhUNITSEL];
   wire        rhGO   = rpGO[rhUNITSEL];
   wire [15:0] rhCS1  = {rhSC, rhTRE, rhMCPE, 1'b1, rhDVA, rhPSEL,
                         rhBA[17:16], rhRDY,  rhIE, rhFUN, rhGO};


   //
   // RH11 Word Count (RHWC) Register
   //

   wire sdINCWD;
   reg  [15:0] rhWC;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rhWC <= 0;
        else
          begin
             if (rhCLR | devRESET)
               rhWC <= 0;
             else
               begin
                  if (rhwcWRITE)
                    begin
                       if (devHIBYTE)
                         rhWC[15:8] <= rhDATAI[15:8];
                       if (devLOBYTE)
                         rhWC[ 7:0] <= rhDATAI[ 7:0];
                    end
                  else if (sdINCWD)
                    rhWC <= rhWC + 1'b1;
               end
          end
     end

   //
   // RH11 Bus Address (RHBA) Register
   //

   reg [17:0] rhBA;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rhBA[17:0] <= 0;
        else
          begin
             if (rhCLR | devRESET)
               rhBA[17:0] <= 0;
             else
               begin
                  if (rhbaWRITE)
                    begin
                       if (devHIBYTE)
                         rhBA[15:8] <= rhDATAI[15:8];
                       if (devLOBYTE)
                         rhBA[ 7:0] <= rhDATAI[ 7:0];
                    end
                  else if (rhcs1WRITE)
                    begin
                       if (devHIBYTE)
                         rhBA[17:16] <= rhDATAI[9:8];
                    end
                  else if (sdINCWD & !rhBAI)
                    rhBA <= rhBA + 2'd2;
               end
          end
     end

   //
   // RH11 Control/Status #2 (RHCS2) Register
   //

   reg rhWCE;
   reg rhPE;
   reg rhNEM;
   reg rhPGE;
   reg rhMXF;
   reg rhPAT;
   reg rhBAI;
   reg [2:0] rhUNIT;

   wire setWCE = 0;
   wire setNEM = 0;

   always @(posedge clk)
     begin
        if (rst)
          begin
             rhWCE  <= 0;
             rhPE   <= 0;
             rhNEM  <= 0;
             rhPGE  <= 0;
             rhMXF  <= 0;
             rhPAT  <= 0;
             rhBAI  <= 0;
             rhUNIT <= 0;
          end
        else
          begin
             if (rhCLR | devRESET)
               begin
                  rhWCE  <= 0;
                  rhPE   <= 0;
                  rhNEM  <= 0;
                  rhPGE  <= 0;
                  rhMXF  <= 0;
                  rhPAT  <= 0;
                  rhBAI  <= 0;
                  rhUNIT <= 0;
               end
             else if (treCLR)
               begin
                  rhWCE <= 0;
                  rhPE  <= 0;
                  rhNEM <= 0;
                  rhPGE <= 0;
                  rhMXF <= 0;
               end
             else if (goCLR)
               begin
                  rhWCE <= 0;
                  rhPE  <= 0;
                  rhNEM <= 0;
                  rhMXF <= 0;
               end
             else if (rhcs2WRITE)
               begin
                  if (devHIBYTE)
                    begin
                       rhPE   <= rhDATAI[13];
                       rhMXF  <= rhDATAI[ 9];
                    end
                  if (devLOBYTE)
                    begin
                       rhPAT  <= rhDATAI[4];
                       rhBAI  <= rhDATAI[3];
                       rhUNIT <= rhDATAI[2:0];
                    end
               end
             else
               begin
                  if (setWCE)
                    rhWCE <= 1;
                  if (setNEM)
                    rhNEM <= 1;
               end
          end
     end

   wire        rhDLT  = 0;                      // CS2[15] : Device Late
   wire        rhNED  = 0;                      // CS2[12] : Non-Existent Device (not implemented)
   wire        rhMDPE = 0;                      // CS2[ 8] : Massbus Data Parity Error (not implemented)
   wire        rhOR   = 1;                      // CS2[ 7] : Output Ready
   wire        rhIR   = 1;                      // CS2[ 6] : Input Ready
   wire [15:0] rhCS2  = {rhDLT, rhWCE,  rhPE, rhNED, rhNEM, rhPGE, rhMXF,
                         rhMDPE, rhOR, rhIR,  1'b0,  rhPAT, rhBAI, rhUNIT};

   //
   // RH11 Data Buffer (RHDB) Register
   //

   reg  [15:0] rhDB;

   always @(posedge clk)
     begin
        if (rst | rhCLR | devRESET)
          begin
             rhDB <= 0;
          end
        else if (rhdbWRITE)
          begin
             if (devHIBYTE)
               begin
                 rhDB[15:8] <= rhDATAI[15:8];
               end
             if (devLOBYTE)
               begin
                 rhDB[7:0] <= rhDATAI[7:0];
               end
          end
     end

   //
   // Attention Summary Pseudo Register
   //

   wire [ 7:0] ataCLR = (rhasWRITE) ? rhDATAI[7:0] : 8'b0;
   wire [15:0] rhAS   = {8'b0,
                         rpDS[7][15], rpDS[6][15], rpDS[5][15], rpDS[4][15],
                         rpDS[3][15], rpDS[2][15], rpDS[1][15], rpDS[0][15]};

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
                    if (rpSDREQ[sdUNITSEL])
                      begin
                         if (rpSDOP[sdUNITSEL] == `sdopNOP)
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
   // Unit Select Decoder for Registers
   //

   reg [7:0] rhUNITSEL;
   always @(rhUNIT)
     begin
        case (rhUNIT)
          0: rhUNITSEL <= 8'b0000_0001;
          1: rhUNITSEL <= 8'b0000_0010;
          2: rhUNITSEL <= 8'b0000_0100;
          3: rhUNITSEL <= 8'b0000_1000;
          4: rhUNITSEL <= 8'b0001_0000;
          5: rhUNITSEL <= 8'b0010_0000;
          6: rhUNITSEL <= 8'b0100_0000;
          7: rhUNITSEL <= 8'b1000_0000;
        endcase
     end

   //
   // Unit Select Decoder for Completion Monitor
   //

   reg [7:0] sdUNITSEL;
   always @(scan)
     begin
        case (scan)
          0: sdUNITSEL <= 8'b0000_0001;
          1: sdUNITSEL <= 8'b0000_0010;
          2: sdUNITSEL <= 8'b0000_0100;
          3: sdUNITSEL <= 8'b0000_1000;
          4: sdUNITSEL <= 8'b0001_0000;
          5: sdUNITSEL <= 8'b0010_0000;
          6: sdUNITSEL <= 8'b0100_0000;
          7: sdUNITSEL <= 8'b1000_0000;
        endcase
     end

   //
   // Generate ACK for the correct disk drive
   //

   assign rpSDACK[0] = ((scan == 0) & (state == stateACK));
   assign rpSDACK[1] = ((scan == 1) & (state == stateACK));
   assign rpSDACK[2] = ((scan == 2) & (state == stateACK));
   assign rpSDACK[3] = ((scan == 3) & (state == stateACK));
   assign rpSDACK[4] = ((scan == 4) & (state == stateACK));
   assign rpSDACK[5] = ((scan == 5) & (state == stateACK));
   assign rpSDACK[6] = ((scan == 6) & (state == stateACK));
   assign rpSDACK[7] = ((scan == 7) & (state == stateACK));

   //
   // Build Array 8 RP Register Sets
   //

   wire [15: 0] rpSN    [7:0];          // SN  Register
   wire [15: 0] rpDA    [7:0];          // DA  Register
   wire [15: 0] rpDS    [7:0];          // DS  Register
   wire [15: 0] rpER1   [7:0];          // ER1 Register
   wire [15: 0] rpLA    [7:0];          // LA  Register
   wire [15: 0] rpMR    [7:0];          // MR  Register
   wire [15: 0] rpOF    [7:0];          // OF  Register
   wire [15: 0] rpDC    [7:0];          // DC  Register
   wire [15: 0] rpCC    [7:0];          // CC  Register
   wire [ 5: 1] rpFUN   [7:0];          // CS1[FUN] Register
   wire         rpGO    [7:0];          // CS1[GO]  Register
   wire [ 1: 0] rpSDOP  [7:0];          // SD Operation
   wire [31: 0] rpSDADDR[7:0];          // SD Sector Address
   wire [ 7: 0] rpSDREQ;                // RP is ready for SD
   wire [ 7: 0] rpSDACK;                // SD is done with RP

   assign rpSN[0] = `rpSN0;
   assign rpSN[1] = `rpSN1;
   assign rpSN[2] = `rpSN2;
   assign rpSN[3] = `rpSN3;
   assign rpSN[4] = `rpSN4;
   assign rpSN[5] = `rpSN5;
   assign rpSN[6] = `rpSN6;
   assign rpSN[7] = `rpSN7;

   wire [7:0] sdINCSECT;
   
   //
   // Build Array 8 RPxx (RP06 in this case) disk drives
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
              .rst      (rst | rhCLR | devRESET),
              .unitSEL  (rhUNITSEL[i]),
              .incSECTOR(sdINCSECT[i]),
              .rhCLR    (rhCLR),
              .ataCLR   (ataCLR[i]),
              .devRESET (devRESET),
              .devADDRI (devADDRI),
              .rhDATAI  (rhDATAI),
              .rpCD     (rh11CD),
              .rpWP     (rh11WP),
              .rpDA     (rpDA[i]),
              .rpDS     (rpDS[i]),
              .rpER1    (rpER1[i]),
              .rpLA     (rpLA[i]),
              .rpMR     (rpMR[i]),
              .rpOF     (rpOF[i]),
              .rpDC     (rpDC[i]),
              .rpCC     (rpCC[i]),
              .rpFUN    (rpFUN[i]),
              .rpGO     (rpGO[i]),
              .rpSDOP   (rpSDOP[i]),
              .rpSDREQ  (rpSDREQ[i]),
              .rpSDACK  (rpSDACK[i]),
              .rpSDADDR (rpSDADDR[i])
           );
        end
   endgenerate

   //
   // SD Controller
   //


`ifdef BROKEN
   
   
   wire sdSTAT;

   SD uSD (
      .clk       (clk),
      .rst       (rst),
      .sdMISO    (rh11MISO),
      .sdMOSI    (rh11MOSI),
      .sdSCLK    (rh11SCLK),
      .sdCS      (rh11CS),
      //.sdREQ     (rpSDREQ[sdUNITSEL]), // here
      .sdOP      (rpSDOP[sdUNITSEL]),
      .sdSECTADDR(rpSDADDR[sdUNITSEL]),
      .sdWDCNT   (rhWC),
      //here
      //.sdBUSADDR (sdBUSADDR),
      .dmaDATAI  (devDATAI),
      //.dmaDATAO  (devDATAO),   // here
      //.dmaADDR   (devADDR),
      .dmaREQ    (/*devREQO*/),  // fixme
      .dmaACK    (devACKI),
      .sdINCWD   (sdINCWD),
      .sdINCSECT (sdINCSECT != 8'b0),

      .sdSTAT    (sdSTAT),
      .sdDEBUG   (rh11DEBUG)
   );


`else

   // fixme
   assign sdINCWD = 0;
   assign devREQO = 0;
   assign rh11MOSI = 0;
   assign rh11SCLK = 0;
   assign rh11CS = 0;
   assign rh11DEBUG = 0;
   
`endif
   
   //
   // Demux Disk Array Registers
   //

   wire [15:0] muxRPDA  =  rpDA[rhUNITSEL];
   wire [15:0] muxRPDS  =  rpDS[rhUNITSEL];
   wire [15:0] muxRPER1 = rpER1[rhUNITSEL];
   wire [15:0] muxRPLA  =  rpLA[rhUNITSEL];
   wire [15:0] muxRPMR  =  rpMR[rhUNITSEL];
   wire [15:0] muxRPSN  =  rpSN[rhUNITSEL];
   wire [15:0] muxRPOF  =  rpOF[rhUNITSEL];
   wire [15:0] muxRPDC  =  rpDC[rhUNITSEL];
   wire [15:0] muxRPCC  =  rpCC[rhUNITSEL];

   //
   // Bus Mux and little-endian to big-endian bus swap.
   //

   reg devACKO;
   reg [0:35] devDATAO;

   always @(devREAD or devIO    or devDEV  or rhDEV   or devADDR or rhCS1 or
            rhWC    or rhBA     or rhCS2   or rhAS    or rhDB    or
            muxRPDA or muxRPDS or muxRPER1 or muxRPLA or muxRPMR or
            muxRPSN or muxRPOF  or muxRPDC or muxRPCC)
     begin
        if (devREAD & devIO & (devDEV == rhDEV))
          begin
             case (devADDR)
               cs1ADDR[18:34]:
                 devDATAO = {20'b0, rhCS1};
               wcADDR[18:34] :
                 devDATAO = {20'b0, rhWC};
               baADDR[18:34]:
                 devDATAO = {18'b0, rhBA};
               daADDR[18:34]:
                 devDATAO = {20'b0, muxRPDA};
               cs2ADDR[18:34]:
                 devDATAO = {20'b0, rhCS2};
               dsADDR[18:34]:
                 devDATAO = {20'b0, muxRPDS};
               er1ADDR[18:34]:
                 devDATAO = {20'b0, muxRPER1};
               asADDR[18:34]:
                 devDATAO = {20'b0, rhAS};
               laADDR[18:34]:
                 devDATAO = {20'b0, muxRPLA};
               dbADDR[18:34]:
                 devDATAO = {20'b0, rhDB};
               mrADDR[18:34]:
                 devDATAO = {20'b0, muxRPMR};
               dtADDR[18:34]:
                 devDATAO = {20'b0, `rpRP06};
               snADDR[18:34]:
                 devDATAO = {20'b0, muxRPSN};
               ofADDR[18:34]:
                 devDATAO = {20'b0, muxRPOF};
               dcADDR[18:34]:
                 devDATAO = {20'b0, muxRPDC};
               ccADDR[18:34]:
                 devDATAO = {20'b0, muxRPCC};
               er2ADDR[18:34],
               er3ADDR[18:34],
               ec1ADDR[18:34],
               ec2ADDR[18:34]:
                 devDATAO = 36'b0;
               default:
                 devDATAO = 36'b0;
             endcase
             devACKO = 1;
          end
        else
          begin
             devDATAO = 36'b0;
             devACKO  = 0;
          end
     end

   //
   // Interrupt Request
   //

   assign devINTR = (rhIFF | (rhSC & rhRDY & rhIE)) ? rhINTR : 4'b0;

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
             $display("[%10.3f] RH11: Unacknowledged bus cycle.  Addr Bus = %012o",  $time/1.0e3, devADDRO);
	     $stop;
          end
     end

`endif

endmodule
