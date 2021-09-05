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
//       This mechanism allows the Console set the address that the KS10
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
//             0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15
//           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//     (LH)  |           |                                |GO|
//           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//
//            16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
//           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//     (RH)  |                 |NX|HA|SR|SC|SE|TE|RE|CE|KI|KR|
//           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//
//           GO : BUSY. Start Read or Write Transaction
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
// File
//   csl.sv
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2020 Rob Doyle
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

`include "csl.vh"
`include "dzccr.vh"
`include "lpccr.vh"
`include "rpccr.vh"
`include "dupccr.vh"
`include "debcsr.vh"
`include "../uba/uba.vh"
`include "../cpu/bus.vh"

module CSL (
      // Clock and Reset
      input  wire          clk,         // Clock
      input  wire          rst,         // Reset
      ks10bus.device       cslBUS,      // CSL Bus
      // AXI Interface
      input  wire  [ 7: 0] axiAWADDR,   // Write address
      input  wire          axiAWVALID,  // Write address valid
      output logic         axiAWREADY,  // Write address ready
      input  wire  [ 2: 0] axiAWPROT,   // Write protections
      input  wire  [31: 0] axiWDATA,    // Write data
      input  wire  [ 3: 0] axiWSTRB,    // Write data strobe
      input  wire          axiWVALID,   // Write data valid
      output logic         axiWREADY,   // Write data ready
      input  wire  [ 7: 0] axiARADDR,   // Read  address
      input  wire          axiARVALID,  // Read  address valid
      output logic         axiARREADY,  // Read  address ready
      input  wire  [ 2: 0] axiARPROT,   // Read  protections
      output logic [31: 0] axiRDATA,    // Read  data
      output logic [ 1: 0] axiRRESP,    // Read  data response
      output logic         axiRVALID,   // Read  data valid
      input  wire          axiRREADY,   // Read  data ready
      output logic [ 1: 0] axiBRESP,    // Write response
      output logic         axiBVALID,   // Write response valid
      input  wire          axiBREADY,   // Write response ready
      // CPU Interfaces
      input  wire          cpuRUN,      // CPU Run Status
      input  wire          cpuCONT,     // CPU Cont Status
      input  wire          cpuEXEC,     // CPU Exec Status
      input  wire          cpuHALT,     // CPU Halt Status
      // Console Interfaces
      output logic         cslRUN,      // Run Switch
      output logic         cslHALT,     // Halt Switch
      output logic         cslCONT,     // Continue Switch
      output logic         cslEXEC,     // Execute Switch
      output logic         cslTIMEREN,  // Timer Enable
      output logic         cslTRAPEN,   // Trap Enable
      output logic         cslCACHEEN,  // Cache Enable
      output logic         cslINTR,     // Interrupt KS10
      output logic         cslRESET,    // Reset KS10
      // DUP11 Interfaces
      input  wire          dupTXE,      // DUP11 TX FIFO Empty
      output logic         dupRI,       // DUP11 Ring Indication
      output logic         dupCTS,      // DUP11 Clear to Send
      output logic         dupDSR,      // DUP11 Data Set Ready
      output logic         dupDCD,      // DUP11 Data Carrier Detect
      input  wire  [ 7: 0] dupTXFIFO,   // DUP11 TX FIFO
      input  wire          dupRXF,      // DUP11 RX FIFO Full
      input  wire          dupDTR,      // DUP11 Data Terminal Ready
      input  wire          dupRTS,      // DUP11 Request to Send
      output logic         dupH325,     // DUP11 H325 Loopback
      output logic         dupW3,       // DUP11 Jumper Wire #3
      output logic         dupW5,       // DUP11 Jumper Wire #3
      output logic         dupW6,       // DUP11 Jumper Wire #3
      output logic [ 7: 0] dupRXFIFO,   // DUP11 RX FIFO
      output logic         dupRXFIFO_WR,// DUP11 RX FIFO Write
      output logic         dupTXFIFO_RD,// DUP11 TX FIFO Read
      // DZ11 Interfaces
      output logic [ 7: 0] dzCO,        // DZ11 Carrier Sense
      output logic [ 7: 0] dzRI,        // DZ11 Ring Indication
      // LP20/LP26 Interfaces
      output logic [ 6:15] lpCONFIG,    // LP26 Serial Configuration
      input  wire          lpSIXLPI,    // LP26 Line spacing
      output logic         lpOVFU,      // LP26 Optical Vertial Format Unit
      input  wire          lpSETOFFLN,  // LP26 Set offline
      output logic         lpONLINE,    // LP26 Status
      // RPXX Interfaces
      output logic [ 7: 0] rpDPR,       // RPXX Drive Present
      output logic [ 7: 0] rpMOL,       // RPXX Media On-line
      output logic [ 7: 0] rpWRL,       // RPXX Write Lock
      input  wire  [ 0:63] rpDEBUG,     // RPXX Debug Info
      // Debug Interfaces
      output logic [ 9:11] debBRCMD,    // Debug Breakpoint command
      input  wire  [13:15] debBRSTATE,  // Debug Breakpoint state
      output logic [24:26] debTRCMD,    // Debug Trace command
      input  wire  [27:29] debTRSTATE,  // Debug Trace state
      input  wire          debTRFULL,   // Debug Trace full
      input  wire          debTREMPTY,  // Debug Trace empty
      output logic [ 0:35] debBAR,      // Debug Breakpoint Address Register
      output logic [ 0:35] debBMR,      // Debug Breakpoint Mask Register
      input  wire  [ 0:63] debITR,      // Debug Instruction Trace Register
      input  wire  [ 0:63] debPCIR,     // Debug Program Counter and Instruction Register
      output logic         debTRCMD_WR, // Debug Trace command write
      output logic         debBRCMD_WR, // Debug Breakpoint command write
      output logic         debITR_RD    // Debug Instruction Trace Register Read
   );

   //
   // Revision Info
   //

   localparam [0:15] major  = `MAJOR_VER;
   localparam [0:15] minor  = `MINOR_VER;
   localparam [0:63] regREV = {"REV", major, ".", minor};

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

   wire         busREAD  = `busREAD(cslBUS.busADDRI);
   wire         busIO    = `busIO(cslBUS.busADDRI);
   wire         busPHYS  = `busPHYS(cslBUS.busADDRI);
   wire [14:17] busDEV   = `busDEV(cslBUS.busADDRI);
   wire [18:35] busADDR  = `busIOADDR(cslBUS.busADDRI);

   //
   // Console Instruction Register Read
   //

   wire cirREAD = cslBUS.busREQI & busREAD & busIO & busPHYS & (busDEV == cslDEV) & (busADDR == addrCIR);

   //
   // State Machine
   //

   logic [0:9] cslNXDTIM;
   logic [0:2] state;
   localparam [0:2] stateIDLE         = 0,
                    stateREADWAITGO   = 1,
                    stateREADWAITACK  = 2,
                    stateWRITEWAITGO  = 3,
                    stateWRITEWAITACK = 4;

   //
   // axiAWREADY
   //
   // axiAWREADY is asserted for one clock cycle when both axiAWVALID and
   // axiWVALID are asserted.  When this occurs, the write address is
   // registered.
   //

   always_ff @(posedge clk)
     begin
        if (rst)
          axiAWREADY <= 0;
        else
          begin
             if (!axiAWREADY & axiAWVALID & axiWVALID)
               axiAWREADY <= 1;
             else
               axiAWREADY <= 0;
          end
     end

   //
   // axiWREADY
   //
   // axiWREADY is asserted for one clock cycle when both axiAWVALID and
   // axiWVALID are asserted.
   //

   always_ff @(posedge clk)
     begin
        if (rst)
          axiWREADY <= 0;
        else
          begin
             if (!axiWREADY & axiWVALID & axiAWVALID)
               axiWREADY <= 1;
             else
               axiWREADY <= 0;
          end
     end

   //
   // axiBVALID
   //
   // axiBVALID signals is asserted for one clock cycle when axiWREADY,
   // axiWVALID, axiWREADY and axiWVALID are asserted.
   //

   always_ff @(posedge clk)
     begin
        if (rst)
          axiBVALID <= 0;
        else
          begin
             if (axiAWREADY & axiAWVALID & !axiBVALID & axiWREADY & axiWVALID)
               axiBVALID <= 1;
             else if (axiBREADY & axiBVALID)
               axiBVALID <= 0;
          end
     end

   //
   // Register write
   //
   // The write data is accepted and written to memory mapped registers when
   // axiAWREADY, axiWVALID, axiWREADY and axiWVALID are asserted.
   //

   logic [0:35] regCONAR;       // 0x00: Console Address Register
   logic [0:35] regCONDR;       // 0x08: Console Data Register
   logic [0:35] regCONIR;       // 0x10: Console Instruction Register
   logic [0:31] regCONCSR;      // 0x18: Console Control/Status Register
   logic [0:31] regDZCCR;       // 0x1c: DZ11  Console Control Register
   logic [0:31] regLPCCR;       // 0x20: LP20  Console Control Register
   logic [0:31] regRPCCR;       // 0x24: RPXX  Console Control Register
   logic [0:31] regDUPCCR;      // 0x28: DUP11 Console Control Register
                                // 0x2c: Spare
                                // 0x30: Spare
                                // 0x34: Spare
                                // 0x38: Spare
   logic [0:31] regDCSR;        // 0x3c: Debug Control/Status Register
   logic [0:35] regDBAR;        // 0x40: Debug Breakpoint Address Register
   logic [0:35] regDBMR;        // 0x48: Debug Breakpoint Mask Register
                                // 0x50: Debug Instruction Trace Register (read-only)
                                // 0x58: Debug Program Counter and Instruction Register (read-only)
                                // 0x60: Spare
                                // 0x64: Spare
                                // 0x68: Spare
                                // 0x6c: Spare
                                // 0x70: RH11 Debug Regsister (read-only)
                                // 0x78: Firmware Version Register (read-only

   always_ff @(posedge clk)
     begin
        if (rst)
          begin
             regCONAR  <= 0;
             regCONDR  <= 0;
             regCONCSR <= 32'h00000001;                // KS10 Reset is asserted at power-up
             regCONIR  <= 0;
             regDZCCR  <= 0;
             regLPCCR  <= 0;
             regRPCCR  <= 0;
             regDUPCCR <= 0;
             regDCSR   <= 0;
             regDBAR   <= 0;
             regDBMR   <= 0;
          end

        else if (axiWREADY & axiWVALID & axiAWREADY & axiAWVALID)
          begin

             if (axiWSTRB[0])

               case ({axiAWADDR[7:2], 2'b0})
                 8'h00 : regCONAR [28:35] <= axiWDATA[ 7: 0];        // Console Address Register
                 8'h04 : regCONAR [ 0: 3] <= axiWDATA[ 3: 0];        // Console Address Register (HI)
                 8'h08 : regCONDR [28:35] <= axiWDATA[ 7: 0];        // Console Data Register
                 8'h0c : regCONDR [ 0: 3] <= axiWDATA[ 3: 0];        // Console Data Register (HI)
                 8'h10 : regCONIR [28:35] <= axiWDATA[ 7: 0];        // Console Instruction Register
                 8'h14 : regCONIR [ 0: 3] <= axiWDATA[ 3: 0];        // Console Instruction Register
                 8'h18 : regCONCSR[24:31] <= axiWDATA[ 7: 0];        // Console Control/Status Register
                 8'h1c : regDZCCR [24:31] <= axiWDATA[ 7: 0];        // DZ11 Console Control Register
                 8'h20 : regLPCCR [24:31] <= axiWDATA[ 7: 0];        // LP20 Console Control Register
                 8'h24 : regRPCCR [24:31] <= axiWDATA[ 7: 0];        // RPXX Console Control Register
                 8'h28 : regDUPCCR[24:31] <= axiWDATA[ 7: 0];        // DUP11 Console Control Register
                 8'h3c : regDCSR  [24:31] <= axiWDATA[ 7: 0];        // Debug Control/Status Register
                 8'h40 : regDBAR  [28:35] <= axiWDATA[ 7: 0];        // Debug Breakpoint Address Register
                 8'h44 : regDBAR  [ 0: 3] <= axiWDATA[ 3: 0];        // Debug Breakpoint Address Register (HI)
                 8'h48 : regDBMR  [28:35] <= axiWDATA[ 7: 0];        // Debug Breakpoint Mask Register
                 8'h4c : regDBMR  [ 0: 3] <= axiWDATA[ 3: 0];        // Debug Breakpoint Mask Register (HI)
               endcase

             if (axiWSTRB[1])

               case ({axiAWADDR[7:2], 2'b0})
                 8'h00 : regCONAR [20:27] <= axiWDATA[15: 8];        // Console Address Register
                 8'h08 : regCONDR [20:27] <= axiWDATA[15: 8];        // Console Data Register
                 8'h10 : regCONIR [20:27] <= axiWDATA[15: 8];        // Console Instruction Register
                 8'h18 : regCONCSR[16:23] <= axiWDATA[15: 8];        // Console Control/Status Register
                 8'h1c : regDZCCR [16:23] <= axiWDATA[15: 8];        // DZ11 Console Control Register
                 8'h20 : regLPCCR [16:23] <= axiWDATA[15: 8];        // LP20 Console Control Register
                 8'h24 : regRPCCR [16:23] <= axiWDATA[15: 8];        // RPXX Console Control Register
                 8'h28 : regDUPCCR[16:23] <= axiWDATA[15: 8];        // DUP11 Console Control Register
                 8'h3c : regDCSR  [16:23] <= axiWDATA[15: 8];        // Debug Control/Status Register
                 8'h40 : regDBAR  [20:27] <= axiWDATA[15: 8];        // Debug Breakpoint Address Register
                 8'h48 : regDBMR  [20:27] <= axiWDATA[15: 8];        // Debug Breakpoint Mask Register
               endcase

            if (axiWSTRB[2])

              case ({axiAWADDR[7:2], 2'b0})
                 8'h00 : regCONAR [12:19] <= axiWDATA[23:16];        // Console Address Register
                 8'h08 : regCONDR [12:19] <= axiWDATA[23:16];        // Console Data Register
                 8'h10 : regCONIR [12:19] <= axiWDATA[23:16];        // Console Instruction Register
                 8'h18 : regCONCSR[ 8:15] <= axiWDATA[23:16];        // Console Control/Status Register
                 8'h1c : regDZCCR [ 8:15] <= axiWDATA[23:16];        // DZ11 Console Control Register
                 8'h20 : regLPCCR [ 8:15] <= axiWDATA[23:16];        // LP20 Console Control Register
                 8'h24 : regRPCCR [ 8:15] <= axiWDATA[23:16];        // RPXX Console Control Register
                 8'h28 : regDUPCCR[ 8:15] <= axiWDATA[23:16];        // DUP11 Console Control Register
                 8'h3c : regDCSR  [ 8:15] <= axiWDATA[23:16];        // Debug Control/Status Register
                 8'h40 : regDBAR  [12:19] <= axiWDATA[23:16];        // Debug Breakpoint Address Register
                 8'h48 : regDBMR  [12:19] <= axiWDATA[23:16];        // Debug Breakpoint Mask Register
               endcase

             if (axiWSTRB[3])

               case ({axiAWADDR[7:2], 2'b0})
                 8'h00 : regCONAR [ 4:11] <= axiWDATA[31:24];        // Console Address Register
                 8'h08 : regCONDR [ 4:11] <= axiWDATA[31:24];        // Console Data Register
                 8'h10 : regCONIR [ 4:11] <= axiWDATA[31:24];        // Console Instruction Register
                 8'h18 : regCONCSR[ 0: 7] <= axiWDATA[31:24];        // Console Control/Status Register
                 8'h1c : regDZCCR [ 0: 7] <= axiWDATA[31:24];        // DZ11 Console Control Register
                 8'h20 : regLPCCR [ 0: 7] <= axiWDATA[31:24];        // LP20 Console Control Register
                 8'h24 : regRPCCR [ 0: 7] <= axiWDATA[31:24];        // RPXX Console Control Register
                 8'h28 : regDUPCCR[ 0: 7] <= axiWDATA[31:24];        // DUP11 Console Control Register
                 8'h3c : regDCSR  [ 0: 7] <= axiWDATA[31:24];        // Debug Control/Status Register
                 8'h40 : regDBAR  [ 4:11] <= axiWDATA[31:24];        // Debug Breakpoint Address Register
                 8'h48 : regDBMR  [ 4:11] <= axiWDATA[31:24];        // Debug Breakpoint Mask Register
                endcase
          end

        else if ((state == stateREADWAITACK) & cslBUS.busACKI)
           regCONDR <= cslBUS.busDATAI;

        else if (cslNXDTIM == 1)
          regCONCSR[22] <= 1;           // NXMNXD

     end

   //
   // axiARREADY
   //
   // axiARREADY is asserted for one clock cycle when axiARVALID is
   // asserted.  When this occurs, the read address is also registered.
   //

   always_ff @(posedge clk)
     begin
        if (rst)
          axiARREADY <= 0;
        else
          begin
             if (!axiARREADY & axiARVALID)
               axiARREADY <= 1;
             else
               axiARREADY <= 0;
          end
     end

   //
   // axiRVALID and axiRDATA
   //
   // axiRVALID is asserted for one clock cycle when both axiARVALID and
   // axiARREADY are asserted. When this occurs, the data should also be
   // asserted onto the axiRDATA
   //

   wire cslGOSTAT = cslBUS.busREQO;
   wire [0:31] regSTAT   = {15'b0, cslGOSTAT, 6'b0, regCONCSR[22], cpuHALT, cpuRUN, cpuCONT, cpuEXEC, cslTIMEREN, cslTRAPEN, cslCACHEEN, 1'b0, cslRESET};
   wire [0:31] regLPRD   = {6'b0, lpCONFIG, 13'b0, lpSIXLPI, lpOVFU, lpONLINE};
   wire [0:31] regDUPRD  = {dupTXE, 3'b0, dupRI, dupCTS, dupDSR, dupDCD, dupTXFIFO, dupRXF, dupDTR, dupRTS, 1'b0, dupH325, dupW3, dupW5, dupW6, 8'b0};
   wire [0:31] regDEBCSR = {9'b0, debBRCMD, 1'b0, debBRSTATE, 8'b0, debTRCMD, debTRSTATE, debTRFULL, debTREMPTY};

   always_ff @(posedge clk)
     begin
        if (rst)
          begin
             axiRDATA  <= 0;
             axiRVALID <= 0;
          end
        else
          begin
             if (axiARREADY & axiARVALID & !axiRVALID)
               begin
                  case ({axiARADDR[7:2], 2'b00})
                    8'h00   : axiRDATA <= regCONAR[4:35];            // Console Address Register
                    8'h04   : axiRDATA <= {28'b0, regCONAR[0:3]};    // Console Address Register (HI)
                    8'h08   : axiRDATA <= regCONDR[4:35];            // Console Data Register
                    8'h0c   : axiRDATA <= {28'b0, regCONDR[0:3]};    // Console Data Register (HI)
                    8'h10   : axiRDATA <= regCONIR[4:35];            // Console Instruction Register
                    8'h14   : axiRDATA <= {28'b0, regCONIR[0:3]};    // Console Instruction Register (HI)
                    8'h18   : axiRDATA <= regSTAT;                   // Console Control/Status Register
                    8'h1c   : axiRDATA <= regDZCCR;                  // DZ11 Console Control Register
                    8'h20   : axiRDATA <= regLPRD;                   // LP20 Console Control Register
                    8'h24   : axiRDATA <= regRPCCR;                  // RPXX Console Control Register
                    8'h28   : axiRDATA <= regDUPRD;                  // DUP11 Console Control Register
                    8'h3c   : axiRDATA <= regDEBCSR;                 // Debug Control/Status Register
                    8'h40   : axiRDATA <= regDBAR[4:35];             // Breakpoint Address Register
                    8'h44   : axiRDATA <= {28'b0, regDBAR[0:3]};     // Breakpoint Address Register (HI)
                    8'h48   : axiRDATA <= regDBMR[4:35];             // Breakpoint Mask Register
                    8'h4c   : axiRDATA <= {28'b0, regDBMR[0:3]};     // Breakpoint Mask Register (HI)
                    8'h50   : axiRDATA <= debITR[32:63];             // Instruction Trace Register
                    8'h54   : axiRDATA <= debITR[0 :31];             // Instruction Trace Register (HI)
                    8'h58   : axiRDATA <= debPCIR[32:63];            // Debug Program Counter and Intruction Register
                    8'h5c   : axiRDATA <= debPCIR[ 0:31];            // Debug Program Counter and Intruction Register (HI)
                    8'h70   : axiRDATA <= rpDEBUG[32:63];            // RH11 Debug Register
                    8'h74   : axiRDATA <= rpDEBUG[ 0:31];            // RH11 Debug Register (HI)
                    8'h78   : axiRDATA <= {regREV[24:31], regREV[16:23], regREV[ 8:15], regREV[ 0: 7]};// Firmware Version Register
                    8'h7c   : axiRDATA <= {regREV[56:63], regREV[48:55], regREV[40:47], regREV[32:39]};// Firmware Version Register (HI)
                    default : axiRDATA <= 32'b0;
                  endcase
                  axiRVALID <= 1;
               end
             else if (axiRVALID & axiRREADY)
               axiRVALID <= 0;
          end
     end

   //
   // Read and Write
   //

   wire rdPULSE = axiARREADY & axiARVALID & !axiRVALID;
   wire wrPULSE = axiAWREADY & axiAWVALID &  axiWVALID & axiWREADY;

   //
   // CSL Outputs
   //

   assign cslTIMEREN = `cslTIMEREN(regCONCSR);
   assign cslTRAPEN  = `cslTRAPEN(regCONCSR);
   assign cslCACHEEN = `cslCACHEEN(regCONCSR);
   assign cslRESET   = `cslRESET(regCONCSR);

   logic cslGO;

   always_ff @(posedge clk)
     begin
        if (rst)
          begin
             cslGO   <= 0;
             cslRUN  <= 0;
             cslHALT <= 0;
             cslCONT <= 0;
             cslEXEC <= 0;
             cslINTR <= 0;
          end
        else
          begin
             cslGO   <= wrPULSE & axiWSTRB[2] & (axiAWADDR[7:0] == 8'h18) &  axiWDATA[16]; // axiWDATA is endian swapped
             cslRUN  <= wrPULSE & axiWSTRB[0] & (axiAWADDR[7:0] == 8'h18) &  axiWDATA[ 7]; // axiWDATA is endian swapped
             cslHALT <= wrPULSE & axiWSTRB[0] & (axiAWADDR[7:0] == 8'h18) & !axiWDATA[ 7]; // axiWDATA is endian swapped
             cslCONT <= wrPULSE & axiWSTRB[0] & (axiAWADDR[7:0] == 8'h18) &  axiWDATA[ 6]; // axiWDATA is endian swapped
             cslEXEC <= wrPULSE & axiWSTRB[0] & (axiAWADDR[7:0] == 8'h18) &  axiWDATA[ 5]; // axiWDATA is endian swapped
             cslINTR <= wrPULSE & axiWSTRB[0] & (axiAWADDR[7:0] == 8'h18) &  axiWDATA[ 1]; // axiWDATA is endian swapped
          end
     end

   //
   // DZ11 Outputs
   //
   assign dzCO  = `dzccrCO(regDZCCR);
   assign dzRI  = `dzccrRI(regDZCCR);

   //
   // RH11 Outputs
   //

   assign rpDPR = `rpccrDPR(regRPCCR);
   assign rpMOL = `rpccrMOL(regRPCCR);
   assign rpWRL = `rpccrWRL(regRPCCR);

   //
   // LP26 Ouputs
   //

   assign lpCONFIG = `lpccrCONFIG(regLPCCR);
   assign lpOVFU   = `lpccrOVFU(regLPCCR);

   //
   // LP26 Online
   //

   wire lpCLR = wrPULSE & axiWSTRB[0] & (axiAWADDR[7:0] == 8'h20) & (axiWDATA[0] == 1'b0);   // axiWDATA is endian swapped
   wire lpSET = wrPULSE & axiWSTRB[0] & (axiAWADDR[7:0] == 8'h20) & (axiWDATA[0] == 1'b1);   // axiWDATA is endian swapped

   always_ff @(posedge clk)
     begin
        if (rst | lpSETOFFLN | lpCLR)
          lpONLINE <= 0;
        else if (lpSET)
          lpONLINE <= 1;
     end

   //
   // DUP11 Outputs
   //

   assign dupRI      = `dupccrRI(regDUPCCR);
   assign dupCTS     = `dupccrCTS(regDUPCCR);
   assign dupDSR     = `dupccrDSR(regDUPCCR);
   assign dupDCD     = `dupccrDCD(regDUPCCR);
   assign dupH325    = `dupccrH325(regDUPCCR);
   assign dupW3      = `dupccrW3(regDUPCCR);
   assign dupW5      = `dupccrW5(regDUPCCR);
   assign dupW6      = `dupccrW6(regDUPCCR);
   assign dupRXFIFO  = `dupccrRXFIFO(regDUPCCR);

   always_ff @(posedge clk)
     begin
        if (rst)
          begin
             dupTXFIFO_RD <= 0;
             dupRXFIFO_WR <= 0;
          end
        else
          begin
             dupTXFIFO_RD <= rdPULSE & axiWSTRB[0] & (axiARADDR[7:0] == 8'h28);
             dupRXFIFO_WR <= wrPULSE & axiWSTRB[2] & (axiAWADDR[7:0] == 8'h28);
          end
     end

   //
   // Debug Outputs
   //

   assign debBAR   = regDBAR;
   assign debBMR   = regDBMR;
   assign debBRCMD = `dcsrBRCMD(regDCSR);
   assign debTRCMD = `dcsrTRCMD(regDCSR);

   always_ff @(posedge clk)
     begin
        if (rst)
          begin
             debITR_RD   <= 0;
             debTRCMD_WR <= 0;
             debBRCMD_WR <= 0;
          end
        else
          begin
             debITR_RD   <= rdPULSE & axiWSTRB[3] & (axiARADDR[7:0] == 8'h54);                   // FIFO advances on MSB
             debTRCMD_WR <= wrPULSE & axiWSTRB[0] & (axiAWADDR[7:0] == 8'h3c);
             debBRCMD_WR <= wrPULSE & axiWSTRB[2] & (axiAWADDR[7:0] == 8'h3c);
          end
     end

   //
   // Backplane Bus Read/Write State Machine
   //
   // Details
   //  This creates 'backplane' bus cycles for the console to read or write to
   //  KS10 IO or or KS10 memory.
   //
   //  Like the KS10, the upper bits of the address bus are used to control
   //  read/write and IO/memory.
   //

   localparam [0:9] timeout = 511;

   always_ff @(posedge clk)
     begin
        if (rst)
          begin
             cslBUS.busREQO  <= 0;
             cslBUS.busADDRO <= 0;
             cslNXDTIM <= timeout;
             state <= stateIDLE;
          end
        else
          case (state)
            stateIDLE:
              if (cslGO & `busREAD(regCONAR))
                state <= stateREADWAITGO;
              else if (cslGO & `busWRITE(regCONAR))
                state <= stateWRITEWAITGO;
            stateREADWAITGO:
              if (!cslGO)
                begin
                   cslBUS.busREQO  <= 1;
                   cslBUS.busADDRO <= regCONAR;
                   cslNXDTIM <= timeout;
                   state <= stateREADWAITACK;
                end
            stateREADWAITACK:
              if (cslBUS.busACKI)
                begin
                   cslBUS.busREQO <= 0;
                   state <= stateIDLE;
                end
              else if (cslNXDTIM != 0)
                cslNXDTIM <= cslNXDTIM - 1'b1;
              else
                begin
                   cslBUS.busREQO <= 0;
                   state <= stateIDLE;
                end
            stateWRITEWAITGO:
              if (!cslGO)
                begin
                   cslBUS.busREQO  <= 1;
                   cslBUS.busADDRO <= regCONAR;
                   cslNXDTIM <= timeout;
                   state <= stateWRITEWAITACK;
                end
            stateWRITEWAITACK:
              if (cslBUS.busACKI)
                begin
                   cslBUS.busREQO <= 0;
                   state <= stateIDLE;
                end
              else if (cslNXDTIM != 0)
                cslNXDTIM <= cslNXDTIM - 1'b1;
              else
                begin
                   cslBUS.busREQO <= 0;
                   state <= stateIDLE;
                end
          endcase
     end

   //
   // KS10 Bus Mux
   //

   assign cslBUS.busDATAO = cirREAD ? regCONIR : regCONDR;

   //
   // Bus ACK
   //

   assign cslBUS.busACKO = cirREAD;

   //
   // This AXI slave always responds with "OK".
   //

   assign axiRRESP = 2'b0;
   assign axiBRESP = 2'b0;

   //
   // Bus Interface
   //  (CSL doesn't generate interrupts)
   //

   assign cslBUS.busINTRO = 0;

`ifndef SYNTHESIS

   //
   // Whine about unacked bus cycles
   //

   always_ff @(posedge clk)
     begin
        if (cslNXDTIM == 1)
          begin
             $display("[%11.3f] CSL: Unacknowledged bus cycle.  Addr was %012o",
                      $time/1.0e3, cslBUS.busADDRO);
             $stop;
          end
     end

`endif

endmodule
