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
`include "../../../ks10.vh"

module RPCTRL (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire         clr,                  // Clr
      input  wire         rpCMDGO,              // Go command
      input  wire [ 5: 1] rpCMDFUN,             // Function
      output wire         rpADRSTRT,            // Address calculation start
      input  wire         rpADRBUSY,            // Address calculation busy
      output reg          rpPIP,                // Positioning-in-progress
      output reg          rpDRY,                // Drive ready
      input  wire         rpSETWLE,             // Write lock error
      input  wire         rpSETIAE,             // Invalid address error
      output wire         rpccWRITE,            // Update RPCC
      output reg          rpSETATA,             // Set ATA
      output reg  [ 1: 0] rpSDOP,               // SD operation
      output wire         rpSDREQ,              // SD request
      input  wire         rpSDACK,              // SD acknowledge
      input  wire [ 9: 0] rpDCA,                // Desired cylinder
      input  wire [ 9: 0] rpCCA                 // Current cylinder
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
   // State Definition
   //

   localparam [4:0] stateIDLE    =  0,
                    stateSEEK    =  1,
                    stateSEEKDLY =  2,
                    stateSEEKEND =  3,
                    stateROTDLY  =  4,
                    stateWAITACK =  5,
                    stateDONE    = 31;

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
             delay    <= 0;
             rpSDOP   <= `sdopNOP;
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
                  delay    <= 0;
                  rpSDOP   <= `sdopNOP;
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

                      if (rpCMDGO)

                        //
                        // Decode Command (Function)
                        //

                        case (rpCMDFUN)

                          //
                          // Unload Head Command
                          //  On an RPxx disk, the seek command would cause the
                          //  heads to retract. This command simulates head
                          //  motion to cylinder 0.
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
                               state <= stateSEEK;
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
                               ata    <= 1;
                               busy   <= 1;
                               rpPIP  <= 1;
                               rpSDOP <= `sdopNOP;
                               if (simTIME)
                                 delay <= seekDELAY(rpDCA, rpCCA);
                               else
                                 delay <= $rtoi(FIXDELAY);
                               state <= stateSEEK;
                            end

                          //
                          // Recalibrate Command
                          //  The seek command causes the heads to move to
                          //  cylinder 0.
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
                               state <= stateSEEK;
                            end

                          //
                          // Search Command
                          //  A search command may have to perform an implied
                          //  seek before before performing the search
                          //  operation.
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
                                  state <= stateSEEK;
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
                               state <= stateSEEK;
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
                               state <= stateSEEK;
                            end

                          //
                          // Write Check Commands
                          //  A write check command may have to perform an
                          //  implied seek before before performing the write
                          //  check operation.
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
                                    state  <= stateSEEK;
                                 end
                            end

                          //
                          // Write Commands
                          //  A write command may have to perform an implied
                          //  seek before before performing the write operation.
                          //

                          `funWRITE,
                          `funWRITEH:
                            begin
                               if (!rpSETIAE && !rpSETWLE)
                                 begin
                                    ata    <= 0;
                                    busy   <= 1;
                                    rpPIP  <= 0;
                                    rpSDOP <= `sdopWR;
                                    if (simTIME)
                                      delay <= seekDELAY(rpDCA, rpCCA);
                                    else
                                      delay <= $rtoi(FIXDELAY);
                                    state  <= stateSEEK;
                                 end
                            end

                          //
                          // Read Commands
                          //  A read command may have to perform an implied
                          //  seek before before performing the read operation.
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
                                    state  <= stateSEEK;
                                 end
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
                 //  Simulate Seek Timing on Seek Commands.
                 //
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
                 //  Wait for SD to handle Read/Write operaton
                 //

                 stateWAITACK:
                   begin
                      if (rpSDACK)
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
   //  Don't negate rpDRY while GO is asserted
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpDRY <= 1;
        else
          rpDRY <= !busy | rpCMDGO;
     end

   //
   // State decode
   //

   assign rpSDREQ   = (state == stateWAITACK);
   assign rpADRSTRT = (state == stateSEEK);
   assign rpccWRITE = (state == stateSEEKEND);

endmodule
