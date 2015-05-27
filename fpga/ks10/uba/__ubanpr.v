////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   UBA Non Processor (DMA) Request
//
// Details
//   This module implements the device to KS10 Non Processor (DMA) Request.
//   This module also implements the UBA loopback.
//
// File
//   ubanpr.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2015 Rob Doyle
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

`include "ubabus.vh"
`include "ubapage.vh"
`include "../cpu/bus.vh"

module UBANPR (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      // Control
      input  wire         regUBAMR,             // UBA maintenance mode
      input  wire [ 0: 3] pageFLAGS,            // Pager flags
      input  wire [ 0:35] pageADDR,             // Pager address
      // Bus Interface
      input  wire [ 0:35] busADDRI,             // Backplane bus address in
      output reg  [ 0:35] busADDRO,             // Backplane bus address out
      input  wire [ 0:35] busDATAI,             // Backplane bus data in
      output reg  [ 0:35] busDATAO,             // Backplane bus data out
      input  wire         busACKI,              // Backplane bus acknowledge
      output reg          busREQO,              // Backplane bus request
      // Loopback Interface
      input  wire         loopREAD,             // Read from loop around
      input  wire         loopWRITE,            // Write to loop around
      output reg          loopACKO,             // ACK loop read/write
      // Device #1 Interface
      input  wire         dev1REQI,             // IO Device #1 Request In
      input  wire         dev1ACKI,             // IO Device #1 Acknowledge In
      output reg          dev1ACKO,             // IO Device #1 Acknowledge Out
      input  wire [ 0:35] dev1ADDRI,            // IO Device #1 Address In
      input  wire [ 0:35] dev1DATAI,            // IO Device #1 Data In
      // Device #2 Interface
      input  wire         dev2REQI,             // IO Device #2 Request In
      input  wire         dev2ACKI,             // IO Device #2 Acknowledge In
      output reg          dev2ACKO,             // IO Device #2 Acknowledge Out
      input  wire [ 0:35] dev2ADDRI,            // IO Device #2 Address In
      input  wire [ 0:35] dev2DATAI             // IO Device #2 Data In
   );

   //
   // Read and Write Flags
   //

   localparam [0:17] rdFLAGS = 18'o040000;
   localparam [0:17] wrFLAGS = 18'o010000;

   //
   // Address Bus Decode
   //

   wire busIO = `busIO(busADDRI);

   //
   // Page Flags
   //

   wire flagsRPW = `flagsRPW(pageFLAGS);
   wire flagsFTM = `flagsFTM(pageFLAGS);

   //
   // NPR State machine states
   //

   localparam [0:3] stateIDLE       =  0,
                    stateWRADDRWAIT =  1,
                    stateWRREADWAIT =  2,
                    stateWRREADREQ  =  3,
                    stateWRPAUSE    =  4,
                    stateWRWAIT     =  5,
                    stateWRREQ      =  6,
                    stateWRDONE     =  7,
                    stateRDADDRWAIT =  8,
                    stateRDWAIT     =  9,
                    stateRDREQ      = 10,
                    stateRDDONE     = 11;

   //
   // NPR request type
   //

   localparam [0:1] reqIDLE = 0,
                    reqLOOP = 1,
                    reqDEV1 = 2,
                    reqDEV2 = 3;

   reg [0:3] state;
   reg [0:1] req;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             loopACKO <= 0;
             dev1ACKO <= 0;
             dev2ACKO <= 0;
             busADDRO <= 0;
             busDATAO <= 0;
             busREQO  <= 0;
             req      <= reqIDLE;
             state    <= stateIDLE;
          end
        else
          begin

             busREQO  <= 0;
             loopACKO <= 0;
             dev1ACKO <= 0;
             dev2ACKO <= 0;

             case (state)

               //
               // stateIDLE:
               //   Determine the type of NPR cycle.  The address is set
               //   immediately because it takes a clock cycle for the address
               //   to propagate through the UBA paging hardware.
               //

               stateIDLE:
                 begin
                    if (loopREAD & regUBAMR)
                      begin
                         req      <= reqLOOP;
                         busADDRO <= {rdFLAGS, busADDRI[18:35]};
                         busDATAO <= 0;
                         state    <= stateRDADDRWAIT;
                      end
                    else if (loopWRITE & regUBAMR)
                      begin
                         if (busADDRI[34])
                           busDATAO[18:35] <= busDATAI[18:35];
                         else
                           busDATAO[ 0:17] <= busDATAI[18:35];
                         req      <= reqLOOP;
                         loopACKO <= 1;
                         busADDRO <= {wrFLAGS, busADDRI[18:35]};
                         state    <= stateWRADDRWAIT;
                      end
                    else if (dev1REQI & `devREAD(dev1ADDRI)  & !regUBAMR)
                      begin
                         req      <= reqDEV1;
                         busADDRO <= dev1ADDRI;
                         busDATAO <= 0;
                         state    <= stateRDADDRWAIT;
                      end
                    else if (dev1REQI & `devWRITE(dev1ADDRI) & !regUBAMR)
                      begin
                         req      <= reqDEV1;
                         busADDRO <= dev1ADDRI;
                         busDATAO <= dev1DATAI;
                         state    <= stateWRADDRWAIT;
                      end
                    else if (dev2REQI & `devREAD(dev2ADDRI)  & !regUBAMR)
                      begin
                         req      <= reqDEV2;
                         busADDRO <= dev2ADDRI;
                         busDATAO <= 0;
                         state    <= stateRDADDRWAIT;
                      end
                    else if (dev2REQI & `devWRITE(dev2ADDRI) & !regUBAMR)
                      begin
                         req      <= reqDEV2;
                         busADDRO <= dev2ADDRI;
                         busDATAO <= dev2DATAI;
                         state    <= stateWRADDRWAIT;
                      end
                 end

               //
               // stateWRADDRWAIT:
               //   The address should have propigated through the UBA Paging memory.
               //   Determine what kind of DMA cycle to generate.
               //   - Some types generate a Read/Pause/Write cycle
               //   - Some types just generate a write cycle
               //

               stateWRADDRWAIT:

                 //
                 // Fast Transfer Mode
                 //

                 if (flagsFTM)
                   begin

                      //
                      // FTM from device #1
                      //

                      if (req == reqDEV1)
                        begin
                           state <= stateWRWAIT;
                        end

                      //
                      // FTM from device #2
                      //

                      else if (req == reqDEV2)
                        begin
                           state <= stateWRWAIT;
                        end

                      //
                      // FTM from loopback.
                      //   Even word is just buffered locally, not written.
                      //

                      else if ((req == reqLOOP) & (busADDRO[34] == 0))
                        begin
                           state <= stateIDLE;
                        end

                      //
                      // FTM from loopback
                      //   Odd word is combined with buffered even word.
                      //

                      else if ((req == reqLOOP) & (busADDRO[34] == 1))
                        begin
                           busADDRO <= {rdFLAGS, busADDRO[18:35]};
                           state    <= stateWRPAUSE;
                        end
                   end

                 //
                 // Even word (non RPW)
                 //

                 else if (!flagsRPW & !busADDRO[34])
                   begin
                      busDATAO <= {busDATAO[0:17], pageADDR[18:35]};
                      state    <= stateWRWAIT;
                   end

                 //
                 // Everything else is a RPW cycle
                 //

                 else
                   begin
                      busADDRO <= {rdFLAGS, busADDRO[18:35]};
                      state <= stateWRREADWAIT;
                   end

               //
               // stateWRREADWAIT:
               //   This state is part of the read cycle on RPW cycles.  This
               //   state asserts the busREQO output for the read request.
               //

               stateWRREADWAIT:
                 if (!busIO)
                   begin
                      busREQO <= 1;
                      state   <= stateWRREADREQ;
                   end

               //
               // stateWRREADREQ:
               //   This state is part of the read cycle on RPW cycles.  This
               //   state waits for the KS10 to acknowledge the read request.
               //

               stateWRREADREQ:
                 begin
                    if (busACKI)
                      begin
                         if (busADDRO[34])
                           busDATAO <= {busDATAI[0:17], busDATAO[18:35]};
                         else
                           busDATAO <= {busDATAO[0:17], busDATAI[18:35]};
                         state <= stateWRPAUSE;
                      end
                    else
                      busREQO <= 1;
                 end

               //
               // stateWRPAUSE
               //   This is the pause state of a the RPW cycle.
               //

               stateWRPAUSE:
                 begin
                    busADDRO <= {wrFLAGS, busADDRO[18:35]};
                    state    <= stateWRWAIT;
                 end

               //
               // stateWRWAIT:
               //   This state is used on various types of single cycle write
               //   cycles and on the write cycle of a RPW cycle.  This state
               //   asserts the busREQO output for the write request.
               //

               stateWRWAIT:
                 if (!busIO)
                   begin
                      busREQO <= 1;
                      state   <= stateWRREQ;
                   end

               //
               // stateWRREQ
               //   This state is used on various types of single cycle write
               //   cycles and on the second cycle of a RPW cycle.  This state
               //   waits for the KS10 to acknowledge the write request.  ACK
               //   device requests as completed.
               //

               stateWRREQ:
                 begin
                    if (busACKI)
                      begin
                         if (req == reqDEV1)
                           begin
                              dev1ACKO <= 1;
                              busDATAO <= dev1DATAI;
                           end
                         else if (req == reqDEV2)
                           begin
                              dev2ACKO <= 1;
                              busDATAO <= dev2DATAI;
                           end
                         state <= stateWRDONE;
                      end
                    else
                      busREQO <= 1;
                 end

               //
               // stateWRDONE:
               //  Wait for write to complete.
               //

               stateWRDONE:
                 state <= stateIDLE;

               //
               // stateRDADDRWAIT:
               //   This state is used on a loopback read NPR cycle.   The
               //   loopback address should have propagated through the UBA
               //   Paging memory.
               //

               stateRDADDRWAIT:
                 state <= stateRDWAIT;

               //
               // stateRDWAIT:
               //   This state is used on a loopback read NPR cycle.  This
               //   state asserts the busREQO output for the read request.
               //

               stateRDWAIT:
                 if (!busIO)
                   begin
                      busREQO <= 1;
                      state   <= stateRDREQ;
                   end

               //
               // stateRDREQ:
               //   This state is used on a loopback read NPR cycle.  This
               //   stage waits for the KS10 to acknowledge the read request
               //   and the acknowledges the selected device.
               //

               stateRDREQ:
                 begin
                    if (busACKI)
                      begin
                         if (req == reqDEV1)
                           begin
                              dev1ACKO <= 1;
                           end
                         else if (req == reqDEV2)
                           begin
                              dev2ACKO <= 1;
                           end
                         loopACKO <= 1;
                         state <= stateRDDONE;
                      end
                    else
                      busREQO <= 1;
                 end

               //
               // stateRDDONE:
               //  Wait for read to complete.
               //

               stateRDDONE:
                 state <= stateIDLE;

             endcase
          end
     end

endmodule
