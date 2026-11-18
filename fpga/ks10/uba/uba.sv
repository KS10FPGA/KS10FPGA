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
`include "ubabus.vh"
`include "../cpu/bus.vh"

module UBA (
      input wire           rst,                         // Reset
      input wire           clk,                         // Clock
      ks10bus.device       ks10bus,                     // Backplane Bus
      unibus.uba           unibus[1:5]                  // Unibus
   );

   //
   // Unibus Interface
   //

   logic         devRESET;                              // Reset
   logic         devACLO[1:5];                          // Power fail
   logic [ 7: 4] devINTRI[1:5];                         // Interrupt in
   logic         devREQI[1:5];                          // Request in
   logic         devACKO[1:5];                          // Acknowledge out
   logic [ 0:35] devADDRI[1:5];                         // Address in
   logic [ 0:35] devDATAI[1:5];                         // Data in
   logic         devREQO[1:5];                          // Request out
   logic         devACKI[1:5];                          // Acknowledge in
   logic [ 0:35] devADDRO[1:5];                         // Address out
   logic [ 0:35] devDATAO[1:5];                         // Data out

   //
   // KS10 Backplane Bus Interface
   //

   logic [ 0:35] busADDRO;                              // Bus address out
   assign busADDRO = ks10bus.busADDRO;

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
   localparam [18:35] pageADDR  = ubaADDR +`pageOFFSET; // Paging RAM Address
   localparam [18:35] statADDR  = ubaADDR +`statOFFSET; // Status Register Address
   localparam [18:35] maintADDR = ubaADDR +`maintOFFSET;// Maintenance Register Address
   localparam [ 0:35] wruRESP   = `getWRU(ubaNUM);      // Lookup WRU Response

   //
   // KS10 Address Bus
   //
   // Details:
   //  busADDRI[ 0:13] is flags
   //  busADDRI[14:35] is address
   //

   wire         busREAD   = `busREAD(ks10bus.busADDRI);  // Read Cycle (IO or Memory)
   wire         busWRITE  = `busWRITE(ks10bus.busADDRI); // Write Cycle (IO or Memory)
   wire         busPHYS   = `busPHYS(ks10bus.busADDRI);  // Physical reference
   wire         busIO     = `busIO(ks10bus.busADDRI);    // IO Cycle
   wire         busWRU    = `busWRU(ks10bus.busADDRI);   // Read interrupting controller number
   wire         busVECT   = `busVECT(ks10bus.busADDRI);  // Read interrupt vector
   wire [15:17] busPI     = `busPI(ks10bus.busADDRI);    // IO Bridge PI Request
   wire [14:17] busDEV    = `busDEV(ks10bus.busADDRI);   // IO Bridge Device Number
   wire [18:35] busADDR   = `busIOADDR(ks10bus.busADDRI);// IO Address

   //
   // Signals
   //

   logic        regUBAMR;                               // Maintenance Mode
   logic        setNXD;                                 // Set NXD
   logic        setTMO;                                 // Set TMO
   logic        pageFAIL;                               // Page failure
   logic        pageCHECK;                              // Page fail is checked this state

   //
   // Device request on any device input
   //

   wire         devREQ   = devREQI[1] | devREQI[2] | devREQI[3] | devREQI[4];

   //
   // Paging flags
   //

   logic [0: 3] pageFLAGS;                              // Page flags
   wire         flagsRRV = `flagsRRV(pageFLAGS);        // Page uses Read Reverse Mode
   wire         flagsE16 = `flagsE16(pageFLAGS);        // Page uses 16-bit transfers
   wire         flagsFTM = `flagsFTM(pageFLAGS);        // Page uses Fast Transfer Mode
// wire         flagsVLD = `flagsVLD(pageFLAGS);        // Page valid

   //
   // Read/Write Decoding
   //

   wire wruREAD  = ks10bus.busREQI & busREAD  & busIO & busPHYS &  busWRU & !busVECT;
   wire vectREAD = ks10bus.busREQI & busREAD  & busIO & busPHYS & !busWRU &  busVECT & (busDEV == ubaNUM);
   wire ubaREAD  = ks10bus.busREQI & busREAD  & busIO & busPHYS & !busWRU & !busVECT & (busDEV == ubaNUM);
   wire ubaWRITE = ks10bus.busREQI & busWRITE & busIO & busPHYS & !busWRU & !busVECT & (busDEV == ubaNUM);

   //
   // Address Decoding
   //

   wire pageREAD   = ubaREAD  & (busADDR[18:29] == pageADDR [18:29]);
   wire pageWRITE  = ubaWRITE & (busADDR[18:29] == pageADDR [18:29]);
   wire statREAD   = ubaREAD  & (busADDR[18:35] == statADDR [18:35]);
   wire statWRITE  = ubaWRITE & (busADDR[18:35] == statADDR [18:35]);
   wire maintWRITE = ubaWRITE & (busADDR[18:35] == maintADDR[18:35]);
   wire vdbgREAD   = ubaREAD  & (busADDR[18:35] >= (ubaADDR + 18'o110)) &
                                (busADDR[18:35] <= (ubaADDR + 18'o113));  // Vector debug (763110-763113)
   wire devREAD    = ubaREAD  & (busADDR[18:28] != ubaADDR  [18:28]) & !regUBAMR;
   wire devWRITE   = ubaWRITE & (busADDR[18:28] != ubaADDR  [18:28]) & !regUBAMR;
   wire loopREAD   = ubaREAD  & (busADDR[18:28] != ubaADDR  [18:28]) &  regUBAMR;
   wire loopWRITE  = ubaWRITE & (busADDR[18:28] != ubaADDR  [18:28]) &  regUBAMR;

   //
   // Status Register
   //
   //  The status register is read/write.
   //

   logic [ 0:35] regUBASR;
   wire          statINI = `statINI(regUBASR);
   wire  [ 0: 2] statPIH = `statPIH(regUBASR);
   wire  [ 0: 2] statPIL = `statPIL(regUBASR);
   wire          statHI  = `statHI(regUBASR);
   wire          statLO  = `statLO(regUBASR);

   //
   // WRU response
   //  Only respond to a WRU cycle when this bridge has an interrupt pending
   //  at the PI level being serviced, like the DEC UBA.  Answering whenever
   //  the level matched PIH or PIL let UBA1 claim an interrupt that belonged
   //  to UBA3 (both use the same levels), and the vector cycle then found no
   //  device on UBA1 ("Illegal Interrupt Instruction" halt).
   //

   wire wruHIT = (statHI & (busPI == statPIH)) | (statLO & (busPI == statPIL));

   UBASR SR (
      .rst        (rst),
      .clk        (clk),
      .busDATAI   (ks10bus.busDATAI),
      .devACLO    (devACLO),
      .devINTR    (devINTRI),
      .statWRITE  (statWRITE),
      .setNXD     (setNXD),
      .setTMO     (setTMO | (pageFAIL & pageCHECK)),
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
      .busDATAI   (ks10bus.busDATAI),
      .maintWRITE (maintWRITE),
      .regUBAMR   (regUBAMR)
   );

   //
   // Interrupts
   //

   UBAINTR INTR (
      .rst        (rst),
      .clk        (clk),
      .busINTR    (ks10bus.busINTRO),
      .wruREAD    (wruREAD),
      .regUBASR   (regUBASR),
      .devINTR    (devINTRI)
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
      .busADDRI   (ks10bus.busADDRI),
      .busDATAI   (ks10bus.busDATAI),
      .busADDRO   (ks10bus.busADDRO),
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

   //
   // Simulation only: SIM_VECDROP=n makes UBA3 ignore its n'th interrupt
   // vector request (and every 64th one after it) for 80 clocks, so the
   // CPU's vector cycle times out.  Used to see how the CPU handles a
   // vector cycle that nobody answers.
   //

`ifdef SIM_VECDROP
`ifndef SIM_VECDROPLEN
`define SIM_VECDROPLEN 80
`endif
   integer vdCOUNT = 0;
   integer vdHOLD  = 0;
   logic   vdLAST  = 0;
   wire    vdNEW   = ks10bus.busREQI & vectREAD & !vdLAST & (ubaNUM == 3);
   wire    vdHIT   = vdNEW & (vdCOUNT >= `SIM_VECDROP) & (((vdCOUNT - `SIM_VECDROP) % 64) == 0);
   wire    simVECDROP = vdHIT | (vdHOLD != 0);
   always @(posedge clk)
     begin
        vdLAST <= ks10bus.busREQI & vectREAD;
        if (vdHOLD != 0)
          vdHOLD <= vdHOLD - 1;
        else if (vdNEW)
          begin
             vdCOUNT <= vdCOUNT + 1;
             if (vdHIT)
               begin
                  vdHOLD <= `SIM_VECDROPLEN;
                  $display("[%11.3f] VECDROP: UBA%0d ignoring vector request #%0d (addr %012o) for %0d clocks",
                           $time/1.0e3, ubaNUM, vdCOUNT, ks10bus.busADDRI, `SIM_VECDROPLEN);
               end
          end
     end
`else
   wire    simVECDROP = 0;
`endif
   logic      [ 0: 3] cntNXD;                           // Timeout timer
   logic      [ 0: 4] state;                            // State variable

   //
   // Vector debug capture (read-only, 763110-763112 on this bridge)
   //
   //  Records the last CPU vector cycle to this bridge that ended without
   //  the bridge returning a vector (the CPU then reads 0 and halts with
   //  ILLII).
   //
   //  763110: [0:3]   count of unanswered vector cycles (saturates at 17)
   //          [4:6]   PI level of the last WRU this bridge answered
   //          [7:10]  0
   //          [11:15] slots selected while the vector cycle was pending
   //                  (slot 1..5 = bits 11..15)
   //          [16:35] device interrupt requests when the vector cycle
   //                  started: slot 1 BR7..BR4 in [16:19] .. slot 5 in [32:35]
   //  763111: [16:35] device interrupt requests at the last answered WRU
   //  763112: [16:35] device interrupt requests when the vector cycle ended
   //          [0:7]   clocks the vector cycle was visible (saturates at 377)
   //          [8:12]  device NPR requests (devREQI slot 1..5) at the start
   //          [13]    busACKO at the start
   //  763113: [0:4]   UBA state when the vector cycle started
   //          [5:9]   UBA state when it ended
   //          [10:14] UBA state on the clock before it started
   //          [16:35] states visited while it was visible (state 0 = bit 16
   //                  .. state 19 = bit 35)
   //
   //  States: 0 IDLE, 1 CPUtoDEV, 2 CPUtoVEC, 3/4 DEVtoMEM0/1, 5 DEVtoIO,
   //          6-14 loopback, 15 WAITREG, 16 WAITBUSREQ, 17 WAITDEVREQ,
   //          18 WAITVECREQ, 19 DONE
   //
   //  UBA3 slots: 1 DZ11, 2 LP20, 3 DUP11, 4 KMC11, 5 RH11 (tape)
   //

   wire  [0:19] vdbgINTR = {devINTRI[1], devINTRI[2], devINTRI[3], devINTRI[4], devINTRI[5]};
   logic        vdbgLAST;
   logic        vdbgACKD;
   logic [0: 4] vdbgSELM;
   logic [0:19] vdbgSNAP;
   logic [0:19] vdbgWRU;
   logic [0: 2] vdbgWRUPI;
   logic [0: 3] vdbgCNT;
   logic [0:35] regVDBG0;
   logic [0:35] regVDBG1;
   logic [0:35] regVDBG2;
   logic [0:35] regVDBG3;
   logic [0: 7] vdbgCLKS;
   logic [0: 4] vdbgST0;
   logic [0: 4] vdbgSTP;
   logic [0: 4] vdbgPREV;
   logic [0:19] vdbgSTM;
   logic [0: 4] vdbgDREQ;
   logic        vdbgACK0;

   always_ff @(posedge clk)
     begin
        if (rst)
          begin
             regVDBG3  <= 0;
             vdbgCLKS  <= 0;
             vdbgST0   <= 0;
             vdbgSTP   <= 0;
             vdbgPREV  <= 0;
             vdbgSTM   <= 0;
             vdbgDREQ  <= 0;
             vdbgACK0  <= 0;
          end
        else
          begin
             vdbgPREV <= state;
             if (vectREAD & !vdbgLAST)
               begin
                  vdbgCLKS <= 1;
                  vdbgST0  <= state;
                  vdbgSTP  <= vdbgPREV;
                  vdbgSTM  <= 20'b1 << (19 - state);
                  vdbgDREQ <= {devREQI[1], devREQI[2], devREQI[3], devREQI[4], devREQI[5]};
                  vdbgACK0 <= ks10bus.busACKO;
               end
             else if (vectREAD)
               begin
                  if (vdbgCLKS != 8'hff)
                    vdbgCLKS <= vdbgCLKS + 1'b1;
                  vdbgSTM <= vdbgSTM | (20'b1 << (19 - state));
               end
             else if (vdbgLAST & !vdbgACKD)
               regVDBG3 <= {vdbgST0, state, vdbgSTP, 1'b0, vdbgSTM};
          end
     end

   always_ff @(posedge clk)
     begin
        if (rst)
          begin
             vdbgLAST  <= 0;
             vdbgACKD  <= 0;
             vdbgSELM  <= 0;
             vdbgSNAP  <= 0;
             vdbgWRU   <= 0;
             vdbgWRUPI <= 0;
             vdbgCNT   <= 0;
             regVDBG0  <= 0;
             regVDBG1  <= 0;
             regVDBG2  <= 0;
          end
        else
          begin
             vdbgLAST <= vectREAD;
             if ((state == stateIDLE) & wruREAD & wruHIT)
               begin
                  vdbgWRU   <= vdbgINTR;
                  vdbgWRUPI <= busPI;
               end
             if (vectREAD & !vdbgLAST)
               begin
                  vdbgACKD <= 0;
                  vdbgSELM <= 0;
                  vdbgSNAP <= vdbgINTR;
               end
             else if (vectREAD)
               begin
                  if (state == stateCPUtoVEC)
                    vdbgSELM <= vdbgSELM | {devREQO[1], devREQO[2], devREQO[3], devREQO[4], devREQO[5]};
                  if (ks10bus.busACKO)
                    vdbgACKD <= 1;
               end
             else if (vdbgLAST & !vdbgACKD)
               begin
                  vdbgCNT  <= (vdbgCNT == 4'hf) ? vdbgCNT : vdbgCNT + 1'b1;
                  regVDBG0 <= {((vdbgCNT == 4'hf) ? vdbgCNT : vdbgCNT + 1'b1), vdbgWRUPI, 4'b0, vdbgSELM, vdbgSNAP};
                  regVDBG1 <= {16'b0, vdbgWRU};
                  regVDBG2 <= {vdbgCLKS, vdbgDREQ, vdbgACK0, 2'b0, vdbgINTR};
`ifndef SYNTHESIS
                  $display("[%11.3f] UBA%0d: unanswered vector cycle. sel=%05b start=%020b wru(pi%0d)=%020b end=%020b clks=%0d st0=%0d prev=%0d end=%0d mask=%020b dreq=%05b ack0=%b",
                           $time/1.0e3, ubaNUM, vdbgSELM, vdbgSNAP, vdbgWRUPI, vdbgWRU, vdbgINTR,
                           vdbgCLKS, vdbgST0, vdbgSTP, state, vdbgSTM, vdbgDREQ, vdbgACK0);
`endif
               end
          end
     end

   //
   // UBAPAGE computes pageFAIL combinationally from devREQ and the
   // registered pageADDRI.  Outside the states below pageADDRI is stale
   // (the previous transfer, with its IO flag replaced by flagREAD or
   // flagWRITE), so a device request that arrives then would be checked
   // against the wrong address.  If the monitor has since invalidated that
   // map entry, the sticky UBASR[TMO] gets set although no transfer fails.
   // TOPS-10 BOOT then refuses to read the disk (R11INI sees TMO) and
   // probably TOPS-20 stalls after "System restarting".  Only set TMO for a page
   // fail in the states that act on it.
   //

   assign pageCHECK = ((state == stateDEVtoMEM0)  |
                       (state == stateLOOPtoMEM0) |
                       (state == stateMEMtoLOOP0));

   always_ff @(posedge clk)
     if (rst | devRESET)
       begin
          ks10bus.busREQO  <= 0;
          ks10bus.busACKO  <= 0;
          ks10bus.busDATAO <= 0;
          devREQO[1]  <= 0;
          devREQO[2]  <= 0;
          devREQO[3]  <= 0;
          devREQO[4]  <= 0;
          devREQO[5]  <= 0;
          devACKO[1]  <= 0;
          devACKO[2]  <= 0;
          devACKO[3]  <= 0;
          devACKO[4]  <= 0;
          devACKO[5]  <= 0;
          devADDRO[1] <= 0;
          devADDRO[2] <= 0;
          devADDRO[3] <= 0;
          devADDRO[4] <= 0;
          devADDRO[5] <= 0;
          devDATAO[1] <= 0;
          devDATAO[2] <= 0;
          devDATAO[3] <= 0;
          devDATAO[4] <= 0;
          devDATAO[5] <= 0;
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

           if ((ks10bus.busREQI & statREAD) | (ks10bus.busREQI & statWRITE))
             begin
                ks10bus.busACKO  <= 1;
                ks10bus.busDATAO <= regUBASR;
                state <= stateWAITBUSREQ;
             end

           //
           // CPU is accessing paging data
           //

           else if ((ks10bus.busREQI & pageREAD) | (ks10bus.busREQI & pageWRITE))
             begin
                ks10bus.busACKO  <= 1;
                ks10bus.busDATAO <= pageDATAO;
                state <= stateWAITBUSREQ;
             end

           //
           // CPU is performing a loopback read
           //  Need to do an NPR read and return the results of that read on
           //  this IO read operation.
           //
           //  DO NOT acknowledge this IO request from the CPU yet.
           //

           else if (ks10bus.busREQI & loopREAD)
             begin
                loopADDR  <= ks10bus.busADDRI;
                pageADDRI <= ks10bus.busADDRI;
                cntTMO    <= timeout;
                state     <= stateMEMtoLOOP0;
             end

           //
           // CPU is performing a loopback write
           //

           else if (ks10bus.busREQI & loopWRITE)
             begin
                ks10bus.busACKO   <= 1;
                case ({`devIOBYTE(ks10bus.busADDRI), `devWORDSEL(ks10bus.busADDRI), `devBYTESEL(ks10bus.busADDRI)})
                  3'b000: loopDATA[ 0:17] <= ks10bus.busDATAI[18:35];     // Even word
                  3'b001: loopDATA[ 0:17] <= ks10bus.busDATAI[18:35];     // Even word
                  3'b010: loopDATA[18:35] <= ks10bus.busDATAI[18:35];     // Odd  word
                  3'b011: loopDATA[18:35] <= ks10bus.busDATAI[18:35];     // Odd  word
                  3'b100: loopDATA[10:17] <= ks10bus.busDATAI[28:35];     // Even word, low  byte.
                  3'b101: loopDATA[ 2: 9] <= ks10bus.busDATAI[20:27];     // Even word, high byte.
                  3'b110: loopDATA[28:35] <= ks10bus.busDATAI[28:35];     // Odd  word, low  byte.
                  3'b111: loopDATA[20:27] <= ks10bus.busDATAI[20:27];     // Odd  word, high byte.
                endcase
                loopADDR  <= ks10bus.busADDRI;
                pageADDRI <= ks10bus.busADDRI;                            // Lookup paging for this address
                cntTMO    <= timeout;
                state     <= stateLOOPtoMEM0;
             end

           //
           // CPU is accessing the maintenance register
           //

           else if (ks10bus.busREQI & maintWRITE)
             begin
                ks10bus.busACKO <= 1;
                state <= stateWAITBUSREQ;
             end

           //
           // CPU is reading the vector debug registers (763110-763112)
           //

           else if (ks10bus.busREQI & vdbgREAD)
             begin
                ks10bus.busACKO  <= 1;
                case (busADDR[34:35])
                  2'd0:    ks10bus.busDATAO <= regVDBG0;
                  2'd1:    ks10bus.busDATAO <= regVDBG1;
                  2'd2:    ks10bus.busDATAO <= regVDBG2;
                  default: ks10bus.busDATAO <= regVDBG3;
                endcase
                state <= stateWAITBUSREQ;
             end

           //
           // CPU is doing a WRU bus cycle
           //

           else if (ks10bus.busREQI & wruREAD & wruHIT)
             begin
                ks10bus.busACKO  <= 1;
                ks10bus.busDATAO <= wruRESP;
                state <= stateWAITBUSREQ;
             end

           //
           // CPU is requesting data from an IO device
           //

           else if ((ks10bus.busREQI & devREAD) | (ks10bus.busREQI & devWRITE))
             begin
                devREQO[1]  <= 1;
                devREQO[2]  <= 1;
                devREQO[3]  <= 1;
                devREQO[4]  <= 1;
                devREQO[5]  <= 1;
                devADDRO[1] <= ks10bus.busADDRI;
                devADDRO[2] <= ks10bus.busADDRI;
                devADDRO[3] <= ks10bus.busADDRI;
                devADDRO[4] <= ks10bus.busADDRI;
                devADDRO[5] <= ks10bus.busADDRI;
                devDATAO[1] <= ks10bus.busDATAI;
                devDATAO[2] <= ks10bus.busDATAI;
                devDATAO[3] <= ks10bus.busDATAI;
                devDATAO[4] <= ks10bus.busDATAI;
                devDATAO[5] <= ks10bus.busDATAI;
                cntNXD      <= timeout;
                state       <= stateCPUtoDEV;
             end

           //
           // CPU is requesting a vector from an IO device
           //  Determine the highest priority interrupt and request the
           //  highest priority device to provide the interrupt vector.
           //

           else if (ks10bus.busREQI & vectREAD & !simVECDROP)
             begin
                if (devINTRI[1][7])
                  devREQO[1] <= 1;
                else if (devINTRI[2][7])
                  devREQO[2] <= 1;
                else if (devINTRI[3][7])
                  devREQO[3] <= 1;
                else if (devINTRI[4][7])
                  devREQO[4] <= 1;
                else if (devINTRI[5][7])
                  devREQO[5] <= 1;
                else if (devINTRI[1][6])
                  devREQO[1] <= 1;
                else if (devINTRI[2][6])
                  devREQO[2] <= 1;
                else if (devINTRI[3][6])
                  devREQO[3] <= 1;
                else if (devINTRI[4][6])
                  devREQO[4] <= 1;
                else if (devINTRI[5][6])
                  devREQO[5] <= 1;
                else if (devINTRI[1][5])
                  devREQO[1] <= 1;
                else if (devINTRI[2][5])
                  devREQO[2] <= 1;
                else if (devINTRI[3][5])
                  devREQO[3] <= 1;
                else if (devINTRI[4][5])
                  devREQO[4] <= 1;
                else if (devINTRI[5][5])
                  devREQO[5] <= 1;
                else if (devINTRI[1][4])
                  devREQO[1] <= 1;
                else if (devINTRI[2][4])
                  devREQO[2] <= 1;
                else if (devINTRI[3][4])
                  devREQO[3] <= 1;
                else if (devINTRI[4][4])
                  devREQO[4] <= 1;
                else if (devINTRI[5][4])
                  devREQO[5] <= 1;
                cntNXD      <= timeout;
                devADDRO[1] <= ks10bus.busADDRI;
                devADDRO[2] <= ks10bus.busADDRI;
                devADDRO[3] <= ks10bus.busADDRI;
                devADDRO[4] <= ks10bus.busADDRI;
                devADDRO[5] <= ks10bus.busADDRI;
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
                  devREQO[5]  <= 1;
                  devADDRO[1] <= devADDRI[1];
                  devADDRO[2] <= devADDRI[1];
                  devADDRO[3] <= devADDRI[1];
                  devADDRO[4] <= devADDRI[1];
                  devADDRO[5] <= devADDRI[1];
                  devDATAO[1] <= devDATAI[1];
                  devDATAO[2] <= devDATAI[1];
                  devDATAO[3] <= devDATAI[1];
                  devDATAO[4] <= devDATAI[1];
                  devDATAO[5] <= devDATAI[1];
                  state       <= stateDEVtoIO;
               end

             //
             // Device 1 is requesting memory
             //

             else
               begin
                  ks10bus.busDATAO <= devDATAI[1];
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
                  devREQO[5]  <= 1;
                  devADDRO[1] <= devADDRI[2];
                  devADDRO[2] <= devADDRI[2];
                  devADDRO[3] <= devADDRI[2];
                  devADDRO[4] <= devADDRI[2];
                  devADDRO[5] <= devADDRI[2];
                  devDATAO[1] <= devDATAI[2];
                  devDATAO[2] <= devDATAI[2];
                  devDATAO[3] <= devDATAI[2];
                  devDATAO[4] <= devDATAI[2];
                  devDATAO[5] <= devDATAI[2];
                  state       <= stateDEVtoIO;
               end

             //
             // Device 2 is requesting memory
             //

             else
               begin
                  ks10bus.busDATAO <= devDATAI[2];
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
                  devREQO[5]  <= 1;
                  devADDRO[1] <= devADDRI[3];
                  devADDRO[2] <= devADDRI[3];
                  devADDRO[3] <= devADDRI[3];
                  devADDRO[4] <= devADDRI[3];
                  devADDRO[5] <= devADDRI[3];
                  devDATAO[1] <= devDATAI[3];
                  devDATAO[2] <= devDATAI[3];
                  devDATAO[3] <= devDATAI[3];
                  devDATAO[4] <= devDATAI[3];
                  devDATAO[5] <= devDATAI[3];
                  state       <= stateDEVtoIO;
               end

             //
             // Device 3 is requesting memory
             //

             else
               begin
                  ks10bus.busDATAO <= devDATAI[3];
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
                  devREQO[5]  <= 1;
                  devADDRO[1] <= devADDRI[4];
                  devADDRO[2] <= devADDRI[4];
                  devADDRO[3] <= devADDRI[4];
                  devADDRO[4] <= devADDRI[4];
                  devADDRO[5] <= devADDRI[4];
                  devDATAO[1] <= devDATAI[4];
                  devDATAO[2] <= devDATAI[4];
                  devDATAO[3] <= devDATAI[4];
                  devDATAO[4] <= devDATAI[4];
                  devDATAO[5] <= devDATAI[4];
                  state       <= stateDEVtoIO;
               end

             //
             // Device 4 is requesting memory
             //

             else
               begin
                  ks10bus.busDATAO <= devDATAI[4];
                  devSEL    <= 3'd4;
                  pageADDRI <= devADDRI[4];
                  cntTMO    <= timeout;
                  state     <= stateDEVtoMEM0;
               end

           //
           // Device 5 is requesting IO or memory
           //

           else if (devREQI[5])

             //
             // Device 5 is requesting IO
             //

             if (`busIO(devADDRI[5]))
               begin
                  devSEL      <= 3'd5;
                  devREQO[1]  <= 1;
                  devREQO[2]  <= 1;
                  devREQO[3]  <= 1;
                  devREQO[4]  <= 1;
                  devREQO[5]  <= 1;
                  devADDRO[1] <= devADDRI[5];
                  devADDRO[2] <= devADDRI[5];
                  devADDRO[3] <= devADDRI[5];
                  devADDRO[4] <= devADDRI[5];
                  devADDRO[5] <= devADDRI[5];
                  devDATAO[1] <= devDATAI[5];
                  devDATAO[2] <= devDATAI[5];
                  devDATAO[3] <= devDATAI[5];
                  devDATAO[4] <= devDATAI[5];
                  devDATAO[5] <= devDATAI[5];
                  state       <= stateDEVtoIO;
               end

             //
             // Device 5 is requesting memory
             //

             else
               begin
                  ks10bus.busDATAO <= devDATAI[5];
                  devSEL    <= 3'd5;
                  pageADDRI <= devADDRI[5];
                  cntTMO    <= timeout;
                  state     <= stateDEVtoMEM0;
               end

         //
         // CPU is requesting data from an IO device
         //

         stateCPUtoDEV:
           if (devACKI[1])
             begin
                ks10bus.busACKO  <= 1;
                ks10bus.busDATAO <= devDATAI[1];
                devREQO[1] <= 0;
                devREQO[2] <= 0;
                devREQO[3] <= 0;
                devREQO[4] <= 0;
                devREQO[5] <= 0;
                state      <= stateWAITBUSREQ;
             end
           else if (devACKI[2])
             begin
                ks10bus.busACKO  <= 1;
                ks10bus.busDATAO <= devDATAI[2];
                devREQO[1] <= 0;
                devREQO[2] <= 0;
                devREQO[3] <= 0;
                devREQO[4] <= 0;
                devREQO[5] <= 0;
                state      <= stateWAITBUSREQ;
             end
           else if (devACKI[3])
             begin
                ks10bus.busACKO  <= 1;
                ks10bus.busDATAO <= devDATAI[3];
                devREQO[1] <= 0;
                devREQO[2] <= 0;
                devREQO[3] <= 0;
                devREQO[4] <= 0;
                devREQO[5] <= 0;
                state      <= stateWAITBUSREQ;
             end
           else if (devACKI[4])
             begin
                ks10bus.busACKO  <= 1;
                ks10bus.busDATAO <= devDATAI[4];
                devREQO[1] <= 0;
                devREQO[2] <= 0;
                devREQO[3] <= 0;
                devREQO[4] <= 0;
                devREQO[5] <= 0;
                state      <= stateWAITBUSREQ;
             end
           else if (devACKI[5])
             begin
                ks10bus.busACKO  <= 1;
                ks10bus.busDATAO <= devDATAI[5];
                devREQO[1] <= 0;
                devREQO[2] <= 0;
                devREQO[3] <= 0;
                devREQO[4] <= 0;
                devREQO[5] <= 0;
                state      <= stateWAITBUSREQ;
             end
           else if (!ks10bus.busREQI)
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
                ks10bus.busACKO  <= 1;
                ks10bus.busDATAO <= devDATAI[1];
                devREQO[1]       <= 0;
                state            <= stateWAITVECREQ;
             end
           else if (devREQO[2] & devACKI[2])
             begin
                ks10bus.busACKO  <= 1;
                ks10bus.busDATAO <= devDATAI[2];
                devREQO[2]       <= 0;
                state            <= stateWAITVECREQ;
             end
           else if (devREQO[3] & devACKI[3])
             begin
                ks10bus.busACKO  <= 1;
                ks10bus.busDATAO <= devDATAI[3];
                devREQO[3]       <= 0;
                state            <= stateWAITVECREQ;
             end
           else if (devREQO[4] & devACKI[4])
             begin
                ks10bus.busACKO  <= 1;
                ks10bus.busDATAO <= devDATAI[4];
                devREQO[4]       <= 0;
                state            <= stateWAITVECREQ;
             end
           else if (devREQO[5] & devACKI[5])
             begin
                ks10bus.busACKO  <= 1;
                ks10bus.busDATAO <= devDATAI[5];
                devREQO[5]       <= 0;
                state            <= stateWAITVECREQ;
             end
           else if (cntTMO != 0)
             cntTMO <= cntTMO - 1'b1;
           else
             begin
                ks10bus.busREQO <= 0;
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
                   ks10bus.busREQO <= 1;
                   state   <= stateDEVtoMEM1;
                end
           end

         //
         // Device is requesting access to memory.
         //  Wait for memory to respond
         //

         stateDEVtoMEM1:
           if (ks10bus.busACKI)
             begin
                ks10bus.busREQO         <= 0;
                devACKO[devSEL] <= 1;
                devDATAO[1]     <= ks10bus.busDATAI;
                devDATAO[2]     <= ks10bus.busDATAI;
                devDATAO[3]     <= ks10bus.busDATAI;
                devDATAO[4]     <= ks10bus.busDATAI;
                devDATAO[5]     <= ks10bus.busDATAI;
                state           <= stateWAITDEVREQ;
             end
           else if (!devREQI[devSEL])
             begin
                ks10bus.busREQO <= 0;
                state   <= stateDONE;
             end
           else if (cntTMO != 0)
             cntTMO <= cntTMO - 1'b1;
           else
             begin
                ks10bus.busREQO <= 0;
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
              else if (devACKI[5])
                begin
                   devACKO[devSEL]  <= 1;
                   devDATAO[devSEL] <= devDATAI[5];
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
              ks10bus.busACKO <= 0;
              if (pageFAIL)
                state <= stateDONE;
              else if (flagsFTM)

                //
                // Fast Transfer Mode
                //  DSUBA TEST14
                //

                if (`devWORDSEL(loopADDR))
                  begin
                     ks10bus.busREQO  <= 1;
                     ks10bus.busDATAO <= {rpwDATA[0:17], loopDATA[18:35]};
                     cntTMO           <= timeout;
                     pageADDRI[0:17]  <= flagWRITE;
                     state            <= stateLOOPtoMEM4;
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
                   ks10bus.busREQO  <= 1;
                   ks10bus.busDATAO <= (flagsE16) ? {2'b0, loopDATA[2:17], 2'b0, busADDRO[20:35]} : {loopDATA[0:17], busADDRO[18:35]};
                   cntTMO           <= timeout;
                   pageADDRI[0:17]  <= flagWRITE;
                   state            <= stateLOOPtoMEM4;
                end

              //
              // Normal Mode Even Word Low Byte (non-RPW) access
              //  DSUBA TEST12
              //

              else if (!flagsRRV & `devIOBYTE(loopADDR) & !`devWORDSEL(loopADDR) & !`devBYTESEL(loopADDR))
                begin
                   ks10bus.busREQO  <= 1;
                   ks10bus.busDATAO <= {10'b0, loopDATA[10:17], busADDRO[18:35]};
                   cntTMO           <= timeout;
                   pageADDRI[0:17]  <= flagWRITE;
                   state            <= stateLOOPtoMEM4;
                end

              //
              // All other accesses are RPW Accesses
              //

              else
                begin
                   ks10bus.busREQO  <= 1;
                   cntTMO           <= timeout;
                   pageADDRI[0:17]  <= flagREAD;
                   state            <= stateLOOPtoMEM1;
                end
           end

         //
         // Loopback is requesting read access to memory. Wait for memory to
         //  respond. This is the read cycle of the read/pause/write cycle.
         //

         stateLOOPtoMEM1:
           if (ks10bus.busACKI)
             begin
                ks10bus.busREQO <= 0;
                rpwDATA         <= ks10bus.busDATAI;
                state           <= stateLOOPtoMEM2;
             end
           else if (cntTMO != 0)
             cntTMO <= cntTMO - 1'b1;
           else
             begin
                ks10bus.busREQO <= 0;
                state           <= stateDONE;
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
              ks10bus.busREQO <= 1;
              pageADDRI[0:17] <= flagWRITE;
              case ({flagsE16, `devIOBYTE(loopADDR), `devWORDSEL(loopADDR), `devBYTESEL(loopADDR)})
                4'b0000: ks10bus.busDATAO <= {loopDATA[0:17],  rpwDATA[18:35]};        // Even word
                4'b0001: ks10bus.busDATAO <= {loopDATA[0:17],  rpwDATA[18:35]};        // Even word
                4'b0010: ks10bus.busDATAO <= { rpwDATA[0:17], loopDATA[18:35]};        // Odd  word
                4'b0011: ks10bus.busDATAO <= { rpwDATA[0:17], loopDATA[18:35]};        // Odd  word
                4'b0100: ks10bus.busDATAO <= {2'b0,  rpwDATA[ 2: 9], loopDATA[10:17], 2'b0,  rpwDATA[20:27],  rpwDATA[28:35]};    // Even word, low  byte.
                4'b0101: ks10bus.busDATAO <= {2'b0, loopDATA[ 2: 9],  rpwDATA[10:17], 2'b0, busADDRO[20:27], busADDRO[28:35]};    // TEST16: Even word, high byte.
                4'b0110: ks10bus.busDATAO <= {       rpwDATA[ 0:17],                  2'b0, loopDATA[20:27], loopDATA[28:35]};    // TEST17: Odd  word, low  byte.
                4'b0111: ks10bus.busDATAO <= {       rpwDATA[ 0:17],                  2'b0, loopDATA[20:27],  rpwDATA[28:35]};    // TEST20: Odd  word, high byte.
                4'b1000: ks10bus.busDATAO <= {2'b0, loopDATA[ 2: 9], loopDATA[10:17], 2'b0,  rpwDATA[20:27],  rpwDATA[28:35]};    // E16, Even word
                4'b1001: ks10bus.busDATAO <= {2'b0, loopDATA[ 2: 9], loopDATA[10:17], 2'b0,  rpwDATA[20:27],  rpwDATA[28:35]};    // E16, Even word
                4'b1010: ks10bus.busDATAO <= {2'b0,  rpwDATA[ 2: 9],  rpwDATA[10:17], 2'b0, loopDATA[20:27], loopDATA[28:35]};    // E16, Odd  word
                4'b1011: ks10bus.busDATAO <= {2'b0,  rpwDATA[ 2: 9],  rpwDATA[10:17], 2'b0, loopDATA[20:27], loopDATA[28:35]};    // E16, Odd  word
                4'b1100: ks10bus.busDATAO <= {2'b0,  rpwDATA[ 2: 9], loopDATA[10:17], 2'b0,  rpwDATA[20:27],  rpwDATA[28:35]};    // E16, Even word, low  byte.
                4'b1101: ks10bus.busDATAO <= {2'b0, loopDATA[ 2: 9],  rpwDATA[10:17], 2'b0, busADDRO[20:27], busADDRO[28:35]};    // E16, Even word, high byte.
                4'b1110: ks10bus.busDATAO <= {2'b0,  rpwDATA[ 2: 9],  rpwDATA[10:17], 2'b0,  rpwDATA[20:27], loopDATA[28:35]};    // E16, Odd  word, low  byte.
                4'b1111: ks10bus.busDATAO <= {2'b0,  rpwDATA[ 2: 9],  rpwDATA[10:17], 2'b0, loopDATA[20:27],  rpwDATA[28:35]};    // E16, Odd  word, high byte.
              endcase
              state <= stateLOOPtoMEM4;
           end

         //
         // Wait for memory to finish
         //

         stateLOOPtoMEM4:
           if (ks10bus.busACKI)
             begin
                ks10bus.busREQO <= 0;
                state <= stateDONE;
             end
           else if (cntTMO != 0)
             cntTMO <= cntTMO - 1'b1;
           else
             begin
                ks10bus.busREQO <= 0;
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
                ks10bus.busREQO  <= 1;
                cntTMO          <= timeout;
                pageADDRI[0:17] <= flagREAD;
                state           <= stateMEMtoLOOP1;
             end

         //
         // Read the data from memory
         //

         stateMEMtoLOOP1:
           if (ks10bus.busACKI)
             begin
                ks10bus.busREQO <= 0;
                case ({`devIOBYTE(loopADDR), `devWORDSEL(loopADDR), `devBYTESEL(loopADDR)})
                  3'b000: loopDATA <= {18'b0, ks10bus.busDATAI[ 0:17]};      // Even word
                  3'b001: loopDATA <= {18'b0, ks10bus.busDATAI[ 0:17]};      // Even word
                  3'b010: loopDATA <= {18'b0, ks10bus.busDATAI[18:35]};      // Odd  word
                  3'b011: loopDATA <= {18'b0, ks10bus.busDATAI[18:35]};      // Odd  word
                  3'b100: loopDATA <= {28'b0, ks10bus.busDATAI[10:17]};      // Even word, low  byte.
                  3'b101: loopDATA <= {20'b0, ks10bus.busDATAI[ 2: 9], 8'b0};// Even word, high byte.
                  3'b110: loopDATA <= {28'b0, ks10bus.busDATAI[28:35]};      // Odd  word, low  byte.
                  3'b111: loopDATA <= {20'b0, ks10bus.busDATAI[20:27], 8'b0};// Odd  word, high byte.
                endcase
                state <= stateMEMtoLOOP2;
             end
           else if (cntTMO != 0)
             cntTMO <= cntTMO - 1'b1;
           else
             begin
                ks10bus.busREQO <= 0;
                state <= stateDONE;
             end

         //
         // Finally acknowlege the IO request that started this all.
         //  Return the loopDATA from the NPR that was performed.
         //

         stateMEMtoLOOP2:
           begin
              ks10bus.busACKO  <= 1;
              ks10bus.busDATAO <= loopDATA;
              state <= stateMEMtoLOOP3;
           end

         //
         // Negate the bus acknowlege.  All done.
         //

         stateMEMtoLOOP3:
           begin
              if (!ks10bus.busREQI)
                begin
                   ks10bus.busACKO <= 0;
                   state   <= stateDONE;
                end
           end

         //
         // Wait for register access to complete
         //

         stateWAITREG:
           if ((!ks10bus.busREQI | !devREAD) & (!ks10bus.busREQI | !devWRITE))
             begin
                ks10bus.busREQO <= 0;
                ks10bus.busACKO <= 0;
                devREQO[1]  <= 0;
                devREQO[2]  <= 0;
                devREQO[3]  <= 0;
                devREQO[4]  <= 0;
                devREQO[5]  <= 0;
                devACKO[1]  <= 0;
                devACKO[2]  <= 0;
                devACKO[3]  <= 0;
                devACKO[4]  <= 0;
                devACKO[5]  <= 0;
                devADDRO[1] <= 0;
                devADDRO[2] <= 0;
                devADDRO[3] <= 0;
                devADDRO[4] <= 0;
                devADDRO[5] <= 0;
                devDATAO[1] <= 0;
                devDATAO[2] <= 0;
                devDATAO[3] <= 0;
                devDATAO[4] <= 0;
                devDATAO[5] <= 0;
                devSEL      <= 0;
                state       <= stateIDLE;
             end

         //
         // Wait for bus request to negate
         //

         stateWAITBUSREQ:
           if (!ks10bus.busREQI)
             begin
                ks10bus.busREQO <= 0;
                ks10bus.busACKO <= 0;
                devREQO[1]  <= 0;
                devREQO[2]  <= 0;
                devREQO[3]  <= 0;
                devREQO[4]  <= 0;
                devREQO[5]  <= 0;
                devACKO[1]  <= 0;
                devACKO[2]  <= 0;
                devACKO[3]  <= 0;
                devACKO[4]  <= 0;
                devACKO[5]  <= 0;
                devADDRO[1] <= 0;
                devADDRO[2] <= 0;
                devADDRO[3] <= 0;
                devADDRO[4] <= 0;
                devADDRO[5] <= 0;
                devDATAO[1] <= 0;
                devDATAO[2] <= 0;
                devDATAO[3] <= 0;
                devDATAO[4] <= 0;
                devDATAO[5] <= 0;
                devSEL      <= 0;
                state       <= stateIDLE;
             end

         //
         // Wait for device request to negate
         //

         stateWAITDEVREQ:
           if (!devREQI[devSEL])
             begin
                ks10bus.busREQO <= 0;
                ks10bus.busACKO <= 0;
                devREQO[1]  <= 0;
                devREQO[2]  <= 0;
                devREQO[3]  <= 0;
                devREQO[4]  <= 0;
                devREQO[5]  <= 0;
                devACKO[1]  <= 0;
                devACKO[2]  <= 0;
                devACKO[3]  <= 0;
                devACKO[4]  <= 0;
                devACKO[5]  <= 0;
                devADDRO[1] <= 0;
                devADDRO[2] <= 0;
                devADDRO[3] <= 0;
                devADDRO[4] <= 0;
                devADDRO[5] <= 0;
                devDATAO[1] <= 0;
                devDATAO[2] <= 0;
                devDATAO[3] <= 0;
                devDATAO[4] <= 0;
                devDATAO[5] <= 0;
                devSEL      <= 0;
                state       <= stateIDLE;
             end

         //
         // Wait for vector request to negate
         //

         stateWAITVECREQ:
           if (!(ks10bus.busREQI & vectREAD))
             begin
                ks10bus.busREQO <= 0;
                ks10bus.busACKO <= 0;
                devREQO[1]  <= 0;
                devREQO[2]  <= 0;
                devREQO[3]  <= 0;
                devREQO[4]  <= 0;
                devREQO[5]  <= 0;
                devACKO[1]  <= 0;
                devACKO[2]  <= 0;
                devACKO[3]  <= 0;
                devACKO[4]  <= 0;
                devACKO[5]  <= 0;
                devADDRO[1] <= 0;
                devADDRO[2] <= 0;
                devADDRO[3] <= 0;
                devADDRO[4] <= 0;
                devADDRO[5] <= 0;
                devDATAO[1] <= 0;
                devDATAO[2] <= 0;
                devDATAO[3] <= 0;
                devDATAO[4] <= 0;
                devDATAO[5] <= 0;
                devSEL      <= 0;
                state       <= stateIDLE;
             end

         //
         // Done
         //  Negate all requests
         //

         stateDONE:
           begin
              ks10bus.busREQO <= 0;
              ks10bus.busACKO <= 0;
              devREQO[1]  <= 0;
              devREQO[2]  <= 0;
              devREQO[3]  <= 0;
              devREQO[4]  <= 0;
              devREQO[5]  <= 0;
              devACKO[1]  <= 0;
              devACKO[2]  <= 0;
              devACKO[3]  <= 0;
              devACKO[4]  <= 0;
              devACKO[5]  <= 0;
              devADDRO[1] <= 0;
              devADDRO[2] <= 0;
              devADDRO[3] <= 0;
              devADDRO[4] <= 0;
              devADDRO[5] <= 0;
              devDATAO[1] <= 0;
              devDATAO[2] <= 0;
              devDATAO[3] <= 0;
              devDATAO[4] <= 0;
              devDATAO[5] <= 0;
              devSEL      <= 0;
              state       <= stateIDLE;
           end
       endcase

   assign devRESET = statINI;
   assign setNXD   = (cntNXD == 1);
   assign setTMO   = (cntTMO == 1);

   //
   // Unibus Interface
   //

   genvar i;
   generate
      for (i = 1; i <= 5; i++)
        begin : loop
           assign devACLO[i]  = unibus[i].devACLO;      // Power fail
           assign devREQI[i]  = unibus[i].devREQO;      // Request out
           assign devACKI[i]  = unibus[i].devACKO;      // Acknowledge out
           assign devADDRI[i] = unibus[i].devADDRO;     // Address out
           assign devDATAI[i] = unibus[i].devDATAO;     // Data out
           assign devINTRI[i] = unibus[i].devINTRO;     // Interrupt out
           assign unibus[i].clk = clk;                  // Clock
           assign unibus[i].rst = rst;                  // Reset
           assign unibus[i].devRESET = devRESET;        // Device reset
           assign unibus[i].devREQI  = devREQO[i];      // Request in
           assign unibus[i].devACKI  = devACKO[i];      // Acknowledge in
           assign unibus[i].devADDRI = devADDRO[i];     // Address in
           assign unibus[i].devDATAI = devDATAO[i];     // Data in
        end
   endgenerate

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

             if (ks10bus.busREQI)
               addr <= ks10bus.busADDRI;

             if (ks10bus.busREQO)
               addr <= pageADDRI;

             if (setNXD)
               $fwrite(file, "[%11.3f] UBA%d: Nonexistent device (NXD). Addr = %012o.\n",
                       $time/1.0e3, ubaNUM, addr);

             if (setTMO)
               $fwrite(file, "[%11.3f] UBA%d: Nonexistent memory (TMO). Addr = %012o.\n",
                       $time/1.0e3, ubaNUM, addr);

             if (pageFAIL & pageCHECK)
               $fwrite(file, "[%11.3f] UBA%d: Page Failure (TMO). Addr = %012o.\n",
                       $time/1.0e3, ubaNUM, addr);

             if (ks10bus.busACKI)
               begin
                  if (`busREAD(ks10bus.busADDRO))
                    $fwrite(file, "[%11.3f] UBA%d: Read %012o from address %012o.\n",
                            $time/1.0e3, ubaNUM, ks10bus.busDATAI, ks10bus.busADDRO);
                  else
                    $fwrite(file, "[%11.3f] UBA%d: Wrote %012o to address %012o.\n",
                            $time/1.0e3, ubaNUM, ks10bus.busDATAO, ks10bus.busADDRO);
               end

          end
     end

   //
   // State monitor (define SIM_UBAMON to enable)
   //  Reports the bridge staying in one non-idle state for more than
   //  SIM_UBAMON_CLKS clocks (default 12), and the reason it left.
   //

`ifdef SIM_UBAMON

`ifndef SIM_UBAMON_CLKS
 `define SIM_UBAMON_CLKS 12
`endif

   logic [0:4] monSTATE;
   integer     monCNT;

   always_ff @(posedge clk)
     if (rst)
       begin
          monSTATE <= stateIDLE;
          monCNT   <= 0;
       end
     else
       begin
          monSTATE <= state;
          if (state != monSTATE)
            begin
               if ((monSTATE != stateIDLE) & (monCNT > `SIM_UBAMON_CLKS))
                 $display("[%11.3f] UBAMON%0d: Left state %0d -> %0d after %0d clocks. REQI=%b ADDRI=%012o devREQI1=%b",
                          $time/1.0e3, ubaNUM, monSTATE, state, monCNT, ks10bus.busREQI, ks10bus.busADDRI, devREQI[1]);
               monCNT <= 1;
            end
          else
            begin
               monCNT <= monCNT + 1;
               if ((state != stateIDLE) & (monCNT == 1000))
                 $display("[%11.3f] UBAMON%0d: Stuck in state %0d for 1000 clocks. REQI=%b ADDRI=%012o ACKO=%b devREQI1=%b",
                          $time/1.0e3, ubaNUM, state, ks10bus.busREQI, ks10bus.busADDRI, ks10bus.busACKO, devREQI[1]);
            end
       end

`endif

   //
   // Simulation monitor: report every interrupt vector that a device gives
   // to this UBA, and vector cycles that end without a device answering.
   //

`ifdef SIM_VECMON

   always_ff @(posedge clk)
     if (state == stateCPUtoVEC)
       begin
`ifdef SIM_VECMON_VERBOSE
          for (int i = 1; i <= 5; i++)
            if (devREQO[i] & devACKI[i])
              $display("[%11.3f] VECMON: UBA%0d dev%0d gave vector %06o Addr=%012o",
                       $time/1.0e3, ubaNUM, i, devDATAI[i][18:35], ks10bus.busADDRI);
`endif
          if (!(devREQO[1] & devACKI[1]) & !(devREQO[2] & devACKI[2]) &
              !(devREQO[3] & devACKI[3]) & !(devREQO[4] & devACKI[4]) &
              !(devREQO[5] & devACKI[5]) & (cntTMO == 0))
            $display("[%11.3f] VECMON: UBA%0d vector cycle timed out, no device. devREQO=%b%b%b%b%b",
                     $time/1.0e3, ubaNUM, devREQO[1], devREQO[2], devREQO[3], devREQO[4], devREQO[5]);
       end

`endif

`endif

endmodule
