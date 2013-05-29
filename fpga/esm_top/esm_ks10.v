////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KS10 Wrapper for the ESM Reference Design.
//
// Details
//   This wrapper allows the KS10 CPU Core to be customized for
//   various FPGA Evaluation Board.  In this implmentation, the
//   Console Interface and the Memory Interface can be customized.
//
//   The Console Interface is pretty generic.   The Console
//   Implementation can range from a Microcontroller Interface like
//   the KS10 to a simple front panel with switches and lights like
//   the KA10 and KI10.
//
// File
//   esm_ks10.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2012-2013 Rob Doyle
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

`default_nettype none

module ESM_KS10(CLK50MHZ, RESET_N,
                // DZ11 Interfaces
                TXD1, TXD2, RXD1, RXD2, RTS1, RTS2, CTS1, CTS2,
                // RH11 Interfaces
                rh11CD, rh11WP, rh11MISO, rh11MOSI, rh11SCLK, rh11CS,
                // Console Interfaces
                cslCLK, cslALE, cslAD, cslRD_N, cslWR_N, cslINTR_N,
                // SSRAM Interfaces
                ssramCLK, ssramCLKEN, ssramADV, ssramBWA_N, ssramBWB_N,
                ssramBWC_N, ssramBWD_N, ssramOE_N, ssramWE_N, ssramCE,
                ssramADDR, ssramDATA, runLED);

   input         CLK50MHZ;      // Clock
   input         RESET_N;       // Reset
   // DZ11 Interfaces
   input         TXD1;          // DZ11 RS-232 Transmitted Data #1
   input         TXD2;          // DZ11 RS-232 Transmitted Data #2
   output        RXD1;          // DZ11 RS-232 Received Data #1
   output        RXD2;          // DZ11 RS-232 Received Data #2
   input         RTS1;          // DZ11 RS-232 Request to Send #1
   input         RTS2;          // DZ11 RS-232 Request to Send #2
   output        CTS1;          // DZ11 RS-232 Clear to Send #1
   output        CTS2;          // DZ11 RS-232 Clear to Send #2
   // RH11 Interfaces
   input         rh11CD;        // RH11 Card Detect
   input         rh11WP;        // RH11 Write Protect
   input         rh11MISO;      // RH11 Data In
   output        rh11MOSI;      // RH11 Data Out
   output        rh11SCLK;      // RH11 Clock
   output        rh11CS;        // RH11 Chip Select
   // Console Interfaces
   input         cslCLK;        // Console Clock
   input         cslALE;        // Console Address Latch Enable
   inout  [7: 0] cslAD;         // Console Multiplexed Address/Data Bus
   input         cslRD_N;       // Console Read Strobe
   input         cslWR_N;       // Console Write Strobe
   output        cslINTR_N;     // Console Interrupt
   // SSRAM Interfaces
   output        ssramCLK;      // SSRAM Clock
   output        ssramCLKEN;    // SSRAM Clken
   output        ssramADV;      // SSRAM Advance
   output        ssramBWA_N;    // SSRAM BWA#
   output        ssramBWB_N;    // SSRAM BWB#
   output        ssramBWC_N;    // SSRAM BWC#
   output        ssramBWD_N;    // SSRAM BWD#
   output        ssramOE_N;     // SSRAM OE#
   output        ssramWE_N;     // SSRAM WE#
   output        ssramCE;       // SSRAM CE
   output [0:22] ssramADDR;     // SSRAM Address Bus
   inout  [0:35] ssramDATA;     // SSRAM Data Bus
   // Misc
   output        runLED;        // RUN LED

   //
   // DZ-11 Interface Stubs
   //

   wire [7: 0] dz11CO = 8'hff;  // DZ11 Carrier Input
   wire [7: 0] dz11RI = 8'h00;  // DZ11 Ring Input
   wire [7: 0] dz11DTR;         // DZ11 DTR Output
   wire [7: 0] dz11TXD;         // DZ11 TXD
   wire [7: 0] dz11RXD;         // DZ11 RXD

   //
   // Console Interfaces
   //

   wire [0:35] cslREGADDR;      // Console Address Register
   wire [0:35] cslREGDATI;      // Console Data Register In
   wire [0:35] cslREGDATO;      // Console Data Register Out
   wire [0:35] cslREGIR;        // Console Instruction Register
   wire        cslSTEP;         // Console Single Step Switch
   wire        cslCONT;         // Console Continue Switch
   wire        cslRUN;          // Console Run Switch
   wire        cslEXEC;         // Console Exec Switch
   wire        cslHALT;         // Console Halt Switch
   wire        cslTRAPEN;       // Console Trap Enable
   wire        cslTIMEREN;      // Console Timer Enable
   wire        cslCACHEEN;      // Console Cache Enable
   wire        cslINTRI;        // Console Interrupt In
   wire        cslINTRO;        // Console Interrupt Out
   wire        cslRESET;        // Console Reset
   wire        cslBUSY;         // Console Busy
   wire        cslGO;           // Console GO
   wire        cslNXM;          // Console NXM

   //
   // KS10 Outputs
   //

   wire        cpuHALT;         // CPU Halt
   wire        cpuRUN;          // CPU Run
   wire        cpuEXEC;         // CPU Exec
   wire        cpuCONT;         // CPU Cont

   //
   // RH11 Outputs
   //

   wire [0:35] rh11DEBUG;

   //
   // KS10 Processor
   //

   KS10 uKS10
     (.clk              (CLK50MHZ),
      .rst              (~RESET_N),
      // DZ11
      .dz11TXD          (dz11TXD),
      .dz11RXD          (dz11RXD),
      .dz11DTR          (dz11DTR),
      .dz11CO           (dz11CO),
      .dz11RI           (dz11RI),
      // RH11
      .rh11CD           (rh11CD),
      .rh11WP           (rh11WP),
      .rh11MISO         (rh11MISO),
      .rh11MOSI         (rh11MOSI),
      .rh11SCLK         (rh11SCLK),
      .rh11CS           (rh11CS),
      .rh11DEBUG        (rh11DEBUG),
      // Console
      .cslREGADDR       (cslREGADDR),
      .cslREGDATI       (cslREGDATI),
      .cslREGDATO       (cslREGDATO),
      .cslREGIR         (cslREGIR),
      .cslBUSY          (cslBUSY),
      .cslNXM           (cslNXM),
      .cslGO            (cslGO),
      .cslRESET         (cslRESET),
      .cslSTEP          (cslSTEP),
      .cslRUN           (cslRUN),
      .cslEXEC          (cslEXEC),
      .cslCONT          (cslCONT),
      .cslHALT          (cslHALT),
      .cslTIMEREN       (cslTIMEREN),
      .cslTRAPEN        (cslTRAPEN),
      .cslCACHEEN       (cslCACHEEN),
      .cslINTRI         (cslINTRI),
      .cslINTRO         (cslINTRO),
      // CPU
      .cpuHALT          (cpuHALT),
      .cpuRUN           (cpuRUN),
      .cpuEXEC          (cpuEXEC),
      .cpuCONT          (cpuCONT),
      // Memory
      .ssramCLK         (ssramCLK),
      .ssramCLKEN       (ssramCLKEN),
      .ssramADV         (ssramADV),
      .ssramBWA_N       (ssramBWA_N),
      .ssramBWB_N       (ssramBWB_N),
      .ssramBWC_N       (ssramBWC_N),
      .ssramBWD_N       (ssramBWD_N),
      .ssramOE_N        (ssramOE_N),
      .ssramWE_N        (ssramWE_N),
      .ssramCE          (ssramCE),
      .ssramADDR        (ssramADDR),
      .ssramDATA        (ssramDATA)
      );

   //
   // Console Wrapper
   //

   ESMCSL uESMCSL
     (.RESET_N          (RESET_N),
      .clk              (CLK50MHZ),
      .cslCLK           (cslCLK),
      .cslALE           (cslALE),
      .cslAD            (cslAD),
      .cslRD_N          (cslRD_N),
      .cslWR_N          (cslWR_N),
      .cslREGADDR       (cslREGADDR),
      .cslREGDATI       (cslREGDATO),
      .cslREGDATO       (cslREGDATI),
      .cslREGIR         (cslREGIR),
      .cslBUSY          (cslBUSY),
      .cslNXM           (cslNXM),
      .cslGO            (cslGO),
      .cslSTEP          (cslSTEP),
      .cslRUN           (cslRUN),
      .cslEXEC          (cslEXEC),
      .cslCONT          (cslCONT),
      .cslHALT          (cslHALT),
      .cslTIMEREN       (cslTIMEREN),
      .cslTRAPEN        (cslTRAPEN),
      .cslCACHEEN       (cslCACHEEN),
      .cslINTRO         (cslINTRO),
      .cslRESET         (cslRESET),
      .rh11DEBUG        (rh11DEBUG),
      .cpuHALT          (cpuHALT),
      .cpuRUN           (cpuRUN),
      .cpuEXEC          (cpuEXEC),
      .cpuCONT          (cpuCONT)
      );

   //
   // DZ11 Fixup
   //  TXD is an output of the FT4232.  RXD is an input to the
   //  FT4232.  Therefore must twist TXD and RXD here.
   //

   assign dz11RXD[1]   = TXD2;
   assign dz11RXD[0]   = TXD1;

   assign RXD2         = dz11TXD[1];
   assign RXD1         = dz11TXD[0];

   assign dz11RXD[7:2] = dz11TXD[7:2];
   assign CTS2         = RTS2;
   assign CTS1         = RTS1;

   //
   // KS10 Interrupt fixup
   //

   assign cslINTR_N    = ~cslINTRI;

   //
   // Run LED
   //

   assign runLED       = cpuRUN;

endmodule
