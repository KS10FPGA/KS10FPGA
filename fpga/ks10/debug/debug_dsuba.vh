//
// These are the test addresses for MAINDEC-10-DSUBA
//

begin
   case (PC[18:35])
     18'o030661: test <= 6'o01;
     18'o030734: test <= 6'o02;
     18'o030767: test <= 6'o03;
     18'o031103: test <= 6'o04;
     18'o031161: test <= 6'o05;
     18'o031210: test <= 6'o06;
     18'o031267: test <= 6'o07;
     18'o031324: test <= 6'o10;
     18'o031372: test <= 6'o11;
     18'o031467: test <= 6'o12;
     18'o031531: test <= 6'o13;
     18'o031633: test <= 6'o14;
     18'o031721: test <= 6'o15;
     18'o032002: test <= 6'o16;
     18'o032056: test <= 6'o17;
     18'o032130: test <= 6'o20;
     18'o032203: test <= 6'o21;
     18'o032273: test <= 6'o22;
     18'o032401: test <= 6'o23;
     18'o032463: test <= 6'o24;
     18'o032531: test <= 6'o25;
     18'o032564: test <= 6'o26;
     18'o032616: test <= 6'o27;
     18'o032647: test <= 6'o30;
     18'o032700: test <= 6'o31;
     18'o032732: test <= 6'o32;
     18'o032770: test <= 6'o33;
     18'o033025: test <= 6'o34;
     18'o033062: test <= 6'o35;
     18'o033117: test <= 6'o36;
     18'o033154: test <= 6'o37;
     18'o033217: test <= 6'o40;
     18'o033246: test <= 6'o41;
     18'o033276: test <= 6'o42;
     18'o033340: test <= 6'o43;
     18'o033375: test <= 6'o44;
     18'o033442: test <= 6'o45;
     18'o033472: test <= 6'o46;
     18'o033526: test <= 6'o47;
     18'o033565: test <= 6'o50;
     18'o033624: test <= 6'o51;
     18'o033665: test <= 6'o52;
     18'o033726: test <= 6'o53;
     18'o033761: test <= 6'o54;
     18'o034014: test <= 6'o55;
     18'o034110: test <= 6'o56;
   endcase
   $display("[%10.3f] debug: Test %02o: PC is %06o", $time/1.0e3,
            test, debugDATA[18:35]);
end