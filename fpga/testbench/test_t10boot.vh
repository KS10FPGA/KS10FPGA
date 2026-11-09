        //
        // T10BOOT - TOPS-10 BOOT from disk (tmp/t10boot.dat holds the
        // monitor pre-boot, built by mkboot.py).  Answer the BOOT> prompt
        // with <CR> to load DSKB:SYSTEM.EXE[1,4], then stop on the result.
        //

        if (ctyMatch(inBuf, "BOOT>"))
          begin
             if (state[0] == 0)
               begin
                  $display("[%11.3f] KS10: BOOT> prompt.  Sending <CR>.", $time/1.0e3);
                  #100000;
                  puts("\015");
                  state[0] = 1;
               end
          end
        else if (ctyMatch(inBuf, "structure") | ctyMatch(inBuf, "reload: "))
          begin
             $fflush(fd_cty);
             $display("[%11.3f] KS10: T10BOOT result \"%s\".  Stopping.", $time/1.0e3, inBuf);
             $stop;
          end
