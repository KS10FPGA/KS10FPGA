////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DZ11 Control and Status Register (CSR)
//
// Details
//   The module implements the DZ11 CSR Register.
//
// File
//   dzcsr.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2015 Rob Doyle
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

`include "dzcsr.vh"
`include "dztcr.vh"
`include "../ks10.vh"

module DZCSR (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire         devRESET,             // Device Reset from UBA
      input  wire         devLOBYTE,            // Device Low Byte
      input  wire         devHIBYTE,            // Device High Byte
      input  wire [ 0:35] devDATAI,             // Device Data In
      input  wire         csrWRITE,             // Write to CSR
      input  wire         tdrWRITE,             // Write to TDR
      input  wire         rbufRDONE,            // RBUF Receiver Done
      input  wire         rbufSA,               // RBUF Silo Alarm
      input  wire [ 7: 0] uartTXEMPTY,          // UART transmitter buffer empty
      input  wire [15: 0] regTCR,               // TCR Register
      output wire [15: 0] regCSR                // CSR Output
   );

   //
   // CSRPER parameter
   //
   // Details
   //  The CSR[CLR] is a 15us one-shot in the KS10.  Because the KS10 FPGA runs
   //  faster than DEC KS10, the CLR timing needs to be adjusted or the DSDZA
   //  diagnostic will fail when it measures this period.  The DZ11 doesn't
   //  care.  The clear only takes a single clock cycle.
   //

   localparam CSRPER = 3.0;                     // 3.0 microseconds

   //
   // Big-endian to little-endian data bus swap
   //

   wire [35:0] dzDATAI = devDATAI[0:35];

   //
   // TCR[LIN] bits
   //

   wire [ 7:0] tcrLIN  = `dzTCR_LIN(regTCR);

   //
   // CSR[CLR]
   //
   // Details
   //  See note associated with CSRPER parameter
   //

   reg [9:0] clrCOUNT;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          clrCOUNT <= 0;
        else
          begin
             if (devRESET)
               clrCOUNT <= 0;
             if (csrWRITE & devLOBYTE & `dzCSR_CLR(dzDATAI))
               clrCOUNT <= CSRPER * `CLKFRQ / 1000000;
             else if (clrCOUNT != 0)
               clrCOUNT <= clrCOUNT - 1'b1;
          end
     end

   wire csrCLR = (clrCOUNT != 0);

   //
   // CSR Read/Write bits
   //
   // Details
   //  These bits can be written as bytes or words.
   //

   reg csrTIE;
   reg csrSAE;
   reg csrRIE;
   reg csrMSE;
   reg csrMAINT;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             csrTIE   <= 0;
             csrSAE   <= 0;
             csrRIE   <= 0;
             csrMSE   <= 0;
             csrMAINT <= 0;
          end
        else
          begin
             if (csrCLR | devRESET)
               begin
                  csrTIE   <= 0;
                  csrSAE   <= 0;
                  csrRIE   <= 0;
                  csrMSE   <= 0;
                  csrMAINT <= 0;
               end
             else if (csrWRITE)
               begin
                  if (devHIBYTE)
                    begin
                       csrTIE   <= `dzCSR_TIE(dzDATAI);
                       csrSAE   <= `dzCSR_SAE(dzDATAI);
                    end
                  if (devLOBYTE)
                    begin
                       csrRIE   <= `dzCSR_RIE(dzDATAI);
                       csrMSE   <= `dzCSR_MSE(dzDATAI);
                       csrMAINT <= `dzCSR_MAINT(dzDATAI);
                    end
               end
          end
     end

   //
   // State Machine states
   //

   localparam [1:0] stateSCAN =  0,
                    stateHOLD =  1,
                    stateWAIT =  2;

   //
   // Transmitter Scanner
   //

   reg [2:0] scan;
   reg [1:0] state;
   reg [2:0] csrTLINE;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             scan     <= 0;
             csrTLINE <= 0;
             state    <= stateSCAN;
          end
        else
          begin
             if (csrCLR | devRESET)
               begin
                  scan     <= 0;
                  csrTLINE <= 0;
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
                        // UART Transmitter.  Save the line in csrTLINE.
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
                             csrTLINE <= scan;
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
                      // (i.e., tcrLIN ia modified), just dump it and go back
                      // to scanning.
                      //

                      if (((csrTLINE == 0) & !tcrLIN[0]) |
                          ((csrTLINE == 1) & !tcrLIN[1]) |
                          ((csrTLINE == 2) & !tcrLIN[2]) |
                          ((csrTLINE == 3) & !tcrLIN[3]) |
                          ((csrTLINE == 4) & !tcrLIN[4]) |
                          ((csrTLINE == 5) & !tcrLIN[5]) |
                          ((csrTLINE == 6) & !tcrLIN[6]) |
                          ((csrTLINE == 7) & !tcrLIN[7]))
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
     end

   wire csrTRDY = (state != stateSCAN);

   //
   // Build CSR
   //

   assign regCSR = {csrTRDY,  csrTIE, rbufSA, csrSAE,  1'b0, csrTLINE[2:0],
                    rbufRDONE, csrRIE, csrMSE, csrCLR, csrMAINT, 3'b0};

endmodule
