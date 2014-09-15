////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   NXD
//
// Details
//   This device provide NXD and an interface to the microcode to
//   provide IO Page Fault functionality.  When a memory transaction
//   occurs on the KS10 backplane bus, the CPU is stalled while
//   waiting for memory.  When an IO transaction occurs on the KS10
//   backplane bus, the microcode measures the timing the
//   transaction and causes an IO Page Fault if the IO transaction
//   is not acknowledged.  The ioBUSY output from this module
//   provides that signal to the microcode.
//
//   The IO Page Fault operation is tested by the DSUBA diagnostic.
//
// File
//   nxd.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2014 Rob Doyle
//
// This source file may be used and distributed without
// restriction provided that this copyright statement is not
// removed from the file and that any derivative work contains
// the original copyright notice and the associated disclaimer.
//
// This source file is free software; you can redistribute it
// and/or modify it under the terms of the GNU Lesser General
// Public License as published by the Free Software Foundation;
// version 2.1 of the License.
//
// This source is distributed in the hope that it will be
// useful, but WITHOUT ANY WARRANTY; without even the implied
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
// PURPOSE. See the GNU Lesser General Public License for more
// details.
//
// You should have received a copy of the GNU Lesser General
// Public License along with this source; if not, download it
// from http://www.gnu.org/licenses/lgpl.txt
//
////////////////////////////////////////////////////////////////////
//
// Comments are formatted for doxygen
//

`default_nettype none
`include "useq/crom.vh"
`include "bus.vh"

module NXD(clk, rst, clken, crom, cpuADDRO, cpuACKI, ioBUSY);

   parameter cromWidth = `CROM_WIDTH;

   input                  clk;          // Clock
   input                  rst;          // Reset
   input                  clken;        // Clock Enable
   input  [0:cromWidth-1] crom;         // Control ROM Data
   input  [0:35]          cpuADDRO;     // Bus Address
   input                  cpuACKI;      // Bus ACK
   output                 ioBUSY;       // IO Latch

   //
   // State definition
   //

   localparam [0:1] stateIDLE   =  0,   // Waiting for IO Cycle
                    stateDELAY1 =  1,   // Delay
                    stateDELAY2 =  2,   // Delay
                    stateWAIT   =  3;   // Wait for IO Cycle to complete

   //
   // Microcode
   //

   wire ioSTART = `busIO(cpuADDRO);
   wire ioCLEAR = `cromSPEC_EN_10 & (`cromSPEC_SEL == `cromSPEC_SEL_CLRIOLAT);

   //
   // IO Busy State Machine
   //
   // Trace
   //  CRA2/E98
   //  CRA2/E148
   //  CRA2/E183
   //  CRA2/E184
   //

   reg [0:1] state;
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
	  
          state <= stateIDLE;
	
        else
	  
          case (state)
            stateIDLE:
              if (ioSTART & cpuACKI)
                state <= stateDELAY1;
              else if (ioSTART & !cpuACKI)
                state <= stateDELAY2;

            stateDELAY1:
              if (ioCLEAR)
                state <= stateWAIT;
              else if (~ioSTART)
                state <= stateIDLE;
	
            stateDELAY2:
              if (cpuACKI)
                state <= stateDELAY1;
              else if (~ioSTART)
                state <= stateIDLE;

            stateWAIT:
              if (~ioSTART)
                state <= stateIDLE;
          endcase
	
     end

   assign ioBUSY = ((state == stateDELAY1) |
                    (state == stateDELAY2));

 endmodule
