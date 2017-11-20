////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   LP20 definitions
//
// Details
//   This file contains LP20 configuration parameters
//
// File
//   lp20.vh
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2017 Rob Doyle
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

`ifndef __LP20_VH
`define __LP20_VH

`include "../uba/uba.vh"

//
// LP20 Device 1 Parameters
//

`define lp1DEV     (`devUBA3)           // Device 3
`define lp1INTR    (`ubaINTR4)          // Interrupt 4
`define lp1VECT    (36'o000000_000754)  // Interrupt Vector
`define lp1ADDR    (18'o775400)         // Base Address

//
// LP20 Device 2 Parameters
//

`define lp2DEV     (`devUBA3)           // Device 3
`define lp2INTR    (`ubaINTR4)          // Interrupt 4
`define lp2VECT    (36'o000000_000750)  // Interrupt Vector
`define lp2ADDR    (18'o775420)         // Base Address

//
// LP20 Register Address offsets
//

`define csraOFFSET (4'o00)              // CSRA Offset (RW)
`define csrbOFFSET (4'o02)              // CSRB Offset (RW)
`define barOFFSET  (4'o04)              // BAR  Offset (RW)
`define bctrOFFSET (4'o06)              // BCTR Offset (RW)
`define pctrOFFSET (4'o10)              // PCTR Offset (RW)
`define ramdOFFSET (4'o12)              // RAMD Offset (RW)
`define cctrOFFSET (4'o14)              // CCTR Offset (RW)
`define cbufOFFSET (4'o14)              // CBUF Offset (RW)
`define cksmOFFSET (4'o16)              // CKSM Offset (RW)
`define pdatOFFSET (4'o16)              // PDAT Offset (RW)

`endif
