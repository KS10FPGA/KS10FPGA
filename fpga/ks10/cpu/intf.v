////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Console Interface
//
// Details
//
// File
//   intf.v
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

`include "useq/crom.vh"

module INTF (
      input  wire         clk,          // clock
      input  wire         rst,          // reset
      input  wire         clken,        // clock enable
      input  wire [0:107] crom,         // Control ROM Data
      input  wire         debugHALT,    // Breakpoint
      input  wire         cslRUN,       // Console Run Switch
      input  wire         cslHALT,      // Console Halt Switch
      input  wire         cslCONT,      // Console Continue Switch
      input  wire         cslEXEC,      // Console Execute Switch
      output reg          cpuRUN,       // CPU Run Status
      output reg          cpuCONT,      // CPU Continue Status
      output reg          cpuEXEC,      // CPU Execute Status
      output reg          cpuHALT       // CPU Halt Status
   );

   //
   // Spec Decoder
   //  CRA2/E97
   //

   wire specCONS = `cromSPEC_EN_10 & (`cromSPEC_SEL == `cromSPEC_SEL_CONS);

   //
   // HALT Status
   //
   // Trace
   //  CSL4/E161
   //  CSL4/E162
   //  CSL4/E168
   //

   always @(posedge clk)
     begin
        if (rst)
          cpuHALT <= 0;
        else if (clken)
          begin
             if (specCONS & `cromCONS_SET_HALT)
               cpuHALT <= 1;
             else if (specCONS & `cromCONS_CLR_HALT)
               cpuHALT <= 0;
          end
     end

   //
   // RUN Status
   //
   // Trace
   //  CSL4/E98
   //  CSL4/E135
   //

   always @(posedge clk)
     begin
        if (rst)
          cpuRUN <= 0;
        else if (clken)
          begin
             if ((specCONS & `cromCONS_CLR_RUN) | cslHALT | debugHALT)
               cpuRUN <= 0;
             else if (cslRUN)
               cpuRUN <= 1;
          end
     end

   //
   // EXECUTE Status
   //
   // Trace
   //  CSL4/E149
   //  CSL4/E168
   //

   always @(posedge clk)
     begin
        if (rst)
          cpuEXEC <= 0;
        else if (clken)
          begin
             if (specCONS & `cromCONS_CLR_EXEC)
               cpuEXEC <= 0;
             else if (cslEXEC)
               cpuEXEC <= 1;
          end
     end

   //
   // CONTINUE Status
   //
   // Trace
   //  CSL4/E168
   //  CSL4/E171
   //

   always @(posedge clk)
     begin
        if (rst)
          cpuCONT <= 0;
        else if (clken)
          begin
             if (specCONS & `cromCONS_CLR_CONT)
               cpuCONT <= 0;
             else if (cslCONT)
               cpuCONT <= 1;
          end
     end

endmodule
