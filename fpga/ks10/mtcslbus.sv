////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KS10 Console to Magtape Interface Bus
//
// Details
//   This file contains interface definitions for Magtape Interface Bus
//
// File
//   mtcslbus.sv
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2021 Rob Doyle
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

//
// MT/CSL Interface
//

interface mtcslbus;
   logic [ 7: 0] mtDPR;                 // Drive present
   logic [ 7: 0] mtMOL;                 // Media on-line
   logic [ 7: 0] mtWRL;                 // Write lock
   logic         mtWRLO;                // Write to low 32 bit (addr 0x60 / bits[32:63])
   logic         mtWRHI;                // Write to hi 32 bits (addr 0x64 / bits[ 0:31])
   logic [ 3: 0] mtWSTRB;               // Byte lane select
   logic [31: 0] mtDATAI;               // AXI bus data in
   logic [63: 0] mtDIRO;                // Data Interface Register Out
   logic [ 0:35] mtWDAT;                // Write data
   logic [63: 0] mtDEBUG;               // Debug Register

   //
   // CSL Port
   //

   modport csl (
      output mtDPR,                     // Drive present
      output mtMOL,                     // Media on-line
      output mtWRL,                     // Write lock
      output mtWRLO,                    // Write to lo 32 bits (addr 0x60 / bits[32:63])
      output mtWRHI,                    // Write to hi 32 bits (addr 0x64 / bits[ 0:31])
      output mtWSTRB,                   // Byte lane select
      output mtDATAI,                   // AXI bus data in
      input  mtDIRO,                    // Data Interface Register Out
      output mtWDAT,                    // Write data
      input  mtDEBUG                    // Debug Register
   );

   //
   // MT Port
   //

   modport mt (
      input  mtDPR,                     // Drive present
      input  mtMOL,                     // Media on-line
      input  mtWRL,                     // Write lock
      input  mtWRLO,                    // Write to lo 32 bits (addr 0x60 / bits[32:63])
      input  mtWRHI,                    // Write to hi 32 bits (addr 0x64 / bits[ 0:31])
      input  mtWSTRB,                   // Byte lane select
      input  mtDATAI,                   // Data in
      input  mtWDAT,                    // Write data
      output mtDIRO,                    // Data Interface Register Out
      output mtDEBUG                    // Debug Register
   );

endinterface
