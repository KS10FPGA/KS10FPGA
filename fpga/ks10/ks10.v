////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      KS10 System.   The system consists of a CPU, a Bus Aribter,
//!      Memory, and a Unibus Interface.
//!
//! \details
//!
//! \todo
//!
//! \file
//!      ks10.v
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

module KS10(clk, reset, pwr_fail, conRXD, conTXD);
  
   // System Interfaces
   input  clk;          // Clock
   input  pwr_fail;     // Power Fail
   
   // Console Outputs
   
   input  conRXD;      // Console RXD
   output conTXD;      // Console TXD

   //
   // Console Outputs
   //

   wire con_request;
   wire con_grant;
   wire con_addr_cycle;
   wire con_data_cycle;
   wire con_io_cycle;
   wire con_mem_busy;
   wire [0:35] con_data;

   //
   // Arbiter Outputs
   //

   wire arb_request;
   wire arb_grant;
   wire arb_uba_busy;
   wire arb_mem_busy;
   wire arb_addr_cycle;
   wire arb_data_cycle;
   wire arb_io_cycle;
   wire [0:35] arb_data;
   
   //
   // Memory Interfaces
   //

   wire mem_busy;
   wire mem_addr_cycle;
   wire mem_data_cycle;
   wire mem_io_cycle;
   wire [0:35] mem_data;
   
   //
   // CPU Interaces
   //
   
   wire cpu_request;
   wire cpu_grant;
   wire cpu_addr_cycle;
   wire cpu_data_cycle;
   wire cpu_io_cycle;
   wire cpu_clr_busy;
   wire [1: 7] cpu_pi_lvl;
   wire [0: 2] cpu_pi_current;
   wire [0:35] cpu_data;
   
   //
   // Unibus Interfaces
   // 

   wire uba_busy;
   wire uba_reqest;
   wire [1: 7] uba_pi_req;
   wire [0:35] uba_data;

   //
   // Reset needs to be asserted for a few clock cycles (min)
   // for the hardware to initialize
   //
   
   RST uRST(.clk            (clk),
            .reset          (reset),
            .rst            (rst)
            );
   
   //
   // The KS10 Bus Arbiter
   //
   
   ARB uARB(.clk            (clk),
            .rst            (rst),
            .pwr_fail       (pwr_fail),
               
            //
            // CON Interface
            //
            
            .con_request    (con_request),
            .con_grant      (con_grant),
            .con_addr_cycle (con_addr_cycle),
            .con_data_cycle (con_data_cycle),
            .con_io_cycle   (con_io_cycle),
            .con_data       (con_data),
            
            //
            // CPU Interface
            //
            
            .cpu_request    (cpu_request),
            .cpu_grant      (cpu_grant),
            .cpu_addr_cycle (cpu_addr_cycle),
            .cpu_data_cycle (cpu_data_cycle),
            .cpu_io_cycle   (cpu_io_cycle),
            .cpu_data       (cpu_data),
               
            //
            // Unibus Interface
            //
            
            .uba_request    (uba_request),
            .uba_grant      (uba_grant),
            .uba_addr_cycle (uba_addr_cycle),
            .uba_data_cycle (uba_data_cycle),
            .uba_io_cycle   (uba_io_cycle),
            .uba_data       (uba_data),
                                
            //
            // Memory Interface
            //
            
            .mem_addr_cycle (mem_addr_cycle),
            .mem_data_cycle (mem_data_cycle),
            .mem_io_cycle   (mem_io_cycle),
            .mem_data       (mem_data),

            //
            // ARB Output
            //
            
            .arb_addr_cycle (arb_addr_cycle),
            .arb_data_cycle (arb_data_cycle),
            .arb_io_cycle   (arb_io_cycle),
            .arb_mem_busy   (arb_mem_busy),
            .arb_uba_busy   (arb_uba_busy),
            .arb_data       (arb_data)
            );

   //
   // The KS10 CPU
   //
   
   CPU uCPU(.clk            (clk),
            .rst            (rst),
            .pwr_fail       (pwr_fail),
            .bus_request    (cpu_request),
            .bus_grant      (cpu_grant),
            .bus_addr_cycle (cpu_addr_cycle),
            .bus_data_cycle (cpu_data_cycle),
            .bus_io_cycle   (cpu_io_cycle),
            .bus_mem_busy   (mem_busy),
            .bus_clr_busy   (uba_clr_busy),
            .bus_pi_req_in  (uba_pi_req),
            .bus_pi_req_out (cpu_pi_lvl),
            .bus_pi_current (cpu_pi_current),
            .bus_data_in    (arb_data_out),
            .bus_data_out   (cpu_data_out)
            );

   //
   // Memory Interface
   //
   
   MEM uMEM(.clk                (clk),
            .rst                (rst),
            .pwr_fail           (pwr_fail),
            .bus_uba_busy       (arb_uba_busy),
            .bus_addr_cycle_in  (arb_addr_cycle),
            .bus_addr_cycle_out (mem_addr_cycle),
            .bus_data_cycle_in  (arb_data_cycle),
            .bus_data_cycle_out (mem_data_cycle),
            .bus_io_cycle_in    (arb_io_cycle),
            .bus_io_cycle_out   (mem_io_cycle),
            .bus_mem_busy_in    (arb_mem_busy),
            .bus_mem_busy_out   (mem_busy),
            .bus_data_in        (arb_data),
            .bus_data_out       (mem_data)
            );

   //
   // Unibus Interface
   //  Note: The KS10 has two UNIBUS adapter.  Somehow SIMH only
   //  implments a single UNIBUS adapter.  We will try the same
   //  trick.
   //
   
   UBA uUBA(.clk                (clk),
            .rst                (rst),
            .pwr_fail           (pwr_fail),
            .bus_request        (uba_request),
            .bus_grant          (uba_grant),
            .bus_uba_busy       (arb_uba_busy),
            .bus_addr_cycle_in  (arb_addr_cycle),
            .bus_addr_cycle_out (uba_addr_cycle),
            .bus_data_cycle_in  (arb_data_cycle),
            .bus_data_cycle_out (uba_data_cycle),
            .bus_io_cycle_out   (uba_io_cycle),
            .bus_mem_busy_in    (arb_mem_busy),
            .bus_mem_busy_out   (uba_mem_busy),
            .bus_data_in        (arb_data),
            .bus_data_out       (uba_data),
            .bus_pi_current     (cpu_pi_current),
            .bus_pi_request     (uba_pi_request)
            );

   //
   // Console
   //
   
   CONS uCONS(.clk                 (clk),
              .rst                 (rst),
              .pwr_fail            (pwr_fail),
              .bus_request         (con_request),
              .bus_grant           (con_grant),
              .bus_uba_busy        (arb_uba_busy),
              .bus_addr_cycle_in   (arb_addr_cycle),
              .bus_addr_cycle_out  (con_addr_cycle),
              .bus_data_cycle_in   (arb_data_cycle), 
              .bus_data_cycle_out  (con_data_cycle),
              .bus_io_cycle_in     (arb_io_cycle), 
              .bus_io_cycle_out    (con_io_cycle),
              .bus_mem_busy_in     (arb_mem_busy), 
              .bus_mem_busy_out    (con_mem_busy),
              .bus_pi_lvl          (cpu_pi_lvl),
              .bus_pi_current      (cpu_pi_current),
              .bus_data_in         (arb_data),     
              .bus_data_out        (con_data),
              .rxd                 (conRXD),
              .txd                 (conTXD)
              );
   
     
endmodule


