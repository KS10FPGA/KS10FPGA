////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KMC11 Microprocessor
//
// Details
//   The information used to design the KMC11 was obtained from the following
//   DEC docmuments:
//
//   "KMC11 Programmer's Manual", DEC Publication AA-52448-TC.
//
//   "KMC11 General Purpose Microprocessor User's Manual", DEC Publication
//      EK-KMCll-OP-PRE
//
//   "KMCll-B Field Maintenance Print Set", DEC Drawing KMC11-B-1
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
//   kmc11.sv
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

`include "kmc11.vh"
`include "kmcmisc.vh"
`include "kmcmaint.vh"
`include "kmcnprc.vh"
`include "../uba/ubabus.vh"

module KMC11 (
      unibus.device        unibus,                      // Unibus connection
      input  wire  [15: 0] kmcLUIBUS,                   // Line unit input bus
      output logic         kmcLUSTEP,                   // Line unit step
      output logic         kmcLULOOP                    // Line unit loop
   );

   //
   // Bus Interface
   //

   logic  clk;                                          // Clock
   logic  rst;                                          // Reset
   assign clk = unibus.clk;                             // Clock
   assign rst = unibus.rst;                             // Reset
   assign unibus.devACLO  = 0;                          // Power fail (not implemented)

   //
   // KMC Parameters
   //

   parameter  [14:17] kmcDEV  = `kmcDEV;                // KMC11 Device Number
   parameter  [18:35] kmcADDR = `kmcADDR;               // KMC11 Base Address
   parameter  [18:35] kmcVECT = `kmcVECT;               // KMC11 Interrupt Vector
   parameter  [ 7: 4] kmcINTR = `kmcINTR;               // KMC11 Interrupt

   //
   // KMC Register Addresses
   //

   localparam [18:35] sel0ADDR = kmcADDR + `sel0OFFSET; // SEL0 Register Address
   localparam [18:35] sel2ADDR = kmcADDR + `sel2OFFSET; // SEL2 Register Address
   localparam [18:35] sel4ADDR = kmcADDR + `sel4OFFSET; // SEL4 Register Address
   localparam [18:35] sel6ADDR = kmcADDR + `sel6OFFSET; // SEL6 Register Address

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
   // KMC Interrupt Vectors
   //

   localparam [18:35] kmcVECT0 = kmcVECT;               // KMC11 Vector
   localparam [18:35] kmcVECT4 = kmcVECT + 18'd4;       // KMC11 Vector + 4

   //
   // Read/Write Decoding
   //

   wire kmcREAD  = /* FIXME: unibus.devREQI & */ devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == kmcDEV);
   wire kmcWRITE = /* FIXME: unibus.devREQI & */ devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == kmcDEV);
   wire vectREAD = /* FIXME: unibus.devREQI & */ devREAD  & devIO & devPHYS & !devWRU &  devVECT & (devDEV == kmcDEV);

   //
   // Address Decoding
   //

   wire sel0READ  = kmcREAD  & (devADDR == sel0ADDR);
   wire sel0WRITE = kmcWRITE & (devADDR == sel0ADDR);
   wire sel2READ  = kmcREAD  & (devADDR == sel2ADDR);
   wire sel2WRITE = kmcWRITE & (devADDR == sel2ADDR);
   wire sel4READ  = kmcREAD  & (devADDR == sel4ADDR);
   wire sel4WRITE = kmcWRITE & (devADDR == sel4ADDR);
   wire sel6READ  = kmcREAD  & (devADDR == sel6ADDR);
   wire sel6WRITE = kmcWRITE & (devADDR == sel6ADDR);

   //
   // Big-endian to little-endian data bus swap
   //

   wire [35: 0] kmcDATAI = unibus.devDATAI[0:35];

   //
   // Address Flags (little-endian)
   //

   localparam [35:22] kmcRDMEMFLAGS = 14'b00010000000000,  // Read memory
                      kmcWRMEMFLAGS = 14'b00000100000000,  // Write memory
                      kmcRDIOFLAGS  = 14'b00010010101000,  // Read Phys IO Byte
                      kmcWRIOFLAGS  = 14'b00000110101000;  // Write Phys IO Byte

   //
   // Read/Pause/Write Data
   //

   logic [35: 0] kmcRPWD;

   //
   // Maintenance Register Bits
   //

   logic [15: 8] kmcMAINT;
   wire          kmcRUN     = `kmcMAINT_RUN(kmcMAINT);
   wire          kmcMCLR    = `kmcMAINT_MCLR(kmcMAINT);
   wire          kmcCRAMWR  = `kmcMAINT_CRAMWR(kmcMAINT);
   wire          kmcCRAMOUT = `kmcMAINT_CRAMOUT(kmcMAINT);
   wire          kmcCRAMIN  = `kmcMAINT_CRAMIN(kmcMAINT);
   wire          kmcSTEP    = `kmcMAINT_STEP(kmcMAINT);

   //
   // Initialize
   //

   wire          kmcINIT = kmcMCLR | unibus.devRESET;

   //
   // Multiport RAM
   //

   logic [15: 0] kmcNPRID;                              // NPR output data
   logic [15: 0] kmcNPROD;                              // NPR output data
   logic [15: 0] kmcNPRIA;                              // NPR input address
   logic [15: 0] kmcNPROA;                              // NPR output address
   logic [15: 0] kmcCSR0;                               // CSR0
   logic [15: 0] kmcCSR2;                               // CSR2
   logic [15: 0] kmcCSR4;                               // CSR4
   logic [15: 0] kmcCSR6;                               // CSR6
   logic [ 9: 0] kmcMNTADDR;                            // Maintenance address register
   logic [15: 0] kmcMNTINST;                            // Maintenance instruction register
   logic         kmcMPBUSY;                             // Multiport RAM Busy

   //
   // Arithmetic Logic Unit (ALU) Signals
   //

   logic [ 7: 0] kmcALU;                                // ALU Data
   logic         kmcALUZ;                               // ALU Zero
   logic         kmcALUC;                               // ALU Carry

   //
   // Branch Register (BRG) Signals
   //

   logic [ 7: 0] kmcBRG;                                // BRG Register

   //
   // Sequencer Signals
   //

   logic [ 9: 0] kmcPC;                                 // Program Counter
   logic [15: 0] kmcCRAM;                               // Control RAM (Microcode)

   //
   // MEM Signals
   //

   logic [ 7: 0] kmcMEM;                                // Memory
   logic [10: 0] kmcMAR;                                // Memory Address Register

   //
   // Data Mux Signals
   //

   logic [ 7: 0] kmcDMUX;                               // Data mux

   //
   // Misc Register Signals
   //

   logic [ 7: 0] kmcMISC;                               // Misc Register
   wire          kmcVECTXXX4 = `kmcMISC_VECTXXX4(kmcMISC);//Interrupt Vector
   wire  [17:16] kmcBAEO     = `kmcMISC_BAEO(kmcMISC);  // BA[17:16] for DMA Writes
   logic         kmcSETIRQ;                             // Start an interrupt
   logic         kmcIRQO;                               // Interrupt in progress
   logic         kmcSETNXM;                             // Non-existent memory

   //
   // NPR Control Port Signals
   //

   logic [ 7: 0] kmcNPRC;                               // NPR Control Register
   wire          kmcNPRO = `kmcNPRC_NPRO(kmcNPRC);      // NPR Direction
   wire          kmcBYTE = `kmcNPRC_BYTEXFER(kmcNPRC);  // NPR size
   wire  [17:16] kmcBAEI = `kmcNPRC_BAEI(kmcNPRC);      // BA[17:16] for DMA Reads

   //
   // Scratch Pad Signals
   //

   logic [ 7: 0] kmcSP;                                 // Scratch Pad Register

   //
   // Clock enables
   //

   logic         kmcALUCLKEN;                           // ALU Clock Enable
   logic         kmcBRGCLKEN;                           // BRG Clock Enable
   logic         kmcCRAMCLKEN;                          // Control RAM Clock Enable
   logic         kmcMARCLKEN;                           // Memory Address Register Clock Enable
   logic         kmcMEMCLKEN;                           // Memory Clock Enable
   logic         kmcMISCCLKEN;                          // Misc Register Clock Enable
   logic         kmcNPRCLKEN;                           // NPR Control Register Clock Enable
   logic         kmcPCCLKEN;                            // Program Counter Clock Enable
   logic         kmcREGCLKEN;                           // Multiport RAM clock enable
   logic         kmcSPCLKEN;                            // SP Clock Enable

   //
   // Maintenance Register
   //  This CSR shadows the CSR1 that is in the multiport memory.
   //

   KMCMAINT uMAINT (
      .clk         (clk),
      .rst         (rst),
      .devHIBYTE   (devHIBYTE),
      .devRESET    (unibus.devRESET),
      .sel0WRITE   (sel0WRITE),
      .kmcDATAI    (kmcDATAI),
      .kmcINIT     (kmcINIT),
      .kmcMAINT    (kmcMAINT)
   );

   //
   // Clock Generator
   //

   KMCCLK uCLK (
      .clk         (clk),
      .rst         (rst),
      .kmcINIT     (kmcINIT),
      .kmcSTEP     (kmcSTEP),
      .kmcRUN      (kmcRUN),
      .kmcSPCLKEN  (kmcSPCLKEN),
      .kmcALUCLKEN (kmcALUCLKEN),
      .kmcBRGCLKEN (kmcBRGCLKEN),
      .kmcCRAMCLKEN(kmcCRAMCLKEN),
      .kmcMARCLKEN (kmcMARCLKEN),
      .kmcMEMCLKEN (kmcMEMCLKEN),
      .kmcMISCCLKEN(kmcMISCCLKEN),
      .kmcNPRCLKEN (kmcNPRCLKEN),
      .kmcPCCLKEN  (kmcPCCLKEN),
      .kmcREGCLKEN (kmcREGCLKEN)
   );

   //
   // Multiport RAM
   //

   KMCMPRAM uMPRAM (
      .clk         (clk),
      .rst         (rst),
      .devREQO     (unibus.devREQO),
      .devACKI     (unibus.devACKI),
      .devLOBYTE   (devLOBYTE),
      .devHIBYTE   (devHIBYTE),
      .sel0WRITE   (sel0WRITE),
      .sel2WRITE   (sel2WRITE),
      .sel4WRITE   (sel4WRITE),
      .sel6WRITE   (sel6WRITE),
      .kmcDATAI    (kmcDATAI),
      .kmcCRAM     (kmcCRAM),
      .kmcCRAMIN   (kmcCRAMIN),
      .kmcCRAMOUT  (kmcCRAMOUT),
      .kmcALU      (kmcALU),
      .kmcRAMCLKEN (kmcREGCLKEN),
      .kmcNPRO     (kmcNPRO),
      .kmcBYTE     (kmcBYTE),
      .kmcMPBUSY   (kmcMPBUSY),
      .kmcNPRID    (kmcNPRID),
      .kmcNPROD    (kmcNPROD),
      .kmcNPRIA    (kmcNPRIA),
      .kmcNPROA    (kmcNPROA),
      .kmcCSR0     (kmcCSR0),
      .kmcCSR2     (kmcCSR2),
      .kmcCSR4     (kmcCSR4),
      .kmcCSR6     (kmcCSR6)
   );

   //
   // Scratch Pad Memory
   //

   KMCSP uKMCSP (
      .clk         (clk),
      .rst         (rst),
      .kmcSPCLKEN  (kmcSPCLKEN),
      .kmcCRAM     (kmcCRAM),
      .kmcALU      (kmcALU),
      .kmcSP       (kmcSP)
   );

   //
   // Microsequencer
   //

   KMCSEQ uSEQ (
      .clk         (clk),
      .rst         (rst),
      .devLOBYTE   (devLOBYTE),
      .devHIBYTE   (devHIBYTE),
      .sel4WRITE   (sel4WRITE),
      .sel6WRITE   (sel6WRITE),
      .kmcINIT     (kmcINIT),
      .kmcDATAI    (kmcDATAI),
      .kmcCRAMIN   (kmcCRAMIN),
      .kmcCRAMOUT  (kmcCRAMOUT),
      .kmcCRAMWR   (kmcCRAMWR),
      .kmcPCCLKEN  (kmcPCCLKEN),
      .kmcCRAMCLKEN(kmcCRAMCLKEN),
      .kmcALU      (kmcALU),
      .kmcALUC     (kmcALUC),
      .kmcALUZ     (kmcALUZ),
      .kmcBRG      (kmcBRG),
      .kmcPC       (kmcPC),
      .kmcMNTADDR  (kmcMNTADDR),
      .kmcMNTINST  (kmcMNTINST),
      .kmcCRAM     (kmcCRAM)
   );

   //
   // 1K Memory
   //

   KMCMEM uMEM (
      .clk         (clk),
      .rst         (rst),
      .kmcINIT     (kmcINIT),
      .kmcCRAM     (kmcCRAM),
      .kmcMARCLKEN (kmcMARCLKEN),
      .kmcMEMCLKEN (kmcMEMCLKEN),
      .kmcALU      (kmcALU),
      .kmcMAR      (kmcMAR),
      .kmcMEM      (kmcMEM)
   );

   //
   // MISC Register
   //

   KMCMISC uMISC (
      .clk         (clk),
      .rst         (rst),
      .kmcINIT     (kmcINIT),
      .kmcCRAM     (kmcCRAM),
      .kmcMISCCLKEN(kmcMISCCLKEN),
      .kmcALU      (kmcALU),
      .kmcIRQO     (kmcIRQO),
      .kmcSETNXM   (kmcSETNXM),
      .kmcSETIRQ   (kmcSETIRQ),
      .kmcMISC     (kmcMISC)
   );

   //
   // BRG Register
   //

   KMCBRG uBRG (
      .clk         (clk),
      .rst         (rst),
      .kmcINIT     (kmcINIT),
      .kmcCRAM     (kmcCRAM),
      .kmcBRGCLKEN (kmcBRGCLKEN),
      .kmcALU      (kmcALU),
      .kmcBRG      (kmcBRG)
   );

   //
   // NPR Control Register
   //

   KMCNPRC uNPRC (
      .clk         (clk),
      .rst         (rst),
      .devACKI     (unibus.devACKI),
      .devREQO     (unibus.devREQO),
      .kmcINIT     (kmcINIT),
      .kmcCRAM     (kmcCRAM),
      .kmcNPRCLKEN (kmcNPRCLKEN),
      .kmcMAR      (kmcMAR),
      .kmcALU      (kmcALU),
      .kmcMPBUSY   (kmcMPBUSY),
      .kmcSETNXM   (kmcSETNXM),
      .kmcRPWD     (kmcRPWD),
      .kmcNPRC     (kmcNPRC)
   );

   //
   // DMUX
   //

   KMCDMUX uDMUX (
      .kmcCRAM     (kmcCRAM),
      .kmcNPRID    (kmcNPRID),
      .kmcNPROD    (kmcNPROD),
      .kmcNPRIA    (kmcNPRIA),
      .kmcNPROA    (kmcNPROA),
      .kmcCSR0     (kmcCSR0),
      .kmcCSR2     (kmcCSR2),
      .kmcCSR4     (kmcCSR4),
      .kmcCSR6     (kmcCSR6),
      .kmcMISC     (kmcMISC),
      .kmcNPRC     (kmcNPRC),
      .kmcBRG      (kmcBRG),
      .kmcMEM      (kmcMEM),
      .kmcLUIBUS   (kmcLUIBUS),
      .kmcPC       (kmcPC),
      .kmcMAR      (kmcMAR),
      .kmcALUZ     (kmcALUZ),
      .kmcALUC     (kmcALUC),
      .kmcDMUX     (kmcDMUX)
   );

   //
   // ALU
   //

   KMCALU uALU (
      .clk         (clk),
      .rst         (rst),
      .kmcINIT     (kmcINIT),
      .kmcCRAM     (kmcCRAM),
      .kmcDMUX     (kmcDMUX),
      .kmcSP       (kmcSP),
      .kmcALUCLKEN (kmcALUCLKEN),
      .kmcALUC     (kmcALUC),
      .kmcALUZ     (kmcALUZ),
      .kmcALU      (kmcALU)
   );

   //
   // Interrupt Controller
   //

   KMCINTR uINTR (
      .clk         (clk),
      .rst         (rst),
      .kmcINIT     (kmcINIT),
      .kmcSETIRQ   (kmcSETIRQ),
      .kmcIACK     (vectREAD),
      .kmcIRQO     (kmcIRQO)
   );

   //
   // Generate Interrutp Request
   //

   assign unibus.devINTRO = kmcIRQO ? kmcINTR : 4'b0;

   //
   // DMA Address
   //
   // The KMC11 can generate IO NPR (aka DMA) operations.  This is tested
   // in DSKMA Test.65 and Test.66.
   //
   // This decodes IO page addresses (0760000 - 0777777) in order to generate
   // the proper KS10 backplane bus cycles.
   //
   // Note:
   //  The addressing here has mixed endian-ness.  The UBA address formed here
   //  is little endian.  The KS10 address is big-endian.
   //

   always_comb
     begin
        if (kmcNPRO)
          begin
             if ((kmcBAEO[17:16] == 2'b11) & (kmcNPROA[15:13] == 3'b111))
               unibus.devADDRO = {kmcWRIOFLAGS[35:22],  kmcDEV,  kmcBAEO[17:16], kmcNPROA[15:0]};
             else
               unibus.devADDRO = {kmcWRMEMFLAGS[35:22], 4'b0000, kmcBAEO[17:16], kmcNPROA[15:0]};
          end
        else
          begin
             if ((kmcBAEI[17:16] == 2'b11) & (kmcNPRIA[15:13] == 3'b111))
               unibus.devADDRO = {kmcRDIOFLAGS[35:22],  kmcDEV,  kmcBAEI[17:16], kmcNPRIA[15:0]};
             else
               unibus.devADDRO = {kmcRDMEMFLAGS[35:22], 4'b0000, kmcBAEI[17:16], kmcNPRIA[15:0]};
          end
     end

   //
   // Generate Bus ACK
   //

   assign unibus.devACKO = (!(unibus.devREQO & !kmcNPRO) & sel0WRITE |
                            !(unibus.devREQO & !kmcNPRO) & sel2WRITE |
                            !(unibus.devREQO & !kmcNPRO) & sel4WRITE |
                            !(unibus.devREQO & !kmcNPRO) & sel6WRITE |
                            !(unibus.devREQO &  kmcNPRO) & sel0READ  |
                            !(unibus.devREQO &  kmcNPRO) & sel2READ  |
                            !(unibus.devREQO &  kmcNPRO) & sel4READ  |
                            !(unibus.devREQO &  kmcNPRO) & sel6READ  |
                            !(unibus.devREQO &  kmcNPRO) & vectREAD);

   //
   // Bus Mux and little-endian to big-endian bus swap
   //
   // Trace (CSR6/CROM Mux)
   //  M8206/D11/E57
   //  M8206/D11/E67
   //  M8206/D11/E76
   //  M8206/D11/E79
   //  M8206/D11/E84
   //

   always_comb
     begin
        unibus.devDATAO = 0;
        if (unibus.devREQO)
          if (kmcCRAMOUT)
            unibus.devDATAO = {20'b0, kmcMNTINST};
          else
`ifdef KMC_BROKE_RPW
            case ({kmcBYTE, kmcNPROA[1:0]})
              3'b000: unibus.devDATAO <= {2'b0, kmcNPROD[15: 8], kmcNPROD[ 7: 0], 2'b0,  kmcRPWD[15: 8],  kmcRPWD[ 7: 0]};     // Even word
              3'b001: unibus.devDATAO <= {2'b0, kmcNPROD[15: 8], kmcNPROD[ 7: 0], 2'b0,  kmcRPWD[15: 8],  kmcRPWD[ 7: 0]};     // Even word
              3'b010: unibus.devDATAO <= {2'b0,  kmcRPWD[33:26],  kmcRPWD[25:18], 2'b0, kmcNPROD[15: 8], kmcNPROD[ 7: 0]};     // Odd  word
              3'b011: unibus.devDATAO <= {2'b0,  kmcRPWD[33:26],  kmcRPWD[25:18], 2'b0, kmcNPROD[15: 8], kmcNPROD[ 7: 0]};     // Odd  word
              3'b100: unibus.devDATAO <= {2'b0, kmcNPROD[15: 8], kmcNPROD[ 7: 0], 2'b0,  kmcRPWD[15: 8],  kmcRPWD[ 7: 0]};     // Even word, low  byte (not RPW)
              3'b101: unibus.devDATAO <= {2'b0, kmcNPROD[15: 8],  kmcRPWD[25:18], 2'b0,  kmcRPWD[15: 8],  kmcRPWD[ 7: 0]};     // Even word, high byte (RPW)
              3'b110: unibus.devDATAO <= {2'b0,  kmcRPWD[33:26],  kmcRPWD[25:18], 2'b0,  kmcRPWD[15: 8], kmcNPROD[ 7: 0]};     // Odd  word, low  byte (RPW)
              3'b111: unibus.devDATAO <= {2'b0,  kmcRPWD[33:26],  kmcRPWD[25:18], 2'b0, kmcNPROD[15: 8],  kmcRPWD[ 7: 0]};     // Odd  word, high byte (RPW)
            endcase
`else
            unibus.devDATAO <= {2'b0, kmcNPROD[15:0], 2'b0, kmcNPROD[15:0]};
`endif
        else
          begin
             if (sel0READ)
               unibus.devDATAO = {20'b0, kmcMAINT[15:8], kmcCSR0[7:0]};
             if (sel2READ)
               unibus.devDATAO = {20'b0, kmcCSR2};
             if (sel4READ)
               if (kmcCRAMOUT)
                 unibus.devDATAO = {26'b0, kmcMNTADDR};
               else
                 unibus.devDATAO = {20'b0, kmcCSR4};
             if (sel6READ)
               if (kmcCRAMOUT)
                 unibus.devDATAO = {20'b0, kmcMNTINST};
               else
                 unibus.devDATAO = {20'b0, kmcCSR6};
             if (vectREAD)
               if (kmcVECTXXX4)
                 unibus.devDATAO = {20'b0, kmcVECT4[20:35]};
               else
                 unibus.devDATAO = {20'b0, kmcVECT0[20:35]};
          end
     end

   //
   // External Interfaces
   //

   assign kmcLUSTEP = `kmcMAINT_LUSTEP(kmcMAINT);
   assign kmcLULOOP = `kmcMAINT_LULOOP(kmcMAINT);

//
// This code write a log kmc11 register accesses to "kmcstatus.txt" in the
// root director of the simulator.  It is best viewed in a terminal window
// as follows:
//
// $ tail -f kmcstatus.txt
//

`ifndef SYNTHESIS

   integer file;

   //
   // String sizes in bytes
   //

   localparam DEVNAME_SZ = 5,
              REGNAME_SZ = 4;

   //
   // Initialize log file
   //

   initial
     begin
        file = $fopen("kmcstatus.txt", "w");
        $fwrite(file, "[%11.3f] KMC11: Initialized.\n", $time/1.0e3);
        $fflush(file);
     end

   //
   // Read CSR0
   //

   PRINT_DEV_REG_ON_RD #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) CSR0_RD (
       .clk             (clk),
       .devRD           (sel0READ),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .regVAL          (kmcCSR0),
       .devNAME         ("KMC11"),
       .regNAME         ("CSR0"),
       .file            (file)
   );

   //
   // Read CSR2
   //

   PRINT_DEV_REG_ON_RD #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) CSR2_RD (
       .clk             (clk),
       .devRD           (sel2READ),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .regVAL          (kmcCSR2),
       .devNAME         ("KMC11"),
       .regNAME         ("CSR2"),
       .file            (file)
   );

   //
   // Read CSR4
   //

   PRINT_DEV_REG_ON_RD #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) CSR4_RD (
       .clk             (clk),
       .devRD           (sel4READ & !kmcCRAMOUT),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .regVAL          (kmcCSR4[15:0]),
       .devNAME         ("KMC11"),
       .regNAME         ("CSR4"),
       .file            (file)
   );

   //
   // Read CSR6
   //

   PRINT_DEV_REG_ON_RD #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) CSR6_RD (
       .clk             (clk),
       .devRD           (sel6READ & !kmcCRAMOUT),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .regVAL          (kmcCSR6),
       .devNAME         ("KMC11"),
       .regNAME         ("CSR6"),
       .file            (file)
   );

   //
   // Read Maintenance Address Register
   //

   PRINT_DEV_REG_ON_RD #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) MNTA_RD (
       .clk             (clk),
       .devRD           (sel4READ & kmcCRAMOUT),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .regVAL          (kmcCSR4[15:0]),
       .devNAME         ("KMC11"),
       .regNAME         ("MNTA"),
       .file            (file)
   );

   //
   // Read Maintenance Instruction Register
   //

   PRINT_DEV_REG_ON_RD #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) MNTI_RD (
       .clk             (clk),
       .devRD           (sel6READ & kmcCRAMOUT),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .regVAL          (kmcCSR6),
       .devNAME         ("KMC11"),
       .regNAME         ("MNTI"),
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
       .regVAL          (kmcCSR6),
       .devNAME         ("KMC11"),
       .regNAME         ("VECT"),
       .file            (file)
   );

   //
   // Write CSR0
   //

   PRINT_DEV_REG_ON_WR #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) CSR0_WR (
       .clk             (clk),
       .devWR           (sel0WRITE),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .devDATA         (kmcDATAI[15:0]),
       .regVAL          (kmcCSR0),
       .devNAME         ("KMC11"),
       .regNAME         ("CSR0"),
       .file            (file)
   );

   //
   // Write CSR2
   //

   PRINT_DEV_REG_ON_WR #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) CSR2_WR (
       .clk             (clk),
       .devWR           (sel2WRITE),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .devDATA         (kmcDATAI[15:0]),
       .regVAL          (kmcCSR2),
       .devNAME         ("KMC11"),
       .regNAME         ("CSR2"),
       .file            (file)
   );

   //
   // Write CSR4
   //

   PRINT_DEV_REG_ON_WR #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) CSR4_WR (
       .clk             (clk),
       .devWR           (sel4WRITE & !kmcCRAMOUT),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .devDATA         (kmcDATAI[15:0]),
       .regVAL          (kmcCSR4),
       .devNAME         ("KMC11"),
       .regNAME         ("CSR4"),
       .file            (file)
   );

   //
   // Write CSR6
   //

   PRINT_DEV_REG_ON_WR #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) CSR6_WR (
       .clk             (clk),
       .devWR           (sel6WRITE & !kmcCRAMOUT),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .devDATA         (kmcDATAI[15:0]),
       .regVAL          (kmcCSR6),
       .devNAME         ("KMC11"),
       .regNAME         ("CSR6"),
       .file            (file)
   );

   //
   // Write Maintenance Address Register
   //

   PRINT_DEV_REG_ON_WR #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) MNTA_WR (
       .clk             (clk),
       .devWR           (sel4WRITE & kmcCRAMOUT),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .devDATA         (kmcDATAI[15:0]),
       .regVAL          (kmcCSR4),
       .devNAME         ("KMC11"),
       .regNAME         ("MNTA"),
       .file            (file)
   );

   //
   // Write Maintenance Instruction Register
   //

   PRINT_DEV_REG_ON_WR #(
       .DEVNAME_SZ      (DEVNAME_SZ),
       .REGNAME_SZ      (REGNAME_SZ)
   ) MNTI_WR (
       .clk             (clk),
       .devWR           (sel6WRITE & kmcCRAMOUT),
       .devHIBYTE       (devHIBYTE),
       .devLOBYTE       (devLOBYTE),
       .devDATA         (kmcDATAI[15:0]),
       .regVAL          (kmcCSR6),
       .devNAME         ("KMC11"),
       .regNAME         ("MNTI"),
       .file            (file)
   );

`endif

endmodule
