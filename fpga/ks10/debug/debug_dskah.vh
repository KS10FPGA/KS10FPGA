////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   These are the test addresses for MAINDEC-10-DSKAH
//
// File
//   debug_dskah.vh
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
     18'o000000: test = "R00";
     18'o000001: test = "R01";
     18'o000002: test = "R02";
     18'o000003: test = "R03";
     18'o000004: test = "R04";
     18'o000005: test = "R05";
     18'o000006: test = "R06";
     18'o000007: test = "R07";
     18'o000010: test = "R10";
     18'o000011: test = "R11";
     18'o000012: test = "R12";
     18'o000013: test = "R13";
     18'o000014: test = "R14";
     18'o000015: test = "R15";
     18'o000016: test = "R16";
     18'o000017: test = "R17";
     18'o030610: test = "DSKAH STARTA";
     18'o030661: test = "DSKAH BEGIOT";
     18'o030672: test = "DSKAH IOT0";
     18'o030676: test = "DSKAH IOT2";
     18'o030703: test = "DSKAH IOT3";
     18'o030712: test = "DSKAH IOT6";
     18'o030716: test = "DSKAH IOT14";
     18'o030724: test = "DSKAH IOT15";
     18'o030724: test = "DSKAH IOT15A";
     18'o030740: test = "DSKAH IOT16";
     18'o030746: test = "DSKAH IOT17";
     18'o030754: test = "DSKAH IOT18";
     18'o030777: test = "DSKAH IOT18A";
     18'o031005: test = "DSKAH IOT19";
     18'o031013: test = "DSKAH IOT20";
     18'o031021: test = "DSKAH IOT22";
     18'o031051: test = "DSKAH IOT24";
     18'o031064: test = "DSKAH IOT25";
     18'o031077: test = "DSKAH IOT26";
     18'o031105: test = "DSKAH IOT33B";
     18'o031114: test = "DSKAH IOT34";
     18'o031121: test = "DSKAH IOT35";
     18'o031127: test = "DSKAH IOT36";
     18'o031130: test = "DSKAH IOT38";
     18'o031135: test = "DSKAH IOT39";
     18'o031143: test = "DSKAH IOT40";
     18'o031150: test = "DSKAH IOT41";
     18'o031156: test = "DSKAH IOT42";
     18'o031163: test = "DSKAH IOT43";
     18'o031171: test = "DSKAH IOT44";
     18'o031176: test = "DSKAH IOT45";
     18'o031204: test = "DSKAH IOT46";
     18'o031211: test = "DSKAH IOT47";
     18'o031217: test = "DSKAH IOT48";
     18'o031224: test = "DSKAH IOT49";
     18'o031232: test = "DSKAH IOT50";
     18'o031237: test = "DSKAH IOT51";
     18'o031245: test = "DSKAH IOTXYZ";
     18'o031247: test = "DSKAH PIOT00";
     18'o031265: test = "DSKAH PIOT01";
     18'o031303: test = "DSKAH PIOT02";
     18'o031321: test = "DSKAH PIOT03";
     18'o031337: test = "DSKAH PIOT04";
     18'o031355: test = "DSKAH PIOT05";
     18'o031373: test = "DSKAH PIOT06";
     18'o031413: test = "DSKAH PIOT10";
     18'o031432: test = "DSKAH PIOT11";
     18'o031447: test = "DSKAH PIOT12";
     18'o031465: test = "DSKAH PIOT13";
     18'o031503: test = "DSKAH PIOT14";
     18'o031521: test = "DSKAH PIOT15";
     18'o031537: test = "DSKAH PIOT16";
     18'o031557: test = "DSKAH PIOT20";
     18'o031577: test = "DSKAH PIOT21";
     18'o031617: test = "DSKAH PIOT22";
     18'o031637: test = "DSKAH PIOT23";
     18'o031657: test = "DSKAH PIOT24";
     18'o031677: test = "DSKAH PIOT25";
     18'o031717: test = "DSKAH PIOT26";
     18'o031741: test = "DSKAH BIGPI1";
     18'o032040: test = "DSKAH BIGPI2";
     18'o032137: test = "DSKAH BIGPI3";
     18'o032236: test = "DSKAH BIGPI4";
     18'o032335: test = "DSKAH BIGPI5";
     18'o032434: test = "DSKAH BIGPI6";
     18'o032533: test = "DSKAH BIGPI7";
     18'o032632: test = "DSKAH BIGPIX";
     18'o032731: test = "DSKAH BIGPIY";
     18'o033030: test = "DSKAH BIGPIZ";
     18'o033131: test = "DSKAH PIOT30";
     18'o033150: test = "DSKAH PIOT31";
     18'o033167: test = "DSKAH PIOT32";
     18'o033206: test = "DSKAH PIOT33";
     18'o033225: test = "DSKAH PIOT34";
     18'o033244: test = "DSKAH PIOT35";
     18'o033263: test = "DSKAH PIOT36";
     18'o033303: test = "DSKAH TRP0";           // ..0047
     18'o033326: test = "DSKAH TRP1";           // ..0050
     18'o033345: test = "DSKAH TRP2";           // ..0051
     18'o033364: test = "DSKAH TRP3";           // ..0052
     18'o033403: test = "DSKAH TRP4";           // ..0053
     18'o033422: test = "DSKAH TRP5";           // ..0054
     18'o033441: test = "DSKAH TRP6";           // ..0055
     18'o033465: test = "DSKAH CKI";            //
     18'o033457: test = "DSKAH CKI";            //
     18'o033476: test = "DSKAH CKI01";          // ..0056
     18'o033514: test = "DSKAH CKI02";          // ..0057
     18'o033532: test = "DSKAH CKI03";          // ..0060
     18'o033550: test = "DSKAH CKI04";          // ..0061
     18'o033566: test = "DSKAH CKI05";          // ..0062
     18'o033604: test = "DSKAH CKI06";          // ..0063
     18'o033622: test = "DSKAH CKI07";          // ..0064
     18'o033633: test = "DSKAH MULTI";          // ..0065
     18'o033646: test = "DSKAH MULT6";          // ..0066
     18'o033663: test = "DSKAH MULT5";          // ..0070
     18'o033700: test = "DSKAH MULT4";          // ..0072
     18'o033715: test = "DSKAH MULT3";          // ..0074
     18'o033732: test = "DSKAH MULT2";          // ..0076
     18'o033747: test = "DSKAH MULT1";          // ..0100
     18'o033764: test = "DSKAH MULT0";          // ..0102
     18'o033774: test = "DSKAH C2A";
     18'o034015: test = "DSKAH C2B";
     18'o034042: test = "DSKAH C2C";
     18'o034067: test = "DSKAH C2D";
     18'o034114: test = "DSKAH C2E";
     18'o034141: test = "DSKAH C2F";
     18'o034166: test = "DSKAH C2G";
     18'o034213: test = "DSKAH C2H";
     18'o034240: test = "DSKAH C2I";
     18'o034265: test = "DSKAH C2J";
     18'o034312: test = "DSKAH C2K";
     18'o034337: test = "DSKAH C2L";
     18'o034364: test = "DSKAH C2M";
     18'o034411: test = "DSKAH C2N";
     18'o034436: test = "DSKAH C2O";
     18'o034463: test = "DSKAH C2P";
     18'o034510: test = "DSKAH C2Q";
     18'o034535: test = "DSKAH C2R";
     18'o034562: test = "DSKAH C2S";
     18'o034607: test = "DSKAH C2T";
     18'o034634: test = "DSKAH C2U";
     18'o034662: test = "DSKAH C2V";
     18'o034670: test = "DSKAH JENDIS0";        //..0130
     18'o034714: test = "DSKAH JENDIS1";        //..0131
     18'o034740: test = "DSKAH JENDIS2";        //..0132
     18'o034764: test = "DSKAH JENDIS3";        //..0133
     18'o035010: test = "DSKAH JENDIS4";        //..0134
     18'o035034: test = "DSKAH JENDIS5";        //..0135
     18'o035060: test = "DSKAH JENDIS6";        //..0136

     18'o035105: test = "DSKAH CKCK0";
     18'o035120: test = "DSKAH CKCK1";
     18'o035133: test = "DSKAH CKCK2";
     18'o035146: test = "DSKAH CKCK3";
     18'o035161: test = "DSKAH CKCK4";
     18'o035174: test = "DSKAH CKCK5";
     18'o035207: test = "DSKAH CKCK6";
     18'o035222: test = "DSKAH CKCK7";

     18'o035235: test = "DSKAH RESET1";
     18'o035245: test = "DSKAH RESET2";

     18'o035307: test = "DSKAH INDPI44";
     18'o035341: test = "DSKAH INDPI46";
     18'o035373: test = "DSKAH INDPI50";
     18'o035425: test = "DSKAH INDPI52";
     18'o035457: test = "DSKAH INDPI54";
     18'o035511: test = "DSKAH INDPI56";
     18'o035543: test = "DSKAH UUO01";
     18'o035567: test = "DSKAH UUO02";
     18'o035613: test = "DSKAH UUO03";
     18'o035637: test = "DSKAH UUO04";
     18'o035663: test = "DSKAH UUO05";
     18'o035707: test = "DSKAH UUO06";
     18'o035733: test = "DSKAH UUO07";
     18'o035757: test = "DSKAH UUO10";
     18'o036003: test = "DSKAH UUO11";
     18'o036027: test = "DSKAH UUO12";
     18'o036053: test = "DSKAH UUO13";
     18'o036077: test = "DSKAH UUO14";
     18'o036123: test = "DSKAH UUO15";
     18'o036147: test = "DSKAH UUO16";
     18'o036173: test = "DSKAH UUO17";
     18'o036217: test = "DSKAH UUO20";
     18'o036243: test = "DSKAH UUO21";
     18'o036267: test = "DSKAH UUO22";
     18'o036313: test = "DSKAH UUO23";
     18'o036337: test = "DSKAH UUO24";
     18'o036363: test = "DSKAH UUO25";
     18'o036407: test = "DSKAH UUO26";
     18'o036433: test = "DSKAH UUO27";
     18'o036457: test = "DSKAH UUO30";
     18'o036503: test = "DSKAH UUO31";
     18'o036527: test = "DSKAH UUO32";
     18'o036553: test = "DSKAH UUO33";
     18'o036577: test = "DSKAH UUO34";
     18'o036623: test = "DSKAH UUO35";
     18'o036647: test = "DSKAH UUO36";
     18'o036673: test = "DSKAH UUO37";
     18'o036720: test = "DSKAH UUOA00";         //..0205
     18'o036737: test = "DSKAH UUOA01";         //..0210
     18'o036756: test = "DSKAH UUOA02";         //..0213
     18'o036775: test = "DSKAH UUOA03";         //..0216
     18'o037014: test = "DSKAH UUOA04";         //..0221
     18'o037033: test = "DSKAH UUOA05";         //..0224
     18'o037052: test = "DSKAH UUOA06";         //..0227
     18'o037071: test = "DSKAH UUOA07";         //..0232
     18'o037110: test = "DSKAH UUOA08";         //..0235
     18'o037127: test = "DSKAH UUOA09";         //..0240
     18'o037146: test = "DSKAH UUOA10";         //..0243
     18'o037165: test = "DSKAH UUOA11";         //..0246
     18'o037204: test = "DSKAH UUOA12";         //..0251
     18'o037223: test = "DSKAH UUOA13";         //..0254
     18'o037242: test = "DSKAH UUOA14";         //..0257
     18'o037261: test = "DSKAH UUOA15";         //..0262
     18'o037300: test = "DSKAH UUOA16";         //..0265
     18'o037317: test = "DSKAH UUOA17";         //..0270
     18'o037336: test = "DSKAH UUOA18";         //..0273
     18'o037355: test = "DSKAH UUOA19";         //..0276
     18'o037374: test = "DSKAH UUOA20";         //..0301
     18'o037413: test = "DSKAH UUOA21";         //..0304
     18'o037433: test = "DSKAH UUOIND";
     18'o037446: test = "DSKAH UUOINX";         // UUOINX
     18'o037461: test = "DSKAH UUOBTH";         // UUOBTH
     18'o037474: test = "DSKAH FMUUO0";         // FFUUOO
     18'o037515: test = "DSKAH FMUUO1";         // FFUUO1
     18'o037536: test = "DSKAH FMUUO2";         // FFUUO2
     18'o037557: test = "DSKAH FMUUO4";         // FFUUO4
     18'o037600: test = "DSKAH FMUUO5";         // FFUUO5
     18'o037621: test = "DSKAH FMUUO10";        // FFUUO10
     18'o037642: test = "DSKAH FMUUO12";        // FFUUO12
     18'o037663: test = "DSKAH FMUUO17";        // FFUUO17
     18'o037704: test = "DSKAH XMUUO0";
     18'o037756: test = "DSKAH USRIO0";
     18'o040000: test = "DSKAH USRIO1";

   endcase
end
