////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KS10 Backplne Bus Definition
//
// Details
//   This file contains interface definitions for the KS10 Backplane Bus
//
// File
//   ks10bus.sv
//
// Note
//   This interface is relativly similar to the KS10 Backplane Bus.  It
//   is different because the address and data parts of the backplane
//   bus are not multiplexed.  This greatly improves bus bandwidth and
//   reduces latency.
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
// KS10bus Interface
//

interface ks10bus;
   logic         busREQI;               // Request in
   logic         busACKI;               // Acknowledge in
   logic [ 0:35] busADDRI;              // Address in
   logic [ 0:35] busDATAI;              // Data in
   logic [ 1: 7] busINTRI;              // Interrupt in
   logic         busREQO;               // Request out
   logic         busACKO;               // Acknowledge out
   logic [ 0:35] busADDRO;              // Address out
   logic [ 0:35] busDATAO;              // Data out
   logic [ 1: 7] busINTRO;              // Interrupt out

   //
   // Master Port
   //

   modport device (
      input  busREQI,                   // Request in
      input  busACKI,                   // Acknowledge in
      input  busADDRI,                  // Address in
      input  busDATAI,                  // Data in
      input  busINTRI,                  // Interrupt in
      output busREQO,                   // Request out
      output busACKO,                   // Acknowledge out
      output busADDRO,                  // Address out
      output busDATAO,                  // Data out
      output busINTRO                   // Interrupt out
   );

   //
   // Arbiter Port
   //

   modport arbiter (
      output busREQI,                   // Request in
      output busACKI,                   // Acknowledge in
      output busADDRI,                  // Address in
      output busDATAI,                  // Data in
      output busINTRI,                  // Interrupt in
      input  busREQO,                   // Request out
      input  busACKO,                   // Acknowledge out
      input  busADDRO,                  // Address out
      input  busDATAO,                  // Data out
      input  busINTRO                   // Interrupt out
   );

endinterface
