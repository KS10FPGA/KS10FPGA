////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Clock Divider
//
// Details
//   This divides the input clock frequency and synchronizes the reset input
//   to that clock.
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

module CLK(RESET_N, CLK50MHZ, clkT, clkR, clkPHS, ssramCLK, rst);

   input        RESET_N;
   input        CLK50MHZ;
   output       clkT;
   output       clkR;
   output [1:4] clkPHS;
   output       ssramCLK;
   output       rst;

   wire RESET = !RESET_N;

`ifdef XILINX

   //
   // The following code is Xilinx Spartan 6 specific.
   //

   wire clkfbo;
   wire clkfbi;
   wire uclkR;
   wire uclkT;
   wire locked;

   PLL_BASE #(
       .BANDWIDTH          ("OPTIMIZED"),
       .CLK_FEEDBACK       ("CLKFBOUT"),
       .COMPENSATION       ("SYSTEM_SYNCHRONOUS"),
       .DIVCLK_DIVIDE      (1),
       .CLKFBOUT_MULT      (8),
       .CLKFBOUT_PHASE     (0.000),
       .CLKOUT0_DIVIDE     (32),
       .CLKOUT0_PHASE      (0.000),
       .CLKOUT0_DUTY_CYCLE (0.500),
       .CLKOUT1_DIVIDE     (32),
       .CLKOUT1_PHASE      (180.000),
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
       .CLKFBIN            (clkfbi),
       .CLKOUT0            (uclkT),
       .CLKOUT1            (uclkR),
       .CLKOUT2            (clkPHS[1]),
       .CLKOUT3            (clkPHS[2]),
       .CLKOUT4            (clkPHS[3]),
       .CLKOUT5            (clkPHS[4]),
       .CLKFBOUT           (clkfbo),
       .LOCKED             (locked)
   );

   //
   // Clock Buffers
   //

   BUFG bufgCLKF (
       .I                  (clkfbo),
       .O                  (clkfbi)
   );

   BUFG bufgCLKT (
       .I                  (uclkT),
       .O                  (clkT)
   );

   BUFG bufgCLKR (
       .I                  (uclkR),
       .O                  (clkR)
   );

   //
   // Xilinx calls this 'clock forwarding'.  The synthesis tools will give
   // errors/warning if you attempt to drive a clock output off-chip without
   // this.
   //

   ODDR2 #(
       .DDR_ALIGNMENT      ("NONE"),    // Sets output alignment
       .INIT               (1'b0),      // Initial state of the Q output
       .SRTYPE             ("SYNC")     // Reset type: "SYNC" or "ASYNC"
   )
   iODDR2 (
       .Q                  (ssramCLK),  // 1-bit DDR output data
       .C0                 (!CLK50MHZ), // 1-bit clock input
       .C1                 (CLK50MHZ),  // 1-bit clock input
       .CE                 (1'b1),      // 1-bit clock enable input
       .D0                 (1'b1),      // 1-bit data input (associated with C0)
       .D1                 (1'b0),      // 1-bit data input (associated with C1)
       .R                  (1'b0),      // 1-bit reset input
       .S                  (1'b0)       // 1-bit set input
   );

   //
   // Synchronize reset
   //

   reg [1:0] d;
   always @(posedge clkT or negedge locked)
     begin
        if (!locked)
          d[1:0] <= 2'b11;
        else
          d[1:0] <= {d[0], 1'b0};
     end

   assign rst = d[1];

 `ifndef SYNTHESIS

   always @(posedge locked)
     $display("[%10.3f] CLK: PLL locked", $time/1.0e3);

 `endif

`else

   //
   // Clock Generator
   //

   parameter [0:1] stateT1 = 0,
                   stateT2 = 1,
                   stateT3 = 2,
                   stateT4 = 3;

   reg [0:1] clkState;
   reg [1:4] clkPHS;
   reg       clkT;
   reg       clkR;

   always @(posedge CLK50MHZ or posedge RESET)
     begin
        if (RESET)
          begin
             clkPHS[1] <= 0;
             clkPHS[2] <= 0;
             clkPHS[3] <= 0;
             clkPHS[4] <= 0;
             clkR      <= 0;
             clkT      <= 1;
             clkState  <= stateT1;
          end
        else
          begin
             case (clkState)
               stateT1:
                 begin
                    clkPHS[1] <= 1;
                    clkPHS[2] <= 0;
                    clkPHS[3] <= 0;
                    clkPHS[4] <= 0;
                    clkR      <= 0;
                    clkT      <= 1;
                    clkState  <= stateT2;
              end
               stateT2:
                 begin
                    clkPHS[1] <= 0;
                    clkPHS[2] <= 1;
                    clkPHS[3] <= 0;
                    clkPHS[4] <= 0;
                    clkR      <= 0;
                    clkT      <= 1;
                    clkState  <= stateT3;
                 end
               stateT3:
                 begin
                    clkPHS[1] <= 0;
                    clkPHS[2] <= 0;
                    clkPHS[3] <= 1;
                    clkPHS[4] <= 0;
                    clkR      <= 1;
                    clkT      <= 0;
                    clkState  <= stateT4;
                 end
               stateT4:
                 begin
                    clkPHS[1] <= 0;
                    clkPHS[2] <= 0;
                    clkPHS[3] <= 0;
                    clkPHS[4] <= 1;
                    clkR      <= 1;
                    clkT      <= 0;
                    clkState  <= stateT1;
                 end
             endcase
          end
     end

   //
   // SSRAM Clock Output
   //

   assign ssramCLK = !CLK50MHZ;

   //
   // Synchronize reset
   //

   reg [1:0] d;
   always @(posedge CLK50MHZ or posedge RESET)
     begin
        if (RESET)
          d[1:0] <= 2'b11;
        else
          d[1:0] <= {d[0], 1'b0};
     end

   assign rst = d[1];

`endif

endmodule
