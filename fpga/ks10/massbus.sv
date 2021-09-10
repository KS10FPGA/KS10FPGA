////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KS10 Massbus Interface Definition
//
// Details
//   This file contains interface definitions for the KS10 IO Buses
//
// File
//   massbus.sv
//
// Note
//   This interface does not even vaguely resemble Massbus, but - it does
//   connect an RH11 to Disk Drives and Tape Drives.
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2021 Rob Doyle
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

//
// Massbus Interface
//

interface massbus;
   logic         clk;                   // Clock
   logic         rst;                   // Reset
`ifndef SYNTHESIS
   logic [31: 0] file;                  // File
`endif
   logic         mbINIT;                // Initialze
   logic         mbACLO;                // Power fail
   logic         mbREQO;                // Request out
   logic         mbACKI;                // Acknowledge in
   logic [ 0:35] mbDATAO;               // Data
   logic [ 0:35] mbDATAI;               // Data in
   logic         mbREAD;                // Register read
   logic         mbWRITE;               // Register write
   logic [ 4: 0] mbREGSEL;              // Register select (Address)
   logic [ 5: 1] mbFUN;                 // Function select (RHCS2[FUN])
   logic         mbGO;                  // Function GO     (RHCS2[ GO])
   logic [ 2: 0] mbUNIT;                // Unit select     (RHCS2[UNIT])
   logic         mbPAT;                 // Parity test     (RHCS2[PAT])
   logic         mbWCZ;                 // Word count is zero
   logic         mbINVPAR;              // Inverted parity
   logic         mbINCBA;               // Increment bus address
   logic         mbINCWC;               // Increment word count
   logic         mbWCE;                 // Write check error
   logic         mbNPRO;                // NPR output
   logic         mbATA[0:7];            // Attention
   logic         mbDVA[0:7];            // Drive available
// logic [15: 0] mbREG00[0:7];          // RPCS1, MTCS1  (RHCS1)
// logic [15: 0] mbREG02;               // RPWC,  MTWC   (RHWC)
// logic [15: 0] mbREG04;               // RPBA,  MTBA   (RHBA)
   logic [15: 0] mbREG06[0:7];          // RPDA,  MTFC
// logic [15: 0] mbREG10;               // RPCS2, MTCS2  (RHCS2)
   logic [15: 0] mbREG12[0:7];          // RPDS,  MTDS           (Read Only)
   logic [15: 0] mbREG14[0:7];          // RPER1, MTER           (Read Only)
// logic [15: 0] mbREG16;               // RPAS,  MTAS   (RHAS)  (Pseudo Reg)
   logic [15: 0] mbREG20[0:7];          // RPLA,  MTCC
// logic [15: 0] mbREG22;               // RPDB,  MTDB   (RHDB)
   logic [15: 0] mbREG24[0:7];          // RPMR,  MTMR
   logic [15: 0] mbREG26[0:7];          // RPDT,  MTDT
   logic [15: 0] mbREG30[0:7];          // RPSN,  MTSN
   logic [15: 0] mbREG32[0:7];          // RPOF,  MTTC
   logic [15: 0] mbREG34[0:7];          // RPDC,  Zero
   logic [15: 0] mbREG36[0:7];          // RPCC,  Zero
   logic [15: 0] mbREG40[0:7];          // RPER2, Zero
   logic [15: 0] mbREG42[0:7];          // RPER3, Zero
   logic [15: 0] mbREG44[0:7];          // RPEC1, Zero
   logic [15: 0] mbREG46[0:7];          // RPEC2, Zero

   //
   // Master Port
   //

   modport master (

      output clk,
      output rst,
`ifndef SYNTHESIS
      output file,
`endif
      output mbINIT,
      input  mbACLO,
      input  mbREQO,
      output mbACKI,
      input  mbDATAO,
      output mbDATAI,
      output mbREAD,
      output mbWRITE,
      output mbREGSEL,
      output mbFUN,
      output mbGO,
      output mbUNIT,
      output mbPAT,
      output mbWCZ,
      input  mbINVPAR,
      input  mbINCBA,
      input  mbINCWC,
      input  mbWCE,
      input  mbNPRO,
      input  mbATA,
      input  mbDVA,
//    input  mbREG00,
//    input  mbREG02,
//    input  mbREG04,
      input  mbREG06,
//    input  mbREG10,
      input  mbREG12,
      input  mbREG14,
//    input  mbREG16,
      input  mbREG20,
//    input  mbREG22,
      input  mbREG24,
      input  mbREG26,
      input  mbREG30,
      input  mbREG32,
      input  mbREG34,
      input  mbREG36,
      input  mbREG40,
      input  mbREG42,
      input  mbREG44,
      input  mbREG46
   );

   //
   // Slave Port
   //

   modport slave (
      input  clk,
      input  rst,
`ifndef SYNTHESIS
      input  file,
`endif
      input  mbINIT  ,
      output mbACLO,
      output mbREQO,
      input  mbACKI,
      input  mbDATAI,
      output mbDATAO,
      input  mbREAD,
      input  mbWRITE,
      input  mbREGSEL,
      input  mbFUN,
      input  mbGO,
      input  mbUNIT,
      input  mbPAT,
      input  mbWCZ,
      output mbINVPAR,
      output mbINCBA,
      output mbINCWC,
      output mbWCE,
      output mbNPRO,
      output mbATA,
      output mbDVA,
//    output mbREG00,
//    output mbREG02,
//    output mbREG04,
      output mbREG06,
//    output mbREG10,
      output mbREG12,
      output mbREG14,
//    output mbREG16,
      output mbREG20,
//    output mbREG22,
      output mbREG24,
      output mbREG26,
      output mbREG30,
      output mbREG32,
      output mbREG34,
      output mbREG36,
      output mbREG40,
      output mbREG42,
      output mbREG44,
      output mbREG46
   );

endinterface
