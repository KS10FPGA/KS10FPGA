////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   NXD
//
// Details
//   This device provide NXD and an interface to the microcode to provide IO
//   Page Fault functionality.  When a memory transaction occurs on the KS10
//   backplane bus, the CPU is stalled while waiting for memory.  When an IO
//   transaction occurs on the KS10 backplane bus, the bus stalls for a few
//   cycles and then continues the CPU.  If no acknowledge is received, the
//   microcode measures the timing the transaction and causes an IO Page Fault
//   if the IO transaction is not acknowledged.  The ioBUSY output from this
//   module provides that signal to the microcode.
//
//   The IO Page Fault operation is tested by the DSUBA diagnostic.
//
// File
//   nxd.v
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

`include "useq/crom.vh"
`include "bus.vh"

module NXD (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire [0:107] crom,                 // Control ROM Data
      input  wire [0: 35] cpuADDRO,             // Bus Address
      input  wire         cpuREQO,              // CPU Bus Request
      input  wire         cpuACKI,              // CPU Bus Acknowledge
      input  wire         cpuGNT,               // CPU has the bus
      output wire         ioWAIT,               // IO Wait
      output wire         ioBUSY                // IO Busy
   );

   //
   // Microcode decode
   //

// wire busREAD  = `busREAD(cpuADDRO);          // Read Cycle (IO or Memory)
// wire busWRITE = `busWRITE(cpuADDRO);         // Write Cycle (IO or Memory)
// wire busPHYS  = `busPHYS(cpuADDRO);          // Physical Address
   wire busIO    = `busIO(cpuADDRO);            // IO Cycle
   wire busWRU   = `busWRU(cpuADDRO);           // WRU Cycle
   wire busVECT  = `busVECT(cpuADDRO);          // Vector Cycle

   //
   // Microcode Decode
   //

   wire ioCLEAR  = `cromSPEC_EN_10 & (`cromSPEC_SEL == `cromSPEC_SEL_CLRIOLAT);

   //
   // Decoding
   //

// wire nxdWRU  = busREAD & busIO & busPHYS & busWRU;
// wire nxdVECT = busREAD & busIO & busPHYS & busVECT;
// wire nxdRWIO = ((busREAD  & busIO & busPHYS & !busWRU & !busVECT) |
//                 (busWRITE & busIO & busPHYS & !busWRU & !busVECT));

   //
   // State definition
   //

   localparam [0:3] stateIDLE   = 0,
                    stateCNT    = 1,
                    stateACKIO  = 2,
                    stateACKWRU = 3,
                    stateACKVEC = 4,
                    stateNOACK  = 5;

   //
   // Microcode address 3726 is executed at the end if
   // the WRU cycle.
   //

   reg wruDONE;

   always @(posedge clk)
     begin
        if (rst)
          wruDONE  <= 0;
        else
          wruDONE <= (crom[0:11] == 12'o3726);
     end

   //
   // IO Busy
   //
   // Trace
   //  CRA2/E98
   //  CRA2/E148
   //  CRA2/E183
   //  CRA2/E184
   //

   reg wru;
   reg vect;
   reg busy;
   reg [0:5] nxmcnt;
   reg [0:3] state;

   //
   // Served request
   //
   //  The CPU request stays asserted after an IO cycle has completed, until
   //  the VMA is loaded again.  If the console or a UBA DMA takes the bus in
   //  that window, the ACK goes away and the old request would look like a
   //  new IO cycle.  The UBA then answers it again, and the state machine
   //  is left in stateACKIO after the microcode has done its last
   //  CLR IO LATCH.  The next WRU then does not wait for its ACK, the CPU
   //  reads zero and takes an unvectored interrupt.
   //
   //  'served' marks the current request as already completed.  It is
   //  cleared when the request goes away or the address changes.
   //

   reg  [0:35] lastADDR;
   reg         lastREQ;
   reg         served;
   reg         lastACK;

   wire sameREQ  = lastREQ & cpuREQO & (lastADDR == cpuADDRO);
   wire newCYCLE = busIO & cpuREQO & !cpuACKI & !(served & sameREQ);

   wire setSERVED = ((state == stateACKIO ) & ioCLEAR) |
                    ((state == stateACKWRU) & wruDONE) |
                    ((state == stateACKVEC) & !busVECT) |
                    ((state == stateIDLE  ) & busIO & cpuREQO & cpuACKI);

   always @(posedge clk)
     begin
        if (rst)
          begin
             lastADDR <= 0;
             lastREQ  <= 0;
             served   <= 0;
             lastACK  <= 0;
          end
        else
          begin
             lastADDR <= cpuADDRO;
             lastREQ  <= cpuREQO;
             lastACK  <= cpuACKI;
             served   <= setSERVED | (served & sameREQ);
          end
     end

   always @(posedge clk)
     begin
        if (rst)
          begin
             wru   <= 0;
             vect  <= 0;
             busy  <= 0;
             state <= stateIDLE;
          end
        else
          case (state)

            //
            // Wait for something to do
            //

            stateIDLE:
              if (newCYCLE)
                begin
                   wru    <= busWRU;
                   vect   <= busVECT;
                   busy   <= 1;
                   nxmcnt <= 32;          // Allow time for a UBA DMA cycle to finish
                   state  <= stateCNT;
                end

              //
              // IO cycle acknowledged in the same clock as the request.
              //  The memory controller answers the Memory Status Register
              //  (IO address 100000) combinationally.  Without this the IO
              //  cycle never went busy, the microcode IOWAIT timed out and
              //  the RDIO/WRIO page failed (PFW 200000 = IO not busy).
              //  TOPS-20 reads the MSR at login and stopped with BUGHLT
              //  IONXM.
              //
              //  Only plain IO cycles, and only when the acknowledge was
              //  not already asserted on the previous clock.  The UBA holds
              //  its acknowledge until the request drops, and the request
              //  can stay asserted when the PI microcode goes straight from
              //  the WRU cycle to the vector cycle.  Taking that held
              //  acknowledge as the answer to the vector cycle let the CPU
              //  read the WRU response as the vector, and TOPS-20 halted
              //  with an Illegal Interrupt Instruction.
              //

              else if (busIO & cpuREQO & cpuACKI & !lastACK & !busWRU & !busVECT &
                       !(served & sameREQ))
                begin
                   wru    <= 0;
                   vect   <= 0;
                   busy   <= 1;
                   state  <= stateACKIO;
                end

            //
            // Wait for ACK.  Timeout if the ACK never occurs.
            //

            stateCNT:
              if (cpuACKI)
                begin
                   if (wru)
                     state <= stateACKWRU;
                   else if (vect)
                     state <= stateACKVEC;
                   else
                     state <= stateACKIO;
                end
              //
              // Only count clocks where the arbiter is giving the bus to
              // the CPU.  UBA DMA (e.g. a disk transfer) has priority over
              // the CPU and could use up the whole timeout before the IO
              // request ever reached the device.  On a vector cycle the
              // CPU then read a vector of zero and halted with an Illegal
              // Interrupt Instruction, and the device's acknowledge came
              // later and was lost.
              //
              else if (nxmcnt != 0)
                begin
                   if (cpuGNT)
                     nxmcnt <= nxmcnt - 1'b1;
                end
              else
                state <= stateNOACK;

            //
            // Finish IO cycle
            //

            stateACKIO:
              if (ioCLEAR)
                begin
                   busy  <= 0;
                   state <= stateIDLE;
                end

            //
            // Finish WRU cycle
            //

            stateACKWRU:
              if (wruDONE)
                begin
                   busy  <= 0;
                   state <= stateIDLE;
                end

            //
            // Finish Vector Cycle
            //

            stateACKVEC:
              if (!busVECT)
                begin
                   busy  <= 0;
                   state <= stateIDLE;
                end

            //
            // Un-acked IO Cycle
            //

            //  A WRU cycle that timed out stays here while the WRU request is
            //  on the bus.  The PI microcode can then go straight from the
            //  WRU to the vector cycle (STRTIO at 3726), and the VMA keeps
            //  the WRU flag until that new cycle is loaded.  Leave on
            //  wruDONE as stateACKWRU does, so that the vector cycle starts
            //  from stateIDLE and waits for its acknowledge.
            //
            //  Previously only !busWRU was checked, which is first true on
            //  the vector cycle itself.  The vector cycle's MEM READ did not
            //  wait (ioWAIT is only asserted from stateIDLE and stateCNT),
            //  read a vector of zero, and TOPS-20 halted with an Illegal
            //  Interrupt Instruction.  This happens when the UBA answers the
            //  WRU on the same clock that the timeout expires: the CPU takes
            //  the WRU data and goes on to the vector cycle.
            //

            stateNOACK:
              if (wru)
                begin
                   busy <= 0;
                   if (!busWRU | wruDONE)
                     state <= stateIDLE;
                end
              else
                state <= stateIDLE;

          endcase
     end

   //
   // Outputs
   //

   assign ioBUSY = ((newCYCLE & (state == stateIDLE)) | busy);

   assign ioWAIT = ((newCYCLE & (state == stateIDLE)) |
                    (busIO & cpuREQO & !cpuACKI & (state == stateCNT)));

   //
   // IO cycle monitor (define SIM_NXDMON to enable)
   //  Reports every WRU and vector cycle (clocks to acknowledge), IO
   //  cycles that time out, and IO cycles that start with the acknowledge
   //  already asserted (a stale acknowledge from the previous cycle).
   //

`ifndef SYNTHESIS
`ifdef SIM_NXDMON

   reg [0:35] monADDR;
   reg        monREQ;
   integer    monCNT;
   reg        monSUP;

   always @(posedge clk)
     if (rst)
       begin
          monADDR <= 0;
          monREQ  <= 0;
          monCNT  <= 0;
          monSUP  <= 0;
       end
     else
       begin
          monADDR <= cpuADDRO;
          monREQ  <= cpuREQO;
          if (busIO & cpuREQO & cpuACKI & (!monREQ | (monADDR != cpuADDRO)) & (state == stateIDLE))
            $display("[%11.3f] NXDMON: IO cycle started with ACK already asserted. Addr=%012o PrevAddr=%012o PrevREQ=%b",
                     $time/1.0e3, cpuADDRO, monADDR, monREQ);
          if ((state == stateIDLE) & busIO & cpuREQO & !cpuACKI & served & sameREQ & monREQ & (monADDR == cpuADDRO) & !monSUP)
            $display("[%11.3f] NXDMON: ACK dropped on a completed IO request; not restarting the cycle. Addr=%012o",
                     $time/1.0e3, cpuADDRO);
          monSUP <= (state == stateIDLE) & busIO & cpuREQO & !cpuACKI & served & sameREQ;
          if ((state == stateIDLE) & newCYCLE)
            monCNT <= 1;
          else if (state == stateCNT)
            begin
               monCNT <= monCNT + 1;
               if (cpuACKI & (wru | vect))
                 $display("[%11.3f] NXDMON: %s cycle acknowledged after %0d clocks. Addr=%012o",
                          $time/1.0e3, wru ? "WRU" : "VECT", monCNT, cpuADDRO);
               else if (cpuACKI & (monCNT > 8))
                 $display("[%11.3f] NXDMON: IO cycle acknowledged after %0d clocks. Addr=%012o",
                          $time/1.0e3, monCNT, cpuADDRO);
               else if (!cpuACKI & (nxmcnt == 0))
                 $display("[%11.3f] NXDMON: %s cycle timed out after %0d clocks. Addr=%012o",
                          $time/1.0e3, wru ? "WRU" : vect ? "VECT" : "IO", monCNT, cpuADDRO);
            end
       end

`endif
`endif

endmodule
