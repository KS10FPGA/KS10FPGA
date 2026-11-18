        //
        // DSKEC (DECSYSTEM 2020 PAGING HARDWARE DIAGNOSTIC)
        //
        // Define SIM_DSKEC_ABORT to set RH switch ABORT (400000), which is
        // how the diagnostic is run on the board.
        //

        expects("TTY SWITCH CONTROL ? - 0,S OR Y <CR> - ",                     "Y\015",       state[ 3]);
        expects("LH SWITCHES <# OR ?> - ",                                     "0\015",       state[ 4]);
`ifdef SIM_DSKEC_ABORT
        expects("RH SWITCHES <# OR ?> - ",                                     "400000\015",  state[ 5]);
`else
        expects("RH SWITCHES <# OR ?> - ",                                     "0\015",       state[ 5]);
`endif
