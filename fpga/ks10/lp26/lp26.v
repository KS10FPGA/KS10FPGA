////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   LP26 Printer Emulator
//
// Details
//   This file provides the implementation of a DEC LP26 printer.
//
// File
//   lp26.v
//
// Note:
//   Most of this information is from "LP26 Line Printer Maintenance Manual",
//   Dataproducts publication number 255182C
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

`define IGNORE_CTRL_CHARS

module LP26 (
      input  wire         clk,          // Clock
      input  wire         rst,          // Reset
      input  wire         lpINIT,       // Printer reset
      input  wire         lpSETONLN,    // Set printer online
      input  wire         lpSETOFFLN,   // Set printer offline
      input  wire [ 6:15] lpCONFIG,     // Printer serial configuration
      input  wire         lpOVFU,       // Printer should use optical VFU
      input  wire         lpRXD,        // Printer received data
      output wire         lpTXD,        // Printer transmitted data
      input  wire         lpSTROBE,     // Printer data stobe
      input  wire [ 8: 1] lpDATA,       // Printer data
      input  wire         lpDPAR,       // Printer data parity
      input  wire         lpPI,         // Printer paper instruction
      output wire         lpTOF,        // Printer is at top of form
      output wire         lpPARERR,     // Printer parity error
      output reg          lpONLINE,     // Printer is online
      output reg          lpVFURDY,     // Printer VFU is ready
      output reg          lpSIXLPI,     // Printer is in 6 LPI mode
      output wire         lpDEMAND      // Printer is ready for another character
);

   //
   // Get ASCII character definitions
   //

   `include "ascii.vh"

   //
   // Determine if the DVFU channel matches the channel command
   //  Note only the first 12 channels are valid
   //

   function [ 0:0] lpVFUMATCH;
      input [12:1] lpVFUDATA;
      input [ 8:1] lpDATA;
      reg   [ 4:1] channel;
      begin
         channel = lpDATA[4:1];
         case (channel)
            0: lpVFUMATCH = lpVFUDATA[ 1];
            1: lpVFUMATCH = lpVFUDATA[ 2];
            2: lpVFUMATCH = lpVFUDATA[ 3];
            3: lpVFUMATCH = lpVFUDATA[ 4];
            4: lpVFUMATCH = lpVFUDATA[ 5];
            5: lpVFUMATCH = lpVFUDATA[ 6];
            6: lpVFUMATCH = lpVFUDATA[ 7];
            7: lpVFUMATCH = lpVFUDATA[ 8];
            8: lpVFUMATCH = lpVFUDATA[ 9];
            9: lpVFUMATCH = lpVFUDATA[10];
           10: lpVFUMATCH = lpVFUDATA[11];
           11: lpVFUMATCH = lpVFUDATA[12];
           12: lpVFUMATCH = 0;
           13: lpVFUMATCH = 0;
           14: lpVFUMATCH = 0;
           15: lpVFUMATCH = 0;
         endcase
      end
   endfunction

   //
   // VFU Lengths
   //   Optical
   //   Digital
   //   Whatever is selected
   //

   reg        [7:0] lpDVFULEN;
   localparam [7:0] lpOVFULEN = 8'd66;
   wire       [7:0] lpVFULEN  = lpOVFU ? lpOVFULEN : lpDVFULEN;

   //
   // VFU Memory
   //  lpVFUDAT[0][n] is OVFU data.  It is read-only.
   //  lpVFUDAT[1][n] is DAVFU data.  It is read/write.
   //

   reg [12:1] lpVFUDAT[1:0][0:255];

   initial
     begin
       `include "lpdvfu.vh"
     end

   //
   // Printer handshaking
   //

   reg  lpXON;
   wire lpRXFULL;
   wire [7:0] lpRXDAT;

   //
   // Line printer parity
   //
   //  Parity is only implemented on the LP07 printer and not the LP05, LP14, or
   //  LP26.  This is obviously not implemented correctly here because it fails
   //  DSLPA Test.107
   //
   //  To test this function, execute DSLPA as follows:
   //
   //   DECSYSTEM 2020 LINE PRINTER DIAGNOSTIC [DSLPA]
   //   VERSION 0.7, SV=0.3, CPU#=4097, MCV=130, MCO=470, HO=0, KASW=003740 000000
   //   TTY SWITCH CONTROL ? - 0,S OR Y <CR> - Y
   //
   //   LH SWITCHES <# OR ?> - 0
   //   RH SWITCHES <# OR ?> - 40
   //   SWITCHES = 000000 000040
   //
   //   IS THIS AN LP05, LP14 OR LP26 LINE PRINTER ? Y OR N <CR> - N
   //
   //   IS THIS AN LP07 LINE PRINTER ? Y OR N <CR> - Y
   //
   //   DOES THIS LPT HAVE A DAVFU ? Y OR N <CR> - Y
   //
   //   TYPE ? TO GET FORMAT ON TERMINAL,
   //   TYPE # TO GET FORMAT PRINTED ON THE LPT
   //   COMMANDS: XX OR XX-YY OR A OR D
   //
   //   *107
   //   PC=  034517
   //   SWITCHES = 000000 000040
   //   ERROR IN *LP20 STATIC TESTS* - TEST.107
   //   ERROR BITS INCORRECT WHEN BAD PARITY SENT TO LPT
   //
   //   UBAS    3763100:  000000 000011  HI PIA=1, LO PIA=1
   //   UBARAM  3763000:  PAGE ADDR=60, VALID,
   //   UBARAM  3763001:  PAGE ADDR=61, VALID,
   //   LPCSRA  3775400: 004202  ONLINE, DONE, PARENB,
   //   LPCSRB  3775402: 100100  VDATA, VFUERR,
   //   LPBSAD  3775404: 000001  BUS ADDR = 000001
   //   LPBCTR  3775406: 000000  BYTE CNT = 0
   //   LPPCTR  3775410: 002777  PAGE CNT = 2777
   //   LPRAMD  3775412: 010000  RAM DATA = 10000
   //   LPCBUF  3775414: 000440  CHAR BUF = 40 COL CNT = 1
   //   LPCKSM  3775416: 020040  CKSUM = 40 PRINTER DATA = 40
   //

   assign lpPARERR = ~^{lpDPAR, lpPI, lpDATA};

   //
   // VFU Start Load and Stop Load characters
   //

   localparam [7:0] charSTART1 = 8'o154,        // 6 LPI line spacing
                    charSTART2 = 8'o155,        // 8 LPI line spacing
                    charSTART3 = 8'o156,        // Current line spacing
                    charSTOP   = 8'o157;

   //
   // Line spacing
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          lpSIXLPI <= 1;
        else
          if (lpSTROBE & lpPI & (lpDATA == charSTART1))
            lpSIXLPI <= 1;
          else if (lpSTROBE & lpPI & (lpDATA == charSTART2))
            lpSIXLPI <= 0;
     end

   //
   // Lines per page
   //

   wire [7:0] lpLPP = lpSIXLPI ? 8'd66 : 8'd88;

   //
   // Printer state
   //

   localparam [4:0] stateIDLE      =  0,        // Wait for something to do
                    statePRINT     =  1,        // Print line buffer
                    stateVFUEVEN   =  2,        // Read even byte of VFU program
                    stateVFUODD    =  3,        // Read odd  byte of VFU program
                    stateVFUCHAN   =  4,        // Count channel linefeeds
                    stateVFUVT     =  5,        // Count vertical tab linefeeds
                    stateVFUSLEW   =  6,        // Count slew linefeeds.
                    stateVFUPRINT  =  7,        // VFU print buffer
                    stateVFUMOVE   =  8,        // Send zero or more LFs
                    stateVFUOFFLN  =  9,        // Set VFU offline
                    stateVFUNOTRDY = 10,        // Set VFU not ready
                    stateVFURDY    = 11,        // Set VFU ready
                    stateWAIT      = 12,        // Wait for UART to finish
                    stateDONE      = 13,        // Done
                    stateDLY1      = 14,
                    stateDLY2      = 15,
                    stateDLY3      = 16,
                    stateDLY4      = 17,
                    stateDLY5      = 18,
                    stateDLY6      = 19;

   //
   // Printer state machine
   //

   reg [4:0] state;                             // State variable
   reg [7:0] lpCCTR;                            // Character counter
   reg [6:1] lpTEMP;                            // Temporary byte storage
   reg [7:0] lpLCTR;                            // Line counter
   reg [7:0] lpLFCNT;                           // Nuber of line feeds for vertical motion
   reg [7:0] lpCOUNT;                           // Generic counter for misc things.
   reg [7:0] lpTXDAT;                           // UART transmit data
   reg       lpTXSTB;                           // UART transmit strobe
   wire      lpTXEMPTY;                         // UART is empty.  Send next character.
   reg [7:0] lpLINBUF[0:255];                   // Line buffer
   integer   j;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             lpCCTR    <= 0;
             lpLCTR    <= 0;
             lpTEMP    <= 0;
             lpTXSTB   <= 0;
             lpTXDAT   <= 0;
             lpLFCNT   <= 0;
             lpCOUNT   <= 0;
             lpDVFULEN <= 0;
             state     <= stateIDLE;

`ifndef SYNTHESIS
             for (j = 0; j < 256; j = j + 1)
               begin
                  lpLINBUF[j] <= 0;
               end
`endif

          end
        else
          begin

             lpTXSTB <= 0;

             case (state)

               //
               // stateIDLE
               //  Wait for something to do
               //

               stateIDLE:

                 if (lpSTROBE)

                   if (lpPI)

                     //
                     // DVFU operation
                     //

                     case (lpDATA)

                       //
                       // Start VFU load operation
                       //

                       charSTART1,
                       charSTART2,
                       charSTART3:
                         begin
                            lpDVFULEN <= 0;
                            state     <= stateVFUEVEN;
                          end

                        //
                        // Make VFU not ready
                        //

                       charSTOP:
                         state <= stateVFUNOTRDY;

                       //
                       // Print the buffer, print a carriage return, do VFU
                       // motion, and then reset the buffer pointer
                       //

                       default:
                         begin
                            lpLFCNT <= 0;
                            if (`VFU_SLEW(lpDATA))
                              state <= stateVFUSLEW;
                            else if (`VFU_CHAN(lpDATA) < 12)
                              begin
                                 lpCOUNT <= 0;
                                 lpLCTR  <= (lpLCTR == lpVFULEN) ? 8'b0 : lpLCTR + 1'b1;
                                 lpLFCNT <= lpLFCNT + 1'b1;
                                 state   <= stateVFUCHAN;
                              end
                            else
                              state <= stateVFUOFFLN;
                         end

                     endcase

                   else

                     //
                     // Printer operation
                     //

                     case (lpDATA)

                       //
                       // The Null character is ignored.
                       //

                       asciiNUL:
                         state <= stateWAIT;

                       //
                       // Control characters are converted to spaces then
                       // buffered.
                       //
                       // This is tested by DSLPA TEST.135
                       //

                       asciiSOH,
                       asciiSTX,
                       asciiETX,
                       asciiEOT,
                       asciiENQ,
                       asciiACK,
                       asciiBEL,
                       asciiBS,
                       asciiSO,
                       asciiSI,
                       asciiDLE,
                       asciiDC1,
                       asciiDC2,
                       asciiDC3,
                       asciiDC4,
                       asciiNAK,
                       asciiSYN,
                       asciiETB,
                       asciiCAN,
                       asciiEM,
                       asciiSUB,
                       asciiESC,
                       asciiFS,
                       asciiGS,
                       asciiRS,
                       asciiUS,
                       asciiDEL:
`ifdef IGNORE_CTRL_CHARS
                         state <= stateWAIT;
`else
                         begin
                            lpLINBUF[lpCCTR] <= asciiSP;
                            lpCCTR <= lpCCTR + 1'b1;
                         end
`endif

                       //
                       // A carriage return prints the buffered characters,
                       // prints a carriage return, and resets the buffer
                       // pointer.
                       //
                       // An LP07 will go offline if you overprint a line 8
                       // times without paper motion.  This is tested by
                       // DSLPA TEST.115.  An LP26 will overprint 140 times
                       // before it will declare a fault.  This is not tested
                       // by the diagnostics.
                       //
                       // For now, we do not support LP07-like operation.
                       //

                       asciiCR:
                           begin
                              lpCOUNT <= 0;
                              state   <= statePRINT;
                           end

                       //
                       // A line feed prints the buffered characters, prints a
                       // line feed, advances the line counter, and resets the
                       // buffer pointer,
                       //

                       asciiLF:
                         begin
                            lpCOUNT <= 0;
                            lpLCTR  <= (lpLCTR == lpVFULEN) ? 8'b0 : lpLCTR + 1'b1;
                            state   <= statePRINT;
                         end

                       //
                       // A form feed prints the buffered characters, prints a
                       // form feed, resets the line counter which increments
                       // the page counter, and resets the buffer pointer.
                       //

                       asciiFF:
                         begin
                            lpCOUNT <= 0;
                            lpLCTR  <= 0;
                            state   <= statePRINT;
                         end

                       //
                       // A vertical tab prints the buffered characters, does
                       // the vertical tab, and resets the buffer pointer.
                       //

                       asciiVT:
                         begin
                            lpLFCNT <= 0;
                            state   <= stateVFUVT;
                         end

                       //
                       // Everything else that is printable is buffered until
                       // a carriage return is received.
                       //

                       default:
                         begin
                            lpLINBUF[lpCCTR] <= lpDATA;
                            lpCCTR <= lpCCTR + 1'b1;
                         end

                     endcase

               //
               // statePRINT
               //  Print the line buffer.
               //  Send the character in lpDATA after the line is printed.
               //

               statePRINT:
                 begin
                    if (lpTXEMPTY & lpXON)
                      if (lpCOUNT == lpCCTR)
                        begin
                           lpCCTR  <= 0;
                           lpCOUNT <= 0;
                           lpTXSTB <= 1;
                           lpTXDAT <= lpDATA;
                           state   <= stateWAIT;
                        end
                      else
                        begin
                           lpTXSTB <= 1;
                           lpTXDAT <= lpLINBUF[lpCOUNT];
                           lpCOUNT <= lpCOUNT + 1'b1;
                           state   <= stateDLY1;
                        end
                 end

               stateDLY1:
                 state <= statePRINT;

               //
               // stateVFUEVEN
               //  Read the first byte of VFU data.  Save it for later.  This
               //  'byte' has the data for channels 1 through 6.
               //
               //  The start/stop characters will have the PI bit asserted. The
               //  DAVFU data will not have the PI bit asserted.
               //
               //  Receiving s START character in this state will discard the
               //  previously sent DAVFU data and begin loading the DAVFU
               //  again.
               //
               //  Receiving a STOP character in this state is valid only if
               //  another data word was received first - check the count.
               //

               stateVFUEVEN:
                 if (lpSTROBE)
                   if ((lpPI & (lpDATA == charSTART1)) |
                       (lpPI & (lpDATA == charSTART2)) |
                       (lpPI & (lpDATA == charSTART3)))
                     begin
                        lpDVFULEN <= 0;
                        state     <= stateVFUEVEN;
                     end
                   else if (lpPI & (lpDATA == charSTOP))
                     if (lpDVFULEN == 0)
                       state <= stateVFUNOTRDY;
                     else
                       state <= stateVFURDY;
                   else
                     begin
                        lpTEMP <= lpDATA[6:1];
                        state  <= stateVFUODD;
                     end

               //
               // stateVFUODD
               //  Read the second byte of VFU data.  Form the word from the two
               //  bytes and store it in the next location of DVFU RAM.
               //
               //  The start/stop character will have the PI bit asserted.
               //  DAVFU data will not have the PI bit asserted.
               //
               //  If the VFU is overrun (more than 143 lines), the printer is
               //  taken offline and will report that the DAVFU is not ready.
               //
               //  Receiving s START character in this state will discard the
               //  previously sent DAVFU data and begin loading the DAVFU
               //  again.
               //
               //  Receiving a STOP character in this state is never valid. In
               //  this case, the printer is taken offline and the DAVFU
               //  reports that it is not ready.
               //
               //  The VFU length limit of 143 is tested by DSLPA TEST.112
               //

               stateVFUODD:
                 if (lpSTROBE)
                   if ((lpPI & (lpDATA == charSTART1)) |
                       (lpPI & (lpDATA == charSTART2)) |
                       (lpPI & (lpDATA == charSTART3)))
                     begin
                        lpDVFULEN <= 0;
                        state     <= stateVFUEVEN;
                     end
                   else if (lpPI & (lpDATA == charSTOP))
                     state <= stateVFUOFFLN;
                   else if (lpDVFULEN == 143)
                     state <= stateVFUOFFLN;
                   else
                     begin
                        lpVFUDAT[1][lpDVFULEN] <= {lpDATA[6:1], lpTEMP};
                        lpDVFULEN <= lpDVFULEN + 1'b1;
                        state <= stateVFUEVEN;
                     end

               //
               // stateVFUCHAN
               //  Count the number of linefeeds to move to the next channel
               //  marker.
               //
               //  This state doesn't actually print any linefeeds even though
               //  we update the line counter (lpLCTR).
               //
               //  We count the linefeeds and watch for overrun errors
               //  like this because the diagnostic software doesn't wait
               //  long enough to let us count the LFs as we send them.  See
               //  DSLPA TEST.114
               //

               stateVFUCHAN:
                 if (lpCOUNT == lpVFULEN)
                   state <= stateVFUOFFLN;
                 else
                   if (lpVFUMATCH(lpVFUDAT[!lpOVFU][lpLCTR], lpDATA))
                     begin
                        lpCOUNT <= 0;
                        state   <= stateVFUPRINT;
                     end
                   else
                     begin
                        lpLCTR  <= (lpLCTR == lpVFULEN) ? 8'b0 : lpLCTR + 1'b1;
                        lpLFCNT <= lpLFCNT + 1'b1;
                        lpCOUNT <= lpCOUNT + 1'b1;
                        state   <= stateDLY2;
                     end

               stateDLY2:
                 state <= stateVFUCHAN;

               //
               // stateVFUVT
               //  Handle vertical tabs.  Vertical tabs are VFU channel 2.
               //
               //  This state doesn't actually print any linefeeds.
               //
               //  We count the linefeeds and watch for overrun errors
               //  like this because the software doesn't wait long enough to
               //  let us count the LFs as we send them.  See DSLPA TEST.114
               //

               stateVFUVT:
                 if (lpCOUNT == lpVFULEN)
                   state <= stateVFUOFFLN;
                 else
                   if (lpVFUMATCH(lpVFUDAT[!lpOVFU][lpLCTR], 8'd1))
                     begin
                        lpCOUNT <= 0;
                        state   <= stateVFUPRINT;
                     end
                   else
                     begin
                        lpLCTR  <= (lpLCTR == lpVFULEN) ? 8'b0 : lpLCTR + 1'b1;
                        lpLFCNT <= lpLFCNT + 1'b1;
                        lpCOUNT <= lpCOUNT + 1'b1;
                        state   <= stateDLY3;
                     end

               stateDLY3:
                 state <= stateVFUVT;

               //
               // stateVFUSLEW
               //  We already know how many linefeeds but we still need to
               //  check for overrun errors.
               //

               stateVFUSLEW:
                 begin
                    lpLCTR  <= (lpLCTR == lpVFULEN) ? 8'b0 : lpLCTR + 1'b1;
                    lpLFCNT <= lpLFCNT + 1'b1;
                    if (lpLFCNT == `VFU_CHAN(lpDATA))
                      begin
                         lpCOUNT <= 0;
                         state   <= stateVFUPRINT;
                      end
                    else
                      state <= stateDLY4;
                 end

               stateDLY4:
                 state <= stateVFUSLEW;

               //
               // stateVFUPRINT
               //  Print the character buffer and then print a carriage
               //  return.
               //

               stateVFUPRINT:
                 if (lpTXEMPTY & lpXON)
                   if (lpCOUNT == lpCCTR)
                     begin
                        lpCCTR  <= 0;
                        lpCOUNT <= 0;
                        lpTXSTB <= 1;
                        lpTXDAT <= asciiCR;
                        state   <= stateVFUMOVE;
                     end
                   else
                     begin
                        lpTXSTB <= 1;
                        lpTXDAT <= lpLINBUF[lpCOUNT];
                        lpCOUNT <= lpCOUNT + 1'b1;
                        state   <= stateDLY5;
                     end

               stateDLY5:
                 state <= stateVFUPRINT;

               //
               // stateVFUMOVE
               //  Move the printer vertically.
               //

               stateVFUMOVE:
                 if (lpTXEMPTY & lpXON)
                   if (lpLFCNT == 0)
                     state <= stateWAIT;
                   else
                     begin
                        lpTXSTB <= 1;
                        lpTXDAT <= asciiLF;
                        lpLFCNT <= lpLFCNT - 1'b1;
                        state   <= stateDLY6;
                     end

               stateDLY6:
                 state <= stateVFUMOVE;

               //
               // stateVFUOFFLN
               //  Take the printer off-line, then make VFU not ready.
               //

               stateVFUOFFLN:
                 begin
                    lpCCTR  <= 0;
                    lpCOUNT <= 0;
                    lpLFCNT <= 0;
                    state   <= stateVFUNOTRDY;
                 end

               //
               // stateVFUNOTRDY
               //  Make DVFU not ready
               //

               stateVFUNOTRDY:
                 state <= stateWAIT;

               //
               // stateVFURDY
               //

               stateVFURDY:
                 begin
                    lpLCTR    <= 0;
                    lpDVFULEN <= lpDVFULEN - 1'b1;
                    state     <= stateWAIT;
                 end

               //
               //  Wait for UART to finish
               //

               stateWAIT:
                 if (lpTXEMPTY)
                   state <= stateDONE;

               //
               // stateDONE
               //  Get ready for next character
               //

               stateDONE:
                 state <= stateIDLE;

             endcase

          end
     end

   //
   // VFU ready
   //
   // VFU is always ready when using an OVFU
   //
   // Trace
   //  M8587/LPD6/E11
   //  M8587/LPD6/E50
   //  M8587/LPD6/E66
   //  M8587/LPD6/E74
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          lpVFURDY <= 0;
        else
          if (lpOVFU)
            lpVFURDY <= 1;
          else
            if (state == stateVFUNOTRDY)
              lpVFURDY <= 0;
            else if (state == stateVFURDY)
              lpVFURDY <= 1;
     end

   //
   // lpONLINE
   //   Printer on-line
   //
   //   The printer is taken off line when:
   //   1.  Console takes it off line, or
   //   2.  Certain DAVFU faults, or
   //   3.  Too many overprints (CRs without LF)
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          lpONLINE <= 0;
        else
          if (lpSETOFFLN | (state == stateVFUOFFLN))
            lpONLINE <= 0;
          else if (lpSETONLN)
            lpONLINE <= 1;
     end

   //
   // Software handshaking to printer
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          lpXON <= 1;
        else
          if (lpINIT)
            lpXON <= 1;
          else
            if (lpRXFULL)
              if (lpRXDAT == asciiXON)
                lpXON <= 1;
              else if (lpRXDAT == asciiXOFF)
                lpXON <= 0;
     end

   //
   // lpDEMAND
   //  Ready to receive next character.
   //

   assign lpDEMAND = ((!lpSTROBE & (state == stateIDLE   )) |
                      (!lpSTROBE & (state == stateVFUEVEN)) |
                      (!lpSTROBE & (state == stateVFUODD )));

   //
   // lpTOF
   //  Printer is at top-of-form
   //

   wire lpLINE0 = (lpLCTR == 0);

   reg lastLINE0;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          lastLINE0 <= 0;
        else
          lastLINE0 <= lpLINE0;
     end

   assign lpTOF = lpLINE0 & !lastLINE0;

   //
   // UART Baud Rate Generator
   //

   wire clken;

   UART_BRG ttyBRG (
      .clk     (clk),
      .rst     (rst),
      .speed   (lpCONFIG[6:10]),
      .clken   (clken)
   );

   //
   // UART Transmitter
   //  Data is adjusted to 7 bits before transmitting.
   //

   UART_TX TX (
       .clk    (clk),
       .rst    (rst),
       .clr    (1'b0),
       .clken  (clken),
       .length (lpCONFIG[11:12]),
       .parity (lpCONFIG[13:14]),
       .stop   (lpCONFIG[15]),
       .load   (lpTXSTB),
       .data   ({1'b0, lpTXDAT[6:0]}),
       .empty  (lpTXEMPTY),
       .intr   (),
       .txd    (lpTXD)
   );

   //
   // UART receiver
   //  The receiver is used for XON/XOFF handshaking

   UART_RX RX (
       .clk    (clk),
       .rst    (rst),
       .clr    (1'b0),
       .clken  (clken),
       .length (lpCONFIG[11:12]),
       .parity (lpCONFIG[13:14]),
       .stop   (lpCONFIG[15]),
       .rxd    (lpRXD),
       .rfull  (1'b0),
       .full   (),
       .intr   (lpRXFULL),
       .data   (lpRXDAT),
       .pare   (),
       .frme   (),
       .ovre   ()
   );

endmodule
