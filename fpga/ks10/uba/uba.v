////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      KS-10 Unibus Adapter
//!
//! \details
//!
//! \todo
//!
//! \file
//!      uba.v
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

module UBA(clk, clken, ubaINTR, curINTR_NUM,  
           busREQI, busREQO, busACKI, busACKO,
           busADDRI, busADDRO, busDATAI, busDATAO);

   input         clk;          	// Clock
   input         clken;        	// Clock enable
   input  [0: 2] curINTR_NUM;	// Current Interrupt Priority
   output [1: 7] ubaINTR;	// Unibus Interrupt Request
   input         busREQI;       // Unibus Request In
   output        busREQO;       // Unibus Request Out
   input         busACKI;       // Unibus Acknowledge In
   output        busACKO;       // Unibus Acknowledge Out
   input  [0:35] busADDRI;     	// Bus Address In
   output [0:35] busADDRO;      // Bus Address Out
   input  [0:35] busDATAI;      // Unibus Data In
   output [0:35] busDATAO;      // Unibus Data Out

   assign busREQO  = 1'b0;
   assign busACKO  = 1'b0;
   assign busADDRO = 36'bx;
   assign busDATAO = 36'bx;
   assign ubaINTR  = 7'b0;

endmodule
