////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor Testbench
//
// Brief
//
// Details
//
// Todo
//
// File
//   testbench.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2014 Rob Doyle
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

`undef SIMCTY
`undef SIMSSMON
`default_nettype none

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

   wire [1:2]  TXD;             // DZ11 RS-232 Received Data
   wire [1:2]  RXD = 2'b11;     // DZ11 RS-232 Transmitted Data

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
   wire        ssramBWA_N;      // SSRAM BWA#
   wire        ssramBWB_N;      // SSRAM BWB#
   wire        ssramBWC_N;      // SSRAM BWC#
   wire        ssramBWD_N;      // SSRAM BWD#

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
   
`ifdef SIMSSMON
   localparam [0:35] valREGCIR    = 36'o254000_020000;
`else
// localparam [0:35] valREGCIR    = 36'o254000_030601;   // DSKAA-DSKAH
   localparam [0:35] valREGCIR    = 36'o254000_030010;   // DSKAI-DSKAM,DSKCF, DSKEA
// localparam [0:35] valREGCIR    = 36'o254000_030660;
// localparam [0:35] valREGCIR    = 36'o254000_030620;   // DSKCG
// localparam [0:35] valREGCIR    = 36'o254000_030622;
// localparam [0:35] valREGCIR    = 36'o254000_020000;   // DSQDC

`endif

   //
   // Register Addresses
   //

   localparam [7:0] addrREGADDR   = 8'h00;
   localparam [7:0] addrREGDATA   = 8'h08;
   localparam [7:0] addrREGSTATUS = 8'h10;
   localparam [7:0] addrREGCIR    = 8'h18;
   localparam [7:0] addrRH11DEB   = 8'h30;
   localparam [7:0] addrVersion   = 8'h38;

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
           $display("NXM/NXD at address %06o", address);

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
         $display("MAG is %012o",  temp);
         conREADMEMP(address +  1, temp);
         $display("PC  is %012o",  temp);
         conREADMEMP(address +  2, temp);
         $display("HR  is %012o",  temp);
         conREADMEMP(address +  3, temp);
         $display("AR  is %012o",  temp);
         conREADMEMP(address +  4, temp);
         $display("ARX is %012o",  temp);
         conREADMEMP(address +  5, temp);
         $display("BR  is %012o",  temp);
         conREADMEMP(address +  6, temp);
         $display("BRX is %012o",  temp);
         conREADMEMP(address +  7, temp);
         $display("ONE is %012o",  temp);
         conREADMEMP(address + 10, temp);
         $display("EBR is %012o",  temp);
         conREADMEMP(address + 11, temp);
         $display("UBR is %012o",  temp);
         conREADMEMP(address + 12, temp);
         $display("MSK is %012o",  temp);
         conREADMEMP(address + 13, temp);
         $display("FLG is %012o",  temp);
         conREADMEMP(address + 14, temp);
         $display("PI  is %012o",  temp);
         conREADMEMP(address + 15, temp);
         $display("X1  is %012o",  temp);
         conREADMEMP(address + 16, temp);
         $display("TO  is %012o",  temp);
         conREADMEMP(address + 17, temp);
         $display("T1  is %012o",  temp);
         conREADMEMP(address + 20, temp);
         $display("VMA is %012o",  temp);
         conREADMEMP(address + 21, temp);
         $display("FE  is %012o",  temp);
      end
   endtask; // printHaltStatusBlock
   
   //
   // Print Halt Status Word
   //
   
   task printHaltStatus;
      begin
         conREADMEMP(0, temp);
         case (temp[24:35])
           12'o0000 : $display("Halt Status: Microcode Startup.");
           12'o0001 : $display("Halt Status: Halt Instruction.");
           12'o0002 : $display("Halt Status: Console Halt.");
           12'o0100 : $display("Halt Status: IO Page Failure.");
           12'o0101 : $display("Halt Status: Illegal Interrupt Instruction.");
           12'o0102 : $display("Halt Status: Pointer to Unibus Vector is zero.");
           12'o1000 : $display("Halt Status: Illegal Microcode Dispatch.");
           12'o1005 : $display("Halt Status: Microcode Startup Check Failed.");
           default  : $display("Halt Status: Unknown Halt Cause.");
         endcase
         if (temp[24:35] != 0)
           begin
              printHaltStatusBlock(18'o376000);
           end
      end
   endtask
   
   //
   // Initialization
   //

   reg [0:35] temp;

   initial
     begin
        $display("KS10: Simulation Starting");

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

        //
        //  Write to Console Instruction Register
        //

        #600
        $display("KS10 time is t = %f us.", $time / 1.0e3);
	conWRITE(addrREGCIR, valREGCIR);

        //
        // Write to Control/Status Register
        // Release RESET and set RUN.
        // (Run is only required for the simulator).
        //

//      conWRITE(addrREGSTATUS, statCACHEEN | statTIMEREN | statTRAPEN | statRUN);
	conWRITE(addrREGSTATUS, statRUN);
        
        //
        // Readback Console Instruction Register
        //

        conREAD(addrREGCIR, temp);
        $display("CIR is : \"%12o\"", temp);

     end

   //
   // Display run/halt status
   //

   always @(negedge haltLED)
     if ($time != 0)
       $display("KS10 CPU Unhalted at t = %f us", $time / 1.0e3);

   //
   // Handle Startup.
   //
   // Details
   //  The Microcode will always halt at startup.  Catch the halt
   //  at startup (only).  When this occurs momentarily push the
   //  RUN, EXEC, and CONT button to continue execution.  Otherwise
   //  let the KS10 halt.
   //

   time haltTIME;
   
   always @(posedge haltLED)
     begin
	haltTIME <= $time;
        $display("KS10 CPU Halted at t = %f us.", $time / 1.0e3);
        printHaltStatus;
        if (haltTIME > 30000 && haltTIME < 40000)
	  begin

             //
             // Initialize Console Status
             //

             conWRITEMEM(18'o000031, 36'b0);

	     //
	     // Initialize Other stuff
	     //
	     
             conWRITEMEM(18'o000036, 36'b0);
             conWRITEMEM(18'o025741, 36'b0);
             conWRITEMEM(18'o026040, 36'b0);
             conWRITEMEM(18'o030024, 36'b0);
             conWRITEMEM(18'o030037, 36'b0);
             conWRITEMEM(18'o061121, 36'b0);
             conWRITEMEM(18'o061125, 36'b0);

	     //
	     // Start executing code
	     //
	     
             conWRITE(addrREGSTATUS, (statEXEC |
                                      statCONT |
                                      statRUN));
	  end
     end

   //
   // PDP10 Memory Initialization
   //
   // Note:
   //  We initialize the PDP10 memory with the diagnostic
   //  code.  This saves having to figure out how to load
   //  the code into memory by some other means.
   //
   //  Object code is extracted from the listing file by a
   //  'simple' AWK script and is included below.
   //

   reg [0:35] SSRAM [0:32767];
   initial
     begin
       `include "../testbench/ssram.dat"
     end

`ifdef SIMCTY

   //
   // File IO
   //

   integer cty_ofile;
   integer cty_ifile;

   initial
     begin
        cty_ofile = $fopen("cty_out.txt", "w");
        cty_ifile = $fopen("cty_in.txt",  "r");
        #1500000;
        $fclose(cty_ofile);
        $fclose(cty_ifile);
        $finish;
     end

   //
   //  CTY Output Processing
   //
   //  Note:
   //   A Console Interrupt (conINTR asserted) may indicate that a
   //   character is available to print or that a character can be
   //   accepted by the KS10, or both, or neither.
   //

   reg [0:35] dataCOUT;
   localparam [18:35] addrCOUT = 18'o000033;

   always @(posedge clk or posedge reset)
     begin
        if (reset)
          dataCOUT <= 36'b0;
        else if (conINTR)
          begin

             //$display("KS10 CPU has interrupted the console at t = %f us", $time / 1.0e3);

             //
             // Read CTYOUT Memory Location
             //

             conREADMEM(addrCOUT, dataCOUT);

             //
             // Print character if character is available.
             // Zero the flag when done printing.
             //

             if (dataCOUT[27])
               begin
                  if ((dataCOUT[28:35] >= 8'h20) && (dataCOUT[28:35] < 8'h7f))
                    $display("KS10 CTY Output: \"%s\"", dataCOUT[28:35]);
                  else
                    $display("KS10 CTY Output: \"%02x\"", dataCOUT[28:35]);
                  $fwrite(cty_ofile, "%s", dataCOUT[28:35]);
                  conWRITEMEM(addrCOUT, 36'b0);
               end
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
   // Bidirectional Data Bus
   //
   
   assign conDATA = (~conRD_N) ? 16'bz : conDATO;

   //
   // Synchronous RAM
   //
   // Details
   //  This is KS10 memory.
   //
   // Note:
   //  Only 32K is implemented.  This is sufficient to run the
   //  MAINDEC diagnostics.  Adding more memory makes the
   //  simulation run very slow.
   //
   // FIXME
   //  This is temporary
   //

   reg  [0:14] rd_addr;
   wire [0:14] wr_addr = ssramADDR[8:22];

   always @(negedge clk or posedge reset)
     begin
        if (reset)
          ;
        else if (~ssramWE_N)
          SSRAM[wr_addr] <= ssramDATA;
        rd_addr <= wr_addr;
     end

   assign ssramDATA = (ssramWE_N) ? SSRAM[rd_addr] : 36'bz;
   
   //
   // KS10
   //

   ESM_KS10 uKS10
     (.CLK50MHZ         (clk),
      .RESET_N          (~reset),
      .MR_N             (1'b0),
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
      .ssramBWA_N       (ssramBWA_N),
      .ssramBWB_N       (ssramBWB_N),
      .ssramBWC_N       (ssramBWC_N),
      .ssramBWD_N       (ssramBWD_N),
      .ssramOE_N        (ssramOE_N),
      .ssramWE_N        (ssramWE_N),
      .ssramCE          (ssramCE),
      .ssramADDR        (ssramADDR),
      .ssramDATA        (ssramDATA),
      .haltLED          (haltLED),
      .test             (test)
      );
   
endmodule
