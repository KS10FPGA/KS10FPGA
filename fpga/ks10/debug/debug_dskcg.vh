//
// These are the test addresses for MAINDEC-10-DSKCG
//

begin
   case (PC[18:35])
     18'o030620: test <= 6'd1;
     18'o030647: test <= 6'd2;
     18'o030704: test <= 6'd3;
     18'o031012: test <= 6'd4;
     18'o031203: test <= 6'd5;
     18'o031444: test <= 6'd6;
     18'o031613: test <= 6'd7;
     18'o031723: test <= 6'd8;
     18'o032576: test <= 6'd9;
   endcase
   $display("[%10.3f] debug: Test %02o: PC is %06o", $time/1.0e3,
            test, debugDATA[18:35]);
end
