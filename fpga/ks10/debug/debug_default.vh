//
// These are the test addresses for uninstrumented diagnostics
//

begin
   case (PC)

      `ifdef __ICARUS__
          18'o000000: test = {``DEBUG, " UNKNOWN"};
      `else
          18'o000000: test = "UNKNOWN";
      `endif

   endcase
end
