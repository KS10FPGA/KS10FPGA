////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   LP20 Translation RAM (RAMD) implementation.
//
// Details
//   This file provides the implementation of the LP20 RAMD Register.
//
// File
//   lpramd.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2017 Rob Doyle
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

`include "lpcsra.vh"
`include "lpcbuf.vh"
`include "lpramd.vh"


module LPRAMD (
      input  wire         clk,          // Clock
      input  wire         rst,          // Reset
      input  wire         devREQO,      // Device request out
      input  wire         devACKI,      // Device acknowledge in
      input  wire         lpINIT,       // Init
      input  wire [35: 0] lpDATAI,      // Bus data in
      input  wire         cbufWRITE,    // CBUF write
      input  wire         ramdWRITE,    // RAMD write
      input  wire         lpERR,        // Composite error
      input  wire         lpPAR,        // Parity enabled
      input  wire         lpTESTRPE,    // RAM Parity Test
      input  wire         lpMODEPRINT,  // Print mode
      input  wire         lpMODETEST,   // Test mode
      input  wire         lpMODELDVFU,  // Load DVFU from DMA
      input  wire         lpMODELDRAM,  // Load RAM from DMA
      input  wire         lpCMDGO,      // Go command
      input  wire         lpINCADDR,    // Increment address
      output wire         lpSETRPE,     // RAM parity error
      output wire         lpSETDHLD,    // Delimiter hold
      output wire         lpCLRDHLD,    // Delimiter hold
      input  wire [17: 0] regBAR,       // Bus Address
      output reg  [15: 0] regRAMD       // RAMD Output
   );

   //
   // RAM Write Enable
   //

   wire ramWRITE = ramdWRITE | (devREQO & devACKI & lpMODELDRAM);

   //
   // Word selection logic
   //  This unpacks words from the 36-bit data word.
   //

   reg [12:0] wordDATAI;
   always @*
     begin
        if (ramdWRITE)
          wordDATAI <= lpDATAI[12:0];
        else
          if (regBAR[1])
            wordDATAI <= lpDATAI[12:0];
          else
            wordDATAI <= lpDATAI[30:18];
     end

   //
   // Byte selection logic
   //  This unpacks bytes from the 36-bit data word.
   //
   // Trace
   //  M8587/LPD2/E7
   //  M8587/LPD2/E15
   //

   reg [7:0] byteDATAI;
   always @*
     begin
        case (regBAR[1:0])
          2'b00:
            byteDATAI <= lpDATAI[25:18];        // Even word, low byte
          2'b01:
            byteDATAI <= lpDATAI[33:26];        // Even word, high byte
          2'b10:
            byteDATAI <= lpDATAI[ 7: 0];        // Odd word, low byte
          2'b11:
            byteDATAI <= lpDATAI[15: 8];        // Odd word, high byte
        endcase
     end

   //
   // RAM parity in
   //  RAM is written with inverted parity in RAM Parity Test Mode.
   //
   // Note:
   //  The funky verilog syntax is an XNOR reduction operator.
   //
   // Trace
   //  M8586/LPC5/E44
   //  M8586/LPC5/E49
   //

   wire ram_parity_in = ~^{lpTESTRPE, wordDATAI[11:0]};

   //
   // RAM Address Register
   //  A word about RAM addressing - the DEC LP20 uses an 8-bit counter and
   //  increments the address counter every other clock cycle.  This is a little
   //  complicated to implement.  This design implements uses a 9-bit counter,
   //  increments it every DMA cycle, but addresses the RAM using the most
   //  signficant 8-bits.  I.e., the LSB is not part of the addressing.
   //
   // Note:
   //  Loading the RAM requires 512 DMA cycles.
   //
   // Trace
   //  M8587/LPD2/E8
   //  M8587/LPD2/E16
   //

   reg [8:0] lpADDR;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          lpADDR <= 0;
        else
          begin
             if (lpCMDGO & lpMODELDRAM)
               lpADDR <= 0;
             else if (cbufWRITE)
               lpADDR <= {`lpCBUF_DAT(lpDATAI), 1'b0};
             else if ((lpMODEPRINT & devREQO & devACKI) |
                      (lpMODETEST  & devREQO & devACKI))
               lpADDR <= {byteDATAI, 1'b0};
             else if (lpINCADDR & lpMODELDRAM)
               lpADDR <= lpADDR + 1'b1;
          end
     end

   wire [7:0] ramADDR = lpADDR[8:1];

   //
   // Translation RAM
   //  The RAM is write enabled in pieces.  We use two RAMS
   //  to accomplish this.
   //
   //  ram[0] contains data and parity
   //  ram[1] contains control bits
   //

   reg [8:0] ram[1:0][0:255];

   //
   // RAM write port
   //  Writes occur as follows:
   //  1.  The RAM Parity bit (bit 12) is always written
   //  2.  The the The RAM Ctrl bits (bits 11:8) are only written (or over-
   //      written when the unit is not in DAVFU load mode.
   //  3.  The RAM Data bits (bits 7:0) are always written.
   //
   // Trace (RAM)
   //  M8585/LPR1/E24
   //  M8585/LPR1/E27
   //  M8585/LPR1/E10
   //  M8585/LPR1/E21
   //  M8585/LPR1/E30
   //  M8585/LPR1/E33
   //  M8585/LPR1/E29
   //  M8585/LPR1/E32
   //  M8585/LPR1/E20
   //  M8585/LPR1/E14
   //  M8585/LPR1/E23
   //  M8585/LPR1/E26
   //  M8585/LPR1/E17
   //
   // Note the RAM DISABLE net on DATA[7:0]
   //

`ifndef SYNTHESIS

   integer i;
   initial
     begin
        for (i = 0; i < 256; i = i + 1)
          begin
             ram[0][i] = 0;
             ram[1][i] = 0;
          end
     end

`endif

   //
   // Writes to Data port
   //

   always @(posedge clk)
     begin
        if (ramWRITE & !lpMODELDVFU)
          ram[1][ramADDR] <= {5'b0, wordDATAI[11:8]};
     end

   //
   // Writes to control port
   //

   always @(posedge clk)
     begin
        if (ramWRITE)
          ram[0][ramADDR] <= {ram_parity_in, wordDATAI[7:0]};
     end

   //
   // RAM read port
   //  Reads occur as follows:
   //  1.  The RAM Parity bit (bit 12) is always read
   //  2.  The RAM Ctrl bits (bits 11:8) are read as zero when the unit is in
   //      DAVFU load mode.
   //  3.  The RAM Data bits (bits 7:0) are always read.
   //

   wire [8:0] ram_ctrl = ram[1][ramADDR];
   wire [8:0] ram_data = ram[0][ramADDR];

   always @*
     begin
        if (lpMODELDVFU)
          regRAMD = {3'b0, ram_data[8], 4'b0, ram_data[7:0]};
        else
          regRAMD = {3'b0, ram_data[8], ram_ctrl[3:0], ram_data[7:0]};
     end

   //
   // RAM Parity Error
   //  The pipeline delay is to match synchronous RAM.
   //  Note the 'exclusive or' reduction operator
   //

   reg lpRPEEN;
    always @(posedge clk or posedge rst)
     begin
        if (rst)
          lpRPEEN <= 0;
        else
          lpRPEEN <= ramWRITE;
     end

   assign lpSETRPE = 1'b0 & lpRPEEN & lpPAR & !lpMODELDVFU & ^{lpTESTRPE, regRAMD};     // FIXME

   //
   // Delimiter hold
   //  The pipeline delay is to match synchronous RAM.
   //

   reg lpDHLDEN;
    always @(posedge clk or posedge rst)
     begin
        if (rst)
          lpDHLDEN <= 0;
        else
          lpDHLDEN <= ((devREQO & devACKI & lpMODEPRINT) |
                       (devREQO & devACKI & lpMODETEST));
     end

   assign lpSETDHLD = (cbufWRITE |
                       (lpDHLDEN & !lpERR & `lpCSRA_DHLD(regRAMD)) |
                       (lpDHLDEN & !lpERR & `lpCSRA_DHLD(regRAMD)));

   assign lpCLRDHLD = ((lpDHLDEN & !`lpCSRA_DHLD(regRAMD)) |
                       (lpDHLDEN & !`lpCSRA_DHLD(regRAMD)));

endmodule
