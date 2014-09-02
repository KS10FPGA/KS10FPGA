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
`include "sd/sd.vh"
`include "rpda.vh"
`include "rpds.vh"
`include "rpof.vh"
`include "rpcs1.vh"
`include "rper1.vh"
`include "../ubabus.vh"

module RPXX(clk, rst,
            unitSEL, incSECTOR, rhCLR, ataCLR,
            devRESET, devADDRI, rhDATAI, rpCD, rpWP,
            rpDA, rpDS, rpER1, rpLA, rpMR, rpOF, rpDC, rpCC,
            rpFUN, rpGO, rpSDOP, rpSDREQ, rpSDACK, rpSDADDR);

   input          clk;                          // Clock
   input          rst;                          // Reset
   input          unitSEL;                      // Unit Select
   input          incSECTOR;                    // Increment Sector
   input          rhCLR;                        // Clear
   input          ataCLR;                       // Clear RPDS[ATA]
   input          devRESET;                     // Device Reset
   input  [ 0:35] devADDRI;                     // Device Address In
   input  [35: 0] rhDATAI;                      // Data In
   input          rpCD;                         // Card Detect from SD Card
   input          rpWP;                         // Write Protect from SD Card
   output [15: 0] rpDA;                         // DA  Register
   output [15: 0] rpDS;                         // DS  Register
   output [15: 0] rpER1;                        // ER1 Register
   output [15: 0] rpLA;                         // LA  Register
   output [15: 0] rpMR;                         // MR  Register
   output [15: 0] rpOF;                         // OF  Register
   output [15: 0] rpDC;                         // DC  Register
   output [15: 0] rpCC;                         // CC  Register
   output [ 5: 1] rpFUN;                        // CS1[FUN] Register
   output         rpGO;                         // CS1[GO]  Register
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

   localparam [24:0] fiveMS = 100000;           // 5 milliseconds
   localparam [24:0] oneUS  = 50;               // 1 microsecond

   //
   // Lookup Drive Geometries
   //

   localparam [4:0] lastSECT = `getLASTSECT(drvTYPE);
   localparam [4:0] lastSURF = `getLASTSURF(drvTYPE);
   localparam [9:0] lastCYL  = `getLASTCYL (drvTYPE);

   //
   // Device Address and Flags
   //

   wire         devREAD   = `devREAD(devADDRI);         // Read Cycle (IO or Memory)
   wire         devWRITE  = `devWRITE(devADDRI);        // Write Cycle (IO or Memory)
   wire         devIO     = `devIO(devADDRI);           // IO Cycle
   wire         devIOBYTE = `devIOBYTE(devADDRI);       // Byte IO Operation
   wire [14:17] devDEV    = `devDEV(devADDRI);          // Device Number
   wire [18:34] devADDR   = `devADDR(devADDRI);         // Device Address
   wire         devHIBYTE = `devHIBYTE(devADDRI);       // Device Hi byte select
   wire         devLOBYTE = `devLOBYTE(devADDRI);       // Device Lo byte select

   //
   // Register Decode
   //

   wire rpcsWRITE = devWRITE & devIO & (devDEV == rhDEV) & (devADDR == cs1ADDR[18:34]);
   wire rpdaWRITE = devWRITE & devIO & (devDEV == rhDEV) & (devADDR ==  daADDR[18:34]);
   wire rperWRITE = devWRITE & devIO & (devDEV == rhDEV) & (devADDR == er1ADDR[18:34]);
   wire rpofWRITE = devWRITE & devIO & (devDEV == rhDEV) & (devADDR ==  ofADDR[18:34]);
   wire rpdcWRITE = devWRITE & devIO & (devDEV == rhDEV) & (devADDR ==  dcADDR[18:34]);

   //
   // Function to calculate disk seek delay
   // The RP06 has 815 cyclinders
   //

   function [24:0] seekDELAY;
      input [9:0] newCYL;               // New Cylinder
      input [9:0] oldCYL;               // Old Cylinder
      reg   [9:0] diffCYL;              // Distance between Cylinders

      begin

         diffCYL = (newCYL > oldCYL) ? newCYL - oldCYL : oldCYL - newCYL;

         if (diffCYL < 1)
           seekDELAY = 0;               //  0 ms, Same cylinder
         else if (diffCYL < 1)
           seekDELAY = fiveMS * 1;      //  5 ms
         else if (diffCYL < 2)
           seekDELAY = fiveMS * 2;      // 10 ms
         else if (diffCYL < 3)
           seekDELAY = fiveMS * 3;      // 15 ms
         else if (diffCYL < 7)
           seekDELAY = fiveMS * 4;      // 20 ms
         else if (diffCYL < 13)
           seekDELAY = fiveMS * 5;      // 25 ms
         else if (diffCYL < 25)
           seekDELAY = fiveMS * 6;      // 30 ms
         else if (diffCYL < 50)
           seekDELAY = fiveMS * 7;      // 35 ms
         else if (diffCYL < 100)
           seekDELAY = fiveMS * 8;      // 40 ms
         else if (diffCYL < 200)
           seekDELAY = fiveMS * 9;      // 45 ms
         else if (diffCYL < 400)
           seekDELAY = fiveMS * 10;     // 50 ms
         else
           seekDELAY = fiveMS * 11;     // 55 ms
      end
   endfunction

   //
   // rpGO
   //

   wire cmdGO = devLOBYTE & devWRITE & devIO & (devDEV == rhDEV) & (devADDR == cs1ADDR[18:34]) & `rpCS1_GO(rhDATAI);

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
                    stateRETURN  =  7,
                    statePRESET  =  8,
                    statePAKACK  =  9,
                    stateILLFUN  = 10,
                    stateINVADDR = 11,
                    stateWRLOCK  = 12,
                    stateATA     = 13,
                    stateDONE    = 31;
   reg [ 4: 0] state;                   // RPxx State

   //
   // RPxx Control/Status (RPCS1) Register
   //

   reg       rpGO;
   reg [5:1] rpFUN;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             rpGO  <= 0;
             rpFUN <= 0;
          end
        else
          begin
             if (rhCLR | devRESET)
               begin
                  rpGO  <= 0;
                  rpFUN <= 0;
               end
             else if (rpcsWRITE & unitSEL & rpDRY & devLOBYTE)
               begin
                  rpFUN <= `rpCS1_FUN(rhDATAI);
                  rpGO  <= `rpCS1_GO (rhDATAI);
               end
             else if (state == stateDONE)
               rpGO <= 0;
          end
     end

   //
   // RPxx Disk Address (RPDA) Register
   //
   // Details
   //  The disk address is incremented after the sector has been
   //  transferred to the controller
   //

   reg  [2:0] rpTAS;
   reg  [4:0] rpTA;
   reg  [2:0] rpSAS;
   reg  [4:0] rpSA;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             rpTAS <= 0;
             rpTA  <= 0;
             rpSAS <= 0;
             rpSA  <= 0;
          end
        else
          begin
             if (rhCLR | devRESET | (state == statePRESET))
               begin
                  rpTAS <= 0;
                  rpTA  <= 0;
                  rpSAS <= 0;
                  rpSA  <= 0;
               end
             else if (rpdaWRITE & unitSEL & rpDRY)
               begin
                  if (devHIBYTE)
                    begin
                       rpTAS <= `rpDA_TAS(rhDATAI);
                       rpTA  <= `rpDA_TA (rhDATAI);
                    end
                  if (devLOBYTE)
                    begin
                       rpSAS <= `rpDA_SAS(rhDATAI);
                       rpSA  <= `rpDA_SA (rhDATAI);
                    end
               end
             else if (incSECTOR & unitSEL)
               begin
                  if (rpSA == lastSECT)
                    begin
                       if (rpTA == lastSURF)
                         rpTA <= 0;
                       else
                         begin
                            rpSA <= 0;
                            rpTA <= rpTA + 1'b1;
                         end
                    end
                  else
                    rpSA <= rpSA + 1'b1;
               end
          end
     end

   assign rpDA  = {rpTAS, rpTA, rpSAS, rpSA};

   //
   // RPxx Disk Status (RPDS) Register
   //

   reg rpATA;
   reg rpLST;
   reg rpVV;
   reg rpOM;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             rpATA <= 0;
             rpLST <= 0;
             rpVV  <= 0;
             rpOM  <= 0;
          end
        else
          begin
             if (rhCLR | devRESET)
               begin
                  rpATA <= 0;
                  rpLST <= 0;
                  rpVV  <= 0;
                  rpOM  <= 0;
               end
             else if (ataCLR)
               rpATA <= 0;
             else
               begin
                  if (incSECTOR & unitSEL & (rpSA == lastSECT))
                    rpLST <= 1;
                  else if (rpdaWRITE & unitSEL)
                    rpLST <= 0;
               end
             case (state)
               stateIDLE:
                 rpVV <= rpVV & rpCD;
               stateATA:
                 rpATA <= 1;
               stateCLEAR:
                 rpATA <= 0;
               statePRESET:
                 rpVV <= rpCD;
               stateOFFSET:
                 rpOM <= 1;
               stateRETURN:
                 rpOM <= 0;
               statePAKACK:
                 rpVV <= rpCD;
             endcase
          end
     end

   wire rpERR  = (rpER1 != 0);
   wire rpPIP  = (state == stateSEEKDLY);
   wire rpMOL  = rpCD;
   wire rpWRL  = rpWP;
   wire rpPGM  = 0;
   wire rpDPR  = 1;
   wire rpDRY  = (state != stateIDLE);
   assign rpDS = {rpATA, rpERR, rpPIP, rpMOL, rpWRL, rpLST,
                  rpPGM, rpDPR, rpDRY, rpVV,  5'b0,  rpOM};

   //
   // RPxx Error #1 (RPER1) Register
   //  This register is not byte addressable.
   //

   reg rpDCK;
   reg rpUNS;
   reg rpOPI;
   reg rpDTE;
   reg rpWLE;
   reg rpIAE;
   reg rpAOE;
   reg rpHCRC;
   reg rpHCE;
   reg rpECH;
   reg rpWCF;
   reg rpFER;
   reg rpPAR;
   reg rpRMR;
   reg rpILR;
   reg rpILF;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             rpDCK  <= 0;
             rpUNS  <= 0;
             rpOPI  <= 0;
             rpDTE  <= 0;
             rpWLE  <= 0;
             rpIAE  <= 0;
             rpAOE  <= 0;
             rpHCRC <= 0;
             rpHCE  <= 0;
             rpECH  <= 0;
             rpWCF  <= 0;
             rpFER  <= 0;
             rpPAR  <= 0;
             rpRMR  <= 0;
             rpILR  <= 0;
             rpILF  <= 0;
          end
        else
          if (rhCLR | devRESET | (state == statePRESET))
            begin
               rpDCK  <= 0;
               rpUNS  <= 0;
               rpOPI  <= 0;
               rpDTE  <= 0;
               rpWLE  <= 0;
               rpIAE  <= 0;
               rpAOE  <= 0;
               rpHCRC <= 0;
               rpHCE  <= 0;
               rpECH  <= 0;
               rpWCF  <= 0;
               rpFER  <= 0;
               rpPAR  <= 0;
               rpRMR  <= 0;
               rpILR  <= 0;
               rpILF  <= 0;
            end
          else if (rperWRITE & unitSEL & rpDRY)
            begin
               rpDCK  <= `rpER1_DCK(rhDATAI);
               rpUNS  <= `rpER1_UNS(rhDATAI);
               rpOPI  <= `rpER1_OPI(rhDATAI);
               rpDTE  <= `rpER1_DTE(rhDATAI);
               rpWLE  <= `rpER1_WLE(rhDATAI);
               rpIAE  <= `rpER1_IAE(rhDATAI);
               rpAOE  <= `rpER1_AOE(rhDATAI);
               rpHCRC <= `rpER1_HCRC(rhDATAI);
               rpHCE  <= `rpER1_HCE(rhDATAI);
               rpECH  <= `rpER1_ECH(rhDATAI);
               rpWCF  <= `rpER1_WCF(rhDATAI);
               rpFER  <= `rpER1_FER(rhDATAI);
               rpPAR  <= `rpER1_PAR(rhDATAI);
               rpRMR  <= `rpER1_RMR(rhDATAI);
               rpILR  <= `rpER1_ILR(rhDATAI);
               rpILF  <= `rpER1_ILF(rhDATAI);
            end
          else
            begin

               if (incSECTOR & (rpDC == lastCYL) & (rpTA == lastSURF) & (rpSA == lastSECT) & unitSEL)
                 rpAOE <= 1;

               if (~rpDRY & unitSEL)
                 if (rpcsWRITE | rperWRITE | rpdaWRITE |  rpofWRITE | rpdcWRITE)
                   rpRMR <= 1;

               if (devWRITE & unitSEL & devIO & (devDEV == rhDEV) & (devADDR >= undADDR[18:34]))
                 rpILR <= 1;

               case (state)
                 stateWRLOCK:
                   rpWLE <= 1;
                 stateINVADDR:
                   rpIAE <= 1;
                 stateILLFUN:
                   rpILF <= 1;
               endcase
            end
     end

   assign rpER1 = {rpDCK, rpUNS, rpOPI, rpDTE, rpWLE, rpIAE, rpAOE, rpHCRC,
                   rpHCE, rpECH, rpWCF, rpFER, rpPAR, rpRMR, rpILR, rpILF};

   //
   // RPxx Look Ahead (RPLA) Register
   //

   assign rpLA = {5'b0, rpSA, 6'b0};

   //
   // RPxx Maintenance Register
   //

   assign rpMR = 16'b0;

   //
   // RPxx Offset (RPOF) Register
   //

   reg rpF16;
   reg rpECI;
   reg rpHCI;
   reg rpOFD;
   reg [6:0] rpOFS;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             rpF16 <= 0;
             rpECI <= 0;
             rpHCI <= 0;
             rpOFD <= 0;
             rpOFS <= 0;
          end
        else
          begin
             if (rhCLR | devRESET | (state == statePRESET))
               begin
                  rpF16 <= 0;
                  rpECI <= 0;
                  rpHCI <= 0;
                  rpOFD <= 0;
                  rpOFS <= 0;
               end
             else if (rpofWRITE & unitSEL & rpDRY)
               begin
                  if (devHIBYTE)
                    begin
                       rpF16 <= `rpOF_F16(rhDATAI);
                       rpECI <= `rpOF_ECI(rhDATAI);
                       rpHCI <= `rpOF_HCI(rhDATAI);
                    end
                  if (devLOBYTE)
                    begin
                       rpOFD <= `rpOF_OFD(rhDATAI);
                       rpOFS <= `rpOF_OFS(rhDATAI);
                    end
               end
          end
     end

   assign rpOF = {3'b0, rpF16, rpECI, rpHCI, 2'b0, rpOFD, rpOFS};

   //
   // RPxx Desired Cylinder (RPDC) Register
   //

   reg [9:0] rpDCA;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpDCA <= 0;
        else
          begin
             if (rhCLR | devRESET | (state == statePRESET))
               rpDCA <= 0;
             else if (rpdcWRITE & unitSEL & rpDRY)
               begin
                  if (devHIBYTE)
                    rpDCA[9:8] <= rhDATAI[9:8];
                  if (devLOBYTE)
                    rpDCA[7:0] <= rhDATAI[7:0];
               end
             else if (incSECTOR & unitSEL & (rpTA == lastSURF) & (rpSA == lastSECT))
               rpDCA <= rpDCA + 1'b1;
          end
     end

   assign rpDC = {6'b0, rpDCA};

   //
   // SD Sector Address Calculation
   //

   wire [31:0] rpSDADDR;
   SDADDR uSDADDR
     (.clk      (clk),
      .rst      (rst),
      .start    (state == stateSEEK),
      .lastSURF (lastSECT),
      .lastSECT (lastSURF),
      .rpDCA    (rpDCA),
      .rpTA     (rpTA),
      .rpSA     (rpSA),
      .sdADDR   (rpSDADDR)
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
        if (rst | rhCLR | devRESET)
          begin
             state    <= stateIDLE;
             rpSDOP   <= `sdopNOP;
             delay    <= 0;
             rpCCA    <= 0;
          end
        else
          begin
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

                    case (rhDATAI[6:0])

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
                      //  On an RPxx disk, the seek command would
                      //  cause the heads to retract. This command
                      //  simulates head motion to cylinder 0.
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
                      //  On an RPxx disk, the seek command causes
                      //  the heads to move to the cylinder
                      //  specified by the RPDC register.
                      //
                      //  This command simulates head motion to
                      //  to the new cylinder specified by the RPDC
                      //  register
                      //

                      `funSEEK:
                        begin
                           if (rpERR)
                             state <= stateILLFUN;
                           else if ((rpDCA <= lastCYL) | (rpTA <= lastSURF) | (rpSA <= lastSECT))
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
                      //  The seek command causes the heads to move
                      //  to cylinder 0.
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
                      // Device Clear Command
                      //

                      `funCLEAR:
                        begin
                           state <= stateCLEAR;
                        end

                      //
                      // Port Release Command
                      //  This command does nothing
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
                      //  On an RPxx disk, the offset command moves
                      //  the heads off the track centerline 250
                      //  microinches either toward the spindle or
                      //  away from the spindle.
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
                      // On an RPxx disk, this command would return
                      // the heads to the centerline of the track.
                      //
                      // This command does nothing.
                      //

                      `funRETURN:
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
                      //  On an RPxx disk, The search command
                      //  compares the actual sector address with
                      //  the requested sector address.  When they
                      //  match, the adapter asserts the attention
                      //  line.
                      //
                      //  This command behaves exactly the same as
                      //  a seek command.
                      //

                      `funSEARCH:
                        begin
                           if (rpERR)
                             state <= stateILLFUN;
                           else if ((rpDCA <= lastCYL) | (rpTA <= lastSURF) | (rpSA <= lastSECT))
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
                      // Write Commands
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
               //  Simulate Seek Timing on Seek Commands.
               //  Update Current Cylinder Address after delay.
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
               // This state modifies the bits that occur
               // when Clear Command function is executed.
               //

               stateCLEAR:
                 state <= stateDONE;

               //
               // statePRESET
               // This state modifies the bits that occur
               // when Preset Command function is executed.
               //

               statePRESET:
                 state <= stateDONE;

               //
               // stateOFFSET
               // This state modifies the bits that occur
               // when Offset Command function is executed.
               //

               stateOFFSET:
                 state <= stateDONE;

               //
               // stateRETURN
               // This state modifies the bits that occur
               // when Return Command function is executed.
               //

               stateRETURN:
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
   assign rpSDREQ = (state == stateWAITSD);

endmodule
