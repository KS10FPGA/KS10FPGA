////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KS10 Bus Arbiter
//
// Details
//   This device is the KS10 Bus Arbiter and Bus Multiplexer
//
// File
//   arb.sv
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

`include "../cpu/bus.vh"

module ARB (
      input  wire        rst,           // Reset
      input  wire        clk,           // Clock
      ks10bus.arbiter    cpuBUS,        // KS10 backplane bus to CPU
      ks10bus.arbiter    cslBUS,        // KS10 backplane bus to CSL
      ks10bus.arbiter    ubaBUS[1:4],   // KS10 backplane bus to UBA
      ks10bus.arbiter    memBUS         // KS10 backplane bus to memory
   );

   //
   // CPU Interface
   //

   logic        cpuREQI;                // CPU Bus Request
   logic [0:35] cpuADDRI;               // CPU Address
   logic [0:35] cpuDATAI;               // CPU Data In
   logic        cpuACKO;                // CPU Bus Acknowledge Out
   logic [0:35] cpuDATAO;               // CPU Data Out
   logic [1: 7] cpuINTRO;               // CPU Interrupt Out

   //
   // Memory Interface
   //

   logic        memACKI;                // MEM Bus Acknowledge In
   logic [0:35] memDATAI;               // MEM Data In
   logic        memREQO;                // MEM Bus Request Out
   logic [0:35] memDATAO;               // MEM Data Out
   logic [0:35] memADDRO;               // MEM Address Out

   //
   // Console Interface
   //

   logic        cslREQI;                // CSL Bus Request In
   logic        cslACKI;                // CSL Bus Acknowledge In
   logic [0:35] cslADDRI;               // CSL Address In
   logic [0:35] cslDATAI;               // CSL Data In
   logic        cslREQO;                // CSL Bus Request Out
   logic        cslACKO;                // CSL Bus Acknowledge Out
   logic [0:35] cslDATAO;               // CSL Data Out
   logic [0:35] cslADDRO;               // CSL Address Out

   //
   // Unibus Interface
   //

   logic        ubaREQI[1:4];           // UBA Bus Request In
   logic        ubaACKI[1:4];           // UBA Bus Acknowledge In
   logic [0:35] ubaADDRI[1:4];          // UBA Address In
   logic [0:35] ubaDATAI[1:4];          // UBA Data In
   logic [1: 7] ubaINTRI[1:4];          // UBA Interrupt In
   logic        ubaREQO[1:4];           // UBA Bus Request Out
   logic        ubaACKO[1:4];           // UBA Bus Acknowledge Out
   logic [0:35] ubaDATAO[1:4];          // UBA Data Out
   logic [0:35] ubaADDRO[1:4];          // UBA Address Out
   logic [1: 7] ubaINTRO[1:4];          // UBA Interrupt Out

   //
   // CPU Interrupts
   //

   assign cpuINTRO = (ubaINTRI[1] | ubaINTRI[2] |  ubaINTRI[3] | ubaINTRI[4]);

   //
   // Interrupt Acknowledge Lock
   //
   // Details:
   //  The bus is arbitrated on every clock cycle, so a console request can
   //  take the bus in the middle of a CPU bus cycle.  WRU and interrupt
   //  vector cycles cannot be restarted: the device that supplies the
   //  vector clears its interrupt request when it does so.  If the UBA
   //  acknowledge is routed to the console, the CPU repeats the vector
   //  read, finds no interrupting device and gets a vector of zero (an
   //  Illegal Interrupt Instruction halt).
   //
   //  Once the CPU has been granted the bus for a WRU or vector cycle, the
   //  console is locked out until the CPU removes the request.
   //
   //  The UBAs are not locked out.  A UBA can be committed to a DMA cycle
   //  before it requests the bus (stateDEVtoMEM0).  Locking it out stalls
   //  the UBA until its DMA timer expires, and the UBA only answers WRU and
   //  vector cycles when it is idle, so the CPU's WRU cycle times out
   //  (an unvectored "unknown" interrupt through EPT+40+2N) and the DMA
   //  word is lost.  A UBA DMA cycle is short and the UBA services the CPU
   //  as soon as it returns to idle.
   //

   wire  cpuINTA  = cpuREQI & `busIO(cpuADDRI) & (`busWRU(cpuADDRI) | `busVECT(cpuADDRI));
   wire  cpuGRANT = !cslREQI;
   logic cpuLOCK;

   always_ff @(posedge clk)
     if (rst)
       cpuLOCK <= 0;
     else
       cpuLOCK <= cpuINTA & (cpuLOCK | cpuGRANT);

   //
   // Hold off the console after a CPU IO cycle has been acknowledged
   //
   //  The CPU keeps its request asserted after an IO cycle has completed,
   //  until the VMA is loaded again.  If the console takes the bus in that
   //  window, the UBA sees the request go away and come back, and performs
   //  the IO cycle a second time (duplicate device reads and writes, and a
   //  stray ACK that can complete the CPU's next IO cycle early).
   //
   //  Once a CPU IO cycle (including WRU and vector cycles) has been
   //  acknowledged, the console is held off until the CPU's request goes
   //  away or changes, or for at most 63 clocks.  UBA DMA is not held off
   //  (the UBA DMA timeout is only a few clocks).
   //

   logic [0:35] holdADDR;
   logic        holdACT;
   logic [0: 5] holdCNT;

   wire holdSAME = holdACT & cpuREQI & (cpuADDRI == holdADDR);
   wire cslBLOCK = holdSAME & (holdCNT != 0);
   wire cpuIOACK = cpuREQI & `busIO(cpuADDRI) & cpuACKO;

   //
   // Console IO to a UBA that is waiting for memory
   //
   // Details:
   //  A UBA is single threaded.  Once it has committed to a DMA cycle
   //  (stateDEVtoMEM0/1) it cannot service an IO request until the memory
   //  cycle completes.  If the console (which has priority) presents an IO
   //  request for that UBA, the console waits for the UBA and the UBA
   //  waits for the bus.  Only the UBA's 8 clock DMA timer breaks the
   //  deadlock: the DMA word is retried but the sticky UBASR[TMO] is left
   //  set.  The console 'rp boot' polls RHCS1 throughout each read, so
   //  TOPS-10 BOOT then found UBASR[TMO] set and would not read the disk.
   //
   //  Let that UBA have the memory cycle first.  The console request is
   //  still pending and is serviced when the UBA returns to idle.
   //

   wire cslDEFER = `busIO(cslADDRI) &
                   (((`busDEV(cslADDRI) == 4'd1) & ubaREQI[1]) |
                    ((`busDEV(cslADDRI) == 4'd2) & ubaREQI[2]) |
                    ((`busDEV(cslADDRI) == 4'd3) & ubaREQI[3]) |
                    ((`busDEV(cslADDRI) == 4'd4) & ubaREQI[4]));

   always_ff @(posedge clk)
     if (rst)
       begin
          holdADDR <= 0;
          holdACT  <= 0;
          holdCNT  <= 0;
       end
     else if (holdSAME)
       begin
          if (holdCNT != 0)
            holdCNT <= holdCNT - 1'b1;
       end
     else if (cpuIOACK)
       begin
          holdADDR <= cpuADDRI;
          holdACT  <= 1;
          holdCNT  <= 6'd63;
       end
     else
       holdACT <= 0;

   //
   // Bus Request Arbitration
   //
   // Details:
   //  Console has highest priority
   //  Unibus has next priority
   //  CPU has lowest priority
   //  Console is locked out while cpuLOCK is asserted
   //

   always_comb
     begin

        cslREQO     = 0;
        ubaREQO[1]  = 0;
        ubaREQO[2]  = 0;
        ubaREQO[3]  = 0;
        ubaREQO[4]  = 0;
        memREQO     = 0;

        cpuACKO     = 0;
        cslACKO     = 0;
        ubaACKO[1]  = 0;
        ubaACKO[2]  = 0;
        ubaACKO[3]  = 0;
        ubaACKO[4]  = 0;

        cslADDRO    = 0;
        ubaADDRO[1] = 0;
        ubaADDRO[2] = 0;
        ubaADDRO[3] = 0;
        ubaADDRO[4] = 0;
        memADDRO    = 0;

        cpuDATAO    = 0;
        cslDATAO    = 0;
        ubaDATAO[1] = 0;
        ubaDATAO[2] = 0;
        ubaDATAO[3] = 0;
        ubaDATAO[4] = 0;
        memDATAO    = 0;

        //
        // Bus Request from the Console
        //
        // Details
        //  The console can access the memory or the unibus
        //

        if (cslREQI & !cpuLOCK & !cslBLOCK & !cslDEFER)
          begin
             ubaREQO[1]  = 1;
             ubaREQO[2]  = 1;
             ubaREQO[3]  = 1;
             ubaREQO[4]  = 1;
             memREQO     = 1;
             ubaADDRO[1] = cslADDRI;
             ubaADDRO[2] = cslADDRI;
             ubaADDRO[3] = cslADDRI;
             ubaADDRO[4] = cslADDRI;
             memADDRO    = cslADDRI;
             ubaDATAO[1] = cslDATAI;
             ubaDATAO[2] = cslDATAI;
             ubaDATAO[3] = cslDATAI;
             ubaDATAO[4] = cslDATAI;
             memDATAO  = cslDATAI;
             if (memACKI)
               begin
                  cslACKO  = 1;
                  cslDATAO = memDATAI;
               end
             else if (ubaACKI[1])
               begin
                  cslACKO  = 1;
                  cslDATAO = ubaDATAI[1];
               end
             else if (ubaACKI[2])
               begin
                  cslACKO  = 1;
                  cslDATAO = ubaDATAI[2];
               end
             else if (ubaACKI[3])
               begin
                  cslACKO  = 1;
                  cslDATAO = ubaDATAI[3];
               end
             else if (ubaACKI[4])
               begin
                  cslACKO  = 1;
                  cslDATAO = ubaDATAI[4];
               end
          end

        //
        // Bus Request from the Unibus #1
        //
        // Details
        //  The unibus can access the memory
        //

        else if (ubaREQI[1])
          begin
             memREQO  = 1;
             memADDRO = ubaADDRI[1];
             memDATAO = ubaDATAI[1];
             if (memACKI)
               begin
                  ubaACKO[1] = 1;
                  ubaDATAO[1] = memDATAI;
               end
          end

        //
        // Bus Request from the Unibus #2
        //
        // Details
        //  The unibus can access the memory
        //

        else if (ubaREQI[2])
          begin
             memREQO  = 1;
             memADDRO = ubaADDRI[2];
             memDATAO = ubaDATAI[2];
             if (memACKI)
               begin
                  ubaACKO[2] = 1;
                  ubaDATAO[2] = memDATAI;
               end
          end

        //
        // Bus Request from the Unibus #3
        //
        // Details
        //  The unibus can access the memory
        //

        else if (ubaREQI[3])
          begin
             memREQO  = 1;
             memADDRO = ubaADDRI[3];
             memDATAO = ubaDATAI[3];
             if (memACKI)
               begin
                  ubaACKO[3] = 1;
                  ubaDATAO[3] = memDATAI;
               end
          end

        //
        // Bus Request from the Unibus #4
        //
        // Details
        //  The unibus can access the memory
        //

        else if (ubaREQI[4])
          begin
             memREQO  = 1;
             memADDRO = ubaADDRI[4];
             memDATAO = ubaDATAI[4];
             if (memACKI)
               begin
                  ubaACKO[4] = 1;
                  ubaDATAO[4] = memDATAI;
               end
          end

        //
        // Bus Request from the CPU
        //
        // Details
        //  The CPU can access the memory, unibus or console.
        //
        // Note
        //  The ARB needs to assert a 36'b0 on the data bus if no device
        //  acknowledges a WRU bus cycle.  This occurs on a PI interrupt.
        //  This simulates the DEC KS10 which implemented this using a
        //  tristated bus with pullups.
        //

        else if (cpuREQI)
          begin
             cslREQO     = 1;
             ubaREQO[1]  = 1;
             ubaREQO[2]  = 1;
             ubaREQO[3]  = 1;
             ubaREQO[4]  = 1;
             memREQO     = 1;
             cslADDRO    = cpuADDRI;
             ubaADDRO[1] = cpuADDRI;
             ubaADDRO[2] = cpuADDRI;
             ubaADDRO[3] = cpuADDRI;
             ubaADDRO[4] = cpuADDRI;
             memADDRO    = cpuADDRI;
             cslDATAO    = cpuDATAI;
             ubaDATAO[1] = cpuDATAI;
             ubaDATAO[2] = cpuDATAI;
             ubaDATAO[3] = cpuDATAI;
             ubaDATAO[4] = cpuDATAI;
             memDATAO  = cpuDATAI;
             if (memACKI)
               begin
                  cpuACKO  = 1;
                  cpuDATAO = memDATAI;
               end
             else if (ubaACKI[1])
               begin
                  cpuACKO  = 1;
                  cpuDATAO = ubaDATAI[1];
               end
             else if (ubaACKI[2])
               begin
                  cpuACKO  = 1;
                  cpuDATAO = ubaDATAI[2];
               end
             else if (ubaACKI[3])
               begin
                  cpuACKO  = 1;
                  cpuDATAO = ubaDATAI[3];
               end
             else if (ubaACKI[4])
               begin
                  cpuACKO  = 1;
                  cpuDATAO = ubaDATAI[4];
               end
             else if (cslACKI)
               begin
                  cpuACKO  = 1;
                  cpuDATAO = cslDATAI;
               end
             else
               cpuDATAO = 0;

          end
     end

   //
   // CPU Bus Interface
   //

   assign cpuREQI  = cpuBUS.busREQO;    // CPU Bus Request In
// assign cpuACKI  = cpuBUS.busACKO;    // CPU Acknowledge In (CPU is not a target)
   assign cpuADDRI = cpuBUS.busADDRO;   // CPU Address In
   assign cpuDATAI = cpuBUS.busDATAO;   // CPU Data In
   assign cpuBUS.busREQI  = 0;          // CPU Request Out (CPU is not a target)
   assign cpuBUS.busACKI  = cpuACKO;    // CPU Acknowldge Out
   assign cpuBUS.busADDRI = 0;          // CPU Address Out (CPU is not a target)
   assign cpuBUS.busDATAI = cpuDATAO;   // CPU Data Out
   assign cpuBUS.busINTRI = cpuINTRO;   // CPU Interrupt Output

   //
   // Memory Bus Interface
   //

// assign memREQI  = memBUS.busREQO;    // MEM Bus Request In (MEM is not an initiator)
   assign memACKI  = memBUS.busACKO;    // MEM Bus Acknowledge In
// assign memADDRI = memBUS.busADDRI;   // MEM Address In (MEM is not an initiator)
   assign memDATAI = memBUS.busDATAO;   // MEM Data In
   assign memBUS.busREQI  = memREQO;    // MEM Request Out
   assign memBUS.busACKI  = 0;          // MEM Acknowledge Out (MEM is not an initiator)
   assign memBUS.busADDRI = memADDRO;   // MEM Address Out
   assign memBUS.busDATAI = memDATAO;   // MEM Data Out
   assign memBUS.busINTRI = 0;          // MEM doesn't generate interrupts

   //
   // CSL Bus Interface
   //

   assign cslREQI  = cslBUS.busREQO;    // CSL Bus Request In
   assign cslACKI  = cslBUS.busACKO;    // CSL Acknowledge In
   assign cslADDRI = cslBUS.busADDRO;   // CSL Address In
   assign cslDATAI = cslBUS.busDATAO;   // CSL Data In
   assign cslBUS.busREQI  = cslREQO;    // CSL Request Out
   assign cslBUS.busACKI  = cslACKO;    // CSL Acknowledge Out
   assign cslBUS.busADDRI = cslADDRO;   // CSL Address Out
   assign cslBUS.busDATAI = cslDATAO;   // CSL Data Out
   assign cslBUS.busINTRI = 0;          // CSL doesn't generate interrupts

   //
   // UBA Bus Interfaces
   //

   genvar i;
   generate
      for (i = 1; i <= 4; i++)
        begin : loop
           assign ubaREQI[i]  = ubaBUS[i].busREQO;      // UBA Bus Request In
           assign ubaACKI[i]  = ubaBUS[i].busACKO;      // UBA Acknowledge In
           assign ubaADDRI[i] = ubaBUS[i].busADDRO;     // UBA Address In
           assign ubaDATAI[i] = ubaBUS[i].busDATAO;     // UBA Data In
           assign ubaINTRI[i] = ubaBUS[i].busINTRO;     // UBA Interrupt In
           assign ubaBUS[i].busREQI  = ubaREQO[i];      // UBA Request Out
           assign ubaBUS[i].busACKI  = ubaACKO[i];      // UBA Acknowledge Out
           assign ubaBUS[i].busADDRI = ubaADDRO[i];     // UBA Address Out
           assign ubaBUS[i].busDATAI = ubaDATAO[i];     // UBA Data Out
           assign ubaBUS[i].busINTRI = 0;               // UBA Interrupt Out
        end
   endgenerate

   //
   // Simulation monitor: report who takes the bus away from a CPU IO cycle
   // that has already been acknowledged.
   //

`ifndef SYNTHESIS
`ifdef SIM_ARBMON

   logic [0:35] monADDR;
   logic        monACK;

   always_ff @(posedge clk)
     begin
        monADDR <= cpuADDRI;
        monACK  <= cpuREQI & `busIO(cpuADDRI) & cpuACKO;
        if (monACK & cpuREQI & (cpuADDRI == monADDR) & !cpuACKO)
          $display("[%11.3f] ARBMON: ACK lost on CPU IO cycle Addr=%012o: cslREQ=%b cpuLOCK=%b ubaREQ=%b%b%b%b ubaACK=%b%b%b%b memACK=%b",
                   $time/1.0e3, cpuADDRI, cslREQI, cpuLOCK,
                   ubaREQI[1], ubaREQI[2], ubaREQI[3], ubaREQI[4],
                   ubaACKI[1], ubaACKI[2], ubaACKI[3], ubaACKI[4], memACKI);
     end

`endif
`endif

endmodule
