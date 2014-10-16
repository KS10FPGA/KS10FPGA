////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Microcontroller Call Stack
//
// Details
//
//   The call/return operation of the microcontroller is quite unique.  The
//   'call' instruction pushes the address of the instruction (not the next
//   instruction) on the call-stack.
//
//   Doing nothing else would return the execution to the very same instruction
//   as the original 'call' instruction.
//
//   The return instruction also provides a dispatch offset which is combined
//   with the return address from the stack to return to the next executable
//   microcode statement.
//
//   The 'called' function must know the offset to the next instruction.
//
// File
//   stack.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2014 Rob Doyle
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
`include "crom.vh"

module STACK(clk, rst, clken, call, ret, addrIN, addrOUT);

   parameter cromWidth = `CROM_WIDTH;

   input         clk;           // Clock
   input         rst;           // Reset
   input         clken;         // Clock Enable
   input         call;          // Push addr onto stakc
   input         ret;           // Pop addr from stack
   input  [0:11] addrIN;        // Calling address for stack
   output [0:11] addrOUT;       // Return address from stack

   //
   // Stack Pointer
   //
   // Details
   //  The stack pointer is incremented on a 'call' and decremented on a 'ret'
   //  instruction - otherwise the stack pointer does not change.
   //
   // Trace
   //  CRA3/E32
   //

   reg [0:3] sp;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          sp <= 15;
        else if (clken)
          begin
             if (call)
               sp <= sp + 1'b1;
             else if (ret)
               sp <= sp - 1'b1;
          end
     end

   //
   // Current Address
   //
   // Details
   //  This delay generates the current microcode address.  The 'addr' register
   //  that is supplied to this module always has the address of the /NEXT/
   //  instruction.
   //
   //  This is a simple one-clock delay to get the proper address.
   //
   // Trace
   //  CRA3/E114
   //  CRA3/E137
   //  CRA3/E161
   //

   reg [0:11] currADDR;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          currADDR <= 12'b0;
        else if (clken)
          currADDR <= addrIN;
     end

   //
   // Write Pointer
   //
   // Details:
   //  The write pointer is always offset from the stack pointer by 1.
   //
   // Note:
   //  This is different than the KS10.  See below.
   //
   // Trace:
   //  CRA3/E16
   //  CRA3/E17
   //

   wire [0: 3] wp = sp + 1'b1;

   //
   // Dual Ported Stack
   //
   // Details
   //  The stack is implemented quite a bit differently than the KS10 just
   //  because the FPGA provides Dual Port RAMs.
   //
   //  The 'read' port of the Dual Port RAM provides the return address.  This
   //  port always points to the top-of-stack and can always be accessed
   //  independantly.
   //
   //  The 'write' port of the Dual Port RAM is used to store the next 'call'
   //  address.  This port always points to the address past the top-of-stack
   //  and can always be accessed independantly.
   //
   //  Once the 'call' address is stored, the stack pointer is incremented and
   //  the return address automatically becomes available at the new
   //  top-of-stack.
   //
   //  This implementation saves all ths KS10 logic to dynamically change RAM
   //  address depending if a 'call' or 'return' instruction is being processed.
   //  It also allow the stack to always update in a single clock cycle.
   //
   // Trace
   //  CRA3/E70
   //  CRA3/E56
   //  CRA3/149
   //  CRA3/E79
   //  CRA3/E55
   //  CRA3/E160
   //

`ifndef SYNTHESIS
   integer i;
`endif

   reg [0:11] stack[0:15];

   always @(posedge clk or posedge rst)
     begin
        if (rst)
`ifdef SYNTHESIS
          ;
`else
          for (i = 0; i < 16; i = i + 1)
            stack[i] <= 0;
`endif
        else if (clken & call)
          stack[wp] <= currADDR;
     end

   //
   // The stack read is asynchronous
   //

   assign addrOUT = stack[sp];

endmodule
