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
//! \note
//!       In the original circuitry the Control ROM (microcode)
//!       was supplied to this module via the dbm input.  This
//!       has been replaced by a direct connection to the Control
//!       ROM. Presumably this was done because of circuit board
//!       interconnection limitations.
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
`include "useq/drom.vh"

module RAMFILE(clk, rst, clken, crom, drom, dp, dbus, regIR, xrPREV,
               vmaFLAGS, vmaADDR, acBLOCK,
               ramfile);

   parameter cromWidth = `CROM_WIDTH;
   parameter dromWidth = `DROM_WIDTH;

   input                   clk;                 // Clock
   input                   rst;                 // Reset
   input                   clken;               // Clock enable
   input  [ 0:cromWidth-1] crom;                // Control ROM Data
   input  [ 0:dromWidth-1] drom;                // Dispatch ROM Data
   input  [ 0:35]          dp;                  // DP Input
   input  [ 0:35]          dbus;                // DBUS Input
   input  [ 0:17]          regIR;               // Instruction Register
   input                   xrPREV;              // XR Previous
   input  [ 0:13]          vmaFLAGS;            // Virtual Memory Flags
   input  [14:35]          vmaADDR;             // Virtual Memory Address
   input  [ 0: 5]          acBLOCK;             // AC Blocks
   output [ 0:35]          ramfile;             // RAMFILE output

   //
   // IR Fields
   //

   wire [ 9:12] regIR_AC = regIR[ 9:12];        // Instruction Register AC Field
   wire [14:17] regIR_XR = regIR[14:17];        // Instruction Register XR Field

   //
   // VMA Flags
   //

   wire vmaREADCYCLE  = vmaFLAGS[3];
   wire vmaWRITECYCLE = vmaFLAGS[5];
   wire vmaPHYSICAL   = vmaFLAGS[8];
   wire vmaPREVIOUS   = vmaFLAGS[9];

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
   // AC Blocks
   //

   wire [0:2] currBLOCK = acBLOCK[0:2];         // Current AC Block
   wire [0:2] prevBLOCK = acBLOCK[3:5];         // Previous AC Block

   //
   // Address Mux
   //
   // Details
   //  This mux provide the address for various RAMFILE
   //  operations.   Operations can be:
   //
   //  Access to the RAMFILE ACs are selected using the
   //  AC field of the instruction.
   //
   //  1.  Access to an AC in the current context using
   //      the AC field of the instruction.
   //  2.  Access to an AC in the current context using
   //      the XR field of the instruction.
   //  3.  Access to an AC in the previous context using
   //      the XR field of the instruction.
   //  4.  Access to an AC in the current context using
   //      a plain address.
   //  5.  Access to an AC in the previous context using
   //      a plain address.
   //  6.  Access to RAMFILE storage.
   //  7.  Access to the cache
   //
   // Note:
   //  The KS10 used {dbm[26:28], dbm[11:17]} for the
   //  cromRAMADDR_SEL_NUM case below.  Since the number
   //  field in on both halves of the dbm, this is
   //  equivalent to dbm[8:17].  This has been replaced
   //  by a direct connection to the CROM.
   //
   //  This was a 74LS181 ALU in the KS10.  Only the part of
   //  that device that is used is implemented.  This adder is
   //  controlled by one of the overloaded usages of the CROM
   //  number field.
   //
   // Trace
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
   //  DPE6/E79
   //

   reg  [0:9] addr;

   always@(crom or currBLOCK or prevBLOCK or regIR_AC or regIR_XR or
           xrPREV or vmaACREF or vmaPREVIOUS or vmaADDR)
     begin
        case(`cromRAMADDR_SEL)
          `cromRAMADDR_SEL_AC:
            addr = {3'b0, currBLOCK, regIR_AC };
          `cromRAMADDR_SEL_ACOPNUM:
            case (`cromACALU_FUN)
              6'o25  :
                addr = {3'b0, currBLOCK, `cromACALU_NUM};
              6'o62  :
                addr = {3'b0, currBLOCK, `cromACALU_NUM + regIR_AC};
              default:
                addr = {3'b0, currBLOCK, `cromACALU_NUM};
            endcase
          `cromRAMADDR_SEL_XR:
            begin
               if (xrPREV)
                 addr = {3'b0, prevBLOCK, regIR_XR};
               else
                 addr = {3'b0, currBLOCK, regIR_XR};
            end
          `cromRAMADDR_SEL_VMA:
            begin
               if (vmaACREF)
                 begin
                    if (vmaPREVIOUS)
                      addr = {3'b0, prevBLOCK, vmaADDR[32:35]};
                    else
                      addr = {3'b0, currBLOCK, vmaADDR[32:35]};
                 end
               else
                 addr = {1'b1, vmaADDR[27:35]};
            end
          `cromRAMADDR_SEL_RAM:
            addr = vmaADDR[26:35];
          `cromRAMADDR_SEL_NUM:
            addr = `cromSNUM;
          default:
            addr = 9'b0;
        endcase
     end

   //
   // RAMFILE WRITE
   //
   // Todo
   //  FIXME: This is a work-in-progess.
   //
   // Trace
   //  DPE5/E119
   //  DPMA/E22
   //  DPMA/E54
   //

/*
   reg DPM5_READ_EN;
   reg DPM5_WRITE_EN;
   always @(crom or drom or dp )
     begin
        case (`cromMEM_CYCLE_SEL)
          0:
            begin
               DPM5_READ_EN  = `cromMEM_READCYCLE;
               DPM5_WRITE_EN = `cromMEM_WRITECYCLE;
            end
          1:
            begin
               DPM5_READ_EN  = dp[3];
               DPM5_WRITE_EN = dp[5];
            end
          2:
            begin
               DPM5_READ_EN  = `dromREADCYCLE;
               DPM5_WRITE_EN = `dromWRITECYCLE;
            end
          default:
            begin
               DPM5_READ_EN  = 1'b0;
               DPM5_WRITE_EN = 1'b0;
            end
        endcase
     end

   wire STOP_MAIN_MEMORY = 1'b0;

   wire specMEM_WAIT = `cromSPEC_EN_10 & (`cromSPEC_SEL == `cromSPEC_SEL_MEMWAIT);
   wire specMEM_CLR  = `cromSPEC_EN_20 & (`cromSPEC_SEL == `cromSPEC_SEL_MEMCLR );

   wire DPM5_MEM_EN = ((`cromMEM_CYCLE & `cromMEM_WAIT                   ) |
                       (`cromMEM_CYCLE & `cromMEM_BWRITE & `dromCOND_FUNC));

   wire DPM5_MEM_WAIT = DPM5_MEM_EN | specMEM_WAIT | specMEM_CLR;

   wire DPM5_RPW_CYCLE = vmaREADCYCLE & vmaWRITECYCLE & ~STOP_MAIN_MEMORY;

   //wire DPM5_START_CYCLE = ~DPM5_RPW_CYCLE & (DPM5_READ_EN | DPM5_WRITE_EN) & DPM5_MEM_EN;

   wire DPM5_START_CYCLE = ((DPM5_READ_EN  & DPM5_MEM_EN & ~DPM5_RPW_CYCLE) |
                            (DPM5_WRITE_EN & DPM5_MEM_EN & ~DPM5_RPW_CYCLE));

   reg DPM6_MEMORY_CYCLE;
   always @(posedge clk or posedge rst)
    begin
        if (rst)
          DPM6_MEMORY_CYCLE <= 1'b0;
        else if (clken)
          DPM6_MEMORY_CYCLE <= DPM5_START_CYCLE;
    end

   wire ramfileWRITE = (( vmaACREF & ~vmaREADCYCLE    & DPM6_MEMORY_CYCLE & DPM5_MEM_WAIT) |
                        (~vmaACREF & STOP_MAIN_MEMORY & DPM6_MEMORY_CYCLE & DPM5_MEM_WAIT) |
                        (`cromFMWRITE));

*/

    wire ramfileWRITE = ((vmaACREF & vmaWRITECYCLE) |
                         (`cromFMWRITE));

   //
   // RAMFILE MEMORY
   //

   RAM1Kx36 uRAM1Kx36
     (.clk(clk),
      .clken(clken),
      .wr(ramfileWRITE),
      .addr(addr),
      .din(dbus),
      .dout(ramfile)
      );

endmodule
