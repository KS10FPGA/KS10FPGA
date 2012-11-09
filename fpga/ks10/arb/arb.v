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

module ARB(memACK,  memDATA,
           consACK, consDATA,
           ubaACK,  ubaDATA,
           arbACK,  arbDATA);
   
   input         memACK;
   output [0:35] memDATA;
   input         consACK;
   output [0:35] consDATA;
   input         ubaACK;
   output [0:35] ubaDATA;
   output        arbACK;
   output [0:35] arbDATA;
   
   assign arbDATA = memACK ? memDATA :
                    ubaACK ? ubaDATA :
                    consDATA;

   assign arbACK = memACK | ubaACK | consACK;

endmodule
