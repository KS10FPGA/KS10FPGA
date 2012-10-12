////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!	 Virtual Memory Address
//!
//! \details
//!
//! \todo
//!
//! \file
//!	 vma.v
//!
//! \author
//!	 Rob Doyle - doyle (at) cox (dot) net
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
// This source fiit under the terms of the GNU Lesser General
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

`include "microcontroller/crom.vh"
`include "microcontroller/drom.vh"

module FLAGS(clk, rst, clken, crom, drom, dp, cry0_flag, cry1_flag,
	     fov_flag, ov_flag, fxu_flag, user_flag, trap1_flag,
	     trap2_flag, nodiv_flag, pcu_flag, userio_flag);
	     
   parameter cromWidth = `CROM_WIDTH;
   parameter dromWidth = `DROM_WIDTH;
	     
   input		  clk;		// Clock
   input		  rst;		// Reset
   input		  clken;	// Clock Enable
   input  [0:cromWidth-1] crom;		// Control ROM Data
   input  [0:dromWidth-1] drom;		// Dispatch ROM Data
   input  [0:35]	  dp;		// Data path
   output reg		  cry0_flag;	//
   output reg		  cry1_flag;	//
   output reg		  fov_flag;	//
   output reg		  ov_flag;	//
   output reg		  fxu_flag;	//
   output reg		  user_flag;	//
   output reg		  trap1_flag;	//
   output reg		  trap2_flag;	//
   output reg		  nodiv_flag;	//
   output reg		  pcu_flag;	//
   output reg		  userio_flag;	//
   
	     
	     
   
endmodule
