////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RPxx definitions
//
// Details
//
// Todo
//
// File
//   rpxx.vh
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
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

`ifndef __RPXX_VH
`define __RPXX_VH

//
// RP Serial Numbers
//

`define rpSN0 16'o000021
`define rpSN1 16'o000022
`define rpSN2 16'o000023
`define rpSN3 16'o000024
`define rpSN4 16'o000025
`define rpSN5 16'o000026
`define rpSN6 16'o000027
`define rpSN7 16'o000030

//
// RP/RM Drive Types
//

`define rpRP04 16'o020020
`define rpRP05 16'o020021		// Single Port RP05
`define rpRP06 16'o020022		// Single Port RP06
`define rpRM03 16'o020024
`define rpRM80 16'o020026
`define rpRM05 16'o020027
`define rpRM07 16'o020042

//
// RP/RM Functions
//
// Note
//  The function code numbering in the book is a little strange -
//  It includes the GO bit, apparently.  The LSB is always set.
//

`define funNOP     6'o00        // 01
`define funUNLOAD  6'o01        // 03
`define funSEEK    6'o02        // 05
`define funRECAL   6'o03        // 07
`define funCLEAR   6'o04        // 11
`define funRELEASE 6'o05        // 13
`define funOFFSET  6'o06        // 15
`define funRETURN  6'o07        // 17
`define funPRESET  6'o10        // 21
`define funPAKACK  6'o11        // 23
`define funSEARCH  6'o14        // 31
`define funWRCHK   6'o24        // 51
`define funWRCHKH  6'o25        // 53
`define funWRITE   6'o30        // 61
`define funWRITEH  6'o31        // 63
`define funREAD    6'o34        // 71
`define funREADH   6'o35        // 73

//
// rp06 Disk Parametes
//

`define rp06LASTSECT    5'd19           // 20 sectors per track numbered 0 to 19
`define rp06LASTSURF    5'd18           // 19 tracks per cylinder numbered 0 to 18
`define rp06LASTCYL     10'd814         // 815 Cylinders

`endif