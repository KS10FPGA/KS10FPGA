////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RH11 CS1 Register
//
// Details
//
//
// Note
//   Please read the white pager entited "PDP-11 Interrupts: Variations On A
//   Theme", Bob Supnik, 03-Feb-2002 [revised 20-Feb-2004]
//
//   As state in that paper, the correct interrupt controller is as follows:
//
//
//                   +-------+         +-------+
//   IE ------------>|D     Q|-------->|  >=1  |
//                   |       |         |       |------- Interrupt Request
//   RDY------------>|C  R   |    +--->|OR Gate|
//                   +---^---+    |    +-------+
//                       |        |
//   INIT + IAK----------+        |
//                                |
//   ATA + RDY + IE --------------+
//
//
// File
//   rhCS1.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2012-2014 Rob Doyle
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
`include "bus.vh"
`include "rhcs1.vh"
`include "rhcs2.vh"
`include "rpds.vh"
`include "rpxx.vh"

module RHCS1(clk, rst,
             devRESET, devADDRI, rhDATAI,
             rhINTA, rhDEV, rhCLR, rhCS2, rhBA, rhFUN, rhGO,
             rpDS0, rpDS1, rpDS2, rpDS3, rpDS4, rpDS5, rpDS6, rpDS7,
             rhCS1);

   input          clk;                          // Clock
   input          rst;                          // Reset
   input          devRESET;                     // Device Reset
   input  [ 0:35] devADDRI;                     // Device Address In
   input  [35: 0] rhDATAI;                      // Data Input
   input          rhINTA;                       // Interrupt acknowledge
   input  [14:17] rhDEV;                        // Device number
   input          rhCLR;                        // Controller Clear
   input  [15: 0] rhCS2;                        // RHCS2 Register
   input  [17: 0] rhBA;                         // RHBA Register
   input  [ 5: 1] rhFUN;                        // Function from RPxx
   input          rhGO;                         // Go from RPxx
   input  [15: 0] rpDS0;                        // Disk 0 RPDS Register
   input  [15: 0] rpDS1;                        // Disk 1 RPDS Register
   input  [15: 0] rpDS2;                        // Disk 2 RPDS Register
   input  [15: 0] rpDS3;                        // Disk 3 RPDS Register
   input  [15: 0] rpDS4;                        // Disk 4 RPDS Register
   input  [15: 0] rpDS5;                        // Disk 5 RPDS Register
   input  [15: 0] rpDS6;                        // Disk 6 RPDS Register
   input  [15: 0] rpDS7;                        // Disk 7 RPDS Register
   output [15: 0] rhCS1;                        // RHCS1 Register
   output         rhINTR;                       // RH Interrupt Request

   //
   // Register Addresses
   //




   //
   // Address decoder
   //

   wire         devREAD   = `devREAD(devADDRI);   // Read cycle (IO or Memory)
   wire         devWRITE  = `devWRITE(devADDRI);  // Write cycle (IO or Memory)
   wire         devIO     = `devIO(devADDRI);     // IO cycle
   wire         devIOBYTE = `devIOBYTE(devADDRI); // IO byte cycle
   wire [14:17] devDEV    = `devDEV(devADDRI);    // Device Number
   wire [18:34] devADDR   = `devADDR(devADDRI);   // Device Address
   wire         devHIBYTE = `devHIBYTE(devADDRI); // High byte
   wire         devLOBYTE = `devLOBYTE(devADDRI); // Low byte

   //
   // Write decoder
   //

   wire rhcs1WRITE = devWRITE & devIO & (devDEV == rhDEV) & (devADDR == cs1ADDR[18:34]);
   wire rhcs2WRITE = devWRITE & devIO & (devDEV == rhDEV) & (devADDR == cs2ADDR[18:34]);

   //
   // Constant register bits
   //

   wire rhMCPE = 0;                             // Massbus Control Parity Error
   wire rhDVA  = 1;                             // Drive available
   wire rhPSEL = 0;                             // Port select

   //
   // History
   //

   reg lastWCE;
   reg lastPE;
   reg lastNEM;
   reg lastPGE;
   reg lastMXF;
   reg lastRDY;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             lastWCE <= 0;
             lastPE  <= 0;
             lastNEM <= 0;
             lastPGE <= 0;
             lastMXF <= 0;
             lastRDY <= 0;
          end
        else if (rhCLR | devRESET)
          begin
             lastWCE <= 0;
             lastPE  <= 0;
             lastNEM <= 0;
             lastPGE <= 0;
             lastMXF <= 0;
             lastRDY <= 0;
          end
        else
          begin
             lastWCE <= rhCS2[`rhCS2_WCE];
             lastPE  <= rhCS2[`rhCS2_PE ];
             lastNEM <= rhCS2[`rhCS2_NEM];
             lastPGE <= rhCS2[`rhCS2_PGE];
             lastMXF <= rhCS2[`rhCS2_MXF];
             lastRDY <= rhRDY;
          end
     end

   //
   // Transfer Error
   //

   reg  rhTRE;
   wire clrFUN = rhcs1WRITE & devLOBYTE & rhDATAI[`rhCS1_GO ] & (rhDATAI[`rhCS1_FUN] == `funCLEAR) & rhRDY;
   wire clrTRE = rhcs1WRITE & devHIBYTE & rhDATAI[`rhCS1_TRE];
   wire setTRE = ((rhCS2[`rhCS2_WCE] & ~lastWCE) |
                  (rhCS2[`rhCS2_PE ] & ~lastPE ) |
                  (rhCS2[`rhCS2_NEM] & ~lastNEM) |
                  (rhCS2[`rhCS2_PGE] & ~lastNEM) |
                  (rhCS2[`rhCS2_MXF] & ~lastMXF));

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rhTRE <= 0;
        else if (rhCLR | devRESET | clrTRE | clrFUN)
          rhTRE <= 0;
        else if (setTRE)
          rhTRE <= 1;
     end

   //
   // Ready
   //

   reg  rhRDY;
   wire clrRDY = rhcs1WRITE & devLOBYTE & ~rhDATAI[`rhCS1_RDY];
   wire setRDY = rhcs1WRITE & devLOBYTE &  rhDATAI[`rhCS1_RDY];

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rhRDY <= 0;
        else if (rhCLR | devRESET | clrRDY)
          rhRDY <= 0;
        else if (setRDY)
          rhRDY <= 1;
     end

   //
   // Interrupt Enable
   //

   reg  rhIE;
   wire clrIE = rhcs1WRITE & devLOBYTE & ~rhDATAI[`rhCS1_IE];
   wire setIE = rhcs1WRITE & devLOBYTE &  rhDATAI[`rhCS1_IE];

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rhIE <= 0;
        else if (rhCLR | devRESET | clrIE)
          rhIE <= 0;
        else if (setIE)
          rhIE <= 1;
     end

   //
   // Interrupt Flip-flop
   //
   //  The interrupt flip-flop is asserted under the following conditions:
   //  1.  Writing IE and RDY simultaneously
   //  2.  RDY transitions from 0 to 1 when IE is asserted
   //
   //  The interrupt is cleared under the following conditions:
   //  1.  Interrupt acknowledge
   //  2.  rhCLR
   //

   reg rhIFF;
   wire setIFF = ((rhRDY & ~lastRDY & rhIE) |
                  (rhcs1WRITE & devLOBYTE & rhDATAI[`rhCS1_RDY] & rhDATAI[`rhCS1_IE]));

   always @(posedge clk or posedge rst)
     begin
        if (rst)
           rhIFF <= 0;
        else
           begin
             if (rhCLR | devRESET | rhINTA)
               rhIFF <= 0;
             else if (setIFF)
               rhIFF <= 1;
           end
     end

   //
   // Special Conditions
   //

   wire rhSC = rpDS0[`rpDS_ATA] | rpDS1[`rpDS_ATA] | rpDS2[`rpDS_ATA] | rpDS3[`rpDS_ATA] |
               rpDS4[`rpDS_ATA] | rpDS5[`rpDS_ATA] | rpDS6[`rpDS_ATA] | rpDS7[`rpDS_ATA] |
               rhTRE;

   //
   // Create Interrupt
   //

   assign rhINTR = rhIFF | (rhSC & rhIE & rhRDY);


   //
   // Create RHCS1 register
   //

   assign rhCS1 = {rhSC, rhTRE, rhMCPE, 1'b0, rhDVA, rhPSEL, rhBA[17:16], rhRDY, rhIE, rhFUN, rhGO};

endmodule
