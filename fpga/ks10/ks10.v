////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KS10 System.   The system consists of a CPU, a Bus Aribter,
//   Memory, and a Unibus Interface.
//
// Details
//
// Todo
//
// File
//   ks10.v
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

`include "ks10.vh"
`include "uba/uba.vh"
`include "uba/dz11/dz11.vh"
`include "uba/rh11/rh11.vh"

module KS10(clk, reset,
            // DZ11 Interfaces
            dz11TXD, dz11RXD,
            // RH11 Interfaces
            rh11CD, rh11WP, rh11MISO, rh11MOSI, rh11SCLK, rh11CS,
            // Console Interfaces
            cslALE, cslAD, cslRD_N, cslWR_N, cslINTR_N,
            // SSRAM Interfaces
            ssramCLK, ssramADDR, ssramDATA, ssramWR, ssramADV,
            runLED);

   parameter [14:17] ctlNUM1 = `ctlNUM1;
   parameter [14:17] ctlNUM3 = `ctlNUM3;

   input         clk;           // Clock
   input         reset;         // Reset
   // DZ11 Interfaces
   output [7: 0] dz11TXD;       // DZ11 Transmitted RS-232 Data
   input  [7: 0] dz11RXD;       // DZ11 Received RS-232 Data
   // RH11 Interfaces
   input         rh11CD;        // RH11 Card Detect
   input         rh11WP;        // RH11 Write Protect
   input         rh11MISO;      // RH11 Data In
   output        rh11MOSI;      // RH11 Data Out
   output        rh11SCLK;      // RH11 Clock
   output        rh11CS;        // SD11 Chip Select
   // Console Interfaces
   input         cslALE;        // Address Latch Enable
   inout  [7: 0] cslAD;         // Multiplexed Address/Data Bus
   input         cslRD_N;       // Read Strobe
   input         cslWR_N;       // Write Strobe
   output        cslINTR_N;     // Console Interrupt
   // SSRAM Interfaces
   output        ssramCLK;      // SSRAM Clock
   output [0:22] ssramADDR;     // SSRAM Address Bus
   inout  [0:35] ssramDATA;     // SSRAM Data Bus
   output        ssramWR;       // SSRAM Write
   output        ssramADV;      // SSRAM Advance
   output        runLED;        // RUN LED

   //
   // DZ-11 Interface Stubs
   //

   wire [7: 0] dz11CO  = 8'hff; // DZ11 Carrier Input
   wire [7: 0] dz11RI  = 8'h00; // DZ11 Ring Input
   wire [7: 0] dz11DTR;         // DZ11 DTR Output

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

   wire        uba1REQO;
   wire        uba1ACKO;
   wire [0:35] uba1ADDRO;
   wire [0:35] uba1DATAO;
   wire        uba1ACKI;
   wire [1: 7] uba1INTR;

   wire        uba3REQO;
   wire        uba3ACKI;
   wire        uba3ACKO;
   wire [0:35] uba3ADDRO;
   wire [0:35] uba3DATAO;
   wire [1: 7] uba3INTR;

   //
   // RH11 Outputs
   //

   wire [0:35] rhDEBUG;
               
   //
   // Bus Arbiter
   //

   ARB uARB
     (.clk              (clk),
      // CPU
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
      .ubaREQO          (ubaREQI),
      .ubaDATAO         (ubaDATAI),
      // Unibus #1
      .uba1REQI         (uba1REQO),
      .uba1ACKI         (uba1ACKO),
      .uba1ADDRI        (uba1ADDRO),
      .uba1DATAI        (uba1DATAO),
      .uba1ACKO         (uba1ACKI),
      // Unibus #3
      .uba3REQI         (uba3REQO),
      .uba3ACKI         (uba3ACKO),
      .uba3ADDRI        (uba3ADDRO),
      .uba3DATAI        (uba3DATAO),
      .uba3ACKO         (uba3ACKI),
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
      // Console Interfaces
      .rhDEBUG		(rhDEBUG),
      .cpuHALT          (cpuHALT),
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
   // IO Bridge #1
   //
   
   wire         ctl1REQO;
   wire [ 0:35] ctl1ADDRO;
   wire [ 0:35] ctl1DATAO;
   wire [ 7: 4] ctl1INTA;
   wire         ctl1RESET;
   wire         ctl1rh1ACKO;
   wire         rh1REQO;
   wire         rh1ACKO;
   wire [ 0:35] rh1ADDRO;
   wire [ 0:35] rh1DATAO;
   wire [ 7: 4] rh1INTR;

   //
   // Stub Connected to IO Bridge 1 Device 2
   //

   wire         ctl1dev2REQI    = 0;
   wire         ctl1dev2ACKI    = 0;
   wire [ 0:35] ctl1dev2ADDRI   = 36'b0;
   wire [ 0:35] ctl1dev2DATAI   = 36'b0;
   wire [ 7: 4] ctl1dev2INTR    =  4'b0;
   wire [18:35] ctl1dev2VECT    = 18'b0;
   wire         ctl1dev2ACKO;
   
   UBA UBA1
     (.clk              (clk),
      .rst              (reset),
      .clken            (1'b1),
      .ctlNUM           (ctlNUM1),
      .busREQI          (ubaREQI),
      .busREQO          (uba1REQO),
      .busACKI          (uba1ACKI),
      .busACKO          (uba1ACKO),
      .busADDRI         (arbADDRO),
      .busADDRO         (uba1ADDRO),
      .busDATAI         (ubaDATAI),
      .busDATAO         (uba1DATAO),
      .busINTR          (uba1INTR),
      .devREQO          (ctl1REQO),
      .devADDRO         (ctl1ADDRO),
      .devDATAO         (ctl1DATAO),
      .devINTA          (ctl1INTA),
      .devRESET         (ctl1RESET),
      .dev1REQI         (rh1REQO),
      .dev1ACKI         (rh1ACKO),
      .dev1ADDRI        (rh1ADDRO),
      .dev1DATAI        (rh1DATAO),
      .dev1INTR         (rh1INTR),
      .dev1VECT         (`rh1VECT),
      .dev1ACKO         (ctl1rh1ACKO),
      .dev2REQI         (ctl1dev2REQI),
      .dev2ACKI         (ctl1dev2ACKI),
      .dev2ADDRI        (ctl1dev2ADDRI),
      .dev2DATAI        (ctl1dev2DATAI),
      .dev2INTR         (ctl1dev2INTR),
      .dev2VECT         (ctl1dev2VECT),
      .dev2ACKO         (ctl1dev2ACKO)
      );

   //
   // RH11 #1 Connected to IO Bridge 1 Device 1
   //

   RH11 uRH11
     (.clk              (clk),
      .rst              (reset),
      // RH11 IO
      .rh11CD           (rh11CD),
      .rh11WP           (rh11WP),
      .rh11MISO         (rh11MISO),
      .rh11MOSI         (rh11MOSI),
      .rh11SCLK         (rh11SCLK),
      .rh11CS           (rh11CS),
      // Reset
      .devRESET         (ctl1RESET),
      // Interrupt
      .devINTR          (rh1INTR),
      .devINTA          (ctl1INTA),
      // Target
      .devREQI          (ctl1REQO),
      .devACKO          (rh1ACKO),
      .devADDRI         (ctl1ADDRO),
      // Initiator
      .devREQO          (rh1REQO),
      .devACKI          (ctl1rh1ACKO),
      .devADDRO         (rh1ADDRO),
      // Data
      .devDATAI         (ctl1DATAO),
      .devDATAO         (rh1DATAO),
      // Debug
      .rhDEBUG		(rhDEBUG)
      );

   //
   // IO Bridge #3
   //
	

   wire         ctl3REQO;
   wire [ 0:35] ctl3ADDRO;
   wire [ 0:35] ctl3DATAO;
   wire [ 7: 4] ctl3INTA;
   wire         ctl3RESET;
   wire         ctl3dz1ACKO;
   wire         dz1REQO;
   wire         dz1ACKO;
   wire [ 0:35] dz1ADDRO;
   wire [ 0:35] dz1DATAO;
   wire [ 7: 4] dz1INTR;

   //
   // Stub Connected to IO Bridge 3 Device 2
   //

   wire         ctl3dev2REQI    = 0;
   wire         ctl3dev2ACKI    = 0;
   wire [ 0:35] ctl3dev2ADDRI   = 36'b0;
   wire [ 0:35] ctl3dev2DATAI   = 36'b0;
   wire [ 7: 4] ctl3dev2INTR    =  4'b0;
   wire [18:35] ctl3dev2VECT    = 18'b0;
   wire         ctl3dev2ACKO;
   
   UBA UBA3
     (.clk              (clk),
      .rst              (reset),
      .clken            (1'b1),
      .ctlNUM           (ctlNUM3),
      .busREQI          (ubaREQI),
      .busREQO          (uba3REQO),
      .busACKI          (uba3ACKI),
      .busACKO          (uba3ACKO),
      .busADDRI         (arbADDRO),
      .busADDRO         (uba3ADDRO),
      .busDATAI         (ubaDATAI),
      .busDATAO         (uba3DATAO),
      .busINTR          (uba3INTR),
      .devREQO          (ctl3REQO),
      .devADDRO         (ctl3ADDRO),
      .devDATAO         (ctl3DATAO),
      .devINTA          (ctl3INTA),
      .devRESET         (ctl3RESET),
      .dev1REQI         (dz1REQO),
      .dev1ACKI         (dz1ACKO),
      .dev1ADDRI        (dz1ADDRO),
      .dev1DATAI        (dz1DATAO),
      .dev1INTR         (dz1INTR),
      .dev1VECT         (`dz1VECT),
      .dev1ACKO         (ctl3dz1ACKO),
      .dev2REQI         (ctl3dev2REQI),
      .dev2ACKI         (ctl3dev2ACKI),
      .dev2ADDRI        (ctl3dev2ADDRI),
      .dev2DATAI        (ctl3dev2DATAI),
      .dev2INTR         (ctl3dev2INTR),
      .dev2VECT         (ctl3dev2VECT),
      .dev2ACKO         (ctl3dev2ACKO)
      );

   //
   // DZ11 #1 Connected to IO Bridge 3 Device 1
   //

   DZ11 uDZ11
     (.clk              (clk),
      .rst              (reset),
      .clken            (1'b1),
      // DZ11 IO
      .dz11TXD          (dz11TXD),
      .dz11RXD          (dz11RXD),
      .dz11CO           (dz11CO),
      .dz11RI           (dz11RI),
      .dz11DTR          (dz11DTR),
      // Reset
      .devRESET         (ctl3RESET),
      // Interrupt
      .devINTR          (dz1INTR),
      .devINTA          (ctl3INTA),
      // Target
      .devREQI          (ctl3REQO),
      .devACKO          (dz1ACKO),
      .devADDRI         (ctl3ADDRO),
      // Initiator
      .devREQO          (dz1REQO),
      .devACKI          (ctl3dz1ACKO),
      .devADDRO         (dz1ADDRO),
      // Data
      .devDATAI         (ctl3DATAO),
      .devDATAO         (dz1DATAO)
      );

   //
   // Console Interrupt fixup
   //

   assign cslINTR_N = ~cslINTR;
   assign runLED    = ~cpuHALT;

   //
   // Interrupts
   //
   
   assign busINTR = uba1INTR | uba3INTR;
   
   
endmodule
