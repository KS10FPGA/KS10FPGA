////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      Timer
//!
//! \details
//!      The original KS10 interval timer was 12 bits and operated
//!      with a 4.096 MHz clock.  The 12-bit timer generates an
//!      interrupt exactly every one millisecond.  
//!
//!      This did not work well in practice.  The RDTIME instruction
//!      needs to convert timer output to time in 10 us increment
//!      which would require a division by 40.96.  Therefore the
//!      timer frequency was changed to 4.100 MHz and the microcode
//!      does a division by 41 to support the RDTIME instruction.
//!
//!      You can find the details of KS10 timer design (and it's
//!      problems) in a DEC memo authored by Dan Murphy entitled
//!      "Clocks for Dolphin" on bitsavers.org
//!
//!      The KS10 would benefit from two timers, one clocked every
//!      10 microseconds and another clocked every 1 ms, supported by
//!      updated microcode.
//!
//! \todo
//!
//! \file
//!      timer.v
//!
//! \author
//!      Rob Doyle - doyle (at) cox (dot) net
//!
////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2009, 2012 Rob Doyle
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

`include "useq/crom.vh"

module TIMER(clk, rst, clken, crom, timerEN, timerINTR, timerCOUNT);

   parameter cromWidth = `CROM_WIDTH;

   input                  clk;          // Clock
   input                  rst;          // Reset
   input                  clken;        // Clock Enable
   input  [0:cromWidth-1] crom;         // Control ROM Data
   input                  timerEN;      // Timer Enable
   output reg             timerINTR;    // Timer Interrupt
   output reg [24:35]     timerCOUNT;   // Timer output

   //
   // CLKGEN
   // The Timer requires a 4.1 MHz clock.  Instead of an oscillator
   // we will employ a PLL.
   //  DPMC/E198
   //

   wire timerclk;

   CLKGEN uCLKGEN(.clk(clk),
                  .rst(rst),
                  .timerCLK(timerCLK));

   //
   // Timer
   //  DPMC/E180
   //  DPMC/E189
   //  DPMC/E181
   //
   // Note:
   //  The timer has the up/down pin wired to the reset signal.
   //  This doesn't make any sense.  I have not implemented this.
   //
   //  The timerCLK runs at 8.2 MHz instead of 4.1 MHZ because
   //  of a PLL limitation.  Therefore there is an extra counter
   //  stage.
   //
   
   reg [0:12] count;

   always @(posedge timerCLK or posedge rst)
     begin
        if (rst)
          count <= 13'b0;
        else if (timerEN)
          count <= count + 1'b1;
     end

   //
   // Change of clock domains
   //  Note: The counter is synchronized with the main clock.  This is a little
   //  different than the KS10
   //
   //

   reg timerLAST;
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             timerCOUNT <= 12'b0;
             timerLAST  <= 1'b0;
          end
        else if (clken)
          begin
             timerCOUNT <= count[0:9];
             timerLAST  <= timerCOUNT[24];
          end
     end
             
   //
   // Interrupt Enable
   //  The timerINTR signal is asserted on a timer overflow;
   //  i.e., when MSB changes from '1' to '0'.
   //
   //  Resetting the interrupt has priority over setting the interrupt.
   //
   //  DPMC/E56
   //  DPMC/E1
   //  DPMC/E3
   //
   
   wire timerRST = `cromSPEC_EN_10 & (`cromSPEC_SEL == `cromSPEC_SEL_CLR1MSEC);

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          timerINTR <= 1'b0;
        else if (clken)
          if (timerRST)
            timerINTR <= 1'b0;
          else if (timerEN & ~timerCOUNT[24] & timerLAST)
            timerINTR <= 1'b1;
     end

endmodule
