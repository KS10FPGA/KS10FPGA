//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    Command Line Processor
//!
//! \file
//!    cmdline.cpp
//!
//! \author
//!    Rob Doyle - doyle (at) cox (dot) net
//
//******************************************************************************
//
// Copyright (C) 2013-2016 Rob Doyle
//
// This file is part of the KS10 FPGA Project
//
// The KS10 FPGA project is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by the Free
// Software Foundation, either version 3 of the License, or (at your option) any
// later version.
//
// The KS10 FPGA project is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
// or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
// more details.
//
// You should have received a copy of the GNU General Public License along with
// this software.  If not, see <http://www.gnu.org/licenses/>.
//
//******************************************************************************

#include <ctype.h>
#include <stdio.h>
#include <string.h>

#include "cursor.hpp"
#include "cmdline.hpp"

//
// Debug macro
//

#ifdef DEBUG
    #define debug(...)          \
        do {                    \
            printf(__VA_ARGS__);\
        } while (0)
#else
    #define debug(...)
#endif

//!
//! \brief
//!    Constructor
//!
//! \param taskHandle -
//!    reference to the command line processing task taskHandle
//!
//! \param task -
//!    Command processor callback.  This executes the command line.
//!

cmdline_t::cmdline_t(xTaskHandle& taskHandle, void (*task)(char* buf, xTaskHandle& taskHandle)) :
    state(stateNONE),
    cmdlen(0),
    taskHandle(taskHandle),
    taskExecute(task) {
    static const char cmd[] = "ds unit=2;bt 1";
    hist.save(cmd, sizeof(cmd)-1);
    memset(cmdline, 0, sizeof(cmdline));
}

//!
//! \brief
//!    Print the command line
//!
//! \details
//!    The command prints the command line from the cursor to end-of-line.
//!
//! \note
//!    This function does not alter the cursor position.
//!

void cmdline_t::update(void) {
    cursor.save();
    cursor.eraseeol();
    for (unsigned char i = cursor.pos(); i < cmdlen; i++) {
        cursor.putchar(cmdline[i]);
    }
    cursor.restore();
}

//!
//! \brief
//!    Get the command line history from the buffer.
//!
//! \note
//!    The cursor is position at the end of the command line.
//!

void cmdline_t::get_hist(hist_t::dir_t dir) {
    int len = hist.recall(cmdline, dir);
    if (len >= 0) {
        cmdlen = len;
        cursor.move(0);
        update();
        cursor.fwd(cmdlen);
    }
}

//!
//! \brief
//!    Insert a character into the command line at the cursor position.
//!
//! \param ch -
//!    Character to insert into command line.
//!
//! \note
//!    - The memmove does nothing if the cursor is at the end-of-line (the
//!      length is zero).
//!    - The line is updated only if the character is inserted into the middle
//!      of line.
//!

void cmdline_t::inschar(char ch) {
    if (cmdlen < sizeof(cmdline) - 1) {
        unsigned int curpos = cursor.pos();
        memmove(&cmdline[curpos + 1], &cmdline[curpos], cmdlen - curpos);
        cmdline[curpos] = ch;
        cursor.putchar(ch);
        cmdlen++;
        if (curpos != cmdlen) {
            update();
        }
    }
}

//!
//! \brief
//!    Delete the character under the cursor.
//!

void cmdline_t::delchar(void) {
    unsigned int curpos = cursor.pos();
    if (curpos != cmdlen) {
        memmove(&cmdline[curpos], &cmdline[curpos+1], cmdlen - curpos - 1);
        cmdlen--;
        cmdline[cmdlen] = '\0';
        update();
    }
}

//!
//! \brief
//!    Backspace the character before the cursor.
//!

void cmdline_t::backspace(void) {
    unsigned int curpos = cursor.pos();
    if (curpos > 0) {
        memmove(&cmdline[curpos - 1], &cmdline[curpos], cmdlen - curpos + 1);
        cmdlen--;
        cmdline[cmdlen] = '\0';
        cursor.back();
        update();
    }
}

//!
//! \brief
//!    Transpose the character to left of the cursor with the character under
//!    the cursor.
//!

void cmdline_t::transpose(void) {
    unsigned int curpos = cursor.pos();
    char temp = cmdline[curpos];
    cmdline[curpos] = cmdline[curpos - 1];
    cmdline[curpos - 1] = temp;
    cursor.back();
    update();
    cursor.fwd();
}

//!
//! \brief
//!    Process a newline.
//!
//! \details
//!    This function processes the newline.  The command line is retrieved,
//!    converted to all upper case, and the command is executed.
//!

void cmdline_t::newline(void) {
    hist.save(cmdline, cmdlen);
    cmdline[cmdlen] = 0;
    cursor.putchar('\n');
    debug("cmdline: \"%s\" (%d)\n", cmdline, cmdlen);
    cmdlen = 0;
    taskExecute(cmdline, taskHandle);
    memset(cmdline, 0, sizeof(cmdline));
}

//!
//! \brief
//!    Process and input character
//!
//! \param ch -
//!    Character to insert into command line.
//!

void cmdline_t::process(int in) {
    char ch = in & 0xff;

    switch (state) {

        //
        // Not processing an escape sequence
        //

        case stateNONE:

            switch (ch) {

                //
                // <RET>
                //

                case '\r':
                    newline();
                    break;

                //
                // Newline
                //

                case '\n':
                    break;

                //
                // ^A
                // Cursor to beginning of line
                //

                case 0x01:
                    cursor.move(0);
                    break;

                //
                // ^B
                // Cursor backward
                //

                case 0x02:
                    if (cursor.pos() > 0) {
                        cursor.back();
                    }
                    break;

                //
                // ^D
                // Delete character under cursor
                //

                case 0x04:
                case 0x7f:
                    delchar();
                    break;

                //
                // ^E
                // Cursor to end of line
                //

                case 0x05:
                    cursor.move(cmdlen);
                    break;

                //
                // ^F
                // Cursor forward
                //

                case 0x06:
                    if (cursor.pos() < cmdlen) {
                        cursor.fwd();
                    }
                    break;

                //
                // ^G
                // Bell (alarm)
                //

                case 0x07:
                    putchar(ch);
                    break;

                //
                // ^K
                // Clear to end-of-line
                //

                case 0x0b:
                    cursor.eraseeol();
                    cmdlen = cursor.pos();
                    break;

                //
                // ^L
                // Redraw
                //

                case 0x0c:
                    cursor.move(0);
                    update();
                    cursor.fwd(cmdlen);
                    break;

                //
                // ^N
                // Next command
                //

                case 0x0e:
                    get_hist(hist_t::down);
                    break;

                //
                // ^P
                // Previous command
                //

                case 0x10:
                    get_hist(hist_t::up);
                    break;

                //
                // ^T
                // Transpose
                //

                case 0x14:
                    transpose();
                    break;

                //
                // ^U
                // Clear Line
                //

                case 0x15:
                    cursor.move(0);
                    cursor.eraseeol();
                    cmdlen = 0;
                    break;

                //
                // ^[
                // Escape character
                //

                case 0x1b:
                    state = stateESC;
                    break;

                //
                // ^C, ^I
                // Backspace
                //

                case 0x03:
                case 0x08:
                    backspace();
                    break;

                //
                // Everything else
                //

                default:
                    if (isprint(ch)) {
                        inschar(ch);
                    }
                    break;
            }
            break;

        //
        // stateESC
        // <ESC>
        //

        case stateESC:
            switch (ch) {

                //
                // Possibly cursor
                //

                case '[':
                    state = stateESCBRK;
                    break;

                //
                // Possibly PF1-PF4 sequence
                //

                case 'O':
                    state = statePFN;
                    break;

                //
                // Everything else
                //

                default:
                    state = stateNONE;
                    break;
            }
            break;

        //
        // stateESCBRK
        // ESC>[
        //

        case stateESCBRK:
            switch (ch) {

                //
                // Up arrow
                // <ESC>[A
                //

                case 'A':
                    get_hist(hist_t::up);
                    state = stateNONE;
                    break;

                //
                // Down Arrow
                // <ESC>[B
                //

                case 'B':
                    get_hist(hist_t::down);
                    state = stateNONE;
                    break;

                //
                // Right Arrow
                // <ESC>[C
                //

                case 'C':
                    if (cursor.pos() < cmdlen) {
                        cursor.fwd();
                    }
                    state = stateNONE;
                    break;

                //
                // Left Arrow
                // <ESC>[D
                //

                case 'D':
                    if (cursor.pos() > 0) {
                        cursor.back();
                    }
                    state = stateNONE;
                    break;

                //
                // Possible HOME keypad
                // <ESC>[1
                //

                case '1':
                    state = stateHOME;
                    break;


                //
                // Possible INS keypad
                // <ESC>[2
                //

                case '2':
                    state = stateINS;
                    break;

                //
                // Possible END keypad
                // <ESC>[4
                //

                case '4':
                    state = stateEND;
                    break;

                //
                // Possible PGUP keypad
                // <ESC>[5
                //

                case '5':
                    state = statePGUP;
                    break;

                //
                // Possible PGDN keypad
                // <ESC>[6
                //

                case '6':
                    state = statePGDN;
                    break;

                //
                // Everything else
                //

                default:
                    state = stateNONE;
                    break;

            }
            break;

        //
        // PF1 - PF4 keypad
        // <ESC>[O
        //

        case statePFN:
            switch (ch) {

                //
                // PF1
                // <ESC>[OP
                //

                case 'P':
                    debug("PF1\n");
#if 1
                    printf("Dump of command history:\n\n");
                    printf("CMDLINE=\"%s\" (%d)\n", cmdline, cmdlen);
                    printf("cmdlen = %d, curpos = %d\n", cmdlen, cursor.pos());
                    hist.dump();
#endif
                    break;

                //
                // PF2
                // <ESC>[OQ
                //

                case 'Q':
                    debug("PF2\n");
                    break;

                //
                // PF3
                // <ESC>[OR
                //

                case 'R':
                    debug("PF3\n");
                    break;

                //
                // PF4
                // <ESC>[OS
                //

                case 'S':
                    debug("PF4\n");
                    break;
            }
            state = stateNONE;
            break;

        //
        // HOME keypad
        // <ESC>[1~
        //

        case stateHOME:
            if (ch == '~') {
                cursor.move(0);
            }
            state = stateNONE;
            break;

        //
        // INS keypad
        // <ESC>[2~
        //

        case stateINS:
            if (ch == '~') {
                debug("INS\n");
            }
            state = stateNONE;
            break;

        //
        // END keypad
        // <ESC>[4~
        //

        case stateEND:
            if (ch == '~') {
                cursor.move(cmdlen);
            }
            state = stateNONE;
            break;

        //
        // PGUP keypad
        // <ESC>[5~
        //

        case statePGUP:
            if (ch == '~') {
                debug("PGUP\n");
            }
            state = stateNONE;
            break;

        //
        // PGDN keypad
        // <ESC>[6~
        //

        case statePGDN:
            if (ch == '~') {
                debug("PGDN\n");
            }
            state = stateNONE;
            break;
    }
}
