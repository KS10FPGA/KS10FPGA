////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//  Generic UART Transmitter
//
// Details
//   The UART Transmitter is hard configured for:
//   - 8 data bits
//   - no parity
//   - 1 stop bit
//
//   To transmit a word of data, provide the data on the data
//   bus and assert the 'load' input for a clock cycle.  When
//   the data is sent, the 'intr' output will be asserted for
//   a single clock cycle.
//
// Note
//   This UART primitive transmitter is kept simple ntentionally and
//   is therefore unbuffered.  If you require a double buffered UART,
//   then you will need to layer a set of buffers on top of this
//   device.
//
// File
//   uart_tx.vhd
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2009, 2010, 2011, 2012 Rob Doyle
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

module UART_TX(clk, rst, clkBR, load, intr, data, txd);

   input        clk;                    // Clock
   input        rst;                    // Reset
   input        clkBR;                  // Clock Enable from BRG
   input  [7:0] data;                   // Transmitter Data
   input        load;                   // Load Transmitter
   output       intr;                   // Data ready
   output       txd;                    // Transmitter Serial Data

   //
   // State machine states
   //

   parameter [3:0] stateIDLE  =  0,     // Idle
                   stateSTART =  1,     // Working on Start Bit
                   stateBIT0  =  2,     // Working on Bit 7
                   stateBIT1  =  3,     // Working on Bit 6
                   stateBIT2  =  4,     // Working on Bit 5
                   stateBIT3  =  5,     // Working on Bit 4
                   stateBIT4  =  6,     // Working on Bit 3
                   stateBIT5  =  7,     // Working on Bit 2
                   stateBIT6  =  8,     // Working on Bit 1
                   stateBIT7  =  9,     // Working on Bit 0
                   stateSTOP  = 10,     // Working on Stop Bit
                   stateDONE  = 11;     // Generate Interrupt
   
    //
    // UART Transmitter:
    //
    //  The clkBR is 16 clocks per bit.  The UART transmits LSB first.
    // 
    //  When the load input is asserted, the data is loaded into the
    //  Transmit Register and the state machine is started.
    //
    //  Once the state machine is started, it proceeds as follows:
    //
    //    - Send Start Bit, then
    //    - Send bit 7 (LSB)
    //    - Send bit 6
    //    - Send bit 5
    //    - Send bit 4
    //    - Send bit 3
    //    - Send bit 2
    //    - Send bit 1
    //    - Send bit 0 (MSB)
    //    - Send Stop Bit 1
    //    - Trigger Interrupt output
    //

   reg [3:0] state;
   reg [7:0] txREG;
   reg [3:0] brdiv;

   always @(posedge clk or posedge rst)
     begin

        if (rst)

          begin
             state <= stateIDLE;
             txREG <= 0;
             brdiv <= 0;
          end

        else

          case (state)
            
            //
            // Transmitter is Idle
            //
            
            stateIDLE:
              if (load)
                begin
                   brdiv <= 15;
                   txREG <= data;
                   state <= stateSTART;
                end
            
            //
            // Transmit Start Bit
            //

            stateSTART:
              if (clkBR)
                if (brdiv == 0)
                  begin
                     brdiv <= 15;
                     state <= stateBIT0;
                  end
                else
                  brdiv <= brdiv - 1'b1;
 
            //
            // Transmit Bit 0 (LSB)
            //

            stateBIT0:
              if (clkBR)
                if (brdiv == 0)
                  begin
                     brdiv <= 15;
                     state <= stateBIT1;
                  end
                else
                  brdiv <= brdiv - 1'b1;
            
            //
            // Transmit Bit 1
            //

            stateBIT1:
              if (clkBR)
                if (brdiv == 0)
                  begin
                     brdiv <= 15;
                     state <= stateBIT2;
                  end
                else
                  brdiv <= brdiv - 1'b1;
 
            //
            // Transmit Bit 2
            //

            stateBIT2:
              if (clkBR)
                if (brdiv == 0)
                  begin
                     brdiv <= 15;
                     state <= stateBIT3;
                  end
                else
                  brdiv <= brdiv - 1'b1;

            //
            // Transmit Bit 3
            //

            stateBIT3:
              if (clkBR)
                if (brdiv == 0)
                  begin
                     brdiv <= 15;
                     state <= stateBIT4;
                  end
                else
                  brdiv <= brdiv - 1'b1;
 
            //
            // Transmit Bit 4
            //

            stateBIT4:
              if (clkBR)
                if (brdiv == 0)
                  begin
                     brdiv <= 15;
                     state <= stateBIT5;
                  end
                else
                  brdiv <= brdiv - 1'b1;
               
            //
            // Transmit Bit 5
            //

            stateBIT5:
              if (clkBR)
                if (brdiv == 0)
                  begin
                     brdiv <= 15;
                     state <= stateBIT6;
                  end
                else
                  brdiv <= brdiv - 1'b1;
            
            //
            // Transmit Bit 6
            //

            stateBIT6:
              if (clkBR)
                if (brdiv == 0)
                  begin
                     brdiv <= 15;
                     state <= stateBIT7;
                  end
                else
                  brdiv <= brdiv - 1'b1;
  
            //
            // Transmit Bit 7 (MSB)
            //

            stateBIT7:
              if (clkBR)
                if (brdiv == 0)
                  begin
                     brdiv <= 15;
                     state <= stateSTOP;
                  end
                else
                  brdiv <= brdiv - 1'b1;
 
            //
            // Transmit Stop Bit
            //

            stateSTOP:
              if (clkBR)
                if (brdiv == 0)
                  state <= stateDONE;
                else
                  brdiv <= brdiv - 1'b1;
 
            //
            // Generate Interrupt
            //

            stateDONE:
              state <= stateIDLE;

            //
            // Everything else
            //

            default:
              state <= stateIDLE;
             
          endcase
     end

   //
   // Data selector for TXD
   //

   reg txdata;
   always @(state or txREG)
     begin
        case (state)
          stateSTART : txdata = 0;
          stateBIT0  : txdata = txREG[0];
          stateBIT1  : txdata = txREG[1];
          stateBIT2  : txdata = txREG[2];
          stateBIT3  : txdata = txREG[3];
          stateBIT4  : txdata = txREG[4];
          stateBIT5  : txdata = txREG[5];
          stateBIT6  : txdata = txREG[6];
          stateBIT7  : txdata = txREG[7];
          default    : txdata = 1;
        endcase
     end

   //
   // Interrupt
   //
   
   assign intr = (state == stateDONE);
   assign txd  = txdata;
   
endmodule
