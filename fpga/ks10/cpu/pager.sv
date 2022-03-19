////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//    Pager
//
// Details
//   The page table translates virtual addresses/page numbers to physical
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
//  - The write port is 256x30
//  - The read port is  512x15
//
//  The x30 write port allows the page memory to be swept two entries at a time.
//  The x15 read port allow for simple page lookups.
//
// Note
//  The Page Sweep is implemented a little differently than the DEC KS10.
//  Clearing the "Page Valid" bit is sufficient to invalidate the page memory.
//  None of the other bits matter if "Page Valid" bit is cleared.
//
// Note:
//   This template for mixed-width dual-port RAM probably only works Quartus
//
//   This also requires Verilog 2012 or System Verilog in order to support
//   multiple packed dimensions.
//
//   See Intel Quartus Prime Pro Edition User Guide: Design Recommendations
//   Section 1.4.1.9 entitled "Mixed-Width Dual-Port RAM".
//
// Note
//  Page parity is not implemented.
//
// File
//   pager.sv
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
`include "useq/crom.vh"
`include "useq/drom.vh"

module PAGER (
      input  wire          clk,         // Clock
      input  wire          rst,         // Reset
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

   always @(posedge clk)
     begin
        if (rst)
          pageWRITE <= 0;
        else if (clken)
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

   always @(posedge clk)
     begin
        if (rst)
          pageSWEEP <= 0;
        else if (clken)
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

   wire [ 0: 8] writeAddr     = vmaREG[18:26];

   //
   // Page Table Read Addressing
   //

   wire  [0: 8] readAddr      = dp[18:26];

`ifndef PAGE_FAIL_TEST

   //
   // This is the 'normal' Pager
   //
   // Two variants exist: one is optimized to use a QUARTUS dual port RAM
   // and the other is generic which infers RAM from the HDL.
   //

`undef QUARTUS
`ifdef QUARTUS

   //
   // The Page Table Dual Port Memory is configured as follows:
   //
   //   Port A: 256x32  (write port)
   //   Part B: 512x16  (read  port)
   //
   // Note the actual memory required is x30 and x15. This is right justified
   // into more standard 32-bit and 16-bit memories. Bit 15 and bit 31 are just
   // padding and are not used.

   wire [16: 0] readData;
   wire [31: 0] writeData  = pageSWEEP ? 32'b0 : {2{1'b0, pageVALID, pageWRITEABLE, pageCACHEABLE, vmaUSER, pageADDRI}};
   wire [ 3: 0] byteEnable = {{2{pageSWEEP | writeSel}}, {2{pageSWEEP | !writeSel}}};

   //
   // Must use SYNCRAM in True Dual-Port Mode to implement the Page Memory
   //

   altsyncram_component #(
      .operation_mode           ("DUAL_PORT"),                  // Memory Mode
      .intended_device_family   ("Cyclone V"),                  // Famility for simulation
      .lpm_type                 ("altsyncram"),                 // Type of memory for simulation
      .power_up_uninitialized   ("FALSE"),                      // No initialization
      .byte_size                (8),                            // For byte-enables
//
      .numwords_a               (256),                          // Port A: Words of Memory
      .width_a                  ( 32),                          // Port A: Data width
      .widthad_a                (  8),                          // Port A: Address width
      .width_byteena_a          (  4),                          // Port A: Byte enable width
      .address_aclr_b           ("NONE"),                       // Port A: No need to clear address registers
      .clock_enable_input_a     ("BYPASS"),                     // Port A: Clock enable mode
//
      .numwords_b               (512),                          // Port B: Words of Memory
      .width_b                  ( 16),                          // Port B: Data width
      .widthad_b                (  8),                          // Port B: Address width
      .address_reg_b            ("CLOCK0"),                     // Port B: Select clock for address reg
      .clock_enable_input_b     ("BYPASS"),                     // Port B:
      .outdata_aclr_b           ("NONE"),                       // Port B:
      .clock_enable_output_b    ("BYPASS"),                     // Port B
      .outdata_reg_b            ("UNREGISTERED"),               // Port B:
      .rdcontrol_reg_b          ("CLOCK0"),                     // Port B: Select clock for control reg
      .read_during_write_mode_mixed_ports("DONT_CARE")
   ) pageTABLE (
      .clock0                   (clk),                          // Clock input
      .clock1                   (1'b1),                         // Not used
      .aclr0                    (1'b0),                         // Not used
      .aclr1                    (1'b0),                         // Not used
      .clocken0                 (1'b1),                         // Not used
      .clocken1                 (1'b1),                         // Not used
      .clocken2                 (1'b1),                         // Not used
      .clocken3                 (1'b1),                         // Not used
      .eccstatus                (),                             // Not used
//
      .address_a                (writeAddr),                    // Port A: Address input (8 bits)
      .data_a                   (writeData),                    // Port A: Data input (32 bits)
      .byteena_a                (byteEnable),                   // Port A: Byte enables (4 bits)
      .wren_a                   (clken & pageWRITE),            // Port A: Write enable
      .rden_a                   (1'b1),                         // Port A: Read enable (port is write-only)
      .q_a                      (),                             // Port A: Data output (port is write-only)
      .addressstall_a           (1'b0),                         // Port A: Address stall (not used)
//
      .address_b                (readAddr),                     // Port B: Address input (9 bits)
      .data_b                   (16'b0),                        // Port B: Data input (port is read-only)
      .byteena_b                ({4{1'b1}}),                    // Port B: Byte enables (not used)
      .wren_b                   (1'b0),                         // Port B: Write enable (port is read-only)
      .rden_b                   (clken & vmaEN),                // Port B: Read enable
      .q_b                      (readData),                     // Port b: Data output (16-bits)
      .addressstall_b           (1'b0)                          // Port B: Address stall (not used)
   );

   always @*
     begin
        {pageFLAGS, pageADDR} <= readData[14:0];
     end

`else // !`ifdef QUARTUS

   //
   // Page Table
   //
   // Details
   //  The Page Table is invalidated by writing zeros.  This clears the "Page
   //  Valid" bit among other bits.
   //
   //  The Page Lookup is performed when the VMA is loaded.  See file header.
   //
   // Trace
   //   DPM6/E130
   //   DPM6/E154
   //   DPM6/E162
   //   DPM6/E184
   //   DPM6/E138
   //   DPM6/E146
   //   DPM6/E176
   //   DPM6/E192
   //

   reg [0:1][0:14] pageTABLE[0:255];

   always @(posedge clk)
     begin

        //
        // Page Table Write
        //

        if (clken & pageWRITE)
          begin
             if (pageSWEEP)
               begin
                  pageTABLE[writeAddr[1:8]][0] <= 15'b0;
                  pageTABLE[writeAddr[1:8]][1] <= 15'b0;
               end
             else
               pageTABLE[writeAddr[1:8]][writeAddr[0]] <= {pageVALID, pageWRITEABLE, pageCACHEABLE, vmaUSER, pageADDRI};
          end

        //
        // Page Table Read
        //

        else if (clken & vmaEN)
          {pageFLAGS, pageADDR} <= pageTABLE[readAddr[1:8]][readAddr[0]];
     end

`endif // !`ifdef QUARTUS

`else // !`ifndef PAGE_FAIL_TEST

   //
   // Page Fail Test 'Pager'.
   //
   // This version of the Pager is deliberately broken so as to force a page
   // failure on every memory access.  It is used to stress test the PAGE FAIL
   // logic and the interface to the microcode.
   //
   // To accomplish this, the pager stores the entire VMA associated with the
   // page fill.  The page translation is only valid for that single access.
   // When the VMA is modified (next instruction or next address), the page
   // translation is returned as invalid.  This will force the microcode to
   // reload the Pager.
   //

   reg [14:35] pageVMA;
   reg [0 :14] pageTABLE;

   always @(posedge clk)
     begin
        if (rst)
          begin
             pageVMA   <= 0;
             pageTABLE <= 0;
             pageFLAGS <= 0;
             pageADDR  <= 0;
          end

        //
        // Page Table Write
        //

        else if (clken & pageWRITE)
          begin
             if (pageSWEEP)
               begin
                  pageVMA   <= 0;
                  pageTABLE <= 0;
               end
             else
               begin
                  pageVMA   <= vmaREG[14:35];
                  pageTABLE <= {pageVALID, pageWRITEABLE, pageCACHEABLE, vmaUSER, pageADDRI};
               end
          end

        //
        // Page Table Read
        //  If the VMA has changed, invalidate the Page Valid flag. Otherwise
        //  lookup the paging.
        //

        else if (clken & vmaEN)
          begin
             if (`vmaADDR(dp) != pageVMA)
               {pageFLAGS, pageADDR} <= 0;
             else
               {pageFLAGS, pageADDR} <= pageTABLE;
          end
     end

`endif // !`ifndef PAGE_FAIL_TEST

   //
   // Test only
   //

`ifndef SYNTHESIS

   wire [16:35] physAddr = {pageADDR[16:26], vmaREG[27:35]};

`endif

endmodule
