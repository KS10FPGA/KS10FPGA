////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Breakpoint Interface
//
// Details
//   This module provides KS10 breakpoint capabilities.  The breakpoint is
//   accomplished by examining the address on the KS10 Backplane Bus.
//
// File
//   breakpoint.sv
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

   module BRKPT (
      brcslbus.br          brCSLDATA,           // Registers from CSL
      input  wire  [ 0:35] cpuADDR,             // Backplane address from CPU
      output logic         brHALT               // Halt signal to CPU
   );

   //
   // Fixup inputs
   //

   wire        clk      = brCSLDATA.clk;
   wire        rst      = brCSLDATA.rst;
   wire [0:35] regBRAR0 = brCSLDATA.regBRAR[0];
   wire [0:35] regBRMR0 = brCSLDATA.regBRMR[0];
   wire [0:35] regBRAR1 = brCSLDATA.regBRAR[1];
   wire [0:35] regBRMR1 = brCSLDATA.regBRMR[1];
   wire [0:35] regBRAR2 = brCSLDATA.regBRAR[2];
   wire [0:35] regBRMR2 = brCSLDATA.regBRMR[2];
   wire [0:35] regBRAR3 = brCSLDATA.regBRAR[3];
   wire [0:35] regBRMR3 = brCSLDATA.regBRMR[3];

   //
   // Match and mask
   //  The read flag and the write flag are in different positions in the
   //  Address flags. Breaking on a read or a write requires two comparisons.
   //
   //  In the first comparison we only check for reads. In the second comparison
   //  only check for writes.
   //
   //  Breakpoints are disable if both regBRAR and regBRMR are zero
   //

   localparam [0:35] flagRD = 36'o_040000_000000;       // Read Flag
   localparam [0:35] flagWR = 36'o_010000_000000;       // Write Flag

   wire addrmatch = ((regBRAR0 != 36'b0) & (regBRMR0 != 36'b0) & ((cpuADDR & regBRMR0 & ~flagWR) == (regBRAR0 & regBRMR0 & ~flagWR)) |       // BR0 Read
                     (regBRAR0 != 36'b0) & (regBRMR0 != 36'b0) & ((cpuADDR & regBRMR0 & ~flagRD) == (regBRAR0 & regBRMR0 & ~flagRD)) |       // BR0 Write
                     (regBRAR1 != 36'b0) & (regBRMR1 != 36'b0) & ((cpuADDR & regBRMR1 & ~flagWR) == (regBRAR1 & regBRMR1 & ~flagWR)) |       // BR1 Read
                     (regBRAR1 != 36'b0) & (regBRMR1 != 36'b0) & ((cpuADDR & regBRMR1 & ~flagRD) == (regBRAR1 & regBRMR1 & ~flagRD)) |       // BR1 Write
                     (regBRAR2 != 36'b0) & (regBRMR2 != 36'b0) & ((cpuADDR & regBRMR2 & ~flagWR) == (regBRAR2 & regBRMR2 & ~flagWR)) |       // BR2 Read
                     (regBRAR2 != 36'b0) & (regBRMR2 != 36'b0) & ((cpuADDR & regBRMR2 & ~flagRD) == (regBRAR2 & regBRMR2 & ~flagRD)) |       // BR2 Write
                     (regBRAR3 != 36'b0) & (regBRMR3 != 36'b0) & ((cpuADDR & regBRMR3 & ~flagWR) == (regBRAR3 & regBRMR3 & ~flagWR)) |       // BR3 Read
                     (regBRAR3 != 36'b0) & (regBRMR3 != 36'b0) & ((cpuADDR & regBRMR3 & ~flagWR) == (regBRAR3 & regBRMR3 & ~flagWR)));       // BR3 Read

   //
   // Create output that is only one clock wide
   //

   logic [1:0] d;
   always_ff @(posedge clk)
     begin
        if (rst)
          d <= 0;
        else
          begin
             d[0] <= addrmatch;
             d[1] <= d[0];
          end
     end

   assign brHALT = (d == 2'b01);

endmodule
