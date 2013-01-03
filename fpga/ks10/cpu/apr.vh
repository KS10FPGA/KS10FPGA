////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Arithmetic Processor (APR) Flags Definitions
//
// Details
//   Contains definitions that are useful to access APR Flags
//
// File
//   apr.vh
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
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

`ifndef __APR_VH
`define __APR_VH

//
// APR Flags
//

`define flagTRAPEN(reg)  (reg[22])      // Traps are enabled
`define flagPAGEEN(reg)  (reg[23])      // Paging is enabled
`define flag24(reg)      (reg[24])      // Flag 24
`define flagCSL(reg)     (reg[25])      // KS10 Interrupt to Console
`define flagPWR(reg)     (reg[26])      // Power fail
`define flagNXM(reg)     (reg[27])      // Non existent memory
`define flagBADDATA(reg) (reg[28])      // Bad memory data (not implemented)
`define flagCORDATA(reg) (reg[29])      // Corrected memory data (not implemented)
`define flag30(reg)      (reg[30])      // Flag 30
`define flag31(reg)      (reg[31])      // Console Interrupt to KS10
`define flagINTREQ(reg)  (reg[32])      // Interrupt Request

`endif
