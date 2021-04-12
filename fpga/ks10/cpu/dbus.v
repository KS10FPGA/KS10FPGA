////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DBUS Multiplexer
//
// Details
//   The DBUS module is essentially a 36-bit wide 4-to-1 multiplexer. This
//   multiplexer selects between the FLAGS, the ALU Output (DP), the DBM
//   Multiplexer and the RAMFILE.  On a read operation, the DBUS Multiplexer
//   also selects between the RAMFILE (where the ACs are stored) if an AC is
//   being read and memory if an AC is not being read.
//
// File
//   dbus.v
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

`include "vma.vh"
`include "useq/crom.vh"

module DBUS (
      input  wire [0:107] crom,         // Control ROM Data
      input  wire [0:  2] piREQPRI,     // Requested Interrupt Priority
      input  wire [0: 35] vmaREG,       // VMA Register
      input  wire [0: 17] pcFLAGS,      // PC Flags in Left Half
      input  wire [0: 35] dp,           // Datapath
      input  wire [0: 35] ramfile,      // Ramfile
      input  wire [0: 35] dbm,          // Databus Mux
      output reg  [0: 35] dbus          // DBus
   );

   //
   // VMA Flags
   //

   wire vmaREAD  = `vmaREAD(vmaREG);
   wire vmaACREF = `vmaACREF(vmaREG);

   //
   // Force RAMFILE
   //
   // Details
   //  This signal is asserted on an memory reference to an AC.  When asserted
   //  during a read cycle, the DBM mux causes the RAMFILE to be read instead of
   //  main memory.
   //
   // Trace
   //  DPM5/E14
   //  DPM5/E38
   //

   wire forceRAMFILE = vmaACREF & vmaREAD & (`cromDBM_SEL == `cromDBM_SEL_MEM);

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
   //  DPE4/E112
   //  DPE4/E127
   //  DPE4/E128
   //  DPE4/E141
   //  DPE4/E149
   //  DPE4/E162
   //  DPE4/E163
   //  DPE4/E177
   //  DPE4/E178
   //

   always @*
     begin
        case (`cromDBUS_SEL)
          `cromDBUS_SEL_FLAGS:
            dbus = {pcFLAGS[0:17], 1'b0, piREQPRI[0:2], 4'b1111, vmaREG[26:35]};
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
