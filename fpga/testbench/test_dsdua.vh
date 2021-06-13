
        //
        // DSDUA (DSDUA DECSYSTEM 2020 DUP-11 DIAGNOSTICS)
        //

        expects("UBA # - ",                                                    "1\015",       state[ 0]);
        expects("DISK:<DIRECTORY> OR DISK:[P,PN] - ",                          "PS:\015",     state[ 1]);
        expects("SMMON CMD - ",                                                "DSDUA\015",   state[ 2]);
        expects("TTY SWITCH CONTROL ? - 0,S OR Y <CR> - ",                     "Y\015",       state[ 3]);
        expects("LH SWITCHES <# OR ?> - ",                                     "100\015",     state[ 4]);
        expects("RH SWITCHES <# OR ?> - ",                                     "0\015",       state[ 5]);
        expects("IS THE DUP-11 UNIT #1 OR #2 ?",                               " 1\015",      state[ 6]);
        expects("DO YOU WANT A MAP OF THE DUP-11 STATUS ? Y OR N <CR> - ",     "N\015",       state[ 7]);
        expects("IS THE H325 TURN AROUND CONNECTER IN PLACE ? Y OR N <CR> - ", "Y\015",       state[ 8]);
        expects("*",                                                           "A\015",       state[ 9]);
