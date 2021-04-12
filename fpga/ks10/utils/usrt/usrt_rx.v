////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Generic unbuffered Synchronous Serial Receiver
//
// Details
//   This module implements a genereric unbuffered synchronous serial receiver.
//   This module can optionally support zero-bit deletion.
//
//   All characters, including the abort character, are eight bits.
//
//   Data is received LSB first.
//
// Note
//   This USRT primitive receiver is kept simple intentionally and is
//   therefore unbuffered.  If you require a double buffered USRT, then you
//   will need to layer a set of buffers on top of this device.
//
//   This Synchronous Serial Receiver is compatible with the DUP11.
//
// File
//   usrt_rx.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2009-2021 Rob Doyle
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

module USRT_RX (
      input  wire       clk,            // Clock
      input  wire       rst,            // Reset
      input  wire       clr,            // Clear
      input  wire       clken,          // Clock enable
      input  wire       decmode,        // DEC (DDCMP) Mode
      input  wire       rxd,            // Receiver serial data
      input  wire [7:0] synchr,         // Sync character
      output wire       crcen,          // Stuff bits (zero bit deletion)
      output wire       full,           // Receiver full
      output wire       flag,           // Flag character
      output wire       abort,          // Abort character
      output wire       decsyn,         // DEC (DDCMP) SYN character sequence
      output reg  [7:0] data            // Received data
   );

   //
   // Zero-bit delete
   //

   wire zbd;

   //
   // Serial Receiver Status Shift Register
   //
   // This register is never bit-stuffed.  It is used for finding flags,
   // abort characters, and SYN character pairs.
   //

   reg [15:0] stat;
   always @(posedge clk)
     begin
        if (rst | clr)
          stat <= 0;
        else if (clken)
          stat <= {rxd, stat[15:1]};
     end

   //
   // Serial Receiver Data Shift Register
   //
   // This is the data shift register.  Zero bit deletion is optionally
   // performed.
   //

   always @(posedge clk)
     begin
        if (rst | clr)
          data <= 0;
        else
          if (clken)
            if (!zbd)
              data <= {rxd, data[7:1]};
     end

   //
   // Flag character
   //
   // A flag character is '01111110'
   //

   assign flag = (stat[15:8] == 8'b0111_1110);

   //
   // Abort character
   //
   // An abort character '11111111'.
   //

   assign abort = (stat[15:8] == 8'b1111111);

   //
   // Pair of SYN characters
   //

   assign decsyn = (stat == {synchr, synchr});

   //
   // Special symbol
   //

   reg special;
   always @(posedge clk)
     begin
        if (rst)
          special <= 0;
        else if (clken)
          special <= flag | abort;
     end

   //
   // Ones counter
   //
   // This counts the number of consecutive ones.
   //

   reg [3:0] ones;
   always @(posedge clk)
     begin
        if (rst)
          ones <= 0;
        else
          if (clr)
            ones <= 0;
          else
            if (clken)
              if (!rxd)
                ones <= 0;
              else
                ones <= ones + 1'b1;
     end

   //
   // Zero bit delete
   //
   // Ignore the bit after the flag or abort character because the state
   // hasn't been updated and will never need zero-bit deleted.  Don't
   // do zero-bit deletes in DEC (DDCMP) mode.
   //

   assign zbd = !decmode & !special & (ones == 5);

   //
   // Sync
   //
   // The sync signal can either be a flag character in SDLC mode, or a
   // SYN character in DDCMP mode.
   //

   wire sync = decmode ? decsyn : flag;

   //
   // Receiver bit counter
   //
   // The bit counter is reset on the sync signal.  It keeps track of the
   // position of the last bit of the character.
   //

   reg [2:0] bitcnt;
   always @(posedge clk)
     begin
        if (rst)
          bitcnt <= 0;
        else if (clken)
          if (sync)
            bitcnt <= 1'b1;
          else if (!zbd)
            bitcnt <= bitcnt + 1'b1;
     end

   //
   // Valid
   //
   // Valid is asserted when the first sync character is found.
   //

   reg valid;
   always @(posedge clk)
     begin
        if (rst | clr)
          valid <= 0;
        else if (clken & sync)
          valid <= 1;
     end

   //
   // Create outputs
   //

   assign full = valid & (bitcnt == 0);

   assign crcen = !zbd;

endmodule
