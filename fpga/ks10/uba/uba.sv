////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KS10 IO Bus Bridge
//
// Details
//   This device 'bridges' the KS10 FPGA backplane bus to the IO Bus.  On a
//   real KS10, the IO bus was UNIBUS.  The IO Bus in the KS10 FPGA is not
//   UNIBUS.
//
// Notes
//   Important addresses:
//
//   763000-763077 : IO Bridge Paging RAM
//   763100        : IO Bridge Status Register
//   763101        : IO Bridge Maintenace Register
//
// File
//   uba.sv
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

`include "uba.vh"
`include "ubasr.vh"
`include "ubapage.vh"
`include "../cpu/bus.vh"

module UBA (
      input  wire          rst,                         // Reset
      input  wire          clk,                         // Clock
      ks10bus.device       ubaBUS,                      // Backplane Bus
      // Device Reset
      output logic         devRESET,                    // Device Reset
      // AC LO
      input  wire          devACLO[1:4],                // Device AC power failure
      // Interupt
      input  wire  [ 7: 4] devINTR[1:4],                // Device Interrupt Request
      // Device as Target
      input  wire          devREQI[1:4],                // Device Request In
      output logic         devACKO[1:4],                // Device Acknowledge Out
      input  wire  [ 0:35] devADDRI[1:4],               // Device Address In
      input  wire  [ 0:35] devDATAI[1:4],               // Device Data In
      // Device as Initiator
      output logic         devREQO[1:4],                // Device Request Out
      input  wire          devACKI[1:4],                // Device Acknowledge In
      output logic [ 0:35] devADDRO[1:4],               // Device Address Out
      output logic [ 0:35] devDATAO[1:4]                // Device Data Out
   );

   //
   // Memory flags
   //

   localparam [ 0:17] flagWRITE = 18'o010000,           // Write bus cycle
                      flagREAD  = 18'o040000;           // Read bus cycle

   //
   // IO Bridge Configuration
   //

   parameter  [14:17] ubaNUM    = 4'd0;                 // Bridge Device Number
   parameter  [18:35] ubaADDR   = `ubaADDR;             // Base address
   localparam [18:35] pageADDR  = ubaADDR + `pageOFFSET;// Paging RAM Address
   localparam [18:35] statADDR  = ubaADDR + `statOFFSET;// Status Register Address
   localparam [18:35] maintADDR = ubaADDR + `maintOFFSET;// Maintenance Register Address
   localparam [ 0:35] wruRESP   = `getWRU(ubaNUM);      // Lookup WRU Response

   //
   // KS10 Address Bus
   //
   // Details:
   //  busADDRI[ 0:13] is flags
   //  busADDRI[14:35] is address
   //

   wire          busREAD   = `busREAD(ubaBUS.busADDRI); // Read Cycle (IO or Memory)
   wire          busWRITE  = `busWRITE(ubaBUS.busADDRI);// Write Cycle (IO or Memory)
   wire          busPHYS   = `busPHYS(ubaBUS.busADDRI); // Physical reference
   wire          busIO     = `busIO(ubaBUS.busADDRI);   // IO Cycle
   wire          busWRU    = `busWRU(ubaBUS.busADDRI);  // Read interrupting controller number
   wire          busVECT   = `busVECT(ubaBUS.busADDRI); // Read interrupt vector
// wire          busIOBYTE = `busIOBYTE(ubaBUS.busADDRI);// IO Byte Cycle
   wire  [15:17] busPI     = `busPI(ubaBUS.busADDRI);   // IO Bridge PI Request
   wire  [14:17] busDEV    = `busDEV(ubaBUS.busADDRI);  // IO Bridge Device Number
   wire  [18:35] busADDR   = `busIOADDR(ubaBUS.busADDRI);// IO Address

   //
   // Signals
   //

   logic         regUBAMR;                              // Maintenance Mode
   logic         setNXD;                                // Set NXD
   logic         setTMO;                                // Set TMO
   logic         pageFAIL;                              // Page failure

   //
   // Device request on any device input
   //

   wire          devREQ   = devREQI[1] | devREQI[2] | devREQI[3] | devREQI[4];

   //
   // Paging flags
   //

   logic [ 0: 3] pageFLAGS;                             // Page flags
   wire          flagsRRV = `flagsRRV(pageFLAGS);       // Page uses Read Reverse Mode
   wire          flagsE16 = `flagsE16(pageFLAGS);       // Page uses 16-bit transfers
   wire          flagsFTM = `flagsFTM(pageFLAGS);       // Page uses Fast Transfer Mode
// wire          flagsVLD = `flagsVLD(pageFLAGS);       // Page valid

   //
   // Address Decoding
   //

   wire wruREAD    = ubaBUS.busREQI & busREAD  & busIO & busPHYS &  busWRU & !busVECT;
   wire vectREAD   = ubaBUS.busREQI & busREAD  & busIO & busPHYS & !busWRU &  busVECT & (busDEV == ubaNUM);
   wire pageREAD   = ubaBUS.busREQI & busREAD  & busIO & busPHYS & !busWRU & !busVECT & (busDEV == ubaNUM) & (busADDR[18:29] == pageADDR[18:29]);
   wire pageWRITE  = ubaBUS.busREQI & busWRITE & busIO & busPHYS & !busWRU & !busVECT & (busDEV == ubaNUM) & (busADDR[18:29] == pageADDR[18:29]);
   wire statREAD   = ubaBUS.busREQI & busREAD  & busIO & busPHYS & !busWRU & !busVECT & (busDEV == ubaNUM) & (busADDR[18:35] == statADDR[18:35]);
   wire statWRITE  = ubaBUS.busREQI & busWRITE & busIO & busPHYS & !busWRU & !busVECT & (busDEV == ubaNUM) & (busADDR[18:35] == statADDR[18:35]);
   wire maintWRITE = ubaBUS.busREQI & busWRITE & busIO & busPHYS & !busWRU & !busVECT & (busDEV == ubaNUM) & (busADDR[18:35] == maintADDR[18:35]);
   wire devREAD    = ubaBUS.busREQI & busREAD  & busIO & busPHYS & !busWRU & !busVECT & (busDEV == ubaNUM) & (busADDR[18:28] != ubaADDR[18:28]) & !regUBAMR;
   wire devWRITE   = ubaBUS.busREQI & busWRITE & busIO & busPHYS & !busWRU & !busVECT & (busDEV == ubaNUM) & (busADDR[18:28] != ubaADDR[18:28]) & !regUBAMR;
   wire loopREAD   = ubaBUS.busREQI & busREAD  & busIO & busPHYS & !busWRU & !busVECT & (busDEV == ubaNUM) & (busADDR[18:28] != ubaADDR[18:28]) &  regUBAMR;
   wire loopWRITE  = ubaBUS.busREQI & busWRITE & busIO & busPHYS & !busWRU & !busVECT & (busDEV == ubaNUM) & (busADDR[18:28] != ubaADDR[18:28]) &  regUBAMR;

   //
   // Status Register
   //
   //  The status register is read/write.
   //

   logic [ 0:35] regUBASR;
   wire          statINI = `statINI(regUBASR);
   wire  [ 0: 2] statPIH = `statPIH(regUBASR);
   wire  [ 0: 2] statPIL = `statPIL(regUBASR);

   UBASR SR (
      .rst        (rst),
      .clk        (clk),
      .busDATAI   (ubaBUS.busDATAI),
      .devACLO    (devACLO),
      .devINTR    (devINTR),
      .statWRITE  (statWRITE),
      .setNXD     (setNXD),
      .setTMO     (setTMO | pageFAIL),
      .regUBASR   (regUBASR)
   );

   //
   // Maintenance Register
   //
   //  The maintenance register is write only.
   //

   UBAMR MR (
      .rst        (rst),
      .clk        (clk),
      .busDATAI   (ubaBUS.busDATAI),
      .maintWRITE (maintWRITE),
      .regUBAMR   (regUBAMR)
   );

   //
   // Interrupts
   //

   UBAINTR INTR (
      .rst        (rst),
      .clk        (clk),
      .busPI      (busPI),
      .busINTR    (ubaBUS.busINTRO),
      .wruREAD    (wruREAD),
      .regUBASR   (regUBASR),
      .devINTR    (devINTR)
   );

   //
   // IO Bus Paging
   //
   //  Don't ever attempt to "page" an IO operation.
   //

   logic [0:35] pageADDRI;
   logic [0:35] pageDATAO;

   UBAPAGE PAGE (
      .rst        (rst),
      .clk        (clk),
      .devREQI    (devREQ),
      .busADDRI   (ubaBUS.busADDRI),
      .busDATAI   (ubaBUS.busDATAI),
      .busADDRO   (ubaBUS.busADDRO),
      .pageWRITE  (pageWRITE),
      .pageDATAO  (pageDATAO),
      .pageADDRI  (pageADDRI),
      .pageFLAGS  (pageFLAGS),
      .pageFAIL   (pageFAIL)
   );

   //
   // Device arbiter
   //

   localparam [0:4] stateIDLE       =  0,               // IDLE
                    stateCPUtoDEV   =  1,               // Request from CPU to Device
                    stateCPUtoVEC   =  2,               // Request from CPU to Interrupt Vector
                    stateDEVtoMEM0  =  3,               // Request from Device to Memory
                    stateDEVtoMEM1  =  4,               // Request from Device to Memory
                    stateDEVtoIO    =  5,               // Request from Device to IO
                    stateLOOPtoMEM0 =  6,               // Request from Loopback to Memory
                    stateLOOPtoMEM1 =  7,               // Request from Loopback to Memory
                    stateLOOPtoMEM2 =  8,               // Request from Loopback to Memory
                    stateLOOPtoMEM3 =  9,               // Request from Loopback to Memory
                    stateLOOPtoMEM4 = 10,               // Request from Loopback to Memory
                    stateMEMtoLOOP0 = 11,               // Request from Memory to Loopback
                    stateMEMtoLOOP1 = 12,               // Request from Memory to Loopback
                    stateMEMtoLOOP2 = 13,               // Request from Memory to Loopback
                    stateMEMtoLOOP3 = 14,               // Request from Memory to Loopback
                    stateWAITREG    = 15,               // Wait for register to complete
                    stateWAITBUSREQ = 16,               // Wait for bus request to complete
                    stateWAITDEVREQ = 17,               // Wait for device request to complete
                    stateWAITVECREQ = 18,               // Wait for vector request to compelte
                    stateDONE       = 19;               // Done

   localparam [ 0: 3] timeout = 4'd8;
   logic      [ 0:35] rpwDATA;                          // Read/Pause/Write Data
   logic      [ 0:35] loopDATA;                         // Loopback Data
   logic      [ 0:35] loopADDR;                         // Loopback Addr
   logic      [ 0: 2] devSEL;                           // Device select
   logic      [ 0: 3] cntTMO;                           // Timeout timer
   logic      [ 0: 3] cntNXD;                           // Timeout timer
   logic      [ 0: 4] state;                            // State variable

   always_ff @(posedge clk)
     if (rst | devRESET)
       begin
          ubaBUS.busREQO  <= 0;
          ubaBUS.busACKO  <= 0;
          ubaBUS.busDATAO <= 0;
          devREQO[1]  <= 0;
          devREQO[2]  <= 0;
          devREQO[3]  <= 0;
          devREQO[4]  <= 0;
          devACKO[1]  <= 0;
          devACKO[2]  <= 0;
          devACKO[3]  <= 0;
          devACKO[4]  <= 0;
          devADDRO[1] <= 0;
          devADDRO[2] <= 0;
          devADDRO[3] <= 0;
          devADDRO[4] <= 0;
          devDATAO[1] <= 0;
          devDATAO[2] <= 0;
          devDATAO[3] <= 0;
          devDATAO[4] <= 0;
          pageADDRI   <= 0;
          rpwDATA     <= 0;
          loopADDR    <= 0;
          loopDATA    <= 0;
          devSEL      <= 0;
          cntNXD      <= 0;
          cntTMO      <= 0;
          state       <= stateIDLE;
       end

     else

       case (state)
         stateIDLE:

           //
           // CPU is accessing status register
           //

           if ((ubaBUS.busREQI & statREAD) | (ubaBUS.busREQI & statWRITE))
             begin
                ubaBUS.busACKO  <= 1;
                ubaBUS.busDATAO <= regUBASR;
                state <= stateWAITBUSREQ;
             end

           //
           // CPU is accessing paging data
           //

           else if ((ubaBUS.busREQI & pageREAD) | (ubaBUS.busREQI & pageWRITE))
             begin
                ubaBUS.busACKO  <= 1;
                ubaBUS.busDATAO <= pageDATAO;
                state <= stateWAITBUSREQ;
             end

           //
           // CPU is performing a loopback read
           //  Need to do an NPR read and return the results of that read on
           //  this IO read operation.
           //
           //  DO NOT acknowledge this IO request from the CPU yet.
           //

           else if (ubaBUS.busREQI & loopREAD)
             begin
                loopADDR  <= ubaBUS.busADDRI;
                pageADDRI <= ubaBUS.busADDRI;
                cntTMO    <= timeout;
                state     <= stateMEMtoLOOP0;
             end

           //
           // CPU is performing a loopback write
           //

           else if (ubaBUS.busREQI & loopWRITE)
             begin
                ubaBUS.busACKO   <= 1;
                case ({`devIOBYTE(ubaBUS.busADDRI), `devWORDSEL(ubaBUS.busADDRI), `devBYTESEL(ubaBUS.busADDRI)})
                  3'b000: loopDATA[ 0:17] <= ubaBUS.busDATAI[18:35];     // Even word
                  3'b001: loopDATA[ 0:17] <= ubaBUS.busDATAI[18:35];     // Even word
                  3'b010: loopDATA[18:35] <= ubaBUS.busDATAI[18:35];     // Odd  word
                  3'b011: loopDATA[18:35] <= ubaBUS.busDATAI[18:35];     // Odd  word
                  3'b100: loopDATA[10:17] <= ubaBUS.busDATAI[28:35];     // Even word, low  byte.
                  3'b101: loopDATA[ 2: 9] <= ubaBUS.busDATAI[20:27];     // Even word, high byte.
                  3'b110: loopDATA[28:35] <= ubaBUS.busDATAI[28:35];     // Odd  word, low  byte.
                  3'b111: loopDATA[20:27] <= ubaBUS.busDATAI[20:27];     // Odd  word, high byte.
                endcase
                loopADDR  <= ubaBUS.busADDRI;
                pageADDRI <= ubaBUS.busADDRI;                            // Lookup paging for this address
                cntTMO    <= timeout;
                state     <= stateLOOPtoMEM0;
             end

           //
           // CPU is accessing the maintenance register
           //

           else if (ubaBUS.busREQI & maintWRITE)
             begin
                ubaBUS.busACKO <= 1;
                state <= stateWAITBUSREQ;
             end

           //
           // CPU is doing a WRU bus cycle
           //

           else if (ubaBUS.busREQI & wruREAD & ((busPI == statPIH) | (busPI == statPIL)))
             begin
                ubaBUS.busACKO  <= 1;
                ubaBUS.busDATAO <= wruRESP;
                state <= stateWAITBUSREQ;
             end

           //
           // CPU is requesting data from an IO device
           //

           else if ((ubaBUS.busREQI & devREAD) | (ubaBUS.busREQI & devWRITE))
             begin
                devREQO[1]  <= 1;
                devREQO[2]  <= 1;
                devREQO[3]  <= 1;
                devREQO[4]  <= 1;
                devADDRO[1] <= ubaBUS.busADDRI;
                devADDRO[2] <= ubaBUS.busADDRI;
                devADDRO[3] <= ubaBUS.busADDRI;
                devADDRO[4] <= ubaBUS.busADDRI;
                devDATAO[1] <= ubaBUS.busDATAI;
                devDATAO[2] <= ubaBUS.busDATAI;
                devDATAO[3] <= ubaBUS.busDATAI;
                devDATAO[4] <= ubaBUS.busDATAI;
                cntNXD      <= timeout;
                state       <= stateCPUtoDEV;
             end

           //
           // CPU is requesting a vector from an IO device
           //  Determine the highest priority interrupt and request the
           //  highest priority device to provide the interrupt vector.
           //

           else if (ubaBUS.busREQI & vectREAD)
             begin
                if (devINTR[1][7])
                  devREQO[1] <= 1;
                else if (devINTR[2][7])
                  devREQO[2] <= 1;
                else if (devINTR[3][7])
                  devREQO[3] <= 1;
                else if (devINTR[4][7])
                  devREQO[4] <= 1;
                else if (devINTR[1][6])
                  devREQO[1] <= 1;
                else if (devINTR[2][6])
                  devREQO[2] <= 1;
                else if (devINTR[3][6])
                  devREQO[3] <= 1;
                else if (devINTR[4][6])
                  devREQO[4] <= 1;
                else if (devINTR[1][5])
                  devREQO[1] <= 1;
                else if (devINTR[2][5])
                  devREQO[2] <= 1;
                else if (devINTR[3][5])
                  devREQO[3] <= 1;
                else if (devINTR[4][5])
                  devREQO[4] <= 1;
                else if (devINTR[1][4])
                  devREQO[1] <= 1;
                else if (devINTR[2][4])
                  devREQO[2] <= 1;
                else if (devINTR[3][4])
                  devREQO[3] <= 1;
                else if (devINTR[4][4])
                  devREQO[4] <= 1;
                cntNXD      <= timeout;
                devADDRO[1] <= ubaBUS.busADDRI;
                devADDRO[2] <= ubaBUS.busADDRI;
                devADDRO[3] <= ubaBUS.busADDRI;
                devADDRO[4] <= ubaBUS.busADDRI;
                state       <= stateCPUtoVEC;
             end

           //
           // Device 1 is requesting IO or memory
           //

           else if (devREQI[1])

             //
             // Device 1 is requesting IO
             //

             if (`busIO(devADDRI[1]))
               begin
                  devSEL      <= 3'd1;
                  devREQO[1]  <= 1;
                  devREQO[2]  <= 1;
                  devREQO[3]  <= 1;
                  devREQO[4]  <= 1;
                  devADDRO[1] <= devADDRI[1];
                  devADDRO[2] <= devADDRI[1];
                  devADDRO[3] <= devADDRI[1];
                  devADDRO[4] <= devADDRI[1];
                  devDATAO[1] <= devDATAI[1];
                  devDATAO[2] <= devDATAI[1];
                  devDATAO[3] <= devDATAI[1];
                  devDATAO[4] <= devDATAI[1];
                  state       <= stateDEVtoIO;
               end

             //
             // Device 1 is requesting memory
             //

             else
               begin
                  ubaBUS.busDATAO <= devDATAI[1];
                  devSEL    <= 3'd1;
                  pageADDRI <= devADDRI[1];
                  cntTMO    <= timeout;
                  state     <= stateDEVtoMEM0;
               end

           //
           // Device 2 is requesting IO or memory
           //

           else if (devREQI[2])

             //
             // Device 2 is requesting IO
             //

             if (`busIO(devADDRI[2]))
               begin
                  devSEL      <= 3'd2;
                  devREQO[1]  <= 1;
                  devREQO[2]  <= 1;
                  devREQO[3]  <= 1;
                  devREQO[4]  <= 1;
                  devADDRO[1] <= devADDRI[2];
                  devADDRO[2] <= devADDRI[2];
                  devADDRO[3] <= devADDRI[2];
                  devADDRO[4] <= devADDRI[2];
                  devDATAO[1] <= devDATAI[2];
                  devDATAO[2] <= devDATAI[2];
                  devDATAO[3] <= devDATAI[2];
                  devDATAO[4] <= devDATAI[2];
                  state       <= stateDEVtoIO;
               end

             //
             // Device 2 is requesting memory
             //

             else
               begin
                  ubaBUS.busDATAO <= devDATAI[2];
                  devSEL    <= 3'd2;
                  pageADDRI <= devADDRI[2];
                  cntTMO    <= timeout;
                  state     <= stateDEVtoMEM0;
               end

           //
           // Device 3 is requesting IO or memory
           //

           else if (devREQI[3])

             //
             // Device 3 is requesting IO
             //

             if (`busIO(devADDRI[3]))
               begin
                  devSEL      <= 3'd3;
                  devREQO[1]  <= 1;
                  devREQO[2]  <= 1;
                  devREQO[3]  <= 1;
                  devREQO[4]  <= 1;
                  devADDRO[1] <= devADDRI[3];
                  devADDRO[2] <= devADDRI[3];
                  devADDRO[3] <= devADDRI[3];
                  devADDRO[4] <= devADDRI[3];
                  devDATAO[1] <= devDATAI[3];
                  devDATAO[2] <= devDATAI[3];
                  devDATAO[3] <= devDATAI[3];
                  devDATAO[4] <= devDATAI[3];
                  state       <= stateDEVtoIO;
               end

             //
             // Device 3 is requesting memory
             //

             else
               begin
                  ubaBUS.busDATAO <= devDATAI[3];
                  devSEL    <= 3'd3;
                  pageADDRI <= devADDRI[3];
                  cntTMO    <= timeout;
                  state     <= stateDEVtoMEM0;
               end

           //
           // Device 4 is requesting IO or memory
           //

           else if (devREQI[4])

             //
             // Device 4 is requesting IO
             //

             if (`busIO(devADDRI[4]))
               begin
                  devSEL      <= 3'd4;
                  devREQO[1]  <= 1;
                  devREQO[2]  <= 1;
                  devREQO[3]  <= 1;
                  devREQO[4]  <= 1;
                  devADDRO[1] <= devADDRI[4];
                  devADDRO[2] <= devADDRI[4];
                  devADDRO[3] <= devADDRI[4];
                  devADDRO[4] <= devADDRI[4];
                  devDATAO[1] <= devDATAI[4];
                  devDATAO[2] <= devDATAI[4];
                  devDATAO[3] <= devDATAI[4];
                  devDATAO[4] <= devDATAI[4];
                  state       <= stateDEVtoIO;
               end

             //
             // Device 4 is requesting memory
             //

             else
               begin
                  ubaBUS.busDATAO <= devDATAI[4];
                  devSEL    <= 3'd4;
                  pageADDRI <= devADDRI[4];
                  cntTMO    <= timeout;
                  state     <= stateDEVtoMEM0;
               end

         //
         // CPU is requesting data from an IO device
         //

         stateCPUtoDEV:
           if (devACKI[1])
             begin
                ubaBUS.busACKO  <= 1;
                ubaBUS.busDATAO <= devDATAI[1];
                devREQO[1] <= 0;
                devREQO[2] <= 0;
                devREQO[3] <= 0;
                devREQO[4] <= 0;
                state      <= stateWAITBUSREQ;
             end
           else if (devACKI[2])
             begin
                ubaBUS.busACKO  <= 1;
                ubaBUS.busDATAO <= devDATAI[2];
                devREQO[1] <= 0;
                devREQO[2] <= 0;
                devREQO[3] <= 0;
                devREQO[4] <= 0;
                state      <= stateWAITBUSREQ;
             end
           else if (devACKI[3])
             begin
                ubaBUS.busACKO  <= 1;
                ubaBUS.busDATAO <= devDATAI[3];
                devREQO[1] <= 0;
                devREQO[2] <= 0;
                devREQO[3] <= 0;
                devREQO[4] <= 0;
                state      <= stateWAITBUSREQ;
             end
           else if (devACKI[4])
             begin
                ubaBUS.busACKO  <= 1;
                ubaBUS.busDATAO <= devDATAI[4];
                devREQO[1] <= 0;
                devREQO[2] <= 0;
                devREQO[3] <= 0;
                devREQO[4] <= 0;
                state      <= stateWAITBUSREQ;
             end
           else if (!ubaBUS.busREQI)
             state <= stateDONE;
           else if (cntNXD != 0)
             cntNXD <= cntNXD - 1'b1;
           else
             state <= stateWAITBUSREQ;

         //
         // CPU is requesting a Interrupt Vector
         //  Acknowledge the vector data from the highest priority device
         //  and forward the vector to the CPU.
         //

         stateCPUtoVEC:
           if (devREQO[1] & devACKI[1])
             begin
                ubaBUS.busACKO  <= 1;
                ubaBUS.busDATAO <= devDATAI[1];
                devREQO[1] <= 0;
                state      <= stateWAITVECREQ;
             end
           else if (devREQO[2] & devACKI[2])
             begin
                ubaBUS.busACKO  <= 1;
                ubaBUS.busDATAO <= devDATAI[2];
                devREQO[2] <= 0;
                state      <= stateWAITVECREQ;
             end
           else if (devREQO[3] & devACKI[3])
             begin
                ubaBUS.busACKO  <= 1;
                ubaBUS.busDATAO <= devDATAI[3];
                devREQO[3] <= 0;
                state      <= stateWAITVECREQ;
             end
           else if (devREQO[4] & devACKI[4])
             begin
                ubaBUS.busACKO  <= 1;
                ubaBUS.busDATAO <= devDATAI[4];
                devREQO[4] <= 0;
                state      <= stateWAITVECREQ;
             end
           else if (cntTMO != 0)
             cntTMO <= cntTMO - 1'b1;
           else
             begin
                ubaBUS.busREQO <= 0;
                state   <= stateDONE;
             end

         //
         // Check for page failures before acessing memory.  If UBA page
         //  failure, bail out; otherwise start a memory request.
         //

         stateDEVtoMEM0:
           begin
              if (pageFAIL)
                state <= stateDONE;
              else
                begin
                   ubaBUS.busREQO <= 1;
                   state   <= stateDEVtoMEM1;
                end
           end

         //
         // Device is requesting access to memory.
         //  Wait for memory to respond
         //

         stateDEVtoMEM1:
           if (ubaBUS.busACKI)
             begin
                ubaBUS.busREQO         <= 0;
                devACKO[devSEL] <= 1;
                devDATAO[1]     <= ubaBUS.busDATAI;
                devDATAO[2]     <= ubaBUS.busDATAI;
                devDATAO[3]     <= ubaBUS.busDATAI;
                devDATAO[4]     <= ubaBUS.busDATAI;
                state           <= stateWAITDEVREQ;
             end
           else if (!devREQI[devSEL])
             begin
                ubaBUS.busREQO <= 0;
                state   <= stateDONE;
             end
           else if (cntTMO != 0)
             cntTMO <= cntTMO - 1'b1;
           else
             begin
                ubaBUS.busREQO <= 0;
                state   <= stateDONE;
             end

         //
         // A device is requesting an IO access
         //  DSKMA Test.65 does a NPR IO write through the UBA to it's own CSR4
         //  DSKMA Test.66 does a NPR IO read through the UBA to it's own CSR4.
         //

         stateDEVtoIO:
           begin
              if (devACKI[1])
                begin
                   devACKO[devSEL]  <= 1;
                   devDATAO[devSEL] <= devDATAI[1];
                   state            <= stateDONE;
                end
              if (devACKI[2])
                begin
                   devACKO[devSEL]  <= 1;
                   devDATAO[devSEL] <= devDATAI[2];
                   state            <= stateDONE;
                end
              else if (devACKI[3])
                begin
                   devACKO[devSEL]  <= 1;
                   devDATAO[devSEL] <= devDATAI[3];
                   state            <= stateDONE;
                end
              else if (devACKI[4])
                begin
                   devACKO[devSEL]  <= 1;
                   devDATAO[devSEL] <= devDATAI[4];
                   state            <= stateDONE;
                end
              else if (!devREQI[devSEL])
                state <= stateDONE;
           end

         //
         //  Check for page failures before acessing memory.  If UBA page
         //    failure, bail out; otherwise decide what to do and request
         //    memory read or memory write.
         //
         //  Fast Transfer Mode Accesses
         //    In Fast Transfer Mode (FTM), Even words are stored in rpwDATA
         //    and do not generate any memory operations.  Odd words are
         //    combined with Even words and cause both to be written to
         //    memory simultaneously.
         //
         //  Non-RPW Accesses
         //    Normal Mode Even Word
         //    Normal Mode Even Word Low Byte
         //
         //  RPW Accesses (everything else)
         //    Normal Mode Odd Word
         //    Normal Mode Even Word High Byte
         //    Normal Mode Odd  Word High Byte
         //    Normal Mode Odd  Word Low  Byte
         //    Read Reverse Even Word
         //    Read Reverse Odd  Word
         //

         stateLOOPtoMEM0:
           begin
              ubaBUS.busACKO <= 0;
              if (pageFAIL)
                state <= stateDONE;
              else if (flagsFTM)

                //
                // Fast Transfer Mode
                //  DSUBA TEST14
                //

                if (`devWORDSEL(loopADDR))
                  begin
                     ubaBUS.busREQO  <= 1;
                     ubaBUS.busDATAO <= {rpwDATA[0:17], loopDATA[18:35]};
                     cntTMO          <= timeout;
                     pageADDRI[0:17] <= flagWRITE;
                     state           <= stateLOOPtoMEM4;
                  end
                else
                  begin
                     rpwDATA <= loopDATA;
                     state   <= stateDONE;
                  end

              //
              // Normal Mode Even Word (non-RPW) access.
              //  DSUBA TEST11
              //

              else if (!flagsRRV & !`devIOBYTE(loopADDR) & !`devWORDSEL(loopADDR))
                begin
                   ubaBUS.busREQO  <= 1;
                   ubaBUS.busDATAO <= (flagsE16) ? {2'b0, loopDATA[2:17], 2'b0, ubaBUS.busADDRO[20:35]} : {loopDATA[0:17], ubaBUS.busADDRO[18:35]};
                   cntTMO          <= timeout;
                   pageADDRI[0:17] <= flagWRITE;
                   state           <= stateLOOPtoMEM4;
                end

              //
              // Normal Mode Even Word Low Byte (non-RPW) access
              //  DSUBA TEST12
              //

              else if (!flagsRRV & `devIOBYTE(loopADDR) & !`devWORDSEL(loopADDR) & !`devBYTESEL(loopADDR))
                begin
                   ubaBUS.busREQO  <= 1;
                   ubaBUS.busDATAO <= {10'b0, loopDATA[10:17], ubaBUS.busADDRO[18:35]};
                   cntTMO          <= timeout;
                   pageADDRI[0:17] <= flagWRITE;
                   state           <= stateLOOPtoMEM4;
                end

              //
              // All other accesses are RPW Accesses
              //

              else
                begin
                   ubaBUS.busREQO  <= 1;
                   cntTMO          <= timeout;
                   pageADDRI[0:17] <= flagREAD;
                   state           <= stateLOOPtoMEM1;
                end
           end

         //
         // Loopback is requesting read access to memory. Wait for memory to
         //  respond. This is the read cycle of the read/pause/write cycle.
         //

         stateLOOPtoMEM1:
           if (ubaBUS.busACKI)
             begin
                ubaBUS.busREQO <= 0;
                rpwDATA <= ubaBUS.busDATAI;
                state   <= stateLOOPtoMEM2;
             end
           else if (cntTMO != 0)
             cntTMO <= cntTMO - 1'b1;
           else
             begin
                ubaBUS.busREQO <= 0;
                state <= stateDONE;
             end

         //
         // This is the pause cycle of the read/pause/write cycle.
         //

         stateLOOPtoMEM2:
           state <= stateLOOPtoMEM3;

         //
         //  This is the write cycle of the read/pause/write cycle.
         //

         stateLOOPtoMEM3:
           begin
              ubaBUS.busREQO         <= 1;
              pageADDRI[0:17] <= flagWRITE;
              case ({flagsE16, `devIOBYTE(loopADDR), `devWORDSEL(loopADDR), `devBYTESEL(loopADDR)})
                4'b0000: ubaBUS.busDATAO <= {loopDATA[0:17],  rpwDATA[18:35]};        // Even word
                4'b0001: ubaBUS.busDATAO <= {loopDATA[0:17],  rpwDATA[18:35]};        // Even word
                4'b0010: ubaBUS.busDATAO <= { rpwDATA[0:17], loopDATA[18:35]};        // Odd  word
                4'b0011: ubaBUS.busDATAO <= { rpwDATA[0:17], loopDATA[18:35]};        // Odd  word
                4'b0100: ubaBUS.busDATAO <= {2'b0,  rpwDATA[ 2: 9], loopDATA[10:17], 2'b0,  rpwDATA[20:27],  rpwDATA[28:35]};    // Even word, low  byte.
                4'b0101: ubaBUS.busDATAO <= {2'b0, loopDATA[ 2: 9],  rpwDATA[10:17], 2'b0, ubaBUS.busADDRO[20:27], ubaBUS.busADDRO[28:35]};    // TEST16: Even word, high byte.
                4'b0110: ubaBUS.busDATAO <= {       rpwDATA[ 0:17],                  2'b0, loopDATA[20:27], loopDATA[28:35]};    // TEST17: Odd  word, low  byte.
                4'b0111: ubaBUS.busDATAO <= {       rpwDATA[ 0:17],                  2'b0, loopDATA[20:27],  rpwDATA[28:35]};    // TEST20: Odd  word, high byte.
                4'b1000: ubaBUS.busDATAO <= {2'b0, loopDATA[ 2: 9], loopDATA[10:17], 2'b0,  rpwDATA[20:27],  rpwDATA[28:35]};    // E16, Even word
                4'b1001: ubaBUS.busDATAO <= {2'b0, loopDATA[ 2: 9], loopDATA[10:17], 2'b0,  rpwDATA[20:27],  rpwDATA[28:35]};    // E16, Even word
                4'b1010: ubaBUS.busDATAO <= {2'b0,  rpwDATA[ 2: 9],  rpwDATA[10:17], 2'b0, loopDATA[20:27], loopDATA[28:35]};    // E16, Odd  word
                4'b1011: ubaBUS.busDATAO <= {2'b0,  rpwDATA[ 2: 9],  rpwDATA[10:17], 2'b0, loopDATA[20:27], loopDATA[28:35]};    // E16, Odd  word
                4'b1100: ubaBUS.busDATAO <= {2'b0,  rpwDATA[ 2: 9], loopDATA[10:17], 2'b0,  rpwDATA[20:27],  rpwDATA[28:35]};    // E16, Even word, low  byte.
                4'b1101: ubaBUS.busDATAO <= {2'b0, loopDATA[ 2: 9],  rpwDATA[10:17], 2'b0, ubaBUS.busADDRO[20:27], ubaBUS.busADDRO[28:35]};    // E16, Even word, high byte.
                4'b1110: ubaBUS.busDATAO <= {2'b0,  rpwDATA[ 2: 9],  rpwDATA[10:17], 2'b0,  rpwDATA[20:27], loopDATA[28:35]};    // E16, Odd  word, low  byte.
                4'b1111: ubaBUS.busDATAO <= {2'b0,  rpwDATA[ 2: 9],  rpwDATA[10:17], 2'b0, loopDATA[20:27],  rpwDATA[28:35]};    // E16, Odd  word, high byte.
              endcase
              state <= stateLOOPtoMEM4;
           end

         //
         // Wait for memory to finish
         //

         stateLOOPtoMEM4:
           if (ubaBUS.busACKI)
             begin
                ubaBUS.busREQO <= 0;
                state <= stateDONE;
             end
           else if (cntTMO != 0)
             cntTMO <= cntTMO - 1'b1;
           else
             begin
                ubaBUS.busREQO <= 0;
                state <= stateDONE;
             end

         //
         // Check for page failures before acessing memory.  If UBA page
         //  failure, bail out; otherwise start a memory request.
         //

         stateMEMtoLOOP0:
           if (pageFAIL)
             state <= stateDONE;
           else
             begin
                ubaBUS.busREQO  <= 1;
                cntTMO          <= timeout;
                pageADDRI[0:17] <= flagREAD;
                state           <= stateMEMtoLOOP1;
             end

         //
         // Read the data from memory
         //

         stateMEMtoLOOP1:
           if (ubaBUS.busACKI)
             begin
                ubaBUS.busREQO <= 0;
                case ({`devIOBYTE(loopADDR), `devWORDSEL(loopADDR), `devBYTESEL(loopADDR)})
                  3'b000: loopDATA <= {18'b0, ubaBUS.busDATAI[ 0:17]};      // Even word
                  3'b001: loopDATA <= {18'b0, ubaBUS.busDATAI[ 0:17]};      // Even word
                  3'b010: loopDATA <= {18'b0, ubaBUS.busDATAI[18:35]};      // Odd  word
                  3'b011: loopDATA <= {18'b0, ubaBUS.busDATAI[18:35]};      // Odd  word
                  3'b100: loopDATA <= {28'b0, ubaBUS.busDATAI[10:17]};      // Even word, low  byte.
                  3'b101: loopDATA <= {20'b0, ubaBUS.busDATAI[ 2: 9], 8'b0};// Even word, high byte.
                  3'b110: loopDATA <= {28'b0, ubaBUS.busDATAI[28:35]};      // Odd  word, low  byte.
                  3'b111: loopDATA <= {20'b0, ubaBUS.busDATAI[20:27], 8'b0};// Odd  word, high byte.
                endcase
                state <= stateMEMtoLOOP2;
             end
           else if (cntTMO != 0)
             cntTMO <= cntTMO - 1'b1;
           else
             begin
                ubaBUS.busREQO <= 0;
                state <= stateDONE;
             end

         //
         // Finally acknowlege the IO request that started this all.
         //  Return the loopDATA from the NPR that was performed.
         //

         stateMEMtoLOOP2:
           begin
              ubaBUS.busACKO  <= 1;
              ubaBUS.busDATAO <= loopDATA;
              state <= stateMEMtoLOOP3;
           end

         //
         // Negate the bus acknowlege.  All done.
         //

         stateMEMtoLOOP3:
           begin
              if (!ubaBUS.busREQI)
                begin
                   ubaBUS.busACKO <= 0;
                   state   <= stateDONE;
                end
           end

         //
         // Wait for register access to complete
         //

         stateWAITREG:
           if ((!ubaBUS.busREQI | !devREAD) & (!ubaBUS.busREQI | !devWRITE))
             begin
                ubaBUS.busREQO <= 0;
                ubaBUS.busACKO <= 0;
                devREQO[1]  <= 0;
                devREQO[2]  <= 0;
                devREQO[3]  <= 0;
                devREQO[4]  <= 0;
                devACKO[1]  <= 0;
                devACKO[2]  <= 0;
                devACKO[3]  <= 0;
                devACKO[4]  <= 0;
                devADDRO[1] <= 0;
                devADDRO[2] <= 0;
                devADDRO[3] <= 0;
                devADDRO[4] <= 0;
                devDATAO[1] <= 0;
                devDATAO[2] <= 0;
                devDATAO[3] <= 0;
                devDATAO[4] <= 0;
                devSEL      <= 0;
                state       <= stateIDLE;
             end

         //
         // Wait for bus request to negate
         //

         stateWAITBUSREQ:
           if (!ubaBUS.busREQI)
             begin
                ubaBUS.busREQO <= 0;
                ubaBUS.busACKO <= 0;
                devREQO[1]  <= 0;
                devREQO[2]  <= 0;
                devREQO[3]  <= 0;
                devREQO[4]  <= 0;
                devACKO[1]  <= 0;
                devACKO[2]  <= 0;
                devACKO[3]  <= 0;
                devACKO[4]  <= 0;
                devADDRO[1] <= 0;
                devADDRO[2] <= 0;
                devADDRO[3] <= 0;
                devADDRO[4] <= 0;
                devDATAO[1] <= 0;
                devDATAO[2] <= 0;
                devDATAO[3] <= 0;
                devDATAO[4] <= 0;
                devSEL      <= 0;
                state       <= stateIDLE;
             end

         //
         // Wait for device request to negate
         //

         stateWAITDEVREQ:
           if (!devREQI[devSEL])
             begin
                ubaBUS.busREQO <= 0;
                ubaBUS.busACKO <= 0;
                devREQO[1]  <= 0;
                devREQO[2]  <= 0;
                devREQO[3]  <= 0;
                devREQO[4]  <= 0;
                devACKO[1]  <= 0;
                devACKO[2]  <= 0;
                devACKO[3]  <= 0;
                devACKO[4]  <= 0;
                devADDRO[1] <= 0;
                devADDRO[2] <= 0;
                devADDRO[3] <= 0;
                devADDRO[4] <= 0;
                devDATAO[1] <= 0;
                devDATAO[2] <= 0;
                devDATAO[3] <= 0;
                devDATAO[4] <= 0;
                devSEL      <= 0;
                state       <= stateIDLE;
             end

         //
         // Wait for vector request to negate
         //

         stateWAITVECREQ:
           if (!(ubaBUS.busREQI & vectREAD))
             begin
                ubaBUS.busREQO <= 0;
                ubaBUS.busACKO <= 0;
                devREQO[1]  <= 0;
                devREQO[2]  <= 0;
                devREQO[3]  <= 0;
                devREQO[4]  <= 0;
                devACKO[1]  <= 0;
                devACKO[2]  <= 0;
                devACKO[3]  <= 0;
                devACKO[4]  <= 0;
                devADDRO[1] <= 0;
                devADDRO[2] <= 0;
                devADDRO[3] <= 0;
                devADDRO[4] <= 0;
                devDATAO[1] <= 0;
                devDATAO[2] <= 0;
                devDATAO[3] <= 0;
                devDATAO[4] <= 0;
                devSEL      <= 0;
                state       <= stateIDLE;
             end

         //
         // Done
         //  Negate all requests
         //

         stateDONE:
           begin
              ubaBUS.busREQO <= 0;
              ubaBUS.busACKO <= 0;
              devREQO[1]  <= 0;
              devREQO[2]  <= 0;
              devREQO[3]  <= 0;
              devREQO[4]  <= 0;
              devACKO[1]  <= 0;
              devACKO[2]  <= 0;
              devACKO[3]  <= 0;
              devACKO[4]  <= 0;
              devADDRO[1] <= 0;
              devADDRO[2] <= 0;
              devADDRO[3] <= 0;
              devADDRO[4] <= 0;
              devDATAO[1] <= 0;
              devDATAO[2] <= 0;
              devDATAO[3] <= 0;
              devDATAO[4] <= 0;
              devSEL      <= 0;
              state       <= stateIDLE;
           end
       endcase

   assign devRESET = statINI;
   assign setNXD   = (cntNXD == 1);
   assign setTMO   = (cntTMO == 1);

`ifndef SYNTHESIS

   //
   // Whine about NXD and TMO
   //

   integer file;

   initial
     begin
        case (ubaNUM)
          1: file = $fopen("uba1status.txt", "w");
          2: file = $fopen("uba2status.txt", "w");
          3: file = $fopen("uba3status.txt", "w");
          4: file = $fopen("uba4status.txt", "w");
        endcase
        $fwrite(file, "[%11.3f] UBA%d: Initialized.\n", $time/1.0e3, ubaNUM);
        $fflush(file);
     end

   reg [0:35] addr;

   always_ff @(posedge clk)
     begin
        if (rst)
          addr <= 0;
        else
          begin

             if (busREQI)
               addr <= busADDRI;

             if (ubaBUS.busREQO)
               addr <= pageADDRI;

             if (setNXD)
               $fwrite(file, "[%11.3f] UBA%d: Nonexistent device (NXD). Addr = %012o.\n",
                       $time/1.0e3, ubaNUM, addr);

             if (setTMO)
               $fwrite(file, "[%11.3f] UBA%d: Nonexistent memory (TMO). Addr = %012o.\n",
                       $time/1.0e3, ubaNUM, addr);

             if (pageFAIL)
               $fwrite(file, "[%11.3f] UBA%d: Page Failure (TMO). Addr = %012o.\n",
                       $time/1.0e3, ubaNUM, addr);

             if (busACKI)
               begin
                  if (`busREAD(ubaBUS.busADDRO))
                    $fwrite(file, "[%11.3f] UBA%d: Read %012o from address %012o.\n",
                            $time/1.0e3, ubaNUM, busDATAI, ubaBUS.busADDRO);
                  else
                    $fwrite(file, "[%11.3f] UBA%d: Wrote %012o to address %012o.\n",
                            $time/1.0e3, ubaNUM, ubaBUS.busDATAO, ubaBUS.busADDRO);
               end

          end
     end

`endif

endmodule
