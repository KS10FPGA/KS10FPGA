////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DUP11 Transmitter
//
// Details
//   This file provides the implementation of the DUP11 Transmitter
//
// File
//   duptx.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2021 Rob Doyle
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

module DUPTX (
      input  wire         clk,          // Clock
      input  wire         rst,          // Reset
      input  wire         dupINIT,      // Initialize
      input  wire         dupDECMD,     // DEC mode
      input  wire         dupCRCI,      // CRC Inhibit
      input  wire [12:11] dupMSEL,      // Maintenance mode select
      input  wire         dupSEND,      // Send
      input  wire         dupTXABRT,    // Abort message
      input  wire         dupTXEOM,     // End of message
      input  wire         dupTXSOM,     // Start of message
      input  wire [ 7: 0] dupTXDAT,     // Transmitter data
      input  wire         dupTXCEN,     // Transmitter clock enable
      input  wire         dupRXCEN,     // Receiver clock enable
      input  wire         dupTXDBUFWR,  // TXDBUF Write
      output reg          dupTXDONE,    // Transmitter done
      output wire         dupMDO,       // Serial Data
      output wire         dupTXCRC,     // Transmitter CRC LSB
      output reg          dupTXDLE,     // Data Late Error
      output reg          dupTXACT,     // Active
      output wire         dupTXD        // Serial Data
   );

   //
   // Signals
   //

   wire [15:0] dupCRC;                  // Transmitter CRC
   wire        dupEMPTY;                // Serial transmitter is empty
   wire        dupLAST;                 // Last bit of character

   //
   // Transmitter state machine
   //

   localparam [3:0] stateIDLE        =  0,
                    stateSTARTDELAY1 =  1,
                    stateSTARTDELAY2 =  2,
                    stateSTARTDELAY3 =  3,
                    statePREFLAG1    =  4,
                    statePREFLAG2    =  5,
                    stateSTARTSYNC   =  6,
                    statePAYLOAD     =  7,
                    stateSENDCRCHI   =  8,
                    stateSENDCRCLO   =  9,
                    stateMARKHOLD    = 10,
                    stateWAIT        = 11,
                    stateDONE        = 12;

   reg [3:0] state;
   reg       dupLOAD;
   reg       dupFLAG;
   reg       dupABRT;
   reg       dupZBI;
   reg       dupCRCINIT;
   reg [7:0] dupCRCLO;
   reg [7:0] dupDATA;

   always @(posedge clk)
     begin
        if (rst)
          begin
             dupTXACT   <= 0;
             dupFLAG    <= 0;
             dupABRT    <= 0;
             dupZBI     <= 0;
             dupLOAD    <= 0;
             dupDATA    <= 0;
             dupCRCLO   <= 0;
             dupCRCINIT <= 0;
             dupTXDONE  <= 0;
             state      <= stateIDLE;
          end
        else
          begin
             if (dupINIT)
               begin
                  dupTXACT   <= 0;
                  dupFLAG    <= 0;
                  dupABRT    <= 0;
                  dupZBI     <= 0;
                  dupDATA    <= 0;
                  dupLOAD    <= 0;
                  dupCRCLO   <= 0;
                  dupCRCINIT <= 0;
                  dupTXDONE  <= 1;
                  state      <= stateIDLE;
               end
             else
               begin

                  dupFLAG    <= 0;
                  dupABRT    <= 0;
                  dupZBI     <= 0;
                  dupLOAD    <= 0;
                  dupCRCINIT <= 0;

                  //
                  // Clear TXDONE on writes to TXDBUF
                  //

                  if (dupTXDBUFWR)
                    dupTXDONE <= 0;

                  //
                  // Handle abort sequences
                  //

                  if (dupEMPTY & dupSEND & dupTXABRT)
                    begin
                       dupFLAG <= 0;
                       dupABRT <= 1;
                       dupZBI  <= 0;
                       dupLOAD <= 1;
                       dupDATA <= 0;
                       state   <= stateWAIT;
                    end

                  else

                    case (state)

                      //
                      // stateIDLE
                      //
                      // Wait for something to do.  Things get interesting when
                      // both SEND and TXSOM are set.
                      //
                      // If both TXSOM and TXEOM are set, do the 16-zero preflag
                      // sequence. This is tested by TEST 60.
                      //

                      stateIDLE:
                        if (dupTXCEN & dupSEND & dupTXSOM)
                          if (!dupDECMD & dupTXEOM)
                            state <= statePREFLAG1;
                          else
                            state <= stateSTARTDELAY1;

                      //
                      // stateSTARTDELAY1
                      //
                      // Delay first clock cycle.
                      //

                      stateSTARTDELAY1:
                        if (dupTXCEN)
                          state <= stateSTARTDELAY2;

                      //
                      // stateSTARTDELAY2
                      //
                      // Delay second clock cycle
                      //

                      stateSTARTDELAY2:
                        if (dupTXCEN)
                          state <= stateSTARTDELAY3;

                      //
                      // stateSTARTDELAY3
                      //
                      // Decide what to do.
                      //

                      stateSTARTDELAY3:
                        begin
                           dupTXACT <= 1;
                           if (dupTXCEN)
                             state <= stateSTARTSYNC;
                        end

                      //
                      // statePREFLAG1
                      //
                      // Send first 8-bits of the 16-bit preflag sequence
                      //
                      // TXSOM and TXEOM were simultaneously asserted from the
                      // IDLE state. This initiates a sequence of 16 zeros.
                      // When the first zero bit is presented to the serial
                      // output, TXDONE is set.
                      //

                      statePREFLAG1:
                        if (dupTXCEN)
                          begin
                             dupFLAG   <= 0;
                             dupABRT   <= 0;
                             dupZBI    <= 0;
                             dupLOAD   <= 1;
                             dupDATA   <= 0;
                             dupTXDONE <= 1;
                             state     <= statePREFLAG2;
                          end

                      //
                      // statePREFLAG2
                      //
                      // Send second 8-bits of the 16-bit preflag sequence
                      //
                      // TXDONE is not set after the first 8-bits.
                      //

                      statePREFLAG2:
                        if (dupEMPTY)
                          begin
                             dupFLAG <= 0;
                             dupABRT <= 0;
                             dupZBI  <= 0;
                             dupLOAD <= 1;
                             dupDATA <= 0;
                             state   <= stateSTARTSYNC;
                          end

                      //
                      // state_STARTSYNC:
                      //
                      // In DEC Mode, this sends SYN characters from the TXDBUF.
                      // In SDLC Mode, this sends Flag characters.
                      //
                      // Send "SYNC" Characters as long as TXSOM is asserted.
                      //
                      // If SEND negates while sending "SYNC" Characters, finish
                      // the current character, empty the transmitter buffer (if
                      // full), and finish the transmission.
                      //

                      stateSTARTSYNC:
                        begin
                           if (dupEMPTY)
                             if (dupSEND)
                               begin
                                  if (dupTXSOM)
                                    begin
                                       dupABRT   <= 0;
                                       dupZBI    <= 0;
                                       dupLOAD   <= 1;
                                       dupTXDONE <= 1;
                                       if (dupDECMD)
                                         begin
                                            dupFLAG <= 0;
                                            dupDATA <= dupTXDAT;
                                         end
                                       else
                                         begin
                                            dupFLAG <= 1;
                                            dupDATA <= 0;
                                         end
                                    end
                                  else
                                    begin
                                       dupCRCINIT <= 1;
                                       state      <= statePAYLOAD;
                                    end
                               end
                             else
                               if (dupTXDONE)
                                 state <= stateDONE;
                               else
                                 state <= statePAYLOAD;
                        end

                      //
                      // statePAYLOAD
                      //
                      // Send message data.  Continue sending data until either
                      // SEND is negated or TXEOM is asserted.
                      //

                      statePAYLOAD:
                        if (dupEMPTY)
                          if (dupSEND)
                            if (dupTXEOM)
                              begin
                                 if (dupCRCI)
                                   begin
                                      if (dupDECMD)
                                        state <= stateDONE;
                                      else
                                        begin
                                           dupFLAG <= 1;
                                           dupABRT <= 0;
                                           dupZBI  <= 1;
                                           dupLOAD <= 1;
                                           dupDATA <= 0;
                                           state   <= stateWAIT;
                                        end
                                   end
                                 else
                                   begin
                                      dupFLAG   <= 0;
                                      dupABRT   <= 0;
                                      dupZBI    <= !dupDECMD;
                                      dupLOAD   <= 1;
                                      dupTXDONE <= 1;
                                      state     <= stateSENDCRCHI;
                                      if (dupDECMD)
                                        begin
                                           dupDATA  <= dupCRC[ 7:0];
                                           dupCRCLO <= dupCRC[15:8];
                                        end
                                      else
                                        begin
                                           dupDATA  <= ~dupCRC[ 7:0];
                                           dupCRCLO <= ~dupCRC[15:8];
                                        end
                                   end
                              end
                            else /* !dupTXEOM */
                              begin
                                 if (dupTXDONE)
                                   begin
                                      state <= stateMARKHOLD;
                                   end
                                 else
                                   begin
                                      dupFLAG   <= 0;
                                      dupABRT   <= 0;
                                      dupZBI    <= !dupDECMD;
                                      dupLOAD   <= 1;
                                      dupTXDONE <= 1;
                                      dupDATA   <= dupTXDAT;
                                   end
                              end
                          else /* !dupSEND */
                            if (dupTXDONE)
                              state <= stateDONE;
                            else
                              begin
                                 dupFLAG <= 0;
                                 dupABRT <= 0;
                                 dupZBI  <= !dupDECMD;
                                 dupLOAD <= 1;
                                 dupDATA <= dupTXDAT;
                                 state   <= stateWAIT;
                              end

                      //
                      // stateSENDCRCHI
                      //
                      // Wait for the high byte of the CRC to complete.  When
                      // done, start sending the low byte of the CRC.
                      //

                      stateSENDCRCHI:
                        if (dupEMPTY)
                          begin
                             dupFLAG <= 0;
                             dupABRT <= 0;
                             dupZBI  <= !dupDECMD;
                             dupLOAD <= 1;
                             dupDATA <= dupCRCLO;
                             state   <= stateSENDCRCLO;
                          end

                      //
                      // stateSENDCRCLO
                      //
                      // In DEC Mode:
                      //
                      //     Wait for low byte of the CRC to complete and then
                      //     do normal message termination.
                      //
                      // In SDLC Mode:
                      //
                      //     Wait for the low byte of the CRC to complete. At
                      //     this point one of three things can happen as
                      //     controlled by the program.
                      //
                      //     1.  SEND negates.  The end flag character is sent
                      //         and a normal message termination follows.
                      //
                      //     2.  EOM negates. The flag character is sent and
                      //         another transmission begins.  In this case, a
                      //         single flag character sperates the two
                      //         transmissions.
                      //
                      //     3.  SEND and EOM stay asserted.  Flag characters
                      //         will be repeated sent until either SEND negates
                      //         or EOM negates.
                      //

                      stateSENDCRCLO:
                        if (dupEMPTY)
                          begin
                             if (dupDECMD)
                               state <= stateDONE;
                             else
                               begin
                                  dupFLAG <= 1;
                                  dupABRT <= 0;
                                  dupZBI  <= 0;
                                  dupLOAD <= 1;
                                  dupDATA <= 0;
                                  if (dupSEND)
                                    if (dupTXEOM)
                                      state <= stateSENDCRCLO;
                                    else
                                      state <= statePAYLOAD;
                                  else
                                    state <= stateWAIT;
                               end
                          end

                      //
                      // stateMARKHOLD
                      //
                      // In SDLC mode, when SEND is negated without asserting
                      // TXEOM (sending a CRC and End Flag character), the
                      // system goes to a Mark Hold state where the unit
                      // continuously sends ABORT characters.
                      //
                      // This only way to exit this state is to INIT the DUP11.
                      //

                      stateMARKHOLD:
                        if (dupEMPTY)
                          begin
                             dupFLAG   <= 0;
                             dupABRT   <= 1;
                             dupZBI    <= 0;
                             dupLOAD   <= 1;
                             dupDATA   <= 0;
                             dupTXDONE <= 1;
                             if (!dupSEND)
                               state <= stateWAIT;
                          end

                      //
                      // stateWAIT
                      //
                      // Wait for transmitter to finish
                      //

                      stateWAIT:
                        if (dupEMPTY)
                          state <= stateDONE;

                      //
                      // stateDONE
                      //
                      // Half a clock cycle after the last bit of the message:
                      // 1. TXACT  should negate
                      // 2. TXDONE should assert
                      //

                      stateDONE:
                        if (dupRXCEN)
                          begin
                             dupTXACT  <= 0;
                             dupTXDONE <= 1;
                             state     <= stateIDLE;
                          end

                    endcase
               end
          end
     end

   //
   // Keep track of transtions of the TXSOM
   //

   reg lastTXSOM;
   always @(posedge clk)
     begin
        if (rst)
          lastTXSOM <= 0;
        else
          lastTXSOM <= dupTXSOM;
     end

   //
   // Data Late (Underrun) Error
   //

   always @(posedge clk)
     begin
        if (rst | dupINIT | (dupTXSOM & !lastTXSOM))
          dupTXDLE <= 0;
        else if ((dupRXCEN & dupLAST & dupSEND &  dupTXSOM & dupDECMD & (state == stateSTARTSYNC)) |
                 (dupRXCEN & dupLAST & dupSEND & !dupTXSOM &            (state == stateSTARTSYNC)) |
                 (dupRXCEN & dupLAST & dupSEND & !dupTXEOM &            (state == statePAYLOAD  )))
          dupTXDLE <= dupTXDONE;
     end

   //
   // Synchronous serial transmitter
   //

   wire dupCRCEN;
   USRT_TX uUSRT_TX (
      .clk      (clk),
      .rst      (rst),
      .clr      (dupINIT),
      .clken    (dupTXCEN),
      .abort    (dupABRT),
      .flag     (dupFLAG),
      .data     (dupDATA),
      .zbi      (dupZBI),
      .load     (dupLOAD),
      .crcen    (dupCRCEN),
      .empty    (dupEMPTY),
      .last     (dupLAST),
      .txd      (dupTXD)
   );

   //
   // Transmitter CRC
   //

   wire [15:0] dupCRCREG;
   CRC16 uCRC16 (
      .clk      (clk),
      .rst      (rst),
      .clken    (dupRXCEN & dupCRCEN),
      .init     (dupCRCINIT),
      .decmode  (dupDECMD),
      .din      (dupTXD),
      .crc      (dupCRCREG)
   );

   //
   // The CRC is ones complimented and transposed so that the MSB is
   // transmitted first.
   //

   assign dupCRC = {dupCRCREG[ 0], dupCRCREG[ 1],
                    dupCRCREG[ 2], dupCRCREG[ 3],
                    dupCRCREG[ 4], dupCRCREG[ 5],
                    dupCRCREG[ 6], dupCRCREG[ 7],
                    dupCRCREG[ 8], dupCRCREG[ 9],
                    dupCRCREG[10], dupCRCREG[11],
                    dupCRCREG[12], dupCRCREG[13],
                    dupCRCREG[14], dupCRCREG[15]};
   //
   // TXCRC (LSB)
   //

   assign dupTXCRC = dupCRCREG[0] & (dupMSEL == `dupTXCSR_MSEL_DIAG);

   //
   // MDO
   //

   assign dupMDO = dupTXD;

endmodule
