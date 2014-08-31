////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DZ11 UART Baud Rate Generator
//
// Details
//   This file contains the definitions that are required to use the UART_BRG
//   module.
//
// File
//   uart_brg.vh
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012 Rob Doyle
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

`ifndef __UART_BRG_VH
`define __UART_BRG_VH

`define CLKDIV  16

`define BR1200   3'd0
`define BR2400   3'd1
`define BR4800   3'd2
`define BR9600   3'd3
`define BR19200  3'd4
`define BR38400  3'd5
`define BR57600  3'd6
`define BR115200 3'd7

`endif
