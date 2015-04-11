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

`include "sd.vh"
`include "sdspi.vh"

module SD(clk, rst,
          // SPI Interface
          sdMISO, sdMOSI, sdSCLK, sdCS,
          // Control
          sdOP, sdSECTADDR, sdWDCNT, sdBUSADDR,
          // Data Interface
          sdDATAI, sdDATAO, dmaREQ, dmaACK,
          //
          sdINCWORD, sdINCSECT, sdSTAT,
          // Debug
          sdDEBUG);

   input         clk;                   // Clock
   input         rst;                   // Reset
   // SPI Interface
   input         sdMISO;                // SD Data In
   output        sdMOSI;                // SD Data Out
   output        sdSCLK;                // SD Clock
   output        sdCS;                  // SD Chip Select
   // Control
   input  [ 1:0] sdOP;                  // SD Operation
   input  [31:0] sdSECTADDR;            // SD Sector Number
   input  [15:0] sdWDCNT;               // SD Word Count
   input  [15:0] sdBUSADDR;             // SD Bus Address

   // DMA Interface
   input  [0:35] sdDATAI;               // Data Input (Writes)
   output [0:35] sdDATAO;               // Data Output (Reads)
   output        dmaREQ;                // DMA Request
   input         dmaACK;                // DMA Acknowledge

   // Outputs
   output        sdINCWORD;             // Increment Word Count
   output        sdINCSECT;             // Increment Sector
   output        sdSTAT;                // Status
   // Diagnostics
   output [0:63] sdDEBUG;               // Debug Output

   //
   // Timing wires
   //

   localparam [15:0] nCR  =    8;        // NCR from SD Spec
   localparam [15:0] nAC  = 1023;        // NAC from SD Spec
   localparam [15:0] nWR  =   20;        // NWR from SD Spec

   //
   // States
   //

   localparam [ 6:0] stateRESET   =  0,
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
                    // Write States
                    stateWRITE00 = 34,
                    stateWRITE01 = 35,
                    stateWRITE02 = 36,
                    stateWRITE03 = 37,
                    stateWRITE04 = 38,
                    stateWRITE05 = 39,
                    stateWRITE06 = 40,
                    stateWRITE07 = 41,
                    stateWRITE08 = 42,
                    stateWRITE09 = 43,
                    stateWRITE10 = 44,
                    stateWRITE11 = 45,
                    stateWRITE12 = 46,
                    stateWRITE13 = 47,
                    stateWRITE14 = 48,
                    stateWRITE15 = 49,
                    stateWRITE16 = 50,

                    // Write Check States
                    stateWRCHK00 = 51,


                    // Other States
                    stateFINI    = 52,
                    stateIDLE    = 53,
                    stateDONE    = 54,
                    stateINFAIL  = 55,
                    stateRWFAIL  = 56;

   //
   // SD Commands:
   //

   reg [ 7:0] sdCMD0  [0:5];
   reg [ 7:0] sdCMD8  [0:5];
   reg [ 7:0] sdCMD13 [0:5];
   reg [ 7:0] sdCMD17 [0:5];
   reg [ 7:0] sdCMD24 [0:5];
   reg [ 7:0] sdACMD41[0:5];
   reg [ 7:0] sdCMD55 [0:5];
   reg [ 7:0] sdCMD58 [0:5];

   reg [ 2:0] spiOP;                    // SPI Op
   reg [ 7:0] spiTXD;                   // SPI Transmit Data
   reg [15:0] loopCNT;                  // Byte Counter

   reg [20:0] busFLAGS;                 // Bus Flags

   reg        abort;                    // Abort this command
   reg [19:0] timeout;                  // Timeout
   reg [ 7:0] sdRDCNT;                  // Read Counter
   reg [ 7:0] sdWRCNT;                  // Write Counter
   reg [15:0] wdCNT;                    // Word Count
   reg [31:0] sectADDR;                 // Sector Address

   reg [ 7:0] sdVAL;                    // Error Value
   reg [ 7:0] sdERR;                    // Error State
   reg        sdINCSECT;                // Increment Sector
   reg        sdINCWORD;                // Increment Word
   reg        rwDONE;                   // Read/Write Completed
   reg        readOP;                   // Read/Write Operation
   reg        dmaREQ;                   // DMA Request

   reg [0:35] sdDATAO;                  // DMA Data Out
   reg [ 7:0] state;                    // Current State

   wire       spiDONE;                  // Asserted by SPI when done
   wire[ 7:0] spiRXD;                   // SPI Received Data

   initial
     begin
        sdCMD0[0]   <= 8'h40 + 8'd00;
        sdCMD0[1]   <= 8'h00;
        sdCMD0[2]   <= 8'h00;
        sdCMD0[3]   <= 8'h00;
        sdCMD0[4]   <= 8'h00;
        sdCMD0[5]   <= 8'h95;

        sdCMD8[0]   <= 8'h40 + 8'd08;
        sdCMD8[1]   <= 8'h00;
        sdCMD8[2]   <= 8'h00;
        sdCMD8[3]   <= 8'h01;
        sdCMD8[4]   <= 8'haa;
        sdCMD8[5]   <= 8'h87;

        sdCMD13[0]  <= 8'h40 + 8'd13;
        sdCMD13[1]  <= 8'h00;
        sdCMD13[2]  <= 8'h00;
        sdCMD13[3]  <= 8'h00;
        sdCMD13[4]  <= 8'h00;
        sdCMD13[5]  <= 8'hff;

        sdACMD41[0] <= 8'h40 + 8'd41;
        sdACMD41[1] <= 8'h40;
        sdACMD41[2] <= 8'h00;
        sdACMD41[3] <= 8'h00;
        sdACMD41[4] <= 8'h00;
        sdACMD41[5] <= 8'hff;

        sdCMD55[0]  <= 8'h40 + 8'd55;
        sdCMD55[1]  <= 8'h00;
        sdCMD55[2]  <= 8'h00;
        sdCMD55[3]  <= 8'h00;
        sdCMD55[4]  <= 8'h00;
        sdCMD55[5]  <= 8'hff;

        sdCMD58[0]  <= 8'h40 + 8'd58;
        sdCMD58[1]  <= 8'h00;
        sdCMD58[2]  <= 8'h00;
        sdCMD58[3]  <= 8'h00;
        sdCMD58[4]  <= 8'h00;
        sdCMD58[5]  <= 8'hff;

     end

   //
   // SD_STATE:
   // This process assumes a 50 MHz clock
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             sdERR      <= 0;
             sdVAL      <= 0;
             sdRDCNT    <= 0;
             sdWRCNT    <= 0;
             wdCNT      <= 0;
             sectADDR   <= 0;
             sdINCSECT  <= 0;
             sdINCWORD  <= 0;
             loopCNT    <= 0;

             sdDATAO    <= 0;

             sdCMD17[0] <= 8'h40 + 8'd17;
             sdCMD17[1] <= 8'h00;
             sdCMD17[2] <= 8'h00;
             sdCMD17[3] <= 8'h00;
             sdCMD17[4] <= 8'h00;
             sdCMD17[5] <= 8'hff;

             sdCMD24[0] <= 8'h40 + 8'd24;
             sdCMD24[1] <= 8'h00;
             sdCMD24[2] <= 8'h00;
             sdCMD24[3] <= 8'h00;
             sdCMD24[4] <= 8'h00;
             sdCMD24[5] <= 8'hff;

             readOP     <= 0;

             spiTXD     <= 0;
             abort      <= 0;
             rwDONE     <= 0;
             spiOP      <= `spiNOP;
             timeout    <= 499999;
             state      <= stateRESET;
          end
        else
          begin

             dmaREQ    <= 0;
             sdINCSECT <= 0;
             spiOP     <= `spiNOP;

             //if ((sdOP == `sdopABORT) & (state != stateIDLE))
             //  begin
             //     abort <= 1;
             //  end

             case (state)

               //
               // stateRESET:
               //

               stateRESET:
                 begin
                    timeout <= timeout - 1'b1;
                    loopCNT <= 0;
                    state   <= stateINIT00;
                 end

               //
               // stateINIT00
               //  Send 8x8 clocks cycles
               //

               stateINIT00:
                 begin
                    timeout <= timeout - 1'b1;
                    if (spiDONE | (loopCNT == 0))
                      begin
                         if (loopCNT == nCR)
                           begin
                              loopCNT <= 0;
                              spiOP   <= `spiCSL;
                              state   <= stateINIT01;
                           end
                         else
                           begin
                              spiOP   <= `spiTR;
                              spiTXD  <= 8'hff;
                              loopCNT <= loopCNT + 1'b1;
                           end
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
                      begin
                         if (loopCNT == 6)
                           begin
                              loopCNT <= 0;
                              state   <= stateINIT02;
                           end
                         else
                           begin
                              spiOP   <= `spiTR;
                              spiTXD  <= sdCMD0[loopCNT];
                              loopCNT <= loopCNT + 1'b1;
                           end
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
                      begin
                         if (spiDONE)
                           begin
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
                         spiOP   <= `spiCSL;
                         loopCNT <= 0;
                         state   <= stateINIT04;
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
                      begin
                         if (loopCNT == 6)
                           begin
                              loopCNT <= 0;
                              state   <= stateINIT05;
                           end
                         else
                           begin
                              spiOP   <= `spiTR;
                              spiTXD  <= sdCMD8[loopCNT];
                              loopCNT <= loopCNT + 1'b1;
                           end
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
                           begin
                              if (spiRXD == 8'hff)
                                begin
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
                        begin
                           if (spiDONE)
                             begin
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
                             end
                        end
                      2:
                        begin
                           if (spiDONE)
                             begin
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
                             end
                        end
                      3:
                        begin
                           if (spiDONE)
                             begin
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
                             end
                        end
                      4:
                        begin
                           if (spiDONE)
                             begin
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
                             end
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
                         spiOP   <= `spiCSL;
                         loopCNT <= 0;
                         state   <= stateINIT08;
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
                              spiTXD  <= sdCMD55[loopCNT];
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
                      begin
                         if (spiDONE)
                           begin
                              if (spiRXD == 8'hff)
                                begin
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
                                end
                              else
                                begin
                                   spiOP   <= `spiCSH;
                                   loopCNT <= 0;
                                   if (spiRXD == 8'h01)
                                     begin
                                        state <= stateINIT10;
                                     end
                                   else
                                     begin
                                        state <= stateINIT07;
                                     end
                                end
                           end
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
                         spiOP   <= `spiCSL;
                         loopCNT <= 0;
                         state   <= stateINIT11;
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
                      begin
                         if (loopCNT == 6)
                           begin
                              loopCNT <= 0;
                              state   <= stateINIT12;
                           end
                         else
                           begin
                              spiOP   <= `spiTR;
                              spiTXD  <= sdACMD41[loopCNT];
                              loopCNT <= loopCNT + 1'b1;
                           end
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
                      begin
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
                         spiOP   <= `spiCSL;
                         loopCNT <= 0;
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
                      begin
                         if (loopCNT == 6)
                           begin
                              loopCNT <= 0;
                              state   <= stateINIT15;
                           end
                         else
                           begin
                              spiOP   <= `spiTR;
                              spiTXD  <= sdCMD58[loopCNT];
                              loopCNT <= loopCNT + 1'b1;
                           end
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
                      begin
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
                        begin
                           if (spiDONE)
                             begin
                                spiOP   <= `spiTR;
                                spiTXD  <= 8'hff;
                                loopCNT <= 2;
                             end
                        end
                      2:
                        begin
                           if (spiDONE)
                             begin
                                spiOP   <= `spiTR;
                                spiTXD  <= 8'hff;
                                loopCNT <= 3;
                             end
                        end
                      3:
                        begin
                           if (spiDONE)
                             begin
                                spiOP   <= `spiTR;
                                spiTXD  <= 8'hff;
                                loopCNT <= 4;
                             end
                        end
                      4:
                        begin
                           if (spiDONE)
                             begin
                                spiOP   <= `spiCSH;
                                loopCNT <= 0;
                                state   <= stateINIT17;
                             end
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
`ifdef GOFAST
                         spiOP   <= spiFAST;
`endif
                         state   <= stateIDLE;
`ifndef SYNTHESIS
                         $display("[%11.3f] RH11: SD Card Initialized Successfully.", $time/1.0e3);
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
                    abort   <= 0;
                    case (sdOP)
                      `sdopNOP:
                        begin
                           state <= stateIDLE;
                        end
                      `sdopRD:
                        begin
                           readOP   <= 1;
                           wdCNT    <= sdWDCNT;
                           sectADDR <= sdSECTADDR;
                           sdRDCNT  <= sdRDCNT + 1'b1;
                           state    <= stateREAD00;
                        end
                      `sdopWR:
                        begin
                           readOP   <= 0;
                           wdCNT    <= sdWDCNT;
                           sectADDR <= sdSECTADDR;
                           sdWRCNT  <= sdWRCNT + 1'b1;
                           state    <= stateWRITE00;
                        end
                      `sdopWRCHK:
                        begin
                           readOP   <= 1;
                           wdCNT    <= sdWDCNT;
                           sectADDR <= sdSECTADDR;
                           sdRDCNT  <= sdRDCNT + 1'b1;
                           state    <= stateWRCHK00;
                        end
                      default:
                        begin
                           state <= stateIDLE;
                        end
                    endcase
                 end

               //
               // stateREAD00:
               //  Setup Read Single Block (CMD17)
               //  This is a loop destination
               //

               stateREAD00:
                 begin
                    sdCMD17[0] <= 8'h40 + 8'd17;
                    sdCMD17[1] <= sectADDR[31:24];
                    sdCMD17[2] <= sectADDR[23:16];
                    sdCMD17[3] <= sectADDR[15: 8];
                    sdCMD17[4] <= sectADDR[ 7: 0];
                    sdCMD17[5] <= 8'hff;
                    loopCNT    <= 0;
                    spiOP      <= `spiCSL;
                    state      <= stateREAD01;
                 end

               //
               // stateREAD01:
               //  Send Read Single Block (CMD17)
               //

               stateREAD01:
                 begin
                    if (spiDONE | (loopCNT == 0))
                      begin
                         if (loopCNT == 6)
                           begin
                              loopCNT <= 0;
                              state   <= stateREAD02;
                           end
                         else
                           begin
                              spiOP   <= `spiTR;
                              spiTXD  <= sdCMD17[loopCNT];
                              loopCNT <= loopCNT + 1'b1;
                           end
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
                      begin
                         if (spiDONE)
                           begin
                              if (spiRXD == 8'hff)
                                begin
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
                           begin
                              if (spiRXD == 8'hff)
                                begin
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
                                end
                              else
                                begin
                                   loopCNT <= 0;
                                   if (spiRXD == 8'hfe)
                                     begin
                                        rwDONE  <= 0;
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
                         spiOP          <= `spiTR;
                         spiTXD         <= 8'hff;
                         sdDATAO[28:35] <= spiRXD;
                         state          <= stateREAD05;
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
                         spiOP          <= `spiTR;
                         spiTXD         <= 8'hff;
                         sdDATAO[20:27] <= spiRXD;
                         state          <= stateREAD06;
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
                         spiOP          <= `spiTR;
                         spiTXD         <= 8'hff;
                         sdDATAO[12:19] <= spiRXD;
                         state          <= stateREAD07;
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
                         spiOP          <= `spiTR;
                         spiTXD         <= 8'hff;
                         sdDATAO[ 4:11] <= spiRXD;
                         state          <= stateREAD08;
                      end
                 end

               //
               // stateREAD08:
               //  Read byte[4] of data from disk.  (MS Nibble)
               //

               stateREAD08:
                 begin
                    if (spiDONE)
                      begin
                         spiOP          <= `spiTR;
                         spiTXD         <= 8'hff;
                         sdDATAO[ 0: 3] <= spiRXD[7:4];
                         state          <= stateREAD09;
                      end
                 end

               //
               // stateREAD09:
               //  Read byte[5] of data from disk.
               //  This byte is ignored by the disk controller
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
               //  This byte is ignored by the disk controller
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
               // stateREAD11:
               //  Read byte[7] of data from disk.
               //  This byte is ignored by the disk controller
               //

               stateREAD11:
                 begin
                    if (spiDONE)
                      begin
                         if (rwDONE)
                           begin
                              state <= stateREAD13;
                           end
                         else
                           begin
                              spiOP  <= `spiTR;
                              spiTXD <= 8'hff;
                              dmaREQ <= 1;
                              state  <= stateREAD12;
                           end
                      end
                 end

               //
               // stateREAD12:
               //  Write disk data to memory.
               //

               stateREAD12:
                 begin
                    if (dmaACK)
                      begin
                         state <= stateREAD13;
                      end
                 end

////////////////////////////////////////////////////////////////////

               //
               // stateREAD13:
               //  The SIMH uses 1024 byte sectors.   This is
               //  because a PDP10 sector is 128 words and SIMH uses
               //  8 bytes (64-bits) per word.  Therefore each PDP10
               //  sector corresponds to two SD sectors.
               //
               //  This state checks the various loop conditions:
               //
               //  - When Word Count increments to zero, we are done
               //    storing data in memory but we continue reading
               //    until the end-of-sector.  In this case we set
               //    'rwDONE'
               //
               //

               stateREAD13:
                 begin
                    if (abort)
                      begin
                         spiOP   <= `spiCSH;
                         loopCNT <= 0;
                         state   <= stateFINI;
                      end
                    else
                      begin
                         if (wdCNT == 0)
                           begin
                              rwDONE <= 0;
                           end

                         //
                         // We just read the first SD Sector of 512 bytes.
                         // Increment the SD Sector Address and read the
                         // next sector.
                         //

                         if (loopCNT == 63)
                           begin
                              wdCNT    <= wdCNT - 1'b1;
                              loopCNT  <= loopCNT + 1'b1;
                              sectADDR <= sectADDR + 1'b1;
                              state    <= stateREAD00;
                           end

                         //
                         // We just read the second SD Sector of 512 bytes.
                         // Increment the SD Sector Address, increment the RPxx
                         // sector, and continue.
                         //

                         else if (loopCNT == 127)
                           begin
                              wdCNT     <= wdCNT - 1'b1;
                              loopCNT   <= loopCNT + 1'b1;
                              sectADDR  <= sectADDR + 1'b1;
                              sdINCSECT <= 1;
                              state     <= stateREAD00;
                           end

                         //
                         // We're not done reading the SD Sector.  Keep reading
                         //

                         else
                           begin
                              wdCNT      <= wdCNT - 1'b1;
                              loopCNT    <= loopCNT + 1'b1;
                              state      <= stateREAD04;
                           end

                      end
                 end

               //
               // stateREAD14:
               //  Read 2 bytes of CRC which is required for the SD Card.
               //

               stateREAD14:
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
                           begin
                              if (loopCNT)
                                begin
                                   spiOP   <= `spiTR;
                                   spiTXD  <= 8'hff;
                                   loopCNT <= 2;
                                end
                              else if (loopCNT == 2)
                                begin
                                   spiOP   <= `spiCSH;
                                   loopCNT <= 0;
                                   state   <= stateFINI;
                                end
                           end
                      end
                 end

               //
               // stateWRITE00:
               //  Setup Write Single Block (CMD24)
               //

               stateWRITE00:
                 begin
                    sdCMD24[0] <= 8'h40 + 8'd24;
                    sdCMD24[1] <= sectADDR[31: 24];
                    sdCMD24[2] <= sectADDR[23: 16];
                    sdCMD24[3] <= sectADDR[15:  8];
                    sdCMD24[4] <= sectADDR[ 7:  0];
                    sdCMD24[5] <= 8'hff;
                    loopCNT    <= 0;
                    spiOP      <= `spiCSL;
                    state      <= stateWRITE01;
                 end

               //
               // stateWRITE01:
               //  Send Write Single Block (CMD24)
               //

               stateWRITE01:
                 begin
                    if (spiDONE | (loopCNT == 0))
                      begin
                         if (loopCNT == 6)
                           begin
                              loopCNT <= 0;
                              state   <= stateWRITE02;
                           end
                         else
                           begin
                              spiOP   <= `spiTR;
                              spiTXD  <= sdCMD24[loopCNT];
                              loopCNT <= loopCNT + 1'b1;
                           end
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
                           begin
                              if (spiRXD == 8'hff)
                                begin
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
               //  Send Write Start Token.  The write start token is 8'hfe
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
               //  Start a DMA Read Address Cycle
               //

               stateWRITE05:
                 begin
                    dmaREQ <= 1;
                    if (dmaACK)
                      begin
                         state <= stateWRITE06;
                      end
                 end

               //
               // stateWRITE06:
               //  This is a loop destination
               //

               stateWRITE06:
                 begin
                    if (dmaREQ)
                      begin
                         //dmaRD <= 1;
                      end
                    state <= stateWRITE07;
                 end

               //
               // stateWRITE07:
               //  Write LSBYTE of data to disk (even addresses)
               //   This state has two modes:
               //    If dmaREQ is asserted we are operating normally.
               //    If dmaREQ is negated we are writing the last 128
               //     words of a 128 word operation.  Therefore we
               //     write zeros.  See file header.
               //

               stateWRITE07:
                 begin
                    spiOP  <= `spiTR;
                    if (dmaREQ)
                      begin
                         spiTXD <= sdDATAI[4:11];
                      end
                    else
                      begin
                         spiTXD <= 8'b0;
                      end
                    state <= stateWRITE08;
                 end

               //
               // stateWRITE08:
               //  Write MSBYTE of data to disk (odd addresses)
               //  Note:  The top 4 bits of the MSBYTE are zero.
               //

               stateWRITE08:
                 begin
                    if (spiDONE)
                      begin
                         spiOP   <= `spiTR;
                         loopCNT <= loopCNT + 1'b1;
                         state   <= stateWRITE09;
                      end
                 end

               //
               // stateWRITE09:
               //  This is the addr phase of the read cycle.
               //

               stateWRITE09:
                 begin
                    if (spiDONE)
                      begin
                         if (abort)
                           begin
                              dmaREQ  <= 0;
                              spiOP   <= `spiCSH;
                              loopCNT <= 0;
                              state   <= stateFINI;
                           end
                         else if (loopCNT == 511)
                           begin
                              dmaREQ  <= 0;
                              spiOP   <= `spiTR;
                              spiTXD  <= 8'hff;
                              loopCNT <= 0;
                              //memADDR <= memADDR + 1'b1;
                              state   <= stateWRITE10;
                           end
                         else
                           begin
                              loopCNT <= loopCNT + 1'b1;
                              //memADDR <= memADDR + 1'b1;
                              state   <= stateWRITE06;
                           end
                      end
                 end

               //
               // stateWRITE10:
               //  Write CRC bytes
               //

               stateWRITE10:
                 begin
                    if (spiDONE)
                      begin
                         if (loopCNT == 0)
                           begin
                              spiOP   <= `spiTR;
                              spiTXD  <= 8'hff;
                              loopCNT <= 1;
                           end
                         else
                           begin
                              spiOP   <= `spiTR;
                              spiTXD  <= 8'hff;
                              loopCNT <= 0;
                              state   <= stateWRITE11;
                           end
                      end
                 end

               //
               // stateWRITE11:
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

               stateWRITE11:
                 begin
                    if (spiDONE)
                      begin
                         if (spiRXD[4:0] == 5'b0_010_1)
                           begin
                              spiOP   <= `spiTR;
                              spiTXD  <= 8'hff;
                              loopCNT <= 0;
                              state   <= stateWRITE12;
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
                 end

               //
               // stateWRITE12:
               //  Wait for busy token to clear.   The disk reports
               //  all zeros while the write is occurring.
               //

               stateWRITE12:
                 begin
                    if (spiDONE)
                      begin
                         if (spiRXD == 0)
                           begin
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
                           end
                         else
                           begin
                              loopCNT <= 0;
                              state   <= stateWRITE13;
                           end
                      end
                 end

               //
               // stateWRITE13:
               //  Send Send Status Command (CMD13)
               //

               stateWRITE13:
                 begin
                    if (spiDONE | (loopCNT == 0))
                      begin
                         if (loopCNT == 6)
                           begin
                              spiOP   <= `spiTR;
                              spiTXD  <= 8'hff;
                              loopCNT <= 0;
                              state   <= stateWRITE14;
                           end
                         else
                           begin
                              spiOP   <= `spiTR;
                              spiTXD  <= sdCMD13[loopCNT];
                              loopCNT <= loopCNT + 1'b1;
                           end
                      end
                 end

               //
               // stateWRITE14:
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

               stateWRITE14:
                 begin
                    if (spiDONE)
                      begin
                         if (spiRXD == 8'hff)
                           begin
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
                           end
                         else
                           begin
                              if (spiRXD == 8'h00 | spiRXD == 8'h01)
                                begin
                                   spiOP   <= `spiTR;
                                   spiTXD  <= 8'hff;
                                   loopCNT <= 0;
                                   state   <= stateWRITE15;
                                end
                              else
                                begin
                                   spiOP   <= `spiCSH;
                                   loopCNT <= 0;
                                   sdVAL   <= spiRXD;
                                   sdERR   <= 21;
                                end
                           end
                      end
                 end

               //
               // stateWRITE15:
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

               stateWRITE15:
                 begin
                    if (spiDONE)
                      begin
                         if (spiRXD == 8'h00)
                           begin
                              spiOP   <= `spiTR;
                              spiTXD  <= 8'hff;
                              loopCNT <= 1;
                              state   <= stateWRITE16;
                           end
                         else
                           begin
                              spiOP   <= `spiCSH;
                              loopCNT <= 0;
                              sdVAL   <= spiRXD;
                              sdERR   <= 22;
                              state   <= stateRWFAIL;
                           end
                      end
                 end

               //
               // stateWRITE16:
               //  Send 8 clock cycles.   Pull CS High.
               //

               stateWRITE16:
                 begin
                    if (spiDONE)
                      begin
                         spiOP   <= `spiCSH;
                         loopCNT <= 0;
                         state   <= stateFINI;
                      end
                 end

               //
               // stateWRCHK00:
               //  Setup Read Single Block (CMD17) - (same as stateRD00)
               //

               stateWRCHK00:
                 begin
                    sdCMD17[0] <= 8'h40 + 8'd17;
                    sdCMD17[1] <= sectADDR[31:24];
                    sdCMD17[2] <= sectADDR[23:16];
                    sdCMD17[3] <= sectADDR[15: 8];
                    sdCMD17[4] <= sectADDR[ 7: 0];
                    sdCMD17[5] <= 8'hff;
                    loopCNT    <= 0;
                    spiOP      <= `spiCSL;
                    state      <= stateWRCHK00;
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
                         state   <= stateDONE;
                      end
                 end

               //
               // stateDONE:
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
             
`ifdef SD_TIMEOUT
             
             if (timeout == 0)
               begin
                  sdERR <= 255;
                  state <= stateINFAIL;
               end
`endif
             
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

   assign sdDEBUG = {sdERR, state, sdVAL, sdWRCNT, sdRDCNT, 24'b0};

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
