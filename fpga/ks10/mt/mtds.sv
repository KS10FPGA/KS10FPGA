////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   MTxx Disk Address Register (MTDS)
//
// File
//   mtds.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2021 Rob Doyle
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

`include "mtds.vh"

module MTDS (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire         mtINIT,               // Initialize
      input  wire         mtCLRATA,             // Clear ATA
      input  wire         mtGO,                 // Go command
      input  wire         mtMOL,                // Media On-line
      input  wire         mtWRL,                // Write Lock
      input  wire         mtDPR,                // Drive present
      input  wire         mtDRVCLR,             // Drive clear
      input  wire [15: 0] mtER,                 // mtER register
      output wire [15: 0] mtDS                  // mtDS register
   );

   //
   // Edge detect dsERR
   //

   logic dsERR;                                 // Composite error
   logic lastERR;                               // Last composite error

   always_ff @(posedge clk)
     begin
        if (rst)
          lastERR <= 0;
        else
          lastERR <= dsERR;
     end

   //
   // MTDS Attention (mtATA)
   //
   // Trace
   //  M8933/TCCM7/E49
   //  M8909/MBI3/E41
   //  M8909/MBI3/E46
   //  M8909/MBI3/E51
   //  M8909/MBI3/E52
   //

   logic dsATA;

   always_ff @(posedge clk)
     begin
        if (rst | mtINIT | mtCLRATA | mtDRVCLR)
          dsATA <= 0;
        else if (dsERR & !lastERR)
          dsATA <= 1;
     end

   //
   // MTDS Composite Error (mtERR)
   //
   // Trace
   //  M8933/TCCM7/E49
   //  M8909/MBI10/E54
   //  M8909/MBI10/E55
   //  M8909/MBI10/E81
   //  M8909/MBI10/E82
   //

   assign dsERR = (mtER != 0);

   //
   // MTDS Positioning In Progress (mtPIP)
   //
   // Trace
   //  M8933/TCCM7/E49
   //

   wire dsPIP = 0;

   //
   // MTDS Medium On-Line (mtMOL)
   //
   // Trace
   //  M8933/TCCM7/E49
   //

   wire dsMOL = mtMOL;

   //
   // MTDS Write Lock (mtWRL)
   //
   // Trace
   //  M8933/TCCM7/E59
   //

   wire dsWRL = mtWRL;

   //
   // End of Tape (mtEOT)
   //
   // Trace
   //  M8933/TCCM7/E59
   //

   wire dsEOT = 0;

   //
   // Unused
   //
   // Trace
   //  M8933/TCCM7/E59
   //

   wire dsUN9 = 0;

   //
   // MTDS Drive Present (mtDPR)
   //
   // Trace
   //  M8933/TCCM7/E59
   //

   wire dsDPR = mtDPR;

   //
   // MTDS Drive Ready (mtDRY)
   //
   // Trace
   //  M8933/TCCM7/E58
   //

   wire dsDRY = !mtGO;

   //
   // Slave Status Change (mtSSC)
   //
   // Trace
   //  M8933/TCCM7/E58
   //

   wire dsSSC = 0;

   //
   // Phase Encoder Status (PES)
   //
   // Trace
   //  M8933/TCCM7/E58
   //

   wire dsPES = 0;

   //
   // Slowing Down (SDWN)
   //
   // Trace
   //  M8933/TCCM7/E58
   //

   wire dsSDWN = 0;

   //
   // Identification Burst (IDB)
   //
   // Trace
   //  M8933/TCCM7/E67
   //

   wire dsIDB = 0;

   //
   // Tape Mark (TM)
   //
   // Trace
   //  M8933/TCCM7/E67
   //

   wire dsTM = 0;

   //
   // Beginnning of Tape (BOT)
   //
   // Trace
   //  M8933/TCCM7/E67
   //

   wire dsBOT = 0;

   //
   // Slave Attention
   //
   // Trace
   //  M8933/TCCM7/E67
   //

   wire dsSLA = 0;

   //
   // Build MTDS
   //

   assign mtDS = {dsATA, dsERR, dsPIP, dsMOL,  dsWRL, dsEOT, dsUN9, dsDPR,
                  dsDRY, dsSSC, dsPES, dsSDWN, dsIDB, dsTM,  dsBOT, dsSLA};

endmodule
