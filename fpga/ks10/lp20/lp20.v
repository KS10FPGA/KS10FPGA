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
//   "LP20 Line Printer Systerm Manuel" DEC Publication EK-LP20-TM-004, and
//   "MP00006_LP20_Nov75, LP20 Line PRinter System Field Maintenance Print Set"
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

`include "lp20.vh"
`include "lpcsra.vh"
`include "lpcsrb.vh"
`include "lpbar.vh"
`include "lpbctr.vh"
`include "lppctr.vh"
`include "lpramd.vh"
`include "lpcbuf.vh"
`include "lpcksm.vh"
`include "../uba/ubabus.vh"

module LP20 (
      input  wire         clk,                          // Clock
      input  wire         rst,                          // Reset
      // LP20 Interfaces
      input  wire         lpOVFU,                       // Optical vertical format unit
      // Reset
      input  wire         devRESET,                     // IO Bus Bridge Reset
      // Interrupt
      output wire [ 7: 4] devINTR,                      // Interrupt Request
      input  wire [ 7: 4] devINTA,                      // Interrupt Acknowledge
      // Target
      input  wire         devREQI,                      // Device Request In
      output wire         devACKO,                      // Device Acknowledge Out
      input  wire [ 0:35] devADDRI,                     // Device Address In
      // Initiator
      output wire         devREQO,                      // Device Request Out
      input  wire         devACKI,                      // Device Acknowledge In
      output wire [ 0:35] devADDRO,                     // Device Address Out
      // Data
      input  wire [ 0:35] devDATAI,                     // Data In
      output reg  [ 0:35] devDATAO,                     // Data Out
      // LP26 Interfaces
      output wire         lpINIT,                       // LP26 initialize
      input  wire         lpONLINE,                     // LP26 online status
      input  wire         lpPARERR,                     // LP26 printer parity error
      input  wire         lpDEMAND,                     // LP26 printer is ready for next character
      input  wire         lpVFURDY,                     // LP26 DAVFU is ready
      output wire         lpPI,                         // LP26 printer paper instruction
      input  wire         lpTOF,                        // LP26 printer is at top of form
      output wire [ 8: 1] lpDATA,                       // LP26 printer data
      output wire         lpDPAR,                       // LP26 printer data parity
      output wire         lpSTROBE                      // LP26 printer data strobe
   );

`ifndef SYNTHESIS

   integer file;

`endif

   //
   // LP Parameters
   //

   parameter [14:17] lpDEV  = `lp1DEV;                  // LP20 Device Number
   parameter [18:35] lpADDR = `lp1ADDR;                 // LP20 Base Address
   parameter [18:35] lpVECT = `lp1VECT;                 // LP20 Interrupt Vector
   parameter [ 7: 4] lpINTR = `lp1INTR;                 // LP20 Interrupt

   //
   // LP Register Addresses
   //

   localparam [18:35] csraADDR = lpADDR + `csraOFFSET;  // CSRA Register
   localparam [18:35] csrbADDR = lpADDR + `csrbOFFSET;  // CSRA Register
   localparam [18:35] barADDR  = lpADDR + `barOFFSET;   // BAR Register
   localparam [18:35] bctrADDR = lpADDR + `bctrOFFSET;  // BCTR Register
   localparam [18:35] pctrADDR = lpADDR + `pctrOFFSET;  // PCTR Register
   localparam [18:35] ramdADDR = lpADDR + `ramdOFFSET;  // RAMD Register
   localparam [18:35] cctrADDR = lpADDR + `cctrOFFSET;  // CCTR Register
   localparam [18:35] cbufADDR = lpADDR + `cbufOFFSET;  // CBUF Register
   localparam [18:35] cksmADDR = lpADDR + `cksmOFFSET;  // CKSM Register
   localparam [18:35] pdatADDR = lpADDR + `pdatOFFSET;  // PDAT Register

   //
   // Address Flags
   //

   localparam [0:17] rdFLAGS = 18'b000_100_000_000_000_000;
   localparam [0:17] wrFLAGS = 18'b000_001_000_000_000_000;

   //
   // Device Address and Flags
   //

   wire         devREAD   = `devREAD(devADDRI);         // Read Cycle
   wire         devWRITE  = `devWRITE(devADDRI);        // Write Cycle
   wire         devPHYS   = `devPHYS(devADDRI);         // Physical reference
   wire         devIO     = `devIO(devADDRI);           // IO Cycle
   wire         devWRU    = `devWRU(devADDRI);          // WRU Cycle
   wire         devVECT   = `devVECT(devADDRI);         // Read interrupt vector
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
   wire csrbREAD  = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == csrbADDR[18:34]);
   wire csrbWRITE = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == csrbADDR[18:34]);
   wire barREAD   = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == barADDR[18:34]);
   wire barWRITE  = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == barADDR[18:34]);
   wire bctrREAD  = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == bctrADDR[18:34]);
   wire bctrWRITE = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == bctrADDR[18:34]);
   wire pctrREAD  = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == pctrADDR[18:34]);
   wire pctrWRITE = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == pctrADDR[18:34]);
   wire ramdREAD  = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == ramdADDR[18:34]);
   wire ramdWRITE = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == ramdADDR[18:34]);
   wire cctrREAD  = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == cctrADDR[18:34]) & devHIBYTE;
   wire cctrWRITE = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == cctrADDR[18:34]) & devHIBYTE;
   wire cbufREAD  = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == cbufADDR[18:34]) & devLOBYTE;
   wire cbufWRITE = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == cbufADDR[18:34]) & devLOBYTE;
   wire cksmREAD  = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == cksmADDR[18:34]) & devHIBYTE;
   wire cksmWRITE = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == cksmADDR[18:34]) & devHIBYTE;
   wire pdatREAD  = devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == pdatADDR[18:34]) & devLOBYTE;
   wire pdatWRITE = devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == lpDEV) & (devADDR == pdatADDR[18:34]) & devLOBYTE;

   //
   // Big-endian to little-endian data bus swap
   //

   wire [35:0] lpDATAI = devDATAI[0:35];

   //
   // Registers
   //

   wire [15:0] regCSRA;
   wire [15:0] regCSRB;
   wire [17:0] regBAR;
   wire [15:0] regBCTR;
   wire [15:0] regPCTR;
   wire [15:0] regRAMD;
   wire [ 7:0] regCCTR;
   wire [ 7:0] regCBUF;
   wire [ 7:0] regCKSM;
   wire [ 7:0] regPDAT;

   //
   // Control/Status Register A Decode
   //

   wire        lpERR  = `lpCSRA_ERR(regCSRA);
   wire        lpDHLD = `lpCSRA_DHLD(regCSRA);
   wire        lpECLR = `lpCSRA_ECLR(regCSRA);
   assign      lpINIT = `lpCSRA_INIT(regCSRA);
   wire        lpDONE = `lpCSRA_DONE(regCSRA);
   wire        lpIE   = `lpCSRA_IE(regCSRA);
   wire [ 1:0] lpMODE = `lpCSRA_MODE(regCSRA);
   wire        lpPAR  = `lpCSRA_PAR(regCSRA);

   //
   // Modes
   //

   wire        lpMODEPRINT = (lpMODE == `lpCSRA_MODE_PRINT);
   wire        lpMODETEST  = (lpMODE == `lpCSRA_MODE_TEST);
   wire        lpMODELDVFU = (lpMODE == `lpCSRA_MODE_DAVFU);
   wire        lpMODELDRAM = (lpMODE == `lpCSRA_MODE_RAM);

   //
   // Control/Status Register B Decode
   //

   wire [ 2:0] lpTEST = `lpCSRB_TEST(regCSRB);

   //
   // Go/Stop Command
   //

   wire lpCMDGO   = csraWRITE & devLOBYTE &  `lpCSRA_GO(lpDATAI);
   wire lpCMDSTOP = csraWRITE & devLOBYTE & !`lpCSRA_GO(lpDATAI);

   //
   // Signals
   //

   wire lpGO;                           // DMA is active
   wire lpREADY;                        // Enable the next DMA transaction
   wire lpSETIRQ;                       // Interrupt request
   wire lpSETPCZ;                       // Page counter is zero
   wire lpSETDONE;                      // Byte counter is done (done with DMA)
   wire lpINCR;                         // Increment bus address, byte count, and RAM address
   wire lpINCCCTR;                      // Increment Column Counter
   wire lpCLRCCTR;                      // Clear Colunn Counter
   wire lpSETRPE;                       // Set RAM parity error
   wire lpSETMPE;                       // Set memory parity error
   wire lpSETMSYN;                      // Set IO bus timeout error
   wire lpSETUNDC;                      // Set undefined character
   wire lpSETDHLD;                      // Set delimiter hold
   wire lpCLRDHLD;                      // Clr delimiter hold
   wire lpVAL;                          // Printer valid data
   wire lpLPE;                          // Line printer parity error
   wire lpSETDTE;                       // Set demand timeout error

//   wire lpVFUERR;                     // VFU error

   wire lpSETGOE = lpCMDGO & lpERR;     // Set GO error

   //
   // Test Demand timeout timer
   //

   wire lpTESTDTE = (lpMODE == `lpCSRA_MODE_RAM) & (lpTEST == `lpCSRB_TEST_DTE);

   //
   // Test DMA Acknowledge timeout timer
   //

   wire lpTESTMSYN = (lpMODE == `lpCSRA_MODE_RAM) & (lpTEST == `lpCSRB_TEST_MSYN);

   //
   // Test RAM Parity
   //

   wire lpTESTRPE = (lpMODE == `lpCSRA_MODE_TEST) & (lpTEST == `lpCSRB_TEST_RAMPAR);

   //
   // Test Memory Parity
   //

   wire lpTESTMPE = (lpMODE == `lpCSRA_MODE_RAM) & (lpTEST == `lpCSRB_TEST_MEMPAR);

   //
   // Test Line Printer parity
   //

   wire lpTESTLPE = lpTEST == `lpCSRB_TEST_LPTPAR;

   //
   // Test Page Counter
   //

   wire lpTESTPCTR = (lpMODE == `lpCSRA_MODE_TEST) & (lpTEST == `lpCSRB_TEST_PCTR);

   //
   // Control/Status Register A (CSRA)
   //

   LPCSRA CSRA (
      .clk        (clk),
      .rst        (rst),
      .devRESET   (devRESET),
      .devLOBYTE  (devLOBYTE),
      .devHIBYTE  (devHIBYTE),
      .csraWRITE  (csraWRITE),
      .bctrWRITE  (bctrWRITE),
      .pctrWRITE  (pctrWRITE),
      .lpDATAI    (lpDATAI),
      .lpONLINE   (lpONLINE),
      .lpGO       (lpGO),
      .lpLPE      (lpLPE),
      .lpVFURDY   (lpVFURDY),
      .lpCMDGO    (lpCMDGO),
      .lpSETUNDC  (lpSETUNDC),
      .lpSETMPE   (lpSETMPE),
      .lpSETRPE   (lpSETRPE),
      .lpSETMSYN  (lpSETMSYN),
      .lpSETDHLD  (lpSETDHLD),
      .lpCLRDHLD  (lpCLRDHLD),
      .lpSETDTE   (lpSETDTE),
      .lpSETGOE   (lpSETGOE),
      .lpSETPCZ   (lpSETPCZ),
      .lpSETDONE  (lpSETDONE),
      .lpSETIRQ   (lpSETIRQ),
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
      .csrbWRITE  (csrbWRITE),
      .lpDATAI    (lpDATAI),
      .lpINIT     (lpINIT),
      .lpECLR     (lpECLR),
      .lpOVFU     (lpOVFU),
      .lpVFURDY   (lpVFURDY),
      .lpVAL      (lpVAL),
      .lpLPE      (lpLPE),
      .lpDPAR     (lpDPAR),
      .lpONLINE   (lpONLINE),
      .lpSETMPE   (lpSETMPE),
      .lpSETRPE   (lpSETRPE),
      .lpSETMSYN  (lpSETMSYN),
      .lpSETGOE   (lpSETGOE),
      .lpSETDTE   (lpSETDTE),
      .regCSRB    (regCSRB)
   );

   //
   // Bus Address Register (BAR)
   //

   LPBAR BAR (
      .clk        (clk),
      .rst        (rst),
      .lpINIT     (lpINIT),
      .devLOBYTE  (devLOBYTE),
      .lpDATAI    (lpDATAI),
      .barWRITE   (barWRITE),
      .csraWRITE  (csraWRITE),
      .lpINCBAR   (lpINCR),
      .regBAR     (regBAR)
   );

   //
   // Byte Counter Register (BCTR)
   //

   LPBCTR BCTR (
      .clk        (clk),
      .rst        (rst),
      .lpINIT     (lpINIT),
      .lpDATAI    (lpDATAI),
      .bctrWRITE  (bctrWRITE),
      .lpINCBCTR  (lpINCR),
      .lpSETDONE  (lpSETDONE),
      .regBCTR    (regBCTR)
   );

   //
   // Column Counter Register (CCTR)
   //

   LPCCTR CCTR (
      .clk        (clk),
      .rst        (rst),
      .lpINIT     (lpINIT),
      .lpDATAI    (lpDATAI),
      .cctrWRITE  (cctrWRITE),
      .lpCLRCCTR  (lpCLRCCTR),
      .lpINCCCTR  (lpINCCCTR),
      .regCCTR    (regCCTR)
   );

   //
   // Page Count Register (PCTR)
   //

   LPPCTR PCTR (
      .clk        (clk),
      .rst        (rst),
      .lpDATAI    (lpDATAI),
      .csrbWRITE  (csrbWRITE),
      .pctrWRITE  (pctrWRITE),
      .lpINIT     (lpINIT),
      .lpTOF      (lpTOF),
      .lpTESTPCTR (lpTESTPCTR),
      .lpSETPCZ   (lpSETPCZ),
      .regPCTR    (regPCTR)
   );

   //
   // RAM Data (RAMD)
   //

   LPRAMD RAMD (
      .clk        (clk),
      .rst        (rst),
      .devREQO    (devREQO),
      .devACKI    (devACKI),
      .lpINIT     (lpINIT),
      .lpDATAI    (lpDATAI),
      .cbufWRITE  (cbufWRITE),
      .ramdWRITE  (ramdWRITE),
      .lpERR      (lpERR),
      .lpPAR      (lpPAR),
      .lpTESTRPE  (lpTESTRPE),
      .lpMODEPRINT(lpMODEPRINT),
      .lpMODETEST (lpMODETEST),
      .lpMODELDVFU(lpMODELDVFU),
      .lpMODELDRAM(lpMODELDRAM),
      .lpCMDGO    (lpCMDGO),
      .lpINCADDR  (lpINCR),
      .lpSETRPE   (lpSETRPE),
      .lpSETDHLD  (lpSETDHLD),
      .lpCLRDHLD  (lpCLRDHLD),
      .regBAR     (regBAR),
      .regRAMD    (regRAMD)
   );

   //
   // Character Buffer Register (CBUF)
   //

   LPCBUF CBUF (
      .clk        (clk),
      .rst        (rst),
      .devREQO    (devREQO),
      .devACKI    (devACKI),
      .cbufWRITE  (cbufWRITE),
      .lpINIT     (lpINIT),
      .lpDATAI    (lpDATAI),
      .lpMODELDRAM(lpMODELDRAM),
      .regBAR     (regBAR),
      .regCBUF    (regCBUF)
   );

   //
   // Checksum Register (CKSM)
   //

   LPCKSM CKSM (
      .clk        (clk),
      .rst        (rst),
      .devREQO    (devREQO),
      .devACKI    (devACKI),
      .lpDATAI    (lpDATAI),
      .lpCMDGO    (lpCMDGO),
      .regBAR     (regBAR),
      .regCKSM    (regCKSM)
   );

   //
   // Printer Data Interface (LPPDAT)
   //

   LPPDAT PDAT (
      .clk        (clk),
      .rst        (rst),
      .devREQO    (devREQO),
      .devACKI    (devACKI),
      .lpINIT     (lpINIT),
      .lpCBUF     (regCBUF),
      .lpRAMD     (regRAMD),
      .lpCCTR     (regCCTR),
      .lpMODETEST (lpMODETEST),
      .lpMODEPRINT(lpMODEPRINT),
      .lpMODELDVFU(lpMODELDVFU),
      .lpTESTDTE  (lpTESTDTE),
      .lpTESTLPE  (lpTESTLPE),
      .lpDHLD     (lpDHLD),
      .lpCMDGO    (lpCMDGO),
      .lpCLRCCTR  (lpCLRCCTR),
      .lpINCCCTR  (lpINCCCTR),
      .lpSETUNDC  (lpSETUNDC),
      .lpSETDTE   (lpSETDTE),
      .lpREADY    (lpREADY),
      .lpLPE      (lpLPE),
      .lpVAL      (lpVAL),
      .lpPDAT     (regPDAT),
      // Printer interfaces
      .lpPARERR   (lpPARERR),
      .lpDEMAND   (lpDEMAND),
      .lpDPAR     (lpDPAR),
      .lpPI       (lpPI),
      .lpSTROBE   (lpSTROBE),
      .lpDATA     (lpDATA)
   );

   //
   // DMA Controller (LPCTRL)
   //

   LPDMA DMA (
      .clk        (clk),
      .rst        (rst),
      .devREQO    (devREQO),
      .devACKI    (devACKI),
      .lpDATAI    (lpDATAI),
      .lpDONE     (lpDONE),
      .lpTESTMSYN (lpTESTMSYN),
      .lpTESTMPE  (lpTESTMPE),
      .lpERR      (lpERR),
      .lpCMDGO    (lpCMDGO),
      .lpCMDSTOP  (lpCMDSTOP),
      .lpREADY    (lpREADY),
      .lpGO       (lpGO),
      .lpSETMPE   (lpSETMPE),
      .lpSETMSYN  (lpSETMSYN),
      .lpINCR     (lpINCR)
   );

   //
   // Interrupt Controller (LPINTR)
   //

   LPINTR INTR (
      .clk        (clk),
      .rst        (rst),
      .devWRU     (devWRU),
      .vectREAD   (vectREAD),
      .csraREAD   (csraREAD),
      .lpINIT     (lpINIT),
      .lpIE       (lpIE),
      .lpSETIRQ   (lpSETIRQ),
      .lpINTR     (lpINTR),
      .devINTA    (devINTA),
      .devINTR    (devINTR)
   );

   //
   // Create DMA address
   //

   assign devADDRO = {rdFLAGS, regBAR};

   //
   // Generate Bus ACK
   //

   assign devACKO = (csraREAD | csraWRITE |
                     csrbREAD | csrbWRITE |
                     barREAD  | barWRITE  |
                     bctrREAD | bctrWRITE |
                     //
                     pctrREAD | pctrWRITE |
                     ramdREAD | ramdWRITE |
                     cctrREAD | cctrWRITE |
                     cbufREAD | cbufWRITE |
                     //
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
        devDATAO = 0;
        if (csraREAD)
          devDATAO = {20'b0, regCSRA};
        if (csrbREAD)
          devDATAO = {20'b0, regCSRB};
        if (barREAD)
          devDATAO = {20'b0, regBAR[15:0]};
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
          devDATAO = {20'b0, lpVECT[20:35]};
     end

`ifndef SYNTHESIS

   //
   // String sizes in bytes
   //

   localparam DEVNAME_SZ = 4,
              REGNAME_SZ = 4;

   //
   // Initialize log file
   //

   initial
     begin
        file = $fopen("lpstatus.txt", "w");
        $fwrite(file, "[%11.3f] LP20: Initialized.\n", $time/1.0e3);
        $fflush(file);
     end

   always @(posedge clk)
     begin
        if (lpGO & devREQO & devACKI)
          $fwrite(file, "[%11.3f] LP20: Read %012o from Memory.  BAR was %06o.\n", $time/1.0e3, lpDATAI[35:0], regBAR);
     end

   //
   // Read CSRA
   //

   PRINT_DEV_REG_ON_RD #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) CSRA_RD (
       .clk             (clk),
       .devRD           (csraREAD),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .regVAL          (regCSRA),
       .devNAME         ("LP20"),
       .regNAME         ("CSRA"),
       .file            (file)
   );

   //
   // Read CSRB
   //

   PRINT_DEV_REG_ON_RD #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) CSRB_RD (
       .clk             (clk),
       .devRD           (csrbREAD),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .regVAL          (regCSRB),
       .devNAME         ("LP20"),
       .regNAME         ("CSRB"),
       .file            (file)
   );

   //
   // Read BAR
   //

   PRINT_DEV_REG_ON_RD #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) BAR_RD (
       .clk             (clk),
       .devRD           (barREAD),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .regVAL          (regBAR[15:0]),
       .devNAME         ("LP20"),
       .regNAME         ("BAR "),
       .file            (file)
   );

   //
   // Read BCTR
   //

   PRINT_DEV_REG_ON_RD #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) BCTR_RD (
       .clk             (clk),
       .devRD           (bctrREAD),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .regVAL          (regBCTR),
       .devNAME         ("LP20"),
       .regNAME         ("BCTR"),
       .file            (file)
   );

   //
   // Read PCTR
   //

   PRINT_DEV_REG_ON_RD #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) PCTR_RD (
       .clk             (clk),
       .devRD           (pctrREAD),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .regVAL          (regPCTR),
       .devNAME         ("LP20"),
       .regNAME         ("PCTR"),
       .file            (file)
   );

   //
   // Read RAMD
   //

   PRINT_DEV_REG_ON_RD #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) RAMD_RD (
       .clk             (clk),
       .devRD           (ramdREAD),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .regVAL          (regRAMD),
       .devNAME         ("LP20"),
       .regNAME         ("RAMD"),
       .file            (file)
   );

   //
   // Read CCTR
   //

   PRINT_DEV_REG_ON_RD #(
       .TYPE            ("H"),
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) CCTR_RD (
       .clk             (clk),
       .devRD           (cctrREAD),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .regVAL          ({8'b0, regCCTR}),
       .devNAME         ("LP20"),
       .regNAME         ("CCTR"),
       .file            (file)
   );

   //
   // Read CBUF
   //

   PRINT_DEV_REG_ON_RD #(
       .TYPE            ("L"),
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) CBUF_RD (
       .clk             (clk),
       .devRD           (cbufREAD),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .regVAL          ({8'b0, regCBUF}),
       .devNAME         ("LP20"),
       .regNAME         ("CBUF"),
       .file            (file)
   );

   //
   // Read CKSM
   //

   PRINT_DEV_REG_ON_RD #(
       .TYPE            ("H"),
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) CKSM_RD (
       .clk             (clk),
       .devRD           (cksmREAD),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .regVAL          ({8'b0, regCKSM}),
       .devNAME         ("LP20"),
       .regNAME         ("CKSM"),
       .file            (file)
   );

   //
   // Read PDAT
   //

   PRINT_DEV_REG_ON_RD #(
       .TYPE            ("L"),
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) PDAT_RD (
       .clk             (clk),
       .devRD           (pdatREAD),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .regVAL          ({8'b0, regPDAT}),
       .devNAME         ("LP20"),
       .regNAME         ("PDAT"),
       .file            (file)
   );

   //
   // Write CSRA
   //

   PRINT_DEV_REG_ON_WR #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) CSRA_WR (
       .clk             (clk),
       .devWR           (csraWRITE),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .devDATA         (lpDATAI[15:0]),
       .regVAL          (regCSRA),
       .devNAME         ("LP20"),
       .regNAME         ("CSRA"),
       .file            (file)
   );

   //
   // Write CSRB
   //

   PRINT_DEV_REG_ON_WR #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) CSRB_WR (
       .clk             (clk),
       .devWR           (csrbWRITE),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .devDATA         (lpDATAI[15:0]),
       .regVAL          (regCSRB),
       .devNAME         ("LP20"),
       .regNAME         ("CSRB"),
       .file            (file)
   );

   //
   // Write BAR
   //

   PRINT_DEV_REG_ON_WR #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) BAR_WR (
       .clk             (clk),
       .devWR           (barWRITE),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .devDATA         (lpDATAI[15:0]),
       .regVAL          (regBAR[15:0]),
       .devNAME         ("LP20"),
       .regNAME         ("BAR "),
       .file            (file)
   );

   //
   // Write BCTR
   //

   PRINT_DEV_REG_ON_WR #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) BCTR_WR (
       .clk             (clk),
       .devWR           (bctrWRITE),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .devDATA         (lpDATAI[15:0]),
       .regVAL          (regBCTR),
       .devNAME         ("LP20"),
       .regNAME         ("BCTR"),
       .file            (file)
   );

   //
   // Write PCTR
   //

   PRINT_DEV_REG_ON_WR #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) PCTR_WR (
       .clk             (clk),
       .devWR           (pctrWRITE),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .devDATA         (lpDATAI[15:0]),
       .regVAL          (regPCTR),
       .devNAME         ("LP20"),
        .regNAME         ("PCTR"),
       .file            (file)
   );

   //
   // Write RAMD
   //

   PRINT_DEV_REG_ON_WR #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) RAMD_WR (
       .clk             (clk),
       .devWR           (ramdWRITE),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .devDATA         (lpDATAI[15:0]),
       .regVAL          (regRAMD),
       .devNAME         ("LP20"),
       .regNAME         ("RAMD"),
       .file            (file)
   );

   //
   // Write CCTR
   //

   PRINT_DEV_REG_ON_WR #(
       .TYPE            ("H"),
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) CCTR_WR (
       .clk             (clk),
       .devWR           (cctrWRITE),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .devDATA         (lpDATAI[15:0]),
       .regVAL          ({8'b0, regCCTR}),
       .devNAME         ("LP20"),
       .regNAME         ("CCTR"),
       .file            (file)
   );

   //
   // Write CBUF
   //

   PRINT_DEV_REG_ON_WR #(
       .TYPE            ("L"),
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) CBUF_WR (
       .clk             (clk),
       .devWR           (cbufWRITE),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .devDATA         (lpDATAI[15:0]),
       .regVAL          ({8'b0, regCBUF}),
       .devNAME         ("LP20"),
       .regNAME         ("CBUF"),
       .file            (file)
   );

`endif

endmodule
