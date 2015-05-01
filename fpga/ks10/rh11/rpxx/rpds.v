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

module RPDS(clk, rst, clr, ataCLR, lastSECTOR, lastTRACK, lastCYL, rpCD, rpWP,
            state, stateATA, stateCLEAR, stateIDLE, stateOFFSET,
            statePRESET, statePAKACK, stateCENTER, stateSEEKDLY,
            rpDA, rpDC, rpER1, rpER2, rpER3, rpDS);

   input          clk;                          // Clock
   input          rst;                          // Reset
   input          clr;                          // Clear
   input          ataCLR;                       // Clear attention
   input  [ 5: 0] lastSECTOR;                   // Last sector number
   input  [ 5: 0] lastTRACK;                    // Last track number
   input  [ 9: 0] lastCYL;                      // Last cylinder number
   input          rpCD;                         // RP Card Detected
   input          rpWP;                         // RP Card Write Protected
   input  [ 4: 0] state;                        // State
   input  [ 4: 0] stateATA;                     // StateATA
   input  [ 4: 0] stateCLEAR;                   // StateCLEAR
   input  [ 4: 0] stateIDLE;                    // StateIDLE
   input  [ 4: 0] stateOFFSET;                  // StateOFFSET
   input  [ 4: 0] statePRESET;                  // StatePRESET
   input  [ 4: 0] statePAKACK;                  // StatePAKACK
   input  [ 4: 0] stateCENTER;                  // StateCENTER
   input  [ 4: 0] stateSEEKDLY;                 // StateSEELDLY
   input  [15: 0] rpDA;                         // rpDA register
   input  [15: 0] rpDC;                         // rpDC register
   input  [15: 0] rpER1;                        // rpER1 register
   input  [15: 0] rpER2;                        // rpER2 register
   input  [15: 0] rpER3;                        // rpER3 register
   output [15: 0] rpDS;                         // rpDS register

   //
   // RPDS Attention (rpATA)
   //
   // Trace
   //  M7787/DP2/E57
   //  M7774/RG6/E23
   //

   reg rpATA;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpATA <= 0;
        else
          if (clr | ataCLR | (state == stateCLEAR))
            rpATA <= 0;
          else if (state == stateATA)
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

   wire rpERR = ((rpER1 != 0) |
                 (rpER2 != 0) |
                 (rpER3 != 0));

   //
   // RPDS Positioning In Progress (rpPIP)
   //
   // Trace
   //  M7774/RG3/E77
   //  M7774/RG3/E81
   //  M7774/RG6/E23
   //

   wire rpPIP = (state == stateSEEKDLY);

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

   wire rpLST = (`rpDA_SA(rpDA) == lastSECTOR) & (`rpDA_TA(rpDA) == lastTRACK) & (`rpDC_DCA(rpDC) == lastCYL);

   //
   // RPDS Programmable (rpPGM)
   //
   // Trace
   //  M7774/DP4/ "PROGRAMMABLE H"
   //  M7774/RG6/E16
   //

   wire rpPGM = 1'b0;

   //
   // RPDS Drive Present (rpDPR)
   //
   // Trace
   //  M7774/RG6/E16
   //

   wire rpDPR = 1'b1;

   //
   // RPDS Drive Ready (rpDRY)
   //
   // Trace
   //  M7774/RG6/E16
   //

   wire rpDRY = (state == stateIDLE);

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
          if (clr)
            rpVV <= 0;
          else
            case (state)
              stateIDLE:
                rpVV <= rpVV & rpCD;
              statePRESET:
                rpVV <= rpCD;
              statePAKACK:
                rpVV <= rpCD;
            endcase
     end

   //
   // RPDS Offset Mode (rpOM)
   //
   // Trace
   //  FIXME
   //

   reg rpOM;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpOM <= 0;
        else
          if (clr)
            rpOM <= 0;
          else
            case (state)
              stateOFFSET:
                rpOM <= 1;
              stateCENTER:
                rpOM <= 0;
            endcase
     end

   //
   // Build RPDS
   //

   assign rpDS = {rpATA, rpERR, rpPIP, rpMOL, rpWRL, rpLST,
                  rpPGM, rpDPR, rpDRY, rpVV,  5'b0,  rpOM};

endmodule
