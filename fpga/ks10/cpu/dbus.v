////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      DBUS Multiplexor
//!
//! \details
//!
//! \todo
//!
//! \file
//!      dbus.v
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

module DBUS(crom, vmaADDR, vmaFLAGS, pcFLAGS, dp, ramfile, dbm, dbus);

   parameter  cromWidth = `CROM_WIDTH;

   input      [0:cromWidth-1] crom;             // Control ROM Data
   input      [ 0:13]         vmaFLAGS;         // Virtual Memory Flags
   input      [14:35]         vmaADDR;          // Virtual Memory Address
   input      [ 0:35]         pcFLAGS;          // PC Flags in Left Half
   input      [ 0:35]         dp;               // Datapath
   input      [ 0:35]         ramfile;          // Ramfile
   input      [ 0:35]         dbm;              // Databus Mux
   output reg [ 0:35]         dbus;             // DBus

   //
   // VMA Flags
   //

   wire vmaREADCYCLE = vmaFLAGS[3];
   wire vmaPHYSICAL  = vmaFLAGS[8];

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

   wire vmaACREF = ~vmaPHYSICAL & (vmaADDR[18:31] == 14'b0);

   //
   // Force RAMFILE
   //
   // Details
   //  This signal is asserted on an AC reference or a cache hit.
   //  When asserted during a read cycle, the DBM mux causes the
   //  RAMFILE to be read instead of main memory.
   //
   // Trace
   //  DPM5/E14
   //  DPM5/E38
   //

   wire cacheHIT     = 1'b0;            // FIXME

   wire forceRAMFILE = ((vmaACREF & vmaREADCYCLE) |
                        (cacheHIT & vmaREADCYCLE));

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

   always @(`cromDBUS_SEL or pcFLAGS or dp or ramfile or dbm or forceRAMFILE)
     begin
        case (`cromDBUS_SEL)
          `cromDBUS_SEL_FLAGS:
            dbus = pcFLAGS;
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
