////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   LP20 Printer Interface
//
// Details
//   The module implements printer interface.
//
// File
//   lppdat.v
//
// Note
//   The interface to the printer is via a serial data link.  The protocol
//   is hardwired to 115200N81 but can be changed by recompiling the code.
//
//   The UART receiver is only implemented to handle XON/XOFF handshaking.
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2017 Rob Doyle
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

`include "lpcsra.vh"
`include "lpramd.vh"

`define EXPAND_TABS

module LPPDAT (
      input  wire         clk,          // Clock
      input  wire         rst,          // Reset
      input  wire         devREQO,      // Device request out
      input  wire         devACKI,      // Device acknowledge in
      input  wire         lpINIT,       // Init
      input  wire [ 7: 0] lpCBUF,       // CBUF input
      input  wire [15: 0] lpRAMD,       // RAMD input
      input  wire [ 7: 0] lpCCTR,       // CCTR input
      input  wire         lpMODETEST,   // Test mode
      input  wire         lpMODEPRINT,  // Print mode
      input  wire         lpMODELDVFU,  // Load DVFU mode
      input  wire         lpTESTDTE,    // Test demand timemout
      input  wire         lpTESTLPE,    // Test line printer parity
      input  wire         lpDHLD,       // Delimiter hold
      input  wire         lpCMDGO,      // DMA is active
      output reg          lpCLRCCTR,    // Clear CCTR
      output reg          lpINCCCTR,    // Increment CCTR
      output reg          lpSETUNDC,    // Character is undefined
      output wire         lpSETDTE,     // Demand timeout error
      output wire         lpREADY,      // Enable DMA for next character
      output wire         lpLPE,        // Printer parity error
      output reg          lpVAL,        // Printer data valid
      output reg  [ 7: 0] lpPDAT,       // Printer data register
      // Printer interfaces
      input  wire         lpPARERR,     // Printer reports parity error
      input  wire         lpDEMAND,     // Printer is ready for next character.
      output wire         lpDPAR,       // Line printer data parity
      output reg          lpPI,         // Printer paper instruction
      output reg          lpSTROBE,     // Printer strobe
      output reg  [ 8: 1] lpDATA        // Printer data
   );

   //
   // Get ASCII character definitions
   //

`include "ascii.vh"

   //
   // DMA write
   //

   wire lpDMAWR = devREQO & devACKI;

   //
   // Lookup printer operation
   //
   //  Depending on state, the printer may:
   //  0. Print the character that is in the Character Buffer Register
   //  1. Print the translated character from the tranlation RAM.
   //  2. Send the character to the DVFU.  It is carriage control.
   //  3. Raise an interrupt to handle an error condition.
   //
   //  The state is a function of the control bits in the RAM data register plus
   //  the Delimiter Hold bit.
   //
   //  See LP20 Line Printer System Manual (EK-LP20-TM-004), Table 4-5
   //

   localparam [1:0] printCBUF = 0,
                    printRAMD = 1,
                    printDVFU = 2,
                    raiseINTR = 3;

   reg [1:0] lpOP;
   always @*
     begin
        case ({`lpRAMD_CTRL(lpRAMD), lpDHLD})
          0: lpOP = printCBUF;
          1: lpOP = printRAMD;
          2: lpOP = printCBUF;
          3: lpOP = printDVFU;
          4: lpOP = printRAMD;
          5: lpOP = printRAMD;
          6: lpOP = printDVFU;
          7: lpOP = printDVFU;
          8: lpOP = printRAMD;
          9: lpOP = printRAMD;
         10: lpOP = printDVFU;
         11: lpOP = printDVFU;
         12: lpOP = printRAMD;
         13: lpOP = printRAMD;
         14: lpOP = printDVFU;
         15: lpOP = printDVFU;
         16: lpOP = raiseINTR;
         17: lpOP = raiseINTR;
         18: lpOP = raiseINTR;
         19: lpOP = raiseINTR;
         20: lpOP = printRAMD;
         21: lpOP = raiseINTR;
         22: lpOP = printDVFU;
         23: lpOP = raiseINTR;
         24: lpOP = raiseINTR;
         25: lpOP = raiseINTR;
         26: lpOP = raiseINTR;
         27: lpOP = raiseINTR;
         28: lpOP = raiseINTR;
         29: lpOP = raiseINTR;
         30: lpOP = raiseINTR;
         31: lpOP = raiseINTR;
        endcase
     end

   //
   // The translation RAM has a clock cycle delay
   //

   reg [2:0] strobe;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          strobe <= 0;
        else
          strobe <= {strobe[1:0], lpDMAWR};
     end

   //
   // Line printer demand timeout errors
   //

   assign lpSETDTE = strobe[0] & lpTESTDTE;

   //
   // Line printer data parity out
   //

   assign lpDPAR = ~^{lpTESTLPE, lpPI, lpDATA};

   //
   // Valid printer data
   //
   // Trace
   //  M8586/LPC9/E50
   //  M8586/LPC9/E58
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          lpVAL <= 0;
        else
          if (lpINIT)
            lpVAL <= 0;
          else if (lpCMDGO)
            lpVAL <= 0;
          else if (lpSTROBE)
            lpVAL <= !lpVAL;
     end

   //
   // State Machine
   //

   localparam [3:0] stateIDLE   =  0,   // Wait for something to do
                    statePARSE  =  1,   // Examine the characters
                    stateWRAPLF =  2,   // Send linefeed on line wrap
                    stateTAB    =  3,   // Expand tabs to spaces
                    stateWRAPCH =  4,   // Send the wrapped char
                    stateDVFU   =  5,   // Send a DVFU char
                    stateWAIT   =  6,   // Wait for UART to finish
                    stateDELAY  =  7;   // Delay

   reg [3:0] state;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             lpPI      <= 0;
             lpDATA    <= 0;
             lpSTROBE  <= 0;
             lpCLRCCTR <= 0;
             lpINCCCTR <= 0;
             lpSETUNDC <= 0;
             lpPDAT    <= 0;
             state     <= stateIDLE;
          end
        else
          begin

             lpSTROBE  <= 0;
             lpCLRCCTR <= 0;
             lpINCCCTR <= 0;
             lpSETUNDC <= 0;

             case (state)

               //
               // stateIDLE
               //  Wait for a DMA transaction.
               //

               stateIDLE:
                 if (strobe[0])
                   begin

                      //
                      // Load DAVFU.
                      //

                      if (lpMODELDVFU)
                        begin
                           lpPDAT <= lpCBUF;
                           state  <= stateDVFU;
                        end

                      //
                      // Print something
                      //

                      else if (lpMODEPRINT | lpMODETEST)

                        case (lpOP)

                          //
                          // Print character from CBUF
                          //

                          printCBUF:
                            begin
                               lpPDAT <= lpCBUF;
                               state  <= statePARSE;
                            end

                          //
                          // Print character from Traslation RAM
                          //

                          printRAMD:
                            begin
                               lpPDAT <= lpRAMD[7:0];
                               state  <= statePARSE;
                            end

                          //
                          // Send character to DVFU
                          //  The character can cause either absolute motion
                          //  (channel command) or relative motion (slew command).
                          //

                          printDVFU:
                            begin
                               lpPDAT <= lpRAMD[7:0];
                               state  <= stateDVFU;
                            end

                          //
                          // Raise an interrupt
                          //  This should set the CSRA[UNDC] bit.
                          //

                          raiseINTR:
                            lpSETUNDC <= 1;

                        endcase

                   end

               //
               // statePARSE
               //  Examine the character.  Decide what to do with it.
               //

               statePARSE:

                 //
                 // Examine the character
                 //

                 case (lpPDAT)

                   //
                   // Null characters are Escape (No Action) characters.  They
                   // are not forwarded to the printer.
                   //
                   // Trace
                   //  M8587/LPD5/E26
                   //  M8587/LPD5/E41
                   //  M8587/LPD6/E51
                   //

                   asciiNUL:
                     state <= stateWAIT;

                   //
                   // Carriage return, line feed, form feed, and vertical tabs
                   // are fowarded to the printer and terminate a line.  The
                   // column counter is cleared.
                   //
                   // Trace
                   //   M8587/LPD5/E31
                   //   M8587/LPD5/E41
                   //   M8587/LPD5/E54
                   //   M8587/LPD5/E67
                   //

                   asciiCR,
                   asciiVT,
                   asciiLF,
                   asciiFF:
                     begin
                        if (lpDEMAND)
                          begin
                             lpPI      <= 0;
                             lpDATA    <= lpPDAT;
                             lpSTROBE  <= 1;
                             lpCLRCCTR <= 1;
                             state     <= stateWAIT;
                          end
                     end

                   //
                   // Tab character
                   //

                   asciiTAB:
                     if (lpDEMAND)
`ifdef EXPAND_TABS
                       begin
                          lpPI      <= 0;
                          lpDATA    <= asciiSP;
                          lpSTROBE  <= 1;
                          lpINCCCTR <= 1;
                          state     <= stateTAB;
                       end
`else
                       begin
                          lpPI      <= 0;
                          lpDATA    <= lpPDAT;
                          lpSTROBE  <= 1;
                          state     <= stateWAIT;
                       end
`endif

                   //
                   // Everything else is printable.  These modify the character
                   // counter and must be counted for line wraps.
                   //
                   // Handle line wraps
                   //

                   default:
                     if (lpDEMAND)
                       if (lpCCTR == 132)
                         begin
                            lpPI      <= 0;
                            lpDATA    <= asciiCR;
                            lpSTROBE  <= 1;
                            lpCLRCCTR <= 1;
                            state     <= stateWRAPLF;
                         end
                       else
                         begin
                            lpPI      <= 0;
                            lpDATA    <= lpPDAT;
                            lpSTROBE  <= 1;
                            lpINCCCTR <= 1;
                            state     <= stateWAIT;
                         end

                 endcase

               //
               // stateWRAPLF
               //

               stateWRAPLF:
                 if (lpDEMAND)
                   begin
                      lpPI      <= 0;
                      lpDATA    <= asciiLF;
                      lpSTROBE  <= 1;
                      lpCLRCCTR <= 1;
                      state     <= stateWRAPCH;
                   end

               //
               // stateWRAPCH
               //  Print the character after the linewrap
               //

               stateWRAPCH:
                 if (lpDEMAND)
                   begin
                      lpPI      <= 0;
                      lpDATA    <= lpPDAT;
                      lpSTROBE  <= 1;
                      lpINCCCTR <= 1;
                      state     <= stateWAIT;
                   end

               //
               // stateTAB
               //  Expand horizonal tabs to spaces
               //

               stateTAB:
                 if (lpDEMAND)
                   if (lpCCTR[2:0] == 0)
                     state <= stateWAIT;
                   else
                     begin
                        lpPI      <= 0;
                        lpDATA    <= asciiSP;
                        lpSTROBE  <= 1;
                        lpINCCCTR <= 1;
                     end

               //
               // stateDVFU:
               //  Send DVFU character to printer
               //
               //  Trace:
               //   M8587/LPD1/E27
               //   M8587/LPD1/E33
               //   M8587/LPD1/E35
               //

               stateDVFU:
                 if (lpDEMAND)
                   begin
                      lpPI      <= 1'b1;
                      lpDATA    <= {1'b0, lpPDAT[6:0]};
                      lpSTROBE  <= 1;
                      lpCLRCCTR <= 1;
                      state     <= stateWAIT;
                   end

               //
               //  Wait for UART to finish
               //

               stateWAIT:
                 if (lpDEMAND)
                   state <= stateDELAY;

               //
               // stateDELAY
               //  Wait for printer to update status
               //

               stateDELAY:
                 state <= stateIDLE;

             endcase
          end
     end

   //
   // lpREADY
   //  Notify the DMA controller to get the next byte
   //

   assign lpREADY = (state == stateIDLE) & lpDEMAND;

   //
   // lpLPE
   //  Line printer parity error
   //
   //  Trace
   //    M8587/LPD6/E20
   //    M8587/LPD6/E23
   //

   assign lpLPE = !lpMODETEST & lpPARERR;

endmodule
