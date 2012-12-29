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
//!      10 microseconds and another clocked every 1 ms, supported
//!      by updated microcode.
//!
//! \note
//!      This timer code has been extensively re-written to remove
//!      the 4.1 MHz clock and use the 50 MHz master clock.
//!
//!      IF YOU CHANGE THE CLOCK FREQUENCY FROM 50 MHZ YOU MUST
//!      CHANGE THE CONSTANTS IN THIS MODULE FOR THE TIMER TO
//!      WORK CORRECTLY.
//!
//! \file
//!      timer.v
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

`default_nettype none
`include "useq/crom.vh"
`include "../ks10.vh"  

module TIMER(clk, rst, clken, crom, timerEN, timerINTR, timerCOUNT);

   parameter cromWidth = `CROM_WIDTH;
   parameter CLKFRQ    = `CLKFRQ;
   parameter TIMFRQ    = 4.1e6;

   input                  clk;          // Clock
   input                  rst;          // Reset
   input                  clken;        // Clock Enable
   input  [0:cromWidth-1] crom;         // Control ROM Data
   input                  timerEN;      // Timer Enable
   output                 timerINTR;    // Timer Interrupt
   output [18:35]         timerCOUNT;   // Timer output

   //
   // Frequency Divider
   //
   // Detail:
   //  This creates the required 4.1 MHz 'clock' for the KS10 timer.
   //
   // Note:
   //  This is an implementation of a Fractional N divider using an
   //  accumulator.
   //
   //  32-bit was chosen because at 32-bits, the frequency error
   //  from the frequency division approximation is less than the
   //  frequency error of the clock generator crystal.
   //
   //  Increment = round-to-integer(2**32 * 4.1 MHz / 50.0 MHz)
   //
   //  Everytime this 32-bit counter overflows, it is time to
   //  increment the interval timer.
   //
   //  The use of an accumulator instead of divider keeps the
   //  average output frequency correct.  IOW, the accumulator
   //  maintains the fractional time when the count overflows.
   //

   reg  [0:31] accum;
   reg         carry;
   wire [0:31] incr = (2.0**32.0) * TIMFRQ / CLKFRQ;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          {carry, accum} = 33'b0;
        else
          {carry, accum} = {1'b0, accum} + {1'b0, incr};
     end

   wire timerINC = carry;

   //
   // Timer
   //
   // Details:
   //  This is the one millisecond interval timer.  Most of the
   //  timer is implemented in microcode.
   //
   // Note:
   //  In the KS10, the timer has the up/down pin wired to the
   //  reset signal. This doesn't make any sense.  I have not
   //  implemented this.
   //
   // Trace:
   //  DPMC/E180
   //  DPMC/E181
   //  DPMC/E189
   //

   reg [0:11] count;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          count <= 12'b0;
        else if (timerEN & timerINC)
          count <= count + 1'b1;
     end

   //
   // Timer Interrupt
   //
   // Details
   //  The timerINTR signal is asserted on a timer overflow;  i.e.,
   //  when MSB changes from '1' to '0'.
   //
   // Note:
   //  Resetting the interrupt has priority over setting the
   //  interrupt.
   //
   // Trace:
   //  DPMC/E1
   //  DPMC/E3
   //  DPMC/E56
   //

   wire timerRST = `cromSPEC_EN_10 & (`cromSPEC_SEL == `cromSPEC_SEL_CLR1MSEC);
   reg  timerMSB;
   reg  intr;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             intr     <= 0;
             timerMSB <= 0;
          end
        else if (clken)
          begin
             if (timerRST)
               intr <= 0;
             else if (timerEN & ~count[0] & timerMSB)
               intr <= 1;
             timerMSB <= count[0];
          end
     end

   //
   // Fixups
   //  The KS10 does not use the two LSBS of the timer.  The upper
   //  6-bits are also not significant.  The microcode seems to
   //  read all of the bits and does not perform any masking.
   //

   assign timerCOUNT[18:23] = 6'b0;
   assign timerCOUNT[24:33] = count[0:9];
   assign timerCOUNT[34:35] = 2'b0;
   assign timerINTR         = intr;

endmodule
