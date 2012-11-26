////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      KS-10 Unibus Adapter
//!
//! \details
//!      Important addresses:
//!
//!      763000-763077 : UBA paging RAM
//!      763100        : UBA Status Register
//!      763101        : UBA Maintenace Register
//!
//! \todo
//!
//! \file
//!      uba.v
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

module UBA(clk, clken, ubaINTR, curINTR_NUM,
           busREQI, busREQO, busACKI, busACKO,
           busADDRI, busADDRO, busDATAI, busDATAO);

   input         clk;           // Clock
   input         clken;         // Clock enable
   input  [0: 2] curINTR_NUM;   // Current Interrupt Priority
   output [1: 7] ubaINTR;       // Unibus Interrupt Request
   input         busREQI;       // Unibus Request In
   output        busREQO;       // Unibus Request Out
   input         busACKI;       // Unibus Acknowledge In
   output        busACKO;       // Unibus Acknowledge Out
   input  [0:35] busADDRI;      // Bus Address In
   output [0:35] busADDRO;      // Bus Address Out
   input  [0:35] busDATAI;      // Unibus Data In
   output [0:35] busDATAO;      // Unibus Data Out

   assign busREQO  = 1'b0;
   assign busACKO  = 1'b0;
   assign busADDRO = 36'bx;
   assign busDATAO = 36'bx;
   assign ubaINTR  = 7'b0;

   //
   // Unibus Status Register (IO Address 763100)
   //  See Page 5-108
   //
   //
   //           0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17
   //         +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //   (LH)  |                                                     |                                                     |
   //         +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //
   //          18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
   //         +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //   (RH)  |TO|BM|PE|ND|     |HI|LO|PF|  |DT|IN| HI PIA | LO PIA |
   //         +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //
   //
   //  TO  : Time Out              - Indicates NXM timeout.
   //                                Cleared by writing a one.
   //  BM  : Bad Memory Data       - Always read as zero.
   //                                Writes are ignored.
   //  PE  : Bus Parity Error      - Always read as zero.
   //                                Writes are ignored.
   //  ND  : Non-existant Device   - TBD
   //  HI  : Hi level intr pending -
   //  LO  : Lo level intr pending -
   //  PF  : Power Fail            -
   //  DT  : Diable Transfer       -
   //  IN  : Initialize            -
   //  HIP : Hi level PIA          -
   //  LOP : Lo level PAI          -
   //

   //
   // Unibus Maintenance Register (IO Address 763101)
   //  See Page 5-111
   //
   //
   //           0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17
   //         +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //   (LH)  |                                                     |
   //         +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //
   //          18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
   //         +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //   (RH)  |                                                  |CR|
   //         +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //
   //
   //  CR  : Change Register       - Modifies a 4x4 memory address




endmodule
