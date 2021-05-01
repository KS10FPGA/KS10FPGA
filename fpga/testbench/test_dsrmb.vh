
        //
        // DSRMB - DECSYSTEM 2020 RH11 - RM03/RP06 - RELIABILITY DIAGNOSTIC
        //

        expects("UBA # - ",                                                    "1\015",       state[ 0]);
        expects("DISK:<DIRECTORY> OR DISK:[P,PN] - ",                          "PS:\015",     state[ 1]);
        expects("SMMON CMD - ",                                                "DSRMB\015",   state[ 2]);
        expects("TTY SWITCH CONTROL ? - 0,S OR Y <CR> - ",                     "Y\015",       state[ 3]);
        expects("LH SWITCHES <# OR ?> - ",                                     "100\015",     state[ 4]);
        expects("RH SWITCHES <# OR ?> - ",                                     "0\015",       state[ 5]);
        expects("WHAT DRIVE(S) TO BE TESTED (00 TO 77, ALL, H=HELP)? - ",      "2\015",       state[11]);
        expects("WHAT TEST ? - ",                                              "10\015",      state[12]);
        expects("FORMAT A PACK? Y OR N <CR> - ",                               "N\015",       state[13]);
        expects("VERIFY A FORMATTED PACK? Y OR N <CR> - ",                     "Y\015",       state[14]);
        expects("36 BIT MODE (10 FORMAT)? Y OR N <CR> - ",                     "Y\015",       state[15]);
        expects("PROCESS ENTIRE PACK FOR ALL SELECTED DRIVES? Y OR N <CR> - ", "Y\015",       state[16]);
