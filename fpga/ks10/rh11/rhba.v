////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RH11 Bus Address Register (RHBA)
//
// File
//   rhba.v
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

`include "rhba.vh"
`include "rhcs1.vh"

module RHBA (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire         devRESET,             // Device reset
      input  wire         devLOBYTE,            // Device Low Byte
      input  wire         devHIBYTE,            // Device High Byte
      input  wire [ 0:35] devDATAI,             // Device Data In
      input  wire         rhcs1WRITE,           // Write to RHCS1
      input  wire         rhbaWRITE,            // Write to BA
      input  wire         rhCLR,                // Controller clear
      input  wire         rhRDY,                // Controller ready
      input  wire         rhBAI,                // Inhibit increment
      input  wire         rhINCBA,              // Increment BA
      output wire [17: 0] rhBA                  // rhBA Output
   );

   //
   // Big-endian to little-endian data bus swap
   //

   wire [35:0] rhDATAI = devDATAI[0:35];

   //
   // RH11 Bus Address (RHBA) Register
   //
   // The LSB of the bus address is always zero.   This makes the bus address
   // always even for word addressing.
   //
   // In the RH11, the bus address can decrement supporting a 'reverse write-
   // check' and a 'reverse read' operation.  The documents imply that this was
   // never supported.  This is not implemented.
   //
   // Trace
   //  M7295/BCTC/E14
   //  M7295/BCTC/E22
   //  M7295/BCTC/E30
   //  M7295/BCTC/E36
   //  M7295/BCTC/E37
   //  M7295/BCTC/E88
   //

   reg [17:1] addr;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          addr <= 0;
        else
          if (devRESET | rhCLR)
            addr <= 0;
          else if (rhcs1WRITE & devHIBYTE & rhRDY)
            addr[17:16] <= `rhCS1_BAE(rhDATAI);
          else if (rhbaWRITE)
            begin
               if (devHIBYTE)
                 addr[15: 8] <= `rhBA_HI(rhDATAI);
               if (devLOBYTE)
                 addr[ 7: 1] <= `rhBA_LO(rhDATAI);
            end
          else if (rhINCBA & !rhBAI)
            addr <= addr + 2'b10;
     end

   //
   // Create RHBA
   //

   assign rhBA = {addr, 1'b0};

endmodule
