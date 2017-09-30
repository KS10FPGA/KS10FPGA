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
// Copyright (C) 2012-2017 Rob Doyle
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

`include "../ks10.vh"
`include "../uba/uba.vh"
`include "../cpu/bus.vh"

module CSL (
      // Clock/Reset
      input  wire         clk,          // Clock
      input  wire         rst,          // Reset
      // Console Microcontroller Intefaces
      inout  wire [15: 0] conDATA,      // Console Address Bus
      input  wire [ 7: 1] conADDR,      // Console Data Bus
      input  wire         conBLE_N,     // Console Bus Lane
      input  wire         conBHE_N,     // Console Bus Lane
      input  wire         conRD_N,      // Console Read Strobe
      input  wire         conWR_N,      // Console Write Strobe
      // Bus Interfaces
      input  wire         busREQI,      // Bus Request In
      output wire         busREQO,      // Bus Request Out
      input  wire         busACKI,      // Bus Acknowledge In
      output wire         busACKO,      // Bus Acknowledge Out
      input  wire [ 0:35] busADDRI,     // Bus Address In
      output wire [ 0:35] busADDRO,     // Bus Address Out
      input  wire [ 0:35] busDATAI,     // Bus Data In
      output reg  [ 0:35] busDATAO,     // Bus Data Out
      // CPU Interfaces
      input  wire         cpuRUN,       // CPU Run Status
      input  wire         cpuCONT,      // CPU Cont Status
      input  wire         cpuEXEC,      // CPU Exec Status
      input  wire         cpuHALT,      // CPU Halt Status
      // Console Interfaces
      output wire         cslSET,       // Set Switches
      output wire         cslRUN,       // Run Switch
      output wire         cslCONT,      // Continue Switch
      output wire         cslEXEC,      // Execute Switch
      output wire         cslTIMEREN,   // Timer Enable
      output wire         cslTRAPEN,    // Trap Enable
      output wire         cslCACHEEN,   // Cache Enable
      output wire         cslINTR,      // Interrupt KS10
      output wire         cslRESET,     // Reset KS10
      // DZ11 Interfaces
      output reg  [ 0:63] dzCCR,        // DZ11 Console Control Register
      // RPXX Interfaces
      output reg  [ 0:63] rpCCR,        // RPXX Console Control Register
      // SD Interfaces
      input  wire [ 0:63] rhDEBUG,      // RH Debug Info
      // Debug Interfaces
      input  wire [ 0:35] debugCSR,     // Debug Control/Status Register
      output reg  [ 0:35] debugBAR,     // Debug Breakpoint Address Register
      output reg  [ 0:35] debugBMR,     // Debug Breakpoint Mask Register
      input  wire [ 0:63] debugITR,     // Debug Instruction Trace Register
      output reg  [ 0: 1] debugBRKEN,   // Debug Breakpoint Enable
      output reg  [ 0: 1] debugTREN,    // Debug Trace Enable
      output wire         debugTRRESET, // Debug Debug Trace Reset
      output wire         debugREADITR  // Debug Trace Read
   );

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

   wire cirREAD = busREAD & busIO & busPHYS & (busDEV == cslDEV) & (busADDR == addrCIR);

   //
   // State Machine States
   //

   localparam [0:2] stateIDLE        = 0,
                    stateREADWAITGO  = 1,
                    stateREADWAITIO  = 2,
                    stateREAD        = 3,
                    stateWRITEWAITGO = 4,
                    stateWRITEWAITIO = 5,
                    stateWRITE       = 6,
                    stateFAIL        = 7;

   //
   // Synchronize bus interface to KS10 clock
   //

   wire cslWR;
   wire cslRD;
   wire cslBLE;
   wire cslBHE;
   SYNC syncRD (clk, rst, cslRD,  !conRD_N);
   SYNC syncWR (clk, rst, cslWR,  !conWR_N);
   SYNC syncBLE(clk, rst, cslBLE, !conBLE_N);
   SYNC syncBHE(clk, rst, cslBHE, !conBHE_N);

   //
   // Fixup addresses for byte addressing
   //

   wire [7:0] cslADDR = {conADDR[7:1], 1'b0};

   //
   // State Register
   //

   reg [0:2] state;

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
             dzCCR           <= 0;
             rpCCR           <= 0;
             regCTRL_NXMNXD  <= 0;
             regCTRL_TIMEREN <= 0;
             regCTRL_TRAPEN  <= 0;
             regCTRL_CACHEEN <= 0;
             regCTRL_RESET   <= 1;
             debugBRKEN      <= 0;
             debugTREN       <= 0;
             debugBAR        <= 0;
             debugBMR        <= 0;
          end

        else if (cslWR)
          begin

             if (cslBHE)

               case (cslADDR)

                 //
                 // Address Register
                 //

                 8'h00 : regADDR[20:27] <= conDATA[15:8];
                 8'h02 : regADDR[ 4:11] <= conDATA[15:8];

                 //
                 // Data Register
                 //

                 8'h08 : regDATA[20:27] <= conDATA[15:8];
                 8'h0a : regDATA[ 4:11] <= conDATA[15:8];

                 //
                 // Control Register
                 //

                 8'h10 : regCTRL_NXMNXD <= conDATA[  10];

                 //
                 // Console Instruction Register
                 //

                 8'h18 : regCIR[20:27]  <= conDATA[15:8];
                 8'h1a : regCIR[ 4:11]  <= conDATA[15:8];

                 //
                 // DZ11 Console Control Register
                 //

                 8'h20 : dzCCR[48:55] <= conDATA[15:8];
                 8'h22 : dzCCR[32:39] <= conDATA[15:8];
                 8'h24 : dzCCR[16:23] <= conDATA[15:8];
                 8'h26 : dzCCR[ 0: 7] <= conDATA[15:8];

                 //
                 // RPXX Console Control Register
                 //

                 8'h28 : rpCCR[48:55] <= conDATA[15:8];
                 8'h2a : rpCCR[32:39] <= conDATA[15:8];
                 8'h2c : rpCCR[16:23] <= conDATA[15:8];
                 8'h2e : rpCCR[ 0: 7] <= conDATA[15:8];

                 //
                 // Debug Control/Status Register
                 //

                 8'h38 :
                   begin
                      debugBRKEN <= conDATA[15:14];
                   end

                 //
                 // Debug Breakpoint Address Register
                 //

                 8'h40 : debugBAR[20:27] <= conDATA[15:8];
                 8'h42 : debugBAR[ 4:11] <= conDATA[15:8];

                 //
                 // Debug Breakpoint Mask Register
                 //

                 8'h48 : debugBMR[20:27] <= conDATA[15:8];
                 8'h4a : debugBMR[ 4:11] <= conDATA[15:8];

               endcase

             if (cslBLE)

               case (cslADDR)

                 //
                 // Address Register
                 //

                 8'h00 : regADDR[28:35] <= conDATA[7:0];
                 8'h02 : regADDR[12:19] <= conDATA[7:0];
                 8'h04 : regADDR[ 0: 3] <= conDATA[3:0];

                 //
                 // Data Register
                 //

                 8'h08 : regDATA[28:35] <= conDATA[7:0];
                 8'h0a : regDATA[12:19] <= conDATA[7:0];
                 8'h0c : regDATA[ 0: 3] <= conDATA[3:0];

                 //
                 // Control Register
                 //

                 8'h10 :
                   begin
                      regCTRL_RESET     <= conDATA[  0];
                      regCTRL_CACHEEN   <= conDATA[  2];
                      regCTRL_TRAPEN    <= conDATA[  3];
                      regCTRL_TIMEREN   <= conDATA[  4];
                   end

                 //
                 // Console Instruction Register
                 //

                 8'h18 : regCIR[28:35]  <= conDATA[7:0];
                 8'h1a : regCIR[12:19]  <= conDATA[7:0];
                 8'h1c : regCIR[ 0: 3]  <= conDATA[3:0];

                 //
                 // DZ11 Console Control Register
                 //

                 8'h20 : dzCCR[56:63] <= conDATA[7:0];
                 8'h22 : dzCCR[40:47] <= conDATA[7:0];
                 8'h24 : dzCCR[24:31] <= conDATA[7:0];
                 8'h26 : dzCCR[ 8:15] <= conDATA[7:0];

                 //
                 // RPXX Console Control Register
                 //

                 8'h28 : rpCCR[56:63] <= conDATA[7:0];
                 8'h2a : rpCCR[40:47] <= conDATA[7:0];
                 8'h2c : rpCCR[24:31] <= conDATA[7:0];
                 8'h2e : rpCCR[ 8:15] <= conDATA[7:0];

                 //
                 // Debug Control/Status Register
                 //

                 8'h38 :
                   begin
                      debugTREN <= conDATA[7:6];
                   end

                 //
                 // Debug Breakpoint Address Register
                 //

                 8'h40 : debugBAR[28:35] <= conDATA[7:0];
                 8'h42 : debugBAR[12:19] <= conDATA[7:0];
                 8'h44 : debugBAR[ 0: 3] <= conDATA[3:0];

                 //
                 // Debug Breakpoint Mask Register
                 //

                 8'h48 : debugBMR[28:35] <= conDATA[7:0];
                 8'h4a : debugBMR[12:19] <= conDATA[7:0];
                 8'h4c : debugBMR[ 0: 3] <= conDATA[3:0];

               endcase
          end

        else if (state == stateREAD)
          regDATA <= busDATAI;

        else if (state == stateFAIL)
          regCTRL_NXMNXD <= 1;

     end

   //
   // 'GO' bit
   //

   wire regCTRL_GO = (state != stateIDLE);

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
   //  This device decodes reads from the Console Microcontroller and
   //  multiplexes the registers.
   //
   // Note:
   //  The console processor read operation is asynchronous.
   //
   // Note:
   //  This code contains an endian swap.
   //

   reg [15:0] dout;

   always @*
     begin
        case (cslADDR)

          //
          // Address Register
          //

          8'h00 : dout <= regADDR[20:35];
          8'h02 : dout <= regADDR[ 4:19];
          8'h04 : dout <= {12'b0, regADDR[0:3]};
          8'h06 : dout <= 0;

          //
          // Data Register
          //

          8'h08 : dout <= regDATA[20:35];
          8'h0a : dout <= regDATA[ 4:19];
          8'h0c : dout <= {12'b0, regDATA[0:3]};
          8'h0e : dout <= 0;

          //
          // Status Register
          //

          8'h10 : dout <= regSTAT[20:35];
          8'h12 : dout <= regSTAT[ 4:19];
          8'h14 : dout <= {12'b0, regSTAT[0:3]};
          8'h16 : dout <= 0;

          //
          // Console Instruction Register
          //

          8'h18 : dout <= regCIR[20:35];
          8'h1a : dout <= regCIR[ 4:19];
          8'h1c : dout <= {12'b0, regCIR[0:3]};
          8'h1e : dout <= 0;

          //
          // DZ11 Console Control Register
          //

          8'h20 : dout <= dzCCR[48:63];
          8'h22 : dout <= dzCCR[32:47];
          8'h24 : dout <= dzCCR[16:31];
          8'h26 : dout <= dzCCR[ 0:15];

          //
          // RPXX Console Control Register
          //

          8'h28 : dout <= rpCCR[48:63];
          8'h2a : dout <= rpCCR[32:47];
          8'h2c : dout <= rpCCR[16:31];
          8'h2e : dout <= rpCCR[ 0:15];

          //
          // RH11 Debug Register
          //

          8'h30 : dout <= rhDEBUG[48:63];
          8'h32 : dout <= rhDEBUG[32:47];
          8'h34 : dout <= rhDEBUG[16:31];
          8'h36 : dout <= rhDEBUG[ 0:15];

          //
          // Debug Control/Status Register
          //

          8'h38 : dout <= debugCSR[20:35];
          8'h3a : dout <= debugCSR[ 4:19];
          8'h3c : dout <= {12'b0, debugCSR[0:3]};
          8'h3e : dout <= 0;

          //
          // Breakpoint Address Register
          //

          8'h40 : dout <= debugBAR[20:35];
          8'h42 : dout <= debugBAR[ 4:19];
          8'h44 : dout <= {12'b0, debugBAR[0:3]};
          8'h46 : dout <= 0;

          //
          // Breakpoint Mask Register
          //

          8'h48 : dout <= debugBMR[20:35];
          8'h4a : dout <= debugBMR[ 4:19];
          8'h4c : dout <= {12'b0, debugBMR[0:3]};
          8'h4e : dout <= 0;

          //
          // Instruction Trace Register
          //

          8'h50 : dout <= debugITR[48:63];
          8'h52 : dout <= debugITR[32:47];
          8'h54 : dout <= debugITR[16:31];
          8'h56 : dout <= debugITR[ 0:15];

          //
          // Firmware Version Register
          //

          8'h78 : dout <= {regREV[ 8:15], regREV[ 0: 7]};
          8'h7a : dout <= {regREV[24:31], regREV[16:23]};
          8'h7c : dout <= {regREV[40:47], regREV[32:39]};
          8'h7e : dout <= {regREV[56:63], regREV[48:55]};

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
   //  This creates 'backplane' bus cycles for the console to read or write to
   //  KS10 IO or or KS10 memory.
   //
   //  Like the KS10, the upper bits of the address bus are used to control
   //  read/write and IO/memory.
   //

   reg [0:9] timer;
   wire cslGO = cslWR & (cslADDR == 8'h12) & cslBLE & conDATA[0];

   localparam [0:9] timeout = 511;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             timer <= 0;
             state <= stateIDLE;
          end
        else
          case (state)
            stateIDLE:
              if (cslGO & regADDR[3])
                state <= stateREADWAITGO;
              else if (cslGO & regADDR[5])
                state <= stateWRITEWAITGO;
            stateREADWAITGO:
              if (!cslGO)
                begin
                   timer <= 0;
                   state <= stateREADWAITIO;
                end
            stateREADWAITIO:
              if (!busIO)
                state <= stateREAD;
            stateREAD:
              if (timer == timeout)
                state <= stateFAIL;
              else if (busACKI)
                state <= stateIDLE;
              else
                timer <= timer + 1'b1;
            stateWRITEWAITGO:
              if (!cslGO)
                begin
                   timer <= 0;
                   state <= stateWRITEWAITIO;
                end
            stateWRITEWAITIO:
              if (!busIO)
                state <= stateWRITE;
            stateWRITE:
              if (timer == timeout)
                state <= stateFAIL;
              else if (busACKI)
                state <= stateIDLE;
              else
                timer <= timer + 1'b1;
            stateFAIL:
              state <= stateIDLE;
          endcase
     end

   //
   // KS10 Bus Mux
   //

   always @*
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
   // Bus ACK
   //

   assign busACKO = cirREAD;

   //
   // Bus Address Out is always set by Address Register
   //

   assign busADDRO = regADDR;

`ifdef SYNTHESIS
`ifdef CHIPSCOPE_CSL

   //
   // ChipScope Pro Integrated Controller (ICON)
   //

   wire [35:0] control0;

   chipscope_csl_icon uICON (
      .CONTROL0  (control0)
   );

   //
   // ChipScope Pro Integrated Logic Analyzer (ILA)
   //

   wire [255:0] TRIG0 = {
       cslRESET,                // dataport[    255]
       regDATA[0:35],           // dataport[219:254]
       regADDR[0:35],           // dataport[183:218]
       regCIR[0:35],            // dataport[147:182]
       busDATAO[0:35],          // dataport[111:146]
       busADDRO[0:35],          // dataport[ 75:110]
       state[0:2],              // dataport[ 72: 74]
       busREQO,                 // dataport[     71]
       busACKI,                 // dataport[     70]
       conBLE_N,                // dataport[     69]
       conBHE_N,                // dataport[     68]
       conRD_N,                 // dataport[     67]
       conWR_N,                 // dataport[     66]
       conDATA[15:0],           // dataport[ 50: 65]
       conADDR[5:1],            // dataport[ 45: 49]
       regSTAT[0:35],           // dataport[  9: 44]
       9'b0                     // dataport[  0:  8]
   };

   chipscope_csl_ila uILA (
      .CLK       (clk),
      .CONTROL   (control0),
      .TRIG0     (TRIG0)
   );

`endif
`endif

   //
   // CPU Outputs
   //

   assign cslSET     = cslWR & (cslADDR == 8'h10) & cslBLE;
   assign cslRUN     = conDATA[7];
   assign cslCONT    = conDATA[6];
   assign cslEXEC    = conDATA[5];
   assign cslTIMEREN = regCTRL_TIMEREN;
   assign cslTRAPEN  = regCTRL_TRAPEN;
   assign cslCACHEEN = regCTRL_CACHEEN;
   assign cslINTR    = cslWR & (cslADDR == 8'h10) & cslBLE & conDATA[1];
   assign cslRESET   = regCTRL_RESET;

   //
   // Debug Outputs
   //

   assign debugTRRESET = cslWR & (cslADDR == 8'h38) & cslBLE & conDATA[0];
   assign debugREADITR = cslRD & (cslADDR == 8'h56);

`ifndef SYNTHESIS

   //
   // Whine about unacked bus cycles
   //

   always @(posedge clk)
     begin
        if (state == stateFAIL)
          begin
             $display("[%11.3f] CSL: Unacknowledged bus cycle.  Addr was %012o",
                      $time/1.0e3, busADDRO);
             $stop;
          end
     end

`endif

 endmodule
