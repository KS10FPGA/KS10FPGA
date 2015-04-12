///////////////////////////////////////////////////////////////////////////////
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

`define STRDEF 0:20*8-1

module testbench;

   //
   // Clock and things
   //

   reg  clk;                    // Clock
   reg  reset;                  // Reset

   //
   // Console Interfaces
   //

   wire [15:0] conDATA;         // Data bus
   reg  [ 5:1] conADDR;         // Address Bus
   reg  [15:0] conDATO;         // Data Bus Out
   reg         conBLE_N;        // Low Byte Lane
   reg         conBHE_N;        // High Byte Lane
   reg         conRD_N;         // Read Strobe
   reg         conWR_N;         // Write Strobe
   wire        conINTR_N;       // Console Interrupt
   wire        conINTR = ~conINTR_N;
   wire        haltLED;         // Halt LED
   wire [0 :7] test;            // Test port

   //
   // DZ11 Serial Interface
   //

   wire [1:2]  TXD = 2'b11;     // DZ11 RS-232 Received Data
   wire [1:2]  RXD;             // DZ11 RS-232 Transmitted Data

   //
   // RH11 Secure Digital Interface
   //

   wire        rh11CD;          // RH11 Card Detect
   wire        rh11MISO;        // RH11 Data In
   wire        rh11MOSI;        // RH11 Data Out
   wire        rh11SCLK;        // RH11 Clock
   wire        rh11CS;          // SD11 Chip Select

   //
   // SSRAM
   //

   wire        ssramCLK;        // SSRAM Clock
   wire [0:22] ssramADDR;       // SSRAM Address Bus
   wire [0:35] ssramDATA;       // SSRAM Data Bus
   wire        ssramADV;        // SSRAM Advance
   wire        ssramWE_N;       // SSRAM Write
   wire        ssramOE_N;       // SSRAM OE#
   wire        ssramCE;         // SSRAM CE
   wire        ssramCLKEN_N;    // SSRAM CLKEN#
   wire [1: 4] ssramBW_N;       // SSRAM BW#

   //
   // Control/Status Register Definitions
   //

   localparam [0:15] statRESET    = 16'h0001;
   localparam [0:15] statINTR     = 16'h0002;
   localparam [0:15] statCACHEEN  = 16'h0004;
   localparam [0:15] statTRAPEN   = 16'h0008;
   localparam [0:15] statTIMEREN  = 16'h0010;
   localparam [0:15] statEXEC     = 16'h0020;
   localparam [0:15] statCONT     = 16'h0040;
   localparam [0:15] statRUN      = 16'h0080;
   localparam [0:15] statHALT     = 16'h0100;
   localparam [0:15] statNXMNXD   = 16'h0200;
   localparam [0:15] statGO       = 16'h0001;

`ifdef SIM_SMMON
   localparam [0:35] valREGCIR    = 36'o254000_020000;  // SMMON
`else
   localparam [0:35] valREGCIR    = 36'o254000_030010;  // Basic diagnostics
`endif

   //
   // Register Addresses from Console Interface
   //

   localparam [7:0] addrREGADDR   = 8'h00;
   localparam [7:0] addrREGDATA   = 8'h08;
   localparam [7:0] addrREGSTATUS = 8'h10;
   localparam [7:0] addrREGCIR    = 8'h18;
   localparam [7:0] addrRH11DEB   = 8'h30;
   localparam [7:0] addrVersion   = 8'h38;

   //
   // KS10 Addresses
   //

   localparam [18:35] addrSTAT    = 18'o000031;
   localparam [18:35] addrCIN     = 18'o000032;
   localparam [18:35] addrCOUT    = 18'o000033;
   localparam [18:35] addrKIN     = 18'o000034;
   localparam [18:35] addrKOUT    = 18'o000035;
   localparam [18:35] addrRHBASE  = 18'o000036;
   localparam [18:35] addrBOOTDSK = 18'o000037;
   localparam [18:35] addrBOOTMAG = 18'o000040;

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
         conWRITE(addrREGADDR, {18'o010000, address});
         conWRITE(addrREGDATA, data);
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
         conWRITE(addrREGADDR, {18'o040000, address});
         conGO(address);
         conREAD(addrREGDATA, data);
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
         conWRITE(addrREGADDR, {18'o041000, address});
         conGO(address);
         conREAD(addrREGDATA, data);
      end
   endtask

   //
   // Task to write a 36-bit word to console register
   //
   // Note:
   //  A 36-bit write requires 3 16-bit word operations.
   //

   task conWRITE;
      input [7: 0] addr;
      input [0:35] data;
      begin
         conWRITEw(addr+0, data[20:35]);
         conWRITEw(addr+2, data[ 4:19]);
         conWRITEw(addr+4, {12'b0, data[0:3]});
         #100;
      end
   endtask

   //
   // Task to read a 36-bit word from console register
   //
   // Note:
   //  A 36-bit read requires 3 16-bit word operations.
   //

   task conREAD;
      input [7:0] addr;
      output reg [0:35] data;
      begin
         conREADw(addr+0, data[20:35]);
         conREADw(addr+2, data[ 4:19]);
         conREADw(addr+4, data[ 0: 3]);
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
         conWRITEw(addrREGSTATUS+2, statGO);
         #100
         conREADw(addrREGSTATUS+2, status);
         while (status & statGO)
           #100 conREADw(addrREGSTATUS+2, status);

         conREADw(addrREGSTATUS, status);
         if (status & statNXMNXD)
           $display("[%11.3f] KS10: NXM/NXD at address %06o", $time/1.0e3,
                    address);

         conWRITEw(addrREGSTATUS, status & ~statNXMNXD);

      end
   endtask

   //
   // Task to write 16-bit word to console register.  The EPI is 16-bit
   // word oriented therefore the LSB (A0) is not available.   The individual
   // bytes are addressed using the byte lanes, BHE and BLE.
   //
   // This timing assumes an 8 MHz CPU clock
   //

   task conWRITEw;
      input [ 7:0] addr;
      input [15:0] data;
      begin
         conBLE_N = 0;
         conBHE_N = 0;
         conADDR  = addr[5:1];
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

   task conREADw;
      input [7:0] addr;
      output reg [15:0] data;
      begin
         conBLE_N = 0;
         conBHE_N = 0;
         conADDR  = addr[5:1];
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
         //conREADMEMP(address + 17, temp);
         //$display("[%11.3f] KS10:   FE  is %012o", $time/1.0e3, temp);
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
   // This task polls the console output register.  When the VALID bit is
   // asserted, a character is present.  When the character has been read, the
   // valid bit is cleared.
   //

   task getchar;
      input  integer fd;
      input  [18:35] addr;
      reg    [ 0:35] temp;
      begin
         conREADMEM(addr, temp);
         if (temp[27])
           begin
              if ((temp[28:35] >= 8'h20) && (temp[28:35] < 8'h7f))
                begin
                   $display("[%11.3f] KS10: CTY Output: \"%s\"", $time/1.0e3, temp[28:35]);
                   $fwrite(fd, "%s", temp[28:35]);
                end
              else if ((temp[28:35] == 8'h0a) || (temp[28:35] == 8'h0d))
                begin
                   $display("[%11.3f] KS10: CTY Output: \"<%02x>\"", $time/1.0e3, temp[28:35]);
                   $fwrite(fd, "%s", temp[28:35]);
                end
              else
                begin
                   $display("[%11.3f] KS10: CTY Output: \"<%02x>\"", $time/1.0e3, temp[28:35]);
//                 $fwrite(fd, "<%02x>", temp[28:35]);
                end
              $fflush(fd);
              conWRITEMEM(addr, 36'b0);
           end
      end
   endtask

   //
   // This task writes a string to the CTY input at a specific time
   //

   task puts;
      input [18:35]   addr;
      input [ 0:35]   ch;
      inout [`STRDEF] msg;
      input time trigger;
      begin
         if (($time > trigger) && (msg[0:7] != 0) && !ch[27])
           begin
              conWRITEMEM(addrCIN, {23'b0, 1'b1, msg[0:7]});
              $display("[%11.3f] KS10: CTY Input: \"%s\"", $time/1.0e3, msg[0:7]);
              msg = msg << 8;
           end
      end
   endtask

   //
   // This task left justifies a string
   //

   task ljstr;
      inout [`STRDEF] str;
      begin
         while (str[0:7] == 0)
           str = str << 8;
      end
   endtask

   //
   // Initialization
   //

   reg [0:35] temp;
   reg [0:35] haltStatus;
   reg [0:35] haltAddr;

   initial
     begin
        $display("[%11.3f] KS10: Simulation Starting", $time/1.0e3);

        //
        // Initial state
        //

        clk      = 0;
        reset    = 1;
        conWR_N  = 1;
        conRD_N  = 1;
        conBLE_N = 1;
        conBHE_N = 1;
        conADDR <= 0;
        conDATO <= 0;

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
        conWRITE(addrREGCIR, valREGCIR);

        //
        // Write to Control/Status Register
        // Release RESET and set RUN.
        //

        conWRITE(addrREGSTATUS, statRUN);
        $display("[%11.3f] KS10: Starting KS10", $time/1.0e3);

        //
        // Readback Console Instruction Register
        //

        conREAD(addrREGCIR, temp);
        $display("[%11.3f] KS10: CIR is \"%12o\"", $time/1.0e3, temp);

     end

   //
   // Display run/halt status
   //

   always @(negedge haltLED)
     if ($time != 0)
       $display("[%11.3f] KS10: CPU Unhalted", $time/1.0e3);

   //
   // Notify about console interrupts
   //

   always @(posedge conINTR)
     begin
        $display("[%11.3f] KS10: Console Interrupted", $time/1.0e3);
     end

   //
   // Handle Startup.
   //
   // Details
   //  The Microcode will always halt at startup.  Catch the halt at startup
   //  (only).  When this occurs momentarily push the RUN, EXEC, and CONT button
   //  to continue execution.  Otherwise let the KS10 halt.
   //

   time haltTIME;

   always @(posedge haltLED)
     begin
        haltTIME <= $time;
        $display("[%11.3f] KS10: CPU Halted", $time/1.0e3);
        printHaltStatus;
        if (haltTIME < 40000 || haltTIME > 60000)
          $stop;
        else
          begin

             //
             // Initialize Console Interface
             //

             conWRITEMEM(addrSTAT,   36'o000000_000000);        // Maintenance Mode
             conWRITEMEM(addrRHBASE, 36'o000000_000000);        // RH Base Address

             //
             // Initialize Other stuff
             //

             conWRITEMEM(18'o025741, 36'o000000_000000);
             conWRITEMEM(18'o026040, 36'o000000_000000);
             conWRITEMEM(18'o030024, 36'o000000_000000);
             conWRITEMEM(18'o030037, 36'o000000_000000);
             conWRITEMEM(18'o061121, 36'o000000_000000);
             conWRITEMEM(18'o061125, 36'o000000_000000);

             //
             // Start executing code
             //

`ifdef ENABLE_TIMER
             conWRITE(addrREGSTATUS, (statEXEC | statCONT | statRUN | statTRAPEN | statTIMEREN));
`else
             conWRITE(addrREGSTATUS, (statEXEC | statCONT | statRUN | statTRAPEN));
`endif
          end
     end

`ifdef __ICARUS__
 `ifdef DUMPVARS

   initial
     begin

        $dumpfile("c:\test.vcd");

        //
        // Dump R0 through R7
        //

        $dumpvars(0, testbench,
                  testbench.uKS10.uKS10.uCPU.uRAMFILE.uRAM1Kx36.ram[0],
                  testbench.uKS10.uKS10.uCPU.uRAMFILE.uRAM1Kx36.ram[1],
                  testbench.uKS10.uKS10.uCPU.uRAMFILE.uRAM1Kx36.ram[2],
                  testbench.uKS10.uKS10.uCPU.uRAMFILE.uRAM1Kx36.ram[3],
                  testbench.uKS10.uKS10.uCPU.uRAMFILE.uRAM1Kx36.ram[4],
                  testbench.uKS10.uKS10.uCPU.uRAMFILE.uRAM1Kx36.ram[5],
                  testbench.uKS10.uKS10.uCPU.uRAMFILE.uRAM1Kx36.ram[6],
                  testbench.uKS10.uKS10.uCPU.uRAMFILE.uRAM1Kx36.ram[7]);
     end

   `endif
`endif

`ifdef SIM_CTY

   //
   // This task outputs a character to the console input register and then
   // polls the VALID bit to know when the KS10 has picked up the character.
   //

   task sendchar;
      input [18:35] addr;
      input [ 0: 7] data;
      reg   [ 0:35] temp;
      begin
         conWRITEMEM(addr, {23'b0, 1'b1, data});
         $display("[%11.3f] KS10: CTY Input: \"%s\"", $time/1.0e3, data);
         conREADMEM(addr, temp);
         while (temp[27])
           #100 conREADMEM(addr, temp);
      end
   endtask

   reg [0:35] ch;
   integer cty_ofile;
   integer kty_ofile;

   reg [`STRDEF] msgSTD = "STD\n";
   reg [`STRDEF] msgSWT = 16'h59_0d;                    // Y<CR>      : response to "TTY SWITCH CONTROL ? - 0,S OR Y <CR> - "
   reg [`STRDEF] msgSLH = 56'h30_30_30_31_30_30_0d;     // 000100<CR> : response to LH SWITCHES <# OR ?> -
   reg [`STRDEF] msgSRH = 56'h30_30_30_30_30_30_0d;     // 000000<CR> : response to RH SWITCHES <# OR ?> -

   initial
     begin
        ch = 0;
        cty_ofile = $fopen("cty_out.txt", "w");
        kty_ofile = $fopen("kty_out.txt", "w");

        ljstr(msgSTD);
        ljstr(msgSWT);
        ljstr(msgSLH);
        ljstr(msgSRH);

        #200000;
        forever
          begin
             getchar(cty_ofile, addrCOUT);
             getchar(kty_ofile, addrKOUT);

             conREADMEM(addrCIN, ch);
             puts(addrCIN, ch, msgSTD,  6000000);
             puts(addrCIN, ch, msgSWT, 23000000);
             puts(addrCIN, ch, msgSLH, 26000000);
             puts(addrCIN, ch, msgSRH, 29000000);

          end
     end

`endif

   //
   // Clock generator
   //
   // Details
   //  Clock is inverted every ten nS
   //

   always
     begin
        #10 clk = ~clk;
     end

   //
   // Periodically flush the output
   //

   always
     begin
        #1000000 $fflush;
     end

   //
   // Bidirectional Data Bus
   //

   assign conDATA = (~conRD_N) ? 16'bz : conDATO;

   //
   // KS10
   //

   ESM_KS10 uKS10 (
      .CLK50MHZ         (clk),
      .RESET_N          (~reset),
      .MR_N             (),
      // DZ11 Interfaces
      .TXD              (TXD),
      .RXD              (RXD),
      // RH11 Interfaces
      .rh11CD           (rh11CD),
      .rh11MISO         (rh11MISO),
      .rh11MOSI         (rh11MOSI),
      .rh11SCLK         (rh11SCLK),
      .rh11CS           (rh11CS),
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
      .a                (ssramADDR[3:22]),
      .d                (ssramDATA[0:35])
   );

`ifdef SIM_SDHC

   //
   // SD Card Simulation
   //

   SDSIM SD (
      .clk              (clk),
      .rst              (reset),
      .sdMISO           (rh11MISO),
      .sdMOSI           (rh11MOSI),
      .sdSCLK           (rh11SCLK),
      .sdCS             (rh11CS)
   );

`else

   //
   // Terminate input
   //

   assign rh11MISO = 0;

`endif

endmodule
