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
      input  wire         SD_MISO,              // SD Data In
      output wire         SD_MOSI,              // SD Data Out
      output wire         SD_SCLK,              // SD Clock
      output wire         SD_SS_N,              // SD Slave Select
      // Device Interface
      input  wire [ 0:35] devDATAI,             // Data Input (Writes)
      output reg  [ 0:35] devDATAO,             // Data Output (Reads)
      output reg          devREQO,              // DMA Request
      input  wire         devACKI,              // DMA Acknowledge
      // RH11
      input  wire [15: 0] rhWC,                 // RH Word Count
      // RPXX
      input  wire [ 2: 0] rpSDOP,               // RP Operation
      input  wire [20: 0] rpSDLSA,              // RP Linear sector address
      input  wire         rpFMT22,              // RP 22 Sector (16-bit) mode
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

   localparam [15:0] nCR  =      8;             // NCR from SD Spec
   localparam [15:0] nAC  =   8191;             // NAC from SD Spec
   localparam [15:0] nWR  =     20;             // NWR from SD Spec
   localparam [23:0] nTIM = {24{1'b1}};         // 16777215

   //
   // States
   //

   localparam [7:0] stateRESET    =  0,
                    // Init States
                    stateINIT00   =  1,
                    stateINIT01   =  2,
                    stateINIT02   =  3,
                    stateINIT03   =  4,
                    stateINIT04   =  5,
                    stateINIT05   =  6,
                    stateINIT06   =  7,
                    stateINIT07   =  8,
                    stateINIT08   =  9,
                    stateINIT09   = 10,
                    stateINIT10   = 11,
                    stateINIT11   = 12,
                    stateINIT12   = 13,
                    stateINIT13   = 14,
                    stateINIT14   = 15,
                    stateINIT15   = 16,
                    stateINIT16   = 17,
                    stateINIT17   = 18,
                    // Read Header States
                    stateREADH00  = 19,
                    stateREADH01  = 20,
                    stateREADH02  = 21,
                    stateREADH03  = 22,
                    // Read States
                    stateREAD00   = 23,
                    stateREAD01   = 24,
                    stateREAD02   = 25,
                    stateREAD03   = 26,
                    stateREAD04   = 27,
                    stateREAD05   = 28,
                    stateREAD06   = 29,
                    stateREAD07   = 30,
                    stateREAD08   = 31,
                    stateREAD09   = 32,
                    stateREAD10   = 33,
                    stateREAD11   = 34,
                    stateREAD12   = 35,
                    stateREAD13   = 36,
                    stateREAD14   = 37,
                    stateREAD15   = 38,
                    stateREAD16   = 39,
                    stateREAD17   = 40,
                    stateREAD18   = 41,
                    stateREAD19   = 42,
                    // Write header states
                    stateWRITEH00 = 43,
                    stateWRITEH01 = 44,
                    stateWRITEH02 = 45,
                    stateWRITEH03 = 46,
                    // Write States
                    stateWRITE00  = 47,
                    stateWRITE01  = 48,
                    stateWRITE02  = 49,
                    stateWRITE03  = 50,
                    stateWRITE04  = 51,
                    stateWRITE05  = 52,
                    stateWRITE06  = 53,
                    stateWRITE07  = 54,
                    stateWRITE08  = 55,
                    stateWRITE09  = 56,
                    stateWRITE10  = 57,
                    stateWRITE11  = 58,
                    stateWRITE12  = 59,
                    stateWRITE13  = 60,
                    stateWRITE14  = 61,
                    stateWRITE15  = 62,
                    stateWRITE16  = 63,
                    stateWRITE17  = 64,
                    stateWRITE18  = 65,
                    stateWRITE19  = 66,
                    stateWRITE20  = 67,
                    stateWRITE21  = 68,
                    stateWRITE22  = 69,
                    stateWRITE23  = 70,
                    stateWRITE24  = 71,
                    stateWRITE25  = 72,
                    // Write Check Header States
                    stateWRCHKH00 = 73,
                    stateWRCHKH01 = 74,
                    stateWRCHKH02 = 75,
                    stateWRCHKH03 = 76,
                    // Write Check States
                    stateWRCHK00  = 77,
                    stateWRCHK01  = 78,
                    stateWRCHK02  = 79,
                    stateWRCHK03  = 80,
                    stateWRCHK04  = 81,
                    stateWRCHK05  = 82,
                    stateWRCHK06  = 83,
                    stateWRCHK07  = 84,
                    stateWRCHK08  = 85,
                    stateWRCHK09  = 86,
                    stateWRCHK10  = 87,
                    stateWRCHK11  = 88,
                    stateWRCHK12  = 89,
                    stateWRCHK13  = 90,
                    stateWRCHK14  = 91,
                    stateWRCHK15  = 92,
                    stateWRCHK16  = 93,
                    stateWRCHK17  = 94,
                    // Other States
                    stateFINI     = 122,
                    stateACKRP    = 123,
                    stateIDLE     = 124,
                    stateDONE     = 125,
                    stateINFAIL   = 126,
                    stateRWFAIL   = 127;

   //
   // Temporary read/write data
   //

   reg [ 0:35] tempDATA;                // Temporary
   reg [ 0:35] header1;                 // Header word 1
   reg [ 0:35] header2;                 // Header word 2

   //
   // Input from SPI machine
   //

   wire[ 7:0] spiRXD;                   // SPI received data
   wire       spiDONE;                  // SPI is done

   //
   // State Machine
   //

   reg [ 7: 0] sdERR;                   // Error state
   reg [ 7: 0] sdVAL;                   // Error value
   reg [15: 0] sdWRCNT;                 // Write counter
   reg [15: 0] sdRDCNT;                 // Read counter
   reg [ 7: 0] sdCMD [0:5];             // SD command (6 byte)
   reg [ 2: 0] spiOP;                   // SPI OP
   reg [ 7: 0] spiTXD;                  // SPI transmit data
   reg [15: 0] loopCNT;                 // Byte counter
   reg         sectCNT;                 // Sector counter (modulo 2)
   reg [31: 0] sectADDR;                // Sector address
   reg [23: 0] timeout;                 // Timeout
   reg [ 7: 0] state;                   // State

   always @(posedge clk)
     begin
        if (rst | clr)
          begin
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
             header1   <= 0;
             header2   <= 0;
             timeout   <= nTIM;

             //
             // Only initialize the SD Card and interface state at power-up
             //

             if (rst)
               begin
                  state   <= stateRESET;
                  sdERR   <= 0;
                  sdVAL   <= 0;
                  sdWRCNT <= 0;
                  sdRDCNT <= 0;
               end
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
                    header1  <= 0;
                    header2  <= 0;
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
               // stateINIT01
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
               // stateINIT02
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
               // stateINIT03
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
               // stateINIT04
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
               //  Read 32-bit R7 Response to CMD8 (Figure 7-12)
               //
               //  Byte 0: (MSB)
               //    Must be zero
               //
               //  Byte 1:
               //    Must be zero
               //
               //  Byte 2:
               //    Voltage should be 8'h01
               //
               //  Byte 3: (LSB)
               //    Check pattern should be 8'h55
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
               // stateINIT07
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
               // stateINIT08
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
               // stateINIT09
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
               // stateINIT10
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
               // stateINIT11
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
               // stateINIT12
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
               // stateINIT14
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
               //  Read 32-bit OCR response to CMD58
               //
               //  Byte 0: (MSB)
               //    Power-up status (bit 7) should be set
               //    Card capacity status (bit 6) should be set
               //
               //  Byte 1:
               //    3.3V (bit 5, or bit 4, or both) should be set
               //
               //  Byte 2:
               //    Don't care about contents
               //
               //  Byte 3: (LSB)
               //    Don't care about contents
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
                          if (spiRXD[7] & spiRXD[6])
                            begin
                               spiOP   <= `spiTR;
                               spiTXD  <= 8'hff;
                               loopCNT <= 2;
                            end
                          else
                            begin
                               spiOP   <= `spiCSH;
                               loopCNT <= 0;
                               sdERR   <= 12;
                               sdVAL   <= spiRXD;
                               state   <= stateINFAIL;
                            end
                      2:
                        if (spiDONE)
                          if (spiRXD[5] | spiRXD[4])
                            begin
                               spiOP   <= `spiTR;
                               spiTXD  <= 8'hff;
                               loopCNT <= 3;
                            end
                          else
                            begin
                               spiOP   <= `spiCSH;
                               loopCNT <= 0;
                               sdERR   <= 13;
                               sdVAL   <= spiRXD;
                               state   <= stateINFAIL;
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
               // stateINIT17
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
               // stateIDLE
               //  Wait for a command to process.
               //  Once the SD card is initialized, it waits in this state
               //  for either a read (sdopRD) or a write (sdopWR) command.
               //

               stateIDLE:
                 begin
                    if (rpSDREQ[sdSCAN])
                      case (rpSDOP)

                        //
                        // NOP command
                        //

                        `sdopNOP:
                          begin
                             state <= stateIDLE;
                          end

                        //
                        // Read data command
                        //

                        `sdopRD:
                          begin
                             sdREADOP <= 1;
                             sectCNT  <= 0;
                             sectADDR <= {8'b0, sdSCAN, rpSDLSA};
                             sdRDCNT  <= sdRDCNT + 1'b1;
                             state    <= stateREAD00;
`ifndef SYNTHESIS
                             $fwrite(file, "[%11.3f] RH11: SD Controller received a Read Command from RPXX[%d].\n", $time/1.0e3, sdSCAN);
                             $fwrite(file, "[%11.3f] RH11: SD Sector Address is 0x%08x\n", $time/1.0e3, {8'b0, sdSCAN, rpSDLSA});
                             $fflush(file);
`endif
                          end

                        //
                        // Read header and data command
                        //

                        `sdopRDH:
                          begin
                             sdREADOP <= 1;
                             sectCNT  <= 0;
                             sectADDR <= {8'b0, sdSCAN, rpSDLSA};
                             sdRDCNT  <= sdRDCNT + 1'b1;
                             state    <= stateREADH00;
`ifndef SYNTHESIS
                             $fwrite(file, "[%11.3f] RH11: SD Controller received a Read Header Command from RPXX[%d].\n", $time/1.0e3, sdSCAN);
                             $fwrite(file, "[%11.3f] RH11: SD Sector Address is 0x%08x\n", $time/1.0e3, {8'b0, sdSCAN, rpSDLSA});
                             $fflush(file);
`endif
                          end

                        //
                        // Write data command
                        //

                        `sdopWR:
                          begin
                             sdREADOP <= 0;
                             sectCNT  <= 0;
                             sectADDR <= {8'b0, sdSCAN, rpSDLSA};
                             sdWRCNT  <= sdWRCNT + 1'b1;
                             state    <= stateWRITE00;
`ifndef SYNTHESIS
                             $fwrite(file, "[%11.3f] RH11: SD Controller received a Write Command from RPXX[%d].\n", $time/1.0e3, sdSCAN);
                             $fwrite(file, "[%11.3f] RH11: SD Sector Address is 0x%08x\n", $time/1.0e3, {8'b0, sdSCAN, rpSDLSA});
                             $fflush(file);
`endif
                          end

                        //
                        // Write header and data command
                        //

                        `sdopWRH:
                          begin
                             sdREADOP <= 0;
                             sectCNT  <= 0;
                             sectADDR <= {8'b0, sdSCAN, rpSDLSA};
                             sdWRCNT  <= sdWRCNT + 1'b1;
                             state    <= stateWRITEH00;
`ifndef SYNTHESIS
                             $fwrite(file, "[%11.3f] RH11: SD Controller received a Write Header Command from RPXX[%d].\n", $time/1.0e3, sdSCAN);
                             $fwrite(file, "[%11.3f] RH11: SD Sector Address is 0x%08x\n", $time/1.0e3, {8'b0, sdSCAN, rpSDLSA});
                             $fflush(file);
`endif
                          end

                        //
                        // Write check data command
                        //

                        `sdopWRCHK:
                          begin
                             sdREADOP <= 0;
                             sectCNT  <= 0;
                             sectADDR <= {8'b0, sdSCAN, rpSDLSA};
                             sdRDCNT  <= sdRDCNT + 1'b1;
                             state    <= stateWRCHK00;
`ifndef SYNTHESIS
                             $fwrite(file, "[%11.3f] RH11: SD Controller received a Write Check Command from RPXX[%d].\n", $time/1.0e3, sdSCAN);
                             $fwrite(file, "[%11.3f] RH11: SD Sector Address is 0x%08x\n", $time/1.0e3, {8'b0, sdSCAN, rpSDLSA});
                             $fflush(file);
`endif
                          end

                        //
                        // Write check header and data command
                        //

                        `sdopWRCHKH:
                          begin
                             sdREADOP <= 0;
                             sectCNT  <= 0;
                             sectADDR <= {8'b0, sdSCAN, rpSDLSA};
                             sdRDCNT  <= sdRDCNT + 1'b1;
                             state    <= stateWRCHKH00;
`ifndef SYNTHESIS
                             $fwrite(file, "[%11.3f] RH11: SD Controller received a Write Check Header Command from RPXX[%d].\n", $time/1.0e3, sdSCAN);
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
               // stateREADH00
               //  Read the first word of the sector header
               //

               stateREADH00:
                 begin
                    devREQO  <= 1;
                    devDATAO <= header1;
                    state    <= stateREADH01;
                 end

               //
               // stateREADH01
               //  Store the first word of the sector header
               //

               stateREADH01:
                 begin
                    if (devACKI)
                      begin
                         sdINCBA <= 1;
                         sdINCWC <= (rhWC != 0);
                         state   <= stateREADH02;
                      end
                    else
                      devREQO <= 1;
                 end

               //
               // stateREADH02
               //  Read the second word of the sector header
               //

               stateREADH02:
                 begin
                    devREQO  <= 1;
                    devDATAO <= header2;
                    state    <= stateREADH03;
                 end

               //
               // stateREADH03
               //  Store the second word of the sector header
               //

               stateREADH03:
                 begin
                    if (devACKI)
                      begin
                         sdINCBA <= 1;
                         sdINCWC <= (rhWC != 0);
                         state   <= stateREAD00;
                      end
                    else
                      devREQO <= 1;
                 end

               //
               // stateREAD00
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
               // stateREAD01
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
               // stateREAD02
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
                             if (spiRXD == 8'h00)
                               begin
                                  state <= stateREAD03;
                               end
                             else
                               begin
                                  spiOP <= `spiCSH;
                                  sdVAL <= spiRXD;
                                  sdERR <= 15;
                                  state <= stateRWFAIL;
                               end
                          end
                 end

               //
               // stateREAD03
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
                                     sdERR <= 17;
                                     sdVAL <= spiRXD;
                                     state <= stateRWFAIL;
                                  end
                             end
                      end
                 end

               //
               // stateREAD04
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
               // stateREAD05
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
               // stateREAD06
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
               // stateREAD07
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
               // stateREAD08
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
               // stateREAD09
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
               // stateREAD10
               //  Read byte[6] of data from disk.
               //  This byte is discarded.
               //

               stateREAD10:
                 begin
                    if (spiDONE)
                      begin
                         spiOP  <= `spiTR;
                         spiTXD <= 8'hff;
                         state  <= stateREAD11;
                      end
                 end

               //
               // stateREAD11
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
               // stateREAD12
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
               // stateREAD13
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
               // stateREAD14
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
               // stateREAD15
               //  Read and discard second byte of CRC
               //  Negate Chip Select
               //

               stateREAD15:
                 begin
                    if (spiDONE)
                      begin
                         spiOP  <= `spiCSH;
                         spiTXD <= 8'hff;
                         state  <= stateREAD16;
                      end
                 end

               //
               // stateREAD16
               //  Send idle character with Chip Select negated
               //

               stateREAD16:
                 begin
                    spiOP  <= `spiTR;
                    spiTXD <= 8'hff;
                    state  <= stateREAD17;
                 end

               //
               // stateREAD17
               //  Determine if we are done reading from the device.
               //

               stateREAD17:
                 begin
                    if (spiDONE)
                      begin
                         if (sectCNT & (rhWC == 0))
                           begin
                              sdINCSECT <= sectCNT;
                              sectCNT   <= 0;
                              loopCNT   <= 0;
                              state     <= stateFINI;
                           end
                         else
                           begin
                              sdINCSECT <= sectCNT;
                              sectCNT   <= !sectCNT;
                              sectADDR  <= sectADDR + 1'b1;
                              state     <= stateREAD18;
                           end
                      end
                 end

               //
               // stateREAD18
               //
               // Negate sdINCSECT
               //

               stateREAD18:
                 begin
                    state <= stateREAD19;
                 end

               //
               // stateREAD20
               //
               // Abort if RPXX has errors.   Specifically RPER1[AOE].
               //

               stateREAD19:
                 begin
                    if (rpSDREQ[sdSCAN])
                      state <= stateREAD00;
                    else
                      begin
                         loopCNT <= 0;
                         sectCNT <= 0;
                         state   <= stateFINI;
                      end
                 end

               //
               // stateWRITEH00
               //  Read first word of sector header from memory
               //

               stateWRITEH00:
                 begin
                    devREQO <= 1;
                    state   <= stateWRITEH01;
                 end

               //
               // stateWRITEH01
               //  Save the first word of the sector header
               //

               stateWRITEH01:
                 begin
                    if (devACKI)
                      begin
                         sdINCBA <= 1;
                         sdINCWC <= (rhWC != 0);
                         header1 <= devDATAI;
                         state   <= stateWRITEH02;
                      end
                    else
                      devREQO <= 1;
                 end

               //
               // stateWRITEH02
               //  Read second word of sector header from memory
               //

               stateWRITEH02:
                 begin
                    devREQO <= 1;
                    state   <= stateWRITEH03;
                 end

               //
               // stateWRITEH03
               //  Save the second word of the sector header
               //

               stateWRITEH03:
                 begin
                    if (devACKI)
                      begin
                         sdINCBA <= 1;
                         sdINCWC <= (rhWC != 0);
                         header2 <= devDATAI;
                         state   <= stateWRITE00;
                      end
                    else
                      devREQO <= 1;
                 end

               //
               // stateWRITE00
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
               // stateWRITE01
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
               // stateWRITE02
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
                                  sdERR   <= 18;
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
                                     sdERR <= 19;
                                  end
                             end
                      end
                 end

               //
               // stateWRITE03
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
               // stateWRITE04
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
               // stateWRITE05
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
               // stateWRITE06
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
               // stateWRITE07
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
               // stateWRITE08
               //  Write byte[1] of data to disk.
               //

               stateWRITE08:
                 begin
                    if (spiDONE)
                      begin
                         spiOP  <= `spiTR;
                         spiTXD <= tempDATA[20:27];
                         state  <= stateWRITE09;
                      end
                 end

               //
               // stateWRITE09
               //  Write byte[2] of data to disk.
               //

               stateWRITE09:
                 begin
                    if (spiDONE)
                      begin
                         spiOP  <= `spiTR;
                         spiTXD <= tempDATA[12:19];
                         state  <= stateWRITE10;
                      end
                 end

               //
               // stateWRITE10
               //  Write byte[3] of data to disk.
               //

               stateWRITE10:
                 begin
                    if (spiDONE)
                      begin
                         spiOP  <= `spiTR;
                         spiTXD <= tempDATA[4:11];
                         state  <= stateWRITE11;
                      end
                 end

               //
               // stateWRITE11
               //  Write byte[4] of data to disk.  (MS Nibble)
               //  The MS bits are zero.
               //

               stateWRITE11:
                 begin
                    if (spiDONE)
                      begin
                         spiOP  <= `spiTR;
                         spiTXD <= {4'b0, tempDATA[0:3]};
                         state  <= stateWRITE12;
                      end
                 end

               //
               // stateWRITE12
               //  Write byte[5] of data to disk.  (Always zero)
               //

               stateWRITE12:
                 begin
                    if (spiDONE)
                      begin
                         spiOP  <= `spiTR;
                         spiTXD <= 0;
                         state  <= stateWRITE13;
                      end
                 end

               //
               // stateWRITE13
               //  Write byte[6] of data to disk.  (Always zero)
               //

               stateWRITE13:
                 begin
                    if (spiDONE)
                      begin
                         spiOP  <= `spiTR;
                         spiTXD <= 0;
                         state  <= stateWRITE14;
                      end
                 end

               //
               // stateWRITE14
               //  Write byte[7] of data to disk.  (Always zero)
               //

               stateWRITE14:
                 begin
                    if (spiDONE)
                      begin
                         spiOP  <= `spiTR;
                         spiTXD <= 0;
                         state <= stateWRITE15;
                      end
                 end

               //
               // stateWRITE15
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
               // stateWRITE16
               //  Write first CRC byte
               //

               stateWRITE16:
                 begin
                    if (spiDONE)
                      begin
                         spiOP  <= `spiTR;
                         spiTXD <= 8'hff;
                         state  <= stateWRITE17;
                      end
                 end

               //
               // stateWRITE17
               //  Write second CRC byte
               //

               stateWRITE17:
                 begin
                    if (spiDONE)
                      begin
                         spiOP  <= `spiTR;
                         spiTXD <= 8'hff;
                         state  <= stateWRITE18;
                      end
                 end

               //
               // stateWRITE18
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
                 begin
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
                              sdERR   <= 20;
                              loopCNT <= 0;
                              state   <= stateRWFAIL;
                           end
                      end
                 end

               //
               // stateWRITE19
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
                             sdERR   <= 21;
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
               // stateWRITE20
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
               // stateWRITE21
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
                             sdERR   <= 22;
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
                             sdERR   <= 23;
                          end
                 end

               //
               // stateWRITE22
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
                           sdERR   <= 24;
                           state   <= stateRWFAIL;
                        end
                 end

               //
               // stateWRITE23
               //  Send 8 clock cycles.   Pull CS High.
               //  Determine if we are done writing to the device.
               //

               stateWRITE23:
                 begin
                    if (spiDONE)
                      begin
                         spiOP <= `spiCSH;
                         if (sectCNT & (rhWC == 0))
                           begin
                              sdINCSECT <= sectCNT;
                              sectCNT   <= 0;
                              loopCNT   <= 0;
                              state     <= stateFINI;
                           end
                         else
                           begin
                              sdINCSECT <= sectCNT;
                              sectCNT   <= !sectCNT;
                              sectADDR  <= sectADDR + 1'b1;
                              state     <= stateWRITE24;
                           end
                      end
                 end

               //
               // stateWRITE24
               //
               // Negate sdINCSECT
               //

               stateWRITE24:
                 begin
                    state <= stateWRITE25;
                 end

               //
               // stateWRITE25
               //
               // Abort if RPXX has errors.   Specifically RPER1[AOE].
               //

               stateWRITE25:
                 begin
                    if (rpSDREQ[sdSCAN])
                      state <= stateWRITE00;
                    else
                      begin
                         loopCNT <= 0;
                         sectCNT <= 0;
                         state   <= stateFINI;
                      end
                 end

               //
               // stateWRCHKH00
               //  Read the first word of the sector header
               //

               stateWRCHKH00:
                 begin
                    devREQO  <= 1;
                    devDATAO <= header1;
                    state    <= stateWRCHKH01;
                 end

               //
               // stateWRCHKH01
               //  Check the first word of the sector header
               //

               stateWRCHKH01:
                 begin
                    if (devACKI)
                      begin
                         sdINCBA  <= 1;
                         sdINCWC  <= (rhWC != 0);
                         sdSETWCE <= (header1 != devDATAI);
                         state    <= stateWRCHKH02;
                      end
                    else
                      devREQO <= 1;
                 end

               //
               // stateWRCHKH02
               //  Read the second word of the sector header
               //

               stateWRCHKH02:
                 begin
                    devREQO  <= 1;
                    devDATAO <= header1;
                    state    <= stateWRCHKH03;
                 end

               //
               // stateWRCHKH03
               //  Check the second word of the sector header
               //

               stateWRCHKH03:
                 begin
                    if (devACKI)
                      begin
                         sdINCBA  <= 1;
                         sdINCWC  <= (rhWC != 0);
                         sdSETWCE <= (header1 != devDATAI);
                         state    <= stateWRCHK00;
                      end
                    else
                      devREQO <= 1;
                 end

               //
               // stateWRCHK00
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
               // stateWRCHK01
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
               // stateWRCHK02
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
                               sdERR   <= 25;
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
                                  sdERR <= 26;
                                  state <= stateRWFAIL;
                               end
                          end
                 end

               //
               // stateWRCHK03
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
                                  sdERR   <= 27;
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
                                     sdERR <= 28;
                                     sdVAL <= spiRXD;
                                     state <= stateRWFAIL;
                                  end
                             end
                      end
                 end

               //
               // stateWRCHK04
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
               // stateWRCHK05
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
               // stateWRCHK06
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
               // stateWRCHK07
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
               // stateWRCHK08
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
               // stateWRCHK09
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
               // stateWRCHK10
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
               // stateWRCHK11
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
               // stateWRCHK12
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
               // stateWRCHK13
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
               // stateWRCHK14
               //  Read and discard first byte of CRC.
               //

               stateWRCHK14:
                 begin
                    if (spiDONE)
                      begin
                         spiOP  <= `spiTR;
                         spiTXD <= 8'hff;
                         state  <= stateWRCHK15;
                      end
                 end

               //
               // stateWRCHK15
               //  Read and discard second byte of CRC
               //  Determine if we are done reading from the device.
               //

               stateWRCHK15:
                 begin
                    if (spiDONE)
                      begin
                         spiOP <= `spiCSH;
                         if (sectCNT & (rhWC == 0))
                           begin
                              sdINCSECT <= sectCNT;
                              sectCNT   <= 0;
                              loopCNT   <= 0;
                              state     <= stateFINI;
                           end
                         else
                           begin
                              sdINCSECT <= sectCNT;
                              sectCNT   <= !sectCNT;
                              sectADDR  <= sectADDR + 1'b1;
                              state     <= stateWRCHK16;
                           end
                      end
                 end

               //
               // stateWRCHK16
               //
               // Negate sdINCSECT
               //

               stateWRCHK16:
                 begin
                    state <= stateWRCHK17;
                 end

               //
               // stateWRCHK17
               //
               // Abort if RPXX has errors.   Specifically RPER1[AOE].
               //

               stateWRCHK17:
                 begin
                    if (rpSDREQ[sdSCAN])
                      state <= stateWRCHK00;
                    else
                      begin
                         loopCNT <= 0;
                         sectCNT <= 0;
                         state   <= stateFINI;
                      end
                 end

               //
               // stateFINI
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
               // stateDONE
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
               // stateINFAIL
               //  Initialization failed somehow.
               //

               stateINFAIL:
                 begin
                    state <= stateINFAIL;
                 end

               //
               // stateRWFAIL
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
      .clk     (clk),
      .rst     (rst),
      .spiOP   (spiOP),
      .spiTXD  (spiTXD),
      .spiRXD  (spiRXD),
      .spiMISO (SD_MISO),
      .spiMOSI (SD_MOSI),
      .spiSCLK (SD_SCLK),
      .spiSS_N (SD_SS_N),
      .spiDONE (spiDONE)
   );

   //
   // Debug Output
   //

   assign sdDEBUG = {state, sdERR, sdVAL, 8'h00, sdWRCNT, sdRDCNT};

endmodule
