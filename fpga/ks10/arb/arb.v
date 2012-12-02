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
           cslREQI,  cslREQO,  cslACKI,  cslACKO,  cslADDRI, cslDATAI, cslDATAO,
           ubaREQI,  ubaREQO,  ubaACKI,  ubaACKO,  ubaADDRI, ubaDATAI, ubaDATAO,
           memREQO,  memACKI,  memDATAI, memDATAO,
           arbADDRO);
   
   input         cpuREQI;	// CPU Bus Request
   output        cpuACKO;	// CPU Bus Acknowledge
   input  [0:35] cpuADDRI;	// CPU Address
   input  [0:35] cpuDATAI;	// CPU Data In
   output [0:35] cpuDATAO;	// CPU Data Out
        
   input         cslREQI;	// CSL Bus Request In
   output        cslREQO;	// CSL Bus Request Out
   input	 cslACKI;     	// CSL Bus Acknowledge In
   output        cslACKO;	// CSL Bus Acknowledge Out
   input  [0:35] cslADDRI;	// CSL Address In
   input  [0:35] cslDATAI;	// CSL Data In
   output [0:35] cslDATAO;	// CSL Data Out
        
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
   reg cslACKO;
   reg cslREQO;
   reg memREQO;
   reg ubaREQO;
   reg ubaACKO;
   reg [0:35] cslDATAO;
   reg [0:35] cpuDATAO;
   reg [0:35] memDATAO;
   reg [0:35] ubaDATAO;
   reg [0:35] arbADDRO;
   
   always @(cpuREQI or cpuADDRI or cpuDATAI or cpuDATAO or
            cslREQI or cslACKI  or cslADDRI or cslDATAI or 
            ubaREQI or ubaACKI  or ubaADDRI or ubaDATAI or
            memACKI or memDATAI)

     begin

        cpuACKO  = 1'b0;
        cslREQO  = 1'b0;
        cslACKO  = 1'b0;
        ubaREQO  = 1'b0;
        ubaACKO  = 1'b0;
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
             ubaACKO  = 1'b0;
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
             else if (ubaACKI)
               begin
                  cslACKO  = 1'b1;
                  cslDATAO = ubaDATAI;
               end
             else
               begin
                  cslACKO  = 1'b0;
                  cslDATAO = 36'bx;
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
             cslREQO  = 1'b0;
             cslACKO  = 1'b0;
             ubaREQO  = 1'b0;
             memREQO  = 1'b1;
             arbADDRO = ubaADDRI;
             cslDATAO = ubaDATAI;
             cpuDATAO = ubaDATAI;
             memDATAO = ubaDATAI;
             if (memACKI)
               begin
                  ubaACKO  = 1'b1;
                  ubaDATAO = memDATAI;
               end
             else
               begin
                  ubaACKO  = 1'b0;
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
             ubaACKO  = 1'b0;
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
             else if (ubaACKI)
               begin
                  cpuACKO  = 1'b1;
                  cpuDATAO = ubaDATAI;
               end
             else if (cslACKI)
               begin
                  cpuACKO  = 1'b1;
                  cpuDATAO = cslDATAI;
               end
             else
               begin
                  cpuACKO  = 1'b0;
                  cpuDATAO = 36'bx;
               end
          end
     end
   
endmodule
