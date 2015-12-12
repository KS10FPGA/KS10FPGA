////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KS10 Wrapper for the ESM Reference Design.
//
// Details
//   This wrapper allows a tiny bit of customization of the KS10.  For now, it
//   just ties off a bunch of DZ11 IO.
//
// File
//   esm_ks10.v
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

`ifndef RPXX_ENABLE
 `define RPXX_ENABLE    8'b00000001
`endif

`ifndef RPXX_WP
 `define RPXX_WP        8'b00000000
`endif  
  
module ESM_KS10 (
      // Clock/Reset
      input  wire         RESET_N,      // Reset
      input  wire         CLK50MHZ,     // Clock
      input  wire         MR_N,         // Master Reset push button
      output wire         MR,           // Master Reset out
      // DZ11 Interfaces
      input  wire [ 1: 2] TXD,          // DZ11 RS-232 Transmitted Data
      output wire [ 1: 2] RXD,          // DZ11 RS-232 Received Data
      // RH11 Interfaces
      input  wire         rh11CD_N,     // RH11 Card Detect
      input  wire         rh11MISO,     // RH11 Data In
      output wire         rh11MOSI,     // RH11 Data Out
      output wire         rh11SCLK,     // RH11 Clock
      output wire         rh11CS,       // RH11 Chip Select
      // Console Microcontroller Interfaces
      inout  wire [15: 0] conDATA,      // Console Data Bus
      input  wire [ 5: 1] conADDR,      // Console Address Bus
      input  wire         conBLE_N,     // Console Bus Lane
      input  wire         conBHE_N,     // Console Bus Lane
      input  wire         conRD_N,      // Console Read Strobe
      input  wire         conWR_N,      // Console Write Strobe
      output wire         conINTR_N,    // Console Interrupt
      // SSRAM Interfaces
      output wire         ssramCLK,     // SSRAM Clock
      output wire         ssramCLKEN_N, // SSRAM Clken
      output wire         ssramADV,     // SSRAM Advance
      output wire [ 1: 4] ssramBW_N,    // SSRAM BWA#
      output wire         ssramOE_N,    // SSRAM OE#
      output wire         ssramWE_N,    // SSRAM WE#
      output wire         ssramCE,      // SSRAM CE
      output wire [ 0:19] ssramADDR,    // SSRAM Address Bus
      inout  wire [ 0:35] ssramDATA,    // SSRAM Data Bus
      output wire         haltLED,      // Halt LED
      output wire [ 0:27] test          // Test signals
   );

   //
   // RH-11 Stubs
   //

   wire [ 7: 0] rh11WP = `RPXX_WP;                      // RH11 Write Protect
   wire [ 7: 0] rh11CD = {8{!rh11CD_N}} & `RPXX_ENABLE; // RH11 Card Detect 

   //
   // DZ-11 Interface Stubs
   //

   wire [ 7: 0] dz11CO = 8'hff;         // DZ11 Carrier Input (stubbed)
   wire [ 7: 0] dz11RI = 8'h00;         // DZ11 Ring Input (stubbed)
   wire [ 7: 0] dz11DTR;                // DZ11 DTR Output (stubbed)
   wire [ 7: 0] dz11TXD;                // DZ11 TXD
   wire [ 7: 0] dz11RXD;                // DZ11 RXD

   //
   // KS10 Processor
   //

   KS10 uKS10(
      .RESET_N          (RESET_N),
      .CLK50MHZ         (CLK50MHZ),
      // DZ11
      .dz11TXD          (dz11TXD),
      .dz11RXD          (dz11RXD),
      .dz11DTR          (dz11DTR),
      .dz11CO           (dz11CO),
      .dz11RI           (dz11RI),
      // RH11
      .rh11CD           (rh11CD),
      .rh11WP           (rh11WP),
      .rh11MISO         (rh11MISO),
      .rh11MOSI         (rh11MOSI),
      .rh11SCLK         (rh11SCLK),
      .rh11CS           (rh11CS),
      // Console
      .conADDR          (conADDR),
      .conDATA          (conDATA ),
      .conBLE_N         (conBLE_N),
      .conBHE_N         (conBHE_N),
      .conRD_N          (conRD_N),
      .conWR_N          (conWR_N),
      .conINTR_N        (conINTR_N),
      // Memory
      .ssramCLK         (ssramCLK),
      .ssramCLKEN_N     (ssramCLKEN_N),
      .ssramADV         (ssramADV),
      .ssramBW_N        (ssramBW_N),
      .ssramOE_N        (ssramOE_N),
      .ssramWE_N        (ssramWE_N),
      .ssramCE          (ssramCE),
      .ssramADDR        (ssramADDR),
      .ssramDATA        (ssramDATA),
      .test             (test),
      .haltLED          (haltLED)
   );

   //
   // DZ11 Fixup
   //  TXD is an output of the FT4232.  RXD is an input to the
   //  FT4232.  Therefore TXD and RXD must get twisted here.
   //

   assign dz11RXD[0]   = TXD[1];
   assign dz11RXD[1]   = TXD[2];
   assign RXD[1]       = dz11TXD[0];
   assign RXD[2]       = dz11TXD[1];

   //
   // Wrap back unused ports
   //

   assign dz11RXD[7:2] = dz11TXD[7:2];

   //
   // MR out.  This is done to quiet the tool.
   //

   assign MR = !MR_N;

endmodule
