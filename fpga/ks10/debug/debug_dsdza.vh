//
// These are the test addresses for MAINDEC-10-DSDZA
//

begin
   case (PC[18:35])
     18'o030671: test <= 6'o01;
     18'o030753: test <= 6'o02;
     18'o031015: test <= 6'o03;
     18'o031052: test <= 6'o04;
     18'o031107: test <= 6'o05;
     18'o031144: test <= 6'o06;
     18'o031201: test <= 6'o07;
     18'o031236: test <= 6'o10;
     18'o031277: test <= 6'o11;
     18'o031341: test <= 6'o12;
     18'o031405: test <= 6'o13;
     18'o031435: test <= 6'o14;
     18'o031474: test <= 6'o15;
     18'o031533: test <= 6'o16;
     18'o031612: test <= 6'o17;
     18'o031666: test <= 6'o20;
     18'o031733: test <= 6'o21;
     18'o032024: test <= 6'o22;
     18'o032121: test <= 6'o23;
     18'o032224: test <= 6'o24;
     18'o032374: test <= 6'o25;
     18'o032567: test <= 6'o26;
     18'o032721: test <= 6'o27;
     18'o033044: test <= 6'o30;
     18'o033151: test <= 6'o31;
     18'o033260: test <= 6'o32;
     18'o033437: test <= 6'o33;
   endcase
   $display("[%10.3f] debug: Test %02o: PC is %06o", $time/1.0e3,
            test, debugDATA[18:35]);
end
