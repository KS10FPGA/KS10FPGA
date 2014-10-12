//
// These are the test addresses for MAINDEC-10-DSDZA
//

begin
   case (PC)
     18'o000000: test = "DSDZA INIT";
     18'o030671: test = "DSDZA TEST1";
     18'o030753: test = "DSDZA TEST2";
     18'o031015: test = "DSDZA TEST3";
     18'o031052: test = "DSDZA TEST4";
     18'o031107: test = "DSDZA TEST5";
     18'o031144: test = "DSDZA TEST6";
     18'o031201: test = "DSDZA TEST7";
     18'o031236: test = "DSDZA TEST10";
     18'o031277: test = "DSDZA TEST11";
     18'o031341: test = "DSDZA TEST12";
     18'o031405: test = "DSDZA TEST13";
     18'o031435: test = "DSDZA TEST14";
     18'o031474: test = "DSDZA TEST15";
     18'o031533: test = "DSDZA TEST16";
     18'o031612: test = "DSDZA TEST17";
     18'o031666: test = "DSDZA TEST20";
     18'o031733: test = "DSDZA TEST21";
     18'o032024: test = "DSDZA TEST22";
     18'o032121: test = "DSDZA TEST23";
     18'o032224: test = "DSDZA TEST24";
     18'o032374: test = "DSDZA TEST25";
     18'o032567: test = "DSDZA TEST26";
     18'o032721: test = "DSDZA TEST27";
     18'o033044: test = "DSDZA TEST30";
     18'o033151: test = "DSDZA TEST31";
     18'o033260: test = "DSDZA TEST32";
     18'o033357: test = "DSDZA TEST32";
     18'o033360: test = "DSDZA TEST32";
     18'o033361: test = "DSDZA TEST32";
     18'o033362: test = "DSDZA TEST32";
     18'o033363: test = "DSDZA TEST32";
     18'o033364: test = "DSDZA TEST32";
     18'o033365: test = "DSDZA TEST32";
     18'o033366: test = "DSDZA TEST32";
     18'o033367: test = "DSDZA TEST32";
     18'o033370: test = "DSDZA TEST32";
     18'o033371: test = "DSDZA TEST32";
     18'o033372: test = "DSDZA TEST32";
     18'o033373: test = "DSDZA TEST32";
     18'o033374: test = "DSDZA TEST32";
     18'o033375: test = "DSDZA TEST32";
     18'o033437: test = "DSDZA TEST33";

     //
     // Error locations
     //

     18'o035006:
       begin
          $display("[%11.3f] %15s: PC is %06o", $time/1.0e3, "DSDZA TXERR1", PC);
          $stop;
       end
     
     18'o034763:
       begin
          $display("[%11.3f] %15s: PC is %06o", $time/1.0e3, "DSDZA RXERR1", PC);
          $stop;
       end
     
     18'o035023:
       begin
          $display("[%11.3f] %15s: PC is %06o", $time/1.0e3, "DSDZA DATER1", PC);
          $stop;
       end

     18'o033246:
       begin
          $display("[%11.3f] %15s: PC is %06o", $time/1.0e3, "DSDZA TXERR2", PC);
          $stop;
       end
     
     18'o033252:
       begin
          $display("[%11.3f] %15s: PC is %06o", $time/1.0e3, "DSDZA RXERR2", PC);
          $stop;
       end
     
     18'o033256:
       begin
          $display("[%11.3f] %15s: PC is %06o", $time/1.0e3, "DSDZA DATER2", PC);
          $stop;
       end

     18'o033425:
      begin
          $display("[%11.3f] %15s: PC is %06o", $time/1.0e3, "DSDZA TXERR3", PC);
          $stop;
       end

     18'o033431:
       begin
          $display("[%11.3f] %15s: PC is %06o", $time/1.0e3, "DSDZA RXERR3", PC);
          $stop;
       end

     18'o033435:
       begin
          $display("[%11.3f] %15s: PC is %06o", $time/1.0e3, "DSDZA DATER3", PC);
          $stop;
       end

     18'o034707: test = "DSDZA RXSER";
     18'o034657: test = "DSDZA TXSER";
     18'o033215: test = "DSDZA TEST31";
     18'o033216: test = "DSDZA TEST31";
     18'o033217: test = "DSDZA TEST31";
     18'o033220: test = "DSDZA TEST31";
     18'o033221: test = "DSDZA TEST31";
     18'o033222: test = "DSDZA TEST31";
     18'o033223: test = "DSDZA TEST31";
     18'o033224: test = "DSDZA TEST31";
     18'o033225: test = "DSDZA TEST31";
     18'o033226: test = "DSDZA TEST31";

     18'o034631:
       begin
          $display("[%11.3f] %15s: PC is %06o", $time/1.0e3, "DSDZA WRGVEC", PC);
          $stop;
       end

   endcase
end
