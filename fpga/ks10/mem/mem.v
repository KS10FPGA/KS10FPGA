////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KS-10 Memory Interface
//
// Details
//   This module is interface between the KS10 backplane bus and the SSRAM.
//
//   Memory Status Register Write (IO addresses o100000)
//
//           0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17
//          +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//    (LH)  |EH|UE|RE|PE|                       |PF|              |
//          +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//
//          18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
//          +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//    (RH)  |                             |       FCB          |ED|
//          +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//
//   Memory Status Register Read (IO addresses o100000)
//
//           0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17
//          +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//    (LH)  |EH|UE|RE|PE|EE|         ECP        |PF| 0|   ERA     |
//          +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//
//           18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
//          +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//    (RH)  |                     ERA                             |
//          +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//
//   EH  : Error Hold          - Always read as 0.  Writes ignored.
//   UE  : Uncorrectable Error - Always read as 0.  Writes ignored.
//   RE  : Refresh Error       - Always read as 0.  Writes ignored.
//   PE  : Parity Error        - Read/Writes PE bit.
//   EE  : ECC Enable          - Reads back inverse value set by write to the
//                               ED bit.  Writes ignored. See ED bit below.
//   PF  : Power Failure       - Initialized to 1 at power-up.  Cleared by
//                               writing 0.
//   ED  : ECC Disable         - Always read as 0.  Writing zero sets EE bit,
//                               Writing one clears EE bit.
//   FCB : Force Check Bits    - Always read as 0.  Writes ignored.
//   ERA : Error Read Address  - Always read as 0.  Writes ignored.
//
// File
//   mem.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2014 Rob Doyle
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
`include "../uba/uba.vh"
`include "../cpu/bus.vh"
`include "../ks10.vh"

module MEM(rst, clkT, clkR, clkPHS, 
           busREQI, busACKO, busADDRI, busDATAI, busDATAO,
           ssramCLK, ssramCLKEN_N, ssramADV, ssramBW_N, ssramOE_N, ssramWE_N,
           ssramCE, ssramADDR, ssramDATA);

   input         rst;           // Reset
   input         clkT;          // Clock T
   input         clkR;          // Clock R
   input  [1: 4] clkPHS;        // Clock Phase
   input         busREQI;       // Memory Request In
   output        busACKO;       // Memory Acknowledge Out
   input  [0:35] busADDRI;      // Address Address In
   input  [0:35] busDATAI;      // Data in
   output [0:35] busDATAO;      // Data out
   input         ssramCLK;      // SSRAM Clock
   output        ssramCLKEN_N;  // SSRAM CLKEN#
   output        ssramADV;      // SSRAM Advance (burst)
   output [1: 4] ssramBW_N;     // SSRAM BW#
   output        ssramOE_N;     // SSRAM OE#
   output        ssramWE_N;     // SSRAM WE#
   output        ssramCE;       // SSRAM CE
   output [0:22] ssramADDR;     // SSRAM Address Bus
   inout  [0:35] ssramDATA;     // SSRAM Data Bus

   //
   // The Memory Conroller is Device 0
   //

   localparam [ 0: 3] memDEV  = `devUBA0;

   //
   // Memory Status Register IO Address
   //

   localparam [18:35] addrMSR = 18'o100000;

   //
   // Memory flags
   //
   // Details:
   //  busADDRI[ 0:13] is flags
   //  busADDRI[14:35] is address
   //

   wire         busREAD    = `busREAD(busADDRI);
   wire         busWRTEST  = `busWRTEST(busADDRI);
   wire         busWRITE   = `busWRITE(busADDRI);
   wire         busPHYS    = `busPHYS(busADDRI);
   wire         busIO      = `busIO(busADDRI);
   wire [ 0: 3] busDEV     = `busDEV(busADDRI);
   wire [18:35] busIOADDR  = `busIOADDR(busADDRI);
   wire [16:35] busMEMADDR = `busMEMADDR(busADDRI);
   wire         busACREF   = `busACREF(busADDRI);

   //
   // Memory Status Register (IO Address 100000)
   //
   // Details
   //  Only the PE, EE, and PF change... and they are not really implemented.
   //

   reg statPE;          // Parity Error
   reg statEE;          // ECC Enabled
   reg statPF;          // Power Failure

   always @(posedge clkR or posedge rst)
     begin
        if (rst)
          begin
             statPE <= 1'b0;
             statEE <= 1'b1;
             statPF <= 1'b1;
          end
        else
          begin
             if (busWRITE & busIO & busPHYS & (busDEV == memDEV) & (busIOADDR == addrMSR))
               begin
                  statPE <=  busDATAI[ 3];
                  statPF <=  busDATAI[12] & statPF;
                  statEE <= !busDATAI[35];
`ifndef SYNTHESIS
                  $display("[%11.3f] MEM: Memory Status Register Written", $time/1.0e3);
`endif
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

   reg busACKO;
   reg [0:35] busDATAO;

   always @*
     begin

        //
        // Default
        //

        busACKO  <= 0;
        busDATAO <= 36'bx;

        //
        // Memory Status Register
        //

        if (busREAD & busIO & busPHYS & (busDEV == memDEV) & (busIOADDR == addrMSR))
          begin
             busACKO  <= 1;
             busDATAO <= statREG;
`ifndef SYNTHESIS
             $display("[%11.3f] MEM: Memory Status Register Read", $time/1.0e3);
`endif
          end

        //
        // Memory
        //

        if ((!busIO & busREAD) | (!busIO & busWRITE) | (!busIO & busWRTEST))
          begin
             busACKO  <= 1;
             busDATAO <= ssramDATA;
          end

     end

   //
   // Create the write signal.  Don't write to memory when writing to IO or the
   // ACs.
   //

   wire memWrite = busWRITE & !busIO & !busACREF;

   assign ssramCLKEN_N = 0;
   assign ssramADV     = 0;
   assign ssramBW_N    = 0;
   assign ssramOE_N    = !(busREAD  & !busIO & clkPHS[4]);
   assign ssramWE_N    = !(memWrite & clkPHS[2]);
   assign ssramCE      = 1;
   assign ssramADDR    = {3'b0, busMEMADDR};
   assign ssramDATA    = (memWrite  & clkPHS[4]) ? busDATAI : 36'bz;

endmodule
