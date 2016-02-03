////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   These are the test addresses for MAINDEC-10-DSKEB
//
// File
//   debug_dskeb.vh
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2016 Rob Doyle
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

begin
   case (PC)
     18'o000000: test = "DSKEB INIT";
     18'o000440: test = "DSKEB STD";
     18'o030000: test = "DSKEB BEGIN";
     18'o030001: test = "DSKEB $START";
     18'o030002: test = "DSKEB DIAGMN";
     18'o030003: test = "DSKEB SYSEXR";
     18'o030004: test = "DSKEB SFSTRT";
     18'o030005: test = "DSKEB PFSTRT";
     18'o030006: test = "DSKEB REENTR";
     18'o030007: test = "DSKEB DDTSRT";
     18'o030010: test = "DSKEB BEGIN1";
     18'o030011: test = "DSKEB SBINIT";
     18'o030012: test = "DSKEB RETURN";
     18'o030013: test = "DSKEB START1";
     18'o030014: test = "DSKEB START2";
     18'o030015: test = "DSKEB START3";
     18'o030016: test = "DSKEB START4";
     18'o030017: test = "DSKEB START5";

     18'o030651: test = "DSKEB ACCHK";
     18'o032012: test = "DSKEB PHYCHK";
     18'o032072: test = "DSKEB CACCHK";
     18'o032317: test = "DSKEB LOALIT";
     18'o033232: test = "DSKEB HOALIT";
     18'o033354: test = "DSKEB UECHEK";
     18'o033440: test = "DSKEB EUCHEK";

//   18'o: test = "DSKEB ";
   endcase
end
