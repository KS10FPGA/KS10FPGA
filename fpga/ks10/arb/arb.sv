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
//   arb.v
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

module ARB (
      // CPU Interfaces
      input  wire        cpuREQI,       // CPU Bus Request
      output reg         cpuACKO,       // CPU Bus Acknowledge
      input  wire [0:35] cpuADDRI,      // CPU Address
      input  wire [0:35] cpuDATAI,      // CPU Data In
      output reg  [0:35] cpuDATAO,      // CPU Data Out
      // Console Interfaces
      input  wire        cslREQI,       // CSL Bus Request In
      output reg         cslREQO,       // CSL Bus Request Out
      input  wire        cslACKI,       // CSL Bus Acknowledge In
      output reg         cslACKO,       // CSL Bus Acknowledge Out
      input  wire [0:35] cslDATAI,      // CSL Data In
      output reg  [0:35] cslDATAO,      // CSL Data Out
      input  wire [0:35] cslADDRI,      // CSL Address In
      output reg  [0:35] cslADDRO,      // CSL Address Out
      // UBA Interfaces
      input  wire        ubaREQI[1:4],  // UBA Bus Request In
      output reg         ubaREQO[1:4],  // UBA Bus Request Out
      input  wire        ubaACKI[1:4],  // UBA Bus Acknowledge In
      output reg         ubaACKO[1:4],  // UBA Bus Acknowledge Out
      input  wire [0:35] ubaDATAI[1:4], // UBA Data In
      output reg  [0:35] ubaDATAO[1:4], // UBA Data Out
      input  wire [0:35] ubaADDRI[1:4], // UBA Address In
      output reg  [0:35] ubaADDRO[1:4], // UBA Address Out
      // Memory Interfaces
      output reg         memREQO,       // MEM Bus Request Out
      input  wire        memACKI,       // MEM Bus Acknowledge In
      input  wire [0:35] memDATAI,      // MEM Data In
      output reg  [0:35] memDATAO,      // MEM Data Out
      output reg  [0:35] memADDRO       // MEM Address Out
   );

   //
   // Bus Request Arbitration
   //
   // Details:
   //  Console has highest priority
   //  Unibus has next priority
   //  CPU has lowest priority
   //

   always @*
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

        if (cslREQI)
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

endmodule
