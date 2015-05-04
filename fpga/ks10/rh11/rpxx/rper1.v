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
`include "rper1.vh"

module RPER1(clk, rst, clr,
             setDCK, setUNS, setIOP, setDTE, setWLE, setIAE, setAOE, setHCRC,
             setHCE, setECH, setWCF, setFER, setPAR, setRMR, setILR, setILF,
             rpDATAI, rper1WRITE, rpER1);

   input          clk;                          // Clock
   input          rst;                          // Reset
   input          clr;                          // Clear
   input          setDCK;                       // Set DCK
   input          setUNS;                       // Set UNS
   input          setIOP;                       // Set IOP
   input          setDTE;                       // Set DTE
   input          setWLE;                       // Set WLE
   input          setIAE;                       // Set IAE
   input          setAOE;                       // Set AOE
   input          setHCRC;                      // Set HCRC
   input          setHCE;                       // Set HCE
   input          setECH;                       // Set ECH
   input          setWCF;                       // Set WCF
   input          setFER;                       // Set FER
   input          setPAR;                       // Set PAR
   input          setRMR;                       // Set RMR
   input          setILR;                       // Set ILR
   input          setILF;                       // Set ILF
   input  [35: 0] rpDATAI;                      // Data in
   input          rper1WRITE;                   // Write
   output [15: 0] rpER1;                        // rpER1 register

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
          if (clr)
            rpDCK <= 0;
          else if (setDCK)
            rpDCK <= 1;
          else if (rper1WRITE)
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
          if (clr)
            rpUNS <= 0;
          else if (setUNS)
            rpUNS <= 1;
          else if (rper1WRITE)
            rpUNS <= `rpER1_UNS(rpDATAI);
     end

   //
   // RPER1 Incomplete Operation (rpIOP)
   //
   // Trace
   //  M7774/RG0/E5
   //

   reg rpIOP;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpIOP <= 0;
        else
          if (clr)
            rpIOP <= 0;
          else if (setIOP)
            rpIOP <= 1;
          else if (rper1WRITE)
            rpIOP <= `rpER1_IOP(rpDATAI);
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
          if (clr)
            rpDTE <= 0;
          else if (setDTE)
            rpDTE <= 1;
          else if (rper1WRITE)
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
          if (clr)
            rpWLE <= 0;
          else if (setWLE)
            rpWLE <= 1;
          else if (rper1WRITE)
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
          if (clr)
            rpIAE <= 0;
          else if (setIAE)
            rpIAE <= 1;
          else if (rper1WRITE)
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
          if (clr)
            rpAOE <= 0;
          else if (setAOE)
            rpAOE <= 1;
          else if (rper1WRITE)
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
          if (clr)
            rpHCRC <= 0;
          else if (setHCRC)
            rpHCRC <= 1;
          else if (rper1WRITE)
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
          if (clr)
            rpHCE <= 0;
          else if (setHCE)
            rpHCE <= 1;
          else if (rper1WRITE)
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
          if (clr)
            rpECH <= 0;
          else if (setECH)
            rpECH <= 1;
          else if (rper1WRITE)
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
          if (clr)
            rpWCF <= 0;
          else if (setWCF)
            rpWCF <= 1;
          else if (rper1WRITE)
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
          if (clr)
            rpFER <= 0;
          else if (setFER)
            rpFER <= 1;
          else if (rper1WRITE)
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
          if (clr)
            rpPAR <= 0;
          else if (setPAR)
            rpPAR <= 1;
          else if (rper1WRITE)
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
          if (clr)
            rpRMR <= 0;
          else if (setRMR)
            rpRMR <= 1;
          else if (rper1WRITE)
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
          if (clr)
            rpILR <= 0;
          else if (setILR)
            rpILR <= 1;
          else if (rper1WRITE)
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
          if (clr)
            rpILF <= 0;
          else if (setILF)
            rpILF <= 1;
          else if (rper1WRITE)
            rpILF <= `rpER1_ILF(rpDATAI);
     end

   //
   // Build the RPER1 Register
   //

   assign rpER1 = {rpDCK, rpUNS, rpIOP, rpDTE, rpWLE, rpIAE, rpAOE, rpHCRC,
                   rpHCE, rpECH, rpWCF, rpFER, rpPAR, rpRMR, rpILR, rpILF};

endmodule
