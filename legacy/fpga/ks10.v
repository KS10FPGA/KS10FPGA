////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KS10 System
//
// Details
//   The system consists of a Clock Generator, a CPU, a Bus Arbiter, a Memory
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
// Copyright (C) 2012-2021 Rob Doyle
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

`include "uba/uba.vh"
`include "dup11/dup11.vh"
`include "dz11/dz11.vh"
`include "kmc11/kmc11.vh"
`include "rh11/rh11.vh"
`include "lp20/lp20.vh"
`include "rh11/rpxx/rpxx.vh"

module KS10 (
      // Clock/Reset
      input  wire         RESET_N,      // Reset
      input  wire         CLK50MHZ,     // Clock
      // DZ11 Interfaces
      input  wire [ 7: 0] DZ_RXD,       // DZ Receiver Serial Data
      output wire [ 7: 0] DZ_TXD,       // DZ Transmitter Serial Data
      output wire [ 7: 0] DZ_DTR,       // DZ Data Terminal Ready
      // LP20 Interface
      input  wire         LP_RXD,       // LP Receiver Serial Data
      output wire         LP_TXD,       // LP Transmitter Serial Data
      // SD Interfaces
      input  wire [ 7: 0] SD_CD,        // SD Card Detect
      input  wire [ 7: 0] SD_WP,        // SD Write Protect
      input  wire         SD_MISO,      // SD Data In
      output wire         SD_MOSI,      // SD Data Out
      output wire         SD_SCLK,      // SD Clock
      output wire         SD_SS_N,      // SD Slave Select
      // RPXX Interfaces
      output wire [ 7: 0] rpLEDS,       // RPXX LEDs
      // Console Interfaces
      inout  wire [15: 0] conDATA,      // Console Data Bus
      input  wire [ 7: 1] conADDR,      // Console Address Bus
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
      output wire [ 0:19] test          // Test signals
   );

   //
   // Clock Generator Signals
   //

   wire rst;                            // Reset
   wire cpuCLK;                         // CPU clock
   wire memCLK;                         // Memory clock
   wire [1:4] clkPHS;                   // Clock phase

   //
   // Console Signals
   //

   wire         cslREQI;                // Console Bus Request In
   wire         cslREQO;                // Console Bus Request Out
   wire         cslACKI;                // Console Bus Acknowledge In
   wire         cslACKO;                // Console Bus Acknowledge Out
   wire [ 0:35] cslADDRI;               // Console Address In
   wire [ 0:35] cslADDRO;               // Console Address Out
   wire [ 0:35] cslDATAI;               // Console Data In
   wire [ 0:35] cslDATAO;               // Console Data Out
   wire         cslHALT;                // Console Halt State
   wire         cslRUN;                 // Console Run Switch
   wire         cslCONT;                // Console Continue Switch
   wire         cslEXEC;                // Console Exec Switch
   wire         cslTRAPEN;              // Console Trap Enable
   wire         cslTIMEREN;             // Console Timer Enable
   wire         cslCACHEEN;             // Console Cache Enable
   wire         cslINTR;                // Console Interrupt to KS10
   wire         cslINTRO;               // KS10 Interrupt to Console
   wire         cpuRST;                 // KS10 Reset
   wire         cslDUPCTS;              // DUP11 Clear to Send
   wire         cslDUPDSR;              // DUP11 Data Terminal Ready
   wire         cslDUPDCD;              // DUP11 Data Carrier Detect
   wire         cslDUPRI;               // DUP11 Ring Indication.

   //
   // CPU Signals
   //

   wire         cpuREQO;                // CPU Bus Request
   wire         cpuACKI;                // CPU Bus Acknowledge
   wire [ 0:35] cpuADDRO;               // CPU Address Out
   wire [ 0:35] cpuDATAI;               // CPU Data In
   wire [ 0:35] cpuDATAO;               // CPU Data Out
   wire         cpuHALT;                // CPU Halt Status
   wire         cpuRUN;                 // CPU Run Status
   wire         cpuEXEC;                // CPU Exec Status
   wire         cpuCONT;                // CPU Cont Status

   //
   // DUP11 Signals
   //

   wire         dupTXE;                 // DUP11 TX Empty
   reg          dupRI;                  // DUP11 Ring Indication
   wire         dupRIO;                 // DUP11 Ring Indication Output from CSL
   reg          dupCTS;                 // DUP11 Clear To Send
   wire         dupCTSO;                // DUP11 Clear To Send Output from CSL
   reg          dupDSR;                 // DUP11 Data Set Ready
   wire         dupDSRO;                // DUP11 Data Set Ready Output from CSL
   reg          dupDCD;                 // DUP11 Data Carrier Detect
   wire         dupDCDO;                // DUP11 Data Carrier Detect Output from CSL
   wire [ 7: 0] dupTXFIFO;              // DUP11 TX FIFO
   wire         dupRXF;                 // DUP11 RX Full
   wire         dupDTR;                 // DUP11 Data Terminal Ready
   wire         dupRTS;                 // DUP11 Request to Send
   wire         dupH325;                // DUP11 H325 Loopback
   wire         dupW3;                  // DUP11 Config Wire 3
   wire         dupW5;                  // DUP11 Config Wire 5
   wire         dupW6;                  // DUP11 Config Wire 6
   wire [ 7: 0] dupRXFIFO;              // DUP11 RX FIFO
   wire         dupCLK;                 // DUP11 Test Clock
   reg          dupRXC;                 // DUP11 Receiver Clock
   reg          dupRXD;                 // DUP11 Receiver Data
   reg          dupTXC;                 // DUP11 Transmitter Clock
   wire         dupTXD;                 // DUP11 Transmitter Data
   wire         dupTXFIFO_RD;           // DUP11 RX FIFO Read
   wire         dupRXFIFO_WR;           // DUP11 RX FIFO Write

   //
   // DZ11 Signals
   //

   wire [ 0: 7] dzRI;                   // DZ11 Ring Indicator
   wire [ 0: 7] dzCO;                   // DZ11 Carrier Sense

   //
   // LP20/LP26 Signals
   //

   wire [ 0:31] lpCCR;                  // LP20 Console Control Register
   wire         lpSETONLN;              // LP20 set online
   wire         lpSETOFFLN;             // LP20 set offline
   wire         lpONLINE;               // LP20 status
   wire         lpOVFU;                 // LP20 has optical vertical format unit
   wire [ 6:15] lpCONFIG;               // LP20 serial configuration
   wire         lpINIT;                 // LP26 initialization
   wire         lpPARERR;               // LP26 data parity error
   wire         lpDPAR;                 // LP26 data parity
   wire [ 8: 1] lpDATA;                 // LP26 data
   wire         lpSTROBE;               // LP26 data strobe
   wire         lpDEMAND;               // LP26 ready for next character
   wire         lpVFURDY;               // LP26 vertical format unit ready
   wire         lpSIXLPI;               // LP26 line spacing
   wire         lpPI;                   // LP26 paper instruction
   wire         lpTOF;                  // LP26 top of form

   //
   // RH11 Interfaces
   //

   wire [ 0:63] rhDEBUG;                // RH11 Debug

   //
   // RPxx Interfaces
   //

   wire [ 7: 0] rpWRL;                  // RPXX Write Lock
   wire [ 7: 0] rpMOL;                  // RPXX Media on-line
   wire [ 7: 0] rpDPR;                  // RPXX Drive Present

   //
   // Memory Signals
   //

   wire         memREQI;                // Memory REQ
   wire         memACKO;                // Memory ACK
   wire [ 0:35] memDATAI;               // Memory Data In
   wire [ 0:35] memDATAO;               // Memory Data Out
   wire [ 0:35] memADDRI;               // Memory Address In

   //
   // Buses between Backplane Bus Arbiter and UBA Adapters (x4)
   //

   wire         ubaREQI;                // Unibus Bus Request In
   wire [ 1: 4] ubaREQO;                // Unibus Bus Request Out
   wire [ 1: 4] ubaACKI;                // Unibus Bus Acknowledge In
   wire [ 1: 4] ubaACKO;                // Unibus Bus Acknowledge Out
   wire [ 0:35] ubaADDRI[1:4];          // Unibus Address In
   wire [ 0:35] ubaADDRO[1:4];          // Unibus Address Out
   wire [ 0:35] ubaDATAI[1:4];          // Unibus Data In
   wire [ 0:35] ubaDATAO[1:4];          // Unibus Data Out
   wire [ 1: 7] ubaINTR[1:4];           // Unibus Interrupt Request

   //
   // Buses between UBA adapters and UBA devices (x16)
   //

   wire         devRESET[1:4];
   wire [ 1: 4] devREQI [1:4];
   wire [ 1: 4] devREQO [1:4];
   wire [ 1: 4] devACKI [1:4];
   wire [ 1: 4] devACKO [1:4];
   wire [ 0:35] devADDRI[1:4][1:4];
   wire [ 0:35] devADDRO[1:4][1:4];
   wire [ 0:35] devDATAI[1:4][1:4];
   wire [ 0:35] devDATAO[1:4][1:4];
   wire [ 7: 4] devINTR [1:4][1:4];
   wire [ 7: 4] devINTA [1:4][1:4];

   //
   // Debug Signals
   //

   wire [18:35] cpuPC;                  // Program Counter
   wire [ 0:35] cpuHR;                  // Instruction Register
   wire         regsLOAD;               // Update registers
   wire         vmaLOAD;                // Update VMA
   wire [ 9:11] debBRCMD;               // Breakpoint Command
   wire [13:15] debBRSTATE;             // Breakpoint state
   wire [24:26] debTRCMD;               // Trace Command
   wire [27:29] debTRSTATE;             // Trace state
   wire         debTRFULL;              // Trace full
   wire         debTREMPTY;             // Trace empty
   wire [ 0:35] debBAR;                 // Breakpoint Address Register
   wire [ 0:35] debBMR;                 // Breakpoint Mask Register
   wire [ 0:63] debITR;                 // Instruction Trace Register
   wire [ 0:63] debPCIR;                // Program counter and instruction register
   wire         debTRCMD_WR;            // Trace Command Write
   wire         debBRCMD_WR;            // Breakpoint Command Write
   wire         debITR_RD;              // Read Instruction Trace Register
   wire         debugHALT;              // Breakpoint the CPU

   //
   // This simulates the H325 Loopback Connector which is required for the
   // DUP11 diagnostics.
   //

   always @*
     begin
        if (dupH325)
          begin
             dupCTS <= dupRTS;
             dupDSR <= dupDTR;
             dupDCD <= dupRTS;
             dupRI  <= dupDTR;
             dupRXD <= dupTXD;
             dupRXC <= dupCLK;
             dupTXC <= dupCLK;
          end
        else
          begin
             dupCTS <= cslDUPCTS;
             dupDSR <= cslDUPDSR;
             dupDCD <= cslDUPDCD;
             dupRI  <= cslDUPRI;
             dupRXD <= dupTXD;
             dupRXC <= dupCLK;
             dupTXC <= dupCLK;
          end
     end

   //
   // Clock Generator and Reset Synchronization
   //

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
      .cslDATAI         (cslDATAO),
      .cslDATAO         (cslDATAI),
      .cslADDRI         (cslADDRO),
      .cslADDRO         (cslADDRI),
      // Unibus
      .ubaREQI          (ubaREQO),
      .ubaREQO          (ubaREQI),
      .ubaACKI          (ubaACKO),
      .ubaACKO          (ubaACKI),
      .uba1DATAI        (ubaDATAO[1]),
      .uba1DATAO        (ubaDATAI[1]),
      .uba1ADDRI        (ubaADDRO[1]),
      .uba1ADDRO        (ubaADDRI[1]),
      .uba2DATAI        (ubaDATAO[2]),
      .uba2DATAO        (ubaDATAI[2]),
      .uba2ADDRI        (ubaADDRO[2]),
      .uba2ADDRO        (ubaADDRI[2]),
      .uba3DATAI        (ubaDATAO[3]),
      .uba3DATAO        (ubaDATAI[3]),
      .uba3ADDRI        (ubaADDRO[3]),
      .uba3ADDRO        (ubaADDRI[3]),
      .uba4DATAI        (ubaDATAO[4]),
      .uba4DATAO        (ubaDATAI[4]),
      .uba4ADDRI        (ubaADDRO[4]),
      .uba4ADDRO        (ubaADDRI[4]),
      // Memory
      .memREQO          (memREQI),
      .memACKI          (memACKO),
      .memDATAI         (memDATAO),
      .memDATAO         (memDATAI),
      .memADDRO         (memADDRI)
   );

   //
   // The KS10 CPU
   //

   CPU uCPU (
      .rst              (cpuRST),
      .clk              (cpuCLK),
      .memCLK           (memCLK),
      .clkPHS           (clkPHS),
      // Breakpoint
      .debugHALT        (debugHALT),
      // Console
      .cslRUN           (cslRUN),
      .cslHALT          (cslHALT),
      .cslCONT          (cslCONT),
      .cslEXEC          (cslEXEC),
      .cslTIMEREN       (cslTIMEREN),
      .cslTRAPEN        (cslTRAPEN),
      .cslCACHEEN       (cslCACHEEN),
      .cslINTRI         (cslINTR),
      .cslINTRO         (cslINTRO),
      // UBA
      .ubaINTR          (ubaINTR[1] | ubaINTR[2] |  ubaINTR[3] | ubaINTR[4]),
      // CPU
      .cpuREQO          (cpuREQO),
      .cpuACKI          (cpuACKI),
      .cpuADDRO         (cpuADDRO),
      .cpuDATAI         (cpuDATAI),
      .cpuDATAO         (cpuDATAO),
      .cpuHALT          (cpuHALT),
      .cpuRUN           (cpuRUN),
      .cpuEXEC          (cpuEXEC),
      .cpuCONT          (cpuCONT),
      // Trace
      .cpuPC            (cpuPC),
      .cpuHR            (cpuHR),
      .regsLOAD         (regsLOAD),
      .vmaLOAD          (vmaLOAD)
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
      .busADDRI         (cslADDRI),
      .busADDRO         (cslADDRO),
      .busDATAI         (cslDATAI),
      .busDATAO         (cslDATAO),
      // CPU Interfaces
      .cpuRUN           (cpuRUN),
      .cpuHALT          (cpuHALT),
      .cpuEXEC          (cpuEXEC),
      .cpuCONT          (cpuCONT),
      // Console Interfaces
      .cslRUN           (cslRUN),
      .cslHALT          (cslHALT),
      .cslCONT          (cslCONT),
      .cslEXEC          (cslEXEC),
      .cslTIMEREN       (cslTIMEREN),
      .cslTRAPEN        (cslTRAPEN),
      .cslCACHEEN       (cslCACHEEN),
      .cslINTR          (cslINTR),
      .cslRESET         (cpuRST),
      // DUP11 Interface
      .dupTXE           (dupTXE),
      .dupRI            (dupRIO),
      .dupCTS           (dupCTSO),
      .dupDCD           (dupDCDO),
      .dupDSR           (dupDSRO),
      .dupTXFIFO        (dupTXFIFO),
      .dupRXF           (dupRXF),
      .dupDTR           (dupDTR),
      .dupRTS           (dupRTS),
      .dupH325          (dupH325),
      .dupW3            (dupW3),
      .dupW5            (dupW5),
      .dupW6            (dupW6),
      .dupRXFIFO        (dupRXFIFO),
      .dupTXFIFO_RD     (dupTXFIFO_RD),
      .dupRXFIFO_WR     (dupRXFIFO_WR),
      // DZ11 Interfaces
      .dzCO             (dzCO),
      .dzRI             (dzRI),
      // LP20/LP26 Interfaces
      .lpCONFIG         (lpCONFIG),
      .lpSIXLPI         (lpSIXLPI),
      .lpOVFU           (lpOVFU),
      .lpSETONLN        (lpSETONLN),
      .lpSETOFFLN       (lpSETOFFLN),
      .lpONLINE         (lpONLINE),
      // RPXX Interfaces
      .rpDPR            (rpDPR),
      .rpMOL            (rpMOL),
      .rpWRL            (rpWRL),
      // RH11 Interfaces
      .rhDEBUG          (rhDEBUG),
      // Debug Interface
      .debTRCMD         (debTRCMD),
      .debBRCMD         (debBRCMD),
      .debBRSTATE       (debBRSTATE),
      .debTRSTATE       (debTRSTATE),
      .debTRFULL        (debTRFULL),
      .debTREMPTY       (debTREMPTY),
      .debBAR           (debBAR),
      .debBMR           (debBMR),
      .debITR           (debITR),
      .debPCIR          (debPCIR),
      .debTRCMD_WR      (debTRCMD_WR),
      .debBRCMD_WR      (debBRCMD_WR),
      .debITR_RD        (debITR_RD)
   );

   //
   // Memory
   //

   MEM uMEM (
      .rst              (cpuRST),
      .cpuCLK           (cpuCLK),
      .memCLK           (memCLK),
      .clkPHS           (clkPHS),
      .busREQI          (memREQI),
      .busACKO          (memACKO),
      .busADDRI         (memADDRI),
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
      .busADDRI         (ubaADDRI[1]),
      .busADDRO         (ubaADDRO[1]),
      .busDATAI         (ubaDATAI[1]),
      .busDATAO         (ubaDATAO[1]),
      .busINTR          (ubaINTR[1]),
      // IO Bridge 1 Common
      .devRESET         (devRESET[1]),
      .devREQI          (devREQO[1]),
      .devREQO          (devREQI[1]),
      .devACKI          (devACKO[1]),
      .devACKO          (devACKI[1]),
      // IO Bridge 1, Device #1
      .dev1INTR         (devINTR[1][1]),
      .dev1INTA         (devINTA[1][1]),
      .dev1ADDRI        (devADDRO[1][1]),
      .dev1ADDRO        (devADDRI[1][1]),
      .dev1DATAI        (devDATAO[1][1]),
      .dev1DATAO        (devDATAI[1][1]),
      // IO Bridge 1, Device #2
      .dev2INTR         (devINTR[1][2]),
      .dev2INTA         (devINTA[1][2]),
      .dev2ADDRI        (devADDRO[1][2]),
      .dev2ADDRO        (devADDRI[1][2]),
      .dev2DATAI        (devDATAO[1][2]),
      .dev2DATAO        (devDATAI[1][2]),
      // IO Bridge 1, Device #3
      .dev3INTR         (devINTR[1][3]),
      .dev3INTA         (devINTA[1][3]),
      .dev3ADDRI        (devADDRO[1][3]),
      .dev3ADDRO        (devADDRI[1][3]),
      .dev3DATAI        (devDATAO[1][3]),
      .dev3DATAO        (devDATAI[1][3]),
      // IO Bridge 1, Device #4
      .dev4INTR         (devINTR[1][4]),
      .dev4INTA         (devINTA[1][4]),
      .dev4ADDRI        (devADDRO[1][4]),
      .dev4ADDRO        (devADDRI[1][4]),
      .dev4DATAI        (devDATAO[1][4]),
      .dev4DATAO        (devDATAI[1][4])
   );

   //
   // IO Bridge #3
   //

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
      .busADDRI         (ubaADDRI[3]),
      .busADDRO         (ubaADDRO[3]),
      .busDATAI         (ubaDATAI[3]),
      .busDATAO         (ubaDATAO[3]),
      .busINTR          (ubaINTR[3]),
      // IO Bridge 3 Common
      .devRESET         (devRESET[3]),
      .devREQI          (devREQO[3]),
      .devREQO          (devREQI[3]),
      .devACKI          (devACKO[3]),
      .devACKO          (devACKI[3]),
      // IO Bridge 3, Device #1
      .dev1INTR         (devINTR[3][1]),
      .dev1INTA         (devINTA[3][1]),
      .dev1ADDRI        (devADDRO[3][1]),
      .dev1ADDRO        (devADDRI[3][1]),
      .dev1DATAI        (devDATAO[3][1]),
      .dev1DATAO        (devDATAI[3][1]),
      // IO Bridge 3, Device #2
      .dev2INTR         (devINTR[3][2]),
      .dev2INTA         (devINTA[3][2]),
      .dev2ADDRI        (devADDRO[3][2]),
      .dev2ADDRO        (devADDRI[3][2]),
      .dev2DATAI        (devDATAO[3][2]),
      .dev2DATAO        (devDATAI[3][2]),
      // IO Bridge 3, Device #3
      .dev3INTR         (devINTR[3][3]),
      .dev3INTA         (devINTA[3][3]),
      .dev3ADDRI        (devADDRO[3][3]),
      .dev3ADDRO        (devADDRI[3][3]),
      .dev3DATAI        (devDATAO[3][3]),
      .dev3DATAO        (devDATAI[3][3]),
      // IO Bridge 3, Device #4
      .dev4INTR         (devINTR[3][4]),
      .dev4INTA         (devINTA[3][4]),
      .dev4ADDRI        (devADDRO[3][4]),
      .dev4ADDRO        (devADDRI[3][4]),
      .dev4DATAI        (devDATAO[3][4]),
      .dev4DATAO        (devDATAI[3][4])
   );

   //
   // RH11 #1 Connected to IO Bridge 1 Device 1
   //

   RH11 #(
      .rhDEV            (`rh1DEV),
      .rhADDR           (`rh1ADDR),
      .rhVECT           (`rh1VECT),
      .rhINTR           (`rh1INTR)
   )
   uRH11 (
      .rst              (cpuRST),
      .clk              (cpuCLK),
      // SD Interfaces
      .SD_MISO          (SD_MISO),
      .SD_MOSI          (SD_MOSI),
      .SD_SCLK          (SD_SCLK),
      .SD_SS_N          (SD_SS_N),
      // RH11 Interfaces
      .rhDEBUG          (rhDEBUG),
      // RPXX Interfaces
      .rpMOL            (rpMOL),
      .rpWRL            (rpWRL),
      .rpDPR            (rpDPR),
      .rpLEDS           (rpLEDS),
      // Device
      .devRESET         (devRESET[1]),
      .devINTR          (devINTR[1][1]),
      .devINTA          (devINTA[1][1]),
      .devREQI          (devREQI[1][1]),
      .devREQO          (devREQO[1][1]),
      .devACKI          (devACKI[1][1]),
      .devACKO          (devACKO[1][1]),
      .devADDRI         (devADDRI[1][1]),
      .devADDRO         (devADDRO[1][1]),
      .devDATAI         (devDATAI[1][1]),
      .devDATAO         (devDATAO[1][1])
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
      .dzTXD            (DZ_TXD),
      .dzRXD            (DZ_RXD),
      .dzCO             (dzCO),
      .dzRI             (dzRI),
      .dzDTR            (DZ_DTR),
      // Device
      .devRESET         (devRESET[3]),
      .devINTR          (devINTR[3][1]),
      .devINTA          (devINTA[3][1]),
      .devREQI          (devREQI[3][1]),
      .devREQO          (devREQO[3][1]),
      .devACKI          (devACKI[3][1]),
      .devACKO          (devACKO[3][1]),
      .devADDRI         (devADDRI[3][1]),
      .devADDRO         (devADDRO[3][1]),
      .devDATAI         (devDATAI[3][1]),
      .devDATAO         (devDATAO[3][1])
   );

   //
   // LP20 #1 is connected to IO Bridge 3 Device 2
   //

   LP20 #(
      .lpDEV            (`lp1DEV),
      .lpADDR           (`lp1ADDR),
      .lpVECT           (`lp1VECT),
      .lpINTR           (`lp1INTR)
   ) uLP20 (
      .clk              (cpuCLK),
      .rst              (cpuRST),
      // LP20 Configuration
      .lpOVFU           (lpOVFU),
      // Device Interface
      .devRESET         (devRESET[3]),
      .devINTR          (devINTR[3][2]),
      .devINTA          (devINTA[3][2]),
      .devREQI          (devREQI[3][2]),
      .devREQO          (devREQO[3][2]),
      .devACKI          (devACKI[3][2]),
      .devACKO          (devACKO[3][2]),
      .devADDRI         (devADDRI[3][2]),
      .devADDRO         (devADDRO[3][2]),
      .devDATAI         (devDATAI[3][2]),
      .devDATAO         (devDATAO[3][2]),
      // LP26 Interfaces
      .lpINIT           (lpINIT),
      .lpONLINE         (lpONLINE),
      .lpPARERR         (lpPARERR),
      .lpDEMAND         (lpDEMAND),
      .lpVFURDY         (lpVFURDY),
      .lpPI             (lpPI),
      .lpTOF            (lpTOF),
      .lpDATA           (lpDATA),
      .lpDPAR           (lpDPAR),
      .lpSTROBE         (lpSTROBE)
   );

   //
   // LP26 printer connected to the LP20 interface
   //

   LP26 uLP26 (
      .clk              (cpuCLK),
      .rst              (cpuRST),
      .lpINIT           (lpINIT),
      .lpSETONLN        (lpSETONLN),
      .lpSETOFFLN       (lpSETOFFLN),
      .lpCONFIG         (lpCONFIG),
      .lpOVFU           (lpOVFU),
      .lpRXD            (LP_RXD),
      .lpTXD            (LP_TXD),
      .lpSTROBE         (lpSTROBE),
      .lpDATA           (lpDATA),
      .lpDPAR           (lpDPAR),
      .lpPI             (lpPI),
      .lpTOF            (lpTOF),
      .lpPARERR         (lpPARERR),
      .lpONLINE         (lpONLINE),
      .lpVFURDY         (lpVFURDY),
      .lpSIXLPI         (lpSIXLPI),
      .lpDEMAND         (lpDEMAND)
   );

`ifdef DUP11

   //
   // DUP11 #1 is connected to IO Bridge 3 Device 3
   //

   DUP11 #(
      .dupDEV           (`dup1DEV),
      .dupADDR          (`dup1ADDR),
      .dupVECT          (`dup1VECT),
      .dupINTR          (`dup1INTR)
   ) uDUP11 (
      .clk              (cpuCLK),
      .rst              (cpuRST),
      // DUP Configuration
      .dupW3            (dupW3),
      .dupW5            (dupW5),
      .dupW6            (dupW6),
      // Device Interface
      .devRESET         (devRESET[3]),
      .devINTR          (devINTR[3][3]),
      .devINTA          (devINTA[3][3]),
      .devREQI          (devREQI[3][3]),
      .devREQO          (devREQO[3][3]),
      .devACKI          (devACKI[3][3]),
      .devACKO          (devACKO[3][3]),
      .devADDRI         (devADDRI[3][3]),
      .devADDRO         (devADDRO[3][3]),
      .devDATAI         (devDATAI[3][3]),
      .devDATAO         (devDATAO[3][3]),
      // DUP Interfaces
      .dupRI            (dupRI),
      .dupCTS           (dupCTS),
      .dupDCD           (dupDCD),
      .dupDSR           (dupDSR),
      .dupRTS           (dupRTS),
      .dupDTR           (dupDTR),
      .dupCLK           (dupCLK),
      .dupRXC           (dupRXC),
      .dupRXD           (dupRXD),
      .dupTXC           (dupTXC),
      .dupTXD           (dupTXD)
   );

`else

   //
   // IO Bridge #3, Device 3 is not connected. Tie inputs
   //

   assign devINTR[3][3] = 0;
   assign devREQO[3][3] = 0;
   assign devACKO[3][3] = 0;
   assign devADDRO[3][3] = 0;
   assign devDATAO[3][3] = 0;

`endif

   //
   // Debug Interface
   //

   DEBUG uDEBUG (
      .rst              (cpuRST),
      .clk              (cpuCLK),
      .cpuADDR          (cpuADDRO),
      .cpuPC            (cpuPC),
      .cpuHR            (cpuHR),
      .regsLOAD         (regsLOAD),
      .vmaLOAD          (vmaLOAD),
      .debBRCMD         (debBRCMD),
      .debBRSTATE       (debBRSTATE),
      .debTRCMD         (debTRCMD),
      .debTRSTATE       (debTRSTATE),
      .debTRFULL        (debTRFULL),
      .debTREMPTY       (debTREMPTY),
      .debBAR           (debBAR),
      .debBMR           (debBMR),
      .debITR           (debITR),
      .debPCIR          (debPCIR),
      .debBRCMD_WR      (debBRCMD_WR),
      .debTRCMD_WR      (debTRCMD_WR),
      .debITR_RD        (debITR_RD),
      .debugHALT        (debugHALT)
   );

   //
   // Console Interrupt fixup
   //

   assign conINTR_N = ~cslINTRO;

   //
   // Halt LED
   //

   assign haltLED = cpuHALT;

   //
   // Test
   //

   assign test = 0;

   //
   // IO Bridge #2 is not implemented. Tie inputs.
   //

   assign ubaREQO[2]  = 0;
   assign ubaACKO[2]  = 0;
   assign ubaADDRO[2] = 0;
   assign ubaDATAO[2] = 0;
   assign ubaINTR[2]  = 0;

   //
   // IO Bridge #4 is not implemented. Tie inputs.
   //

   assign ubaREQO[4]  = 0;
   assign ubaACKO[4]  = 0;
   assign ubaADDRO[4] = 0;
   assign ubaDATAO[4] = 0;
   assign ubaINTR[4]  = 0;

   //
   // IO Bridge #1, Device 2 is not implemented. Tie inputs
   //

   assign devINTR[1][2] = 0;
   assign devREQO[1][2] = 0;
   assign devACKO[1][2] = 0;
   assign devADDRO[1][2] = 0;
   assign devDATAO[1][2] = 0;

   //
   // IO Bridge #1, Device 3 is not implemented. Tie inputs
   //

   assign devINTR[1][3] = 0;
   assign devREQO[1][3] = 0;
   assign devACKO[1][3] = 0;
   assign devADDRO[1][3] = 0;
   assign devDATAO[1][3] = 0;

   //
   // IO Bridge #1, Device 4 is not implemented. Tie inputs
   //

   assign devINTR[1][4] = 0;
   assign devREQO[1][4] = 0;
   assign devACKO[1][4] = 0;
   assign devADDRO[1][4] = 0;
   assign devDATAO[1][4] = 0;

   //
   // IO Bridge #3, Device 4 is not implemented. Tie inputs
   //

   assign devINTR[3][4] = 0;
   assign devREQO[3][4] = 0;
   assign devACKO[3][4] = 0;
   assign devADDRO[3][4] = 0;
   assign devDATAO[3][4] = 0;

endmodule
