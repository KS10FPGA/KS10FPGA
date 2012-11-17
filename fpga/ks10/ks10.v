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

   input       clk;             // Clock
   input       reset;           // Reset
   input       pwrFAIL;         // Power Fail
   input       swCONT;          // Continue Switch
   input       swEXEC;          // Exec Switch
   input       swRUN;           // Run Switch
   output      cpuHALT;         // Halt LED
   output      cpuRUN;          // Run LED

   //
   // Console Interfaces
   //

   input       conRXD;          // Console RXD
   output      conTXD;          // Console TXD

   //
   // Bus Arbiter Outputs
   //

   wire [0:35] arbADDRO;	// Arbiter Address Out

   //
   // Console Interfaces
   //


   wire        conREQI;         // Console Bus Request In
   wire        conREQO;         // Console Bus Request Out
   wire        conACKI;         // Console Bus Acknowledge In
   wire        conACKO;         // Console Bus Acknowledge Out
   wire [0:35] conADDRI;        // Console Address In
   wire [0:35] conADDRO;        // Console Address Out        
   wire [0:35] conDATAI;        // Console Data In
   wire [0:35] conDATAO;       	// Console Data Out

   //
   // CPU Outputs
   //

   wire        cpuHALT;         //
   wire        cpuRUN;          //
   wire        cpuREQ;          // CPU Bus Request
   wire        cpuACK;          // CPU Bus Acknowledge
   wire [0:35] cpuADDRO;        // CPU Address Out
   wire [0:35] cpuDATAI;        // CPU Data In
   wire [0:35] cpuDATAO;        // CPU Data Out

   //
   // Memory Outputs
   //

   wire [0:35] memDATAI;       // Memory Data In
   wire [0:35] memDATAO;       // Memory Data Out
   wire        memACK;         // Memory ACK

   //
   // Unibus Interface
   //

   wire [1: 7] ubaINTR;		// Unibus Interrupt Request
   wire        ubaREQ;         	// Unibus Bus Request
   wire        ubaACK;         	// Unibus Bus Acknowledge
   wire [0:35] ubaADDRI;        // Unibus Address In
   wire [0:35] ubaADDRO;        // Unibus Address Out
   wire [0:35] ubaDATAI;        // Unibus Data In
   wire [0:35] ubaDATAO;        // Unibus Data Out

   //
   // Interrupts
   //
   
   wire [0: 2] curINTR_NUM;	// Current Interrupt Priority
   
   //
   // Reset
   //

   RST uRST
     (.clk              (clk),
      .reset            (reset),
      .rst              (rst)
      );

   //
   // Bus Arbiter
   //

   ARB uARB
     (// CPU
      .cpuREQI          (cpuREQ),
      .cpuACKO          (cpuACK),
      .cpuADDRI         (cpuADDRO),
      .cpuDATAI         (cpuDATAO),
      .cpuDATAO         (cpuDATAI),
      // Console
      .conREQI          (conREQO),
      .conREQO          (conREQI),
      .conACKI          (conACKO),
      .conACKO          (conACKI),
      .conADDRI         (conADDRO),
      .conDATAI         (conDATAO),
      .conDATAO         (conDATAI),
      // Unibus
      .ubaREQI          (ubaREQO),
      .ubaREQO          (ubaREQI),
      .ubaACKI          (ubaACKO),
      .ubaACKO          (ubaACKI),
      .ubaADDRI         (ubaADDRO),
      .ubaDATAI         (ubaDATAO),
      .ubaDATAO         (ubaDATAI),
      // Memory
      .memREQO          (memREQ),
      .memACKI          (memACK),
      .memDATAI         (memDATAO),
      .memDATAO         (memDATAI),
      // Arb
      .arbADDRO         (arbADDRO)
      );

   //
   // The KS10 CPU
   //

   CPU uCPU
     (.clk              (clk),
      .rst              (rst),
      .consTIMEREN      (1'b1),
      .consSTEP         (1'b0),
      .consRUN          (swRUN),
      .consEXEC         (swEXEC),
      .consCONT         (swCONT),
      .consHALT         (1'b0),
      .consTRAPEN       (1'b1),
      .consCACHEEN      (1'b0),
      .pwrINTR          (pwrFAIL),
      .consINTR         (1'b0),
      .ubaINTR          (ubaINTR),
      .curINTR_NUM      (curINTR_NUM),
      .busREQ           (cpuREQ),
      .busACK           (cpuACK),
      .busADDRO         (cpuADDRO),
      .busDATAI         (cpuDATAI),
      .busDATAO         (cpuDATAO),
      .cpuHALT          (cpuHALT),
      .cpuRUN           (cpuRUN)
      );

   //
   // Console Interface
   //

   CON uCON
     (.clk              (clk),
      .clken            (1'b1),
      .busREQI          (conREQI),
      .busREQO          (conREQO),
      .busACKI          (conACKI),
      .busACKO          (conACKO),
      .busADDRI         (arbADDRO),
      .busADDRO         (conADDRO),
      .busDATAI         (conDATAI),
      .busDATAO         (conDATAO)
      );

   //
   // Memory Interface
   //

   MEM uMEM
     (.clk              (clk),
      .clken            (1'b1),
      .busREQI		(memREQ),
      .busACKO          (memACK),
      .busADDRI         (arbADDRO),
      .busDATAI 	(memDATAI),
      .busDATAO         (memDATAO)
      );

   //
   // Unibus Interface
   //

   UBA uUBA
     (.clk              (clk),
      .clken            (1'b1),
      .ubaINTR		(ubaINTR),
      .curINTR_NUM      (curINTR_NUM),
      .busREQI          (ubaREQI),
      .busREQO          (ubaREQO),
      .busACKI          (ubaACKI),
      .busACKO          (ubaACKO),
      .busADDRI         (arbADDRO),
      .busADDRO         (ubaADDRO),
      .busDATAI         (ubaDATAI),
      .busDATAO         (ubaDATAO)
      );

endmodule
