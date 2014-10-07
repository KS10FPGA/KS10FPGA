//
// These are the test addresses for DSKAH
//

begin
   case (PC)
     18'o000000: test = "DSKAH INIT";
     18'o030660: test = "DSKAH STARTA";
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
     18'o033304: test = "DSKAH TRP0";           // ..0047 Return address
     18'o033326: test = "DSKAH TRP1";           // ..0050
     18'o033327: test = "DSKAH TRP1";           // ..0050 Return address
     18'o033345: test = "DSKAH TRP2";           // ..0051
     18'o033346: test = "DSKAH TRP2";           // ..0051 Return address
     18'o033364: test = "DSKAH TRP3";           // ..0052
     18'o033365: test = "DSKAH TRP3";           // ..0052 Return address
     18'o033403: test = "DSKAH TRP4";           // ..0053
     18'o033404: test = "DSKAH TRP4";           // ..0053 Return address
     18'o033422: test = "DSKAH TRP5";           // ..0054
     18'o033423: test = "DSKAH TRP5";           // ..0054 Return address
     18'o033441: test = "DSKAH TRP6";           // ..0055
     18'o033442: test = "DSKAH TRP6";           // ..0055 Return address
     18'o033457: test = "DSKAH CKI";            //
     18'o033475: test = "DSKAH CKI01";          // ..0056
     18'o033513: test = "DSKAH CKI02";          // ..0057
     18'o033531: test = "DSKAH CKI03";          // ..0060
     18'o033550: test = "DSKAH CKI04";          // ..0061
     18'o033566: test = "DSKAH CKI05";          // ..0062
     18'o033603: test = "DSKAH CKI06";          // ..0063
     18'o033622: test = "DSKAH CKI07";          // ..0064

     18'o033633: test = "DSKAH MULTI";          // ..0065
     18'o033633: test = "DSKAH MULTI6";         // ..0066

     18'o040033: test = "DSKAH HALTPI";
     18'o040050: test = "DSKAH TRPPI";
     18'o040054: test = "DSKAH TRPPI";
     18'o040216: test = "DSKAH TRPSET";

   endcase
end
