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

//
// ASCII character definition
//

localparam [7:0] asciiNUL  = 8'o000,
                 asciiSOH  = 8'o001,
                 asciiSTX  = 8'o002,
                 asciiETX  = 8'o003,
                 asciiEOT  = 8'o004,
                 asciiENQ  = 8'o005,
                 asciiACK  = 8'o006,
                 asciiBEL  = 8'o007,
                 asciiBS   = 8'o010,
                 asciiTAB  = 8'o011,
                 asciiLF   = 8'o012,
                 asciiVT   = 8'o013,
                 asciiFF   = 8'o014,
                 asciiCR   = 8'o015,
                 asciiSO   = 8'o016,
                 asciiSI   = 8'o017,
                 asciiDLE  = 8'o020,
                 asciiDC1  = 8'o021,
                 asciiDC2  = 8'o022,
                 asciiDC3  = 8'o023,
                 asciiDC4  = 8'o024,
                 asciiNAK  = 8'o025,
                 asciiSYN  = 8'o026,
                 asciiETB  = 8'o027,
                 asciiCAN  = 8'o030,
                 asciiEM   = 8'o031,
                 asciiSUB  = 8'o032,
                 asciiESC  = 8'o033,
                 asciiFS   = 8'o034,
                 asciiGS   = 8'o035,
                 asciiRS   = 8'o036,
                 asciiUS   = 8'o037,
                 asciiSP   = 8'o040,
                 asciiDEL  = 8'o177;

//
// XON/XOFF handshaking aliases
//

localparam [7:0] asciiXON  = 8'o021,
                 asciiXOFF = 8'o023;
