//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    Tape File simulator
//!
//! \details
//!    This file defines an object that performs tape operations on a tape file.
//!
//! \file
//!    tape.cpp
//!
//! \author
//!    Rob Doyle - doyle (at) cox (dot) net
//
//******************************************************************************
//
// Copyright (C) 2021-2022 Rob Doyle
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

#include <exception>

#include <stdio.h>
#include <unistd.h>

#include "mt.hpp"
#include "tape.hpp"
#include "dasm.hpp"
#include "ks10.hpp"
#include "vt100.hpp"
#include "commands.hpp"

#define DEBUG_TOP(...)          ({if (debug & debugTOP     ) printf(__VA_ARGS__);})
#define DEBUG_HEADER(...)       ({if (debug & debugHEADER  ) printf(__VA_ARGS__);})
#define DEBUG_UNLOAD(...)       ({if (debug & debugUNLOAD  ) printf(__VA_ARGS__);})
#define DEBUG_REWIND(...)       ({if (debug & debugREWIND  ) printf(__VA_ARGS__);})
#define DEBUG_PRESET(...)       ({if (debug & debugPRESET  ) printf(__VA_ARGS__);})
#define DEBUG_ERASE(...)        ({if (debug & debugERASE   ) printf(__VA_ARGS__);})
#define DEBUG_WRTM(...)         ({if (debug & debugWRTM    ) printf(__VA_ARGS__);})
#define DEBUG_RDFWD(...)        ({if (debug & debugRDFWD   ) printf(__VA_ARGS__);})
#define DEBUG_RDREV(...)        ({if (debug & debugRDREV   ) printf(__VA_ARGS__);})
#define DEBUG_WRCHKFWD(...)     ({if (debug & debugWRCHKFWD) printf(__VA_ARGS__);})
#define DEBUG_WRCHKREV(...)     ({if (debug & debugWRCHKREV) printf(__VA_ARGS__);})
#define DEBUG_WRFWD(...)        ({if (debug & debugWRFWD   ) printf(__VA_ARGS__);})
#define DEBUG_SPCFWD(...)       ({if (debug & debugSPCFWD  ) printf(__VA_ARGS__);})
#define DEBUG_SPCREV(...)       ({if (debug & debugSPCREV  ) printf(__VA_ARGS__);})
#define DEBUG_BOTEOT(...)       ({if (debug & debugBOTEOT  ) printf(__VA_ARGS__);})
#define DEBUG_DELAY(...)        ({if (debug & debugDELAY   ) printf(__VA_ARGS__);})
#define DEBUG_VALIDATE(...)     ({if (debug & debugVALIDATE) printf(__VA_ARGS__);})
#define DEBUG_DATA(...)         ({if (debug & debugDATA    ) printf(__VA_ARGS__);})
#define DEBUG_POS(...)          ({if (debug & debugPOS     ) printf(__VA_ARGS__);})

#define PARANOID
#undef  DEBUG_REGS

//!
//! \brief
//!    max() macro
//!
//! \note
//!    This uses GCC language extensions.
//!

#define max(a,b) ({           \
    __typeof__ (a) _a = (a);  \
    __typeof__ (b) _b = (b);  \
    _a > _b ? _a : _b;        \
})

//!
//! \brief
//!    Wait a delay proportional to number of bytes at the current recording
//!    density.
//!
//! \details
//!    The tape drive reads and writes at 75 inches-per-second (nominally).
//!
//!    With a recording density of 800 bytes-per-inch and with a read/write
//!    speed of 75 inches-per-second, data is transferred at 60,000
//!    bytes-per-second.
//!
//!    With a recording density of 1600 bytes-per-inch and with a read/write
//!    speed of 75 inches-per-second, data is transferred at 120,000
//!    bytes-per-second.
//!

inline void tape_t::waitReadWrite(uint8_t density, unsigned int bytes) {
    float usec_per_byte = (density == d_1600BPI) ? 1.0e6/120000.0 : 1.0e6/60000.0;
    float microsec = (float)bytes * usec_per_byte;
    DEBUG_DELAY("TAPE: Unit %d: Read/write delay is %.1f ms.\n", unit, microsec * 0.001);
    usleep((unsigned int)microsec + 0.5);
}

//!
//! \brief
//!    Wait a delay proportional to file offset for rewind at the current
//!    recording density.
//!
//! \details
//!    The tape drive rewinds at 350 inches-per-second (nominally).
//!
//!    With a recording density of 800 bytes-per-inch and with a rewind speed
//!    of 350 inches-per-second, the tape rewinds at 280,000 bytes-per-second.
//!
//!    With a recording density of 1600 bytes-per-inch and with a rewind speed
//!    of 350 inches-per-second, the tape rewinds at 560,000 bytes-per-second.
//!

inline void tape_t::waitRewind(uint8_t density, unsigned int offset) {
    float usec_per_byte = (density == d_1600BPI) ? 1.0e6/560000.0 : 1.0e6/280000.0;
    float microsec = (float)offset * usec_per_byte;
    DEBUG_DELAY("TAPE: Unit %d: Rewind delay is %.1f ms.\n", unit, microsec * 0.001);
    usleep((unsigned int)microsec + 0.5);
}

//!
//! \brief
//!    Read header from tape file
//!
//! \details
//!    Header data is always little-endian.
//!
//!    If we can't read the entire header, we assume we are at EOT.
//!
//! \returns
//!    32-bit data header or error indication
//!

uint32_t tape_t::readHeader(void) {

    uint8_t buf[4];
    const unsigned int bufsiz = sizeof(buf)/sizeof(buf[0]);

    size_t nread = fread(buf, sizeof(buf[0]), bufsiz, fp);
    if (nread != bufsiz) {
        DEBUG_HEADER("TAPE: Unit %d: Error: readHeader() - fread() returned %d.\n", unit, nread);
        return h_EOT;
    }

    return ((((uint32_t) buf[0]) <<  0) |
            (((uint32_t) buf[1]) <<  8) |
            (((uint32_t) buf[2]) << 16) |
            (((uint32_t) buf[3]) << 24));
}

//!
//! \brief
//!    Write header to tape file
//!
//! \returns
//!    0 if header written sucessfully, -1 otherwise.
//!

int tape_t::writeHeader(uint32_t header) {

    char buf[4];
    const unsigned int bufsiz = sizeof(buf)/sizeof(buf[0]);

    buf[0] = ((header & 0x000000ff) >>  0);
    buf[1] = ((header & 0x0000ff00) >>  8);
    buf[2] = ((header & 0x00ff0000) >> 16);
    buf[3] = ((header & 0xff000000) >> 24);

    size_t nwrite = fwrite(buf, sizeof(buf[0]), bufsiz, fp);
    if (nwrite != bufsiz) {
        printf("TAPE: Unit %d: Error: writeHeader() - fwrite() returned %d.\n", unit, nwrite);
        return -1;
    }
    return 0;
}

//!
//! \brief
//!
//!    Read one word of PDP-10 CORDMP Data from tape
//!
//! \param [out] data
//!    36-bit data word which was read.
//!
//! \details
//!    Core Dump Data (Format 0) is stored as follows:
//!
//!    Byte 0: B00 B01 B02 B03 B04 B05 B06 B07
//!    Byte 1: B08 B09 B10 B11 B12 B13 B14 B15
//!    Byte 2: B16 B17 B18 B19 B20 B21 B22 B23
//!    Byte 3: B24 B25 B26 B27 B28 B29 B30 B31
//!    Byte 4:  0   0   0   0  B32 B33 B34 B35
//!
//! \returns
//!    0 if data is written successfully, -1 otherwise.
//!

inline int tape_t::readDataCORDMP(ks10_t::data_t &data) {

    uint8_t buf[5];
    const unsigned int bufsiz = sizeof(buf)/sizeof(buf[0]);

    size_t nread = fread(buf, sizeof(buf[0]), bufsiz, fp);
    if (nread != bufsiz) {
        printf("TAPE: Unit %d: Error: readData(CoreDump) - fread() returned %d.\n", unit, nread);
        return -1;
    }

    data = ((((ks10_t::data_t)buf[0] & 0xff) << 28) |
            (((ks10_t::data_t)buf[1] & 0xff) << 20) |
            (((ks10_t::data_t)buf[2] & 0xff) << 12) |
            (((ks10_t::data_t)buf[3] & 0xff) <<  4) |
            (((ks10_t::data_t)buf[4] & 0x0f) <<  0));

    return 0;
}

//!
//! \brief
//!    Read one word of PDP-10 COMPAT Data from tape
//!
//! \param [out] data
//!    36-bit data word which was read.
//!
//! \details
//!    Compat Data (Format 3) is stored as follows:
//!
//!    Byte 0: B00 B01 B02 B03 B04 B05 B06 B07
//!    Byte 1: B08 B09 B10 B11 B12 B13 B14 B15
//!    Byte 2: B16 B17 B18 B19 B20 B21 B22 B23
//!    Byte 3: B24 B25 B26 B27 B28 B29 B30 B31
//!
//! \returns
//!    0 if data is written successfully, -1 otherwise.
//!

inline int tape_t::readDataCOMPAT(ks10_t::data_t &data) {

    uint8_t buf[4];
    const unsigned int bufsiz = sizeof(buf)/sizeof(buf[0]);

    size_t nread = fread(buf, sizeof(buf[0]), bufsiz, fp);
    if (nread != bufsiz) {
        printf("TAPE: Unit %d: Error: readData(Compat) - fread() returned %d.\n", unit, nread);
        return -1;
    }

    data = ((((ks10_t::data_t)buf[0] & 0xff) << 28) |
            (((ks10_t::data_t)buf[1] & 0xff) << 20) |
            (((ks10_t::data_t)buf[2] & 0xff) << 12) |
            (((ks10_t::data_t)buf[3] & 0xff) <<  4));

    return 0;
}

//!
//! \brief
//!    Read one word of data from file.
//!
//! \details
//!    The data can be in diferent formats
//!
//! \param data
//!    36-bit data word to be written
//!
//! \param format
//!    Format to be written
//!
//! \returns
//!    0 if data is written successfully, -1 otherwise.
//!

int tape_t::readData(uint8_t format, ks10_t::data_t &data) {
    switch (format) {
        case f_CORDMP:
            return readDataCORDMP(data);
        case f_COMPAT:
            return readDataCOMPAT(data);
    }
    return -1;
}

//!
//! \brief
//!    Write one word of PDP-10 CORDMP Data to tape
//!
//! \param data
//!    36-bit data word to be written
//!
//! \details
//!    Core Dump Data (Format 0) is stored as follows:
//!
//!    Byte 0: B00 B01 B02 B03 B04 B05 B06 B07
//!    Byte 1: B08 B09 B10 B11 B12 B13 B14 B15
//!    Byte 2: B16 B17 B18 B19 B20 B21 B22 B23
//!    Byte 3: B24 B25 B26 B27 B28 B29 B30 B31
//!    Byte 4:  0   0   0   0  B32 B33 B34 B35
//!

int tape_t::writeDataCORDMP(ks10_t::data_t data) {

    char buf[5];
    const unsigned int bufsiz = sizeof(buf)/sizeof(buf[0]);

    buf[0] = ((data & 0xff0000000) >> 28);
    buf[1] = ((data & 0x00ff00000) >> 20);
    buf[2] = ((data & 0x0000ff000) >> 12);
    buf[3] = ((data & 0x000000ff0) >>  4);
    buf[4] = ((data & 0x00000000f) >>  0);

    size_t nwrite = fwrite(buf, sizeof(buf[0]), bufsiz, fp);
    if (nwrite != bufsiz) {
        printf("TAPE: Unit %d: Error: writeCoreDump() - fwrite() returned %d.\n", unit, nwrite);
        return -1;
    }

    return 0;
}

//!
//! \brief
//!    Write one word of PDP-10 COMPAT Data to tape
//!
//! \param data
//!    36-bit data word to be written
//!
//! \details
//!    Compat Data (Format 3) is stored as follows:
//!
//!    Byte 0: B00 B01 B02 B03 B04 B05 B06 B07
//!    Byte 1: B08 B09 B10 B11 B12 B13 B14 B15
//!    Byte 2: B16 B17 B18 B19 B20 B21 B22 B23
//!    Byte 3: B24 B25 B26 B27 B28 B29 B30 B31

int tape_t::writeDataCOMPAT(ks10_t::data_t data) {

    char buf[4];
    const unsigned int bufsiz = sizeof(buf)/sizeof(buf[0]);

    buf[0] = ((data & 0xff0000000) >> 28);
    buf[1] = ((data & 0x00ff00000) >> 20);
    buf[2] = ((data & 0x0000ff000) >> 12);
    buf[3] = ((data & 0x000000ff0) >>  4);

    size_t nwrite = fwrite(buf, sizeof(buf[0]), bufsiz, fp);
    if (nwrite != bufsiz) {
        printf("TAPE: Unit %d: Error: writeCoreDump() - fwrite() returned %d.\n", unit, nwrite);
        return -1;
    }
    return 0;
}

//!
//! \brief
//!    Read one word of data from file.
//!
//! \details
//!    The data can be in diferent formats
//!
//! \param data
//!    36-bit data word to be written
//!
//! \param format
//!    Format to be written
//!
//! \returns
//!    36-bit data word
//!

int tape_t::writeData(ks10_t::data_t data, uint8_t format) {
    switch (format) {
        case f_CORDMP:
            return writeDataCORDMP(data);
        case f_COMPAT:
            return writeDataCOMPAT(data);
    }
    return -1;
}

//!
//! \brief
//!    This function peforms a tape unload function
//!
//! \details
//!    This function does the following:
//!
//!    #.  It performs a delay that is proportional to the initial file position.
//!    #.  Sets the file position back to the beginning-of-file.
//!

void tape_t::unload(uint64_t mtDIR) {
    DEBUG_UNLOAD("TAPE: Unit %d: Unload.\n", unit);
    objcnt = 1;
    reccnt = 1;
    filcnt = 1;
    waitRewind(getDEN(mtDIR), ftell(fp));
    fseek(fp, 0, SEEK_SET);
    DEBUG_UNLOAD("TAPE: Unit %d: Unload Done. Pos = %ld.\n", unit, ftell(fp));
}

//!
//! \brief
//!    This function peforms a tape rewind function
//!
//! \details
//!    This function does the following:
//!
//!    #.  It performs a delay that is proportional to the initial file position.
//!    #.  Sets the file position back to the beginning-of-file.
//!

void tape_t::rewind(uint64_t mtDIR) {
    DEBUG_REWIND("TAPE: Unit %d: Rewind.\n", unit);
    objcnt = 1;
    reccnt = 1;
    filcnt = 1;
    waitRewind(getDEN(mtDIR), ftell(fp));
    fseek(fp, 0, SEEK_SET);
    DEBUG_REWIND("TAPE: Unit %d: Rewind Done. Pos = %ld.\n", unit, ftell(fp));
}

//!
//! \brief
//!    This function peforms a tape read-in preset function
//!
//! \details
//!    This function does the following:
//!
//!    #.  It performs a delay that is proportional to the initial file position.
//!    #.  Sets the file position back to the beginning-of-file.
//!

void tape_t::preset(uint64_t mtDIR) {
    DEBUG_PRESET("TAPE: Unit %d: Preset.\n", unit);
    objcnt = 1;
    reccnt = 1;
    filcnt = 1;
    waitRewind(getDEN(mtDIR), ftell(fp));
    fseek(fp, 0, SEEK_SET);
    DEBUG_PRESET("TAPE: Unit %d: Preset Done. Pos = %ld.\n", unit, ftell(fp));
}

//!
//! \brief
//!    This function erases approximately 3 inches of tape.
//!
//! \details
//!    Starting at the current position, erase the amount of tape indicated by
//!    the specified length and density. If the end of the gap overwrites an
//!    existing record, shorten that record appropriately. Position the tape
//!    after the gap.
//!
//!    The TU-45 supports densities of either 800 Bytes-Per-Inch (BPI) or 1600
//!    Bytes-Per-Inch (BPI); therefore this command erases either 2400 bytes or
//!    4800 bytes of data.
//!
//!    The TU-45 also operates at 75 inches per second. Therefore the tape
//!    motion requires 40 milliseconds to erase 3 inches of tape.
//!
//! \note
//!    Because headers are 4 bytes, and PDP10 words are either 4 bytes or 5 bytes,
//!    the erase gap should always be a multiple of 20 bytes.
//!

void tape_t::erase(uint64_t mtDIR) {
    DEBUG_ERASE("TAPE: Unit %d: Erase.\n", unit);

    size_t bytes = (getDEN(mtDIR) == d_1600BPI) ? 3 * 1600 : 3 * 800;
    int gaps = bytes / sizeof(h_GAP);

    uint32_t header = readHeader();
    DEBUG_HEADER("TAPE: Unit %d: Header was %d (0x%08x), (pos=%ld)\n", unit, header, header, ftell(fp) - sizeof(header));

    if (header < 0xffff0000) {

        DEBUG_ERASE("TAPE: Unit %d: Header was valid. Writing GAP and updating the following record.\n", unit);
        for (int i = 0; i < gaps; i++) {
            writeHeader(h_GAP);
        }

        DEBUG_ERASE("TAPE: Unit %d: Header - bytes was %d (0x%08x).\n", unit, header - bytes, header - bytes);

        writeHeader(header - bytes);
        fseek(fp, header - bytes, SEEK_CUR);
        writeHeader(header - bytes);
        fseek(fp, -(header - bytes) - 2 * sizeof(header), SEEK_CUR);

    } else {

        DEBUG_ERASE("TAPE: Unit %d: Header was not valid. Just writing GAP.\n", unit);
        for (int i = 0; i < gaps + 1; i++) {
            writeHeader(h_GAP);
        }

        //
        // This erase can potentially make the file larger.
        //

        fsize = max(fsize, ftell(fp));
    }

    usleep(40000);

    DEBUG_ERASE("TAPE: Unit %d: Erase Done. Pos = %ld.\n", unit, ftell(fp));
}

//!
//! \brief
//!    This function peforms a write tape mark function
//!
//! \details
//!    Write a tape mark at the current position. Position the tape after the
//!    new tape mark.
//!

void tape_t::writeTapeMark(uint64_t /*mtDIR*/) {
    DEBUG_WRTM("TAPE: Unit %d: Write Tape Mark.\n", unit);
    writeHeader(h_TM);
    ks10_t::writeMTDIR(ks10_t::mtDIR_SETTM);
    fsize = max(fsize, ftell(fp));
    DEBUG_WRTM("TAPE: Unit %d: Write Tape Mark Done. Pos = %ld.\n", unit, ftell(fp));
}

//!
//! \brief
//!    This peforms a space forward function
//!
//! \details
//!    The Space Forward command moves the tape forward (toward EOT) on the
//!    selected transport over the number of records specified by the Frame
//!    Count register. Each time a new record is detected, the Frame Counter
//!    is incremented. The Space Forward function terminates when any of
//!    the following condtions exist:
//!
//!    - A Tape Mark (TM) is detected. In that case, assert Tape Mark
//!      (MTDS[TM] = 1) and position the file just after the tape mark, or
//!    - An end-of-file is detected. In that case, assert End-of-Tape
//!     (MTDS[EOT] = 1) and position the file at the end-of-file, or
//!    - The contents of the Frame Counter register is incremented to zero.
//!
//!    When a TM or EOT is detected, the contents of the Frame Count Register
//!    indicates the number of records that were spaced over.
//!
//!    When completed, the Space Forward function:
//!
//!    - Asserts Attention Active (MTDS[ATA] = 1), and
//!    - Asserts Drive Ready (MTDS[DRY] = 1).
//!

void tape_t::spaceForward(uint64_t /*mtDIR*/) {

    DEBUG_SPCFWD("TAPE: Unit %d: Space Forward.\n", unit);
    bool done = false;

    do {

        uint32_t header = readHeader();
        DEBUG_HEADER("TAPE: Unit %d: Header was %d (0x%08x), (pos=%ld)\n", unit, header, header, ftell(fp) - sizeof(header));

        if (header == h_GAP) {
            continue;
        } else if (header == h_EOT) {
            DEBUG_SPCFWD("TAPE: Unit %d: Physical EOT. Signal EOT.\n", unit);
            ks10_t::writeMTDIR(ks10_t::mtDIR_SETEOT);
            break;
        } else if (header == h_ERR) {
            DEBUG_SPCFWD("TAPE: Unit %d: Header Error.\n", unit);
            break;
        } else if ((header >= 0xff000000) && (header <= 0xffff0000)) {
            DEBUG_SPCFWD("TAPE: Unit %d: Header Error.\n", unit);
            break;
        } else if ((header == h_TM) && !lastTM) {
            DEBUG_SPCFWD("TAPE: Unit %d: Found Tape Mark. Signal Tape Mark.\n", unit);
            DEBUG_SPCFWD("TAPE: Unit %d: obj=%3d, fpos=%7ld, End of tape file %d.\n", unit, objcnt, ftell(fp), filcnt);
            filcnt += 1;
            objcnt += 1;
            reccnt = 1;
            lastTM = 1;
            done = true;
        } else if ((header == h_TM) && lastTM) {
            DEBUG_SPCFWD("TAPE: Unit %d: obj=%3d, fpos=%7ld, Logical EOT.\n", unit, objcnt, ftell(fp));
            lastTM = 1;
            done = true;
        } else {

            if (lastTM) {
                DEBUG_SPCFWD("TAPE: Unit %d: Processing tape file %d.\n", unit, filcnt);
            }

            unsigned int length = header & 0xffff;

            DEBUG_SPCFWD("TAPE: Unit %d: obj=%3d, fpos=%7ld, rec=%2d, len=%d.\n", unit, objcnt, ftell(fp), reccnt, length);

            //
            // Increment the Frame Counter
            //

            ks10_t::writeMTDIR(ks10_t::mtDIR_INCFC);
            objcnt += 1;
            reccnt += 1;

            //
            // Skip forward over the record data and the header that follows the data
            // This should not fail at EOF.  We've already validated the tape file.
            //
            // Note: fseek() doesn't fail if you seek past end-of-file.
            //

#ifdef PARANOID
            if (ftell(fp) + (long)length + (long)sizeof(header) > fsize) {
                DEBUG_SPCFWD("TAPE: Unit %d: Space Forward. Would space forward past EOT.\n", unit);
                done = true;
                break;
            } else {
                fseek(fp, length + sizeof(header), SEEK_CUR);
            }
#else
            fseek(fp, length + sizeof(header), SEEK_CUR);
#endif

            //
            // Simulate delay from tape motion
            //

            uint64_t mtDIR  = ks10_t::readMTDIR();
            waitReadWrite(getDEN(mtDIR), length);

            //
            // Done when frame count is incremented to zero
            //

            if (isFCZ(mtDIR)) {
                DEBUG_SPCFWD("TAPE: Unit %d: Space Forward. Frame Count incremented to zero.\n", unit);
                done = true;
            }
        }

        if (header == h_TM) {
            lastTM = true;
            ks10_t::writeMTDIR(ks10_t::mtDIR_SETTM);
        } else {
            lastTM = false;
            ks10_t::writeMTDIR(ks10_t::mtDIR_CLRTM);
        }

    } while (!done);

    DEBUG_SPCFWD("TAPE: Unit %d: Space Forward Done. Pos = %ld.\n", unit, ftell(fp));
}

//!
//! \brief
//!    This peforms a space reverse function
//!
//! \details

void tape_t::spaceReverse(uint64_t /*mtDIR*/) {

    DEBUG_SPCREV("TAPE: Unit %d: Space Reverse.\n", unit);
    bool done = false;

    do {

        //
        // Check for BOT
        //

        if (ftell(fp) < 4) {
            DEBUG_SPCREV("TAPE: Unit %d: Space Reverse. Backspaced from BOT.\n", unit);
            break;
        }

        //
        // Seek to previous header
        //

        uint32_t header;
        fseek(fp, -sizeof(header), SEEK_CUR);
        header = readHeader();
        DEBUG_HEADER("TAPE: Unit %d: Header was %d (0x%08x), (pos=%ld)\n", unit, header, header, ftell(fp) - sizeof(header));
        fseek(fp, -sizeof(header), SEEK_CUR);

        if (header == h_GAP) {
            continue;
        } else if (header == h_EOT) {
            DEBUG_SPCREV("TAPE: Unit %d: Physical EOT. Signal EOT.\n", unit);
            ks10_t::writeMTDIR(ks10_t::mtDIR_SETEOT);
            break;
        } else if (header == h_ERR) {
            DEBUG_SPCREV("TAPE: Unit %d: Header Error.\n", unit);
            break;
        } else if ((header >= 0xff000000) && (header <= 0xffff0000)) {
            DEBUG_SPCREV("TAPE: Unit %d: Header Error.\n", unit);
            break;
        } else if ((header == h_TM) && !lastTM) {
            DEBUG_SPCREV("TAPE: Unit %d: Found Tape Mark. Signal Tape Mark.\n", unit);
            DEBUG_SPCREV("TAPE: Unit %d: obj=%3d, fpos=%7ld, End of tape file %d.\n", unit, objcnt, ftell(fp), filcnt);
            filcnt -= 1;
            objcnt -= 1;
            reccnt = -1;
            lastTM = 1;
            done = true;
        } else if ((header == h_TM) && lastTM) {
            DEBUG_SPCREV("TAPE: Unit %d: obj=%3d, fpos=%7ld, Logical EOT.\n", unit, objcnt, ftell(fp));
            lastTM = 1;
            done = true;
        } else {

            if (lastTM) {
                DEBUG_SPCREV("TAPE: Unit %d: Processing tape file %d.\n", unit, filcnt);
            }

            unsigned int length = header & 0xffff;
            DEBUG_SPCREV("TAPE: Unit %d: obj=%3d, fpos=%7ld, rec=%2d, len=%d.\n", unit, objcnt, ftell(fp), reccnt, length);
            ks10_t::writeMTDIR(ks10_t::mtDIR_INCFC);
            objcnt -= 1;
            reccnt -= 1;

            //
            // Skip reverse over the record data and the header that preceeds the data
            // This should not fail at BOF. We've already validated the tape file.
            //

#ifdef PARANOID
            if (ftell(fp) - (long)length - (long)sizeof(header) < 0) {
                DEBUG_SPCREV("TAPE: Unit %d: Space Reverse. Would space backward past BOT.\n", unit);
                done = true;
                break;
            } else {
                fseek(fp, -(length + sizeof(header)), SEEK_CUR);
            }
#else
            fseek(fp, -(length + sizeof(header)), SEEK_CUR);
#endif

            //
            // Simulate delay from tape motion
            //

            uint64_t mtDIR = ks10_t::readMTDIR();
            waitReadWrite(getDEN(mtDIR), length);

            //
            // Done when frame count is incremented to zero
            //

            if (isFCZ(mtDIR)) {
                DEBUG_SPCREV("TAPE: Unit %d: Space Reverse. Frame Count incremented to zero.\n", unit);
                done = true;
            }
        }

        if (header == h_TM) {
            lastTM = true;
            ks10_t::writeMTDIR(ks10_t::mtDIR_SETTM);
        } else {
            lastTM = false;
            ks10_t::writeMTDIR(ks10_t::mtDIR_CLRTM);
        }

    } while (!done);

    DEBUG_SPCREV("TAPE: Unit %d: Space Reverse Done. Pos = %ld.\n", unit, ftell(fp));
}

//!
//! \brief
//!    This peforms a write check forward function
//!

void tape_t::writeCheckForward(uint64_t mtDIR) {
    DEBUG_WRCHKFWD("TAPE: Unit %d: Write Check Forward.\n", unit);
    readForward(mtDIR);
    DEBUG_WRCHKFWD("TAPE: Unit %d: Write Check Forward Done.\n", unit);
}

//!
//! \brief
//!    This peforms write check reverse function
//!

void tape_t::writeCheckReverse(uint64_t mtDIR) {
    DEBUG_WRCHKREV("TAPE: Unit %d: Write Check Reverse.\n", unit);
    readReverse(mtDIR);
    DEBUG_WRCHKREV("TAPE: Unit %d: Write Check Reverse Done.\n", unit);
}

//!
//! \brief
//!    This peforms a write forward function
//!
//! \details
//!    Starting at the current position, write the initial record length,
//!    followed the data record, followed by the trailing record length.
//!    Position the tape after the trailing record length.
//!

void tape_t::writeForward(uint64_t mtDIR) {

    DEBUG_WRFWD("TAPE: Unit %d: Write Forward.\n", unit);
    int length = 0;
    uint8_t density = getDEN(mtDIR);
    uint8_t format = getFMT(mtDIR);
    int bpw = bytes_per_word(format);

    //
    // Save the location of the start header and write a fake header. We will
    // update the initial header later when we know the record size
    //

    long headPos = ftell(fp);
    writeHeader(0);

    for (;;) {

        //
        // Check to see if there is any data to get from the Tape Controller.
        //

        uint64_t mtDIR = ks10_t::readMTDIR();

        if (isSTB(mtDIR)) {

            //
            // Check the Frame Counter and Word Counter. If the either is zero,
            // we are done.
            //

            mtDIR = ks10_t::readMTDIR();
            if (isFCZ(mtDIR) || isWCZ(mtDIR)) {
                DEBUG_WRFWD("TAPE: Unit %d: Write Forward. %s Count is zero.\n", unit, isWCZ(mtDIR) ? "Frame" : "Word");
                break;
            }

            //
            // Increment the Frame Counter
            //
            // Wait for a short time for the Frame Count and Word Counter to
            // increment in the Tape Controller.
            //
            // In CORDMP mode, the Frame Counter is incremented 5 times.
            // In COMPAT mode, the Frame Counter is incremented 4 times.
            //

            for (int i = 0; i < bpw; i++) {
                ks10_t::writeMTDIR(ks10_t::mtDIR_INCFC | ks10_t::mtDIR_STB);
                length += 1;
                usleep(1);
            }

            //
            // Read the data from the tape controller
            // Negate STB after data is read
            //

            uint64_t data = getDATA(mtDIR);
            writeData(data, getFMT(mtDIR));
//          printf("Unit %d: %06o %06o: pos=%ld\n", unit, ks10_t::lh(data), ks10_t::rh(data), ftell(fp)-bpw);
            ks10_t::writeMTDIR(0);

        } else {

            usleep(100);

        }
    }

    //
    // Simulate tape speed
    //

    waitReadWrite(density, length);

    //
    // Update status
    //

    objcnt += 1;
    reccnt += 1;

    //
    // Write the end header and save the footer position. Update file size
    //

    writeHeader(length);
    DEBUG_HEADER("TAPE: Unit %d: Header was %d (0x%08x), (pos=%ld)\n", unit, length, length, ftell(fp) - sizeof(length));

    long footPos = ftell(fp);
    fsize = max(fsize, footPos);

    //
    // Seek back to the header position, update the header, and seek back to
    // position after the footer.
    //

    fseek(fp, headPos, SEEK_SET);
    writeHeader(length);
    DEBUG_HEADER("TAPE: Unit %d: Header was %d (0x%08x), (pos=%ld)\n", unit, length, length, ftell(fp) - sizeof(length));

    fseek(fp, footPos, SEEK_SET);

    DEBUG_WRFWD("TAPE: Unit %d: Write Forward Done. Pos = %ld. Length = %d\n", unit, ftell(fp), length);
}

//!
//! \brief
//!    This performs a read forward function
//!
//! \details
//!    At the start of the Read Forward operation, the contents of the Frame
//!    Count Register is set to zero.
//!
//!    The Read Forward operation reads data from the Tape File and transfers
//!    the data to memory while moving the tape in the forward direction
//!    (towards EOT). The status registers are updated during the operation as
//!    follows:
//!
//!    - The Frame Counter is incremented for every byte read from tape.
//!    - The Word Counter is incremented by two for every word read.
//!    - The Base Address is incremented by two for every word read.
//!
//!    Note: the number of bytes per word varies depending on the selected tape
//!    format and is usually either 4 bytes-per-word of 5 bytes-per-word.
//!
//!    The Read Forward operation terminates when any of the following conditions
//!    exist:
//!
//!    - A Tape Mark is detected. In that case, assert Tape Mark (MTDS[TM] = 1)
//!      and position the file just after the tape mark, or
//!    - An end-of-file is detected. In that case, assert End-of-Tape
//!      (MTDS[EOT] = 1) and position the file at the end-of-file, or
//!    - The Frame Count Register (MTFC) increments to zero.
//!    - The Word Count Register (MTWC) increments to zero.
//!
//!    When completed, the Read Forward function asserts Drive Ready (MTDS[DRY] = 1).
//!

void tape_t::readForward(uint64_t mtDIR) {

    DEBUG_RDFWD("TAPE: Unit %d: Read Forward.\n", unit);

    bool done = false;
    unsigned int total = 0;
    uint8_t density = getDEN(mtDIR);
    uint8_t format = getFMT(mtDIR);
    int bpw = bytes_per_word(format);

    do {

        uint32_t header  = readHeader();
        DEBUG_HEADER("TAPE: Unit %d: Header was %d (0x%08x), (pos=%ld)\n", unit, header, header, ftell(fp) - sizeof(header));

        if (header == h_GAP) {
            continue;
        } else if (header == h_EOT) {
            DEBUG_RDFWD("TAPE: Unit %d: Physical EOT. Signal EOT.\n", unit);
            ks10_t::writeMTDIR(ks10_t::mtDIR_SETEOT);
            break;
        } else if (header == h_ERR) {
            DEBUG_RDFWD("TAPE: Unit %d: Header Error.\n", unit);
            break;
        } else if ((header >= 0xff000000) && (header <= 0xffff0000)) {
            DEBUG_RDFWD("TAPE: Unit %d: Header Error.\n", unit);
            break;
        } else if ((header == h_TM) && !lastTM) {
            DEBUG_RDFWD("TAPE: Unit %d: Found Tape Mark. Signal Tape Mark.\n", unit);
            DEBUG_RDFWD("TAPE: Unit %d: obj=%3d, fpos=%7ld, End of tape file %d.\n", unit, objcnt, ftell(fp), filcnt);
            filcnt += 1;
            objcnt += 1;
            reccnt += 1;
            break;
        } else if ((header == h_TM) && lastTM) {
            DEBUG_RDFWD("TAPE: Unit %d: obj=%3d, fpos=%7ld, Logical EOT.\n", unit, objcnt, ftell(fp));
            break;
        } else {
            if (lastTM) {
                DEBUG_RDFWD("TAPE: Unit %d: Processing tape file %d.\n", unit, filcnt);
            }

            unsigned int length = header & 0xffff;

            //
            // Read data from file then strobe it into the tape controller.
            // The strobe will increment the MTBA and MTWC registers.
            //
            // In CORDMP mode, the frame counter is incremented 5 times.
            // In COMPAT mode, the frame counter is incremented 4 times.
            //

            DEBUG_RDFWD("TAPE: Unit %d: obj=%3d, fpos=%7ld, rec=%2d, len=%d (%d words).\n", unit, objcnt, ftell(fp), reccnt, length, length / bpw);
            objcnt += 1;
            reccnt += 1;

            for (unsigned int i = 0; i < length; i += bpw) {

                //
                // Read data from file.
                // This should not fail at EOF. We've already validated the tape file.
                //

                ks10_t::data_t data;
                int status = readData(format, data);
                if (status < 0) {
                    DEBUG_RDFWD("TAPE: Unit %d: Read Forward. Found EOF reading data.\n", unit);
                    done = true;
                    break;
                }

                //
                // Write data to Tape Controller
                //

                ks10_t::writeMTDIR(ks10_t::mtDIR_STB | data);
//              DEBUG_DATA("TAPE: Unit %d: %s pos=%ld\n", unit, dasm(data), ftell(fp));
                DEBUG_DATA("TAPE: Unit %d: %06o %06o: pos=%ld\n", unit, ks10_t::lh(data), ks10_t::rh(data), ftell(fp));

                //
                // Increment the Frame Counter
                //

                for (int j = 0; j < bpw; j++) {
                    ks10_t::writeMTDIR(ks10_t::mtDIR_INCFC);
                    usleep(1);
                }
                total  += 1;

                //
                // Wait for a short time for the Frame Count and Word Counter
                // to increment then check the Word Counter. If the Word
                // Counter is zero, we are done.
                //

                uint64_t mtDIR = ks10_t::readMTDIR();
                if (isWCZ(mtDIR)) {
                    DEBUG_WRFWD("TAPE: Unit %d: Read Forward. Word Count is zero.\n", unit);
                    done = true;
                    break;
                }
            }

            //
            // Skip over the post-record header
            // This should not fail at EOF. We've already validated the tape file.
            //

            readHeader();

            //
            // Simulate delay from tape motion
            //

            waitReadWrite(density, length);
        }

        if (header == h_TM) {
            lastTM = true;
            ks10_t::writeMTDIR(ks10_t::mtDIR_SETTM);
        } else {
            lastTM = false;
            ks10_t::writeMTDIR(ks10_t::mtDIR_CLRTM);
        }

    } while (!done);

    DEBUG_RDFWD("TAPE: Unit %d: Read Forward Done. Read %d words.\n", unit, total);
}

//!
//! \brief
//!    At the start of the Read Reverse operation, the contents of the Frame
//!    Count Register is set to zero.
//!
//!    The Read Reverse operation reads data from the Tape File and transfers
//!    the data to memory while moving the tape in the reverse direction
//!    (towards BOT). The status registers are updated during the operation as
//!    follows:
//!
//!    - The Frame Counter is incremented for every byte read from tape.
//!    - The Word Counter is incremented by two for every word read.
//!    - The Base Address is decremented by two for every word read.
//!
//!    Note: the number of bytes per word varies depending on the selected tape
//!    format and is usually either 4 bytes-per-word of 5 bytes-per-word.
//!
//!    The Read Reverse operation terminates when any of the following conditions
//!    exist:
//!
//!    - A Tape Mark is detected. In that case, assert Tape Mark (MTDS[TM] = 1)
//!      and position the file just after the tape mark, or
//!    - An beginning-of-file is detected. In that case, assert Beginning-of-Tape
//!      (MTDS[BOT] = 1) and position the file at the end-of-file, or
//!    - The Frame Count Register (MTFC) increments to zero.
//!    - The Word Count Register (MTWC) increments to zero.
//!
//!    When completed, the Read Forward function asserts Drive Ready (MTDS[DRY] = 1).
//!

void tape_t::readReverse(uint64_t mtDIR) {

    DEBUG_RDREV("TAPE: Unit %d: Read Reverse.\n", unit);

    bool done = false;
    unsigned int total = 0;
    uint8_t density = getDEN(mtDIR);
    uint8_t format  = getFMT(mtDIR);
    int bpw = bytes_per_word(format);

    do {

        if (ftell(fp) < 4) {
            DEBUG_RDREV("TAPE: Unit %d: Read Reverse. Backspaced from BOT.\n", unit);
            break;
        }

        uint32_t header;
        fseek(fp, -sizeof(header), SEEK_CUR);
        header = readHeader();
        DEBUG_HEADER("TAPE: Unit %d: Header was %d (0x%08x), (pos=%ld)\n", unit, header, header, ftell(fp) - sizeof(header));
        fseek(fp, -sizeof(header), SEEK_CUR);

        if (header == h_GAP) {
            continue;
        } else if (header == h_EOT) {
            DEBUG_RDREV("TAPE: Unit %d: Physical EOT. Signal EOT.\n", unit);
            ks10_t::writeMTDIR(ks10_t::mtDIR_SETEOT);
            break;
        } else if (header == h_ERR) {
            DEBUG_RDREV("TAPE: Unit %d: Header Error.\n", unit);
            break;
        } else if ((header >= 0xff000000) && (header <= 0xffff0000)) {
            DEBUG_RDREV("TAPE: Unit %d: Header Error.\n");
            break;
        } else if ((header == h_TM) && !lastTM) {
            DEBUG_RDREV("TAPE: Unit %d: Found Tape Mark. Signal Tape Mark.\n", unit);
            DEBUG_RDREV("TAPE: Unit %d: obj=%3d, fpos=%7ld, End of tape file %d.\n", unit, objcnt, ftell(fp), filcnt);
            filcnt -= 1;
            objcnt -= 1;
            reccnt = -1;
            break;
        } else if ((header == h_TM) && lastTM) {
            DEBUG_RDREV("TAPE: Unit %d: obj=%3d, fpos=%7ld, Logical EOT.\n", unit, objcnt, ftell(fp));
            break;
        } else {
            if (lastTM) {
                DEBUG_RDREV("TAPE: Unit %d: Processing tape file %d.\n", unit, filcnt);
            }

            unsigned int length = header & 0xffff;

            //
            // Read data from file then strobe it into the tape controller.
            // The strobe will increment the MTBA and MTWC registers. Wait
            // a microsecond for the before checking Word Count Zero (WCZ).
            // If WCZ is asserted, we are done.
            //
            // In CORDMP mode, the frame counter is incremented 5 times.
            // In COMPAT mode, the frame counter is incremented 4 times.
            //

            DEBUG_RDREV("TAPE: Unit %d: obj=%3d, fpos=%7ld, rec=%2d, len=%d (%d words).\n", unit, objcnt, ftell(fp), reccnt, length, length / bpw);
            objcnt -= 1;
            reccnt -= 1;

            for (unsigned int i = 0; i < length; i += bpw) {

                //
                // Check for beginning of file
                //

                if (ftell(fp) < 4) {
                    DEBUG_RDREV("TAPE: Unit %d: Read Reverse. Backspaced from BOT reading data.\n", unit);
                    break;
                }

                //
                // Read a word of data from the Tape File
                //

                fseek(fp, -bpw, SEEK_CUR);
                ks10_t::data_t data;
                readData(format, data);
                fseek(fp, -bpw, SEEK_CUR);
//              DEBUG_DATA("TAPE: Unit %d: %s pos=%ld\n", unit, dasm(data), ftell(fp));
                DEBUG_DATA("TAPE: Unit %d: %06o %06o: pos=%ld\n", unit, ks10_t::lh(data), ks10_t::rh(data), ftell(fp));

                //
                // Write data to Tape Controller
                //

                ks10_t::writeMTDIR(ks10_t::mtDIR_STB | data);
                DEBUG_DATA("TAPE: Unit %d: %s pos=%ld\n", unit, dasm(data), ftell(fp));

                //
                // Increment the Frame Counter
                //

                for (int j = 0; j < bpw; j++) {
                    ks10_t::writeMTDIR(ks10_t::mtDIR_INCFC);
                    usleep(1);
                }
                total += 1;

                //
                // Wait for a short time for the Frame Count and Word Counter
                // to increment then check the Word Counter. If the Word
                // Counter is zero, we are done.
                //

                uint64_t mtDIR = ks10_t::readMTDIR();
                if (isWCZ(mtDIR)) {
                    DEBUG_RDREV("TAPE: Unit %d: Read Reverse. Word Count is zero.\n", unit);
                    done = true;
                    break;
                }
            }

            //
            // Skip post-record header
            // This should not fail at BOF. We've already validated the tape file.
            //

            fseek(fp, -sizeof(header), SEEK_CUR);
            readHeader();
            fseek(fp, -sizeof(header), SEEK_CUR);

            //
            // Simulate delay from tape motion
            //

            waitReadWrite(density, length);
        }

        if (header == h_TM) {
            lastTM = true;
            ks10_t::writeMTDIR(ks10_t::mtDIR_SETTM);
        } else {
            lastTM = false;
            ks10_t::writeMTDIR(ks10_t::mtDIR_CLRTM);
        }

    } while (!done);

    DEBUG_RDREV("TAPE: Unit %d: Read Reverse Done.\n", unit);
}

//!
//! \brief
//!    This function looks for a tape command to process. If a command is
//!    found, the command is decoded and dispatched to be processed.
//!

void tape_t::processCommand(void) {

    uint64_t mtDIR    = ks10_t::readMTDIR();
    uint8_t  function = getFUN(mtDIR);
    uint8_t  format   = getFMT(mtDIR);
    uint8_t  density  = getDEN(mtDIR);

    //
    // Check for something to do
    // Ready negating indicates there is something to do...
    //

    if (!isREADY(mtDIR)) {

        if (getSS(mtDIR) == unit) {

            DEBUG_TOP("TAPE: Unit %d: Function was \"%s\" (0%02o), Density was \"%s\" (0%02o), Format was \"%s\" (0%02o), Slave was %d.\n",
                      unit, mt_t::printFUN(function), function, mt_t::printDEN(density), density, mt_t::printFMT(format), format, getSS(mtDIR));

            if ((format == f_CORDMP) || (format == f_COMPAT)) {

#ifdef DEBUG_REGS
                mt_t::dumpMTCS1(03772440);
                mt_t::dumpMTCS2(03772450);
                mt_t::dumpMTMR(03772464);
                mt_t::dumpMTDS(03772452);
                mt_t::dumpMTER(03772454);
                mt_t::dumpMTWC(03772442);
                mt_t::dumpMTFC(03772446);
                mt_t::dumpMTTC(03772472);
#endif

                switch (function) {
                    case 000:
                        DEBUG_TOP("TAPE: NOP\n");
                        break;
                    case 001:
                        unload(mtDIR);
                        break;
                    case 003:
                        rewind(mtDIR);
                        break;
                    case 010:
                        preset(mtDIR);
                        break;
                    case 012:
                        erase(mtDIR);
                        break;
                    case 013:
                        writeTapeMark(mtDIR);
                        break;
                    case 014:
                        spaceForward(mtDIR);
                        break;
                    case 015:
                        spaceReverse(mtDIR);
                        break;
                    case 024:
                        writeCheckForward(mtDIR);
                        break;
                    case 027:
                        writeCheckReverse(mtDIR);
                        break;
                    case 030:
                        writeForward(mtDIR);
                        break;
                    case 034:
                        readForward(mtDIR);
                        break;
                    case 037:
                        readReverse(mtDIR);
                        break;
                    default:
                        DEBUG_TOP("TAPE: Unrecognized function.\n");
                        break;
                }

                //
                // Update BOT and EOT based on file position.
                //
                // The number of bytes per tape is a function of tape length and
                // density
                //

                long fpos  = ftell(fp);
                int  bpt   = bytes_per_tape(density);
                bool isEOT = (fpos > bpt);

                if ((fpos == 0) && (!statBOT)) {
                    statBOT = true;
                    DEBUG_BOTEOT("TAPE: Unit %d: BOT is true.\n", unit);
                    ks10_t::writeMTDIR(ks10_t::mtDIR_SETBOT);
                } else if ((fpos != 0) && (statBOT)) {
                    statBOT = false;
                    DEBUG_BOTEOT("TAPE: Unit %d: BOT is false.\n", unit);
                    ks10_t::writeMTDIR(ks10_t::mtDIR_CLRBOT);
                } else if (isEOT && !statEOT) {
                    statEOT = true;
                    DEBUG_BOTEOT("TAPE: Unit %d: EOT is true.\n", unit);
                    ks10_t::writeMTDIR(ks10_t::mtDIR_SETEOT);
                } else if (!isEOT && statEOT) {
                    statEOT = false;
                    DEBUG_BOTEOT("TAPE: Unit %d: EOT is false.\n", unit);
                    ks10_t::writeMTDIR(ks10_t::mtDIR_CLREOT);
                }

                DEBUG_POS("TAPE: Unit %d: fpos = %ld (0x%08lx) \n", unit, fpos, fpos);

#ifdef DEBUG_REGS
                mt_t::dumpMTCS1(03772440);
                mt_t::dumpMTCS2(03772450);
                mt_t::dumpMTMR(03772464);
                mt_t::dumpMTDS(03772452);
                mt_t::dumpMTER(03772454);
                mt_t::dumpMTWC(03772442);
                mt_t::dumpMTFC(03772446);
                mt_t::dumpMTTC(03772472);
#endif

            } else {
                printf("TAPE: Unit %d: Unsupported PDP10 Tape Format. Format was 0%o\n", unit, format);
            }

            ks10_t::writeMTDIR(ks10_t::mtDIR_READY);
        }
    }
}

//!
//! \brief
//!    Validate the tape file.
//!
//! \details
//!    This function verifies that:
//!
//!    #. We can follow the records from the beginning to end of the file.
//!
//!    #. The header and footer are identical. That implies that we could follow
//!       the records from the end to the beginning of the file also.
//!
//!    #. There is a logical EOT (two tape marks) immediatly preceeding the
//!       physical EOT.
//!

void tape_t::validate(void) {
    bool lastTM = false;
    bool mismatch = false;
    bool logicalEOT = false;
    bool physicalEOT = false;
    for (;;) {
        uint32_t header = readHeader();
        DEBUG_VALIDATE("TAPE: Unit %d: Header = 0x%08x, pos=%ld\n", unit, header, ftell(fp));
        if (header == h_GAP) {
            lastTM = false;
            logicalEOT = false;
        } else if (header == h_EOT) {
            DEBUG_VALIDATE("TAPE: Unit %d: Physical EOT.\n", unit);
            physicalEOT = true;
            break;
        } else if (header == h_ERR) {
            DEBUG_VALIDATE("TAPE: Unit %d: Error.\n", unit);
            break;
        } else if ((header == h_TM) && !lastTM) {
            lastTM = true;
            logicalEOT = false;
            DEBUG_VALIDATE("TAPE: Unit %d: Tape Mark.\n", unit);
        } else if ((header == h_TM) && lastTM) {
            logicalEOT = true;
            DEBUG_VALIDATE("TAPE: Unit %d: Logical EOT\n", unit);
            break;
        } else if ((header >= 0xff000000) && (header <= 0xffff0000)) {
            DEBUG_VALIDATE("TAPE: Unit %d: Tape Error.\n", unit);
            break;
        } else {
            lastTM = false;
            uint32_t length = header & 0xffff;
            fseek(fp, length, SEEK_CUR);
            uint32_t footer = readHeader();
            DEBUG_VALIDATE("TAPE: Unit %d: Footer = 0x%08x, pos=%ld\n", unit, footer, ftell(fp));
            if (header != footer) {
                DEBUG_VALIDATE("TAPE: Unit %d: Header and footer mismatch.\n", unit);
                mismatch = true;
            }
        }
    }

    fseek(fp, 0L, SEEK_SET);

    if (mismatch) {
        printf("TAPE: Unit %d: %sTape file is invalid. Found header and footer mismatches.%s\n", unit, vt100fg_red, vt100at_rst);
    } else if (physicalEOT && !logicalEOT) {
        printf("TAPE: Unit %d: %sTape file is invalid. Missing logical EOT.%s\n", unit, vt100fg_red, vt100at_rst);
    } else {
        printf("TAPE: Unit %d: Tape file is valid.\n", unit);
    }
}

//!
//! \brief
//!   Close the file
//!

void tape_t::close(void) {
    fclose(fp);
}

//!
//! \brief
//!    This is a std::thread that is started when the tape file is mounted.
//!

void tape_t::processThread(void) {

    printf("TAPE: Unit %d: Tape thread started.\n", unit);

    while (attached) {
        processCommand();
        usleep(10);
    };

    close();
    printf("TAPE: Unit %d: Tape thread exited.\n", unit);

}

//!
//! \brief
//!    Constructor
//!
//! \details
//!    This function initializes the object, validates the tape file, and starts a
//!    thread to process requests.
//!
//! \param [in] unit -
//!    Tape unit number.
//!
//! \param [in] fp -
//!    FILE pointer to open tape file.
//!
//! \param [in] length -
//!    Length of the tape file in feet.
//!
//! \param [in] attached -
//!    Reference to atomic variable that indicates that the tape file is attached. When
//!    'attached' negates, the thread should exit.
//!
//! \param [in] debug -
//!    Enable various types a vebose debugging.
//!
//! \note:
//!    Standard tape lengths were 800 feet, 2400 feet, and 3600 feet.
//!

tape_t::tape_t(unsigned int unit, FILE *fp, unsigned int tapeLength, std::atomic<bool> &attached, off_t fsize, uint32_t &debug) :
    unit(unit),
    attached(attached),
    tapeLength(tapeLength),
    debug(debug),
    fsize(fsize),
    filcnt(1),
    objcnt(1),
    reccnt(1),
    statBOT(false),
    statEOT(false),
    lastTM(true),
    fp(fp) {

        //
        // Verify that the tape file is valid
        //

        validate();

        //
        // Start the process thread to handle requests
        //

        thread = std::thread(&tape_t::processThread, this);
}

