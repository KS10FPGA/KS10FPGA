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
      input  wire          clk,                         // Clock
      input  wire          rst,                         // Reset
      // Reset
      input  wire          devRESET,                    // Device Reset
      // AC LO
      output logic         devACLO,                     // Device Power Fail
      // Interrupt
      output logic [ 7: 4] devINTR,                     // Device Interrupt Request
      // Target
      input  wire          devREQI,                     // Device Request In
      output logic         devACKO,                     // Device Acknowledge Out
      input  wire  [ 0:35] devADDRI,                    // Device Address In
      input  wire  [ 0:35] devDATAI,                    // Device Data In
      // Initiator
      output logic         devREQO,                     // Device Request Out
      input  wire          devACKI,                     // Device Acknowledge In
      output logic [ 0:35] devADDRO,                    // Device Address Out
      output logic [ 0:35] devDATAO                     // Device Data Out
   );

   //
   // UBE Parameters
   //

   parameter  [14:17] ubeDEV  = `ube1DEV;               // UBE Device Number
   parameter  [18:35] ubeVECT = `ube1VECT;              // UBE Interrupt Vector
   parameter  [18:35] ubeADDR = `ube1ADDR;              // UBE Base Address

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

   wire vectREAD   = devREQI & devREAD  & devIO & devPHYS & !devWRU &  devVECT & (devDEV == ubeDEV);
   wire dbREAD     = devREQI & devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == ubeDEV) & (devADDR == dbADDR[18:34]);
   wire dbWRITE    = devREQI & devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == ubeDEV) & (devADDR == dbADDR[18:34]);
   wire ccREAD     = devREQI & devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == ubeDEV) & (devADDR == ccADDR[18:34]);
   wire ccWRITE    = devREQI & devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == ubeDEV) & (devADDR == ccADDR[18:34]);
   wire baREAD     = devREQI & devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == ubeDEV) & (devADDR == baADDR[18:34]);
   wire baWRITE    = devREQI & devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == ubeDEV) & (devADDR == baADDR[18:34]);
   wire csr1READ   = devREQI & devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == ubeDEV) & (devADDR == csr1ADDR[18:34]);
   wire csr1WRITE  = devREQI & devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == ubeDEV) & (devADDR == csr1ADDR[18:34]);
   wire csr2READ   = devREQI & devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == ubeDEV) & (devADDR == csr2ADDR[18:34]);
   wire csr2WRITE  = devREQI & devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == ubeDEV) & (devADDR == csr2ADDR[18:34]);
   wire clrREAD    = devREQI & devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == ubeDEV) & (devADDR == clrADDR[18:34]);
   wire clrWRITE   = devREQI & devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == ubeDEV) & (devADDR == clrADDR[18:34]);
   wire simgoREAD  = devREQI & devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == ubeDEV) & (devADDR == simgoADDR[18:34]);
   wire simgoWRITE = devREQI & devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == ubeDEV) & (devADDR == simgoADDR[18:34]);

   //
   // Big-endian to little-endian data bus swap
   //

   wire [35:0] ubeDATAI = devDATAI[0:35];

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
   assign       devACLO  = `ubeCSR2_ACLO(regCSR2);       // Power down

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
      .devRESET   (devRESET),
      .devHIBYTE  (devHIBYTE),
      .devLOBYTE  (devLOBYTE),
      .devADDRO   (devADDRO),
      .devDATAI   (devDATAI),
      .devREQO    (devREQO),
      .devACKI    (devACKI),
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
      .devRESET   (devRESET),
      .devHIBYTE  (devHIBYTE),
      .devLOBYTE  (devLOBYTE),
      .devDATAI   (devDATAI),
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
      .devRESET   (devRESET),
      .devHIBYTE  (devHIBYTE),
      .devLOBYTE  (devLOBYTE),
      .devDATAI   (devDATAI),
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
      .clr        (devRESET),
      .devHIBYTE  (devHIBYTE),
      .devLOBYTE  (devLOBYTE),
      .devDATAI   (devDATAI),
      .csr1WRITE  (csr1WRITE),
      .regCSR1    (regCSR1)
   );

   //
   // UBE Control/Status Register #2
   //

   UBECSR2 CSR2 (
      .rst        (rst),
      .clk        (clk),
      .devRESET   (devRESET),
      .devHIBYTE  (devHIBYTE),
      .devLOBYTE  (devLOBYTE),
      .devDATAI   (devDATAI),
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
             ubeINC   <= 0;
             devINTR  <= 0;
             devREQO  <= 0;
             devADDRO <= 0;
             state    <= stateIDLE;
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
                        devINTR <= ubeBR;
                        state   <= stateINTACT;
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
                            devREQO  <= 1;
                            devADDRO <= {rdFLAGS, 2'b0, regBA};
                            state    <= stateNPRS;
                         end

                       //
                       // Single NPR Out
                       //

                       3'b101:
                         begin
                            devREQO  <= 1;
                            devADDRO <= {wrFLAGS, 2'b0, regBA};
                            state    <= stateNPRS;
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
                   devINTR <= 0;
                   state   <= stateIDLE;
                end

            //
            // NPR Single
            //  Just wait for the ACK then negate REQ
            //

            stateNPRS:
              if (devACKI)
                begin
                   devREQO <= 0;
                   state   <= stateIDLE;
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
                   devREQO  <= 0;
                   devADDRO <= 0;
                   state    <= stateIDLE;
                end
              else
                begin
                   devREQO  <= 1;
                   devADDRO <= {wrFLAGS, 2'b0, regBA};
                   state    <= stateNPROM1;
                end

            //
            // NPR Out Multiple 1
            //

            stateNPROM1:
              if (devACKI)
                begin
                   devREQO <= 0;
                   ubeINC  <= 1;
                   state   <= stateNPROM2;
                end

            //
            // NPR Out Multiple 2
            //

            stateNPROM2:
              begin
                 ubeINC  <= 0;
                 state   <= stateNPROM3;
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
                   ubeINC   <= 0;
                   devREQO  <= 0;
                   devADDRO <= 0;
                   state    <= stateIDLE;
                end
              else
                begin
                   ubeINC   <= 0;
                   devREQO  <= 1;
                   devADDRO <= {rdFLAGS, 2'b0, regBA};
                   state    <= stateNPRIM1;
                end

            //
            // NPR In Multiple 1
            //

            stateNPRIM1:
              if (devACKI)
                begin
                   devREQO <= 0;
                   ubeINC  <= 1;
                   state   <= stateNPRIM2;
                end

            //
            // NPR In Multiple 2
            //

            stateNPRIM2:
              begin
                 ubeINC  <= 0;
                 state   <= stateNPRIM3;
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

   assign devACKO = ((!(devREQO & !ubeNPRO) & dbREAD)     |
                     (!(devREQO & !ubeNPRO) & dbWRITE)    |
                     (!(devREQO & !ubeNPRO) & ccREAD)     |
                     (!(devREQO & !ubeNPRO) & ccWRITE)    |
                     (!(devREQO & !ubeNPRO) & baREAD)     |
                     (!(devREQO & !ubeNPRO) & baWRITE)    |
                     (!(devREQO & !ubeNPRO) & csr1READ)   |
                     (!(devREQO & !ubeNPRO) & csr1WRITE)  |
                     (!(devREQO & !ubeNPRO) & csr2READ)   |
                     (!(devREQO & !ubeNPRO) & csr2WRITE)  |
                     (!(devREQO & !ubeNPRO) & clrREAD)    |
                     (!(devREQO & !ubeNPRO) & clrWRITE)   |
                     (!(devREQO & !ubeNPRO) & simgoREAD)  |
                     (!(devREQO & !ubeNPRO) & simgoWRITE) |
                     (!(devREQO & !ubeNPRO) & vectREAD));

   //
   // Bus Mux
   //  NPR Out operations have priority.  Requests will not be
   //  ACK'd while an NPR Out operation is occurring.  See above.
   //

   always_comb
     begin
        devDATAO = 0;
        if (devREQO & ubeNPRO)
          devDATAO = {2'b0, regDB, 2'b0, regDB};
        else
          begin
             if (dbREAD)
               devDATAO = {20'b0, regDB};
             if (ccREAD)
               devDATAO = {20'b0, regCC};
             if (baREAD)
               devDATAO = {20'b0, regBA};
             if (csr1READ)
               devDATAO = {20'b0, regCSR1};
             if (csr2READ)
               devDATAO = {20'b0, regCSR2};
             if (vectREAD)
               devDATAO = {20'b0, ubeVECT[20:35]};
          end
     end

`ifndef SYNTHESIS

   integer file;

`endif

endmodule
