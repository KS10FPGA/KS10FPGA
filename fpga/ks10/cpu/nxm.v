////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Non-existent Memory
//
// Details
//
// File
//   nxm.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2014 Rob Doyle
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
`include "bus.vh"

module NXM(clk, rst, cpuADDRO, cpuREQO, cpuACKI, memWAIT, nxmINTR);

   input          clk;                  // Clock
   input          rst;                  // Reset
   input  [ 0:35] cpuADDRO;             // Bus Address
   input          cpuREQO;              // Bus Request
   input          cpuACKI;              // Bus Acknowledge
   output         memWAIT;              // Wait for Memory
   output         nxmINTR;              // Non-existant Memory Interrupt

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

   localparam [0:3] tDONE = 15;
   reg        [0:3] timeout;

   always @(posedge clk or posedge rst)
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

   assign memWAIT = (cpuREQO & !cpuACKI & (timeout != 0));

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
             $display("[%10.3f] CPU: Unacknowledged memory cycle.  Addr = %012o",
                      $time/1.0e3, cpuADDRO);
          end
     end

`endif

endmodule
