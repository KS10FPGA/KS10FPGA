////////////////////////////////////////////////////////////////////   
//   
// KS-10 Processor
//   
// Brief
//   KS-10 Memory Interface
//   
// Details
//   This module is simply a wrapper for the external memory.
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
//
//          EH  : Error Hold          - Always read as 0.  Writes
//                                      ignored.
//          UE  : Uncorrectable Error - Always read as 0.  Writes
//                                      ignored.
//          RE  : Refresh Error       - Always read as 0.  Writes
//                                      ignored.
//          PE  : Parity Error        - Read/Writes PE bit.
//          EE  : ECC Enable          - Reads back inverse value set
//                                      by write to bit ED bit.
//                                      Writes ignored. See ED bit
//                                      below.
//          PF  : Power Failure       - Initialized to 1 at power-up,
//                                      Writing zero clears PF.
//          ED  : ECC Disable         - Always read as 0.
//                                      Writing zero sets EE bit,
//                                      Writing one clears EE bit.
//          FCB : Force Check Bits    - Always read as 0.  Writes
//                                      ignored.
//          ERA : Error Read Address  - Always read as 0.  Writes
//                                      ignored.
// File
//   mem.v
//   
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//   
////////////////////////////////////////////////////////////////////   
//   
// Copyright (C) 2012-2013 Rob Doyle
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

`default_nettype none
`include "../ks10.vh"

module MEM(clk, rst, clken,
           busREQI, busACKO, busADDRI, busDATAI, busDATAO,
           ssramCLK, ssramCLKEN_N, ssramADV, ssramBWA_N, ssramBWB_N,
	   ssramBWC_N, ssramBWD_N, ssramOE_N, ssramWE_N, ssramCE,
	   ssramADDR, ssramDATA);

   input         clk;           // Clock
   input         rst;           // Reset
   input         clken;         // Clock enable
   input         busREQI;       // Memory Request In
   output        busACKO;       // Memory Acknowledge Out
   input  [0:35] busADDRI;      // Address Address In
   input  [0:35] busDATAI;      // Data in
   output [0:35] busDATAO;      // Data out
   output        ssramCLK;      // SSRAM Clock
   output        ssramCLKEN_N;  // SSRAM CLKEN#
   output        ssramADV;      // SSRAM Advance (burst)
   output        ssramBWA_N;    // SSRAM BWA#
   output        ssramBWB_N;    // SSRAM BWB#
   output        ssramBWC_N;    // SSRAM BWC#
   output        ssramBWD_N;    // SSRAM BWD#
   output        ssramOE_N;     // SSRAM OE#
   output        ssramWE_N;     // SSRAM WE#
   output        ssramCE;       // SSRAM CE
   output [0:22] ssramADDR;     // SSRAM Address Bus
   inout  [0:35] ssramDATA;     // SSRAM Data Bus
   
   //
   // The Memory Conroller is Device 0
   //

   localparam [0:3] memDEV = `ctlNUM0;
   
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

   wire         busREAD   = busADDRI[ 3];
   wire         busWRTEST = busADDRI[ 4];
   wire         busWRITE  = busADDRI[ 5];
   wire         busIO     = busADDRI[10];
   wire [ 0: 3] busDEV    = busADDRI[14:17];
   wire [16:35] busADDR   = busADDRI[18:35];

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
             if (busIO & busWRITE  & (busDEV == memDEV) & (busADDR == addrMSR))
               begin
                  statPE <=  busDATAI[ 3];
                  statPF <=  busDATAI[12] & statPF;
                  statEE <= ~busDATAI[35];
`ifndef SYNTHESIS
                  $display("Memory Status Register Written.\n");
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
   // FIXME
   //  Only 32K of memory is implemented.
   //
 
   reg busACKO;
   reg [0:35] busDATAO;
   
   always @(busIO or busDEV or busADDR or busREAD or busWRITE or busWRTEST or ssramDATA or statREG)
     begin

        //
        // Memory Status Register
        //
        
        if (busIO & busREAD & (busDEV == memDEV) & (busADDR == addrMSR))
          begin
             busACKO  <= 1'b1;
             busDATAO <= statREG;
`ifndef SYNTHESIS
             $display("Memory Status Register Read.\n");
`endif
          end

        //
        // Memory
        //
        
        else if ((~busIO & busREAD & (busADDR < 32768)) |
                 (~busIO & busWRITE                   ) | 
                 (~busIO & busWRTEST                  ))
          begin
             busACKO  <= 1'b1;
             busDATAO <= ssramDATA;
          end

        //
        // Everything else.
        //
        
        else
          begin
             busACKO  <= 1'b0;
             busDATAO <= ssramDATA;
          end
     end

   //
   // SSRAM Interface
   //

   assign ssramCLKEN_N = 0;
   assign ssramADV     = 0;
   assign ssramBWA_N   = 0;
   assign ssramBWB_N   = 0;
   assign ssramBWC_N   = 0;
   assign ssramBWD_N   = 0;
   assign ssramOE_N    = 0;
   assign ssramWE_N    = ~(busWRITE & ~busIO);
   assign ssramCE      = 1;
   assign ssramADDR    = {3'b0, busADDR[16:35]};
   assign ssramDATA    = (~ssramWE_N) ? busDATAI : 36'bz;

   //
   // Funky clock forwarding for clock output
   // Spartan6 will give errors if you try to drive a clock output.
   //

   ODDR2 #(
       .DDR_ALIGNMENT("NONE"),  // Sets output alignment to "NONE", "C0" or "C1"
       .INIT(1'b0),             // Sets initial state of the Q output to 1'b0 or 1'b1
       .SRTYPE("SYNC")          // Specifies "SYNC" or "ASYNC"   set/reset
   )
   ODDR2_inst (
       .Q(ssramCLK),   		// 1-bit DDR output data
       .C0(clk), 		// 1-bit clock input
       .C1(~clk), 		// 1-bit clock input
       .CE(1'b1), 		// 1-bit clock enable input
       .D0(1'b1), 		// 1-bit data input (associated with C0)
       .D1(1'b0), 		// 1-bit data input (associated with C1)
       .R(1'b0),   		// 1-bit reset input
       .S(1'b0)    		// 1-bit set input
   );

   
endmodule
