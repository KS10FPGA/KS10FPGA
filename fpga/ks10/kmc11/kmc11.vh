////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KMC11 definitions
//
// Details
//   This file contains KMC11 configuration parameters
//
// File
//   kmc11.vh
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2021 Rob Doyle
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

`ifndef __KMC11_VH
`define __KMC11_VH

`include "../uba/uba.vh"

//
// KMC11 Parameters
//

`define kmcDEV    (`devUBA3)            // Device 3
`define kmcINTR   (`ubaINTR5)           // Interrupt 5
`define kmcVECT   (18'o000540)          // Interrupt Vector
`define kmcADDR   (18'o760540)          // Base Address

//
// Control/Status Register Addresses
//
// SEL0: CSR0, CSR1
// SEL2: CSR2, CSR3
// SEL4: CSR4, CSR5
// SEL6: CSR6, CSR7
//
// Shadow Register Addresses
//
// SEL1: Maintenance Register
// SEL4: Maintenance Address Register
// SEL6: Maintenance Data Register
//

//
// KMC11 Register Address offsets
//

`define sel0OFFSET (4'o00)              // SEL0 Offset (RW)
`define sel2OFFSET (4'o02)              // SEL2 Offset (RW)
`define sel4OFFSET (4'o04)              // SEL4 Offset (RW)
`define sel6OFFSET (4'o06)              // SEL6 Offset (RW)

`endif
