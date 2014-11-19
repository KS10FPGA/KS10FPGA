//
// These are the test addresses for uninstrumented diagnostics
//

begin
   case (PC)

      `ifdef __ICARUS__
          18'o000000: test = {``DEBUG, " RESET"  };
          18'o030000: test = {``DEBUG, " BEGIN"  };
          18'o030001: test = {``DEBUG, " $START" };
          18'o030002: test = {``DEBUG, " DIAGMN" };
          18'o030003: test = {``DEBUG, " SYSEXR" };
          18'o030004: test = {``DEBUG, " SFSTRT" };
          18'o030005: test = {``DEBUG, " PFSTRT" };
          18'o030006: test = {``DEBUG, " REENTR" };
          18'o030007: test = {``DEBUG, " DDTSRT" };
          18'o030010: test = {``DEBUG, " BEGIN1" };
          18'o030011: test = {``DEBUG, " SBINIT" };
          18'o030012: test = {``DEBUG, " RETURN" };
          18'o030013: test = {``DEBUG, " START1" };
          18'o030014: test = {``DEBUG, " START2" };
          18'o030015: test = {``DEBUG, " START3" };
          18'o030016: test = {``DEBUG, " START4" };
          18'o030017: test = {``DEBUG, " START5" };
      `else
          18'o000000: test = "DIAG RESET";
          18'o030000: test = "DIAG BEGIN";
          18'o030001: test = "DIAG $START";
          18'o030002: test = "DIAG DIAGMN";
          18'o030003: test = "DIAG SYSEXR";
          18'o030004: test = "DIAG SFSTRT";
          18'o030005: test = "DIAG PFSTRT";
          18'o030006: test = "DIAG REENTR";
          18'o030007: test = "DIAG DDTSRT";
          18'o030010: test = "DIAG BEGIN1";
          18'o030011: test = "DIAG SBINIT";
          18'o030012: test = "DIAG RETURN";
          18'o030013: test = "DIAG START1";
          18'o030014: test = "DIAG START2";
          18'o030015: test = "DIAG START3";
          18'o030016: test = "DIAG START4";
          18'o030017: test = "DIAG START5";
      `endif
     
   endcase
end
