////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      KS-10 Memory Interface
//!
//! \details
//!      This module is simply a wrapper for the external memory.
//!
//!      Memory Status Register Write (IO addresses o100000)
//!
//!              0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17
//!             +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!       (LH)  |EH|UE|RE|PE|                       |PF|              |
//!             +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!   
//!             18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
//!             +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!       (RH)  |                             |       FCB          |ED|
//!             +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!   
//!      Memory Status Register Read (IO addresses o100000)
//!   
//!              0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17
//!             +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!       (LH)  |EH|UE|RE|PE|EE|         ECP        |PF| 0|   ERA     |
//!             +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!   
//!              18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
//!             +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!       (RH)  |                     ERA                             |
//!             +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!
//!   
//!             EH  : Error Hold          - Always read as 0.  Writes
//!                                         ignored.
//!             UE  : Uncorrectable Error - Always read as 0.  Writes
//!                                         ignored.
//!             RE  : Refresh Error       - Always read as 0.  Writes
//!                                         ignored.
//!             PE  : Parity Error        - Read/Writes PE bit.
//!             EE  : ECC Enable          - Reads back inverse value set
//!                                         by write to bit ED bit.
//!                                         Writes ignored. See ED bit
//!                                         below.
//!             PF  : Power Failure       - Initialized to 1 at power-up,
//!                                         Writing zero clears PF.
//!             ED  : ECC Disable         - Always read as 0.
//!                                         Writing zero sets EE bit,
//!                                         Writing one clears EE bit.
//!             FCB : Force Check Bits    - Always read as 0.  Writes
//!                                         ignored.
//!             ERA : Error Read Address  - Always read as 0.  Writes
//!                                         ignored.
//! \todo
//!
//! \file
//!      mem.v
//!
//! \author
//!      Rob Doyle - doyle (at) cox (dot) net
//!
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
//
// Comments are formatted for doxygen
//

module MEM(clk, rst, clken,
           busREQI, busACKO, busADDRI, busDATAI, busDATAO,
           ssramCLK, ssramADDR, ssramDATA, ssramADV, ssramWR);

   input         clk;           // Clock
   input         rst;           // Reset
   input         clken;         // Clock enable
   input         busREQI;       // Memory Request In
   output        busACKO;       // Memory Acknowledge Out
   input  [0:35] busADDRI;      // Address Address In
   input  [0:35] busDATAI;      // Data in
   output [0:35] busDATAO;      // Data out
   output        ssramCLK;      // SSRAM Clock
   output [0:22] ssramADDR;     // SSRAM Address Bus
   inout  [0:35] ssramDATA;     // SSRAM Data Bus
   output        ssramADV;      // SSRAM Advance (burst)
   output        ssramWR;       // SSRAM Write
   
   //
   // Memory Status is Device 0
   //

   wire [ 0: 3] ubaDEV   = 4'b0000;
 
   //
   // Memory flags
   //
   // Details:
   //  busADDRI[ 0:13] is flags
   //  busADDRI[14:35] is address
   //

   wire         busREAD  = busADDRI[ 3];
   wire         busWRITE = busADDRI[ 5];
   wire         busIO    = busADDRI[10];
   wire [ 0: 3] busDEV   = busADDRI[14:17];
   wire [16:35] busADDR  = busADDRI[16:35];

   //
   // Memory Status Register (IO Address 100000)
   //
   // Details
   //  Only the PE, EE, and PF change... and they are not really
   //  implemented.
   //
   // FIXME:
   //  SIMH igores writes to this register and reads zeros
   //  always
   //
   
   reg statPE;          // Parity Error
   reg statEE;          // ECC Enabled
   reg statPF;          // Power Failure
   
   always @(negedge clk or posedge rst)
     begin
        if (rst)
          begin
             statPE <= 1'b0;
             statEE <= 1'b1;
             statPF <= 1'b1;
          end
        else if (clken)
          begin
             if (busIO & busWRITE  & (busDEV[0:3] == ubaDEV) & (busADDR == 18'o100000))
               begin
                  statPE <=  busDATAI[ 3];
                  statPF <=  busDATAI[12] & statPF;
                  statEE <= ~busDATAI[35];
               end
          end
     end

   wire [0:35] statREG = {3'b0, statPE, statEE, 7'b0, statPF, 23'b0};
   
   //
   // Bus Multiplexer
   //
   // Details
   //  This selects between SSRAM and the Memory Status Register.
   //
   // FIXME
   //  Only 32K of memory is implemented.
   //
 
   reg busACKO;
   reg [0:35] busDATAO;
   
   always @(busIO or busADDR or busREAD or busWRITE or ssramDATA or statREG)
     begin
        if (busIO & (busADDR == 18'o100000))
          begin
             busACKO  <= 1'b1;
             busDATAO <= statREG;
// synthesis translate_off
             if (busREAD)
               $display("Memory Status Register Read.\n");
             else if (busWRITE)
               $display("Memory Status Register Written.\n");
// synthesis translate_on
          end
        else if (~busIO & (busADDR < 32768))
          begin
             busACKO  <= 1'b1;
             busDATAO <= ssramDATA;
          end
        else
          begin
             busACKO  <= 1'b0;
             busDATAO <= ssramDATA;
          end
     end

   //
   // SSRAM Interface
   //
   // FIXME:
   //  This is not setup for SSRAM.
   //

   assign ssramCLK  = clk;
   assign ssramADV  = 1'b0;
   assign ssramWR   = busWRITE & ~busIO;
   assign ssramADDR = {3'b0, busADDR[16:35]};
   assign ssramDATA = (ssramWR) ? busDATAI : 36'bz;

endmodule
