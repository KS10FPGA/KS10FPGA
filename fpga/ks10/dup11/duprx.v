////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DUP11 Receiver
//
// Details
//   This file provides the implementation of the DUP11 Receiver
//
// File
//   duprx.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2018 Rob Doyle
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

`include "crc16.vh"

module DUPRX (
      input  wire         clk,          // Clock
      input  wire         rst,          // Reset
      input  wire         devLOBYTE,    // Device Low Byte
      input  wire         rxdbufREAD,   // Read RXDBUF
      input  wire         dupINIT,      // Initialize
      input  wire [12:11] dupMSEL,      // Maintenance mode select
      input  wire         dupRXEN,      // Receiver enable
      input  wire         dupMDI,       // Maintenance data in
      input  wire         dupRXCEN,     // Receiver Clock Enable
      input  wire         dupTXCEN,     // Transmitter Clock Enable
      input  wire         dupTXD,       // Transmitter Serial Data
      input  wire         dupRXD,       // Receiver Serial Data
      output reg          dupRXDONE,    // Set Receiver Done
      output reg          dupRXACT,     // Receiver Active
      output wire         dupRXCRC,     // Receiver CRC Register LSB
      input  wire [15: 0] regRXCSR,     // Receiver Control/Status Register
      input  wire [15: 0] regPARCSR,    // Parameter data
      output wire [15: 0] regRXDBUF     // Receiver Data Buffer
   );

   //
   // Valid CRCs for the various modes
   //

   localparam [15:0] dupSDLC_CRC = 16'o16417,
                     dupDEC_CRC  = 16'o00000;

   //
   // RXCSR Bits
   //

   wire dupSTRSYN = `dupRXCSR_STRSYN(regRXCSR);

   //
   // PARCSR Bits
   //

   wire       dupDECMD    = `dupPARCSR_DECMD(regPARCSR);
   wire       dupSSM      = `dupPARCSR_SSM(regPARCSR);
   wire       dupCRCI     = `dupPARCSR_CRCI(regPARCSR);
   wire [7:0] dupRXSYNADR = `dupPARCSR_SYNADR(regPARCSR);

   //
   // Selftest Input Multiplexer
   //

`ifdef DUP11_DEBUG_TX

   wire dupRXIN = dupTXD;

`else

   reg dupRXIN;
   always @*
     begin
        case (dupMSEL)
          `dupTXCSR_MSEL_USER:
            dupRXIN <= dupRXD;
          `dupTXCSR_MSEL_MEXT:
            dupRXIN <= dupRXD;
          `dupTXCSR_MSEL_MINT:
            dupRXIN <= dupTXD;
          `dupTXCSR_MSEL_DIAG:
            dupRXIN <= dupMDI | dupTXD;
        endcase
     end

`endif

   //
   // Watch transitions of rxdbufREAD
   //

   reg lastRXDBUFRD;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          lastRXDBUFRD <= 0;
        else
          lastRXDBUFRD <= rxdbufREAD & devLOBYTE;
     end

   //
   // Synchronous serial receiver
   //

   wire [7:0] dupDATA;
   wire       dupFLAG;
   wire       dupFULL;
   wire       dupABRT;
   wire       dupDECSYN;
   wire       dupCRCEN;

   USRT_RX uUSRT_RX (
      .clk      (clk),
      .rst      (rst),
      .clr      (dupINIT),
      .clken    (dupRXCEN),
      .decmode  (dupDECMD),
      .rxd      (dupRXIN),
      .synchr   (dupRXSYNADR),
      .crcen    (dupCRCEN),
      .full     (dupFULL),
      .flag     (dupFLAG),
      .abort    (dupABRT),
      .decsyn   (dupDECSYN),
      .data     (dupDATA)
   );

   //
   // Receiver Buffer Register
   //

   reg [7:0] dupRXDAT;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          dupRXDAT <= 0;
        else
          if (dupINIT)
            dupRXDAT <= 0;
          else if (dupTXCEN & dupFULL)
            dupRXDAT <= dupDATA;
     end

   //
   // Receiver CRC
   //

   wire [15:0] dupCRCREG;
   reg         dupCRCINIT;

   CRC16 uCRC16 (
      .clk      (clk),
      .rst      (rst),
      .clken    (dupRXCEN & dupCRCEN),
      .init     (dupCRCINIT),
      .decmode  (dupDECMD),
      .din      (dupRXD),
      .crc      (dupCRCREG)
   );

   assign dupRXCRC = dupCRCREG[0] & (dupMSEL == `dupTXCSR_MSEL_DIAG);

   //
   // CRC Check
   //

   reg dupCRCERR;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          dupCRCERR <= 0;
        else
          if (dupINIT)
            dupCRCERR <= 0;
          else if (dupTXCEN & dupFULL)
            begin
               if (dupDECMD)
                 dupCRCERR <= (dupCRCREG != dupDEC_CRC);
               else
                 dupCRCERR <= (dupCRCREG != dupSDLC_CRC);
            end
     end

   //
   // Receiver state machine
   //

   localparam [3:0] stateIDLE        = 0,       // BOTH : Wait for something to do.
                    stateSDLC_SSM    = 1,       // SDLC : Found flag.  Search for another flag or secondary address
                    stateSDLC_SYNC   = 2,       // SDLC : Found flag.  Search for another flag or first char of message.
                    stateSDLC_RECV   = 3,       // SDLC : Receiving message
                    stateSDLC_CLRSOM = 4,       // SDLC : Clear RXSOM
                    stateSDLC_ABRT   = 5,       // SDLC : Abort received
                    stateDEC_SYNC    = 6,       // DEC  : Synchronization completed
                    stateDEC_RECV    = 7;       // DEC  : Receiving message that cannot be sync characters


   reg [3:0] state;
   reg       dupRXSOM;
   reg       dupRXEOM;
   reg       dupRXCRCE;
   reg       dupRXOVR;
   reg       dupRXABRT;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             dupRXACT   <= 0;
             dupRXSOM   <= 0;
             dupRXEOM   <= 0;
             dupRXOVR   <= 0;
             dupRXCRCE  <= 0;
             dupCRCINIT <= 0;
             dupRXABRT  <= 0;
             dupRXDONE  <= 0;
             state      <= stateIDLE;
          end
        else
          if (dupINIT | !dupRXEN)
            begin
               dupRXACT   <= 0;
               dupRXSOM   <= 0;
               dupRXEOM   <= 0;
               dupRXOVR   <= 0;
               dupRXCRCE  <= 0;
               dupRXABRT  <= 0;
               dupCRCINIT <= 0;
               dupRXDONE  <= 0;
               state      <= stateIDLE;
            end
          else
            begin

               //
               // Clear RXABRT and RXDONE after reading character
               //

               if (!rxdbufREAD & lastRXDBUFRD)
                 begin
                    dupRXDONE <= 0;
                    dupRXABRT <= 0;
                 end

               //
               // Initialize CRC on Flag Character
               //

               if (dupTXCEN & dupFLAG)
                 dupCRCINIT <= 1;
               else
                 dupCRCINIT <= 0;

               case (state)

                 //
                 // stateIDLE
                 //
                 // Wait for a sync sequence in whatever mode the receiver is
                 // configured.
                 //

                 stateIDLE:
                   if (dupTXCEN)
                     begin
                        dupRXEOM <= 0;
                        dupRXOVR <= 0;
                        if (dupDECMD)
                          begin
                             if (dupDECSYN)
                               begin
                                  dupRXACT <= 1;
                                  state    <= stateDEC_SYNC;
                               end
                          end
                        else
                          begin
                             if (dupFLAG)
                               begin
                                  dupRXACT <= 1;
                                  if (dupSSM)
                                    state <= stateSDLC_SSM;
                                  else
                                    state <= stateSDLC_SYNC;
                               end
                          end
                     end

                 //
                 // stateSDLC_SSM
                 //
                 // Found the flag character.
                 // 1. If this is an abort character, then abort.
                 // 2. If this is another flag, then resync.
                 // 3. If this character matches the secondary address, then
                 //    the synchronization is complete. Go to the next state.
                 //    a.  Reception of the secondary address sets RXSOM.
                 //    b.  Reception of the secondary address does not assert
                 //        RXDONE.
                 //

                 stateSDLC_SSM:
                   if (dupABRT)
                     state <= stateSDLC_ABRT;
                   else if (dupTXCEN)
                     if (dupFLAG)
                          state <= stateSDLC_SSM;
                     else if (dupFULL)
                       if (dupDATA == dupRXSYNADR)
                         begin
                            dupRXSOM <= 1;
                            state    <= stateSDLC_RECV;
                         end
                       else
                         state <= stateIDLE;

                 //
                 // stateSDLC_SYNC
                 //
                 // Found the flag character.
                 // 1. If this is an abort character, then abort.
                 // 2. If this is another flag, then resync.
                 // 3. If this is a normal character, put the character in the
                 //    RXDBUF[RXDAT] buffer.  Reception of the first message
                 //    character does the following:
                 //    a. Set RXOVR if we overran the buffer (RXDONE still
                 //       asserted)
                 //    a. Set RXSOM
                 //    b. Set RXDONE
                 //

                 stateSDLC_SYNC:
                   if (dupABRT)
                     state <= stateSDLC_ABRT;
                   else if (dupTXCEN)
                     if (dupFLAG)
                       state  <= stateSDLC_SYNC;
                     else if (dupFULL)
                       begin
                          dupRXOVR  <= dupRXDONE;
                          dupRXSOM  <= 1;
                          dupRXDONE <= 1;
                          state     <= stateSDLC_RECV;
                       end

                 //
                 // stateSDLC_RECV
                 //
                 // Continue processing the message.
                 //
                 // In this state, we've processed at least one character that
                 // is not a flag character.  If the character is a flag
                 // character, we're done with the message.
                 //
                 // If the CRC Check is enabled and we get a CRC Error, don't
                 // set RXEOM.
                 //

                stateSDLC_RECV:
                  if (dupABRT)
                    state <= stateSDLC_ABRT;
                  else if (dupTXCEN)
                    if (dupFLAG)
                      begin
                         dupRXACT  <= 0;
                         dupRXEOM  <=  dupCRCI | !dupCRCERR;
                         dupRXCRCE <= !dupCRCI &  dupCRCERR;
                         dupRXDONE <= 1;
                         state     <= stateIDLE;
                      end
                    else if (dupFULL)
                      begin
                         dupRXOVR  <= dupRXDONE;
                         dupRXDONE <= 1;
                         state     <= stateSDLC_CLRSOM;
                      end

                 //
                 // stateSDLC_CLRSOM
                 //
                 // Clear RXSOM on the first bit of the second message
                 // character.
                 //

                 stateSDLC_CLRSOM:
                   if (dupTXCEN)
                     begin
                        dupRXSOM <= 0;
                        state    <= stateSDLC_RECV;
                     end

                 //
                 // stateSDLC_ABRT
                 //
                 // Cleanup after an abort
                 //

                 stateSDLC_ABRT:
                   begin
                      dupRXACT  <= 0;
                      dupRXABRT <= 1;
                      dupRXDONE <= 1;
                      state     <= stateIDLE;
                   end

                 //
                 // stateDEC_SYNC
                 //
                 // Found a SYN character pair.
                 // 1. If this is another SYN charcter pair, then resync.
                 // 2. If this is a normal character, put the character in the
                 //    RXDBUF[RXDAT] buffer.  Reception of the first message
                 //    character does the following:
                 //    a. Set RXOVR if we overran the buffer (RXDONE still
                 //       asserted)
                 //    b. Set RXACT
                 //    c. Set RXDONE
                 //

                 stateDEC_SYNC:
                   if (dupTXCEN)
                     if (dupDECSYN)
                       state <= stateDEC_SYNC;
                     else if (dupFULL)
                       begin
                          dupRXOVR  <= dupRXDONE;
                          dupRXACT  <= 1;
                          dupRXDONE <= 1;
                          state     <= stateDEC_RECV;
                       end

                 //
                 // stateDEC_RECV
                 //
                 // In this state, we've processed at least one character that
                 // is not a SYN character.  If the character is a another SYN
                 // character, start a new message.
                 //

                 stateDEC_RECV:
                   if (dupTXCEN)
                     if (dupDECSYN)
                       state <= stateDEC_SYNC;
                     else if (dupFULL)
                       begin
                          dupRXACT  <= dupRXDONE;
                          dupRXDONE <= 1;
                       end

               endcase
            end
     end

   //
   // Composite error
   //

   wire dupRXERR = dupRXOVR | dupRXCRCE | dupRXABRT;

   //
   // Build upper half of RXDBUF
   //

   assign regRXDBUF = {dupRXERR, dupRXOVR, 1'b0, dupRXCRCE, 1'b0, dupRXABRT, dupRXEOM, dupRXSOM, dupRXDAT};

endmodule
