//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    Main Program
//!
//! \details
//!    This is the console program entry point.  This function does some simple
//!    hardware checks and then starts the console processing.
//!
//! \file
//!    main.cpp
//!
//! \author
//!    Rob Doyle - doyle (at) cox (dot) net
//
//******************************************************************************
//
// Copyright (C) 2013-2022 Rob Doyle
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
#include <termios.h>
#include <sys/select.h>

#include "mt.hpp"
#include "ks10.hpp"
#include "tape.hpp"
#include "vt100.hpp"
#include "cmdline.hpp"
#include "commands.hpp"

#define __noreturn __attribute__((noreturn))

static volatile bool print_hsb = false;
static const char *prompt = "KS10> ";

//!
//! \brief
//!    This thread polls the KS10 Halt Status.
//!
//!    This really should be an interrupt that triggers when the halt signal
//!    transitions from one state to another or when a character becomes
//!    available. For now, this is much simpler.
//!
//! \note
//!    Because this application is multi-threaded, you must be careful with
//!    the FPGA IO Mutex locking.
//!

void *__noreturn haltThread(void *) {
    bool halted = true;
    printf("KS10: Halt Status thread started.\n");
    for (;;) {
        bool halt = ks10_t::halt();
        if (halt && !halted) {
            printf("KS10: %sHalted.%s\n", vt100fg_red, vt100at_rst);
            print_hsb = true;
        } else if (halted && !halt) {
            printf("KS10: %sRunning.%s\n", vt100fg_grn, vt100at_rst);
        }
        halted = halt;
//      usleep(1);
    }
}

//!
//! \brief
//!    This thread polls the CTY status.
//!
//! \note
//!    Because this application is multi-threaded, you must be careful with
//!    the FPGA IO Mutex locking.
//!

void * __noreturn ctyThread(void *) {
    printf("KS10: CTY thread started.\n");
    for (;;) {
        int ch = ks10_t::getchar();
        switch (ch) {
            case -1:
            case 0x01:
            case 0x05:
            case 0x1b:
                break;
            default:
                printf("%c", ch);
                fflush(stdout);
                break;
        }
        usleep(100);
    }
}

//!
//! \brief
//!    Main Program
//!

int main(int argc, char *argv[]) {

    const bool debugKS10 = (argc == 2) && (strncasecmp(argv[1], "--debug", 5) == 0);

    //
    // Print startup message
    //

    printf("%s%s"
           "KS10: Console started.\n"
           "KS10: Copyright 2012-2021 (c) Rob Doyle.  All rights reserved.\n",
           vt100_hom, vt100_cls);

    //
    // Initialize the KS10 object
    //

    ks10_t ks10(debugKS10);

    //
    // Check the firmware revision.
    //

    ks10.checkFirmware();

    //
    // Test the Console Interface Registers
    //

    ks10.testRegs();

    //
    // Create the Halt Status thread
    //

    pthread_t haltThreadID;
    int status = pthread_create(&haltThreadID, NULL, &haltThread, NULL);
    if (status != 0) {
        printf("KS10: pthread_create(haltThread) returned \"%s\".\n", strerror(status));
        exit(EXIT_FAILURE);
    }

    //
    // Create CTY thread
    //

    pthread_t ctyThreadID;
    status = pthread_create(&ctyThreadID, NULL, &ctyThread, NULL);
    if (status != 0) {
        printf("KS10: pthread_create(ctyThread) returned \"%s\".\n", strerror(status));
        exit(EXIT_FAILURE);
    }

    //
    // Create TAPE thread
    //

    pthread_t tapeThreadID;
    const char *file = "red405a2.tap";
    //const char *file = "temp.tap";
    status = pthread_create(&tapeThreadID, NULL, &tape_t::processThread, (void*)file);
    if (status != 0) {
        printf("KS10: pthread_create(tapeThread) returned \"%s\".\n", strerror(status));
        exit(EXIT_FAILURE);
    }

    usleep(1000);

    //
    // Boot the KS10
    //
    // Wait for the KS10 to peform the selftest and initialize the ALU.  When
    // the microcode initialization is completed, the KS10 will enter a HALT
    // state.
    //

    printf("KS10: Booting KS10.\n");
    fflush(stdin);
    ks10.boot();

    //
    // Recall configuration
    //

    recallConfig();

    //
    // Check RP Initialization Status
    //

    sleep(1);

    uint64_t rpdebug = ks10.getRPDEBUG();
    if (rpdebug >> 56 == ks10_t::rpIDLE) {
        printf("KS10: RP06 successfully initialized SDHC media.\n");
    } else if (rpdebug >> 40 == 0x7e0c80) {
        printf("KS10: %sRP06 cannot utilize SDSC media.  Use SDHC media.%s\n", vt100fg_red, vt100at_rst);
    } else {
        printf("KS10: %sRP06 failed to initialize SDHC media.%s\n", vt100fg_red, vt100at_rst);
        ks10.printRPDEBUG();
    }

    //
    // Set stdio to unbuffered and no echo
    //

    struct termios termattr;
    tcgetattr(STDIN_FILENO, &termattr);
    termattr.c_lflag &= ~(ICANON | ECHO);
    tcsetattr(STDIN_FILENO, TCSANOW, &termattr);

    //
    // Process characters
    //

    cmdline_t cmdline(strlen(prompt));

    fd_set fds;
    struct timeval tv = {0, 0};

    for (;;) {

        FD_ZERO(&fds);
        FD_SET(STDIN_FILENO, &fds);

        if (select(1, &fds, NULL, NULL, &tv) != 0) {
            int ch = getchar();
            if (cmdline.process(ch)) {
                printf(prompt);
                fflush(stdout);
            }
            fflush(stdout);
        } else {
            if (print_hsb) {
                ks10_t::printHaltStatusWord();
                printf(prompt);
                fflush(stdout);
                print_hsb = false;
            }
        }
    }

    return 0;
}
