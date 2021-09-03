////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KS10 Unibus Interface Definition
//
// Details
//   This file contains interface definitions for the KS10 IO Buses
//
// File
//   unibus.sv
//
// Note
//   This interface does not even vaguely resemble Unibus, but - it does
//   connect IO devices to the KS10 Unibus Adapter (UBA).
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
// Unibus Interface
//

interface unibus;
   logic         clk;                   // Clock
   logic         rst;                   // Reset
   logic         devRESET;              // Device reset
   logic         devACLO;               // Power fail
   logic         devREQI;               // Request in
   logic         devACKI;               // Acknowledge in
   logic [ 0:35] devADDRI;              // Address in
   logic [ 0:35] devDATAI;              // Data in
   logic         devREQO;               // Request out
   logic         devACKO;               // Acknowledge out
   logic [ 0:35] devADDRO;              // Address out
   logic [ 0:35] devDATAO;              // Data out
   logic [ 7: 4] devINTRO;              // Interrupt out

   //
   // Device Port
   //

   modport device (
      input  clk,                       // Clock
      input  rst,                       // Reset
      input  devRESET,                  // Device reset
      output devACLO,                   // Power fail
      input  devREQI,                   // Request in
      input  devACKI,                   // Acknowledge in
      input  devADDRI,                  // Address in
      input  devDATAI,                  // Data in
      output devREQO,                   // Request out
      output devACKO,                   // Acknowledge out
      output devADDRO,                  // Address out
      output devDATAO,                  // Data out
      output devINTRO                   // Interrupt out
   );

   //
   // UBA Port
   //

   modport uba (
      output clk,                       // Clock
      output rst,                       // Reset
      output devRESET,                  // Device reset
      input  devACLO,                   // Power fail
      output devREQI,                   // Request in
      output devACKI,                   // Acknowledge in
      output devADDRI,                  // Address in
      output devDATAI,                  // Data in
      input  devREQO,                   // Request out
      input  devACKO,                   // Acknowledge out
      input  devADDRO,                  // Address out
      input  devDATAO,                  // Data out
      input  devINTRO                   // Interrupt out
   );

endinterface
