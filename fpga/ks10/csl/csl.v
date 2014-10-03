////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KS10 Console
//
// Details
//
//   Console Instruction Register (Device 0, IO Address 0200000)
//
//       When the KS10 is halted and the 'execute' signal is asserted along
//       with the 'continue' signal, the KS10 microcode performs a IO read of
//       the Console Instruction Register (regCIR) at IO address o200000 and
//       then executes that instruction.
//
//       The Console Instruction Register is normally initialized with a JRST
//       instruction which causes the code to jump to the entry point of the
//       code/bootloader but can be used to execute any single instruction.
//
//       This mechanism allowes the Console set the address that the KS10
//       begins execution.
//
//
//             0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17
//           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//     (LH)  |                   Instruction                       |
//           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//
//            18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
//           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//     (RH)  |                   Instruction                       |
//           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//
//   Console Control/Status register:
//
//       The Console Control/Status register controls the operation of the KS10
//       and allows the Console to be cognizant of the status of the KS10 CPU.
//
//             0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17
//           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//     (LH)  |           |                                         |
//           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//
//            18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
//           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//     (RH)  |  |GO|                 |NX|HA|SR|SC|SE|TE|RE|CE|KI|KR|
//           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//
//           GO : BUSY.  Start Read or Write Transaction
//           NX : Non-existant memory timeout
//           HA : Halt Status
//           SR : Run Switch
//           SC : Continue Switch
//           SE : Execute Switch
//           TE : Timer Enable
//           RE : Trap Enable
//           CE : Cache Enable
//           KI : KS10 Interrupt (momentary)
//           KR : KS10 Reset
//
//   Console Address Register:
//
//       The console can read from or write to KS10 memory and/or IO.  The
//       address of the memory or IO location to be accessed is placed in the
//       Console Address Register prior to starting the access.
//
//       The format of the Console Address Register during Memory Operations
//       is:
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
//       The format of the Console Address Register during IO Operations is:
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
//       Note: Bit 10 is asserted during IO operations and is negated during
//       Memory Operations.
//
//       Note: 20-bit addressing of memory is supported.
//
//   Console Data Register:
//
//       Data to be written to Memory or IO is placed in the Console Data
//       Register.   Similarly data that has been read from from Memory or IO
//      is placed in the Console Data Register.
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
//          1.  The memory address is written to the Console Address Register.
//              The 'RD' bit should be asserted.  The 'WR' bit and the 'IO' bit
//              should be negated.
//          2.  After the Console Address Register initialized, the 'GO' bit of
//              the Console Control/Status register should be asserted.
//          3.  The state machine performs a read from memory and places the
//              results in the Console Data Register.  The 'GO' bit will remain
//              asserted while the memory transaction is active and will negate
//              when the memory transaction is completed.
//
//   Console Memory Write Procedure
//
//       The KS10 memory is written using the following procedure:
//          1.  The memory address is written to the Console Address Register.
//              The 'WR' bit should be asserted.  The 'RD' bit and the 'IO' bit
//              should be negated.
//          2.  The data to be written to memory is written to the Console Data
//              Register.
//          3.  After the Console Address Register and Console Data Register
//              are both initialized, the 'GO' bit of the Console Control/
//              Status register should be asserted.
//          4.  The state machine performs a write to memory.  The 'GO' bit
//              will remain asserted while the memory transaction is active and
//              will negate when the memory transaction is completed.
//
//   Console IO Read and Write Procedure
//       Console IO operations are similar to Console Memory operations except
//       that the IO bit in the Console Address Register must be asserted and
//       the IO address must include the IO Device Number - which may be zero.
//
//       Unibus IO Device Numbers are non-zero.  Unibus IO addresses are
//       limited to 16-bits and therefore Unibus IO addresses bits 18 and 19
//       must be zero.
//
// Note:
//   ALL OUTPUT SIGNALS TO THE KS10 MUST BE SYNCHRONIZED TO THE KS10 CLOCK.
//
// Note:
//   The Stellaris Microcontroller use little-endian notation where bit 0 is
//   the LSB.  All of the KS10 signal use big-endian notation where bit 0 is
//   the MSB.
//
// File
//   csl.v
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

`default_nettype none
`include "../ks10.vh"
`include "../uba/uba.vh"
`include "../cpu/bus.vh"

module CSL(clk, rst,
           conDATA,  conADDR,  conBLE_N, conBHE_N, conRD_N,  conWR_N,
           busREQI,  busREQO,  busACKI,  busACKO,
           busADDRI, busADDRO, busDATAI, busDATAO,
           cpuRUN, cpuCONT, cpuEXEC, cpuHALT,
           cslSET, cslRUN, cslCONT, cslEXEC,
           cslTIMEREN, cslTRAPEN, cslCACHEEN, cslINTR, cslRESET,
           rh11DEBUG);

   // Clock/Reset
   input         clk;           // Clock
   input         rst;           // Reset
   // Console Microcontroller Intefaces
   inout [15: 0] conDATA;       // Console Address Bus
   input [ 5: 1] conADDR;       // Console Data Bus
   input         conBLE_N;      // Console Bus Lane
   input         conBHE_N;      // Console Bus Lane
   input         conRD_N;       // Console Read Strobe
   input         conWR_N;       // Console Write Strobe
   // Bus Interfaces
   input         busREQI;       // Bus Request In
   output        busREQO;       // Bus Request Out
   input         busACKI;       // Bus Acknowledge In
   output        busACKO;       // Bus Acknowledge Out
   input  [0:35] busADDRI;      // Bus Address In
   output [0:35] busADDRO;      // Bus Address Out
   input  [0:35] busDATAI;      // Bus Data In
   output [0:35] busDATAO;      // Bus Data Out
   // CPU Interfaces
   input         cpuRUN;        // CPU Run Status
   input         cpuCONT;       // CPU Cont Status
   input         cpuEXEC;       // CPU Exec Status
   input         cpuHALT;       // CPU Halt Status
   // Console Interfaces
   output        cslSET;        // Set Switches
   output        cslRUN;        // Run Switch
   output        cslCONT;       // Continue Switch
   output        cslEXEC;       // Execute Switch
   output        cslTIMEREN;    // Timer Enable
   output        cslTRAPEN;     // Trap Enable
   output        cslCACHEEN;    // Cache Enable
   output        cslINTR;       // Interrupt KS10
   output        cslRESET;      // Reset KS10
   // RH11 Interfaces
   input  [0:63] rh11DEBUG;     // RH11 Debug Info

   //
   // Revision Info
   //

   localparam [0:15] major  = `MAJOR_VER;
   localparam [0:15] minor  = `MINOR_VER;
   localparam [0:63] regREV = {"REV", major, 8'hae, minor};

   //
   // The Console is Device 0
   //

   localparam [0:3] cslDEV = `devUBA0;

   //
   // Console Instruction Register IO Address
   //

   localparam [18:35] addrCIR = 18'o200000;

   //
   // Memory Address and Flags
   //

   wire         busREAD  = `busREAD(busADDRI);
   wire         busWRITE = `busWRITE(busADDRI);
   wire         busIO    = `busIO(busADDRI);
   wire         busPHYS  = `busPHYS(busADDRI);
   wire [14:17] busDEV   = `busDEV(busADDRI);
   wire [18:35] busADDR  = `busIOADDR(busADDRI);

   //
   // Console Instruction Register Read
   //

   wire cirREAD = busIO & busPHYS & busREAD & (busDEV == cslDEV) & (busADDR == addrCIR);

   //
   // State Machine States
   //

   localparam [0:2] stateIDLE      = 0,
                    stateREADWAIT  = 1,
                    stateREAD      = 2,
                    stateWRITEWAIT = 3,
                    stateWRITE     = 4,
                    stateFAIL      = 5,
                    stateDONE      = 6;

   //
   // Synchronize bus interface to KS10 clock
   //

   wire cslWR;
   wire cslBLE;
   wire cslBHE;
   SYNC syncWR (clk, rst, cslWR,  !conWR_N);
   SYNC syncBLE(clk, rst, cslBLE, !conBLE_N);
   SYNC syncBHE(clk, rst, cslBHE, !conBHE_N);

   //
   // Fixup addresses for byte addressing
   //

   wire [5:0] cslADDR = {conADDR[5:1], 1'b0};

   //
   // Write Decoder
   //
   // Details:
   //  This device decodes writes from the Console Microcontroller and builds
   //  the console registers.
   //
   // Note:
   //  The status register is inititalized at power-up with the KS10 reset.
   //
   // Note:
   //  This code contains an endian swap.  The Console Microcontroller is
   //  little-endian while the KS10 is big-endian.
   //

   reg [0:35] regCIR;
   reg [0:35] regDATA;
   reg [0:35] regADDR;
   reg [0:63] regTEST;
   reg        regCTRL_NXMNXD;
   reg        regCTRL_TIMEREN;
   reg        regCTRL_TRAPEN;
   reg        regCTRL_CACHEEN;
   reg        regCTRL_RESET;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             regCIR          <= 0;
             regDATA         <= 0;
             regADDR         <= 0;
             regTEST         <= 0;
             regCTRL_NXMNXD  <= 0;
             regCTRL_TIMEREN <= 0;
             regCTRL_TRAPEN  <= 0;
             regCTRL_CACHEEN <= 0;
             regCTRL_RESET   <= 1;
          end

        else if (cslWR)
          begin

             if (cslBHE)

               case (cslADDR)

                 //
                 // Address Register
                 //

                 6'h00 : regADDR[20:27] <= conDATA[15:8];
                 6'h02 : regADDR[ 4:11] <= conDATA[15:8];

                 //
                 // Data Register
                 //

                 6'h08 : regDATA[20:27] <= conDATA[15:8];
                 6'h0a : regDATA[ 4:11] <= conDATA[15:8];

                 //
                 // Control Register
                 //

                 6'h10 : regCTRL_NXMNXD <= conDATA[  10];

                 //
                 // Console Instruction Register
                 //

                 6'h18 : regCIR[20:27]  <= conDATA[15:8];
                 6'h1a : regCIR[ 4:11]  <= conDATA[15:8];

                 //
                 // Test Register
                 //

                 6'h20 : regTEST[48:55] <= conDATA[15:8];
                 6'h22 : regTEST[32:39] <= conDATA[15:8];
                 6'h24 : regTEST[16:23] <= conDATA[15:8];
                 6'h26 : regTEST[ 0: 7] <= conDATA[15:8];

               endcase // case (cslADDR)

             if (cslBLE)

               case (cslADDR)

                 //
                 // Address Register
                 //

                 6'h00 : regADDR[28:35] <= conDATA[7:0];
                 6'h02 : regADDR[12:19] <= conDATA[7:0];
                 6'h04 : regADDR[ 0: 3] <= conDATA[3:0];

                 //
                 // Data Register
                 //

                 6'h08 : regDATA[28:35] <= conDATA[7:0];
                 6'h0a : regDATA[12:19] <= conDATA[7:0];
                 6'h0c : regDATA[ 0: 3] <= conDATA[3:0];

                 //
                 // Control Register
                 //

                 6'h10 :
                   begin
                      regCTRL_RESET     <= conDATA[  0];
                      regCTRL_CACHEEN   <= conDATA[  2];
                      regCTRL_TRAPEN    <= conDATA[  3];
                      regCTRL_TIMEREN   <= conDATA[  4];
                   end

                 //
                 // Console Instruction Register
                 //

                 6'h18 : regCIR[28:35]  <= conDATA[7:0];
                 6'h1a : regCIR[12:19]  <= conDATA[7:0];
                 6'h1c : regCIR[ 0: 3]  <= conDATA[3:0];

                 //
                 // Test Register
                 //

                 6'h20 : regTEST[56:63] <= conDATA[7:0];
                 6'h22 : regTEST[40:47] <= conDATA[7:0];
                 6'h24 : regTEST[24:31] <= conDATA[7:0];
                 6'h26 : regTEST[ 8:15] <= conDATA[7:0];

               endcase
          end

        else if (state == stateREAD)
          regDATA <= busDATAI;

        else if (state == stateFAIL)
          regCTRL_NXMNXD <= 1;

     end

   //
   // Console Status Register
   //

   wire [0:35] regSTAT = {4'b0,
                          15'b0, regCTRL_GO,
                          6'b0, regCTRL_NXMNXD, cpuHALT,
                          cpuRUN, cpuCONT, cpuEXEC, regCTRL_TIMEREN,
                          regCTRL_TRAPEN, regCTRL_CACHEEN, 1'b0, regCTRL_RESET};

   //
   // Read Decoder
   //
   // Details:
   //  This device decodes reads from the Console Microcontroller and multiplexes
   //  the registers.
   //
   // Note:
   //  The console processor read operation is asynchronous.
   //
   // Note:
   //  This code contains an endian swap.
   //

   reg [15:0] dout;

   always @(cslADDR or regADDR or regDATA or regSTAT or regCIR or regTEST or rh11DEBUG)
     begin
        case (cslADDR)

          //
          // Address Register
          //

          6'h00 : dout <= regADDR[20:35];
          6'h02 : dout <= regADDR[ 4:19];
          6'h04 : dout <= {12'b0, regADDR[0:3]};
          6'h06 : dout <= 0;

          //
          // Data Register
          //

          6'h08 : dout <= regDATA[20:35];
          6'h0a : dout <= regDATA[ 4:19];
          6'h0c : dout <= {12'b0, regDATA[0:3]};
          6'h0e : dout <= 0;

          //
          // Status Register
          //

          6'h10 : dout <= regSTAT[20:35];
          6'h12 : dout <= regSTAT[ 4:19];
          6'h14 : dout <= {12'b0, regSTAT[0:3]};
          6'h16 : dout <= 0;

          //
          // Console Instruction Register
          //

          6'h18 : dout <= regCIR[20:35];
          6'h1a : dout <= regCIR[ 4:19];
          6'h1c : dout <= {12'b0, regCIR[0:3]};
          6'h1e : dout <= 0;

          //
          // Test Register
          //

          6'h20 : dout <= regTEST[48:63];
          6'h22 : dout <= regTEST[32:47];
          6'h24 : dout <= regTEST[16:31];
          6'h26 : dout <= regTEST[ 0:15];

          //
          // RH11 Debug Register
          //

          6'h30 : dout <= 16'h9aab; //rh11DEBUG[48:63];
          6'h32 : dout <= 16'h6778; //rh11DEBUG[32:47];
          6'h34 : dout <= 16'h4556; //rh11DEBUG[16:31];
          6'h36 : dout <= 16'h1223; //rh11DEBUG[ 0:15];

          //
          // Firmware Version Register
          //

          6'h38 : dout <= {regREV[ 8:15], regREV[ 0: 7]};
          6'h3a : dout <= {regREV[24:31], regREV[16:23]};
          6'h3c : dout <= {regREV[40:47], regREV[32:39]};
          6'h3e : dout <= {regREV[56:63], regREV[48:55]};

          //
          // Everything else
          //

          default : dout <= 16'b0;

        endcase
     end

   //
   // Handle bi-directional bus output to Console Microcontroller
   //

   assign conDATA[15: 0] = !conRD_N ? dout : 16'bz;

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
   wire cslGO = cslWR & (cslADDR == 6'h12) & cslBLE & conDATA[0];

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             timeout <= 0;
             state   <= stateIDLE;
          end
        else
          case (state)
            stateIDLE:
              begin
                 if (cslGO & regADDR[3])
                   state <= stateREADWAIT;
                 else if (cslGO & regADDR[5])
                   state <= stateWRITEWAIT;
              end
            stateREADWAIT:
              if (!cslGO)
                begin
                   timeout <= 0;
                   state   <= stateREAD;
                end
            stateREAD:
              if (timeout == 31)
                state <= stateFAIL;
              else if (busACKI)
                state <= stateDONE;
              else
                timeout <= timeout + 1'b1;
            stateWRITEWAIT:
              if (!cslGO)
                begin
                   timeout <= 0;
                   state   <= stateWRITE;
                end
            stateWRITE:
              if (timeout == 31)
                state <= stateFAIL;
              else if (busACKI)
                state <= stateDONE;
              else
                timeout <= timeout + 1'b1;
            stateFAIL:
              state <= stateDONE;
            stateDONE:
              if (!cslGO)
                state <= stateIDLE;
          endcase
     end

   //
   // KS10 Bus Mux
   //

   reg [0:35] busDATAO;
   always @(cirREAD or state or regCIR or regDATA)
     begin
        if (cirREAD)
          busDATAO = regCIR;
        else if (state == stateWRITE)
          busDATAO = regDATA;
        else
          busDATAO = 36'bx;
     end

   //
   // Bus REQ
   //

   assign busREQO = ((state == stateREAD ) ||
                     (state == stateWRITE));

   //
   // 'GO' bit
   //

   wire regCTRL_GO = (state != stateIDLE);

   //
   // Bus ACK
   //

   assign busACKO = cirREAD;

   //
   // Bus Address Out is always set by Address Register
   //

   assign busADDRO = regADDR;

   //
   // Fixups
   //

   assign cslSET     = cslWR & (cslADDR == 6'h10) & cslBLE;
   assign cslRUN     = conDATA[7];
   assign cslCONT    = conDATA[6];
   assign cslEXEC    = conDATA[5];
   assign cslTIMEREN = regCTRL_TIMEREN;
   assign cslTRAPEN  = regCTRL_TRAPEN;
   assign cslCACHEEN = regCTRL_CACHEEN;
   assign cslINTR    = cslWR & (cslADDR == 6'h10) & cslBLE & conDATA[1];
   assign cslRESET   = regCTRL_RESET;

`ifndef SYNTHESIS

   //
   // Whine about unacked bus cycles
   //

   always @(posedge clk)
     begin
        if (state == stateFAIL)
          begin
             $display("[%10.0f] CSL: Unacknowledged bus cycle.  Addr was %012o",
                      $time/1.0e3, busADDRO);
             $stop;
          end
     end

`endif

 endmodule
