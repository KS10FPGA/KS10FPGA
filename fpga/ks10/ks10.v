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

module KS10(clk, reset, TXD, RXD,
            cslALE, cslAD, cslRD_N, cslWR_N, cslINTR_N,
            ssramCLK, ssramADDR, ssramDATA, ssramWR, ssramADV,
            runLED);

   //
   // System Interfaces
   //
   
   input         clk;           // Clock
   input         reset;         // Reset
   input  [0: 3] RXD;           // Received RS-232 Data
   input  [0: 3] TXD;           // Transmitted RS-232 Data
   input         cslALE;        // Address Latch Enable
   inout  [7: 0] cslAD;         // Multiplexed Address/Data Bus
   input         cslRD_N;       // Read Strobe
   input         cslWR_N;       // Write Strobe
   output        cslINTR_N;     // Console Interrupt
   output        ssramCLK;      // SSRAM Clock
   output [0:22] ssramADDR;     // SSRAM Address Bus
   inout  [0:35] ssramDATA;     // SSRAM Data Bus
   output        ssramWR;       // SSRAM Write
   output        ssramADV;      // SSRAM Advance
   output        runLED;        // RUN LED

   //
   // Bus Arbiter Outputs
   //

   wire [0:35] arbADDRO;        // Arbiter Address Out

   //
   // Console Interfaces
   //


   wire        cslREQI;         // Console Bus Request In
   wire        cslREQO;         // Console Bus Request Out
   wire        cslACKI;         // Console Bus Acknowledge In
   wire        cslACKO;         // Console Bus Acknowledge Out
   wire [0:35] cslADDRI;        // Console Address In
   wire [0:35] cslADDRO;        // Console Address Out        
   wire [0:35] cslDATAI;        // Console Data In
   wire [0:35] cslDATAO;        // Console Data Out
   wire        cslSTEP;         // Console Single Step Switch
   wire        cslCONT;         // Console Continue Switch
   wire        cslRUN;          // Console Run Switch
   wire        cslEXEC;         // Console Exec Switch
   wire        cslHALT;         // Console Halt Switch
   wire        cslTRAPEN;       // Console Trap Enable
   wire        cslTIMEREN;      // Console Timer Enable
   wire        cslCACHEEN;      // Console Cache Enable
   wire        cslINTR;         // KS10 Interrupt to Console
   wire        ks10INTR;        // KS10 Interrupt
   wire        ks10RESET;       // KS10 Reset

   //
   // CPU Outputs
   //

   wire        cpuHALT;         // CPU Halt Status
   wire        cpuREQ;          // CPU Bus Request
   wire        cpuACK;          // CPU Bus Acknowledge
   wire [0:35] cpuADDRO;        // CPU Address Out
   wire [0:35] cpuDATAI;        // CPU Data In
   wire [0:35] cpuDATAO;        // CPU Data Out

   //
   // Memory Outputs
   //

   wire [0:35] memDATAI;        // Memory Data In
   wire [0:35] memDATAO;        // Memory Data Out
   wire        memREQ;          // Memory REQ
   wire        memACK;          // Memory ACK

   //
   // Unibus Interface
   //

   wire [1: 7] busINTR;         // Unibus Interrupt Request
   wire        ubaREQI;         // Unibus Bus Request In
   wire        ubaREQO;         // Unibus Bus Request Out
   wire        ubaACKI;         // Unibus Bus Acknowledge In
   wire        ubaACKO;         // Unibus Bus Acknowledge Out
   wire [0:35] ubaADDRI;        // Unibus Address In
   wire [0:35] ubaADDRO;        // Unibus Address Out
   wire [0:35] ubaDATAI;        // Unibus Data In
   wire [0:35] ubaDATAO;        // Unibus Data Out

   //
   // Interrupts
   //
   
   wire [0: 2] curINTR_NUM;     // Current Interrupt Priority

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
      .cslREQI          (cslREQO),
      .cslREQO          (cslREQI),
      .cslACKI          (cslACKO),
      .cslACKO          (cslACKI),
      .cslADDRI         (cslADDRO),
      .cslDATAI         (cslDATAO),
      .cslDATAO         (cslDATAI),
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
      .rst              (ks10RESET),
      .cslSTEP          (cslSTEP),
      .cslRUN           (cslRUN),
      .cslEXEC          (cslEXEC),
      .cslCONT          (cslCONT),
      .cslHALT          (cslHALT),
      .cslTIMEREN       (cslTIMEREN),
      .cslTRAPEN        (cslTRAPEN),
      .cslCACHEEN       (cslCACHEEN),
      .ks10INTR         (ks10INTR),
      .cslINTR          (cslINTR),
      .busINTR          (busINTR),
      .curINTR_NUM      (curINTR_NUM),
      .busREQ           (cpuREQ),
      .busACK           (cpuACK),
      .busADDRO         (cpuADDRO),
      .busDATAI         (cpuDATAI),
      .busDATAO         (cpuDATAO),
      .cpuHALT          (cpuHALT)
      );

   //
   // Console
   //

   CSL uCSL
     (.clk              (clk),
      .reset            (reset),
      .cslALE           (cslALE),
      .cslAD            (cslAD),
      .cslRD_N          (cslRD_N),
      .cslWR_N          (cslWR_N),
      .busREQI          (cslREQI),
      .busREQO          (cslREQO),
      .busACKI          (cslACKI),
      .busACKO          (cslACKO),
      .busADDRI         (arbADDRO),
      .busADDRO         (cslADDRO),
      .busDATAI         (cslDATAI),
      .busDATAO         (cslDATAO),
      .cpuHALT          (cpuHALT),
      // Console Interfaces
      .cslSTEP          (cslSTEP),
      .cslRUN           (cslRUN),
      .cslEXEC          (cslEXEC),
      .cslCONT          (cslCONT),
      .cslHALT          (cslHALT),
      .cslTIMEREN       (cslTIMEREN),
      .cslTRAPEN        (cslTRAPEN),
      .cslCACHEEN       (cslCACHEEN),
      .ks10INTR         (ks10INTR),
      .ks10RESET        (ks10RESET)
      );

   //
   // Memory
   //

   MEM uMEM
     (.clk              (clk),
      .rst              (reset),
      .clken            (1'b1),
      .busREQI          (memREQ),
      .busACKO          (memACK),
      .busADDRI         (arbADDRO),
      .busDATAI         (memDATAI),
      .busDATAO         (memDATAO),
      .ssramCLK         (ssramCLK),
      .ssramADDR        (ssramADDR),
      .ssramDATA        (ssramDATA),
      .ssramADV         (ssramADV),
      .ssramWR          (ssramWR)
      );

   //
   // DZ11 on Unibus
   //

   DZ11 uDZ11
     (.clk              (clk),
      .rst              (reset),
      .clken            (1'b1),
      .TXD              (TXD),
      .RXD              (RXD),
      .busINTR          (busINTR),
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

   //
   // Console Interrupt fixup
   //
   
   assign cslINTR_N = ~cslINTR;
   assign runLED    = ~cpuHALT;
   
endmodule
