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
// Copyright (C) 2012-2014 Rob Doyle
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

`include "rpda.vh"
`include "rpdc.vh"
`include "rpds.vh"
`include "rper1.vh"

  module RPER1(clk, rst, clr, lastSECTOR, lastTRACK, lastCYL,
	       state, stateCLEAR, stateINVADDR, stateILLFUN, stateWRLOCK, 
	       rpDATAI, rpcs1WRITE, rpdaWRITE, rpofWRITE, rpdcWRITE,
	       rper1WRITE, incSECTOR, rpDS, rpDA, rpDC, rpER1); 

   input          clk;                          // Clock
   input          rst;                          // Reset
   input          clr;                          // Clear
   input  [ 5: 0] lastSECTOR;                   // Last sector number
   input  [ 5: 0] lastTRACK;                    // Last track number
   input  [ 9: 0] lastCYL;                      // Last cylinder number
   input  [ 4: 0] state;                        // State
   input  [ 4: 0] stateCLEAR;                   // StateCLEAR
   input  [ 4: 0] stateINVADDR;			// stateINVADDR
   input  [ 4: 0] stateILLFUN;			// stateILLFUN
   input  [ 4: 0] stateWRLOCK;			// StateWRLOCK
   input  [35: 0] rpDATAI;                      // RP Data In
   input          rpcs1WRITE;			// Write CS1 register
   input 	  rpdaWRITE;			// Write DA register
   input 	  rpofWRITE;			// Write OF register
   input 	  rpdcWRITE;			// Write DC register
   input          rper1WRITE;			// Write ER1 register
   input          incSECTOR;			// Increment sector
   input  [15: 0] rpDS;                         // rpDS register
   input  [15: 0] rpDA;                         // rpDA register
   input  [15: 0] rpDC;                         // rpDC register
   output [15: 0] rpER1;                        // rpER1 register

   //
   // RPER1 Data Check (rpDCK)
   //
   // Trace
   //

   reg [5:0] rpDCK;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpDCK <= 0;
	else
	  if (clr | (state == stateCLEAR))
            rpDCK <= 0;
	  else if (rper1WRITE)
	    rpDCK <= `rpER1_DCK(rpDATAI);
     end

   //
   // RPER1 Unsafe (rpUNS)
   //
   // Trace
   //

   reg [5:0] rpUNS;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpUNS <= 0;
	else
	  if (clr | (state == stateCLEAR))
            rpUNS <= 0;
	  else if (rper1WRITE)
	    rpUNS <= `rpER1_UNS(rpDATAI);
     end

   //
   // RPER1 Operation Incomplete (rpOPI)
   //
   // Trace
   //

   reg [5:0] rpOPI;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpOPI <= 0;
	else
	  if (clr | (state == stateCLEAR))
            rpOPI <= 0;
	  else if (rper1WRITE)
	    rpOPI <= `rpER1_OPI(rpDATAI);
     end

   //
   // RPER1 Drive Timing Error (rpDTE)
   //
   // Trace
   //

   reg [5:0] rpDTE;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpDTE <= 0;
	else
	  if (clr | (state == stateCLEAR))
            rpDTE <= 0;
	  else if (rper1WRITE)
	    rpDTE <= `rpER1_DTE(rpDATAI);
     end
   
   //
   // RPER1 Write Lock Error (rpWLE)
   //
   // Trace
   //

   reg [5:0] rpWLE;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpWLE <= 0;
	else
	  if (clr | (state == stateCLEAR))
            rpWLE <= 0;
	  else if (rper1WRITE)
	    rpWLE <= `rpER1_WLE(rpDATAI);
	  else if (state == stateWRLOCK)
            rpWLE <= 1;
     end

   //
   // RPER1 Invalid Address Error (rpIAE)
   //
   // Trace
   //

   reg [5:0] rpIAE;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpIAE <= 0;
	else
	  if (clr | (state == stateCLEAR))
            rpIAE <= 0;
	  else if (rper1WRITE)
	    rpIAE <= `rpER1_IAE(rpDATAI);
	  else if (state == stateINVADDR)
            rpIAE <= 1;
     end
   
   //
   // RPER1 Address Overflow Error (rpAOE)
   //
   // Trace
   //

   reg [5:0] rpAOE;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpAOE <= 0;
	else
	  if (clr | (state == stateCLEAR))
            rpAOE <= 0;
	  else if (rper1WRITE)
	    rpAOE <= `rpER1_AOE(rpDATAI);
	  else if (incSECTOR  & (`rpDA_SA(rpDA) == lastSECTOR) & (`rpDA_TA(rpDA) == lastTRACK) & (`rpDC_DCA(rpDC) == lastCYL))
            rpAOE <= 1;
     end
   
   //
   // RPER1 Header CRC Error (rpHCRC)
   //
   // Trace
   //

   reg [5:0] rpHCRC;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpHCRC <= 0;
	else
	  if (clr | (state == stateCLEAR))
            rpHCRC <= 0;
	  else if (rper1WRITE)
	    rpHCRC <= `rpER1_HCRC(rpDATAI);
     end
     
   //
   // RPER1 Header Compare Error (rpHCE)
   //
   // Trace
   //

   reg [5:0] rpHCE;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpHCE <= 0;
	else
	  if (clr | (state == stateCLEAR))
            rpHCE <= 0;
	  else if (rper1WRITE)
	    rpHCE <= `rpER1_HCE(rpDATAI);
     end
    
   //
   // RPER1 ECC Hard Failure Error (rpECH)
   //
   // Trace
   //

   reg [5:0] rpECH;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpECH <= 0;
	else
	  if (clr | (state == stateCLEAR))
            rpECH <= 0;
	  else if (rper1WRITE)
	    rpECH <= `rpER1_ECH(rpDATAI);
     end

   //
   // RPER1 Write Clock Fail Error (rpWCF)
   //
   // Trace
   //

   reg [5:0] rpWCF;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpWCF <= 0;
	else
	  if (clr | (state == stateCLEAR))
            rpWCF <= 0;
	  else if (rper1WRITE)
	    rpWCF <= `rpER1_WCF(rpDATAI);
     end

   //
   // RPER1 Format Error (rpFER)
   //
   // Trace
   //

   reg [5:0] rpFER;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpFER <= 0;
	else
	  if (clr | (state == stateCLEAR))
            rpFER <= 0;
	  else if (rper1WRITE)
	    rpFER <= `rpER1_FER(rpDATAI);
     end
  
   //
   // RPER1 Parity Error (rpPAR)
   //
   // Trace
   //

   reg [5:0] rpPAR;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpPAR <= 0;
	else
	  if (clr | (state == stateCLEAR))
            rpPAR <= 0;
	  else if (rper1WRITE)
	    rpPAR <= `rpER1_PAR(rpDATAI);
     end
  
   //
   // RPER1 Register Modification Refused (rpRMR)
   //
   // Trace
   //

   reg [5:0] rpRMR;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpRMR <= 0;
	else
	  if (clr | (state == stateCLEAR))
            rpRMR <= 0;
	  else if (rper1WRITE)
	    rpRMR <= `rpER1_RMR(rpDATAI);
	  else if (!`rpDS_DRY(rpDS))
            if (rpcs1WRITE | rper1WRITE | rpdaWRITE |  rpofWRITE | rpdcWRITE)
              rpRMR <= 1;
     end
  
   //
   // RPER1 Illegal Register (rpILR)
   //
   // Trace
   //

   reg [5:0] rpILR;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpILR <= 0;
	else
	  if (clr | (state == stateCLEAR))
            rpILR <= 0;
	  else if (rper1WRITE)
	    rpILR <= `rpER1_ILR(rpDATAI);
     end

   //
   // RPER1 Illegal Function (rpILF)
   //
   // Trace
   //

   reg [5:0] rpILF;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rpILF <= 0;
	else
	  if (clr | (state == stateCLEAR))
            rpILF <= 0;
	  else if (rper1WRITE)
	    rpILF <= `rpER1_ILF(rpDATAI);
	  else if (state == stateILLFUN)
            rpILF <= 1;
     end
   
   //
   // Build the RPER1 Register
   //
   
   assign rpER1 = {rpDCK, rpUNS, rpOPI, rpDTE, rpWLE, rpIAE, rpAOE, rpHCRC,
                   rpHCE, rpECH, rpWCF, rpFER, rpPAR, rpRMR, rpILR, rpILF};

endmodule
