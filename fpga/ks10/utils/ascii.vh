////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   ASCII character definitions
//
// Details
//   This file contains the definitions for ASCII characters.
//
// File
//   ascii.vh
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

`ifndef __ASCII_VH
`define __ASCII_VH

//
// ASCII character definition
//

`define asciiNUL  (8'o000)
`define asciiSOH  (8'o001)
`define asciiSTX  (8'o002)
`define asciiETX  (8'o003)
`define asciiEOT  (8'o004)
`define asciiENQ  (8'o005)
`define asciiACK  (8'o006)
`define asciiBEL  (8'o007)
`define asciiBS   (8'o010)
`define asciiTAB  (8'o011)
`define asciiLF   (8'o012)
`define asciiVT   (8'o013)
`define asciiFF   (8'o014)
`define asciiCR   (8'o015)
`define asciiSO   (8'o016)
`define asciiSI   (8'o017)
`define asciiDLE  (8'o020)
`define asciiDC1  (8'o021)
`define asciiDC2  (8'o022)
`define asciiDC3  (8'o023)
`define asciiDC4  (8'o024)
`define asciiNAK  (8'o025)
`define asciiSYN  (8'o026)
`define asciiETB  (8'o027)
`define asciiCAN  (8'o030)
`define asciiEM   (8'o031)
`define asciiSUB  (8'o032)
`define asciiESC  (8'o033)
`define asciiFS   (8'o034)
`define asciiGS   (8'o035)
`define asciiRS   (8'o036)
`define asciiUS   (8'o037)
`define asciiSP   (8'o040)
`define asciiDEL  (8'o177)

//
// XON/XOFF handshaking aliases
//

`define asciiXON  (8'o021)
`define asciiXOFF (8'o023)

`endif