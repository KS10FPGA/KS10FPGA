////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Secure Digital Card (SD) SPI Inteface Definitions
//
// File
//   sdspi.vh
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

`ifndef __SDSPI_VH
`define __SDSPI_VH

//
// SD SPI Operations
//

`define spiNOP    3'd0
`define spiCSL    3'd1
`define spiCSH    3'd2
`define spiFAST   3'd3
`define spiSLOW   3'd4
`define spiTR     3'd5

`endif
