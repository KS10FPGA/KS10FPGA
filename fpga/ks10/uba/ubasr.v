////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   UBA Status Register (UBASR)
//
// Details
//   This module implements the IO Bridge Status Register (UBASR).
//
//   The IO Bridge Status Register is defined as follows:
//
//     0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17
//   +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
//   |                                                                       |
//   +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
//
//    18  19  20  21  22  23  24 25 26 27 28 29 30 31 32 33 34 35
//   +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
//   |TMO|BMD|BPE|NXD|   |   |HI |LO |PWR|   |DXF|INI|    PIH    |    PIL    |
//   +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
//
//   Register Definitions
//
//      TMO : Non-existent Memory - Set by TMO.  Cleared by writing a 1.
//      BMD : Bad Memory Data     - Always read as 0.  Writes are ignored.
//      BPE : Bus Parity Error    - Always read as 0.  Writes are ignored.
//      NXD : Non-existant Device - Set by NXD.  Cleared by writing a 1.
//      HI  : Hi level intr pend  - IRQ on BR7 or BR6.  Writes are ignored.
//      LO  : Lo level intr pend  - IRQ on BR5 or BR4.  Writes are ignored.
//      PWR : Power Fail          - Always read as 0.  Writes are ignored.
//      DXF : Diable Transfer     - Read/Write.  Does nothing.
//      INI : Initialize          - Read/Write.  Writing 1 resets all IO
//                                  Bridge Devices.  The bit is cleared after
//                                  one microsecond so it is probably always
//                                  read back as zero.
//      PIH : Hi level PIA        - Read/Write.   Hi level interrupt priority
//      PIL : Lo level PIA        - Read/Write.   Lo level interrupt priority
//
// File
//   ubasr.v
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

`include "ubasr.vh"
`include "../ks10.vh"
`include "../cpu/bus.vh"

module UBASR (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire [ 0:35] busDATAI,             // Backplane Bus Data In
      input  wire         statWRITE,            // Write to status register
      input  wire         statINTHI,            // Interrupt status low
      input  wire         statINTLO,            // Interrupt status high
      input  wire         setNXD,               // Set NXD bit
      input  wire         setTMO,               // Set TMO bit
      output wire [ 0:35] regUBASR              // Status Register
   );

   //
   // Control/Status Register
   //

   reg       statTMO;
   reg       statNXD;
   reg       statDXF;
   reg [0:2] statPIH;
   reg [0:2] statPIL;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             statTMO <= 0;
             statNXD <= 0;
             statDXF <= 0;
             statPIH <= 0;
             statPIL <= 0;
          end
        else
          begin
             if (statWRITE)
               begin
                  if (`statINI(busDATAI))
                    begin
                       statTMO <= 0;
                       statNXD <= 0;
                       statDXF <= 0;
                       statPIH <= 0;
                       statPIL <= 0;
                    end
                  else
                    begin
                       statTMO <= statTMO & !`statTMO(busDATAI);
                       statNXD <= statNXD & !`statNXD(busDATAI);
                       statDXF <= `statDXF(busDATAI);
                       statPIH <= `statPIH(busDATAI);
                       statPIL <= `statPIL(busDATAI);
                    end
               end
             else
               begin
                  if (setTMO | setNXD)
                    statTMO <= 1;
                  if (setNXD)
                    statNXD <= 1;
               end
          end
     end

   //
   // UBASR[INI] Initialization Timer
   //  This is a 1 uS one-shot
   //

   reg [0:4] rstCount;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rstCount <= 0;
        else if (statWRITE & `statINI(busDATAI))
          rstCount <=  1 * `CLKFRQ / 1000000;
        else if (rstCount != 0)
          rstCount <= rstCount - 1'b1;
     end

   wire statINI = (rstCount != 0);

   //
   // Build Status Register
   //

   assign  regUBASR = {18'b0, statTMO, 2'b0, statNXD, 2'b0, statINTHI,
                       statINTLO, 2'b0, statDXF, statINI, statPIH, statPIL};

endmodule
