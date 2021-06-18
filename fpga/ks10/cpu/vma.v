////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Virtual Memory Address
//
// Details
//
// File
//   vma.v
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

`include "vma.vh"
`include "pcflags.vh"
`include "useq/crom.vh"
`include "useq/drom.vh"

module VMA (
      input  wire          clk,         // Clock
      input  wire          rst,         // Reset
      input  wire          clken,       // Clock Enable
      input  wire [ 0:107] crom,        // Control ROM Data
      input  wire [ 0: 35] drom,        // Dispatch ROM Data
      input  wire [ 0: 35] dp,          // Data path
      input  wire          cpuEXEC,     // Execute
      input  wire          prevEN,      // Previous enable
      input  wire [ 0: 17] pcFLAGS,     // PC Flags
      input  wire          pageFAIL,    // Page fail
      output reg  [ 0: 35] vmaREG,      // VMA register
      output reg           vmaLOAD,     // VMA load
      output reg           writeEN      // Write Enable
   );

   //
   // PC Flags
   //

   wire flagUSER = `flagUSER(pcFLAGS);   // User
   wire flagPCU  = `flagPCU(pcFLAGS);    // Previous Context User

   //
   // Microcode Decode
   //
   // Note
   //  The cache clear and the previous selection are exclusive operations.
   //
   // Trace
   //  DPE5/E76
   //  DPE6/E53
   //

   wire cacheSWEEP  = `cromSPEC_EN_20 & (`cromSPEC_SEL == `cromSPEC_SEL_CLRCACHE);
   wire selPREVIOUS = `cromSPEC_EN_20 & (`cromSPEC_SEL == `cromSPEC_SEL_PREVIOUS);

   //
   // VMA Data Selector
   //
   // Trace
   //  DPM4/E54
   //  DPM4/E55
   //  DPM4/E56
   //  DPM4/E72
   //  DPM4/E74
   //  DPM4/E115
   //

   reg vmaUSER;
   reg vmaFETCH;
   reg vmaPHYS;
   reg vmaPREV;
   reg vmaIO;
   reg vmaWRU;
   reg vmaVECT;
   reg vmaIOBYTE;

   always @*
     begin
        if (`cromMEM_DPFUNC)
          begin
             vmaUSER   <= `vmaUSER(dp);
             vmaFETCH  <= `vmaFETCH(dp);
             vmaPHYS   <= `vmaPHYS(dp);
             vmaPREV   <= `vmaPREV(dp);
             vmaIO     <= `vmaIO(dp);
             vmaWRU    <= `vmaWRU(dp);
             vmaVECT   <= `vmaVECT(dp);
             vmaIOBYTE <= `vmaIOBYTE(dp);
          end
        else
          begin
             vmaUSER   <= ((~`cromMEM_FORCEEXEC & flagUSER & ~cpuEXEC) |
                           (`cromMEM_FETCHCYCLE & flagUSER           ) |
                           (prevEN              & flagPCU            ) |
                           (selPREVIOUS         & flagPCU            ) |
                           (`cromMEM_FORCEUSER));
             vmaFETCH  <= `cromMEM_FETCHCYCLE;
             vmaPHYS   <= `cromMEM_PHYSICAL;
             vmaPREV   <= prevEN | selPREVIOUS;
             vmaIO     <= 0;
             vmaWRU    <= 0;
             vmaVECT   <= 0;
             vmaIOBYTE <= 0;
          end
     end

   //
   // VMA Register
   //
   // Details
   //  The VMA is loaded when cromMEM_CYCLE is active and the VMA is loaded.
   //
   // Trace
   //  DPM4/E82
   //  DPM4/E90
   //  DPM4/E103
   //  DPM4/E137
   //  DPM4/E152
   //  DPM4/E175
   //  DPM4/E182
   //  DPM4/E183
   //

   wire vmaEN = ((`cromMEM_CYCLE & `cromMEM_LOADVMA           ) |
                 (`cromMEM_CYCLE & `cromMEM_AREAD   & `dromVMA) |
                 (cacheSWEEP));

   always @(posedge clk)
     begin
        if (rst)
          begin
             `vmaEXTD(vmaREG)   <= 0;
             `vmaADDR(vmaREG)   <= 0;
             `vmaUSER(vmaREG)   <= 0;
             `vmaEXEC(vmaREG)   <= 0;
             `vmaFETCH(vmaREG)  <= 0;
             `vmaPHYS(vmaREG)   <= 0;
             `vmaPREV(vmaREG)   <= 0;
             `vmaIO(vmaREG)     <= 0;
             `vmaWRU(vmaREG)    <= 0;
             `vmaVECT(vmaREG)   <= 0;
             `vmaIOBYTE(vmaREG) <= 0;
          end
        else if (clken & vmaEN & !pageFAIL)		// FIXME: Why
          begin
             `vmaEXEC(vmaREG)   <= 0;
             `vmaEXTD(vmaREG)   <= `cromMEM_EXTADDR;
             `vmaADDR(vmaREG)   <= `vmaADDR(dp);
             `vmaUSER(vmaREG)   <= vmaUSER;
             `vmaFETCH(vmaREG)  <= vmaFETCH;
             `vmaPHYS(vmaREG)   <= vmaPHYS;
             `vmaPREV(vmaREG)   <= vmaPREV;
             `vmaIO(vmaREG)     <= vmaIO;
             `vmaWRU(vmaREG)    <= vmaWRU;
             `vmaVECT(vmaREG)   <= vmaVECT;
             `vmaIOBYTE(vmaREG) <= vmaIOBYTE;
          end
     end

   //
   // Memory Cycle Decoder
   //
   // Details
   //  The type of memory cycle can controlled by the microcode or can be
   //  controlled by the Dispatch ROM.
   //
   // Trace
   //  DPM5/E48
   //  DPM5/E66
   //

   reg readEN;
   reg wrtestEN;
   reg cacheinhEN;
   wire [1:0] sel = {`cromMEM_CYCLE_SEL};

   always @*
     begin
        case (sel)
          0 : begin
                readEN     <= `cromMEM_READCYCLE;
                wrtestEN   <= `cromMEM_WRTESTCYCLE;
                writeEN    <= `cromMEM_WRITECYCLE;
                cacheinhEN <= `cromMEM_CACHEINH;
              end
          1 : begin
                readEN     <= `vmaREAD(dp);
                wrtestEN   <= `vmaWRTEST(dp);
                writeEN    <= `vmaWRITE(dp);
                cacheinhEN <= `vmaCACHEINH(dp);
              end
          2 : begin
                readEN     <= `dromREADCYCLE;
                wrtestEN   <= `dromWRTESTCYCLE;
                writeEN    <= `dromWRITECYCLE;
                cacheinhEN <= 0;
              end
          3 : begin
                readEN     <= 0;
                wrtestEN   <= 0;
                writeEN    <= 0;
                cacheinhEN <= 0;
              end
        endcase
     end

   //
   //  The Cycle Control is loaded when cromMEM_CYCLE is active.
   //
   // Trace
   //  DPM5/E33
   //  DPM5/E110
   //

   wire memEN = ((`cromMEM_CYCLE  & `cromMEM_WAIT                   ) |
                 (`cromMEM_CYCLE  & `cromMEM_BWRITE & `dromCOND_FUNC));

   always @(posedge clk)
     begin
        if (rst)
          begin
             `vmaREAD(vmaREG)     <= 0;
             `vmaWRTEST(vmaREG)   <= 0;
             `vmaWRITE(vmaREG)    <= 0;
             `vmaCACHEINH(vmaREG) <= 0;
          end
        else if (clken & memEN & !pageFAIL)  // FIXME (why !pageFAIL?)
          begin
             `vmaREAD(vmaREG)     <= readEN;
             `vmaWRTEST(vmaREG)   <= wrtestEN;
             `vmaWRITE(vmaREG)    <= writeEN;
             `vmaCACHEINH(vmaREG) <= cacheinhEN;
          end
     end

   //
   // Memory Cycle Control
   // Debug output
   //
   //  This is asserted when the VMA has a new value.
   //

    always @(posedge clk)
     begin
        if (rst)
          vmaLOAD <= 0;
        else
          vmaLOAD <= vmaEN;
     end

endmodule
