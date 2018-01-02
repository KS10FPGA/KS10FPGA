////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DUP11 definitions
//
// Details
//   This file contains DUP11 configuration parameters
//
// File
//   dup11.vh
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2018 Rob Doyle
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

`ifndef __DUP11_VH
`define __DUP11_VH

`include "../uba/uba.vh"

//
// DUP11 Device 1 Parameters
//

`define dup1DEV    (`devUBA3)           // Device 3
`define dup1INTR   (`ubaINTR5)          // Interrupt 5
`define dup1VECT   (36'o000000_000570)  // Interrupt Vector
`define dup1ADDR   (18'o760300)         // Base Address

//
// DUP11 Device 2 Parameters
//

`define dup2DEV    (`devUBA3)           // Device 3
`define dup2INTR   (`ubaINTR5)          // Interrupt 5
`define dup2VECT   (36'o000000_000600)  // Interrupt Vector
`define dup2ADDR   (18'o760310)         // Base Address

//
// DUP11 Register Address offsets
//

`define rxcsrOFFSET  (3'o0)             // RXCSR  Offset (RW)
`define rxdbufOFFSET (3'o2)             // RXDBUF Offset (R )
`define parcsrOFFSET (3'o2)             // PARCSR Offset ( W)
`define txcsrOFFSET  (3'o4)             // TXCSR  Offset (RW)
`define txdbufOFFSET (3'o6)             // TXDBUF Offset (RW)

`endif
