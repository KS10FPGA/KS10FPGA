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
//      TMO : Non-existent Memory - Set by TMO. Cleared by writing a 1.
//      BMD : Bad Memory Data     - Always read as 0. Writes are ignored.
//      BPE : Bus Parity Error    - Always read as 0. Writes are ignored.
//      NXD : Non-existant Device - Set by NXD. Cleared by writing a 1.
//      HI  : Hi level intr pend  - IRQ on BR7 or BR6. Writes are ignored.
//      LO  : Lo level intr pend  - IRQ on BR5 or BR4. Writes are ignored.
//      PWR : Power Fail          - Always read as 0. Writes are ignored.
//      DXF : Diable Transfer     - Read/Write. Does nothing.
//      INI : Initialize          - Read/Write. Writing 1 resets all IO
//                                  Bridge Devices. The bit is cleared after
//                                  one microsecond so it is probably always
//                                  read back as zero.
//      PIH : Hi level PIA        - Read/Write. Hi level interrupt priority
//      PIL : Lo level PIA        - Read/Write. Lo level interrupt priority
//
// File
//   ubasr.v
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

`include "ubasr.vh"
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
   // UBA Adapter Timeout - UBASR[TMO]
   //

   reg statTMO;

   always @(posedge clk)
     begin
        if (rst)
          statTMO <= 0;
        else if (statWRITE & `statINI(busDATAI))
          statTMO <= 0;
        else if (statWRITE)
          statTMO <= statTMO & !`statTMO(busDATAI);
        else if (setTMO | setNXD)
          statTMO <= 1;
     end

   //
   // UBA Non Existent Device - UBASR[NXD]
   //

   reg statNXD;

   always @(posedge clk)
     begin
        if (rst)
          statNXD <= 0;
        else if (statWRITE & `statINI(busDATAI))
          statNXD <= 0;
        else if (statWRITE)
          statNXD <= statNXD & !`statNXD(busDATAI);
        else if (setNXD)
          statNXD <= 1;
     end

   //
   // UBA Disable Transfer - UBASR[DXF]
   //

   reg statDXF;

   always @(posedge clk)
     begin
        if (rst)
          statDXF <= 0;
        else if (statWRITE & `statINI(busDATAI))
          statDXF <= 0;
        else if (statWRITE)
          statDXF <= `statDXF(busDATAI);
     end

   //
   // UBA Initialize - UBASR[INI]
   //
   //  This is a 1 uS one-shot
   //

   reg [0:4] counter;
   localparam [0:4] timeout = 0.000001 * `CLKFRQ;

   always @(posedge clk)
     begin
        if (rst)
          counter <= 0;
        else if (statWRITE & `statINI(busDATAI))
          counter <= timeout;
        else if (counter != 0)
          counter <= counter - 1'b1;
     end

   wire statINI = (counter != 0);

   //
   // UBA High Priority Interrupt Assignment - UBASR[PIH]
   //

   reg [0:2] statPIH;

   always @(posedge clk)
     begin
        if (rst)
          statPIH <= 0;
        else if (statWRITE & `statINI(busDATAI))
          statPIH <= 0;
        else if (statWRITE)
          statPIH <= `statPIH(busDATAI);
     end

   //
   // UBA Low Priority Interrupt Assignment - UBASR[PIL]
   //

   reg [0:2] statPIL;

   always @(posedge clk)
     begin
        if (rst)
          statPIL <= 0;
        else if (statWRITE & `statINI(busDATAI))
          statPIL <= 0;
        else if (statWRITE)
          statPIL <= `statPIL(busDATAI);
     end

   //
   // Build Status Register
   //

   assign regUBASR = {18'b0, statTMO, 2'b0, statNXD, 2'b0, statINTHI,
                      statINTLO, 2'b0, statDXF, statINI, statPIH, statPIL};

endmodule
