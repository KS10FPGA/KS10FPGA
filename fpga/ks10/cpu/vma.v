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
// Copyright (C) 2012-2016 Rob Doyle
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
      output reg           vmaLOAD      // VMA load
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
   // VMA Register
   //
   // Details
   //  The VMA is loaded when cromMEM_CYCLE is active and the VMA is loaded.
   //
   // Trace
   //  DPE3/E53
   //  DPM4/E55
   //  DPM4/E56
   //  DPM4/E74
   //  DPE3/E76
   //  DPM4/E82
   //  DPM4/E90
   //  DPM4/E97
   //  DPM4/E103
   //  DPM4/E115
   //  DPM4/E137
   //  DPM4/E152
   //  DPM4/E168
   //  DPM4/E175
   //  DPM4/E182
   //  DPM4/E183
   //

   wire vmaEN = ((`cromMEM_CYCLE & `cromMEM_LOADVMA           ) |
                 (`cromMEM_CYCLE & `cromMEM_AREAD   & `dromVMA) |
                 (cacheSWEEP));

   always @(posedge clk or posedge rst)
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
        else if (clken & vmaEN & !pageFAIL)
          begin
             `vmaEXTD(vmaREG) <= `cromMEM_EXTADDR;
             `vmaADDR(vmaREG) <= `vmaADDR(dp);
             if (`cromMEM_DPFUNC)
               begin
                  `vmaUSER(vmaREG)   <= `vmaUSER(dp);
                  `vmaFETCH(vmaREG)  <= `vmaFETCH(dp);
                  `vmaPHYS(vmaREG)   <= `vmaPHYS(dp);
                  `vmaPREV(vmaREG)   <= `vmaPREV(dp);
                  `vmaIO(vmaREG)     <= `vmaIO(dp);
                  `vmaWRU(vmaREG)    <= `vmaWRU(dp);
                  `vmaVECT(vmaREG)   <= `vmaVECT(dp);
                  `vmaIOBYTE(vmaREG) <= `vmaIOBYTE(dp);
               end
             else
               begin
                  `vmaUSER(vmaREG)   <= ((~`cromMEM_FORCEEXEC & flagUSER & ~cpuEXEC) |
                                         (`cromMEM_FETCHCYCLE & flagUSER           ) |
                                         (prevEN              & flagPCU            ) |
                                         (selPREVIOUS         & flagPCU            ) |
                                         (`cromMEM_FORCEUSER));
                  `vmaFETCH(vmaREG)  <= `cromMEM_FETCHCYCLE;
                  `vmaPHYS(vmaREG)   <= `cromMEM_PHYSICAL;
                  `vmaPREV(vmaREG)   <= prevEN | selPREVIOUS;
                  `vmaIO(vmaREG)     <= 0;
                  `vmaWRU(vmaREG)    <= 0;
                  `vmaVECT(vmaREG)   <= 0;
                  `vmaIOBYTE(vmaREG) <= 0;
               end
          end
    end

   //
   // Memory Cycle Control
   //
   // Details
   //  The type of memory cycle can controlled by the microcode or can be
   //  controlled by the Dispatch ROM.  The Cycle Control is loaded when
   //  cromMEM_CYCLE is active.
   //
   // Trace
   //  DPM5/E48
   //  DPM5/E66
   //  DPM5/E33
   //  DPM5/E110
   //

   wire memEN = ((`cromMEM_CYCLE  & `cromMEM_WAIT                   ) |
                 (`cromMEM_CYCLE  & `cromMEM_BWRITE & `dromCOND_FUNC));

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             `vmaREAD(vmaREG)     <= 0;
             `vmaWRTEST(vmaREG)   <= 0;
             `vmaWRITE(vmaREG)    <= 0;
             `vmaCACHEINH(vmaREG) <= 0;
          end
        else if (clken & memEN & !pageFAIL)
          begin
             if (`cromMEM_AREAD)
               begin
                  `vmaREAD(vmaREG)     <= `dromREADCYCLE;
                  `vmaWRTEST(vmaREG)   <= `dromWRTESTCYCLE;
                  `vmaWRITE(vmaREG)    <= `dromWRITECYCLE;
                  `vmaCACHEINH(vmaREG) <= 0;
               end
             else
               if (`cromMEM_DPFUNC)
                 begin
                    `vmaREAD(vmaREG)     <= `vmaREAD(dp);
                    `vmaWRTEST(vmaREG)   <= `vmaWRTEST(dp);
                    `vmaWRITE(vmaREG)    <= `vmaWRITE(dp);
                    `vmaCACHEINH(vmaREG) <= `vmaCACHEINH(dp);
                 end
               else
                 begin
                    `vmaREAD(vmaREG)     <= `cromMEM_READCYCLE;
                    `vmaWRTEST(vmaREG)   <= `cromMEM_WRTESTCYCLE;
                    `vmaWRITE(vmaREG)    <= `cromMEM_WRITECYCLE;
                    `vmaCACHEINH(vmaREG) <= `cromMEM_CACHEINH;
                 end
          end
     end

   //
   // Debug output
   //
   //  This is asserted when the VMA has a new value.
   //

    always @(posedge clk or posedge rst)
     begin
        if (rst)
          vmaLOAD <= 0;
        else
          vmaLOAD <= vmaEN;
     end

endmodule
