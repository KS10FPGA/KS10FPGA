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
`include "rphcrc.vh"
`include "../sd/sd.vh"
`include "../../ks10.vh"

//
// Simulate seek accurately
//

`ifdef RPXX_SIMSEEK
 `define simSEEK 1'b1
`else
 `define simSEEK 1'b0
`endif

//
// Simulate search accurately
//

`ifdef RPXX_SIMSEARCH
 `define simSEARCH 1'b1
`else
 `define simSEARCH 1'b0
`endif

//
// Simulate diagnostic mode
//

`ifdef RPXX_SIMDMD
 `define simDMD 1'b1
`else
 `define simDMD 1'b0
`endif

module RPCTRL (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire         clr,                  // Clr
      input  wire         rpGO,                 // Go bit
      input  wire [ 5: 1] rpFUN,                // Function
      input  wire [ 9: 0] rpCYLNUM,             // Number of cylinders
      output reg  [15: 0] rpCC,                 // Current cylinder
      input  wire [15: 0] rpDA,                 // Disk address
      input  wire [15: 0] rpDC,                 // Desired cylinder
      input  wire [15: 0] rpLA,                 // Lookahead register
      input  wire         rpDMD,                // Diagnostic Mode
      input  wire         rpDSCK,               // Diagnostic sector clock
      input  wire         rpDCLK,               // Diagnostic clock
      input  wire         rpDIND,               // Diagnostic index pulse
      input  wire         rpDRDD,               // Diagnostic read data
      output reg          rpDWRD,               // Dianostic write data
      output reg          rpDFE,                // Data field envelope
      output wire         rpSBD,                // Sync byte detected
      output wire         rpZD,                 // ECC zero detect
      output reg          rpDRY,                // Drive ready
      output reg          rpEBL,                // End of block
      output reg          rpECE,                // ECC envelope
      input  wire         rpECI,                // Error correct inhibit
      input  wire         rpFMT22,              // 22 sector format (16-bit)
      input  wire         rpPAT,                // Parity test
      output reg          rpPIP,                // Positioning-in-progress
      input  wire         rpCLBERR,             // Class B error (abort)
      input  wire         rpSETAOE,             // Set address overflow error
      output reg          rpSETATA,             // Set attenation
      output wire         rpSETDCK,             // Set data check error
      output reg          rpSETDTE,             // Set drive timing error
      output wire         rpSETOPI,             // Set operation incomplete
      output reg          rpSETSKI,             // Set seek incomplete
      input  wire         rpSETWLE,             // Set write lock error
      output wire         rpSETHCRC,            // Set header CRC error
      output reg          rpADRSTRT,            // Address calculation start
      input  wire         rpADRBUSY,            // Address calculation busy
      output reg  [ 2: 0] rpSDOP,               // SD operation
      output wire         rpSDREQ,              // SD request
      input  wire         rpSDACK               // SD acknowledge
   );

   //
   // Timing Parameters
   //

   localparam simSEEK   = `simSEEK;             // Simulate seek accurately
   localparam simSEARCH = `simSEARCH;           // Simulate search accurately
   localparam simDMD    = `simDMD;              // Simulate diagnostic mode
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
         if (simDMD)
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
      end
   endtask

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

   reg [15:0] head_pos;

   //
   // Desired Sector
   //

   wire [5:0] rpSA = `rpDA_SA(rpDA);

   //
   // RPLA Sector
   //

   wire [5:0] rpLAS = `rpLA_LAS(rpLA);

   //
   // Diagnostic clock.  Triggered on falling edge of maintenance
   // register signal.
   //

`ifdef RPXX_SIMDMD
   wire diag_clken;
   wire diag_clken_p;
   EDGETRIG #(.POSEDGE(1)) MAINTCLKP(clk, rst, 1'b1, rpDCLK, diag_clken_p);
   EDGETRIG #(.POSEDGE(0)) MAINTCLKN(clk, rst, 1'b1, rpDCLK, diag_clken);
`else
   wire diag_clken = 0;
   wire diag_clken_p = 0;
`endif

   //
   // Diagnostic index pulse.  Triggered on falling edge of maintenance
   // register signal.
   //

`ifdef RPXX_SIMDMD
   wire diag_index;
   EDGETRIG #(.POSEDGE(0)) uDIAGIND(clk, rst, 1'b1, rpDIND, diag_index);
`else
   wire diag_index = 0;
`endif

   //
   // go_cmd
   //
   // go_cmd must be asserted after rpGO is negated otherwise it will
   // create an RHCS2[PGE] error
   //

   wire go_cmd;
   EDGETRIG #(.POSEDGE(0)) GOEDGE(clk, rst, 1'b1, rpGO, go_cmd);

   //
   // State Definition
   //

   localparam [4:0] stateIDLE       =  0,       // Idle
                    stateOFFSET     =  1,       // Offset/center command
                    stateUNLOAD     =  2,       // Unload command
                    stateRECAL      =  3,       // Recalibrate command
                    stateSEEK       =  4,       // Seek
                    stateSEEKSEARCH =  5,       // Seek then search
                    stateSEARCH     =  6,       // Searching for sector
                    stateWRHDR      =  7,       // Diagnostic write pre-header, header, header gap
                    stateWRDATA     =  8,       // Diagnostic write data
                    stateWRECC      =  9,       // Diagnostic write ECC
                    stateWRDATAGAP  = 10,       // Diagnostic write data gap
                    stateRDPREHDR   = 11,       // Diagnostic read pre-header
                    stateRDHDR      = 12,       // Diagnostic read header
                    stateRDHDRGAP   = 13,       // Diagnostic read header gap
                    stateRDDATA     = 14,       // Diagnostic read data
                    stateRDECC      = 15,       // Diagnostic read ECC
                    stateRDFIXECC   = 16,       // Diagnostic fix ECC
                    stateDATA       = 17,       // Non-diagnostic read/write data
                    stateDONE       = 18;       // Done

   //
   // Disk Motion Simlation State Machine
   //

   reg [24: 0] delay;                           // RPxx Delay Simulation
   reg [15: 0] tmpCC;                           // rpCC value when command completes
   reg [ 5: 0] bit_cnt;                         // Bit counter (0 - 17)
   reg [ 7: 0] word_cnt;                        // Word counter (0 - 255)
   reg         tmpATA;                          // Do ATA at end
   reg [ 4: 0] state;                           // State

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             rpCC     <= 0;
             rpDFE    <= 0;
             rpDRY    <= 1;
             rpEBL    <= 0;
             rpECE    <= 0;
             rpPIP    <= 0;
             rpSETATA <= 0;
             rpSETSKI <= 0;
             rpSDOP   <= `sdopNOP;
             tmpATA   <= 0;
             tmpCC    <= 0;
             bit_cnt  <= 0;
             word_cnt <= 0;
             delay    <= 0;
             head_pos <= 0;
             state    <= stateIDLE;
          end
        else
          begin
             if (clr)
               begin
                  rpCC     <= rpDC;
                  rpDFE    <= 0;
                  rpDRY    <= 1;
                  rpEBL    <= 0;
                  rpECE    <= 0;
                  rpPIP    <= 0;
                  rpSETATA <= 0;
                  rpSETSKI <= 0;
                  rpSDOP   <= `sdopNOP;
                  tmpATA   <= 0;
                  tmpCC    <= 0;
                  bit_cnt  <= 0;
                  word_cnt <= 0;
                  delay    <= 0;
                  state    <= stateIDLE;
               end
             else
               begin
                  rpEBL     <= 0;
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
                         rpDRY    <= 1;
                         rpPIP    <= 0;
                         rpSETATA <= 0;
                         tmpATA   <= 0;
                         tmpCC    <= 0;

                         //
                         // Wait for a GO command
                         //

                         if (go_cmd)

                           //
                           // Decode Command (Function)
                           //

                           case (rpFUN)

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
                                  rpDRY  <= 0;
                                  rpPIP  <= 1;
                                  tmpATA <= 1;
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
                                  rpDRY  <= 0;
                                  tmpATA <= 1;
                                  rpPIP  <= 1;
                                  if (rpDCA == rpCCA)
                                    state  <= stateDONE;
                                  else
                                    begin
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
                                  rpDRY  <= 0;
                                  rpPIP  <= 1;
                                  tmpATA <= 1;
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
                                  rpDRY  <= 0;
                                  rpPIP  <= 0;
                                  tmpATA <= 1;
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

                             //
                             // Offset Command
                             //
                             // This command would offset the head from the
                             // centerline of the track.
                             //

                             `funOFFSET:
                               begin
                                  rpDRY  <= 0;
                                  rpPIP  <= 1;
                                  tmpATA <= 1;
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
                                  rpDRY  <= 0;
                                  rpPIP  <= 1;
                                  tmpATA <= 1;
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
                                  rpDRY  <= 0;
                                  rpPIP  <= 0;
                                  tmpATA <= 0;
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

                             //
                             // Write check header and data command
                             //
                             // The disk should not seek if DCY = CCY.  This is
                             // tested by DSPRA TST262.
                             //

                             `funWRCHKH:
                               begin
                                  rpDRY  <= 0;
                                  rpPIP  <= 0;
                                  tmpATA <= 0;
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
                                  rpDRY  <= 0;
                                  rpPIP  <= 0;
                                  tmpATA <= 0;
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

                             //
                             // Write header and data command
                             //
                             // The disk should not seek if DCY = CCY.  This is
                             // tested by DSPRA TST262.
                             //

                             `funWRITEH:
                               begin
                                  rpDRY  <= 0;
                                  rpPIP  <= 0;
                                  rpSDOP <= `sdopWRH;
                                  tmpATA <= 0;
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
                                  rpDRY  <= 0;
                                  rpPIP  <= 0;
                                  tmpATA <= 0;
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

                             //
                             // Read header and data command
                             //
                             // The disk should not seek if DCY = CCY.  This is
                             // tested by DSPRA TST262.
                             //

                             `funREADH:
                               begin
                                  rpDRY  <= 0;
                                  rpPIP  <= 0;
                                  tmpATA <= 0;
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
                              if (simDMD & rpDMD)
                                begin
                                end
                              else
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
                              if (simDMD & rpDMD)
                                begin
                                end
                              else
                                begin
                                   rpCC     <= 0;
                                   head_pos <= 0;
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
                              if (simDMD & rpDMD)
                                begin
                                end
                              else
                                begin
                                   rpCC     <= tmpCC;
                                   head_pos <= tmpCC;
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
                              if (simDMD & rpDMD)
                                begin
                                end
                              else
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
                         bit_cnt  <= 0;
                         word_cnt <= 0;
                         if (rpCLBERR)
                           state <= stateDONE;
                         else
                           begin
                              if (simDMD & rpDMD)

                                //
                                // In diagnostic mode.
                                //
                                // The search completes when a diagnostic index
                                // pulse is detected.
                                //
                                // The dianostics only do Read Header and Write
                                // Header operations.  The others probably don't
                                // work.
                                //

                                begin
                                   if (diag_index)
                                     case (rpSDOP)
                                       `sdopNOP:
                                         state <= stateDONE;
                                       `sdopWRCHKH, `sdopRDH:
                                         state <= stateRDPREHDR;
                                       `sdopWRH:
                                         state <= stateWRHDR;
                                       `sdopWRCHK, `sdopRD:
                                         state <= stateRDDATA;
                                       `sdopWR:
                                         state <= stateWRDATA;
                                     endcase
                                end

                              else

                                //
                                // Not in diagnostic mode.
                                //
                                // If accurate search is required for diagnostics
                                // (see DSRPA TEST-302), the search completes
                                // when the sector under the head (visbile in
                                // the RPLA register) is the same as the desired
                                // sector.  This is slow but is very accurate.
                                //
                                // If accurate search is not required, the
                                // search completes after a fixed period of
                                // time.  This is much faster but fails some of
                                // the diagnostic tests.
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
                      end

                    //
                    // stateWRHDR
                    //
                    // Write Header (Diagnostic Mode only)
                    //
                    // The pre-header, header, and header-gap fields are a
                    // total of 31 16-bit words (496 bits).  This state
                    // transitions to the next state when all of the bits in
                    // the header have been written.
                    //

`ifdef RPXX_SIMDMD
                    stateWRHDR:
                     begin
                         if (rpCLBERR)
                           state <= stateDONE;
                         else
                           if (diag_clken)
                             begin
                                if (bit_cnt == 15)
                                  if (word_cnt == 30)
                                    begin
                                       rpDFE    <= 1;
                                       rpECE    <= 0;
                                       bit_cnt  <= 0;
                                       word_cnt <= 0;
                                       state    <= stateWRDATA;
                                    end
                                  else
                                    begin
                                       bit_cnt  <= 0;
                                       word_cnt <= word_cnt + 1'b1;
                                    end
                                else
                                  bit_cnt <= bit_cnt + 1'b1;
                             end
                     end

                    //
                    // stateWRDATA
                    //
                    // Write Data Field (Diagnostic Mode only)
                    //
                    // The data field is 256 words.  In the data field, the
                    // word length can be either 16-bits of 18-bits.
                    //

                    stateWRDATA:
                      begin
                         if (rpCLBERR)
                           state <= stateDONE;
                         else
                           if (diag_clken)
                             begin
                                if ((rpFMT22 & (bit_cnt == 15)) | (bit_cnt == 17))
                                  if (word_cnt == 255)
                                    begin
                                       rpDFE    <= 0;
                                       rpECE    <= 1;
                                       bit_cnt  <= 0;
                                       word_cnt <= 0;
                                       state    <= stateWRECC;
                                    end
                                  else
                                    begin
                                       bit_cnt  <= 0;
                                       word_cnt <= word_cnt + 1'b1;
                                    end
                                else
                                  bit_cnt <= bit_cnt + 1'b1;
                             end
                      end

                    //
                    // stateWRECC
                    //
                    // Write ECC field (Diagnostic Mode only)
                    //
                    // The ECC field is two 16-bit words (32 bits).
                    //

                    stateWRECC:
                      begin
                         if (rpCLBERR)
                           state <= stateDONE;
                         else
                           if (diag_clken)
                             begin
                                if (bit_cnt == 15)
                                  if (word_cnt == 1)
                                    begin
                                       rpDFE    <= 0;
                                       rpECE    <= 0;
                                       bit_cnt  <= 0;
                                       word_cnt <= 0;
                                       state    <= stateWRDATAGAP;
                                    end
                                  else
                                    begin
                                       bit_cnt  <= 0;
                                       word_cnt <= word_cnt + 1'b1;
                                    end
                                else
                                  bit_cnt <= bit_cnt + 1'b1;
                             end
                      end

                    //
                    // stateWRDATAGAP
                    //
                    // Diagnostic Mode only
                    //
                    // The data gap field is one 16-bit word.
                    //

                    stateWRDATAGAP:
                      begin
                         if (rpCLBERR)
                           state <= stateDONE;
                         else
                           if (diag_clken)
                             begin
                                if (bit_cnt == 15)
                                  begin
                                     rpDFE    <= 0;
                                     rpECE    <= 0;
                                     bit_cnt  <= 0;
                                     word_cnt <= 0;
                                     state    <= stateDONE;
                                  end
                                else
                                  bit_cnt <= bit_cnt + 1'b1;
                             end
                      end

                    //
                    // stateRDPREHDR
                    //
                    // Read Pre-Header (Diagnostic Mode only)
                    //
                    // This state just waits unit a pre-header sync is detected.
                    //

                    stateRDPREHDR:
                     begin
                         if (rpCLBERR)
                           state <= stateDONE;
                         else
                           if (diag_clken)
                             begin
                                if (rpSBD)
                                  begin
                                     bit_cnt  <= 0;
                                     word_cnt <= 0;
                                     state    <= stateRDHDR;
                                  end
                                else
                                  begin
                                     if (bit_cnt == 15)
                                       begin
                                          bit_cnt  <= 0;
                                          word_cnt <= word_cnt + 1'b1;
                                       end
                                     else
                                       bit_cnt <= bit_cnt + 1'b1;
                                  end
                             end
                     end

                    //
                    // stateRDHDR
                    //
                    // Read Header (Diagnostic Mode only)
                    //
                    // The header data is read in this state.  The header
                    // field is 5 16-bit words long.
                    //

                    stateRDHDR:
                      begin
                         if (rpCLBERR)
                           state <= stateDONE;
                         else
                           if (diag_clken)
                             begin
                                if (bit_cnt == 15)
                                  if (word_cnt == 4)
                                    begin
                                       bit_cnt  <= 0;
                                       word_cnt <= 0;
                                       state    <= stateRDHDRGAP;
                                    end
                                  else
                                    begin
                                       bit_cnt  <= 0;
                                       word_cnt <= word_cnt + 1'b1;
                                    end
                                else
                                  bit_cnt <= bit_cnt + 1'b1;
                             end
                     end
-
                    //
                    // stateRDHDRGAP
                    //
                    // Read Header Gap (Diagnostic Mode only)
                    //
                    // This state just waits unit a post-header sync is
                    // detected.
                    //

                    stateRDHDRGAP:
                     begin
                         if (rpCLBERR)
                           state <= stateDONE;
                         else
                           if (diag_clken)
                             begin
                                if (rpSBD)
                                  begin
                                     rpDFE    <= 1;
                                     rpECE    <= 0;
                                     bit_cnt  <= 0;
                                     word_cnt <= 0;
                                     state    <= stateRDDATA;
                                  end
                                else
                                  begin
                                     if (bit_cnt == 15)
                                       begin
                                          bit_cnt  <= 0;
                                          word_cnt <= word_cnt + 1'b1;
                                       end
                                     else
                                       bit_cnt <= bit_cnt + 1'b1;
                                  end
                             end
                     end

                    //
                    // Read Data Field (Diagnostic Mode only)
                    //
                    // The data field is 256 words.  In the data field, the
                    // word length can be either 16-bits of 18-bits.
                    //

                    stateRDDATA:
                     begin
                         if (rpCLBERR)
                           state <= stateDONE;
                         else
                           if (diag_clken)
                             begin
                                if ((rpFMT22 & (bit_cnt == 15)) | (bit_cnt == 17))
                                  if (word_cnt == 255)
                                    begin
                                       rpDFE    <= 0;
                                       rpECE    <= 1;
                                       bit_cnt  <= 0;
                                       word_cnt <= 0;
                                       state    <= stateRDECC;
                                    end
                                  else
                                    begin
                                       bit_cnt  <= 0;
                                       word_cnt <= word_cnt + 1'b1;
                                    end
                                else
                                  bit_cnt <= bit_cnt + 1'b1;
                             end
                     end

                    //
                    // stateRDECC
                    //
                    // Read ECC field (Diagnostic Mode only)
                    //
                    // The ECC field is two 16-bit words (32 bits).
                    //

                    stateRDECC:
                      begin
                         if (rpCLBERR)
                           state <= stateDONE;
                         else
                           if (diag_clken)
                             begin
                                if (bit_cnt == 15)
                                  if (word_cnt == 1)
                                    begin
                                       rpDFE    <= 0;
                                       rpECE    <= 0;
                                       bit_cnt  <= 0;
                                       word_cnt <= 0;
                                       if (rpZD)
                                         state  <= stateDONE;
                                       else
                                         state  <= stateRDFIXECC;
                                    end
                                  else
                                    begin
                                       bit_cnt  <= 0;
                                       word_cnt <= word_cnt + 1'b1;
                                    end
                                else
                                  bit_cnt <= bit_cnt + 1'b1;
                             end
                      end

                    //
                    // stateRDFIXECC:
                    //
                    // Fix data (Diagnostic Mode only)
                    //
                    // This state fixes ECC errors, if possible.
                    //

                    stateRDFIXECC:
                      begin
                         state <= stateDONE;
                      end
`endif

                    //
                    // stateDATA:
                    //
                    // Read/Write Data to SD Card (Not Diagnostic Mode)
                    //
                    // Wait for SD to complete Read/Write operaton
                    //
                    // The controller should abort on a invalid address when it
                    // occurs on a mid-transfer seek.  Keep rpCC updated on mid-
                    // transfer seeks.
                    //

                    stateDATA:
                      begin
                         if (rpSETAOE | rpSDACK | rpCLBERR)
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
                         rpDRY    <= 1;
                         rpEBL    <= 1;
                         rpPIP    <= 0;
                         tmpATA   <= 0;
                         rpSETATA <= tmpATA;
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
   // Load data from memory.  Store data to memory
   //

`ifdef NOT_IMPLEMENTED

   localparam [2:0] busIDLE  = 0,
                    busRDREQ = 1,
                    busRDACK = 2,
                    busWRREQ = 3,
                    busWRACK = 4;

   //
   // The first word of a disk write is read from memory during the header.
   // The last word of a disk read is written to memory during the ecc.
   //

   reg rpINCBA;
   reg rpINCWC
   reg rpDEVREQO;
   reg [0:31] tempDATAI;
   reg [2: 0] busState;

   devDATAI
   devDATAO

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             rpINCBA   <= 0;
             rpINCWC   <= 0;
             rpDEVREQO <= 0;
             busState  <= busIDLE;
          end
        else
          begin
             rpINCBA   <= 0;
             rpINCWC   <= 0;
             rpDEVREQO <= 0;
             case (busState)
               busIDLE:
                 begin
                    if (((state == stateWRHDR ) & (word_cnt == 30) & (bit_cnt == 8)) |
                        ((state == stateWRDATA) & (bit_cnt == 8)))
                      begin
                         rpDEVREQO <= 1;
                         busState  <= busRDREQ;
                      end
                    else (((state == stateRDDATA) & (bit_cnt == 8)) |
                          ((state == stateRDECC ) & (word_cnt == 1) & (bit_cnt == 1)))
                      begin
                         rpDEVREQO <= 1;
                         busState  <= busWRREQ;
                      end
                 end
               busRDREQ:
                 begin
                    if (rpDEVACKI)
                      begin
                         rpINCBA  <= 1;
                         rpINCWC  <= (rhWC != 0);
                         busState <= busRDACK;
                      end
                    else
                      rpDEVREQO <= 1;
                 end
               busRDACK:
                 begin
                 end
               busWRREQ:
                 begin
                    if (rpDEVACKI)
                      begin
                         tempDATA <= devDATAI;
                         state    <= stateWRACK;
                      end
                    else
                      rpDEVREQO <= 1;
                 end
               busWRACK:
                 begin
                 end
             endcase
          end
     end

`endif

`define asdf
`ifdef asdf


   //
   // rpDWRD
   //

   always @*
     begin
        rpDWRD <= 0;
        if (((state == stateWRHDR)  & (word_cnt == 19) & (bit_cnt ==  8)) | // Pre header sync byte
            ((state == stateWRHDR)  & (word_cnt == 19) & (bit_cnt == 11)) | // Pre header sync byte
            ((state == stateWRHDR)  & (word_cnt == 19) & (bit_cnt == 12)) | // Pre header sync byte
            ((state == stateWRHDR)  & (word_cnt == 30) & (bit_cnt ==  8)) | // Post header sync byte
            ((state == stateWRHDR)  & (word_cnt == 30) & (bit_cnt == 11)) | // Post header sync byte
            ((state == stateWRHDR)  & (word_cnt == 30) & (bit_cnt == 12)) | // Post header sync byte
            ((state == stateWRDATA) & (word_cnt ==  1)))                    // FIXME test
          rpDWRD <= 1;
     end

`else

   //
   //
   //

   RPDCLRW DCLRW (
      .clk         (clk),
      .rst         (rst),
      .clr         (clr),
      .trig        (1'b0),

   );

   //
   // ShiftWR Register
   //
   // Data is transferred LSB first
   //
   // Trace
   //  M7773/SN3/E8
   //  M7773/SN3/E13
   //  M7773/SN3/E17
   //  M7773/SN3/E20
   //  M7773/SN3/E29
   //

   reg [17:0] shiftWR;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          shiftWR <= 0;
        else
          if (simDMD & diag_clken_p)
            begin

               //
               // Pre-header sync
               //

               if ((state == stateWRHDR) & (word_cnt == 19))
                 shiftWR <= 18'o000031;

               //
               // Header Word 1 (Desired Cylinder Address and Format)
               //

               else if ((state == stateWRHDR) & (word_cnt == 20))
                 ;//shiftWR <= header1[2:17];

               //
               // Header Word 2 (Desired Sector and Track Address)
               //

               else if ((state == stateWRHDR) & (word_cnt == 21))
                 ;//shiftWR <= header1[20:35];

               //
               // Header Word 3 (Key Field #1)
               //

               else if ((state == stateWRHDR) & (word_cnt == 22))
                 ;//shiftWR <= header2[2:17];

               //
               // Header Word 4 (Key Field #2)
               //

               else if ((state == stateWRHDR) & (word_cnt == 23))
                 ;//shiftWR <= header1[20:35];

               //
               // Header Word 5 (Header CRC)
               //

               else if ((state == stateWRHDR) & (word_cnt == 24))
                 ;//shiftWR <= hcrc;

               //
               // Post-header sync
               //

               else if ((state == stateWRHDR) & (word_cnt == 30))
                 shiftWR <= 18'o000031;

               //
               // Shift out data
               //

               else
                  shiftWR <= {0, shiftWR[17:1]};
            end
     end

   assign rpDWRD = shiftWR[0];

`endif

   //
   // ShiftRD Register
   //
   // Data is transferred LSB first
   //

   reg [17:0] shiftRD;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          shiftRD <= 0;
        else
          if (simDMD & diag_clken_p)
            shiftRD <= {rpDRDD, shiftRD[17:1]};
     end

   //
   // Sync byte detector
   //
   // Trace
   //  M7773/SN7/E26
   //  M7773/SN7/E30
   //  M7773/SN7/E33
   //  M7773/SN7/E55
   //

   assign rpSBD = (shiftRD[17:10] == 8'o031);

   //
   // Header CRC
   //

   wire crc_ok;
   wire crc_out;

   reg [1:0] opHCRC;

   always @*
     begin
        if (state == stateRDHDR)
          opHCRC <= `opHCRC_IN;
        else
          opHCRC <= `opHCRC_RST;
     end

   wire [15:0] hcrc;

   RPHCRC HCRC (
      .clk         (clk),
      .rst         (rst),
      .clken       (diag_clken_p),
      .opHCRC      (opHCRC),
      .in          (rpDRDD),
      .crc         (hcrc)
   );

   //
   // Header CRC Error - RPER1[HCRC]
   //
   // Asserted after peforming the CRC on the header (including the header CRC
   // itself) is not zero.
   //
   // Trace
   //  M7786/SS7/E68
   //  M7786/SS7/E78
   //  M7786/SS7/E82
   //  M7786/SS7/E90
   //

   assign rpSETHCRC = simDMD & diag_clken_p & (hcrc != 0) & (state == stateRDHDR) & (word_cnt == 4) & (bit_cnt == 15);

   //
   // Drive Timing Error - RPER1[DTE]
   //
   // Asserted in Diagnostic Mode when an Sector Pulse is detected while the
   // drive is performing a data transfer.
   //
   // Trace
   //  M7773/SN0/E35
   //  M7773/SN0/E45
   //  M7773/SN0/E48
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpSETDTE <= 0;
        else
          rpSETDTE <= ((simDMD & rpDMD & rpDIND & (state == stateWRHDR    )) |
                       (simDMD & rpDMD & rpDIND & (state == stateWRDATA   )) |
                       (simDMD & rpDMD & rpDIND & (state == stateWRECC    )) |
                       (simDMD & rpDMD & rpDIND & (state == stateWRDATAGAP)) |
                       (simDMD & rpDMD & rpDIND & (state == stateRDPREHDR )) |
                       (simDMD & rpDMD & rpDIND & (state == stateRDHDR    )) |
                       (simDMD & rpDMD & rpDIND & (state == stateRDHDRGAP )) |
                       (simDMD & rpDMD & rpDIND & (state == stateRDDATA   )) |
                       (simDMD & rpDMD & rpDIND & (state == stateRDECC    )));
     end

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
          if (simDMD & rpDMD)
            begin
               if ((rpFUN != `funSEARCH) &
                   (rpFUN != `funWRCHK ) &
                   (rpFUN != `funWRCHKH) &
                   (rpFUN != `funWRITE ) &
                   (rpFUN != `funWRITEH) &
                   (rpFUN != `funREAD  ) &
                   (rpFUN != `funREADH ))
                 index_cnt <= 0;
               else if (diag_index)
                 index_cnt <= {index_cnt[0], 1'b1};
            end
          else
            index_cnt <= 0;
     end

   assign rpSETOPI = simDMD & rpDMD & rpDIND & index_cnt[1];

   //
   // State decode
   //

   assign rpSDREQ = (state == stateDATA);

   assign rpSETDCK = 0;         // FIXME
   assign rpZD     = 0;         // FIXME

endmodule
