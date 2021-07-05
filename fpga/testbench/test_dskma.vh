
        //
        // DSKMA (DSKMA DECSYSTEM 2020 KMC11 DIAGNOSTICS)
        //

        expects("UBA # - ",                                                    "3\015",     state[0]);
        expects("DISK:<DIRECTORY> OR DISK:[P,PN] - ",                          "PS:\015",   state[1]);
        expects("SMMON CMD - ",                                                "DSKMA\015", state[2]);
        expects("TTY SWITCH CONTROL ? - 0,S OR Y <CR> - ",                     "0\015",     state[3]);
        expects("LH SWITCHES <# OR ?> - ",                                     "0\015",     state[4]);
        expects("RH SWITCHES <# OR ?> - ",                                     "0\015",     state[5]);
        expects("*",                                                           "A\015",     state[6]);
