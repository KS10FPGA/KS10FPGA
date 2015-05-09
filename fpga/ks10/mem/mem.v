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

module MEM(
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
   // Data is written to the SSRAM on clkPHS[4] which is
   // two clock cycles after the WE signal is asserted.
   //
/*

   reg dir;
   always @(negedge memCLK or posedge rst)
     begin
        if (rst)
          dir <= 0;
        else
          dir <= memWrite & clkPHS[3];
     end

   //
   // ssramWE is asserted on clkPHS[2] during a write cycle
   //

   reg ssramWE;
   always @(negedge memCLK or posedge rst)
     begin
        if (rst)
          ssramWE <= 0;
        else
          ssramWE <= memWrite & clkPHS[1];
     end
*/

   //
   // Register the Bus Data In
   //

/*
   reg [0:35] writeReg;
   always @(posedge memCLK or posedge rst)
     begin
        if (rst)
          writeReg <= 0;
        else
          if (clkPHS[1])
            writeReg <= busDATAI;
     end

   //
   // Register the Bus Data Out
   //

   reg [0:35] readReg;
   always @(posedge memCLK or posedge rst)
     begin
        if (rst)
          readReg <= 0;
        else
          if (clkPHS[4])
            readReg <= ssramDATA;
     end
*/

   //
   // SSRAM Interface
   //  The OE# pin is tied low.  This is permitted per the CY7C1460AV33 data
   //  sheet.   Quoting the section entitled "Single Write Accesses" it states
   //  that "... on the subsequent clock rise the data lines are automatically
   //  tri-stated regardless of the state of the OE input signal."
   //
   //  The the eval board has 23 address lines connected between the FPGA and
   //  the SSRAM chip.  However the 1MW CY7C1460AV33 SSRAM chip that is on the
   //  board only has 20-bit addressing.  Therefore the upper 3 address lines
   //  are not used and are always set to zero.
   //

// assign ssramCLK     = !memCLK;
   assign ssramCLKEN_N = 0;
   assign ssramADV     = 0;
   assign ssramBW_N    = 0;
   assign ssramWE_N    = !(memWRITE & clkPHS[2]);
// assign ssramWE_N    = !ssramWE;
   assign ssramOE_N    = 0;
// assign ssramOE_N    = !(memRead  & clkPHS[4]);
   assign ssramCE      = 1;
   assign ssramADDR    = {3'b0, busMEMADDR};
// assign ssramDATA    = memWRITE & clkPHS[4] ? writeReg : 36'bz;
   assign ssramDATA    = memWRITE & clkPHS[4] ? busDATAI : 36'bz;
// assign ssramDATA    = dir ? busDATAI : 36'bz;

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

`ifdef XILINX

   //
   // Xilinx calls this 'clock forwarding'.  The synthesis tools will give
   // errors/warning if you attempt to drive a clock output off-chip without
   // this.
   //

   ODDR2 #(
       .DDR_ALIGNMENT      ("NONE"),    // Sets output alignment
       .INIT               (1'b0),      // Initial state of the Q output
       .SRTYPE             ("SYNC")     // Reset type: "SYNC" or "ASYNC"
   )
   iODDR2 (
       .Q                  (ssramCLK),  // 1-bit DDR output data
       .C0                 (!memCLK),   // 1-bit clock input
       .C1                 (memCLK),    // 1-bit clock input
       .CE                 (1'b1),      // 1-bit clock enable input
       .D0                 (1'b1),      // 1-bit data input (associated with C0)
       .D1                 (1'b0),      // 1-bit data input (associated with C1)
       .R                  (1'b0),      // 1-bit reset input
       .S                  (1'b0)       // 1-bit set input
   );

`else

   assign ssramCLK = !memCLK;

`endif

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
