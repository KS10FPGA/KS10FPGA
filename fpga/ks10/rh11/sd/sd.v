////////////////////////////////////////////////////////////////////
//
// KS10 Processor
//
// Brief
//  RPXX Secure Digital Interface
//
// Details
//
// File
//  sd.vhd
//
// Author
//  Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2012 Rob Doyle
//
// This source file may be used and distributed without
// restriction provided that this copyright statement is not
// removed from the file and that any derivative work contains
// the original copyright notice and the associated disclaimer.
//
// This source file is free software; you can redistribute it
// and/or modify it under the terms of the GNU Lesser General
// Public License as published by the Free Software Foundation;
// version 2.1 of the License.
//
// This source is distributed in the hope that it will be
// useful, but WITHOUT ANY WARRANTY; without even the implied
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
// PURPOSE. See the GNU Lesser General Public License for more
// details.
//
// You should have received a copy of the GNU Lesser General
// Public License along with this source; if not, download it
// from http://www.gnu.org/licenses/lgpl.txt
//
////////////////////////////////////////////////////////////////////

`include "sd.vh"
`include "sdspi.vh"

module sd(clk, rst,
          // SD Interface
          sdMISO, sdMOSI, sdSCLK, sdCS,
          
          sdOP, sdSECT,          sdINCWD,
          // Debug
          sdRDCNT, sdWRCNT, sdERR, sdVAL, sdSTATE
          );
   
   input         clk;                	// Clock
   input         rst;                   // Reset
   input	 sdMISO;		// SD Data In
   output	 sdMOSI;		// SD Data Out
   output	 sdSCLK;		// SD Clock
   output	 sdCS;			// SD Chip Select
   input  [ 1:0] sdOP;			// SD Operation
   input  [31:0] sdSECT;		// 
   output        sdINCWD;		//
   // Diagnostics
   output [ 7:0] sdRDCNT;		// Read Counter
   output [ 7:0] sdWRCNT;              	// Write Counter
   output [ 7:0] sdERR;                	// Error State
   output [ 7:0] sdVAL;                	// Error Value
   output [ 7:0] sdSTATE;		// State Value
               
`ifdef notyet
          
    // PDP8 Interface
   dmaDIN     : in  data_t;                    // DMA Data Into Disk
   dmaDOUT    : out data_t;                    // DMA Data Out of Disk
   dmaADDR    : out addr_t;                    // DMA Address
   dmaRD      : out std_logic;                 // DMA Read
   dmaWR      : out std_logic;                 // DMA Write
   dmaREQ     : out std_logic;                 // DMA Request
   dmaGNT     : in  std_logic;                 // DMA Grant
   // Interface to SD Hardware
   sdMISO     : in  std_logic;                 // SD Data In
   sdMOSI     : out std_logic;                 // SD Data Out
   sdSCLK     : out std_logic;                 // SD Clock
   sdCS       : out std_logic;                 // SD Chip Select
   // RK8E Interface
   sdOP       : in  sdOP_t;                    // SD OP
   sdMEMaddr  : in  addr_t;                    // Memory Address
   sdLEN      : in  sdLEN_t;                   // Sector Length
   sdSTAT     : out sdSTAT_t;                  // Status
   
`endif
   
   //
   // Commands:
   // Sending leading 0xff just sends clocks with data parked.
   //
   
   parameter [7:0] sdCMD0  [0:5] = {8'h40, 8'h00, 8'h00, 8'h00, 8'h00, 8'h95}; 
   parameter [7:0] sdCMD8  [0:5] = {8'h48, 8'h00, 8'h00, 8'h01, 8'haa, 8'h87};
   parameter [7:0] sdCMD13 [0:5] = {8'h4d, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff};
   parameter [7:0] sdACMD41[0:5] = {8'h69, 8'h40, 8'h00, 8'h00, 8'h00, 8'hff};
   parameter [7:0] sdCMD55 [0:5] = {8'h77, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff};
   parameter [7:0] sdCMD58 [0:5] = {8'h7a, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff};

   
   parameter [15:0] nCR  =    8;            	// NCR from SD Spec
   parameter [15:0] nAC  = 1023;         	// NAC from SD Spec
   parameter [15:0] nWR  =   20;           	// NWR from SD Spec
   
   parameter [ 7:0] stateRESET   =  0,
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
                 // Write States
                 stateWRITE00 = 29,
                 stateWRITE01 = 30,
                 stateWRITE02 = 31,
                 stateWRITE03 = 32,
                 stateWRITE04 = 33,
                 stateWRITE05 = 34,
                 stateWRITE06 = 35,
                 stateWRITE07 = 36,
                 stateWRITE08 = 37,
                 stateWRITE09 = 38,
                 stateWRITE10 = 39,
                 stateWRITE11 = 40,
                 stateWRITE12 = 41,
                 stateWRITE13 = 42,
                 stateWRITE14 = 43,
                 stateWRITE15 = 44,
                 stateWRITE16 = 45,
                 // Other States
                 stateFINI    = 46,
                 stateIDLE    = 47,
                 stateDONE    = 48,
                 stateINFAIL  = 49,
                 stateRWFAIL  = 50;
   
   reg [ 7:0] state;                    // Current State
   reg [ 2:0] spiOP;                    // SPI Op
   reg [ 7:0] spiRXD;                   // SPI Received Data
   reg [ 7:0] spiTXD;                   // SPI Transmit Data
   reg        spiDONE;                  // Asserted when SPI is done
   reg [15:0] bytecnt;		    	// Byte Counter
   reg [ 7:0] sdCMD17[0:5];             // CMD17
   reg [ 7:0] sdCMD24[0:5];             // CMD24
   reg [15:0] memADDR;                  // Memory Address
   reg        memREQ;                   // DMA Request
   reg        abort;                    // Abort this command
   reg [19:0] timeout;			// Timeout
   reg [ 7:0] sdRDCNT;                	// Read Counter
   reg [ 7:0] sdWRCNT;                	// Write Counter
   reg [ 7:0] sdERR;                	// Error State
   reg [ 7:0] sdVAL;                	// Error Value
   
   //
   // SD_STATE:
   // This process assumes a 50 MHz clock
   //
   
   always @(posedge clk)
     begin
        if (rst)
          begin
             sdERR   <= 0;
             sdVAL   <= 0;
             sdRDCNT <= 0;
             sdWRCNT <= 0;
             spiOP   <= `spiNOP;
             bytecnt <= 0;
             dmaRD   <= 0;
             dmaWR   <= 0;
             memREQ  <= 0;
             memBUF  <= 0;
             memADDR <= 0;
             dmaDOUT <= 0;
             spiTXD  <= 0;
             //sdCMD17 <= {8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00}; 
             //sdCMD24 <= {8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00}; 
             abort   <= 0;
             bytecnt <= 0;
             dmaRD   <= 0;
             dmaWR   <= 0;
             memREQ  <= 0;
             spiOP   <= `spiNOP;
             timeout <= 499999;
             state   <= stateRESET;
          end
        else
          begin
             
             dmaRD   <= 0;
             dmaWR   <= 0;
             spiOP   <= `spiNOP;
             
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
                    bytecnt <= 0;
                    state   <= stateINIT00;
                 end
               
               //
               // stateINIT00
               //  Send 8x8 clocks cycles
               //
               
               stateINIT00:
                 begin
                    timeout <= timeout - 1'b1;
                    if (spiDONE | (bytecnt == 0))
                      begin
                         if (bytecnt == nCR)
                           begin
                              bytecnt <= 0;
                              spiOP   <= `spiCSL;
                              state   <= stateINIT01;
                           end
                         else
                           begin
                              spiOP   <= `spiTR;
                              spiTXD  <= 8'hff;
                              bytecnt <= bytecnt + 1'b1;
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
                    if (spiDONE | (bytecnt == 0))
                      begin
                         if (bytecnt == 6)
                           begin
                              bytecnt <= 0;
                              state   <= stateINIT02;
                           end
                         else
                           begin
                              spiOP   <= `spiTR;
                              spiTXD  <= sdCMD0[bytecnt];
                              bytecnt <= bytecnt + 1'b1;
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
                    if (bytecnt == 0)
                      begin
                         spiOP   <= `spiTR;
                         spiTXD  <= 8'hff;
                         bytecnt <= 1;
                      end
                    else
                      begin
                         if (spiDONE)
                           begin
                              if (spiRXD == 8'hff)
                                begin
                                   if (bytecnt == nCR)
                                     begin
                                        spiOP   <= `spiCSH;
                                        bytecnt <= 0;
                                        state   <= stateRESET;
                                     end
                                   else
                                     begin
                                        spiOP   <= `spiTR;
                                        spiTXD  <= 8'hff;
                                        bytecnt <= bytecnt + 1'b1;
                                     end
                                end
                              else
                                begin
                                   spiOP   <= `spiCSH;
                                   bytecnt <= 0;
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
                    if (bytecnt == 0)
                      begin
                         spiOP   <= `spiTR;
                         spiTXD  <= 8'hff;
                         bytecnt <= 1;
                      end
                    else if (spiDONE)
                      begin
                         spiOP   <= `spiCSL;
                         bytecnt <= 0;
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
                    if (spiDONE | (bytecnt == 0))
                      begin
                         if (bytecnt == 6)
                           begin
                              bytecnt <= 0;
                              state   <= stateINIT05;
                           end
                         else
                           begin
                              spiOP   <= `spiTR;
                              spiTXD  <= sdCMD8[bytecnt];
                              bytecnt <= bytecnt + 1'b1;
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
                    if (bytecnt == 0)
                      begin
                         spiOP   <= `spiTR;
                         spiTXD  <= 8'hff;
                         bytecnt <= 1;
                      end
                    else
                      begin
                         if (spiDONE)
                           begin
                              if (spiRXD == 8'hff)
                                begin
                                   if (bytecnt == nCR)
                                     begin
                                        spiOP   <= `spiCSH;
                                        bytecnt <= 0;
                                        sdERR   <= 1;
                                        state   <= stateINFAIL;
                                     end
                                   else
                                     begin
                                        spiOP   <= `spiTR;
                                        spiTXD  <= 8'hff;
                                        bytecnt <= bytecnt + 1'b1;
                                     end
                                end
                              else
                                begin
                                   bytecnt   <= 0;
                                   if (spiRXD == 8'h01)
                                     begin
                                        state <= stateINIT06;
                                     end
                                   else if (spiRXD <= 8'h05)
                                     begin
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
                    case (bytecnt)
                      0:
                        begin
                           spiOP   <= `spiTR;
                           spiTXD  <= 8'hff;
                           bytecnt <= 1;
                        end
                      1:
                        begin
                           if (spiDONE)
                             begin
                                if (spiRXD == 8'h00)
                                  begin
                                     spiOP   <= `spiTR;
                                     spiTXD  <= 8'hff;
                                     bytecnt <= 2;
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
                                     bytecnt <= 3;
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
                                     bytecnt <= 4;
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
                                     bytecnt <= 0;
                                     state   <= stateINIT07;
                                  end
                                else
                                  begin
                                     sdERR <= 7;
                                     state <= stateINFAIL;
                                  end
                             end
                        end
                      default:
                        begin
                           ;
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
                    if (bytecnt == 0)
                      begin
                         spiOP   <= `spiTR;
                         spiTXD  <= 8'hff;
                         bytecnt <= 1;
                      end
                    else if (spiDONE)
                      begin
                         spiOP   <= `spiCSL;
                         bytecnt <= 0;
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
                    if (spiDONE | (bytecnt == 0))
                      begin
                         if (bytecnt == 6)
                           begin
                              bytecnt <= 0;
                              state   <= stateINIT09;
                           end
                         else
                           begin
                              spiOP   <= `spiTR;
                              spiTXD  <= sdCMD55[bytecnt];
                              bytecnt <= bytecnt + 1'b1;
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
                    if (bytecnt == 0)
                      begin
                         spiOP   <= `spiTR;
                         spiTXD  <= 8'hff;
                         bytecnt <= 1;
                      end
                    else
                      begin
                         if (spiDONE)
                           begin
                              if (spiRXD == 8'hff)
                                begin
                                   if (bytecnt == nCR)
                                     begin
                                        spiOP   <= `spiCSH;
                                        bytecnt <= 0;
                                        sdERR   <= 8;
                                        state   <= stateINFAIL;
                                     end
                                   else
                                     begin
                                        spiOP   <= `spiTR;
                                        spiTXD  <= 8'hff;
                                        bytecnt <= bytecnt + 1'b1;
                                     end
                                end
                              else
                                begin
                                   spiOP   <= `spiCSH;
                                   bytecnt <= 0;
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
                    if (bytecnt == 0)
                      begin
                         spiOP   <= `spiTR;
                         spiTXD  <= 8'hff;
                         bytecnt <= 1;
                      end
                    else if (spiDONE)
                      begin
                         spiOP   <= `spiCSL;
                         bytecnt <= 0;
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
                    if (spiDONE | (bytecnt == 0) )
                      begin
                         if (bytecnt == 6)
                           begin
                              bytecnt <= 0;
                              state   <= stateINIT12;
                           end
                         else
                           begin
                              spiOP   <= `spiTR;
                              spiTXD  <= sdACMD41[bytecnt];
                              bytecnt <= bytecnt + 1'b1;
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
                    if (bytecnt == 0)
                      begin
                         spiOP   <= `spiTR;
                         spiTXD  <= 8'hff;
                         bytecnt <= 1;
                      end
                    else
                      begin
                         if (spiDONE)
                           begin
                              if (spiRXD == 8'hff)
                                begin
                                   if (bytecnt == nCR)
                                     begin
                                        spiOP   <= `spiCSH;
                                        bytecnt <= 0;
                                        sdERR   <= 9;
                                        state   <= stateINFAIL;
                                     end
                                   else
                                     begin
                                        spiOP   <= `spiTR;
                                        spiTXD  <= 8'hff;
                                        bytecnt <= bytecnt + 1'b1;
                                     end
                                end
                              else
                                begin
                                   spiOP   <= `spiCSH;
                                   bytecnt <= 0;
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
                    if (bytecnt == 0)
                      begin
                         spiOP   <= `spiTR;
                         spiTXD  <= 8'hff;
                         bytecnt <= 1;
                      end
                    else if (spiDONE)
                      begin
                         spiOP   <= `spiCSL;
                         bytecnt <= 0;
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
                    if (spiDONE | (bytecnt == 0))
                      begin
                         if (bytecnt == 6)
                           begin
                              bytecnt <= 0;
                              state   <= stateINIT15;
                           end
                         else
                           begin
                              spiOP   <= `spiTR;
                              spiTXD  <= sdCMD58[bytecnt];
                              bytecnt <= bytecnt + 1'b1;
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
                    if (bytecnt == 0)
                      begin
                         spiOP   <= `spiTR;
                         spiTXD  <= 8'hff;
                         bytecnt <= 1;
                      end
                    else
                      begin
                         if (spiDONE)
                           begin
                              if (spiRXD == 8'hff)
                                begin
                                   if (bytecnt == nCR)
                                     begin
                                        spiOP   <= `spiCSH;
                                        bytecnt <= 0;
                                        sdERR   <= 10;
                                        state   <= stateINFAIL;
                                     end
                                   else
                                     begin
                                        spiOP   <= `spiTR;
                                        spiTXD  <= 8'hff;
                                        bytecnt <= bytecnt + 1'b1;
                                     end
                                end
                              else
                                begin
                                   bytecnt    <= 0;
                                   if (spiRXD == 8'h00)
                                     state <= stateINIT16;
                                   else
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
                    case (bytecnt)
                      0:
                        begin
                           spiOP   <= `spiTR;
                           spiTXD  <= 8'hff;
                           bytecnt <= 1;
                        end
                      1:
                        begin
                           if (spiDONE)
                             begin
                                spiOP      <= `spiTR;
                                spiTXD     <= 8'hff;
                                bytecnt    <= 2;
                             end
                        end
                      2:
                        begin
                           if (spiDONE)
                             begin
                                spiOP      <= `spiTR;
                                spiTXD     <= 8'hff;
                                bytecnt    <= 3;
                             end
                        end
                      3:
                        begin
                           if (spiDONE)
                             begin
                                spiOP      <= `spiTR;
                                spiTXD     <= 8'hff;
                                bytecnt    <= 4;
                             end
                        end
                      4:
                        begin
                           if (spiDONE)
                             begin
                                spiOP      <= `spiCSH;
                                bytecnt    <= 0;
                                state      <= stateINIT17;
                             end
                        end
                      default
                        begin
                           ;
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
                    if (bytecnt == 0)
                      begin
                         spiOP   <= `spiTR;
                         spiTXD  <= 8'hff;
                         bytecnt <= 1;
                      end
                    else if (spiDONE)
                      begin
                         bytecnt <= 0;
`ifdef GOFAST                         
                         spiOP   <= spiFAST;
`endif                         
                         state   <= stateIDLE;
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
                           sdRDCNT <= sdRDCNT + 1'b1;
                           state <= stateREAD00;
                        end
                      `sdopWR:
                        begin
                           sdWRCNT <= sdWRCNT + 1'b1;
                           state <= stateWRITE00;
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
               //
               
               stateREAD00:
                 begin
                    memADDR    <= sdMEMaddr;
                    sdCMD17[0] <= 8'h51;
                    sdCMD17[1] <= sdSECT[31 :24];
                    sdCMD17[2] <= sdSECT[23 :16];
                    sdCMD17[3] <= sdSECT[15 : 8];
                    sdCMD17[4] <= sdSECT[ 7 : 0];
                    sdCMD17[5] <= 8'hff;
                    bytecnt    <= 0;
                    spiOP      <= `spiCSL;
                    state      <= stateREAD01;
                 end
               
               //
               // stateREAD01:
               //  Send Read Single Block (CMD17)
               //
               
               stateREAD01:
                 begin
                    if (spiDONE | (bytecnt == 0))
                      begin
                         if (bytecnt == 6)
                           begin
                              bytecnt <= 0;
                              state   <= stateREAD02;
                           end
                         else
                           begin
                              spiOP   <= `spiTR;
                              spiTXD  <= sdCMD17[bytecnt];
                              bytecnt <= bytecnt + 1'b1;
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
                    if (bytecnt == 0)
                      begin
                         spiOP   <= `spiTR;
                         spiTXD  <= 8'hff;
                         bytecnt <= 1;
                      end
                    else
                      begin
                         if (spiDONE)
                           begin
                              if (spiRXD == 8'hff)
                                begin
                                   if (bytecnt == nCR)
                                     begin
                                        spiOP   <= `spiCSH;
                                        bytecnt <= 0;
                                        sdERR   <= 12;
                                        state   <= stateRWFAIL;
                                     end
                                   else
                                     begin
                                        spiOP   <= `spiTR;
                                        spiTXD  <= 8'hff;
                                        bytecnt <= bytecnt + 1'b1;
                                     end
                                end
                              else
                                begin
                                   bytecnt <= 0;
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
                    if (bytecnt == 0)
                      begin
                         spiOP   <= `spiTR;
                         spiTXD  <= 8'hff;
                         bytecnt <= 1;
                      end
                    else
                      begin
                         if (spiDONE)
                           begin
                              if (spiRXD == 8'hff)
                                begin
                                   if (bytecnt == nAC)
                                     begin
                                        spiOP   <= `spiCSH;
                                        bytecnt <= 0;
                                        sdERR   <= 14;
                                        state   <= stateRWFAIL;
                                     end
                                   else
                                     begin
                                        spiOP   <= `spiTR;
                                        spiTXD  <= 8'hff;
                                        bytecnt <= bytecnt + 1'b1;
                                     end
                                end
                              else
                                begin
                                   bytecnt <= 0;
                                   if (spiRXD == 8'hfe)
                                     begin
                                        state <= stateREAD04;
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
               //  Acquire DMA.  Setup for loop.
               //
               
               stateREAD04:
                 begin
                    memREQ <= 1;
                    if (dmaGNT)
                      begin
                         spiOP   <= `spiTR;
                         spiTXD  <= 8'hff;
                         bytecnt <= 0;
                         state   <= stateREAD05;
                      end
                 end
               
               //
               // stateREAD05:
               //  Read LSBYTE of data from disk (even addresses)
               //  Loop destination
               //
               
               stateREAD05:
                 begin
                    if (spiDONE)
                      begin
                         spiOP   <= `spiTR;
                         spiTXD  <= 8'hff;
                         bytecnt <= bytecnt + 1'b1;
                         dmaDOUT[4 : 11] <= spiRXD[0 : 7];
                         state <= stateREAD06;
                      end
                 end
               
               //
               // stateREAD06:
               //  Read MSBYTE of data from disk (odd addresses).
               //  Discard the top four bits forming a 12-bit word
               //  from the two bytes.
               //
               
               stateREAD06:
                 begin
                    if (spiDONE)
                      begin
                         spiOP   <= `spiTR;
                         spiTXD  <= 8'hff;
                         dmaDOUT[0 : 3] <= spiRXD[4 : 7];
                         state <= stateREAD07;
                      end
                 end
               
               //
               // stateREAD07:
               //  Write disk data to memory.
               //  if memREQ is not asserted, we are reading the second
               //  128 words of a 128 word read.  Notice no DMA occurs
               //  to memory and the bits are dropped.
               //
               
               stateREAD07:
                 begin
                    if (memREQ)
                      begin
                         dmaWR <= 1;
                      end
                    state <= stateREAD08;
                 end
               
               //
               // stateREAD08:
               //  This state checks the loop conditions:
               //  1.  An abort command causes the loop to terminate immediately.
               //  2.  if sdLEN is asserted (128 word read) at byte 255,)
               //      the memory write DMA request is dropped.  The DMA address
               //      stops incrementing.  The state machine continues to read
               //      all 256 words (512 bytes).
               //  3.  At word 256 (byte 512), the loop terminates.
               //
               
               stateREAD08:
                 begin
                    if (abort)
                      begin
                         memREQ  <= 0;
                         spiOP   <= `spiCSH;
                         bytecnt <= 0;
                         state   <= stateFINI;
                      end
                    else if (bytecnt == 511)
                      begin
                         memREQ  <= 0;
                         memADDR <= memADDR + 1'b1;
                         bytecnt <= 0;
                         state   <= stateREAD09;
                      end
                    else if (bytecnt >= 255 & sdLEN)
                      begin
                         memREQ  <= 0;
                         bytecnt <= bytecnt + 1'b1;
                         state   <= stateREAD05;
                      end
                    else
                      begin
                         memADDR <= memADDR + 1'b1;
                         bytecnt <= bytecnt + 1'b1;
                         state   <= stateREAD05;
                      end
                 end
               
               //
               // stateREAD09:
               //  Read 2 bytes of CRC which is required for the SD Card.
               //
               
               stateREAD09:
                 begin
                    if (bytecnt == 0)
                      begin
                         spiOP   <= `spiTR;
                         spiTXD  <= 8'hff;
                         bytecnt <= 1;
                      end
                    else
                      begin
                         if (spiDONE)
                           begin
                              if (bytecnt)
                                begin
                                   spiOP   <= `spiTR;
                                   spiTXD  <= 8'hff;
                                   bytecnt <= 2;
                                end
                              else if (bytecnt == 2)
                                begin
                                   spiOP   <= `spiCSH;
                                   bytecnt <= 0;
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
                    memADDR    <= sdMEMaddr;
                    sdCMD24[0] <= 8'h58;
                    sdCMD24[1] <= sdSECT[31 : 24];
                    sdCMD24[2] <= sdSECT[23 : 16];
                    sdCMD24[3] <= sdSECT[15 :  8];
                    sdCMD24[4] <= sdSECT[ 7 :  0];
                    sdCMD24[5] <= 8'hff;
                    bytecnt    <= 0;
                    spiOP      <= `spiCSL;
                    state      <= stateWRITE01;
                 end
               
               //
               // stateWRITE01:
               //  Send Write Single Block (CMD24)
               //
               
               stateWRITE01:
                 begin
                    if (spiDONE | (bytecnt == 0))
                      begin
                         if (bytecnt == 6)
                           begin
                              bytecnt <= 0;
                              state   <= stateWRITE02;
                           end
                         else
                           begin
                              spiOP   <= `spiTR;
                              spiTXD  <= sdCMD24[bytecnt];
                              bytecnt <= bytecnt + 1'b1;
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
                    if (bytecnt == 0)
                      begin
                         spiOP   <= `spiTR;
                         spiTXD  <= 8'hff;
                         bytecnt <= 1;
                      end
                    else
                      begin
                         if (spiDONE)
                           begin
                              if (spiRXD == 8'hff)
                                begin
                                   if (bytecnt == nCR)
                                     begin
                                        spiOP   <= `spiCSH;
                                        bytecnt <= 0;
                                        sdERR   <= 16;
                                        state   <= stateRWFAIL;
                                     end
                                   else
                                     begin
                                        spiOP   <= `spiTR;
                                        spiTXD  <= 8'hff;
                                        bytecnt <= bytecnt + 1'b1;
                                     end
                                end
                              else
                                begin
                                   bytecnt <= 0;
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
                    if (bytecnt == 0)
                      begin
                         spiOP   <= `spiTR;
                         spiTXD  <= 8'hff;
                         bytecnt <= 1;
                      end
                    else if (spiDONE)
                      begin
                         bytecnt <= 0;
                         state   <= stateWRITE04;
                      end
                 end
               
               //
               // stateWRITE04:
               //  Send Write Start Token.  The write start token is 8'hfe
               //
               
               stateWRITE04:
                 begin
                    if (bytecnt == 0)
                      begin
                         spiOP   <= `spiTR;
                         spiTXD  <= 8'hfe;
                         bytecnt <= 1;
                      end
                    else if (spiDONE)
                      begin
                         bytecnt <= 0;
                         state   <= stateWRITE05;
                      end
                 end
               
               //
               // stateWRITE05:
               //  Start a DMA Read Address Cycle
               //
               
               stateWRITE05:
                 begin
                    memREQ <= 1;
                    if (dmaGNT)
                      begin
                         state <= stateWRITE06;
                      end
                 end
               
               //
               // stateWRITE06:
               //  Loop destination
               //  This is the data phase of the read cycle.
               //  If memREQ is not asserted, we are writing the second
               //  128 words of a 128 word write.  Notice no DMA occurs.
               //
               
               stateWRITE06:
                 begin
                    if (memREQ)
                      begin
                         dmaRD <= 1;
                      end
                    state <= stateWRITE07;
                 end
               
               //
               // stateWRITE07:
               //  Write LSBYTE of data to disk (even addresses)
               //   This state has two modes:
               //    If memREQ is asserted we are operating normally.
               //    If memREQ is negated we are writing the last 128
               //     words of a 128 word operation.  Therefore we
               //     write zeros.  See file header.
               //
               
               stateWRITE07:
                 begin
                    spiOP  <= `spiTR;
                    if (memREQ)
                      begin
                         memBUF <= dmaDIN[0 : 3];
                         spiTXD <= dmaDIN[4 :11];
                      end
                    else
                      begin
                         memBUF <= b0000;
                         spiTXD <= b0000_0000;
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
                         spiTXD  <= b0000 & memBUF;
                         bytecnt <= bytecnt + 1'b1;
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
                              memREQ  <= 0;
                              spiOP   <= `spiCSH;
                              bytecnt <= 0;
                              state   <= stateFINI;
                           end
                         else if (bytecnt == 511)
                           begin
                              memREQ  <= 0;
                              spiOP   <= `spiTR;
                              spiTXD  <= 8'hff;
                              bytecnt <= 0;
                              memADDR <= memADDR + 1'b1;
                              state   <= stateWRITE10;
                           end
                         else if ((bytecnt == 255) & sdLEN)
                           begin
                              memREQ  <= 0;
                              spiOP   <= `spiCSH;
                              bytecnt <= bytecnt + 1'b1;
                              state   <= stateWRITE06;
                           end
                         else
                           begin
                              bytecnt <= bytecnt + 1'b1;
                              memADDR <= memADDR + 1'b1;
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
                         if (bytecnt == 0)
                           begin
                              spiOP   <= `spiTR;
                              spiTXD  <= 8'hff;
                              bytecnt <= 1;
                           end
                         else
                           begin
                              spiOP   <= `spiTR;
                              spiTXD  <= 8'hff;
                              bytecnt <= 0;
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
                         if (spiRXD[3 : 7] == 5'b0_010_1)
                           begin
                              spiOP   <= `spiTR;
                              spiTXD  <= 8'hff;
                              bytecnt <= 0;
                              state   <= stateWRITE12;
                           end
                         else
                           begin
                              spiOP   <= `spiCSH;
                              sdVAL   <= spiRXD;
                              sdERR   <= 18;
                              bytecnt <= 0;
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
                              if (bytecnt == 65535)
                                begin
                                   spiOP   <= `spiCSH;
                                   bytecnt <= 0;
                                   sdERR   <= 19;
                                   state   <= stateRWFAIL;
                                end
                              else
                                begin
                                   spiOP   <= `spiTR;
                                   spiTXD  <= 8'hff;
                                   bytecnt <= bytecnt + 1'b1;
                                end
                           end
                         else
                           begin
                              bytecnt <= 0;
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
                    if (spiDONE | (bytecnt == 0))
                      begin
                         if (bytecnt == 6)
                           begin
                              spiOP   <= `spiTR;
                              spiTXD  <= 8'hff;
                              bytecnt <= 0;
                              state   <= stateWRITE14;
                           end
                         else
                           begin
                              spiOP   <= `spiTR;
                              spiTXD  <= sdCMD13(bytecnt);
                              bytecnt <= bytecnt + 1'b1;
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
                              if (bytecnt == nCR)
                                begin
                                   spiOP   <= `spiCSH;
                                   bytecnt <= 0;
                                   sdERR   <= 20;
                                   state   <= stateRWFAIL;
                                end
                              else
                                begin
                                   spiOP   <= `spiTR;
                                   spiTXD  <= 8'hff;
                                   bytecnt <= bytecnt + 1'b1;
                                end
                           end
                         else
                           begin
                              if (spiRXD == 8'h00 | spiRXD == 8'h01)
                                begin
                                   spiOP   <= `spiTR;
                                   spiTXD  <= 8'hff;
                                   bytecnt <= 0;
                                   state   <= stateWRITE15;
                                end
                              else
                                begin
                                   spiOP   <= `spiCSH;
                                   bytecnt <= 0;
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
                              bytecnt <= 1;
                              state   <= stateWRITE16;
                           end
                         else
                           begin
                              spiOP   <= `spiCSH;
                              bytecnt <= 0;
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
                         bytecnt <= 0;
                         state   <= stateFINI;
                      end
                 end
               
               //
               // stateFINI:
               //  Send 8 clock cycles
               //
               
               stateFINI:
                 begin
                    if (bytecnt == 0)
                      begin
                         spiOP   <= `spiTR;
                         spiTXD  <= 8'hff;
                         bytecnt <= 1;
                      end
                    else if (spiDONE)
                      begin
                         bytecnt <= 0;
                         state   <= stateDONE;
                      end
                 end
               
               //
               // stateDONE:
               //
               
               stateDONE:
                 begin
                    state   <= stateIDLE;
                 end
               
               //
               // stateINFAIL:
               //  Initialization failed somehow.
               //
               
               stateINFAIL:
                 begin
                    state   <= stateINFAIL;
                 end
               
               //
               // stateRWFAIL:
               //  Read or Write failed somehow.
               //
               
               stateRWFAIL:
                 begin
                    state   <= stateRWFAIL;
                 end
               
             endcase;
             
             if (timeout == 0)
               begin
                  state  <= stateINFAIL;
               end
             
          end
     end

   //
   // SPI Interface
   //
   
   SDSPI uSDSPI
     (.clk	(clk),
      .rst	(rst),
      .spiOP	(spiOP),
      .spiTXD	(spiTXD),
      .spiRXD	(spiRXD),
      .spiMISO	(sdMISO),
      .spiMOSI	(sdMOSI),
      .spiSCLK	(sdSCLK),
      .spiCS	(sdCS),
      .spiDONE  (spiDONE)
      );   
   
   assign sdSTATE = state;
   
endmodule
