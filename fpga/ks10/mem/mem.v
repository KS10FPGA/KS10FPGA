////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KS-10 Memory Interface
//
// Details
//   This module is interface between the KS10 backplane bus and the SSRAM.
//
//   This module can support either a CY7C1460 pipelined 36-bit wide SSRAM, a
//   CY7C1463 flowthrough 18-bit wide SSRAM using a "two 18-bit word burst",
//   or internal block RAM.
//
//   The burst mode 18-bit interface saves a significant number of IO pins on
//   the SSRAM interface.
//
//   Many of the simple diagnostics will execute in 32K words of memory.
//
//   The SSRAM OE# pin is tied low.  This is permitted per the CY7C1460AV33
//   data sheet. Quoting the section entitled "Single Write Accesses" it
//   states that "On the subsequent clock rise the data lines are
//   automatically tri-stated regardless of the state of the OE input signal."
//
// File
//   mem.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2020 Rob Doyle
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

`include "../uba/uba.vh"
`include "../cpu/bus.vh"

module MEM (
      input  wire         rst,          // Reset
      input  wire         memCLK,       // Memory clock
      input  wire [ 1: 4] clkT,         // Clock
      input  wire         writeEN,      // Write Enable
      output wire         SSRAM_CLK,    // SSRAM Clock
      output wire         SSRAM_WE_N,   // SSRAM WE#
      output wire         SSRAM_ADV,    // SSRAM Advance
`ifdef SSRAMx36
      output wire [19: 0] SSRAM_A,      // SSRAM Address Bus
      inout  wire [35: 0] SSRAM_D,      // SSRAM Data Bus
`else
      output wire [21: 0] SSRAM_A,      // SSRAM Address Bus
      inout  wire [17: 0] SSRAM_D,      // SSRAM Data Bus
`endif
      input  wire         busREQI,      // Memory Request In
      output wire         busACKO,      // Memory Acknowledge Out
      input  wire [ 0:35] busADDRI,     // Address Address In
      input  wire [ 0:35] busDATAI,     // Data in
      output wire [ 0:35] busDATAO      // Data out
   );

   //
   // The Memory Conroller is Device 0
   //

   localparam [ 0: 3] memDEV  = `devUBA0;

   //
   // Memory Status Register IO Address
   //

   localparam [18:35] addrMSR = 18'o100000;

   //
   // Halt Status Block Address
   //

   localparam [16:35] addrHSB = 20'o0376000;

   //
   // Memory flags
   //
   // Details:
   //  busADDRI[ 0:13] is flags
   //  busADDRI[14:35] is address
   //

   wire         busREAD    = `busREAD(busADDRI);
   wire         busWRTEST  = `busWRTEST(busADDRI);
   wire         busWRITE   = `busWRITE(busADDRI);
   wire         busPHYS    = `busPHYS(busADDRI);
   wire         busIO      = `busIO(busADDRI);
   wire [ 0: 3] busDEV     = `busDEV(busADDRI);
   wire [18:35] busIOADDR  = `busIOADDR(busADDRI);
   wire [16:35] busMEMADDR = `busMEMADDR(busADDRI);

   //
   // Address decoding
   //

   wire msrREAD   = busREAD   &  busIO & busPHYS & (busDEV == memDEV) & (busIOADDR == addrMSR);
   wire msrWRITE  = busWRITE  &  busIO & busPHYS & (busDEV == memDEV) & (busIOADDR == addrMSR);
   wire memREAD   = busREAD   & !busIO;
   wire memWRITE  = busWRITE  & !busIO;
   wire memWRTEST = busWRTEST & !busIO;

   //
   // Memory Status Register
   //

   wire [0:35] regSTAT;

   MEMSTAT STAT (
      .rst       (rst),
      .clk       (clkT[1]),
      .busDATAI  (busDATAI),
      .msrWRITE  (msrWRITE),
      .regSTAT   (regSTAT)
   );

   //
   // 32K Block RAM
   //

`ifdef SSRAM_BLKRAM

   reg  [0:35] mem[0:32767];
   reg  [0:14] rd_mem_addr;
   wire [0:14] wr_mem_addr = busMEMADDR[21:35];

   reg  [0:35] hsb[0:31];
   reg  [0: 4] rd_hsb_addr;
   wire [0: 4] wr_hsb_addr = busMEMADDR[31:35];

   wire hsbVALID = (busMEMADDR[16:30] == addrHSB[16:30]);
   wire memVALID = (busMEMADDR[16:20] == 0);

`ifndef SYNTHESIS

   initial
     $readmemh(`SSRAM_DAT, mem);

`endif

   always @(posedge clkT[3])
     begin
        if (memWRITE & memVALID)
          mem[wr_mem_addr] <= busDATAI;
        rd_mem_addr <= wr_mem_addr;
     end

   //
   // SRAM for Halt Status Block
   //

   always @(posedge clkT[3])
     begin
        if (memWRITE & hsbVALID)
          hsb[wr_hsb_addr] <= busDATAI;
        rd_hsb_addr <= wr_hsb_addr;
     end

   assign busDATAO  = busIO ? regSTAT : (memVALID ? mem[rd_mem_addr] : hsb[rd_hsb_addr]);
   assign busACKO   = msrREAD | msrWRITE | (memVALID | hsbVALID) & (memREAD | memWRITE | memWRTEST);

`endif

   //
   // 36-bit wide pipelined SSRAM interface
   //

`ifdef SSRAMx36

   assign SSRAM_CLK  = !memCLK;
   assign SSRAM_WE_N = !(memWRITE & (clkT == 4'b1001));
   assign SSRAM_A    = busMEMADDR;
   assign SSRAM_D    = memWRITE ? busDATAI : 36'bz;
   assign SSRAM_ADV  = 0;
   assign busDATAO   = busIO ? regSTAT : SSRAM_D;
   assign busACKO    = msrREAD | msrWRITE | memREAD | memWRITE | memWRTEST;

`endif

   //
   // 18-bit flow-through SSRAM Interface with 2 word burst
   //

`ifdef SSRAMx18

   //
   // Delay Write Enable from T3 and T4 into T1 and T2
   //

   reg ssramWE;
   always @(posedge memCLK)
     begin
        ssramWE <= memWRITE & ((clkT == 4'b1001) | (clkT == 4'b1100));
     end

   //
   // ssramA[0] is asserted in T2 and T3.
   //

   reg ssramA0;

   always @(posedge memCLK)
     begin
        if (rst)
          ssramA0 <= 0;
        else
          ssramA0 <= ((clkT == 4'b1001) | (clkT == 4'b0110));
     end

   //
   // Create output data
   //  D[ 0:17] is asserted on SSRMA_D in T2
   //  D[18:35] is asserted on SSRAM_D in T3
   //
   //  SSRAM samples data in middle of T3 and T4
   //

   reg [0:17] ssramDO;
   always @(posedge memCLK)
     if (rst)
       ssramDO <= 18'b0;
     else if (clkT == 4'b1100)
       ssramDO <= busDATAI[18:35];
     else
       ssramDO <= busDATAI[ 0:17];

   //
   // Capture data from SSRAM
   //
   //  D[ 0:17] is captured on SSRMA_D in T2
   //  D[18:35] is captured on SSRAM_D in T3
   //

   reg [0:35] ssramDI;
   always @(posedge SSRAM_CLK)
      begin
        if (rst)
          ssramDI <= 0;
        else
          begin
             if (clkT == 4'b1100)
               ssramDI[ 0:17] <= SSRAM_D;
             if (clkT == 4'b0110)
               ssramDI[18:35] <= SSRAM_D;
          end
      end

   assign SSRAM_CLK  = !memCLK;
   assign SSRAM_WE_N = !ssramWE;
   assign SSRAM_A    = {1'b0, busMEMADDR, ssramA0};
   assign SSRAM_D    = memWRITE ? ssramDO : {18{1'bz}};
   assign SSRAM_ADV  = 0;
   assign busDATAO   = busIO ? regSTAT : ssramDI;
   assign busACKO    = msrREAD | msrWRITE | memREAD | memWRITE | memWRTEST;

`endif

   //
   // Simulation/Debug
   //

`ifndef SYNTHESIS

   initial
     begin
       `ifdef SSRAM_BLKRAM
          $display("[%11.3f] KS10: Memory configured for Block RAM.", $time/1.0e3);
       `else
          `ifdef SSRAMx18
             $display("[%11.3f] KS10: Memory configured for 18-bit SSRAM.", $time/1.0e3);
          `else
             `ifdef SSRAMx36
                $display("[%11.3f] KS10: Memory configured for 36-bit SSRAM.", $time/1.0e3);
             `else
                $display("[%11.3f] KS10: Memory is not configured.  This won't work.", $time/1.0e3);
             `endif
          `endif
       `endif
     end


   always @(posedge clkT[3])
     begin
        if (msrREAD)
          $display("[%11.3f] KS10: Memory Status Register Read", $time/1.0e3);
        if (msrWRITE)
          $display("[%11.3f] KS10: Memory Status Register Written", $time/1.0e3);
     end

`endif

endmodule
