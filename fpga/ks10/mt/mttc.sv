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
      input  wire          mtINIT,              // MT Initialize
      input  wire  [35: 0] mtDATAI,             // MT Data In
      input  wire          mtWRTC,              // Write to TC
      input wire           mtSETFCS,            // MT Set FCS bit
      input wire           mtCLRFCS,            // MT Clear FCS bit
      output logic [15: 0] mtTC                 // mtTC Output
   );

   //
   // MTTC Acceleration (tcACCEL)
   //

   wire tcACCEL = 1;

   //
   // MTTC Frame Count Status (tcFCS)
   //

   logic tcFCS;

   always_ff @(posedge clk)
     begin
        if (rst | mtINIT | mtCLRFCS)
          tcFCS <= 0;
        else if (mtSETFCS)
          tcFCS <= 1;
     end

   //
   // MTTC Tape Control Write (tcTCW)
   //

   logic tcTCW;

   always_ff @(posedge clk)
     begin
        if (rst)
          tcTCW <= 0;
        else if (mtWRTC)
          tcTCW <= `mtTC_TCW(mtDATAI);
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
   //  M8905/MBR6/E3
   //  M8905/MBR6/E9
   //

   logic [2:0] tcDEN;

   always_ff @(posedge clk)
     begin
        if (rst)
          tcDEN <= 0;
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
        if (rst)
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
        if (rst)
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
        if (rst)
          tcSS <= 0;
        else if (mtWRTC)
          tcSS <= `mtTC_SS(mtDATAI);
     end

   //
   // Build TC Register
   //

   assign mtTC = {tcACCEL, tcFCS, tcTCW, tcEAODTE, tcUN11, tcDEN, tcFMT, tcEVPAR, tcSS};

endmodule
