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
   logic         devRESET;              // Device Reset
   logic         devACLO;               // Power Fail

   //
   // Initiator
   //

   logic         devREQO;               // Massbus Request Out
   logic         devACKI;               // Massbus Acknowledge In
   logic [ 0:35] devDATAI;              // Massbus Data In
   logic [ 0:35] devDATAO;              // Massbus Data Out

   //
   // Register Addressing
   //

   logic [18:35] mbADDR;                // Address
   logic         mbREAD;                // Read
   logic         mbWRITE;               // Write

   //
   // From RH11 to Massbus
   //

   logic [15: 0] rhCS1;                 // RHCS1
   logic [15: 0] rhCS2;                 // RHCS2
   logic [15: 0] rhWC;                  // RHWC

   logic         mbWRREG00;             // Write RPCS1, MTCS1  (RHCS1) (Need RHCS2[GO])
// logic         mbWRREG02;             // Write RPWC,  MTWC   (RHWC)
// logic         mbWRREG04;             // Write RPBA,  MTBA   (RHBA)
   logic         mbWRREG06;             // Write RPDA,  MTFC

// logic         mbWRREG10;             // Write RPCS2, MTCS2  (RHCS2)
// logic         mbWRREG12;             // Write RPDS,  MTDS           (Read Only)
   logic         mbWRREG14;             // Write RPER1, MTER           (Read Only)
   logic         mbWRREG16;             // Write RPAS,  MTAS   (RHAS)

   logic         mbWRREG20;             // Write RPLA,  MTCC
// logic         mbWRREG22;             // Write RPDB,  MTDB   (RHDB)
   logic         mbWRREG24;             // Write RPMR,  MTMR
// logic         mbWRREG26;             // Write RPDT,  MTDT           (Read only)

// logic         mbWRREG30;             // Write RPSN,  MTSN           (Read Only)
   logic         mbWRREG32;             // Write RPOF,  MTTC
   logic         mbWRREG34;             // Write RPDC,  Zero
   logic         mbWRREG36;             // Write RPCC,  Zero

   logic         mbWRREG40;             // Write RPER2, Zero
   logic         mbWRREG42;             // Write RPER3, Zero
   logic         mbWRREG44;             // Write RPEC1, Zero
   logic         mbWRREG46;             // Write RPEC2, Zero

   //
   // From Massbus to RH11
   //

   logic         mbINVPAR;              // Received data has even (wrong parity
   logic         incBA4;                // Increment Address by 4
   logic         incWC2;                // Increment Word Count by 2
   logic         setWCE;                // Set write check error
   logic         setNPRO;               // Set NPR output

   logic [15: 0] mbREG00[0:7];          // RPCS1, MTCS1  (RHCS1) (Need RHCS2[GO])
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

      output clk,                       // Clock
      output rst,                       // Reset
`ifndef SYNTHESIS
      output file,                      // Debug file
`endif
      output devRESET,                  // Massbus Reset
      input  devACLO,                   // Massbus Power Fail

      input  devREQO,                   // Massbus Request Out
      output devACKI,                   // Massbus Acknowledge In
      output devDATAI,                  // Massbus Data In
      input  devDATAO,                  // Massbus Data Out

      output mbADDR,                    // Address
      output mbREAD,                    // Read
      output mbWRITE,                   // Write

      output rhCS1,                     // RHCS1
      output rhCS2,                     // RHCS2
      output rhWC,                      // rhWC

      input  mbINVPAR,                  // Data has inverted (wrong) parity
      input  incBA4,                    // Increment Address by 4
      input  incWC2,                    // Increment Word Count by 2
      input  setWCE,                    // Set write check error
      input  setNPRO,                   // Set NPR output

      output mbWRREG00,                 // Write RPCS1, MTCS1  (RHCS1) (Need RHCS2[GO])
//    output mbWRREG02,                 // Write RPWC,  MTWC   (RHWC)
//    output mbWRREG04,                 // Write RPBA,  MTBA   (RHBA)
      output mbWRREG06,                 // Write RPDA,  MTFC

//    output mbWRREG10,                 // Write RPCS2, MTCS2  (RHCS2)
//    output mbWRREG12,                 // Write RPDS,  MTDS           (Read Only)
      output mbWRREG14,                 // Write RPER1, MTER           (Read Only)
      output mbWRREG16,                 // Write RPAS,  MTAS   (RHAS)

      output mbWRREG20,                 // Write RPLA,  MTCC
//    output mbWRREG22,                 // Write RPDB,  MTDB   (RHDB)
      output mbWRREG24,                 // Write RPMR,  MTMR
//    output mbWRREG26,                 // Write RPDT,  MTDT           (Read Only)

//    output mbWRREG30,                 // Write RPSN,  MTSN           (Read Only)
      output mbWRREG32,                 // Write RPOF,  MTTC
      output mbWRREG34,                 // Write RPDC,  Zero
      output mbWRREG36,                 // Write RPCC,  Zero

      output mbWRREG40,                 // Write RPER2, Zero
      output mbWRREG42,                 // Write RPER3, Zero
      output mbWRREG44,                 // Write RPEC1, Zero
      output mbWRREG46,                 // Write RPEC2, Zero

      input  mbREG00,                   // RPCS1, MTCS1  (RHCS1)
//    input  mbREG02,                   // RPWC,  MTWC   (RHWC)
//    input  mbREG04,                   // RPBA,  MTBA   (RHBA)
      input  mbREG06,                   // RPDA,  MTFC

//    input  mbREG10,                   // RPCS2, MTCS2  (RHCS2)
      input  mbREG12,                   // RPDS,  MTDS
      input  mbREG14,                   // RPER1, MTER
//    input  mbREG16,                   // RPAS,  MTAS   (RHAS)        (Pseudo Reg)

      input  mbREG20,                   // RPLA,  MTCC
//    input  mbREG22,                   // RPDB,  MTDB   (RHDB)
      input  mbREG24,                   // RPMR,  MTMR
      input  mbREG26,                   // RPDT,  MTDT

      input  mbREG30,                   // RPSN,  MTSN
      input  mbREG32,                   // RPOF,  MTTC
      input  mbREG34,                   // RPDC,  Zero
      input  mbREG36,                   // RPCC,  Zero

      input  mbREG40,                   // RPER2, Zero
      input  mbREG42,                   // RPER3, Zero
      input  mbREG44,                   // RPEC1, Zero
      input  mbREG46                    // RPEC2, Zero
   );

   //
   // Slave Port
   //

   modport slave (
      input  clk,                       // Clock
      input  rst,                       // Reset
`ifndef SYNTHESIS
      input  file,                      // Debug file
`endif
      input  devRESET,                  // Massbus Reset
      output devACLO,                   // Massbus Power Fail

      output devREQO,                   // Massbus Request Out
      input  devACKI,                   // Massbus Acknowledge In
      input  devDATAI,                  // Massbus Data In
      output devDATAO,                  // Massbus Data Out

      input  mbADDR,                    // Address
      input  mbREAD,                    // Read
      input  mbWRITE,                   // Write

      input  rhCS1,                     // rhCS1
      input  rhCS2,                     // rhCS2
      input  rhWC,                      // rhWC

      output mbINVPAR,                  // Data has inverted (wrong) parity
      output incBA4,                    // Increment Address by 4
      output incWC2,                    // Increment Word Count by 2
      output setWCE,                    // Set write check error
      output setNPRO,                   // Set NPR Output

      input  mbWRREG00,                 // Write RPCS1, MTCS1  (RHCS1) (Need RHCS2[GO])
//    input  mbWRREG02,                 // Write RPWC,  MTWC   (RHWC)
//    input  mbWRREG04,                 // Write RPBA,  MTBA   (RHBA)
      input  mbWRREG06,                 // Write RPDA,  MTFC

//    input  mbWRREG10,                 // Write RPCS2, MTCS2  (RHCS2)
//    input  mbWRREG12,                 // Write RPDS,  MTDS           (Read Only)
      input  mbWRREG14,                 // Write RPER1, MTER           (Read Only)
      input  mbWRREG16,                 // Write RPAS,  MTAS   (RHAS)

      input  mbWRREG20,                 // Write RPLA,  MTCC
//    input  mbWRREG22,                 // Write RPDB,  MTDB   (RHDB)
      input  mbWRREG24,                 // Write RPMR,  MTMR
//    input  mbWRREG26,                 // Write RPDT,  MTDT           (Read Only)

//    input  mbWRREG30,                 // Write RPSN,  MTSN           (Read Only)
      input  mbWRREG32,                 // Write RPOF,  MTTC
      input  mbWRREG34,                 // Write RPDC,  Zero
      input  mbWRREG36,                 // Write RPCC,  Zero

      input  mbWRREG40,                 // Write RPER2, Zero
      input  mbWRREG42,                 // Write RPER3, Zero
      input  mbWRREG44,                 // Write RPEC1, Zero
      input  mbWRREG46,                 // Write RPEC2, Zero

      output mbREG00,                   // RPCS1, MTCS1 (RHCS1)
//    output mbREG02,                   // RPWC,  MTWC  (RHWC)
//    output mbREG04,                   // RPBA,  MTBA  (RHBA)
      output mbREG06,                   // RPDA,  MTFC

//    output mbREG10,                   // RPCS2, MTCS2 (RHCS2)
      output mbREG12,                   // RPDS,  MTDS
      output mbREG14,                   // RPER1, MTER
//    output mbREG16,                   // RPAS,  MTAS  (RHAS)

      output mbREG20,                   // RPLA,  MTCC
//    output mbREG22,                   // RPDB,  MTDB  (RHDB)
      output mbREG24,                   // RPMR,  MTMR
      output mbREG26,                   // RPDT,  MTDT

      output mbREG30,                   // RPSN,  MTSN
      output mbREG32,                   // RPOF,  MTTC
      output mbREG34,                   // RPDC,  Zero
      output mbREG36,                   // RPCC,  Zero

      output mbREG40,                   // RPER2, Zero
      output mbREG42,                   // RPER3, Zero
      output mbREG44,                   // RPEC1, Zero
      output mbREG46                    // RPEC2, Zero
   );

endinterface
