////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KS10 IO Bus Bridge definitions
//
// Details
//   This file contains definitions for the KS10 IO Bus Bridge devices.
//
// File
//   uba.vh
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2016 Rob Doyle
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

`ifndef __UBA_VH
`define __UBA_VH

//
// UBA Register Addressing
//

`define ubaADDR         (18'o763000)            // UBA Base Address
`define pageOFFSET      (9'o000)                // Paging RAM Offset
`define statOFFSET      (9'o100)                // Status Register Offset
`define maintOFFSET     (9'o101)                // Maintenance Register Offset

//
// UBA Device Definitions
//  The KS10 architecture supports 16 device numbers.
//  Only 5 devices are implemented.
//

`define devUBA0         (4'd0)                  // UBA 0: KS10 Memory controller and console
`define devUBA1         (4'd1)                  // UBA 1: RPXX controller
`define devUBA2         (4'd2)                  // UBA 2: Not implemented on KS10
`define devUBA3         (4'd3)                  // UBA 3: DZ11 controller
`define devUBA4         (4'd4)                  // UBA 4: Non-standard on KS10

//
// UBA Who Are You (WRU) Responses
//  The KS10 microcode will actually handle 18 devices.
//  It checks for the 'right half' to be non-zero.
//

`define wruUBA0         (36'o000000_400000)     // Memory and Console. Never generates interrupts.
`define wruUBA1         (36'o000000_200000)     // UBA 1 WRU Response
`define wruUBA2         (36'o000000_100000)     // UBA 2 WRU Response
`define wruUBA3         (36'o000000_040000)     // UBA 3 WRU Response
`define wruUBA4         (36'o000000_020000)     // UBA 4 WRU Response
`define wruNULL         (36'o000000_000000)     // Invalid WRU Response

//
// UBA Interrupts
//

`define ubaINTR4        (4'b0001)               // Interrupt 4
`define ubaINTR5        (4'b0010)               // Interrupt 5
`define ubaINTR6        (4'b0100)               // Interrupt 6
`define ubaINTR7        (4'b1000)               // Interrupt 7
`define ubaINTNUL       (4'b0000)               // No interrupt

//
// Lookup WRU response from ubaNUM
//

`define getWRU(ubaNUM) (((ubaNUM) == `devUBA0) ? `wruUBA0 : \
                        (((ubaNUM) == `devUBA1) ? `wruUBA1 : \
                         (((ubaNUM) == `devUBA2) ? `wruUBA2 : \
                          (((ubaNUM) == `devUBA3) ? `wruUBA3 : \
                           (((ubaNUM) == `devUBA4) ? `wruUBA4 : \
                            `wruNULL)))))

`endif
