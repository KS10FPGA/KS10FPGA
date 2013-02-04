////////////////////////////////////////////////////////////////////
//
// KS10 Processor
//
// Brief
//   DZ11 Asynchronous Terminal Multiplexer
//
// Details
//   The information used to design the DZ11 was obtained from the
//   following DEC docmument:
//
//   DZ11 Asynchronous Multiplexer Technical Manual
//   DEC Publication EK-DZ110-TM-002
//
// Notes
//   The KS10 is 36-bit big-endian and uses [0:35] notation.
//
//   The 'Unibus' IO Bus is 16-bit little-endian and uses [15:0]
//   notation.   Sorry about the mixed endian-ism.  I didn't
//   create this stuff - I've just matched the exising notation.
//
// File
//   dz11.v
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
`include "dz11.vh"
`include "../../ks10.vh"
`include "uart/uart_brg.vh"

module DZ11(clk,      rst,      ctlNUM,
            dz11TXD,  dz11RXD,  dz11CO,   dz11RI,  dz11DTR,
            devRESET, devINTR,  devINTA,
            devREQI,  devACKO,  devADDRI,
            devREQO,  devACKI,  devADDRO,
            devDATAI, devDATAO);

   input          clk;                          // Clock
   input          rst;                          // Reset
   input  [ 0: 3] ctlNUM;                       // Bridge Device Number
   // DZ11 External Interfaces
   output [ 7: 0] dz11TXD;                      // DZ11 Transmitter Serial Data
   input  [ 7: 0] dz11RXD;                      // DZ11 Receiver Serial Data
   input  [ 7: 0] dz11CO;                       // DZ11 Carrier Detect Input
   input  [ 7: 0] dz11RI;                       // DZ11 Ring Indicator Input
   output [ 7: 0] dz11DTR;                      // DZ11 Data Terminal Ready Output
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

   parameter [14:17] dzDEV  = `dzDEV;           // Device 3
   parameter [18:35] dzADDR = `dz1ADDR;         // DZ11 Base Address
   parameter [18:35] dzVECT = `dz1VECT;         // DZ11 Interrupt Vector
   parameter [ 7: 4] dzINTR = `dzINTR;		// DZ11 Interrupt
                 
   //
   // DZ Register Addresses
   //

   parameter [18:35] csrADDR = dzADDR + `csrOFFSET;
   parameter [18:35] rbfADDR = dzADDR + `rbfOFFSET;
   parameter [18:35] lprADDR = dzADDR + `lprOFFSET;
   parameter [18:35] tcrADDR = dzADDR + `tcrOFFSET;
   parameter [18:35] msrADDR = dzADDR + `msrOFFSET;
   parameter [18:35] tdrADDR = dzADDR + `tdrOFFSET;

   //
   // DZ Interrupt Vectors
   //

   parameter [18:35] rxVECT = dzVECT;           // DZ11 Receiver Interrupt Vector
   parameter [18:35] txVECT = dzVECT + 4;       // DZ11 Transmitter Interrupt Vector
   
   //
   // Memory Address and Flags
   //
   // Details:
   //  devADDRI[ 0:13] is flags
   //  devADDRI[14:35] is address
   //

   wire         devREAD   = devADDRI[ 3];       // 1 = Read Cycle (IO or Memory)
   wire         devWRITE  = devADDRI[ 5];       // 1 = Write Cycle (IO or Memory)
   wire         devIO     = devADDRI[10];       // 1 = IO Cycle, 0 = Memory Cycle
   wire         devVECT   = devADDRI[12];       // 1 = Read interrupt vector
   wire         devIOBYTE = devADDRI[13];       // 1 = Byte IO Operation
   wire [14:17] devDEV    = devADDRI[14:17];    // Device Number
   wire [18:35] devADDR   = devADDRI[18:35];    // Device Address
   wire         devHIBYTE = devADDRI[35];       // Register High Byte
   wire         devLOBYTE = ~devHIBYTE;         // Register Low Byte

   //
   // Address Decoding
   //

   wire csrREAD   = devIO & devREAD  & (devDEV == dzDEV) & (devADDR[18:34] == csrADDR[18:34]);
   wire csrWRITE  = devIO & devWRITE & (devDEV == dzDEV) & (devADDR[18:34] == csrADDR[18:34]);
   wire rbufREAD  = devIO & devREAD  & (devDEV == dzDEV) & (devADDR[18:34] == rbfADDR[18:34]) & ~devIOBYTE;
   wire lprWRITE  = devIO & devWRITE & (devDEV == dzDEV) & (devADDR[18:34] == lprADDR[18:34]) & ~devIOBYTE;
   wire tcrREAD   = devIO & devREAD  & (devDEV == dzDEV) & (devADDR[18:34] == tcrADDR[18:34]);
   wire tcrWRITE  = devIO & devWRITE & (devDEV == dzDEV) & (devADDR[18:34] == tcrADDR[18:34]);
   wire msrREAD   = devIO & devREAD  & (devDEV == dzDEV) & (devADDR[18:34] == msrADDR[18:34]);
   wire tdrWRITE  = devIO & devWRITE & (devDEV == dzDEV) & (devADDR[18:34] == tdrADDR[18:34]);

   wire csrWRITEH = ((csrWRITE & devIOBYTE & devHIBYTE) | (csrWRITE & ~devIOBYTE));
   wire csrWRITEL = ((csrWRITE & devIOBYTE & devLOBYTE) | (csrWRITE & ~devIOBYTE));
   wire tcrWRITEH = ((tcrWRITE & devIOBYTE & devHIBYTE) | (tcrWRITE & ~devIOBYTE));
   wire tcrWRITEL = ((tcrWRITE & devIOBYTE & devLOBYTE) | (tcrWRITE & ~devIOBYTE));
   wire tdrWRITEH = ((tdrWRITE & devIOBYTE & devHIBYTE) | (tdrWRITE & ~devIOBYTE));
   wire tdrWRITEL = ((tdrWRITE & devIOBYTE & devLOBYTE) | (tdrWRITE & ~devIOBYTE));

   //
   // Interrupt Vector Read Operation
   //
   
   wire vectREAD  = devIO & devVECT & (devDEV == ctlNUM);
   
   //
   // Big-endian to little-endian data bus fixup
   //

   wire [35:0] dzDATAI = devDATAI[0:35];

   //
   // CSR[CLR] 15us one-shot
   //

   reg [9:0] clrCOUNT;
   always @(posedge clk or posedge rst or posedge devRESET)
     begin
        if (rst | devRESET)
          clrCOUNT <= 2;
        else
          begin
             if (csrWRITEL & dzDATAI[4])
               clrCOUNT <= `CLKFRQ / 1000000 * 15;
             else if (csrCLR)
               clrCOUNT <= clrCOUNT - 1'b1;
          end
     end

   wire csrCLR = (clrCOUNT != 0);
   wire regRESET = csrCLR;

   //
   // CSR Register
   //
   // Details
   //  The CSR is read/write and can be accessed as bytes or words.
   //

   reg       csrTRDY;
   reg       csrTIE;
   reg       csrSAE;
   reg       csrRIE;
   reg       csrMSE;
   reg [2:0] csrTLINE;
   reg       csrMAINT;

   always @(posedge clk or posedge regRESET)
     begin
        if (regRESET)
          begin
             csrTRDY  <= 0;
             csrTIE   <= 0;
             csrSAE   <= 0;
             csrRIE   <= 0;
             csrMSE   <= 0;
             csrTLINE <= 0;
             csrMAINT <= 0;
          end
        else
          begin

             //
             // Write to high byte
             //

             if (csrWRITEH)
               begin
                  csrTIE   <= dzDATAI[14];
                  csrSAE   <= dzDATAI[12];
               end

             //
             // Write to low byte
             //

             if (csrWRITEL)
               begin
                  csrRIE   <= dzDATAI[ 6];
                  csrMSE   <= dzDATAI[ 5];
                  csrMAINT <= dzDATAI[ 3];
               end

             //
             // Transmitter Scan
             //

             if (csrTRDY & tdrWRITEL)
               csrTRDY <= 0;
             else if (tcrLIN[scan] & ttyTXEMPTY[scan])
               begin
                  csrTRDY  <= 1;
                  csrTLINE <= scan;
               end
          end
     end

   wire csrSA;
   wire csrRDONE;
   wire [15:0] regCSR = {csrTRDY,  csrTIE, csrSA, csrSAE,  1'b0, csrTLINE,
                         csrRDONE, csrRIE, csrMSE, csrCLR, csrMAINT, 3'b0};

   //
   // Line Enable Decoder
   //

   reg [7:0] tlineMUX;
   always @(csrTLINE)
     begin
        case (csrTLINE)
          0: tlineMUX <= 8'b0000_0001;
          1: tlineMUX <= 8'b0000_0010;
          2: tlineMUX <= 8'b0000_0100;
          3: tlineMUX <= 8'b0000_1000;
          4: tlineMUX <= 8'b0001_0000;
          5: tlineMUX <= 8'b0010_0000;
          6: tlineMUX <= 8'b0100_0000;
          7: tlineMUX <= 8'b1000_0000;
        endcase
     end
   
   //
   // RBUF Register
   //
   // Details
   //  RBUF is read only and can only be read as words
   //
   
   wire rbufVALID;
   wire [15:0] regRBUF  = {rbufVALID, 4'b0, rbufDATA};

   //
   // LPR Register
   //
   // Details
   //  LPR is write-only and can only be written as words.
   //

   reg lprRXON;

   always @(posedge clk or posedge regRESET)
     begin
        if (regRESET)
          begin
             lprRXON  <= 0;
          end
        else if (lprWRITE)
          begin
             lprRXON <= dzDATAI[12];
          end
     end

   //
   // TCR Reguster
   //
   // Details
   //  TCR is read/write and can be accessed as bytes or words
   //
   //  The DTR registers are not reset by CSR[CLR].
   //

   reg [7:0] tcrDTR;
   reg [7:0] tcrLIN;
   always @(posedge clk or posedge rst or posedge devRESET)
     begin
        if (rst | devRESET)
          begin
             tcrDTR <= 0;
             tcrLIN <= 0;
          end
        else if (csrCLR)
          begin
             tcrLIN <= 0;
          end
        else
          begin
             if (tcrWRITEH)
               tcrDTR <= dzDATAI[15:8];
             if (tcrWRITEL)
               tcrLIN <= dzDATAI[ 7:0];
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

   wire [7:0] ttyTXDATA = dzDATAI[7:0];
   wire [7:0] ttyTXLOAD = (tdrWRITEL) ? (tlineMUX & tcrLIN) : 8'b0;

   //
   // Scanner
   //
   // Details
   //  This just increments the scan signal.
   //
   
   reg [2:0] scan;
   always @(posedge clk or posedge rst or posedge csrCLR)
     begin
        if (rst | csrCLR)
          scan <= 0;
        else if (csrMSE)
          scan <= scan + 1'b1;
     end
   
   //
   // Scan Decoder
   //
   // Details
   //  This decodes the scan variable.
   //

   reg [7:0] scanMUX;
   always @(scan)
     begin
        case (scan)
          0: scanMUX <= 8'b0000_0001;
          1: scanMUX <= 8'b0000_0010;
          2: scanMUX <= 8'b0000_0100;
          3: scanMUX <= 8'b0000_1000;
          4: scanMUX <= 8'b0001_0000;
          5: scanMUX <= 8'b0010_0000;
          6: scanMUX <= 8'b0100_0000;
          7: scanMUX <= 8'b1000_0000;
        endcase
     end

   //
   // Maintenance Loopback
   //
   // Details:
   //  When CSR[MAINT] is asserted, the transmitter is looped
   //  back to the receiver.
   //

   wire [7:0] ttyRXD = (csrMAINT) ? dz11TXD : dz11RXD;

   //
   // Clear receiver full flag
   //
   // Details:
   //  If the receiver is full, empty the receiver into the
   //  RXFIFO and clear the full flag.
   //
   
   wire [7:0] ttyRXCLR = scanMUX & ttyRXFULL;
   
   //
   // UART Baud Rate Generators
   //
   // Details
   //  For now the UARTS are fixed programmed to 9600 baud
   //

   wire clkBR;
   UART_BRG ttyBRG
     (.clk        (clk),
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
   // Note
   //  For some reason, Xilinx ISE requires that the
   //  genvar line is inside the generate statement.
   //  Other tools don't seem to care.
   //

   wire [7:0] ttyRXFULL;                // UART receiver has data
   wire [7:0] ttyRXDATA[0:7];           // UART received data
   wire [7:0] ttyTXEMPTY;               // UART transmitter buffer is empty
   
   generate
      
      genvar  i;

      for (i = 0; i < 8; i = i + 1)

        begin : uart_loop

           //
           // UART Transmitters
           //

           UART_BUFTX ttyTX
             (.clk      (clk),
              .rst      (rst | devRESET),
              .clkBR    (lprRXON & clkBR),
              .load     (ttyTXLOAD[i]),
              .data     (ttyTXDATA),
              .empty    (ttyTXEMPTY[i]),
              .txd      (dz11TXD[i])
              );
           
           //
           // UART Receivers
           //
           
           UART_BUFRX ttyRX
             (.clk      (clk),
              .rst      (rst | devRESET),
              .clkBR    (clkBR),
              .clr      (ttyRXCLR[i]),
              .rxd      (ttyRXD[i]),
              .full     (ttyRXFULL[i]),
              .data     (ttyRXDATA[i])
              );
        end

   endgenerate

   //
   // RBUF FIFO
   //

   wire fifoEMPTY;
   wire [10:0] rbufDATA;

   DZFIFO uDZFIFO
     (.clk      (clk),
      .rst      (rst | csrCLR | devRESET),
      .din      ({scan, ttyRXDATA[scan]}),
      .wr       (ttyRXFULL[scan]),
      .dout     (rbufDATA),
      .rd       (rbufREAD),
      .alarm    (csrSA),
      .empty    (fifoEMPTY)
      );

   assign csrRDONE  = ~fifoEMPTY;
   assign rbufVALID = ~fifoEMPTY;

   //
   // Edge Trigger RX Interrupts
   //
   
   wire intRX0 = ((~csrSAE & csrRDONE & csrRIE) |
                  (csrSAE  & csrSA    & csrRIE));

   reg  intRX1;

   always @(posedge clk or posedge regRESET)
     begin
        if (regRESET)
          intRX1 <= 0;
        else
          intRX1 <= intRX0;
     end
   
   wire intRX = intRX0 & ~intRX1;

   //
   // Edge Trigger TX Interrupts
   //

   wire intTX0 = csrTIE & csrTRDY;
   reg  intTX1;
   
   always @(posedge clk or posedge regRESET)
     begin
        if (regRESET)
          intTX1 <= 0;
        else
          intTX1 <= intTX0;
     end

   wire intTX = intTX0 & ~intTX1;
   
   //
   // Receiver Interrupts
   //
   // Details:
   //  This process generates the receiver interrupt from the silo
   //  alarm and from the receiver done register bits.
   //
   //  The interrupt is edge-trigger by the conditions that are
   //  described above.
   //
   // Notes:
   //  The receiver interrupt is cleared when:
   //  1.  Reset
   //  2.  IO Bus Reset
   //  3.  CSR[CLR]
   //  4.  Receiver interrupts are disabled
   //  5.  The interrupt is acknowledged
   //

   reg dzRXINTR;

   always @(posedge clk or posedge regRESET)
     begin
        if (regRESET)
          dzRXINTR <= 0;
        else if (devINTA & dzINTR)
          dzRXINTR <= 0;
        else if (intRX)
          dzRXINTR <= 1;
     end
     
   //
   // Transmiter Interrupts
   //
   // Details:
   //   This process generates the transmitter interrupt from the
   //   transmitter ready register bit.
   //
   // Notes:
   //   The transmitter interrupt is cleared when:
   //   1.  Reset
   //   2.  IO Bus Reset
   //   3.  CSR[CLR]
   //   4.  Transmitter interrupts are disabled
   //   5.  The interrupt is acknowledged
   //
   
   reg dzTXINTR;

   always @(posedge clk or posedge regRESET)
     begin
        if (regRESET)
          dzTXINTR <= 0;
        else if (devINTA & dzINTR)
          dzTXINTR <= 0;
        else if (intTX)
          dzTXINTR <= 1;
     end

   //
   // Vector Type
   //
   
   reg dzRXVECT;
   
   always @(posedge clk or posedge regRESET)
     begin
        if (regRESET)
          dzRXVECT <= 0;
        else if (intRX)
          dzRXVECT <= 1;
        else if (intTX)
          dzRXVECT <= 0;
     end
   
   //
   // Bus Mux and little-endian to big-endian bus swap.
   //

   reg devACKO;
   reg [0:35] devDATAO;

   always @(csrREAD  or csrWRITE or regCSR  or
            rbufREAD or lprWRITE or regRBUF or
            tcrREAD  or tcrWRITE or regTCR  or
            msrREAD  or tdrWRITE or regMSR  or
            vectREAD or dzRXINTR or rxVECT  or txVECT)
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
             if (dzRXVECT)
               begin
                  devACKO  = 1;
                  devDATAO = rxVECT;
               end
             else
               begin
                  devACKO  = 1;
                  devDATAO = txVECT;
               end
          end
     end
   
   //
   // DZ11 Device Interface
   //

   assign devINTR  = (dzRXINTR | dzTXINTR) ? dzINTR : 4'b0;
   assign devADDRO = 0;
   assign devREQO  = 0;

endmodule
