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

module KS10(clk, reset, pwrFAIL, conRXD, conTXD, cpuHALT);

   //
   // System Interfaces
   //
   
   input        clk;          	// Clock
   input        reset;		// Reset
   input        pwrFAIL;     	// Power Fail

   //
   // Console Outputs
   //
   
   input        conRXD;      	// Console RXD
   output       conTXD;      	// Console TXD
   output       cpuHALT;	// CPU Halt

   //
   // CPU Outputs
   //
   
   wire         cpuWRITE;	// Memory Write
   wire		cpuREAD;	// Memory Read
   wire         cpuCONT;	//
   wire         cpuHALT;	//
   wire         cpuRUN;		//
   wire [14:35] cpuADDR;	// Memory Address
   wire [ 0:35] cpuDOUT;     	// Memory Data
  
   //
   // Memory Outputs
   //
   
   wire [ 0:35] memDOUT;	// Memory Data Output
   wire         memACK;		// Memory ACK
     
   //
   // Reset needs to be asserted for a few clock cycles (min)
   // for the hardware to initialize
   //
   
   RST uRST
     (.clk            	(clk),
      .reset          	(reset),
      .rst            	(rst)
      );

   //
   // The KS10 CPU
   //
   
   CPU uCPU
     (.clk            	(clk),
      .rst            	(rst),
      .clken          	(1'b1),
      .consTIMEREN	(1'b1),
      .consSTEP		(1'b0),
      .consRUN		(1'b1),
      .consEXEC		(1'b0),
      .consCONT		(1'b1),
      .consHALT		(1'b0),
      .consTRAPEN	(1'b1),
      .consCACHEEN	(1'b0),
      .pwrIRQ		(1'b0),
      .consIRQ		(1'b0),
      .ubiIRQ		(7'b0),
      .nxmIRQ		(~memACK),
      .cpuADDR 		(cpuADDR),
      .cpuDIN		(memDOUT),
      .cpuDOUT		(cpuDOUT),
      .cpuWRITE		(cpuWRITE),
      .cpuREAD		(cpuREAD),
      .cpuCONT		(cpuCONT),
      .cpuHALT		(cpuHALT),
      .cpuRUN		(cpuRUN)
      );

   //
   // Memory Interface
   //
   
   MEM uMEM
     (.clk              (clk),
      .clken            (1'b1),
      .memWRITE		(cpuWRITE),
      .memADDR		(cpuADDR),
      .memDIN		(cpuDOUT),
      .memDOUT		(memDOUT),
      .memACK		(memACK)
      );
     
endmodule


