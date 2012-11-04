////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      KS-10 Console
//!
//! \details
//!
//! \todo
//!
//! \file
//!      ir.v
//!
//! \author
//!      Rob Doyle - doyle (at) cox (dot) net
//!
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
// Comments are formatted for doxygen
//

module CONS(clk, rst, pwr_fail,

            bus_request,
            bus_grant,

            bus_uba_busy,
            bus_addr_cycle_in,  bus_addr_cycle_out,
            bus_data_cycle_in,  bus_data_cycle_out,
            bus_io_cycle_in,    bus_io_cycle_out,
            bus_mem_busy_in,    bus_mem_busy_out,
            bus_pi_lvl,         bus_pi_current,
            bus_data_in,        bus_data_out,
            rxd, txd
            );

   input         clk;        		// Clock
   input         rst;          		// Reset
   input         pwr_fail;		//

   output        bus_request;		//
   input         bus_grant;		//
   
   input         bus_uba_busy;		// Unibus Busy
   input         bus_addr_cycle_in;	//
   output        bus_addr_cycle_out;	//
   input         bus_data_cycle_in;	//
   output        bus_data_cycle_out;	//
   input         bus_io_cycle_in;	//
   output        bus_io_cycle_out;	//
   input         bus_mem_busy_in;	//
   output        bus_mem_busy_out;	// Never Asserted

   input  [1: 7] bus_pi_lvl;		//
   input  [0: 2] bus_pi_current;	//
   
   input  [0:35] bus_data_in;		//
   output [0:35] bus_data_out;		//
   input         rxd;
   output        txd;
   
   assign bus_mem_busy_out = 1'b0;
   
   
endmodule
