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

#include <thread>

#include <ctype.h>
#include <error.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <getopt.h>
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

void __noreturn haltThread(void) {
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

void __noreturn ctyThread(void) {
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
//!    Process Initialization File
//!
//! \param command -
//!    Reference to Command Processing object
//!
//! \param filename -
//!    "ini" filename to read and process
//!
//! \param debug -
//!    Enable debug when true.
//!

void processIniFile(command_t &command, const char *filename, bool debug = false) {

    FILE *fp = fopen(filename, "r");

    if (fp == NULL) {
        printf("KS10: Unable to open initialization file: \"%s\".\n", filename);
        return;
    }

    size_t len = 0;
    ssize_t nread;
    char *cmd = NULL;

    printf("KS10: Processing Initialization File \"%s\"%c\n", filename, debug ? ':' : '.');
    while ((nread = getline(&cmd, &len, fp)) != -1) {
        // Replace newline with null termination
        cmd[nread-1] = 0;
        if (debug) {
            printf("KS10:  %s\n", cmd);
        }
        command.execute(cmd);
    }
    fclose(fp);

}

//!
//! \brief
//!    Main Program
//!

int main(int argc, char *argv[]) {

    bool debugKS10 = false;

    const char *usage =
        "\n"
        "Start the KS10 Console Application\n"
        "\n"
        "usage: console [options]\n"
        "\n"
        "Valid options are:\n"
        "\n"
        "  --help          Print this help message and exit.\n"
        "  --debug         Enable verbose debugging at startup.\n"
        "  --ini=inifile   Execute the commands in the initialization file after startup.\n"
        "  --ver[sion]     Print the build date and exit.\n"
        "\n"
        "At startup and before any other initialization files are processed, the console\n"
        "application will execute the commands the file: \"ks10.ini\".\n"
        "\n";

    static const struct option options[] = {
        {"help",    no_argument,       0, 0},  // 0
        {"ver",     no_argument,       0, 0},  // 1
        {"version", no_argument,       0, 0},  // 2
        {"debug",   no_argument,       0, 0},  // 3
        {"ini",     required_argument, 0, 0},  // 4
        {0,         0,                 0, 0},  // 5
    };

    //
    // Print startup message
    //

    printf("%s%s"
           "KS10: Console started.\n"
           "KS10: Copyright 2012-2022 (c) Rob Doyle.  All rights reserved.\n",
           vt100_hom, vt100_cls);

    //
    // Process command line
    //

    char * arglist[16];
    unsigned int argcnt = 0;
    opterr = 0;
    for (;;) {
        int index = 0;
        int ret = getopt_long(argc, argv, "", options, &index);
        if (ret == -1) {
            break;
        } else if (ret == '?') {
            printf("lp: unrecognized option: %s\n", argv[optind-1]);
            return true;
        } else {
            switch (index) {
                case 0:
                    // help
                    printf(usage);
                    return EXIT_SUCCESS;
                case 1:
                case 2:
                    // version
                    printf("KS10: Console Application built %s\n", __DATE__);
                    return EXIT_SUCCESS;
                case 3:
                    // debug
                    debugKS10 = true;
                    break;
                case 4:
                    // ini
                    if (argcnt < sizeof(arglist) / sizeof(arglist[0])) {
                        arglist[argcnt++] = optarg;
                    }
                    break;
            }
        }
    }

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

    std::thread thread1(haltThread);

    //
    // Create CTY thread
    //

    std::thread thread2(ctyThread);

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
    // Create command parser
    //

    command_t command;

    //
    // Process the ".ini" file
    //

    processIniFile(command, "ks10.ini", debugKS10);
    for (unsigned int i = 0; i < argcnt; i++) {
        processIniFile(command, arglist[i], debugKS10);
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

    cmdline_t cmdline(command, strlen(prompt));

    fd_set fds;
    struct timeval tv = {0, 0};

    //
    // Wait for commands to process before printing prompt
    //

    usleep (250000);

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
