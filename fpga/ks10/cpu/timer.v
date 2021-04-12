////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Timer
//
// Details
//   The original KS10 interval timer was 12 bits and operated with a 4.096 MHz
//   clock.  The 12-bit timer generates an interrupt exactly every one
//   millisecond.
//
//   This did not work well in practice.  The RDTIME instruction needs to
//   convert timer output to time in 10 us increment which would require a
//   division by 40.96.  Therefore the timer frequency was changed to 4.100
//   MHz and the microcode does a division by 41 to support the RDTIME
//   instruction.
//
//   You can find the details of KS10 timer design (and it's problems) in a
//   DEC memo authored by Dan Murphy entitled "Clocks for Dolphin" on
//   bitsavers.org
//
//   The KS10 would benefit from two timers, one clocked every 10 microseconds
//   and another clocked every 1 ms, supported by updated microcode.
//
// Note
//   This timer code uses a Fractional-N divider to accurately create the 
//   4.1 MHz timer clock.  Set the CLKFRQ macro correctly.
//
// File
//   timer.v
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

`include "useq/crom.vh"

//
// Timer clock frequency is 4.1 MHz
//

`define TIMERFRQ 4100000

module TIMER (
      input  wire         clk,          // Clock
      input  wire         rst,          // Reset
      input  wire         clken,        // Clock Enable
      input  wire [0:107] crom,         // Control ROM Data
      input  wire         timerEN,      // Timer Enable
      output reg          timerINTR,    // Timer Interrupt
      output wire [18:35] timerCOUNT    // Timer output
   );

   //
   // Microcode Decode
   //

   wire timerRST = `cromSPEC_EN_10 & (`cromSPEC_SEL == `cromSPEC_SEL_CLR1MSEC);

   //
   // Frequency Divider
   //
   // Detail:
   //  This creates the required 4.1 MHz 'clock' for the KS10 timer.
   //
   // Note:
   //  This is an implementation of a Fractional N divider using an accumulator.
   //
   //  32-bit was chosen because at 32-bits, the frequency error from the
   //  frequency division approximation is less than the frequency error of the
   //  clock generator crystal.
   //
   //  Increment = round-to-integer(2**32 * 4.1 MHz / 50.0 MHz)
   //
   //  Everytime this 32-bit counter overflows, it is time to increment the
   //  interval timer.
   //
   //  The use of an accumulator instead of divider keeps the average output
   //  frequency correct.  IOW, the accumulator maintains the fractional time
   //  when the count overflows.
   //

   reg  [0:31] accum;
   reg         carry;
   wire [0:31] incr = (2.0**32.0) * `TIMERFRQ / `CLKFRQ;

   always @(posedge clk)
     begin
        if (rst)
          {carry, accum} <= 33'b0;
        else
          {carry, accum} <= {1'b0, accum} + {1'b0, incr};
     end

   wire timerINC = carry;

   //
   // Timer Counter
   //
   // Details
   //  This is the one millisecond interval timer.  Most of the timer is
   //  implemented in microcode.
   //
   // Note:
   //  In the KS10, the timer has the up/down pin wired to the reset signal.
   //  This doesn't make any sense.  I have not implemented this.
   //
   // Trace:
   //  DPMC/E180
   //  DPMC/E181
   //  DPMC/E189
   //

   reg [0:11] count;

   always @(posedge clk)
     begin
        if (rst)
          count <= 12'b0;
        else if (timerEN & timerINC)
          count <= count + 1'b1;
     end

   //
   // Keep track of MSB transitions
   //
   // Trace:
   //  DPMC/E1
   //  DPMC/E56
   //

   reg  lastMSB;
   wire currMSB = count[0];

   always @(posedge clk)
     begin
        if (rst)
          lastMSB <= 0;
        else
          lastMSB <= currMSB;
     end

   //
   // Timer Interrupt
   //
   // Details
   //  The timerINTR signal is asserted on a timer overflow;  i.e., when MSB
   //  changes from '1' to '0'.
   //
   // Note:
   //  Resetting the interrupt has priority over setting the interrupt.
   //
   // Trace:
   //  DPMC/E1
   //  DPMC/E3
   //

   always @(posedge clk)
     begin
        if (rst)
          timerINTR <= 0;
        else if (clken)
          begin
             if (timerRST)
               timerINTR <= 0;
             else if (timerEN & !currMSB & lastMSB)
               timerINTR <= 1;
          end
     end

   //
   // The KS10 does not use the two LSBS of the timer.  The upper 6-bits are
   // also not significant.  The microcode seems to read all of the bits and
   // does not perform any masking.
   //

   assign timerCOUNT = {6'b0, count[0:9], 2'b0};

endmodule
