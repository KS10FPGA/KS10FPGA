////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//    Pager
//
// Details
//   The page table translates virtual addresses/page numbers to phyical
//   addresses/page numbers.  There are 512 virtual pages which map to 2048
//   pages.
//
//        18                26 27                    35
//       +--------------------+------------------------+
//       |Virtual Page Number |        Word Number     |
//       +--------------------+------------------------+
//                |                       |
//                |                       |
//               \ /                      |
//        +-------+-------+               |
//        |      Page     |               |
//        |  Translation  |               |
//        +-------+-------+               |
//                |                       |
//                |                       |
//               \ /                     \ /
//   +------------------------+------------------------+
//   |  Physical Page Number  |        Word Number     |
//   +------------------------+------------------------+
//    16                    26 27                    35
//
//
// Note
//   The Page Tables use asynchronous memory which won't work in an FPGA.
//   Since the Page Table is addressed by the VMAregister and the VMA register
//   is loaded synchronously, we can absorb the VMA register into the Page
//   Table Memory addressing.
//
// File
//   pager.v
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
`include "vma.vh"
`include "useq/crom.vh"
`include "useq/drom.vh"

module PAGER(clk, rst, clken, crom, drom, dp, vmaREG, pageFLAGS, pageADDR);

   parameter cromWidth = `CROM_WIDTH;
   parameter dromWidth = `DROM_WIDTH;

   input                   clk;                 // Clock
   input                   rst;                 // Reset
   input                   clken;               // Clock Enable
   input  [ 0:cromWidth-1] crom;                // Control ROM Data
   input  [ 0:dromWidth-1] drom;                // Dispatch ROM Data
   input  [ 0:35]          dp;                  // Data path
   input  [ 0:35]          vmaREG;              // VMA Register
   output [ 0: 3]          pageFLAGS;           // Page Flags
   output [16:26]          pageADDR;            // Page Address

   //
   // vmaFLAGS
   //

   wire vmaUSER = `vmaUSER(vmaREG);

   //
   // VMA Logic
   //
   // Details
   //  During a page table sweep, both specPAGESWEEP and specPAGEWRITE are
   //  asserted simultaneously.
   //
   // Trace
   //  DPE5/E76
   //  DPE6/E53
   //

   wire specPAGESWEEP = `cromSPEC_EN_20 & (`cromSPEC_SEL == `cromSPEC_SEL_CLRCACHE );
   wire specPAGEWRITE = `cromSPEC_EN_10 & (`cromSPEC_SEL == `cromSPEC_SEL_PAGEWRITE);

   //
   // vmaEN
   //

   wire vmaEN = ((`cromMEM_CYCLE & `cromMEM_LOADVMA           ) |
                 (`cromMEM_CYCLE & `cromMEM_AREAD   & `dromVMA) |
                 (specPAGESWEEP));


   //
   // Sweep and Page Write
   //
   // Details:
   //   These signals occur on the cycle before they are required.
   //
   // Trace:
   //  DPM4/E184
   //  DPMC/E3
   //

   reg pageSWEEP;
   reg pageWRITE;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             pageSWEEP <= 0;
             pageWRITE <= 0;
          end
        else
          if (clken)
            begin
               pageSWEEP <= specPAGESWEEP;
               pageWRITE <= specPAGEWRITE;
            end
     end

   //
   // Table Address
   //

   wire [0:7] tableAddr   = dp[19:26];
   wire       tableSelect = dp[18];

   //
   // Page Table Write
   //

   wire         pageinVALID     = dp[18];
   wire         pageinWRITEABLE = dp[21];
   wire         pageinCACHEABLE = dp[22];
   wire [16:26] pageinADDR      = dp[25:35];
   wire [ 0: 3] pageinFLAGS     = {pageinVALID, pageinWRITEABLE, pageinCACHEABLE, vmaUSER};

   //
   // Page Table Write
   //
   // Details
   //  The page tables perform the virtual address to physical address
   //  translation using a lookup table that is addressed by the virtual
   //  address.
   //
   // Notes
   //  This has been converted to synchronous memory.  The page table address
   //  is set when the vma address is set
   //
   //  The page table is interleaved with odd and even memories so that the
   //  memory can be swept two entries at a time.
   //
   //  Page parity is not implemented.
   //
   // Trace
   //  Even Memory
   //   DPM6/E130
   //   DPM6/E154
   //   DPM6/E162
   //   DPM6/E184
   //  Odd Memory
   //   DPM6/E138
   //   DPM6/E146
   //   DPM6/E176
   //   DPM6/E192
   //

   reg [0:14] pageTABLE1[0:255];
   reg [0:14] pageTABLE2[0:255];

   wire [18:26] asdf = vmaREG[19:26];
   wire [ 0:14] qwer = {pageinFLAGS, pageinADDR};

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          ;
        else
          if (clken)
            begin
               if (pageSWEEP & vmaEN & pageWRITE)
                 begin
                    pageTABLE1[tableAddr] <= {7'b0110_000, pageinADDR[19:26]};
                    pageTABLE2[tableAddr] <= {7'b0110_001, pageinADDR[19:26]};
                 end
               else if (pageWRITE)
                 begin
                    if (!asdf[18])
                      pageTABLE1[asdf[19:26]] <= {pageinFLAGS, pageinADDR};
                    else
                      pageTABLE2[asdf[19:26]] <= {pageinFLAGS, pageinADDR};
                 end
            end
     end

   //
   // Page Table Read
   //

   reg [16:26] pageADDR;
   reg [ 0: 3] pageFLAGS;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             pageFLAGS <= 0;
             pageADDR  <= 0;
          end
        else
          if (clken & vmaEN)
            begin
               if (!tableSelect)
                 {pageFLAGS, pageADDR} <= pageTABLE1[tableAddr];
               else
                 {pageFLAGS, pageADDR} <= pageTABLE2[tableAddr];
            end
     end

   //
   // Test only
   //

   wire [16:35] addr = {pageADDR[16:26], vmaREG[27:35]};

endmodule
