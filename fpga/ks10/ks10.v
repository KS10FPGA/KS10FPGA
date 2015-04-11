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
`include "uba/dz11/dz11.vh"
`include "uba/rh11/rh11.vh"
`include "uba/rh11/rpxx/rpxx.vh"

module KS10(RESET_N, CLK50MHZ,
            // DZ11 Interfaces
            dz11TXD, dz11RXD, dz11CO, dz11RI, dz11DTR,
            // RH11 Interfaces
            rh11CD, rh11WP, rh11MISO, rh11MOSI, rh11SCLK, rh11CS,
            // Console Interfaces
            conADDR, conDATA, conBLE_N, conBHE_N, conRD_N, conWR_N, conINTR_N,
            // SSRAM Interfaces
            ssramCLK, ssramCLKEN_N, ssramADV, ssramBW_N,
            ssramOE_N, ssramWE_N, ssramCE, ssramADDR, ssramDATA,
            haltLED, test);

   // Clock/Reset
   input         RESET_N;       // Reset
   input         CLK50MHZ;      // Clock
   // DZ11 Interfaces
   output [ 7: 0] dz11TXD;      // DZ11 Transmitter Serial Data
   input  [ 7: 0] dz11RXD;      // DZ11 Receiver Serial Data
   input  [ 7: 0] dz11CO;       // DZ11 Carrier Detect Input
   input  [ 7: 0] dz11RI;       // DZ11 Ring Indicator Input
   output [ 7: 0] dz11DTR;      // DZ11 Data Terminal Ready Output
   // RH11 Interfaces
   input         rh11CD;        // RH11 Card Detect
   input         rh11WP;        // RH11 Write Protect
   input         rh11MISO;      // RH11 Data In
   output        rh11MOSI;      // RH11 Data Out
   output        rh11SCLK;      // RH11 Clock
   output        rh11CS;        // SD11 Chip Select
   // Console Interfaces
   inout [15: 0] conDATA;       // Console Data Bus
   input [ 5: 1] conADDR;       // Console Address Bus
   input         conBLE_N;      // Console Bus Lane
   input         conBHE_N;      // Console Bus Lane
   input         conRD_N;       // Console Read Strobe
   input         conWR_N;       // Console Write Strobe
   output        conINTR_N;     // KS10 Interrupt to Console
   // SSRAM Interfaces
   output        ssramCLK;      // SSRAM Clock
   output        ssramCLKEN_N;  // SSRAM CLKEN#
   output        ssramADV;      // SSRAM Advance
   output [1: 4] ssramBW_N;     // SSRAM BW#
   output        ssramOE_N;     // SSRAM OE#
   output        ssramWE_N;     // SSRAM WE#
   output        ssramCE;       // SSRAM CE
   output [0:22] ssramADDR;     // SSRAM Address Bus
   inout  [0:35] ssramDATA;     // SSRAM Data Bus
   output        haltLED;       // Halt LED
   output [0: 7] test;          // Test signals

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
   wire        cslSET;          // Console Set State
   wire        cslRUN;          // Console Run Switch
   wire        cslCONT;         // Console Continue Switch
   wire        cslEXEC;         // Console Exec Switch
   wire        cslTRAPEN;       // Console Trap Enable
   wire        cslTIMEREN;      // Console Timer Enable
   wire        cslCACHEEN;      // Console Cache Enable
   wire        cslINTR;         // Console Interrupt to KS10
   wire        cslRESET;        // KS10 Reset
   wire        cslINTRO;        // KS10 Interrupt to Console

   //
   // CPU Interfaces
   //

   wire        cpuREQO;         // CPU Bus Request
   wire        cpuACKI;         // CPU Bus Acknowledge
   wire [0:35] cpuADDRO;        // CPU Address Out
   wire [0:35] cpuDATAI;        // CPU Data In
   wire [0:35] cpuDATAO;        // CPU Data Out
   wire        cpuHALT;         // CPU Halt Status
   wire        cpuRUN;          // CPU Run Status
   wire        cpuEXEC;         // CPU Exec Status
   wire        cpuCONT;         // CPU Cont Status

   //
   // DZ11 Interfaces
   //

   wire [0:63] rh11DEBUG;       // RH11 Debug

   //
   // Memory Interfaces
   //

   wire [0:35] memDATAI;        // Memory Data In
   wire [0:35] memDATAO;        // Memory Data Out
   wire        memREQ;          // Memory REQ
   wire        memACK;          // Memory ACK

   //
   // Unibus Interfaces (x4)
   //

   wire [1: 7] ubaINTR;         // Unibus Interrupt Request
   wire        ubaREQI;         // Unibus Bus Request In
   wire [0: 3] ubaREQO;         // Unibus Bus Request Out
   wire [0: 3] ubaACKI;         // Unibus Bus Acknowledge In
   wire [0: 3] ubaACKO;         // Unibus Bus Acknowledge Out
   wire [0:35] ubaADDRO[0:3];   // Unibus Address Out
   wire [0:35] ubaDATAI;        // Unibus Data In
   wire [0:35] ubaDATAO[0:3];   // Unibus Data Out
   wire [1: 7] ubaINTRO[0:3];   // Unibus Interrupt

   //
   // Clock Generator and Reset Synchronization
   //

   wire rst;
   wire clk;
   wire [1:4] clkPHS;

   CLK uCLK (
      .RESET_N          (RESET_N),
      .CLK50MHZ         (CLK50MHZ),
      .clk              (clk),
      .clkPHS           (clkPHS),
      .ssramCLK         (ssramCLK),
      .rst              (rst)
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
      .rst              (cslRESET),
      .clk              (clk),
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
      .clk              (clk),
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
      .cslRESET         (cslRESET),
      // RH11 Interfaces
      .rh11DEBUG        (rh11DEBUG)
   );

   //
   // Memory
   //

   MEM uMEM (
      .rst              (cslRESET),
      .clk              (clk),
      .clkPHS           (clkPHS),
      .busREQI          (memREQ),
      .busACKO          (memACK),
      .busADDRI         (arbADDRO),
      .busDATAI         (memDATAI),
      .busDATAO         (memDATAO),
      .ssramCLK         (!CLK50MHZ),
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

   //
   // Stub Connected to IO Bridge 1 Device 2
   //

   wire         ctl1dev2REQI    = 0;
   wire         ctl1dev2ACKI    = 0;
   wire [ 0:35] ctl1dev2ADDRI   = 36'b0;
   wire [ 0:35] ctl1dev2DATAI   = 36'b0;
   wire [ 7: 4] ctl1dev2INTR    =  4'b0;

   UBA #(
      .ubaNUM           (`devUBA1),
      .ubaADDR          (`ubaADDR)
   )
   UBA1 (
      .rst              (cslRESET),
      .clk              (clk),
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
      .devADDRO         (ctl1ADDRO),
      .devDATAO         (ctl1DATAO),
      .devINTA          (ctl1INTA),
      .devRESET         (ctl1RESET),
      .dev1REQI         (rh1REQO),
      .dev1ACKI         (rh1ACKO),
      .dev1ADDRI        (rh1ADDRO),
      .dev1DATAI        (rh1DATAO),
      .dev1INTR         (rh1INTR),
      .dev1ACKO         (ctl1rh1ACKO),
      .dev2REQI         (ctl1dev2REQI),
      .dev2ACKI         (ctl1dev2ACKI),
      .dev2ADDRI        (ctl1dev2ADDRI),
      .dev2DATAI        (ctl1dev2DATAI),
      .dev2INTR         (ctl1dev2INTR),
      .dev2ACKO         ()
      );

   //
   // RH11 #1 Connected to IO Bridge 1 Device 1
   //

   RH11 #(
      .rhDEV            (`rh1DEV),
      .rhADDR           (`rh1ADDR),
      .rhVECT           (`rh1VECT),
      .rhINTR           (`rh1INTR),
      .drvTYPE          (`rpRP06),
      .simTIME          (1'b0)
   )
   uRH11 (
      .rst              (cslRESET),
      .clk              (clk),
      // RH11 IO
      .rh11CD           (rh11CD),
      .rh11WP           (rh11WP),
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

   //
   // Stub Connected to IO Bridge 3 Device 2
   //

   wire         ctl3dev2REQI    = 0;
   wire         ctl3dev2ACKI    = 0;
   wire [ 0:35] ctl3dev2ADDRI   = 36'b0;
   wire [ 0:35] ctl3dev2DATAI   = 36'b0;
   wire [ 7: 4] ctl3dev2INTR    =  4'b0;

   UBA #(
      .ubaNUM           (`devUBA3),
      .ubaADDR          (`ubaADDR)
   )
   UBA3 (
      .rst              (cslRESET),
      .clk              (clk),
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
      .devADDRO         (ctl3ADDRO),
      .devDATAO         (ctl3DATAO),
      .devINTA          (ctl3INTA),
      .devRESET         (ctl3RESET),
      .dev1REQI         (dz1REQO),
      .dev1ACKI         (dz1ACKO),
      .dev1ADDRI        (dz1ADDRO),
      .dev1DATAI        (dz1DATAO),
      .dev1INTR         (dz1INTR),
      .dev1ACKO         (ctl3dz1ACKO),
      .dev2REQI         (ctl3dev2REQI),
      .dev2ACKI         (ctl3dev2ACKI),
      .dev2ADDRI        (ctl3dev2ADDRI),
      .dev2DATAI        (ctl3dev2DATAI),
      .dev2INTR         (ctl3dev2INTR),
      .dev2ACKO         ()
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
      .rst              (cslRESET),
      .clk              (clk),
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
   // Test Signals
   //

   assign test[0] = RESET_N;
   assign test[1] = rst;
   assign test[2] = 0;
   assign test[3] = 0;
   assign test[4] = 0;
   assign test[5] = 0;
   assign test[6] = 0;
   assign test[7] = 0;

   //
   // Halt LED
   //

   assign haltLED = cpuHALT;

endmodule
