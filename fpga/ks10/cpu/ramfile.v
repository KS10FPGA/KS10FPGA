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

module RAMFILE(clk, rst, clken, crom, dbus, dbm, regIR, xrPREV,
               vmaADDR, vmaPHYSICAL, vmaPREVIOUS,
               previous_block, current_block,
               //memory_cycle, mem_wait, mem_read, stop_main_memory,
               ramfile);
   
   parameter cromWidth = `CROM_WIDTH;
            
   input                   clk;                 // Clock
   input                   rst;                 // Reset
   input                   clken;               // Clock enable
   input  [ 0:cromWidth-1] crom;                // Control ROM Data
   input  [ 0:35]          dbus;                // DBUS Input
   input  [ 0:35]          dbm;                 // DBM Input
   input  [ 0:17]          regIR;               // Instruction Register
   input                   xrPREV;          	//
   input  [14:35]          vmaADDR;             // Virtual Memory Address
   input                   vmaPHYSICAL;         // 
   input                   vmaPREVIOUS;         //
   input  [0:2]            previous_block;      //
   input  [0:2]            current_block;       //
   output [0:35]           ramfile;             // RAMFILE output

   //
   // IR Fields
   //
   
   wire [ 9:12] regIR_AC = regIR[ 9:12];        // Instruction Register AC Field
   wire [14:17] regIR_XR = regIR[14:17];        // Instruction Register XR Field
   
   //
   // AC Reference
   //  True when addressing lowest 16 addresses using
   //  physical addressing.
   //
   
   wire vmaACREF = vmaPHYSICAL & (vmaADDR[18:31] == 14'b0);
   
   //
   // This was a 74LS181 ALU in the KS10.  Only the part of
   // that device that is used is implemented.  This adder is
   // controlled by one of the overloaded usages of the CROM
   // number field.   See cromACALU_FUN and cromACALU_NUM.
   // I'm not exactly certain why this is controlled by the
   // DBM instead of directly by the microcode.  It is
   // probably just because of the way the boards were
   // partitioned.
   //
   //  DPE6/E79
   //

   wire [0:5] acFUN = dbm[ 8:13];
   wire [0:2] acNUM = dbm[14:17];
   reg  [0:3] AC_PLUS_N;
   
   always @(acFUN or acNUM or regIR_AC)
     begin
        case (acFUN)
          6'o25  : AC_PLUS_N = acNUM;
          6'o62  : AC_PLUS_N = regIR_AC + acNUM;
          default: AC_PLUS_N = 4'b0;
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

   always@(selRAMADDR or current_block or previous_block or regIR_AC or
           regIR_XR or AC_PLUS_N or xrPREV or vmaACREF or vmaPREVIOUS or
           vmaADDR or dbm)
     begin
        case(selRAMADDR)
          `cromRAMADDR_SEL_AC:
            addr = {3'b0, current_block, regIR_AC };
          `cromRAMADDR_SEL_ACOPNUM:
            addr = {3'b0, current_block, AC_PLUS_N};
          `cromRAMADDR_SEL_XR:
            begin
               if (xrPREV)
                 addr = {3'b0, previous_block, regIR_XR};
               else 
                 addr = {3'b0, current_block,  regIR_XR};
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
   // RAMFILE WRITE
   //  DPE5/E119
   //  DPMA/E22
   //  DPMA/E54
   //

/*
   // FIXME
   start_cycle =  ((`cromMEM_READCYCLE & `cromMEM_WRITECYCLE & ~stop_main_memory) &
                   (READ_EN | WRITE_EN) &
 
                   (CRA6_MEMORY_FUNCTION & `cromMEM_WAIT   &              )
                   (CRA6_MEMORY_FUNCTION & `cromMEM_BWRITE & dromCOND_FUNC));
 
*/
   
   wire ramfileWRITE = (
                   /*
                    ( vmaACREF & ~MEM_READ        & memory_cycle & mem_wait) |
                    (~vmaACREF & STOP_MAIN_MEMORY & memory_cycle & mem_wait) |
                    */
                   (`cromFMWRITE));
   
   //
   // RAMFILE MEMORY
   //
   
   RAM1Kx36 uRAM1Kx36(.clk(clk),
                      .clken(clken),
                      .wr(ramfileWRITE),
                      .addr(addr),
                      .din(dbus),
                      .dout(ramfile));
   
endmodule
