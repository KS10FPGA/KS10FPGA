////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   These are the test addresses for MAINDEC-10-DSKEA
//
// File
//   debug_dskea.vh
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

begin
   case (PC)
     18'o000000: test = "DSKEA INIT";
     18'o000440: test = "DSKEA STD";
     18'o030000: test = "DSKEA BEGIN";
     18'o030001: test = "DSKEA $START";
     18'o030002: test = "DSKEA DIAGMN";
     18'o030003: test = "DSKEA SYSEXR";
     18'o030004: test = "DSKEA SFSTRT";
     18'o030005: test = "DSKEA PFSTRT";
     18'o030006: test = "DSKEA REENTR";
     18'o030007: test = "DSKEA DDTSRT";
     18'o030010: test = "DSKEA BEGIN1";
     18'o030011: test = "DSKEA SBINIT";
     18'o030012: test = "DSKEA RETURN";
     18'o030013: test = "DSKEA START1";
     18'o030014: test = "DSKEA START2";
     18'o030015: test = "DSKEA START3";
     18'o030016: test = "DSKEA START4";
     18'o030017: test = "DSKEA START5";
     18'o030637: test = "DSKEA STARTA";
     18'o030652: test = "DSKEA EBRCK0";
     18'o030663: test = "DSKEA EBRCK1";
     18'o030707: test = "DSKEA EBRCK2";
     18'o031024: test = "DSKEA EBRCK3";
     18'o031035: test = "DSKEA EBRCK4";
     18'o031153: test = "DSKEA UBRCK0";
     18'o031166: test = "DSKEA UBRCK1";
     18'o031201: test = "DSKEA UBRCK2";
     18'o031344: test = "DSKEA UBRCK3";
     18'o031521: test = "DSKEA P0TRP";
     18'o031521: test = "DSKEA P0PDLX";
     18'o031577: test = "DSKEA P0AROX";
     18'o031615: test = "DSKEA PDT0";
     18'o031636: test = "DSKEA PDT4A";
     18'o031660: test = "DSKEA PDT7";
     18'o031700: test = "DSKEA PDT10";
     18'o031716: test = "DSKEA ASHTST";
     18'o031734: test = "DSKEA ASHCTST";
     18'o031753: test = "DSKEA MULTST";
     18'o031771: test = "DSKEA IMULTST";
     18'o032007: test = "DSKEA ADJTST";
     18'o032022: test = "DSKEA FSCTST";
     18'o032035: test = "DSKEA FIXTST";
     18'o032053: test = "DSKEA FIXRTST";
     18'o032071: test = "DSKEA FADTST";
     18'o032104: test = "DSKEA DFADTST";
     18'o032117: test = "DSKEA FSBTST";
     18'o032133: test = "DSKEA DFSBTST";
     18'o032150: test = "DSKEA FMPTST";
     18'o032163: test = "DSKEA DFMPTST";
     18'o032176: test = "DSKEA DIVTST";
     18'o032217: test = "DSKEA IDIVTST";
     18'o032240: test = "DSKEA FDVTST";
     18'o032261: test = "DSKEA FDVRTST";
     18'o032302: test = "DSKEA DFDVTST";
     18'o032371: test = "DSKEA MAPCK0";
     18'o032401: test = "DSKEA MAPCK1";
     18'o032406: test = "DSKEA MAPCK2";
     18'o032413: test = "DSKEA MAPCK3";
     18'o032420: test = "DSKEA MAPCK4";
     18'o032425: test = "DSKEA MAPCK5";
     18'o032434: test = "DSKEA MAPCK6";
     18'o032444: test = "DSKEA PFAIL0";
     18'o032467: test = "DSKEA PFAIL1";
     18'o032504: test = "DSKEA PFAIL2";
     18'o032507: test = "DSKEA PFAIL3";
     18'o032522: test = "DSKEA PFAIL4";
     18'o032542: test = "DSKEA PFAIL6";
     18'o032547: test = "DSKEA EPPM0";
     18'o032557: test = "DSKEA EPPM1";
     18'o032564: test = "DSKEA EPPM2";
     18'o032571: test = "DSKEA EPPM3";
     18'o032600: test = "DSKEA EPPM4";
     18'o032607: test = "DSKEA EPPM5";
     18'o032613: test = "DSKEA EPPM6";
     18'o032622: test = "DSKEA EPPM7";
     18'o032632: test = "DSKEA AMTST4";
     18'o032714: test = "DSKEA AMTST7";
     18'o032764: test = "DSKEA PAGRDA";
     18'o032776: test = "DSKEA PAGRDB";
     18'o033005: test = "DSKEA PAGRDC";
     18'o033016: test = "DSKEA PAGRD0";
     18'o033122: test = "DSKEA PGWRTA";
     18'o033134: test = "DSKEA PGWTBB";
     18'o033152: test = "DSKEA PGWRTC";
     18'o033172: test = "DSKEA PGWRT0";
     18'o033200: test = "DSKEA PGWRT1";
     18'o033220: test = "DSKEA PGWRT2";
     18'o033227: test = "DSKEA PGWRT3";
     18'o033252: test = "DSKEA PGWRT4";
     18'o033266: test = "DSKEA PGWRT5";
     18'o033273: test = "DSKEA PGWRT6";
     18'o033321: test = "DSKEA PGWRT7";
     18'o033356: test = "DSKEA PFT0";
     18'o033421: test = "DSKEA WRTP0";
     18'o033522: test = "DSKEA BLT0";
     18'o033530: test = "DSKEA BLT1";
     18'o033537: test = "DSKEA BLT2";
     18'o033544: test = "DSKEA BLT3";
     18'o033553: test = "DSKEA BLT4";
     18'o033560: test = "DSKEA BLT5";
     18'o033567: test = "DSKEA BLT6";
     18'o033575: test = "DSKEA BLT7";
     18'o033604: test = "DSKEA BLT8";
     18'o033612: test = "DSKEA BLT9";
     18'o033622: test = "DSKEA RLBAS0";
     18'o033670: test = "DSKEA RLBAS1";
     18'o033674: test = "DSKEA RLBAS2";
     18'o033715: test = "DSKEA RLBAS3";
     18'o033741: test = "DSKEA RLBAS4";
     18'o033766: test = "DSKEA RLBAS5";
     18'o033772: test = "DSKEA RLBAS6";
     18'o034066: test = "DSKEA EPPT0";
     18'o034126: test = "DSKEA RLPFT0";
     18'o034166: test = "DSKEA RLTRP0";
     18'o034253: test = "DSKEA RLINT0";
     18'o034305: test = "DSKEA RLINT1";
     18'o034320: test = "DSKEA RLINT2";
     18'o034321: test = "DSKEA RLINT3";
     18'o034331: test = "DSKEA RLINT4";
     18'o034341: test = "DSKEA RLINT5";
     18'o034346: test = "DSKEA RLINT6";
     18'o034361: test = "DSKEA RLINT7";
     18'o034371: test = "DSKEA RLINT8";
     18'o034401: test = "DSKEA RLINT9";
     18'o034412: test = "DSKEA RLINTA";
     18'o034421: test = "DSKEA RLEPM0";
     18'o034427: test = "DSKEA RLEPM1";
     18'o034445: test = "DSKEA RLEPM2";
     18'o034456: test = "DSKEA RLEPM3";
     18'o034502: test = "DSKEA RLEPM4";
     18'o034520: test = "DSKEA PFBLT0";
     18'o034532: test = "DSKEA PFBLT1";
     18'o034547: test = "DSKEA PFBLT2";
     18'o034552: test = "DSKEA PFBLT3";
     18'o034612: test = "DSKEA PFBLT4";
     18'o034662: test = "DSKEA PFBLT5";
     18'o034666: test = "DSKEA PFBYT0";
     18'o034676: test = "DSKEA PFBYT1";
     18'o034706: test = "DSKEA PFBYT2";
     18'o034711: test = "DSKEA PFBYT3";
     18'o034733: test = "DSKEA PFBYT4";
     18'o034743: test = "DSKEA PFBYT5";
     18'o034746: test = "DSKEA PFBYT6";
     18'o034770: test = "DSKEA PFBYT7";
     18'o035002: test = "DSKEA PFBYT8";
     18'o035005: test = "DSKEA PFBYT9";
     18'o035031: test = "DSKEA PFDMV0";
     18'o035135: test = "DSKEA PFDMM0";
     18'o035254: test = "DSKEA TIPF0";
     18'o035425: test = "DSKEA PFIO0";
     18'o035542: test = "DSKEA STMUUO";
   endcase
end
