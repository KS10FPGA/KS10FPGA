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

`include "microcontroller/crom.vh"

module TIMER(clk, rst, clken, crom, msec_en, msec_intr, msec_count);

   parameter cromWidth = `CROM_WIDTH;

   input                  clk;          // Clock
   input                  rst;          // Reset
   input                  clken;        // Clock Enable
   input  [0:cromWidth-1] crom;         // Control ROM Data
   input                  msec_en;      // Timer Enable
   output reg             msec_intr;    // Timer Interrupt
   output [0:11]          msec_count;   // Timer output

   //
   // CLKGEN
   // The Timer requires a 4.1 MHz clock.  Instead of an oscillator
   // we will employ a PLL.
   //  DPMC/E198
   //

   wire timerclk;

   CLKGEN uCLKGEN(.clk(clk), .rst(rst), .timerclk(timerclk));

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

   reg [0:11] count;

   always @(posedge timerclk or posedge rst)
     begin
        if (rst)
          count <= 12'b0;
        else if (clken)
          begin
             count <= count + 1'b1;
          end
     end

   //
   // Interrupt Enable
   // The msec_intr signal is asserted on a timer overflow;
   //  i.e., MSB changes from '1' to '0'.
   //  DPMC/E56
   //  DPMC/E1
   //  DPMC/E3
   //

   wire reset_msec = `cromSPEC_EN_10 & (`cromSPEC_SEL == `cromSPEC_SEL_CLR1MSEC);
   reg  last;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             msec_intr <= 1'b0;
             last      <= 1'b0;
          end
        else
          begin
             if (reset_msec)
               msec_intr <= 1'b0;
             else if (msec_en && (count[0] == 1'b0) && (last == 1'b1))
               msec_intr <= 1'b1;
             last <= count[0];
          end
     end

   assign msec_count = count;

endmodule
