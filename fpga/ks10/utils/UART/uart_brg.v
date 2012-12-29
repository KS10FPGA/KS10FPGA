////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// brief
//      DZ11 UART Baud Rate Generator
//
// details
//
// todo
//
// file
//      uart_brg.v
//
// author
//      Rob Doyle - doyle (at) cox (dot) net
//
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

`default_nettype none
`include "uart_brg.vh"
`include "../../../ks10.vh"  
  
module UART_BRG(clk, rst, brgSEL, brgCLKEN);

   parameter clkfrq = `CLKFRQ;  // 50 MHz
   parameter clkdiv = `CLKDIV;  // 16x Clock
   
   input       clk;             // Clock
   input       rst;             // Reset
   input [0:2] brgSEL;          // Speed Select
   output      brgCLKEN;        // BRG Clock Enable

   //
   // Programmable Clock Divider.
   //
   // Details
   //  This process generates a clkBR signal that is suitable for
   //  use as a 16x Baud Rate clock.   Both UART Transmitters and
   //  UART Receivers require this 16x clock.
   //

   reg brgCLKEN;
   reg [0:31] count;
   always @(posedge clk)
     begin
        if (rst)
          begin
             brgCLKEN <= 0;
             count    <= 0;
          end
        else if (count == 0)
          begin
             case (brgSEL)
               `BR1200   : count <= clkfrq/clkdiv/1200;         //   1,200 (-0.016%
               `BR2400   : count <= clkfrq/clkdiv/2400;         //   2,400 (-0.032%)
               `BR4800   : count <= clkfrq/clkdiv/4800;         //   4,800 (-0.032%)
               `BR9600   : count <= clkfrq/clkdiv/9600;         //   9,600 (+0.16%)
               `BR19200  : count <= clkfrq/clkdiv/19200;        //  19,200 (+0.16%)
               `BR38400  : count <= clkfrq/clkdiv/38400;        //  38,400 (+0.16%)
               `BR57600  : count <= clkfrq/clkdiv/57600;        //  57,600 (+0.94%)
               `BR115200 : count <= clkfrq/clkdiv/115200;       // 115,200 (+1.35%)
              endcase
             brgCLKEN <= 1;
          end
        else
          begin
             count    <= count - 1'b1;
             brgCLKEN <= 0;
          end
     end

endmodule
