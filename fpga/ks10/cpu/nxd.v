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
   // Microcode decode
   //

   wire busIO   = `busIO(cpuADDRO);
   wire busWRU  = `busWRU(cpuADDRO);
   wire busVECT = `busVECT(cpuADDRO);
   wire ioCLEAR = `cromSPEC_EN_10 & (`cromSPEC_SEL == `cromSPEC_SEL_CLRIOLAT);

   //
   // State definition
   //

   localparam [0:3] stateIDLE   =  0,
                    stateCNT0   =  1,
                    stateCNT1   =  2,
                    stateCNT2   =  3,
                    stateCNT3   =  4,
                    stateCNT4   =  5,
                    stateCNT5   =  6,
                    stateCNT6   =  7,
                    stateCNT7   =  8,
                    stateCNT8   =  9,
                    stateCNT9   = 10,
                    stateACKIO1 = 11,
                    stateACKIO2 = 12,
                    stateACKWRU = 13,
                    stateACKVEC = 14,
                    stateNOACK  = 15;

   //
   // Microcode address 3666 is executed at the end if
   // the WRU cycle.
   //

   reg addr3666;
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          addr3666  <= 0;
        else
          addr3666 <= (crom[0:11] == 12'o3666);
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
   reg [0:3] state;

   always @(posedge clk or posedge rst)
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

            stateIDLE:
              if (busIO & cpuREQO & !cpuACKI)
                begin
                   wru   <= busWRU;
                   vect  <= busVECT;
                   busy  <= 1;
                   state <= stateCNT0;
                end

            stateCNT0:
              if (cpuACKI)
                begin
                   if (wru)
                     state <= stateACKWRU;
                   else if (vect)
                     state <= stateACKVEC;
                   else
                     state <= stateACKIO1;
                end
              else
                state <= stateCNT1;

            stateCNT1:
              if (cpuACKI)
                begin
                   if (wru)
                     state <= stateACKWRU;
                   else if (vect)
                     state <= stateACKVEC;
                   else
                     state <= stateACKIO1;
                end
              else
                state <= stateCNT2;

            stateCNT2:
              if (cpuACKI)
                begin
                   if (wru)
                     state <= stateACKWRU;
                   else if (vect)
                     state <= stateACKVEC;
                   else
                     state <= stateACKIO1;
                end
              else
                state <= stateCNT3;

            stateCNT3:
              if (cpuACKI)
                begin
                   if (wru)
                     state <= stateACKWRU;
                   else if (vect)
                     state <= stateACKVEC;
                   else
                     state <= stateACKIO1;
                end
              else
                state <= stateCNT4;

            stateCNT4:
              if (cpuACKI)
                begin
                   if (wru)
                     state <= stateACKWRU;
                   else if (vect)
                     state <= stateACKVEC;
                   else
                     state <= stateACKIO1;
                end
              else
                state <= stateCNT5;

            stateCNT5:
              if (cpuACKI)
                begin
                   if (wru)
                     state <= stateACKWRU;
                   else if (vect)
                     state <= stateACKVEC;
                   else
                     state <= stateACKIO1;
                end
              else
                state <= stateCNT6;

            stateCNT6:
              if (cpuACKI)
                begin
                   if (wru)
                     state <= stateACKWRU;
                   else if (vect)
                     state <= stateACKVEC;
                   else
                     state <= stateACKIO1;
                end
              else
                state <= stateCNT7;

            stateCNT7:
              if (cpuACKI)
                begin
                   if (wru)
                     state <= stateACKWRU;
                   else if (vect)
                     state <= stateACKVEC;
                   else
                     state <= stateACKIO1;
                end
              else
                state <= stateCNT8;

            stateCNT8:
              if (cpuACKI)
                begin
                   if (wru)
                     state <= stateACKWRU;
                   else if (vect)
                     state <= stateACKVEC;
                   else
                     state <= stateACKIO1;
                end
              else
                state <= stateCNT9;

            stateCNT9:
              if (cpuACKI)
                begin
                   if (wru)
                     state <= stateACKWRU;
                   else if (vect)
                     state <= stateACKVEC;
                   else
                     state <= stateACKIO1;
                end
              else
                state <= stateNOACK;

            stateACKIO1:
              state  <= stateACKIO2;

            stateACKIO2:
              if (ioCLEAR)
                begin
                   busy  <= 0;
                   state <= stateIDLE;
                end

            stateACKWRU:
              if (addr3666)
                begin
                   busy  <= 0;
                   state <= stateIDLE;
                end

            stateACKVEC:
              if (!busVECT)
                begin
                   busy  <= 0;
                   state <= stateIDLE;
                end

            stateNOACK:
              state  <= stateIDLE;

          endcase
     end

   //
   // Outputs
   //

   assign ioBUSY = ((cpuREQO & !cpuACKI & (state == stateIDLE)) |
                    busy);

   assign ioWAIT = ((cpuREQO & !cpuACKI & (state == stateIDLE)) |
                    (cpuREQO & !cpuACKI & (state == stateCNT0)) |
                    (cpuREQO & !cpuACKI & (state == stateCNT1)) |
                    (cpuREQO & !cpuACKI & (state == stateCNT2)) |
                    (cpuREQO & !cpuACKI & (state == stateCNT3)) |
                    (cpuREQO & !cpuACKI & (state == stateCNT4)) |
                    (cpuREQO & !cpuACKI & (state == stateCNT5)) |
                    (cpuREQO & !cpuACKI & (state == stateCNT6)) |
                    (cpuREQO & !cpuACKI & (state == stateCNT7)) |
                    (cpuREQO & !cpuACKI & (state == stateCNT8)) |
                    (cpuREQO & !cpuACKI & (state == stateCNT9)));

endmodule
