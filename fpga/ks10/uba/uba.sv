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
      // KS10 Backplane Bus Interface
      input  wire          busREQI,                     // Backplane Bus Request In
      output logic         busREQO,                     // Backplane Bus Request Out
      input  wire          busACKI,                     // Backplane Bus Acknowledge In
      output logic         busACKO,                     // Backplane Bus Acknowledge Out
      input  wire  [ 0:35] busADDRI,                    // Backplane Bus Address In
      output logic [ 0:35] busADDRO,                    // Backplane Bus Address Out
      input  wire  [ 0:35] busDATAI,                    // Backplane Bus Data In
      output logic [ 0:35] busDATAO,                    // Backplane Bus Data Out
      output logic [ 1: 7] busINTR,                     // Backplane Bus Interrupt Request
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
   // IO Bridge Configuration
   //

   parameter  [14:17] ubaNUM   = 4'd0;                  // Bridge Device Number
   parameter  [18:35] ubaADDR  = `ubaADDR;              // Base address
   localparam [18:35] pageADDR = ubaADDR + `pageOFFSET; // Paging RAM Address
   localparam [18:35] statADDR = ubaADDR + `statOFFSET; // Status Register Address
   localparam [18:35] maintADDR= ubaADDR + `maintOFFSET;// Maintenance Register Address
   localparam [ 0:35] wruRESP  = `getWRU(ubaNUM);       // Lookup WRU Response

   //
   // KS10 Address Bus
   //
   // Details:
   //  busADDRI[ 0:13] is flags
   //  busADDRI[14:35] is address
   //

   wire          busREAD   = `busREAD(busADDRI);        // Read Cycle (IO or Memory)
   wire          busWRITE  = `busWRITE(busADDRI);       // Write Cycle (IO or Memory)
   wire          busPHYS   = `busPHYS(busADDRI);        // Physical reference
   wire          busIO     = `busIO(busADDRI);          // IO Cycle
   wire          busWRU    = `busWRU(busADDRI);         // Read interrupting controller number
   wire          busVECT   = `busVECT(busADDRI);        // Read interrupt vector
   wire          busIOBYTE = `busIOBYTE(busADDRI);      // IO Byte Cycle
   wire  [15:17] busPI     = `busPI(busADDRI);          // IO Bridge PI Request
   wire  [14:17] busDEV    = `busDEV(busADDRI);         // IO Bridge Device Number
   wire  [18:35] busADDR   = `busIOADDR(busADDRI);      // IO Address

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
   wire          flagsRPW = `flagsRPW(pageFLAGS);       // Page read/pause/write
   wire          flagsE16 = `flagsE16(pageFLAGS);       // Page E16
   wire          flagsFTM = `flagsFTM(pageFLAGS);       // Page fast transfer mode
   wire          flagsVLD = `flagsVLD(pageFLAGS);       // Page valid

   //
   // Address Decoding
   //

   wire wruREAD    = busREAD  & busIO & busPHYS &  busWRU & !busVECT;
   wire vectREAD   = busREAD  & busIO & busPHYS & !busWRU &  busVECT & (busDEV == ubaNUM);
   wire pageREAD   = busREAD  & busIO & busPHYS & !busWRU & !busVECT & (busDEV == ubaNUM) & (busADDR[18:29] == pageADDR[18:29]);
   wire pageWRITE  = busWRITE & busIO & busPHYS & !busWRU & !busVECT & (busDEV == ubaNUM) & (busADDR[18:29] == pageADDR[18:29]);
   wire statREAD   = busREAD  & busIO & busPHYS & !busWRU & !busVECT & (busDEV == ubaNUM) & (busADDR[18:35] == statADDR[18:35]);
   wire statWRITE  = busWRITE & busIO & busPHYS & !busWRU & !busVECT & (busDEV == ubaNUM) & (busADDR[18:35] == statADDR[18:35]);
   wire maintWRITE = busWRITE & busIO & busPHYS & !busWRU & !busVECT & (busDEV == ubaNUM) & (busADDR[18:35] == maintADDR[18:35]);
   wire devREAD    = busREAD  & busIO & busPHYS & !busWRU & !busVECT & (busDEV == ubaNUM) & (busADDR[18:28] != ubaADDR[18:28]) & !regUBAMR;
   wire devWRITE   = busWRITE & busIO & busPHYS & !busWRU & !busVECT & (busDEV == ubaNUM) & (busADDR[18:28] != ubaADDR[18:28]) & !regUBAMR;
   wire loopREAD   = busREAD  & busIO & busPHYS & !busWRU & !busVECT & (busDEV == ubaNUM) & (busADDR[18:28] != ubaADDR[18:28]) &  regUBAMR;
   wire loopWRITE  = busWRITE & busIO & busPHYS & !busWRU & !busVECT & (busDEV == ubaNUM) & (busADDR[18:28] != ubaADDR[18:28]) &  regUBAMR;

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
      .busDATAI   (busDATAI),
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
      .busDATAI   (busDATAI),
      .maintWRITE (maintWRITE),
      .regUBAMR   (regUBAMR)
   );

`ifdef LOOPBACK

   //
   // Loopback testing
   //

   logic [ 0:35] loopDATA;
   logic [ 0:35] loopADDR;

   always_ff @(posedge clk)
     begin
        if (rst)
          begin
             loopDATA <= 0;
             loopADDR <= 0;
          end
        else if (loopWRITE)
          begin
             loopDATA <= busDATAI;
             loopADDR <= busADDRI;
          end
     end

   wire ewlb = `busIO(loopADDR) &  `busIOBYTE(loopADDR) & !loopADDR[34] & !loopADDR[35];        // Even word, low  byte.
   wire ewhb = `busIO(loopADDR) &  `busIOBYTE(loopADDR) & !loopADDR[34] &  loopADDR[35];        // Even word, high byte.
   wire owlb = `busIO(loopADDR) &  `busIOBYTE(loopADDR) &  loopADDR[34] & !loopADDR[35];        // Odd  word, low byte.
   wire owhb = `busIO(loopADDR) &  `busIOBYTE(loopADDR) &  loopADDR[34] &  loopADDR[35];        // Odd  word, high byte.
   wire ew   = `busIO(loopADDR) & !`busIOBYTE(loopADDR) & !loopADDR[34] & !loopADDR[35];        // Even word
   wire ow   = `busIO(loopADDR) & !`busIOBYTE(loopADDR) &  loopADDR[34] & !loopADDR[35];        // Odd  word

`endif

   //
   // Interrupts
   //

   UBAINTR INTR (
      .rst        (rst),
      .clk        (clk),
      .busPI      (busPI),
      .busINTR    (busINTR),
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
      .busADDRI   (busADDRI),
      .busDATAI   (busDATAI),
      .busADDRO   (busADDRO),
      .pageWRITE  (pageWRITE),
      .pageDATAO  (pageDATAO),
      .pageADDRI  (pageADDRI),
      .pageFLAGS  (pageFLAGS),
      .pageFAIL   (pageFAIL)
   );

   //
   // Device arbiter
   //

   localparam [0:3] stateIDLE       = 0,                // IDLE
                    stateCPUtoDEV   = 1,                // Request from CPU to Device
                    stateCPUtoVEC   = 2,                // Request from CPU to Interrupt Vector
                    stateDEVtoMEM0  = 3,                // Request from Device to Memory
                    stateDEVtoMEM1  = 4,                // Request from Device to Memory
                    stateDEVtoIO    = 5,                // Request from Device to IO
                    stateWAITREG    = 6,                // Wait for register to complete
                    stateWAITBUSREQ = 7,                // Wait for bus request to complete
                    stateWAITDEVREQ = 8,                // Wait for device request to complete
                    stateDONE       = 9;                // Done

   localparam [ 0: 3] timeout = 4'd8;
   logic      [ 0: 2] devSEL;                           // Device select
   logic      [ 0: 3] cntTMO;                           // Timeout timer
   logic      [ 0: 3] cntNXD;                           // Timeout timer
   logic      [ 0: 3] state;                            // State variable

   always_ff @(posedge clk)
     begin
        if (rst)
          begin
             busREQO     <= 0;
             busACKO     <= 0;
             busDATAO    <= 0;
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
             devSEL      <= 0;
             cntNXD      <= 0;
             cntTMO      <= 0;
             state       <= stateIDLE;
          end
        else
          case (state)
            stateIDLE:
              begin

                 //
                 // CPU is accessing status register
                 //

                 if ((busREQI & statREAD) | (busREQI & statWRITE))
                   begin
                      busACKO  <= 1;
                      busDATAO <= regUBASR;
                      state    <= stateWAITBUSREQ;
                   end

                 //
                 // CPU is accessing paging data
                 //

                 else if ((busREQI & pageREAD) | (busREQI & pageWRITE))
                   begin
                      busACKO  <= 1;
                      busDATAO <= pageDATAO;
                      state    <= stateWAITBUSREQ;
                   end

                 //
                 // CPU is accessing the maintenance register
                 //

                 else if (busREQI & maintWRITE)
                   begin
                      busACKO  <= 1;
                      state    <= stateWAITBUSREQ;
                   end

                 //
                 // CPU is doing a WRU bus cycle
                 //

                 else if (busREQI & wruREAD & ((busPI == statPIH) | (busPI == statPIL)))
                   begin
                      busACKO  <= 1;
                      busDATAO <= wruRESP;
                      state    <= stateWAITBUSREQ;
                   end

                 //
                 // CPU is requesting data from an IO device
                 //

                 else if ((busREQI & devREAD) | (busREQI & devWRITE))
                   begin
                      devREQO[1]  <= 1;
                      devREQO[2]  <= 1;
                      devREQO[3]  <= 1;
                      devREQO[4]  <= 1;
                      devADDRO[1] <= busADDRI;
                      devADDRO[2] <= busADDRI;
                      devADDRO[3] <= busADDRI;
                      devADDRO[4] <= busADDRI;
                      devDATAO[1] <= busDATAI;
                      devDATAO[2] <= busDATAI;
                      devDATAO[3] <= busDATAI;
                      devDATAO[4] <= busDATAI;
                      cntNXD      <= timeout;
                      state       <= stateCPUtoDEV;
                   end

                 //
                 // CPU is requesting a vector from an IO device
                 //

                 if (busREQI & vectREAD)
                   begin
                      devREQO[1]  <= 1;
                      devREQO[2]  <= 1;
                      devREQO[3]  <= 1;
                      devREQO[4]  <= 1;
                      devADDRO[1] <= busADDRI;
                      devADDRO[2] <= busADDRI;
                      devADDRO[3] <= busADDRI;
                      devADDRO[4] <= busADDRI;
                      devDATAO[1] <= busDATAI;
                      devDATAO[2] <= busDATAI;
                      devDATAO[3] <= busDATAI;
                      devDATAO[4] <= busDATAI;
                      cntNXD      <= timeout;
                      state       <= stateCPUtoVEC;
                   end

                 //
                 // Device 1 is requesting IO or memory
                 //

                 else if (devREQI[1])
                   begin
                      devSEL <= 3'd1;

                      //
                      // Device 1 is requesting IO
                      //

                      if (`busIO(devADDRI[1]))
                        begin
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
                           busDATAO  <= devDATAI[1];
                           pageADDRI <= devADDRI[1];
                           cntTMO    <= timeout;
                           state     <= stateDEVtoMEM0;
                        end
                   end

                 //
                 // Device 2 is requesting IO or memory
                 //

                 else if (devREQI[2])
                   begin
                      devSEL <= 3'd2;

                      //
                      // Device 2 is requesting IO
                      //

                      if (`busIO(devADDRI[2]))
                        begin
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
                           busDATAO  <= devDATAI[2];
                           pageADDRI <= devADDRI[2];
                           cntTMO    <= timeout;
                           state     <= stateDEVtoMEM0;
                        end
                   end

                 //
                 // Device 3 is requesting IO or memory
                 //

                 else if (devREQI[3])
                   begin
                      devSEL <= 3'd3;

                      //
                      // Device 3 is requesting IO
                      //

                      if (`busIO(devADDRI[3]))
                        begin
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
                           busDATAO  <= devDATAI[3];
                           pageADDRI <= devADDRI[3];
                           cntTMO    <= timeout;
                           state     <= stateDEVtoMEM0;
                        end
                   end

                 //
                 // Device 4 is requesting IO or memory
                 //

                 else if (devREQI[4])
                   begin
                      devSEL <= 3'd4;

                      //
                      // Device 4 is requesting IO
                      //

                      if (`busIO(devADDRI[4]))
                        begin
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
                           busDATAO  <= devDATAI[4];
                           pageADDRI <= devADDRI[4];
                           cntTMO    <= timeout;
                           state     <= stateDEVtoMEM0;
                        end
                   end
              end

            //
            // CPU is requesting data from an IO device
            //

            stateCPUtoDEV:
              begin
                 if (devACKI[1])
                   begin
                      busACKO    <= 1;
                      devREQO[1] <= 0;
                      devREQO[2] <= 0;
                      devREQO[3] <= 0;
                      devREQO[4] <= 0;
                      busDATAO   <= devDATAI[1];
                      state      <= stateWAITBUSREQ;
                   end
                 else if (devACKI[2])
                   begin
                      busACKO    <= 1;
                      devREQO[1] <= 0;
                      devREQO[2] <= 0;
                      devREQO[3] <= 0;
                      devREQO[4] <= 0;
                      busDATAO   <= devDATAI[2];
                      state      <= stateWAITBUSREQ;
                   end
                 else if (devACKI[3])
                   begin
                      busACKO    <= 1;
                      devREQO[1] <= 0;
                      devREQO[2] <= 0;
                      devREQO[3] <= 0;
                      devREQO[4] <= 0;
                      busDATAO   <= devDATAI[3];
                      state      <= stateWAITBUSREQ;
                   end
                 else if (devACKI[4])
                   begin
                      busACKO    <= 1;
                      devREQO[1] <= 0;
                      devREQO[2] <= 0;
                      devREQO[3] <= 0;
                      devREQO[4] <= 0;
                      busDATAO   <= devDATAI[4];
                      state      <= stateWAITBUSREQ;
                   end
                 else if (!busREQI)
                   begin
                      state <= stateDONE;
                   end
                 else if (cntNXD != 0)
                   begin
                      cntNXD <= cntNXD - 1'b1;
                   end
                 else
                   begin
                      state <= stateWAITBUSREQ;
                   end
              end

            //
            // CPU is requesting a Interrupt Vector
            //

            stateCPUtoVEC:
              begin

                 //
                 // INTR 7 vector arbitration (Highest Priority)
                 //

                 if (devACKI[1] & devINTR[1][7])
                   begin
                      busACKO    <= 1;
                      devREQO[1] <= 0;
                      devREQO[2] <= 0;
                      devREQO[3] <= 0;
                      devREQO[4] <= 0;
                      busDATAO   <= devDATAI[1];
                      state      <= stateWAITBUSREQ;
                   end
                 else if (devACKI[2] & devINTR[2][7])
                   begin
                      busACKO    <= 1;
                      devREQO[1] <= 0;
                      devREQO[2] <= 0;
                      devREQO[3] <= 0;
                      devREQO[4] <= 0;
                      busDATAO   <= devDATAI[2];
                      state      <= stateWAITBUSREQ;
                   end
                 else if (devACKI[3] & devINTR[3][7])
                   begin
                      busACKO    <= 1;
                      devREQO[1] <= 0;
                      devREQO[2] <= 0;
                      devREQO[3] <= 0;
                      devREQO[4] <= 0;
                      busDATAO   <= devDATAI[3];
                      state      <= stateWAITBUSREQ;
                   end
                 else if (devACKI[4] & devINTR[4][7])
                   begin
                      busACKO    <= 1;
                      devREQO[1] <= 0;
                      devREQO[2] <= 0;
                      devREQO[3] <= 0;
                      devREQO[4] <= 0;
                      busDATAO   <= devDATAI[4];
                      state      <= stateWAITBUSREQ;
                   end

                 //
                 // INTR 6 vector arbitration
                 //

                 else if (devACKI[1] & devINTR[1][6])
                   begin
                      busACKO    <= 1;
                      devREQO[1] <= 0;
                      devREQO[2] <= 0;
                      devREQO[3] <= 0;
                      devREQO[4] <= 0;
                      busDATAO   <= devDATAI[1];
                      state      <= stateWAITBUSREQ;
                   end
                 else if (devACKI[2] & devINTR[2][6])
                   begin
                      busACKO    <= 1;
                      devREQO[1] <= 0;
                      devREQO[2] <= 0;
                      devREQO[3] <= 0;
                      devREQO[4] <= 0;
                      busDATAO   <= devDATAI[2];
                      state      <= stateWAITBUSREQ;
                   end
                 else if (devACKI[3] & devINTR[3][6])
                   begin
                      busACKO    <= 1;
                      devREQO[1] <= 0;
                      devREQO[2] <= 0;
                      devREQO[3] <= 0;
                      devREQO[4] <= 0;
                      busDATAO   <= devDATAI[3];
                      state      <= stateWAITBUSREQ;
                   end
                 else if (devACKI[4] & devINTR[4][6])
                   begin
                      busACKO    <= 1;
                      devREQO[1] <= 0;
                      devREQO[2] <= 0;
                      devREQO[3] <= 0;
                      devREQO[4] <= 0;
                      busDATAO   <= devDATAI[4];
                      state      <= stateWAITBUSREQ;
                   end

                 //
                 // INTR 5 vector arbitration
                 //

                 else if (devACKI[1] & devINTR[1][5])
                   begin
                      busACKO    <= 1;
                      devREQO[1] <= 0;
                      devREQO[2] <= 0;
                      devREQO[3] <= 0;
                      devREQO[4] <= 0;
                      busDATAO   <= devDATAI[1];
                      state      <= stateWAITBUSREQ;
                   end
                 else if (devACKI[2] & devINTR[2][5])
                   begin
                      busACKO    <= 1;
                      devREQO[1] <= 0;
                      devREQO[2] <= 0;
                      devREQO[3] <= 0;
                      devREQO[4] <= 0;
                      busDATAO   <= devDATAI[2];
                      state      <= stateWAITBUSREQ;
                   end
                 else if (devACKI[3] & devINTR[3][5])
                   begin
                      busACKO    <= 1;
                      devREQO[1] <= 0;
                      devREQO[2] <= 0;
                      devREQO[3] <= 0;
                      devREQO[4] <= 0;
                      busDATAO   <= devDATAI[3];
                      state      <= stateWAITBUSREQ;
                   end
                 else if (devACKI[4] & devINTR[4][5])
                   begin
                      busACKO    <= 1;
                      devREQO[1] <= 0;
                      devREQO[2] <= 0;
                      devREQO[3] <= 0;
                      devREQO[4] <= 0;
                      busDATAO   <= devDATAI[4];
                      state      <= stateWAITBUSREQ;
                   end

                 //
                 // INTR 4 vector arbitration (Lowest prioity)
                 //

                 else if (devACKI[1] & devINTR[1][4])
                   begin
                      busACKO    <= 1;
                      devREQO[1] <= 0;
                      devREQO[2] <= 0;
                      devREQO[3] <= 0;
                      devREQO[4] <= 0;
                      busDATAO   <= devDATAI[1];
                      state      <= stateWAITBUSREQ;
                   end
                 else if (devACKI[2] & devINTR[2][4])
                   begin
                      busACKO    <= 1;
                      devREQO[1] <= 0;
                      devREQO[2] <= 0;
                      devREQO[3] <= 0;
                      devREQO[4] <= 0;
                      busDATAO   <= devDATAI[2];
                      state      <= stateWAITBUSREQ;
                   end
                 else if (devACKI[3] & devINTR[3][4])
                   begin
                      busACKO    <= 1;
                      devREQO[1] <= 0;
                      devREQO[2] <= 0;
                      devREQO[3] <= 0;
                      devREQO[4] <= 0;
                      busDATAO   <= devDATAI[3];
                      state      <= stateWAITBUSREQ;
                   end
                 else if (devACKI[4] & devINTR[4][4])
                   begin
                      busACKO    <= 1;
                      devREQO[1] <= 0;
                      devREQO[2] <= 0;
                      devREQO[3] <= 0;
                      devREQO[4] <= 0;
                      busDATAO   <= devDATAI[4];
                      state      <= stateWAITBUSREQ;
                   end

              end

            //
            // Device is requesting access to memory
            //  Address and Data are routed to CPU.
            //  Wait a clock cycle to check for a UBA Page Fail
            //

            stateDEVtoMEM0:
              begin
                 if (pageFAIL)
                   state <= stateDONE;
                 else
                   begin
                      busREQO <= 1;
                      state   <= stateDEVtoMEM1;
                   end
              end

            //
            // Device is requesting access to memory.
            //  Wait for memory to respond
            //

            stateDEVtoMEM1:
              begin
                 if (busACKI)
                   begin
                      busREQO         <= 0;
                      devACKO[devSEL] <= 1;
                      devDATAO[1]     <= busDATAI;
                      devDATAO[2]     <= busDATAI;
                      devDATAO[3]     <= busDATAI;
                      devDATAO[4]     <= busDATAI;
                      state           <= stateWAITDEVREQ;
                   end
                 else if (!devREQI[devSEL])
                   begin
                      busREQO <= 0;
                      state   <= stateDONE;
                   end
                 else if (cntTMO != 0)
                   begin
                      cntTMO <= cntTMO - 1'b1;
                   end
                 else
                   begin
                      busREQO <= 0;
                      state   <= stateDONE;
                   end
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
                   begin
                      state <= stateDONE;
                   end
              end

            //
            // Wait for register access to complete
            //

            stateWAITREG:
              begin
                 if ((!busREQI | !devREAD) & (!busREQI | !devWRITE))
                   begin
                      busREQO     <= 0;
                      busACKO     <= 0;
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
              end

            //
            // Wait for bus request to negate
            //

            stateWAITBUSREQ:
              begin
                 if (!busREQI)
                   begin
                      busREQO     <= 0;
                      busACKO     <= 0;
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
              end

            //
            // Wait for device request to negate
            //

            stateWAITDEVREQ:
              begin
                 if (!devREQI[devSEL])
                   begin
                      busREQO     <= 0;
                      busACKO     <= 0;
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
              end

            //
            // Done
            //  Negate all requests
            //

             stateDONE:
              begin
                 busREQO     <= 0;
                 busACKO     <= 0;
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
     end

   assign devRESET = statINI;
   assign setNXD   = (cntNXD == 1);
   assign setTMO   = (cntTMO == 1);

   //
   // Whine about NXD and TMO
   //

`ifndef SYNTHESIS

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

             if (busREQO)
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
                  if (`busREAD(busADDRO))
                    $fwrite(file, "[%11.3f] UBA%d: Read %012o from address %012o.\n",
                            $time/1.0e3, ubaNUM, busDATAI, busADDRO);
                  else
                    $fwrite(file, "[%11.3f] UBA%d: Wrote %012o to address %012o.\n",
                            $time/1.0e3, ubaNUM, busDATAO, busADDRO);
               end

          end
     end

`endif

endmodule
