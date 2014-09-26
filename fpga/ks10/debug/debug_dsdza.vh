//
// These are the test addresses for MAINDEC-10-DSDZA
//

begin
   case (PC[18:35])
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
     18'o033437: test = "DSDZA TEST33";

     //
     // Error locations
     //

     18'o035006: test = "DZDZA TXERR1";
     18'o034763: test = "DZDZA RXERR1";
     18'o035023: test = "DZDZA DATER1";

     18'o033246: test = "DZDZA TXERR2";
     18'o033252: test = "DZDZA RXERR2";
     18'o033256: test = "DZDZA DATER2";

     18'o033425: test = "DZDZA TXERR3";
     18'o033431: test = "DZDZA RXERR3";
     18'o033435: test = "DZDZA DATER3";

     //
     // Wrong Vector
     //

     18'o034631:
       begin
          test = "DZDZA WRGVEC";
          $display("[%10.3f] %s: Took the wrong interrupt vector.",
                   $time/1.0e3, test);
          $stop;
       end

   endcase
end
