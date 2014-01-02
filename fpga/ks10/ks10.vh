////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// brief
//      KS10 definitions
//
// details
//
// todo
//
// file
//      ks10.vh
//
// author
//      Rob Doyle - doyle (at) cox (dot) net
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

`ifndef __KS10_VH
`define __KS10_VH

//
// Firmware Version
//

`define MAJOR_VER "00"			// Two ASCII characters
`define MINOR_VER "05"			// Two ASCII characters

//
// CPU Clock Frequency
//

`define CLKFRQ    20000000              // Clock Speed

//
// Device Number Definitions
//  The KS10 supports 16 external devices.  Only the first 5 are meaningful.
//

`define ctlNUM0 (4'd0)                  // Memory Controller and Console
`define ctlNUM1 (4'd1)                  // IO Bridge Controller #1
`define ctlNUM2 (4'd2)                  // IO Bridge Controller #2 (not implemented)
`define ctlNUM3 (4'd3)                  // IO Bridge Controller #3
`define ctlNUM4 (4'd4)                  // IO Bridge Controller #4 (not implemented)

//
// Who Are You (WRU) Responses
//  The KS10 microcode will actually handle 18 devices.  It checks for the
//  'right half' to be non-zero.
//

`define wruNUM0 36'o000000_400000       // Memory Controller and Console.  Never generates interrupts.
`define wruNUM1 36'o000000_200000       // IO Bridge Controller #1 WRU Response
`define wruNUM2 36'o000000_100000       // IO Bridge Controller #2 WRU Response
`define wruNUM3 36'o000000_040000       // IO Bridge Controller #3 WRU Response
`define wruNUM4 36'o000000_020000       // IO Bridge Controller #4 WRU Response

`endif
