////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RPxx definitions
//
// Details
//   This file provides definitions for the various types of disks.
//
// File
//   rpxx.vh
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
`define rpRP05 16'o020021
`define rpRP06 16'o020022
`define rpRM03 16'o020024
`define rpRM80 16'o020026
`define rpRM05 16'o020027
`define rpRP07 16'o020042

//
// RP04 Disk Parameters
//

`define rp04LASTSECT    6'd19           // 20 sectors per track numbered 0 to 19
`define rp04LASTSURF    5'd18           // 19 tracks per cylinder numbered 0 to 18
`define rp04LASTCYL     10'd410         // 411 Cylinders

//
// RP05 Disk Parameters
//

`define rp05LASTSECT    6'd19           // 20 sectors per track numbered 0 to 19
`define rp05LASTSURF    5'd18           // 19 tracks per cylinder numbered 0 to 18
`define rp05LASTCYL     10'd410         // 411 Cylinders

//
// RP06 Disk Parameters
//

`define rp06LASTSECT    6'd19           // 20 sectors per track numbered 0 to 19
`define rp06LASTSURF    5'd18           // 19 tracks per cylinder numbered 0 to 18
`define rp06LASTCYL     10'd814         // 815 Cylinders

//
// RP07 Disk Parameters
//

`define rp07LASTSECT    6'd42           // 43 sectors per track numbered 0 to 42
`define rp07LASTSURF    5'd31           // 31 tracks per cylinder numbered 0 to 18
`define rp07LASTCYL     10'd629         // 630 Cylinders

//
// RM03 Disk Parameters
//

`define rm03LASTSECT    6'd29           // 30 sectors per track numbered 0 to 29
`define rm03LASTSURF    5'd4            // 5 tracks per cylinder numbered 0 to 4
`define rm03LASTCYL     10'd822         // 823 Cylinders

//
// RM05 Disk Parameters
//

`define rm05LASTSECT    6'd29           // 30 sectors per track numbered 0 to 29
`define rm05LASTSURF    5'd18           // 19 tracks per cylinder numbered 0 to 18
`define rm05LASTCYL     10'd822         // 823 Cylinders

//
// RM80 Disk Parameters
//

`define rm80LASTSECT    6'd29           // 30 sectors per track numbered 0 to 29
`define rm80LASTSURF    5'd13           // 14 tracks per cylinder numbered 0 to 13
`define rm80LASTCYL     10'd558         // 559 Cylinders

//
// getLASTSECT(type)
//

`define getLASTSECT(type) (((type) == `rpRP04) ? `rp04LASTSECT : \
                           (((type) == `rpRP05) ? `rp05LASTSECT : \
                            (((type) == `rpRP06) ? `rp06LASTSECT : \
                             (((type) == `rpRP07) ? `rp07LASTSECT : \
                              (((type) == `rpRM03) ? `rm03LASTSECT : \
                               (((type) == `rpRM05) ? `rm05LASTSECT : \
                                (((type) == `rpRM80) ? `rm80LASTSECT : \
                                 `rp06LASTSECT)))))))
//
// getLASTSURF(type)
//

`define getLASTSURF(type) (((type) == `rpRP04) ? `rp04LASTSURF : \
                           (((type) == `rpRP05) ? `rp05LASTSURF : \
                            (((type) == `rpRP06) ? `rp06LASTSURF : \
                             (((type) == `rpRP07) ? `rp07LASTSURF : \
                              (((type) == `rpRM03) ? `rm03LASTSURF : \
                               (((type) == `rpRM05) ? `rm05LASTSURF : \
                                (((type) == `rpRM80) ? `rm80LASTSURF : \
                                 `rp06LASTSURF)))))))

//
// getLASTCYL(type)
//

`define getLASTCYL(type) (((type) == `rpRP04) ? `rp04LASTCYL : \
                          (((type) == `rpRP05) ? `rp05LASTCYL : \
                           (((type) == `rpRP06) ? `rp06LASTCYL : \
                            (((type) == `rpRP07) ? `rp07LASTCYL : \
                             (((type) == `rpRM03) ? `rm03LASTCYL : \
                              (((type) == `rpRM05) ? `rm05LASTCYL : \
                               (((type) == `rpRM80) ? `rm80LASTCYL : \
                                `rp06LASTCYL)))))))

`endif
