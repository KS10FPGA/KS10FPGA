
        //
        // DSLPA (DECSYSTEM 2020 LINE PRINTER DIAGNOSTIC) Responses
        //

        expects("UBA # - ",                                                    "3\015",     state[ 0]);
        expects("DISK:<DIRECTORY> OR DISK:[P,PN] - ",                          "PS:\015",   state[ 1]);
        expects("SMMON CMD - ",                                                "DSLPA\015", state[ 2]);
        expects("TTY SWITCH CONTROL ? - 0,S OR Y <CR> - ",                     "0\015",     state[ 3]);
        expects("LH SWITCHES <# OR ?> - ",                                     "0\015",     state[ 4]);
        expects("RH SWITCHES <# OR ?> - ",                                     "0\015",     state[ 5]);
        expects("IS THIS AN LP05 OR LP14 LINE PRINTER ? Y OR N <CR> - ",       "Y\015",     state[ 6]);
        expects("IS THIS AN LP05, LP14 OR LP26 LINE PRINTER ? Y OR N <CR> - ", "Y\015",     state[ 7]);
        expects("IS THIS AN LP07 LINE PRINTER ? Y OR N <CR> - ",               "Y\015",     state[ 8]);
        expects("IS THIS AN LP20 CONTROLLER WITH NO PRINTER ? Y OR N <CR> - ", "Y\015",     state[ 9]);
        expects("TYPE ALTMODE WHEN READY - ",                                  "\033",      state[10]);
        expects("DOES THIS LPT HAVE A DAVFU ? Y OR N <CR> - ",                 "Y\015",     state[11]);
        expects("CHANNEL-PASS NUMBER: (1-16, CR=ALL CHANNELS) ",               "\015",      state[12]);
        expects("CHANNEL NUMBER: (1-12, CR=ALL CHANNELS) ",                    "\015",      state[13]);
        expects("CHANNEL NUMBER: (2-12, CR=ALL CHANNELS) ",                    "\015",      state[14]);
        expects("*",                                                           "A\015",     state[15]);
