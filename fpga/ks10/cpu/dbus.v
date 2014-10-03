////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DBUS Multiplexer
//
// Details
//
// File
//   dbus.v
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
`include "vma.vh"
`include "useq/crom.vh"

module DBUS(crom, cacheHIT, piREQPRI, vmaREG, pcFLAGS, dp, ramfile, dbm, dbus);

   parameter  cromWidth = `CROM_WIDTH;

   input      [0:cromWidth-1] crom;             // Control ROM Data
   input                      cacheHIT;         // Cache Hit
   input      [ 0: 2]         piREQPRI;         // Requested Interrupt Priority
   input      [ 0:35]         vmaREG;           // VMA Register
   input      [ 0:17]         pcFLAGS;          // PC Flags in Left Half
   input      [ 0:35]         dp;               // Datapath
   input      [ 0:35]         ramfile;          // Ramfile
   input      [ 0:35]         dbm;              // Databus Mux
   output reg [ 0:35]         dbus;             // DBus

   //
   // VMA Flags
   //

   wire vmaREAD = `vmaREAD(vmaREG);
   wire vmaPHYS = `vmaPHYS(vmaREG);

   //
   // AC Reference
   //
   // Details:
   //  True when addressing lowest 16 addresses using and not
   //  physical addressing.  References to the ACs are never
   //  physical.
   //
   // Trace
   //  DPM4/E160
   //  DPM4/E168
   //  DPM4/E191
   //

   wire vmaACREF = `vmaACREF(vmaREG);

   //
   // Force RAMFILE
   //
   // Details
   //  This signal is asserted on an AC reference or a cache hit.
   //  When asserted during a read cycle, the DBM mux causes the
   //  RAMFILE to be read instead of main memory.
   //
   // Fixme
   //  I'm not sure why I had to hack this to exclude address
   //  1146.
   //
   // Trace
   //  DPM5/E14
   //  DPM5/E38
   //

   wire forceRAMFILE = ((vmaACREF & vmaREAD & (crom[0:11] != 12'o1146) & (crom[0:11] != 12'o3666)) |
                        (cacheHIT & vmaREAD));

   //
   // DBM
   //
   // Details
   //  This is a simple 4-way 36-bit multiplexer.
   //
   // Trace
   //  DPE3/E34
   //  DPE3/E35
   //  DPE3/E40
   //  DPE3/E56
   //  DPE3/E63
   //  DPE3/E70
   //  DPE3/E72
   //  DPE3/E73
   //  DPE3/E87
   //  DPE3/E100
   //

   always @*
     begin
        case (`cromDBUS_SEL)
          `cromDBUS_SEL_FLAGS:
            dbus = {pcFLAGS, 1'b0, piREQPRI, 4'b1111, vmaREG[26:35]};
          `cromDBUS_SEL_DP:
            dbus = dp;
          `cromDBUS_SEL_RAMFILE:
            dbus = ramfile;
          `cromDBUS_SEL_DBM:
            if (forceRAMFILE)
              dbus = ramfile;
            else
              dbus = dbm;
        endcase
     end

endmodule
