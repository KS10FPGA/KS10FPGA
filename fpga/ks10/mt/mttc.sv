////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   MT Tape Control Register (MTTC)
//
// File
//   mttc.v
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

`timescale 1ns/1ps
`default_nettype none

`include "mttc.vh"

module MTTC (
      input  wire          clk,                 // Clock
      input  wire          rst,                 // Reset
      input  wire          mtINIT,              // Initialize
      input  wire  [35: 0] mtDATAI,             // Data In
      input  wire          mtWRTC,              // Write to TC
      input  wire          mtPRESET,            // Read-in preset function
      input  wire          mtFCS,               // Frame count status
      input  wire          mtACCL,              // Accelerate
      output logic [15: 0] mtTC                 // mtTC Output
   );

   //
   // MTTC Acceleration (tcACCL)
   //

   wire tcACCL = mtACCL;

   //
   // MTTC Frame Count Status (tcFCS)
   //

   wire tcFCS = mtFCS;

   //
   // MTTC Slave Access Change (tcSAC)
   //
   // SAC is asserted when the slave selecgt address is modified.
   //
   // Note: SAC is not negated when the slave select address is not changed.
   //

   logic tcSAC;

   always_ff @(posedge clk)
     begin
        if (rst)
          tcSAC <= 0;
        else if (mtWRTC & !tcSAC & (`mtTC_SS(mtDATAI) != `mtTC_SS(mtTC)))
          tcSAC <= 1;
     end

   //
   // MTTC Enable Abort On Data Transfer Errors (tcEAODTE)
   //
   // Trace:
   //  M8905/MBR6/E9
   //

   logic tcEAODTE;

   always_ff @(posedge clk)
     begin
        if (rst)
          tcEAODTE <= 0;
        else if (mtWRTC)
          tcEAODTE <= `mtTC_EAODTE(mtDATAI);
     end

   //
   // MTTC Unused (tcUN11)
   //
   // This register must be read/write to pass diagnostics
   //
   // Trace:
   //  M8905/MBR6/E9
   //

   logic tcUN11;

   always_ff @(posedge clk)
     begin
        if (rst)
          tcUN11 <= 0;
        else if (mtWRTC)
          tcUN11 <= `mtTC_UN11(mtDATAI);
     end

   //
   // MTTC Density Select (tcDEN)
   //
   // Trace:
   //  M8905/MR6/E3
   //  M8905/MR6/E9
   //
   // Note:
   //  I don't understand the documents describing the read-in preset. The docs
   //  say tcDEN should be initialized to 800 BPI NRZI (which is 3).
   //  Initializing tcDEN to 3 fails DSTUA TST106.  The schematic (M8905/MR6)
   //  shows that tcDEN[2:0] is set to 3'b010 by the read-in preset command.
   //  tcDEN[2] is negated by E9 (net C10), tcDEN[1] is asserted by E3 (net C9),
   //  and tcDEN[0] is negated by E9 (net C8).
   //
   //  Anyway. This passes the diagnostics.
   //

   logic [2:0] tcDEN;

   always_ff @(posedge clk)
     begin
        if (rst)
          tcDEN <= 0;
        else if (mtPRESET)
          tcDEN <= 3'd2;
        else if (mtWRTC)
          tcDEN <= `mtTC_DEN(mtDATAI);
     end

   //
   // MTTC Format Select (tcFMT)
   //
   // Trace:
   //  M8905/MBR6/E28
   //  M8905/MBR6/E9
   //

   logic [3:0] tcFMT;

   always_ff @(posedge clk)
     begin
        if (rst | mtPRESET)
          tcFMT <= 0;
        else if (mtWRTC)
          tcFMT <= `mtTC_FMT(mtDATAI);
     end

   //
   // MTTC Format Select (tcEVPAR)
   //
   // Trace:
   //  M8905/MBR6/E28
   //

   logic tcEVPAR;

   always_ff @(posedge clk)
     begin
        if (rst | mtPRESET)
          tcEVPAR <= 0;
        else if (mtWRTC)
          tcEVPAR <= `mtTC_EVPAR(mtDATAI);
     end

   //
   // MTTC Slave Select (tcSS)
   //
   // Trace:
   //  M8905/MBR6/E28
   //

   logic [2:0] tcSS;

   always_ff @(posedge clk)
     begin
        if (rst | mtPRESET)
          tcSS <= 0;
        else if (mtWRTC)
          tcSS <= `mtTC_SS(mtDATAI);
     end

   //
   // Build TC Register
   //

   assign mtTC = {tcACCL, tcFCS, tcSAC, tcEAODTE, tcUN11, tcDEN, tcFMT, tcEVPAR, tcSS};

endmodule
