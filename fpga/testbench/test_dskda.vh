        //
        // DSKDA (DECSYSTEM 2020 CPU & MEMORY RELIABILITY TEST)
        //
        // RH switches INHDFP, INHFP, INHBYT, INHFXD and INHRAN (000370) skip
        // the arithmetic and random instruction sections so that the
        // interrupt tests (clock, instruction interrupt, NXM and BLT
        // interrupt) run straight away.  Define SIM_DSKDA_ALL to run every
        // section.
        //

        expects("TTY SWITCH CONTROL ? - 0,S OR Y <CR> - ",                     "Y\015",     state[ 3]);
        expects("LH SWITCHES <# OR ?> - ",                                     "0\015",     state[ 4]);
`ifdef SIM_DSKDA_ALL
        expects("RH SWITCHES <# OR ?> - ",                                     "0\015",     state[ 5]);
`else
        expects("RH SWITCHES <# OR ?> - ",                                     "370\015",   state[ 5]);
`endif

        //
        // A FATAL PROGRAM ERROR drops into EDDT and waits for input forever.
        //

        if (inBuf == "EDDT")
          begin
             $display("[%11.3f] KS10: Diagnostic entered EDDT.  Stopping.", $time/1.0e3);
             $stop;
          end
