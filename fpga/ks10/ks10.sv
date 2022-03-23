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
//   ks10.sv
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
`include "ube/ube.vh"
`include "dup11/dup11.vh"
`include "dz11/dz11.vh"
`include "kmc11/kmc11.vh"
`include "rh11/rh11.vh"
`include "lp20/lp20.vh"

module KS10 (
      // Clock/Reset
      input  wire         memRST,       // Reset
      input  wire         memCLK,       // Memory Clock
      output wire         cpuCLK,       // CPU clock
      output wire         cpuRST,       // CPU reset
      // AXI4-Lite Interface
      input  wire [ 7: 0] axiAWADDR,    // AXI Write address
      input  wire         axiAWVALID,   // AXI Write address valid
      input  wire [ 2: 0] axiAWPROT,    // AXI Write protections
      output wire         axiAWREADY,   // AXI Write address ready
      input  wire [31: 0] axiWDATA,     // AXI Write data
      input  wire [ 3: 0] axiWSTRB,     // AXI Write data strobe
      input  wire         axiWVALID,    // AXI Write data valid
      output wire         axiWREADY,    // AXI Write data ready
      input  wire [ 7: 0] axiARADDR,    // AXI Read  address
      input  wire         axiARVALID,   // AXI Read  address valid
      input  wire [ 2: 0] axiARPROT,    // AXI Read  protections
      output wire         axiARREADY,   // AXI Read  address ready
      output wire [31: 0] axiRDATA,     // AXI Read  data
      output wire [ 1: 0] axiRRESP,     // AXI Read  data response
      output wire         axiRVALID,    // AXI Read  data valid
      input  wire         axiRREADY,    // AXI Read  data ready
      output wire [ 1: 0] axiBRESP,     // AXI Write response
      output wire         axiBVALID,    // AXI Write response valid
      input  wire         axiBREADY,    // AXI Write response ready
      // Front Panel
      input  wire         SW_RESET_N,   // Reset switch
      input  wire         SW_BOOT_N,    // Boot switch
      input  wire         SW_HALT_N,    // Halt switch
      output wire         LED_PWR_N,    // Power LED
      output wire         LED_RESET_N,  // Reset LED
      output wire         LED_BOOT_N,   // Boot LED
      output wire         LED_HALT_N,   // Halt LED
      input  wire         SPARE0,       // Spare 0
      input  wire         SPARE1,       // Spare 1
      input  wire         SPARE2,       // Spare 2
      // External SD Card
      output wire         ESD_SCLK,     // External SD serial clock
      input  wire         ESD_DI,       // External SD serial data in
      output wire         ESD_DO,       // External SD serial data out
      output wire         ESD_CS_N,     // External SD serial data chip select
      output wire         ESD_RST_N,    // External config reset
      output wire         ESD_RD_N,     // External config read
      output wire         ESD_WR_N,     // External config write
      output wire [ 4: 0] ESD_ADDR,     // External config address
      inout  wire         ESD_DIO,      // External config data inout
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
      // RP Interfaces
      output wire [ 7: 0] RP_LEDS,      // RP LEDs
      // SSRAM Interfaces
      output wire         SSRAM_CLK,    // SSRAM Clock
      output wire         SSRAM_WE_N,   // SSRAM WE#
      output wire         SSRAM_ADV,    // SSRAM Advance
`ifdef SSRAMx36
      output wire [19: 0] SSRAM_A,      // SSRAM Address Bus
      inout  wire [35: 0] SSRAM_D,      // SSRAM Data Bus
`else
      output wire [21: 0] SSRAM_A,      // SSRAM Address Bus
      inout  wire [17: 0] SSRAM_D,      // SSRAM Data Bus
`endif
`ifndef SYNTHESIS
      output wire [63: 0] mtDIRO,       // MT Data Interface Register for SIM
`endif
      // DE10-Nano Interfaces
      input  wire [ 1: 0] KEY,
      input  wire [ 3: 0] SW
   );

   //
   // Loop variable
   //

   genvar i;

   //
   // Clock generator
   //

`ifdef SYNTHESIS

   //
   // PLL Locked
   //

   wire [1:4] clkT;
   wire locked;

`ifdef XILINX

   //
   // The following code is Xilinx Spartan 6 specific.
   //

   wire clkfbout;
   wire clkfbout_buf;

   //
   // Phase locked loop.  PLL is 400 MHz
   //

   PLL_BASE #(
       .BANDWIDTH          ("OPTIMIZED"),
       .CLK_FEEDBACK       ("CLKFBOUT"),
       .COMPENSATION       ("SYSTEM_SYNCHRONOUS"),
       .DIVCLK_DIVIDE      (1),
       .CLKFBOUT_MULT      (8),
       .CLKFBOUT_PHASE     (0.000),
       .CLKOUT0_DIVIDE     (32),
       .CLKOUT0_PHASE      (0.000),
       .CLKOUT0_DUTY_CYCLE (0.500),
       .CLKOUT1_DIVIDE     (32),
       .CLKOUT1_PHASE      (90.000),
       .CLKOUT1_DUTY_CYCLE (0.500),
       .CLKOUT2_DIVIDE     (32),
       .CLKOUT2_PHASE      (180.000),
       .CLKOUT2_DUTY_CYCLE (0.500),
       .CLKOUT3_DIVIDE     (32),
       .CLKOUT3_PHASE      (270.000),
       .CLKOUT3_DUTY_CYCLE (0.500),
       .CLKIN_PERIOD       (20.0),
       .REF_JITTER         (0.010)
   )
   iPLL_BASE (
       .RST                (memRST),
       .CLKIN              (memCLK),
       .CLKFBIN            (clkfbout_buf),
       .CLKOUT0            (clkPHS[1]),
       .CLKOUT1            (clkPHS[2]),
       .CLKOUT2            (clkPHS[3]),
       .CLKOUT3            (clkPHS[4]),
       .CLKFBOUT           (clkfbout),
       .LOCKED             (locked)
   );

   //
   // Output clock buffers
   //

   BUFG bufgCLKF (
       .I                  (clkfbout),
       .O                  (clkfbout_buf)
   );

`else

   //
   // FIXME:
   //   The inputs should be clk and rst
   //
   //   The output should be:
   //   MEMCLK_P
   //   MEMCLK_N
   //   clkT1
   //   clkT2
   //   clkT3
   //   clkT4
   //

   altera_pll #(
      .fractional_vco_multiplier("false"),
      .reference_clock_frequency("50.0 MHz"),
      .operation_mode           ("direct"),
      .number_of_clocks         (4),
      .output_clock_frequency0  ("12.500000 MHz"),
      .phase_shift0             ("0 ps"),
      .duty_cycle0              (50),
      .output_clock_frequency1  ("12.500000 MHz"),
      .phase_shift1             ("20000 ps"),
      .duty_cycle1              (50),
      .output_clock_frequency2  ("12.500000 MHz"),
      .phase_shift2             ("40000 ps"),
      .duty_cycle2              (50),
      .output_clock_frequency3  ("12.500000 MHz"),
      .phase_shift3             ("60000 ps"),
      .duty_cycle3              (50),
      .pll_type                 ("General"),
      .pll_subtype              ("General")
    ) PLL (
      .rst                      (memRST),
      .outclk                   ({clkT[4], clkT[3], clkT[2], clkT[1]}),
      .locked                   (locked),
      .fboutclk                 (),
      .fbclk                    (1'b0),
      .refclk                   (memCLK)
    );

`endif

   //
   // Synchronize Reset
   //

   reg [2:0] d;
   always @(posedge clkT[1])
     begin
        if (memRST)
          d <= 3'b111;
        else
          d <= {d[1:0], !locked};
     end

   wire cslRST = d[2];

`else

   reg       cslRST;
   reg [1:4] clkT;
   localparam [1:4] t1 = 4'b1001,
                    t2 = 4'b1100,
                    t3 = 4'b0110,
                    t4 = 4'b0011;

   always @(posedge memCLK)
     begin
        if (memRST)
          begin
             clkT   <= t1;
             cslRST <= 1;
          end
        else
          case (clkT)
            t1: clkT <= t2;
            t2: clkT <= t3;
            t3: clkT <= t4;
            t4: begin
               clkT   <= t1;
               cslRST <= 0;
            end
          endcase
     end
`endif

   assign cpuCLK = clkT[1];

   //
   // Console Signals
   //

   wire         cslRUN;                 // Console Run Switch
   wire         cslHALT;                // Console Halt Switch
   wire         cslCONT;                // Console Continue Switch
   wire         cslEXEC;                // Console Exec Switch
   wire         cslTRAPEN;              // Console Trap Enable
   wire         cslTIMEREN;             // Console Timer Enable
   wire         cslCACHEEN;             // Console Cache Enable
   wire         cslINTR;                // Console Interrupt to KS10
   wire         cslINTRO;               // KS10 Interrupt to Console

   //
   // CPU Signals
   //

   wire [ 0:35] cpuADDRO;               // CPU Address Out (for breakpoints)
   wire         cpuHALT;                // CPU Halt Status
   wire         cpuRUN;                 // CPU Run Status
   wire         cpuEXEC;                // CPU Exec Status
   wire         cpuCONT;                // CPU Cont Status

   //
   // KMC11 Signals
   //

   wire [15: 0] kmcLUIBUS = 0;          // KMC11 Line Unit IBUS (tied for now)
   wire         kmcLUSTEP;              // KMC11 Line Unit Step
   wire         kmcLULOOP;              // KMC11 Line Unit Loop

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

   wire [ 0:31] lpCCR;                  // LP26 Console Control Register
   wire         lpSETOFFLN;             // LP26 set offline
   wire         lpONLINE;               // LP26 status
   wire         lpOVFU;                 // LP26 has optical vertical format unit
   wire [ 6:15] lpCONFIG;               // LP26 serial configuration
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
   // Device Interfaces
   //

   mtcslbus     mtCSLDATA();            // MT/CSL interface
   rpcslbus     rpCSLDATA();            // RP/CSL interface
   brcslbus     brCSLDATA();            // BR/CSL interface
   trcslbus     trCSLDATA();            // TR/CSL interface

   //
   // Backplane bus interfaces
   //

   ks10bus      cpuBUS();               // KS10 backplane bus
   ks10bus      cslBUS();               // KS10 backplane bus
   ks10bus      memBUS();               // KS10 backplane bus
   ks10bus      ubaBUS[1:4]();          // KS10 backplane bus

   //
   // Unibuses between UBA adapters and UBA devices (x20)
   //   Four unibuses for each of the four unibus adapters
   //   UBA2 is not implementable and is tied off.
   //

   unibus       unibus[1:4][1:5]();     // Unibus array

   //
   // Massbus interfaces
   //

   massbus massbusRP();                 // Massbus from RH11 to disk drives
   massbus massbusMT();                 // Massbus from RH11 to tape drives

   //
   // Debug Signals
   //

   wire [18:35] cpuPC;                  // Program Counter
   wire [ 0:35] cpuHR;                  // Instruction Register
   wire         regsLOAD;               // Update registers
   wire         vmaLOAD;                // Update VMA
   wire         brHALT;                 // Breakpoint the CPU

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
             dupCTS <= dupCTSO;
             dupDSR <= dupDSRO;
             dupDCD <= dupDCDO;
             dupRI  <= dupRIO;
             dupRXD <= dupTXD;
             dupRXC <= dupCLK;
             dupTXC <= dupCLK;
          end
     end

   //
   // Bus Arbiter
   //

   ARB uARB (
      .cpuBUS           (cpuBUS),
      .cslBUS           (cslBUS),
      .ubaBUS           (ubaBUS),
      .memBUS           (memBUS)
   );

   //
   // The KS10 CPU
   //

   CPU uCPU (
      .rst              (cpuRST),
      .clk              (cpuCLK),
      .clkT             (clkT),
      // CPU
      .cpuBUS           (cpuBUS),
      .cpuADDRO         (cpuADDRO),
      .cpuHALT          (cpuHALT),
      .cpuRUN           (cpuRUN),
      .cpuEXEC          (cpuEXEC),
      .cpuCONT          (cpuCONT),
      .cpuPC            (cpuPC),
      .cpuHR            (cpuHR),
      // Breakpoint
      .brHALT           (brHALT),
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
      // Trace
      .regsLOAD         (regsLOAD),
      .vmaLOAD          (vmaLOAD)
   );

   //
   // Console
   //

   CSL uCSL (
      .rst              (cslRST),
      .clk              (cpuCLK),
      // AXI Interface to ARM Core
      .axiAWADDR        (axiAWADDR),
      .axiAWVALID       (axiAWVALID),
      .axiAWPROT        (axiAWPROT),
      .axiAWREADY       (axiAWREADY),
      .axiWDATA         (axiWDATA),
      .axiWSTRB         (axiWSTRB),
      .axiWVALID        (axiWVALID),
      .axiWREADY        (axiWREADY),
      .axiARADDR        (axiARADDR),
      .axiARVALID       (axiARVALID),
      .axiARPROT        (axiARPROT),
      .axiARREADY       (axiARREADY),
      .axiRDATA         (axiRDATA),
      .axiRRESP         (axiRRESP),
      .axiRVALID        (axiRVALID),
      .axiRREADY        (axiRREADY),
      .axiBRESP         (axiBRESP),
      .axiBVALID        (axiBVALID),
      .axiBREADY        (axiBREADY),
      // Bus Interfaces
      .cslBUS           (cslBUS),
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
      .lpSETOFFLN       (lpSETOFFLN),
      .lpONLINE         (lpONLINE),
      .mtDATA           (mtCSLDATA),
      .rpDATA           (rpCSLDATA),
      .brDATA           (brCSLDATA),
      .trDATA           (trCSLDATA)
   );

   //
   // Memory
   //

   MEM uMEM (
      .rst              (memRST),
      .memCLK           (memCLK),
      .clkT             (clkT),
      .memBUS           (memBUS),
      .SSRAM_CLK        (SSRAM_CLK),
      .SSRAM_WE_N       (SSRAM_WE_N),
      .SSRAM_A          (SSRAM_A),
      .SSRAM_D          (SSRAM_D),
      .SSRAM_ADV        (SSRAM_ADV)
   );

   //
   // Breakpoint Interface
   //

   BRKPT uBRKPT (
     .brDATA           (brCSLDATA),
     .cpuADDR          (cpuADDRO),
     .brHALT           (brHALT)
   );

   //
   // Trace Interface
   //

   TRACE uTRACE (
     .trDATA           (trCSLDATA),
     .cpuPC            (cpuPC),
     .cpuHR            (cpuHR),
     .regsLOAD         (regsLOAD)
   );

   //
   // Debug Interface
   //

   DEBUG uDEBUG (
      .rst              (cpuRST),
      .clk              (cpuCLK),
      .cpuPC            (cpuPC),
      .cpuHR            (cpuHR),
      .regsLOAD         (regsLOAD),
      .vmaLOAD          (vmaLOAD)
   );

`ifdef UBA1

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
      .ks10bus          (ubaBUS[1]),
      .unibus           (unibus[1])
   );

`ifdef RH11A

   //
   // RH11 #1 Connected to IO Bridge 1 Device 1
   //

   RH11 #(
      .rhDEV            (`rh1DEV),
      .rhADDR           (`rh1ADDR),
      .rhVECT           (`rh1VECT),
      .rhINTR           (`rh1INTR)
   )
   uRH11A (
      .unibus           (unibus[1][1]),
      .massbus          (massbusRP)
   );

   //
   // RP Disk Drives slaved to the RH11
   //

   RP uRP (
      .massbus          (massbusRP),
      .rpCSLDATA        (rpCSLDATA),
      .rpLEDS           (RP_LEDS),
      // SD Card Interface
      .SD_MISO          (SD_MISO),
      .SD_MOSI          (SD_MOSI),
      .SD_SCLK          (SD_SCLK),
      .SD_SS_N          (SD_SS_N)
   );

`else

   //
   // IO Bridge #1, Device 1 is not implemented. Tie inputs
   //

   assign unibus[1][1].devINTRO = 0;
   assign unibus[1][1].devACLO  = 0;
   assign unibus[1][1].devREQO  = 0;
   assign unibus[1][1].devACKO  = 0;
   assign unibus[1][1].devADDRO = 0;
   assign unibus[1][1].devDATAO = 0;

`endif

   //
   // IO Bridge #1, Device 2 is not implemented. Tie inputs
   //

   assign unibus[1][2].devINTRO = 0;
   assign unibus[1][2].devACLO  = 0;
   assign unibus[1][2].devREQO  = 0;
   assign unibus[1][2].devACKO  = 0;
   assign unibus[1][2].devADDRO = 0;
   assign unibus[1][2].devDATAO = 0;

   //
   // IO Bridge #1, Device 3 is not implemented. Tie inputs
   //

   assign unibus[1][3].devINTRO = 0;
   assign unibus[1][3].devACLO  = 0;
   assign unibus[1][3].devREQO  = 0;
   assign unibus[1][3].devACKO  = 0;
   assign unibus[1][3].devADDRO = 0;
   assign unibus[1][3].devDATAO = 0;

   //
   // IO Bridge #1, Device 4 is not implemented. Tie inputs
   //

   assign unibus[1][4].devINTRO = 0;
   assign unibus[1][4].devACLO  = 0;
   assign unibus[1][4].devREQO  = 0;
   assign unibus[1][4].devACKO  = 0;
   assign unibus[1][4].devADDRO = 0;
   assign unibus[1][4].devDATAO = 0;

   //
   // IO Bridge #1, Device 5 is not implemented. Tie inputs
   //

   assign unibus[1][5].devINTRO = 0;
   assign unibus[1][5].devACLO  = 0;
   assign unibus[1][5].devREQO  = 0;
   assign unibus[1][5].devACKO  = 0;
   assign unibus[1][5].devADDRO = 0;
   assign unibus[1][5].devDATAO = 0;

`else

   //
   // IO Bridge #1 is not implemented. Tie inputs.
   //

   assign ubaBUS[1].busREQO  = 0;
   assign ubaBUS[1].busACKO  = 0;
   assign ubaBUS[1].busADDRO = 0;
   assign ubaBUS[1].busDATAO = 0;
   assign ubaBUS[1].busINTRO = 0;

   generate
      for (i = 1; i <= 5; i++)
        begin : loop1
           assign unibus[1][i].clk      = 0;
           assign unibus[1][i].rst      = 0;
           assign unibus[1][i].devRESET = 0;
           assign unibus[1][i].devACLO  = 0;
           assign unibus[1][i].devREQO  = 0;
           assign unibus[1][i].devACKO  = 0;
           assign unibus[1][i].devADDRO = 0;
           assign unibus[1][i].devDATAO = 0;
           assign unibus[1][i].devINTRO = 0;
           assign unibus[1][i].devREQI  = 0;
           assign unibus[1][i].devACKI  = 0;
           assign unibus[1][i].devADDRI = 0;
           assign unibus[1][i].devDATAI = 0;
        end
   endgenerate

`endif

   //
   // IO Brige #2
   //

`ifdef UBA2

   //
   // IO Bridge #2 is not implemented. Tie inputs.
   //

   assign ubaBUS[2].busREQO  = 0;
   assign ubaBUS[2].busACKO  = 0;
   assign ubaBUS[2].busADDRO = 0;
   assign ubaBUS[2].busDATAO = 0;
   assign ubaBUS[2].busINTRO = 0;

   generate
      for (i = 1; i <= 5; i++)
        begin : loop2
           assign unibus[2][i].clk      = 0;
           assign unibus[2][i].rst      = 0;
           assign unibus[2][i].devRESET = 0;
           assign unibus[2][i].devACLO  = 0;
           assign unibus[2][i].devREQO  = 0;
           assign unibus[2][i].devACKO  = 0;
           assign unibus[2][i].devADDRO = 0;
           assign unibus[2][i].devDATAO = 0;
           assign unibus[2][i].devINTRO = 0;
           assign unibus[2][i].devREQI  = 0;
           assign unibus[2][i].devACKI  = 0;
           assign unibus[2][i].devADDRI = 0;
           assign unibus[2][i].devDATAI = 0;
        end
   endgenerate

`else

   //
   // IO Bridge #2 is not implemented. Tie inputs.
   //

   assign ubaBUS[2].busREQO  = 0;
   assign ubaBUS[2].busACKO  = 0;
   assign ubaBUS[2].busADDRO = 0;
   assign ubaBUS[2].busDATAO = 0;
   assign ubaBUS[2].busINTRO = 0;

   generate
      for (i = 1; i <= 5; i++)
        begin : loop2
           assign unibus[2][i].clk      = 0;
           assign unibus[2][i].rst      = 0;
           assign unibus[2][i].devRESET = 0;
           assign unibus[2][i].devACLO  = 0;
           assign unibus[2][i].devREQO  = 0;
           assign unibus[2][i].devACKO  = 0;
           assign unibus[2][i].devADDRO = 0;
           assign unibus[2][i].devDATAO = 0;
           assign unibus[2][i].devINTRO = 0;
           assign unibus[2][i].devREQI  = 0;
           assign unibus[2][i].devACKI  = 0;
           assign unibus[2][i].devADDRI = 0;
           assign unibus[2][i].devDATAI = 0;
       end
   endgenerate

`endif

`ifdef UBA3

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
      .ks10bus          (ubaBUS[3]),
      .unibus           (unibus[3])
   );

   //
   // DZ11 #1 Connected to IO Bridge 3 Device 1
   //

`ifdef DZ11

   DZ11 #(
      .dzDEV            (`dz1DEV),
      .dzADDR           (`dz1ADDR),
      .dzVECT           (`dz1VECT),
      .dzINTR           (`dz1INTR)
   )
   uDZ11 (
      .unibus           (unibus[3][1]),
      .dzTXD            (DZ_TXD),
      .dzRXD            (DZ_RXD),
      .dzCO             (dzCO),
      .dzRI             (dzRI),
      .dzDTR            (DZ_DTR)
   );

`else

   //
   // IO Bridge #3, Device 1 is not connected. Tie inputs
   //

   assign unibus[3][1].devINTRO = 0;
   assign unibus[3][1].devACLO  = 0;
   assign unibus[3][1].devREQO  = 0;
   assign unibus[3][1].devACKO  = 0;
   assign unibus[3][1].devADDRO = 0;
   assign unibus[3][1].devDATAO = 0;
   assign DZ_TXD = 0;
   assign DZ_DTR = 0;

`endif

   //
   // LP20 #1 is connected to IO Bridge 3 Device 2
   //

`ifdef LP20

   LP20 #(
      .lpDEV            (`lp1DEV),
      .lpADDR           (`lp1ADDR),
      .lpVECT           (`lp1VECT),
      .lpINTR           (`lp1INTR)
   ) uLP20 (
      .unibus           (unibus[3][2]),
      // LP20/LP26 Interface
      .lpOVFU           (lpOVFU),
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
      .lpSETOFFLN       (lpSETOFFLN),
      .lpVFURDY         (lpVFURDY),
      .lpSIXLPI         (lpSIXLPI),
      .lpDEMAND         (lpDEMAND)
   );

`else

   //
   // IO Bridge #3, Device 2 is not connected. Tie inputs
   //

   assign unibus[3][2].devINTRO = 0;
   assign unibus[3][2].devACLO  = 0;
   assign unibus[3][2].devREQO  = 0;
   assign unibus[3][2].devACKO  = 0;
   assign unibus[3][2].devADDRO = 0;
   assign unibus[3][2].devDATAO = 0;
   assign LP_TXD                = 0;
   assign lpSETOFFLN            = 0;
   assign lpSIXLPI              = 0;

`endif

   //
   // DUP11 #1 is connected to IO Bridge 3 Device 3
   //

`ifdef DUP11

   DUP11 #(
      .dupDEV           (`dup1DEV),
      .dupADDR          (`dup1ADDR),
      .dupVECT          (`dup1VECT),
      .dupINTR          (`dup1INTR)
   ) uDUP11 (
      .unibus           (unibus[3][3]),
      // DUP Interfaces
      .dupW3            (dupW3),
      .dupW5            (dupW5),
      .dupW6            (dupW6),
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

   assign unibus[3][3].devINTRO = 0;
   assign unibus[3][3].devACLO  = 0;
   assign unibus[3][3].devREQO  = 0;
   assign unibus[3][3].devACKO  = 0;
   assign unibus[3][3].devADDRO = 0;
   assign unibus[3][3].devDATAO = 0;

`endif


   //
   // KMC11 #1 is connected to IO Bridge 3 Device 4
   //

`ifdef KMC11

   KMC11 #(
      .kmcDEV           (`kmcDEV),
      .kmcADDR          (`kmcADDR),
      .kmcVECT          (`kmcVECT),
      .kmcINTR          (`kmcINTR)
   ) uKMC11 (
      .unibus           (unibus[3][4]),
      .kmcLUIBUS        (kmcLUIBUS),
      .kmcLUSTEP        (kmcLUSTEP),
      .kmcLULOOP        (kmcLULOOP)
   );

`else

   //
   // IO Bridge #3, Device 4 is not connected. Tie inputs
   //

   assign unibus[3][4].devINTRO = 0;
   assign unibus[3][4].devACLO  = 0;
   assign unibus[3][4].devREQO  = 0;
   assign unibus[3][4].devACKO  = 0;
   assign unibus[3][4].devADDRO = 0;
   assign unibus[3][4].devDATAO = 0;

`endif

`ifdef RH11B

   //
   // RH11 #2 is connected to IO Bridge 3 Device 5
   //

   RH11 #(
      .rhDEV            (`rh3DEV),
      .rhADDR           (`rh3ADDR),
      .rhVECT           (`rh3VECT),
      .rhINTR           (`rh3INTR)
   )
   uRH11B (
      .unibus           (unibus[3][5]),
      .massbus          (massbusMT)
   );

   //
   // MT Tape Drives slaved to the RH11
   //

   MT uMT (
      .massbus          (massbusMT),
      .mtCSLDATA        (mtCSLDATA)
   );

`else

   //
   // IO Bridge #3, Device 5 is not connected. Tie inputs
   //

   assign unibus[3][5].devINTRO = 0;
   assign unibus[3][5].devACLO  = 0;
   assign unibus[3][5].devREQO  = 0;
   assign unibus[3][5].devACKO  = 0;
   assign unibus[3][5].devADDRO = 0;
   assign unibus[3][5].devDATAO = 0;

`endif

`else

   //
   // IO Bridge #3 is not implemented. Tie inputs.
   //

   assign ubaBUS[3].busREQO  = 0;
   assign ubaBUS[3].busACKO  = 0;
   assign ubaBUS[3].busADDRO = 0;
   assign ubaBUS[3].busDATAO = 0;
   assign ubaBUS[3].busINTRO = 0;

   generate
      for (i = 1; i <= 5; i++)
        begin : loop3
           assign unibus[3][i].clk      = 0;
           assign unibus[3][i].rst      = 0;
           assign unibus[3][i].devRESET = 0;
           assign unibus[3][i].devACLO  = 0;
           assign unibus[3][i].devREQO  = 0;
           assign unibus[3][i].devACKO  = 0;
           assign unibus[3][i].devADDRO = 0;
           assign unibus[3][i].devDATAO = 0;
           assign unibus[3][i].devINTRO = 0;
           assign unibus[3][i].devREQI  = 0;
           assign unibus[3][i].devACKI  = 0;
           assign unibus[3][i].devADDRI = 0;
           assign unibus[3][i].devDATAI = 0;
        end
   endgenerate

`endif

   //
   // IO Bridge #4
   //

`ifdef UBA4

   UBA #(
      .ubaNUM           (`devUBA4),
      .ubaADDR          (`ubaADDR)
   )
   UBA4 (
      .rst              (cpuRST),
      .clk              (cpuCLK),
      .ks10bus          (ubaBUS[4]),
      .unibus           (unibus[4])
   );

   //
   // UBE1 is connected to UBA4
   //

`ifdef UBE1

   UBE #(
      .ubeDEV           (`ube1DEV),
      .ubeVECT          (`ube1VECT),
      .ubeADDR          (`ube1ADDR)
   )
   uUBE1 (
      .unibus           (unibus[4][1])
   );

`else

   //
   // IO Bridge #4, Device 1 is not implemented. Tie inputs
   //

   assign unibus[4][1].devINTRO = 0;
   assign unibus[4][1].devACLO  = 0;
   assign unibus[4][1].devREQO  = 0;
   assign unibus[4][1].devACKO  = 0;
   assign unibus[4][1].devADDRO = 0;
   assign unibus[4][1].devDATAO = 0;

`endif

   //
   // UBE2 is connected to UBA4
   //

`ifdef UBE2

   UBE #(
      .ubeDEV           (`ube2DEV),
      .ubeVECT          (`ube2VECT),
      .ubeADDR          (`ube2ADDR)
   )
   uUBE2 (
      .unibus           (unibus[4][2])
   );

`else

   //
   // IO Bridge #4, Device 2 is not implemented. Tie inputs
   //

   assign unibus[4][2].devINTRO = 0;
   assign unibus[4][2].devACLO  = 0;
   assign unibus[4][2].devREQO  = 0;
   assign unibus[4][2].devACKO  = 0;
   assign unibus[4][2].devADDRO = 0;
   assign unibus[4][2].devDATAO = 0;

`endif

   //
   // UBE3 is connected to UBA4
   //

`ifdef UBE3

   UBE #(
      .ubeDEV           (`ube3DEV),
      .ubeVECT          (`ube3VECT),
      .ubeADDR          (`ube3ADDR)
   )
   uUBE3 (
      .unibus           (unibus[4][3])
   );

`else

   //
   // IO Bridge #4, Device 3 is not implemented. Tie inputs
   //

   assign unibus[4][3].devINTRO = 0;
   assign unibus[4][3].devACLO  = 0;
   assign unibus[4][3].devREQO  = 0;
   assign unibus[4][3].devACKO  = 0;
   assign unibus[4][3].devADDRO = 0;
   assign unibus[4][3].devDATAO = 0;

`endif

   //
   // UBE4 is connected to UBA4
   //

`ifdef UBE4

   UBE #(
      .ubeDEV           (`ube4DEV),
      .ubeVECT          (`ube4VECT),
      .ubeADDR          (`ube4ADDR)
   )
   uUBE4 (
      .unibus           (unibus[4][4])
   );

`else

   //
   // IO Bridge #4, Device 4 is not implemented. Tie inputs
   //

   assign unibus[4][4].devINTRO = 0;
   assign unibus[4][4].devACLO  = 0;
   assign unibus[4][4].devREQO  = 0;
   assign unibus[4][4].devACKO  = 0;
   assign unibus[4][4].devADDRO = 0;
   assign unibus[4][4].devDATAO = 0;

`endif

`ifdef UBE5

   UBE #(
      .ubeDEV           (`ube5DEV),
      .ubeVECT          (`ube5VECT),
      .ubeADDR          (`ube5ADDR)
   )
   uUBE5 (
      .unibus           (unibus[4][5])
   );

`else

   //
   // IO Bridge #4, Device 5 is not implemented. Tie inputs
   //

   assign unibus[4][5].devINTRO = 0;
   assign unibus[4][5].devACLO  = 0;
   assign unibus[4][5].devREQO  = 0;
   assign unibus[4][5].devACKO  = 0;
   assign unibus[4][5].devADDRO = 0;
   assign unibus[4][5].devDATAO = 0;

`endif

`else

   //
   // IO Bridge #4 is not implemented. Tie inputs.
   //

   assign ubaBUS[4].busREQO  = 0;
   assign ubaBUS[4].busACKO  = 0;
   assign ubaBUS[4].busADDRO = 0;
   assign ubaBUS[4].busDATAO = 0;
   assign ubaBUS[4].busINTRO = 0;

   generate
      for (i = 1; i <= 5; i++)
        begin : loop4
           assign unibus[4][i].clk      = 0;
           assign unibus[4][i].rst      = 0;
           assign unibus[4][i].devRESET = 0;
           assign unibus[4][i].devACLO  = 0;
           assign unibus[4][i].devREQO  = 0;
           assign unibus[4][i].devACKO  = 0;
           assign unibus[4][i].devADDRO = 0;
           assign unibus[4][i].devDATAO = 0;
           assign unibus[4][i].devINTRO = 0;
           assign unibus[4][i].devREQI  = 0;
           assign unibus[4][i].devACKI  = 0;
           assign unibus[4][i].devADDRI = 0;
           assign unibus[4][i].devDATAI = 0;
        end
   endgenerate

`endif

   //
   // LEDs
   //

   assign LED_HALT_N  = !cpuHALT;
   assign LED_PWR_N   = 0;
   assign LED_RESET_N = SW_RESET_N;
   assign LED_BOOT_N  = SW_BOOT_N;

   //
   // External SD Array Interface
   //  Not implemented
   //

   assign ESD_SCLK  = 0;
   assign ESD_DO    = 0;
   assign ESD_DIO   = 0;
   assign ESD_RST_N = 1;
   assign ESD_RD_N  = 1;
   assign ESD_WR_N  = 1;
   assign ESD_CS_N  = 1;
   assign ESD_ADDR  = 0;

`ifndef SYNTHESIS
   assign mtDIRO = mtCSLDATA.mtDIRO;
`endif

endmodule
