////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KS10 Console to Disk Drive Interface Bus
//
// Details
//   This file contains interface definitions for Disk Drive Interface Bus
//
// File
//   rpcslbus.sv
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
// RP/CSL Interface
//

interface rpcslbus;
   logic [ 7: 0] rpDPR;                 // Drive present
   logic [ 7: 0] rpMOL;                 // Media on-line
   logic [ 7: 0] rpWRL;                 // Write lock
   logic [ 0:63] rpDEBUG;               // Debug Register

   //
   // CSL Port
   //

   modport csl (
      output rpDPR,                     // Drive present
      output rpMOL,                     // Media on-line
      output rpWRL,                     // Write lock
      input  rpDEBUG                    // Debug Register
   );

   //
   // RP Port
   //

   modport rp (
      input  rpDPR,                     // Drive present
      input  rpMOL,                     // Media on-line
      input  rpWRL,                     // Write lock
      output rpDEBUG                    // Debug Register
   );

endinterface
