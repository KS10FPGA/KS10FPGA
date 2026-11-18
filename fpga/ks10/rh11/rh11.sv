//////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KS-10 RH11 Massbus Disk Controller
//
// Details
//
// Notes
//   Regarding endian-ness:
//     The KS10 backplane bus is 36-bit big-endian and uses [0:35] notation.
//     The IO Device are 36-bit little-endian (after Unibus) and uses [35:0]
//     notation.
//
//     Whereas the 'Unibus' is 18-bit data and 16-bit address, I've implemented
//     the IO bus as 36-bit address and 36-bit data just to keep things simple.
//
// File
//   rh11.sv
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2022 Rob Doyle
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

`include "rh11.vh"
`include "rhds.vh"
`include "rhcs1.vh"
`include "rhcs2.vh"
`include "../uba/ubabus.vh"

module RH11 (
      unibus.device  unibus,                            // Unibus connection
      massbus.master massbus                            // Massbus Interface
   );

   //
   // Bus Interface
   //

   logic  clk;                                          // Clock
   logic  rst;                                          // Reset
   logic  devRESET;                                     // Device reset
   assign clk      = unibus.clk;                        // Clock
   assign rst      = unibus.rst;                        // Reset
   assign devRESET = unibus.devRESET;                   // Device reset

   //
   // RH Parameters
   //

   parameter [14:17] rhDEV   = `devUBA1;                // RH11 Device Number
   parameter [18:35] rhADDR  = `rh1ADDR;                // RH11 Base Address
   parameter [18:35] rhVECT  = `rh1VECT;                // RH11 Interrupt Vector
   parameter [ 7: 4] rhINTR  = `rh1INTR;                // RH11 Interrupt

   //
   // RH Register Addresses
   //

   localparam [18:35] rhADDR00 = rhADDR + 6'o00;        // Address 00
   localparam [18:35] rhADDR02 = rhADDR + 5'o02;        // Address 02
   localparam [18:35] rhADDR04 = rhADDR + 6'o04;        // Address 04
   localparam [18:35] rhADDR06 = rhADDR + 6'o06;        // Address 06

   localparam [18:35] rhADDR10 = rhADDR + 6'o10;        // Address 10
   localparam [18:35] rhADDR12 = rhADDR + 6'o12;        // Address 12
   localparam [18:35] rhADDR14 = rhADDR + 6'o14;        // Address 14
   localparam [18:35] rhADDR16 = rhADDR + 6'o16;        // Address 16

   localparam [18:35] rhADDR20 = rhADDR + 6'o20;        // Address 20
   localparam [18:35] rhADDR22 = rhADDR + 6'o22;        // Address 22
   localparam [18:35] rhADDR24 = rhADDR + 6'o24;        // Address 24
   localparam [18:35] rhADDR26 = rhADDR + 6'o26;        // Address 26

   localparam [18:35] rhADDR30 = rhADDR + 6'o30;        // Address 30
   localparam [18:35] rhADDR32 = rhADDR + 6'o32;        // Address 32
   localparam [18:35] rhADDR34 = rhADDR + 6'o34;        // Address 34
   localparam [18:35] rhADDR36 = rhADDR + 6'o36;        // Address 36

   localparam [18:35] rhADDR40 = rhADDR + 6'o40;        // Address 40
   localparam [18:35] rhADDR42 = rhADDR + 6'o42;        // Address 42
   localparam [18:35] rhADDR44 = rhADDR + 6'o44;        // Address 44
   localparam [18:35] rhADDR46 = rhADDR + 6'o46;        // Address 46

   localparam [18:35] rhADDR50 = rhADDR + 6'o50;        // Address 50
   localparam [18:35] rhADDR52 = rhADDR + 6'o52;        // Address 52
   localparam [18:35] rhADDR54 = rhADDR + 6'o54;        // Address 54
   localparam [18:35] rhADDR56 = rhADDR + 6'o56;        // Address 56

   localparam [18:35] rhADDR60 = rhADDR + 6'o60;        // Address 60
   localparam [18:35] rhADDR62 = rhADDR + 6'o62;        // Address 62
   localparam [18:35] rhADDR64 = rhADDR + 6'o64;        // Address 64
   localparam [18:35] rhADDR66 = rhADDR + 6'o66;        // Address 66

   localparam [18:35] rhADDR70 = rhADDR + 6'o70;        // Address 70
   localparam [18:35] rhADDR72 = rhADDR + 6'o72;        // Address 72
   localparam [18:35] rhADDR74 = rhADDR + 6'o74;        // Address 74
   localparam [18:35] rhADDR76 = rhADDR + 6'o76;        // Address 76

   //
   // Type of device attached to controller
   //

   wire rhISDISK = (rhADDR == `rh1ADDR);

   //
   // Address Flags
   //

   localparam [ 0:17] rdFLAGS = 18'b000_100_000_000_000_000;
   localparam [ 0:17] wrFLAGS = 18'b000_001_000_000_000_000;

   //
   // Debug output
   //

`ifndef SYNTHESIS

   integer file;

`endif

   //
   // Device Address and Flags
   //

   wire         devREAD   = `devREAD(unibus.devADDRI);  // Read Cycle
   wire         devWRITE  = `devWRITE(unibus.devADDRI); // Write Cycle
   wire         devPHYS   = `devPHYS(unibus.devADDRI);  // Physical reference
   wire         devIO     = `devIO(unibus.devADDRI);    // IO Cycle
   wire         devWRU    = `devWRU(unibus.devADDRI);   // WRU Cycle
   wire         devVECT   = `devVECT(unibus.devADDRI);  // Read interrupt vector
   wire [14:17] devDEV    = `devDEV(unibus.devADDRI);   // Device Number
   wire [18:35] devADDR   = `devADDR(unibus.devADDRI);  // Device Address
   wire         devHIBYTE = `devHIBYTE(unibus.devADDRI);// Device High Byte
   wire         devLOBYTE = `devLOBYTE(unibus.devADDRI);// Device Low Byte

   //
   // Read/Write Decoding
   //

   wire rhREAD   = unibus.devREQI & devREAD  & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV);
   wire rhWRITE  = unibus.devREQI & devWRITE & devIO & devPHYS & !devWRU & !devVECT & (devDEV == rhDEV);
   wire vectREAD = unibus.devREQI & devREAD  & devIO & devPHYS & !devWRU &  devVECT & (devDEV == rhDEV);

   //
   // Address Decoding
   //

   wire rhRDREG00 = rhREAD  & (devADDR == rhADDR00);    // RHCS1
   wire rhWRREG00 = rhWRITE & (devADDR == rhADDR00);    // RHCS1
   wire rhRDREG02 = rhREAD  & (devADDR == rhADDR02);    // RHWC
   wire rhWRREG02 = rhWRITE & (devADDR == rhADDR02);    // RHWC
   wire rhRDREG04 = rhREAD  & (devADDR == rhADDR04);    // RHBA
   wire rhWRREG04 = rhWRITE & (devADDR == rhADDR04);    // RHBA
   wire rhRDREG06 = rhREAD  & (devADDR == rhADDR06);    // RPDA/MTFC

   wire rhRDREG10 = rhREAD  & (devADDR == rhADDR10);    // RHCS2
   wire rhWRREG10 = rhWRITE & (devADDR == rhADDR10);    // RHCS2
   wire rhRDREG12 = rhREAD  & (devADDR == rhADDR12);    // RPDS/MTDS
   wire rhRDREG14 = rhREAD  & (devADDR == rhADDR14);    // RPER1/MTER
   wire rhRDREG16 = rhREAD  & (devADDR == rhADDR16);    // RHAS

   wire rhRDREG20 = rhREAD  & (devADDR == rhADDR20);    // RPLA/MTCC
   wire rhRDREG22 = rhREAD  & (devADDR == rhADDR22);    // RHDB
   wire rhWRREG22 = rhWRITE & (devADDR == rhADDR22);    // RHDB
   wire rhRDREG24 = rhREAD  & (devADDR == rhADDR24);    // RPMR/MTMR
   wire rhRDREG26 = rhREAD  & (devADDR == rhADDR26);    // RPDT/MTDT

   wire rhRDREG30 = rhREAD  & (devADDR == rhADDR30);    // RPSN/MTSN
   wire rhRDREG32 = rhREAD  & (devADDR == rhADDR32);    // RPOF/MTTC
   wire rhRDREG34 = rhREAD  & (devADDR == rhADDR34);    // RPDC/zero
   wire rhRDREG36 = rhREAD  & (devADDR == rhADDR36);    // RPCC/zero

   wire rhRDREG40 = rhREAD  & (devADDR == rhADDR40);    // RPER2/zero
   wire rhRDREG42 = rhREAD  & (devADDR == rhADDR42);    // RPER3/zero
   wire rhRDREG44 = rhREAD  & (devADDR == rhADDR44);    // RPEC1/zero
   wire rhRDREG46 = rhREAD  & (devADDR == rhADDR46);    // RPEC2/zero

   //
   // Big-endian to little-endian data bus swap
   //

   wire [35: 0] rhDATAI = unibus.devDATAI[0:35];

   //
   // Interrupt Acknowledge
   //

   wire         rhIACK = vectREAD;

   //
   // Massbus Address ROM
   //  Converts Unibus addresses to Massbus addresses.
   //
   //  rhREGSEL - Massbus register address.
   //  rhREGEXT - Asserted if the register associatied with this address is a
   //             Massbus register (as opposed to an RH11 address).
   //
   // Trace:
   //  M7295/BCTA/E29.  The truth table is on M7295/BCTK
   //

   logic       rhREGEXT;
   logic [4:0] rhREGSEL;

   always_comb
     begin
        case (devADDR)
          rhADDR00: {rhREGEXT, rhREGSEL} = {1'b1, 5'o00}; // RHCS1
          rhADDR02: {rhREGEXT, rhREGSEL} = {1'b0, 5'o37}; // RHWC
          rhADDR04: {rhREGEXT, rhREGSEL} = {1'b0, 5'o37}; // RHBA
          rhADDR06: {rhREGEXT, rhREGSEL} = {1'b1, 5'o05}; // RPDA/RMDA/MTFC

          rhADDR10: {rhREGEXT, rhREGSEL} = {1'b0, 5'o37}; // RHCS2
          rhADDR12: {rhREGEXT, rhREGSEL} = {1'b1, 5'o01}; // RPDS/RMAS/MTDS
          rhADDR14: {rhREGEXT, rhREGSEL} = {1'b1, 5'o02}; // RPER1/RMER1/MTER
          rhADDR16: {rhREGEXT, rhREGSEL} = {1'b1, 5'o04}; // RHAS/RMAS/MTAS

          rhADDR20: {rhREGEXT, rhREGSEL} = {1'b1, 5'o07}; // RPLA/RMLA/MTCC
          rhADDR22: {rhREGEXT, rhREGSEL} = {1'b0, 5'o37}; // RHDB
          rhADDR24: {rhREGEXT, rhREGSEL} = {1'b1, 5'o03}; // RPMR/RMMR1/MTMR
          rhADDR26: {rhREGEXT, rhREGSEL} = {1'b1, 5'o06}; // RPDT/RMTD/MTDT

          rhADDR30: {rhREGEXT, rhREGSEL} = {1'b1, 5'o10}; // RPSN/RMSN/MTSN
          rhADDR32: {rhREGEXT, rhREGSEL} = {1'b1, 5'o11}; // RPOF/RMOF/MTTC
          rhADDR34: {rhREGEXT, rhREGSEL} = {1'b1, 5'o12}; // RPDC/RMDC/-
          rhADDR36: {rhREGEXT, rhREGSEL} = {1'b1, 5'o13}; // RPCC/RMHR/-

          rhADDR40: {rhREGEXT, rhREGSEL} = {1'b1, 5'o14}; // RPER2/RMMR2/-
          rhADDR42: {rhREGEXT, rhREGSEL} = {1'b1, 5'o15}; // RPER3/RMER2/-
          rhADDR44: {rhREGEXT, rhREGSEL} = {1'b1, 5'o16}; // RPER1/RMEC1/-
          rhADDR46: {rhREGEXT, rhREGSEL} = {1'b1, 5'o17}; // RPER2/RMEC2/-

          rhADDR50: {rhREGEXT, rhREGSEL} = {1'b1, 5'o20}; // Unused
          rhADDR52: {rhREGEXT, rhREGSEL} = {1'b1, 5'o21}; // Unused
          rhADDR54: {rhREGEXT, rhREGSEL} = {1'b1, 5'o22}; // Unused
          rhADDR56: {rhREGEXT, rhREGSEL} = {1'b1, 5'o23}; // Unused

          rhADDR60: {rhREGEXT, rhREGSEL} = {1'b1, 5'o24}; // Unused
          rhADDR62: {rhREGEXT, rhREGSEL} = {1'b1, 5'o25}; // Unused
          rhADDR64: {rhREGEXT, rhREGSEL} = {1'b1, 5'o26}; // Unused
          rhADDR66: {rhREGEXT, rhREGSEL} = {1'b1, 5'o27}; // Unused

          rhADDR70: {rhREGEXT, rhREGSEL} = {1'b1, 5'o30}; // Unused
          rhADDR72: {rhREGEXT, rhREGSEL} = {1'b1, 5'o31}; // Unused
          rhADDR74: {rhREGEXT, rhREGSEL} = {1'b1, 5'o32}; // Unused
          rhADDR76: {rhREGEXT, rhREGSEL} = {1'b1, 5'o33}; // Unused

          default : {rhREGEXT, rhREGSEL} = {1'b0, 5'o37}; // Everything else
        endcase
     end

   //
   // RH11 Registers
   //

   wire [15: 0] rhCS1;                   // RHCS1
   wire [15: 0] rhWC;                    // RHWC
   wire [17: 0] rhBA;                    // RHBA
   wire [15: 0] rhCS2;                   // RHCS2
   wire [15: 0] rhDB;                    // RHDB

   //
   // RH11 Control/Status #2 (CS2) Register
   //

   wire         rhDLT  = `rhCS2_DLT(rhCS2);
   wire         rhWCE  = `rhCS2_WCE(rhCS2);
   wire         rhUPE  = `rhCS2_UPE(rhCS2);
   wire         rhNED  = `rhCS2_NED(rhCS2);
   wire         rhNEM  = `rhCS2_NEM(rhCS2);
   wire         rhPGE  = `rhCS2_PGE(rhCS2);
   wire         rhMXF  = `rhCS2_MXF(rhCS2);
   wire         rhDPE  = `rhCS2_DPE(rhCS2);
   wire         rhCLR  = `rhCS2_CLR(rhCS2);
   wire         rhPAT  = `rhCS2_PAT(rhCS2);
   wire         rhBAI  = `rhCS2_BAI(rhCS2);
   wire [ 2: 0] rhUNIT = `rhCS2_UNIT(rhCS2);

   //
   // RH11 Control/Status #1 (CS1) Register
   //

   wire         rhSC   = `rhCS1_SC (rhCS1);
   wire         rhRDY  = `rhCS1_RDY(rhCS1);
   wire         rhIE   = `rhCS1_IE (rhCS1);
   wire [ 5: 1] rhFUN  = `rhCS1_FUN(rhCS1);
   wire         rhDVA  =  massbus.mbDVA;
   wire         rhGO;

   //
   // RHDS Status
   //

   wire         rhDRY  = massbus.mbDRY;

   //
   // RH11 Attention Summary (RHAS) Pseudo Register
   //

   wire [15: 0] rhAS = {8'b0,
                        massbus.mbATA[7], massbus.mbATA[6],
                        massbus.mbATA[5], massbus.mbATA[4],
                        massbus.mbATA[3], massbus.mbATA[2],
                        massbus.mbATA[1], massbus.mbATA[0]};

   //
   // ATA (from all disks)
   //

   wire         rhATA = (massbus.mbATA[7] | massbus.mbATA[6] |
                         massbus.mbATA[5] | massbus.mbATA[4] |
                         massbus.mbATA[3] | massbus.mbATA[2] |
                         massbus.mbATA[1] | massbus.mbATA[0]);

   //
   // RH Signals
   //

   wire rhSETNEM;                       // Set non-existent memory
   wire rhSETDLT;                       // Set device late
   wire rhBUFIR;                        // Buffer input ready
   wire rhBUFOR;                        // Buffer output ready
   wire rhIRQ;                          // Interrupt request

   //
   // Transfer Error Clear
   //

   wire rhCLRTRE = rhWRREG00 & devHIBYTE & `rhCS1_TRE(rhDATAI);

   //
   // Set Non-existant Device (NED)
   //  Only external registers
   //

   wire rhSETNED = ((rhREAD  & rhREGEXT & !massbus.mbREGACK) |
                    (rhWRITE & rhREGEXT & !massbus.mbREGACK));

   //
   // Command Clear
   //  This decodes functions 24 through 37.  Some of these are used by the Disk
   //  Drives, some are used by the Tape Drives, and some are unused.
   //
   //  See comments below.
   //
   // Trace
   //  M7296/CSRA/E6
   //  M7296/CSRA/E14
   //  M7296/CSRA/E16
   //  M7296/CSRA/E17
   //
   //                                                                                           // ------- RP06 -------   ------- TM02 -------
   wire rhCLRGO = ((rhWRREG00 & rhRDY & (`rhCS1_FUN(rhDATAI) == 5'o24) & `rhCS1_GO(rhDATAI)) |  // Write Check            Write Check Forward
                   (rhWRREG00 & rhRDY & (`rhCS1_FUN(rhDATAI) == 5'o25) & `rhCS1_GO(rhDATAI)) |  // Write Check Header
                   (rhWRREG00 & rhRDY & (`rhCS1_FUN(rhDATAI) == 5'o26) & `rhCS1_GO(rhDATAI)) |  //
                   (rhWRREG00 & rhRDY & (`rhCS1_FUN(rhDATAI) == 5'o27) & `rhCS1_GO(rhDATAI)) |  //                        Write Check Reverse
                   (rhWRREG00 & rhRDY & (`rhCS1_FUN(rhDATAI) == 5'o30) & `rhCS1_GO(rhDATAI)) |  // Write                  Write Forward
                   (rhWRREG00 & rhRDY & (`rhCS1_FUN(rhDATAI) == 5'o31) & `rhCS1_GO(rhDATAI)) |  // Write Header
                   (rhWRREG00 & rhRDY & (`rhCS1_FUN(rhDATAI) == 5'o32) & `rhCS1_GO(rhDATAI)) |  //
                   (rhWRREG00 & rhRDY & (`rhCS1_FUN(rhDATAI) == 5'o33) & `rhCS1_GO(rhDATAI)) |  //
                   (rhWRREG00 & rhRDY & (`rhCS1_FUN(rhDATAI) == 5'o34) & `rhCS1_GO(rhDATAI)) |  // Read                   Read Forward
                   (rhWRREG00 & rhRDY & (`rhCS1_FUN(rhDATAI) == 5'o35) & `rhCS1_GO(rhDATAI)) |  // Read Header
                   (rhWRREG00 & rhRDY & (`rhCS1_FUN(rhDATAI) == 5'o36) & `rhCS1_GO(rhDATAI)) |  //
                   (rhWRREG00 & rhRDY & (`rhCS1_FUN(rhDATAI) == 5'o37) & `rhCS1_GO(rhDATAI)));  //                        Read Reverse

   //
   // Program Error
   //  A data transfer command (functions 24 through 37) while the controller
   //  is busy is a program error.  The command is not passed to the drive.
   //

   wire rhSETPGE = (rhWRREG00 & devLOBYTE & !rhRDY & `rhCS1_GO(rhDATAI) &
                    (`rhCS1_FUN(rhDATAI) >= 5'o24));

   reg rhPGEGO;

   always @(posedge clk)
     begin
        if (rst)
          rhPGEGO <= 0;
        else
          rhPGEGO <= rhSETPGE;
     end

   //
   // Controller Ready (RHCS1[RDY])
   //  RDY is a controller flag.  It is not the DRY bit of the selected drive.
   //  A data transfer command clears it and it is set again when the drive
   //  doing the transfer is ready.  The transfer drive is remembered so that
   //  selecting another drive (RHCS2[UNIT]) during a transfer, for example to
   //  read its registers or start a seek, does not change RDY.
   //
   //  If the drive never goes busy, RDY is set again when the drive raises
   //  ATA (command rejected) or after a timeout.
   //
   //  Drive Exception
   //   On the Massbus, a drive that has an error during a data transfer
   //   asserts EXC and the RH11 sets RHCS1[TRE].  This is modelled by
   //   watching the composite error (RHDS[ERR]) of the transfer drive: if
   //   it sets while the transfer is in progress, TRE is set.  An error
   //   that was already present when the command was issued is ignored.
   //   DSRPA TEST-326 checks this after forcing an OPI error.
   //

   reg       ctlRDY;                    // Controller ready
   reg [2:0] xfrUNIT;                   // Drive doing the transfer
   reg       xfrBUSY;                   // Transfer drive has gone busy
   reg [9:0] xfrTIME;                   // Clocks since the transfer started
   reg       xfrLASTERR;                // Transfer drive ERR last clock

   wire xfrDRY = massbus.mbDRYA[xfrUNIT];
   wire xfrATA = massbus.mbATA[xfrUNIT];
   wire xfrERR = massbus.mbERRA[xfrUNIT];
   wire rhEXC  = !ctlRDY & xfrERR & !xfrLASTERR;

   always @(posedge clk)
     begin
        if (rst | devRESET | rhCLR)
          begin
             ctlRDY     <= 1;
             xfrUNIT    <= 0;
             xfrBUSY    <= 0;
             xfrTIME    <= 0;
             xfrLASTERR <= 1;
          end
        else if (rhCLRGO)
          begin
             ctlRDY     <= 0;
             xfrUNIT    <= rhUNIT;
             xfrBUSY    <= 0;
             xfrTIME    <= 0;
             xfrLASTERR <= 1;
          end
        else if (!ctlRDY)
          begin
             xfrLASTERR <= xfrERR;
             if (!xfrDRY)
               xfrBUSY <= 1;
             if (xfrTIME != 10'o1777)
               xfrTIME <= xfrTIME + 1'b1;
             if ((xfrBUSY & xfrDRY) |
                 (!xfrBUSY & xfrDRY & xfrATA & (xfrTIME >= 10'd64)) |
                 (!xfrBUSY & xfrDRY & (xfrTIME == 10'o1777)) |
                 rhNED)
               ctlRDY <= 1;
          end
     end

   //
   // Controller Parity Error
   //  Massbus device is sending inverted parity to RH11 in maintenance mode.
   //

   wire rhSETCPE = rhREAD & massbus.mbCPE;

   //
   // RH11 Control/Status #1 (RHCS1) Register
   //

   RHCS1 CS1 (
      .clk        (clk),
      .rst        (rst),
      .devRESET   (devRESET),
      .devLOBYTE  (devLOBYTE),
      .devHIBYTE  (devHIBYTE),
      .rhDATAI    (rhDATAI),
      .rhcs1WRITE (rhWRREG00),
      .rhCLRGO    (rhCLRGO),
      .rhCLRTRE   (rhCLRTRE),
      .rhSETCPE   (rhSETCPE),
      .rhDLT      (rhDLT),
      .rhWCE      (rhWCE),
      .rhUPE      (rhUPE),
      .rhNED      (rhNED),
      .rhNEM      (rhNEM),
      .rhPGE      (rhPGE),
      .rhMXF      (rhMXF),
      .rhDPE      (rhDPE),
      .rhCLR      (rhCLR),
      .rhIACK     (rhIACK),
      .rhATA      (rhATA),
      .rhDVA      (rhDVA),
      .rhDRY      (rhDRY),
      .rhCRDY     (ctlRDY),
      .rhEXC      (rhEXC),
      .rhBA       (rhBA[17:16]),
      .rhGO       (rhGO),
      .rhCS1      (rhCS1)
   );

   //
   // RH11 Word Count (RHWC) Register
   //

   RHWC WC (
      .clk        (clk),
      .rst        (rst),
      .devRESET   (devRESET),
      .devLOBYTE  (devLOBYTE),
      .devHIBYTE  (devHIBYTE),
      .rhDATAI    (rhDATAI),
      .rhwcWRITE  (rhWRREG02),
      .rhCLR      (rhCLR),
      .rhINCWC    (massbus.mbINCWC),
      .rhWC       (rhWC)
   );

   //
   // RH11 Bus Address (RHBA) Register
   //

   RHBA BA (
      .clk        (clk),
      .rst        (rst),
      .devRESET   (devRESET),
      .devLOBYTE  (devLOBYTE),
      .devHIBYTE  (devHIBYTE),
      .rhDATAI    (rhDATAI),
      .rhcs1WRITE (rhWRREG00),
      .rhbaWRITE  (rhWRREG04),
      .rhCLR      (rhCLR),
      .rhRDY      (rhRDY),
      .rhBAI      (rhBAI),
      .rhINCBA    (massbus.mbINCBA),
      .rhDECBA    (massbus.mbDECBA),
      .rhBA       (rhBA)
   );

   //
   // RH11 Control/Status #2 (RHCS2) Register
   //

   RHCS2 CS2 (
      .clk        (clk),
      .rst        (rst),
      .devRESET   (devRESET),
      .devLOBYTE  (devLOBYTE),
      .devHIBYTE  (devHIBYTE),
      .rhDATAI    (rhDATAI),
      .rhcs2WRITE (rhWRREG10),
      .rhCMDGO    (rhSETPGE),
      .rhCLRGO    (rhCLRGO),
      .rhCLRTRE   (rhCLRTRE),
      .rhCLR      (rhCLR),
      .rhRDY      (rhRDY),
      .rhSETDLT   (rhSETDLT),
      .rhSETNED   (rhSETNED),
      .rhSETNEM   (rhSETNEM),
      .rhSETDPE   (massbus.mbDPE),
      .rhSETWCE   (massbus.mbWCE),
      .rhBUFIR    (rhBUFIR),
      .rhBUFOR    (rhBUFOR),
      .rhCS2      (rhCS2)
   );

   //
   // RH11 Data Buffer (RHDB) Register
   //

   RHDB DB (
      .clk        (clk),
      .rst        (rst),
      .devRESET   (devRESET),
      .devLOBYTE  (devLOBYTE),
      .devHIBYTE  (devHIBYTE),
      .rhDATAI    (rhDATAI),
      .rhCLRGO    (rhCLRGO),
      .rhCLRTRE   (rhCLRTRE),
      .rhCLR      (rhCLR),
      .rhdbREAD   (rhRDREG22),
      .rhdbWRITE  (rhWRREG22),
      .rhSETDLT   (rhSETDLT),
      .rhBUFIR    (rhBUFIR),
      .rhBUFOR    (rhBUFOR),
      .rhDB       (rhDB)
   );

   //
   // RH11 Interrupt Controller
   //

   RHINTR INTR (
      .clk        (clk),
      .rst        (rst),
      .devRESET   (devRESET),
      .devLOBYTE  (devLOBYTE),
      .rhDATAI    (rhDATAI),
      .rhcs1WRITE (rhWRREG00),
      .rhSC       (rhSC),
      .rhRDY      (rhRDY),
      .rhIE       (rhIE),
      .rhCLR      (rhCLR),
      .rhIACK     (rhIACK),
      .rhIRQ      (rhIRQ)
   );

   //
   // Non-existent Memory
   //

   RHNEM NEM (
      .clk        (clk),
      .rst        (rst),
      .devREQO    (unibus.devREQO),
      .devACKI    (unibus.devACKI),
      .setNEM     (rhSETNEM)
   );

   //
   // Generate Bus ACK
   //
   //  Diagnostics expect a UBA Timeout (UBASR[TMO]) if accessing a register
   //  that is not addressable for this type of device.
   //

   assign unibus.devACKO = ((rhREAD  &  rhISDISK & (devADDR >= rhADDR00) & (devADDR <= rhADDR46)) |
                            (rhWRITE &  rhISDISK & (devADDR >= rhADDR00) & (devADDR <= rhADDR46)) |
                            (rhREAD  & !rhISDISK & (devADDR >= rhADDR00) & (devADDR <= rhADDR32)) |
                            (rhWRITE & !rhISDISK & (devADDR >= rhADDR00) & (devADDR <= rhADDR32)) |
                            vectREAD);

   //
   // Bus Mux and little-endian to big-endian bus swap.
   //  Only output the RP register if the disk is present.
   //

   always @*
     begin
        unibus.devDATAO = 0;
        if (massbus.mbREQO)
          unibus.devDATAO = massbus.mbDATAO;
        if (rhRDREG00)
          unibus.devDATAO = {20'b0, rhCS1};                     // RHCS1
        if (rhRDREG02)
          unibus.devDATAO = {20'b0, rhWC};                      // RHWC
        if (rhRDREG04)
          unibus.devDATAO = {20'b0, rhBA[15:0]};                // RHBA
        if (rhRDREG06 & massbus.mbREGACK)
          unibus.devDATAO = {20'b0, massbus.mbREGDAT};          // RPDA,  MTFC
        if (rhRDREG10)
          unibus.devDATAO = {20'b0, rhCS2};                     // RHCS2
        if (rhRDREG12 & massbus.mbREGACK)
          unibus.devDATAO = {20'b0, massbus.mbREGDAT};          // RPDS,  MTDS
        if (rhRDREG14 & massbus.mbREGACK)
          unibus.devDATAO = {20'b0, massbus.mbREGDAT};          // RPER1, MTER
        if (rhRDREG16)
          unibus.devDATAO = {20'b0, rhAS};                      // RHAS
        if (rhRDREG20 & massbus.mbREGACK)
          unibus.devDATAO = {20'b0, massbus.mbREGDAT};          // RPLA,  MTCC
        if (rhRDREG22)
          unibus.devDATAO = {20'b0, rhDB};                      // RHDB
        if (rhRDREG24 & massbus.mbREGACK)
          unibus.devDATAO = {20'b0, massbus.mbREGDAT};          // RPMR,  MTMR
        if (rhRDREG26 & massbus.mbREGACK)
          unibus.devDATAO = {20'b0, massbus.mbREGDAT};          // RPDT,  MTDT
        if (rhRDREG30 & massbus.mbREGACK)
          unibus.devDATAO = {20'b0, massbus.mbREGDAT};          // RPSN,  MTSN
        if (rhRDREG32 & massbus.mbREGACK)
          unibus.devDATAO = {20'b0, massbus.mbREGDAT};          // RPOF,  MTTC
        if (rhRDREG34 & massbus.mbREGACK)
          unibus.devDATAO = {20'b0, massbus.mbREGDAT};          // RPDC,  Zero
        if (rhRDREG36 & massbus.mbREGACK)
          unibus.devDATAO = {20'b0, massbus.mbREGDAT};          // RPCC,  Zero
        if (rhRDREG40 & massbus.mbREGACK)
          unibus.devDATAO = {20'b0, massbus.mbREGDAT};          // RPER2, Zero
        if (rhRDREG42 & massbus.mbREGACK)
          unibus.devDATAO = {20'b0, massbus.mbREGDAT};          // RPER3, Zero
        if (rhRDREG44 & massbus.mbREGACK)
          unibus.devDATAO = {20'b0, massbus.mbREGDAT};          // RPEC1, Zero
        if (rhRDREG46 & massbus.mbREGACK)
          unibus.devDATAO = {20'b0, massbus.mbREGDAT};          // RPEC2, Zero
        if (vectREAD)
          unibus.devDATAO = {20'b0, rhVECT[20:35]};
     end

   //
   // Interrupt Request
   //

   assign unibus.devINTRO = rhIRQ ? rhINTR : 4'b0;

   //
   // Unibus Interface
   //

   assign unibus.devREQO  = massbus.mbREQO;
   assign unibus.devACLO  = massbus.mbACLO;
   assign unibus.devADDRO = massbus.mbNPRO ? {wrFLAGS, rhBA} : {rdFLAGS, rhBA};

   //
   // Hookup Massbus Outputs
   //

   assign massbus.clk      = clk;
   assign massbus.rst      = rst;
   assign massbus.mbINIT   = devRESET | rhCLR;
   assign massbus.mbACKI   = unibus.devACKI;
   assign massbus.mbDATAI  = unibus.devDATAI;
   assign massbus.mbREAD   = rhREAD  & rhREGEXT;
   assign massbus.mbWRITE  = rhWRITE & rhREGEXT;
   assign massbus.mbREGSEL = rhREGSEL;
   assign massbus.mbFUN    = rhFUN;
   assign massbus.mbGO     = rhGO & !rhPGEGO;
   assign massbus.mbUNIT   = rhUNIT;
   assign massbus.mbPAT    = rhPAT;
   assign massbus.mbWCZ    = (rhWC == 0);

   //
   // Debug output
   //

`ifndef SYNTHESIS

   assign massbus.file = file;

   initial
     begin
        file = $fopen("rhstatus.txt", "w");
        $fwrite(file, "[%11.3f] RH11: Debug Mode.\n", $time/1.0e3);
        $fflush(file);
     end

   always @(posedge clk)
     begin
        if (rhSETNEM)
          begin
             $display("[%11.3f] RH11: Unacknowledged bus cycle.  Addr Bus = %012o", $time/1.0e3, unibus.devADDRO);
             $stop;
          end
        if (unibus.devACKI)
          begin
             if (massbus.mbNPRO)
               $fwrite(file, "[%11.3f] RH11: Wrote %012o to address %012o.  rhWC = 0x%04x\n", $time/1.0e3, unibus.devDATAO, unibus.devADDRO, rhWC);
             else
               $fwrite(file, "[%11.3f] RH11: Read %012o from address %012o.  rhWC = 0x%04x\n", $time/1.0e3, unibus.devDATAI, unibus.devADDRO, rhWC);
             $fflush(file);
          end
     end

   //
   // Interrupt and attention monitor (define SIM_RHMON to enable)
   //
   // Reports why the interrupt flip-flop sets, interrupt requests and
   // acknowledges, RDY transitions, commands, unit selects and changes to
   // the attention summary.
   //

`ifdef SIM_RHMON

   reg        lastIRQ;
   reg        lastRDYMON;
   reg [15:0] lastAS;
   reg [ 2:0] lastUNIT;

   always @(posedge clk)
     begin
        if (rst)
          begin
             lastIRQ    <= 0;
             lastRDYMON <= 0;
             lastAS     <= 0;
             lastUNIT   <= 0;
          end
        else
          begin
             lastIRQ    <= rhIRQ;
             lastRDYMON <= rhRDY;
             lastAS     <= rhAS;
             lastUNIT   <= rhUNIT;

             if (rhRDY & !INTR.lastRDY & rhIE & !INTR.rhIFF)
               $display("[%11.3f] RHMON %m: IFF set by RDY edge. Unit=%o CS1=%06o AS=%03o",
                        $time/1.0e3, rhUNIT, rhCS1, rhAS);
             if (rhWRREG00 & devLOBYTE & `rhCS1_RDY(rhDATAI) & `rhCS1_IE(rhDATAI))
               $display("[%11.3f] RHMON %m: IFF set by CS1 write of RDY+IE. Data=%06o Unit=%o CS1=%06o",
                        $time/1.0e3, rhDATAI[15:0], rhUNIT, rhCS1);
             if (rhIRQ & !lastIRQ)
               $display("[%11.3f] RHMON %m: IRQ asserted (IFF=%b SC&RDY=%b IE=%b). Unit=%o CS1=%06o AS=%03o",
                        $time/1.0e3, INTR.rhIFF, rhSC & rhRDY, rhIE, rhUNIT, rhCS1, rhAS);
             if (rhIACK)
               $display("[%11.3f] RHMON %m: IACK. Unit=%o CS1=%06o AS=%03o",
                        $time/1.0e3, rhUNIT, rhCS1, rhAS);
             if (rhRDY != lastRDYMON)
               $display("[%11.3f] RHMON %m: RDY %b->%b. Unit=%o UnitChanged=%b",
                        $time/1.0e3, lastRDYMON, rhRDY, rhUNIT, rhUNIT != lastUNIT);
             if (rhUNIT != lastUNIT)
               $display("[%11.3f] RHMON %m: Unit select %o->%o. RDY=%b IE=%b",
                        $time/1.0e3, lastUNIT, rhUNIT, rhRDY, rhIE);
             if (rhWRREG00 & devLOBYTE & `rhCS1_GO(rhDATAI))
               $display("[%11.3f] RHMON %m: Command. Data=%06o Fun=%02o Unit=%o RDY=%b",
                        $time/1.0e3, rhDATAI[15:0], `rhCS1_FUN(rhDATAI), rhUNIT, rhRDY);
             if (rhAS != lastAS)
               $display("[%11.3f] RHMON %m: AS %03o->%03o",
                        $time/1.0e3, lastAS, rhAS);
             if (rhREAD & unibus.devACKO & rhISDISK)
               $display("[%11.3f] RHMON %m: Read reg %02o = %06o. Unit=%o",
                        $time/1.0e3, devADDR - rhADDR, unibus.devDATAO[20:35], rhUNIT);
          end
     end

`endif

`endif

endmodule
