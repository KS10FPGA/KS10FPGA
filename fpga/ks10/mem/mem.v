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
      output wire [ 0:35] busDATAO,     // Data out
      output wire         ssramCLK,     // SSRAM Clock
      output wire         ssramCLKEN_N, // SSRAM CLKEN#
      output wire         ssramADV,     // SSRAM Advance (burst)
      output wire [ 1: 4] ssramBW_N,    // SSRAM BW#
      output wire         ssramOE_N,    // SSRAM OE#
      output wire         ssramWE_N,    // SSRAM WE#
      output wire         ssramCE,      // SSRAM CE
      output wire [ 0:19] ssramADDR,    // SSRAM Address Bus
      inout  wire [ 0:35] ssramDATA,    // SSRAM Data Bus
      output wire [ 0:27] test          // Test signals
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

   wire msrREAD   = busREAD   &  busIO & busPHYS & (busDEV == memDEV) & (busIOADDR == addrMSR);
   wire msrWRITE  = busWRITE  &  busIO & busPHYS & (busDEV == memDEV) & (busIOADDR == addrMSR);
   wire memREAD   = busREAD   & !busIO;
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
       ssramDATAIN[0:35],       // dataport[111:146]
       ssramADDR[0:19],         // dataport[ 91:110]
       3'b0,,                   // dataport[ 88: 90]
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
   // SSRAM Write Enable
   //  This synchronizes the SSRAM Write Enable to the falling edge of the
   //  SSRAM Clock.
   //

   reg ssramWE;
   always @(negedge memCLK or posedge rst)
     begin
        if (rst)
          ssramWE <= 0;
        else
          ssramWE <= memWRITE & clkPHS[1];
     end
 
   //
   // SSRAM Interface
   //  The OE# pin is tied low.  This is permitted per the CY7C1460AV33 data
   //  sheet.   Quoting the section entitled "Single Write Accesses" it states
   //  that "... on the subsequent clock rise the data lines are automatically
   //  tri-stated regardless of the state of the OE input signal."
   //

   assign ssramCLKEN_N = 0;
   assign ssramADV     = 0;
   assign ssramBW_N    = 0;
   assign ssramWE_N    = !ssramWE;
   assign ssramOE_N    = 0;
   assign ssramCE      = 1;
   assign ssramADDR    = busMEMADDR;
   assign ssramDATA    = memWRITE ? busDATAI : 36'bz;
   
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

   assign busDATAO = busIO ? regSTAT : ssramDATA;

   //
   // Create the busACKO signal
   //

   assign busACKO = msrREAD | msrWRITE | memREAD | memWRITE | memWRTEST;

   //
   // Test outputs
   //

   wire testRAMCLK;
   wire testCPUCLK;
   wire clkPHS1;
   wire clkPHS2;
   wire clkPHS3;
   wire clkPHS4;

`ifdef XILINX

   wire clkPHSb[1:4];

   CLKFWD fwdCPUCLK (
      .I (cpuCLK),
      .O (testCPUCLK)
   );

   CLKFWD fwdSSRAMCLK (
      .I (memCLK),
      .O (ssramCLK)
   );

   CLKFWD fwdRAMCLK (
      .I (memCLK),
      .O (testRAMCLK)
   );

   BUFG bufCLKPHS1 (
      .I (clkPHS[1]),
      .O (clkPHSb[1])
   );

   CLKFWD fwdCLKPHS1 (
      .I (clkPHSb[1]),
      .O (clkPHS1)
   );

   BUFG bufCLKPHS2 (
      .I (clkPHS[2]),
      .O (clkPHSb[2])
   );

   CLKFWD fwdCLKPHS2 (
      .I (clkPHSb[2]),
      .O (clkPHS2)
   );

   BUFG bufCLKPHS3 (
      .I (clkPHS[3]),
      .O (clkPHSb[3])
   );

   CLKFWD fwdCLKPHS3 (
      .I (clkPHSb[3]),
      .O (clkPHS3)
   );

   BUFG bufCLKPHS4 (
      .I (clkPHS[4]),
      .O (clkPHSb[4])
   );

   CLKFWD fwdCLKPHS4 (
      .I (clkPHSb[4]),
      .O (clkPHS4)
   );

`else

   assign testCPUCLK = cpuCLK;
   assign testRAMCLK = memCLK;
   assign ssramCLK   = memCLK;
   assign clkPHS1    = clkPHS[1];
   assign clkPHS2    = clkPHS[2];
   assign clkPHS3    = clkPHS[3];
   assign clkPHS4    = clkPHS[4];

`endif

   //
   // Test Signals
   //

   assign test[ 0] = testCPUCLK;        // VB31
   assign test[ 1] = testRAMCLK;        // VB30
   assign test[ 2] = busADDRI[35];      // VB29
   assign test[ 3] = busADDRI[34];      // VB28
   assign test[ 4] = busADDRI[33];      // VB27
   assign test[ 5] = busADDRI[32];      // VB26
   assign test[ 6] = busDATAI[35];      // VB25
   assign test[ 7] = busDATAI[34];      // VB24
   assign test[ 8] = busDATAI[33];      // VB23
   assign test[ 9] = busDATAI[32];      // VB22
   assign test[10] = memREAD;           // VB21
   assign test[11] = memWRITE;          // VB20
   assign test[12] = clkPHS1;           // VB19
   assign test[13] = clkPHS2;           // VB18
   assign test[14] = clkPHS3;           // VB15
   assign test[15] = clkPHS4;           // VB14
   assign test[16] = ssramWE_N;         // VB13
   assign test[17] = ssramOE_N;         // VB12
   assign test[18] = 0;                 // VB11
   assign test[19] = 0;                 // VB10
   assign test[20] = 0;                 // VB9
   assign test[21] = 0;                 // VB8
   assign test[22] = 0;                 // VB7
   assign test[23] = 0;                 // VB6
   assign test[24] = busDATAO[35];      // VB5
   assign test[25] = busDATAO[34];      // VB4
   assign test[26] = busDATAO[33];      // VB3
   assign test[27] = busDATAO[32];      // VB2

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
