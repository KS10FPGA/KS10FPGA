
        //
        // DSDZA - DECSYSTEM 2020 DZ11 ASYNC. LINE MUX DIAGNOSTICS (DSDZA)
        //

        expects("UBA # - ",                                                    "1\015",       state[ 0]);
        expects("DISK:<DIRECTORY> OR DISK:[P,PN] - ",                          "PS:\015",     state[ 1]);
        expects("SMMON CMD - ",                                                "DSDZA\015",   state[ 2]);
        expects("TTY SWITCH CONTROL ? - 0,S OR Y <CR> - ",                     "Y\015",       state[ 3]);
        expects("LH SWITCHES <# OR ?> - ",                                     "100\015",     state[ 4]);
        expects("RH SWITCHES <# OR ?> - ",                                     "0\015",       state[ 5]);
        expects("WHICH UNIBUS ADAPTER? (1,3,4):",                              "1\015",       state[ 6]);
