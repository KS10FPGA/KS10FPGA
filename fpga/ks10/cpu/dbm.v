////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DBM Multiplexer
//
// File
//   dbm.v
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

`include "useq/crom.vh"

module DBM (
      input  wire          rst,         // Reset
      input  wire          clk,         // Clock
      input  wire [ 0:107] crom,        // Control ROM Data
      input  wire [ 0: 35] dp,          // Datapath
      input  wire [ 0:  9] scad,        // SCAD
      input  wire [ 8: 11] dispPF,      // Page Fail Dispatch
      input  wire [22: 35] aprFLAGS,    // APR Flags
      input  wire [18: 35] timerCOUNT,  // Timer Count
      input  wire [ 0: 35] vmaREG,      // VMA Register
      input  wire [ 0: 35] cpuDATAI,    // Memory Bus Data
      output reg  [ 0: 35] dbm          // DBM output
   );

   //
   // DBM Bus Mux
   //
   // Details
   //  Special logic is available for grabbing BYTES from the dp bus.
   //
   // Trace
   //  Select Logic
   //   DPM1/E94
   //   DPM1/E72
   //   DPM1/E86
   //  DBM[0:6] MUX
   //   DPM1/E58
   //   DPM1/E42
   //   DPM1/E34
   //   DPM1/E65
   //   DPM1/E50
   //   DPM1/E49
   //   DPM1/E57
   //  DBM[7:13] MUX
   //   DPM1/E64
   //   DPM1/E59
   //   DPM1/E80
   //   DPM1/E73
   //   DPM1/E79
   //   DPM1/E81
   //   DPM1/E98
   //  DBM[14:20] MUX
   //   DPM1/E88
   //   DPM1/E89
   //   DPM1/E95
   //   DPM1/E96
   //   DPM2/E104
   //   DPM2/E105
   //   DPM2/E106
   //  DBM[21:27] MUX
   //   DPM2/E112
   //   DPM2/E113
   //   DPM2/E120
   //   DPM2/E128
   //   DPM2/E143
   //   DPM2/E129
   //   DPM2/E121
   //  DBM[28:35] MUX
   //   DPM2/E173
   //   DPM2/E151
   //   DPM2/E166
   //   DPM2/E167
   //   DPM2/E172
   //   DPM2/E187
   //   DPM2/E165
   //   DPM2/E188
   //

   reg [0:35] mux;
   always @*
     begin
        case (`cromDBM_SEL)
          `cromDBM_SEL_SCADPFAPR:
            mux = {scad[1:9], 8'b11111111, scad[0], dispPF, aprFLAGS};
          `cromDBM_SEL_BYTES :
            mux = {scad[1:7], scad[1:7], scad[1:7], scad[1:7], scad[1:7], dp[35]};
          `cromDBM_SEL_EXPTIME :
            mux = {1'b0, scad[2:9], dp[9:17], timerCOUNT[18:35]};
          `cromDBM_SEL_DP :
            case (`cromSPEC_SELBYTE)
              `cromSPEC_SELBYTE_1 :
                mux = {scad[1:7], dp[ 7:13], dp[14:20], dp[21:27], dp[28:34], dp[35]};
              `cromSPEC_SELBYTE_2 :
                mux = {dp[ 0: 6], scad[1:7], dp[14:20], dp[21:27], dp[28:34], dp[35]};
              `cromSPEC_SELBYTE_3 :
                mux = {dp[ 0: 6], dp[ 7:13], scad[1:7], dp[21:27], dp[28:34], dp[35]};
              `cromSPEC_SELBYTE_4 :
                mux = {dp[ 0: 6], dp[ 7:13], dp[14:20], scad[1:7], dp[28:34], dp[35]};
              `cromSPEC_SELBYTE_5 :
                mux = {dp[ 0: 6], dp[ 7:13], dp[14:20], dp[21:27], scad[1:7], dp[35]};
              default:
                mux = dp;
            endcase
          `cromDBM_SEL_DPSWAP :
            mux = {dp[18:35], dp[0:17]};
          `cromDBM_SEL_VMA :
            mux = vmaREG;
          `cromDBM_SEL_MEM :
            mux = cpuDATAI;
          `cromDBM_SEL_NUM :
            mux = {`cromNUM, `cromNUM};
        endcase
     end

   //
   // Register Mux on T4
   //

`define REGISTER_DBM
`ifdef REGISTER_DBM

   always @(posedge clk)
     begin
        dbm <= mux;
     end

`else

   always @*
     begin
        dbm <= mux;
     end

`endif

endmodule
