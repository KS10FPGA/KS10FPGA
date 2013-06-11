/*!
********************************************************************************
**
** KS10 Console Microcontroller
**
** \brief
**      Commands
**
** \details
**      All the console commands are implemented in the file.
**
** \file
**      commands.cpp
**
** \author
**      Rob Doyle - doyle (at) cox (dot) net
**
********************************************************************************
*/
/* Copyright (C) 2013 Rob Doyle
**
** This program is free software; you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation; either version 2 of the License, or
** (at your option) any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program; if not, write to the Free Software
** Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
**
********************************************************************************
*/

#include <ctype.h>
#include <stdint.h>

#include "printf.h"
#include "bootcode.hpp"
#include "drivers/ks10.hpp"

static ks10_t::addr_t address;

static enum access_t {
    accessMEM = 0,
    accessIO,
} access;

//!
//! \brief
//!     Parses an octal number from the command line
//!
//! \param [in] buf
//!     Pointer to line buffer.
//!
//! \returns
//!     Octal Number
//! 

static ks10_t::data_t parseOctal(const char *buf) {
    
    ks10_t::data_t num = 0;
    
    for (int i = 0; i < 64; i += 3) {
        if (*buf >= '0' && *buf <= '7') {
            num += *buf - '0';
            num <<= 3;
            continue;
        }
        break;
    }
    
    return num;
}

//!
//! \brief
//!     Parse the PDP10 .SAV file
//!
//! \details
//!     This function reads the .SAV file and writes the contents to
//!     to the KS10.
//!
//! \param [in] data
//!     is the starting address of the .SAV file
//!
//! \notes
//!     This function sets the starting address in the Console
//!     Instruction Register with the starting address contained
//!     in the .SAV file.
//!
//! \returns
//!     Nothing
//! 

static void parseSavFile(const uint8_t *data) {
    for (;;) {

        //
        // The data36 format is:  -n,,a-1
        //

        ks10_t::data_t data36 = rdword(data);
        unsigned int words    = ks10_t::lh(data36);
        unsigned int addr     = ks10_t::rh(data36);
        data += 5;

        //
        // Check for end
        //

        if ((words & 0400000) == 0) {
            if (words == ks10_t::opJRST) {
                
                //
                // Create JRST to starting address.
                //

#ifdef CONFIG_KS10                
                ks10_t::writeCIR(data36);
#else
                printf("Starting Address: %06lo,,%06lo\n",
                       ks10_t::lh(data36), ks10_t::rh(data36));
#endif
                return;
            } 
            return;
        }

        //
        // Read record
        //

        while ((words & 0400000) != 0) {
            ks10_t::data_t data36 = rdword(data);
            data += 5;
#ifdef CONFIG_KS10                
            ks10_t::writeMem(addr, data36);
#else
            //            printf("%06o: %06lo,,%06lo\n", addr,
            //                   ks10_t::lh(data36), ks10_t::rh(data36));
            printf("%06o: %012llo\n", addr, data36);
#endif
            addr  = (addr  + 1) & 0777777;
            words = (words + 1) & 0777777;
	}
    }
}


//
// \brief
//    Load Code
//
// \details
//    The 
//
// \returns
//    Nothing
//
// \note
//    This is a kludge.  Eventually the code should be loaded from a USB or
//    Secure Digital Card.  For now, the code needs to be compiled into the
//    console code.
//

static void loadCode(void) {
    parseSavFile(bootcode);
}

//!
//! \brief
//!    Boot System
//!
//! \details
//!    The Boot (\bBT) command loads code into KS10 memory and starts
//!    execution.
//!
//!    - If there is no argument, the monitor is loaded into KS10 memory
//!      and execution begins at address 01000.
//!
//!    - if there is an argument, SMMON is loaded into KS10 memory and
//!      execution begins at address 020000.
//!
//! \returns
//!    Nothing
//!
//! \note
//!    This is a kludge.  Eventually the code should be loaded from a USB or
//!    Secure Digital Card.  For now, the code needs to be compiled into the
//!    console code.
//!

static void cmdBT(const char *buf) {
    char state = *buf++;
    if (state == '1') {
        loadCode();
    } else {
        loadCode();
    }
    loadCode();
//  ks10_t::run(true);
}

//!
//! \brief
//!    Cache Enable
//!
//! \details
//!    The Cache Enable (\bCE) command enables or disable the KS10's cache.
//!
//! \returns
//!    Nothing
//!

static void cmdCE(const char * buf) {
    char state = *buf++;
    if (state == '0') {
        ks10_t::cacheEnable(false);
    } else if (state == '1') {
        ks10_t::cacheEnable(true);
    } else {
        printf("Command Error.\n"
               "Usage: CE {0 | 1}\n");
    }
}

//!
//! \brief
//!    Continue
//!
//! \details
//!    The Continue (\bCO) command causes the KS10 to exit the HALT state.
//!
//! \returns
//!    Nothing
//!

static void cmdCO(const char *) {
    ks10_t::cont();
}

//!
//! \brief
//!    Deposit IO
//!
//! \details
//!    The Deposit IO (\bDM) deposits data into the IO
//!    address previously loaded by the Load Address (\bLA)
//!    command.
//!
//! \note
//!    If the data is less that 0377 and the address points
//!    to a Unibus Address, this function assumes that a
//!    byte operation is desired.  The KS10 does not do this.
//!
//! \returns
//!    Nothing
//!

static void cmdDI(const char *buf) {
    access = accessIO;
    ks10_t::data_t data = parseOctal(buf);
    if (address <= ks10_t::maxIOAddr) {
        if ((ks10_t::deviceAddr(address) > 0) && (data < 0377)) {
            ks10_t::writeIObyte(address, data);
        } else {
            ks10_t::writeIO(address, data);
        }
    } else {
        printf("Invalid IO address.\n"
               "Valid addresses are %08o-%08llo\n",
               0, ks10_t::maxIOAddr);
    }
}

//!
//! \brief
//!    Deposit Memory
//!
//! \details
//!    The Deposit Memory (\bDM) deposits data into the memory
//!    address previously loaded by the Load Address (\bLA)
//!    command.
//!
//! \returns
//!    Nothing
//!

static void cmdDM(const char *buf) {
    access = accessMEM;
    ks10_t::data_t data = parseOctal(buf);
    if (address <= ks10_t::maxMemAddr) {
        ks10_t::writeMem(address, data);
    } else {
        printf("Invalid memory address.\n"
               "Valid addresses are %08o-%08llo\n",
               0, ks10_t::maxMemAddr);
        
    }
}

//!
//! \brief
//!    Deposit Next
//!
//! \details
//!    The Deposit Next(\bDM) command deposits data into the next 
//!    memory or IO address depending on the last DM or DI
//!    command.
//!
//! \returns
//!    Nothing
//!

static void cmdDN(const char *buf) {
    address += 1;
    ks10_t::data_t data = parseOctal(buf);
    if (access == accessMEM) {
        ks10_t::writeMem(address, data);
    } else {
        ks10_t::writeIO(address, data);
    }
}

//!
//! \brief
//!    Disk Select
//!
//! \details
//!    The Disk Select (\bDS) select the Unit, Unibus Adapter
//!    to load when booting.
//!
//! \returns
//!    Nothing
//!

static void cmdDS(const char *) {
    printf("DS Command is not implemented, yet.\n");
}

//!
//! \brief
//!    Examine IO
//!
//! \details
//!    The Examine IO (\bEI) reads from the last IO
//!    address specified.
//!
//! \returns
//!    Nothing
//!

static void cmdEI(const char *) {
    access = accessIO; 
    printf("%012llo\n", ks10_t::readIO(address));
}

//!
//! \brief
//!    Examine Memory
//!
//! \details
//!    The Examine Memory (\bEM) reads from the last memory
//!    address specified.
//!
//! \returns
//!    Nothing
//!

static void cmdEM(const char *) {
    access = accessMEM;
    printf("%012llo\n", ks10_t::readMem(address));
}

//!
//! \brief
//!    Examine Next
//!
//! \details
//!    The Examine Next (\bEM) reads from next IO or
//!    memory address.
//!
//! \returns
//!    Nothing
//!

static void cmdEN(const char *) {
    if (access == accessMEM) {
        printf("%012llo\n", ks10_t::readMem(address));
    } else {
        printf("%012llo\n", ks10_t::readIO(address));
    }
}

//!
//! \brief
//!    Halt
//!
//! \details
//!    The Halt Command (\bHA) halts the KS10 CPU.
//!
//! \returns
//!    Nothing
//!

static void cmdHA(const char *) {
    ks10_t::halt(true);

    //
    // Wait for the KS10 to halt
    //
    
    while (!ks10_t::halt()) {
        ;
    }

    printf("KS10> Halted\n");
}

//!
//! \brief
//!    Load Memory Address
//!
//! \details
//!    The Load Memory Address (\bLA) command sets the memory
//!    address for the next commands.
//!
//! \returns
//!    Nothing
//!

static void cmdLA(const char *buf) {
    access = accessMEM;
    ks10_t::addr_t addr = parseOctal(buf);
    if (addr <= ks10_t::maxMemAddr) {
        address = addr;
    } else {
        printf("Invalid address.\n"
               "Valid addresses are %08o-%08llo\n",
               0, ks10_t::maxMemAddr);
    }
}

//!
//! \brief
//!    Load Diagnostic Monitor SMMON
//!
//! \details
//!    The Load Diagnostic (\bLB) command loads the diagnostic
//!    Monitor.
//!
//! \returns
//!    Nothing
//!

static void cmdLB(const char *) {
    printf("LB Command is not implemented, yet.\n");
}

//!
//! \brief
//!    Load IO Address
//!
//! \details
//!    The Load IO Address (\bLI) command sets the IO address
//!    for the next commands.
//!
//! \returns
//!    Nothing
//!

static void cmdLI(const char *buf) {
    access = accessIO;
    ks10_t::addr_t addr = parseOctal(buf);
    if (addr <= ks10_t::maxIOAddr) {
        address = addr;
    } else {
        printf("Invalid address.\n"
               "Valid addresses are %08o-%08llo\n",
               0, ks10_t::maxIOAddr);
    }
}

//!
//! \brief
//!    Master Reset
//!
//! \details
//!    The Master Reset (\bMR) command hard resets the KS10 CPU.
//!
//! \returns
//!    Nothing
//!
 
static void cmdMR(const char *) {

    //
    // Reset the CPU
    //

    ks10_t::cpuReset(true);

    //
    // Initialize traps, timer, and cache.
    //
    
    ks10_t::trapEnable(true);
    ks10_t::timerEnable(true);
    ks10_t::cacheEnable(true);
    
    //
    // Delay a little longer
    //

    ks10_t::delay();

    //
    // Unreset the CPU
    //

    ks10_t::cpuReset(false);

    //
    // Wait for the KS10 to peform a selftest and initialize the ALU.  When
    // the microcode initialization is completed, the KS10 will enter a HALT
    // state.  Wait for that to occur.
    //

    while (!ks10_t::halt()) {
        ;
    }

}

//!
//! \brief
//!    Single Step
//!
//! \details
//!    The Step Instruction (\bSI) single steps the KS10 CPU.
//!
//! \returns
//!    Nothing
//!

static void cmdSI(const char *) {
    ks10_t::step();
}

//! 
//! \brief
//!    Shutdown Command
//!
//! \details
//!    The Shutdown (\bSH) command deposits non-zero data in memory location 30.
//!    This causes TOPS20 to shut down without issuing a warning.
//!
//! \returns
//!    Nothing
//!

static void cmdSH(const char *) {
    ks10_t::writeMem(030, 1);
}

//!
//! \brief
//!    Start Command
//!
//! \details
//!    The Start (\bST) command stuffs a JRST instruction into the Console
//!    Instruction Register and TBD.
//!
//! \note
//!    The address must be a virtual address and is therefore limited to
//!    0777777.
//!
//! \returns
//!    Nothing
//!

static void cmdST(const char *buf) {
    ks10_t::addr_t addr = parseOctal(buf);
    if (addr <= ks10_t::maxVirtAddr) {
        ks10_t::writeCIR((ks10_t::opJRST << 18) | (addr & 0777777));
        ks10_t::run(true);
    } else {
        printf("Invalid Address\n"
               "Valid addresses are %08o-%08llo\n",
               0, ks10_t::maxVirtAddr);
    }
}

//!
//! \brief
//!    Enable Timer
//!
//! \details
//!    The Timer Enable (\bTE) command enables or disable the KS10's
//!    1 millisecond system timer.
//!
//! \returns
//!    Nothing
//!

void cmdTE(const char *buf) {
    char state = *buf++;
    if (state == '0') {
        ks10_t::timerEnable(false);
    } else if (state == '1') {
        ks10_t::timerEnable(true);
    } else {
        printf("Command Error.\n"
               "Usage: TE {0 | 1}\n");
    }
}

//!
//! \brief
//!    Enable Traps
//!
//! \details
//!    The Trap Enable (\bTP) command enables or disables KS10's traps.
//!
//! \returns
//!    Nothing
//!
//!

static void cmdTP(const char * buf) {
    char state = *buf++;
    if (state == '0') {
        ks10_t::trapEnable(false);
    } else if (state == '1') {
        ks10_t::trapEnable(true);
    } else {
        printf("Command Error.\n"
               "Usage: TP {0 | 1}\n");
    }
}

//!
//! \brief
//!    Not implemented
//!
//! \details
//!    This function handles commands that are not implemented.
//!
//! \returns
//!    Nothing
//!

static void cmdXX(const char * buf) {
    buf -= 2;
    printf("Command \"%c%c\" is not implemented.\n", buf[0], buf[1]);
}


static void cmdZZ(const char * buf) {
    printf("Test is %012llo\n", 0765432123456);
}

void parseCMD(char * buf) {

    //
    // List of Commands
    //

    struct cmdList_t {
        const char * name;
        void (*function)(const char *);
    };

    static const cmdList_t cmdList[] = {
        {"BT", cmdBT},
        {"B2", cmdXX},		// Not implemented.
        {"CE", cmdCE},
        {"CH", cmdXX},		// Not implemented.
        {"CO", cmdCO},
        {"CP", cmdXX},		// Not implemented.
        {"CS", cmdXX},		// Not implemented.
        {"DB", cmdXX},		// Not implemented.
        {"DC", cmdXX},		// Not implemented.
        {"DF", cmdXX},		// Not implemented.
        {"DK", cmdXX},		// Not implemented.
        {"DI", cmdDI},
        {"DM", cmdDM},
        {"DN", cmdDN},
        {"DR", cmdXX},		// Not implemented.
        {"DS", cmdDS},
        {"EB", cmdXX},		// Not implemented.
        {"EC", cmdXX},		// Not implemented.
        {"EK", cmdXX},		// Not implemented.
        {"EI", cmdEI},
        {"EJ", cmdXX},		// Not implemented.
        {"EM", cmdEM},
        {"EN", cmdEN},
        {"ER", cmdXX},		// Not implemented.
        {"EX", cmdXX},		// Not implemented.
        {"FI", cmdXX},		// Not implemented.
        {"HA", cmdHA},
        {"KL", cmdXX},		// Not implemented.
        {"LA", cmdLA},
        {"LB", cmdLB},
        {"LC", cmdXX},		// Not implemented.
        {"LF", cmdXX},		// Not implemented.
        {"LI", cmdLI},
        {"LK", cmdXX},		// Not implemented.
        {"LR", cmdXX},		// Not implemented.
        {"LT", cmdXX},		// Not implemented.
        {"MB", cmdXX},		// Not implemented.
        {"MK", cmdXX},		// Not implemented.
        {"MM", cmdXX},		// Not implemented.
        {"MR", cmdMR},
        {"MS", cmdXX},		// Not implemented.
        {"MT", cmdXX},		// Not implemented.
        {"PE", cmdXX},		// Not implemented.
        {"PM", cmdXX},		// Not implemented.
        {"PW", cmdXX},		// Not implemented.
        {"RC", cmdXX},		// Not implemented.
        {"RP", cmdXX},		// Not implemented.
        {"SC", cmdXX},		// Not implemented.
        {"SH", cmdSH},
        {"SI", cmdSI},
        {"ST", cmdST},
        {"TE", cmdTE},
        {"TP", cmdTP},
        {"TT", cmdXX},		// Not implemented.
        {"UM", cmdXX},		// Not implemented.
        {"VD", cmdXX},		// Not implemented.
        {"VT", cmdXX},		// Not implemented.
        {"VM", cmdXX},		// Not implemented.
        {"ZZ", cmdZZ},		// Testing
    };

    const int numCMD = sizeof(cmdList)/sizeof(cmdList_t);

    for (int i = 0; buf[i] != 0; i++) {
        buf[i] = toupper(buf[i]);
    }

    for (int i = 0; i < numCMD; i++) {
        if ((cmdList[i].name[0] == buf[0]) &&
            (cmdList[i].name[1] == buf[1])) {
            (*cmdList[i].function)(&buf[2]);
            return;
        }
    }
    printf("Command not found\n");
}
