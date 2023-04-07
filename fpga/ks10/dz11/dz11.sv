////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DZ11 Asynchronous Terminal Multiplexer
//
// Details
//   The information used to design the DZ11 was obtained from the following
//   DEC docmument:
//
//   "DZ11 Asynchronous Multiplexer Technical Manual" DEC Publication
//   EK-DZ110-TM-002
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
//   dz11.sv
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2023 Rob Doyle
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

`include "dz11.vh"
`include "dzcsr.vh"
`include "dztcr.vh"
`include "dztdr.vh"
`include "../uba/ubabus.vh"

  module DZ11 (
      unibus.device       unibus,                       // Unibus connection
      output wire [ 7: 0] dzTXD,                        // DZ11 Transmitter Serial Data
      input  wire [ 7: 0] dzRXD,                        // DZ11 Receiver Serial Data
      input  wire [ 7: 0] dzCO,                         // DZ11 Carrier Detect
      input  wire [ 7: 0] dzRI,                         // DZ11 Ring Indicator
      output wire [ 7: 0] dzDTR                         // DZ11 Data Terminal Ready
   );

   //
   // Bus Interface
   //

   logic  clk;                                          // Clock
   logic  rst;                                          // Reset
   logic  devRESET;                                     // Device Reset
   assign clk = unibus.clk;                             // Clock
   assign rst = unibus.rst;                             // Reset
   assign devRESET = unibus.devRESET;                   // Device Reset

   //
   // DZ Parameters
   //

   parameter [14:17] dzDEV  = `dz1DEV;                  // DZ11 Device Number
   parameter [18:35] dzADDR = `dz1ADDR;                 // DZ11 Base Address
   parameter [18:35] dzVECT = `dz1VECT;                 // DZ11 Interrupt Vector
   parameter [ 7: 4] dzINTR = `dz1INTR;                 // DZ11 Interrupt

   //
   // DZ Register Addresses
   //

   localparam [18:35] csrADDR = dzADDR + `csrOFFSET;    // CSR Register
   localparam [18:35] rbfADDR = dzADDR + `rbfOFFSET;    // RBF Register
   localparam [18:35] lprADDR = dzADDR + `lprOFFSET;    // LPR Register
   localparam [18:35] tcrADDR = dzADDR + `tcrOFFSET;    // TCR Register
   localparam [18:35] msrADDR = dzADDR + `msrOFFSET;    // MSR Register
   localparam [18:35] tdrADDR = dzADDR + `tdrOFFSET;    // TDR Register

   //
   // DZ Interrupt Vectors
   //

   localparam [18:35] rxVECT = dzVECT;                  // DZ11 RX Interrupt Vector
   localparam [18:35] txVECT = dzVECT + 18'd4;          // DZ11 TX Interrupt Vector

   //
   // Device Address and Flags
   //

   wire         devREAD   = `devREAD(unibus.devADDRI);  // Read Cycle
   wire         devWRITE  = `devWRITE(unibus.devADDRI); // Write Cycle
   wire         devPHYS   = `devPHYS(unibus.devADDRI);  // Physical reference
   wire         devIO     = `devIO(unibus.devADDRI);    // IO Cycle
   wire         devWRU    = `devWRU(unibus.devADDRI);   // WRU Cycle
   wire         devVECT   = `devVECT(unibus.devADDRI);  // Read interrupt vector
   wire [14:17] devDEV    = `devDEV(unibus.devADDRI);   // Device Number
   wire [18:35] devADDR   = `devADDR(unibus.devADDRI);  // Device Address
   wire         devHIBYTE = `devHIBYTE(unibus.devADDRI);// Device High Byte
   wire         devLOBYTE = `devLOBYTE(unibus.devADDRI);// Device Low Byte

   //
   // Read/Write Decoding
   //

   wire dzREAD   = /*FIXME: unibus.devREQI & */devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == dzDEV);
   wire dzWRITE  = /*FIXME: unibus.devREQI & */devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == dzDEV);
   wire vectREAD = /*FIXME: unibus.devREQI & */devREAD  & devIO & devPHYS & !devWRU &  devVECT & (devDEV == dzDEV);

   //
   // Address Decoding
   //

   wire csrREAD  = dzREAD  & (devADDR == csrADDR);
   wire csrWRITE = dzWRITE & (devADDR == csrADDR);
   wire rbufREAD = dzREAD  & (devADDR == rbfADDR);
   wire lprWRITE = dzWRITE & (devADDR == lprADDR);
   wire tcrREAD  = dzREAD  & (devADDR == tcrADDR);
   wire tcrWRITE = dzWRITE & (devADDR == tcrADDR);
   wire msrREAD  = dzREAD  & (devADDR == msrADDR);
   wire tdrWRITE = dzWRITE & (devADDR == tdrADDR);

   //
   // Big-endian to little-endian data bus swap
   //

   wire [35:0] dzDATAI = unibus.devDATAI[0:35];

   //
   // Interrupt Acknowledge
   //

   wire dzIACK = vectREAD;

   //
   // DZ11 Registers
   //

   logic [15:0] regCSR;
   logic [15:0] regMSR;
   logic [15:0] regTCR;
   logic [15:0] regTDR;
   logic [15:0] regRBUF;

   //
   // UART Array Registers
   //

   logic        rbufRDONE;
   logic        rbufSA;
   logic        tdrTRDY;
   logic [ 2:0] tdrTLINE;
   logic [ 7:0] uartTXEMPTY;
   logic [ 7:0] uartTXLOAD;
   logic [ 7:0] uartRXFULL;
   logic [ 7:0] uartRXDATA[7:0];
   logic [ 7:0] uartRXCLR;
   logic [ 7:0] uartRXFRME;
   logic [ 7:0] uartRXPARE;

   //
   // Control/Status Register Decode
   //

   wire        csrCLR   = `dzCSR_CLR(regCSR);
   wire        csrTIE   = `dzCSR_TIE(regCSR);
   wire        csrRIE   = `dzCSR_RIE(regCSR);
   wire        csrMSE   = `dzCSR_MSE(regCSR);
   wire        csrSA    = `dzCSR_SA(regCSR);
   wire        csrSAE   = `dzCSR_SAE(regCSR);
   wire        csrMAINT = `dzCSR_MAINT(regCSR);
   wire        csrRDONE = `dzCSR_RDONE(regCSR);
// wire [ 2:0] csrTLINE = `dzCSR_TLINE(regCSR);
   wire        csrTRDY  = `dzCSR_TRDY(regCSR);
   wire [ 7:0] tcrLIN   = `dzTCR_LIN(regTCR);

   wire [ 7:0] uartTXDATA = `dzTDR_TBUF(regTDR);
   wire [ 7:0] tdrBRK     = `dzTDR_BRK (regTDR);

   wire        dzINIT = devRESET | csrCLR;

   //
   // Control/Status Register (CSR)
   //

   DZCSR CSR (
      .clk        (clk),
      .rst        (rst),
      .devRESET   (devRESET),
      .devLOBYTE  (devLOBYTE),
      .devHIBYTE  (devHIBYTE),
      .dzDATAI    (dzDATAI),
      .csrWRITE   (csrWRITE),
      .rbufRDONE  (rbufRDONE),
      .rbufSA     (rbufSA),
      .tdrTRDY    (tdrTRDY),
      .tdrTLINE   (tdrTLINE),
      .regCSR     (regCSR)
   );

   //
   // Transmit Control Register (TCR)
   //

   DZTCR TCR (
      .clk        (clk),
      .rst        (rst),
      .devRESET   (devRESET),
      .devLOBYTE  (devLOBYTE),
      .devHIBYTE  (devHIBYTE),
      .dzDATAI    (dzDATAI),
      .csrCLR     (csrCLR),
      .tcrWRITE   (tcrWRITE),
      .regTCR     (regTCR)
   );

   assign dzDTR = `dzTCR_DTR(regTCR);

   //
   // Modem Status Register (MSR)
   //

   DZMSR MSR (
      .clk        (clk),
      .rst        (rst),
      .dzCO       (dzCO),
      .dzRI       (dzRI),
      .regMSR     (regMSR)
   );

   //
   // Maintenance Loopback
   //
   // Details:
   //  When CSR[MAINT] is asserted, the transmitters are looped back to the
   //  receivers.
   //

   logic [7:0] uartRXD;
   logic [7:0] uartTXD;

   assign uartRXD = csrMAINT ? dzTXD[7:0] : dzRXD[7:0];

   //
   // Generate an array of eight UARTS and 8 Baud Rate Generators
   //
   // Trace (BRGS)
   //  M7819/S11/E53
   //  M7819/S11/E54
   //  M7819/S11/E55
   //  M7819/S11/E56
   //
   // Trace (UARTS)
   //  M7819/S12/E44
   //  M7819/S12/E45
   //  M7819/S12/E46
   //  M7819/S12/E47
   //  M7819/S12/E48
   //  M7819/S12/E49
   //  M7819/S12/E50
   //  M7819/S12/E51
   //

   generate

      genvar  i;

      for (i = 0; i < 8; i = i + 1)

        begin : UART

           DZUART UART (
              .clk      (clk),
              .rst      (rst),
              .clr      (dzINIT),
              .num      (i[2:0]),
              .lprWRITE (lprWRITE),
              .dzDATAI  (dzDATAI),
              .rxd      (uartRXD[i]),
              .rxclr    (uartRXCLR[i]),
              .rxfull   (uartRXFULL[i]),
              .rxdata   (uartRXDATA[i]),
              .rxpare   (uartRXPARE[i]),
              .rxfrme   (uartRXFRME[i]),
              .txd      (uartTXD[i]),
              .txempty  (uartTXEMPTY[i]),
              .txload   (uartTXLOAD[i]),
              .txdata   (uartTXDATA)
           );

        end

   endgenerate

   //
   // Transmitter Data Register (TDR)
   //

   DZTDR TDR (
      .clk        (clk),
      .rst        (rst),
      .devRESET   (devRESET),
      .devLOBYTE  (devLOBYTE),
      .devHIBYTE  (devHIBYTE),
      .dzDATAI    (dzDATAI),
      .tdrWRITE   (tdrWRITE),
      .uartTXLOAD (uartTXLOAD),
      .uartTXEMPTY(uartTXEMPTY),
      .csrCLR     (csrCLR),
      .csrMSE     (csrMSE),
      .tcrLIN     (tcrLIN),
      .tdrTLINE   (tdrTLINE),
      .tdrTRDY    (tdrTRDY),
      .regTDR     (regTDR)
   );

   //
   // Receiver Buffer Register (RBUF)
   //

   DZRBUF RBUF (
      .clk        (clk),
      .rst        (rst),
      .clr        (dzINIT),
      .csrMSE     (csrMSE),
      .csrSAE     (csrSAE),
      .uartRXFRME (uartRXFRME),
      .uartRXPARE (uartRXPARE),
      .uartRXDATA (uartRXDATA),
      .uartRXFULL (uartRXFULL),
      .uartRXCLR  (uartRXCLR),
      .rbufREAD   (rbufREAD),
      .rbufRDONE  (rbufRDONE),
      .rbufSA     (rbufSA),
      .regRBUF    (regRBUF)
   );

   //
   // Interrupts
   //
   // Details:
   //  This module generates the transmitter and receiver interrupts
   //
   // Notes:
   //  The receiver interrupt is generated when:
   //  1. csr[RDONE] asserted when csr[SAE] is negated, or
   //  2. csr[SA] asserted.
   //
   //  The transmitter interrupt is generated when:
   //  1.  CSR[TRDY] is asserted when CSR[TIE] is asserted.
   //

   logic txINTR;
   logic rxINTR;
   logic rxVECTOR;

   DZINTR INTR (
      .clk        (clk),
      .rst        (rst),
      .clr        (dzINIT),
      .dzIACK     (dzIACK),
      .rxVECTOR   (rxVECTOR),
      .csrRIE     (csrRIE),
      .csrRRDY    (csrSAE ? csrSA : csrRDONE),
      .rbufREAD   (rbufREAD),
      .rxINTR     (rxINTR),
      .csrTIE     (csrTIE),
      .csrTRDY    (csrTRDY),
      .tdrWRITE   (tdrWRITE),
      .txINTR     (txINTR)
   );

   //
   // Generate Bus ACK
   //

   assign unibus.devACKO = (csrREAD  | csrWRITE |
                            rbufREAD | lprWRITE |
                            tcrREAD  | tcrWRITE |
                            msrREAD  | tdrWRITE |
                            vectREAD);

   //
   // Bus Mux and little-endian to big-endian bus swap.
   //
   // Trace
   //  M7819/S7/E19
   //  M7819/S7/E20
   //  M7819/S7/E30
   //  M7819/S7/E31
   //  M7819/S7/E32
   //  M7819/S7/E33
   //  M7819/S7/E38
   //  M7819/S7/E39
   //  M7819/S7/E40
   //  M7819/S7/E41
   //

   always_comb
     begin
        unibus.devDATAO = 0;
        if (csrREAD)
          unibus.devDATAO = {20'b0, regCSR};
        if (rbufREAD)
          unibus.devDATAO = {20'b0, regRBUF};
        if (tcrREAD)
          unibus.devDATAO = {20'b0, regTCR};
        if (msrREAD)
          unibus.devDATAO = {20'b0, regMSR};
        if (vectREAD)
          if (rxVECTOR)
            unibus.devDATAO = {20'b0, rxVECT[20:35]};
          else
            unibus.devDATAO = {20'b0, txVECT[20:35]};
     end

   //
   // Serial output data
   //  While a BRK bit is set, the associated line transmits zeros continuously.
   //
   // Trace:
   //  M7819/S5/E7
   //  M7819/S5/E8
   //  M7819/S5/E9
   //

   assign dzTXD = uartTXD & ~tdrBRK;

   //
   // Interrupt output
   //

   assign unibus.devINTRO = (rxINTR | txINTR) ? dzINTR : 4'b0;

   //
   // Bus Interface
   //

   assign unibus.devACLO  = 0;                          // Power fail (not implemented)
   assign unibus.devREQO  = 0;                          // Request out (DZ11 is not an initiator)
   assign unibus.devADDRO = 0;                          // Address out (DZ11 is not an initiator)

`ifndef SYNTHESIS

   //
   // String sizes in bytes
   //

   localparam DEVNAME_SZ = 4,
              REGNAME_SZ = 4;

   //
   // Initialize log file
   //

   integer file;

   initial
     begin
        file = $fopen("dzstatus.txt", "w");
        $fwrite(file, "[%11.3f] DZ11: Initialized.\n", $time/1.0e3);
        $fflush(file);
     end

   //
   // Read CSR
   //

   PRINT_DEV_REG_ON_RD #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) CSR_RD (
       .clk             (clk),
       .devRD           (csrREAD),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .regVAL          (regCSR),
       .devNAME         ("DZ11"),
       .regNAME         ("CSR "),
       .file            (file)
   );

   //
   // Read RBUF
   //

   PRINT_DEV_REG_ON_RD #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) RBUF_RD (
       .clk             (clk),
       .devRD           (rbufREAD),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .regVAL          (regRBUF),
       .devNAME         ("DZ11"),
       .regNAME         ("RBUF"),
       .file            (file)
   );

   //
   // Read TCR
   //

   PRINT_DEV_REG_ON_RD #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) TCR_RD (
       .clk             (clk),
       .devRD           (tcrREAD),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .regVAL          (regTCR),
       .devNAME         ("DZ11"),
       .regNAME         ("TCR "),
       .file            (file)
   );

   //
   // Read MSR
   //

   PRINT_DEV_REG_ON_RD #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) MSR_RD (
       .clk             (clk),
       .devRD           (msrREAD),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .regVAL          (regMSR),
       .devNAME         ("DZ11"),
       .regNAME         ("MSR "),
       .file            (file)
   );

   //
   // Read Interrupt Vector
   //

   PRINT_DEV_REG_ON_RD #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) VECT_RD (
       .clk             (clk),
       .devRD           (vectREAD),
       .devHIBYTE       (1'b0),
       .devLOBYTE       (1'b0),
       .regVAL          (rxVECTOR ? rxVECT[20:35] : txVECT[20:35]),
       .devNAME         ("DZ11"),
       .regNAME         ("VECT"),
       .file            (file)
   );

   //
   // Write CSR
   //

   PRINT_DEV_REG_ON_WR #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) CSR_WR (
       .clk             (clk),
       .devWR           (csrWRITE),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .devDATA         (dzDATAI[15:0]),
       .regVAL          (regCSR),
       .devNAME         ("DZ11"),
       .regNAME         ("CSR "),
       .file            (file)
   );

   //
   // Write LPR
   //

   PRINT_DEV_REG_ON_WR #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) LPR_WR (
       .clk             (clk),
       .devWR           (lprWRITE),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .devDATA         (dzDATAI[15:0]),
       .regVAL          (16'bx),
       .devNAME         ("DZ11"),
       .regNAME         ("LPR "),
       .file            (file)
   );

   //
   // Write TCR
   //

   PRINT_DEV_REG_ON_WR #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) TCR_WR (
       .clk             (clk),
       .devWR           (tcrWRITE),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .devDATA         (dzDATAI[15:0]),
       .regVAL          (regTCR),
       .devNAME         ("DZ11"),
       .regNAME         ("TCR "),
       .file            (file)
   );

   //
   // Write TDR
   //

   PRINT_DEV_REG_ON_WR #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) TDR_WR (
       .clk             (clk),
       .devWR           (tdrWRITE),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .devDATA         (dzDATAI[15:0]),
       .regVAL          (regTDR),
       .devNAME         ("DZ11"),
       .regNAME         ("TDR "),
       .file            (file)
   );

`endif

endmodule
