//
// These are the test addresses for MAINDEC-10-DSKEA
//

begin
   case (PC[18:35])
     18'o000000: test = "DSKEA INIT";
     18'o030010: test = "DSKEA BEGIN1";
     18'o030637: test = "DSKEA STARTA";
     18'o030652: test = "DSKEA EBRCK";
     18'o031153: test = "DSKEA UBRCK";
     18'o031521: test = "DSKEA P0TRP";
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

   endcase
end
