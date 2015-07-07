////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RPxx State Machine
//
// File
//   rpctrl.v
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

`include "rpda.vh"
`include "rpla.vh"
`include "rpmr.vh"
`include "rpcc.vh"
`include "rpdc.vh"
`include "rpcs1.vh"
`include "../sd/sd.vh"
`include "../../ks10.vh"

`define RPXX_SKI                                // Required to pass DSRPA test
`define RPXX_OPI                                // Required to pass DSRPA test
`define RPXX_DFE                                // Required to pass DSRPA test

module RPCTRL (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire         clr,                  // Clr
      input  wire [35: 0] rpDATAI,              // Data input
      input  wire         rpcs1WRITE,           // CS1 write
      input  wire [ 9: 0] rpCYLNUM,             // Number of cylinders
      input  wire [15: 0] rpLA,                 // Lookahead register
      input  wire [15: 0] rpDA,                 // Disk address
      input  wire [15: 0] rpDC,                 // Desired cylinder
      output reg  [15: 0] rpCC,                 // Current cylinder
      input  wire         rpDMD,                // Diagnostic Mode
      input  wire         rpDSCK,               // Diagnostic sector clock
      input  wire         rpDCLK,               // Diagnostic clock
      input  wire         rpDIND,               // Diagnostic index pulse
      input  wire         rpPAT,                // Parity test
      output reg          rpPIP,                // Positioning-in-progress
      output reg          rpDRY,                // Drive ready
      output reg          rpECE,                // ECC envelope
      output reg          rpDFE,                // Data field envelope
      input  wire         rpFMT22,              // 22 sector format (16-bit)
      input  wire         rpSETAOE,             // Set address overflow error
      input  wire         rpSETIAE,             // Set invalid address error
      input  wire         rpSETWLE,             // Set write lock error
      output reg          rpSETATA,             // Set attenation
      output wire         rpSETOPI,             // Set operation incomplete
      output reg          rpSETSKI,             // Set seek incomplete
      output reg          rpADRSTRT,            // Address calculation start
      input  wire         rpADRBUSY,            // Address calculation busy
      output reg  [ 2: 0] rpSDOP,               // SD operation
      output wire         rpSDREQ,              // SD request
      input  wire         rpSDACK               // SD acknowledge
   );

   //
   // Timing Parameters
   //

   parameter  simSEEK   = 1'b0;                 // Simulate seek accurately
   parameter  simSEARCH = 1'b1;                 // Simulate search accurately
   localparam CLKFRQ    = `CLKFRQ;              // Clock frequency
   localparam OFFDELAY  = 0.005000 * `CLKFRQ;   // Offset delay (5 ms)
   localparam FIXDELAY  = 0.000100 * `CLKFRQ;   // Fixed delay (100 us)

   //
   // Check for RPER3[SKI] error. A  SKI error occurs when you seek off the
   // edge of the disk.
   //
   // Force the disk to recalibrate (zero rpCC) on a SKI error.
   //

   task check_ski;
      begin
`ifdef RPXX_SKI
         if (rpDCA > rpCCA)
           begin
              if (rpDCA - rpCCA > rpCYLNUM - head_pos)
                begin
                   tmpCC    <= 0;
                   rpSETSKI <= 1;
                end
           end
         else
           begin
              if (rpCCA - rpDCA > head_pos)
                begin
                   tmpCC    <= 0;
                   rpSETSKI <= 1;
                end
           end
`endif
      end
   endtask;

   //
   // Function to calculate disk seek delay.  This is psudeo exponential.
   // The RP06 has 815 cyclinders
   //

   function [24:0] seekDELAY;
      input [9:0] newCYL;                       // New Cylinder
      input [9:0] oldCYL;                       // Old Cylinder
      reg   [9:0] diffCYL;                      // Distance between Cylinders
      begin
         if (simSEEK)
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
         else
           begin
              seekDELAY = $rtoi(FIXDELAY);
           end
      end
   endfunction
   
   //
   // rpDCA
   //

   wire [9:0] rpDCA = `rpDC_DCA(rpDC);

   //
   // rpCCA
   //

   wire [9:0] rpCCA = `rpCC_CCA(rpCC);

   //
   // Head position (cylinder)
   //
   // The head position can be unsynchronized from the DCA/CCA if a seek is
   // performed in maintenance mode: the DCA/CCA moves but the head does not.
   //

   reg  [9:0] head_pos;

   //
   // Desired Sector
   //

   wire [5:0] rpSA = `rpDA_SA(rpDA);

   //
   // RPLA Sector
   //

   wire [5:0] rpLAS = `rpLA_LAS(rpLA);

   //
   // Diagnostic clock
   //

   wire diag_clken;
   EDGETRIG MAINTCLK(clk, rst, 1'b1, 1'b1, rpDCLK, diag_clken);

   //
   // rpGO
   //
   // Commands are ignored with incorrect parity.
   //

   wire rpGO = !rpPAT & rpcs1WRITE & `rpCS1_GO(rpDATAI);

   //
   // State Definition
   //

   localparam [3:0] stateIDLE       =  0,       // Idle
                    stateOFFSET     =  1,	// Offset/center command
                    stateUNLOAD     =  2,	// Unload command
                    stateRECAL      =  3,	// Recalibrate command
                    stateSEEK       =  4,       // Seek
                    stateSEEKSEARCH =  5,       // Seek then search
                    stateSEARCH     =  6,       // Searching for sector
                    stateXFERHEADER =  7,       // Diagnostic transfer header
                    stateXFERDATA   =  8,       // Diagnostic transfer data
                    stateXFERECC    =  9,       // Diagnostic transfer ECC
                    stateXFERGAP    = 10,	// Diagnostic transfer data gap
                    stateDATA       = 11,       // Reading/writing data
                    stateDONE       = 12;       // Done

   //
   // Disk Motion Simlation State Machine
   //

   reg ata;                                     // Do ATA at end
   reg busy;                                    // Drive busy
   reg [24: 0] delay;                           // RPxx Delay Simulation
   reg [15: 0] tmpCC;                           // rpCC value when command completes
   reg [12: 0] bit_cnt;                         // Data bit counter
   reg [ 3: 0] state;                           // State

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             ata      <= 0;
             busy     <= 0;
             rpCC     <= 0;
             head_pos <= 0;
             rpPIP    <= 0;
             rpDFE    <= 0;
             rpECE    <= 0;
             rpSETATA <= 0;
             rpSETSKI <= 0;
             rpSDOP   <= `sdopNOP;
             bit_cnt  <= 0;
             delay    <= 0;
             tmpCC    <= 0;
             state    <= stateIDLE;
          end
        else
          begin
             if (clr)
               begin
                  ata      <= 0;
                  busy     <= 0;
                  rpCC     <= rpDC;
                  rpPIP    <= 0;
                  rpDFE    <= 0;
                  rpECE    <= 0;
                  rpSETATA <= 0;
                  rpSETSKI <= 0;
                  rpSDOP   <= `sdopNOP;
                  bit_cnt  <= 0;
                  delay    <= 0;
                  tmpCC    <= 0;
                  state    <= stateIDLE;
               end
             else
               begin
                  rpADRSTRT <= 0;
                  rpSETSKI  <= 0;
                  case (state)

                    //
                    // stateIDLE
                    //
                    // Look for a function (command) to go process
                    //

                    stateIDLE:
                      begin
                         ata      <= 0;
                         busy     <= 0;
                         rpPIP    <= 0;
                         rpSETATA <= 0;
                         tmpCC    <= 0;

                         //
                         // Wait for a GO command
                         //

                         if (rpGO)

                           //
                           // Decode Command (Function)
                           //

                           case (`rpCS1_FUN(rpDATAI))

                             //
                             // Unload Command
                             //
                             // On an RPxx disk, the unload command would unload
                             // the heads, spin-down the disk, off-line the
                             // disk, allow the operator to change the disk
                             // pack, on-line the disk, spin-up the disk, and
                             // reload the heads.
                             //

                             `funUNLOAD:
                               begin
                                  ata    <= 1;
                                  busy   <= 1;
                                  rpPIP  <= 1;
                                  rpSDOP <= `sdopNOP;
                                  delay  <= seekDELAY(0, rpCCA);
                                  state  <= stateUNLOAD;
                               end

                             //
                             // Seek Command
                             //
                             // On an RPxx disk, the seek command causes the
                             // heads to move to the cylinder specified by the
                             // RPDC register.
                             //
                             // The disk will not seek to an invalid address.
                             //
                             // The disk should not seek if DCY = CCY.  This is
                             // tested by DSPRA TST262.
                             //

                             `funSEEK:
                               begin
                                  if (!rpSETIAE & (rpDCA != rpCCA))
                                    begin
                                       ata    <= 1;
                                       busy   <= 1;
                                       rpPIP  <= 1;
                                       rpSDOP <= `sdopNOP;
                                       tmpCC  <= rpDC;
                                       delay  <= seekDELAY(rpDCA, rpCCA);
                                       check_ski();
                                       state  <= stateSEEK;
                                    end
                               end

                             //
                             // Recalibrate Command
                             //
                             // The recalibrate command causes the heads to move
                             // to cylinder 0.
                             //

                             `funRECAL:
                               begin
                                  ata    <= 1;
                                  busy   <= 1;
                                  rpPIP  <= 1;
                                  rpSDOP <= `sdopNOP;
                                  delay  <= seekDELAY(0, rpCCA);
                                  state  <= stateRECAL;
                               end

                             //
                             // Search Command
                             //
                             // A search command may have to perform an implied
                             // seek before before performing the search
                             // operation.
                             //
                             // The disk will not seek to an invalid address.
                             //
                             // The disk should not seek if DCY = CCY.  This is
                             // tested by DSPRA TST262.
                             //

                             `funSEARCH:
                               begin
                                  if (!rpSETIAE)
                                    begin
                                       ata    <= 1;
                                       busy   <= 1;
                                       rpPIP  <= 0;
                                       rpSDOP <= `sdopNOP;
                                       if (rpDCA == rpCCA)
                                         begin
                                            delay <= $rtoi(FIXDELAY);
                                            state <= stateSEARCH;
                                         end
                                       else
                                         begin
                                            tmpCC <= rpDC;
                                            delay <= seekDELAY(rpDCA, rpCCA);
                                            state <= stateSEEKSEARCH;
                                         end
                                    end
                               end

                             //
                             // Offset Command
                             //
                             // This command would offset the head from the
                             // centerline of the track.
                             //

                             `funOFFSET:
                               begin
                                  ata    <= 1;
                                  busy   <= 1;
                                  rpPIP  <= 1;
                                  rpSDOP <= `sdopNOP;
                                  if (simSEEK)
                                    delay <= $rtoi(OFFDELAY);
                                  else
                                    delay <= $rtoi(FIXDELAY);
                                  state <= stateOFFSET;
                               end

                             //
                             // Return-to-center command
                             //
                             // This command would return the head to the
                             // centerline of the track.
                             //

                             `funCENTER:
                               begin
                                  ata    <= 1;
                                  busy   <= 1;
                                  rpPIP  <= 1;
                                  rpSDOP <= `sdopNOP;
                                  if (simSEEK)
                                    delay <= $rtoi(OFFDELAY);
                                  else
                                    delay <= $rtoi(FIXDELAY);
                                  state <= stateOFFSET;
                               end

                             //
                             // Write check data command
                             //
                             // A write check command may have to perform an
                             // implied seek before before performing the write
                             // check operation.
                             //
                             // The disk will not seek to an invalid address.
                             //
                             // The disk should not seek if DCY = CCY.  This is
                             // tested by DSPRA TST262.
                             //

                             `funWRCHK:
                               begin
                                  if (!rpSETIAE)
                                    begin
                                       ata    <= 0;
                                       busy   <= 1;
                                       rpPIP  <= 0;
                                       rpSDOP <= `sdopWRCHK;
                                       rpADRSTRT <= 1;
                                       if (rpDCA == rpCCA)
                                         begin
                                            delay <= $rtoi(FIXDELAY);
                                            state <= stateSEARCH;
                                         end
                                       else
                                         begin
                                            tmpCC <= rpDC;
                                            delay <= seekDELAY(rpDCA, rpCCA);
                                            state <= stateSEEKSEARCH;
                                         end
                                    end
                               end

                             //
                             // Write check header and data command
                             //
                             // The disk should not seek if DCY = CCY.  This is
                             // tested by DSPRA TST262.
                             //

                             `funWRCHKH:
                               begin
                                  if (!rpSETIAE)
                                    begin
                                       ata    <= 0;
                                       busy   <= 1;
                                       rpPIP  <= 0;
                                       rpSDOP <= `sdopWRCHKH;
                                       rpADRSTRT <= 1;
                                       if (rpDCA == rpCCA)
                                         begin
                                            delay <= $rtoi(FIXDELAY);
                                            state <= stateSEARCH;
                                         end
                                       else
                                         begin
                                            tmpCC <= rpDC;
                                            delay <= seekDELAY(rpDCA, rpCCA);
                                            check_ski();
                                            state <= stateSEEKSEARCH;
                                         end
                                    end
                               end

                             //
                             // Write data command
                             //
                             // A write command may have to perform an implied
                             // seek before before performing the write
                             // operation.
                             //
                             // The disk will not seek to an invalid address.
                             //
                             // The disk should not seek if DCY = CCY.  This is
                             // tested by DSPRA TST262.
                             //

                             `funWRITE:
                               begin
                                  if (!rpSETIAE & !rpSETWLE)
                                    begin
                                       ata    <= 0;
                                       busy   <= 1;
                                       rpPIP  <= 0;
                                       rpSDOP <= `sdopWR;
                                       rpADRSTRT <= 1;
                                       if (rpDCA == rpCCA)
                                         begin
                                            delay <= $rtoi(FIXDELAY);
                                            state <= stateSEARCH;
                                         end
                                       else
                                         begin
                                            tmpCC <= rpDC;
                                            delay <= seekDELAY(rpDCA, rpCCA);
                                            check_ski();
                                            state <= stateSEEKSEARCH;
                                         end
                                    end
                               end

                             //
                             // Write header and data command
                             //
                             // The disk should not seek if DCY = CCY.  This is
                             // tested by DSPRA TST262.
                             //

                             `funWRITEH:
                               begin
                                  if (!rpSETIAE & !rpSETWLE)
                                    begin
                                       ata    <= 0;
                                       busy   <= 1;
                                       rpPIP  <= 0;
                                       rpSDOP <= `sdopWRH;
                                       rpADRSTRT <= 1;
                                       if (rpDCA == rpCCA)
                                         begin
                                            delay <= $rtoi(FIXDELAY);
                                            state <= stateSEARCH;
                                         end
                                       else
                                         begin
                                            tmpCC <= rpDC;
                                            delay <= seekDELAY(rpDCA, rpCCA);
                                            check_ski();
                                            state <= stateSEEKSEARCH;
                                         end
                                    end
                               end

                             //
                             // Read data command
                             //
                             // A read command may have to perform an implied
                             // seek before before performing the read
                             // operation.
                             //
                             // The disk will not seek to an invalid address.
                             //
                             // The disk should not seek if DCY = CCY.  This is
                             // tested by DSPRA TST262.
                             //

                             `funREAD:
                               begin
                                  if (!rpSETIAE)
                                    begin
                                       ata    <= 0;
                                       busy   <= 1;
                                       rpPIP  <= 0;
                                       rpSDOP <= `sdopRD;
                                       rpADRSTRT <= 1;
                                       if (rpDCA == rpCCA)
                                         begin
                                            delay <= $rtoi(FIXDELAY);
                                            state <= stateSEARCH;
                                         end
                                       else
                                         begin
                                            tmpCC <= rpDC;
                                            delay <= seekDELAY(rpDCA, rpCCA);
                                            check_ski();
                                            state <= stateSEEKSEARCH;
                                         end
                                    end
                               end

                             //
                             // Read header and data command
                             //
                             // The disk should not seek if DCY = CCY.  This is
                             // tested by DSPRA TST262.
                             //

                             `funREADH:
                               begin
                                  if (!rpSETIAE)
                                    begin
                                       ata    <= 0;
                                       busy   <= 1;
                                       rpPIP  <= 0;
                                       rpSDOP <= `sdopRDH;
                                       rpADRSTRT <= 1;
                                       if (rpDCA == rpCCA)
                                         begin
                                            delay <= $rtoi(FIXDELAY);
                                            state <= stateSEARCH;
                                         end
                                       else
                                         begin
                                            tmpCC <= rpDC;
                                            delay <= seekDELAY(rpDCA, rpCCA);
                                            check_ski();
                                            state <= stateSEEKSEARCH;
                                         end
                                    end
                               end
                           endcase
                      end

                    //
                    // stateOFFSET
                    //
                    // Handle Offset command And Return-to-center command.
                    //
                    // Heads do not move and RPCC does not change.
                    //

                    stateOFFSET:
                      begin
                         if (delay == 0)
                           begin
                              if (!rpDMD)
                                state <= stateDONE;
                           end
                         else
                           delay <= delay - 1'b1;
                      end

                    //
                    // stateUNLOAD
                    //
                    // Simulate timing for
                    //  - Unload command
                    //
                    // FIXME:
                    //  This is a NOP
                    //

                    stateUNLOAD:
                      begin
                         rpCC  <= 0;
                         state <= stateDONE;
                      end

                    //
                    // stateRECAL
                    //
                    // Simulate timing for
                    //  - Recalibrate command
                    //
                    // Heads move cylinder zero and RPCC changes to zero
                    //
                    
                    stateRECAL:
                      begin
                         if (delay == 0)
                           begin
                              if (!rpDMD)
                                begin
                                   head_pos <= 0;
                                   rpCC     <= 0;
                                   state    <= stateDONE;
                                end
                           end
                         else
                           delay <= delay - 1'b1;
                      end
                    
                    //
                    // stateSEEK
                    //
                    // Simulate seek timing for:
                    //  - Seek command
                    //
                    // These commands are done once the seek is completed
                    //
                    // The head position does not move in diagnostic mode.
                    //

                    stateSEEK:
                      begin
                         if (delay == 0)
                           begin
                              if (!rpDMD)
                                begin
                                   head_pos <= tmpCC;
                                   rpCC     <= tmpCC;
                                   state    <= stateDONE;
                                end
                           end
                         else
                           delay <= delay - 1'b1;
                      end

                    //
                    // stateSEEKSEARCH
                    //
                    // Simulate seek timing for:
                    //  - Search command
                    //  - Read commands
                    //  - Write commands
                    //  - Write check commands
                    //
                    // These commands will do a sector search once the seek has
                    // completed.
                    //
                    // The head position does not move in diagnostic mode.
                    //

                    stateSEEKSEARCH:
                      begin
                         if (delay == 0)
                           begin
                              if (!rpDMD)
                                begin
                                   head_pos <= tmpCC;
                                   rpCC     <= tmpCC;
                                   delay    <= $rtoi(FIXDELAY);
                                   state    <= stateSEARCH;
                                end
                           end
                         else
                           delay <= delay - 1'b1;
                      end

                    //
                    // stateSEARCH
                    //
                    // Simulate timining for sector search
                    //  - Search command
                    //  - Read commands
                    //  - Write commands
                    //  - Write check commands
                    //
                    // Wait for SD sector address calculation to complete before
                    // moving to a data transfer state.
                    //

                    stateSEARCH:
                      begin

                         if (rpDMD)

                           //
                           // In diagnostic mode.
                           //
                           // The search completes when a diagnostic index pulse
                           // is detected.
                           //

                           begin
                              if (rpDIND)
                                begin
                                   if (rpSDOP == `sdopNOP)
                                     state <= stateDONE;
                                   else
                                     begin
                                        bit_cnt <= 0;
                                        state   <= stateXFERHEADER;
                                     end
                                end
                           end

                         else

                           //
                           // Not in diagnostic mode.
                           //
                           // If accurate search is required for diagnostics
                           // (see DSRPA TEST-302), the search completes when
                           // the sector under the head (visbile in the RPLA
                           // register) is the same as the desired sector.  This
                           // is slow but is very accurate.
                           //
                           // If accurate search is not required, the search
                           // completes after a fixed period of time.   This is
                           // much faster but fails some diagnostic tests.
                           //

                           begin
                              if (simSEARCH ? (rpSA  == rpLAS) : (delay == 0))
                                begin
                                   if (rpSDOP == `sdopNOP)
                                     state <= stateDONE;
                                   else if (!rpADRBUSY)
                                     state <= stateDATA;
                                end
                              else
                                delay <= delay - 1'b1;
                           end
                      end

                    //
                    // stateXFERHEADER
                    //
                    // Diagnostic Mode only
                    //
                    // Header: 31 words (496 bits)
                    //

                    stateXFERHEADER:
                      begin
                         if (diag_clken)
                           begin
                              if (bit_cnt == 495)
                                begin
                                   rpDFE   <= 1;
                                   rpECE   <= 0;
                                   bit_cnt <= 0;
                                   state   <= stateXFERDATA;
                                end
                              else
                                bit_cnt <= bit_cnt + 1;
                           end
                      end

                    //
                    // stateXFERDATA
                    //
                    // Diagnostic Mode only
                    //
                    // Data: 256 words (4608 bits 18-bit mode)
                    //       256 words (4096 bits 16-bit mode)
                    //

                    stateXFERDATA:
                      begin
                         if (diag_clken)
                           begin
                              if (( rpFMT22 & (bit_cnt == 4095)) |
                                  (!rpFMT22 & (bit_cnt == 4607)))
                                begin
                                   rpDFE   <= 0;
                                   rpECE   <= 1;
                                   bit_cnt <= 0;
                                   state   <= stateXFERECC;
                                end
                              else
                                bit_cnt <= bit_cnt + 1;
                           end
                      end

                    //
                    // stateXFERECC
                    //
                    // Diagnostic Mode only
                    //
                    // ECC: 2 words (32 bits)
                    //

                    stateXFERECC:
                      begin
                         if (diag_clken)
                           begin
                              if (bit_cnt == 31)
                                begin
                                   rpDFE   <= 0;
                                   rpECE   <= 0;
                                   bit_cnt <= 0;
                                   state   <= stateXFERGAP;
                                end
                              else
                                bit_cnt <= bit_cnt + 1;
                           end
                      end

                    //
                    // stateXFERGAP
                    //
                    // Diagnostic Mode only
                    //
                    // Data Gap: 1 word (16 bits)
                    //

                    stateXFERGAP:
                      begin
                         if (diag_clken)
                           begin
                              if (bit_cnt == 15)
                                begin
                                   rpDFE   <= 0;
                                   rpECE   <= 0;
                                   bit_cnt <= 0;
                                   state   <= stateDONE;
                                end
                              else
                                bit_cnt <= bit_cnt + 1;
                           end
                      end

                    //
                    // stateDATA:
                    //
                    // Not Diagnostic Mode
                    //
                    // Wait for SD to complete Read/Write operaton
                    //
                    // The controller should abort on a invalid address when it
                    // occurs on a mid-transfer seek.  Keep rpCC updated on mid-
                    // transfer seeks.
                    //

                    stateDATA:
                      begin
                         if (rpSETAOE | rpSDACK)
                           state <= stateDONE;
                         else
                           rpCC <= rpDC;
                      end

                    //
                    // stateDONE:
                    //
                    // Update the visible disk state
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
     end

   //
   // rpDRY
   //  Don't negate rpDRY while rpGO is asserted otherwise it will create a
   //  RHCS1[PGE] error.
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpDRY <= 1;
        else
          rpDRY <= !busy | rpGO;
     end

`ifdef RPXX_OPI

   //
   // Diagnostic index pulse.  Triggerd on falling edge of maintenance
   // register signal.
   //

   wire diag_index;
   EDGETRIG uDIAGIND(clk, rst, 1'b1, 1'b0, rpDIND, diag_index);

   //
   // Index pulse counter for testing OPI
   //
   // This should set RPER1[OPI] on the third index pulse in maintenance mode.
   // This is required to pass DSRPA TEST-273.
   //
   // Trace
   //  M7786/SS0/E57
   //  M7786/SS0/E58
   //  M7786/SS0/E53
   //

   reg [1:0] index_cnt;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          index_cnt <= 0;
        else
          if (rpDMD)
            begin
               if (diag_index)
                 index_cnt <= {index_cnt[0], 1'b1};
            end
          else
            index_cnt <= 0;
     end

   assign rpSETOPI = rpDMD & rpDIND & index_cnt[1];

`else

   //
   // Tie off rpSETOPI
   //

   assign rpSETOPI = 0;

`endif

   //
   // State decode
   //

   assign rpSDREQ = (state == stateDATA);

endmodule
