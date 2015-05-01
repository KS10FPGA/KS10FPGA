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
`include "rpdc.vh"
`include "rpds.vh"
`include "rpof.vh"
`include "rpcs1.vh"
`include "rper1.vh"
`include "../rh11.vh"
`include "../sd/sd.vh"
`include "../../ubabus.vh"

module RPXX(clk, rst, clr,
            unitSEL, incSECTOR, ataCLR, devADDRI, devDATAI, rpCD, rpWP,
            rpCS1, rpDA, rpDS, rpER1, rpLA, rpMR, rpDT, rpOF, rpDC, rpCC, rpER2, rpER3,
            rpSDOP, rpSDREQ, rpSDACK, rpSDADDR);

   input          clk;                          // Clock
   input          rst;                          // Reset
   input          clr;                          // Clear
   input          unitSEL;                      // Unit Select
   input          incSECTOR;                    // Increment Sector
   input          ataCLR;                       // Clear RPDS[ATA]
   input  [ 0:35] devADDRI;                     // Device Address In
   input  [ 0:35] devDATAI;                     // Device Data In
   input          rpCD;                         // Card Detect from SD Card
   input          rpWP;                         // Write Protect from SD Card
   output [15: 0] rpCS1;                        // CS1 Register
   output [15: 0] rpDA;                         // DA  Register
   output [15: 0] rpDS;                         // DS  Register
   output [15: 0] rpER1;                        // ER1 Register
   output [15: 0] rpLA;                         // LA  Register
   output [15: 0] rpMR;                         // MR  Register
   output [15: 0] rpDT;                         // DT  Register
   output [15: 0] rpOF;                         // OF  Register
   output [15: 0] rpDC;                         // DC  Register
   output [15: 0] rpCC;                         // CC  Register
   output [15: 0] rpER2;                        // ER2 Register
   output [15: 0] rpER3;                        // ER3 Register
   output [ 1: 0] rpSDOP;                       // SD Operation
   output         rpSDREQ;                      // SD Request
   input          rpSDACK;                      // SD Complete Acknowledge
   output [31: 0] rpSDADDR;                     // SD Sector Address

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
   // Timing Parameters
   //

   localparam [24:0] fiveMS = 100000;                           // 5 milliseconds
   localparam [24:0] oneUS  = 50;                               // 1 microsecond

   //
   // Lookup Drive Geometries
   //

   localparam [5:0] lastSECTOR = `getLAST_SECTOR(drvTYPE);      // Sectors
   localparam [5:0] lastTRACK  = `getLAST_TRACK(drvTYPE);       // Tracks (or surfaces or heads)
   localparam [9:0] lastCYL    = `getLAST_CYL (drvTYPE);        // Cylinder

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

   wire rpcs1WRITE = devWRITE & devIO & devPHYS & (devDEV == rhDEV) & (devADDR == cs1ADDR[18:34]) & unitSEL;    //  0
   wire rper1WRITE = devWRITE & devIO & devPHYS & (devDEV == rhDEV) & (devADDR == er1ADDR[18:34]) & unitSEL;    //  2
   wire rpmrWRITE  = devWRITE & devIO & devPHYS & (devDEV == rhDEV) & (devADDR ==  mrADDR[18:34]) & unitSEL;    //  3
   wire rpofWRITE  = devWRITE & devIO & devPHYS & (devDEV == rhDEV) & (devADDR ==  ofADDR[18:34]) & unitSEL;    //  9
   wire rpdaWRITE  = devWRITE & devIO & devPHYS & (devDEV == rhDEV) & (devADDR ==  daADDR[18:34]) & unitSEL;    //  5
   wire rpdcWRITE  = devWRITE & devIO & devPHYS & (devDEV == rhDEV) & (devADDR ==  dcADDR[18:34]) & unitSEL;    // 10
   wire rper2WRITE = devWRITE & devIO & devPHYS & (devDEV == rhDEV) & (devADDR == er2ADDR[18:34]) & unitSEL;    // 12
   wire rper3WRITE = devWRITE & devIO & devPHYS & (devDEV == rhDEV) & (devADDR == er3ADDR[18:34]) & unitSEL;    // 13

   //
   // Big-endian to little-endian data bus swap
   //

   wire [35:0] rpDATAI = devDATAI[0:35];

   //
   // RPxx Control/Status Register (RPCS1)
   //

   wire [15:0] rpCS1;
   wire        rpGO = `rpCS1_GO(rpCS1);

   //
   // RPxx Disk Status Register (RPDS)
   //

   wire [15:0] rpDS;
   wire        rpERR = `rpDS_ERR(rpDS);
   wire        rpDRY = `rpDS_DRY(rpDS);

   //
   // RPxx Disk Address Register (RPDA)
   //

   wire [15:0] rpDA;
   wire [ 5:0] rpSA = `rpDA_SA(rpDA);
   wire [ 5:0] rpTA = `rpDA_TA(rpDA);

   //
   // RPxx Error #1 (RPER1) Register
   //

   wire [15:0] rpER1;

   //
   // RPxx Offset (RPOF) Register
   //

   wire [15:0] rpOF;

   //
   // RPxx Desired Cylinder (RPDC) Register
   //

   wire [15:0] rpDC;
   wire [ 9:0] rpDCA = `rpDC_DCA(rpDC);

   //
   // SD Sector Address
   //

   wire [31:0] rpSDADDR;

   //
   // Function to calculate disk seek delay.  This is psudeo exponential.
   // The RP06 has 815 cyclinders
   //

   function [24:0] seekDELAY;
      input [9:0] newCYL;               // New Cylinder
      input [9:0] oldCYL;               // Old Cylinder
      reg   [9:0] diffCYL;              // Distance between Cylinders
      begin
         diffCYL = (newCYL > oldCYL) ? newCYL - oldCYL : oldCYL - newCYL;
         if (diffCYL[9])
           seekDELAY = fiveMS * 10;     // 50 ms (more than 512 cylinders away)
         else if (diffCYL[8])
           seekDELAY = fiveMS *  9;     // 45 ms (more than 256 cylinders away)
         else if (diffCYL[7])
           seekDELAY = fiveMS *  8;     // 40 ms (more than 128 cylinders away)
         else if (diffCYL[6])
           seekDELAY = fiveMS *  7;     // 35 ms (more than  64 cylinders away)
         else if (diffCYL[5])
           seekDELAY = fiveMS *  6;     // 30 ms (more than  32 cylinders away)
         else if (diffCYL[4])
           seekDELAY = fiveMS *  5;     // 25 ms (more than  16 cylinders away)
         else if (diffCYL[3])
           seekDELAY = fiveMS *  4;     // 20 ms (more than   8 cylinders away)
         else if (diffCYL[2])
           seekDELAY = fiveMS *  3;     // 15 ms (more than   4 cylinders away)
         else if (diffCYL[1])
           seekDELAY = fiveMS *  2;     // 10 ms (more than   2 cylinders away)
         else if (diffCYL[0])
           seekDELAY = fiveMS *  1;     //  5 ms (more than   1 cylinders away)
         else
           seekDELAY = fiveMS *  0;     //  0 ms (same cylinder)
      end
   endfunction

   //
   // Commands
   //
   // Trace
   //  M7774/RG4/E60
   //

   wire cmdGO     = rpcs1WRITE & `rpCS1_GO(rpDATAI);
   wire cmdDRVCLR = cmdGO & (`rpCS1_FUN(rpDATAI) == `funCLEAR);         // Drive clear
   wire cmdPRESET = cmdGO & (`rpCS1_FUN(rpDATAI) == `funPRESET);        // Read-in preset
   wire cmdCENTER = cmdGO & (`rpCS1_FUN(rpDATAI) == `funCENTER);        // Return to center

   //
   // Master Clear
   //

   // wire masterCLR = (( )
   //                    );


   //
   // State Definition
   //

   localparam [4:0] stateIDLE    =  0,
                    stateSEEK    =  1,
                    stateSEEKDLY =  2,
                    stateROTDLY  =  3,
                    stateWAITSD  =  4,
                    stateCLEAR   =  5,
                    stateOFFSET  =  6,
                    stateCENTER  =  7,
                    statePRESET  =  8,
                    statePAKACK  =  9,
                    stateILLFUN  = 10,
                    stateINVADDR = 11,
                    stateWRLOCK  = 12,
                    stateATA     = 13,
                    stateDONE    = 31;
   reg [ 4: 0] state;                   // RPxx State

   //
   // RPxx Control/Status Register (RPCS1)
   //

   RPCS1 CS1 (
      .clk         (clk),
      .rst         (rst),
      .clrGO       (clr | (state == stateDONE)),
      .rpDATAI     (rpDATAI),
      .rpcs1WRITE  (rpcs1WRITE & rpDRY),
      .rpCS1       (rpCS1)
   );

   //
   // RPxx Disk Address Register (RPDA)
   //

   RPDA DA (
      .clk         (clk),
      .rst         (rst),
      .clr         (clr | (state == statePRESET)),
      .rpDATAI     (rpDATAI),
      .lastSECTOR  (lastSECTOR),
      .lastTRACK   (lastTRACK),
      .rpdaWRITE   (rpdaWRITE & rpDRY),
      .incSECTOR   (incSECTOR & unitSEL),
      .rpDA        (rpDA)
   );

   //
   // RPxx Disk Status Register (RPDS)
   //

   RPDS DS (
      .clk         (clk),
      .rst         (rst),
      .clr         (clr),
      .ataCLR      (ataCLR),
      .lastSECTOR  (lastSECTOR),
      .lastTRACK   (lastTRACK),
      .lastCYL     (lastCYL),
      .rpCD        (rpCD),
      .rpWP        (rpWP),
      .state       (state),
      .stateATA    (stateATA),
      .stateCLEAR  (stateCLEAR),
      .stateIDLE   (stateIDLE),
      .stateOFFSET (stateOFFSET),
      .statePRESET (statePRESET),
      .statePAKACK (statePAKACK),
      .stateCENTER (stateCENTER),
      .stateSEEKDLY(stateSEEKDLY),
      .rpDA        (rpDA),
      .rpDC        (rpDC),
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
      .lastSECTOR  (lastSECTOR),
      .lastTRACK   (lastTRACK),
      .lastCYL     (lastCYL),
      .state       (state),
      .stateCLEAR  (stateCLEAR),
      .stateINVADDR(stateINVADDR),
      .stateILLFUN (stateILLFUN),
      .stateWRLOCK (stateWRLOCK),
      .rpDATAI     (rpDATAI),
      .rpcs1WRITE  (rpcs1WRITE),
      .rpdaWRITE   (rpdaWRITE),
      .rpofWRITE   (rpofWRITE),
      .rpdcWRITE   (rpdcWRITE),
      .rper1WRITE  (rper1WRITE),
      .incSECTOR   (incSECTOR),
      .rpDS        (rpDS),
      .rpDA        (rpDA),
      .rpDC        (rpDC),
      .rpER1       (rpER1)
   );

   //
   // RPxx Look Ahead (RPLA) Register
   //

   assign rpLA = {4'b0, rpSA, 6'b0};

   //
   // RPxx Offset (RPOF) Register
   //

   RPOF OF (
      .clk        (clk),
      .rst        (rst),
      .clr        (clr),
      .cmdCENTER  (state == stateCENTER),
      .cmdPRESET  (state == statePRESET),
      .rpDATAI    (rpDATAI),
      .rpofWRITE  (rpofWRITE & rpDRY),
      .rpOF       (rpOF)
   );

   //
   // RPxx Desired Cylinder (RPDC) Register
   //

   RPDC DC (
      .clk        (clk),
      .rst        (rst),
      .clr        (clr),
      .cmdPRESET  (state == statePRESET),
      .rpDATAI    (rpDATAI),
      .rpdcWRITE  (rpdcWRITE & rpDRY),
      .rpINCCYL   (incSECTOR & (rpTA == lastTRACK) & (rpSA == lastSECTOR)),
      .rpDC       (rpDC)
   );

   //
   // RPxx Maintenaince (RPMR) Register
   //

   RPMR MR (
      .clk        (clk),
      .rst        (rst),
      .clr        (clr | (state == stateCLEAR)),
      .rpDATAI    (rpDATAI),
      .rpmrWRITE  (rpmrWRITE),
      .rpGO       (rpGO),
      .rpMR       (rpMR)
   );

   //
   // RPxx Error Status #2 (RPER2) Register
   //

   RPER2 ER2 (
      .clk        (clk),
      .rst        (rst),
      .clr        (clr),
      .rpDATAI    (rpDATAI),
      .rper2WRITE (rper2WRITE),
      .rpER2      (rpER2)
   );

   //
   // RPxx Error Status #3 (RPER3) Register
   //

   RPER3 ER3 (
      .clk        (clk),
      .rst        (rst),
      .clr        (clr),
      .rpDATAI    (rpDATAI),
      .rper3WRITE (rper3WRITE),
      .rpER3      (rpER3)
   );

   //
   // SD Sector Address Calculation
   //

   SDADDR uSDADDR (
      .clk        (clk),
      .rst        (rst),
      .start      (state == stateSEEK),
      .lastTRACK  (lastTRACK),
      .lastSECTOR (lastSECTOR),
      .rpDCA      (rpDCA),
      .rpTA       (rpTA),
      .rpSA       (rpSA),
      .sdADDR     (rpSDADDR),
      .done       ()
   );

   //
   // Disk Motion Simlation State Machine
   //

   reg [ 1: 0] rpSDOP;                  // SD Operation
   reg [24: 0] delay;                   // RPxx Delay Simulation
   reg [ 9: 0] rpCCA;                   // Current Cylinder Address
   reg [ 9: 0] tempCYL;                 // Temporary Cylinder

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             delay  <= 0;
             rpCCA  <= 0;
             rpSDOP <= `sdopNOP;
             state  <= stateIDLE;
          end
        else
          begin
             if (clr)
               begin
                  delay  <= 0;
                  rpCCA  <= 0;
                  rpSDOP <= `sdopNOP;
                  state  <= stateIDLE;
               end
             else
               case (state)

                 //
                 // stateIDLE
                 //  Look for a function (command) to go process
                 //

                 stateIDLE:
                   begin
                      if (cmdGO)

                        //
                        // Decode Command (Function)
                        //

                        case (`rpCS1_FUN(rpDATAI))

                          //
                          // NOP Command
                          //  Does nothing
                          //

                          `funNOP:
                            begin
                               if (rpERR)
                                 state <= stateILLFUN;
                               else
                                 state <= stateDONE;
                            end

                          //
                          // Unload Head Command
                          //  On an RPxx disk, the seek command would cause the
                          //  heads to retract. This command simulates head
                          //  motion to cylinder 0.
                          //

                          `funUNLOAD:
                            begin
                               if (rpERR)
                                 state <= stateILLFUN;
                               else
                                 begin
                                    tempCYL <= 0;
                                    delay   <= seekDELAY(0, rpCCA);
                                    state   <= stateSEEK;
                                 end
                            end

                          //
                          // Seek Command
                          //  On an RPxx disk, the seek command causes the heads
                          //  to move to the cylinder specified by the RPDC
                          //  register.
                          //
                          //  This command simulates head motion to the new
                          //  cylinder specified by the RPDC register
                          //

                          `funSEEK:
                            begin
                               if (rpERR)
                                 state <= stateILLFUN;
                               else if ((rpDCA <= lastCYL)  |
                                        (rpTA <= lastTRACK) |
                                        (rpSA <= lastSECTOR))
                                 begin
                                    tempCYL <= rpDCA;
                                    delay   <= seekDELAY(rpDCA, rpCCA);
                                    state   <= stateSEEK;
                                 end
                               else
                                 state <= stateINVADDR;
                            end

                          //
                          // Recalibrate Command
                          //  The seek command causes the heads to move to
                          //  cylinder 0.
                          //

                          `funRECAL:
                            begin
                               if (rpERR)
                                 state <= stateILLFUN;
                               else
                                 begin
                                    tempCYL <= 0;
                                    delay   <= seekDELAY(0, rpCCA);
                                    state   <= stateSEEK;
                                 end
                            end

                          //
                          // Drive Clear Command
                          //

                          `funCLEAR:
                            begin
                               state <= stateCLEAR;
                            end

                          //
                          // Port Release Command
                          //  This command does nothing.
                          //

                          `funRELEASE:
                            begin
                               if (rpERR)
                                 state <= stateILLFUN;
                               else
                                 state <= stateDONE;
                            end

                          //
                          // Offset Comand
                          //  On an RPxx disk, the offset command moves the
                          //  heads off the track centerline as specfied by the
                          //  RPOF register either toward the spindle or away
                          //  from the spindle.
                          //
                          //  This command does nothing.
                          //

                          `funOFFSET:
                            begin
                               state <= stateATA;
                            end

                          //
                          // Return to Centerline Command.
                          //
                          // On an RPxx disk, this command would return the
                          // heads back to the centerline of the track.
                          //
                          // This command does nothing.
                          //

                          `funCENTER:
                            begin
                               if (rpERR)
                                 state <= stateILLFUN;
                               else
                                 state <= stateATA;
                            end

                          //
                          // Read-in Preset Command
                          //

                          `funPRESET:
                            begin
                               if (rpERR)
                                 state <= stateILLFUN;
                               else
                                 state <= statePRESET;
                            end

                          //
                          // Pack Acknowldege Command
                          //

                          `funPAKACK:
                            begin
                               if (rpERR)
                                 state <= stateILLFUN;
                               else
                                 state <= statePAKACK;
                            end

                          //
                          // Search Command
                          //
                          //  On an RPxx disk, The search command compares the
                          //  actual sector address with the requested sector
                          //  address.  When they match, the adapter asserts
                          //  the attention line.
                          //
                          //  This command behaves exactly the same as a seek
                          //  command.
                          //

                          `funSEARCH:
                            begin
                               if (rpERR)
                                 state <= stateILLFUN;
                               else if ((rpDCA <= lastCYL)   |
                                        (rpTA  <= lastTRACK) |
                                        (rpSA  <= lastSECTOR))
                                 begin
                                    tempCYL <= rpDCA;
                                    delay   <= seekDELAY(rpDCA, rpCCA);
                                    state   <= stateSEEK;
                                 end
                               else
                                 state <= stateINVADDR;
                            end

////////////////////////////////////////////////////////////////////////////////

                          //
                          // Write Check Commands
                          //

                          `funWRCHK,
                          `funWRCHKH:
                            begin
                               if (rpERR)
                                 state <= stateILLFUN;
                               else
                                 begin
                                    if (simTIME)
                                      begin
                                         delay <= fiveMS;
                                      end
                                    else
                                  begin
                                     delay <= oneUS;
                                  end
                                    rpSDOP <= `sdopWRCHK;
                                    state  <= stateROTDLY;
                                 end
                            end

                          //
                          // Write Commands
                          //

                          `funWRITE,
                          `funWRITEH:
                            begin
                               if (rpERR)
                                 state <= stateILLFUN;
                               else if (rpWP)
                                 state <= stateWRLOCK;
                               else
                                 begin
                                    if (simTIME)
                                      begin
                                         delay <= fiveMS;
                                      end
                                    else
                                      begin
                                         delay <= oneUS;
                                      end
                                    rpSDOP <= `sdopWR;
                                    state  <= stateROTDLY;
                                 end
                            end

                          //
                          // Read Commands
                          //

                          `funREAD,
                          `funREADH:
                            begin
                               if (rpERR)
                                 state <= stateILLFUN;
                               else
                                 begin
                                    if (simTIME)
                                      begin
                                         delay <= fiveMS;
                                      end
                                    else
                                      begin
                                         delay <= oneUS;
                                      end
                                    rpSDOP <= `sdopRD;
                                    state  <= stateROTDLY;
                                 end
                            end

                          //
                          // Functions that don't exist
                          //

                          default:
                            begin
                               state <= stateILLFUN;
                            end
                        endcase
                   end

                 //
                 // stateSEEK
                 //  This state starts the SD Address Calculation
                 //

                 stateSEEK:
                   begin
                      state <= stateSEEKDLY;
                   end

                 //
                 // stateSEEKDLY
                 //
                 //  Simulate Seek Timing on Seek Commands.  Update Current
                 //  Cylinder Address after delay.
                 //

                 stateSEEKDLY:
                   begin
                      if (delay == 0)
                        begin
                           rpCCA <= tempCYL;
                           state <= stateATA;
                        end
                      else
                        delay <= delay - 1'b1;
                   end

                 //
                 // stateROTDLY:
                 //
                 //  Simulate Rotation Latency on Reads/Writes
                 //

                 stateROTDLY:
                   begin
                      if (delay == 0)
                        state <= stateWAITSD;
                      else
                        delay <= delay - 1'b1;
                   end

                 //
                 // stateWAITSD:
                 //
                 //  Wait for SD to handle Read/Write operaton
                 //

                 stateWAITSD:
                   begin
                      if (rpSDACK)
                        begin
                           state <= stateDONE;
                        end
                   end

                 //
                 // stateCLEAR
                 //
                 //  This state modifies the bits that occur when Clear Command
                 //  function is executed.
                 //

                 stateCLEAR:
                   state <= stateDONE;

                 //
                 // statePRESET
                 //
                 //  This state modifies the bits that occur when Preset Command
                 //  function is executed.
                 //

                 statePRESET:
                   state <= stateDONE;

                 //
                 // stateOFFSET
                 //
                 //  This state modifies the bits that occur when Offset Command
                 //  function is executed.
                 //

                 stateOFFSET:
                   state <= stateDONE;

                 //
                 // stateCENTER
                 // This state modifies the bits that occur
                 // when Return Command function is executed.
                 //

                 stateCENTER:
                   state <= stateDONE;

                 //
                 // statePAKACK
                 // This state modifies the bits that occur
                 // when Pack Acknowledge Command function
                 // is executed.
                 //

                 statePAKACK:
                   state <= stateDONE;

                 //
                 // stateILLFUN
                 // This state modifies the bits that occur
                 // when an illegal function is executed.
                 //

                 stateILLFUN:
                   state <= stateDONE;

                 //
                 // stateINVADDR
                 // This state modifies the bits that occur
                 // when an invalid seek error is provided.
                 //

                 stateINVADDR:
                   state <= stateDONE;

                 //
                 // stateWRLOCK
                 // This state modifies the bits that occur
                 // when a write-locked disk is written to
                 //

                 stateWRLOCK:
                   state <= stateDONE;

                 //
                 // stateATA
                 // This state sets the RPDS[ATA] bit.
                 //

                 stateATA:
                   state <= stateDONE;

                 //
                 // stateDONE:
                 //  Update the disk state
                 //

                 stateDONE:
                   begin
                      rpSDOP <= `sdopNOP;
                      state  <= stateIDLE;
                   end

                 //
                 // Everything else
                 //

                 default:
                   state <= stateIDLE;

               endcase
          end
     end

   assign rpCC    = {6'b0, rpCCA};
   assign rpDT    = drvTYPE;
   assign rpSDREQ = (state == stateWAITSD);

endmodule
