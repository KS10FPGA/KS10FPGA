//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    Command History Buffer
//!
//! \file
//!    hist.cpp
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

#include "hist.hpp"

//!
//! \brief
//!    Constructor
//!

hist_t::hist_t(void) :
    head(0),
    tail(0),
    index(0) {
    memset(buffer, 0, bufsize);
}

//!
//! \brief
//!    Dump the circular buffer in a semi-readable manner.
//!

void hist_t::dump(void) {

    printf("head = %d, tail = %d, index = %d,\n", head, tail, index);

    //
    // Print tens row
    //

    printf ("\n");
    for (unsigned int i = 0; i < bufsize; i++) {
        if ((i % 10) == 0) {
            printf("%1d", i / 10);
        } else {
            printf(" ");
        }
    }
    printf ("\n");

    //
    // Print ones row
    //

    for (unsigned int i = 0; i < bufsize; i++) {
        printf("%1d", i % 10);
    }
    printf ("\n");

    //
    // Print buffer
    //

    for (unsigned int i = 0; i < bufsize; i++) {
        if (isprint(buffer[i])) {
            printf("%c", buffer[i]);
        } else {
            printf("%d", buffer[i] % 10);
        }
    }
    printf ("\n");
}

//!
//! \brief
//!    Circular addressing
//!
//! \param index -
//!    input index
//!
//! \returns -
//!    index wrapped per the buffer size
//!

inline unsigned int hist_t::wrap(unsigned int index) const {
    if (index >= bufsize) {
        index -= bufsize;
    }
    return index;
}

//!
//! \brief
//!    Find/make some free space in the buffer suitable for storing the command
//!    line.   The head is moved until there is buffer space.
//!
//! \param size -
//!    The amount of buffer space to find.
//!

void hist_t::findfree(unsigned int size) {

    for(;;) {

        //
        // Check empty
        //

        if (buffer[head] == 0) {
            return;
        }

        //
        // Delete oldest entries
        //

        if (tail < head) {
            if (size < head - tail - 1) {
                return;
            }
        } else {
            if (size < bufsize + head - tail - 1) {
                return;
            }
        }
        head = wrap(head + buffer[head] + 1);
    }
}

//!
//! \brief
//!    Save the command line in the buffer
//!
//! \param cmdline -
//!    command line to store in buffer
//!
//! \param size -
//!    size of the command line
//!

void hist_t::save(const char* cmdline, unsigned char size) {

    //
    // Check size.  Don't store zero length command.
    //

    if ((size > bufsize - 2) || (size == 0)) {
        return;
    }

    //
    // Free some space
    //

    findfree(size);

    //
    // Initialize head, if not alread initialized
    //

    if (buffer[head] == 0) {
        buffer[head] = size;
    }

    //
    // Copy command line to buffer.
    //

    buffer[tail] = size;
    tail = wrap(tail + 1);
    for (int i = 0; i < size; i++) {
        buffer[tail] = cmdline[i];
        tail = wrap(tail + 1);
    }
    buffer[tail] = 0;
    index = 0;
}

//!
//! \brief
//!    Count the number of entries in the command buffer
//!
//! \returns
//!    number of command line entries in the buffer
//!

unsigned int hist_t::entries(void) {
    unsigned int i;
    unsigned int header = head;
    for (i = 0; buffer[header] != 0; i++) {
        header = wrap(header + buffer[header] + 1);
    }
    return i;
}

//!
//! \brief
//!
//! \param head -
//!    location of head index
//!
//! \param num -
//!    number of entries in buffer
//!
//! \param index -
//!    current index
//!
//! \returns
//!    location of header for this index
//!


unsigned int hist_t::find(unsigned int head, unsigned int num, unsigned int index) {
    unsigned int header = head;
    for (unsigned int i = 0; buffer[header] != 0; i++) {
        if (num - i == index) {
            break;
        }
        header = wrap(header + buffer[header] + 1);
    }
    return header;
}

//!
//! \brief
//!    Copy the data to the command line
//!
//! \param [out] cmdline -
//!    pointer to destination (usually cmdline)
//!
//! \param [in] header -
//!    location of header in buffer
//!
//! \returns
//!    size of the command line
//!

int hist_t::copybuffer(char* dest, unsigned int header) {
    unsigned int temp = wrap(header + 1);
    for (int i = 0; i < buffer[header]; i++) {
        dest[i] = buffer[temp];
        temp = wrap(temp + 1);
    }
    return buffer[header];
}

//!
//! \brief
//!    Get a command line from the buffer
//!
//! \param [out] cmdline -
//!    pointer to destination (usually cmdline)
//!
//! \param [in] dir -
//!    direction of buffer motion
//!
//! \returns
//!    -1, if at beginning of command buffer,
//!     0, if at end of command buffer,
//!     otherwise the number of characters in the command
//!

int hist_t::recall(char* cmdline, dir_t dir) {

    unsigned int num = entries();

    if (dir == up) {

        unsigned int header = find(head, num - 1, index);
        if ((index <= num) && buffer[header]){
            index++;
            return copybuffer(cmdline, header);
        }
        return -1;

    } else {

        unsigned int header = find(head, num + 1, index);
        if (index > 0) {
            index--;
            return copybuffer(cmdline, header);
        }
        return 0;

    }
}
