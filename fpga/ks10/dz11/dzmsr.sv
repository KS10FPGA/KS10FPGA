////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DZ11 Modem Status Register (MSR)
//
// Details
//   The module implements the DZ11 MSR Register.
//
// File
//   dzmsr.sv
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2023 Rob Doyle
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

module DZMSR (
      input  wire        clk,                   // Clock
      input  wire        rst,                   // Reset
      input  wire [ 7:0] dzCO,                  // DZ11 Carrier Detect
      input  wire [ 7:0] dzRI,                  // DZ11 Ring Indicator
      output reg  [15:0] regMSR                 // MSR Output
   );

   //
   // Synchronize the inputs
   //

   logic [15:0] tmpMSR;

   always_ff @(posedge clk)
     begin
        if (rst)
          tmpMSR <= 16'b0;
        else
          tmpMSR <= {dzCO, dzRI};
     end

   //
   // MSR Register
   //
   // Trace
   //  M7819/S4/E1
   //  M7819/S4/E2
   //  M7819/S4/E3
   //  M7819/S4/E4
   //  M7819/S4/E5
   //  M7819/S4/E6
   //  M7819/S4/E12
   //  M7819/S4/E13
   //  M7819/S4/E14
   //

   always_ff @(posedge clk)
     begin
        if (rst)
          regMSR <= 16'b0;
        else
          regMSR <= tmpMSR;
     end

endmodule
