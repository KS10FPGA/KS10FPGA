////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KS-10 Memory Interface
//
// Details
//   This module is interface between the KS10 backplane bus and the SSRAM.
//
// File
//   mem.v
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

`include "../uba/uba.vh"
`include "../cpu/bus.vh"
`include "../ks10.vh"

module MEM (
      input  wire         rst,          // Reset
      input  wire         cpuCLK,       // Clock
      input  wire         memCLK,       // Memory clock
      input  wire [ 1: 4] clkPHS,       // Clock Phase
      input  wire         busREQI,      // Memory Request In
      output wire         busACKO,      // Memory Acknowledge Out
      input  wire [ 0:35] busADDRI,     // Address Address In
      input  wire [ 0:35] busDATAI,     // Data in
      output reg  [ 0:35] busDATAO,     // Data out
      output wire         ssramCLK,     // SSRAM Clock
      output wire         ssramCLKEN_N, // SSRAM CLKEN#
      output wire         ssramADV,     // SSRAM Advance (burst)
      output wire [ 1: 4] ssramBW_N,    // SSRAM BW#
      output wire         ssramOE_N,    // SSRAM OE#
      output wire         ssramWE_N,    // SSRAM WE#
      output wire         ssramCE,      // SSRAM CE
      output wire [ 0:22] ssramADDR,    // SSRAM Address Bus
      inout  wire [ 0:35] ssramDATA     // SSRAM Data Bus
   );

   //
   // The Memory Conroller is Device 0
   //

   localparam [ 0: 3] memDEV  = `devUBA0;

   //
   // Memory Status Register IO Address
   //

   localparam [18:35] addrMSR = 18'o100000;

   //
   // Memory flags
   //
   // Details:
   //  busADDRI[ 0:13] is flags
   //  busADDRI[14:35] is address
   //

   wire         busREAD    = `busREAD(busADDRI);
   wire         busWRTEST  = `busWRTEST(busADDRI);
   wire         busWRITE   = `busWRITE(busADDRI);
   wire         busPHYS    = `busPHYS(busADDRI);
   wire         busIO      = `busIO(busADDRI);
   wire [ 0: 3] busDEV     = `busDEV(busADDRI);
   wire [18:35] busIOADDR  = `busIOADDR(busADDRI);
   wire [16:35] busMEMADDR = `busMEMADDR(busADDRI);

   //
   // Address decoding
   //

   localparam [16:35] addrHSB = 20'o0376000;

   wire msrREAD   = busREAD   &  busIO & busPHYS & (busDEV == memDEV) & (busIOADDR == addrMSR);
   wire msrWRITE  = busWRITE  &  busIO & busPHYS & (busDEV == memDEV) & (busIOADDR == addrMSR);
   wire memREAD   = busREAD   & !busIO & ((busMEMADDR[16:20] == 0) | (busMEMADDR[16:30] == addrHSB[16:30]));
   wire memWRITE  = busWRITE  & !busIO;
   wire memWRTEST = busWRTEST & !busIO;

   //
   // Memory Status Register
   //

   wire [0:35] regSTAT;

   MEMSTAT STAT (
      .rst       (rst),
      .clk       (cpuCLK),
      .busDATAI  (busDATAI),
      .msrWRITE  (msrWRITE),
      .regSTAT   (regSTAT)
   );

`ifdef SYNTHESIS
`ifdef CHIPSCOPE_MEM

   //
   // ChipScope Pro Integrated Controller (ICON)
   //

   wire [35:0] control0;

   chipscope_mem_icon uICON (
      .CONTROL0  (control0)
   );

   //
   // ChipScope Pro Integrated Logic Analyzer (ILA)
   //

   wire [255:0] TRIG0 = {
       rst,                     // dataport[    255]
       busDATAI[0:35],          // dataport[219:254]
       busDATAO[0:35],          // dataport[183:218]
       busADDRI[0:35],          // dataport[147:182]
       ssramDATA[0:35],         // dataport[111:146]
       ssramADDR[0:22],         // dataport[ 88:110]
       clkPHS[1:4],             // dataport[ 84: 87]
       ssramOE_N,               // dataport[     83]
       ssramWE_N,               // dataport[     82]
       busREQI,                 // dataport[     81]
       busACKO,                 // dataport[     80]
       busIO,                   // dataport[     79]
       busREAD,                 // dataport[     78]
       busWRITE,                // dataport[     77]
       41'b0,                   // dataport[ 36: 76]
       36'b0                    // dataport[  0: 35]
   };

   chipscope_mem_ila uILA (
      .CLK       (memCLK),
      .CONTROL   (control0),
      .TRIG0     (TRIG0)
   );

`endif
`endif

   //
   // Bus Multiplexer
   //
   // This selects between SSRAM and the Memory Status Register.
   // We just use busIO to selected between the two.
   //
   // Trace
   //  MMC7/E75
   //  MMC7/E86
   //  MMC7/E90
   //  MMC7/E103
   //  MMC7/E107
   //  MMC7/E136
   //  MMC7/E142
   //  MMC7/E150
   //  MMC7/E157
   //

// assign busDATAO = busIO ? regSTAT : mem[rd_addr];

   always @*
     begin
        if (busIO)
          busDATAO <= regSTAT;
        else if (busMEMADDR[16:20] == 0)
          busDATAO <= mem[rd_addr];
        else
          busDATAO <= hsb[rd_hsb_addr];
     end

   //
   // Create the busACKO signal
   //

   assign busACKO = msrREAD | msrWRITE | memREAD | memWRITE | memWRTEST;

   //
   // Syncrhonous SRAM for test
   //

   reg  [0:35] mem[0:32767];
   reg  [0:14] rd_addr;
   wire [0:14] wr_addr = busMEMADDR[21:35];

`ifndef SYNTHESIS
   initial
     $readmemh(`SSRAM_DAT, mem);
`endif

   always @(negedge cpuCLK)
     begin
        if (memWRITE)
          mem[wr_addr] <= busDATAI;
        rd_addr <= wr_addr;
     end

   //
   // Syncrhonous SRAM for HSB
   //

   reg  [0:35] hsb[0:31];
   reg  [0: 4] rd_hsb_addr;
   wire [0: 4] wr_hsb_addr = busMEMADDR[30:35];
   always @(negedge cpuCLK)
     begin
        if (memWRITE & (busMEMADDR[16:30] == addrHSB[16:30]))
          hsb[wr_hsb_addr] <= busDATAI;
        rd_hsb_addr <= wr_hsb_addr;
     end

   //
   // Stub
   //

   assign ssramCLK     = 0;
   assign ssramCLKEN_N = 0;
   assign ssramADV     = 0;
   assign ssramBW_N    = 0;
   assign ssramWE_N    = 1;
   assign ssramOE_N    = 1;
   assign ssramCE      = 1;
   assign ssramADDR    = 0;
   assign ssramDATA    = 0;

   //
   // Simulation/Debug
   //

`ifndef SYNTHESIS

   always @(negedge cpuCLK)
     begin
        if (msrREAD)
          $display("[%11.3f] MEM: Memory Status Register Read", $time/1.0e3);
        if (msrWRITE)
          $display("[%11.3f] MEM: Memory Status Register Written", $time/1.0e3);
     end

`endif

endmodule
