
        //
        // DSTUB - DECSYSTEM 2020 RH11-TM02/03-TU16/TU45/TU77 RELIABILITY DIAGNOSTIC(DSTUB)
        //

        expects("UBA # - ",                                                    "1\015",      state[ 0]);
        expects("DISK:<DIRECTORY> OR DISK:[P,PN] - ",                          "PS:\015",    state[ 1]);
        expects("SMMON CMD - ",                                                "DSTUA\015",  state[ 2]);
        expects("TTY SWITCH CONTROL ? - 0,S OR Y <CR> - ",                     "Y\015",      state[ 3]);
        expects("LH SWITCHES <# OR ?> - ",                                     "100\015",    state[ 4]);
        expects("RH SWITCHES <# OR ?> - ",                                     "400000\015", state[ 5]);
        expects("SPECIFY TM (3=TM03,2=TM02,CR WILL TEST ALL ON-LINE DRIVES)",  "\015",       state[ 6]);
        expects("INPUT TM02 #'S - ",                                           "1\015",      state[ 7]);
        expects("TM02 # 1; SLV TYPE (TU16, TU45, OR TU77):   ",                "TU45\015",   state[ 8]);
        expects("TM02 # 1 SLAVES: ",                                           "1\015",      state[ 9]);
        expects("WHAT TEST (H<CR> FOR HELP):  ",                               "\015",       state[10]);
        expects("TYPE NUMBER OF PROGRAM PASSES (DECIMAL) (CR=INFINITE):  ",    "1\015",      state[11]);
        expects("MOVE TAPE TO BOT, ON LINE, TYPE <CR>:",                       "\015",       state[12]);
        expects("MOVE TAPE OFF BOT, ON-LINE; TYPE <CR>:  ",                    "\015",       state[13]);
