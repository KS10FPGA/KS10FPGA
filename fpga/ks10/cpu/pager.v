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
//  The DEC KS10 Page Tables were implemented using asynchronous memory which
//  does not translate to an FPGA very well. Since the Page Table is addressed
//  by the VMA register and the VMA register is loaded synchronously, we
//  simply absorb the VMA register into the Page Table memory addressing.  In
//  other words, when we load the VMA register, we lookup the translated page
//  address.
//
//  The Page Table is interleaved with odd and even memories so that the
//  memory can be swept two entries at a time.
//
//  The Page Table addressing is rearranged from that of the DEC KS10.  On the
//  DEC KS10 the two memories are interleaved by the MSB of the address. On the
//  KS10 FPGA, the two memories are interleaved by the LSB of the address.  When
//  the interleaving is done this way, the Xilinx synthesis tool can infer a
//  dual port memory with different aspect ratios as follows:
//
//  - The write port is 256x30
//  - The read port is 512x15
//
//  The x30 write port allows the page memory to be swept two entries at a time.
//  The x15 read port allow for simple page lookups.
//
// Note
//  The Page Sweep is implemented a little differently than the DEC KS10.
//  Clearing the "Page Valid" bit is sufficient to invalidate the page memory.
//  None of the other bits matter if "Page Valid" bit is cleared.
//
// Note
//  Page parity is not implemented.
//
// File
//   pager.v
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
`include "useq/crom.vh"
`include "useq/drom.vh"

module PAGER (
      input  wire          clk,         // Clock
      input  wire          rst,         // Reset
      input  wire          memCLK,      // Memory Clock
      input  wire [ 1: 4]  clkPHS,      // Clock Phase
      input  wire          clken,       // Clock Enable
      input  wire [ 0:107] crom,        // Control ROM Data
      input  wire [ 0: 35] drom,        // Dispatch ROM Data
      input  wire [ 0: 35] dp,          // Data path
      input  wire [ 0: 35] vmaREG,      // VMA Register
      output reg  [ 0:  3] pageFLAGS,   // Page Flags
      output reg  [16: 26] pageADDR     // Page Address
   );

   //
   // vmaFLAGS
   //

   wire vmaUSER = `vmaUSER(vmaREG);

   //
   // Microcode decode
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
   //  This signal indicates that the VMA should be updated.
   //
   // Trace
   //  DPE5/E53
   //  DPE5/E76
   //

   wire vmaEN = ((`cromMEM_CYCLE & `cromMEM_LOADVMA           ) |
                 (`cromMEM_CYCLE & `cromMEM_AREAD   & `dromVMA));

   //
   // Page Write
   //
   // Details
   //  This signal is the write enable for the page memory.
   //
   // Trace:
   //  DPMC/E3
   //

   reg pageWRITE;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          pageWRITE <= 0;
        else
          if (clken)
            pageWRITE <= specPAGEWRITE;
     end

   //
   // Page Sweep
   //
   // Details
   //  This signal is asserted when invalidating the page memory.
   //
   // Trace
   //  DPM4/E103
   //

   reg pageSWEEP;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          pageSWEEP <= 0;
        else
          if (clken)
            pageSWEEP <= specPAGESWEEP;
     end

   //
   // Page Table Write Data
   //

   wire         pageVALID     = dp[18];
   wire         pageWRITEABLE = dp[21];
   wire         pageCACHEABLE = dp[22];
   wire [16:26] pageADDRI     = dp[25:35];

   //
   // Page Table Write Addressing
   //

   wire         writeSel      = vmaREG[18];
   wire [ 0: 7] writeAddr     = vmaREG[19:26];

   //
   // Page Table Read Addressing
   //

   wire [ 0: 8] readAddr      = {dp[19:26], dp[18]};

`ifdef XILINX

   wire [31: 0] readData;
   wire [31: 0] writeData     = pageSWEEP ? 32'b0 : {2{1'b0, pageVALID, pageWRITEABLE, pageCACHEABLE, vmaUSER, pageADDRI}};
   wire [ 3: 0] writeEnable   = {{2{pageSWEEP | writeSel}}, {2{pageSWEEP | !writeSel}}};

   //
   // Must use 18Kb Block RAM in True Dual-Port Mode to implement the Page Memory
   //   Port A: 256x36  (write port)
   //   Part B: 512x18  (read  port)
   //
   // http://www.xilinx.com/support/documentation/sw_manuals/xilinx11/spartan6_hdl.pdf
   //

   RAMB16BWER #(
      .DATA_WIDTH_A             (36),                           //   Port A data width
      .DATA_WIDTH_B             (18),                           //   Port B data width
      .DOA_REG                  (0),                            // * Port A output register not used
      .DOB_REG                  (0),                            // * Port B output register not used
      .EN_RSTRAM_A              ("FALSE"),                      //   Port A output register reset (not used)
      .EN_RSTRAM_B              ("FALSE"),                      //   Port B output register reset (not used)
      .INIT_A                   (36'b0),                        // * Port A output register initial value (not used)
      .INIT_B                   (36'b0),                        // * Port B output register initial value (not used)
      .INIT_FILE                ("NONE"),                       // * Initialization file
      .RSTTYPE                  ("SYNC"),                       // * Type of reset
      .RST_PRIORITY_A           ("CE"),                         //
      .RST_PRIORITY_B           ("CE"),                         //
      .SIM_COLLISION_CHECK      ("ALL"),                        //
      .SIM_DEVICE               ("SPARTAN6"),                   //
      .SRVAL_A                  (36'b0),                        //
      .SRVAL_B                  (36'b0),                        //
      .WRITE_MODE_A             ("WRITE_FIRST"),                //
      .WRITE_MODE_B             ("WRITE_FIRST")                 //
   ) pageTABLE (
      .DIA                      (writeData),                    // Port A data input
      .DIPA                     (4'b0),                         // Port A parity input (not used)
      .DOA                      (),                             // Port A data output (not used)
      .DOPA                     (),                             // Port A parity output (not used)
      .ADDRA                    ({1'b0, writeAddr, 5'b0}),      // Port A address input (9 bits)
      .CLKA                     (clk),                          // Port A clock input
      .ENA                      (clken & pageWRITE),            // Port A enable input
      .REGCEA                   (1'b1),                         // Port A register clock enable input
      .RSTA                     (1'b0),                         // Port A register set/reset input
      .WEA                      (writeEnable),                  // Port A write enable input (4 bits)
      .DIB                      (32'b0),                        // Port B data input (not used)
      .DIPB                     (4'b0),                         // Port B parity input (not used)
      .DOB                      (readData),                     // Port B data output (32 bit)
      .DOPB                     (),                             // Port B parity output (not used)
      .ADDRB                    ({1'b0, readAddr, 4'b0}),       // Port B address input (10 bits)
      .CLKB                     (clk),                          // Port B clock input
      .ENB                      (clken & vmaEN),                // Port B enable input
      .REGCEB                   (1'b1),                         // Port B register clock enable input
      .RSTB                     (1'b0),                         // Port B register set/reset input
      .WEB                      (4'b0)                          // Port B write enable input (4 bits)
   );

   always @*
     begin
        {pageFLAGS, pageADDR} <= readData[14:0];
     end

`else

   //
   // Page Table Write (Even)
   //
   // Details
   //  The Page Table is invalidated by writing zeros.  This clears the "Page
   //  Valid" bit.
   //
   // Trace
   //   DPM6/E130
   //   DPM6/E154
   //   DPM6/E162
   //   DPM6/E184
   //

   reg [0:14] pageTABLE[0:511];

   always @(posedge clk)
     begin
        if (clken & pageWRITE)
          begin
             if (pageSWEEP)
               pageTABLE[{writeAddr, 1'b0}] <= 0;
             else if (!writeSel)
               pageTABLE[{writeAddr, 1'b0}] <= {pageVALID, pageWRITEABLE, pageCACHEABLE, vmaUSER, pageADDRI};
          end
     end

   //
   // Page Table Write (Odd)
   //
   // Details
   //  The Page Table is invalidated by writing zeros.  This clears the "Page
   //  Valid" bit.
   //
   // Trace
   //   DPM6/E138
   //   DPM6/E146
   //   DPM6/E176
   //   DPM6/E192
   //

   always @(posedge clk)
     begin
        if (clken & pageWRITE)
          begin
             if (pageSWEEP)
               pageTABLE[{writeAddr, 1'b1}] <= 0;
             else if (writeSel)
               pageTABLE[{writeAddr, 1'b1}] <= {pageVALID, pageWRITEABLE, pageCACHEABLE, vmaUSER, pageADDRI};
          end
     end

   //
   // Page Table Read
   //
   // Details
   //  The Page Lookup is performed when the VMA is loaded.  See file header.
   //


   always @(posedge clk)
     begin
        if (clken & vmaEN)
          begin
             {pageFLAGS, pageADDR} <= pageTABLE[readAddr];
          end
     end

`endif

   //
   // Test only
   //

`ifndef SYNTHESIS

   wire [16:35] physAddr = {pageADDR[16:26], vmaREG[27:35]};

`endif

endmodule
