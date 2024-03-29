////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KMC11 NPR Control Register (NPRC)
//
// Details
//   This file contains the implementation of the Microprocessor NPR Control
//   Register (NPRC).
//
// File
//   kmcnprc.sv
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2021 Rob Doyle
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

`include "kmcnprc.vh"
`include "kmccram.vh"

module KMCNPRC (
      input  wire          clk,         // Clock
      input  wire          rst,         // Reset
      input  wire          devACKI,     // Device acknowledge in
      output logic         devREQO,     // Device request out
      input  wire          kmcINIT,     // Initialize
      input  wire  [15: 0] kmcCRAM,     // Control ROM
      input  wire          kmcNPRCLKEN, // NPR clock enable
      input  wire  [10: 0] kmcMAR,      // MAR register
      input  wire  [ 7: 0] kmcALU,      // ALU register
      input  wire          kmcMPBUSY,   // Multiport RAM Busy
      output logic         kmcSETNXM,   // Non-existent Memory
      output logic [35: 0] kmcRPWD,     // Read/Pause/Write Data
      output logic [ 7: 0] kmcNPRC      // NPRC register
   );

   //
   // NXM Timeout Timer Time
   //  2.0 microseconds
   //

   localparam [11:0] kmcNXMVAL = (0.000002 * `CLKFRQ);

   //
   // Microcode Decode
   //

   wire kmcLDNPRC = `kmcCRAM_OBUSS(kmcCRAM) == `kmcCRAM_OBUSS_NPR;

   //
   // Bit 7: Byte Xfer
   //

   logic kmcBYTEXFER;
   always_ff @(posedge clk)
     begin
        if (rst | kmcINIT)
          kmcBYTEXFER <= 0;
        else if (kmcNPRCLKEN & kmcLDNPRC)
          kmcBYTEXFER <= `kmcNPRC_BYTEXFER(kmcALU);
     end

   //
   // Bit 6: MAR(10) (Read Only)
   //

   //
   // Bit 5: MAR(8) (Read Only)
   //

   //
   // Bit 4: NPR Out
   //

   logic kmcNPRO;
   always_ff @(posedge clk)
     begin
        if (rst | kmcINIT)
          kmcNPRO <= 0;
        else if (kmcNPRCLKEN & kmcLDNPRC)
          kmcNPRO <= `kmcNPRC_NPRO(kmcALU);
     end

   //
   // Bit 3:2: Bus Address Extension on NPR In
   //

   logic [3:2] kmcBAEI;
   always_ff @(posedge clk)
     begin
        if (rst | kmcINIT)
          kmcBAEI <= 0;
        else if (kmcNPRCLKEN & kmcLDNPRC)
          kmcBAEI <= `kmcNPRC_BAEI(kmcALU);
     end

   //
   // Bit 1: Not Last Xfer (NLXFER)
   //

   logic kmcNLXFER;
   always_ff @(posedge clk)
     begin
        if (rst | kmcINIT)
          kmcNLXFER <= 0;
        else if (kmcNPRCLKEN & kmcLDNPRC)
          kmcNLXFER <= `kmcNPRC_NLXFER(kmcALU);
     end

   //
   // Bit 0: NPR Request (NPRRQ)
   //
   // NPRO, BAEI, and REQO can change in the same register write.  Need to delay
   // the DMA request for a clock cycle so that the NPRC register can update
   // before generting the DMA request or the DMA address will be incorrect.
   //

   localparam [1:0] stateIDLE = 0,
                    stateREQO = 1,
                    stateDONE = 2;

   logic [ 1:0] state;
   logic [11:0] kmcNXMCNT;

   always_ff @(posedge clk)
     begin
        if (rst | kmcINIT)
          begin
             devREQO   <= 0;
             kmcSETNXM <= 0;
             kmcRPWD   <= 0;
             kmcNXMCNT <= kmcNXMVAL;
             state     <= stateIDLE;
          end
        else
          case (state)
            stateIDLE:
              if (kmcNPRCLKEN & kmcLDNPRC & `kmcNPRC_NPRRQ(kmcALU))
                begin
                   devREQO   <= 1;
                   kmcNXMCNT <= kmcNXMVAL;
                   state     <= stateREQO;
                end
            stateREQO:
              if (devACKI)
                state <= stateDONE;
              else if (kmcNXMCNT != 0)
                kmcNXMCNT <= kmcNXMCNT - 1'b1;
              else
                begin
                   kmcSETNXM <= 1;
                   state     <= stateDONE;
                end
            stateDONE:
              begin
                 devREQO   <= 0;
                 kmcSETNXM <= 0;
                 kmcNXMCNT <= kmcNXMVAL;
                 state     <= stateIDLE;
              end
          endcase
     end

   //
   // Build NPRC Register
   //

   assign kmcNPRC = {kmcBYTEXFER, kmcMAR[10], kmcMAR[8], kmcNPRO, kmcBAEI, kmcNLXFER, devREQO};

endmodule
