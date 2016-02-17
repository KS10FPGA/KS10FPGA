////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Clock Divider
//
// Details
//   This divides the input clock frequency and synchronizes the reset input to
//   that clock.
//
//   This file contains two implementations of the clock generator.  The first
//   one is totally generic.   The second is Xilinx specific and uses a PLL
//   primitive.
//
// File
//   clk.v
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

module CLK (
      input  wire       RESET_N,
      input  wire       CLK50MHZ,
      output wire       cpuCLK,
      output wire       memCLK,
      output wire       rst,
      output wire [1:4] clkPHS
   );

   wire locked;
   wire RESET = !RESET_N;

`ifdef XILINX

   //
   // The following code is Xilinx Spartan 6 specific.
   //

   wire clk50;          // 50.0 MHz
   wire clk12;          // 12.5 MHz

   //
   // Phase locked loop.  PLL is 400 MHz
   //

   PLL_BASE #(
       .BANDWIDTH          ("OPTIMIZED"),
       .CLK_FEEDBACK       ("CLKOUT0"),
       .COMPENSATION       ("SYSTEM_SYNCHRONOUS"),
       .DIVCLK_DIVIDE      (1),
       .CLKFBOUT_MULT      (1),
       .CLKFBOUT_PHASE     (0.000),
       .CLKOUT0_DIVIDE     (8),
       .CLKOUT0_PHASE      (0.000),
       .CLKOUT0_DUTY_CYCLE (0.500),
       .CLKOUT1_DIVIDE     (32),
       .CLKOUT1_PHASE      (0.000),
       .CLKOUT1_DUTY_CYCLE (0.500),
       .CLKOUT2_DIVIDE     (32),
       .CLKOUT2_PHASE      (0.000),
       .CLKOUT2_DUTY_CYCLE (0.250),
       .CLKOUT3_DIVIDE     (32),
       .CLKOUT3_PHASE      (90.000),
       .CLKOUT3_DUTY_CYCLE (0.250),
       .CLKOUT4_DIVIDE     (32),
       .CLKOUT4_PHASE      (180.000),
       .CLKOUT4_DUTY_CYCLE (0.250),
       .CLKOUT5_DIVIDE     (32),
       .CLKOUT5_PHASE      (270.000),
       .CLKOUT5_DUTY_CYCLE (0.250),
       .CLKIN_PERIOD       (20.0),
       .REF_JITTER         (0.010)
   )
   iPLL_BASE (
       .RST                (RESET),
       .CLKIN              (CLK50MHZ),
       .CLKFBIN            (memCLK),
       .CLKOUT0            (clk50),
       .CLKOUT1            (clk12),
       .CLKOUT2            (clkPHS[1]),
       .CLKOUT3            (clkPHS[2]),
       .CLKOUT4            (clkPHS[3]),
       .CLKOUT5            (clkPHS[4]),
       .CLKFBOUT           (),
       .LOCKED             (locked)
   );

   //
   // Output clock buffers
   //

   BUFG bufgCLKF (
       .I                  (clk50),
       .O                  (memCLK)
   );

   BUFG bufgCLKO (
       .I                  (clk12),
       .O                  (cpuCLK)
   );

`else

   //
   // 4 phase clock Generator for SSRAM
   //

   parameter [1:4] clkT1 = 4'b1000,
                   clkT2 = 4'b0100,
                   clkT3 = 4'b0010,
                   clkT4 = 4'b0001;

   //
   // State Machine
   //

   reg cpuCLKb;
   reg [1:4] clkPHSb;

   always @(posedge CLK50MHZ or posedge RESET)
     begin
        if (RESET)
          begin
             clkPHSb <= clkT1;
             cpuCLKb <= 0;
          end
        else
          begin
             case (clkPHSb)
               clkT1:
                 begin
                    clkPHSb <= clkT2;
                    cpuCLKb <= 1;
                 end
               clkT2:
                 begin
                    clkPHSb <= clkT3;
                    cpuCLKb <= 1;
                 end
               clkT3:
                 begin
                    clkPHSb <= clkT4;
                    cpuCLKb <= 0;
                 end
               clkT4:
                 begin
                    clkPHSb <= clkT1;
                    cpuCLKb <= 0;
                 end
               default:
                 begin
                    clkPHSb <= clkT1;
                    cpuCLKb <= 0;
                 end
             endcase
          end
     end

   //
   // Fixup Outputs
   //

   assign locked = 1'b1;
   assign memCLK = CLK50MHZ;
   assign cpuCLK = cpuCLKb;
   assign clkPHS = clkPHSb;

`endif

   //
   // Synchronize reset
   //

   reg [2:0] d;
   always @(posedge cpuCLK or posedge RESET)
     begin
        if (RESET)
          d <= 3'b111;
        else
          d <= {d[1:0], !locked};
     end

   assign rst = d[2];

   //
   // Debugging
   //

`ifndef SYNTHESIS

   always @(posedge locked)
     $display("[%11.3f] CLK: PLL locked", $time/1.0e3);

`endif

endmodule
