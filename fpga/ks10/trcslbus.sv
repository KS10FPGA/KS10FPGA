////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KS10 Console to Trace Device Interface
//
// Details
//   This file contains interface definitions Trace Device.
//
// File
//   trcslbus.sv
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2022 Rob Doyle
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
// TR/CSL Interface
//

interface trcslbus;
   logic        clk;            // Clock
   logic        rst;            // Reset
   logic        trCLR;          // Clear buffer
   logic        trADV;          // Advance tracebuffer
   logic [0:63] trITR;          // Instruction Trace Register
   logic [0:63] trPCIR;         // Program Counter and Instruction Register

   //
   // CSL Port
   //

   modport csl (
      output clk,               // Clock
      output rst,               // Reset
      output trCLR,             // Clear Buffer
      output trADV,             // Advance Trace Buffer
      input  trITR,             // Instruction Trace Register
      input  trPCIR             // Program Counter and Instruction Register
   );

   //
   // TR Port
   //

   modport tr (
      input  clk,               // Clock
      input  rst,               // Reset
      input  trCLR,             // Clear Buffer
      input  trADV,             // Advance Trace Buffer
      output trITR,             // Instruction Trace Register
      output trPCIR             // Program Counter and Instruction Register
   );

endinterface
