////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RPxx State Machine
//
// File
//   rpstatev
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

`include "rpmr.vh"
`include "rpcs1.vh"
`include "../sd/sd.vh"
`include "../../ks10.vh"

module RPCTRL (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire         clr,                  // Clr
      input  wire [35: 0] rpDATAI,              // Data input
      input  wire         rpcs1WRITE,           // CS1 write
      input  wire [ 9: 0] rpDCA,                // Desired cylinder
      input  wire [ 9: 0] rpCCA,                // Current cylinder
      input  wire         rpDMD,                // Diagnostic Mode
      input  wire         rpPAT,                // Parity test
      output reg          rpPIP,                // Positioning-in-progress
      output reg          rpDRY,                // Drive ready
      input  wire         rpSETAOE,             // Address overflow error
      input  wire         rpSETIAE,             // Invalid address error
      input  wire         rpSETWLE,             // Write lock error
      output reg          rpSETATA,             // Set ATA
      output wire         rpADRSTRT,            // Address calculation start
      input  wire         rpADRBUSY,            // Address calculation busy
      output reg  [ 1: 0] rpSDOP,               // SD operation
      output wire         rpSDREQ,              // SD request
      input  wire         rpSDACK,              // SD acknowledge
      output wire         rpSEEKDONE            // Update RPCC
   );

   //
   // Timing Parameters
   //

   parameter  simTIME = 1'b0;                   // Simulate timing
   localparam CLKFRQ  = `CLKFRQ;                // Clock frequency
   localparam ROTDELAY = 0.005000 * `CLKFRQ;    // Rotation delay (5 ms)
   localparam FIXDELAY = 0.000100 * `CLKFRQ;    // Fixed delay (100 us)

   //
   // Function to calculate disk seek delay.  This is psudeo exponential.
   // The RP06 has 815 cyclinders
   //

   function [24:0] seekDELAY;
      input [9:0] newCYL;                       // New Cylinder
      input [9:0] oldCYL;                       // Old Cylinder
      reg   [9:0] diffCYL;                      // Distance between Cylinders
      begin
         diffCYL = (newCYL > oldCYL) ? newCYL - oldCYL : oldCYL - newCYL;
         if (diffCYL[9])
           seekDELAY = $rtoi(0.05000 * CLKFRQ); // 50 ms (more than 512 cylinders away)
         else if (diffCYL[8])
           seekDELAY = $rtoi(0.04500 * CLKFRQ); // 45 ms (more than 256 cylinders away)
         else if (diffCYL[7])
           seekDELAY = $rtoi(0.04000 * CLKFRQ); // 40 ms (more than 128 cylinders away)
         else if (diffCYL[6])
           seekDELAY = $rtoi(0.03500 * CLKFRQ); // 35 ms (more than  64 cylinders away)
         else if (diffCYL[5])
           seekDELAY = $rtoi(0.03000 * CLKFRQ); // 30 ms (more than  32 cylinders away)
         else if (diffCYL[4])
           seekDELAY = $rtoi(0.02500 * CLKFRQ); // 25 ms (more than  16 cylinders away)
         else if (diffCYL[3])
           seekDELAY = $rtoi(0.02000 * CLKFRQ); // 20 ms (more than   8 cylinders away)
         else if (diffCYL[2])
           seekDELAY = $rtoi(0.01500 * CLKFRQ); // 15 ms (more than   4 cylinders away)
         else if (diffCYL[1])
           seekDELAY = $rtoi(0.01000 * CLKFRQ); // 10 ms (more than   2 cylinders away)
         else if (diffCYL[0])
           seekDELAY = $rtoi(0.00500 * CLKFRQ); //  5 ms (more than   1 cylinders away)
         else
           seekDELAY = $rtoi(0.000010 * CLKFRQ);//  10 us (same cylinder)
      end
   endfunction

   //
   // rpGO
   //
   // Commands are ignored with incorrect parity.
   //

   wire rpGO = !rpPAT & rpcs1WRITE & `rpCS1_GO(rpDATAI);

   //
   // State Definition
   //

   localparam [4:0] stateIDLE     =  0,
                    stateSEEKSTRT =  1,
                    stateSEEKDLY  =  2,
                    stateSEEKEND  =  3,
                    stateROTDLY   =  4,
                    stateWAITACK  =  5,
                    stateRECAL    =  6,
                    stateDONE     = 31;

   //
   // Disk Motion Simlation State Machine
   //

   reg ata;                                     // Do ATA at end
   reg busy;                                    // Drive busy
   reg [24: 0] delay;                           // RPxx Delay Simulation
   reg [ 4: 0] state;                           // State

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             ata      <= 0;
             busy     <= 0;
             rpPIP    <= 0;
             rpSETATA <= 0;
             rpSDOP   <= `sdopNOP;
             delay    <= 0;
             state    <= stateIDLE;
          end
        else
          begin
             if (clr)
               begin
                  ata      <= 0;
                  busy     <= 0;
                  rpPIP    <= 0;
                  rpSETATA <= 0;
                  rpSDOP   <= `sdopNOP;
                  delay    <= 0;
                  state    <= stateIDLE;
               end
             else
               case (state)

                 //
                 // stateIDLE
                 //  Look for a function (command) to go process
                 //

                 stateIDLE:
                   begin
                      ata      <= 0;
                      busy     <= 0;
                      rpPIP    <= 0;
                      rpSETATA <= 0;

                      //
                      // Don't execute commands with incorrect parity
                      //

                      if (!rpPAT & rpcs1WRITE & `rpCS1_GO(rpDATAI))

                        //
                        // Decode Command (Function)
                        //

                        case (`rpCS1_FUN(rpDATAI))

                          //
                          // Unload Command
                          //  On an RPxx disk, the unload command would unload the
                          //  heads, spin-down the disk, off-line the disk, allow
                          //  the operator to change the disk pack, on-line the
                          //  disk, spin-up the disk, and reload the heads.
                          //

                          `funUNLOAD:
                            begin
                               ata    <= 1;
                               busy   <= 1;
                               rpPIP  <= 1;
                               rpSDOP <= `sdopNOP;
                               if (simTIME)
                                 delay <= seekDELAY(0, rpCCA);
                               else
                                 delay <= $rtoi(FIXDELAY);
                               state <= stateSEEKSTRT;
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
                          //  The disk will not seek to an invalid address.
                          //

                          `funSEEK:
                            begin
                               if (!rpSETIAE & (rpDCA != rpCCA))
                                 begin
                                    ata    <= 1;
                                    busy   <= 1;
                                    rpPIP  <= 1;
                                    rpSDOP <= `sdopNOP;
                                    if (simTIME)
                                      delay <= seekDELAY(rpDCA, rpCCA);
                                    else
                                      delay <= $rtoi(FIXDELAY);
                                    state <= stateSEEKSTRT;
                                 end
                            end

                          //
                          // Recalibrate Command
                          //  The recalibrate command causes the heads to move
                          //  to cylinder 0.
                          //

                          `funRECAL:
                            begin
                               ata    <= 1;
                               busy   <= 1;
                               rpPIP  <= 1;
                               rpSDOP <= `sdopNOP;
                               if (simTIME)
                                 delay  <= seekDELAY(0, rpCCA);
                               else
                                 delay <= $rtoi(FIXDELAY);
                               state <= stateRECAL;
                            end

                          //
                          // Search Command
                          //  A search command may have to perform an implied
                          //  seek before before performing the search
                          //  operation.
                          //
                          //  The disk will not seek to an invalid address.
                          //

                          `funSEARCH:
                            begin
                               if (!rpSETIAE)
                                 begin
                                    ata    <= 1;
                                    busy   <= 1;
                                    rpPIP  <= 1;
                                    rpSDOP <= `sdopNOP;
                                    if (simTIME)
                                      delay <= seekDELAY(rpDCA, rpCCA);
                                    else
                                      delay <= $rtoi(FIXDELAY);
                                    state <= stateSEEKSTRT;
                                 end
                            end

                          //
                          // Offset Command
                          //

                          `funOFFSET:
                            begin
                               ata    <= 1;
                               busy   <= 1;
                               rpPIP  <= 1;
                               rpSDOP <= `sdopNOP;
                               if (simTIME)
                                 delay <= $rtoi(ROTDELAY);
                               else
                                 delay <= $rtoi(FIXDELAY);
                               state <= stateSEEKSTRT;
                            end

                          //
                          // Return-to-center Command
                          //

                          `funCENTER:
                            begin
                               ata    <= 1;
                               busy   <= 1;
                               rpPIP  <= 1;
                               rpSDOP <= `sdopNOP;
                               if (simTIME)
                                 delay <= $rtoi(ROTDELAY);
                               else
                                 delay <= $rtoi(FIXDELAY);
                               state <= stateSEEKSTRT;
                            end

                          //
                          // Write Check Commands
                          //  A write check command may have to perform an
                          //  implied seek before before performing the write
                          //  check operation.
                          //
                          //  The disk will not seek to an invalid address.
                          //

                          `funWRCHK,
                          `funWRCHKH:
                            begin
                               if (!rpSETIAE)
                                 begin
                                    ata    <= 0;
                                    busy   <= 1;
                                    rpPIP  <= 0;
                                    rpSDOP <= `sdopWRCHK;
                                    if (simTIME)
                                      delay <= seekDELAY(rpDCA, rpCCA);
                                    else
                                      delay <= $rtoi(FIXDELAY);
                                    state  <= stateSEEKSTRT;
                                 end
                            end

                          //
                          // Write Commands
                          //  A write command may have to perform an implied
                          //  seek before before performing the write operation.
                          //
                          //  The disk will not seek to an invalid address.
                          //

                          `funWRITE,
                          `funWRITEH:
                            begin
                               if (!rpSETIAE & !rpSETWLE)
                                 begin
                                    ata    <= 0;
                                    busy   <= 1;
                                    rpPIP  <= 0;
                                    rpSDOP <= `sdopWR;
                                    if (simTIME)
                                      delay <= seekDELAY(rpDCA, rpCCA);
                                    else
                                      delay <= $rtoi(FIXDELAY);
                                    state   <= stateSEEKSTRT;
                                 end
                            end

                          //
                          // Read Commands
                          //  A read command may have to perform an implied
                          //  seek before before performing the read operation.
                          //
                          //  The disk will not seek to an invalid address.
                          //

                          `funREAD,
                          `funREADH:
                            begin
                               if (!rpSETIAE)
                                 begin
                                    ata    <= 0;
                                    busy   <= 1;
                                    rpPIP  <= 0;
                                    rpSDOP <= `sdopRD;
                                    if (simTIME)
                                      delay <= seekDELAY(rpDCA, rpCCA);
                                    else
                                      delay <= $rtoi(FIXDELAY);
                                    state  <= stateSEEKSTRT;
                                 end
                            end

                        endcase
                   end

                 //
                 // stateSEEK
                 //  This state starts the SD Address Calculation
                 //

                 stateSEEKSTRT:
                   begin
                      state <= stateSEEKDLY;
                   end

                 //
                 // stateSEEKDLY
                 //
                 //  Simulate Seek Timing on Seek Commands.
                 //

                 stateSEEKDLY:
                   begin
                      if ((delay == 0) & !rpADRBUSY)
                        state <= stateSEEKEND;
                      else
                        delay <= delay - 1'b1;
                   end

                 //
                 // stateSEEKEND
                 //
                 //  Update Current Cylinder Address after delay.
                 //

                 stateSEEKEND:
                   begin
                      if (rpSDOP == `sdopNOP)
                        state <= stateDONE;
                      else
                        begin
                           if (simTIME)
                             delay <= $rtoi(ROTDELAY);
                           else
                             delay <= $rtoi(FIXDELAY);
                           state <= stateROTDLY;
                        end
                   end

                 //
                 // stateRECAL
                 //
                 // Don't update RPCC.  It was already zeroed.
                 //

                 stateRECAL:
                   begin
                      if (delay == 0)
                        state <= stateDONE;
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
                        state <= stateWAITACK;
                      else
                        delay <= delay - 1'b1;
                   end

                 //
                 // stateWAITACK:
                 //
                 //  Wait for SD to complete Read/Write operaton
                 //
                 //  The controller should abort on a invalid address when it
                 //  occurs on a mid-transfer seek.
                 //

                 stateWAITACK:
                   begin
                      if (rpSDACK | rpSETAOE)
                        state <= stateDONE;
                   end

                 //
                 // stateDONE:
                 //  Update the disk state
                 //

                 stateDONE:
                   begin
                      ata      <= 0;
                      busy     <= 0;
                      rpPIP    <= 0;
                      rpSETATA <= ata;
                      rpSDOP   <= `sdopNOP;
                      state    <= stateIDLE;
                   end

                 //
                 // Everything else
                 //

                 default:
                   state <= stateIDLE;

               endcase
          end
     end

   //
   // rpDRY
   //  Don't negate rpDRY while rpGO is asserted
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpDRY <= 1;
        else
          rpDRY <= !busy | rpGO;
     end

   //
   // State decode
   //

   assign rpSDREQ    = (state == stateWAITACK);
   assign rpADRSTRT  = (state == stateSEEKSTRT);
   assign rpSEEKDONE = (state == stateSEEKEND);

endmodule
