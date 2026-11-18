`ifndef DSRMB_VAFTER
`define DSRMB_VAFTER "N"
`endif
`ifndef DSRMB_CYL0
`define DSRMB_CYL0 "0"
`endif
`ifndef DSRMB_CYL1
`define DSRMB_CYL1 "0"
`endif
`ifndef DSRMB_SURF0
`define DSRMB_SURF0 "0"
`endif
`ifndef DSRMB_SURF1
`define DSRMB_SURF1 "1"
`endif
`ifndef DSRMB_FORMAT
`define DSRMB_FORMAT "N"
`endif
`ifndef DSRMB_ENTIRE
`define DSRMB_ENTIRE "Y"
`endif

        //
        // DSRMB - DECSYSTEM 2020 RH11 - RM03/RP06 - RELIABILITY DIAGNOSTIC
        //

        expects("UBA # - ",                                                    "1\015",       state[ 0]);
        expects("DISK:<DIRECTORY> OR DISK:[P,PN] - ",                          "PS:\015",     state[ 1]);
        expects("SMMON CMD - ",                                                "DSRMB\015",   state[ 2]);
        expects("TTY SWITCH CONTROL ? - 0,S OR Y <CR> - ",                     "Y\015",       state[ 3]);
        expects("LH SWITCHES <# OR ?> - ",                                     "100\015",     state[ 4]);
        expects("RH SWITCHES <# OR ?> - ",                                     "0\015",       state[ 5]);
        expects("WHAT DRIVE(S) TO BE TESTED (00 TO 77, ALL, H=HELP)? - ",      {`DSRMB_DRIVE, "\015"}, state[11]);
        expects("WHAT TEST ? - ",                                              {`DSRMB_TEST, "\015"}, state[12]);
        expects("FORMAT A PACK? Y OR N <CR> - ",                               {`DSRMB_FORMAT, "\015"}, state[13]);
        expects("VERIFY A FORMATTED PACK? Y OR N <CR> - ",                     "Y\015",       state[14]);
        expects("36 BIT MODE (10 FORMAT)? Y OR N <CR> - ",                     "Y\015",       state[15]);
        expects("PROCESS ENTIRE PACK FOR ALL SELECTED DRIVES? Y OR N <CR> - ", {`DSRMB_ENTIRE, "\015"}, state[16]);
`ifdef DSRMB_RANGE
        //
        // Partial pack: FORMAT/VERIFY a range (DSRMB_ENTIRE="N").  Prompts
        // captured from the board (drive 6 on RH1).
        //

        expects("VERIFY AFTER FORMATTING? Y OR N <CR> - ",                    {`DSRMB_VAFTER, "\015"}, state[18]);
        expects({"PROCESS A RANGE OF PACK AREAS ON DRIVE RH1 - ", `DSRMB_DRIVE, "<", `DSRMB_DRIVE, "> Y OR N <CR> - "}, "Y\015", state[19]);
        expects("TYPE START CYLINDER # - ",                                    {`DSRMB_CYL0,  "\015"}, state[20]);
        expects("TYPE STOP CYLINDER # - ",                                     {`DSRMB_CYL1,  "\015"}, state[21]);
        expects("TYPE START SURFACE # - ",                                     {`DSRMB_SURF0, "\015"}, state[22]);
        expects("TYPE STOP SURFACE # - ",                                      {`DSRMB_SURF1, "\015"}, state[23]);
`endif
        expects("NAME = ",                                                     "RAND\015",    state[17]);
