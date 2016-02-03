////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RPxx Error Register #1 (RPER1)
//
// File
//   rper1.v
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

`include "rpda.vh"
`include "rpdc.vh"
`include "rpds.vh"
`include "rper1.vh"

module RPER1 (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire         clr,                  // Clear
      input  wire         rpDRVCLR,             // Drive clear command
      input  wire         rpSETDCK,             // Set data check error
      input  wire         rpSETOPI,             // Set operation incomplete
      input  wire         rpSETDTE,             // Set drive timing error
      input  wire         rpSETWLE,             // Set write lock error
      input  wire         rpSETIAE,             // Set invalid address error
      input  wire         rpSETAOE,             // Set address overflow error
      input  wire         rpSETPAR,             // Set parity error
      input  wire         rpSETRMR,             // Set register modification refused
      input  wire         rpSETILF,             // Set illegal function
      input  wire         rpSETHCRC,            // Set header CRC error
      input  wire [35: 0] rpDATAI,              // Data in
      input  wire         rper1WRITE,           // Write ER1
      input  wire         rpHCI,                // Header compare inhibit
      input  wire         rpDRY,                // Drive ready
      output wire [15: 0] rpER1                 // rpER1 register
   );

   //
   // RPER1 Data Check (rpDCK)
   //
   // Trace
   //  M7774/RG0/E18
   //

   reg rpDCK;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpDCK <= 0;
        else
          if (clr | rpDRVCLR)
            rpDCK <= 0;
          else if (rpSETDCK)
            rpDCK <= 1;
          else if (rper1WRITE & rpDRY)
            rpDCK <= `rpER1_DCK(rpDATAI);
     end

   //
   // RPER1 Unsafe (rpUNS)
   //
   // Trace
   //  M7774/RG0/E15
   //

   reg rpUNS;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpUNS <= 0;
        else
          if (clr | rpDRVCLR)
            rpUNS <= 0;
          else if (rper1WRITE & rpDRY)
            rpUNS <= `rpER1_UNS(rpDATAI);
     end

   //
   // RPER1 Operation Incomplete (rpOPI)
   //
   // Trace
   //  M7774/RG0/E5
   //

   reg rpOPI;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpOPI <= 0;
        else
          if (clr | rpDRVCLR)
            rpOPI <= 0;
          else if (rpSETOPI)
            rpOPI <= 1;
          else if (rper1WRITE & rpDRY)
            rpOPI <= `rpER1_OPI(rpDATAI);
     end

   //
   // RPER1 Drive Timing Error (rpDTE)
   //
   // Trace
   //  M7774/RG0/E5
   //

   reg rpDTE;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpDTE <= 0;
        else
          if (clr | rpDRVCLR)
            rpDTE <= 0;
          else if (rpSETDTE)
            rpDTE <= 1;
          else if (rper1WRITE & rpDRY)
            rpDTE <= `rpER1_DTE(rpDATAI);
     end

   //
   // RPER1 Write Lock Error (rpWLE)
   //
   // Trace
   //  M7774/RG0/E3
   //

   reg rpWLE;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpWLE <= 0;
        else
          if (clr | rpDRVCLR)
            rpWLE <= 0;
          else if (rpSETWLE)
            rpWLE <= 1;
          else if (rper1WRITE & rpDRY)
            rpWLE <= `rpER1_WLE(rpDATAI);
     end

   //
   // RPER1 Invalid Address Error (rpIAE)
   //
   // Trace
   //  M7774/RG0/E3
   //

   reg rpIAE;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpIAE <= 0;
        else
          if (clr | rpDRVCLR)
            rpIAE <= 0;
          else if (rpSETIAE)
            rpIAE <= 1;
          else if (rper1WRITE & rpDRY)
            rpIAE <= `rpER1_IAE(rpDATAI);
     end

   //
   // RPER1 Address Overflow Error (rpAOE)
   //
   // Trace
   //  M7774/RG0/E9
   //

   reg rpAOE;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpAOE <= 0;
        else
          if (clr | rpDRVCLR)
            rpAOE <= 0;
          else if (rpSETAOE)
            rpAOE <= 1;
          else if (rper1WRITE & rpDRY)
            rpAOE <= `rpER1_AOE(rpDATAI);
     end

   //
   // RPER1 Header CRC Error (rpHCRC)
   //
   // Trace
   //  M7774/RG0/E9
   //

   reg rpHCRC;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpHCRC <= 0;
        else
          if (clr | rpDRVCLR)
            rpHCRC <= 0;
          else if (rpSETHCRC & !rpHCI)
            rpHCRC <= 1;
          else if (rper1WRITE & rpDRY)
            rpHCRC <= `rpER1_HCRC(rpDATAI);
     end

   //
   // RPER1 Header Compare Error (rpHCE)
   //
   // Trace
   //  M7774/RG0/E13
   //

   reg rpHCE;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpHCE <= 0;
        else
          if (clr | rpDRVCLR)
            rpHCE <= 0;
          else if (rper1WRITE & rpDRY)
            rpHCE <= `rpER1_HCE(rpDATAI);
     end

   //
   // RPER1 ECC Hard Failure Error (rpECH)
   //
   // Trace
   //  M7774/RG0/E10
   //

   reg rpECH;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpECH <= 0;
        else
          if (clr | rpDRVCLR)
            rpECH <= 0;
          else if (rper1WRITE & rpDRY)
            rpECH <= `rpER1_ECH(rpDATAI);
     end

   //
   // RPER1 Write Clock Fail Error (rpWCF)
   //
   // Trace
   //  M7774/RG0/E10
   //

   reg rpWCF;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpWCF <= 0;
        else
          if (clr | rpDRVCLR)
            rpWCF <= 0;
          else if (rper1WRITE & rpDRY)
            rpWCF <= `rpER1_WCF(rpDATAI);
     end

   //
   // RPER1 Format Error (rpFER)
   //
   // Trace
   //  M7774/RG0/E14
   //

   reg rpFER;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpFER <= 0;
        else
          if (clr | rpDRVCLR)
            rpFER <= 0;
          else if (rper1WRITE & rpDRY)
            rpFER <= `rpER1_FER(rpDATAI);
     end

   //
   // RPER1 Parity Error (rpPAR)
   //
   // Trace
   //  M7774/RG0/E15
   //

   reg rpPAR;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpPAR <= 0;
        else
          if (clr | rpDRVCLR)
            rpPAR <= 0;
          else if (rpSETPAR)
            rpPAR <= 1;
          else if (rper1WRITE & rpDRY)
            rpPAR <= `rpER1_PAR(rpDATAI);
     end

   //
   // RPER1 Register Modification Refused (rpRMR)
   //
   // Trace
   //  M7774/RG0/E14
   //

   reg rpRMR;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpRMR <= 0;
        else
          if (clr | rpDRVCLR)
            rpRMR <= 0;
          else if (rpSETRMR)
            rpRMR <= 1;
          else if (rper1WRITE & rpDRY)
            rpRMR <= `rpER1_RMR(rpDATAI);
     end

   //
   // RPER1 Illegal Register (rpILR)
   //
   // Trace
   //  M7774/RG0/E24
   //

   reg rpILR;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpILR <= 0;
        else
          if (clr | rpDRVCLR)
            rpILR <= 0;
          else if (rper1WRITE & rpDRY)
            rpILR <= `rpER1_ILR(rpDATAI);
     end

   //
   // RPER1 Illegal Function (rpILF)
   //
   // Trace
   //  M7774/RG0/E24
   //

   reg rpILF;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpILF <= 0;
        else
          if (clr | rpDRVCLR)
            rpILF <= 0;
          else if (rpSETILF)
            rpILF <= 1;
          else if (rper1WRITE & rpDRY)
            rpILF <= `rpER1_ILF(rpDATAI);
     end

   //
   // Build the RPER1 Register
   //

   assign rpER1 = {rpDCK, rpUNS, rpOPI, rpDTE, rpWLE, rpIAE, rpAOE, rpHCRC,
                   rpHCE, rpECH, rpWCF, rpFER, rpPAR, rpRMR, rpILR, rpILF};

endmodule
