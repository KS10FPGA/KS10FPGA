////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      KS-10 DZ11 
//!
//! \details
//!      Important addresses:
//!
//! \todo
//!
//! \file
//!      dz11.v
//!
//! \author
//!      Rob Doyle - doyle (at) cox (dot) net
//!
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
//
// Comments are formatted for doxygen
//

`default_nettype none
  
module DZ11(clk, rst, clken, TXD, RXD, curINTR_NUM,
            busINTR, busREQI, busREQO, busACKI, busACKO,
            busADDRI, busADDRO, busDATAI, busDATAO);
             
   input         clk;           // Clock
   input         rst;           // Reset
   input         clken;         // Clock enable
   input  [0: 3] RXD;           // Received Serial Data
   output [0: 3] TXD;           // Transmitted Serial Data
   input  [0: 2] curINTR_NUM;   // Current Interrupt Priority
   output [1: 7] busINTR;       // Unibus Interrupt Request
   input         busREQI;       // Unibus Request In
   output        busREQO;       // Unibus Request Out
   input         busACKI;       // Unibus Acknowledge In
   output        busACKO;       // Unibus Acknowledge Out
   input  [0:35] busADDRI;      // Bus Address In
   output [0:35] busADDRO;      // Bus Address Out
   input  [0:35] busDATAI;      // Unibus Data In
   output [0:35] busDATAO;      // Unibus Data Out

   //
   // DZ Unibus Parameters
   //

   parameter [14:17] dz1DEV   = 4'd3;           // Device 3
   parameter [18:35] dz1VECT  = 18'o000340;     // Interrupt Vector
   parameter [18:35] dz1WRU   = 18'o200000;     // WRU Response
   parameter [ 7: 4] dz1INTR  = 4'b0010;        // Interrupt 5
   parameter [18:35] csrADDR  = 18'o760010;     // CSR Address
   parameter [18:35] rbufADDR = 18'o760012;     // RBUF Address
   parameter [18:35] lprADDR  = 18'o760014;     // LPR Address
   parameter [18:35] tcrADDR  = 18'o760014;     // TCR Address
   parameter [18:35] msrADDR  = 18'o760016;     // MSR Address
   parameter [18:35] tdrADDR  = 18'o760016;     // TDR Address

   //
   // Memory Address and Flags
   //
   // Details:
   //  busADDRI[ 0:13] is flags
   //  busADDRI[14:35] is address
   //
   
   wire         busREAD   = busADDRI[ 3];       // 1 = Read Cycle (IO or Memory)
   wire         busWRITE  = busADDRI[ 5];       // 1 = Write Cycle (IO or Memory)
   wire         busIO     = busADDRI[10];       // 1 = IO Cycle, 0 = Memory Cycle
   wire         busIOBYTE = busADDRI[13];       // 1 = Unibus Byte IO Operation
   wire [14:17] busDEV    = busADDRI[14:17];    // Unibus Device Number
   wire [18:35] busADDR   = busADDRI[18:35];    // Unibus Address

   //
   // Unibus Reset
   //

   wire ubaRESET;
   
   //
   // CSR Register
   //
   // Details
   //  CSR is read/write and can be accessed as bytes or words
   //
   // Note
   //  The LSB decodes bytes
   //
   
   wire csrREAD   = busIO & busREAD  & (busDEV == dz1DEV) & (busADDR[18:34] == csrADDR[18:34]);
   wire csrWRITE  = busIO & busWRITE & (busDEV == dz1DEV) & (busADDR[18:34] == csrADDR[18:34]);
   wire csrWRITEH = ((csrWRITE & busIOBYTE & (busADDRI[35] == 1'b1)) | (csrWRITE & ~busIOBYTE));
   wire csrWRITEL = ((csrWRITE & busIOBYTE & (busADDRI[35] == 1'b0)) | (csrWRITE & ~busIOBYTE));

   reg csrTIE;
   reg csrSAE;
   reg csrRIE;
   reg csrMSE;
   reg csrCLR;
   reg csrMAINT;
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             csrTIE   <= 1'b0;
             csrSAE   <= 1'b0;
             csrRIE   <= 1'b0;
             csrMSE   <= 1'b0;
             csrCLR   <= 1'b0;
             csrMAINT <= 1'b0;
          end
        else
          begin
             if (csrWRITEH)
               begin
                  csrTIE   <= busDATAI[21];
                  csrSAE   <= busDATAI[23];
               end
             if (csrWRITEL)
               begin
                  csrRIE   <= busDATAI[29];
                  csrMSE   <= busDATAI[30];
                  csrCLR   <= busDATAI[31];
                  csrMAINT <= busDATAI[32];
               end
          end
     end              

   wire [2:0] csrTLINE = 3'b0;
   wire       csrRDONE = csrRIE & csrSAE;
   wire       csrSA    = 1'b0;
   wire       csrTRDY  = 1'b0;
   
   wire [0:35] regCSR = {20'b0,
                         csrTRDY,  csrTIE, csrSA, csrSAE,  1'b0, csrTLINE[2:0], 
                         csrRDONE, csrRIE, csrMSE, csrCLR, csrMAINT, 3'b0};
   
   //
   // RBUF Register
   //
   // Details
   //  RBUF is read only and can only be read as words
   //
   // Note
   //  The LSB decodes bytes
   //

   wire        rxfifoEMPTY;
   wire        rxfifoFULL;
   wire [0:10] rxfifoDOUT;
   wire rbufREAD       = busIO & busREAD  & ~busIOBYTE & (busDEV == dz1DEV) & (busADDR[18:34] == rbufADDR[18:34]);
   wire [0:15] regRBUF = {~rxfifoEMPTY, 4'b0, rxfifoDOUT};

   //
   // LPR Register
   //
   // Details
   //  LPR is write only and can only be written as words
   //
   // Note
   //  The LSB decodes bytes
   //
   
   wire lprWRITE  = busIO & busWRITE & ~busIOBYTE & (busDEV == dz1DEV) & (busADDR[18:34] == lprADDR [18:34]);

   reg lprRXON;
   reg [0:3] lprBR[0:3];
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             lprRXON  <= 1'b0;
             lprBR[0] <= 4'b0;
             lprBR[1] <= 4'b0;
             lprBR[2] <= 4'b0;
             lprBR[3] <= 4'b0;
          end
        else if (lprWRITE)
          begin
             lprRXON <= busDATAI[23];
             if (busDATAI[33] == 1'b0)
               lprBR[busDATAI[33:34]] <= busDATAI[24:27];
          end
     end
 
   //
   // TCR Reguster
   //
   // Details
   //  TCR is read/write and can be accessed as bytes or words
   //
   // Note
   //  The LSB decodes bytes
   //
 
   wire tcrREAD   = busIO & busREAD  & (busDEV == dz1DEV) & (busADDR[18:34] == tcrADDR[18:34]);
   wire tcrWRITE  = busIO & busWRITE & (busDEV == dz1DEV) & (busADDR[18:34] == tcrADDR[18:34]);
   wire tcrWRITEH = ((tcrWRITE & busIOBYTE & (busADDRI[35] == 1'b1)) | (tcrWRITE & ~busIOBYTE));
   wire tcrWRITEL = ((tcrWRITE & busIOBYTE & (busADDRI[35] == 1'b0)) | (tcrWRITE & ~busIOBYTE));

   reg [16:0] regTCR;
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          regTCR <= 16'b0;
        else
          begin
             if (tcrWRITEH)
               regTCR[16:8] <= busDATAI[20:27];
             if (tcrWRITEL)
               regTCR[ 7:0] <= busDATAI[28:35];
          end
     end
        
   //
   // MSR Register
   //
   // Details
   //  MSR can be accessed as bytes or words
   //
   // Note
   //  The LSB decodes bytes
   //
         
   wire msrREAD = busIO & busREAD  & (busDEV == dz1DEV) & (busADDR[18:34] == msrADDR[18:34]);
   wire [0:35] regMSR = 36'b0;

   //
   // TDR Register
   //
   // Details
   //  TDR can be accessed as bytes or words
   //
   // Note
   //  The LSB decodes bytes
   //
   
   wire tdrWRITE  = busIO & busWRITE & (busDEV == dz1DEV) & (busADDR[18:34] == tdrADDR[18:34]);
   wire tdrWRITEH = ((tdrWRITE & busIOBYTE & (busADDRI[35] == 1'b1)) | (tdrWRITE & ~busIOBYTE));
   wire tdrWRITEL = ((tdrWRITE & busIOBYTE & (busADDRI[35] == 1'b0)) | (tdrWRITE & ~busIOBYTE));

   //
   // KS10 Interface
   //

   wire         ubaACKO;
   wire [ 0:35] ubaDATAO;
   wire [17: 0] ubaADDRI;
   wire         pageVALID;
   wire         forceRPW;
   wire         fastMODE;
   wire         enable16;

   wire [7:4]   ubaINTA;
                
   UBA DZUBA
     (.clk              (clk),
      .rst              (rst),
      .clken            (clken),
      .ubaDEV           (dz1DEV),
      .ubaVECT          (dz1VECT),
      .ubaWRU           (dz1WRU),
      .ubaINTR          (dz1INTR),
      .ubaINTA          (ubaINTA),
      .ubaRESET         (ubaRESET),
      .busREQI          (busREQI),
      .busREQO          (busREQO),
      .busACKI          (busACKI),
      .busACKO          (ubaACKO),
      .busADDRI         (busADDRI),
      .busADDRO         (busADDRO),
      .busDATAI         (busDATAI),
      .busDATAO         (ubaDATAO),
      .busINTR 		(busINTR),
      .ubaADDRI         (ubaADDRI),
      .pageVALID        (pageVALID),
      .forceRPW         (forceRPW),
      .fastMODE         (fastMODE),
      .enable16         (enable16)
      );

   //
   // UART Interfaces
   //

   wire [0:7] ttyTXDATA[0:3];
   wire [0:7] ttyRXDATA[0:3];
   wire       clkBR    [0:3];
   wire       ttyTXLOAD[0:3];
   wire       ttyTXINTR[0:3];
   wire       ttyRXINTR[0:3];

   //
   // Generate Array of UARTS
   //
   
   genvar i;

   generate
      
      for (i = 0; i < 4; i = i+1)
        
        begin : uartINTF

           //
           // UART Baud Rate Generators
           //

           eUART_BRG ttyBRG
           (.clk        (clk),
            .rst        (rst),
            .uartBR     (lprBR[i]),
            .clkBR      (clkBR[i])
            );
           
           //
           // UART Transmitters
           //
           
           eUART_TX ttyTX
             (.clk      (clk),
              .rst      (rst),
              .clkBR    (clkBR[i]),
              .data     (ttyTXDATA[i]),
              .load     (ttyTXLOAD[i]),
              .intr     (ttyTXINTR[i]),
              .txd      (TXD[i])
              );

           //
           // UART Receivers
           //
           
           eUART_RX ttyRX
             (.clk      (clk),
              .rst      (rst),
              .clkBR    (clkBR[i]),
              .rxd      (RXD[i]),
              .intr     (ttyRXINTR[i]),
              .data     (ttyRXDATA[i])
              );
        end
      
   endgenerate

   //
   // RBUF FIFO
   //
   
   fifo64x11 rxfifo
     (.clk      (clk),
      .rst      (rst),
      .clken    (clken),
      .din      (),
      .wr       (),
      .dout     (),
      .rd       (),
      .full     (rxfifoFULL),
      .empty    (rxfifoEMPTY)
      );

   //
   //
   //

   reg busACKO;
   reg [0:35] busDATAO;
   
   always @(csrREAD or regCSR or rbufREAD or regRBUF or tcrREAD or regTCR or msrREAD or regMSR or ubaACKO or ubaDATAO)
     begin
        busACKO  = 1'b0;             
        busDATAO = 36'bx;
        if (csrREAD)
          begin
             busACKO  = 1'b1;             
             busDATAO = regCSR;
          end
        if (rbufREAD)
          begin
             busACKO  = 1'b1;             
             busDATAO = regRBUF;
          end
        if (tcrREAD)
          begin
             busACKO  = 1'b1;             
             busDATAO = regTCR;
          end
        if (msrREAD)
          begin
             busACKO  = 1'b1;             
             busDATAO = regMSR;
          end
        if (ubaACKO)
          begin
             busACKO  = ubaACKO;
             busDATAO = ubaDATAO;
          end
     end
   
endmodule
