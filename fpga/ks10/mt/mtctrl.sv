////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   MT State Machine
//
// File
//   mtctrl.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2021-2022 Rob Doyle
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

`include "mtcs1.vh"
`include "mttc.vh"

module MTCTRL (
      input  wire          clk,                 // Clock
      input  wire          rst,                 // Reset
      input  wire          mtINIT,              // Initialize
      input  wire          mtDRVCLR,            // Drive Clear
      input  wire          mtCLRATA,            // Clear ATA
      output logic         mtREQO,              // Request out
      input  wire          mtACKI,              // Acknowledge in
      input  wire  [ 0:35] mtDATAI,             // Data input (Writes)
      output logic [ 0:35] mtDATAO,             // Data output (Reads)
      output logic         mtNPRO,              // NPR direction
      output logic         mtINCWC,             // Increment word count
      output logic         mtINCBA,             // Increment bus address
      output logic         mtDECBA,             // Decrement bus address
      output logic         mtWCE,               // Write check error detected
      input  wire  [ 7: 0] mtMOL,               // Media on-line
      input  wire          mtWRL,               // Write lock
      input  wire          mtWRLO,              // Write lo word (addr 0x60 / bits[32:63])
      input  wire          mtWRHI,              // Write hi word (addr 0x64 / bits[ 0:31])
      input  wire  [ 3: 0] mtWSTRB,             // Write stobes (byte lanes)
      input  wire  [31: 0] mtCSLDATAI,          // Console data in
      output logic [63: 0] mtDIRO,              // Data interface register
      output logic [63: 0] mtDEBUG,             // Debug output
      input  wire          mtFCZ,               // Frame count is zero
      input  wire          mtFMTE,              // Format Error
      input  wire          mtNEF,               // Non-executable function
      input  wire          mtWCZ,               // Word count is zero
      input  wire  [ 2: 0] mtDEN,               // Density
      input  wire  [ 3: 0] mtFMT,               // Format
      input  wire  [ 5: 1] mtFUN,               // Function
      input  wire          mtGO,                // Go bit
      input  wire  [ 2: 0] mtSS,                // Slave Select
      output logic         mtPIP,               // Positioning in progress
      output logic         mtACCL,              // Tape drive acceleration
      output logic         mtATA,               // Attention
      output logic         mtDRY,               // Tape drive is ready
      output logic         mtBOT,               // Beginning of tape
      output logic         mtEOT,               // End of tape
      output logic         mtTM,                // Tape mark
      output logic         mtSLA,               // Slave attention
      output logic         mtSSC,               // Slave status change
      output logic         mtIDB,               // ID Burst Found
      output logic         mtPES,               // Phase encoded status
      output logic [ 8: 0] mtMDF,               // Maintenance Data Field
      output logic         mtSDWN,              // Settle down
      output logic         mtINCFC              // Increment frame counter
   );

   //
   // Parity Function
   //

   function [8:0] parity(logic [35:0] d, logic [3:0] fmt);
      case (fmt)
        `mtTC_FMT_CORDMP:
          begin
             parity[8] = d[35] ^ d[27] ^ d[19] ^ d[11];
             parity[7] = d[34] ^ d[26] ^ d[18] ^ d[10];
             parity[6] = d[33] ^ d[25] ^ d[17] ^ d[ 9];
             parity[5] = d[32] ^ d[24] ^ d[16] ^ d[ 8];
             parity[4] = d[31] ^ d[23] ^ d[15] ^ d[ 7] ^ d[ 3];
             parity[3] = d[30] ^ d[22] ^ d[14] ^ d[ 6] ^ d[ 2];
             parity[2] = d[29] ^ d[21] ^ d[13] ^ d[ 5] ^ d[ 1];
             parity[1] = d[28] ^ d[20] ^ d[12] ^ d[ 4] ^ d[ 0];
             parity[0] = parity[8] ^ parity[7] ^ parity[6] ^ parity[5] ^
                         parity[4] ^ parity[3] ^ parity[2] ^ parity[1]; // vertical parity
          end
        `mtTC_FMT_COMPAT:
          begin
             parity[8] = d[35] ^ d[27] ^ d[19] ^ d[11];
             parity[7] = d[34] ^ d[26] ^ d[18] ^ d[10];
             parity[6] = d[33] ^ d[25] ^ d[17] ^ d[ 9];
             parity[5] = d[32] ^ d[24] ^ d[16] ^ d[ 8];
             parity[4] = d[31] ^ d[23] ^ d[15] ^ d[ 7];
             parity[3] = d[30] ^ d[22] ^ d[14] ^ d[ 6];
             parity[2] = d[29] ^ d[21] ^ d[13] ^ d[ 5];
             parity[1] = d[28] ^ d[20] ^ d[12] ^ d[ 4];
             parity[0] = parity[8] ^ parity[7] ^ parity[6] ^ parity[5] ^
                         parity[4] ^ parity[3] ^ parity[2] ^ parity[1]; // vertical parity
          end
        default:
          parity = 0;
      endcase
   endfunction

   //
   // State Definition
   //

   logic      [7:0] state;
   localparam [7:0] stateINIT      =  0,        // Initialize
                    stateIDLE      =  1,        // Wait for something to do
                    stateDLY       =  2,        // Delay a clock cycle
                    stateTSTERR    =  3,        // Test for errors
                    stateSDWN      =  4,        // Settle down time
                    stateDECODE    =  5,        // Decode the command
                    stateACCL      =  6,        // Wait for transport to accelerate to speed
                    stateSTARTEXEC =  7,        // Prepare to execute a command
                    stateEXECCMD   =  8,        // Let the software execute the commad
                    stateWRCHK     =  9,        // Write check fwd/rev
                    stateWRCHK0    = 10,        // Write check fwd/rev
                    stateWRCHK1    = 11,        // Write check fwd/rev
                    stateREAD      = 12,        // Read  forward
                    stateREAD0     = 13,        // Read  fwd/rev accessing data
                    stateREAD1     = 14,        // Read  fwd/rev accessing data
                    stateWRITE     = 15,        // Write forward
                    stateWRITE0    = 16,        // Write forward
                    stateWRITE1    = 17,        // Write forward
                    stateWRITE2    = 18,        // Write forward
                    stateDONE      = 31;        // Done
   //
   // Timing parameters
   //

   localparam [31:0] mtACCLVAL = (0.0032000 * `CLKFRQ);   // Offset delay (2.8 ms)
   localparam [31:0] mtSDWNVAL = (0.0100000 * `CLKFRQ);   // Settle-down timer (10.0 ms)

   //
   // Bit positions in mtDIR
   //

   localparam int bREAD   = 63-32,
                  bSTB    = 62-32,
                  bINIT   = 61-32,
                  bREADY  = 60-32,
                  bINCFC  = 59-32,
                  bWCZ    = 43-32,
                  bFCZ    = 42-32,
                  bSETBOT = 41-32,
                  bCLRBOT = 40-32,
                  bSETEOT = 39-32,
                  bCLREOT = 38-32,
                  bSETTM  = 37-32,
                  bCLRTM  = 36-32;

   //
   // mtDIR[READY]
   //
   // The state machine negates this bit to indicate to the software to execute
   // a command.
   //
   // When the command is completed, the software should assert the READY bit.
   //

   logic mtREADY;

   always @(posedge clk)
     begin
        if (rst | (state == stateINIT) | (mtWSTRB[3] & mtWRHI & mtCSLDATAI[bREADY]))
          mtREADY <= 1;
        else if ((state == stateWRITE    ) |
                 (state == stateREAD     ) |
                 (state == stateWRCHK    ) |
                 (state == stateSTARTEXEC))
          mtREADY <= 0;
     end

   //
   // mtDIR[INCFC] - Increment Frame Count
   //
   //  The console software sets this bit to increment the Frame Counter
   //  The FPGA resets this bit after reading.
   //

   always @(posedge clk)
     begin
        if (rst | mtINIT)
          mtINCFC <= 0;
        else
          mtINCFC <= mtWRHI & mtWSTRB[3] & mtCSLDATAI[bINCFC];
     end

   //
   // mtDIR[BOT] - Beginning of tape
   //
   //  The console software sets these bits to indicate a beginning of tape
   //  condition.  The FPGA does not modify this bit.
   //
   //  Each tape transport maintains its own BOT signal
   //

   logic mtBOTA[7:0];

   always @(posedge clk)
     begin
        if (rst)
          begin
             mtBOTA[0] <= 0;
             mtBOTA[1] <= 0;
             mtBOTA[2] <= 0;
             mtBOTA[3] <= 0;
             mtBOTA[4] <= 0;
             mtBOTA[5] <= 0;
             mtBOTA[6] <= 0;
             mtBOTA[7] <= 0;
          end
        else if (mtWRHI & mtWSTRB[1] & mtCSLDATAI[bCLRBOT])
          mtBOTA[mtSS] <= 0;
        else if (mtWRHI & mtWSTRB[1] & mtCSLDATAI[bSETBOT])
          mtBOTA[mtSS] <= 1;
     end

   assign mtBOT  = mtBOTA[mtSS];

   //
   // mtDIR[EOT] - End of tape
   //
   //  The console software sets these bits to indicate a end of tape
   //  condition.  The FPGA does not modify this bit.
   //
   //  Each tape transport maintains its own EOT signal
   //

   logic mtEOTA[7:0];

   always @(posedge clk)
     begin
        if (rst)
          begin
             mtEOTA[0] <= 0;
             mtEOTA[1] <= 0;
             mtEOTA[2] <= 0;
             mtEOTA[3] <= 0;
             mtEOTA[4] <= 0;
             mtEOTA[5] <= 0;
             mtEOTA[6] <= 0;
             mtEOTA[7] <= 0;
          end
        else if (mtWRHI & mtWSTRB[0] & mtCSLDATAI[bCLREOT])
          mtEOTA[mtSS] <= 0;
        else if (mtWRHI & mtWSTRB[0] & mtCSLDATAI[bSETEOT])
          mtEOTA[mtSS] <= 1;
     end

   assign mtEOT = mtEOTA[mtSS];

   //
   // mtIDB - ID Burst
   //
   //  The IDB logic uses the PES logic.
   //
   //  Each tape transport maintains its own IDB signal
   //

   logic mtIDBA[7:0];

   always @(posedge clk)
     begin
        if (rst | mtINIT)
          begin
             mtIDBA[0] <= 0;
             mtIDBA[1] <= 0;
             mtIDBA[2] <= 0;
             mtIDBA[3] <= 0;
             mtIDBA[4] <= 0;
             mtIDBA[5] <= 0;
             mtIDBA[6] <= 0;
             mtIDBA[7] <= 0;
          end
        else if (((state == stateDECODE) & (mtFUN == `mtCS1_FUN_WRFWD ) & mtBOT) |
                 ((state == stateDECODE) & (mtFUN == `mtCS1_FUN_RDFWD ) & mtBOT) |
                 ((state == stateDECODE) & (mtFUN == `mtCS1_FUN_SPCFWD) & mtBOT))
          mtIDBA[mtSS] <= mtPES;
     end

   assign mtIDB = mtIDBA[mtSS];

   //
   // mtPES
   //
   //  This signal emulates the formatting state off the tape.  Unlike a real
   //  tape, this state is not persistent (not written on the tape). This signal
   //  maintains semi-persitent state that is not reset by Drive Clear, etc.
   //  This should be good enough for the diagnostics.
   //
   //  mtPES is negated when the tape transport is taken off-line (or unloaded),
   //  or the tape transport is written in NRZI mode at BOT. mtPES not not
   //  negated by a Massbus INIT signal.
   //
   //  mtPES is asserted when the tape transport is written in PE mode at BOT.
   //
   //  Each tape transport maintains its own mtPES signal
   //

   logic mtPESA[7:0];

   always @(posedge clk)
     begin
        if (rst)
          begin
             mtPESA[0] <= 0;
             mtPESA[1] <= 0;
             mtPESA[2] <= 0;
             mtPESA[3] <= 0;
             mtPESA[4] <= 0;
             mtPESA[5] <= 0;
             mtPESA[6] <= 0;
             mtPESA[7] <= 0;
          end
        else if ((state == stateIDLE) & (mtFUN == `mtCS1_FUN_WRFWD) & mtBOT)
          mtPESA[mtSS] <= (mtDEN == `mtTC_DEN_1600);
        else if (mtSLA)
          mtPESA[mtSS] <= 0;
     end

   assign mtPES = mtPESA[mtSS];

   //
   // mtDIR[TM] - Tape Mark
   //
   //  The console software sets this bit to indicate a tape mark condition.
   //  The FPGA does not modify this bit.
   //

   always @(posedge clk)
     begin
        if (rst | mtINIT | mtDRVCLR | mtWRHI & mtWSTRB[0] & mtCSLDATAI[bCLRTM])
          mtTM <= 0;
        else if (mtWRHI & mtWSTRB[0] & mtCSLDATAI[bSETTM])
          mtTM <= 1;
     end

   //
   // mtDATAO
   //
   // There is an endian-swap here.
   //

   always @(posedge clk)
     begin
        if (rst)
          mtDATAO <= 0;
        else
          begin
             if (mtWRHI & mtWSTRB[0])
               mtDATAO[ 0: 3] <= mtCSLDATAI[3 : 0];
             if (mtWRLO & mtWSTRB[3])
               mtDATAO[ 4:11] <= mtCSLDATAI[31:24];
             if (mtWRLO & mtWSTRB[2])
               mtDATAO[12:19] <= mtCSLDATAI[23:16];
             if (mtWRLO & mtWSTRB[1])
               mtDATAO[20:27] <= mtCSLDATAI[15: 8];
             if (mtWRLO & mtWSTRB[0])
               mtDATAO[28:35] <= mtCSLDATAI[ 7: 0];
          end
     end

   //
   // State Machine
   //

   logic         mtFWD;                 // Direction of last motion
   logic         mtSTB;                 // Strobe out
   logic [35: 0] mtDIRD;                // Data from tape controller to console processor
   logic [15: 0] mtRDCNT;               // Read counter
   logic [15: 0] mtWRCNT;               // Write counter
   logic [31: 0] mtACCLTIM;             // Delay timer
   logic [31: 0] mtSDWNTIM;             // Settle-down timer
   logic [ 7: 0] lastMOL;               // Last MOL

   always @(posedge clk)
     begin
        if (rst | mtINIT | mtDRVCLR)
          begin
             mtACCL    <= 1;
             mtACCLTIM <= 0;
             mtSLA     <= 0;
             mtPIP     <= 0;
             mtATA     <= 0;
             mtSSC     <= 0;
             mtDRY     <= 1;
             mtWCE     <= 0;
             mtSTB     <= 0;
             mtMDF     <= 0;
             mtDIRD    <= 0;
             mtREQO    <= 0;
             mtNPRO    <= 0;
             mtINCWC   <= 0;
             mtINCBA   <= 0;
             mtDECBA   <= 0;
             state     <= stateINIT;
             if (rst)
               begin
                  mtFWD      <= 0;
                  mtSDWN     <= 0;
                  mtSDWNTIM  <= 0;
                  lastMOL[0] <= 0;
                  lastMOL[1] <= 0;
                  lastMOL[2] <= 0;
                  lastMOL[3] <= 0;
                  lastMOL[4] <= 0;
                  lastMOL[5] <= 0;
                  lastMOL[6] <= 0;
                  lastMOL[7] <= 0;
                  mtRDCNT    <= 0;
                  mtWRCNT    <= 0;
               end
             else if (mtDRVCLR)
               begin
                  ;
               end
          end
        else
          begin

             //
             // Handle transitions of MOL for each transport
             //

             if ((mtMOL[0] != lastMOL[0]) |
                 (mtMOL[1] != lastMOL[1]) |
                 (mtMOL[2] != lastMOL[2]) |
                 (mtMOL[3] != lastMOL[3]) |
                 (mtMOL[4] != lastMOL[4]) |
                 (mtMOL[5] != lastMOL[5]) |
                 (mtMOL[6] != lastMOL[6]) |
                 (mtMOL[7] != lastMOL[7]))
               begin
                  mtSSC <= 1;
                  mtSLA <= 1;
               end
             lastMOL[0] <= mtMOL[0];
             lastMOL[1] <= mtMOL[1];
             lastMOL[2] <= mtMOL[2];
             lastMOL[3] <= mtMOL[3];
             lastMOL[4] <= mtMOL[4];
             lastMOL[5] <= mtMOL[5];
             lastMOL[6] <= mtMOL[6];
             lastMOL[7] <= mtMOL[7];

             //
             // Update Settledown Timer
             //

             if (mtSDWNTIM != 0)
               mtSDWNTIM <= mtSDWNTIM - 1'b1;
             else
               mtSDWN <= 0;

             //
             // Clear ATA
             //

             if (mtCLRATA)
               mtATA <= 0;

             //
             // Handle state machine
             //

             case (state)

               //
               // stateINIT
               //

               stateINIT:
                 state <= stateIDLE;

               //
               // stateIDLE
               //
               // Wait for a command to go process
               //

               stateIDLE:
                 if (mtGO)
                   state <= stateDLY;

               //
               // stateDLY
               //
               // Delay a clock cycle. Wait for errors to propigate, if any.
               //

               stateDLY:
                 state <= stateTSTERR;

               //
               // stateTSTERR
               //
               // Test for Errors. Abort commands if any errors.
               //
               // The purpose of this logic is to quickly triage the command and
               // decide what to do.
               //

               stateTSTERR:
                 if (!mtNEF & !mtFMTE)
                   begin
                      case (mtFUN)

                        //
                        // Commands that don't require motion
                        //

                        `mtCS1_FUN_NOP,
                        `mtCS1_FUN_DRVCLR:
                          begin
                             state <= stateIDLE;
                          end

                        //
                        // Rewind commands
                        //

                        `mtCS1_FUN_UNLOAD,
                        `mtCS1_FUN_REWIND,
                        `mtCS1_FUN_PRESET:
                          begin
                             if (mtSDWN & mtFWD)
                               begin
                                  mtDRY <= 0;
                                  state <= stateSDWN;
                               end
                             else
                               state <= stateDECODE;
                          end

                        //
                        // Reverse commands
                        //

                        `mtCS1_FUN_SPCREV,
                        `mtCS1_FUN_WRCHKREV,
                        `mtCS1_FUN_RDREV:
                          begin
                             if (mtBOT)
                               state <= stateIDLE;
                             else if (mtSDWN & mtFWD)
                               state <= stateSDWN;
                             else
                               state <= stateDECODE;
                          end

                        //
                        // Forward commands that can be write protected
                        //

                        `mtCS1_FUN_ERASE,
                        `mtCS1_FUN_WRTM,
                        `mtCS1_FUN_WRFWD:
                          begin
                             mtDRY <= 0;
                             if (mtWRL)
                               state <= stateIDLE;
                             else if (mtSDWN & !mtFWD)
                               state <= stateSDWN;
                             else
                               state <= stateDECODE;
                          end

                        //
                        // Forward commands
                        //

                        `mtCS1_FUN_SPCFWD,
                        `mtCS1_FUN_WRCHKFWD,
                        `mtCS1_FUN_RDFWD:
                          begin
                             if (mtSDWN & !mtFWD)
                               state <= stateSDWN;
                             else
                               state <= stateDECODE;
                          end
                      endcase
                   end

               //
               // stateSDWN:
               //   Settling down time
               //

               stateSDWN:
                 begin
                    mtDRY <= 0;
                    if (!mtSDWN)
                      state <= stateDECODE;
                 end

               //
               // stateDECODE:
               //

               stateDECODE:
                 begin

                    //
                    // Stop settle down timer
                    //

                    mtSDWNTIM <= 0;
                    mtSDWN <= 0;

                    //
                    // Decode Command (Function)
                    //
                    // Trace:
                    //  M8909/MBI5/E67
                    //  See truth table for PROM.
                    //

                    case (mtFUN)

                      //
                      // Rewind-like commands
                      //
                      //  If this is a direction change, wait for SDWN
                      //  if necessary. Rewind-like commands signal
                      //  MTDS[DRY] immediately.
                      //
                      //  See TM03 Magnetic Tape Formatter User Guide
                      //  Section 2.3.3 for details on this function.
                      //

                      `mtCS1_FUN_UNLOAD,
                      `mtCS1_FUN_REWIND,
                      `mtCS1_FUN_PRESET:
                        begin

                           //
                           // Drive is at BOT
                           //

                           if (mtBOT)
                             begin
                                mtDRY <= 1;
                                mtATA <= 1;
                                mtSSC <= 1;
                                state <= stateDONE;
                             end

                           //
                           // Drive is not at BOT
                           //

                           else
                             begin
                                mtDRY     <= 1;
                                mtATA     <= 1;
                                mtPIP     <= 1;
                                mtACCLTIM <= mtACCLVAL;
                                state     <= stateACCL;
                             end
                        end

                      //
                      // Space forward and space reverse set PIP
                      //

                      `mtCS1_FUN_SPCFWD,
                      `mtCS1_FUN_SPCREV:
                        begin
                           mtDRY     <= 0;
                           mtPIP     <= 1;
                           mtACCLTIM <= mtACCLVAL;
                           state     <= stateACCL;
                        end

                      //
                      // Everything else
                      //

                      default:
                        begin
                           mtDRY     <= 0;
                           mtACCLTIM <= mtACCLVAL;
                           state     <= stateACCL;
                        end

                    endcase
                 end

               //
               // stateACCL
               //  Wait for ACCL timer to expire.
               //

               stateACCL:
                 if (mtACCLTIM == 0)
                   begin
                      mtACCL <= 0;
                      case (mtFUN)
                        `mtCS1_FUN_WRCHKFWD,
                        `mtCS1_FUN_WRCHKREV:
                          begin
                             state <= stateWRCHK;
                          end
                        `mtCS1_FUN_WRFWD:
                          begin
                             state <= stateWRITE;
                          end
                        `mtCS1_FUN_RDFWD,
                        `mtCS1_FUN_RDREV:
                          begin
                             state <= stateREAD;
                          end
                        default:
                          begin
                             state <= stateSTARTEXEC;
                          end
                      endcase
                   end
                 else
                   mtACCLTIM <= mtACCLTIM - 1'b1;

               //
               // stateWRCHK
               //  Write check forward or write check reverse
               //

               stateWRCHK:
                 begin
                    mtNPRO  <= 1;
                    mtMDF   <= 0;
                    mtFWD   <= (mtFUN == `mtCS1_FUN_WRCHKFWD);
                    mtRDCNT <= mtRDCNT + 1'b1;
                    state   <= stateWRCHK0;
                 end

               //
               // stateWRCHK0
               //  Read data from console processor. Start an NPRO cycle.
               //
               //  This is a loop destination
               //

               stateWRCHK0:
                 begin
                    mtDECBA <= 0;
                    mtINCBA <= 0;
                    mtINCWC <= 0;
                    if (mtREADY)
                      begin
                         state <= stateDONE;
                      end
                    else if (mtWRHI & mtWSTRB[3] & mtCSLDATAI[bSTB])
                      begin
                         mtREQO <= 1;
                         state  <= stateWRCHK1;
                      end
                 end

               //
               // stateWRCHK1
               //
               //  Wait for NPR ACK.
               //  Modify the Base Address Register and increment the Word Count Register
               //  Loop
               //

               stateWRCHK1:
                 if (mtACKI)
                   begin
                      mtREQO  <= 0;
                      mtDECBA <= (mtFUN == `mtCS1_FUN_WRCHKREV);
                      mtINCBA <= (mtFUN == `mtCS1_FUN_WRCHKFWD);
                      mtINCWC <= 1;
                      state   <= stateWRCHK0;
                   end

               //
               // stateWRITE
               //  Write forward
               //

               stateWRITE:
                 begin
                    mtNPRO  <= 0;
                    mtMDF   <= 0;
                    mtFWD   <= 1;
                    mtWRCNT <= mtWRCNT + 1'b1;
                    state   <= stateWRITE0;
                 end

               //
               // stateWRITE0
               //  Start NPR cycle to read data from memory.
               //
               //  This is a loop destination
               //

               stateWRITE0:
                 begin
                    mtDECBA <= 0;
                    mtINCBA <= 0;
                    mtINCWC <= 0;
                    if (mtREADY)
                      begin
                         state <= stateDONE;
                      end
                    else
                      begin
                         mtREQO <= 1;
                         state <= stateWRITE1;
                      end
                 end

               //
               // stateWRITE1
               //
               //  Wait for NPR ACK.  Assert mtSTB
               //

               stateWRITE1:
                 begin
                    if (mtACKI)
                      begin
                         mtREQO <= 0;
                         mtSTB  <= 1;
                         mtDIRD <= mtDATAI;     // endian swap here
                         mtMDF  <= mtMDF ^ parity(mtDATAI, mtFMT);
                         state  <= stateWRITE2;
                      end
                 end

               //
               // stateWRITE2
               //
               //  Wait for software to negate mtSTB
               //

               stateWRITE2:
                 begin
                    if (mtWRHI & mtWSTRB[3] & !mtCSLDATAI[bSTB])
                      begin
                         mtSTB   <= 0;
                         mtDIRD  <= 0;
                         mtDECBA <= 0;
                         mtINCBA <= 1;
                         mtINCWC <= 1;
                         state   <= stateWRITE0;
                      end
                 end

               //
               // stateREAD
               //  Read Forward or Read Reverse
               //

               stateREAD:
                 begin
                    mtNPRO  <= 1;
                    mtMDF   <= 0;
                    mtFWD   <= (mtFUN == `mtCS1_FUN_RDFWD);
                    mtRDCNT <= mtRDCNT + 1'b1;
                    state   <= stateREAD0;
                 end

               //
               // stateREAD0
               //  Read data from console processor. Start an NPRO cycle.
               //
               //  This is a loop destination
               //

               stateREAD0:
                 begin
                    mtDECBA <= 0;
                    mtINCBA <= 0;
                    mtINCWC <= 0;
                    if (mtREADY)
                      begin
                         state <= stateDONE;
                      end
                    else if (mtWRHI & mtWSTRB[3] & mtCSLDATAI[bSTB])
                      begin
                         mtREQO <= 1;
                         state  <= stateREAD1;
                      end
                 end

               //
               // stateREAD1
               //
               //  Wait for NPR ACK.
               //  Modify the Base Address Register and increment the Word
               //  Count Register.
               //  Loop
               //

               stateREAD1:
                 if (mtACKI)
                   begin
                      mtREQO  <= 0;
                      mtDECBA <= (mtFUN == `mtCS1_FUN_RDREV);
                      mtINCBA <= (mtFUN == `mtCS1_FUN_RDFWD);
                      mtINCWC <= 1;
                      state   <= stateREAD0;
                   end

               //
               // stateSTARTEXEC:
               //

               stateSTARTEXEC:
                 begin
                    state <= stateEXECCMD;
                 end

               //
               // statEXECCMD
               //  Wait for the software to do it's thing.
               //  These are commands that don't exchange data.
               //  The software sets READY when it is completed.
               //

               stateEXECCMD:
                 if (mtREADY)
                   begin
                      case (mtFUN)
                        `mtCS1_FUN_UNLOAD,
                        `mtCS1_FUN_REWIND,
                        `mtCS1_FUN_PRESET:
                          begin
                             mtFWD <= 0;
                             mtATA <= 1;
                             mtSSC <= 1;
                          end
                        `mtCS1_FUN_WRTM,
                        `mtCS1_FUN_ERASE,
                        `mtCS1_FUN_SPCFWD:
                          begin
                             mtFWD <= 1;
                          end
                        `mtCS1_FUN_SPCREV:
                          begin
                             mtFWD <= 0;
                          end
                      endcase
                      state <= stateDONE;
                   end

               //
               // stateDONE:
               //  Report drive ready
               //

               stateDONE:
                 begin
                    mtPIP     <= 0;
                    mtDRY     <= 1;
                    mtREQO    <= 0;
                    mtNPRO    <= 0;
                    mtSDWN    <= 1;
                    mtACCL    <= 1;
                    mtSDWNTIM <= mtSDWNVAL;
                    state     <= stateIDLE;
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
   // Data Interface Register
   //

   assign mtDIRO = {// Byte 3
                    mtNPRO,     // 63 (READ/Deprecated)
                    mtSTB,      // 62 STB
                    1'b0,       // 61 (INIT/Deprecated)
                    mtREADY,    // 60 READY
                    mtINCFC,    // 59 INCFC
                    mtSS[2:0],  // 58-56
                    // Byte 2
                    mtDEN[2:0], // 55-53
                    mtFUN[5:1], // 52-48
                    // Byte 1
                    mtFMT[3:0], // 47-44
                    mtWCZ,      // 43 WCZ
                    mtFCZ,      // 42 FCZ
                    1'b0,       // 41 SETBOT
                    1'b0,       // 40 CLRBOT
                    // Byte 0
                    1'b0,       // 39 SETEOT
                    1'b0,       // 38 CLREOT
                    1'b0,       // 37 SETTM
                    1'b0,       // 36 CLRTM
                    // Byte 3:0
                    mtDIRD[35:0]};// 35-0

   //
   // Debug Output
   //

   assign mtDEBUG = {state, 8'h00, 8'h00, 8'h00, mtWRCNT, mtRDCNT};

endmodule
