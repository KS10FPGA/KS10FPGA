////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KS-10 Console
//
// Details
//
//   Console Instruction Register (Device 0, IO Address 0200000)
//
//       When the 'execute switch' is asserted at power-up the KS10
//       microcode performs a IO read of the Console Instruction
//       Register (regIR) at IO address o200000 and then executes
//       that instruction.
//
//       The Console Instruction Register is normally initialized
//       with a JRST instruction which causes the code to jump to
//       the entry point of the code/bootloader.
//
//       This mechanism allowes the Console set the address that
//       the KS10 began execution.
//
//       The JRST opcode is 0254.
//
//             0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17
//           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//     (LH)  |0 |1 |0 |1 |0 |1 |1 |0 |0 |0 |0 |0 |0 |0 |0 |0 |0 |0 |
//           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//
//            18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
//           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//     (RH)  |                     ADDRESS                         |
//           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//
//   Console Address Register:
//
//       The console can read from or write to KS10 memory and/or IO.
//       The address of the memory or IO location to be accessed is
//       placed in the Console Address Register prior to starting
//       the access.
//
//       The format of the Console Address Register during Memory
//       Operations is:
//
//             0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17
//           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//     (LH)  |0 |0 |0 |RD|0 |WR|0 |0 |0 |0 |0 |0 |0 |0 |0 |0 |Addr |
//           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//
//            18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
//           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//     (RH)  |                      Memory Address                 |
//           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//
//       The format of the Console Address Register during IO
//       Operations is:
//
//             0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17
//           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//     (LH)  |0 |0 |0 |RD|0 |WR|0 |0 |0 |0 |1 |0 |0 |0 |  DEV NO   |
//           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//
//            18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
//           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//     (RH)  |                     IO Address                      |
//           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//
//       Note: Bit 10 is asserted during IO operations and is
//       negated during Memory Operations.
//
//       Note: 20-bit addressing of memory is supported.
//
//   Console Data Register:
//
//       Data to be written to Memory or IO is placed in the Console
//       Data Register.   Similarly data that has been read from
//       from Memory or IO is placed in the Console Data Register.
//
//             0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17
//           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//     (LH)  |                      DATA                           |
//           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//
//            18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
//           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//     (RH)  |                      DATA                           |
//           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//
//    Console Memory Read Procedure
//
//       The KS10 memory is read using the following procedure:
//          1.  The memory address is written to the Console Address
//              Register.   The 'RD' bit should be asserted.  The 'WR'
//              bit and the 'IO' bit should be negated.
//          2.  After the Console Address Register initialized, the
//              'GO' bit of the Console Control/Status register should
//              be asserted.
//          3.  The state machine performs a read from memory and
//              places the results in the Console Data Register.  The
//              'GO' bit will remain asserted while the memory
//              transaction is active and will negate when the memory
//              transaction is completed.
//
//    Console Memory Write Procedure
//
//       The KS10 memory is written using the following procedure:
//          1.  The memory address is written to the Console Address
//              Register.   The 'RD' bit should be asserted.  The 'WR'
//              bit and the 'IO' bit should be negated.
//          2.  The data to be written to memory is written to the
//              Console Data Register.
//          3.  After the Console Address Register and Console Data
//              Register are both initialized, the 'GO' bit of the
//              Console Control/Status register should be asserted.
//          4.  The state machine performs a write to memory.  The
//              'GO' bit will remain asserted while the memory
//              transaction is active and will negate when the
//              memory transaction is completed.
//
//    Console IO Read and Write Procedure
//       Console IO operations are similar to Console Memory
//       operations except that the IO bit in the Console
//       Address Register must be asserted and the IO address
//       must include the IO Device Number - which may be zero.
//
//       Unibus IO Device Numbers are non-zero.  Unibus IO
//       addresses are limited to 16-bits and therefore
//       Unibus IO addresses bits 18 and 19 must be zero.
//
// File
//   csl.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
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

module CSL(clk, rst,
           cslREGADDR, cslREGDATI, cslREGDATO, cslREGIR,
           cslBUSY, cslNXM, cslGO,
           busREQI,  busREQO,  busACKI,  busACKO,
           busADDRI, busADDRO, busDATAI, busDATAO);

   input         clk;           // Clock
   input         rst;           // Reset
   input  [0:35] cslREGADDR;	// Console Address Register
   input  [0:35] cslREGDATI;	// Console Data Register In
   output [0:35] cslREGDATO;	// Console Data Register Out
   input  [0:35] cslREGIR;	// Console Instructon Register
   input         cslGO;		// Console GO
   output        cslBUSY;	// Console BUSY
   output        cslNXM;	// Console NXM, NXD
   input         busREQI;       // Bus Request In
   output        busREQO;       // Bus Request Out
   input         busACKI;       // Bus Acknowledge In
   output        busACKO;       // Bus Acknowledge Out
   input  [0:35] busADDRI;      // Bus Address In
   output [0:35] busADDRO;      // Bus Address Out
   input  [0:35] busDATAI;      // Bus Data In
   output [0:35] busDATAO;      // Bus Data Out

   //
   // Console is Device 0
   //

   parameter [0:3] cslDEV   = 4'b0000;

   //
   // Console Instruction Register Address
   //

   parameter [18:35] addrCIR = 18'o200000;

   //
   // Memory Address and Flags
   //

   wire         busREAD     = busADDRI[ 3];
   wire         busWRITE    = busADDRI[ 5];
   wire         busPHYSICAL = busADDRI[ 8];
   wire         busIO       = busADDRI[10];
   wire [14:17] busDEV      = busADDRI[14:17];
   wire [18:35] busADDR     = busADDRI[18:35];

   //
   // Console Instruction Register Read
   //

   wire cirREAD = busIO & busREAD & (busDEV == cslDEV) & (busADDR[18:35] == addrCIR);

   //
   // State Machine States
   //

   parameter [0:2] stateIDLE  = 0,
                   stateCHECK = 1,
                   stateREAD  = 2,
                   stateWRITE = 3,
                   stateFAIL  = 4,
                   stateDONE  = 5;

   //
   // Read/Write State Machine
   //
   // Details
   //  This creates 'backplane' bus cycles for the console to
   //  read or write to KS10 IO or or KS10 memory.
   //
   //  Like the KS10, the upper bits of the address bus are
   //  used to control read/write and IO/memory.
   //

   reg [0:2] state;
   reg [0:9] timeout;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             timeout <= 0;
             state   <= stateIDLE;
          end
        else
          case (state)
            stateIDLE :
              begin
                 timeout <= 0;
                 if ((cslGO & cslREGADDR[3]) |
                     (cslGO & cslREGADDR[5]))
                   state <= stateCHECK;
              end
            stateCHECK :
              if (timeout == 1023)
                state <= stateFAIL;
              else if (busACKI & cslREGADDR[3])
                state <= stateREAD;
              else if (busACKI & cslREGADDR[5])
                state <= stateWRITE;
              else
                timeout <= timeout + 1'b1;
            stateREAD :
              state <= stateDONE;
            stateWRITE :
              state <= stateDONE;
            stateFAIL :
              state <= stateDONE;
            stateDONE :
              state <= stateIDLE;
          endcase
     end

   //
   // Bus REQ
   //

   assign busREQO = ((state == stateCHECK) ||
                     (state == stateREAD ) ||
                     (state == stateWRITE));

   //
   // Bus ACK
   //

   assign busACKO = cirREAD;

   //
   // NXM/NXD
   //

   assign cslNXM = (state == stateFAIL);

   //
   // BUSY
   //

   assign cslBUSY = (state != stateIDLE);

   //
   // Bus MUX
   //

   reg [0:35] busDATAO;
   always @(cirREAD or state or cslREGIR or cslREGDATI)
     begin
        if (cirREAD)
          busDATAO = cslREGIR;
        else if (state == stateWRITE)
          busDATAO = cslREGDATI;
        else
          busDATAO = 36'bx;
     end

   //
   // Print the Halt Status Block
   //

`ifndef SYNTHESIS

   always @(posedge clk)
     begin
        if (busWRITE & ~busIO & busPHYSICAL)
          begin
             case (busADDR)
               18'o000000 :
                 begin
                  $display("");
                  case (busDATAI[24:35])
                    12'o0000 : $display("Microcode Startup.");
                    12'o0001 : $display("Halt Instruction.");
                    12'o0002 : $display("Console Halt.");
                    12'o0100 : $display("IO Page Failure.");
                    12'o0101 : $display("Illegal Interrupt Instruction.");
                    12'o0102 : $display("Pointer to Unibus Vector is zero.");
                    12'o1000 : $display("Illegal Microcode Dispatch.");
                    12'o1005 : $display("Microcode Startup Check Failed.");
                    default  : $display("Unknown Halt Cause.");
                  endcase
               end
               18'o000001 : $display("PC  is %06o", busDATAI);
               18'o376000 : $display("MAG is %06o", busDATAI);
               18'o376001 : $display("PC  is %06o", busDATAI);
               18'o376002 : $display("HR  is %06o", busDATAI);
               18'o376003 : $display("AR  is %06o", busDATAI);
               18'o376004 : $display("ARX is %06o", busDATAI);
               18'o376005 : $display("BR  is %06o", busDATAI);
               18'o376006 : $display("BRX is %06o", busDATAI);
               18'o376007 : $display("ONE is %06o", busDATAI);
               18'o376010 : $display("EBR is %06o", busDATAI);
               18'o376011 : $display("UBR is %06o", busDATAI);
               18'o376012 : $display("MSK is %06o", busDATAI);
               18'o376013 : $display("FLG is %06o", busDATAI);
               18'o376014 : $display("PI  is %06o", busDATAI);
               18'o376015 : $display("X1  is %06o", busDATAI);
               18'o376016 : $display("TO  is %06o", busDATAI);
               18'o376017 : $display("T1  is %06o", busDATAI);
               18'o376020 : $display("VMA is %06o", busDATAI);
               18'o376021 : $display("FE  is %06o", busDATAI);
             endcase
          end
     end

`endif
   //
   // Bus Address Out is always set by Address Register
   //

   assign busADDRO = cslREGADDR;
   
endmodule
