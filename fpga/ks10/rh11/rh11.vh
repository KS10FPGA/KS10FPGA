////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RH11 definitions
//
// Details
//   This file contains RH11 configuration parameters
//
// File
//   rh11.vh
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2021 Rob Doyle
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

`ifndef __RH11_VH
`define __RH11_VH

`include "../uba/uba.vh"

//
// RH Device 1 (RPxx) Parameters
//

`define rh1DEV    (`devUBA1)            // Device 1
`define rh1INTR   (`ubaINTR6)           // Interrupt 6
`define rh1VECT   (18'o000254)          // Interrupt Vector
`define rh1ADDR   (18'o776700)          // Base Address

//
// RH Device 3 (TU45) Parameters
//

`define rh3DEV    (`devUBA3)            // Device 3
`define rh3INTR   (`ubaINTR6)           // Interrupt 6
`define rh3VECT   (18'o00224)           // Interrupt Vector
`define rh3ADDR   (18'o772440)          // Base Address

`endif
