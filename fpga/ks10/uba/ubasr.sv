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
//      PWR : Power Fail          - As reported by IO devices. Writes are ignored.
//      DXF : Diable Transfer     - Read/Write. Does nothing.
//      INI : Initialize          - Read/Write. Writing 1 resets all IO
//                                  Bridge Devices. The bit is cleared after
//                                  one microsecond so it is probably always
//                                  read back as zero.
//      PIH : Hi level PIA        - Read/Write. Hi level interrupt priority
//      PIL : Lo level PIA        - Read/Write. Lo level interrupt priority
//
// File
//   ubasr.sv
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
      input  wire          clk,                 // Clock
      input  wire          rst,                 // Reset
      input  wire  [ 0:35] busDATAI,            // Backplane Bus Data In
      input  wire          devACLO[1:5],        // Power fail indication from device
      input  wire  [ 7: 4] devINTR[1:5],        // Interrupt request
      input  wire          statWRITE,           // Write to status register
      input  wire          setNXD,              // Set NXD bit
      input  wire          setTMO,              // Set TMO bit
      output logic [ 0:35] regUBASR             // Status Register
   );

   //
   // High and Low Interrupt Request
   //

   wire statINTHI = (devINTR[1][7] | devINTR[2][7] | devINTR[3][7] | devINTR[4][7] | devINTR[5][7] |
                     devINTR[1][6] | devINTR[2][6] | devINTR[3][6] | devINTR[4][6] | devINTR[5][6]);

   wire statINTLO = (devINTR[1][5] | devINTR[2][5] | devINTR[3][5] | devINTR[4][5] | devINTR[5][5] |
                     devINTR[1][4] | devINTR[2][4] | devINTR[3][4] | devINTR[4][4] | devINTR[5][4]);

   //
   // UBA Adapter Timeout - UBASR[TMO]
   //

   logic statTMO;

   always_ff @(posedge clk)
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

   logic statNXD;

   always_ff @(posedge clk)
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

   logic statDXF;

   always_ff @(posedge clk)
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
   //  This is a 1 uS one-shot on the KS10 - which is not necessary here.
   //

   logic statINI;

   always_ff @(posedge clk)
     begin
        if (rst)
          statINI <= 0;
        else
          statINI <= statWRITE & `statINI(busDATAI);
     end

   //
   // UBA High Priority Interrupt Assignment - UBASR[PIH]
   //

   logic [0:2] statPIH;

   always_ff @(posedge clk)
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

   logic [0:2] statPIL;

   always_ff @(posedge clk)
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

   wire statPWR = devACLO[1] | devACLO[2] | devACLO[3] | devACLO[4] | devACLO[5];

   assign regUBASR = {18'b0, statTMO, 2'b0, statNXD, 2'b0, statINTHI,
                      statINTLO, statPWR, 1'b0, statDXF, statINI, statPIH,
                      statPIL};

endmodule
