////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Previous Context (PXCT) Block Definitions
//
// Details
//   Contains definitions that are useful to access APR Flags
//
// File
//   pxct.vh
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2015 Rob Doyle
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

`ifndef __PXCT_VH
`define __PXCT_VH

//
// PXCT Blocks
//

`define currBLOCK(reg)  (reg[0:2])      //  Current AC Block
`define prevBLOCK(reg)  (reg[3:5])      //  Previous AC Block

`endif
