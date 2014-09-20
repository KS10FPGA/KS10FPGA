//
// These are the test addresses for MAINDEC-10-DSKCG
//

begin
   case (PC[18:35])
     18'o000000: test = "DSKCG INIT";
     18'o030620: test = "DSKCG TRAPT1";
     18'o030647: test = "DSKCG TRAPT2";
     18'o030704: test = "DSKCG TRAPT3";
     18'o031012: test = "DSKCG CMPMOD";
     18'o031203: test = "DSKCG MOVMOD";
     18'o031444: test = "DSKCG CDBMOD";
     18'o031613: test = "DSKCG CBDMOD";
     18'o031723: test = "DSKCG EDMODM";
     18'o032576: test = "DSKCG PFTST";
   endcase
end
