////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   LP20 Controller State Machine
//
// Details
//   The module implements the LP20 Controller
//
// File
//   lpctrl.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2016 Rob Doyle
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

`include "lpcsra.vh"

module LPCTRL (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire [ 1: 0] lpMODE,               // Mode
      input  wire         lpCMDGO,              // Go Command

      output wire         lpINCBAR,             // Increment bus address register
      output wire [15: 0] regCSRB               // CSRA Output
   );

   //
   // Translation RAM
   //

/*
   reg [14:0] RAM[0:asdf];
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          ;
        else
          begin
             if (wr)
               RAM[wr_addr] <= data;
          end
     end

   ODATA <= RAM[rd_ptr];
*/

   //
   // State Definition
   //

   localparam [4:0] stateIDLE       =  0,       // Idle
                    stateOFFSET     =  1;       //

   //
   // State Machine
   //

   reg [4:0] state;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             state <= stateIDLE;
          end
        else
          begin
             if (0)
               begin
               end
             else
               begin
                  case (state)
                    stateIDLE:
                      begin
                         if (lpCMDGO)
                           case (lpMODE)
                             `lpCSRA_MODE_PRINT:
                               begin
                               end
                             `lpCSRA_MODE_TEST:
                               begin
                               end
                             `lpCSRA_MODE_DAVFU:
                               begin
                               end
                             `lpCSRA_MODE_RAM:
                               begin
                               end
                           endcase
                      end
                  endcase
               end
          end
     end

endmodule
