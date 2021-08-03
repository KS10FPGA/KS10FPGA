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
      input  wire         clk,          // Clock
      input  wire         rst,          // Reset
      input  wire [0:107] crom,         // Control ROM Data
      input  wire [0: 35] cpuADDRO,     // Bus Address
      input  wire         cpuREQO,      // CPU Bus Request
      input  wire         cpuACKI,      // CPU Bus Acknowledge
      output wire         ioWAIT,       // IO Wait
      output wire         ioBUSY        // IO Busy
   );

   //
   // Microcode decode
   //

   wire busREAD  = `busREAD(cpuADDRO);          // Read Cycle (IO or Memory)
   wire busWRITE = `busWRITE(cpuADDRO);         // Write Cycle (IO or Memory)
   wire busPHYS  = `busPHYS(cpuADDRO);          // Physical Address
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
   reg [0:3] nxmcnt;
   reg [0:3] state;

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
              if (busIO & cpuREQO & !cpuACKI)
                begin
                   wru    <= busWRU;
                   vect   <= busVECT;
                   busy   <= 1;
                   nxmcnt <= 10;
                   state  <= stateCNT;
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
              else if (nxmcnt != 0)
                nxmcnt <= nxmcnt - 1'b1;
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

            stateNOACK:
              if (wru)
                begin
                   busy <= 0;
                   if (!busWRU)
                     state <= stateIDLE;
                end
              else
                state <= stateIDLE;

          endcase
     end

   //
   // Outputs
   //

   assign ioBUSY = ((busIO & cpuREQO & !cpuACKI & (state == stateIDLE)) | busy);

   assign ioWAIT = ((busIO & cpuREQO & !cpuACKI & (state == stateIDLE)) |
                    (busIO & cpuREQO & !cpuACKI & (state == stateCNT)));

endmodule
