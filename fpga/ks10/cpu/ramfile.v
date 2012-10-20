////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      Ramfile
//!
//! \details
//!      
//! \note
//!     
//!     +------+----------------+
//!     | 1777 |                |
//!     |      |     Cache      |
//!     | 1000 |                |
//!     +------+----------------+
//!     | 0777 |                |
//!     |      |   Workspace    |
//!     | 0200 |                |
//!     +------+----------------+
//!     | 0177 |                |
//!     |      |   AC Block 7   |
//!     | 0160 |                |
//!     +------+----------------+
//!     | 0067 |                |
//!     |      |   AC Block 6   |
//!     | 0140 |                |
//!     +------+----------------+
//!     | 0037 |                |
//!     |      |   AC Block 5   |
//!     | 0120 |                |
//!     +------+----------------+
//!     | 0117 |                |
//!     |      |   AC Block 4   |
//!     | 0100 |                |
//!     +------+----------------+
//!     | 0077 |                |
//!     |      |   AC Block 3   |
//!     | 0060 |                |
//!     +------+----------------+
//!     | 0057 |                |
//!     |      |   AC Block 2   |
//!     | 0040 |                |
//!     +------+----------------+
//!     | 0037 |                |
//!     |      |   AC Block 1   |
//!     | 0020 |                |
//!     +------+----------------+
//!     | 0017 |                |
//!     |      |   AC Block 0   |
//!     | 0000 |                |
//!     +------+----------------+
//!
//! \todo
//!
//! \file
//!      ramfile.v
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

module RAMFILE(clk, rst, clken, crom, dbus, dbm, ac,
               xr, xr_previous,
               vmaADDR, vmaPHYSICAL, vmaPREVIOUS,
               previous_block, current_block,
               //memory_cycle, mem_wait, mem_read, stop_main_memory,
               ram);
   
   parameter cromWidth = `CROM_WIDTH;
            
   input                   clk;                 // Clock
   input                   rst;                 // Reset
   input                   clken;               // Clock enable
   input  [ 0:cromWidth-1] crom;                // Control ROM Data
   input  [ 0:35]          dbus;                // DBUS Input
   input  [ 0:35]          dbm;                 // DBM Input
   input  [ 9:12]          ac;                  // AC
   input  [14:17]          xr;                  // XR
   input                   xr_previous;         //
   input  [14:35]          vmaADDR;             // Virtual Memory Address
   input                   vmaPHYSICAL;         // 
   input                   vmaPREVIOUS;         //
   input  [0:2]            previous_block;      //
   input  [0:2]            current_block;       //
   output [0:35]           ram;                 // RAMFILE output
   
   //
   // AC Reference
   //  True when addressing lowest 16 addresses using
   //  physical addressing.
   //
   
   wire vmaACREF = vmaPHYSICAL & (vmaADDR[18:31] == 14'b0);
   
   //
   // This was a 74LS181 ALU.  Only the part of that device
   // that is used implemented.  The CROM Number field is
   // present on the DBUS.  See microcode.
   //
   //  DPE6/E79
   //

   wire [0:5] acFUN = dbus[ 8:13];      // See cromACALU_EXTFUN
   wire [0:2] acNUM = dbus[14:17];      // See cromACALU_NUM;
   reg  [0:3] acPN;
   
   always @(acFUN or acNUM or ac)
     begin
        case (acFUN)
          6'o25  : acPN = acNUM;
          6'o62  : acPN = ac + acNUM;
          default: acPN = 4'b0;
        endcase
     end
   
   //
   // Address Mux
   //  DPE6/E3
   //  DPE6/E6
   //  DPE6/E7
   //  DPE6/E8
   //  DPE6/E13
   //  DPE6/E14
   //  DPE6/E15
   //  DPE6/E16
   //  DPE6/E21
   //  DPE6/E22
   //  DPE6/E23
   //  DPE6/E24
   // 

   reg  [0:9] addr;
   wire [0:2] selRAMADDR = `cromRAMADDR_SEL;

   always@(selRAMADDR or current_block or previous_block or ac or
           xr or acPN or xr_previous or vmaACREF or vmaPREVIOUS or vmaADDR or dbm)
     begin
        case(selRAMADDR)
          `cromRAMADDR_SEL_AC:
            addr = {3'b0, current_block, ac  };
          `cromRAMADDR_SEL_ACOPNUM:
            addr = {3'b0, current_block, acPN};
          `cromRAMADDR_SEL_XR:
            begin
               if (xr_previous)
                 addr = {3'b0, previous_block, xr};
               else 
                 addr = {3'b0, current_block,  xr};
            end
          `cromRAMADDR_SEL_SPARE3:
            addr = 9'b0;
          `cromRAMADDR_SEL_VMA:
            begin
               if (vmaACREF)
                 begin
                    if (vmaPREVIOUS)
                      addr = {3'b0, previous_block, vmaADDR[32:35]};
                    else
                      addr = {3'b0, current_block, vmaADDR[32:35]};
                 end
               else
                 addr = {1'b1, vmaADDR[27:35]};
            end
          `cromRAMADDR_SEL_SPARE5:
            addr = 9'b0;
          `cromRAMADDR_SEL_RAM:
            addr = vmaADDR[26:35];
          `cromRAMADDR_SEL_NUM:
            addr = {dbm[26:28], dbm[11:17]};
        endcase
     end
   
   //
   // RAMFILE PAGE WRITE
   //  DPMA/E2
   //  DPMC/E3
   //  DPMA/E134
   //  DPMA/E119
   //

   reg pageWR;
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          pageWR <= 1'b0;
        else if (clken)
          pageWR <= `cromSPEC_EN_10 && (`cromSPEC_SEL == `cromSPEC_SEL_PAGEWRITE);
     end

   //
   // RAMFILE MEMORY
   //
   
   RAM1Kx36 uRAM1Kx36(.clk(clk),
                      .clken(clken),
                      .wr(pageWR),
                      .addr(addr),
                      .din(dbus),
                      .dout(ram));
   
endmodule
