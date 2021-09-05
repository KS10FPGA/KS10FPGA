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

`define rp04LAST_SECT18 6'd19           // Sector[0:19] (18-bit mode)
`define rp04LAST_SECT16 6'd21           // Sector[0:21] (16-bit mode)
`define rp04LAST_TRACK  6'd18           // Track[0:18]
`define rp04LAST_CYL    10'd410         // Cylinder[0:410]

//
// RP05 Disk Parameters
//

`define rp05LAST_SECT18 6'd19           // Sector[0:19] (18-bit mode)
`define rp05LAST_SECT16 6'd21           // Sector[0:21] (16-bit mode)
`define rp05LAST_TRACK  6'd18           // Track[0:18]
`define rp05LAST_CYL    10'd410         // Cylinder[0:410]

//
// RP06 Disk Parameters
//

`define rp06LAST_SECT18 6'd19           // Sector[0:19] (18-bit mode)
`define rp06LAST_SECT16 6'd21           // Sector[0:21] (16-bit mode)
`define rp06LAST_TRACK  6'd18           // Track[0:18]
`define rp06LAST_CYL    10'd814         // Cylinder[0:814]

//
// RP07 Disk Parameters
//

`define rp07LAST_SECT18 6'd42           // Sector[0:42] (18-bit mode)
`define rp07LAST_SECT16 6'd49           // Sector[0:49] (16-bit mode)
`define rp07LAST_TRACK  6'd31           // Track[0:31]
`define rp07LAST_CYL    10'd629         // Cylinder[0:629]

//
// RM03 Disk Parameters
//

`define rm03LAST_SECT18 6'd29           // Sector[0:29] (18-bit mode)
`define rm03LAST_SECT16 6'd31           // Sector[0:31] (16-bit mode)
`define rm03LAST_TRACK  6'd4            // Track[0:4]
`define rm03LAST_CYL    10'd822         // Cylinder[0:822]

//
// RM05 Disk Parameters
//

`define rm05LAST_SECT18 6'd29           // Sector[0:29] (18-bit mode)
`define rm05LAST_SECT16 6'd31           // Sector[0:29] (16-bit mode)
`define rm05LAST_TRACK  6'd18           // Track[0:18]
`define rm05LAST_CYL    10'd822         // Cylinder[0:822]

//
// RM80 Disk Parameters
//

`define rm80LAST_SECT18 6'd29           // Sector[0:29] (18-bit mode)
`define rm80LAST_SECT16 6'd31           // Sector[0:29] (16-bit mode)
`define rm80LAST_TRACK  6'd13           // Track[0:13]
`define rm80LAST_CYL    10'd558         // Cylinder[0:558]

//
// getLAST_SECT18(type)
//

`define getLAST_SECT18(type) (((type) == `rpRP04) ? `rp04LAST_SECT18 : \
                              (((type) == `rpRP05) ? `rp05LAST_SECT18 : \
                               (((type) == `rpRP06) ? `rp06LAST_SECT18 : \
                                (((type) == `rpRP07) ? `rp07LAST_SECT18 : \
                                 (((type) == `rpRM03) ? `rm03LAST_SECT18 : \
                                  (((type) == `rpRM05) ? `rm05LAST_SECT18 : \
                                   (((type) == `rpRM80) ? `rm80LAST_SECT18 : \
                                    `rp06LAST_SECT18)))))))

//
// getLAST_SECT16(type)
//

`define getLAST_SECT16(type) (((type) == `rpRP04) ? `rp04LAST_SECT16 : \
                              (((type) == `rpRP05) ? `rp05LAST_SECT16 : \
                               (((type) == `rpRP06) ? `rp06LAST_SECT16 : \
                                (((type) == `rpRP07) ? `rp07LAST_SECT16 : \
                                 (((type) == `rpRM03) ? `rm03LAST_SECT16 : \
                                  (((type) == `rpRM05) ? `rm05LAST_SECT16 : \
                                   (((type) == `rpRM80) ? `rm80LAST_SECT16 : \
                                    `rp06LAST_SECT16)))))))

//
// getLAST_TRACK(type)
//

`define getLAST_TRACK(type) (((type) == `rpRP04) ? `rp04LAST_TRACK : \
                             (((type) == `rpRP05) ? `rp05LAST_TRACK : \
                              (((type) == `rpRP06) ? `rp06LAST_TRACK : \
                               (((type) == `rpRP07) ? `rp07LAST_TRACK : \
                                (((type) == `rpRM03) ? `rm03LAST_TRACK : \
                                 (((type) == `rpRM05) ? `rm05LAST_TRACK : \
                                  (((type) == `rpRM80) ? `rm80LAST_TRACK : \
                                   `rp06LAST_TRACK)))))))

//
// getLAST_CYL(type)
//

`define getLAST_CYL(type) (((type) == `rpRP04) ? `rp04LAST_CYL : \
                           (((type) == `rpRP05) ? `rp05LAST_CYL : \
                            (((type) == `rpRP06) ? `rp06LAST_CYL : \
                             (((type) == `rpRP07) ? `rp07LAST_CYL : \
                              (((type) == `rpRM03) ? `rm03LAST_CYL : \
                               (((type) == `rpRM05) ? `rm05LAST_CYL : \
                                (((type) == `rpRM80) ? `rm80LAST_CYL : \
                                 `rp06LAST_CYL)))))))

//
// getTYPE(unit)
//

`define getTYPE(unit) (((unit) == 0) ? `rpRP06 : \
                       (((unit) == 1) ? `rpRP06 : \
                        (((unit) == 2) ? `rpRP06 : \
                         (((unit) == 3) ? `rpRP06 : \
                          (((unit) == 4) ? `rpRP06 : \
                           (((unit) == 5) ? `rpRP06 : \
                            (((unit) == 6) ? `rpRP06 : \
                             `rpRM03)))))))

`endif
