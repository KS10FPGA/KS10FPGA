////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor Testbench
//!
//! \brief
//!
//! \details
//!
//! \todo
//!
//! \file
//!      testbench.v
//!
//! \author
//!      Rob Doyle - doyle (at) cox (dot) net
//!
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
//
// Comments are formatted for doxygen
//

`undef SIMCTY
`undef SIMSSMON
`define EOF 32'hFFFF_FFFF

module testbench;
   
   //
   // Clock and things
   //
   
   reg clk;                     // Clock
   reg reset;                   // Reset
   wire runLED;                 // Run LED

   //
   // Console Interfaces
   //

   wire [7:0] cslAD;            // Multiplexed Address/Data Bus
   reg  [7:0] cslADOUT;         // Address/Data Bus Out
   wire [7:0] cslADIN;          // Data Bus In
   reg        cslALE;           // Address Latch Enable
   reg        cslRD_N;          // Read Strobe
   reg        cslWR_N;          // Write Strobe
   wire       cslINTR_N;        // Console Interrupt
   wire       cslINTR = ~cslINTR_N;
   
   //
   // DZ11 Serial Interface
   //

   wire [0:7] dz11RXD;          // DZ11 Received RS-232 Data
   wire [0:7] dz11TXD;        	// DZ11 Transmitted RS-232 Data

   //
   // RH11 Secure Digital Interface
   //
   
   wire        rh11CD;        	// RH11 Card Detect
   wire        rh11WP;        	// RH11 Write Protect
   wire        rh11MISO;      	// RH11 Data In
   wire        rh11MOSI;      	// RH11 Data Out
   wire        rh11SCLK;      	// RH11 Clock
   wire        rh11CS;        	// SD11 Chip Select
   
   //
   // SSRAM
   //

   wire        ssramCLK;        // SSRAM Clock
   wire [0:22] ssramADDR;       // SSRAM Address Bus
   wire [0:35] ssramDATA;       // SSRAM Data Bus
   wire        ssramADV;        // SSRAM Advance
   wire        ssramWR;         // SSRAM Write

   //
   // Data to KS10
   //

   parameter [0:35] valREGSTATUS = 36'o000005_003000;
`ifdef SIMSSMON
   parameter [0:35] valREGCIR    = 36'o254000_020000;
`else
// parameter [0:35] valREGCIR    = 36'o254000_030601;	// DSKAA-DSKAH
   parameter [0:35] valREGCIR    = 36'o254000_030010;	// DSKAI-DSKAM,DSKCF, DSKEA
// parameter [0:35] valREGCIR    = 36'o254000_030660;
// parameter [0:35] valREGCIR    = 36'o254000_030620;	// DSKCG
// parameter [0:35] valREGCIR    = 36'o254000_030622;
// parameter [0:35] valREGCIR    = 36'o254000_020000;	// DSQDC
   
`endif   
   
   //
   // Register Addresses
   //
   
   parameter [7:0] addrREGADDR   = 8'h00;
   parameter [7:0] addrREGDATA   = 8'h10;
   parameter [7:0] addrREGSTATUS = 8'h20;
   parameter [7:0] addrREGCIR    = 8'h30;

   //
   // Task to write to KS10 memory
   //
   // Details
   //  Write address.  Write data.
   //
   
   task cslWRKS10MEM;
      input [18:35] address;
      input [ 0:35] data;
      begin
         cslWRITE (addrREGADDR, {18'o010000, address});
         cslWRITE (addrREGDATA, data);
         cslWRITEb(addrREGSTATUS+4, 8'h01);
      end
   endtask
   
   //
   // Task to read from KS10 memory
   //
   
   task cslRDKS10MEM;
      input  [18:35] address;
      output [ 0:35] data;
      begin
         cslWRITE (addrREGADDR, {18'o040000, address});
         cslWRITEb(addrREGSTATUS+4, 8'h01);
         #40;
         cslREAD  (addrREGDATA, data);
      end
   endtask
   
   //
   // Task to write a word to console register
   //
   // Note:
   //  A 36-bit write requires 5 byte operations.
   //

   task cslWRITE;
      input [7: 0] addr;
      input [0:35] data;
      begin
         cslWRITEb(addr+3, {4'b0, data[0:3]});
         cslWRITEb(addr+4, data[ 4:11]);
         cslWRITEb(addr+5, data[12:19]);
         cslWRITEb(addr+6, data[20:27]);
         cslWRITEb(addr+7, data[28:35]);
         #100;
      end
   endtask
   
   //
   // Task to read word from console register
   //
   // Note:
   //  A 36-bit read requires 5 byte operations.
   //
   
   task cslREAD;
      input [7:0] addr;
      output reg [0:35] data;
      begin
         cslREADb(addr+3, data[ 0: 3]);
         cslREADb(addr+4, data[ 4:11]);
         cslREADb(addr+5, data[12:19]);
         cslREADb(addr+6, data[20:27]);
         cslREADb(addr+7, data[28:35]);
         #100;
      end
   endtask
    
   //
   // Task to write byte to console register
   //
   
   task cslWRITEb;
      input [7:0] addr;
      input [7:0] data;
      begin
         #50 cslADOUT = addr;
         #5  cslALE   = 1;
         #5  cslADOUT = data;
         #5  cslALE   = 0;
         #5  cslWR_N  = 0;
         #50 cslWR_N  = 1;
      end
   endtask

   //
   // Task to read byte from console register
   //
   
   task cslREADb;
      input [7:0] addr;
      output reg [7:0] data;
      begin
        #5  cslADOUT = addr;
        #5  cslALE   = 1;
        #5  cslALE   = 0;
        #5  cslRD_N  = 0;
        #25 data     = cslAD;
        #25 cslRD_N  = 1;
      end
   endtask

   //
   // Initialization
   //
        
   reg [0:35] temp;
   
   initial
     begin
        $display("KS10 Simulation Starting");

        //
        // Initial state
        //
        
        clk     = 0;
        reset   = 1;
        cslALE  = 0;
        cslWR_N = 1;
        cslRD_N = 1;

        //
        // Release reset at 95 nS
        //
        
        #95 reset = 1'b0;

        //
        //  Write to Console Instruction Register
        //
       
        cslWRITE(addrREGCIR, valREGCIR);

        //
        // Write to Control/Status Register
        //  Set EXEC, RUN, and release RESET
        //

        cslWRITE(addrREGSTATUS, valREGSTATUS);

        //
        // Readback Console Instruction Register
        //

        cslREAD(addrREGCIR, temp);

        //
        // Initialize Console Status
        //

        cslWRKS10MEM(18'o000031, 36'b0);
        cslWRKS10MEM(18'o000036, 36'b0);
        cslWRKS10MEM(18'o025741, 36'b0);
        cslWRKS10MEM(18'o026040, 36'b0);
        cslWRKS10MEM(18'o030024, 36'b0);
        cslWRKS10MEM(18'o030037, 36'b0);
        
     end

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

   assign cslAD = (~cslRD_N) ? 8'bz : cslADOUT;

   //
   // KS10
   //

   KS10 uKS10
     (.clk              (clk),
      .reset            (reset),
      .dz11RXD          (dz11RXD),
      .dz11TXD          (dz11TXD),
      .rh11CD           (rh11CD),
      .rh11WP           (rh11WP),
      .rh11MISO         (rh11MISO),
      .rh11MOSI         (rh11MOSI),
      .rh11SCLK         (rh11SCLK),
      .rh11CS           (rh11CS),
      .cslALE           (cslALE),
      .cslAD            (cslAD),
      .cslRD_N          (cslRD_N),
      .cslWR_N          (cslWR_N),
      .cslINTR_N        (cslINTR_N),
      .ssramCLK         (ssramCLK),
      .ssramADDR        (ssramADDR),
      .ssramDATA        (ssramDATA),
      .ssramWR          (ssramWR),
      .ssramADV         (ssramADV),
      .runLED           (runLED)
      );
   
   //
   // Display run/halt status
   //

   always @(negedge runLED)
     $display("KS10 CPU Halted at t = %f us.", $time / 1.0e3);
   
   always @(posedge runLED)
     $display("KS10 CPU Unhalted at t = %f us", $time / 1.0e3);
   
   //
   // Handle Startup.
   //
   // Details
   //  The Microcode will always halt at startup.  Catch the halt
   //  at startup (only).  When this occurs momentarily push the
   //  continue button to continue execution.  Otherwise let the
   //  KS10 halt.
   //
   
   always @(negedge runLED)
     begin
        if ($time > 13000 && $time < 15000)
          begin
             cslWRITEb(8'h25, 8'h16);
             cslWRITEb(8'h25, 8'h14);
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
       `include "ssram.dat"
     end

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
        else if (ssramWR)
          SSRAM[wr_addr] <= ssramDATA;
        rd_addr <= wr_addr;
     end

   assign ssramDATA = (ssramWR) ? 36'bz : SSRAM[rd_addr];

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
   //   A Console Interrupt (cslINTR asserted) may indicate that a
   //   character is available to print or that a character can be
   //   accepted by the KS10, or both, or neither.
   //
   
   reg [0:35] dataCOUT;
   parameter [18:35] addrCOUT = 18'o000033;
   
   always @(posedge clk or posedge reset)
     begin
        if (reset)
          dataCOUT <= 36'b0;
        else if (cslINTR)
          begin
             
             //$display("KS10 CPU has interrupted the console at t = %f us", $time / 1.0e3);
             
             //
             // Read CTYOUT Memory Location
             //
             
             cslRDKS10MEM(addrCOUT, dataCOUT);

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
                  cslWRKS10MEM(addrCOUT, 36'b0);
               end
          end
     end

`endif
   
endmodule
