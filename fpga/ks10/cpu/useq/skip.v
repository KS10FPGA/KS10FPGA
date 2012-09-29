////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      Microcontroller Skip Logic
//!
//! \details
//!
//! \todo
//!
//! \file
//!      skip.v
//!
//! \author
//!      Rob Doyle - doyle (at) cox (dot) net
//!
////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2009, 2012 Rob Doyle
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

`include "microcontroller.vh"

module SKIP(crom, skip_40, skip_20, skip_10, skip_addr);
   
   parameter cromWidth = `CROM_WIDTH;

   input  [0:7]           skip_40;
   input  [0:7]           skip_20;
   input  [0:7]           skip_10;
   input  [0:cromWidth-1] crom; 	// Control ROM Data
   output [0:11]          skip_addr;	// Skip Address
   
   //
   // Skip Mux
   //
   
   reg sk;
   always @(`cromSKIP or skip_40 or skip_20 or skip_10)
     begin
	
        sk = 1'b0;
        
        //
        // DPEA/E45
        //
        
        if (`cromSKIP_EN_40)
          begin
             case (`cromSKIP_SEL)
               3'b000:
                 sk = skip_40[0];
               3'b001:
                 sk = skip_40[1];
               3'b010:
                 sk = skip_40[2];
               3'b011:
                 sk = skip_40[3];
               3'b100:
                 sk = skip_40[4];
               3'b101:
                 sk = skip_40[5];
               3'b110:
                 sk = skip_40[6];
               3'b111:
                 sk = skip_40[7];
             endcase
          end

        //
        // DPEA/E38
        //
        
        if (`cromSKIP_EN_20)
          begin
             case (`cromSKIP_SEL)
               3'b000:
                 sk = skip_20[0];
               3'b001:
                 sk = skip_20[1];
               3'b010:
                 sk = skip_20[2];
               3'b011:
                 sk = skip_20[3];
               3'b100:
                 sk = skip_20[4];
               3'b101:
                 sk = skip_20[5];
               3'b110:
                 sk = skip_20[6];
               3'b111:
                 sk = skip_20[7];
             endcase
          end

        //
        // CRA2/E85
        //
        
        if (`cromSKIP_EN_10)
          begin
             case (`cromSKIP_SEL)
               3'b000:
                 sk = skip_10[0];
               3'b001:
                 sk = skip_10[1];
               3'b010:
                 sk = skip_10[2];
               3'b011:
                 sk = skip_10[3];
               3'b100:
                 sk = skip_10[4];
               3'b101:
                 sk = skip_10[5];
               3'b110:
                 sk = skip_10[6];
               3'b111:
                 sk = skip_10[7];
             endcase
          end
     end
   
   assign skip_addr = (sk) ? 12'b000_000_000_001 : 12'b000_000_000_000;
   
endmodule
