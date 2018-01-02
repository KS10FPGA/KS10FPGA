////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Generic unbuffered Synchronous Serial Transmitter
//
// Details
//   This module implements a genereric unbuffered synchronous serial
//   transmitter.  The module can optionally support zero-bit insertion.
//
//   All characters, including the abort character, are eight bits.
//
//   Data is sent LSB first.
//
// Note
//   This USRT primitive transmitter is kept simple intentionally and is
//   therefore unbuffered.  If you require a double buffered USRT, then you
//   will need to layer a set of buffers on top of this device.
//
//   This Synchronous Serial Transmitter is compatible with the DUP11.
//
// File
//   usrt_tx.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2009-2018 Rob Doyle
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

module USRT_TX (
      input  wire       clk,            // Clock
      input  wire       rst,            // Reset
      input  wire       clr,            // Clear
      input  wire       clken,          // Clock enable
      input  wire       abort,          // Abort character
      input  wire       flag,           // Flag character
      input  wire [7:0] data,           // Data
      input  wire       zbi,            // Stuff bits (zero bit insertion)
      input  wire       load,           // Load
      output reg        crcen,          // No asserted on stuffed zeros
      output wire       empty,          // Buffer empty
      output wire       last,           // Last bit
      output wire       txd             // Serial data
   );

   //
   // Special characters
   //

   parameter [7:0] charFLAG  = 8'b0111_1110,
                   charABORT = 8'b1111_1111;

   //
   // Transmit shift register
   //

   reg [7:0] txdat;

   //
   // Bit Stuff Counter
   //
   // This counts the number of consecutive ones in the data stream.
   //

   reg [2:0] count;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          count <= 0;
        else
          if (clr)
            count <= 0;
          else if (clken)
            if (!txdat[0])
              count <= 0;
            else
              count <= count + 1'b1;
     end

   //
   // Serial Transmitter Shift Register
   //
   // Data is sent LSB first.
   // Empty is aserted after the last bit is transmitted.
   //

   parameter [1:0] stateIDLE  = 0,
                   stateSEND  = 1,
                   stateDONE  = 2;

   reg [1:0] state;
   reg       txzbi;
   reg [2:0] txlen;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             crcen <= 1;
             txzbi <= 0;
             txlen <= 3'd7;
             txdat <= 0;
             state <= stateIDLE;
          end
        else
          if (clr)
            begin
               crcen <= 1;
               txzbi <= 0;
               txlen <= 3'd7;
               txdat <= 0;
               state <= stateIDLE;
            end
          else
            case (state)

              //
              // stateIDLE

              //
              // Wait for data
              //

              stateIDLE:
                if (load)
                  begin
                     if (abort)
                       begin
                          txzbi <= 0;
                          txdat <= charABORT;
                       end
                     else if (flag)
                       begin
                          txzbi <= 0;
                          txdat <= charFLAG;
                       end
                     else
                       begin
                          txzbi <= zbi;
                          txdat <= data;
                       end
                     txlen <= 3'd7;
                     state <= stateSEND;
                  end

              //
              // stateSEND
              //
              // Send data bits.  Stuff a zero bit, if necessary.
              //

              stateSEND:
                if (clken)
                  begin
                     if ((count == 4) & txdat[0] & txzbi)
                       begin
                          crcen    <= 0;
                          txdat[0] <= 0;
                       end
                     else
                       begin
                          crcen <= 1;
                          txlen <= txlen - 1'b1;
                          txdat <= {1'b0, txdat[7:1]};
                          if (txlen == 0)
                            state <= stateDONE;
                       end
                  end

              //
              // stateDONE
              //
              // Update status
              //

              stateDONE:
                state <= stateIDLE;

            endcase
     end

   //
   // Output status
   //

   assign empty = (state == stateIDLE) & !load;

   //
   // Output data
   //

   assign txd = txdat[0];

   //
   // Last bit of message
   //

   assign last = (txlen == 0);

endmodule
