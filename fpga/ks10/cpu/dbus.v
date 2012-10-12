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

module DBUS(crom, force_ramfile, flags, dp, ram, dbm, dbus);

   parameter  cromWidth = `CROM_WIDTH;

   input      [0:cromWidth-1] crom;             // Control ROM Data
   input                      force_ramfile;    // Force Ramfile
   input      [0:35]          flags;         // PC Flags in Left Half
   input      [0:35]          dp;               // Datapath
   input      [0:35]          ram;              // RAM File
   input      [0:35]          dbm;              // Databus Mux
   output reg [0:35]          dbus;             // DBus

   //
   // DBM
   //  DPE3/E34
   //  DPE3/E72
   //  DPE3/E35
   //  DPE3/E73
   //  DPE3/E56
   //  DPE3/E100
   //  DPE3/E63
   //  DPE3/E87
   //  DPE3/E40
   //  DPE3/E70 (force ramfile)
   //

   wire [0:1] cromDBUS = `cromDBUS;
   wire [0:1] dbusSEL = {cromDBUS[0], cromDBUS[1] & ~(cromDBUS[0] & force_ramfile)};
   
   always @(dbusSEL or flags or dp or ram or dbm)
     begin
        case (dbusSEL)
          `cromDBUS_FLAGS:
            dbus = flags;
          `cromDBUS_DP:
            dbus = dp;
          `cromDBUS_RAM:
            dbus = ram;
          `cromDBUS_DBM:
            dbus = dbm;
        endcase
     end

endmodule
