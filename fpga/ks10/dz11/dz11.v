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
//     "DZ11 Asynchronous Multiplexer Technical Manual" DEC Publication
//     EK-DZ110-TM-002
//
// Notes
//   Regarding endian-ness:
//     The KS10 backplane bus is 36-bit big-endian and uses [0:35] notation.
//     The IO Device are 36-bit little-endian (after Unibus) and uses [35:0]
//     notation.
//
//     Whereas the 'Unibus' is 18-bit data and 16-bit address, I've implemented
//     the IO bus as 36-bit address and 36-bit data just to keep things simple.
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
   wire rbufREAD  = devIO & devREAD  & (devDEV == dzDEV) & (devADDR == rbfADDR[18:34]) & !devIOBYTE;
   wire lprWRITE  = devIO & devWRITE & (devDEV == dzDEV) & (devADDR == lprADDR[18:34]) & !devIOBYTE;
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
   // CSR[CLR]
   //   This is a 15us one-shot in the KS10
   //

   reg [9:0] clrCOUNT;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          clrCOUNT <= 0;
        else
          begin
             if (devRESET)
               clrCOUNT <= 0;
             if (csrWRITE & devLOBYTE & `dzCSR_CLR(dzDATAI))
               clrCOUNT <= 15 * `CLKFRQ / 1000000;
             else if (clrCOUNT != 0)
               clrCOUNT <= clrCOUNT - 1'b1;
          end
     end

   wire csrCLR = (clrCOUNT != 0);

   //
   // CSR Register
   //
   // Details
   //  The CSR is read/write and can be accessed as bytes or words.
   //

   reg csrTIE;
   reg csrSAE;
   reg csrRIE;
   reg csrMSE;
   reg csrMAINT;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             csrTIE   <= 0;
             csrSAE   <= 0;
             csrRIE   <= 0;
             csrMSE   <= 0;
             csrMAINT <= 0;
          end
        else
          begin
             if (csrCLR | devRESET)
               begin
                  csrTIE   <= 0;
                  csrSAE   <= 0;
                  csrRIE   <= 0;
                  csrMSE   <= 0;
                  csrMAINT <= 0;
               end
             else if (csrWRITE)
               begin
                  if (devHIBYTE)
                    begin
                       csrTIE   <= `dzCSR_TIE(dzDATAI);
                       csrSAE   <= `dzCSR_SAE(dzDATAI);
                    end
                  if (devLOBYTE)
                    begin
                       csrRIE   <= `dzCSR_RIE(dzDATAI);
                       csrMSE   <= `dzCSR_MSE(dzDATAI);
                       csrMAINT <= `dzCSR_MAINT(dzDATAI);
                    end
               end
          end
     end

   //
   // CSR[TLINE] and CSR[TRDY]
   //
   // Note:
   //  The pipelining in the TLINE indexing is a little weird.  This way the
   //  multiplexing is strictly round-robbin.
   //

   reg       csrTRDY;
   reg [2:0] csrTLINE;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             csrTRDY  <= 0;
             csrTLINE <= 0;
          end
        else
          begin
             if (csrCLR | devRESET)
               begin
                  csrTRDY  <= 0;
                  csrTLINE <= 0;
               end
             else
               begin
                  if (csrTRDY)
                    begin
                       if (tdrWRITE & devLOBYTE)
                         csrTRDY <= 0;
                    end
                  else
                    begin
                       csrTLINE <= csrTLINE + 1'b1;
                       if (((csrTLINE == 7) & tcrLIN[0] & uartTXEMPTY[0]) |
                           ((csrTLINE == 0) & tcrLIN[1] & uartTXEMPTY[1]) |
                           ((csrTLINE == 1) & tcrLIN[2] & uartTXEMPTY[2]) |
                           ((csrTLINE == 2) & tcrLIN[3] & uartTXEMPTY[3]) |
                           ((csrTLINE == 3) & tcrLIN[4] & uartTXEMPTY[4]) |
                           ((csrTLINE == 4) & tcrLIN[5] & uartTXEMPTY[5]) |
                           ((csrTLINE == 5) & tcrLIN[6] & uartTXEMPTY[6]) |
                           ((csrTLINE == 6) & tcrLIN[7] & uartTXEMPTY[7]))
                         csrTRDY <= 1;
                    end
               end
          end
     end

   wire [15:0] regCSR = {csrTRDY,  csrTIE, csrSA, csrSAE,  1'b0, csrTLINE[2:0],
                         csrRDONE, csrRIE, csrMSE, csrCLR, csrMAINT, 3'b0};


   //
   // LPR Register
   //
   // Details
   //  LPR is write-only and can only be written as words.
   //  The LINE field selects which receiver is being updated.
   //

   reg lprRXEN[0:7];

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             lprRXEN[0] <= 0;
             lprRXEN[1] <= 0;
             lprRXEN[2] <= 0;
             lprRXEN[3] <= 0;
             lprRXEN[4] <= 0;
             lprRXEN[5] <= 0;
             lprRXEN[6] <= 0;
             lprRXEN[7] <= 0;
          end
        else
          begin
             if (csrCLR | devRESET)
               begin
                  lprRXEN[0] <= 0;
                  lprRXEN[1] <= 0;
                  lprRXEN[2] <= 0;
                  lprRXEN[3] <= 0;
                  lprRXEN[4] <= 0;
                  lprRXEN[5] <= 0;
                  lprRXEN[6] <= 0;
                  lprRXEN[7] <= 0;
               end
             else if (lprWRITE)
               lprRXEN[`dzLPR_LINE(dzDATAI)] <= `dzLPR_RXEN(dzDATAI);
          end
     end

   //
   // TCR Register
   //
   // Details
   //  TCR is read/write and can be accessed as bytes or words
   //
   //  The DTR registers are not reset by CSR[CLR].
   //

   reg [7:0] tcrDTR;
   reg [7:0] tcrLIN;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             tcrDTR <= 0;
             tcrLIN <= 0;
          end
        else
          begin
             if (devRESET)
               begin
                  tcrDTR <= 0;
                  tcrLIN <= 0;
               end
             else if (csrCLR)
               tcrLIN <= 0;
             else
               begin
                  if (tcrWRITE)
                    begin
                       if (devHIBYTE)
                         tcrDTR <= `dzTCR_DTR(dzDATAI);
                       if (devLOBYTE)
                         tcrLIN <= `dzTCR_LIN(dzDATAI);
                    end
               end
          end
     end

   wire [15:0] regTCR = {tcrDTR, tcrLIN};
   assign dz11DTR = tcrDTR;

   //
   // MSR Register
   //
   // Details
   //  MSR can be accessed as bytes or words
   //

   wire [15:0] regMSR = {dz11CO, dz11RI};

   //
   // TDR Register
   //
   // Details
   //  TDR is write-only and can be accessed as bytes or words
   //
   // Note
   //  The Break circuitry is not implemented
   //

   wire [7:0] uartTXDATA = `dzTDR_TBUF(dzDATAI);

   //
   // Scanner
   //
   // Details
   //  This just increments the scan signal.
   //

   reg [2:0] scan;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          scan <= 0;
        else
          begin
             if (csrCLR | devRESET)
               scan <= 0;
             else if (csrMSE)
               scan <= scan + 1'b1;
          end
     end

   //
   // Maintenance Loopback
   //
   // Details:
   //  When CSR[MAINT] is asserted, the transmitter is looped back to the
   //  receiver.
   //

   wire [7:0] ttyRXD = (csrMAINT) ? dz11TXD : dz11RXD;

   //
   // Load the transmitter UART(s)
   //

   reg  [7:0] uartTXLOAD;

   always @(csrTLINE or tcrLIN or tdrWRITE or devLOBYTE)
     begin
        if (tdrWRITE & devLOBYTE)
          case (csrTLINE)
            0: uartTXLOAD <= 8'b0000_0001;
            1: uartTXLOAD <= 8'b0000_0010;
            2: uartTXLOAD <= 8'b0000_0100;
            3: uartTXLOAD <= 8'b0000_1000;
            4: uartTXLOAD <= 8'b0001_0000;
            5: uartTXLOAD <= 8'b0010_0000;
            6: uartTXLOAD <= 8'b0100_0000;
            7: uartTXLOAD <= 8'b1000_0000;
          endcase
        else
          uartTXLOAD <= 8'b0000_0000;
     end

   //
   // Clear receiver full flag
   //
   // Details:
   //  If the receiver is full, empty the receiver into the FIFO and clear
   //  the full flag.
   //

   reg [7:0] uartRXCLR;

   always @(scan or uartRXFULL)
     begin
        case (scan)
          0: uartRXCLR <= uartRXFULL & 8'b0000_0001;
          1: uartRXCLR <= uartRXFULL & 8'b0000_0010;
          2: uartRXCLR <= uartRXFULL & 8'b0000_0100;
          3: uartRXCLR <= uartRXFULL & 8'b0000_1000;
          4: uartRXCLR <= uartRXFULL & 8'b0001_0000;
          5: uartRXCLR <= uartRXFULL & 8'b0010_0000;
          6: uartRXCLR <= uartRXFULL & 8'b0100_0000;
          7: uartRXCLR <= uartRXFULL & 8'b1000_0000;
        endcase
     end

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
   // Generate Array of UARTS
   //
   // Details
   //  The 'generate' loops below builds 8 UARTS.
   //

   wire [7:0] uartRXFULL;               // UART receiver has data
   wire [7:0] uartRXDATA[0:7];          // UART received data
   wire [7:0] uartTXEMPTY;              // UART transmitter buffer is empty

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
              .clkBR    (lprRXEN[i] & clkBR),
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
              .clkBR    (clkBR),
              .rxd      (ttyRXD[i]),
              .clr      (uartRXCLR[i]),
              .full     (uartRXFULL[i]),
              .data     (uartRXDATA[i])
           );

        end

   endgenerate

   //
   // Read FIFO edge trigger
   //
   // Details:
   //  The FIFO state is updated on the trailing edge of the read pulse; i.e.,
   //  after the read is completed.
   //

   wire fifoREAD;
   EDGETRIG uFIFOREAD(clk, rst, 1'b1, 1'b0, rbufREAD, fifoREAD);

   //
   // RBUF FIFO
   //
   // Details:
   //  Framing Error and Parity Error are not implemented.  UART status should
   //  be pushed into the FIFO with the data.
   //

   wire [14:0] fifoDATA;
   wire        fifoEMPTY;
   wire        fifoWRITE = uartRXFULL[scan];

   DZFIFO uDZFIFO (
      .clk      (clk),
      .rst      (rst),
      .clr      (csrCLR | devRESET),
      .din      ({4'b0, scan, uartRXDATA[scan]}),
      .wr       (fifoWRITE),
      .dout     (fifoDATA),
      .rd       (fifoREAD),
      .empty    (fifoEMPTY)
   );

`ifdef TEST31

   wire csrRDONE = !fifoEMPTY;

`else

   reg  csrRDONE;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          csrRDONE <= 0;
        else
          begin
             if (fifoREAD)
               csrRDONE <= 0;
             else
               csrRDONE <= !fifoEMPTY;
          end
     end

`endif

   //
   // RBUF DVAL
   //

`ifdef TEST31

   reg rbufDVAL;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          rbufDVAL  <= 0;
        else
          begin
             if (csrCLR | devRESET)
               rbufDVAL <= 0;
             else if (fifoREAD | fifoWRITE)
               rbufDVAL <= !fifoEMPTY;
          end
     end

`else

   wire rbufDVAL = !fifoEMPTY;

`endif



   //
   // RBUF Register
   //
   // Details
   //  RBUF is read only and can only be read as words.
   //
   //  RBUF[DVAL] is the FIFO Status.  Everything else is read from the FIFO.
   //

   wire [15:0] regRBUF = {rbufDVAL, fifoDATA};

   //
   // SILO Alarm Counter.
   //  This increments every time a character is stored in the FIFO. The
   //  counter is reset by a rbufREAD.  This is not the FIFO depth.
   //

   reg [0:4] countSA;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          countSA <= 0;
        else
          begin
             if (csrCLR | devRESET)
               countSA <= 0;
             else if (fifoREAD | !csrSAE)
               countSA <= 0;
             else if (fifoWRITE)
               countSA <= countSA + 1'b1;
          end
     end

   //
   // SILO Alarm
   //

   reg csrSA;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          csrSA <= 0;
        else
          begin
             if (csrCLR | devRESET)
               csrSA <= 0;
             else if (fifoREAD | !csrSAE)
               csrSA <= 0;
             else if (countSA == 16)
               csrSA <= 1;
          end
     end

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
   //  4.  Receiver interrupts are disabled
   //  5.  The interrupt is acknowledged
   //
   //  The transmitter interrupt is generated when:
   //  1.  CSR[TRDY] is asserted when CSR[TIE] is asserted.
   //
   //  The transmitter interrupt is cleared when:
   //  1.  Reset
   //  2.  IO Bus Reset
   //  3.  CSR[CLR]
   //  4.  Transmitter interrupts are disabled
   //  5.  The interrupt is acknowledged
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

   always @(csrREAD  or csrWRITE or regCSR  or
            rbufREAD or lprWRITE or regRBUF or
            tcrREAD  or tcrWRITE or regTCR  or
            msrREAD  or tdrWRITE or regMSR  or
            vectREAD or rxINTR   or rxVECT   or txVECT)
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
   //

   assign devINTR  = (rxINTR | txINTR) ? dzINTR : 4'b0;
   assign devADDRO = 0;
   assign devREQO  = 0;

endmodule
