////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   LP20 Checksum Register (CKSM) definitions.
//
// Details
//   This file contains the bit definitions for the LP20 CKSM register.
//
// File
//   lppctr.vh
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2017 Rob Doyle
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

`ifndef __LPCKSM_VH
`define __LPCKSM_VH

//
// lpCKSM Register Bits
//

`define lpCKSM_DAT(bus) (bus[15:8])     // Checksum

`endif
