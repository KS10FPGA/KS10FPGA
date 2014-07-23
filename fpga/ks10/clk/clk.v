////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Clock Divider
//
// Details
//   This divides the input clock frequency and synchronizes the reset input
//   to that clock.
//
// File
//   esm_clk.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2014 Rob Doyle
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

module ESM_CLK(clkIn, rstIn, clkOutT, clkOutR, clkT, ssramCLK, rstOut);

   input        clkIn;
   input        rstIn;
   output       clkOutT;
   output       clkOutR;
   output [1:4] clkT;
   output       ssramCLK;
   output       rstOut;

   //
   // Synchronize rstOut to the clock
   //

   reg [1:0] d;
   always @(posedge clkIn or posedge rstIn)
     begin
        if (rstIn)
          d[1:0] <= 2'b11;
        else
          d[1:0] <= {d[0], 1'b0};
     end

   assign rstOut = d[1];

   //
   // Clock Generator
   //

   parameter [0:1] stateT1 = 0,
                   stateT2 = 1,
                   stateT3 = 2,
                   stateT4 = 3;

   reg [0:1] clkState;
   reg [1:4] clkT;
   reg       clkOutT;
   reg       clkOutR;

   always @(posedge clkIn or posedge rstOut)
     begin
        if (rstIn)
          begin
             clkT[1]  <= 0;
             clkT[2]  <= 0;
             clkT[3]  <= 0;
             clkT[4]  <= 0;
             clkOutR  <= 0;
             clkOutT  <= 1;
             clkState <= stateT1;
          end
        else
          case (clkState)
            stateT1:
              begin
                 clkT[1]  <= 1;
                 clkT[2]  <= 0;
                 clkT[3]  <= 0;
                 clkT[4]  <= 0;
                 clkOutR  <= 0;
                 clkOutT  <= 1;
                 clkState <= stateT2;
              end
            stateT2:
              begin
                 clkT[1]  <= 0;
                 clkT[2]  <= 1;
                 clkT[3]  <= 0;
                 clkT[4]  <= 0;
                 clkOutR  <= 0;
                 clkOutT  <= 1;
                 clkState <= stateT3;
              end
            stateT3:
              begin
                 clkT[1]  <= 0;
                 clkT[2]  <= 0;
                 clkT[3]  <= 1;
                 clkT[4]  <= 0;
                 clkOutR  <= 1;
                 clkOutT  <= 0;
                 clkState <= stateT4;
              end
            stateT4:
              begin
                 clkT[1]  <= 0;
                 clkT[2]  <= 0;
                 clkT[3]  <= 0;
                 clkT[4]  <= 1;
                 clkOutR  <= 1;
                 clkOutT  <= 0;
                 clkState <= stateT1;
              end
            endcase
     end

   //
   // Funky clock forwarding circuit for the ssramCLK output
   // Spartan6 will give errors if you try to drive a clock output.
   //

   ODDR2 #(
       .DDR_ALIGNMENT   ("NONE"),       // Sets output alignment
       .INIT            (1'b0),         // Initial state of the Q output
       .SRTYPE          ("SYNC")        // Reset type: "SYNC" or "ASYNC"
   )
   iODDR2 (
       .Q               (ssramCLK),     // 1-bit DDR output data
       .C0              (~clkIn),       // 1-bit clock input
       .C1              (clkIn),        // 1-bit clock input
       .CE              (1'b1),         // 1-bit clock enable input
       .D0              (1'b1),         // 1-bit data input (associated with C0)
       .D1              (1'b0),         // 1-bit data input (associated with C1)
       .R               (1'b0),         // 1-bit reset input
       .S               (1'b0)          // 1-bit set input
   );

endmodule
