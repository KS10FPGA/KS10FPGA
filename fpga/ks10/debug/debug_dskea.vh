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


   endcase
end
