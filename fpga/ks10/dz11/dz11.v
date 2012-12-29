////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KS-10 DZ11 
//
// Details
//
// Notes
//   Unibus is little-endian and uses [15:0] notation
//   KS10 is big-endian and uses [0:35] notation.
//
//   The addressing big-endian from the KS10.
//   The data bus little-endian from Unibus. Confusing? Sorry.
//
// File
//   dz11.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2012 Rob Doyle
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
`include "uart/uart_brg.vh"
  
module DZ11(clk, rst, clken,
            dz11TXD, dz11RXD, dz11CO, dz11RI, dz11DTR,
            devRESET, devINTR,  devINTA,
            devREQI,  devACKO,  devADDRI,
            devREQO,  devACKI,  devADDRO,
            devDATAI, devDATAO);

   input          clk;                          // Clock
   input          rst;                          // Reset
   input          clken;                        // Clock enable
   // DZ11 External Interfaces
   output [ 7: 0] dz11TXD;                      // DZ11 Transmitter Serial Data
   input  [ 7: 0] dz11RXD;                      // DZ11 Receiver Serial Data
   input  [ 7: 0] dz11CO;                       // DZ11 Carrier Detect Input
   input  [ 7: 0] dz11RI;                       // DZ11 Ring Indicator Input
   output [ 7: 0] dz11DTR;                      // DZ11 DTR Output
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

   parameter [ 7: 4] dzINTR  = `dzINTR;         // Interrupt 5
   parameter [14:17] dzDEV   = `dzDEV;          // Device 3
   parameter [18:35] dzADDR  = `dz1ADDR;        // DZ11 Base Address

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
   // Memory Address and Flags
   //
   // Details:
   //  devADDRI[ 0:13] is flags
   //  devADDRI[14:35] is address
   //
   
   wire         devREAD   = devADDRI[ 3];       // 1 = Read Cycle (IO or Memory)
   wire         devWRITE  = devADDRI[ 5];       // 1 = Write Cycle (IO or Memory)
   wire         devIO     = devADDRI[10];       // 1 = IO Cycle, 0 = Memory Cycle
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
   wire rbfREAD   = devIO & devREAD  & (devDEV == dzDEV) & (devADDR[18:34] == rbfADDR[18:34]) & ~devIOBYTE;
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
   // Big-endian to little-endian data bus swap
   //
   
   wire [35:0] dzDATAI = devDATAI[0:35];
   
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
   reg [9:0] clrCOUNT;
   
   always @(posedge clk)
     begin
        if (rst | devRESET | (csrWRITEL & dzDATAI[4]))
          begin
             csrTRDY  <= 0;
             csrTIE   <= 0;
             csrSAE   <= 1;
             csrRIE   <= 0;
             csrMSE   <= 0;
             csrTLINE <= 0;
             csrMAINT <= 0;
             clrCOUNT <= 1023;
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
             // Decrement CLR one-shot time if not zero already
             //
             
             if (csrCLR)
               clrCOUNT <= clrCOUNT - 1'b1;

             //
             // Transmitter Scan
             //

             if (csrTRDY & tdrWRITEL)
               csrTRDY <= 0;
             else if (tcrLIN[scanMUX] & ~ttyTXEMPTY[scanMUX])
               begin
                  csrTRDY  <= 1;
                  csrTLINE <= scan;
               end
          end
     end              
   
   wire        csrCLR   = (clrCOUNT != 0);
   wire [15:0] regCSR   = {csrTRDY,  csrTIE, csrSA, csrSAE,  1'b0, csrTLINE, 
                           csrRDONE, csrRIE, csrMSE, csrCLR, csrMAINT, 3'b0};
   
   //
   // RBUF Register
   //
   // Details
   //  RBUF is read only and can only be read as words
   //

   wire [15:0] regRBUF  = {rbufVALID, 4'b0, rbufDATA};

   //
   // LPR Register
   //
   // Details
   //  LPR is write-only and can only be written as words
   //
   
   reg lprRXON;
   reg [3:0] lprBR[7:0];
   
   always @(posedge clk)
     begin
        if (rst | devRESET | csrCLR)
          begin
             lprRXON  <= 0;
             lprBR[7] <= 0;
             lprBR[6] <= 0;
             lprBR[5] <= 0;
             lprBR[4] <= 0;
             lprBR[3] <= 0;
             lprBR[2] <= 0;
             lprBR[1] <= 0;
             lprBR[0] <= 0;
          end
        else if (lprWRITE)
          begin
             lprRXON <= dzDATAI[12];
             case (dzDATAI[2:0])
               7: lprBR[7] <= dzDATAI[11:8];
               6: lprBR[6] <= dzDATAI[11:8];
               5: lprBR[5] <= dzDATAI[11:8];
               4: lprBR[4] <= dzDATAI[11:8];
               3: lprBR[3] <= dzDATAI[11:8];
               2: lprBR[2] <= dzDATAI[11:8];
               1: lprBR[1] <= dzDATAI[11:8];
               0: lprBR[0] <= dzDATAI[11:8];
             endcase
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
   always @(posedge clk)
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

   wire [7:0] tdrDATA = dzDATAI[7:0];
   wire [7:0] tdrLOAD = (tdrWRITEL) ? tlineMUX : 8'b0;
                 
   //
   // Maintenance Loopback
   //
   
   wire [0:7] loopRXD = (csrMAINT) ? dz11TXD : dz11RXD;

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
      .brgSEL     (`BR9600),
      .brgCLKEN   (clkBR)
      );

   //
   // Generate Array of UARTS
   //
   // Details
   //  The 'generate' loops below builds 8 UARTS.
   //

   wire [0:7] ttyRXINTR;                // UART Receiver has data
   wire [0:7] ttyRXDATA[0:7];           // UART RX received data
   wire [0:7] ttyTXEMPTY;               // UART Transmitter buffer is empty
   genvar     i;

   generate
      
      for (i = 0; i < 8; i = i + 1)
        
        begin : uart_loop
           
           //
           // UART Transmitters
           //
           
           UART_BUFTX ttyTX
             (.clk      (clk),
              .rst      (rst | devRESET),
              .clkBR    (lprRXON & clkBR),
              .load     (tdrLOAD[i]),
              .data     (tdrDATA),
              .full     (),
              .empty    (ttyTXEMPTY[i]),
              .txd      (dz11TXD[i])
              );

           //
           // UART Receivers
           //
           
           UART_RX ttyRX
             (.clk      (clk),
              .rst      (rst | devRESET),
              .clkBR    (clkBR),
              .rxd      (loopRXD[i]),
              .intr     (ttyRXINTR[i]),
              .data     (ttyRXDATA[i])
              );
        end
      
   endgenerate
   
   //
   // RBUF FIFO
   //

   wire fifoEMPTY;
   wire [10:0] rbufDATA;
   wire csrSA;
   reg  [2:0] scan;
   reg  [7:0] scanMUX;
   
   dzfifo rxfifo
     (.clk      (clk),
      .rst      (rst | csrCLR | devRESET),
      .clken    (clken),
      .din      ({scan, ttyRXDATA[scanMUX]}),
      .wr       (ttyRXINTR[scanMUX]),
      .dout     (rbufDATA),
      .rd       (rbfREAD),
      .full     (),
      .alarm    (csrSA),
      .empty    (fifoEMPTY)
      );

   wire csrRDONE  = ~fifoEMPTY;
   wire rbufVALID = ~fifoEMPTY;
   
   //
   // Scanner
   //
   // Details
   //  This just increments the scan signal.
   //

   //reg [2:0] scan;
   always @(posedge clk)
     begin
        if (rst | csrCLR)
          scan <= 0;
        else if (csrMSE)
          scan <= scan + 1'b1;
     end

   //
   // Scan Decoder
   //
   
   //reg [7:0] scanMUX;
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
   // Bus Mux and little-endian to big-endian bus swap.
   //

   reg devACKO;
   reg [0:35] devDATAO;
   
   always @(csrREAD or regCSR or rbfREAD or regRBUF or
            tcrREAD or regTCR or msrREAD or regMSR)
     begin
        devACKO  = 0;             
        devDATAO = 36'bx;
        if (csrREAD)
          begin
             devACKO  = 1;             
             devDATAO = {20'b0, regCSR};
          end
        if (rbfREAD)
          begin
             devACKO  = 1;             
             devDATAO = {20'b0, regRBUF};
          end
        if (tcrREAD)
          begin
             devACKO  = 1;             
             devDATAO = {20'b0, regTCR};
          end
        if (msrREAD)
          begin
             devACKO  = 1;             
             devDATAO = {20'b0, regMSR};
          end
     end

   //
   // RX Interrupts
   //

   reg intSA;
   reg intRDONE;
   reg dzRXINTR;
   
   always @(posedge clk)
     begin
        if (rst | csrCLR | devRESET)
          begin
             intSA    <= 0;
             intRDONE <= 0;
             dzRXINTR <= 0;
          end
        else if (clken)
          begin
             if (csrRIE)
               begin
                  if (csrSAE)
                    begin
                       if (~intSA & csrSA)
                         dzRXINTR <= 1;
                       else if (~intRDONE & csrRDONE)
                         dzRXINTR <= 1;
                    end
               end
             else
               begin
                  dzRXINTR <= 0;
               end
             intSA    <= csrSA;
             intRDONE <= csrRDONE;
          end
     end
   
   //
   // TX Interrupts
   //

   reg dzTXINTR;
   reg intTRDY;
   
   always @(posedge clk)
     begin
        if (rst | csrCLR | devRESET)
          begin
             dzTXINTR <= 0;
             intTRDY  <= 0;
          end
        else if (clken)
          begin
             if (csrTIE)
               begin
                  if (~intTRDY & csrTRDY)
                    dzTXINTR <= 1;
               end
             else
               begin
                  dzTXINTR <= 0;
               end
             intTRDY <= csrTRDY;
          end
     end
   
   //
   // DZ11 Interrupt
   //

   reg [7:4] devINTR;
   always @(posedge clk)
     begin
        if (rst | csrCLR | devRESET)
          devINTR <= 0;
        else if (clken)
          begin
             if (dzRXINTR | dzTXINTR)
               devINTR <= dzINTR;
             else if (devINTA & dzINTR)
               devINTR <= 0;
          end
     end
   
endmodule
