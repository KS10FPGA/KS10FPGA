////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KMC11 Interrupt Controller
//
// Details
//   This file provides the implementation of the Interrupt Controller
//
// File
//   kmcintr.v
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

`default_nettype none
`timescale 1ns/1ps

module KMCINTR (
      input  wire clk,          // Clock
      input  wire rst,          // Reset
      input  wire kmcINIT,      // Initialize
      input  wire kmcSETIRQ,    // Edge trigger interrupt
      input  wire kmcIACK,      // Interrupt acknowledge
      output reg  kmcIRQO       // Interrupt request out
   );

   always @(posedge clk)
     begin
        if (rst | kmcINIT | kmcIACK)
          kmcIRQO <= 0;
        else if (kmcSETIRQ)
          kmcIRQO <= 1;
     end

endmodule
