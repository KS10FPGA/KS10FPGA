////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RPMR Register Definitions
//
// File
//   rpmr.vh
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2015 Rob Doyle
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

`ifndef __RPMR_VH
`define __RPMR_VH

//
// RPMR Register Bits
//

`define rpMR_DDAT(bus)  (bus[4])        // Diagnostic data
`define rpMR_DSCK(bus)  (bus[3])        // Diagnostic sector clock
`define rpMR_DIND(bus)  (bus[2])        // Diagnostic index pulse
`define rpMR_DCLK(bus)  (bus[1])        // Diagnostic clock
`define rpMR_DMD(bus)   (bus[0])        // Diagnostic mode

`endif
