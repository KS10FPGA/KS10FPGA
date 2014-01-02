////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   IO Latch
//
// Details
//   The IO Latch is a vestige of the Unibus IO implementation of
//   the DEC KS10.   In the DEC KS10 implementation, the KS10
//   backplane bus is synchronous while the Unibus IO bus is
//   asynchronous.   The IO Latch synchronized the backplane bus
//   and KS10 microcode to the Unibus.   The IO Latch was asserted
//   by the microcode when a Unibus IO transaction was asserted and
//   negated by the IO device when the IO transaction completed.
//
//   The KS10 FPGA is implemented quite differently.   In this
//   design, both the KS10 backplane bus and the IO bus are
//   synchronous and the IO Latch is not necessary.  The normal
//   KS10 backplane bus handshaking works for IO bus transactions
//   just like for memory transactions.
//
//   Even though this is true, the microcode verifies that the IO
//   Latch is asserted and waits until the IO Latch is negated -
//   therefore the IO Latch needs to be implemented.
//
//   This code implements the IO Latch as a non-retriggerable
//   one-shot state machine that is asserted by the microcode and
//   clears after a few clock cycles.  This 'fakes-out' the
//   microcode.
//
//   Ideally the IO Latch functionality should be removed from the
//   microcode.
//
// File
//   iolatch.v
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
`include "useq/crom.vh"
`include "vma.vh"

module IOLATCH(clk, rst, clken, crom, vmaFLAGS, iolatch);

   parameter cromWidth = `CROM_WIDTH;

   input                  clk;          // Clock
   input                  rst;          // Reset
   input                  clken;        // Clock Enable
   input  [0:cromWidth-1] crom;         // Control ROM Data
   input  [0:13]          vmaFLAGS;     // VMA Flags
   output                 iolatch;      // IO Latch

   //
   // State definition
   //

   localparam [0:1] stateIDLE   =  0,   // Waiting for IO Cycle
                    stateDELAY1 =  1,   // Delay
                    stateDELAY2 =  2,   // Delay
                    stateWAIT   =  3;   // IO Latch cleared, wait for IO Cycle to complete

   //
   // VMA Flags
   //

   wire vmaIOCYCLE = `vmaIOCYCLE(vmaFLAGS);

   //
   // IO Latch
   //
   // Trace
   //  DPEA/E99
   //  DPEA/E93
   //

   reg [0:1] state;
   reg       iolatch;

   always @(posedge clk or posedge rst)
    begin
        if (rst)
          begin
             iolatch <= 0;
             state <= stateIDLE;
          end
        else if (clken)
          case (state)
            stateIDLE:
              if (vmaIOCYCLE)
                begin
                   iolatch <= 1;
                   state   <= stateDELAY1;
                end
            stateDELAY1:
              state <= stateDELAY2;
            stateDELAY2:
                begin
                   iolatch <= 0;
                   state   <= stateWAIT;
                end
            stateWAIT:
              if (~vmaIOCYCLE)
                state <= stateIDLE;
          endcase
    end

 endmodule
