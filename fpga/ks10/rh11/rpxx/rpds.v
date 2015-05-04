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

`include "rpda.vh"
`include "rpdc.vh"
`include "rpds.vh"

module RPDS(clk, rst, clr, ataCLR, rpCD, rpWP,
            setATA, setERR, setPIP, setLST,
            setPGM, setDPR, setDRY,
            cmdDRVCLR, cmdPRESET, cmdPAKACK, rpDS);

   input          clk;                          // Clock
   input          rst;                          // Reset
   input          clr;                          // Clr
   input          ataCLR;                       // Clr ATA
   input          rpCD;                         // SD Card Detect
   input          rpWP;                         // SD Write Protect
   input          setATA;                       // Set ATA
   input          setERR;                       // Set ERR
   input          setPIP;                       // Set PIP
   input          setLST;                       // Set LST
   input          setPGM;                       // Set PGM
   input          setDPR;                       // Set DPR
   input          setDRY;                       // Set DRY
   input          cmdDRVCLR;                    // Drive clear command
   input          cmdPRESET;                    // Preset command
   input          cmdPAKACK;                    // Pack Ack command
   output [15: 0] rpDS;                         // rpDS register

   //
   // RPDS Attention (rpATA)
   //
   // Trace
   //  M7787/DP2/E57
   //  M7774/RG6/E23
   //  M7774/RG5/E37 (online transition)
   //  M7774/RG5/E39 (online transition)
   //  M7774/RG5/E48 (unload command/Go with composite error)
   //  M7774/RG5/E66
   //  M7774/RG5/E68 (search complete)
   //  M7774/RG5/E81 (position complete)
   //  M7774/RG5/E79 (release command)
   //  M7774/RG5/E80
   //  M7774/RG5/E81 (position complete)
   //  M7774/RG5/E51 (position complete)
   //  M7774/RG5/E57 (position complete)
   //

   reg rpATA;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpATA <= 0;
        else
          if (clr | ataCLR | cmdDRVCLR)
            rpATA <= 0;
          else if (setATA)
            rpATA <= 1;
     end

   //
   // RPDS Error (rpERR)
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

   wire rpERR = setERR;

   //
   // RPDS Positioning In Progress (rpPIP)
   //
   // Trace
   //  M7774/RG3/E77
   //  M7774/RG3/E81
   //  M7774/RG6/E23
   //

   wire rpPIP = setPIP;

   //
   // RPDS Medium On-Line (rpMOL)
   //
   // Trace
   //  M7774/RG6/E23
   //

   wire rpMOL = rpCD;

   //
   // RPDS Write Lock (rpWRL)
   //
   // Trace
   //  M7774/RG6/E16
   //

   wire rpWRL = rpWP;

   //
   // RPDS Last Sector Transferred (rpLST)
   //
   // Trace
   //  M7774/RG6/E16
   //  M7774/RG6/E40
   //

   wire rpLST = setLST;

   //
   // RPDS Programmable (rpPGM)
   //
   // Trace
   //  M7774/DP4/ "PROGRAMMABLE H"
   //  M7774/RG6/E16
   //

   wire rpPGM = setPGM;

   //
   // RPDS Drive Present (rpDPR)
   //
   // Trace
   //  M7774/RG6/E16
   //

   wire rpDPR = setDPR;

   //
   // RPDS Drive Ready (rpDRY)
   //
   // Trace
   //  M7774/RG6/E16
   //

   wire rpDRY = setDRY;

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

   reg rpVV;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpVV <= 0;
        else
          if (clr | !rpCD)
            rpVV <= 0;
          else if (rpCD & (cmdPRESET | cmdPAKACK))
            rpVV <= 1;
     end

   //
   // Build RPDS
   //

   assign rpDS = {rpATA, rpERR, rpPIP, rpMOL, rpWRL, rpLST,
                  rpPGM, rpDPR, rpDRY, rpVV,  6'b0};

endmodule
