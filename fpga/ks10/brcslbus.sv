////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KS10 Console to Breakpoint Device Interface
//
// Details
//   This file contains interface definitions for Breakpoint Device.
//
// File
//   brcslbus.sv
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
// BR/CSL Interface
//

interface brcslbus;
   logic        clk;                    // Clock
   logic        rst;                    // Reset
   logic [0:35] regBRAR[0:3];           // Breakpoint Address Registers
   logic [0:35] regBRMR[0:3];           // Breakpoint Mask Registers

   //
   // CSL Port
   //

   modport csl (
      output clk,                       // Clock
      output rst,                       // Reset
      output regBRAR,                   // Breakpoint Address Registers
      output regBRMR                    // Breakpoint Mask Registers
   );

   //
   // BR Port
   //

   modport br (
      input  clk,                       // Clock
      input  rst,                       // Reset
      input  regBRAR,                   // Breakpoint Address Registers
      input  regBRMR                    // Breakpoint Mask Registers
   );

endinterface
