////////////////////////////////////////////////////////////////////
//
// KS10 Processor
//
// Brief
//   Xilinx Clock Forwarding
//
// Details
//   Xilinx calls this 'clock forwarding'.  The synthesis tools will
//   give errors/warning if you attempt to drive a clock output
//   off-chip without this.
//
// File
//   clkfwd.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2016 Rob Doyle
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

`default_nettype none
`timescale 1ns/1ps

`ifdef XILINX

module CLKFWD (
      output wire O,    // Out
      input  wire I     // In
   );

   ODDR2 #(
       .DDR_ALIGNMENT      ("NONE"),    // Sets output alignment
       .INIT               (1'b0),      // Initial state of the Q output
       .SRTYPE             ("SYNC")     // Reset type: "SYNC" or "ASYNC"
   )
   DDR (
       .Q                  (O),         // 1-bit DDR output data
       .C0                 (I),         // 1-bit clock input
       .C1                 (!I),        // 1-bit clock input
       .CE                 (1'b1),      // 1-bit clock enable input
       .D0                 (1'b1),      // 1-bit data input (associated with C0)
       .D1                 (1'b0),      // 1-bit data input (associated with C1)
       .R                  (1'b0),      // 1-bit reset input
       .S                  (1'b0)       // 1-bit set input
   );

endmodule

`endif
