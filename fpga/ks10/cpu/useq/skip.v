////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      Microcontroller Skip Logic
//!
//! \details
//!      This section of the microcontroller controls the SKIP
//!      field selection.
//!
//!      The microcontroller can execute simple branches based
//!      on a selected boolean input value.  Because the branch
//!      logic is implemented as an OR gate, the skip logic can
//!      only change the LSB of the control ROM address from a
//!      zero to a one - this means that the 'skip not taken'
//!      must be an even address and that the 'skip taken'
//!      address must be the following odd address.
//!
//!      The microcode assemler handles all the details regarding
//!      how microcode addresses are selected.
//!
//!      See the description of the dispatch logic and the
//!      microcontroller for addtional details.
//!
//! \file
//!      skip.v
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

`include "crom.vh"
`include "drom.vh"

module SKIP(crom, skip40, skip20, skip10, skipADDR);
   
   parameter cromWidth = `CROM_WIDTH;

   input  [0:cromWidth-1] crom; 	// Control ROM Data
   input  [1:7]           skip40;	// Skip 40 bits
   input  [1:7]           skip20;	// Skip 20 bits
   input  [1:7]           skip10;	// Skip 10 bits
   output [0:11]          skipADDR;	// Skip Address
   
   //
   // Control ROM Skip Address
   //
   // Details:
   //  A skip always advances the microsequencer program counter
   //  from an even address to the next odd address.
   //
   // Trace:
   //  DPEA/E38
   //  DPEA/E45
   //  CRA2/E85
   //
   
   reg skip;
   
   always @(`cromSKIP or skip40 or skip20 or skip10)
     begin
	
        skip = 1'b0;
        
        //
        // DPEA/E45
        //
        
        if (`cromSKIP_EN_40)
          begin
             case (`cromSKIP_SEL)
               3'b000:
                 skip = 1'b0;
               3'b001:
                 skip = skip40[1];
               3'b010:
                 skip = skip40[2];
               3'b011:
                 skip = skip40[3];
               3'b100:
                 skip = skip40[4];
               3'b101:
                 skip = skip40[5];
               3'b110:
                 skip = skip40[6];
               3'b111:
                 skip = skip40[7];
             endcase
          end

        //
        // DPEA/E38
        //
        
        if (`cromSKIP_EN_20)
          begin
             case (`cromSKIP_SEL)
               3'b000:
                 skip = 1'b0;
               3'b001:
                 skip = skip20[1];
               3'b010:
                 skip = skip20[2];
               3'b011:
                 skip = skip20[3];
               3'b100:
                 skip = skip20[4];
               3'b101:
                 skip = skip20[5];
               3'b110:
                 skip = skip20[6];
               3'b111:
                 skip = skip20[7];
             endcase
          end

        //
        // CRA2/E85
        //
        
        if (`cromSKIP_EN_10)
          begin
             case (`cromSKIP_SEL)
               3'b000:
                 skip = 1'b0;
               3'b001:
                 skip = skip10[1];
               3'b010:
                 skip = skip10[2];
               3'b011:
                 skip = skip10[3];
               3'b100:
                 skip = skip10[4];
               3'b101:
                 skip = skip10[5];
               3'b110:
                 skip = skip10[6];
               3'b111:
                 skip = skip10[7];
             endcase
          end
     end

   //
   // Skip Address Generation
   //
   // Details:
   //  This generates the 12-bit skip address that is "OR"ed into
   //  the microsequencer address.
   //
   // Trace
   //  CRA1/E111
   //  CRA1/E121
   
   assign skipADDR = (skip) ? 12'b000_000_000_001 : 12'b000_000_000_000;
   
endmodule
