////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
// These are the test addresses for MAINDEC-10-DSKEC
//
// File
//   debug_dskec.vh
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
     18'o000000: test = "DSKEC INIT";
     18'o000440: test = "DSKEC STD";
     18'o030000: test = "DSKEC BEGIN";
     18'o030001: test = "DSKEC $START";
     18'o030002: test = "DSKEC DIAGMN";
     18'o030003: test = "DSKEC SYSEXR";
     18'o030004: test = "DSKEC SFSTRT";
     18'o030005: test = "DSKEC PFSTRT";
     18'o030006: test = "DSKEC REENTR";
     18'o030007: test = "DSKEC DDTSRT";
     18'o030010: test = "DSKEC BEGIN1";
     18'o030011: test = "DSKEC SBINIT";
     18'o030012: test = "DSKEC RETURN";
     18'o030013: test = "DSKEC START1";
     18'o030014: test = "DSKEC START2";
     18'o030015: test = "DSKEC START3";
     18'o030016: test = "DSKEC START4";
     18'o030017: test = "DSKEC START5";
     18'o030632: test = "DSKEC START";
     18'o030652: test = "DSKEC STARTA";
     18'o030655: test = "DSKEC STARTA";
     18'o030656: test = "DSKEC STARTA";
     18'o030657: test = "DSKEC TST01";
     18'o030707: test = "DSKEC TST02";
     18'o030722: test = "DSKEC TST03";
     18'o030741: test = "DSKEC TST04";
     18'o030775: test = "DSKEC TST05";
     18'o031022: test = "DSKEC TST06";
     18'o031046: test = "DSKEC TST07";
     18'o031103: test = "DSKEC TST08";

     18'o032007: test = "DSKEC KLPAGE";

   endcase
end
