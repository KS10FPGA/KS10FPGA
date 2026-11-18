        //
        // Default console script for diagnostics without their own
        // test_<diag>.vh file (DSKAI-DSKAM, DSKCA-DSKCF, DSKDA-DSKFA,
        // DSMMA-DSMMD, ...).  Answers the standard DSQDA "TTY SWITCH
        // CONTROL" dialog with all switches zero.
        //

        expects("TTY SWITCH CONTROL ? - 0,S OR Y <CR> - ",                     "Y\015",     state[ 3]);
        expects("LH SWITCHES <# OR ?> - ",                                     "0\015",     state[ 4]);
        expects("RH SWITCHES <# OR ?> - ",                                     "0\015",     state[ 5]);

        //
        // A FATAL PROGRAM ERROR drops into EDDT and waits for input forever.
        // Stop the simulation instead of running to the time limit.
        //

        if (inBuf == "EDDT")
          begin
             $display("[%11.3f] KS10: Diagnostic entered EDDT.  Stopping.", $time/1.0e3);
             $stop;
          end
