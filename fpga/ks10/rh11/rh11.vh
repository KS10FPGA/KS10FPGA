////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RH11 definitions
//
// Details
//
// Todo
//
// File
//   rh11.vh
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

//
// RH Device and Interrupt
//

`define rhDEV     4'd1           	// Device 1
`define rhINTR    4'b0100        	// Interrupt 6

//
// RH Register Address offsets
//

`define cs1OFFSET 6'o00	    		// CS1 Offset
`define wcOFFSET  6'o02       		// WC  Offset
`define baOFFSET  6'o04       		// BA  Offset
`define daOFFSET  6'o06       		// DA  Offset

`define cs2OFFSET 6'o10       		// CS2 Offset
`define dsOFFSET  6'o12       		// DS  Offset
`define er1OFFSET 6'o14       		// ER1 Offset
`define asOFFSET  6'o16       		// AS  Offset

`define laOFFSET  6'o20       		// LA  Offset
`define dbOFFSET  6'o22       		// DB  Offset
`define mrOFFSET  6'o24       		// MR  Offset
`define dtOFFSET  6'o26       		// DT  Offset

`define snOFFSET  6'o30       		// SN  Offset
`define ofOFFSET  6'o32       		// OF  Offset
`define dcOFFSET  6'o34       		// DC  rOffset
`define ccOFFSET  6'o36       		// HR  Offset

`define er2OFFSET 6'o40       		// ER2 Offset
`define er3OFFSET 6'o42       		// ER2 Offset
`define ec1OFFSET 6'o44       		// EC1 Offset
`define ec2OFFSET 6'o46       		// EC2 Offset

`define undOFFSET 6'o50			// Undefined

//
// RH #1 parameters
//

`define rh1VECT   18'o000254     	// Interrupt Vector
`define rh1ADDR   18'o776700     	// Base Address
