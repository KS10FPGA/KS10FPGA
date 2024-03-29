////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor Testbench
//
// Brief
//   KS-10 FPGA Test Bench
//
// File
//   testbench.sv
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2022 Rob Doyle
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

`include "uart.vh"

`define STRLEN 80
`define STRDEF 0:`STRLEN*8-1

//
// Default starting address (SMMON)
//

`ifndef STARTADDR
 `define STARTADDR 18'o020000
`endif

//
// Default breakpoint settings
//

`ifndef valBRAR0
 `define valBRAR0 36'o000000_000000
`endif

`ifndef valBRMR0
 `define valBRMR0 36'o000000_000000
`endif

`ifndef valBRAR1
 `define valBRAR1 36'o000000_000000
`endif

`ifndef valBRMR1
 `define valBRMR1 36'o000000_000000
`endif

`ifndef valBRAR2
 `define valBRAR2 36'o000000_000000
`endif

`ifndef valBRMR2
 `define valBRMR2 36'o000000_000000
`endif

`ifndef valBRAR3
 `define valBRAR3 36'o000000_000000
`endif

`ifndef valBRMR3
 `define valBRMR3 36'o000000_000000
`endif

module testbench;

   //
   // Front Panel
   //

   wire         SW_RESET_N;      // Reset switch
   wire         SW_BOOT_N;       // Boot switch
   wire         SW_HALT_N;       // Halt switch
   wire         LED_PWR_N;       // Power LED
   wire         LED_RESET_N;     // Reset LED
   wire         LED_BOOT_N;      // Boot LED
   wire         LED_HALT_N;      // Halt LED
   wire         SPARE0;          // Spare
   wire         SPARE1;          // Spare
   wire         SPARE2;          // Spare

   //
   // External SD Card array
   //

   wire         ESD_SCLK;        // Serial clock
   wire         ESD_DI;          // Serial data in
   wire         ESD_DO;          // Serial data out
   wire         ESD_CS_N;        // Serial data chip select
   wire         ESD_RST_N;       // Serial config reset
   wire         ESD_RD_N;        // Serial config data read
   wire         ESD_WR_N;        // Serial config data write
   wire [ 4: 0] ESD_ADDR;        // Serial config data address
   wire         ESD_DIO;         // Serial config data

   //
   // AXI Bus
   //

   reg  [ 7: 0] axiAWADDR;       // Write address
   reg          axiAWVALID;      // Write address valid
   reg  [ 2: 0] axiAWPROT;       // Write protections
   wire         axiAWREADY;      // Write address ready
   reg  [31: 0] axiWDATA;        // Write data
   reg  [ 3: 0] axiWSTRB;        // Write data strobe
   reg          axiWVALID;       // Write data valid
   wire         axiWREADY;       // Write data ready
   reg  [ 7: 0] axiARADDR;       // Read  address
   reg          axiARVALID;      // Read  address valid
   reg [ 2: 0]  axiARPROT;       // Read  protections
   wire         axiARREADY;      // Read  address ready
   wire [31: 0] axiRDATA;        // Read  data
   wire [ 1: 0] axiRRESP;        // Read  data response
   wire         axiRVALID;       // Read  data valid
   reg          axiRREADY;       // Read  data ready
   wire [ 1: 0] axiBRESP;        // Write response
   wire         axiBVALID;       // Write response valid
   wire         axiBREADY = 1;   // Write response ready

   //
   // Console Interfaces
   //

   wire [ 7:0] RP_LEDS;         // RPXX Leds

   //
   // DZ11 Serial Interface
   //

   wire [ 7: 0] DZ_TXD;         // DZ11 RS-232 Received Data
   wire [ 7: 0] DZ_RXD = 8'hff; // DZ11 RS-232 Transmitted Data
   wire [ 7: 0] DZ_DTR;         // DZ11 RS-232 Data Terminal Ready

   //
   // LP26 Serial Interface
   //

   wire LP_TXD;                 // LP26 RS-232 Received Data
   wire LP_RXD = 1'b1;          // LP26 RS-232 Transmitted Data

   //
   // RH11 Secure Digital Interface
   //

   wire         sdCD_N = 0;      // SD Card Detect
   wire         SD_MISO;         // SD Data In
   wire         SD_MOSI;         // SD Data Out
   wire         SD_SCLK;         // SD Clock
   wire         SD_SS_N;         // SD Chip Select

   //
   // SSRAM
   //

`ifdef SSRAMx36
   wire         SSRAM_CLK;      // SSRAM Clock
   wire         SSRAM_WE_N;     // SSRAM Write
   wire [19: 0] SSRAM_A;        // SSRAM Address Bus
   wire [35: 0] SSRAM_D;        // SSRAM Data Bus
   wire         SSRAM_ADV;      // SSRAM Advance
`else
   wire         SSRAM_CLK;      // SSRAM Clock
   wire         SSRAM_WE_N;     // SSRAM Write
   wire [21: 0] SSRAM_A;        // SSRAM Address Bus
   wire [17: 0] SSRAM_D;        // SSRAM Data Bus
   wire         SSRAM_ADV;      // SSRAM Advance
`endif

   //
   // MT Debug
   //

   wire [63: 0] mtDIRO;

   //
   // DE10 Nano Interfaces
   //

   wire [ 1: 0] KEY;            // KEY
   wire [ 3: 0] SW;             // SW

   //
   // CPU Clock and Reset
   //

   wire         cpuCLK;
   wire         cpuRST;

   //
   // 50 MHz clock generator
   //
   // Details
   //  Clock is inverted every 10.0 ns
   //

   reg clk;                  // Memory Clock
   initial
     begin
        clk <= 0;
        forever
          begin
             #10.0 clk <= 0;
             #10.0 clk <= 1;
          end
     end

   //
   // Synchronous reset
   //

   integer rstcnt = 0;
   reg rst = 1;

   always @(posedge clk)
     begin
        if (rst)
          begin
             if (rstcnt == 16)
               begin
                  rst <= 0;
                  $display("[%11.3f] KS10: Negating Reset", $time/1.0e3);
               end
             else
               rstcnt = rstcnt + 1;
          end
     end

   //
   // Control/Status Register Definitions
   //

   localparam [ 0:31] statRESET     = 32'h00000001,
                      statINTR      = 32'h00000002,
                      statCACHEEN   = 32'h00000004,
                      statTRAPEN    = 32'h00000008,
                      statTIMEREN   = 32'h00000010,
                      statEXEC      = 32'h00000020,
                      statCONT      = 32'h00000040,
                      statRUN       = 32'h00000080,
                      statHALT      = 32'h00000100,
                      statNXMNXD    = 32'h00000200,
                      statGO        = 32'h00010000;

   localparam [ 0:35] valREGCIR     = {18'o254000, `STARTADDR};

   //
   // Register Addresses from Console Interface
   //

   localparam [31: 0] addrREGADDR   = 32'h4000_0000,
                      addrREGDATA   = 32'h4000_0008,
                      addrREGCIR    = 32'h4000_0010,
                      addrREGSTATUS = 32'h4000_0018,
                      addrREGDZCCR  = 32'h4000_001c,
                      addrREGLPCCR  = 32'h4000_0020,
                      addrREGRPCCR  = 32'h4000_0024,
                      addrREGMTCCR  = 32'h4000_0028,
                      addrREGDPCCR  = 32'h4000_002c,
                      addrREGCKMCCR = 32'h4000_0030,
                      addrDITR      = 32'h4000_0050,
                      addrPCIR      = 32'h4000_0058,
                      addrMTDIR     = 32'h4000_0060,
                      addrMTDEBUG   = 32'h4000_0068,
                      addrRPDEBUG   = 32'h4000_0070,
                      addrBRAR0     = 32'h4000_0080,
                      addrBRMR0     = 32'h4000_0088,
                      addrBRAR1     = 32'h4000_0090,
                      addrBRMR1     = 32'h4000_0098,
                      addrBRAR2     = 32'h4000_00a0,
                      addrBRMR2     = 32'h4000_00a8,
                      addrBRAR3     = 32'h4000_00b0,
                      addrBRMR3     = 32'h4000_00b8,
                      addrVERSION   = 32'h4000_00f8;

   //
   // KS10 Addresses
   //

   localparam [18:35] addrSWITCH    = 18'o000030,
                      addrKASW      = 18'o000031,
                      addrCIN       = 18'o000032,
                      addrCOUT      = 18'o000033,
                      addrKIN       = 18'o000034,
                      addrKOUT      = 18'o000035,
                      addrRHBASE    = 18'o000036,
                      addrRHUNIT    = 18'o000037,
                      addrMTPARAM   = 18'o000040;

   //
   // Halt Status
   //

   reg [0:35] haltStatus;
   reg [0:35] haltAddr;

   //
   // Line buffer for expect()
   //

   reg [`STRDEF] inBuf;
   reg [`STRDEF] outBuf;

   //
   // Semaphore to control access to console registers
   // This ensures that the CTY and MT don't collide
   //

   semaphore key;

`include "conio.sv"

   //
   // Print Halt Status Block
   //

   task printHaltStatusBlock;
      input [18:35] address;
      reg   [ 0:35] temp;
      begin
         conREADMEMP(address +  0, temp);
         $display("[%11.3f] KS10:   MAG is %012o", $time/1.0e3, temp);
         conREADMEMP(address +  1, temp);
         $display("[%11.3f] KS10:   PC  is %012o", $time/1.0e3, temp);
         conREADMEMP(address +  2, temp);
         $display("[%11.3f] KS10:   HR  is %012o", $time/1.0e3, temp);
         conREADMEMP(address +  3, temp);
         $display("[%11.3f] KS10:   AR  is %012o", $time/1.0e3, temp);
         conREADMEMP(address +  4, temp);
         $display("[%11.3f] KS10:   ARX is %012o", $time/1.0e3, temp);
         conREADMEMP(address +  5, temp);
         $display("[%11.3f] KS10:   BR  is %012o", $time/1.0e3, temp);
         conREADMEMP(address +  6, temp);
         $display("[%11.3f] KS10:   BRX is %012o", $time/1.0e3, temp);
         conREADMEMP(address +  7, temp);
         $display("[%11.3f] KS10:   ONE is %012o", $time/1.0e3, temp);
         conREADMEMP(address +  8, temp);
         $display("[%11.3f] KS10:   EBR is %012o", $time/1.0e3, temp);
         conREADMEMP(address +  9, temp);
         $display("[%11.3f] KS10:   UBR is %012o", $time/1.0e3, temp);
         conREADMEMP(address + 10, temp);
         $display("[%11.3f] KS10:   MSK is %012o", $time/1.0e3, temp);
         conREADMEMP(address + 11, temp);
         $display("[%11.3f] KS10:   FLG is %012o", $time/1.0e3, temp);
         conREADMEMP(address + 12, temp);
         $display("[%11.3f] KS10:   PI  is %012o", $time/1.0e3, temp);
         conREADMEMP(address + 13, temp);
         $display("[%11.3f] KS10:   X1  is %012o", $time/1.0e3, temp);
         conREADMEMP(address + 14, temp);
         $display("[%11.3f] KS10:   TO  is %012o", $time/1.0e3, temp);
         conREADMEMP(address + 15, temp);
         $display("[%11.3f] KS10:   T1  is %012o", $time/1.0e3, temp);
         conREADMEMP(address + 16, temp);
         $display("[%11.3f] KS10:   VMA is %012o", $time/1.0e3, temp);
      end
   endtask

   //
   // Print Halt Status Word
   //

   task printHaltStatus;
      begin
         conREADMEMP(0, haltStatus);
         conREADMEMP(1, haltAddr);
         case (haltStatus[24:35])
           12'o0000 : $display("[%11.3f] KS10: Halt Status: Microcode Startup", $time/1.0e3);
           12'o0001 : $display("[%11.3f] KS10: Halt Status: Halt Instruction", $time/1.0e3);
           12'o0002 : $display("[%11.3f] KS10: Halt Status: Console Halt", $time/1.0e3);
           12'o0100 : $display("[%11.3f] KS10: Halt Status: IO Page Failure", $time/1.0e3);
           12'o0101 : $display("[%11.3f] KS10: Halt Status: Illegal Interrupt Instruction", $time/1.0e3);
           12'o0102 : $display("[%11.3f] KS10: Halt Status: Pointer to Unibus Vector is zero", $time/1.0e3);
           12'o1000 : $display("[%11.3f] KS10: Halt Status: Illegal Microcode Dispatch", $time/1.0e3);
           12'o1005 : $display("[%11.3f] KS10: Halt Status: Microcode Startup Check Failed", $time/1.0e3);
           default  : $display("[%11.3f] KS10: Halt Status: Unknown Halt Cause", $time/1.0e3);
         endcase
         if (haltStatus[24:35] != 0)
           begin
              $display("[%11.3f] KS10: Halt Address: %06o", $time/1.0e3, haltAddr[18:35]);
              printHaltStatusBlock(18'o376000);
           end
      end
   endtask

   //
   // This function left justifies a string
   //

   function [`STRDEF] ljstr;
      input [`STRDEF] s;
      begin
         while (s[0:7] == 0)
           s = s << 8;
         ljstr = s;
      end
   endfunction

   //
   // This task polls the console output register.  When the VALID bit is
   // asserted, a character is present.  When the character has been read, the
   // valid bit is cleared.
   //

   task getchar;
      input  integer fd;
      reg    [ 0:35] temp;
      begin
         conREADMEM(addrCOUT, temp);
         if (temp[27])
           begin
              if ((temp[28:35] >= 8'h20) && (temp[28:35] < 8'h7f))
                begin
                   $display("[%11.3f] KS10: CTY Output: \"%s\"", $time/1.0e3,
                            temp[28:35]);
                   $fwrite(fd, "%s", temp[28:35]);
                   inBuf = {inBuf, temp[28:35]};
                end
              else if ((temp[28:35] == 8'h0a) || (temp[28:35] == 8'h0d))
                begin
                   $display("[%11.3f] KS10: CTY Output: \"<%02x>\"",
                            $time/1.0e3, temp[28:35]);
                   $fwrite(fd, "%s", temp[28:35]);
                   inBuf = 0;
                end
              else
                begin
                   $display("[%11.3f] KS10: CTY Output: \"<%02x>\"",
                            $time/1.0e3, temp[28:35]);
                end
              $fflush(fd);
              conWRITEMEM(addrCOUT, 36'b0);
           end
      end
   endtask

   //
   // putchar()
   //

   task putchar;
      input [0:7] ch;
      begin
         outBuf = {outBuf, ch};
      end
   endtask

   //
   // puts()
   //

   task puts;
      input [`STRDEF] s;
      begin
         outBuf = 0;
         while (s != 0)
           begin
              s = ljstr(s);
              putchar(s[0:7]);
              s = s << 8;
           end
      end
   endtask

   //
   // charout()
   //

   task charout;
      reg [0:35] temp;
      begin
         conREADMEM(addrCIN, temp);
         if ((outBuf != 0) && !temp[27])
           begin
              outBuf = ljstr(outBuf);
              conWRITEMEM(addrCIN, {23'b0, 1'b1, outBuf[0:7]});
              if ((outBuf[0:7] >= 8'h20) && (outBuf[0:7] < 8'h7f))
                $display("[%11.3f] KS10: CTY Input: \"%s\"", $time/1.0e3,
                         outBuf[0:7]);
              else
                $display("[%11.3f] KS10: CTY Input: \"<%02x>\"", $time/1.0e3,
                         outBuf[0:7]);
              outBuf = outBuf << 8;
           end
      end
   endtask

   //
   // Expect()
   //

   task expects;
      input [`STRDEF] inString;
      input [`STRDEF] outString;
      inout state;
      begin
         if (inString == inBuf)
           begin
              if (state == 0)
                begin
                   $display("[%11.3f] KS10: Expect(%s) triggered.", $time/1.0e3, inString);

                   //
                   // Need to delay output otherwise the response will come
                   // before the KS10 software is ready.
                   //

                   #100000;
                   puts(outString);
                   state = 1;
                   //$display("[%11.3f] KS10: outBuf is \"%s\".", outBuf);
                end
           end
         else
           state = 0;
      end
   endtask

   //
   // Initialization.
   //
   // All Console IO must be here since the KS10 interface is single thread.
   //

   wire haltLED = !LED_HALT_N;
   integer    fd_cty;
   reg [0:35] temp;
   reg [0:63] temp64;
   reg [0:63] state;

   initial
     begin

        //
        // Initialize semaphore
        //

        key = new(1);

        $display("[%11.3f] KS10: Starting %s Diagnostic Simulation.", $time/1.0e3, `DIAG);

        fd_cty = $fopen("cty_out.txt", "w");

        //
        //
        //

        inBuf  <= 0;
        outBuf <= 0;
        state  <= 0;

        //
        //  Write to Console Instruction Register
        //

        #1000
        conWRITE36(addrREGCIR, valREGCIR);

        //
        // Enable 8 channels of the DZ11
        //

        conWRITE32(addrREGDZCCR, 32'h0000ff00);

        //
        // Put the printer on-line.  Set the baud rate
        //

        conWRITE32(addrREGLPCCR, 32'h02590001);

        //
        // MT0 present, on-line, write-enabled
        //

        conWRITE32(addrREGMTCCR, 32'h00010100);

        //
        // Enable UNIT0, UNIT1, and UNIT2 disk drives
        //

        conWRITE32(addrREGRPCCR, 32'h00070700);

        //
        // Set jumper W3 and W6 of the DPCCR
        // Enable the H325 loopback connector
        //

        conWRITE32(addrREGDPCCR, 32'h00000d00);

        //
        // Initialize the Breakpoint Registers
        //

        conWRITE36(addrBRAR0, `valBRAR0);
        conWRITE36(addrBRMR0, `valBRMR0);
        conWRITE36(addrBRAR1, `valBRAR1);
        conWRITE36(addrBRMR1, `valBRMR1);
        conWRITE36(addrBRAR2, `valBRAR2);
        conWRITE36(addrBRMR2, `valBRMR2);
        conWRITE36(addrBRAR3, `valBRAR3);
        conWRITE36(addrBRMR3, `valBRMR3);

        //
        // Readback Some Console Register
        //

        conREAD36(addrREGCIR, temp);
        $display("[%11.3f] KS10: CIR  is \"%12o\"", $time/1.0e3, temp);

        conWRITEIO(22'o1776710, 36'o2); // Select Disk Unit 2

        conREADIO(22'o1776726, temp);
        $display("[%11.3f] KS10: RPDT[2] is \"%6o\"", $time/1.0e3, temp);

        conREADIO(22'o1776730, temp);
        $display("[%11.3f] KS10: RPSN[2] is \"%6o\"", $time/1.0e3, temp);

        conREADIO(22'o1776712, temp);
        $display("[%11.3f] KS10: RPDS[2] is \"%6o\"", $time/1.0e3, temp);

        conWRITEIO(22'o3772450, 36'o0); // Select Tape Unit 0

        conREADIO(22'o3772466, temp);
        $display("[%11.3f] KS10: MTDT[0] is \"%6o\"", $time/1.0e3, temp);

        conREADIO(22'o3772470, temp);
        $display("[%11.3f] KS10: MTSN[0] is \"%6o\"", $time/1.0e3, temp);

        conREADIO(22'o3772452, temp);
        $display("[%11.3f] KS10: MTDS[0] is \"%6o\"", $time/1.0e3, temp);

        conREAD64(addrVERSION, temp64);
        $display("[%11.3f] KS10: FVR  is \"%c%c%c%c %c%c%c%c\".", $time/1.0e3,
                 temp64[56:63], temp64[48:55], temp64[40:47], temp64[32:39],
                 temp64[24:31], temp64[16:23], temp64[ 8:15], temp64[ 0: 7]);

        //
        // Write to Control/Status Register
        // Release RESET and set RUN.
        //

        conWRITE32(addrREGSTATUS, statRUN);
        $display("[%11.3f] KS10: Starting KS10", $time/1.0e3);

        //
        // Handle Startup.
        //
        // Details
        //  The Microcode will always halt at startup.  Catch the halt at
        //  startup (only).  When this occurs momentarily push the RUN, EXEC,
        //  and CONT button to continue execution.
        //

        @(posedge haltLED)
          begin

             $display("[%11.3f] KS10: CPU Halted", $time/1.0e3);
             printHaltStatus;

             //
             // Initialize Console Communcations Area
             //

             conWRITEMEM(addrSWITCH,  36'o000000_000000);       // Initialize Switch Register
             conWRITEMEM(addrKASW,    36'o003740_000000);       // Keep Alive Status Word
             conWRITEMEM(addrCIN,     36'o000000_000000);       // Console Input
             conWRITEMEM(addrCOUT,    36'o000000_000000);       // Console Output
             conWRITEMEM(addrKIN,     36'o000000_000000);       // Klinik Input
             conWRITEMEM(addrKOUT,    36'o000000_000000);       // Klinik Output
`ifdef RPBOOT
             conWRITEMEM(addrRHBASE,  36'o000001_776700);       // RP Base Address
             conWRITEMEM(addrRHUNIT,  36'o000000_000002);       // Boot Disk Unit Number
             conWRITEMEM(addrMTPARAM, 36'o000000_000000);       // MT Parameters
`else
             conWRITEMEM(addrRHBASE,  36'o000003_772440);       // MT Base Address
             conWRITEMEM(addrRHUNIT,  36'o000000_000000);       // Boot Tape Unit Number
             conWRITEMEM(addrMTPARAM, 36'o000000_002000);       // MT Parameters (1600 BPI, COREDUMP, SLAVE 0
`endif

             //
             // Start executing code (Push the Continue Button).
             //

`ifdef ENABLE_TIMER
             conWRITE32(addrREGSTATUS, (statEXEC | statCONT | statRUN | statTRAPEN | statTIMEREN));
`else
             conWRITE32(addrREGSTATUS, (statEXEC | statCONT | statRUN | statTRAPEN));
`endif
          end

       @(negedge haltLED)

        //
        // Console Processing and Monitoring
        //

        forever

          @(posedge cpuCLK)

          begin

             //
             // Stop simulation if the KS10 halts
             //

             if (haltLED)
               begin
                  $display("[%11.3f] KS10: CPU Halted...", $time/1.0e3);
                  printHaltStatus;
                  $stop;
               end

             //
             // Handle CTY IO
             //

             key.get(1);
             getchar(fd_cty);

             `ifdef DIAG_DSKCG
                `include "test_dskcg.vh"
             `endif

             `ifdef DIAG_DSDZA
                `include "test_dsdza.vh"
             `endif

             `ifdef DIAG_DSRPA
                `include "test_dsrpa.vh"
             `endif

             `ifdef DIAG_DSRMB
                `include "test_dsrmb.vh"
             `endif

             `ifdef DIAG_DSLPA
                 `include "test_dslpa.vh"
             `endif

             `ifdef DIAG_DSDUA
                 `include "test_dsdua.vh"
             `endif

             `ifdef DIAG_DSKMA
                 `include "test_dskma.vh"
             `endif

             `ifdef DIAG_DSTUA
                 `include "test_dstua.vh"
             `endif

             `ifdef DIAG_DSTUB
                 `include "test_dstub.vh"
             `endif

             `ifdef DIAG_DSUBA
                 `include "test_dsuba.vh"
             `endif

             charout();
             key.put(1);

          end
     end

   //
   // Thread to interact with the tape simulator
   //

`define SIMMT
`ifdef SIMMT

`include "mtsim.sv"

   initial
     begin
        mtSIM_INIT();
        forever
          begin
             #100
             key.get(1);
             mtSIM_RUN(addrMTDIR);
             key.put(1);
          end
     end
`endif

   //
   // Periodically flush the output buffer
   //

   always
     begin
        #1000000 $fflush(fd_cty);
     end

   //
   // KS10
   //

   KS10 uKS10 (
      .rst              (rst),
      .clk              (clk),
      // Front Panel
      .SW_RESET_N       (SW_RESET_N),
      .SW_BOOT_N        (SW_BOOT_N),
      .SW_HALT_N        (SW_HALT_N),
      .LED_PWR_N        (LED_PWR_N),
      .LED_RESET_N      (LED_RESET_N),
      .LED_HALT_N       (LED_HALT_N),
      .LED_BOOT_N       (LED_BOOT_N),
      .SPARE0           (SPARE0),
      .SPARE1           (SPARE1),
      .SPARE2           (SPARE2),
      // External SD Card
      .ESD_SCLK         (ESD_SCLK),
      .ESD_DI           (ESD_DI),
      .ESD_DO           (ESD_DO),
      .ESD_DIO          (ESD_DIO),
      .ESD_RST_N        (ESD_RST_N),
      .ESD_RD_N         (ESD_RD_N),
      .ESD_WR_N         (ESD_WR_N),
      .ESD_CS_N         (ESD_CS_N),
      .ESD_ADDR         (ESD_ADDR),
      // DZ11 Interfaces
      .DZ_RXD           (DZ_RXD),
      .DZ_TXD           (DZ_TXD),
      .DZ_DTR           (DZ_DTR),
      // LP26 Interface
      .LP_TXD           (LP_TXD),
      .LP_RXD           (LP_RXD),
      // SD Interfaces
      .SD_MISO          (SD_MISO),
      .SD_MOSI          (SD_MOSI),
      .SD_SCLK          (SD_SCLK),
      .SD_SS_N          (SD_SS_N),
      .SD_CD            (8'hff),
      .SD_WP            (8'h00),
      // SSRAM Interfaces
      .SSRAM_CLK        (SSRAM_CLK),
      .SSRAM_WE_N       (SSRAM_WE_N),
      .SSRAM_A          (SSRAM_A),
      .SSRAM_D          (SSRAM_D),
      .SSRAM_ADV        (SSRAM_ADV),
      // LEDS
      .RP_LEDS          (RP_LEDS),
      // DE10-Nano Interfaces
      .KEY              (KEY),
      .SW               (SW),
      // AXI Interface
      .axiAWADDR        (axiAWADDR),
      .axiAWVALID       (axiAWVALID),
      .axiAWPROT        (axiAWPROT),
      .axiAWREADY       (axiAWREADY),
      .axiWDATA         (axiWDATA),
      .axiWSTRB         (axiWSTRB),
      .axiWVALID        (axiWVALID),
      .axiWREADY        (axiWREADY),
      .axiARADDR        (axiARADDR),
      .axiARVALID       (axiARVALID),
      .axiARPROT        (axiARPROT),
      .axiARREADY       (axiARREADY),
      .axiRDATA         (axiRDATA),
      .axiRRESP         (axiRRESP),
      .axiRVALID        (axiRVALID),
      .axiRREADY        (axiRREADY),
      .axiBRESP         (axiBRESP),
      .axiBVALID        (axiBVALID),
      .axiBREADY        (axiBREADY),
      // CPU clock out
      .cpuCLK           (cpuCLK),
      .cpuRST           (cpuRST),
      .mtDIRO           (mtDIRO)
   );

   //
   // SSRAM
   //

`ifdef SSRAMx36

   CY7C1460 SSRAM (
      .clk              (SSRAM_CLK),
      .cenb             (1'b0),
      .adv_lb           (SSRAM_ADV),
      .bws              (4'b00),
      .oeb              (1'b0),
      .we_b             (SSRAM_WE_N),
      .ce1b             (1'b0),
      .ce2              (1'b1),
      .ce3b             (1'b0),
      .mode             (1'b0),
      .a                (SSRAM_A[19:0]),
      .d                (SSRAM_D[35:0])
   );

`endif

`ifdef SSRAMx18

   CY7C1463 SSRAM (
      .clk              (SSRAM_CLK),
      .cenb             (1'b0),
      .adv_lb           (SSRAM_ADV),
      .bws              (2'b00),
      .oeb              (1'b0),
      .we_b             (SSRAM_WE_N),
      .ce1b             (1'b0),
      .ce2              (1'b1),
      .ce3b             (1'b0),
      .mode             (1'b0),
      .a                (SSRAM_A[20:0]),
      .d                (SSRAM_D)
   );

`endif

   //
   // SD Card Simulation
   //

   SDSIM SD (
      .clk          (cpuCLK),
      .rst          (cpuRST),
      .SD_MISO      (SD_MISO),
      .SD_MOSI      (SD_MOSI),
      .SD_SCLK      (SD_SCLK),
      .SD_SS_N      (SD_SS_N)
   );

`ifdef SIM_LPR

   //
   // LPR Debug Simulation
   //

   wire       intr;
   wire       clken;
   wire [7:0] data;
   integer    fd_lpt;

   //
   // Open printer output fd_lpt
   //

   initial
     begin
        fd_lpt = $fopen("lpr_out.txt", "w");
     end

   //
   // Printer baud rate generator
   //

   UART_BRG lprBRG (
      .clk          (cpuCLK),
      .rst          (cpuRST),
      .speed        (`UARTBR_115200),
      .clken        (clken)
   );

   //
   // Printer serial data receiver
   //

   UART_RX lprRX (
      .clk          (cpuCLK),
      .rst          (cpuRST),
      .clr          (1'b0),
      .clken        (clken),
      .length       (`UARTLEN_8),
      .parity       (`UARTPAR_NONE),
      .stop         (`UARTSTOP_1),
      .rxd          (LP_TXD),
      .rfull        (1'b0),
      .full         (),
      .intr         (intr),
      .data         (data),
      .pare         (),
      .frme         (),
      .ovre         ()
   );

   //
   // Print characters
   //

   always @(posedge cpuCLK)
     begin
        if (intr)
          begin
             $fwrite(fd_lpt, "%c", {1'b0, data[6:0]});
             $fflush(fd_lpt);
          end
     end

`endif

endmodule
