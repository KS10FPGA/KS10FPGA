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
//   transaction occurs on the KS10 backplane bus, the microcode measures the
//   timing the transaction and causes an IO Page Fault if the IO transaction
//   is not acknowledged.  The ioBUSY output from this module provides that
//   signal to the microcode.
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
// Copyright (C) 2012-2014 Rob Doyle
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
`include "useq/crom.vh"
`include "bus.vh"

module NXD(clk, rst, crom, cpuADDRO, cpuREQO, cpuACKI, ioWAIT, ioBUSY);

   parameter cromWidth = `CROM_WIDTH;

   input                  clk;          // Clock
   input                  rst;          // Reset
   input  [0:cromWidth-1] crom;         // Control ROM Data
   input  [0:35]          cpuADDRO;     // Bus Address
   input                  cpuREQO;      // CPU Bus Request
   input                  cpuACKI;      // CPU Bus Acknowledge
   output                 ioWAIT;       // IO Wait
   output                 ioBUSY;       // IO Busy

   //
   // Microcode
   //

   wire busIO    = `busIO(cpuADDRO);
   wire busWRU   = `busWRU(cpuADDRO);
   wire busVECT  = `busVECT(cpuADDRO);
   wire busREAD  = `busREAD(cpuADDRO);
   wire busWRITE = `busWRITE(cpuADDRO);
   wire ioCLEAR  = `cromSPEC_EN_10 & (`cromSPEC_SEL == `cromSPEC_SEL_CLRIOLAT);

   //
   // IO Busy
   //
   // Trace
   //  CRA2/E98
   //  CRA2/E148
   //  CRA2/E183
   //  CRA2/E184
   //

   localparam [1:0] busyIDLE = 0,
                    busySET  = 1,
                    busyWAIT = 2;

   reg [1:0] busy;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          busy <= busyIDLE;
        else
          case (busy)
            busyIDLE:
              if ((busIO & busREAD) | (busIO & busWRITE))
                busy <= busySET;
            busySET:
              if (ioCLEAR)
                busy <= busyWAIT;
            busyWAIT:
              if (!busREAD & !busWRITE)
                busy <= busyIDLE;
          endcase
     end

   assign ioBUSY = (busy == busySET);

   //
   // State definition
   //

   localparam [0:3] stateIDLE =  0,
                    stateCNT0 =  1,
                    stateCNT1 =  2,
                    stateCNT2 =  3,
                    stateCNT3 =  4,
                    stateCNT4 =  5,
                    stateCNT5 =  6,
                    stateCNT6 =  7,
                    stateWAIT =  8;

   reg wru;
   reg [0:3] state;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             wru   <= 0;
             state <= stateIDLE;
          end
        else
          case (state)

            stateIDLE:
              begin
                 wru <= 0 & busWRU;
                 if (cpuREQO & busIO & !cpuACKI)
                   state <= stateCNT0;
              end

            stateCNT0:
              if (cpuACKI)
                begin
                   if (wru)
                     state <= stateIDLE;
                   else
                     state <= stateWAIT;
                end
              else
                state <= stateCNT1;

            stateCNT1:
              if (cpuACKI)
                begin
                   if (wru)
                     state <= stateIDLE;
                   else
                     state <= stateWAIT;
                end
              else
                state <= stateCNT2;

            stateCNT2:
              if (cpuACKI)
                begin
                   if (wru)
                     state <= stateIDLE;
                   else
                     state <= stateWAIT;
                end
              else
                state <= stateCNT3;

            stateCNT3:
              if (cpuACKI)
                begin
                   if (wru)
                     state <= stateIDLE;
                   else
                     state <= stateWAIT;
                end
              else
                state <= stateCNT4;

            stateCNT4:
              if (cpuACKI)
                begin
                   if (wru)
                     state <= stateIDLE;
                   else
                     state <= stateWAIT;
                end
              else
                state <= stateWAIT;

            stateWAIT:
                state <= stateCNT5;

            stateCNT5:
              state <= stateIDLE;

            stateCNT6:
              state <= stateWAIT;

          endcase
     end

   assign ioWAIT = ((cpuREQO & !cpuACKI & (state == stateIDLE)) |
                    (cpuREQO & !cpuACKI & (state == stateCNT0)) |
                    (cpuREQO & !cpuACKI & (state == stateCNT1)) |
                    (cpuREQO & !cpuACKI & (state == stateCNT2)) |
                    (cpuREQO & !cpuACKI & (state == stateCNT3)) |
                    (cpuREQO & !cpuACKI & (state == stateCNT4)));

 endmodule
