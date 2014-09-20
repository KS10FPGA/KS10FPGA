
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
//   dz11.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2014 Rob Doyle
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
`include "dz11.vh"
`include "dzcsr.vh"
`include "dzlpr.vh"
`include "dztcr.vh"
`include "dztdr.vh"
`include "../ubabus.vh"
`include "../../ks10.vh"
`include "uart/uart_brg.vh"

module DZ11(clk,      rst,
            dz11TXD,  dz11RXD,  dz11CO,  dz11RI,  dz11DTR,
            devRESET, devINTR,  devINTA,
            devREQI,  devACKO,  devADDRI,
            devREQO,  devACKI,  devADDRO,
            devDATAI, devDATAO);

   input          clk;                          // Clock
   input          rst;                          // Reset
   // DZ11 Interfaces
   output [ 7: 0] dz11TXD;                      // DZ11 Transmitter Serial Data
   input  [ 7: 0] dz11RXD;                      // DZ11 Receiver Serial Data
   input  [ 7: 0] dz11CO;                       // DZ11 Carrier Detect
   input  [ 7: 0] dz11RI;                       // DZ11 Ring Indicator
   output [ 7: 0] dz11DTR;                      // DZ11 Data Terminal Ready
   // Reset
   input          devRESET;                     // IO Bus Bridge Reset
   // Interrupt
   output [ 7: 4] devINTR;                      // Interrupt Request
   input  [ 7: 4] devINTA;                      // Interrupt Acknowledge
   // Target
   input          devREQI;                      // Device Request In
   output         devACKO;                      // Device Acknowledge Out
   input  [ 0:35] devADDRI;                     // Device Address In
   // Initiator
   output         devREQO;                      // Device Request Out
   input          devACKI;                      // Device Acknowledge In
   output [ 0:35] devADDRO;                     // Device Address Out
   // Data
   input  [ 0:35] devDATAI;                     // Data In
   output [ 0:35] devDATAO;                     // Data Out

   //
   // DZ Parameters
   //

   parameter [14:17] dzDEV  = `dz1DEV;          // DZ11 Device Number
   parameter [18:35] dzADDR = `dz1ADDR;         // DZ11 Base Address
   parameter [18:35] dzVECT = `dz1VECT;         // DZ11 Interrupt Vector
   parameter [ 7: 4] dzINTR = `dz1INTR;         // DZ11 Interrupt

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

   localparam [18:35] rxVECT = dzVECT;          // DZ11 RX Interrupt Vector
   localparam [18:35] txVECT = dzVECT + 4;      // DZ11 TX Interrupt Vector

   //
   // Device Address and Flags
   //

   wire         devREAD   = `devREAD(devADDRI);         // Read Cycle
   wire         devWRITE  = `devWRITE(devADDRI);        // Write Cycle
   wire         devIO     = `devIO(devADDRI);           // IO Cycle
   wire         devVECT   = `devVECT(devADDRI);         // Read interrupt vector
   wire         devIOBYTE = `devIOBYTE(devADDRI);       // Byte IO Operation
   wire [14:17] devDEV    = `devDEV(devADDRI);          // Device Number
   wire [18:34] devADDR   = `devADDR(devADDRI);         // Device Address
   wire         devHIBYTE = `devHIBYTE(devADDRI);       // Device High Byte
   wire         devLOBYTE = `devLOBYTE(devADDRI);       // Device Low Byte

   //
   // Address Decoding
   //

   wire csrREAD   = devIO & devREAD  & (devDEV == dzDEV) & (devADDR == csrADDR[18:34]);
   wire csrWRITE  = devIO & devWRITE & (devDEV == dzDEV) & (devADDR == csrADDR[18:34]);
   wire rbufREAD  = devIO & devREAD  & (devDEV == dzDEV) & (devADDR == rbfADDR[18:34]);
   wire lprWRITE  = devIO & devWRITE & (devDEV == dzDEV) & (devADDR == lprADDR[18:34]);
   wire tcrREAD   = devIO & devREAD  & (devDEV == dzDEV) & (devADDR == tcrADDR[18:34]);
   wire tcrWRITE  = devIO & devWRITE & (devDEV == dzDEV) & (devADDR == tcrADDR[18:34]);
   wire msrREAD   = devIO & devREAD  & (devDEV == dzDEV) & (devADDR == msrADDR[18:34]);
   wire tdrWRITE  = devIO & devWRITE & (devDEV == dzDEV) & (devADDR == tdrADDR[18:34]);
   wire vectREAD  = devIO & devVECT  & (devDEV == dzDEV);

   //
   // Big-endian to little-endian data bus swap
   //

   wire [35:0] dzDATAI = devDATAI[0:35];

   //
   // Registers
   //

   wire [15:0] regCSR;
   wire [15:0] regMSR;
   wire [15:0] regTCR;
   wire [15:0] regTDR;
   wire [15:0] regRBUF;

   //
   // Signals
   //
   
   wire        csrCLR   = `dzCSR_CLR(regCSR);
   wire        csrTIE   = `dzCSR_TIE(regCSR);
   wire        csrRIE   = `dzCSR_RIE(regCSR);
   wire        csrMSE   = `dzCSR_MSE(regCSR);
   wire        csrSA    = `dzCSR_SA(regCSR);
   wire        csrSAE   = `dzCSR_SAE(regCSR);
   wire        csrMAINT = `dzCSR_MAINT(regCSR);
   wire        csrRDONE = `dzCSR_RDONE(regCSR);
   wire [ 2:0] csrTLINE = `dzCSR_TLINE(regCSR);
   wire        csrTRDY  = `dzCSR_TRDY(regCSR);
   wire        rbufRDONE;
   wire        rbufSA;
   wire [ 0:7] lprRXEN;
   wire [ 2:0] scan;
   wire [ 7:0] tcrLIN = `dzTCR_LIN(regTCR);
   wire [ 7:0] uartTXEMPTY;
   wire [ 7:0] uartTXLOAD;
   wire [ 7:0] uartRXFULL;
   wire [ 7:0] uartRXDATA[0:7];
   wire [ 7:0] uartRXCLR;
   wire [ 7:0] uartTXDATA = `dzTDR_TBUF(regTDR);
   
   //
   // Control/Status Register (CSR)
   //

   DZCSR CSR (
      .clk        (clk),
      .rst        (rst),
      .devRESET   (devRESET),
      .devLOBYTE  (devLOBYTE),
      .devHIBYTE  (devHIBYTE),
      .devDATAI   (devDATAI),
      .csrWRITE   (csrWRITE),
      .tdrWRITE   (tdrWRITE),
      .scan       (scan),
      .rbufRDONE  (rbufRDONE),
      .rbufSA     (rbufSA),
      .uartTXEMPTY(uartTXEMPTY),
      .regTCR     (regTCR),
      .regCSR     (regCSR)
   );

   //
   // Line Parameter Register (LPR)
   //

   DZLPR LPR (
      .clk        (clk),
      .rst        (rst),
      .clr        (devRESET | csrCLR),
      .devDATAI   (devDATAI),
      .lprWRITE   (lprWRITE),
      .lprRXEN    (lprRXEN)
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
      .devDATAI   (devDATAI),
      .csrCLR     (csrCLR),
      .tcrWRITE   (tcrWRITE),
      .regTCR     (regTCR)
   );

   assign dz11DTR = `dzTCR_DTR(regTCR);

   //
   // Modem Status Register (MSR)
   //

   DZMSR MSR (
      .clk        (clk),
      .rst        (rst),
      .dz11CO     (dz11CO),
      .dz11RI     (dz11RI),
      .regMSR     (regMSR)
   );

   //
   // TDR Register
   //

   DZTDR TDR (
      .clk        (clk),
      .rst        (rst),
      .devLOBYTE  (devLOBYTE),
      .devHIBYTE  (devHIBYTE),
      .devDATAI   (devDATAI),
      .csrTLINE   (csrTLINE),
      .tdrWRITE   (tdrWRITE),
      .uartTXLOAD (uartTXLOAD),
      .regTDR     (regTDR)
   );

   //
   // Line Scanner
   //

   DZSCAN SCAN (
      .clk        (clk),
      .rst        (rst),
      .clr        (csrCLR | devRESET),
      .csrMSE     (csrMSE),
      .scan       (scan)
   );

   //
   // Maintenance Loopback
   //
   // Details:
   //  When CSR[MAINT] is asserted, the transmitters are looped back to the
   //  receivers.
   //

   wire [7:0] ttyRXD = (csrMAINT) ? dz11TXD : dz11RXD;

   //
   // UART Baud Rate Generators
   //
   // Details
   //  For now, all of the UARTS are fixed programmed at 115200 baud
   //

   wire clkBR;
   UART_BRG ttyBRG (
      .clk        (clk),
      .rst        (rst | devRESET),
      .brgSEL     (`BR115200),
      .brgCLKEN   (clkBR)
   );

   //
   // Array of UARTS
   //
   // Details
   //  The 'generate' loops below builds 8 UARTS.
   //

   generate

      genvar  i;

      for (i = 0; i < 8; i = i + 1)

        begin : uart_loop

           //
           // UART Transmitters
           //

           UART_BUFTX ttyTX (
              .clk      (clk),
              .rst      (rst | devRESET),
              .clkBR    (clkBR),
              .load     (uartTXLOAD[i]),
              .data     (uartTXDATA),
              .empty    (uartTXEMPTY[i]),
              .txd      (dz11TXD[i])
           );

           //
           // UART Receivers
           //

           UART_BUFRX ttyRX (
              .clk      (clk),
              .rst      (rst | devRESET),
              .clkBR    (lprRXEN[i] & clkBR),
              .rxd      (ttyRXD[i]),
              .clr      (uartRXCLR[i]),
              .full     (uartRXFULL[i]),
              .data     (uartRXDATA[i])
           );

        end

   endgenerate

   //
   // Receiver Buffer Register (RBUF)
   //
   // Details:
   //  Framing Error and Parity Error are not implemented.  UART status should
   //  be pushed into the FIFO with the data.
   //

   DZRBUF RBUF (
      .clk       (clk),
      .rst       (rst),
      .clr       (csrCLR | devRESET),
      .csrMSE    (csrMSE),
      .csrSAE    (csrSAE),
      .scan      (scan),
      .uartRXDATA({5'b0, scan, uartRXDATA[scan]}),
      .uartRXFULL(uartRXFULL),
      .uartRXCLR (uartRXCLR),
      .rbufREAD  (rbufREAD),
      .rbufRDONE (rbufRDONE),
      .rbufSA    (rbufSA),
      .regRBUF   (regRBUF)
   );

   //
   // Interrupts
   //
   // Details:
   //  This module generates the transmitter and receiver interrupts
   //
   //  The receiver interrupt has priority over the transmitter interrupt.
   //
   // Notes:
   //  The receiver interrupt is generated when:
   //  1. csr[RDONE] asserted when csr[SAE] is negated
   //  2. csr[SA] asserted
   //
   //  The receiver interrupt is cleared when:
   //  1.  Reset
   //  2.  IO Bus Reset
   //  3.  CSR[CLR]
   //  4.  The interrupt is acknowledged
   //
   //  The transmitter interrupt is generated when:
   //  1.  CSR[TRDY] is asserted when CSR[TIE] is asserted.
   //
   //  The transmitter interrupt is cleared when:
   //  1.  Reset
   //  2.  IO Bus Reset
   //  3.  CSR[CLR]
   //  4.  The interrupt is acknowledged and the receiver interrupt is
   //      not asserted.  This gives the receiver priority over the
   //      transmitter.
   //

   wire txINTR;
   wire rxINTR;
   DZINTR INTR (
      .clk      (clk),
      .rst      (rst),
      .clr      (csrCLR | devRESET),
      .rxen     (csrRIE),
      .txen     (csrTIE),
      .rxin     (csrSA | (!csrSAE & csrRDONE)),
      .txin     (csrTRDY),
      .ack      (devINTA == dzINTR),
      .vect     (vectREAD),
      .rxout    (rxINTR),
      .txout    (txINTR)
   );

   //
   // Bus Mux and little-endian to big-endian bus swap.
   //

   reg devACKO;
   reg [0:35] devDATAO;

   always @*
     begin
        devACKO  = 0;
        devDATAO = 36'bx;
        if (csrREAD | csrWRITE)
          begin
             devACKO  = 1;
             devDATAO = {20'b0, regCSR};
          end
        if (rbufREAD | lprWRITE)
          begin
             devACKO  = 1;
             devDATAO = {20'b0, regRBUF};
          end
        if (tcrREAD | tcrWRITE)
          begin
             devACKO  = 1;
             devDATAO = {20'b0, regTCR};
          end
        if (msrREAD | tdrWRITE)
          begin
             devACKO  = 1;
             devDATAO = {20'b0, regMSR};
          end
        if (vectREAD)
          begin
             devACKO  = 1;
             devDATAO = rxINTR ? rxVECT : txVECT;
          end
     end

   //
   // DZ11 Device Interface
   //  The DZ11 is not a KS10 bus initiator.

   assign devINTR  = (rxINTR | txINTR) ? dzINTR : 4'b0;
   assign devADDRO = 0;
   assign devREQO  = 0;

endmodule
