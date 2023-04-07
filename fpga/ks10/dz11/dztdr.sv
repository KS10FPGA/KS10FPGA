////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DZ11 Transmit Data Register (TDR)
//
// Details
//   The module implements the DZ11 TDR Register.
//
// File
//   dztdr.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2023 Rob Doyle
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

`include "dztdr.vh"
`include "dzcsr.vh"
`include "dztcr.vh"

module DZTDR (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire         devRESET,             // Device Reset from UBA
      input  wire         devLOBYTE,            // Device Low Byte
      input  wire         devHIBYTE,            // Device High Byte
      input  wire [35: 0] dzDATAI,              // DZ Data In
      input  wire         tdrWRITE,             // Write to TDR
      output reg  [ 7: 0] uartTXLOAD,           // Load UART
      input  wire [ 7: 0] uartTXEMPTY,          // UART is empty
      input  wire         csrCLR,               // Controller clear
      input  wire         csrMSE,               // Master Scan Enable
      input  wire [ 7: 0] tcrLIN,               // Transmitter Control Register Line
      output reg  [ 2: 0] tdrTLINE,             // Transmitter Line Bits
      output wire         tdrTRDY,              // Transmitter Data Ready
      output wire [15: 0] regTDR                // TDR Output
   );

   //
   // State Machine states
   //

   localparam [1:0] stateSCAN =  0,
                    stateHOLD =  1,
                    stateWAIT =  2;

   //
   // Transmitter Scanner
   //

   logic [2:0] scan;
   logic [1:0] state;

   always_ff @(posedge clk)
     begin
        if (rst | devRESET | csrCLR)
          begin
             scan     <= 0;
             tdrTLINE <= 0;
             state    <= stateSCAN;
          end
        else

          case (state)

            //
            // Scan for an empty UART transmitter that is enabled.
            //

            stateSCAN:
              begin
                 if (csrMSE)

                   //
                   // Check for a line that is enabled that has an empty
                   // UART Transmitter.  Save the line in tdrTLINE.
                   //

                   if (((scan == 0) & tcrLIN[0] & uartTXEMPTY[0]) |
                       ((scan == 1) & tcrLIN[1] & uartTXEMPTY[1]) |
                       ((scan == 2) & tcrLIN[2] & uartTXEMPTY[2]) |
                       ((scan == 3) & tcrLIN[3] & uartTXEMPTY[3]) |
                       ((scan == 4) & tcrLIN[4] & uartTXEMPTY[4]) |
                       ((scan == 5) & tcrLIN[5] & uartTXEMPTY[5]) |
                       ((scan == 6) & tcrLIN[6] & uartTXEMPTY[6]) |
                       ((scan == 7) & tcrLIN[7] & uartTXEMPTY[7]))
                     begin
                        tdrTLINE <= scan;
                        state    <= stateHOLD;
                     end
                   else
                     begin
                        scan <= scan + 1'b1;
                     end
              end

            //
            // Hold the TLINE until data is written to the UART
            // transmitter.
            //

            stateHOLD:
              begin

                 //
                 // If the line is disabled while we are holding it
                 // (i.e., tcrLIN is modified), just dump it and go back
                 // to scanning.
                 //

                 if (((tdrTLINE == 0) & !tcrLIN[0]) |
                     ((tdrTLINE == 1) & !tcrLIN[1]) |
                     ((tdrTLINE == 2) & !tcrLIN[2]) |
                     ((tdrTLINE == 3) & !tcrLIN[3]) |
                     ((tdrTLINE == 4) & !tcrLIN[4]) |
                     ((tdrTLINE == 5) & !tcrLIN[5]) |
                     ((tdrTLINE == 6) & !tcrLIN[6]) |
                     ((tdrTLINE == 7) & !tcrLIN[7]))
                   begin
                      state <= stateSCAN;
                   end

                 //
                 // Data is being written to the UART transmitter.
                 //

                 else if (tdrWRITE & devLOBYTE)
                   begin
                      state <= stateWAIT;
                   end
              end

            //
            // Wait for the UART transmitter write cycle to complete
            // before resuming the scan.
            //

            stateWAIT:
              begin
                 if (!(tdrWRITE & devLOBYTE))
                   state <= stateSCAN;
              end

          endcase

     end

   assign tdrTRDY = (state != stateSCAN);

   //
   // Load the proper UART when writing to the TBUF
   //

   always_comb
     begin
        if (tdrWRITE & devLOBYTE)
          case (tdrTLINE)
            0: uartTXLOAD = 8'b0000_0001;
            1: uartTXLOAD = 8'b0000_0010;
            2: uartTXLOAD = 8'b0000_0100;
            3: uartTXLOAD = 8'b0000_1000;
            4: uartTXLOAD = 8'b0001_0000;
            5: uartTXLOAD = 8'b0010_0000;
            6: uartTXLOAD = 8'b0100_0000;
            7: uartTXLOAD = 8'b1000_0000;
          endcase
        else
          uartTXLOAD = 8'b0000_0000;
     end

   //
   // Break register
   //  While a BRK bit is set, the associated line transmits zeros continuously.
   //
   // Trace:
   //  M7819/S5/E16
   //  M7819/S5/E17
   //

   logic [7:0] tdrBRK;

   always_ff @(posedge clk)
     begin
        if (rst | devRESET | csrCLR)
          tdrBRK <= 0;
        else if (tdrWRITE & devHIBYTE)
          tdrBRK <= `dzTDR_BRK(dzDATAI);
     end

   //
   // Build TDR.
   //

   assign regTDR = {tdrBRK[7:0], `dzTDR_TBUF(dzDATAI)};

endmodule
