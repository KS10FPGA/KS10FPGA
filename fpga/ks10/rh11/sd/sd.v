////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RPXX Secure Digital Interface
//
// Details
//   This module contains an interfaced to an SDHC device via a serial SPI
//   connection.
//
// File
//   sd.vhd
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

`include "sd.vh"
`include "sdspi.vh"

`define SDSPI_FAST

module SD (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire         clr,                  // Clear
`ifndef SYNTHESIS
      input  wire [31: 0] file,                 // Debug file
`endif
      // SPI Interface
      input  wire         sdMISO,               // SD Data In
      output wire         sdMOSI,               // SD Data Out
      output wire         sdSCLK,               // SD Clock
      output wire         sdCS,                 // SD Chip Select
      // Device Interface
      input  wire [ 0:35] devDATAI,             // Data Input (Writes)
      output reg  [ 0:35] devDATAO,             // Data Output (Reads)
      output reg          devREQO,              // DMA Request
      input  wire         devACKI,              // DMA Acknowledge
      // RH11
      input  wire [15: 0] rhWC,                 // RH Word Count
      // RPXX
      input  wire [ 1: 0] rpSDOP,               // RP Operation
      input  wire [20: 0] rpSDLSA,              // RP Linear sector address
      input  wire [ 7: 0] rpSDREQ,              // RP requests SD
      output reg  [ 7: 0] rpSDACK,              // SD has finished with RP
      // Output
      output reg          sdINCBA,              // Increment Bus Address
      output reg          sdINCWC,              // Increment Word Count
      output reg          sdINCSECT,            // Increment Sector
      output reg          sdSETWCE,             // Set write check error
      output reg          sdREADOP,             // Read operation
      output wire [ 0:63] sdDEBUG,              // Debug Output
      output reg  [ 2: 0] sdSCAN                // Scan
   );

   //
   // Timing parameters
   //

   localparam [15:0] nCR  =    8;               // NCR from SD Spec
   localparam [15:0] nAC  = 1023;               // NAC from SD Spec
   localparam [15:0] nWR  =   20;               // NWR from SD Spec
   localparam [23:0] nTIM =   ~0;               // 16777215

   //
   // States
   //

   localparam [7:0] stateRESET   =  0,
                    // Init States
                    stateINIT00  =  1,
                    stateINIT01  =  2,
                    stateINIT02  =  3,
                    stateINIT03  =  4,
                    stateINIT04  =  5,
                    stateINIT05  =  6,
                    stateINIT06  =  7,
                    stateINIT07  =  8,
                    stateINIT08  =  9,
                    stateINIT09  = 10,
                    stateINIT10  = 11,
                    stateINIT11  = 12,
                    stateINIT12  = 13,
                    stateINIT13  = 14,
                    stateINIT14  = 15,
                    stateINIT15  = 16,
                    stateINIT16  = 17,
                    stateINIT17  = 18,
                    // Read States
                    stateREAD00  = 19,
                    stateREAD01  = 20,
                    stateREAD02  = 21,
                    stateREAD03  = 22,
                    stateREAD04  = 23,
                    stateREAD05  = 24,
                    stateREAD06  = 25,
                    stateREAD07  = 26,
                    stateREAD08  = 27,
                    stateREAD09  = 28,
                    stateREAD10  = 29,
                    stateREAD11  = 30,
                    stateREAD12  = 31,
                    stateREAD13  = 32,
                    stateREAD14  = 33,
                    stateREAD15  = 34,
                    // Write States
                    stateWRITE00 = 35,
                    stateWRITE01 = 36,
                    stateWRITE02 = 37,
                    stateWRITE03 = 38,
                    stateWRITE04 = 39,
                    stateWRITE05 = 40,
                    stateWRITE06 = 41,
                    stateWRITE07 = 42,
                    stateWRITE08 = 43,
                    stateWRITE09 = 44,
                    stateWRITE10 = 45,
                    stateWRITE11 = 46,
                    stateWRITE12 = 47,
                    stateWRITE13 = 48,
                    stateWRITE14 = 49,
                    stateWRITE15 = 50,
                    stateWRITE16 = 51,
                    stateWRITE17 = 52,
                    stateWRITE18 = 53,
                    stateWRITE19 = 54,
                    stateWRITE20 = 55,
                    stateWRITE21 = 56,
                    stateWRITE22 = 57,
                    stateWRITE23 = 58,
                    // Write Check States
                    stateWRCHK00 = 59,
                    stateWRCHK01 = 60,
                    stateWRCHK02 = 61,
                    stateWRCHK03 = 62,
                    stateWRCHK04 = 63,
                    stateWRCHK05 = 64,
                    stateWRCHK06 = 65,
                    stateWRCHK07 = 66,
                    stateWRCHK08 = 67,
                    stateWRCHK09 = 68,
                    stateWRCHK10 = 69,
                    stateWRCHK11 = 70,
                    stateWRCHK12 = 71,
                    stateWRCHK13 = 72,
                    stateWRCHK14 = 73,
                    stateWRCHK15 = 74,
                    // Other States
                    stateFINI    = 122,
                    stateACKRP   = 123,
                    stateIDLE    = 124,
                    stateDONE    = 125,
                    stateINFAIL  = 126,
                    stateRWFAIL  = 127;

   //
   // Temporary read/write data
   //

   reg [0:35] tempDATA;

   //
   // Input from SPI machine
   //

   wire[ 7:0] spiRXD;                   // SPI received data
   wire       spiDONE;                  // SPI is done

   //
   // State Machine
   //

   reg [ 7:0] sdERR;                    // Error state
   reg [ 7:0] sdVAL;                    // Error value
   reg [ 7:0] sdWRCNT;                  // Write counter
   reg [ 7:0] sdRDCNT;                  // Read counter
   reg [ 7:0] sdCMD [0:5];              // SD command (6 byte)
   reg [ 2:0] spiOP;                    // SPI OP
   reg [ 7:0] spiTXD;                   // SPI transmit data
   reg [15:0] loopCNT;                  // Byte counter
   reg        sectCNT;                  // Sector counter (modulo 2)
   reg [31:0] sectADDR;                 // Sector address
   reg [23:0] timeout;                  // Timeout
   reg [ 7:0] state;                    // State

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             sdERR     <= 0;
             sdVAL     <= 0;
             sdWRCNT   <= 0;
             sdRDCNT   <= 0;
             sdINCSECT <= 0;
             sdINCBA   <= 0;
             sdINCWC   <= 0;
             sdSETWCE  <= 0;
             sdREADOP  <= 0;
             sdSCAN    <= 0;
             rpSDACK   <= 0;
             devREQO   <= 0;
             devDATAO  <= 0;
             sdCMD[0]  <= 0;
             sdCMD[1]  <= 0;
             sdCMD[2]  <= 0;
             sdCMD[3]  <= 0;
             sdCMD[4]  <= 0;
             sdCMD[5]  <= 0;
             spiOP     <= `spiNOP;
             spiTXD    <= 0;
             sectCNT   <= 0;
             sectADDR  <= 0;
             loopCNT   <= 0;
             timeout   <= nTIM;
             state     <= stateRESET;
          end
        else
          if (clr & 0)
            begin
               sdERR     <= 0;
               sdVAL     <= 0;
               sdWRCNT   <= 0;
               sdRDCNT   <= 0;
               sdINCSECT <= 0;
               sdINCBA   <= 0;
               sdINCWC   <= 0;
               sdSETWCE  <= 0;
               sdREADOP  <= 0;
               sdSCAN    <= 0;
               rpSDACK   <= 0;
               devREQO   <= 0;
               devDATAO  <= 0;
               sdCMD[0]  <= 0;
               sdCMD[1]  <= 0;
               sdCMD[2]  <= 0;
               sdCMD[3]  <= 0;
               sdCMD[4]  <= 0;
               sdCMD[5]  <= 0;
               spiOP     <= `spiNOP;
               spiTXD    <= 0;
               sectCNT   <= 0;
               sectADDR  <= 0;
               loopCNT   <= 0;
               tempDATA  <= 0;
               timeout   <= nTIM;
               state     <= stateRESET;
            end
          else
            begin
               devREQO   <= 0;
               rpSDACK   <= 0;
               sdINCBA   <= 0;
               sdINCWC   <= 0;
               sdINCSECT <= 0;
               sdSETWCE  <= 0;
               spiOP     <= `spiNOP;

`ifdef SD_TIMEOUT

               //
               // Handle timeouts
               //

               if (timeout == 0)
                 begin
                    sdERR <= 255;
                    state <= stateINFAIL;
                 end

`endif

               //
               // Run the SD state machine
               //

               case (state)

                 //
                 // stateRESET:
                 //

                 stateRESET:
                   begin
                      tempDATA <= 0;
                      timeout  <= nTIM;
                      loopCNT  <= 0;
                      state    <= stateINIT00;
                   end

                 //
                 // stateINIT00
                 //  Send 8x8 clocks cycles
                 //

                 stateINIT00:
                   begin
                      timeout <= timeout - 1'b1;
                      if (spiDONE | (loopCNT == 0))
                        if (loopCNT == nCR)
                          begin
                             sdCMD[0] <= 8'h40 + 8'd00;   // CMD0
                             sdCMD[1] <= 8'h00;
                             sdCMD[2] <= 8'h00;
                             sdCMD[3] <= 8'h00;
                             sdCMD[4] <= 8'h00;
                             sdCMD[5] <= 8'h95;
                             loopCNT  <= 0;
                             spiOP    <= `spiCSL;
                             state    <= stateINIT01;
                          end
                        else
                          begin
                             spiOP   <= `spiTR;
                             spiTXD  <= 8'hff;
                             loopCNT <= loopCNT + 1'b1;
                          end
                   end

                 //
                 // stateINIT01:
                 //  Send GO_IDLE_STATE command (CMD0)
                 //

                 stateINIT01:
                   begin
                      timeout <= timeout - 1'b1;
                      if (spiDONE | (loopCNT == 0))
                        if (loopCNT == 6)
                          begin
                             loopCNT <= 0;
                             state   <= stateINIT02;
                          end
                        else
                          begin
                             spiOP   <= `spiTR;
                             spiTXD  <= sdCMD[loopCNT];
                             loopCNT <= loopCNT + 1'b1;
                          end
                   end

                 //
                 // stateINIT02:
                 //  Read R1 Response from CMD0
                 //  Response should be 8'h01
                 //

                 stateINIT02:
                   begin
                      timeout <= timeout - 1'b1;
                      if (loopCNT == 0)
                        begin
                           spiOP   <= `spiTR;
                           spiTXD  <= 8'hff;
                           loopCNT <= 1;
                        end
                      else
                        if (spiDONE)
                          if (spiRXD == 8'hff)
                            begin
                               if (loopCNT == nCR)
                                 begin
                                    spiOP   <= `spiCSH;
                                    loopCNT <= 0;
                                    state   <= stateRESET;
                                end
                               else
                                 begin
                                    spiOP   <= `spiTR;
                                    spiTXD  <= 8'hff;
                                    loopCNT <= loopCNT + 1'b1;
                                 end
                            end
                          else
                            begin
                               spiOP   <= `spiCSH;
                               loopCNT <= 0;
                               if (spiRXD == 8'h01)
                                 state <= stateINIT03;
                               else
                                 state <= stateRESET;
                            end
                   end

                 //
                 // stateINIT03:
                 //  Send 8 clock cycles
                 //

                 stateINIT03:
                   begin
                      timeout <= timeout - 1'b1;
                      if (loopCNT == 0)
                        begin
                           spiOP   <= `spiTR;
                           spiTXD  <= 8'hff;
                           loopCNT <= 1;
                        end
                      else if (spiDONE)
                        begin
                           sdCMD[0] <= 8'h40 + 8'd08;   // CMD8
                           sdCMD[1] <= 8'h00;
                           sdCMD[2] <= 8'h00;
                           sdCMD[3] <= 8'h01;
                           sdCMD[4] <= 8'haa;
                           sdCMD[5] <= 8'h87;
                           spiOP    <= `spiCSL;
                           loopCNT  <= 0;
                           state    <= stateINIT04;
                        end
                   end

                 //
                 // stateINIT04:
                 //   Send SEND_IF_COND (CMD8)
                 //

                 stateINIT04:
                   begin
                      timeout <= timeout - 1'b1;
                      if (spiDONE | (loopCNT == 0))
                        if (loopCNT == 6)
                          begin
                             loopCNT <= 0;
                             state   <= stateINIT05;
                          end
                        else
                          begin
                             spiOP   <= `spiTR;
                             spiTXD  <= sdCMD[loopCNT];
                             loopCNT <= loopCNT + 1'b1;
                          end
                   end

                 //
                 // stateINIT05
                 //  Read first byte R1 of R7 Response
                 //  Response should be 8'h01 for V2.00 initialization or
                 //  8'h05 for V1.00 initialization.
                 //

                 stateINIT05:
                   begin
                      timeout <= timeout - 1'b1;
                      if (loopCNT == 0)
                        begin
                           spiOP   <= `spiTR;
                           spiTXD  <= 8'hff;
                           loopCNT <= 1;
                        end
                      else
                        begin
                           if (spiDONE)
                             if (spiRXD == 8'hff)
                               if (loopCNT == nCR)
                                 begin
                                    spiOP   <= `spiCSH;
                                    loopCNT <= 0;
                                    sdERR   <= 1;
                                    state   <= stateINFAIL;
                                 end
                               else
                                 begin
                                    spiOP   <= `spiTR;
                                    spiTXD  <= 8'hff;
                                    loopCNT <= loopCNT + 1'b1;
                                 end
                             else
                               begin
                                  loopCNT   <= 0;
                                  if (spiRXD == 8'h01)
                                      begin
                                         state <= stateINIT06;
                                      end
                                  else if (spiRXD == 8'h05)
                                    begin
                                       spiOP <= `spiCSH;
                                       sdERR <= 2;
                                       state <= stateINFAIL;
                                    end
                                  else
                                    begin
                                       spiOP <= `spiCSH;
                                       sdERR <= 3;
                                       state <= stateINFAIL;
                                    end
                               end
                        end
                   end

                 //
                 // stateINIT06
                 //  Read 32-bit Response to CMD8
                 //  Response should be 8'h00_00_01_aa
                 //    8'h01 - Voltage
                 //    8'h55 - Pattern
                 //

                 stateINIT06:
                   begin
                      timeout <= timeout - 1'b1;
                      case (loopCNT)
                        0:
                          begin
                             spiOP   <= `spiTR;
                             spiTXD  <= 8'hff;
                             loopCNT <= 1;
                          end
                        1:
                          if (spiDONE)
                            if (spiRXD == 8'h00)
                              begin
                                 spiOP   <= `spiTR;
                                 spiTXD  <= 8'hff;
                                 loopCNT <= 2;
                              end
                            else
                              begin
                                 sdERR <= 4;
                                 state <= stateINFAIL;
                              end
                        2:
                          if (spiDONE)
                            if (spiRXD == 8'h00)
                              begin
                                 spiOP   <= `spiTR;
                                 spiTXD  <= 8'hff;
                                 loopCNT <= 3;
                              end
                            else
                              begin
                                 sdERR <= 5;
                                 state <= stateINFAIL;
                              end
                        3:
                          if (spiDONE)
                            if (spiRXD == 8'h01)
                              begin
                                 spiOP   <= `spiTR;
                                 spiTXD  <= 8'hff;
                                 loopCNT <= 4;
                              end
                            else
                              begin
                                 sdERR <= 6;
                                 state <= stateINFAIL;
                              end
                        4:
                          if (spiDONE)
                            if (spiRXD == 8'haa)
                              begin
                                 spiOP   <= `spiCSH;
                                 loopCNT <= 0;
                                 state   <= stateINIT07;
                              end
                            else
                              begin
                                 sdERR <= 7;
                                 state <= stateINFAIL;
                              end
                      endcase
                   end

                 //
                 // stateINIT07:
                 //  Send 8 clock cycles
                 //

                 stateINIT07:
                   begin
                      timeout <= timeout - 1'b1;
                      if (loopCNT == 0)
                        begin
                           spiOP   <= `spiTR;
                           spiTXD  <= 8'hff;
                           loopCNT <= 1;
                        end
                      else if (spiDONE)
                        begin
                           sdCMD[0] <= 8'h40 + 8'd55;   // CMD55
                           sdCMD[1] <= 8'h00;
                           sdCMD[2] <= 8'h00;
                           sdCMD[3] <= 8'h00;
                           sdCMD[4] <= 8'h00;
                           sdCMD[5] <= 8'hff;
                           loopCNT  <= 0;
                           spiOP    <= `spiCSL;
                           state    <= stateINIT08;
                        end
                   end

                 //
                 // stateINIT08:
                 //   Send APP_CMD (CMD55)
                 //

                 stateINIT08:
                   begin
                      timeout <= timeout - 1'b1;
                      if (spiDONE | (loopCNT == 0))
                        begin
                           if (loopCNT == 6)
                             begin
                                loopCNT <= 0;
                                state   <= stateINIT09;
                             end
                           else
                             begin
                                spiOP   <= `spiTR;
                                spiTXD  <= sdCMD[loopCNT];
                                loopCNT <= loopCNT + 1'b1;
                             end
                        end
                   end

                 //
                 // stateINIT09:
                 //  Read R1 response from CMD55.
                 //  Response should be 8'h01
                 //

                 stateINIT09:
                   begin
                      timeout <= timeout - 1'b1;
                      if (loopCNT == 0)
                        begin
                           spiOP   <= `spiTR;
                           spiTXD  <= 8'hff;
                           loopCNT <= 1;
                        end
                      else
                        if (spiDONE)
                          if (spiRXD == 8'hff)
                            if (loopCNT == nCR)
                              begin
                                 spiOP   <= `spiCSH;
                                 loopCNT <= 0;
                                 sdERR   <= 8;
                                 state   <= stateINFAIL;
                              end
                            else
                              begin
                                 spiOP   <= `spiTR;
                                 spiTXD  <= 8'hff;
                                 loopCNT <= loopCNT + 1'b1;
                              end
                          else
                            begin
                               spiOP   <= `spiCSH;
                               loopCNT <= 0;
                               if (spiRXD == 8'h01)
                                 state <= stateINIT10;
                               else
                                 state <= stateINIT07;
                            end
                   end

                 //
                 // stateINIT10:
                 //  Send 8 clock cycles
                 //

                 stateINIT10:
                   begin
                      timeout <= timeout - 1'b1;
                      if (loopCNT == 0)
                        begin
                           spiOP   <= `spiTR;
                           spiTXD  <= 8'hff;
                           loopCNT <= 1;
                        end
                      else if (spiDONE)
                        begin
                           sdCMD[0] <= 8'h40 + 8'd41;   // ACMD41
                           sdCMD[1] <= 8'h40;
                           sdCMD[2] <= 8'h00;
                           sdCMD[3] <= 8'h00;
                           sdCMD[4] <= 8'h00;
                           sdCMD[5] <= 8'hff;
                           loopCNT  <= 0;
                           spiOP    <= `spiCSL;
                           state    <= stateINIT11;
                        end
                   end

                 //
                 // stateINIT11:
                 //  Send SD_SEND_OP_COND (ACMD41)
                 //

                 stateINIT11:
                   begin
                      timeout <= timeout - 1'b1;
                      if (spiDONE | (loopCNT == 0) )
                        if (loopCNT == 6)
                          begin
                             loopCNT <= 0;
                             state   <= stateINIT12;
                          end
                        else
                          begin
                             spiOP   <= `spiTR;
                             spiTXD  <= sdCMD[loopCNT];
                             loopCNT <= loopCNT + 1'b1;
                          end
                   end

                 //
                 // stateINIT12:
                 //  Read R1 response from ACMD41.
                 //  Response should be 8'h00
                 //

                 stateINIT12:
                   begin
                      timeout <= timeout - 1'b1;
                      if (loopCNT == 0)
                        begin
                           spiOP   <= `spiTR;
                           spiTXD  <= 8'hff;
                           loopCNT <= 1;
                        end
                      else
                        if (spiDONE)
                          begin
                             if (spiRXD == 8'hff)
                               begin
                                  if (loopCNT == nCR)
                                    begin
                                       spiOP   <= `spiCSH;
                                       loopCNT <= 0;
                                       sdERR   <= 9;
                                       state   <= stateINFAIL;
                                    end
                                  else
                                    begin
                                       spiOP   <= `spiTR;
                                       spiTXD  <= 8'hff;
                                       loopCNT <= loopCNT + 1'b1;
                                    end
                               end
                             else
                               begin
                                  spiOP   <= `spiCSH;
                                  loopCNT <= 0;
                                  if (spiRXD == 8'h00)
                                    begin
                                       state <= stateINIT13;
                                    end
                                  else
                                    begin
                                       state <= stateINIT07;
                                    end
                               end
                          end
                   end

                 //
                 // stateINIT13
                 //  Send 8 clock cycles
                 //

                 stateINIT13:
                   begin
                      timeout <= timeout - 1'b1;
                      if (loopCNT == 0)
                        begin
                           spiOP   <= `spiTR;
                           spiTXD  <= 8'hff;
                           loopCNT <= 1;
                        end
                      else if (spiDONE)
                        begin
                           sdCMD[0] <= 8'h40 + 8'd58;   // CMD58
                           sdCMD[1] <= 8'h00;
                           sdCMD[2] <= 8'h00;
                           sdCMD[3] <= 8'h00;
                           sdCMD[4] <= 8'h00;
                           sdCMD[5] <= 8'hff;
                           loopCNT <= 0;
                           spiOP   <= `spiCSL;
                           state   <= stateINIT14;
                        end
                   end

                 //
                 // stateINIT14:
                 //  Send READ_OCR (CMD58)
                 //

                 stateINIT14:
                   begin
                      timeout <= timeout - 1'b1;
                      if (spiDONE | (loopCNT == 0))
                        if (loopCNT == 6)
                          begin
                             loopCNT <= 0;
                             state   <= stateINIT15;
                          end
                        else
                          begin
                             spiOP   <= `spiTR;
                             spiTXD  <= sdCMD[loopCNT];
                             loopCNT <= loopCNT + 1'b1;
                          end
                   end

                 //
                 // stateINIT15
                 //  Read first byte of R3 response to CMD58
                 //  Response should be 8'h00
                 //

                 stateINIT15:
                   begin
                      timeout <= timeout - 1'b1;
                      if (loopCNT == 0)
                        begin
                           spiOP   <= `spiTR;
                           spiTXD  <= 8'hff;
                           loopCNT <= 1;
                        end
                      else
                        if (spiDONE)
                          begin
                             if (spiRXD == 8'hff)
                               begin
                                  if (loopCNT == nCR)
                                    begin
                                       spiOP   <= `spiCSH;
                                       loopCNT <= 0;
                                       sdERR   <= 10;
                                       state   <= stateINFAIL;
                                    end
                                  else
                                    begin
                                       spiOP   <= `spiTR;
                                       spiTXD  <= 8'hff;
                                       loopCNT <= loopCNT + 1'b1;
                                    end
                               end
                             else
                               begin
                                  loopCNT    <= 0;
                                  if (spiRXD == 8'h00)
                                    state <= stateINIT16;
                                  else
                                    begin
                                       spiOP <= `spiCSH;
                                       sdERR <= 11;
                                       state <= stateINFAIL;
                                    end
                               end
                          end
                   end

                 //
                 // stateINIT16
                 //  Response should be e0_ff_80_00
                 //  Read 32-bit OCR response to CMD58
                 //

                 stateINIT16:
                   begin
                      timeout <= timeout - 1'b1;
                      case (loopCNT)
                        0:
                          begin
                             spiOP   <= `spiTR;
                             spiTXD  <= 8'hff;
                             loopCNT <= 1;
                          end
                        1:
                          if (spiDONE)
                            begin
                               spiOP   <= `spiTR;
                               spiTXD  <= 8'hff;
                               loopCNT <= 2;
                            end
                        2:
                          if (spiDONE)
                            begin
                               spiOP   <= `spiTR;
                               spiTXD  <= 8'hff;
                               loopCNT <= 3;
                            end
                        3:
                          if (spiDONE)
                            begin
                               spiOP   <= `spiTR;
                               spiTXD  <= 8'hff;
                               loopCNT <= 4;
                            end
                        4:
                          if (spiDONE)
                            begin
                               spiOP   <= `spiCSH;
                               loopCNT <= 0;
                               state   <= stateINIT17;
                            end
                      endcase
                   end

                 //
                 // stateINIT17:
                 //  Send 8 clock cycles
                 //

                 stateINIT17:
                   begin
                      timeout <= timeout - 1'b1;
                      if (loopCNT == 0)
                        begin
                           spiOP   <= `spiTR;
                           spiTXD  <= 8'hff;
                           loopCNT <= 1;
                        end
                      else if (spiDONE)
                        begin
                           loopCNT <= 0;
`ifdef SDSPI_FAST
                           spiOP   <= `spiFAST;
`endif
                           state   <= stateIDLE;
`ifndef SYNTHESIS
                           $fwrite(file, "[%11.3f] RH11: SD Card Initialized Successfully.\n", $time/1.0e3);
                           $fflush(file);
`endif
                        end
                   end

                 //
                 // stateIDLE:
                 //  Wait for a command to process.
                 //  Once the SD card is initialized, it waits in this state
                 //  for either a read (sdopRD) or a write (sdopWR) command.
                 //

                 stateIDLE:
                   begin
                      if (((sdSCAN == 0) & rpSDREQ[0]) |
                          ((sdSCAN == 1) & rpSDREQ[1]) |
                          ((sdSCAN == 2) & rpSDREQ[2]) |
                          ((sdSCAN == 3) & rpSDREQ[3]) |
                          ((sdSCAN == 4) & rpSDREQ[4]) |
                          ((sdSCAN == 5) & rpSDREQ[5]) |
                          ((sdSCAN == 6) & rpSDREQ[6]) |
                          ((sdSCAN == 7) & rpSDREQ[7]))
                        case (rpSDOP)
                          `sdopNOP:
                            begin
                               state <= stateIDLE;
                            end
                          `sdopRD:
                            begin
                               sdREADOP <= 1;
                               sectCNT  <= 0;
                               sectADDR <= {8'b0, sdSCAN, rpSDLSA};
                               sdRDCNT  <= sdRDCNT + 1'b1;
                               state    <= stateREAD00;
`ifndef SYNTHESIS
                               $fwrite(file, "[%11.3f] RH11: SD Controller received a READ Command from RPXX[%d].\n", $time/1.0e3, sdSCAN);
                               $fwrite(file, "[%11.3f] RH11: SD Sector Address is 0x%08x\n", $time/1.0e3, {8'b0, sdSCAN, rpSDLSA});
                               $fflush(file);
`endif
                            end
                          `sdopWR:
                            begin
                               sdREADOP <= 0;
                               sectCNT  <= 0;
                               sectADDR <= {8'b0, sdSCAN, rpSDLSA};
                               sdWRCNT  <= sdWRCNT + 1'b1;
                               state    <= stateWRITE00;
`ifndef SYNTHESIS
                               $fwrite(file, "[%11.3f] RH11: SD Controller received a WRITE Command from RPXX[%d].\n", $time/1.0e3, sdSCAN);
                               $fwrite(file, "[%11.3f] RH11: SD Sector Address is 0x%08x\n", $time/1.0e3, {8'b0, sdSCAN, rpSDLSA});
                               $fflush(file);
`endif
                            end
                          `sdopWRCHK:
                            begin
                               sdREADOP <= 0;
                               sectCNT  <= 0;
                               sectADDR <= {8'b0, sdSCAN, rpSDLSA};
                               sdRDCNT  <= sdRDCNT + 1'b1;
                               state    <= stateWRCHK00;
`ifndef SYNTHESIS
                               $fwrite(file, "[%11.3f] RH11: SD Controller received a WRCHK Command from RPXX[%d].\n", $time/1.0e3, sdSCAN);
                               $fwrite(file, "[%11.3f] RH11: SD Sector Address is 0x%08x\n", $time/1.0e3, {8'b0, sdSCAN, rpSDLSA});
                               $fflush(file);
`endif
                            end
                        endcase
                      else
                        begin
                           sdSCAN <= sdSCAN + 1'b1;
                        end
                   end

                 //
                 // stateREAD00:
                 //  Setup Read Single Block (CMD17)
                 //  This is a loop destination
                 //

                 stateREAD00:
                   begin
                      sdCMD[0] <= 8'h40 + 8'd17;        // CMD17
                      sdCMD[1] <= sectADDR[31:24];
                      sdCMD[2] <= sectADDR[23:16];
                      sdCMD[3] <= sectADDR[15: 8];
                      sdCMD[4] <= sectADDR[ 7: 0];
                      sdCMD[5] <= 8'hff;
                      loopCNT  <= 0;
                      spiOP    <= `spiCSL;
                      state    <= stateREAD01;
                   end

                 //
                 // stateREAD01:
                 //  Send Read Single Block (CMD17)
                 //

                 stateREAD01:
                   begin
                      if (spiDONE | (loopCNT == 0))
                        if (loopCNT == 6)
                          begin
                             loopCNT <= 0;
                             state   <= stateREAD02;
                          end
                        else
                          begin
                             spiOP   <= `spiTR;
                             spiTXD  <= sdCMD[loopCNT];
                             loopCNT <= loopCNT + 1'b1;
                          end
                   end

                 //
                 // stateREAD02:
                 //  Read R1 response from CMD17
                 //  Response should be 8'h00
                 //

                 stateREAD02:
                   begin
                      if (loopCNT == 0)
                        begin
                           spiOP   <= `spiTR;
                           spiTXD  <= 8'hff;
                           loopCNT <= 1;
                        end
                      else
                        if (spiDONE)
                          if (spiRXD == 8'hff)
                            if (loopCNT == nCR)
                              begin
                                 spiOP   <= `spiCSH;
                                 loopCNT <= 0;
                                 sdERR   <= 12;
                                 state   <= stateRWFAIL;
                              end
                            else
                              begin
                                 spiOP   <= `spiTR;
                                 spiTXD  <= 8'hff;
                                 loopCNT <= loopCNT + 1'b1;
                              end
                          else
                            begin
                               loopCNT <= 0;
                               if (spiRXD == 8'h00)
                                 begin
                                    state <= stateREAD03;
                                 end
                               else
                                 begin
                                    spiOP <= `spiCSH;
                                    sdERR <= 13;
                                    state <= stateRWFAIL;
                                 end
                            end
                   end

                 //
                 // stateREAD03:
                 //  Find 'Read Start token' which should be 8'hfe
                 //

                 stateREAD03:
                   begin
                      if (loopCNT == 0)
                        begin
                           spiOP   <= `spiTR;
                           spiTXD  <= 8'hff;
                           loopCNT <= 1;
                        end
                      else
                        begin
                           if (spiDONE)
                             if (spiRXD == 8'hff)
                               if (loopCNT == nAC)
                                 begin
                                    spiOP   <= `spiCSH;
                                    loopCNT <= 0;
                                    sdERR   <= 14;
                                    state   <= stateRWFAIL;
                                 end
                               else
                                 begin
                                    spiOP   <= `spiTR;
                                    spiTXD  <= 8'hff;
                                    loopCNT <= loopCNT + 1'b1;
                                 end
                             else
                               begin
                                  loopCNT <= 0;
                                  if (spiRXD == 8'hfe)
                                    begin
                                       spiOP   <= `spiTR;
                                       spiTXD  <= 8'hff;
                                       loopCNT <= 0;
                                       state   <= stateREAD04;
                                    end
                                  else
                                    begin
                                       spiOP <= `spiCSH;
                                       sdERR <= 15;
                                       sdVAL <= spiRXD;
                                       state <= stateRWFAIL;
                                    end
                               end
                        end
                   end

                 //
                 // stateREAD04:
                 //  Read byte[0] of data from disk. (LS Byte)
                 //  This is a loop destination
                 //

                 stateREAD04:
                   begin
                      if (spiDONE)
                        begin
                           spiOP           <= `spiTR;
                           spiTXD          <= 8'hff;
                           tempDATA[28:35] <= spiRXD;
                           state           <= stateREAD05;
                        end
                   end

                 //
                 // stateREAD05:
                 //  Read byte[1] of data from disk.
                 //

                 stateREAD05:
                   begin
                      if (spiDONE)
                        begin
                           spiOP           <= `spiTR;
                           spiTXD          <= 8'hff;
                           tempDATA[20:27] <= spiRXD;
                           state           <= stateREAD06;
                        end
                   end

                 //
                 // stateREAD06:
                 //  Read byte[2] of data from disk.
                 //

                 stateREAD06:
                   begin
                      if (spiDONE)
                        begin
                           spiOP           <= `spiTR;
                           spiTXD          <= 8'hff;
                           tempDATA[12:19] <= spiRXD;
                           state           <= stateREAD07;
                        end
                   end

                 //
                 // stateREAD07:
                 //  Read byte[3] of data from disk.
                 //

                 stateREAD07:
                   begin
                      if (spiDONE)
                        begin
                           spiOP           <= `spiTR;
                           spiTXD          <= 8'hff;
                           tempDATA[ 4:11] <= spiRXD;
                           state           <= stateREAD08;
                        end
                   end

                 //
                 // stateREAD08:
                 //  Read byte[4] of data from disk.  (MS Nibble)
                 //  The MS bits are discarded.
                 //

                 stateREAD08:
                   begin
                      if (spiDONE)
                        begin
                           spiOP           <= `spiTR;
                           spiTXD          <= 8'hff;
                           tempDATA[ 0: 3] <= spiRXD[3:0];
                           state           <= stateREAD09;
                        end
                   end

                 //
                 // stateREAD09:
                 //  Read byte[5] of data from disk.
                 //  This byte is discarded.
                 //

                 stateREAD09:
                   begin
                      if (spiDONE)
                        begin
                           spiOP  <= `spiTR;
                           spiTXD <= 8'hff;
                           state  <= stateREAD10;
                        end
                   end

                 //
                 // stateREAD10:
                 //  Read byte[6] of data from disk.
                 //  This byte is discarded.
                 //

                 stateREAD10:
                   begin
                      if (spiDONE)
                        begin
                           spiOP    <= `spiTR;
                           spiTXD   <= 8'hff;
                           state    <= stateREAD11;
                        end
                   end

                 //
                 // stateREAD11:
                 //  Read byte[7] of data from disk.  This byte is discarded.
                 //

                 stateREAD11:
                   begin
                      if (spiDONE)
                        begin
                           devREQO  <= 1;
                           devDATAO <= (rhWC != 0) ? tempDATA : 0;
                           state    <= stateREAD12;
                        end
                   end

                 //
                 // stateREAD12:
                 //  Write disk data to memory.
                 //

                 stateREAD12:
                   begin
                      if (devACKI)
                        begin
                           sdINCBA <= 1;
                           sdINCWC <= (rhWC != 0);
                           state   <= stateREAD13;
                        end
                      else
                        devREQO <= 1;
                   end

                 //
                 // stateREAD13:
                 //  Determine if we are done reading the SD Sector.
                 //

                 stateREAD13:
                   begin
                      if (loopCNT == 63)
                        begin
                           spiOP  <= `spiTR;
                           spiTXD <= 8'hff;
                           state  <= stateREAD14;
                        end
                      else
                        begin
                           spiOP   <= `spiTR;
                           spiTXD  <= 8'hff;
                           loopCNT <= loopCNT + 1'b1;
                           state   <= stateREAD04;
                        end
                   end

                 //
                 // stateREAD14:
                 //  Read and discard first byte of CRC.
                 //

                 stateREAD14:
                   begin
                      if (spiDONE)
                        begin
                           spiOP  <= `spiTR;
                           spiTXD <= 8'hff;
                           state  <= stateREAD15;
                        end
                   end

                 //
                 // stateREAD15:
                 //  Read and discard second byte of CRC
                 //  Determine if we are done reading from the device.
                 //

                 stateREAD15:
                   begin
                      if (spiDONE)
                        begin
                           spiOP <= `spiCSH;
                           if (sectCNT & (rhWC == 0))
                             begin
                                loopCNT <= 0;
                                sectCNT <= 0;
                                state   <= stateFINI;
                             end
                           else
                             begin
                                sdINCSECT <= sectCNT;
                                sectCNT   <= !sectCNT;
                                sectADDR  <= sectADDR + 1'b1;
                                state     <= stateREAD00;
                             end
                        end
                   end

                 // stateWRITE00:
                 //  Setup Write Single Block (CMD24)
                 //  This is a loop destination
                 //

                 stateWRITE00:
                   begin
                      sdCMD[0] <= 8'h40 + 8'd24;        // CMD24
                      sdCMD[1] <= sectADDR[31:24];
                      sdCMD[2] <= sectADDR[23:16];
                      sdCMD[3] <= sectADDR[15: 8];
                      sdCMD[4] <= sectADDR[ 7: 0];
                      sdCMD[5] <= 8'hff;
                      loopCNT  <= 0;
                      spiOP    <= `spiCSL;
                      state    <= stateWRITE01;
                   end

                 //
                 // stateWRITE01:
                 //  Send Write Single Block (CMD24)
                 //

                 stateWRITE01:
                   begin
                      if (spiDONE | (loopCNT == 0))
                        if (loopCNT == 6)
                          begin
                             loopCNT <= 0;
                             state   <= stateWRITE02;
                          end
                        else
                          begin
                             spiOP   <= `spiTR;
                             spiTXD  <= sdCMD[loopCNT];
                             loopCNT <= loopCNT + 1'b1;
                          end
                   end

                 //
                 // stateWRITE02:
                 //  Read R1 response from CMD24
                 //  Response should be 8'h00
                 //

                 stateWRITE02:
                   begin
                      if (loopCNT == 0)
                        begin
                           spiOP   <= `spiTR;
                           spiTXD  <= 8'hff;
                           loopCNT <= 1;
                        end
                      else
                        begin
                           if (spiDONE)
                             if (spiRXD == 8'hff)
                               if (loopCNT == nCR)
                                 begin
                                    spiOP   <= `spiCSH;
                                    loopCNT <= 0;
                                    sdERR   <= 16;
                                    state   <= stateRWFAIL;
                                 end
                               else
                                 begin
                                    spiOP   <= `spiTR;
                                    spiTXD  <= 8'hff;
                                    loopCNT <= loopCNT + 1'b1;
                                 end
                             else
                               begin
                                  loopCNT <= 0;
                                  if (spiRXD == 8'h00)
                                    begin
                                       state <= stateWRITE03;
                                    end
                                  else
                                    begin
                                       spiOP <= `spiCSH;
                                       sdVAL <= spiRXD;
                                       sdERR <= 17;
                                    end
                               end
                        end
                   end

                 //
                 // stateWRITE03:
                 //  Send 8 clock cycles
                 //

                 stateWRITE03:
                   begin
                      if (loopCNT == 0)
                        begin
                           spiOP   <= `spiTR;
                           spiTXD  <= 8'hff;
                           loopCNT <= 1;
                        end
                      else if (spiDONE)
                        begin
                           loopCNT <= 0;
                           state   <= stateWRITE04;
                        end
                   end

                 //
                 // stateWRITE04:
                 //  Send Write Start Token.  The write start token is 8'hfe.
                 //

                 stateWRITE04:
                   begin
                      if (loopCNT == 0)
                        begin
                           spiOP   <= `spiTR;
                           spiTXD  <= 8'hfe;
                           loopCNT <= 1;
                        end
                      else if (spiDONE)
                        begin
                           loopCNT <= 0;
                           state   <= stateWRITE05;
                        end
                   end

                 //
                 // stateWRITE05:
                 //  If RHWC is zero, we are done reading data - just write zero
                 //  to the disk.  Otherwise begin a DMA read cycle.
                 //  This is a loop destination
                 //

                 stateWRITE05:
                   begin
                      if (rhWC == 0)
                        begin
                           tempDATA <= 0;
                           state    <= stateWRITE07;
                        end
                      else
                        begin
                           devREQO <= 1;
                           state   <= stateWRITE06;
                        end
                   end

                 //
                 // stateWRITE06:
                 //  Read data from memory.
                 //

                 stateWRITE06:
                   begin
                      if (devACKI)
                        begin
                           tempDATA <= devDATAI;
                           state    <= stateWRITE07;
                        end
                      else
                        devREQO <= 1;
                   end

                 //
                 // stateWRITE07:
                 //  Write byte[0] of data to disk.  (LS Byte)
                 //

                 stateWRITE07:
                   begin
                      sdINCBA <= 1;
                      sdINCWC <= (rhWC != 0);
                      spiOP   <= `spiTR;
                      spiTXD  <= tempDATA[28:35];
                      state   <= stateWRITE08;
                   end

                 //
                 // stateWRITE08:
                 //  Write byte[1] of data to disk.
                 //

                 stateWRITE08:
                   if (spiDONE)
                     begin
                        spiOP  <= `spiTR;
                        spiTXD <= tempDATA[20:27];
                        state  <= stateWRITE09;
                     end

                 //
                 // stateWRITE09:
                 //  Write byte[2] of data to disk.
                 //

                 stateWRITE09:
                   if (spiDONE)
                     begin
                        spiOP  <= `spiTR;
                        spiTXD <= tempDATA[12:19];
                        state  <= stateWRITE10;
                     end

                 //
                 // stateWRITE10:
                 //  Write byte[3] of data to disk.
                 //

                 stateWRITE10:
                   if (spiDONE)
                     begin
                        spiOP  <= `spiTR;
                        spiTXD <= tempDATA[4:11];
                        state  <= stateWRITE11;
                     end

                 //
                 // stateWRITE11:
                 //  Write byte[4] of data to disk.  (MS Nibble)
                 //  The MS bits are zero.
                 //

                 stateWRITE11:
                   if (spiDONE)
                     begin
                        spiOP  <= `spiTR;
                        spiTXD <= {4'b0, tempDATA[0:3]};
                        state  <= stateWRITE12;
                     end

                 //
                 // stateWRITE12:
                 //  Write byte[5] of data to disk.  (Always zero)
                 //

                 stateWRITE12:
                   if (spiDONE)
                     begin
                        spiOP  <= `spiTR;
                        spiTXD <= 0;
                        state  <= stateWRITE13;
                     end

                 //
                 // stateWRITE13:
                 //  Write byte[6] of data to disk.  (Always zero)
                 //

                 stateWRITE13:
                   if (spiDONE)
                     begin
                        spiOP  <= `spiTR;
                        spiTXD <= 0;
                        state  <= stateWRITE14;
                     end

                 //
                 // stateWRITE14:
                 //  Write byte[7] of data to disk.  (Always zero)
                 //

                 stateWRITE14:
                   if (spiDONE)
                     begin
                        spiOP  <= `spiTR;
                        spiTXD <= 0;
                        state <= stateWRITE15;
                     end

                 //
                 // stateWRITE15:
                 //  Determine if we are done writing the SD Sector.
                 //

                 stateWRITE15:
                   begin
                      if (spiDONE)
                        begin
                           if (loopCNT == 63)
                             begin
                                spiOP   <= `spiTR;
                                spiTXD  <= 8'hff;
                                state   <= stateWRITE16;
                             end
                           else
                             begin
                                loopCNT <= loopCNT + 1'b1;
                                state   <= stateWRITE05;
                             end
                        end
                   end

                 //
                 // stateWRITE16:
                 //  Write first CRC byte
                 //

                 stateWRITE16:
                   if (spiDONE)
                     begin
                        spiOP   <= `spiTR;
                        spiTXD  <= 8'hff;
                        state   <= stateWRITE17;
                     end

                 //
                 // stateWRITE17:
                 //  Write second CRC byte
                 //

                 stateWRITE17:
                   if (spiDONE)
                     begin
                        spiOP   <= `spiTR;
                        spiTXD  <= 8'hff;
                        state   <= stateWRITE18;
                     end

                 //
                 // stateWRITE18:
                 //  Read Data Response.  The response is is one byte long
                 //   and has the following format:
                 //
                 //   xxx0sss1
                 //
                 //    Where x is don't-care and sss is a 3-bit status field.
                 //     010 is accepted,
                 //     101 is rejected due to CRC error and
                 //     110 is rejected due to write error.
                 //

                 stateWRITE18:
                   if (spiDONE)
                     begin
                        if (spiRXD[4:0] == 5'b0_010_1)
                          begin
                             spiOP   <= `spiTR;
                             spiTXD  <= 8'hff;
                             loopCNT <= 0;
                             state   <= stateWRITE19;
                          end
                        else
                          begin
                             spiOP   <= `spiCSH;
                             sdVAL   <= spiRXD;
                             sdERR   <= 18;
                             loopCNT <= 0;
                             state   <= stateRWFAIL;
                          end
                     end

                 //
                 // stateWRITE19:
                 //  Wait for busy token to clear.   The disk reports
                 //  all zeros while the write is occurring.
                 //

                 stateWRITE19:
                   begin
                      if (spiDONE)
                        if (spiRXD == 0)
                          if (loopCNT == 65535)
                            begin
                               spiOP   <= `spiCSH;
                               loopCNT <= 0;
                               sdERR   <= 19;
                               state   <= stateRWFAIL;
                            end
                          else
                            begin
                               spiOP   <= `spiTR;
                               spiTXD  <= 8'hff;
                               loopCNT <= loopCNT + 1'b1;
                            end
                        else
                          begin
                             sdCMD[0] <= 8'h40 + 8'd13;
                             sdCMD[1] <= 8'h00;
                             sdCMD[2] <= 8'h00;
                             sdCMD[3] <= 8'h00;
                             sdCMD[4] <= 8'h00;
                             sdCMD[5] <= 8'hff;
                             loopCNT  <= 0;
                             state    <= stateWRITE20;
                          end
                   end

                 //
                 // stateWRITE20:
                 //  Send Send Status Command (CMD13)
                 //

                 stateWRITE20:
                   begin
                      if (spiDONE | (loopCNT == 0))
                        if (loopCNT == 6)
                          begin
                             spiOP   <= `spiTR;
                             spiTXD  <= 8'hff;
                             loopCNT <= 0;
                             state   <= stateWRITE21;
                          end
                        else
                          begin
                             spiOP   <= `spiTR;
                             spiTXD  <= sdCMD[loopCNT];
                             loopCNT <= loopCNT + 1'b1;
                          end
                   end

                 //
                 // stateWRITE21:
                 //  Check first byte of CMD13 response
                 //  Status:
                 //   Bit 0: Zero
                 //   Bit 1: Parameter Error
                 //   Bit 2: Address Error
                 //   Bit 3: Erase Sequence Error
                 //   Bit 4: COM CRC Error
                 //   Bit 5: Illegal Command
                 //   Bit 6: Erase Reset
                 //   Bit 7: Idle State
                 //

                 stateWRITE21:
                   begin
                      if (spiDONE)
                        if (spiRXD == 8'hff)
                          if (loopCNT == nCR)
                            begin
                               spiOP   <= `spiCSH;
                               loopCNT <= 0;
                               sdERR   <= 20;
                               state   <= stateRWFAIL;
                            end
                          else
                            begin
                               spiOP   <= `spiTR;
                               spiTXD  <= 8'hff;
                               loopCNT <= loopCNT + 1'b1;
                            end
                        else
                          if (spiRXD == 8'h00 | spiRXD == 8'h01)
                            begin
                               spiOP   <= `spiTR;
                               spiTXD  <= 8'hff;
                               loopCNT <= 0;
                               state   <= stateWRITE22;
                            end
                          else
                            begin
                               spiOP   <= `spiCSH;
                               loopCNT <= 0;
                               sdVAL   <= spiRXD;
                               sdERR   <= 21;
                            end
                   end

                 //
                 // stateWRITE22:
                 //  Check second byte of CMD13 response
                 //  Status:
                 //   Bit 0: Out of range
                 //   Bit 1: Erase Param
                 //   Bit 2: WP Violation
                 //   Bit 3: ECC Error
                 //   Bit 4: CC Error
                 //   Bit 5: Error
                 //   Bit 6: WP Erase Skip
                 //   Bit 7: Card is locked
                 //

                 stateWRITE22:
                   begin
                      if (spiDONE)
                        if (spiRXD == 8'h00)
                          begin
                             spiOP   <= `spiTR;
                             spiTXD  <= 8'hff;
                             loopCNT <= 1;
                             state   <= stateWRITE23;
                          end
                        else
                          begin
                             spiOP   <= `spiCSH;
                             sdVAL   <= spiRXD;
                             sdERR   <= 22;
                             state   <= stateRWFAIL;
                          end
                   end

                 //
                 // stateWRITE23:
                 //  Send 8 clock cycles.   Pull CS High.
                 //  Determine if we are done writing to the device.
                 //

                 stateWRITE23:
                   if (spiDONE)
                     begin
                        spiOP <= `spiCSH;
                        if (sectCNT & (rhWC == 0))
                          begin
                             loopCNT <= 0;
                             sectCNT <= 0;
                             state   <= stateFINI;
                          end
                        else
                          begin
                             sdINCSECT <= sectCNT;
                             sectCNT   <= !sectCNT;
                             sectADDR  <= sectADDR + 1'b1;
                             state     <= stateWRITE00;
                          end
                     end

                 //
                 // stateWRCHK00:
                 //  Setup Read Single Block (CMD17) - (same as stateRD00)
                 //

                 stateWRCHK00:
                   begin
                      sdCMD[0] <= 8'h40 + 8'd17;        // CMD17
                      sdCMD[1] <= sectADDR[31:24];
                      sdCMD[2] <= sectADDR[23:16];
                      sdCMD[3] <= sectADDR[15: 8];
                      sdCMD[4] <= sectADDR[ 7: 0];
                      sdCMD[5] <= 8'hff;
                      loopCNT  <= 0;
                      spiOP    <= `spiCSL;
                      state    <= stateWRCHK01;
                   end

                 //
                 // stateWRCHK01:
                 //  Send Read Single Block (CMD17)
                 //

                 stateWRCHK01:
                   begin
                      if (spiDONE | (loopCNT == 0))
                        if (loopCNT == 6)
                          begin
                             loopCNT <= 0;
                             state   <= stateWRCHK02;
                          end
                        else
                          begin
                             spiOP   <= `spiTR;
                             spiTXD  <= sdCMD[loopCNT];
                             loopCNT <= loopCNT + 1'b1;
                          end
                   end

                 //
                 // stateWRCHK02:
                 //  Read R1 response from CMD17
                 //  Response should be 8'h00
                 //

                 stateWRCHK02:
                   begin
                      if (loopCNT == 0)
                        begin
                           spiOP   <= `spiTR;
                           spiTXD  <= 8'hff;
                           loopCNT <= 1;
                        end
                      else
                        if (spiDONE)
                          if (spiRXD == 8'hff)
                            if (loopCNT == nCR)
                              begin
                                 spiOP   <= `spiCSH;
                                 loopCNT <= 0;
                                 sdERR   <= 12;
                                 state   <= stateRWFAIL;
                              end
                            else
                              begin
                                 spiOP   <= `spiTR;
                                 spiTXD  <= 8'hff;
                                 loopCNT <= loopCNT + 1'b1;
                              end
                          else
                            begin
                               loopCNT <= 0;
                               if (spiRXD == 8'h00)
                                 begin
                                    state <= stateWRCHK03;
                                 end
                               else
                                 begin
                                    spiOP <= `spiCSH;
                                    sdERR <= 13;
                                    state <= stateRWFAIL;
                                 end
                            end
                   end

                 //
                 // stateWRCHK03:
                 //  Find 'Read Start token' which should be 8'hfe
                 //

                 stateWRCHK03:
                   begin
                      if (loopCNT == 0)
                        begin
                           spiOP   <= `spiTR;
                           spiTXD  <= 8'hff;
                           loopCNT <= 1;
                        end
                      else
                        begin
                           if (spiDONE)
                             if (spiRXD == 8'hff)
                               if (loopCNT == nAC)
                                 begin
                                    spiOP   <= `spiCSH;
                                    loopCNT <= 0;
                                    sdERR   <= 14;
                                    state   <= stateRWFAIL;
                                 end
                               else
                                 begin
                                    spiOP   <= `spiTR;
                                    spiTXD  <= 8'hff;
                                    loopCNT <= loopCNT + 1'b1;
                                 end
                             else
                               begin
                                  loopCNT <= 0;
                                  if (spiRXD == 8'hfe)
                                    begin
                                       spiOP   <= `spiTR;
                                       spiTXD  <= 8'hff;
                                       loopCNT <= 0;
                                       state   <= stateWRCHK04;
                                    end
                                  else
                                    begin
                                       spiOP <= `spiCSH;
                                       sdERR <= 15;
                                       sdVAL <= spiRXD;
                                       state <= stateRWFAIL;
                                    end
                               end
                        end
                   end

                 //
                 // stateWRCHK04:
                 //  Read byte[0] of data from disk. (LS Byte)
                 //  This is a loop destination
                 //

                 stateWRCHK04:
                   begin
                      if (spiDONE)
                        begin
                           spiOP           <= `spiTR;
                           spiTXD          <= 8'hff;
                           tempDATA[28:35] <= spiRXD;
                           state           <= stateWRCHK05;
                        end
                   end

                 //
                 // stateWRCHK05:
                 //  Read byte[1] of data from disk.
                 //

                 stateWRCHK05:
                   begin
                      if (spiDONE)
                        begin
                           spiOP           <= `spiTR;
                           spiTXD          <= 8'hff;
                           devDATAO[20:27] <= spiRXD;
                           state           <= stateWRCHK06;
                        end
                   end

                 //
                 // stateWRCHK06:
                 //  Read byte[2] of data from disk.
                 //

                 stateWRCHK06:
                   begin
                      if (spiDONE)
                        begin
                           spiOP           <= `spiTR;
                           spiTXD          <= 8'hff;
                           tempDATA[12:19] <= spiRXD;
                           state           <= stateWRCHK07;
                        end
                   end

                 //
                 // stateWRCHK07:
                 //  Read byte[3] of data from disk.
                 //

                 stateWRCHK07:
                   begin
                      if (spiDONE)
                        begin
                           spiOP           <= `spiTR;
                           spiTXD          <= 8'hff;
                           tempDATA[ 4:11] <= spiRXD;
                           state           <= stateWRCHK08;
                        end
                   end

                 //
                 // stateWRCHK08:
                 //  Read byte[4] of data from disk.  (MS Nibble)
                 //  The MS bits are discarded.
                 //

                 stateWRCHK08:
                   begin
                      if (spiDONE)
                        begin
                           spiOP           <= `spiTR;
                           spiTXD          <= 8'hff;
                           tempDATA[ 0: 3] <= spiRXD[3:0];
                           state           <= stateWRCHK09;
                        end
                   end

                 //
                 // stateWRCHK09:
                 //  Read byte[5] of data from disk.
                 //  This byte is discarded.
                 //

                 stateWRCHK09:
                   begin
                      if (spiDONE)
                        begin
                           spiOP  <= `spiTR;
                           spiTXD <= 8'hff;
                           state  <= stateWRCHK10;
                        end
                   end

                 //
                 // stateWRCHK10:
                 //  Read byte[6] of data from disk.
                 //  This byte is discarded.
                 //

                 stateWRCHK10:
                   begin
                      if (spiDONE)
                        begin
                           spiOP  <= `spiTR;
                           spiTXD <= 8'hff;
                           state  <= stateWRCHK11;
                        end
                   end

                 //
                 // stateWRCHK11:
                 //  Read byte[7] of data from disk.  This byte is discarded.
                 //  Determine if we will be doing a write check comparison.
                 //

                 stateWRCHK11:
                   begin
                      if (spiDONE)
                        if (rhWC == 0)
                          state <= stateWRCHK13;
                        else
                          begin
                             devREQO <= 1;
                             spiOP   <= `spiTR;
                             spiTXD  <= 8'hff;
                             state   <= stateWRCHK12;
                          end
                   end

                 //
                 // stateWRCHK12:
                 //  Read data from memory.  Check the data against the disk.
                 //

                 stateWRCHK12:
                   begin
                      if (devACKI)
                        begin
                           sdSETWCE <= (tempDATA != devDATAI);
                           state    <= stateWRCHK13;
                        end
                      else
                        devREQO <= 1;
                   end

                 //
                 // stateWRCHK13:
                 //  Determine if we are done reading the SD Sector.
                 //

                 stateWRCHK13:
                   begin
                      sdINCBA <= 1;
                      sdINCWC <= (rhWC != 0);
                      if (loopCNT == 63)
                        begin
                           spiOP  <= `spiTR;
                           spiTXD <= 8'hff;
                           state  <= stateWRCHK14;
                        end
                      else
                        begin
                           spiOP   <= `spiTR;
                           spiTXD  <= 8'hff;
                           loopCNT <= loopCNT + 1'b1;
                           state   <= stateWRCHK04;
                        end
                   end

                 //
                 // stateWRCHK14:
                 //  Read and discard first byte of CRC.
                 //

                 stateWRCHK14:
                   if (spiDONE)
                     begin
                        spiOP  <= `spiTR;
                        spiTXD <= 8'hff;
                        state  <= stateWRCHK15;
                     end

                 //
                 // stateWRCHK15:
                 //  Read and discard second byte of CRC
                 //  Determine if we are done reading from the device.
                 //

                 stateWRCHK15:
                   if (spiDONE)
                     begin
                        spiOP <= `spiCSH;
                        if (sectCNT & (rhWC == 0))
                          begin
                             loopCNT <= 0;
                             sectCNT <= 0;
                             state   <= stateFINI;
                          end
                        else
                          begin
                             sdINCSECT <= sectCNT;
                             sectCNT   <= !sectCNT;
                             sectADDR  <= sectADDR + 1'b1;
                             state     <= stateWRCHK00;
                          end
                     end

                 //
                 // stateFINI:
                 //  Send 8 clock cycles
                 //

                 stateFINI:
                   begin
                      if (loopCNT == 0)
                        begin
                           spiOP   <= `spiTR;
                           spiTXD  <= 8'hff;
                           loopCNT <= 1;
                        end
                      else if (spiDONE)
                        begin
                           loopCNT <= 0;
                           state   <= stateACKRP;
                        end
                   end

                 //
                 // stateDONE:
                 //  Acknowledge the RPxx that just completed.
                 //

                 stateACKRP:
                   begin
                      case (sdSCAN)
                        0: rpSDACK <= 8'b0000_0001;
                        1: rpSDACK <= 8'b0000_0010;
                        2: rpSDACK <= 8'b0000_0100;
                        3: rpSDACK <= 8'b0000_1000;
                        4: rpSDACK <= 8'b0001_0000;
                        5: rpSDACK <= 8'b0010_0000;
                        6: rpSDACK <= 8'b0100_0000;
                        7: rpSDACK <= 8'b1000_0000;
                      endcase
                      state <= stateDONE;
                   end

                 //
                 // stateDONE
                 //

                 stateDONE:
                   begin
                      state <= stateIDLE;
                   end

                 //
                 // stateINFAIL:
                 //  Initialization failed somehow.
                 //

                 stateINFAIL:
                   begin
                      state <= stateINFAIL;
                   end

                 //
                 // stateRWFAIL:
                 //  Read or Write failed somehow.
                 //

                 stateRWFAIL:
                   begin
                      state <= stateRWFAIL;
                   end

               endcase

            end

     end

   //
   // SPI Interface
   //

   SDSPI uSDSPI (
      .clk      (clk),
      .rst      (rst),
      .spiOP    (spiOP),
      .spiTXD   (spiTXD),
      .spiRXD   (spiRXD),
      .spiMISO  (sdMISO),
      .spiMOSI  (sdMOSI),
      .spiSCLK  (sdSCLK),
      .spiCS    (sdCS),
      .spiDONE  (spiDONE)
   );

   //
   // Debug Output
   //

   assign sdDEBUG = {state, sdERR, sdVAL, sdWRCNT, sdRDCNT, 8'h00, 8'h00, 8'h00};

   //
   // Chipscode debugging
   //

`ifdef SYNTHESIS
 `ifdef CHIPSCOPE_SD

   //
   // ChipScope Pro Integrated Controller (ICON)
   //

   wire [35:0] control0;

   chipscope_sd_icon uICON (
      .CONTROL0 (control0)
   );

   //
   // ChipScope Pro Integrated Logic Analyzer (ILA)
   //

   wire [63:0] TRIG0 = {
       state[7:0],              // dataport[63:56]
       sdERR[7:0],              // dataport[55:48]
       sdVAL[7:0],              // dataport[47:40]
       sdWRCNT[7:0],            // dataport[39:32]
       sdRDCNT[7:0],            // dataport[31:24]
       20'b0,                   // dataport[23: 4]
       sdMISO,                  // dataport[    3]
       sdMOSI,                  // dataport[    2]
       sdSCLK,                  // dataport[    1]
       sdCS                     // dataport[    0]
   };

   chipscope_sd_ila uILA (
      .CLK      (clk),
      .CONTROL  (control0),
      .TRIG0    (TRIG0)
   );

 `endif
`endif

endmodule
