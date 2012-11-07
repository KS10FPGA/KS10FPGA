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
//!      This timer code has be extensively re-written to clean
//!      up metastaility issues from the independant timer clock.
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

`include "useq/crom.vh"

module TIMER(clk, rst, clken, crom, timerEN, timerIRQ, timerCOUNT);

   parameter cromWidth = `CROM_WIDTH;

   input                  clk;          // Clock
   input                  rst;          // Reset
   input                  clken;        // Clock Enable
   input  [0:cromWidth-1] crom;         // Control ROM Data
   input                  timerEN;      // Timer Enable
   output                 timerIRQ;     // Timer Interrupt
   output [18:35]         timerCOUNT;   // Timer output

   //
   // CLKGEN
   //
   // Details:
   //  The Timer requires a 4.1 MHz clock.  This design uses a PLL
   //  instead of an oscillator.
   //
   // Note:
   //  Actually, the timerCLK runs at 8.2 MHz instead of 4.1 MHZ
   //  because of a PLL limitation (can't divide by a large enough
   //  number).  Therefore there is an extra counter stage in the
   //  timer.
   //
   // Trace:
   //  DPMC/E198
   //

   wire timerCLK;

   CLKGEN uCLKGEN
     (.clk(clk),
      .rst(rst),
      .timerCLK(timerCLK)
      );

   //
   // Timer Clock Synchronization
   //
   // Details:
   //  Synchronize timerCLK to the CPU clock domain.  I.e., treat
   //  timerCLK as an asynchronous input to the CPU.  This 'clock'
   //  input is synchronized by multiple levels of flip-flops to
   //  mitgate meta-stability issues.
   //
   // Note:
   //  timerINC is asserted for one clock cycle on the falling
   //  edge of timerCLK.
   //
   // Trace:
   //  The KS10 does this very differently any probably has
   //  metastability issues.  In fact, the microcode reads the timer
   //  twice to ensure that it gets the same answer!  See the RDTIME
   //  entry point in the microcode.
   //

   reg [0:2] d;
   reg timerINC;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             d[0]     <= 1'b0;
             d[1]     <= 1'b0;
             d[2]     <= 1'b0;
             timerINC <= 1'b0;
          end
        else
          begin
             d[0]     <= timerCLK;
             d[1]     <= d[0];
             d[2]     <= d[1];
             timerINC <= ~d[2] & d[1];
          end
     end

   //
   // Timer
   //
   // Details:
   //  This is the one millisecond interval timer.  Most of the
   //  timer is implemented in microcode...
   //
   // Note:
   //  The timer has the up/down pin wired to the reset signal.
   //  This doesn't make any sense.  I have not implemented this.
   //
   //  The timer is 13 bits instead of 12 bits because one bit
   //  has been added to the LSB because the clock frequency is
   //  8.2 MHz instead of 4.1 MHz.
   //
   //  This extra bit is used internally by the timer module only.
   //
   // Trace:
   //  DPMC/E180
   //  DPMC/E181
   //  DPMC/E189
   //

   reg [0:12] count;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          count <= 13'b0;
        else if (timerEN & timerINC)
          count <= count + 1'b1;
     end

   //
   // Timer Interrupt
   //
   // Details
   //  The timerIRQ signal is asserted on a timer overflow;
   //  i.e., when MSB changes from '1' to '0'.
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
             intr     <= 1'b0;
             timerMSB <= 1'b0;
          end
        else if (clken)
          begin
             if (timerRST)
               intr <= 1'b0;
             else if (timerEN & ~count[0] & timerMSB)
               intr <= 1'b1;
             timerMSB <= count[0];
          end
     end

   //
   // Fixups
   //  The KS10 does not use the two LSBS of the timer.
   //  The upper 6-bits are also not significant.
   //  The microcode seems to read all of the bits and does
   //  not perform any masking.
   //

   assign timerCOUNT[18:23] = 6'b0;
   assign timerCOUNT[24:33] = count[1:10];
   assign timerCOUNT[34:35] = 2'b0;
   assign timerIRQ          = intr;

endmodule
