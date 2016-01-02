////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KS10 System
//
// Details
//   The system consists of a Clock Generator, a CPU, a Bus Aribter, a Memory
//   Controller, two Unibus Interfaces, and Console Interface, a DZ11 Terminal
//   Multiplexer, and an RH11 Disk Controller.
//
// File
//   ks10.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2015 Rob Doyle
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

`default_nettype none
`timescale 1ns/1ps

`include "ks10.vh"
`include "uba/uba.vh"
`include "dz11/dz11.vh"
`include "rh11/rh11.vh"
`include "rh11/rpxx/rpxx.vh"

module KS10 (
      // Clock/Reset
      input  wire         RESET_N,      // Reset
      input  wire         CLK50MHZ,     // Clock
      // DZ11 Interfaces
      output wire [ 7: 0] dz11TXD,      // DZ11 Transmitter Serial Data
      input  wire [ 7: 0] dz11RXD,      // DZ11 Receiver Serial Data
      output wire         dz11LOOP,     // DZ11 Loopback enable
      // RH11 Interfaces
      input  wire         rh11CD_N,     // RH11 Card Detect
      input  wire         rh11MISO,     // RH11 Data In
      output wire         rh11MOSI,     // RH11 Data Out
      output wire         rh11SCLK,     // RH11 Clock
      output wire         rh11CS,       // SD11 Chip Select
      // Console Interfaces
      inout  wire [15: 0] conDATA,      // Console Data Bus
      input  wire [ 5: 1] conADDR,      // Console Address Bus
      input  wire         conBLE_N,     // Console Bus Lane
      input  wire         conBHE_N,     // Console Bus Lane
      input  wire         conRD_N,      // Console Read Strobe
      input  wire         conWR_N,      // Console Write Strobe
      output wire         conINTR_N,    // KS10 Interrupt to Console
      // SSRAM Interfaces
      output wire         ssramCLK,     // SSRAM Clock
      output wire         ssramCLKEN_N, // SSRAM CLKEN#
      output wire         ssramADV,     // SSRAM Advance
      output wire [ 1: 4] ssramBW_N,    // SSRAM BW#
      output wire         ssramOE_N,    // SSRAM OE#
      output wire         ssramWE_N,    // SSRAM WE#
      output wire         ssramCE,      // SSRAM CE
      output wire [ 0:19] ssramADDR,    // SSRAM Address Bus
      inout  wire [ 0:35] ssramDATA,    // SSRAM Data Bus
      output wire         haltLED,      // Halt LED
      output wire [ 0:27] test          // Test signals
   );

   //
   // Bus Arbiter Outputs
   //

   wire [0:35] arbADDRO;                // Arbiter Address Out

   //
   // Console Interfaces
   //

   wire        cslREQI;                 // Console Bus Request In
   wire        cslREQO;                 // Console Bus Request Out
   wire        cslACKI;                 // Console Bus Acknowledge In
   wire        cslACKO;                 // Console Bus Acknowledge Out
   wire [0:35] cslADDRI;                // Console Address In
   wire [0:35] cslADDRO;                // Console Address Out
   wire [0:35] cslDATAI;                // Console Data In
   wire [0:35] cslDATAO;                // Console Data Out
   wire        cslSET;                  // Console Set State
   wire        cslRUN;                  // Console Run Switch
   wire        cslCONT;                 // Console Continue Switch
   wire        cslEXEC;                 // Console Exec Switch
   wire        cslTRAPEN;               // Console Trap Enable
   wire        cslTIMEREN;              // Console Timer Enable
   wire        cslCACHEEN;              // Console Cache Enable
   wire        cslINTR;                 // Console Interrupt to KS10
   wire        cslINTRO;                // KS10 Interrupt to Console
   wire        cpuRST;                  // KS10 Reset

   //
   // CPU Interfaces
   //

   wire        cpuREQO;                 // CPU Bus Request
   wire        cpuACKI;                 // CPU Bus Acknowledge
   wire [0:35] cpuADDRO;                // CPU Address Out
   wire [0:35] cpuDATAI;                // CPU Data In
   wire [0:35] cpuDATAO;                // CPU Data Out
   wire        cpuHALT;                 // CPU Halt Status
   wire        cpuRUN;                  // CPU Run Status
   wire        cpuEXEC;                 // CPU Exec Status
   wire        cpuCONT;                 // CPU Cont Status

   //
   // DZ11 Interfaces
   //

   wire [0: 7] dz11DTR;                 // DZ11 Data Terminal Ready
   wire [0:63] dz11CCR;                 // DZ11 Console Control Register
   wire [0: 7] dz11RI = dz11CCR[56:63]; // DZ11 Ring Indicator
   wire [0: 7] dz11CO = dz11CCR[48:55]; // DZ11 Carrier Sense
   assign dz11LOOP    = dz11CCR[47];    // DZ11 Loopback

   //
   // RH11 Interfaces
   //

   wire [0:63] rh11CCR;                 // RH11 Console Control Register
   wire [0:63] rh11DEBUG;               // RH11 Debug
   wire [7: 0] rh11WP  = rh11CCR[56:63];// RH11 Write Protect
   wire [7: 0] rh11CD  = rh11CCR[48:55];// RH11 Card Detect
   wire [7: 0] rh11DPR = rh11CCR[40:47];// RH11 Drive Present
   wire [7: 0] rh11EN  = rh11CCR[32:39];// RH11 Enabled

   //
   // Memory Interfaces
   //

   wire [0:35] memDATAI;                // Memory Data In
   wire [0:35] memDATAO;                // Memory Data Out
   wire        memREQ;                  // Memory REQ
   wire        memACK;                  // Memory ACK

   //
   // Unibus Interfaces (x4)
   //

   wire [1: 7] ubaINTR;                 // Unibus Interrupt Request
   wire        ubaREQI;                 // Unibus Bus Request In
   wire [0: 3] ubaREQO;                 // Unibus Bus Request Out
   wire [0: 3] ubaACKI;                 // Unibus Bus Acknowledge In
   wire [0: 3] ubaACKO;                 // Unibus Bus Acknowledge Out
   wire [0:35] ubaADDRO[0:3];           // Unibus Address Out
   wire [0:35] ubaDATAI;                // Unibus Data In
   wire [0:35] ubaDATAO[0:3];           // Unibus Data Out
   wire [1: 7] ubaINTRO[0:3];           // Unibus Interrupt

   //
   // Clock Generator and Reset Synchronization
   //

   wire rst;
   wire cpuCLK;
   wire memCLK;
   wire [1:4] clkPHS;

   CLK uCLK (
      .RESET_N          (RESET_N),
      .CLK50MHZ         (CLK50MHZ),
      .cpuCLK           (cpuCLK),
      .memCLK           (memCLK),
      .rst              (rst),
      .clkPHS           (clkPHS)
   );

   //
   // Bus Arbiter
   //

   ARB uARB (
      // CPU
      .cpuREQI          (cpuREQO),
      .cpuACKO          (cpuACKI),
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
      .uba0ADDRI        (ubaADDRO[0]),
      .uba1ADDRI        (ubaADDRO[1]),
      .uba2ADDRI        (ubaADDRO[2]),
      .uba3ADDRI        (ubaADDRO[3]),
      .uba0DATAI        (ubaDATAO[0]),
      .uba1DATAI        (ubaDATAO[1]),
      .uba2DATAI        (ubaDATAO[2]),
      .uba3DATAI        (ubaDATAO[3]),
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

   CPU uCPU (
      .rst              (cpuRST),
      .clk              (cpuCLK),
      .memCLK           (memCLK),
      .clkPHS           (clkPHS),
      // Console
      .cslSET           (cslSET),
      .cslRUN           (cslRUN),
      .cslCONT          (cslCONT),
      .cslEXEC          (cslEXEC),
      .cslTIMEREN       (cslTIMEREN),
      .cslTRAPEN        (cslTRAPEN),
      .cslCACHEEN       (cslCACHEEN),
      .cslINTRI         (cslINTR),
      .cslINTRO         (cslINTRO),
      // UBA
      .ubaINTR          (ubaINTR),
      // CPU
      .cpuREQO          (cpuREQO),
      .cpuACKI          (cpuACKI),
      .cpuADDRO         (cpuADDRO),
      .cpuDATAI         (cpuDATAI),
      .cpuDATAO         (cpuDATAO),
      .cpuHALT          (cpuHALT),
      .cpuRUN           (cpuRUN),
      .cpuEXEC          (cpuEXEC),
      .cpuCONT          (cpuCONT)
   );

   //
   // Console
   //

   CSL uCSL (
      .rst              (rst),
      .clk              (cpuCLK),
      // Console Microcontroller Interfaces
      .conADDR          (conADDR),
      .conDATA          (conDATA),
      .conBLE_N         (conBLE_N),
      .conBHE_N         (conBHE_N),
      .conRD_N          (conRD_N),
      .conWR_N          (conWR_N),
      // Bus Interfaces
      .busREQI          (cslREQI),
      .busREQO          (cslREQO),
      .busACKI          (cslACKI),
      .busACKO          (cslACKO),
      .busADDRI         (arbADDRO),
      .busADDRO         (cslADDRO),
      .busDATAI         (cslDATAI),
      .busDATAO         (cslDATAO),
      // CPU Interfaces
      .cpuRUN           (cpuRUN),
      .cpuHALT          (cpuHALT),
      .cpuEXEC          (cpuEXEC),
      .cpuCONT          (cpuCONT),
      // Console Interfaces
      .cslSET           (cslSET),
      .cslRUN           (cslRUN),
      .cslCONT          (cslCONT),
      .cslEXEC          (cslEXEC),
      .cslTIMEREN       (cslTIMEREN),
      .cslTRAPEN        (cslTRAPEN),
      .cslCACHEEN       (cslCACHEEN),
      .cslINTR          (cslINTR),
      .cslRESET         (cpuRST),
      // DZ11
      .dz11CCR          (dz11CCR),
      // RH11 Interfaces
      .rh11CCR          (rh11CCR),
      .rh11DEBUG        (rh11DEBUG)
   );

   //
   // Memory
   //

   MEM uMEM (
      .rst              (cpuRST),
      .cpuCLK           (cpuCLK),
      .memCLK           (memCLK),
      .clkPHS           (clkPHS),
      .busREQI          (memREQ),
      .busACKO          (memACK),
      .busADDRI         (arbADDRO),
      .busDATAI         (memDATAI),
      .busDATAO         (memDATAO),
      .ssramCLK         (ssramCLK),
      .ssramCLKEN_N     (ssramCLKEN_N),
      .ssramADV         (ssramADV),
      .ssramBW_N        (ssramBW_N),
      .ssramOE_N        (ssramOE_N),
      .ssramWE_N        (ssramWE_N),
      .ssramCE          (ssramCE),
      .ssramADDR        (ssramADDR),
      .ssramDATA        (ssramDATA)
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

   UBA #(
      .ubaNUM           (`devUBA1),
      .ubaADDR          (`ubaADDR)
   )
   UBA1 (
      .rst              (cpuRST),
      .clk              (cpuCLK),
      .busREQI          (ubaREQI),
      .busREQO          (ubaREQO[1]),
      .busACKI          (ubaACKI[1]),
      .busACKO          (ubaACKO[1]),
      .busADDRI         (arbADDRO),
      .busADDRO         (ubaADDRO[1]),
      .busDATAI         (ubaDATAI),
      .busDATAO         (ubaDATAO[1]),
      .busINTR          (ubaINTRO[1]),
      .devREQO          (ctl1REQO),
      .devACKI          (rh1ACKO),
      .devREQI          (rh1REQO),
      .devACKO          (ctl1rh1ACKO),
      .devADDRO         (ctl1ADDRO),
      .devADDRI         (rh1ADDRO),
      .devDATAO         (ctl1DATAO),
      .devDATAI         (rh1DATAO),
      .devINTR          (rh1INTR),
      .devINTA          (ctl1INTA),
      .devRESET         (ctl1RESET)
   );

   //
   // RH11 #1 Connected to IO Bridge 1 Device 1
   //

   RH11 #(
      .rhDEV            (`rh1DEV),
      .rhADDR           (`rh1ADDR),
      .rhVECT           (`rh1VECT),
      .rhINTR           (`rh1INTR),
      .drvTYPE          (`rpRP06)
   )
   uRH11 (
      .rst              (cpuRST),
      .clk              (cpuCLK),
      // RH11 IO
      .rh11CD           (rh11CD),
      .rh11WP           (rh11WP),
      .rh11DPR          (rh11DPR),
      .rh11EN           (rh11EN),
      .rh11MISO         (rh11MISO),
      .rh11MOSI         (rh11MOSI),
      .rh11SCLK         (rh11SCLK),
      .rh11CS           (rh11CS),
      .rh11DEBUG        (rh11DEBUG),
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
      .devDATAO         (rh1DATAO)
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

   UBA #(
      .ubaNUM           (`devUBA3),
      .ubaADDR          (`ubaADDR)
   )
   UBA3 (
      .rst              (cpuRST),
      .clk              (cpuCLK),
      .busREQI          (ubaREQI),
      .busREQO          (ubaREQO[3]),
      .busACKI          (ubaACKI[3]),
      .busACKO          (ubaACKO[3]),
      .busADDRI         (arbADDRO),
      .busADDRO         (ubaADDRO[3]),
      .busDATAI         (ubaDATAI),
      .busDATAO         (ubaDATAO[3]),
      .busINTR          (ubaINTRO[3]),
      .devREQO          (ctl3REQO),
      .devACKI          (dz1ACKO),
      .devREQI          (dz1REQO),
      .devACKO          (ctl3dz1ACKO),
      .devADDRO         (ctl3ADDRO),
      .devADDRI         (dz1ADDRO),
      .devDATAO         (ctl3DATAO),
      .devDATAI         (dz1DATAO),
      .devINTR          (dz1INTR),
      .devINTA          (ctl3INTA),
      .devRESET         (ctl3RESET)
   );

   //
   // DZ11 #1 Connected to IO Bridge 3 Device 1
   //

   DZ11 #(
      .dzDEV            (`dz1DEV),
      .dzADDR           (`dz1ADDR),
      .dzVECT           (`dz1VECT),
      .dzINTR           (`dz1INTR)
   )
   uDZ11 (
      .rst              (cpuRST),
      .clk              (cpuCLK),
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

   assign conINTR_N = ~cslINTRO;

   //
   // Interrupts
   //

   assign ubaINTR = ubaINTRO[0] | ubaINTRO[1] |  ubaINTRO[2] | ubaINTRO[3];

   //
   // Unused Unibus Devices
   //

   assign ubaREQO[0]  = 0;
   assign ubaREQO[2]  = 0;
   assign ubaACKO[0]  = 0;
   assign ubaACKO[2]  = 0;
   assign ubaADDRO[0] = 0;
   assign ubaADDRO[2] = 0;
   assign ubaDATAO[0] = 0;
   assign ubaDATAO[2] = 0;
   assign ubaINTRO[0] = 0;
   assign ubaINTRO[2] = 0;

   //
   // Halt LED
   //

   assign haltLED = cpuHALT;

   //
   // Test
   //

   assign test = 0;

endmodule
