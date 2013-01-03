////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Console (CSL) Flag Definitions
//
// Details
//   Contains definitions that are useful to access CSL Flags
//
// File
//   csl.vh
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

`ifndef __CSL_VH
`define __CSL_VH

//
//
// CSL Flags
//

`define cslSTEP(reg) 	(reg[0])	// Single Step
`define cslRUN(reg)     (reg[1])	// Run
`define cslEXEC(reg)    (reg[2])	// Execute
`define cslCONT(reg)    (reg[3])	// Continue
`define cslHALT(reg)    (reg[4])	// Halt
`define cslTIMEREN(reg) (reg[5])	// Timer Enable
`define cslTRAPEN(reg)  (reg[6])	// Trap Enable
`define cslCACHEEN(reg) (reg[7])	// Cache Enable

`endif