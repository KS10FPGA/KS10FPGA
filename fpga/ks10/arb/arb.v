////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      KS10 Bus Arbiter
//!
//! \details
//!      This device is the KS10 Bus Arbiter.
//!
//! \todo
//!
//! \file
//!      arb.v
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

module ARB(clk, rst, pwr_fail,

           con_request,   
           con_grant,
           con_addr_cycle, 
           con_data_cycle, 
           con_io_cycle,
           con_pi_request,
           con_data,
           
           cpu_request,
           cpu_grant,
           cpu_addr_cycle, 
           cpu_data_cycle, 
           cpu_io_cycle,
           cpu_pi_request,
           cpu_data,

           uba_request,
           uba_grant,
           uba_addr_cycle, 
           uba_data_cycle, 
           uba_io_cycle,   
           uba_data,

           mem_addr_cycle,
           mem_data_cycle,
           mem_io_cycle,
           mem_data,
           
           arb_addr_cycle,
           arb_data_cycle,
           arb_io_cycle,
           arb_mem_busy,
           arb_uba_busy,
           arb_data);

   input         clk;        		// Clock
   input         rst;          		// Reset
   input         pwr_fail;		//

   input         con_request;
   output reg    con_grant;
   input         con_addr_cycle; 
   input         con_data_cycle; 
   input         con_io_cycle;
   input [1: 7]  con_pi_request;
   input [0:35]  con_data;
   
   input         cpu_request;
   output reg    cpu_grant;
   input         cpu_addr_cycle;
   input         cpu_data_cycle;
   input         cpu_io_cycle;
   input [1: 7]  cpu_pi_request;
   input [0:35]  cpu_data;
   
   input         uba_request;
   output reg    uba_grant;
   input         uba_addr_cycle; 
   input         uba_data_cycle;
   input         uba_io_cycle;
   input [0:35]  uba_data;

   input         mem_addr_cycle;
   input         mem_data_cycle;
   input         mem_io_cycle;
   input [0:35]  mem_data;
  
   output reg    arb_addr_cycle;	//
   output reg    arb_data_cycle;	//
   output reg    arb_io_cycle;		//
   output        arb_mem_busy;		//
   output        arb_uba_busy;		//
   output reg [0:35] arb_data;		//

   wire          request = (con_request | cpu_request | uba_request);

   //
   //
   //

   reg           grant;
   
   always @(posedge clk or posedge rst)
     begin
        
        if (rst)
          begin
          end
        else 
          begin
          end
    end
  
   //
   //
   //
   
   always @(grant or con_request or uba_request or cpu_request)
     begin
        con_grant = 1'b0;
        uba_grant = 1'b0;
        cpu_grant = 1'b0;
        if (grant)
          begin
             if (con_request)
               begin
                  con_grant      = 1'b1;
                  arb_addr_cycle = con_addr_cycle;
                  arb_data_cycle = con_addr_cycle;
                  arb_io_cycle   = con_io_cycle;
                  arb_data       = con_data;
               end
              else if (uba_request)
               begin
                  uba_grant      = 1'b1;
                  arb_addr_cycle = uba_addr_cycle;
                  arb_data_cycle = uba_addr_cycle;
                  arb_io_cycle   = uba_io_cycle;
                  arb_data       = uba_data;
               end
             else if (cpu_request)
               begin
                  cpu_grant      = 1'b1;
                  arb_addr_cycle = cpu_addr_cycle;
                  arb_data_cycle = cpu_addr_cycle;
                  arb_io_cycle   = cpu_io_cycle;
                  arb_data       = cpu_data;
               end
          end
     end

   //assign arb_mem_busy = mem_busy;
   //assign arb_uba_busy = uba_busy;
   
endmodule
