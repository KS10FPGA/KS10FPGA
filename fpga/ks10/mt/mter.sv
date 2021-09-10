////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   MT Tape Control Register (MTER)
//
// File
//   mter.v
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

`include "mter.vh"

module MTER (
      input  wire          clk,                 // Clock
      input  wire          rst,                 // Reset
      input  wire          mtINIT,              // MT Initialize
      input  wire          mtSETUNS,            // Unsafe
      input  wire          mtSETOPI,            // Operation incomplete
      input  wire          mtSETDTE,            // Drive timing error
      input  wire          mtSETNEF,            // Non-executable function
      input  wire          mtSETFCE,            // Frame counter error
      input  wire          mtSETDPAR,           // Data parity error
      input  wire          mtSETFMTE,           // Format error
      input  wire          mtSETPAR,            // Parity error
      input  wire          mtSETRMR,            // Register Modification Refused
      input  wire          mtSETILR,            // Illegal register
      input  wire          mtSETILF,            // Illegal function
      output logic [15: 0] mtER                 // mter Output
   );

   //
   // Correctable Data or CRC Error (erCORCRC)
   //
   // Trace:
   //  M8909/MBI10/E58
   //

   wire erCORCRC = 0;

   //
   // Drive timing error (erUNS)
   //
   // Trace:
   //  M8909/MBI10/E58
   //  M8909/MBI11/E60
   //

   logic erUNS;

   always_ff @(posedge clk)
     begin
        if (rst | mtINIT)
          erUNS <= 0;
        else if (mtSETUNS)
          erUNS <= 1;
     end

   //
   // Operation Incomplete (erOPI)
   //
   // Trace:
   //  M8909/MBI10/E58
   //  M8909/MBI11/E65
   //

   logic erOPI;

   always_ff @(posedge clk)
     begin
        if (rst | mtINIT)
          erOPI <= 0;
        else if (mtSETOPI)
          erOPI <= 1;
     end

   //
   // Operation Incomplete (erDTE)
   //
   // Trace:
   //  M8909/MBI10/E58
   //  M8909/MBI11/E65
   //

   logic erDTE;

   always_ff @(posedge clk)
     begin
        if (rst | mtINIT)
          erDTE <= 0;
        else if (mtSETDTE)
          erDTE <= 1;
     end

   //
   // Non-executable function (erNEF)
   //
   // Trace:
   //  M8909/MBI10/E68
   //  M8909/MBI11/E70
   //

   logic erNEF;

   always_ff @(posedge clk)
     begin
        if (rst | mtINIT)
          erNEF <= 0;
        else if (mtSETNEF)
          erNEF <= 1;
     end

   //
   // Correctable skew or illegal tape mark (erCSIMT)
   //
   // Trace:
   //  M8909/MBI10/E82
   //

   wire erCSIMT = 0;

   //
   // Frame counter error (erFCE)
   //
   // Trace:
   //  M8909/MBI10/E68
   //  M8909/MBI11/E70
   //

   logic erFCE;

   always_ff @(posedge clk)
     begin
        if (rst | mtINIT)
          erFCE <= 0;
        else if (mtSETFCE)
          erFCE <= 1;
     end

   //
   // Non-standard gap (erNSG)
   //
   // Trace:
   //  M8909/MBI10/E75
   //  M8909/MBI10/E82
   //

   wire erNSG = 0;

   //
   // PE Format Error/LRC (erPEFLRC)
   //
   // Trace:
   //  M8909/MBI10/E75
   //  M8909/MBI10/E82
   //

   wire erPEFLRC = 0;

   //
   // In-correctable Data / Vertical Parity Error (erINCVPE)
   //
   // Trace:
   //  M8909/MBI9/E75
   //  M8909/MBI9/E82
   //

   wire erINCVPE = 0;

   //
   // Format Error (erDPAR)
   //
   // Trace:
   //  M8909/MBI10/E73
   //  M8909/MBI10/E75
   //

   logic erDPAR;

   always_ff @(posedge clk)
     begin
        if (rst | mtINIT)
          erDPAR <= 0;
        else if (mtSETDPAR)
          erDPAR <= 1;
     end

   //
   // Format Error (erFMTE)
   //
   // Trace:
   //  M8909/MBI10/E73
   //  M8909/MBI10/E75
   //

   logic erFMTE;

   always_ff @(posedge clk)
     begin
        if (rst | mtINIT)
          erFMTE <= 0;
        else if (mtSETFMTE)
          erFMTE <= 1;
     end

   //
   // Parity Error (erPAR)
   //
   // Trace:
   //  M8909/MBI10/E80
   //  M8909/MBI10/E83
   //

   logic erPAR;

   always_ff @(posedge clk)
     begin
        if (rst | mtINIT)
          erPAR <= 0;
        else if (mtSETPAR)
          erPAR <= 1;
     end

   //
   // Register Modification Refused (erRMR)
   //
   // Trace:
   //  M8909/MBI11/E80
   //  M8909/MBI10/E83
   //

   logic erRMR;

   always_ff @(posedge clk)
     begin
        if (rst | mtINIT)
          erRMR <= 0;
        else if (mtSETRMR)
          erRMR <= 1;
     end

   //
   // Illegal Register (erILR)
   //
   // Trace:
   //  M8909/MBI10/E83
   //  M8909/MBI11/E85
   //

   logic erILR;

   always_ff @(posedge clk)
     begin
        if (rst | mtINIT)
          erILR <= 0;
        else if (mtSETILR)
          erILR <= 1;
     end

   //
   // Illegal Function (erILF)
   //
   // Trace:
   //  M8909/MBI10/E83
   //  M8909/MBI11/E85
   //

   logic erILF;

   always_ff @(posedge clk)
     begin
        if (rst | mtINIT)
          erILF <= 0;
        else if (mtSETILF)
          erILF <= 1;
     end

   //
   // Build TC Register
   //

   assign mtER = {erCORCRC, erUNS, erOPI, erDTE, erNEF, erCSIMT, erFCE, erNSG,
                  erPEFLRC, erINCVPE, erDPAR, erFMTE, erPAR, erRMR, erILR, erILF};

endmodule
