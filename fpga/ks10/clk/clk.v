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
// Copyright (C) 2012-2013 Rob Doyle
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

module ESM_CLK(clkIn, rstIn, clkOut, rstOut, locked);

   input  clkIn;
   input  rstIn;
   output clkOut;
   output rstOut;
   output locked;

   //
   // Input buffer
   //

   wire bclkin;
   IBUFG clkin_buf (
       .I (clkIn),
       .O (bclkin)
   );

   //
   // PLL
   //

   wire clkfb;
   wire clk0;
   wire clkfx;

   DCM_SP #(
       .CLKDV_DIVIDE       (2.500),
       .CLKFX_DIVIDE       (5),
       .CLKFX_MULTIPLY     (2),
       .CLKIN_DIVIDE_BY_2  ("FALSE"),
       .CLKIN_PERIOD       (20.0),
       .CLKOUT_PHASE_SHIFT ("NONE"),
       .CLK_FEEDBACK       ("1X"),
       .DESKEW_ADJUST      ("SYSTEM_SYNCHRONOUS"),
       .PHASE_SHIFT        (0),
       .STARTUP_WAIT       ("FALSE")
   )
   dcm_sp_inst (
       .CLKIN              (bclkin),
       .CLKFB              (clkfb),
       .CLK0               (clk0),
       .CLK90              (),
       .CLK180             (),
       .CLK270             (),
       .CLK2X              (),
       .CLK2X180           (),
       .CLKFX              (clkfx),
       .CLKFX180           (),
       .CLKDV              (),
       .PSCLK              (1'b0),
       .PSEN               (1'b0),
       .PSINCDEC           (1'b0),
       .PSDONE             (),
       .LOCKED             (locked),
       .STATUS             (),
       .RST                (rstIn),
       .DSSEN              (1'b0)
   );

   //
   // Output buffers
   //

   BUFG clkf_buf (
       .I (clk0),
       .O (clkfb)
   );

   BUFG clkout_buf (
       .I (clkfx),
       .O (clkOut)
   );

   //
   // Synchronize rstOut to the new clock domain.
   //

   reg d0;
   reg d1;

   always @(posedge clkOut or posedge rstIn)
     begin
        if (rstIn)
          begin
             d0 <= 1;
             d1 <= 1;
          end
        else
          begin
             if (locked)
               begin
                  d0 <= 0;
                  d1 <= d0;
               end
             else
               begin
                  d0 <= 1;
                  d1 <= 1;
               end
          end
     end

   assign rstOut = d1;

endmodule
