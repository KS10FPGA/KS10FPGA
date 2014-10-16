////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Pager Flags Definitions
//
// Details
//   Contains definitions that are useful to access Page Flags
//
// File
//   pager.vh
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
////////////////////////////////////////////////////////////////////

`ifndef __PAGER_VH
`define __PAGER_VH

//
// Page Flags
//

`define pageVALID(reg)      (reg[0])    // Page is valid
`define pageWRITEABLE(reg)  (reg[1])    // Page is writeable
`define pageCACHEABLE(reg)  (reg[2])    // Page is cacheable
`define pageUSER(reg)       (reg[3])    // Page is user mode

`endif
