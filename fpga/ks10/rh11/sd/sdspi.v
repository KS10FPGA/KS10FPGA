////////////////////////////////////////////////////////////////////
//
// KS10 Processor
//
// Brief
//   Secure Digital SPI Interface
//
// Details
//   This interface communicates with the Secure Digital Chip
//   at the physical layer.
//
// File
//   sdspi.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2012 Rob Doyle
//
// This source file may be used and distributed without
// restriction provided that this copyright statement is not
// removed from the file and that any derivative work contains
// the original copyright notice and the associated disclaimer.
//
// This source file is free software; you can redistribute it
// and/or modify it under the terms of the GNU Lesser General
// Public License as published by the Free Software Foundation;
// version 2.1 of the License.
//
// This source is distributed in the hope that it will be
// useful, but WITHOUT ANY WARRANTY; without even the implied
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
// PURPOSE. See the GNU Lesser General Public License for more
// details.
//
// You should have received a copy of the GNU Lesser General
// Public License along with this source; if not, download it
// from http://www.gnu.org/licenses/lgpl.txt
//
////////////////////////////////////////////////////////////////////

`include "sdspi.vh"

module SDSPI(clk, rst, spiOP, spiTXD, spiRXD,
             spiMISO, spiMOSI, spiSCLK, spiCS, spiDONE);

   input        clk;            // Clock
   input        rst;            // Reset
   input  [1:0] spiOP;          // Operation
   input  [7:0] spiTXD;         // Transmit Data
   output [7:0] spiRXD;         // Receive Data
   input        spiMISO;        // SD Data In
   output       spiMOSI;        // SD Data Out
   output       spiSCLK;        // SD Clock
   output       spiCS;          // SD Chip Select
   output       spiDONE;        // Done

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

   parameter [5:0] slowDiv = 63;
   parameter [5:0] fastDiv =  1;

   //
   // State Variables
   //

   reg [2:0]    state;
   reg [2:0]    bitcnt;
   reg [7:0]    txd;
   reg [7:0]    rxd;
   reg [5:0]    clkcnt;
   reg [5:0]    clkdiv;
   reg          spiDONE;
   reg          spiCS;

   always @(posedge clk)
     begin
        if (rst)
          begin
             spiDONE <= 0;
             txd     <= 8'b1111_1111;
             rxd     <= 8'b1111_1111;
             spiCS   <= 1;
             bitcnt  <= 0;
             clkcnt  <= 0;
             clkdiv  <= slowDiv;
             state   <= stateRESET;
          end
        else
          begin
             case (state)

               //
               // StateRESET
               // Initialize variables
               //

               stateRESET:
                 begin
                    clkdiv  <= slowDiv;
                    state   <= stateIDLE;
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
                        begin
                           ;
                        end
                      `spiCSL:
                        begin
                           spiCS <= 0;
                        end
                      `spiCSH:
                        begin
                           spiCS <= 1;
                        end
                      `spiFAST:
                        begin
                           clkdiv <= fastDiv;
                        end
                      `spiSLOW:
                        begin
                           clkdiv <= slowDiv;
                        end
                      `spiTR:
                        begin
                           clkcnt <= clkdiv;
                           bitcnt <= 7;
                           txd    <= spiTXD;
                           state  <= stateTXL;
                        end
                      default:
                        begin
                           state <= stateIDLE;
                        end
                    endcase;
                 end

               //
               // Clock Low
               //

               stateTXL:
                 begin
                    if (clkcnt == 0)
                      begin
                         clkcnt <= clkdiv;
                         rxd    <= {rxd[6:0] & spiMISO};
                         state  <= stateTXH;
                      end
                    else
                      begin
                         clkcnt <= clkcnt - 1'b1;
                      end
                 end

               //
               // Clock High
               //

               stateTXH:
                 begin
                    if (clkcnt == 0)
                      begin
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
                      end
                    else
                      begin
                         clkcnt <= clkcnt - 1;
                      end
                 end

               //
               // Last bit clock high
               //

               stateTXM:
                 begin
                    if (clkcnt == 0)
                      begin
                         clkcnt <= clkdiv;
                         state  <= stateTXN;
                      end
                    else
                      begin
                         clkcnt <= clkcnt - 1'b1;
                      end
                 end

               //
               // Lst bit clock low
               //

               stateTXN:
                 begin
                    if (clkcnt == 0)
                      begin
                         clkcnt  <= clkdiv;
                         spiDONE <= 1;
                         state   <= stateIDLE;
                      end
                    else
                      begin
                         clkcnt <= clkcnt - 1;
                      end
                 end

               //
               // Everything else
               //

               default:
                 begin
                    state <= stateIDLE;
                 end
             endcase
          end
     end


   assign spiSCLK = (state != stateTXL);
   assign spiMOSI = txd[0];
   assign spiRXD  = rxd;

endmodule
