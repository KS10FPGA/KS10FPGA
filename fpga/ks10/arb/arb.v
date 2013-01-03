////////////////////////////////////////////////////////////////////
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
////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2012 Rob Doyle
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

`include "../cpu/vma.vh"

module ARB(cpuREQI,  cpuACKO,  cpuADDRI, cpuDATAI, cpuDATAO,
           cslREQI,  cslREQO,  cslACKI,  cslACKO,  cslADDRI, cslDATAI, cslDATAO,
           ubaREQO,  ubaDATAO,
           uba1REQI, uba1ACKI, uba1ACKO, uba1ADDRI, uba1DATAI,
           uba3REQI, uba3ACKI, uba3ACKO, uba3ADDRI, uba3DATAI,
           memREQO,  memACKI,  memDATAI, memDATAO,
           arbADDRO);

   input         cpuREQI;       // CPU Bus Request
   output        cpuACKO;       // CPU Bus Acknowledge
   input  [0:35] cpuADDRI;      // CPU Address
   input  [0:35] cpuDATAI;      // CPU Data In
   output [0:35] cpuDATAO;      // CPU Data Out

   input         cslREQI;       // CSL Bus Request In
   output        cslREQO;       // CSL Bus Request Out
   input         cslACKI;       // CSL Bus Acknowledge In
   output        cslACKO;       // CSL Bus Acknowledge Out
   input  [0:35] cslADDRI;      // CSL Address In
   input  [0:35] cslDATAI;      // CSL Data In
   output [0:35] cslDATAO;      // CSL Data Out

   output        ubaREQO;       // UBA Bus Request Out
   output [0:35] ubaDATAO;      // UBA Data Out

   input         uba1REQI;      // UBA1 Bus RequestIn
   input         uba1ACKI;      // UBA1 Bus Acknowledge In
   input  [0:35] uba1ADDRI;     // UBA1 Address In
   input  [0:35] uba1DATAI;     // UBA1 Data In
   output        uba1ACKO;      // UBA1 Bus Acknowledge Out

   input         uba3REQI;      // UBA3 Bus RequestIn
   input         uba3ACKI;      // UBA3 Bus Acknowledge In
   input  [0:35] uba3ADDRI;     // UBA3 Address In
   input  [0:35] uba3DATAI;     // UBA3 Data In
   output        uba3ACKO;      // UBA3 Bus Acknowledge Out

   output        memREQO;       // MEM Bus Request Out
   input         memACKI;       // MEM Bus Acknowledge In
   input  [0:35] memDATAI;      // MEM Data In
   output [0:35] memDATAO;      // MEM Data Out

   output [0:35] arbADDRO;      // ARB Address

   //
   // Bus Address Flags
   //

   wire vmaPHYSICAL    = `vmaPHYSICAL(cpuADDRI);
   wire vmaIOCYCLE     = `vmaIOCYCLE(cpuADDRI);
   wire vmaVECTORCYCLE = `vmaVECTORCYCLE(cpuADDRI);
   wire vmaWRUCYCLE    = `vmaWRUCYCLE(cpuADDRI);
   
   //
   // Bus Request Arbitration
   //
   // Details:
   //  Console has highest priority
   //  Unibus has next priority
   //  CPU has lowest priority
   //

   reg cpuACKO;
   reg cslACKO;
   reg cslREQO;
   reg memREQO;
   reg ubaREQO;
   reg uba1ACKO;
   reg uba3ACKO;
   reg [0:35] cslDATAO;
   reg [0:35] cpuDATAO;
   reg [0:35] memDATAO;
   reg [0:35] ubaDATAO;
   reg [0:35] arbADDRO;

   always @(cpuREQI  or cpuADDRI  or cpuDATAI  or cpuDATAO  or
            cslREQI  or cslACKI   or cslADDRI  or cslDATAI  or
            uba1REQI or uba1ACKI  or uba1ADDRI or uba1DATAI or
            uba3REQI or uba3ACKI  or uba3ADDRI or uba3DATAI or
            memACKI  or memDATAI)

     begin

        cpuACKO  = 1'b0;
        cslREQO  = 1'b0;
        cslACKO  = 1'b0;
        ubaREQO = 1'b0;
        uba1ACKO = 1'b0;
        uba3ACKO = 1'b0;
        memREQO  = 1'b0;
        arbADDRO = 36'bx;
        cslDATAO = 36'bx;
        cpuDATAO = 36'bx;
        memDATAO = 36'bx;
        ubaDATAO = 36'bx;
        arbADDRO = 36'bx;

        //
        // Bus Request from the Console
        //
        // Details
        //  The console can access the memory or the unibus
        //

        if (cslREQI)
          begin
             cpuACKO  = 1'b0;
             cslREQO  = 1'b0;
             ubaREQO  = 1'b1;
             uba1ACKO = 1'b0;
             uba3ACKO = 1'b0;
             memREQO  = 1'b1;
             arbADDRO = cslADDRI;
             cpuDATAO = cslDATAI;
             memDATAO = cslDATAI;
             ubaDATAO = cslDATAI;
             if (memACKI)
               begin
                  cslACKO  = 1'b1;
                  cslDATAO = memDATAI;
               end
             else if (uba1ACKI)
               begin
                  cslACKO  = 1'b1;
                  cslDATAO = uba1DATAI;
               end
             else if (uba3ACKI)
               begin
                  cslACKO  = 1'b1;
                  cslDATAO = uba3DATAI;
               end
             else
               begin
                  cslACKO  = 1'b0;
                  cslDATAO = 36'bx;
               end
          end

        //
        // Bus Request from the Unibus #1
        //
        // Details
        //  The unibus can access the memory
        //

        else if (uba1REQI)
          begin
             cpuACKO  = 1'b0;
             cslREQO  = 1'b0;
             cslACKO  = 1'b0;
             ubaREQO  = 1'b0;
             memREQO  = 1'b1;
             arbADDRO = uba1ADDRI;
             cslDATAO = uba1DATAI;
             cpuDATAO = uba1DATAI;
             memDATAO = uba1DATAI;
             if (memACKI)
               begin
                  uba1ACKO = 1'b1;
                  ubaDATAO = memDATAI;
               end
             else
               begin
                  uba1ACKO  = 1'b0;
                  ubaDATAO = 36'bx;
               end
          end

        //
        // Bus Request from the Unibus #3
        //
        // Details
        //  The unibus can access the memory
        //

        else if (uba3REQI)
          begin
             cpuACKO  = 1'b0;
             cslREQO  = 1'b0;
             cslACKO  = 1'b0;
             ubaREQO  = 1'b0;
             memREQO  = 1'b1;
             arbADDRO = uba3ADDRI;
             cslDATAO = uba3DATAI;
             cpuDATAO = uba3DATAI;
             memDATAO = uba3DATAI;
             if (memACKI)
               begin
                  uba3ACKO = 1'b1;
                  ubaDATAO = memDATAI;
               end
             else
               begin
                  uba3ACKO  = 1'b0;
                  ubaDATAO = 36'bx;
               end
          end

        //
        // Bus Request from the CPU
        //
        // Details
        //  The CPU can access the memory, unibus or
        //  console.
        //

        else if (cpuREQI)
          begin
             cslREQO  = 1'b1;
             cslACKO  = 1'b0;
             ubaREQO  = 1'b1;
             uba1ACKO = 1'b0;
             uba3ACKO = 1'b0;
             memREQO  = 1'b1;
             arbADDRO = cpuADDRI;
             cslDATAO = cpuDATAI;
             memDATAO = cpuDATAI;
             ubaDATAO = cpuDATAI;

             if (memACKI)
               begin
                  cpuACKO  = 1'b1;
                  cpuDATAO = memDATAI;
               end
             else if (uba1ACKI)
               begin
                  cpuACKO  = 1'b1;
                  cpuDATAO = uba1DATAI;
               end
             else if (uba3ACKI)
               begin
                  cpuACKO  = 1'b1;
                  cpuDATAO = uba3DATAI;
               end
             else if (cslACKI)
               begin
                  cpuACKO  = 1'b1;
                  cpuDATAO = cslDATAI;
               end
             
             //
             // Ack an otherwise un-acked WRU cycle
             // WRU Cycles really aren't arbitrated.
             //
             
             else if (vmaPHYSICAL & vmaIOCYCLE & vmaWRUCYCLE)
               begin
                  cpuACKO  = 1'b1;
                  cpuDATAO = 36'b0;
               end

	     //
	     // Everything else
	     //
	     
             else
               begin
                  cpuACKO  = 1'b0;
                  cpuDATAO = 36'bx;
               end
          end
     end

endmodule
