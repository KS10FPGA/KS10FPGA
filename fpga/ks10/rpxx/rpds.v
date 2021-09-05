////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RPxx Disk Address Register (RPDS)
//
// File
//   rpds.v
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

`include "rpda.vh"
`include "rpdc.vh"
`include "rpds.vh"

module RPDS (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire         clr,                  // Clr
      input  wire         rpCLRATA,             // ATA clr
      input  wire         rpSETLST,             // Last sector transferred
      input  wire         rpSETATA,             // Set ATA
      input  wire         rpGO,                 // Go command
      input  wire         rpMOL,                // Media On-line
      input  wire         rpWRL,                // Write Lock
      input  wire         rpDPR,                // Drive present
      input  wire         rpPIP,                // Positioning in progress
      input  wire         rpDRY,                // Drive ready
      input  wire         rpDRVCLR,             // Drive clear command
      input  wire         rpPRESET,             // Preset command
      input  wire         rpPAKACK,             // Pack Ack command
      input  wire         rpdaWRITE,            // Write RPDA
      input  wire [15: 0] rpER1,                // rpER1 register
      input  wire [15: 0] rpER2,                // rpER2 register
      input  wire [15: 0] rpER3,                // rpER3 register
      output wire [15: 0] rpDS                  // rpDS register
   );

   //
   // Watch for transitions of rpMOL
   //

   reg lastMOL;

   always @(posedge clk)
     begin
        if (rst)
          lastMOL <= 0;
        else
          lastMOL <= rpMOL;
     end

   //
   // RPDS Attention (rpATA)
   //
   // Trace
   //  M7787/DP2/E57
   //  M7774/RG6/E23
   //  M7774/RG5/E37
   //  M7774/RG5/E39
   //  M7774/RG5/E48
   //  M7774/RG5/E66
   //  M7774/RG5/E68
   //  M7774/RG5/E81
   //  M7774/RG5/E79
   //  M7774/RG5/E80
   //  M7774/RG5/E81
   //  M7774/RG5/E51
   //  M7774/RG5/E57
   //
   // Note:
   //  ATA is asserted when the disk transitions from off-line to on-line or
   //  from off-line to on-line.
   //

   wire dsERR;
   reg  dsATA;
   always @(posedge clk)
     begin
        if (rst | clr | rpCLRATA | rpDRVCLR)
          dsATA <= 0;
        else if (rpSETATA | (rpMOL != lastMOL) | (rpGO & dsERR))
          dsATA <= 1;
     end

   //
   // RPDS Composite Error (rpERR)
   //
   // Trace
   //  M7774/RG0/E4
   //  M7774/RG0/E29
   //  M7774/RG0/E33
   //  M7774/RG0/E46
   //  M7774/RG0/E47
   //  M7774/RG6/E23
   //  M7776/EC6/E52
   //  M7776/EC6/E80
   //  M7776/EC6/E85
   //  M7776/EC7/E49
   //  M7776/EC7/E59
   //  M7776/EC7/E85
   //  M7776/EC7/E95
   //

   assign dsERR = (rpER1 != 0) | (rpER2 != 0) | (rpER3 != 0);

   //
   // RPDS Positioning In Progress (rpPIP)
   //
   // Trace
   //  M7774/RG3/E77
   //  M7774/RG3/E81
   //  M7774/RG6/E23
   //

   wire dsPIP = rpPIP;

   //
   // RPDS Medium On-Line (rpMOL)
   //
   // Trace
   //  M7774/RG6/E23
   //

   wire dsMOL = rpMOL;

   //
   // RPDS Write Lock (rpWRL)
   //
   // Trace
   //  M7774/RG6/E16
   //

   wire dsWRL = rpWRL;

   //
   // RPDS Last Sector Transferred (rpLST)
   //
   // Trace
   //  M7774/RG6/E16
   //  M7774/RG6/E40
   //  SS4/
   //

   reg dsLST;
   always @(posedge clk)
     begin
        if (rst | clr | rpdaWRITE)
          dsLST <= 0;
        else if (rpSETLST)
          dsLST <= 1;
     end

   //
   // RPDS Programmable (rpPGM)
   //
   // Trace
   //  M7774/DP4/ "PROGRAMMABLE H"
   //  M7774/RG6/E16
   //

   wire dsPGM = 0;

   //
   // RPDS Drive Present (rpDPR)
   //
   // Trace
   //  M7774/RG6/E16
   //

   wire dsDPR = rpDPR;

   //
   // RPDS Drive Ready (rpDRY)
   //
   // Trace
   //  M7774/RG6/E16
   //

   wire dsDRY = rpDRY;

   //
   // RPDS Volume Valid (rpVV)
   //
   // Trace
   //  M7774/RG4/E50
   //  M7774/RG4/E52
   //  M7774/RG4/E55
   //  M7774/RG4/E58
   //  M7774/RG4/E59
   //  M7774/RG4/E68
   //  M7774/RG6/E16
   //
   // Note:
   //  VV is cleared when the disk transitions from off-line to online.
   //  Clearing rpMOL does not clear VV.
   //
   //  VV is not set when a composite error (RPDS[ERR]) is present.
   //

   reg dsVV;
   always @(posedge clk)
     begin
        if (rst | (rpMOL & !lastMOL))
          dsVV <= 0;
        else if ((rpPRESET & !dsERR) |
                 (rpPAKACK & !dsERR))
          dsVV <= 1;
     end

   //
   // Build RPDS
   //
   // Trace
   //  M7774/RG6/E16
   //  M7774/RG6/E22
   //  M7774/RG6/E23
   //  M7774/RG6/E27
   //

   assign rpDS = {dsATA, dsERR, dsPIP, dsMOL, dsWRL, dsLST,
                  dsPGM, dsDPR, dsDRY, dsVV,  6'b0};

endmodule
