////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      KS10 Bus Arbiter
//!
//! \details
//!      This device is the KS10 Bus Arbiter and Bus Multiplexer
//!
//! \todo
//!
//! \file
//!      arb.v
//!
//! \author
//!      Rob Doyle - doyle (at) cox (dot) net
//!
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
//
// Comments are formatted for doxygen
//

module ARB(cpuREQI,  cpuACKO,  cpuADDRI, cpuDATAI, cpuDATAO,
           conREQI,  conREQO,  conACKI,  conACKO,  conADDRI, conDATAI, conDATAO,
           ubaREQI,  ubaREQO,  ubaACKI,  ubaACKO,  ubaADDRI, ubaDATAI, ubaDATAO,
           memREQO,  memACKI,  memDATAI, memDATAO,
           arbADDRO);
   
   input         cpuREQI;	// CPU Bus Request
   output        cpuACKO;	// CPU Bus Acknowledge
   input  [0:35] cpuADDRI;	// CPU Address
   input  [0:35] cpuDATAI;	// CPU Data In
   output [0:35] cpuDATAO;	// CPU Data Out
        
   input         conREQI;	// CON Bus Request In
   output        conREQO;	// CON Bus Request Out
   input	 conACKI;     	// CON Bus Acknowledge In
   output        conACKO;	// CON Bus Acknowledge Out
   input  [0:35] conADDRI;	// CON Address In
   input  [0:35] conDATAI;	// CON Data In
   output [0:35] conDATAO;	// CON Data Out
        
   input         ubaREQI;	// UBA Bus RequestIn
   output        ubaREQO;	// UBA Bus Request Out
   input	 ubaACKI;     	// UBA Bus Acknowledge In
   output        ubaACKO;	// UBA Bus Acknowledge Out
   input  [0:35] ubaADDRI;	// UBA Address In
   input  [0:35] ubaDATAI;	// UBA Data In
   output [0:35] ubaDATAO;	// UBA Data Out

   output	 memREQO;	// MEM Bus Request Out
   input         memACKI;	// MEM Bus Acknowledge In
   input  [0:35] memDATAI;	// MEM Data In
   output [0:35] memDATAO;	// MEM Data Out

   output [0:35] arbADDRO;	// ARB Address
   
   //
   // Bus Request Arbitration
   //
   // Details:
   //  Console has highest priority
   //  Unibus has next priority
   //  CPU has lowest priority
   //
   
   reg cpuACKO;
   reg conACKO;
   reg conREQO;
   reg memREQO;
   reg ubaREQO;
   reg ubaACKO;
   reg [0:35] conDATAO;
   reg [0:35] cpuDATAO;
   reg [0:35] memDATAO;
   reg [0:35] ubaDATAO;
   reg [0:35] arbADDRO;
   
   always @(cpuREQI or cpuADDRI or cpuDATAI or cpuDATAO or
            conREQI or conACKI  or conADDRI or conDATAI or 
            ubaREQI or ubaACKI  or ubaADDRI or ubaDATAI or
            memACKI or memDATAI)

     begin

        cpuACKO  = 1'b0;
        conREQO  = 1'b0;
        conACKO  = 1'b0;
        ubaREQO  = 1'b0;
        ubaACKO  = 1'b0;
        memREQO  = 1'b0;
        arbADDRO = 36'bx;
        conDATAO = 36'bx;
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
        
        if (conREQI)
          begin
             cpuACKO  = 1'b0;
             conREQO  = 1'b0;
             ubaREQO  = 1'b1;
             ubaACKO  = 1'b0;
             memREQO  = 1'b1;
             arbADDRO = conADDRI;
             if (memACKI)
               begin
                  conACKO  = 1'b1;
                  conDATAO = memDATAI;
                  cpuDATAO = 36'bx;
                  memDATAO = conDATAI;
                  ubaDATAO = 36'bx;
               end
             else if (ubaACKI)
               begin
                  conACKO  = 1'b1;
                  conDATAO = ubaDATAI;
                  cpuDATAO = 36'bx;
                  memDATAO = 36'bx;
                  ubaDATAO = conDATAI;
               end
             else
               begin
                  conACKO  = 1'b0;
                  conDATAO = 36'bx;
                  cpuDATAO = 36'bx;
                  memDATAO = 36'bx;
                  ubaDATAO = 36'bx;
               end
          end

        //
        // Bus Request from the Unibus
        //
        // Details
        //  The unibus can access the memory
        //
        
        else if (ubaREQI)
          begin
             cpuACKO  = 1'b0;
             conREQO  = 1'b0;
             conACKO  = 1'b0;
             ubaREQO  = 1'b0;
             memREQO  = 1'b1;
             arbADDRO = ubaADDRI;
             if (memACKI)
               begin
                  ubaACKO  = 1'b1;
                  conDATAO = 36'bx;
                  cpuDATAO = 36'bx;
                  memDATAO = ubaDATAI;
                  ubaDATAO = memDATAI;
               end
             else
               begin
                  ubaACKO  = 1'b0;
                  conDATAO = 36'bx;
                  cpuDATAO = 36'bx;
                  memDATAO = 36'bx;
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
             conREQO  = 1'b1;
             conACKO  = 1'b0;
             ubaREQO  = 1'b1;
             ubaACKO  = 1'b0;
             memREQO  = 1'b1;
             arbADDRO = cpuADDRI;
             if (memACKI)
               begin
                  cpuACKO  = 1'b1;
                  conDATAO = 36'bx;
                  cpuDATAO = memDATAI;
                  memDATAO = cpuDATAI;
                  ubaDATAO = 36'bx;
               end
             else if (ubaACKI)
               begin
                  cpuACKO  = 1'b1;
                  conDATAO = 36'bx;
                  cpuDATAO = ubaDATAI;
                  memDATAO = 36'bx;
                  ubaDATAO = cpuDATAI;
               end
             else if (conACKI)
               begin
                  cpuACKO  = 1'b1;
                  conDATAO = cpuDATAO;
                  cpuDATAO = conDATAI;
                  memDATAO = 36'bx;
                  ubaDATAO = 36'bx;
               end
             else
               begin
                  ubaACKO  = 1'b0;
                  conDATAO = 36'bx;
                  cpuDATAO = 36'bx;
                  memDATAO = 36'bx;
                  ubaDATAO = 36'bx;
               end
          end
     end
   
endmodule
