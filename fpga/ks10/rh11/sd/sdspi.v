////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Secure Digital SPI Interface
//
// Details
//   This interface communicates with the SDHC Chip at the physical layer.
//
// File
//   sdspi.v
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

`include "sdspi.vh"

module SDSPI (
      input  wire       clk,            // Clock
      input  wire       rst,            // Reset
      input  wire [2:0] spiOP,          // Operation
      input  wire [7:0] spiTXD,         // Transmit Data
      output wire [7:0] spiRXD,         // Receive Data
      input  wire       spiMISO,        // SD Data In
      output wire       spiMOSI,        // SD Data Out
      output wire       spiSCLK,        // SD Clock
      output reg        spiSS_N,        // SD Slave Select
      output reg        spiDONE         // Done
   );

   //
   // State Machine States
   //

   parameter [2:0] stateRESET = 0,
                   stateIDLE  = 1,
                   stateTXH   = 2,
                   stateTXL   = 3,
                   stateTXM   = 4,
                   stateTXN   = 5;

   //
   // Clock Speed Divisors
   //

   localparam [63:0] slowDiv = (1 + (`CLKFRQ / `SLOW_CLK));
   localparam [63:0] fastDiv =  1;

   //
   // State Variables
   //

   reg [2:0] state;
   reg [2:0] bitcnt;
   reg [7:0] txd;
   reg [7:0] rxd;
   reg [5:0] clkcnt;
   reg [5:0] clkdiv;

   always @(posedge clk)
     begin
        if (rst)
          begin
             spiDONE <= 0;
             txd     <= 8'hff;
             rxd     <= 8'hff;
             spiSS_N <= 1;
             bitcnt  <= 0;
             clkcnt  <= 0;
             clkdiv  <= slowDiv[5:0];
             state   <= stateRESET;
          end
        else
          case (state)

            //
            // StateRESET
            // Initialize variables
            //

            stateRESET:
              begin
                 clkdiv <= slowDiv[5:0];
                 state  <= stateIDLE;
              end

            //
            // StateIDLE
            // Wait for a command to start the state machine.
            //

            stateIDLE:
              begin
                 spiDONE <= 0;
                 case (spiOP)
                   `spiNOP:
                     ;
                   `spiCSL:
                     spiSS_N <= 0;
                   `spiCSH:
                     spiSS_N <= 1;
                   `spiFAST:
                     clkdiv <= fastDiv[5:0];
                   `spiSLOW:
                     clkdiv <= slowDiv[5:0];
                   `spiTR:
                     begin
                        clkcnt <= clkdiv;
                        bitcnt <= 7;
                        txd    <= spiTXD;
                        state  <= stateTXL;
                     end
                   default:
                     state <= stateIDLE;
                 endcase
              end

            //
            // Clock Low
            //

            stateTXL:
              if (clkcnt == 0)
                begin
                   clkcnt <= clkdiv;
                   rxd    <= {rxd[6:0], spiMISO};
                   state  <= stateTXH;
                end
              else
                clkcnt <= clkcnt - 1'b1;

            //
            // Clock High
            //

            stateTXH:
              if (clkcnt == 0)
                if (bitcnt == 0)
                  begin
                     clkcnt <= clkdiv;
                     state  <= stateTXM;
                  end
                else
                  begin
                     clkcnt <= clkdiv;
                     txd    <= {txd[6:0], 1'b1};
                     bitcnt <= bitcnt - 1'b1;
                     state  <= stateTXL;
                  end
              else
                clkcnt <= clkcnt - 1'b1;

            //
            // Last bit clock high
            //

            stateTXM:
              if (clkcnt == 0)
                begin
                   clkcnt <= clkdiv;
                   state  <= stateTXN;
                end
              else
                clkcnt <= clkcnt - 1'b1;

            //
            // Last bit clock low
            //

            stateTXN:
              if (clkcnt == 0)
                begin
                   clkcnt  <= clkdiv;
                   spiDONE <= 1;
                   state   <= stateIDLE;
                end
              else
                clkcnt <= clkcnt - 1'b1;

            //
            // Everything else
            //

            default:
              state <= stateIDLE;
          endcase
     end

   assign spiSCLK = (state != stateTXL);
   assign spiMOSI = txd[7];
   assign spiRXD  = rxd;

endmodule
