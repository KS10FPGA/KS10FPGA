////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Non-existent Memory
//
// File
//   nxm.v
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

`include "bus.vh"

module NXM (
      input  wire         clk,          // Clock
      input  wire         rst,          // Reset
      input  wire [ 0:35] cpuADDRO,     // Bus Address
      input  wire         cpuREQO,      // Bus Request
      input  wire         cpuACKI,      // Bus Acknowledge
      output wire         memWAIT,      // Wait for Memory
      output wire         nxmINTR       // Non-existant Memory Interrupt
   );

   //
   // Bus Flags
   //

   wire busIO = `busIO(cpuADDRO);

   //
   // Bus Monitor
   //
   // Details
   //  Wait for Bus ACK on memory accesses.  Generate a NXM Interrupt on memory
   //  cycles that are never acknowledged.
   //
   // FIXME
   //  Just delete this.  NXM can't happen.
   //

   localparam [0:3] tDONE = 15;
   reg        [0:3] timeout;

   always @(posedge clk)
     begin
        if (rst)
          timeout <= 0;
        else
          begin
             if (!busIO & cpuREQO & !cpuACKI)
               timeout <= tDONE;
             else if (cpuACKI)
               timeout <= 0;
             else if (timeout != 0)
               timeout <= timeout - 1'b1;
          end
     end

   //
   // Wait for memory cycle ACK.  Timeout if no ACK occurs.
   //

   assign memWAIT = ((!busIO & cpuREQO & !cpuACKI) |
                     (timeout != 0)    & !cpuACKI);

   //
   // Generate an NXM trap
   //

   assign nxmINTR = (timeout == 1);

`ifndef SYNTHESIS

   //
   // Whine about unacked bus cycles
   //

   always @(posedge clk)
     begin
        if (nxmINTR)
          begin
             $display("[%11.3f] CPU: Unacknowledged memory cycle.  Addr = %012o",
                      $time/1.0e3, cpuADDRO);
          end
     end

`endif

endmodule
