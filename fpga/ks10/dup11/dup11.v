////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DUP11 Bit Synchronous Interface
//
// Details
//   The information used to design the DUP was obtained from the following
//   DEC docmument:
//
//   "DUP11 Bit Synchronous Interface Mantenance Manual", EK-DUP11_MM-003
//
// Notes
//   Regarding endian-ness:
//
//   The KS10 backplane bus is 36-bit big-endian and uses [0:35] notation.
//   The IO Device are 36-bit little-endian (after Unibus) and uses [35:0]
//   notation.
//
//   Whereas the 'Unibus' is 18-bit data and 16-bit address, I've implemented
//   the IO bus as 36-bit address and 36-bit data just to keep things simple.
//
// File
//   dup11.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2018 Rob Doyle
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

`include "dup11.vh"
`include "duprxcsr.vh"
`include "duprxdbuf.vh"
`include "duptxcsr.vh"
`include "duptxdbuf.vh"
`include "dupparcsr.vh"

`include "../ks10.vh"
`include "../uba/ubabus.vh"

module DUP11 (
      input  wire         clk,                          // Clock
      input  wire         rst,                          // Reset
      // DUP Configuration
      input  wire         dupW3,                        // Configuration Wire 3
      input  wire         dupW5,                        // Configuration Wire 3
      input  wire         dupW6,                        // Configuration Wire 3
      // Device Interface
      input  wire         devRESET,                     // IO Bus Bridge Reset
      output wire [ 7: 4] devINTR,                      // Interrupt Request
      input  wire [ 7: 4] devINTA,                      // Interrupt Acknowledge
      input  wire         devREQI,                      // Device Request In
      output wire         devREQO,                      // Device Request Out
      input  wire         devACKI,                      // Device Acknowledge In
      output wire         devACKO,                      // Device Acknowledge Out
      input  wire [ 0:35] devADDRI,                     // Device Address In
      output wire [ 0:35] devADDRO,                     // Device Address Out
      input  wire [ 0:35] devDATAI,                     // Device Data In
      output reg  [ 0:35] devDATAO,                     // Device Data Out
      // DUP11 Interfaces
      input  wire         dupRI,                        // Ring Indication
      input  wire         dupCTS,                       // Clear To Send
      input  wire         dupDCD,                       // Data Carrier Detect
      input  wire         dupDSR,                       // Data Set Ready
      output wire         dupRTS,                       // Request to Send
      output wire         dupDTR,                       // Data Terminal Ready
      output wire         dupCLK,                       // Test Clock
      input  wire         dupRXC,                       // Receiver Clock
      input  wire         dupRXD,                       // Receiver Data
      input  wire         dupTXC,                       // Transmitter Clock
      output wire         dupTXD                        // Transmitter Data
   );

`ifndef SYNTHESIS

   integer file;

`endif

   //
   // DUP Parameters
   //

   parameter [14:17] dupDEV  = `dup1DEV;                // DUP11 Device Number
   parameter [18:35] dupADDR = `dup1ADDR;               // DUP11 Base Address
   parameter [18:35] dupVECT = `dup1VECT;               // DUP11 Interrupt Vector
   parameter [ 7: 4] dupINTR = `dup1INTR;               // DUP11 Interrupt

   //
   // DUP Register Addresses
   //

   localparam [18:35] rxcsrADDR  = dupADDR + `rxcsrOFFSET;      // RXCSR Register
   localparam [18:35] rxdbufADDR = dupADDR + `rxdbufOFFSET;     // RXDBUF Register
   localparam [18:35] parcsrADDR = dupADDR + `parcsrOFFSET;     // PARCSR Register
   localparam [18:35] txcsrADDR  = dupADDR + `txcsrOFFSET;      // TXCSR Register
   localparam [18:35] txdbufADDR = dupADDR + `txdbufOFFSET;     // TXDBUF Register

   //
   // Device Address and Flags
   //

   wire         devREAD   = `devREAD(devADDRI);         // Read Cycle
   wire         devWRITE  = `devWRITE(devADDRI);        // Write Cycle
   wire         devPHYS   = `devPHYS(devADDRI);         // Physical reference
   wire         devIO     = `devIO(devADDRI);           // IO Cycle
   wire         devWRU    = `devWRU(devADDRI);          // WRU Cycle
   wire         devVECT   = `devVECT(devADDRI);         // Read interrupt vector
   wire         devIOBYTE = `devIOBYTE(devADDRI);       // Byte IO Operation
   wire [14:17] devDEV    = `devDEV(devADDRI);          // Device Number
   wire [18:34] devADDR   = `devADDR(devADDRI);         // Device Address
   wire         devHIBYTE = `devHIBYTE(devADDRI);       // Device High Byte
   wire         devLOBYTE = `devLOBYTE(devADDRI);       // Device Low Byte

   //
   // DUP Interrupt Vectors
   //

   localparam [18:35] dupRXVECT = dupVECT;              // DUP11 RX Interrupt Vector
   localparam [18:35] dupTXVECT = dupVECT + 4;          // DUP11 TX Interrupt Vector

   //
   // Address Decoding
   //

   wire vectREAD    = devREAD  & devIO & devPHYS & !devWRU &  devVECT & (devDEV == dupDEV);
   wire rxcsrREAD   = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == dupDEV) & (devADDR == rxcsrADDR [18:34]);
   wire rxcsrWRITE  = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == dupDEV) & (devADDR == rxcsrADDR [18:34]);
   wire rxdbufREAD  = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == dupDEV) & (devADDR == rxdbufADDR[18:34]);
   wire parcsrWRITE = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == dupDEV) & (devADDR == parcsrADDR[18:34]);
   wire txcsrREAD   = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == dupDEV) & (devADDR == txcsrADDR [18:34]);
   wire txcsrWRITE  = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == dupDEV) & (devADDR == txcsrADDR [18:34]);
   wire txdbufREAD  = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == dupDEV) & (devADDR == txdbufADDR[18:34]);
   wire txdbufWRITE = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == dupDEV) & (devADDR == txdbufADDR[18:34]);

   //
   // Big-endian to little-endian data bus swap
   //

   wire [35: 0] dupDATAI = devDATAI[0:35];

   //
   // RXCSR Register
   //

   wire [15: 0] regRXCSR;

   wire dupDSCA   = `dupRXCSR_DSCA(regRXCSR);
   wire dupSTRSYN = `dupRXCSR_STRSYN(regRXCSR);
   wire dupRXIE   = `dupRXCSR_RXIE(regRXCSR);
   wire dupDSCIE  = `dupRXCSR_DSCIE(regRXCSR);
   wire dupRXEN   = `dupRXCSR_RXEN(regRXCSR);

   //
   // RXDBUF Register
   //

   wire [15: 0] regRXDBUF;

   //
   // PARCSR Register
   //

   wire [15: 0] regPARCSR;
   wire         dupDECMD  = `dupPARCSR_DECMD(regPARCSR);
   wire         dupSSM    = `dupPARCSR_SSM(regPARCSR);
   wire         dupCRCI   = `dupPARCSR_CRCI(regPARCSR);
   wire [ 7: 0] dupSYNADR = `dupPARCSR_SYNADR(regPARCSR);

   //
   // TXCSR Register
   //

   wire [15: 0] regTXCSR;
   wire         dupMCO  =   `dupTXCSR_MCO(regTXCSR);
   wire [12:11] dupMSEL =   `dupTXCSR_MSEL(regTXCSR);
   wire         dupMDI  =   `dupTXCSR_MDI(regTXCSR);
   wire         dupINIT =   `dupTXCSR_INIT(regTXCSR);
   wire         dupTXIE =   `dupTXCSR_TXIE(regTXCSR);
   wire         dupSEND =   `dupTXCSR_SEND(regTXCSR);

   //
   // TXDBUF Register
   //

   wire [15: 0] regTXDBUF;
   wire         dupTXABRT = `dupTXDBUF_TXABRT(regTXDBUF);
   wire         dupTXEOM  = `dupTXDBUF_TXEOM(regTXDBUF);
   wire         dupTXSOM  = `dupTXDBUF_TXSOM(regTXDBUF);
   wire [ 7: 0] dupTXDAT  = `dupTXDBUF_TXDAT(regTXDBUF);

   //
   // Misc signals
   //

   wire dupRXDONE;                      // RXCSR[RXDONE]
   wire dupRXACT;                       // RXCSR[RXACT]
   wire dupRXCRC;                       // TXDBUF[RXCRC]
   wire dupTXCRC;                       // TXDBUF[TXCRC]
   wire dupMNTT;                        // TXDBUF[MNTT]
   wire dupTXDONE;                      // TXCSR[TXDONE]
   wire dupTXACT;                       // TXCSR[TXACT]
   wire dupMDO;                         // TXCSR[MDO]
   wire dupTXDLE;                       // TXCSR[TXDLE]

   //
   // RXCSR
   //
   // Receiver Control and Status Register
   //

   DUPRXCSR RXCSR (
      .clk          (clk),
      .rst          (rst),
      .devLOBYTE    (devLOBYTE),
      .devHIBYTE    (devHIBYTE),
      .rxdbufREAD   (rxdbufREAD),
      .rxcsrREAD    (rxcsrREAD),
      .rxcsrWRITE   (rxcsrWRITE),
      .dupDATAI     (dupDATAI),
      .dupW3        (dupW3),
      .dupW5        (dupW5),
      .dupW6        (dupW6),
      .dupRI        (dupRI),
      .dupCTS       (dupCTS),
      .dupDCD       (dupDCD),
      .dupDSR       (dupDSR),
      .dupRTS       (dupRTS),
      .dupDTR       (dupDTR),
      .dupINIT      (dupINIT),
      .dupRXACT     (dupRXACT),
      .dupRXDONE    (dupRXDONE),
      .regRXCSR     (regRXCSR)
   );

   //
   // PARCSR
   //
   // Parameter Control and Status Register
   //

   DUPPARCSR PARCSR (
      .clk          (clk),
      .rst          (rst),
      .devLOBYTE    (devLOBYTE),
      .devHIBYTE    (devHIBYTE),
      .parcsrWRITE  (parcsrWRITE),
      .dupINIT      (dupINIT),
      .dupDATAI     (dupDATAI),
      .regPARCSR    (regPARCSR)
   );

   //
   // TXCSR
   //
   // Transmitter Control and Status Register
   //

   DUPTXCSR TXCSR (
      .clk          (clk),
      .rst          (rst),
      .devRESET     (devRESET),
      .devLOBYTE    (devLOBYTE),
      .devHIBYTE    (devHIBYTE),
      .txdbufWRITE  (txdbufWRITE),
      .txcsrWRITE   (txcsrWRITE),
      .dupDATAI     (dupDATAI),
      .dupMDO       (dupMDO),
      .dupTXDLE     (dupTXDLE),
      .dupTXACT     (dupTXACT),
      .dupTXDONE    (dupTXDONE),
      .regTXCSR     (regTXCSR)
   );

   //
   // TXCSR
   //
   // Transmitter Data Buffer
   //

   DUPTXDBUF TXDBUF (
      .clk          (clk),
      .rst          (rst),
      .devLOBYTE    (devLOBYTE),
      .devHIBYTE    (devHIBYTE),
      .txdbufWRITE  (txdbufWRITE),
      .dupINIT      (dupINIT),
      .dupDATAI     (dupDATAI),
      .dupRXCRC     (dupRXCRC),
      .dupTXCRC     (dupTXCRC),
      .dupMNTT      (dupMNTT),
      .regTXDBUF    (regTXDBUF)
   );

   //
   // DUPCLK
   //
   // Transmitter and Receiver Clock Generator
   //

   wire dupRXCEN;
   wire dupTXCEN;

   DUPCLK uDUPCLK (
      .clk          (clk),
      .rst          (rst),
      .dupMSEL      (dupMSEL),
      .dupMCO       (dupMCO),
      .dupMNTT      (dupMNTT),
      .dupCLK       (dupCLK),
      .dupRXC       (dupRXC),
      .dupTXC       (dupTXC),
      .dupRXCEN     (dupRXCEN),
      .dupTXCEN     (dupTXCEN)
   );

   //
   // DUPTX
   //
   // Transmitter State Machine
   //

   DUPTX uDUPTX (
      .clk          (clk),
      .rst          (rst),
      .dupINIT      (dupINIT),
      .dupDECMD     (dupDECMD),
      .dupCRCI      (dupCRCI),
      .dupMSEL      (dupMSEL),
      .dupSEND      (dupSEND),
      .dupTXABRT    (dupTXABRT),
      .dupTXEOM     (dupTXEOM),
      .dupTXSOM     (dupTXSOM),
      .dupTXDAT     (dupTXDAT),
      .dupTXCEN     (dupTXCEN),
      .dupRXCEN     (dupRXCEN),
      .dupTXDBUFWR  (txdbufWRITE & devLOBYTE),
      .dupTXDONE    (dupTXDONE),
      .dupMDO       (dupMDO),
      .dupTXCRC     (dupTXCRC),
      .dupTXDLE     (dupTXDLE),
      .dupTXACT     (dupTXACT),
      .dupTXD       (dupTXD)
   );

   //
   // DUPRX
   //
   // Receiver State Machine
   //

   DUPRX uDUPRX (
      .clk          (clk),
      .rst          (rst),
      .devLOBYTE    (devLOBYTE),
      .rxdbufREAD   (rxdbufREAD),
      .dupINIT      (dupINIT),
      .dupMSEL      (dupMSEL),
      .dupRXEN      (dupRXEN),
      .dupMDI       (dupMDI),
      .dupRXCEN     (dupRXCEN),
      .dupTXCEN     (dupTXCEN),
      .dupTXD       (dupTXD),
      .dupRXD       (dupRXD),
      .dupRXDONE    (dupRXDONE),
      .dupRXACT     (dupRXACT),
      .dupRXCRC     (dupRXCRC),
      .regRXCSR     (regRXCSR),
      .regPARCSR    (regPARCSR),
      .regRXDBUF    (regRXDBUF)
   );

   //
   // RXINTR
   //
   // Receiver Interrupt Controller
   //
   // The receiver interrupt has priority over the transmitter interrupt.
   //

   wire dupRXINTR;
   wire dupPRIACT;
   DUPINTR uRXINTR (
      .clk        (clk),
      .rst        (rst),
      .init       (dupINIT),
      .vect       (vectREAD),
      .statrw     (rxcsrREAD | rxdbufREAD),
      .trig       ((dupRXIE & dupRXDONE) | (dupDSCIE & dupDSCA)),
      .secinh     (1'b0),
      .priact     (dupPRIACT),
      .intr       (dupRXINTR)
   );

   //
   // TXINTR
   //
   // Transmitter Interrupt Controller
   //

   wire dupTXINTR;
   DUPINTR uTXINTR (
      .clk        (clk),
      .rst        (rst),
      .init       (dupINIT),
      .vect       (vectREAD),
      .statrw     (txdbufWRITE),
      .trig       (dupTXIE & dupTXDONE),
      .secinh     (dupPRIACT),
      .priact     (),
      .intr       (dupTXINTR)
   );

   //
   // Interrupt Request
   //

   assign devINTR = dupTXINTR | dupRXINTR ? dupINTR : 4'b0;

   //
   // Generate Bus ACK
   //

   assign devACKO = (rxcsrREAD  | rxcsrWRITE  |
                     rxdbufREAD | parcsrWRITE |
                     txcsrREAD  | txcsrWRITE  |
                     txdbufREAD | txdbufWRITE |
                     vectREAD);

   //
   // Bus Mux and little-endian to big-endian bus swap
   //

   always @*
     begin
        devDATAO = 0;
        if (rxcsrREAD)
          devDATAO = {20'b0, regRXCSR};
        if (rxdbufREAD)
          devDATAO = {20'b0, regRXDBUF};
        if (txcsrREAD)
          devDATAO = {20'b0, regTXCSR};
        if (txdbufREAD)
          devDATAO = {20'b0, regTXDBUF};
        if (vectREAD)
          devDATAO = {20'b0, dupRXINTR ? dupRXVECT : dupTXVECT};
     end

`ifndef SYNTHESIS

   //
   // String sizes in bytes
   //

   localparam DEVNAME_SZ = 5,
              REGNAME_SZ = 6;

   //
   // Initialize log file
   //

   initial
     begin
        file = $fopen("dupstatus.txt", "w");
        $fwrite(file, "[%11.3f] DUP11: Initialized.\n", $time/1.0e3);
        $fflush(file);
     end

   //
   // Read RXCSR
   //

   PRINT_DEV_REG_ON_RD #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) RXCSR_RD (
       .clk             (clk),
       .devRD           (rxcsrREAD),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .regVAL          (regRXCSR),
       .devNAME         ("DUP11"),
       .regNAME         ("RXCSR "),
       .file            (file)
   );

   //
   // Read RXDBUF
   //

   PRINT_DEV_REG_ON_RD #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) RXDBUF_RD (
       .clk             (clk),
       .devRD           (rxdbufREAD),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .regVAL          (regRXDBUF),
       .devNAME         ("DUP11"),
       .regNAME         ("RXDBUF"),
       .file            (file)
   );

   //
   // Read TXCSR
   //

   PRINT_DEV_REG_ON_RD #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) TXCSR_RD (
       .clk             (clk),
       .devRD           (txcsrREAD),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .regVAL          (regTXCSR),
       .devNAME         ("DUP11"),
       .regNAME         ("TXCSR "),
       .file            (file)
   );

   //
   // Read TXDBUF
   //

   PRINT_DEV_REG_ON_RD #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) TXDBUF_RD (
       .clk             (clk),
       .devRD           (txdbufREAD),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .regVAL          (regTXDBUF),
       .devNAME         ("DUP11"),
       .regNAME         ("TXDBUF"),
       .file            (file)
   );

   //
   // Write RXCSR
   //

   PRINT_DEV_REG_ON_WR #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) RXCSR_WR (
       .clk             (clk),
       .devWR           (rxcsrWRITE),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .devDATA         (dupDATAI[15:0]),
       .regVAL          (regRXCSR),
       .devNAME         ("DUP11"),
       .regNAME         ("RXCSR "),
       .file            (file)
   );

   //
   // Write PARCSR
   //

   PRINT_DEV_REG_ON_WR #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) PARCSR_WR (
       .clk             (clk),
       .devWR           (parcsrWRITE),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .devDATA         (dupDATAI[15:0]),
       .regVAL          (regPARCSR),
       .devNAME         ("DUP11"),
       .regNAME         ("PARCSR"),
       .file            (file)
   );

   //
   // Write TXCSR
   //

   PRINT_DEV_REG_ON_WR #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) TXCSR_WR (
       .clk             (clk),
       .devWR           (txcsrWRITE),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .devDATA         (dupDATAI[15:0]),
       .regVAL          (regTXCSR),
       .devNAME         ("DUP11"),
       .regNAME         ("TXCSR "),
       .file            (file)
   );

   //
   // Write TXDBUF
   //

   PRINT_DEV_REG_ON_WR #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) TXDBUF_WR (
       .clk             (clk),
       .devWR           (txdbufWRITE),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .devDATA         (dupDATAI[15:0]),
       .regVAL          (regTXDBUF),
       .devNAME         ("DUP11"),
       .regNAME         ("TXDBUF"),
       .file            (file)
   );

`endif

endmodule
