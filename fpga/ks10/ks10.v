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

module KS10(clk, reset, pwrFAIL,
            swCONT, swEXEC, swRUN,
            conRXD, conTXD,
            cpuHALT, cpuRUN);

   //
   // System Interfaces
   //
   
   input        clk;          	// Clock
   input        reset;		// Reset
   input        pwrFAIL;     	// Power Fail
   input        swCONT;		// Continue Switch
   input        swEXEC;		// Exec Switch
   input        swRUN;		// Run Switch
   output	cpuHALT;	// Halt LED
   output       cpuRUN;		// Run LED
   
   //
   // Console Interfaces
   //
   
   input        conRXD;      	// Console RXD
   output       conTXD;      	// Console TXD
 
   //
   // Bus Arbiter Outputs
   //

   wire [ 0:35] arbDATA;     	// Arbiter Data
   wire         arbACK;		// Arbiter ACK
   wire         arbNXMIRQ;	//
   
   //
   // Console Interfaces
   //

   wire [ 0:35] consDATA;     	// Console Data
   wire         consACK;	// Console ACK
   
   //
   // CPU Outputs
   //
   
   wire         cpuWRITE;	// Memory/IO Write
   wire		cpuREAD;	// Memory/IO Read
   wire         cpuIO;		// IO 
   
   wire         cpuCONT;	// 
   wire         cpuHALT;	// 
   wire         cpuRUN;		// 
   wire [14:35] cpuADDR;	// Memory Address
   wire [ 0:35] cpuDATA;     	// Memory Data
  
   //
   // Memory Outputs
   //
   
   wire [ 0:35] memDATA;	// Memory Data Output
   wire         memACK;		// Memory ACK

   //
   // Unibus Interface
   //
   
   wire [ 0:35] ubaDATA;	// Unibus Data Output
   wire         ubaACK;		// Unibus ACK
   
   //      
   // Reset
   //
   // Details
   //  The reset signal (rst) needs to be asserted for a few clock
   //  cycles (min) for the hardware to initialize.  It also needs
   //  to by synchronously negated.
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
      .consRUN		(swRUN),
      .consEXEC		(swEXEC),
      .consCONT		(swCONT),
      .consHALT		(1'b0),
      .consTRAPEN	(1'b1),
      .consCACHEEN	(1'b0),
      .pwrIRQ		(pwrFAIL),
      .consIRQ		(1'b0),
      .ubaIRQ		(7'b0),
      .nxmIRQ		(arbNXMIRQ),
      .cpuADDR 		(cpuADDR),
      .cpuDIN		(arbDATA),
      .cpuACK		(arbACK),
      .cpuDOUT		(cpuDATA),
      .cpuWRITE		(cpuWRITE),
      .cpuREAD		(cpuREAD),
      .cpuIO		(cpuIO),
      .cpuCONT		(cpuCONT),
      .cpuHALT		(cpuHALT),
      .cpuRUN		(cpuRUN)
      );

   //
   // Bus Arbiter
   //

   ARB uARB
     (.memACK		(memACK),
      .memDATA		(memDATA),
      .consACK		(consACK),
      .consDATA		(consDATA),
      .ubaACK		(ubaACK),
      .ubaDATA		(ubaDATA),
      .arbACK		(arbACK),
      .arbDATA		(arbDATA)
      );
   
   //
   // Console Interface
   //

    CONS uCONS
     (.clk              (clk),
      .clken            (cpuIO),
      .cpuREAD		(cpuREAD),
      .cpuWRITE		(cpuWRITE),
      .cpuIO 		(cpuIO),
      .cpuADDR		(cpuADDR),
      .cpuDATA		(cpuDATA),
      .consDATA		(consDATA),
      .consACK		(consACK)
      );
   
   //
   // Memory Interface
   //
   
   MEM uMEM
     (.clk              (clk),
      .clken            (1'b1),
      .cpuREAD 		(cpuREAD),
      .cpuWRITE		(cpuWRITE),
      .cpuIO 		(cpuIO),
      .cpuADDR		(cpuADDR),
      .cpuDATA		(cpuDATA),
      .memDATA		(memDATA),
      .memACK		(memACK)
      );
   
   //
   // Unibus Interface
   //
   
   UBA uUBA
     (.clk              (clk),
      .clken            (1'b1),
      .cpuREAD 		(cpuREAD),
      .cpuWRITE		(cpuWRITE),
      .cpuIO 		(cpuIO),
      .cpuADDR		(cpuADDR),
      .cpuDATA		(cpuDATA),
      .ubaDATA		(ubaDATA),
      .ubaACK		(ubaACK)
      );

    assign arbNXMIRQ = ~arbACK & ~cpuIO;
     
endmodule


