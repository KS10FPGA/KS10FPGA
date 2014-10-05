//
// These are the test addresses for MAINDEC-10-DSKBA
//

begin
   case (PC[18:35])
     18'o000000: test = "DSKBA INIT";
     18'o030606: test = "DSKBA START";
     18'o055323: test = "DSKBA JFOT0";
     18'o055457: test = "DSKBA MSADT";
     18'o055512: test = "DSKBA TST1";
     18'o055543: test = "DSKBA TST2";
     18'o055573: test = "DSKBA TST3";
     18'o055624: test = "DSKBA TST4";
     18'o055654: test = "DSKBA TST5";
     18'o055704: test = "DSKBA TST6";
     18'o055735: test = "DSKBA TST7";
     18'o055765: test = "DSKBA TST10";
     18'o056015: test = "DSKBA TST11";
     18'o056045: test = "DSKBA TST12";
     18'o056074: test = "DSKBA TST13";
     18'o056135: test = "DSKBA TST14";
     18'o056173: test = "DSKBA TST15";
     18'o056231: test = "DSKBA TST16";
     18'o056273: test = "DSKBA TST17";
     18'o056335: test = "DSKBA TST20";
     18'o056404: test = "DSKBA TST21";
     18'o056456: test = "DSKBA TST22";
     18'o056515: test = "DSKBA TST23";
     18'o056554: test = "DSKBA TST24";
     18'o056613: test = "DSKBA TST25";
     18'o056652: test = "DSKBA TST26";
     18'o056726: test = "DSKBA TST27";
     18'o056767: test = "DSKBA TST30";
     18'o057026: test = "DSKBA TST31";
     18'o056767: test = "DSKBA TST30";
     18'o057065: test = "DSKBA JRST1";
     18'o057120: test = "DSKBA JSP1";
     18'o057154: test = "DSKBA JSRA";
     18'o057210: test = "DSKBA JSR1";
     18'o057252: test = "DSKBA JSAA";
     18'o057356: test = "DSKBA JRA1";
     18'o057411: test = "DSKBA JRAA";
     18'o057450: test = "DSKBA SKPA";
     18'o057500: test = "DSKBA SKPB";
     18'o057531: test = "DSKBA DFRTST";
     18'o057600: test = "DSKBA DFT";
     18'o057677: test = "DSKBA TPOP";
     18'o057747: test = "DSKBA TPUSH";
     18'o057771: test = "DSKBA TPUSH3";
     18'o060022: test = "DSKBA POPT";
     18'o060124: test = "DSKBA PUSHT";
     18'o060200: test = "DSKBA POPJ1";
     18'o060236: test = "DSKBA PUSHJ1";
   endcase
end
