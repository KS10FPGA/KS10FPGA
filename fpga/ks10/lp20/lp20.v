////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   LP20 Line Printer
//
// Details
//   The information used to design the LP20 was obtained from the following
//   DEC docmument:
//
//   "LP20 Line Printer Systerm Manuel" DEC Publication EK-LP20-TM-004
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
//   lp20.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2016 Rob Doyle
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

`include "lp20.vh"
`include "lpcsra.vh"
`include "lpcsrb.vh"
`include "lpbar.vh"
`include "lpbctr.vh"
`include "lppctr.vh"
`include "lpramd.vh"
`include "lpcbuf.vh"
`include "lpcksm.vh"
`include "../ks10.vh"
`include "../uba/ubabus.vh"

module LP20 (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      // LP20 Interfaces
      input  wire         lpONLINE,             // LP20 Online
      // Reset
      input  wire         devRESET,             // IO Bus Bridge Reset
      // Interrupt
      output wire [ 7: 4] devINTR,              // Interrupt Request
      input  wire [ 7: 4] devINTA,              // Interrupt Acknowledge
      // Target
      input  wire         devREQI,              // Device Request In
      output wire         devACKO,              // Device Acknowledge Out
      input  wire [ 0:35] devADDRI,             // Device Address In
      // Initiator
      output wire         devREQO,              // Device Request Out
      input  wire         devACKI,              // Device Acknowledge In
      output wire [ 0:35] devADDRO,             // Device Address Out
      // Data
      input  wire [ 0:35] devDATAI,             // Data In
      output reg  [ 0:35] devDATAO              // Data Out
   );

   //
   // DZ Parameters
   //

   parameter [14:17] lpDEV  = `lp1DEV;          // LP20 Device Number
   parameter [18:35] lpADDR = `lp1ADDR;         // LP20 Base Address
   parameter [18:35] lpVECT = `lp1VECT;         // LP20 Interrupt Vector
   parameter [ 7: 4] lpINTR = `lp1INTR;         // LP20 Interrupt

   //
   // DZ Register Addresses
   //

   localparam [18:35] csraADDR = lpADDR + `csraOFFSET;  // CSRA Register
   localparam [18:35] csrbADDR = lpADDR + `csrbOFFSET;  // CSRA Register
   localparam [18:35] barADDR  = lpADDR + `barOFFSET;   // BAR Register
   localparam [18:35] bctrADDR = lpADDR + `bctrOFFSET;  // BCTR Register
   localparam [18:35] pctrADDR = lpADDR + `pctrOFFSET;  // PCTR Register
   localparam [18:35] ramdADDR = lpADDR + `ramdOFFSET;  // RAMD Register
   localparam [18:35] cbufADDR = lpADDR + `cbufOFFSET;  // CBUF Register
   localparam [18:35] cksmADDR = lpADDR + `cksmOFFSET;  // CKSM Register

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
   // Address Decoding
   //
   // Trace
   //  M8586/LPC9/E26
   //  M8586/LPC9/E30
   //  M8586/LPC9/E31
   //

   wire vectREAD  = devREAD  & devIO & devPHYS & !devWRU &  devVECT & (devDEV == lpDEV);
   wire csraREAD  = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == csraADDR[18:34]);
   wire csraWRITE = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == csraADDR[18:34]);
   wire csrbREAD  = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == csraADDR[18:34]);
   wire csrbWRITE = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == csraADDR[18:34]);
   wire barREAD   = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == barADDR[18:34]);
   wire barWRITE  = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == barADDR[18:34]);
   wire bctrREAD  = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == bctrADDR[18:34]);
   wire bctrWRITE = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == bctrADDR[18:34]);
   wire pctrREAD  = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == pctrADDR[18:34]);
   wire pctrWRITE = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == pctrADDR[18:34]);
   wire ramdREAD  = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == ramdADDR[18:34]);
   wire ramdWRITE = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == ramdADDR[18:34]);
   wire cctrREAD  = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == cbufADDR[18:34]) & devHIBYTE;
   wire cctrWRITE = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == cbufADDR[18:34]) & devHIBYTE;
   wire cbufREAD  = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == cksmADDR[18:34]) & devLOBYTE;
   wire cbufWRITE = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == cksmADDR[18:34]) & devLOBYTE;
   wire cksmREAD  = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == cbufADDR[18:34]) & devHIBYTE;
   wire cksmWRITE = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == cbufADDR[18:34]) & devHIBYTE;
   wire pdatREAD  = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == cksmADDR[18:34]) & devLOBYTE;
   wire pdatWRITE = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == cksmADDR[18:34]) & devLOBYTE;

   //
   // Big-endian to little-endian data bus swap
   //

   wire [35:0] lpDATAI = devDATAI[0:35];

   //
   // Control/Status Register A
   //

   wire [15:0] regCSRA;
   wire        lpINIT = `lpCSRA_INIT(regCSRA);
   wire        lpECLR = `lpCSRA_ECLR(regCSRA);
   wire [ 1:0] lpMODE = `lpCSRA_MODE(regCSRA);

   //
   // Control/Status Register B
   //

   wire [15:0] regCSRB;
   wire        lpMPE  = `lpCSRB_MPE(regCSRB);
   wire        lpRPE  = `lpCSRB_RPE(regCSRB);
   wire        lpGOE  = `lpCSRB_GOE(regCSRB);

   //
   // Base Address Register
   //

   wire [17:0] regBAR;

   //
   //
   //

   wire [15:0] regBCTR;
   wire [15:0] regPCTR;
   wire [15:0] regRAMD;
   wire [ 7:0] regCCTR;
   wire [ 7:0] regCBUF;
   wire [ 7:0] regCKSM;
   wire [ 7:0] regPDAT;

   //
   // Signals
   //

   wire        lpPCZ;           // Page count zero
   wire        lpUNDC;          // Undefined character
   wire        lpDVON;          // DAVFU ready
   wire        lpDONE;          // Done
   wire        lpGO;            // Go
   wire        lpINCBAR;
   wire        lpDECPCTR;       // Decrement Page Counter
   wire        lpINCBCTR;       // Increment Byte Counter
   wire        lpINCCKSM;       // Update checksum

   wire        lpVAL   = 0;     // Valid (Not implemented)
   wire        lpNRDY  = 0;     //
   wire        lpDPAR  = 0;     //
   wire        lpOVFU  = 0;     //
   wire        lpOFFL  = 0;     //
   wire        lpDVOF  = 0;     //
   wire        lpLPE   = 0;     //
   wire        lpSETMPE   = 0;  //

   wire        lpSETRPE   = 0;  //
   wire        lpMTE   = 0;     //
   wire        lpDTE   = 0;     //
   wire        lpSETGOE   = 0;  //
   wire        lpGOCLR = 0;

   wire        lpSETERR;        // Set Error
   wire        lpSETDHLD;       // Set delimiter hold
   wire        lpCMDGO;         // Go command
   wire        lpGORST;
   wire [ 7:0] lpDATA;          // byte data to checksum

   //
   // Control/Status Register A (CSRA)
   //

   LPCSRA CSRA (
      .clk        (clk),
      .rst        (rst),
      .devRESET   (devRESET),
      .devLOBYTE  (devLOBYTE),
      .devHIBYTE  (devHIBYTE),
      .lpDATAI    (lpDATAI),
      .csraWRITE  (csraWRITE),
      .lpPCZ      (lpPCZ),
      .lpUNDC     (lpUNDC),
      .lpDVON     (lpDVON),
      .lpONLINE   (lpONLINE),
      .lpDONE     (lpDONE),
      .lpGO       (lpGO),
      .lpLPE      (lpLPE),
      .lpMPE      (lpMPE),
      .lpRPE      (lpRPE),
      .lpMTE      (lpMTE),
      .lpDTE      (lpDTE),
      .lpGOE      (lpGOE),
      .lpSETDHLD  (lpSETDHLD),
      .lpCMDGO    (lpCMDGO),
      .regBAR     (regBAR),
      .regCSRA    (regCSRA)
   );

   //
   // Control/Status Register B (CSRB)
   //

   LPCSRB CSRB (
      .clk        (clk),
      .rst        (rst),
      .devRESET   (devRESET),
      .devLOBYTE  (devLOBYTE),
      .devHIBYTE  (devHIBYTE),
      .lpDATAI    (lpDATAI),
      .csrbWRITE  (csrbWRITE),
      .lpINIT     (lpINIT),
      .lpVAL      (lpVAL),
      .lpNRDY     (lpNRDY),
      .lpDPAR     (lpDPAR),
      .lpOVFU     (lpOVFU),
      .lpOFFL     (lpOFFL),
      .lpDVOF     (lpDVOF),
      .lpLPE      (lpLPE),
      .lpSETMPE   (lpSETMPE),
      .lpSETRPE   (lpSETRPE),
      .lpMTE      (lpMTE),
      .lpDTE      (lpDTE),
      .lpSETGOE   (lpSETGOE),
      .regCSRB    (regCSRB)
   );

   //
   // Bus Address Register (BAR)
   //

   LPBAR BAR (
      .clk        (clk),
      .rst        (rst),
      .devLOBYTE  (devLOBYTE),
      .lpDATAI    (lpDATAI),
      .barWRITE   (barWRITE),
      .csraWRITE  (csraWRITE),
      .lpINIT     (lpINIT),
      .lpINCBAR   (lpINCBAR),
      .regBAR     (regBAR)
   );

   //
   // Byte Counter Register (BCTR)
   //

   LPBCTR BCTR (
      .clk        (clk),
      .rst        (rst),
      .lpDATAI    (lpDATAI),
      .bctrWRITE  (bctrWRITE),
      .lpINIT     (lpINIT),
      .lpINCBCTR  (lpINCBCTR),
      .regBCTR    (regBCTR)
   );

   //
   // Column Counter Register (CCTR)
   //

/*

   LPCCTR CCTR (
      .clk        (clk),
      .rst        (rst),
      .devRESET   (devRESET),
      .devLOBYTE  (devLOBYTE),
      .devHIBYTE  (devHIBYTE),
 .devDATAI   (devDATAI),
      .cctrWRITE  (cctrWRITE),
      .lpINIT     (lpINIT),

      .regCCTR    (regCCTR)
   );
*/

   //
   // Page Count Register (LPPCTR)
   //

   LPPCTR PCTR (
      .clk        (clk),
      .rst        (rst),
      .lpDATAI    (lpDATAI),
      .pctrWRITE  (pctrWRITE),
      .lpINIT     (lpINIT),
      .lpDECPCTR  (lpDECPCTR),
      .lpPCZ      (lpPCZ),
      .regPCTR    (regPCTR)
   );

   //
   // Checksum Register (CKSM)
   //

   LPCKSM CKSM (
      .clk        (clk),
      .rst        (rst),
      .lpGOCLR    (lpGOCLR),
      .lpDATA     (lpDATA),
      .lpINCCKSM  (lpINCCKSM),
      .regCKSM    (regCKSM)
   );

   //
   // LPCTRL
   //

   LPCTRL CTRL (
      .clk        (clk),
      .rst        (rst),
      .lpMODE     (lpMODE),
      .lpCMDGO    (lpCMDGO),

      .lpINCBAR   (lpINCBAR)
   );

   //
   // Generate Bus ACK
   //

   assign devACKO = (csraREAD | csraWRITE |
                     csrbREAD | csrbWRITE |
                     barREAD  | barWRITE  |
                     bctrREAD | bctrWRITE |
                     pctrREAD | pctrWRITE |
                     ramdREAD | ramdWRITE |
                     cctrREAD | cctrWRITE |
                     cbufREAD | cbufWRITE |
                     cksmREAD | cksmWRITE |
                     pdatREAD | pdatWRITE |
                     vectREAD);

   //
   // Bus Mux and little-endian to big-endian bus swap
   //
   // Trace
   //  M8587/LPD3/E1
   //  M8587/LPD3/E5
   //  M8587/LPD3/E13
   //  M8587/LPD3/E21
   //  M8587/LPD3/E29
   //  M8587/LPD3/E37
   //  M8587/LPD3/E45
   //  M8587/LPD3/E46
   //  M8587/LPD3/E60
   //  M8587/LPD3/E69
   //  M8587/LPD3/E70
   //  M8587/LPD3/E71
   //  M8587/LPD3/E54
   //  M8587/LPD3/E61
   //  M8587/LPD3/E60
   //  M8587/LPD3/E53
   //

   always @*
     begin
        devDATAO = 36'bx;
        if (csraREAD)
          devDATAO = {20'b0, regCSRA};
        if (csrbREAD)
          devDATAO = {20'b0, regCSRB};
        if (barREAD)
          devDATAO = {20'b0, regBAR};
        if (bctrREAD)
          devDATAO = {20'b0, regBCTR};
        if (pctrREAD)
          devDATAO = {20'b0, regPCTR};
         if (ramdREAD)
          devDATAO = {20'b0, regRAMD};
        if (cctrREAD | cbufREAD)
          devDATAO = {20'b0, regCCTR, regCBUF};
        if (cksmREAD | pdatREAD)
          devDATAO = {20'b0, regCKSM, regPDAT};
        if (vectREAD)
          devDATAO = lpVECT;
     end

endmodule
