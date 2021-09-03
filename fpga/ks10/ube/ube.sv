////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Unibus Exerciser
//
// Details
//   The information used to design the UBE was mostly obtained be reverse
//   engineering the UBE from DSDUA source code and CXBEAB0 diagnostic source
//   code.
//
// File
//   ube.sv
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2021 Rob Doyle
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

`include "ube.vh"
`include "ubecsr1.vh"
`include "ubecsr2.vh"
`include "../uba/ubabus.vh"

module UBE (
      unibus.device unibus                                      // Unibus connection
   );

   //
   // Bus Interface
   //

   logic  clk;                                                  // Clock
   logic  rst;                                                  // Reset
   assign clk = unibus.clk;                                     // Clock
   assign rst = unibus.rst;                                     // Reset

   //
   // UBE Parameters
   //

   parameter  [14:17] ubeDEV  = `ube1DEV;                       // UBE Device Number
   parameter  [18:35] ubeVECT = `ube1VECT;                      // UBE Interrupt Vector
   parameter  [18:35] ubeADDR = `ube1ADDR;                      // UBE Base Address

   //
   // UBE Register Addresses
   //

   localparam [18:35] dbADDR    = ubeADDR + `ubedbOFFSET;       // DB    Register (UBEDB1 according to DSUBA)
   localparam [18:35] ccADDR    = ubeADDR + `ubeccOFFSET;       // CC    Register (UBECC1 according to DSUBA)
   localparam [18:35] baADDR    = ubeADDR + `ubebaOFFSET;       // BA    Register (UBEBA1 according to DSUBA)
   localparam [18:35] csr1ADDR  = ubeADDR + `ubec1OFFSET;       // CSR1  Register (UBEC1A according to DSUBA)
   localparam [18:35] csr2ADDR  = ubeADDR + `ubec2OFFSET;       // CSR2  Register (UBEC1B according to DSUBA)
   localparam [18:35] clrADDR   = ubeADDR + `ubeclrOFFSET;      // CLR   Register (not mentioned but used by DSUBA)
   localparam [18:35] simgoADDR = `ubesimgoADDR;                // SIMGO Register (Simultaneous GO register)

   //
   // Address Flags
   //

   localparam [0:17] rdFLAGS = 18'b000_100_000_000_000_000,
                     wrFLAGS = 18'b000_001_000_000_000_000;

   //
   // Interrupts
   //

   localparam [7:4] ubeBR7 = 4'b1000,
                    ubeBR6 = 4'b0100,
                    ubeBR5 = 4'b0010,
                    ubeBR4 = 4'b0001;

   //
   // Device Address and Flags
   //

   wire         devREAD   = `devREAD(unibus.devADDRI);          // Read Cycle
   wire         devWRITE  = `devWRITE(unibus.devADDRI);         // Write Cycle
   wire         devPHYS   = `devPHYS(unibus.devADDRI);          // Physical reference
   wire         devIO     = `devIO(unibus.devADDRI);            // IO Cycle
   wire         devWRU    = `devWRU(unibus.devADDRI);           // WRU Cycle
   wire         devVECT   = `devVECT(unibus.devADDRI);          // Read interrupt vector
   wire [14:17] devDEV    = `devDEV(unibus.devADDRI);           // Device Number
   wire [18:35] devADDR   = `devADDR(unibus.devADDRI);          // Device Address
   wire         devHIBYTE = `devHIBYTE(unibus.devADDRI);        // Device High Byte
   wire         devLOBYTE = `devLOBYTE(unibus.devADDRI);        // Device Low Byte

   //
   // Read/Write Decoding
   //

   wire ubeREAD  = unibus.devREQI & devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == ubeDEV);
   wire ubeWRITE = unibus.devREQI & devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == ubeDEV);
   wire vectREAD = unibus.devREQI & devREAD  & devIO & devPHYS & !devWRU &  devVECT & (devDEV == ubeDEV);

   //
   // Address Decoding
   //

   wire dbREAD     = ubeREAD  & (devADDR == dbADDR);
   wire dbWRITE    = ubeWRITE & (devADDR == dbADDR);
   wire ccREAD     = ubeREAD  & (devADDR == ccADDR);
   wire ccWRITE    = ubeWRITE & (devADDR == ccADDR);
   wire baREAD     = ubeREAD  & (devADDR == baADDR);
   wire baWRITE    = ubeWRITE & (devADDR == baADDR);
   wire csr1READ   = ubeREAD  & (devADDR == csr1ADDR);
   wire csr1WRITE  = ubeWRITE & (devADDR == csr1ADDR);
   wire csr2READ   = ubeREAD  & (devADDR == csr2ADDR);
   wire csr2WRITE  = ubeWRITE & (devADDR == csr2ADDR);
   wire clrREAD    = ubeREAD  & (devADDR == clrADDR);
   wire clrWRITE   = ubeWRITE & (devADDR == clrADDR);
   wire simgoREAD  = ubeREAD  & (devADDR == simgoADDR);
   wire simgoWRITE = ubeWRITE & (devADDR == simgoADDR);

   //
   // Big-endian to little-endian data bus swap
   //

   wire [35:0] ubeDATAI = unibus.devDATAI[0:35];

   //
   // Interrupt Acknowledge
   //

   wire ubeIACK = vectREAD;

   //
   // Data Buffer Register
   //

   logic [15:0] regDB;

   //
   // Cycle Count Register
   //

   logic [15:0] regCC;

   //
   // Buffer Address Register
   //

   logic [15:0] regBA;

   //
   // Control/Status Register #1
   //

   logic [15:0] regCSR1;
   wire         ubeXTCCO = `ubeCSR1_XTCCO(regCSR1);     // XFR 'til CC Overflow
   wire         ubeNPRS  = `ubeCSR1_NPRS(regCSR1);      // NPR Simulate
   wire         ubeBYTE  = `ubeCSR1_BYTE(regCSR1);      // Byte Operation
   wire         ubeNPRO  = `ubeCSR1_NPRO(regCSR1);      // NPR Out
   wire  [ 7:4] ubeBR    = `ubeCSR1_BR(regCSR1);        // Interrupt request
   wire         ubeGO    = `ubeCSR1_GO(regCSR1);        // Go

   //
   // Control/Status Register #2
   //

   logic [15:0] regCSR2;
   assign unibus.devACLO = `ubeCSR2_ACLO(regCSR2);      // Power down

   //
   // Simultaneous GO
   //

   wire ubeSIMGO  = simgoWRITE & devLOBYTE & `ubeSIMGO(ubeDATAI);
   wire ubeGOANY  = ubeGO | ubeSIMGO;

   //
   // Clear
   //

   wire ubeCLR    = clrWRITE & devLOBYTE & `ubeCLRERR(ubeDATAI);

   //
   // Address and cycle count increments
   //

   logic ubeINC;

   //
   // UBE Data Buffer Register
   //

   UBEDB DB (
      .rst        (rst),
      .clk        (clk),
      .devRESET   (unibus.devRESET),
      .devHIBYTE  (devHIBYTE),
      .devLOBYTE  (devLOBYTE),
      .devADDRO   (unibus.devADDRO),
      .devDATAI   (unibus.devDATAI),
      .devREQO    (unibus.devREQO),
      .devACKI    (unibus.devACKI),
      .dbWRITE    (dbWRITE),
      .ubeBYTE    (ubeBYTE),
      .ubeNPRO    (ubeNPRO),
      .regDB      (regDB)
   );

   //
   // UBE Cycle Count Register
   //

   UBECC CC (
      .rst        (rst),
      .clk        (clk),
      .devRESET   (unibus.devRESET),
      .devHIBYTE  (devHIBYTE),
      .devLOBYTE  (devLOBYTE),
      .devDATAI   (unibus.devDATAI),
      .ccWRITE    (ccWRITE),
      .ubeINC     (ubeINC),
      .regCC      (regCC)
   );

   //
   // UBE Buffer Address Register
   //

   UBEBA BA (
      .rst        (rst),
      .clk        (clk),
      .devRESET   (unibus.devRESET),
      .devHIBYTE  (devHIBYTE),
      .devLOBYTE  (devLOBYTE),
      .devDATAI   (unibus.devDATAI),
      .baWRITE    (baWRITE),
      .ubeINC     (ubeINC),
      .regBA      (regBA)
   );

   //
   // UBE Control/Status Register #1
   //

   UBECSR1 CSR1 (
      .rst        (rst),
      .clk        (clk),
      .clr        (unibus.devRESET),
      .devHIBYTE  (devHIBYTE),
      .devLOBYTE  (devLOBYTE),
      .devDATAI   (unibus.devDATAI),
      .csr1WRITE  (csr1WRITE),
      .regCSR1    (regCSR1)
   );

   //
   // UBE Control/Status Register #2
   //

   UBECSR2 CSR2 (
      .rst        (rst),
      .clk        (clk),
      .devRESET   (unibus.devRESET),
      .devHIBYTE  (devHIBYTE),
      .devLOBYTE  (devLOBYTE),
      .devDATAI   (unibus.devDATAI),
      .csr2WRITE  (csr2WRITE),
      .regCSR2    (regCSR2)
   );

   //
   // UBE State Machine
   //  The design seems to allow the mode bits to be set simultaneously
   //  with the "GO" bit.
   //

   localparam [0:3] stateIDLE   =  0,
                    stateWAITGO =  1,
                    stateINTACT =  2,
                    stateINTCLR =  3,
                    stateNPRS   =  4,
                    stateNPROM0 =  5,
                    stateNPROM1 =  6,
                    stateNPROM2 =  7,
                    stateNPROM3 =  8,
                    stateNPRIM0 =  9,
                    stateNPRIM1 = 10,
                    stateNPRIM2 = 11,
                    stateNPRIM3 = 12;

   logic [0:3] state;

   always_ff @(posedge clk)
     begin
        if (rst | ubeCLR)
          begin
             ubeINC <= 0;
             unibus.devREQO  <= 0;
             unibus.devADDRO <= 0;
             unibus.devINTRO <= 0;
             state <= stateIDLE;
          end
        else
          case (state)

            //
            // Wait for GO to be asserted
            //

            stateIDLE:
              if (ubeGOANY)
                state <= stateWAITGO;

            //
            // Wait for GO to be negated
            //  This allows GO to be asserted simultaneously with other bits
            //  in UBECSR1
            //
            //  Note: The diagnostic software cannot distinguish between a
            //  normal NPR transfer and an FTM NPR transfer.  Therefore FTM
            //  transfers are not implemented.
            //

            stateWAITGO:
              if (!ubeGOANY)
                begin
                   if ((ubeBR == ubeBR7) |
                       (ubeBR == ubeBR6) |
                       (ubeBR == ubeBR5) |
                       (ubeBR == ubeBR4))
                     begin
                        unibus.devINTRO <= ubeBR;
                        state <= stateINTACT;
                     end
                   else
                     case ({ubeNPRS, ubeXTCCO, ubeNPRO})

                       //
                       // NOPs
                       //

                       3'b000,
                       3'b001,
                       3'b010,
                       3'b011:
                         begin
                            state <= stateIDLE;
                         end

                       //
                       // Single NPR In
                       //

                       3'b100:
                         begin
                            unibus.devREQO  <= 1;
                            unibus.devADDRO <= {rdFLAGS, 2'b0, regBA};
                            state <= stateNPRS;
                         end

                       //
                       // Single NPR Out
                       //

                       3'b101:
                         begin
                            unibus.devREQO  <= 1;
                            unibus.devADDRO <= {wrFLAGS, 2'b0, regBA};
                            state <= stateNPRS;
                         end

                       //
                       // Multiple NPR In
                       //

                       3'b110:
                         begin
                            state <= stateNPRIM0;
                         end

                       //
                       // Multiple NPR Out
                       //

                       3'b111:
                         begin
                            state <= stateNPROM0;
                         end
                     endcase
                end

            //
            // Wait for an Interrupt Acknowledge
            //

            stateINTACT:
              if (ubeIACK)
                state <= stateINTCLR;

            //
            // Wait for Interrupt Acknowledge to clear
            //

            stateINTCLR:
              if (!ubeIACK)
                begin
                   unibus.devINTRO <= 0;
                   state <= stateIDLE;
                end

            //
            // NPR Single
            //  Just wait for the ACK then negate REQ
            //

            stateNPRS:
              if (unibus.devACKI)
                begin
                   unibus.devREQO <= 0;
                   state <= stateIDLE;
                end

            //
            // NPR Out Multiple 0
            //
            // Loop Destination
            //
            // Start write cycle to memory
            //

            stateNPROM0:
              if (regCC[15:1] == 0)
                begin
                   unibus.devREQO  <= 0;
                   unibus.devADDRO <= 0;
                   state <= stateIDLE;
                end
              else
                begin
                   unibus.devREQO  <= 1;
                   unibus.devADDRO <= {wrFLAGS, 2'b0, regBA};
                   state <= stateNPROM1;
                end

            //
            // NPR Out Multiple 1
            //

            stateNPROM1:
              if (unibus.devACKI)
                begin
                   unibus.devREQO <= 0;
                   ubeINC <= 1;
                   state  <= stateNPROM2;
                end

            //
            // NPR Out Multiple 2
            //

            stateNPROM2:
              begin
                 ubeINC <= 0;
                 state  <= stateNPROM3;
              end

            //
            // NPR Out Multiple 3
            //

            stateNPROM3:
              begin
                 state <= stateNPROM0;
              end

            //
            // NPR In Multiple 0
            //
            // Loop Destination
            //
            // Start read cycle from memory
            //

            stateNPRIM0:
              if (regCC[15:1] == 0)
                begin
                   ubeINC <= 0;
                   unibus.devREQO  <= 0;
                   unibus.devADDRO <= 0;
                   state  <= stateIDLE;
                end
              else
                begin
                   ubeINC <= 0;
                   unibus.devREQO  <= 1;
                   unibus.devADDRO <= {rdFLAGS, 2'b0, regBA};
                   state  <= stateNPRIM1;
                end

            //
            // NPR In Multiple 1
            //

            stateNPRIM1:
              if (unibus.devACKI)
                begin
                   unibus.devREQO <= 0;
                   ubeINC <= 1;
                   state  <= stateNPRIM2;
                end

            //
            // NPR In Multiple 2
            //

            stateNPRIM2:
              begin
                 ubeINC <= 0;
                 state  <= stateNPRIM3;
              end

            //
            // NPR In Multiple 3
            //

            stateNPRIM3:
              begin
                 state <= stateNPRIM0;
              end

          endcase
     end

   //
   // Generate Bus ACK
   //  Don't ACK a request when this device is already making
   //  a request
   //

   assign unibus.devACKO = ((!(unibus.devREQO & !ubeNPRO) & dbREAD)     |
                            (!(unibus.devREQO & !ubeNPRO) & dbWRITE)    |
                            (!(unibus.devREQO & !ubeNPRO) & ccREAD)     |
                            (!(unibus.devREQO & !ubeNPRO) & ccWRITE)    |
                            (!(unibus.devREQO & !ubeNPRO) & baREAD)     |
                            (!(unibus.devREQO & !ubeNPRO) & baWRITE)    |
                            (!(unibus.devREQO & !ubeNPRO) & csr1READ)   |
                            (!(unibus.devREQO & !ubeNPRO) & csr1WRITE)  |
                            (!(unibus.devREQO & !ubeNPRO) & csr2READ)   |
                            (!(unibus.devREQO & !ubeNPRO) & csr2WRITE)  |
                            (!(unibus.devREQO & !ubeNPRO) & clrREAD)    |
                            (!(unibus.devREQO & !ubeNPRO) & clrWRITE)   |
                            (!(unibus.devREQO & !ubeNPRO) & simgoREAD)  |
                            (!(unibus.devREQO & !ubeNPRO) & simgoWRITE) |
                            (!(unibus.devREQO & !ubeNPRO) & vectREAD));

   //
   // Bus Mux
   //  NPR Out operations have priority.  Requests will not be
   //  ACK'd while an NPR Out operation is occurring.  See above.
   //

   always_comb
     begin
        unibus.devDATAO = 0;
        if (unibus.devREQO & ubeNPRO)
          unibus.devDATAO = {2'b0, regDB, 2'b0, regDB};
        else
          begin
             if (dbREAD)
               unibus.devDATAO = {20'b0, regDB};
             if (ccREAD)
               unibus.devDATAO = {20'b0, regCC};
             if (baREAD)
               unibus.devDATAO = {20'b0, regBA};
             if (csr1READ)
               unibus.devDATAO = {20'b0, regCSR1};
             if (csr2READ)
               unibus.devDATAO = {20'b0, regCSR2};
             if (vectREAD)
               unibus.devDATAO = {20'b0, ubeVECT[20:35]};
          end
     end

endmodule
