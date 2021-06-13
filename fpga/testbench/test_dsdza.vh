
        //
        // DSDZA - DECSYSTEM 2020 DZ11 ASYNC. LINE MUX DIAGNOSTICS (DSDZA)
        //

        expects("UBA # - ",                                                    "1\015",     state[ 0]);
        expects("DISK:<DIRECTORY> OR DISK:[P,PN] - ",                          "PS:\015",   state[ 1]);
        expects("SMMON CMD - ",                                                "DSDZA\015", state[ 2]);
        expects("TTY SWITCH CONTROL ? - 0,S OR Y <CR> - ",                     "0\015",     state[ 3]);
        expects("LH SWITCHES <# OR ?> - ",                                     "0\015",     state[ 4]);
        expects("RH SWITCHES <# OR ?> - ",                                     "0\015",     state[ 5]);
        expects("TEST NO. (1 - 33 OCTAL) = ",                                  "0\015",     state[ 6]);
