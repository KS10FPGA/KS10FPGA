////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor Testbench
//
// Brief
//   KS-10 FPGA Test Bench
//
// File
//   testbench.v
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

`include "uart.vh"

`define STRLEN 80
`define STRDEF 0:`STRLEN*8-1

module testbench;

   //
   // Clock and things
   //

   reg  clk;                    // Clock
   reg  reset;                  // Reset

   //
   // Console Interfaces
   //

   wire [15: 0] conDATA;        // Data bus
   reg  [ 7: 1] conADDR;        // Address Bus
   reg  [15: 0] conDATO;        // Data Bus Out
   reg          conBLE_N;       // Low Byte Lane
   reg          conBHE_N;       // High Byte Lane
   reg          conRD_N;        // Read Strobe
   reg          conWR_N;        // Write Strobe
   wire         conINTR_N;      // Console Interrupt
   wire         conINTR = ~conINTR_N;
   wire         haltLED;        // Halt LED
   wire [0 :19] test;           // Test port

   //
   // DZ11 Serial Interface
   //

   wire [ 1: 2] DZ_TXD = 2'b11; // DZ11 RS-232 Received Data
   wire [ 1: 2] DZ_RXD;         // DZ11 RS-232 Transmitted Data

   //
   // LP26 Serial Interface
   //

   wire LP_TXD = 1'b1;          // LP26 RS-232 Received Data
   wire LP_RXD;                 // LP26 RS-232 Transmitted Data

   //
   // RH11 Secure Digital Interface
   //

   wire         SD_CD_N = 0;    // SD Card Detect
   wire         SD_MISO;        // SD Data In
   wire         SD_MOSI;        // SD Data Out
   wire         SD_SCLK;        // SD Clock
   wire         SD_SS_N;        // SD Chip Select

   //
   // RPXX Interface
   //

   wire [ 7: 0] rpLEDS_N;       // RPXX Status LEDS

   //
   // SSRAM
   //

   wire         ssramCLK;       // SSRAM Clock
   wire [ 0:19] ssramADDR;      // SSRAM Address Bus
   wire [ 0:35] ssramDATA;      // SSRAM Data Bus
   wire         ssramADV;       // SSRAM Advance
   wire         ssramWE_N;      // SSRAM Write
   wire         ssramOE_N;      // SSRAM OE#
   wire         ssramCE;        // SSRAM CE
   wire         ssramCLKEN_N;   // SSRAM CLKEN#
   wire [ 1: 4] ssramBW_N;      // SSRAM BW#

   //
   // Control/Status Register Definitions
   //

   localparam [ 0:15] statRESET     = 16'h0001;
   localparam [ 0:15] statINTR      = 16'h0002;
   localparam [ 0:15] statCACHEEN   = 16'h0004;
   localparam [ 0:15] statTRAPEN    = 16'h0008;
   localparam [ 0:15] statTIMEREN   = 16'h0010;
   localparam [ 0:15] statEXEC      = 16'h0020;
   localparam [ 0:15] statCONT      = 16'h0040;
   localparam [ 0:15] statRUN       = 16'h0080;
   localparam [ 0:15] statHALT      = 16'h0100;
   localparam [ 0:15] statNXMNXD    = 16'h0200;
   localparam [ 0:15] statGO        = 16'h0001;

`ifdef SIM_SMMON
   localparam [ 0:35] valREGCIR     = 36'o254000_020000;  // SMMON
`else
   localparam [ 0:35] valREGCIR     = 36'o254000_030001;  // Basic diagnostics
`endif

   //
   // Register Addresses from Console Interface
   //

   localparam [ 7: 0] addrREGADDR   = 8'h00,
                      addrREGDATA   = 8'h08,
                      addrREGCIR    = 8'h10,
                      addrREGSTATUS = 8'h18,
                      addrREGDZCCR  = 8'h1c,
                      addrREGLPCCR  = 8'h20,
                      addrREGRHCCR  = 8'h24,
                      addrREGDPCCR  = 8'h28,
                      addrDCSR      = 8'h3c,
                      addrDBAR      = 8'h40,
                      addrDBMR      = 8'h48,
                      addrDITR      = 8'h50,
                      addrRH11DEB   = 8'h70,
                      addrVersion   = 8'h78;

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
                      addrBOOTDSK   = 18'o000037,
                      addrBOOTMAG   = 18'o000040;

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
   // Task to write to KS10 memory
   //
   // Details
   //  Write address.  Write data.
   //

   task conWRITEMEM;
      input [18:35] address;
      input [ 0:35] data;
      begin
         conWRITE36(addrREGADDR, {18'o010000, address});
         conWRITE36(addrREGDATA, data);
         conGO(address);
      end
   endtask

   //
   // Task to read from KS10 memory
   //

   task conREADMEM;
      input  [18:35] address;
      output [ 0:35] data;
      begin
         conWRITE36(addrREGADDR, {18'o040000, address});
         conGO(address);
         conREAD36(addrREGDATA, data);
      end
   endtask

   //
   // Task to read from KS10 memory (physical)
   //

   task conREADMEMP;
      input  [18:35] address;
      output [ 0:35] data;
      reg    [ 0:15] status;
      begin
         conWRITE36(addrREGADDR, {18'o041000, address});
         conGO(address);
         conREAD36(addrREGDATA, data);
      end
   endtask

   //
   // Task to write a 32-bit word to console register
   //
   // Note:
   //  A 32-bit write requires 2 16-bit word operations.
   //

   task conWRITE32;
      input [7: 0] addr;
      input [0:31] data;
      begin
         conWRITE16(addr+0, data[16:31]);
         conWRITE16(addr+2, data[ 0:15]);
         #100;
      end
   endtask

   //
   // Task to read a 32-bit word from console register
   //
   // Note:
   //  A 32-bit read requires 2 16-bit word operations.
   //

   task conREAD32;
      input [7:0] addr;
      output reg [0:31] data;
      begin
         conREAD16(addr+0, data[16:31]);
         conREAD16(addr+2, data[ 0:15]);
         #100;
      end
   endtask

   //
   // Task to write a 36-bit word to console register
   //
   // Note:
   //  A 36-bit write requires 3 16-bit word operations.
   //

   task conWRITE36;
      input [7: 0] addr;
      input [0:35] data;
      begin
         conWRITE16(addr+0, data[20:35]);
         conWRITE16(addr+2, data[ 4:19]);
         conWRITE16(addr+4, {12'b0, data[0:3]});
         #100;
      end
   endtask

   //
   // Task to read a 36-bit word from console register
   //
   // Note:
   //  A 36-bit read requires 3 16-bit word operations.
   //

   task conREAD36;
      input [7:0] addr;
      output reg [0:35] data;
      begin
         conREAD16(addr+0, data[20:35]);
         conREAD16(addr+2, data[ 4:19]);
         conREAD16(addr+4, data[ 0: 3]);
         #100;
      end
   endtask

   //
   // Task to write a 64-bit word to console register
   //
   // Note:
   //  A 64-bit write requires 4 16-bit word operations.
   //

   task conWRITE64;
      input [7: 0] addr;
      input [0:63] data;
      begin
         conWRITE16(addr+0, data[48:63]);
         conWRITE16(addr+2, data[32:47]);
         conWRITE16(addr+4, data[16:31]);
         conWRITE16(addr+6, data[ 0:15]);
         #100;
      end
   endtask

   //
   // Task to read a 64-bit word from console register
   //
   // Note:
   //  A 64-bit read requires 4 16-bit word operations.
   //

   task conREAD64;
      input [7:0] addr;
      output reg [0:63] data;
      begin
         conREAD16(addr+0, data[48:63]);
         conREAD16(addr+2, data[32:47]);
         conREAD16(addr+4, data[16:31]);
         conREAD16(addr+6, data[ 0:15]);
         #100;
      end
   endtask

   //
   // Set the GO bit then poll the GO bit.
   // Whine about NXM/NXD response
   //

   task conGO;
      input [18:35] address;
      reg   [ 0:15] status;
      begin
         conWRITE16(addrREGSTATUS+2, statGO);
         #100
         conREAD16(addrREGSTATUS+2, status);
         while (status & statGO)
           #100 conREAD16(addrREGSTATUS+2, status);

         conREAD16(addrREGSTATUS, status);
         if (status & statNXMNXD)
           $display("[%11.3f] KS10: NXM/NXD at address %06o", $time/1.0e3,
                    address);

         conWRITE16(addrREGSTATUS, status & ~statNXMNXD);

      end
   endtask

   //
   // Task to write 16-bit word to console register.  The EPI is 16-bit
   // word oriented therefore the LSB (A0) is not available.   The individual
   // bytes are addressed using the byte lanes, BHE and BLE.
   //
   // This timing assumes an 8 MHz CPU clock
   //

   task conWRITE16;
      input [ 7:0] addr;
      input [15:0] data;
      begin
         conBLE_N = 0;
         conBHE_N = 0;
         conADDR  = addr[7:1];
         conDATO  = data;
         #250
         conWR_N  = 0;
         #250
         conWR_N  = 1;
         conBLE_N = 1;
         conBHE_N = 1;
         #250;
      end
   endtask

   //
   // Task to read 16-bit word from console register.  The EPI is 16-bit
   // word oriented therefore the LSB (A0) is not available.  The individual
   // bytes are addressed using the byte lanes, BHE and BLE.
   //
   // This timing assumes an 8 MHz CPU clock
   //

   task conREAD16;
      input [7:0] addr;
      output reg [15:0] data;
      begin
         conBLE_N = 0;
         conBHE_N = 0;
         conADDR  = addr[7:1];
         #250
         conRD_N  = 0;
         #250
         conRD_N  = 1;
         data     = conDATA;
         #250
         conBLE_N = 1;
         conBHE_N = 1;
         #250;
      end
   endtask

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
//                 $fwrite(fd, "<%02x>", temp[28:35]);
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

   task expect;
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
                   //$display("[%11.3f] KS10: outBuf is \"%s\".", outBuf);x
                end
           end
         else
           state = 0;
      end
   endtask

   //
   // 50 MHz clock generator
   //
   // Details
   //  Clock is inverted every ten nS
   //

   always
     begin
        #10 clk = ~clk;
     end

   //
   // Initialization.
   //
   // All Console IO must be here since the KS10 interface is single thread.
   //

   integer    fd_cty;
   reg [0:35] temp;
   reg [0:31] state;

   initial
     begin

        $display("[%11.3f] KS10: Simulation Starting", $time/1.0e3);

`ifdef SIM_CTY

        fd_cty = $fopen("cty_out.txt", "w");

`endif

        //
        // Initial state
        //

        clk       = 0;
        reset     = 1;
        conWR_N   = 1;
        conRD_N   = 1;
        conBLE_N  = 1;
        conBHE_N  = 1;
        conADDR  <= 0;
        conDATO  <= 0;
        inBuf    <= 0;
        outBuf   <= 0;
        state    <= 0;

        //
        // Release reset at 95 nS
        //

        #95
        reset = 0;
        $display("[%11.3f] KS10: Negating Reset", $time/1.0e3);

        //
        //  Write to Console Instruction Register
        //

        #600
        conWRITE36(addrREGCIR, valREGCIR);

        //
        // Enable 8 channels of the DZ11
        //

        conWRITE32(addrREGDZCCR, 32'h0000ff00);

        //
        // Put the printer on-line.  Set the baud rate
        //

        conWRITE32(addrREGLPCCR, 32'h02590002);

        //
        // Enable UNIT0, UNIT1, and UNIT2 disk drives
        //

        conWRITE32(addrREGRHCCR, 32'h07070700);

        //
        // Set jumper W3 and W6 of the DPCCR
        // Enable the H325 loopback connector
        //

        conWRITE32(addrREGDPCCR, 32'h00000d00);

        //
        // Initialize the Debug Registers
        //

`ifdef BRKPT
        conWRITE36(addrDCSR, 36'o000000_040000);
        conWRITE36(addrDBAR, 36'o140000_034776);
        conWRITE36(addrDBMR, 36'o140003_777777);
`else
        conWRITE36(addrDCSR, 36'o000000_000000);
        conWRITE36(addrDBAR, 36'o000000_000000);
        conWRITE36(addrDBMR, 36'o000000_000000);
`endif

        //
        // Write to Control/Status Register
        // Release RESET and set RUN.
        //

        conWRITE32(addrREGSTATUS, statRUN);
        $display("[%11.3f] KS10: Starting KS10", $time/1.0e3);

        //
        // Readback Console Instruction Register
        //

        conREAD36(addrREGCIR, temp);
        $display("[%11.3f] KS10: CIR is \"%12o\"", $time/1.0e3, temp);

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
             // Initialize Console Interface
             //

             conWRITEMEM(addrSWITCH,  36'o000000_000000);       // Initialize Switch Register
             conWRITEMEM(addrKASW,    36'o003740_000000);       // Keep Alive Status Word
             conWRITEMEM(addrCIN,     36'o000000_000000);       // Console Input
             conWRITEMEM(addrCOUT,    36'o000000_000000);       // Console Output
             conWRITEMEM(addrKIN,     36'o000000_000000);       // Klinik Input
             conWRITEMEM(addrKOUT,    36'o000000_000000);       // Klinik Output
//           conWRITEMEM(addrRHBASE,  36'o000001_776700);       // RH Base Address
             conWRITEMEM(addrRHBASE,  36'o000000_000000);       // RH Base Address
             conWRITEMEM(addrBOOTDSK, 36'o000000_000000);       // Boot Disk Unit Number
             conWRITEMEM(addrBOOTMAG, 36'o000000_000000);       // Boot Magtape Parameters

             //
             // Start executing code (Push the Continue Button).
             //

`ifdef ENABLE_TIMER
             conWRITE32(addrREGSTATUS, (statEXEC | statCONT | statRUN | statTRAPEN | statTIMEREN));
`else
             conWRITE32(addrREGSTATUS, (statEXEC | statCONT | statRUN | statTRAPEN));
`endif
          end

        //
        // Console Processing and Monitoring
        //

        forever

          @(posedge clk)

          begin

             //
             // Stop simulation if the KS10 halts
             //

             if (haltLED)
               begin
                  $display("[%11.3f] KS10: CPU Halted", $time/1.0e3);
                  printHaltStatus;
                  $stop;
               end

             //
             // Handle CTY IO
             //

             if (1 || conINTR)
               begin
//                $display("[%11.3f] KS10: Console Interrupted", $time/1.0e3);

`ifdef SIM_CTY

                  getchar(fd_cty);

                  //
                  // SMMON (DECSYSTEM 2020 DIAGNOSTIC MONITOR) Responses
                  //

                  expect("UBA # - ",                                                    "1\015",       state[0]);
                  expect("DISK:<DIRECTORY> OR DISK:[P,PN] - ",                          "PS:\015",     state[1]);
                  expect("SMMON CMD - ",                                                "DSRPA\015",   state[2]);
`ifdef SIM_SMMON
                  expect("TTY SWITCH CONTROL ? - 0,S OR Y <CR> - ",                     "0\015",       state[3]);
                  expect("LH SWITCHES <# OR ?> - ",                                     "0\015",       state[4]);
                  expect("RH SWITCHES <# OR ?> - ",                                     "0\015",       state[5]);
`endif

                  //
                  // DSRPA (RP06-RH11 BASIC DRIVE DIAGNOSTIC) Responses
                  //

`ifndef SIM_SMMON
                  expect("TTY SWITCH CONTROL ? - 0,S OR Y <CR> - ",                     "Y\015",       state[3]);
                  expect("LH SWITCHES <# OR ?> - ",                                     "400000\015",  state[4]);
                  expect("RH SWITCHES <# OR ?> - ",                                     "400000\015",  state[5]);
`endif
                  expect("LIST PGM SWITCH OPTIONS ?  Y OR N <CR> - ",                   "N\015",       state[6]);
                  expect("SELECT DRIVES (0-7 OR \"A\") - ",                             "0\015",       state[7]);
                  expect("HEADS LOADED CORRECTLY ?  Y OR N <CR> - ",                    "Y\015",       state[8]);
                  expect("PUT DRIVE ON LINE. HIT <CR> WHEN READY",                      "\015",        state[9]);

                  //
                  // DSLPA (DECSYSTEM 2020 LINE PRINTER DIAGNOSTIC) Responses
                  //

                  expect("IS THIS AN LP05 OR LP14 LINE PRINTER ? Y OR N <CR> - ",       "Y\015",       state[10]);
                  expect("IS THIS AN LP05, LP14 OR LP26 LINE PRINTER ? Y OR N <CR> - ", "Y\015",       state[11]);
                  expect("IS THIS AN LP07 LINE PRINTER ? Y OR N <CR> - ",               "Y\015",       state[12]);
                  expect("IS THIS AN LP20 CONTROLLER WITH NO PRINTER ? Y OR N <CR> - ", "Y\015",       state[13]);
                  expect("TYPE ALTMODE WHEN READY - ",                                  "\033",        state[14]);
                  expect("DOES THIS LPT HAVE A DAVFU ? Y OR N <CR> - ",                 "Y\015",       state[15]);
                  expect("CHANNEL-PASS NUMBER: (1-16, CR=ALL CHANNELS) ",               "\015",        state[16]);
                  expect("CHANNEL NUMBER: (1-12, CR=ALL CHANNELS) ",                    "\015",        state[17]);
                  expect("CHANNEL NUMBER: (2-12, CR=ALL CHANNELS) ",                    "\015",        state[18]);
//                expect("*",                                                           "A\015",       state[19]);

                  //
                  // DSDUA (DSDUA DECSYSTEM 2020 DUP-11 DIAGNOSTICS)
                  //

                  expect("IS THE DUP-11 UNIT #1 OR #2 ?",                               " 1\015",      state[20]);
                  expect("DO YOU WANT A MAP OF THE DUP-11 STATUS ? Y OR N <CR> - ",     "N\015",       state[21]);
                  expect("IS THE H325 TURN AROUND CONNECTER IN PLACE ? Y OR N <CR> - ", "Y\015",       state[22]);
                  expect("*",                                                           "65-75\015",      state[23]);
                  charout();

`endif

               end
          end
     end

   //
   // Bidirectional Data Bus
   //

   assign conDATA = (~conRD_N) ? 16'bz : conDATO;

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

   ESM_KS10 uKS10 (
      .CLK50MHZ         (clk),
      .RESET_N          (~reset),
      .MR_N             (1'b0),
      .MR               (),
      // DZ11 Interfaces
      .DZ_RXD           (DZ_RXD),
      .DZ_TXD           (DZ_TXD),
      // LP26 Interface
      .LP_TXD           (LP_TXD),
      .LP_RXD           (LP_RXD),
      // SD Interfaces
      .SD_CD_N          (SD_CD_N),
      .SD_MISO          (SD_MISO),
      .SD_MOSI          (SD_MOSI),
      .SD_SCLK          (SD_SCLK),
      .SD_SS_N          (SD_SS_N),
      // RPXX Interfaces
      .rpLEDS_N         (rpLEDS_N),
      // Console Interfaces
      .conADDR          (conADDR),
      .conDATA          (conDATA),
      .conBLE_N         (conBLE_N),
      .conBHE_N         (conBHE_N),
      .conRD_N          (conRD_N),
      .conWR_N          (conWR_N),
      .conINTR_N        (conINTR_N),
      // SSRAM Interfaces
      .ssramCLK         (ssramCLK),
      .ssramCLKEN_N     (ssramCLKEN_N),
      .ssramADV         (ssramADV),
      .ssramBW_N        (ssramBW_N),
      .ssramOE_N        (ssramOE_N),
      .ssramWE_N        (ssramWE_N),
      .ssramCE          (ssramCE),
      .ssramADDR        (ssramADDR),
      .ssramDATA        (ssramDATA),
      // Misc
      .haltLED          (haltLED),
      .test             (test)
   );

   //
   // SSRAM
   //

   CY7C1460 SSRAM (
      .clk              (ssramCLK),
      .cenb             (ssramCLKEN_N),
      .adv_lb           (ssramADV),
      .bws              (ssramBW_N),
      .oeb              (ssramOE_N),
      .we_b             (ssramWE_N),
      .ce1b             (1'b0),
      .ce2              (ssramCE),
      .ce3b             (1'b0),
      .mode             (1'b0),
      .a                (ssramADDR[0:19]),      // Endian Swap
      .d                (ssramDATA[0:35])       // Endian Swap
   );

`ifdef SIM_SDHC

   //
   // SD Card Simulation
   //

   SDSIM SD (
      .clk              (clk),
      .rst              (reset),
      .SD_MISO          (SD_MISO),
      .SD_MOSI          (SD_MOSI),
      .SD_SCLK          (SD_SCLK),
      .SD_SS_N          (SD_SS_N)
   );

`else

   //
   // Terminate input
   //

   assign sdMISO = 0;

`endif

`ifdef SIM_LPR

   //
   // LPR Debug Simulation
   //

   wire intr;
   wire clken;
   wire [7:0] data;
   integer file;

   UART_BRG #(
      .CLKFRQ  (50000000)
   )
   lprBRG (
      .clk     (clk),
      .rst     (reset),
      .speed   (`UARTBR_115200),
      .clken   (clken)
   );

   UART_RX lprRX (
      .clk    (clk),
      .rst    (reset),
      .clr    (1'b0),
      .clken  (clken),
      .length (`UARTLEN_8),
      .parity (`UARTPAR_NONE),
      .stop   (`UARTSTOP_1),
      .rxd    (LP_RXD),
      .rfull  (1'b0),
      .full   (),
      .intr   (intr),
      .data   (data),
      .pare   (),
      .frme   (),
      .ovre   ()
   );

   //
   // Open printer output file
   //

   initial
     begin
        file = $fopen("lpr_out.txt", "w");
     end

   //
   // Print characters
   //

   always @(posedge clk)
     begin
        if (intr)
          begin
             $fwrite(file, "%c", {1'b0, data[6:0]});
             $fflush(file);
          end
     end

`endif

endmodule
