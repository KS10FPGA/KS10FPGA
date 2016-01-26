////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RH11 Interrupt
//
// Details
//   The module implements the RH11 interrupt controller.
//
// File
//   rhintr.v
//
// Notes
//   RH11 interrupts are a little strange.
//
//   Please read the white pager entited "PDP-11 Interrupts: Variations On A
//   Theme", Bob Supnik, 03-Feb-2002 [revised 20-Feb-2004]
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2016 Rob Doyle
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

`include "rhcs1.vh"

module RHINTR (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire         devRESET,             // Device reset from UBA
      input  wire         devLOBYTE,            // Device low byte
      input  wire [ 0:35] devDATAI,             // Device data in
      input  wire         rhcs1WRITE,           // CS1 write
      input  wire         rhSC,                 // Special Conditions (RHCS1[SC ])
      input  wire         rhRDY,                // Ready              (RHCS1[RDY])
      input  wire         rhIE,                 // Interrupt enable   (RHCS1[IE ])
      input  wire         rhCLR,                // Controller         (RHCS2[CLR])
      input  wire         rhIACK,               // Interrupt acknowledge
      output wire         rhIRQ                 // Interrupt request
   );

   //
   // Big-endian to little-endian data bus swap
   //

   wire [35:0] rhDATAI = devDATAI[0:35];

   //
   // Keep track of rhRDY transitions.
   //

   reg lastRDY;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          lastRDY <= 0;
        else
          lastRDY <= rhRDY;
     end

   //
   // Interrupt Flip-flop.
   //  An interrupt is triggered on the rising edge of rhRDY when interrupts are
   //  enabled. An interrupt is also created when rhRDY and rhIE are written
   //  simultaneously.
   //
   //  The interrupt is cleared when an interrupt acknowledge is received.
   //
   // Trace
   //  M7286/CSRA/E14
   //  M7286/CSRA/E18A
   //

   reg rhIFF;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rhIFF <= 0;
        else
          if (devRESET | rhCLR | rhIACK)
            rhIFF <= 0;
          else if ((rhRDY & !lastRDY & rhIE) |
                   (rhcs1WRITE & devLOBYTE & `rhCS1_RDY(rhDATAI) & `rhCS1_IE(rhDATAI)))
            rhIFF <= 1;
     end

   //
   // Interrupt request
   //
   // Trace
   //  M7296/CSRA/E17B
   //  M7296/CSRA/E17C
   //

   assign rhIRQ = rhIFF | (rhSC & rhRDY);

endmodule
