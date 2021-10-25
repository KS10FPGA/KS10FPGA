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
   logic         mbDVA;                 // Drive available
   logic         mbDPR;			// Drive present
   logic         mbDRY;			// Drive ready
   logic [15: 0] mbREGDAT;		// Register data
   logic         mbREGACK;		// Register ack

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
      input  mbDPR,
      input  mbDRY,
      input  mbREGDAT,
      input  mbREGACK
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
      output mbDPR,
      output mbDRY,
      output mbREGDAT,
      output mbREGACK
   );

endinterface
