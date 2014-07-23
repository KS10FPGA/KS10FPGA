////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DZ11 definitions
//
// Details
//   This file contains DZ11 configuration parameters
//
// File
//   dz11.vh
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2012-2014 Rob Doyle
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

`ifndef __DZ11_VH
`define __DZ11_VH

`include "../uba.vh"

//
// DZ Device 1 Parameters
//

`define dz1DEV    (`devUBA3)            // Device 3
`define dz1INTR   (`ubaINTR5)           // Interrupt 5
`define dz1VECT   (36'o000000_000340)   // Interrupt Vector
`define dz1ADDR   (18'o760010)          // Base Address

//
// DZ Device 2 Parameters
//

`define dz2DEV    (`devUBA3)            // Device 3
`define dz2INTR   (`ubaINTR5)           // Interrupt 5
`define dz2VECT   (36'o000000_000350)   // Interrupt Vector
`define dz2ADDR   (18'o760020)          // Base Address

//
// DZ Device 3 parameters
//

`define dz3DEV    (`devUBA3)            // Device 3
`define dz3INTR   (`ubaINTR5)           // Interrupt 5
`define dz3VECT   (36'o000000_000360)   // Interrupt Vector
`define dz3ADDR   (18'o760030)          // Base Address

//
// DZ Device 4 parameters
//

`define dz4DEV    (`devUBA3)            // Device 3
`define dz4INTR   (`ubaINTR5)           // Interrupt 5
`define dz4VECT   (36'o000000_000370)   // Interrupt Vector
`define dz4ADDR   (18'o760040)          // Base Address

//
// DZ Register Address offsets
//

`define csrOFFSET (3'd0)                // CSR Offset  (RW)
`define rbfOFFSET (3'd2)                // RBUF Offset (RO)
`define lprOFFSET (3'd2)                // LPR Offset  (WO)
`define tcrOFFSET (3'd4)                // TCR Offset  (RW)
`define msrOFFSET (3'd6)                // MSR Offset  (RO)
`define tdrOFFSET (3'd6)                // TDR Offset  (WO)

`endif
