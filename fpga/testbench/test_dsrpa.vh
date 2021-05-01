
        //
        // DSRPA (RP06-RH11 BASIC DRIVE DIAGNOSTIC) Responses
        //

        expects("UBA # - ",                                                    "1\015",       state[ 0]);
        expects("DISK:<DIRECTORY> OR DISK:[P,PN] - ",                          "PS:\015",     state[ 1]);
        expects("SMMON CMD - ",                                                "DSRPA\015",   state[ 2]);
        expects("TTY SWITCH CONTROL ? - 0,S OR Y <CR> - ",                     "Y\015",       state[ 3]);
        expects("LH SWITCHES <# OR ?> - ",                                     "100\015",     state[ 4]);
        expects("RH SWITCHES <# OR ?> - ",                                     "0\015",       state[ 5]);
        expects("LIST PGM SWITCH OPTIONS ?  Y OR N <CR> - ",                   "N\015",       state[ 6]);
        expects("SELECT DRIVES (0-7 OR \"A\") - ",                             "0\015",       state[ 7]);
        expects("HEADS LOADED CORRECTLY ?  Y OR N <CR> - ",                    "Y\015",       state[ 8]);
        expects("PUT DRIVE ON LINE. HIT <CR> WHEN READY",                      "\015",        state[ 9]);
