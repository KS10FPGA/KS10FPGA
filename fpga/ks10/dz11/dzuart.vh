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
//   dzuart.vh
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
////////////////////////////////////////////////////////////////////////////////

`ifndef __DZUART_VH
`define __DZUART_VH

`define CLKDIV  16

//
// Baudrate selection
//

`define UARTBR_50     (4'd0)
`define UARTBR_75     (4'd1)
`define UARTBR_110    (4'd2)
`define UARTBR_134    (4'd3)
`define UARTBR_150    (4'd4)
`define UARTBR_300    (4'd5)
`define UARTBR_600    (4'd6)
`define UARTBR_1200   (4'd7)
`define UARTBR_1800   (4'd8)
`define UARTBR_2000   (4'd9)
`define UARTBR_2400   (4'd10)
`define UARTBR_3600   (4'd11)
`define UARTBR_4800   (4'd12)
`define UARTBR_7200   (4'd13)
`define UARTBR_9600   (4'd14)
`define UARTBR_115200 (4'd15)

//
// Character Size
//

`define UARTLEN_5     (2'b00)
`define UARTLEN_6     (2'b01)
`define UARTLEN_7     (2'b10)
`define UARTLEN_8     (2'b11)

//
// Parity
//

`define UARTPAR_NONE  (2'b00)
`define UARTPAR_ODD   (2'b01)
`define UARTPAR_EVEN  (2'b11)

//
// Stop bits
//

`define UARTSTOP_1    (1'b0)
`define UARTSTOP_2    (1'b1)

`endif
