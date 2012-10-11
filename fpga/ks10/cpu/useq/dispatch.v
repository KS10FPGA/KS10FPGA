////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      Microcontroller Dispatch Logic
//!
//! \details
//!
//! \todo
//!
//! \file
//!      disp.v
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

`include "crom.vh"

module DISPATCH(crom, disp_diag, disp_ret, disp_j, disp_aread,
                disp_mul, disp_pf, disp_ni, disp_byte, disp_ea, disp_scad,
                disp_addr);

   parameter  cromWidth = `CROM_WIDTH;

   input      [0:cromWidth-1] crom; 		// Control ROM Data
   input      [0:11]          disp_diag;	// Diagnostic dispatch
   input      [0:11]          disp_ret; 	// Microcode return dispatch
   input      [0: 7]          disp_j; 		// Jump dispatch
   input      [0: 7]          disp_aread; 	// Address Read dispatch
   input      [8:11]          disp_mul;     	// Multiply Dispatch
   input      [8:11]          disp_pf;      	// Page Fail Dispatch
   input      [8:11]          disp_ni;      	// Next Instruction Dispatch
   input      [8:11]          disp_byte;    	// Byte Size/Position Dispatch
   input      [8:11]          disp_ea;      	// Effective Address Mode Dispatch
   input      [8:11]          disp_scad;    	// SCAD Dispatch
   output reg [0:11]          disp_addr;    	// Dispatch Addr
   
   //
   // Control ROM Dispatch Address
   //
   
   wire disp_en_10 = `cromDISP_EN_10;
   wire disp_en_20 = `cromDISP_EN_20;
   wire disp_selh  = `cromDISP_SELH;
   wire disp_sel   = `cromDISP_SEL;
       
   always @(disp_diag or disp_ret or disp_j or disp_aread or
            disp_mul or disp_pf or disp_ni or disp_byte or disp_ea or
            disp_scad or disp_en_20 or disp_en_10 or disp_sel or disp_selh)
     begin
        
        disp_addr[0:11] = 12'b000_000_000_000;

        //
        // CROM Address Mux MSBs
        //  CRA1/E69
        //  CRA1/E68
        //  CRA1/E151
        //  CRA1/E138
        //
        
        if (disp_en_20)
          begin
             case (disp_selh)
               `cromDISP_SELH_DIAG:
                 disp_addr[0:7] = disp_diag[0:7];
               `cromDISP_SELH_RET:
                 disp_addr[0:7] = disp_ret[0:7];
               `cromDISP_SELH_J:
                 disp_addr[0:7] = disp_j[0:7];
               `cromDISP_SELH_AREAD:
                 disp_addr[0:7] = disp_aread[0:7];
             endcase
          end

        //
        // CROM Address Mux LSBs
        //  CRA1/E158
        //  CRA1/E170
        //  CRA1/E171
        //  CRA1/E182
        //
        
        if (disp_en_10)
          begin
             case (disp_sel)
               `cromDISP_SEL_DIAG:
                 disp_addr[8:11] = disp_diag[8:11];
               `cromDISP_SEL_RET:
                 disp_addr[8:11] = disp_ret[8:11];
               `cromDISP_SEL_MULTIPLY:
                 disp_addr[8:11] = disp_mul[8:11];
               `cromDISP_SEL_PAGEFAIL:
                 disp_addr[8:11] = disp_pf[8:11];
               `cromDISP_SEL_NICOND:
                 disp_addr[8:11] = disp_ni[8:11];
               `cromDISP_SEL_BYTE:
                 disp_addr[8:11] = disp_byte[8:11];
               `cromDISP_SEL_EAMODE:
                 disp_addr[8:11] = disp_ea[8:11];               
               `cromDISP_SEL_SCAD:
                 disp_addr[8:11] = disp_scad[8:11];
             endcase
          end
     end
   
endmodule
